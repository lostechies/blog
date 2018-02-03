---
wordpress_id: 781
title: 'RabbitMQ for Windows: Topic Exchanges'
date: 2012-05-18T10:31:06+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=781
dsq_thread_id:
  - "695072158"
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
      RabbitMQ for Windows: Topic Exchanges
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/05/29/rabbitmq-for-windows-headers-exchanges/">RabbitMQ for Windows: Headers Exchanges</a>
    </li>
  </ul>
</div>

This is the seventh installment to the series: RabbitMQ for Windows.&nbsp; In the [last installment](http://lostechies.com/derekgreer/2012/05/16/rabbitmq-for-windows-fanout-exchanges/), we walked through creating a fanout exchange example.&nbsp; In this installment, we’ll be walking through a topic exchange example.

Topic exchanges are similar to direct exchanges in that they use a routing key to determine which queue a message should be delivered to, but they differ in that they provide the ability to match on portions of a routing key.&nbsp; When publishing to a topic exchange, a routing key consisting of multiple words separated by periods (e.g. “word1.word2.word3”) will be matched against a pattern supplied by the binding queue.&nbsp; Patterns may contain an asterisk (“*”) to match a word in a specific segment or a hash (“#”) to match zero or more words.&nbsp; As discussed earlier in the series, the topic exchange type can be useful for directing messages based on multiple categories or for routing messages originating from multiple sources.

To demonstrate topic exchanges, we’ll return to our logging example, but this time we’ll subscribe to a subset of the messages being published to demonstrate the flexibility of how routing keys are used by topic exchanges.&nbsp; For this example, we’ll be modeling a scenario where a company may have multiple client installations, each of which may be used to service different sectors of a company’s business model (e.g. Business or Personal sectors).&nbsp; We’ll use a routing key that specifies the sector and subscribe to messages published for the Personal sector only.

As with our previous examples, we’ll keep things simple by creating console applications for a Producer and a Consumer.&nbsp; Let’s start by creating the Producer app and establishing a connection using the default settings:

<pre class="prettyprint">using RabbitMQ.Client;

namespace Producer
{
  class Program
  {
    const long ClientId = 10843;

    static void Main(string[] args)
    {
      var connectionFactory = new ConnectionFactory();
      IConnection connection = connectionFactory.CreateConnection();
    }
  }
}
</pre>

&nbsp;

Rather than just publishing messages directly from the Main() method as with our first logging example, let’s create a separate logger object this time.&nbsp; Here the logger interface and implementation we’ll be using:

<pre class="prettyprint">interface ILogger
  {
    void Write(Sector sector, string entry, TraceEventType traceEventType);
  }

  class RabbitLogger : ILogger, IDisposable
  {
    readonly long _clientId;
    readonly IModel _channel;
    bool _disposed;

    public RabbitLogger(IConnection connection, long clientId)
    {
      _clientId = clientId;
      _channel = connection.CreateModel();
      _channel.ExchangeDeclare("direct-exchange-example", ExchangeType.Topic, false, true, null);
    }

    public void Dispose()
    {
      if (!_disposed)
      {
        if (_channel != null && _channel.IsOpen)
        {
          _channel.Close();
        }
      }
      GC.SuppressFinalize(this);
    }

    public void Write(Sector sector, string entry, TraceEventType traceEventType)
    {
      byte[] message = Encoding.UTF8.GetBytes(entry);
      string routingKey = string.Format("{0}.{1}.{2}", _clientId, sector.ToString(), traceEventType.ToString());
      _channel.BasicPublish("topic-exchange-example", routingKey, null, message);
    }

    ~RabbitLogger()
    {
      Dispose();
    }
  }
</pre>

In addition to an open IConnection, our RabbitLogger class is instantiated with a client Id.&nbsp; We use this as part of the routing key.&nbsp; Since each log can vary by sector, we pass a Sector enum as part of the Write() method.&nbsp; Here’s our Sector enum:

<pre class="prettyprint">public enum Sector
  {
    Personal,
    Business
  }
</pre>

Returning to our Main() method, we now need to instantiate our RabbitLogger and log messages with differing sectors.&nbsp; As as way to ensure our client has an opportunity to subscribe to our messages and to help emulate a continual stream of log messages being published, let’s use the logger to publish a series of log messages every second for 10 seconds:

<pre class="prettyprint">TimeSpan time = TimeSpan.FromSeconds(10);
      var stopwatch = new Stopwatch();
      Console.WriteLine("Running for {0} seconds", time.ToString("ss"));
      stopwatch.Start();

      while (stopwatch.Elapsed &lt; time)
      {
        using (var logger = new RabbitLogger(connection, ClientId))
        {
          Console.Write("Time to complete: {0} seconds\r", (time - stopwatch.Elapsed).ToString("ss"));
          logger.Write(Sector.Personal, "This is an information message", TraceEventType.Information);
          logger.Write(Sector.Business, "This is an warning message", TraceEventType.Warning);
          logger.Write(Sector.Business, "This is an error message", TraceEventType.Error);
          Thread.Sleep(1000);
        }
      }
</pre>

This code prints out the time remaining just to give us a little feedback on the publishing progress.&nbsp; Finally, we’ll close our our connection and prompt the user to exit the console application:

<pre class="prettyprint">connection.Close();
      Console.Write("                             \r");
      Console.WriteLine("Press any key to exit");
      Console.ReadKey();
</pre>

&nbsp;

Here’s the full Producer listing:

<pre class="prettyprint">using System;
using System.Diagnostics;
using System.Text;
using System.Threading;
using RabbitMQ.Client;

namespace Producer
{
  public enum Sector
  {
    Personal,
    Business
  }

  interface ILogger
  {
    void Write(Sector sector, string entry, TraceEventType traceEventType);
  }

  class RabbitLogger : ILogger, IDisposable
  {
    readonly long _clientId;
    readonly IModel _channel;
    bool _disposed;

    public RabbitLogger(IConnection connection, long clientId)
    {
      _clientId = clientId;
      _channel = connection.CreateModel();
      _channel.ExchangeDeclare("direct-exchange-example", ExchangeType.Topic, false, true, null);
    }

    public void Dispose()
    {
      if (!_disposed)
      {
        if (_channel != null && _channel.IsOpen)
        {
          _channel.Close();
        }
      }
      GC.SuppressFinalize(this);
    }

    public void Write(Sector sector, string entry, TraceEventType traceEventType)
    {
      byte[] message = Encoding.UTF8.GetBytes(entry);
      string routingKey = string.Format("{0}.{1}.{2}", _clientId, sector.ToString(), traceEventType.ToString());
      _channel.BasicPublish("topic-exchange-example", routingKey, null, message);
    }

    ~RabbitLogger()
    {
      Dispose();
    }
  }

  class Program
  {
    const long ClientId = 10843;

    static void Main(string[] args)
    {
      var connectionFactory = new ConnectionFactory();
      IConnection connection = connectionFactory.CreateConnection();

      TimeSpan time = TimeSpan.FromSeconds(10);
      var stopwatch = new Stopwatch();
      Console.WriteLine("Running for {0} seconds", time.ToString("ss"));
      stopwatch.Start();

      while (stopwatch.Elapsed &lt; time)
      {
        using (var logger = new RabbitLogger(connection, ClientId))
        {
          Console.Write("Time to complete: {0} seconds\r", (time - stopwatch.Elapsed).ToString("ss"));
          logger.Write(Sector.Personal, "This is an information message", TraceEventType.Information);
          logger.Write(Sector.Business, "This is an warning message", TraceEventType.Warning);
          logger.Write(Sector.Business, "This is an error message", TraceEventType.Error);
          Thread.Sleep(1000);
        }
      }

      connection.Close();
      Console.Write("                             \r");
      Console.WriteLine("Press any key to exit");
      Console.ReadKey();
    }
  }
}
</pre>

&nbsp;

For our Consumer app, we’ll pretty much be using the same code as with our fanout exchange example, but we’ll need to change the exchange type along with the exchange and queue names.&nbsp; Additionally, we also need to provide a routing key that registers for logs in the Personal sector only.&nbsp; The messages published by the Producer will be in the form: [client Id].[sector].[log severity], so we can use a routing key of “\*.Personal.\*” (or alternately “*.Personal.#”).&nbsp; Here’s the full Consumer listing:

<pre class="prettyprint">using System;
using System.IO;
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

      channel.ExchangeDeclare("topic-exchange-example", ExchangeType.Topic, false, true, null);
      channel.QueueDeclare("log", false, false, true, null);
      channel.QueueBind("log", "topic-exchange-example", "*.Personal.*");

      var consumer = new QueueingBasicConsumer(channel);
      channel.BasicConsume("log", true, consumer);

      while (true)
      {
        try
        {
          var eventArgs = (BasicDeliverEventArgs) consumer.Queue.Dequeue();
          string message = Encoding.UTF8.GetString(eventArgs.Body);
          Console.WriteLine(string.Format("{0} - {1}", eventArgs.RoutingKey, message));
        }
        catch (EndOfStreamException)
        {
          // The consumer was cancelled, the model closed, or the connection went away.
          break;
        }
      }

      channel.Close();
      connection.Close();
    }
  }
}
</pre>

&nbsp;

Setting the solution to run both the Producer and Consumer on startup, we should see similar output to the following listings:

&nbsp;

**Producer**

<pre class="prettyprint">Running for 10 seconds
Time to complete: 06 seconds
</pre>

&nbsp;

**Consumer**

<pre class="prettyprint">10843.Personal.Information - This is an information message
10843.Personal.Information - This is an information message
10843.Personal.Information - This is an information message
10843.Personal.Information - This is an information message
10843.Personal.Information - This is an information message
10843.Personal.Information - This is an information message
10843.Personal.Information - This is an information message
</pre>

&nbsp;

This concludes our topic exchange example.&nbsp; Next time, we’ll walk through an example using the final exchange type: Header Exchanges.
