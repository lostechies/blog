---
id: 743
title: 'RabbitMQ for Windows: Direct Exchanges'
date: 2012-04-02T07:00:00+00:00
author: Derek Greer
layout: post
guid: http://lostechies.com/derekgreer/?p=743
dsq_thread_id:
  - "633460746"
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
      <a href="https://lostechies.com/derekgreer/2012/03/07/rabbitmq-for-windows-building-your-first-application/">RabbitMQ for Windows: Building Your First Application</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/03/18/rabbitmq-for-windows-hello-world-review/">RabbitMQ for Windows: Hello World Review</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/03/28/rabbitmq-for-windows-exchange-types/">RabbitMQ for Windows: Exchange Types</a>
    </li>
    <li>
      RabbitMQ for Windows: Direct Exchanges
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

This is the fifth installment to the series: RabbitMQ for Windows.&nbsp; In the [last installment](http://lostechies.com/derekgreer/2012/03/28/rabbitmq-for-windows-exchange-types/), we took a look at the four exchange types provided by RabbitMQ: Direct, Fanout, Topic, and Headers.&nbsp; In this installment we’ll walk through an example which uses a direct exchange type directly and we’ll take a look at the push API. 

In the Hello World example from the second installment of the series, we used a direct exchange type implicitly by taking advantage of the automatic&nbsp; binding of queues to the default exchange using the queue name as the routing key.&nbsp; The example we’ll work through this time will be similar, but we’ll declare and bind to the exchange explicitly. 

This time our example will be a distributed logging application.&nbsp; We’ll create a Producer console application which publishes a logging message for some noteworthy action and a Consumer console application which displays the message to the console. 

Beginning with our Producer app, we’ll start by establishing a connection using the default settings, create the connection, and create a channel: 

<pre class="prettyprint">using RabbitMQ.Client;

namespace Producer
{
  class Program
  {
    static void Main(string[] args)
    {
      var connectionFactory = new ConnectionFactory();
      IConnection connection = connectionFactory.CreateConnection();
      IModel channel = connection.CreateModel();
    }
  }
}
</pre>

Next, we need to declare the exchange we’ll be publishing our message to.&nbsp; We need to give our exchange a name in order to reference it later, so let’s use “direct-exchange-example”: 

<pre class="prettyprint">channel.ExchangeDeclare("direct-exchange-example", ExchangeType.Direct);
</pre>

The second parameter indicates the exchange type.&nbsp; For the official RabbitMQ .Net client, this is just a simple string containing one of the values: direct, fanout, topic, or headers.&nbsp; The type RabbitMQ.Client.ExchangeType defines each of the exchange types as a constant for convenience. 

Next, let’s call some method which might produce a value worthy of interest.&nbsp; We’ll call the method DoSomethingInteresting() and have it return a string value: 

<pre class="prettyprint">string value = DoSomethingInteresting();
</pre>

For the return value, the implementation of DoSomethingInteresting() can just return the string value of a new Guid: 

<pre class="prettyprint">static string DoSomethingInteresting() 
{ 
  return Guid.NewGuid().ToString(); 
} 
</pre>

Next, let’s use the returned value to create a log message containing a severity level of Information: 

<pre class="prettyprint">string logMessage = string.Format("{0}: {1}", TraceEventType.Information, value); 
</pre>

Next, we need to convert our log message to a byte array and publish the message to our new exchange: 

<pre class="prettyprint"><p>
  byte[] message = Encoding.UTF8.GetBytes(logMessage);
  channel.BasicPublish("direct-exchange-example", "", null, message); 
  
</p></pre>

Here, we use an empty string as our routing key and null for our message properties. 

We end our Producer by closing the channel and connection: 

<pre class="prettyprint">channel.Close(); 
connection.Close(); 
</pre>

Here’s the full listing: 

<pre class="prettyprint">using System;
using System.Diagnostics;
using System.Text;
using System.Threading;
using RabbitMQ.Client;

namespace Producer
{
  class Program
  {
    static void Main(string[] args)
    {
      Thread.Sleep(1000);
      var connectionFactory = new ConnectionFactory();
      IConnection connection = connectionFactory.CreateConnection();
      IModel channel = connection.CreateModel();

      channel.ExchangeDeclare("direct-exchange-example", ExchangeType.Direct);
      string value = DoSomethingInteresting();
      string logMessage = string.Format("{0}: {1}", TraceEventType.Information, value);

      byte[] message = Encoding.UTF8.GetBytes(logMessage);
      channel.BasicPublish("direct-exchange-example", "", null, message);

      channel.Close();
      connection.Close();
    }

    static string DoSomethingInteresting()
    {
      return Guid.NewGuid().ToString();
    }
  }
}
</pre>

Note that our logging example’s Producer differs from our Hello World’s Producer in that we didn’t declare a queue this time.&nbsp; In our Hello World example, we needed to run our Producer before the Consumer since the Consumer simply retrieved a single message and exited.&nbsp; Had we published to the default exchange without declaring the queue first, our message would simply have been discarded by the server before the Consumer had an opportunity to declare and bind the queue. 

Next, we’ll create our Consumer which starts the same way as our Producer code: 

<pre class="prettyprint">using RabbitMQ.Client;

namespace Consumer
{
  class Program
  {
    static void Main(string[] args)
    {
      var connectionFactory = new ConnectionFactory();
      IConnection connection = connectionFactory.CreateConnection();
      IModel channel = connection.CreateModel();

      channel.ExchangeDeclare("direct-exchange-example", ExchangeType.Direct);
    }
  }
}
</pre>

Next, we need to declare a queue to bind to our exchange.&nbsp; Let’s name our queue “logs”: 

<pre class="prettyprint">channel.QueueDeclare("logs", false, false, true, null); 
</pre>

To associate our logs queue with our exchange, we use the QueueBind() method providing the name of the queue, the name of the exchange, and the binding key to filter messages on: 

<pre class="prettyprint">channel.QueueBind("logs", "direct-exchange-example", "");
</pre>

At this point we could consume messages using the pull API method BasicGet() as we did in the Hello World example, but this time we’ll use the push API.&nbsp; To have messages pushed to us rather than us pulling messages, we first need to declare a consumer: 

<pre class="prettyprint">var consumer = new QueueingBasicConsumer(channel);
</pre>

To start pushing messages to our consumer, we call the channel’s BasicConsume() method and tell it which consumer to start pushing messages to: 

<pre class="prettyprint">channel.BasicConsume(“logs”, true, consumer); 
</pre>

Here, we specify the queue to consume messages from, a boolean flag instructing messages to be auto-acknowledged (see discussion in the Getting the Message section of [Hello World Review](http://lostechies.com/derekgreer/2012/03/18/rabbitmq-for-windows-hello-world-review/)), and the consumer to push the messages to.&nbsp;&nbsp; 

Now, any messages placed on the queue will automatically be retrieved and placed in a local in-memory queue.&nbsp; To dequeue a message from the local queue, we call the Dequeue() method on the consumer’s Queue property: 

<pre class="prettyprint">var eventArgs = (BasicDeliverEventArgs)consumer.Queue.Dequeue(); 
</pre>

This method call blocks until a message is available to be dequeued, or until an EndOfStreamException is thrown indicating that the consumer was cancelled, the channel was closed, or the connection otherwise was terminated. 

Once the Dequeue() method returns, the BasicDeliverEventArgs contains the bytes published from the Producer in the Body property, so we can convert this value back into a string and print it to the console: 

<pre class="prettyprint">var message = Encoding.UTF8.GetString(eventArgs.Body);
Console.WriteLine(message); 
</pre>

We end our Consumer by closing the channel and connection: 

<pre class="prettyprint">channel.Close();
connection.Close(); 
</pre>

Here’s the full listing: 

<pre class="prettyprint">using System;
using System.Text;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;

namespace Consumer
{
  class Program
  {
    static void Main(string[] args)
    {
      var connectionFactory = new ConnectionFactory();
      IConnection connection = connectionFactory.CreateConnection();
      IModel channel = connection.CreateModel();

      channel.ExchangeDeclare("direct-exchange-example", ExchangeType.Direct);
      channel.QueueDeclare("logs", false, false, true, null);
      channel.QueueBind("logs", "direct-exchange-example", "");

      var consumer = new QueueingBasicConsumer(channel);
      channel.BasicConsume("logs", true, consumer);

      var eventArgs = (BasicDeliverEventArgs) consumer.Queue.Dequeue();

      string message = Encoding.UTF8.GetString(eventArgs.Body);
      Console.WriteLine(message);

      channel.Close();
      connection.Close();
      Console.ReadLine();
    }
  }
}
</pre>

If we run the resulting Consumer.exe at this point, it will block until a message is routed to the queue.&nbsp; Running the Producer.exe from another shell produces a message on the consumer console similar to the following: 

<pre class="prettyprint">Information: 610fe447-bf31-41d2-ae29-414b2d00087b 
</pre>

<div class="note">
  Note: For a convenient way to execute both the Consumer and Producer from within Visual Studio, go to the solution properties and choose “Set StartUp Projects …”.&nbsp; Select the “Multiple startup projects:” option and set both the Consumer and Producer to the Action: Start.&nbsp; Use the arrows to the right of the projects to ensure the Consumer is started before the Producer.&nbsp; In some cases, this can still result in the Producer publishing the message before the Consumer has time to declare and bind the queue, so putting a Thread.Sleep(1000) at the start of your Producer should ensure things happen in the required order.&nbsp; After this, you can run your examples by using Ctrl+F5 (which automatically prompts to exit).
</div>

That concludes our direct exchange example.&nbsp; Next time, we’ll take a look at the Fanout exchange type.
