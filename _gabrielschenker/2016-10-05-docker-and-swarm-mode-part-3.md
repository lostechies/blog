---
wordpress_id: 1827
title: 'Docker and Swarm Mode &#8211; Part 3'
date: 2016-10-05T10:09:02+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=1827
dsq_thread_id:
  - "5199067648"
categories:
  - containers
  - docker
  - Elasticsearch
  - How To
  - introduction
tags:
  - containers
  - Docker
  - logging
  - swarm
  - troubleshoot
---
# Refresher

In [part 1](https://lostechies.com/gabrielschenker/2016/09/05/docker-and-swarm-mode-part-1/) we have created a swarm of 5 nodes of which we defined 3 to be master nodes and the remaining ones worker nodes. Then we deployed the open source version of the Docker Registry v2 in our swarm. On `node1` of our swarm we cloned the GitHub repository of Jerome Petazzo containing the `dockercoins` application that mines Docker coins and consists of 4 services `rng`, `hasher`, `worker` and `webui`. We then created images for the 4 services and pushed them to our local registry listening at port 5000. Normally the Docker Registry wants us to communicate via TLS but to make it simple we use it on `localhost:5000`. when using the registry on localhost the communication is in plain text and no TLS encryption is needed. By defining the registry service to publish `port 5000` each node in the swarm can now use `localhost:5000` to access the registry, even if the registry itself is running on a different node. In this case the swarm will automatically forward the call to the correct node.

If on any node we execute the following command

`curl localhost:5000/v2/_catalog`

we should see something similar to this

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/registry-catalog.png" alt="" title="registry-catalog" width="445" height="56" class="alignnone size-full wp-image-1891" />](https://lostechies.com/gabrielschenker/files/2016/10/registry-catalog.png)

In [part 2](https://lostechies.com/gabrielschenker/2016/09/11/docker-and-swarm-mode-part-2/) we then learned about `services`, `tasks` and `software defined networks` and how they are related.

Now it is time to use all what we have learned so far and get our mining application up and running.

# Running the Mining Application

When we want to run an application in a swarm we first want to define a network. The services will then be running on this network. The type of network has to be overlay so that our application can span all the nodes of the swarm. Let&#8217;s do that. We call our network `dockercoins`

`docker network create dockercoins --driver overlay`

We can double check that it has been created by using this command

`docker network ls`

which lists all networks visible to the node on which I am (node1 in this case). In my case it looks like this and we can see the newly created network in the list

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/list-of-networks.png" alt="" title="list-of-networks" width="537" height="161" class="alignnone size-full wp-image-1893" />](https://lostechies.com/gabrielschenker/files/2016/10/list-of-networks.png)

Next we are going to run the `Redis` service which is used as the storage backend for our mining application. We should already be familiar on how to do that after reading part 2.

`docker service create --name redis --network dockercoins redis`

Please note how we place the service onto the `dockercoins` network by using the `--network` parameter.

After this we run all the other services. To simplify things and avoid repetitive typing we can use a for loop

[gist id=554de48ad4d1220e0145d3bbb749c7ff]

After running this and waiting for a short moment we should see the following when listing all services with `docker service ls`

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/list-of-services.png" alt="" title="list-of-services" width="572" height="184" class="alignnone size-full wp-image-1895" />](https://lostechies.com/gabrielschenker/files/2016/10/list-of-services.png)

The column `replicas` in the above image shows `1/1` for each service which indicates that all is good. If there was a problem with any of the services we would see something like `0/1`, which indicates the desired number of instances of the service is 1 but the number of running instances is zero.

If we want to see the details of each service we could now use the `docker service ps` command for each service. This is kind of tedious and thus a better solution is to use some combined command

`docker service ls -q | xargs -n1 docker service ps`

The output of this for me looks like this

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/status-of-services.png" alt="" title="status-of-services" width="953" height="298" class="alignnone size-full wp-image-1898" />](https://lostechies.com/gabrielschenker/files/2016/10/status-of-services.png)

Agreed, it looks a bit messy, but at least I have all the necessary information at one place with a simple command. I expect that Docker will extend the `docker servic` command with some more global capabilities but for now we have to hack our own commands together.

In the above output we can see that each service runs in a single container and the containers are distributed accross all the nodes of the swarm, e.g. redis runs on node3 and the worker service on node5.

If we wanted to watch our application to start up we could just put the above command as an argument into a `watch` statement

`watch "docker service ls -q | xargs -n1 docker service ps"`

which is useful for situations where the individual services need a bit more time to initialize than the simple mining services.

We have one little problem left. **As is**, the `webui` service is not accessible from the outside since it has no published port. We can change that by using the `update` command for a Docker service. If we want to publish the internal port 80 to the host `port 8080` we have to do this

`docker service update --publish-add 8080:80 webui`

After this our service is reachable from the outside. We could also have chosen a more radical way and re-created the service by destroying and creating it again with a `--publish 8080:80` statement.

By choosing the `update` command we instructed the scheduler (Docker Swarm) to terminate the old version of the service and run the updated one instead

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/published-port.png" alt="" title="published-port" width="962" height="95" class="alignnone size-full wp-image-1901" />](https://lostechies.com/gabrielschenker/files/2016/10/published-port.png)

_If our service would have been scaled out to more than one instance then the swarm would have done a rolling update._

Now we can open a browser and connect to **ANY** of the nodes of our swarm on port `8080` and we should see the Web UI. Let&#8217;s do this. In my case `webui` is running on `node1` with IP address `192.168.99.100` and thus I&#8217;ll try to connect to say `node2` with IP address `192.168.99.101`.

And indeed I see this

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/mining-dashboard.png" alt="" title="mining-dashboard" width="859" height="636" class="alignnone size-full wp-image-1907" />](https://lostechies.com/gabrielschenker/files/2016/10/mining-dashboard.png)

# Load Balancer

Now in a production system we would not want anyone from the internet hit the `webui` service directly but we would want to place the service behind a load balancer, e.g. an `ELB` if running in AWS. The load balancer would then forward the request to any of the nodes of the swarm which in turn would reroute it to the node on which `webui` is running. An image probably helps to clarify the situation

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/load-balancer.png" alt="" title="load-balancer" width="660" height="600" class="alignnone size-full wp-image-1906" />](https://lostechies.com/gabrielschenker/files/2016/10/load-balancer.png)

# Logging

What can we do if one of our service instances shows a problem? How can we find out what is the root cause of the problem? We could technically `ssh` into the swarm node on which the problematic container is running and then use the `docker logs [container ID]` command to get the details. But this of course is **not** a scalable solution. There must be a better way of getting insight into our application. The answer is **log aggregation**. We want to collect the log output of each container and redirect it to a central location e.g. in the cloud.

## Commercial Offerings

There are many services that offer just that, some of them being [Logentries](https://logentries.com/), [SumoLogic](https://www.sumologic.com/), [Splunk](https://www.splunk.com/), [Loggly](https://www.loggly.com/), to just name a few.

Let&#8217;s take **Logentries** as a sample. The company provides a [Docker image](https://hub.docker.com/r/logentries/docker-logentries/) that we can use to create a container running on each node of the swarm. This container hooks into the event stream of Docker Engine and forwards all event messages to a pre-defined endpoint in the cloud. We can then use the Web client of **Logentries** to slice and dice the aggregated information and easily find what we&#8217;re looking for.

If you do not yet have an account with Logentries you can easily create a 30-days trial account as I did. Once you have created the account you can define a new **Log Set** by clicking on **+ Add New**

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/logentries-logset.png" alt="" title="logentries-logset" width="556" height="393" class="alignnone size-full wp-image-1909" />](https://lostechies.com/gabrielschenker/files/2016/10/logentries-logset.png)

In the following dialog when asked to **Select How To Send Your Logs** select **Docker** and then in step 2 define the name of the new log set. I called mine **my-log-set**. In this step you will also generate a **token** that you will be using when running the log container.A token has this form

`a62dc88a-xxxx-xxxx-xxxx-a1fee4df9557`

Once we&#8217;re done with the configuration we can execute the following command to start an instance of the Logentries container

`docker run -d -v /var/run/docker.sock:/var/run/docker.sock logentries/docker-logentries -t [your-token] -j`

If we do this then the container will run on the current node of the swarm and collect and forward all its information. That&#8217;s not exactly what we want though! We want to run an instance of the container on each and every node. Thus we use the feature of a `global` service

`docker service create --name log --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock --mode global logentries/docker-logentries -t [your-token] -j`

After a short period of time we should have an instance of the Logentries container running on each node and collecting log information. To verify this just `ssh` into any node of the swarm and run an instance of [busybox](https://hub.docker.com/_/busybox/), e.g. something like

`docker run --rm -it busybox echo "Hello world"`

while you have Logentries running in **Live tail** mode. You should see something similar to this

[<img src="https://lostechies.com/gabrielschenker/files/2016/10/logentries-sample.png" alt="" title="logentries-sample" width="1286" height="466" class="alignnone size-full wp-image-1903" />](https://lostechies.com/gabrielschenker/files/2016/10/logentries-sample.png)

In the above image we can see an entry in the log for each event generated by Docker during the life-cycle of the `busybox` container.

## Logging with an ELK Stack

If we want to run our own log aggregator then we can use the so called ELK stack (ELK = Elastic Search, Logstash and Kibana). We only really need to configure `Logstash`, the other two services run with defaults.

First we create a network just for logging

`docker network create --driver overlay logging`

now we can create the service for Elasticsearch

`docker service create --network logging --name elasticsearch elasticsearch`

Then we will define a service for `Kibana`. `Kibana` needs to know where `Elasticsearch` is found thus we need a tiny bit more configure information

`docker service create --network logging --name kibana --publish 5601:5601 -e ELASTICSEARCH_URL=http://elasticsearch:9200 kibana`

Note how we use the integrated DNS service to locate the `Elasticsearch` service via its name in `http://elasticsearch:9200`.

Finally we need a service for `Logstash`

`docker service create --network logging --name logstash -p 12201:12201/udp logstash -e "$(cat ~/orchestration-workshop/elk/logstash.conf)"`

As you can see `Logstash` needs a configuration which we get from the `logstash.conf` file that is part of our repository. Also we use the [Gelf](http://docs.graylog.org/en/2.1/pages/gelf.html) protocol for logging which uses `port 12201/udp`.

To see what `Logstash` is reporting we can localize the `Logstash` container with `docker service ps logstash` and then can `ssh` into the corresponding node and use

`docker logs --follow [container id]`

where [container id] corresponds to the ID of the `Logstash` container (the ID we can get via `docker ps` on the node).

To generate/send a (sample) log message we can e.g. use the following command

`docker run --log-driver gelf --log-opt gelf-address=udp://127.0.0.1:12201 --rm busybox echo hello`

Now we can update all our services to use the ELK stack with this command

[gist id=f41614506f131a0c344c85697a1875d4]

Finally we can open the Browser at the IP of one of our nodes and `port 5601` (e.g. http://192.168.99.101:5601) to see `Kibana`. Click on the top level menu &#8220;Discover&#8221; to see the incoming logs. You might want to change the time window and the refresh interval in the top right of the screen to say last 1 hour and every 5 sec.

# Summary

In this post I have shown how we can deploy and run an application consisting of multiple services. Once an application runs in production it needs to be monitored. This requires, among other things, that we collect all the log output of all our containers to be aggregated in a central location. I have shown how we can use one of the commercial SaaS offerings to do exactly that and also how we can run our own ELK stack instead. In part 4 I will be showing how we can further automate the deployment of services and the subsequent upgrade to new versions without incurring any downtime.