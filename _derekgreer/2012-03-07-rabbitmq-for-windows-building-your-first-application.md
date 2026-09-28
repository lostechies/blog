---
wordpress_id: 667
title: 'RabbitMQ for Windows: Building Your First Application'
date: 2012-03-07T22:14:58+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=667
dsq_thread_id:
  - "602878288"
categories:
  - Uncategorized
tags:
  - RabbitMQ
---
## Posts In This Series

<div>
  <ul>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/03/05/rabbitmq-for-windows-introduction/">RabbitMQ for Windows: Introduction</a>
    </li>
    <li>
      RabbitMQ for Windows: Building Your First Application
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/03/18/rabbitmq-for-windows-hello-world-review/">RabbitMQ for Windows: Hello World Review</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/03/28/rabbitmq-for-windows-exchange-types/">RabbitMQ for Windows: Exchange Types</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/04/02/rabbitmq-for-windows-direct-exchanges/">RabbitMQ for Windows: Direct Exchanges</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/05/16/rabbitmq-for-windows-fanout-exchanges/">RabbitMQ for Windows: Fanout Exchanges</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/05/18/rabbitmq-for-windows-topic-exchanges/">RabbitMQ for Windows: Topic Exchanges</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/05/29/rabbitmq-for-windows-headers-exchanges/">RabbitMQ for Windows: Headers Exchanges</a>
    </li>
  </ul>
</div>

This is the second installment to the RabbitMQ for Windows series.&nbsp; In our <a href="https://lostechies.com/derekgreer/2012/03/05/rabbitmq-for-windows-introduction/" target="_blank">first installment</a>, we walked through getting RabbitMQ installed on a Microsoft Windows machine. In this installment, we’ll discuss a few high-level concepts and walk through creating our first RabbitMQ application.

## Basic Concepts

To being, let’s discuss a few basic concepts. Each of the examples we’ll be working through will have two roles represented: a _Producer_ and a _Consumer_. A Producer sends messages and a Consumer receives messages. 

_Messages_ are basically any blob of bytes you’d like to send. This could be a simple ASCII string, JavaScript Object Notation (JSON), or a binary-serialized object. 

Messages are sent to _Queues_.&nbsp; A Queue is a First-In-First-Out (FIFO) data structure. You can think of a queue as a sort of pipe where you put messages in one side of the pipe and the messages arrive at the other end of the pipe.&nbsp; 

The following diagram depicts these concepts: 

&nbsp;

