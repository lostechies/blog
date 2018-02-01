---
id: 197
title: 'Event Sourcing and System of Record: Sane Distributed Development In The Modern Era'
date: 2015-09-17T11:20:41+00:00
author: Ryan Svihla
layout: post
guid: https://lostechies.com/ryansvihla/?p=197
dsq_thread_id:
  - "4138805759"
categories:
  - Cassandra
  - Event sourcing
  - Lambda
tags:
  - Cassandra
  - Distributed
  - Idempotent
---
## <span style="font-size: 16px;">No matter the message queue or broker you rely on whether it be RabbitMQ, JMS, ActiveMQ, Websphere, MSMQ and yes even Kafka you can lose messages in any of the following ways:</span> {#8e26}

<li id="636e">
  A downstream system from the broker can have data loss
</li>
<li id="4de8">
  All message queues today can lose already acknowledged messages during failover or leader election.
</li>
<li id="e06d">
  A bug can send the wrong messages to the wrong systems.
</li>

<p id="468b">
  <em>AKA the typical distributed systems problem set.</em>
</p>

<p id="2cea">
  Despite these data safety issues, messaging remains a popular pattern for the following reasons:
</p>

<li id="0adf">
  Messaging is an easy way to publish a given transaction to several separate systems at once.
</li>
<li id="f034">
  Messaging often can help handle bursts of load gracefully by providing a queue of work to work on while your services catch up.
</li>
<li id="0b22">
  Messaging can help decouple the services in your business from one another.
</li>

<p id="ba7b">
  All of these advantages are BIG wins and not easily shrugged off.
</p>

<p id="8e58">
  So how does one minimize the bad and get all that messaging goodness? There are several strategies that companies use but I’ll cover the most common approach I see.
</p>

### **System of Record** {#ab18}

<div>
  <div>
  </div>
  
  <p>
    <img src="https://cdn-images-1.medium.com/max/800/1*2_fy1qQaotCwtjytw6Pk8g.png" alt="" width="522" height="306" data-image-id="1*2_fy1qQaotCwtjytw6Pk8g.png" data-width="652" data-height="382" />
  </p>
</div>

Duplicate writes to the messaging system and the System of Record

<p id="9cef">
  In the above diagram I’m showing a variant of the common approach where I chose to write to the system of record while writing to my broker of choice which is Kafka. For the system of record I persist every message to database (Cassandra in this case which is often called C*) in a table called events.
</p>

<p id="9763">
  Most often these events are using <a href="http://martinfowler.com/eaaDev/EventSourcing.html" rel="nofollow" data-href="http://martinfowler.com/eaaDev/EventSourcing.html">Event Sourcing</a> or what is sometimes called a Ledger Model.
</p>

<pre name="6375">create table my_keyspace.events (time_bucket timestamp, event_id timeuuid, ts timestamp, message text)
# use a reasonably small time resolution to keep events under 100k per timestamp</pre>

### Replay {#6519}

<div>
  <div>
  </div>
  
  <p>
    <img src="https://cdn-images-1.medium.com/max/800/1*lPAxcBL2KAK8cYUbR5AuTw.png" alt="" data-image-id="1*lPAxcBL2KAK8cYUbR5AuTw.png" data-width="418" data-height="238" />
  </p>
</div>

Replaying Events C and B

<p id="6163">
  The ability to replay those events lies primarily in the following code. While the replayBucketStrategy is just a Java 8 Consumer so it’s up to the reader to build something useful with that. This sample makes clear the strategy used for replay.
</p>

<pre name="62c8">public class SystemOfRecord {
    private final Consumer replayBucketStrategy;
    //15 second increments for the time bucket. This can be as  
    // large or as small as needed for proper partition sizing      private final long bucketIncrement = 15000;

    public SystemOfRecord(Consumer&lt;Date&gt; replayBucketStrategy){

        this.replayBucketStrategy = replayBucketStrategy;
    }
    public void replayDateRange(Date start, Date end)
        Date incrementedDate = new Date(start.getTime());
        //check to see if the incremented time is greater
        // than the end time.
        while(incrementedDate.getTime()&lt;end.getTime()) 
            //take the date as an arugment for which cassandra 
            // table to query for messages  
            this.replayBucketStrategy.accept(incrementedDate);

            final long time = incrementedDate.getTime();
            //add bucket increment to get the next bucket   
            incrementedDate = new Date(time + bucketIncrement);
        }
    }
}</pre>

<p id="0f1a">
  This code will allow you to over a given range of data to resend a given series of time buckets and their corresponding messages ( note I chose to not include the end range as one of the buckets that are replayed, you may change this to suit your preferences).
</p>

### Handling Duplication {#19c1}

<p id="aeab">
  Your downstream systems have to be able to handle duplication with this scheme, or the process will become completely manual where you’ll have to manually compare which events have been replicated and which have not.
</p>

<div>
  <div>
  </div>
  
  <p>
    <img src="https://cdn-images-1.medium.com/max/800/1*T2QEgQVTL6N-1UHu_sD1kg.png" alt="" data-image-id="1*T2QEgQVTL6N-1UHu_sD1kg.png" data-width="418" data-height="238" />
  </p>
</div>

Service 1 Already has Event B

<p id="c2a4">
  This gives us one two choices, Idempotent Services or Delete+Reload
</p>

### Idempotent Services {#8cbb}

<p id="4f6e">
  Advantages: Safe, easy to replay. You should be doing this anyway in distributed systems.
</p>

<p id="7ab7">
  Disadvantages: More work than the alternatives. Have to think about your data model and code. Have to have some concept transaction history in your downstream systems.
</p>

<p id="7f45">
  Read more about is almost anywhere on the web, you can start with a short summary <a href="http://www.servicedesignpatterns.com/WebServiceInfrastructures/IdempotentRetry" rel="nofollow" data-href="http://www.servicedesignpatterns.com/WebServiceInfrastructures/IdempotentRetry">here</a>. In summary you design your service around these replays of messages, and it’s trivial to build up from there.
</p>

<p id="a069">
  In traditional idempotent designs you often have a threshold of how long a retry can occur. If you use an immutable data model like we talked about earlier such as Event Sourcing, this becomes pretty easy.
</p>

### Delete + Reload {#e7f5}

<p id="9da5">
  Advantages: Low tech, easy to understand.
</p>

<p id="c432">
  Disadvantages: This is an implied outage during the delete phase.
</p>

<p id="0a97">
  Simple, delete all your data in the downstream service, and then replay all the events from the system of record. The downside of course is that you have no data while this is occuring, and it can take some very long period of time to wait on. On the plus side there are lots of problem domains that fit into this downtime mode. The downside is there are a lot more than do not, and cannot afford to be down at all. This is in no small part why you see Idempotent Services and Event Sourcing becoming so popular.
</p>

### Wrap Up {#ade4}

<p id="b60a">
  I hope this was a helpful introduction to safer messaging. While on the surface this seems simple enough, as you can see there is a lot of nuance to consider and there always is with any distributed system. My goal is not to hide the complexity but highlight the parts you have to think about and simplify those choices from there.
</p>