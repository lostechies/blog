# Getting started with Cassandra: Load testing Cassandra in brief

An opinionated guide on the "correct" way to load test Cassandra. I'm aiming to keep this short so I'm going to leave out a _lot_ of the nuance that one would normally get into when talking about load testing cassandra.

## If you have no data model in mind

Use cassandra stress since it's around:

* first initialize the keyspace with RF3 `cassandra-stress "write cl=ONE no-warmup -col size=FIXED(15000) -schema replication(strategy=SimpleStrategy,factor=3)"`
* second run stress `cassandra-stress "mixed n=1000k cl=ONE -col size=FIXED(15000)`
* repeat as often as you'd like with as many clients as you want.

## If you have a specific data model in mind

You can use cassandra-stress, but I suspect you're going to find your data model isn't supported (collections for example) or that you don't have the required PHD to make it work the way you want. There are probably 2 dozen options from here you can use to build your load test, some of the more popular ones are gatling, jmeter, and tlp-stress. My personal favorite for this though, write a small simple python or java program that replicates your use case accurately in your own code, using a faker library to generate your data. This takes more time but you tend to have less surprises in production as it will accurately model your code.

### Small python script with python driver

* use python3 and virtualenv
* `python -m venv venv`
* source venv/bin/activate
* read and follow install [docs](https://docs.datastax.com/en/developer/python-driver/3.21/getting_started/)
* if you want to skip the docs you can get away with `pip install cassandra-driver`
* install a faker library `pip install Faker`

```python
import argparse
import uuid
import time
import random
from cassandra.cluster import Cluster
from cassandra.query import BatchStatement
from faker import Faker

parser = argparse.ArgumentParser(description='simple load generator for cassandra')
parser.add_argument('--hosts', default='127.0.0.1',
                    type=str,
                    help='comma separated list of hosts to use for contact points')
parser.add_argument('--port', default=9042, type=int, help='port to connect to')
parser.add_argument('--trans', default=1000000, type=int, help='number of transactions') 
parser.add_argument('--inflight', default=25, type=int, help='number of operations in flight') 
parser.add_argument('--errors', default=-1, type=int, help='number of errors before stopping. default is unlimited') 
args = parser.parse_args()
fake = Faker(['en-US'])
hosts = args.hosts.split(",")
cluster = Cluster(hosts, port=args.port)

try:
    session = cluster.connect()
    print("setup schema");
    session.execute("CREATE KEYSPACE IF NOT EXISTS my_key WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 1}")
    session.execute("CREATE TABLE IF NOT EXISTS my_key.my_table (id uuid, name text, address text, state text, zip text, balance int, PRIMARY KEY(id))")
    session.execute("CREATE TABLE IF NOT EXISTS my_key.my_table_by_zip (zip text, id uuid, balance bigint, PRIMARY KEY(zip, id))")
    print("allow schema to replicate throughout the cluster for 30 seconds")
    time.sleep(30)
    print("prepare queries")
    insert = session.prepare("INSERT INTO my_key.my_table (id, name, address, state, zip, balance) VALUES (?, ?, ?, ?, ?, ?)")
    insert_rollup = session.prepare("INSERT INTO my_key.my_table_by_zip (zip, id, balance) VALUES (?, ?, ?)")
    row_lookup = session.prepare("SELECT * FROM my_key.my_table WHERE id = ?")
    rollup = session.prepare("SELECT sum(balance) FROM my_key.my_table_by_zip WHERE zip = ?")
    threads = []
    ids = []
    error_counter = 0
    query = None
    params = []
    ids = []
    
    def get_id():
        items = len(ids)
        if items == 0:
            ## nothing present so return something random
            return uuid.uuid4()
        if items == 1:
            return ids[0]
        return ids[random.randint(0, items -1)]
    print("starting transactions")
    for i in range(args.trans):
        chance = random.randint(1, 100)
        if chance > 0 and chance < 50:
            new_id = uuid.uuid4()
            ids.append(new_id)
            state = fake.state_abbr()
            zip_code = fake.zipcode_in_state(state)
            balance = random.randint(1, 50000)
            query = BatchStatement()
            name = fake.name()
            address = fake.address()
            bound_insert = insert.bind([new_id, fake.name(), fake.address(), state, zip_code, balance])
            query.add(bound_insert)
            bound_insert_rollup = insert_rollup.bind([zip_code, new_id, balance])
            query.add(bound_insert_rollup)
        elif chance > 50 and chance < 75:
            query = row_lookup.bind([get_id()])
        elif chance > 75:
            zip_code = fake.zipcode()
            query = rollup.bind([zip_code])
        threads.append(session.execute_async(query))
        if i % args.inflight == 0:
            for t in threads:
                try:
                    t.result() #we don't care about result so toss it
                except Exception as e:
                    print("unexpected exception %s" % e)
                    if args.errors > 0:
                        error_counter = error_counter + 1
                        if error_counter > args.errors:
                            print("too many errors stopping. Consider raising --errors flag if this happens more quickly than you'd like")
                            break
            threads = []
            print("submitted %i of %i transactions" % (i, args.trans))
finally:
    cluster.shutdown()
```

### Small java program with latest java driver

* download java 8
* create a command line application in your project technology of choice (I used maven in this example for no particularly good reason)
* download a faker lib like [this one](https://github.com/DiUS/java-faker) and the [Cassandra java driver from DataStax](https://github.com/datastax/java-driver) again using your preferred technology to do so.
* run the following code sample somewhere (set your RF and your desired queries and data model)
* use different numbers of clients at your cluster until you get enough "saturation" or the server stops responding.

[See complete example](https://github.com/rssvihla/simple_cassandra_load_test/tree/master/java/simple-cassandra-stress)
```java
package pro.foundev;

import java.lang.RuntimeException;
import java.lang.Thread;
import java.util.Locale;
import java.util.ArrayList;
import java.util.List;
import java.util.function.*;
import java.util.Random;
import java.util.UUID;
import java.util.concurrent.CompletionStage;
import java.net.InetSocketAddress;
import com.datastax.oss.driver.api.core.CqlSession;
import com.datastax.oss.driver.api.core.CqlSessionBuilder;
import com.datastax.oss.driver.api.core.cql.*;
import com.github.javafaker.Faker;

public class App 
{
    public static void main( String[] args )
    {
        List<String> hosts = new ArrayList<>();
        hosts.add("127.0.0.1");
        if (args.length > 0){
            hosts = new ArrayList<>();
            String rawHosts = args[0];
            for (String host: rawHosts.split(",")){
                hosts.add(host.trim());
            }
        }
        int port = 9042;
        if (args.length > 1){
            port = Integer.valueOf(args[1]);
        }
        long trans = 1000000;
        if (args.length > 2){
            trans = Long.valueOf(args[2]);
        }
        int inFlight = 25;
        if (args.length > 3){
            inFlight = Integer.valueOf(args[3]);
        }
        int maxErrors = -1;
        if (args.length > 4){
            maxErrors = Integer.valueOf(args[4]);
        }
        CqlSessionBuilder builder = CqlSession.builder();
        for (String host: hosts){
            builder = builder.addContactPoint(new InetSocketAddress(host, port));
        }
        builder = builder.withLocalDatacenter("datacenter1");
        try(final CqlSession session = builder.build()){
            System.out.println("setup schema");
            session.execute("CREATE KEYSPACE IF NOT EXISTS my_key WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 1}");
            session.execute("CREATE TABLE IF NOT EXISTS my_key.my_table (id uuid, name text, address text, state text, zip text, balance int, PRIMARY KEY(id))");
            session.execute("CREATE TABLE IF NOT EXISTS my_key.my_table_by_zip (zip text, id uuid, balance bigint, PRIMARY KEY(zip, id))");
			System.out.println("allow schema to replicate throughout the cluster for 30 seconds");
			try{
			    Thread.sleep(30000);
            }catch(Exception ex){
                throw new RuntimeException(ex);
            }
            System.out.println("prepare queries");
            final PreparedStatement insert = session.prepare("INSERT INTO my_key.my_table (id, name, address, state, zip, balance) VALUES (?, ?, ?, ?, ?, ?)");
            final PreparedStatement insertRollup = session.prepare("INSERT INTO my_key.my_table_by_zip (zip, id, balance) VALUES (?, ?, ?)");
            final PreparedStatement rowLookup = session.prepare("SELECT * FROM my_key.my_table WHERE id = ?");
            final PreparedStatement rollup = session.prepare("SELECT sum(balance) FROM my_key.my_table_by_zip WHERE zip = ?");
            final List<UUID> ids = new ArrayList<>();
            final Random rnd = new Random();
            final Locale us = new Locale("en-US");
            final Faker faker = new Faker(us);
            final Supplier<UUID> getId = ()-> {
                if (ids.size() == 0){
                    //return random uuid will be record not found
                    return UUID.randomUUID();
                }
                if (ids.size() == 1){
                    return ids.get(0);
                }
                final int itemIndex = rnd.nextInt(ids.size()-1);
                return ids.get(itemIndex);
            };
            final Supplier<Statement<?>> getOp = ()-> {
                int chance = rnd.nextInt(100);
                if (chance > 0 && chance < 50){
                    final String state = faker.address().stateAbbr();
                    final String zip = faker.address().zipCodeByState(state);
                    final UUID newId = UUID.randomUUID();
                    final int balance = rnd.nextInt();
                    ids.add(newId);
                    return BatchStatement.builder(BatchType.LOGGED)
                        .addStatement(insert.bind(newId,
                                    faker.name().fullName(), 
                                    faker.address().streetAddress(), 
                                    state, 
                                    zip,
                                    balance))
                        .addStatement(insertRollup.bind(zip, newId, Long.valueOf(balance)))
                        .build();
                } else if (chance > 50 && chance < 75){
                    return rowLookup.bind(getId.get());
                } 
                final String state = faker.address().stateAbbr();
                final String zip = faker.address().zipCodeByState(state);
                return rollup.bind(zip);
            };
            System.out.println("start transactions");
            List<CompletionStage<AsyncResultSet>> futures = new ArrayList<>();
            int errorCounter = 0;
            for (int i = 0; i < trans; i++){
                //this is an uncessary hack to port old code and cap transactions in flight
                if ( i % inFlight == 0){
                    for (CompletionStage<AsyncResultSet> future: futures){
                        try{
                            future.thenRun(()->{});
                        }catch(Exception ex){
                            if (maxErrors > 0){
                                if (errorCounter > maxErrors){
                                    System.out.println("too many errors therefore stopping.");
                                    break;
                                }
                                errorCounter += 1;
                            }
                        }
                    }
                    futures = new ArrayList<>(); 
                    System.out.println("submitted " + Integer.toString(i) + " of " + Long.toString(trans) + " transactions");
               }
               Statement<?> query = getOp.get();
               futures.add(session.executeAsync(query));
            }
        }
    }
}
```


## How to measure performance

The above scripts and examples are not ideal for several points but if you throw enough clients at the cluster at the same time those problems should balance out (namely the pseudo random distributions aren't ideal).
But let's assume you've worked these points out or gone with a gatling or other such tool what sort of issues should you look for now:

* Are the nodes saturated or not? IE have you thrown enough client load at them?
* What does GC look like? Use a tool like [gceasy](gceasy.io) with the logs or [sperf core gc](https://www.github.com/riptano/sperf) to analyze things.
* How are pending compactions and pending mutations looking? Again, a tool like [sperf core statuslogger](https://www.github.com/riptano/sperf) help a lot. Rule of thumb though is more than 100 pending compactions or 10000 pending mutations spells trouble.
* How does disk io and cpu usage look? Collect an iostat on your servers. Disk queue length of 1 means your IO isn't keeping up, this will happen sometimes in a busy but otherwise healthy server, if it's happening a lot (more than 5%) of the time you're in for some trouble. If your CPU uses hyperthreading and is busier than 40% of the time a lot of the time (say more than 5% again) that's probably alos an issue. Use `sperf sysbottle` to analyze your iostat file.

## Summary

There are dozens of other good measurements to look at when trying to monitor load on your server and observe what your server can handle, but this is supposed to be a quick and dirty guide. So try these out for starters and ask yourself the following questions:

* Does my data model generate a lot of GC? If so how can I change it? Validate this by randomly turniing off some of your queries and seeing which ones are the most expensive.
* Is my server well tuned for my hardware? Is CPU or IO pegged? If not how busy are they? Can you add more clients? If not why?
* Should I just add more nodes? Does changing RF have any affect on my reads and write load?