[<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="ProducerQueueConsumer" border="0" alt="ProducerQueueConsumer" src="https://lostechies.com/content/derekgreer/uploads/2012/03/ProducerQueueConsumer_thumb.png" width="419" height="227" />](https://lostechies.com/content/derekgreer/uploads/2012/03/ProducerQueueConsumer.png)

&nbsp;

We’ll introduce other concepts further into the series, but that’s the basics. Let’s move on to creating our first example.

## Hello, World! 

Our first application will be an obligatory “Hello World” example.&nbsp; We’ll create a Publisher application which sends the string “_Hello, World!_” to a RabbitMQ queue and a Consumer application which receives the message from the queue and displays it to the console. 

For all of our examples, we’ll be using the official RabbitMQ .Net client available [here](http://www.rabbitmq.com/dotnet.html).&nbsp; This library is also available via [NuGet](http://nuget.org/), so if you have the [NuGet Package Manager](http://visualstudiogallery.msdn.microsoft.com/27077b70-9dad-4c64-adcf-c7cf6bc9970c) installed you can retrieve it through the “Tools->Library Package Manager” menu item, or if you have the <a href="http://nuget.codeplex.com/releases/view/58939" target="_blank">NuGet.exe command line utility</a> then you can issue the following command in the directory you’d like it installed to: 

</b>

<pre class="prettyprint">nuget install RabbitMQ.Client
</pre>

&nbsp;

### Create the Producer

To start, let’s create a new empty solution named HelloWorldExample (File->New->Project->Other Project Types->Visual Studio Solutions->Blank Solution). Once you have that created, add a new project of type “Console Application” to the solution and name it “Producer”. 

Next, add a reference to the RabbitMQ.Client.dll assembly. 

The first thing we’ll need to do for our producer is to establish a connection to the RabbitMQ server using a ConnectionFactory: 

<pre class="prettyprint">namespace Producer
{
  class Program
  {
    static void Main(string[] args)
    {
      var connectionFactory = new ConnectionFactory();
      IConnection connection = connectionFactory.CreateConnection();
    }
  }
}
</pre>

&nbsp;

The ConnectionFactory has a number of properties that can be set for our connection. In this example, we’re establishing a connection using the default connection settings which assumes you have the RabbitMQ Windows service running on your local development machine. If you’ve installed it on a different machine then you’ll need to set the Host property of the connectionFactory instance to the DNS name where you’ve installed RabbitMQ. 

Next, we need to create a Channel: 

<pre class="prettyprint">IModel channel = connection.CreateModel();
</pre>

&nbsp;

A channel is a light-weight connection which RabbitMQ uses to enable multiple threads of communication over a single TCP/IP socket. Note that the actual type created is _RabbitMQ.Client.IModel_. In most RabbitMQ client libraries the term channel is used, but for some reason the authors of the .Net client library chose to use the term “Model”. Descriptive, eh? We’ll use the instance name of “channel” to be more descriptive. 

Next, we need to create a queue: 

<pre class="prettyprint">channel.QueueDeclare(“hello-world-queue”, false, false, false, null);
</pre>

&nbsp;

This creates a queue on the server named “_hello-world-queue_” which is non-durable (won’t survive a server restart), is non- exclusive (other channels can connect to the same queue), and is not auto-deleted once it’s no longer being used.&nbsp; We’ll discuss these parameters in more detail further in our series.

Next, we’ll declare a byte array containing a UTF8-encoded array of bytes from the string “Hello, World!” and use the BasicPublish() method to publish the message to the queue: 

<pre class="prettyprint">byte[] message = Encoding.UTF8.GetBytes("Hello, World!");
channel.BasicPublish(string.Empty, “hello-world-queue”, null, message);
</pre>

&nbsp;

Again, don’t worry about understanding the parameters just yet. We’ll get to that soon enough. 

Finally, we’ll prompt the user to press a key to exit the application and close our channel and connection: 

<pre class="prettyprint">Console.WriteLine("Press any key to exit");
Console.ReadKey();
channel.Close();
connection.Close();
</pre>

&nbsp;

Here’s the full Producer listing: 

<pre class="prettyprint">using System.Text;
using RabbitMQ.Client;

namespace Producer
{
  class Program
  {
    static void Main(string[] args)
    {
      var connectionFactory = new ConnectionFactory();
      IConnection connection = connectionFactory.CreateConnection();
      IModel channel = connection.CreateModel();
      channel.QueueDeclare("hello-world-queue", false, false, false, null);
      byte[] message = Encoding.UTF8.GetBytes("Hello, World!");
      channel.BasicPublish(string.Empty, "hello-world-queue", null, message);
      Console.WriteLine("Press any key to exit");
      Console.ReadKey();
      channel.Close();
      connection.Close();
    }
  }
}
</pre>

&nbsp;

### Create the Consumer

Next, let’s create our Consumer application. Add a new Console Application to the solution named “Consumer” and add a reference to the RabbitMQ.Client assembly. We’ll start our consumer with the same connection, channel, and queue declarations: 

<pre class="prettyprint">var connectionFactory = new ConnectionFactory();
IConnection connection = connectionFactory.CreateConnection();
IModel channel = connection.CreateModel();
channel.QueueDeclare("hello-world-queue", false, false, false, null);
</pre>

&nbsp;

Next, we’ll use the BasicGet() method to consume the message from the queue “hello-world-queue”: 

<pre class="prettyprint">BasicGetResult result = channel.BasicGet("hello-world-queue", true);
</pre>

&nbsp;

Next, we’ll check to ensure we received a result. If so, we’ll convert the byte array contained within the Body property to a string and display it to the console: 

<pre class="prettyprint">if (result != null)
{
  string message = Encoding.UTF8.GetString(result.Body);
  Console.WriteLine(message);
}
</pre>

&nbsp;

Lastly, we’ll prompt the user to press a key to exit the application and close our channel and connection: 

<pre class="prettyprint">Console.WriteLine("Press any key to exit");
Console.ReadKey();
channel.Close();
connection.Close();
</pre>

&nbsp;

Here’s the full Consumer listing: 

<pre class="prettyprint">using System;
using System.Text;
using RabbitMQ.Client;

namespace Consumer
{
  class Program
  {
    static void Main(string[] args)
    {
      var connectionFactory = new ConnectionFactory();
      IConnection connection = connectionFactory.CreateConnection();
      IModel channel = connection.CreateModel();
      channel.QueueDeclare("hello-world-queue", false, false, false, null);
      BasicGetResult result = channel.BasicGet("hello-world-queue", true);
      if (result != null)
      {
        string message = Encoding.UTF8.GetString(result.Body);
        Console.WriteLine(message);
      }
      Console.WriteLine("Press any key to exit");
      Console.ReadKey();
      channel.Close();
      connection.Close();
    }
  }
}
</pre>

&nbsp;

To see the application in action, start the Publisher application first and then start the Consumer application. If all goes well, you should see the Consumer application print the following:

<pre class="prettyprint">Hello, World!
Press any key to exit
</pre>

&nbsp;

Congratulations! You’ve just completed your first RabbitMQ application.&nbsp; Next time, we&#8217;ll take a closer look at the concepts used within our Hello World example. 

<pre></pre>
