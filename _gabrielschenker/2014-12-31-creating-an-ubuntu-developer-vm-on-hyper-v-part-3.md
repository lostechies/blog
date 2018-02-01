---
id: 850
title: Creating an Ubuntu developer VM on Hyper-V – Part 3
date: 2014-12-31T15:04:10+00:00
author: Gabriel Schenker
layout: post
guid: http://lostechies.com/gabrielschenker/?p=850
dsq_thread_id:
  - "3378054386"
categories:
  - Elasticsearch
  - How To
  - installation
  - Java
  - Lucene
  - Setup
---
# Introduction

In the previous two posts ([here](http://lostechies.com/gabrielschenker/2014/12/29/creating-an-ubuntu-developer-vm-on-hyper-v/) and [here](http://lostechies.com/gabrielschenker/2014/12/30/creating-an-ubuntu-developer-vm-on-hyper-v-part-2/)) I first prepared a new Ubuntu 14.x VM running hosted in Hyper-V on Windows 8.1 Enterprise. Then I installed all the necessary tools and libraries to start developing Web applications using Angular JS on the client and .NET (Mono) or Node JS on the backend. In the second post I described how we can install and run [MongoDB](http://www.mongodb.org/) and [GetEventStore](http://geteventstore.com/) on our VM. In this third part I want to install and run Elastic Search. The software of my company relies heavily on [Lucene](http://lucene.apache.org/) which is a low level framework for full text indexing. In the past we have build our own high level framework on top of Lucene (we use the .NET version of it). On the long run apart from being complex, this is a maintenance burden. Thus we decided to give [Elastic Search](http://www.elasticsearch.org/) a try.

# Installing Java 8

Lucene and Elastic Search run on Java thus we need to first install this. Open a terminal (CTRL-ALT-T) and add the PPA

<font face="courier new">sudo add-apt-repository ppa:webupd8team/java</font>

Update the advanced package tool (apt)

<font face="courier new">sudo apt-get update</font>

And install JAVA

<font face="courier new">sudo apt-get install oracle-java8-installer</font>

If we have more than one Java version installed we need to make v8 the default by running this command

<font face="courier new">sudo apt-get install oracle-java8-set-default</font>

Finally we can check out which version we run

<font face="courier new">java -version</font>&nbsp;

and should get something like this

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;border-left: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2014/12/image_thumb6.png" width="598" height="158" />](http://lostechies.com/gabrielschenker/files/2014/12/image6.png)

Now we are ready to install and use software that depends on Java…

# Installing Elastic Search

Elastic search is very easy to install and run. It is highly scalable and has a nice REST API over which all access happens. We start by downloading and installing the public signing key

[gist id=ee99641384663efbbc6b]

Enable the repository

[gist id=b51ed290d1f1cbdfb670]

We run apt-get update and the repository is ready to use

<font face="courier new">sudo apt-get update</font>

Now we install Elasticsearch 

<font face="courier new">sudo apt-get install elasticsearch</font>

If we want to configure the system such as that Elasticsearch automatically starts during bootup we can execute the following command

<pre><font size="3">sudo update-rc.d elasticsearch defaults 95 10</font></pre>

To start Elasticsearch use this command

<font face="courier new">sudo /etc/init.d/elasticsearch start</font>

You should see something like this

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;border-left: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2014/12/image_thumb7.png" width="733" height="122" />](http://lostechies.com/gabrielschenker/files/2014/12/image7.png) 

Similarly to stop Elasticsearch use

<font face="courier new">sudo /etc/init.d/elasticsearch stop</font>

# Installing curl

To test Elasticsearch I want to use **curl**. We can install curl like this

<font face="courier new">sudo apt-get install curl</font>

## Testing Elasticsearch

By default Elasticsearch listens at port 9200. We can use this simple command to connect with Elasticsearch

<font face="courier new">curl –X GET </font>[<font face="courier new">http://localhost:9200</font>](http://localhost:9200)

If all works well we should see this

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;border-left: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2014/12/image_thumb8.png" width="637" height="341" />](http://lostechies.com/gabrielschenker/files/2014/12/image8.png)

When playing around with a REST API I also like to use the Postman – REST Client for Chrome. We can install this extension from [here](https://chrome.google.com/webstore/detail/postman-rest-client/fdmmgilgnpjigdojojpjoooidkmcomcm?hl=en). Using the exact same URI as with curl we have this

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;border-left: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2014/12/image_thumb9.png" width="586" height="388" />](http://lostechies.com/gabrielschenker/files/2014/12/image9.png)