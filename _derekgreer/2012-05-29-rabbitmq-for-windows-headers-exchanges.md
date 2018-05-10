---
wordpress_id: 789
title: 'RabbitMQ for Windows: Headers Exchanges'
date: 2012-05-29T14:46:34+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=789
dsq_thread_id:
  - "707515114"
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
      <a href="https://lostechies.com/derekgreer/2012/04/02/rabbitmq-for-windows-direct-exchanges/">RabbitMQ for Windows: Direct Exchanges</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/05/16/rabbitmq-for-windows-fanout-exchanges/">RabbitMQ for Windows: Fanout Exchanges</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/05/18/rabbitmq-for-windows-topic-exchanges/">RabbitMQ for Windows: Topic Exchanges</a>
    </li>
    <li>
      RabbitMQ for Windows: Headers Exchanges
    </li>
  </ul>
</div>

This is the eighth and final installment to the series: RabbitMQ for Windows.&nbsp; In the [last installment](https://lostechies.com/derekgreer/2012/05/18/rabbitmq-for-windows-topic-exchanges/), we walked through creating a topic exchange example.&nbsp; As the last installment, we’ll walk through a headers exchange example.

Headers exchanges examine the message headers to determine which queues a message should be routed to.&nbsp; As discussed earlier in this series, headers exchanges are similar to topic exchanges in that they allow you to specify multiple criteria, but offer a bit more flexibility in that the headers can be constructed using a wider range of data types ([1](#Footnote_1)).

To subscribe to receive messages from a headers exchange, a dictionary of headers is specified as part of the binding arguments.&nbsp; In addition to the headers, a key of “x-match” is also included in the dictionary with a value of “all”, specifying that messages must be published with all the specified headers in order to match, or “any”, specifying that the message needs to only have one of the specified headers specified.

As our final example, we’ll create a Producer application which publishes the message “Hello, World!” using a headers exchange.&nbsp; Here’s our Producer code:

<pre class="prettyprint">using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using System.Threading;
using RabbitMQ.Client;
using RabbitMQ.Client.Framing.v0_9_1;

namespace Producer
{
  class Program
  {
    const string ExchangeName = "header-exchange-example";

    static void Main(string[] args)
    {
      var connectionFactory = new ConnectionFactory();
      connectionFactory.HostName = "localhost";

      IConnection connection = connectionFactory.CreateConnection();
      IModel channel = connection.CreateModel();
      channel.ExchangeDeclare(ExchangeName, ExchangeType.Headers, false, true, null);
      byte[] message = Encoding.UTF8.GetBytes("Hello, World!");

      var properties = new BasicProperties();
      properties.Headers = new Dictionary&lt;string, object&gt;();
      properties.Headers.Add("key1", "12345");
      
      TimeSpan time = TimeSpan.FromSeconds(10);
      var stopwatch = new Stopwatch();
      Console.WriteLine("Running for {0} seconds", time.ToString("ss"));
      stopwatch.Start();
      var messageCount = 0;

      while (stopwatch.Elapsed &lt; time)
      {
        channel.BasicPublish(ExchangeName, "", properties, message);
        messageCount++;
        Console.Write("Time to complete: {0} seconds - Messages published: {1}\r", (time - stopwatch.Elapsed).ToString("ss"), messageCount);
        Thread.Sleep(1000);
      }

      Console.Write(new string(' ', 70) + "\r");
      Console.WriteLine("Press any key to exit");
      Console.ReadKey();
      message = Encoding.UTF8.GetBytes("quit");
      channel.BasicPublish(ExchangeName, "", properties, message);
      connection.Close();
    }
  }
}</pre>

In the Producer, we’ve used a generic dictionary of type Dictionary<string, object> and added a single key “key1” with a value of “12345”.&nbsp; As with our previous example, we’re using a stopwatch as a way to publish messages continually for 10 seconds.

For our Consumer application, we can use an “x-match” argument of “all” with the single key/value pair specified by the Producer, or we can use an “x-match” argument of “any” which includes the key/value pair specified by the Producer along with other potential matches.&nbsp; We’ll use the latter for our example.&nbsp;&nbsp; Here’s our Consumer code:

<pre class="prettyprint">using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;

namespace Consumer
{
  class Program
  {
    const string QueueName = "header-exchange-example";
    const string ExchangeName = "header-exchange-example";

    static void Main(string[] args)
    {
      var connectionFactory = new ConnectionFactory();
      connectionFactory.HostName = "localhost";

      IConnection connection = connectionFactory.CreateConnection();
      IModel channel = connection.CreateModel();
      channel.ExchangeDeclare(ExchangeName, ExchangeType.Headers, false, true, null);
      channel.QueueDeclare(QueueName, false, false, true, null);

      IDictionary specs = new Dictionary&lt;string object ,>();
      specs.Add("x-match", "any");
      specs.Add("key1", "12345");
      specs.Add("key2", "123455");
      channel.QueueBind(QueueName, ExchangeName, string.Empty, specs);

      channel.StartConsume(QueueName, MessageHandler);
      connection.Close();
    }

    public static void MessageHandler(IModel channel, DefaultBasicConsumer consumer, BasicDeliverEventArgs eventArgs)
    {
      string message = Encoding.UTF8.GetString(eventArgs.Body);
      Console.WriteLine("Message received: " + message);
      foreach (object headerKey in eventArgs.BasicProperties.Headers.Keys)
      {
        Console.WriteLine(headerKey + ": " + eventArgs.BasicProperties.Headers[headerKey]);
      }

      if (message == "quit")
        channel.BasicCancel(consumer.ConsumerTag);
    }
  }
}</pre>

Rather than handling our messages inline as we’ve done in previous examples, this example uses an extension method named StartConsume() which accepts a callback to be invoked each time a message is received.&nbsp; Here’s the extension method used by our example:

<pre class="prettyprint">using System;
using System.IO;
using System.Threading;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;

namespace Consumer
{
  public static class ChannelExtensions
  {
    public static void StartConsume(this IModel channel, string queueName,  Action&lt;IModel, DefaultBasicConsumer, BasicDeliverEventArgs&gt; callback)
    {
      var consumer = new QueueingBasicConsumer(channel);
      channel.BasicConsume(queueName, true, consumer);

      while (true)
      {
        try
        {
          var eventArgs = (BasicDeliverEventArgs)consumer.Queue.Dequeue();
          new Thread(() =&gt; callback(channel, consumer, eventArgs)).Start();
        }
        catch (EndOfStreamException)
        {
          // The consumer was cancelled, the model closed, or the connection went away.
          break;
        }
      }
    }
  }
}</pre>

Setting our solution to run both the Producer and Consumer applications upon startup, running our example produces output similar to the following:

**Producer**

<pre class="prettyprint">Running for 10 seconds
Time to complete: 08 seconds - Messages published: 2</pre>

**Consumer**

<pre class="prettyprint">Message received: Hello, World!
key1: 12345
Message received: Hello, World!
key1: 12345</pre>

That concludes our headers exchange example as well as the RabbitMQ for Windows series.&nbsp; For more information on working with RabbitMQ, see the documentation at <http://www.rabbitmq.com> or the purchase the book [RabbitMQ in Action](http://rabbitmqinaction.com/) by Alvaro Videla and Jason Williams.&nbsp; I hope you enjoyed the series.

&nbsp;

Footnotes:

<a name="Footnote_1">1</a> – See <http://www.rabbitmq.com/amqp-0-9-1-errata.html#section_3> and <http://hg.rabbitmq.com/rabbitmq-dotnet-client/diff/4def852523e2/projects/client/RabbitMQ.Client/src/client/impl/WireFormatting.cs> for supported field types.
