---
wordpress_id: 767
title: 'RabbitMQ for Windows: Fanout Exchanges'
date: 2012-05-16T08:24:24+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=767
dsq_thread_id:
  - "691969148"
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
      RabbitMQ for Windows: Fanout Exchanges
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/05/18/rabbitmq-for-windows-topic-exchanges/">RabbitMQ for Windows: Topic Exchanges</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2012/05/29/rabbitmq-for-windows-headers-exchanges/">RabbitMQ for Windows: Headers Exchanges</a>
    </li>
  </ul>
</div>

This is the sixth installment to the series: RabbitMQ for Windows. In the [last installment](https://lostechies.com/derekgreer/2012/04/02/rabbitmq-for-windows-direct-exchanges/), we walked through creating a direct exchange example and introduced the push API. In this installment, we’ll walk through a fanout exchange example.

As discussed earlier in the series, the fanout exchange type is useful for facilitating the [publish-subscribe](http://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern) pattern. When we publish a message to a fanout exchange, the message is delivered indiscriminately to all bound queues. With the Direct, Topic, and Headers exchange types, a criteria is used by a routing algorithm taking the form of a routing key or a collection of message headers depending on the exchange type in question. A routing key or a collection of message headers may also be specified with the fanout exchange which will be delivered as part of the message’s metadata, but they will not be used as a filter in determining which queue receives a published message.

To demonstrate the fanout exchange, we’ll use a stock ticker example. In the previous example, logs were routed to queues based upon a matching routing key (an empty string in the logging example’s case). In this example, we’d like our messages to be delivered to all bound queues regardless of qualification.

Similar to the previous example, we’ll create a Producer console application which periodically publishes stock quote messages and a Consumer console application which displays the message to the console.

We’ll start our Producer app as before by establishing a connection using the default settings, creating the connection, and creating a channel:

<pre class="prettyprint">namespace Producer
{
  class Program
  {
    static volatile bool _cancelling;

    static void Main(string[] args)
    {
      var connectionFactory = new ConnectionFactory();
      IConnection connection = connectionFactory.CreateConnection();
      IModel channel = connection.CreateModel();
    }
  }
}
</pre>

Next, we need to declare an exchange of type “fanout”. We’ll name our new exchange “fanout-exchange-example”:

<pre class="prettyprint">channel.ExchangeDeclare("fanout-exchange-example", ExchangeType.Fanout, false, true, null);
</pre>

To publish the stock messages periodically, we’ll call a PublishQuotes() method with the provided channel and run it on a background thread:

<pre class="prettyprint">var thread = new Thread(() => PublishQuotes(channel));
thread.Start();
</pre>

Next, we’ll provide a way to exit the application by prompting the user to enter ‘x’ and use a simple Boolean to signal the background thread when to exit:

<pre class="prettyprint">Console.WriteLine("Press 'x' to exit");
var input = (char) Console.Read();
_cancelling = true;
</pre>

Lastly, we need to close the channel and connection:

<pre class="prettyprint">channel.Close();
connection.Close();
</pre>

For our PublishQuotes() method, well iterate over a set of stock symbols, retrieve the stock information for each symbol, and publish a simple string-based message in the form [symbol]:[price]:

<pre class="prettyprint">static void PublishQuotes(IModel channel)
{
  while (true)
  {
    if (_cancelling) return;
    IEnumerable&lt;string> quotes = FetchStockQuotes(new[] {"GOOG", "HD", "MCD"});
    foreach (string quote in quotes)
    {
      byte[] message = Encoding.UTF8.GetBytes(quote);
      channel.BasicPublish("fanout-exchange-example", "", null, message);
    }
    Thread.Sleep(5000);
  }
}
</pre>

To implement the FetchStockQuotes() method, we’ll use the Yahoo Finance API which entails retrieving an XML-based list of stock quotes and parsing out the bit of information we’re interested in for our example:

<pre class="prettyprint">static IEnumerable&lt;string> FetchStockQuotes(string[] symbols)
{
  var quotes = new List&lt;string>();

  string url = string.Format("http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20({0})&env=store://datatables.org/alltableswithkeys",
      String.Join("%2C", symbols.Select(s => "%22" + s + "%22")));
  var wc = new WebClient {Proxy = WebRequest.DefaultWebProxy};
  var ms = new MemoryStream(wc.DownloadData(url));
  var reader = new XmlTextReader(ms);
  XDocument doc = XDocument.Load(reader);
  XElement results = doc.Root.Element("results");

  foreach (string symbol in symbols)
  {
    XElement q = results.Elements("quote").First(w => w.Attribute("symbol").Value == symbol);  
    quotes.Add(symbol + ":" + q.Element("AskRealtime").Value);
  }

  return quotes;
}
</pre>

Here is the complete Producer listing:

<pre class="prettyprint">using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading;
using System.Xml;
using System.Xml.Linq;
using RabbitMQ.Client;

namespace Producer
{
  class Program
  {
    static volatile bool _cancelling;

    static void Main(string[] args)
    {
      var connectionFactory = new ConnectionFactory();
      IConnection connection = connectionFactory.CreateConnection();
      IModel channel = connection.CreateModel();
      channel.ExchangeDeclare("fanout-exchange-example", ExchangeType.Fanout, false, true, null);

      var thread = new Thread(() => PublishQuotes(channel));
      thread.Start();

      Console.WriteLine("Press 'x' to exit");
      var input = (char) Console.Read();
      _cancelling = true;

      channel.Close();
      connection.Close();
    }

    static void PublishQuotes(IModel channel)
    {
      while (true)
      {
        if (_cancelling) return;
        IEnumerable&lt;string> quotes = FetchStockQuotes(new[] {"GOOG", "HD", "MCD"});
        foreach (string quote in quotes)
        {
          byte[] message = Encoding.UTF8.GetBytes(quote);
          channel.BasicPublish("fanout-exchange-example", "", null, message);
        }
        Thread.Sleep(5000);
      }
    }


    static IEnumerable&lt;string> FetchStockQuotes(string[] symbols)
    {
      var quotes = new List&lt;string>();

      string url = string.Format("http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20({0})&env=store://datatables.org/alltableswithkeys",
          String.Join("%2C", symbols.Select(s => "%22" + s + "%22")));
      var wc = new WebClient {Proxy = WebRequest.DefaultWebProxy};
      var ms = new MemoryStream(wc.DownloadData(url));
      var reader = new XmlTextReader(ms);
      XDocument doc = XDocument.Load(reader);
      XElement results = doc.Root.Element("results");

      foreach (string symbol in symbols)
      {
        XElement q = results.Elements("quote").First(w => w.Attribute("symbol").Value == symbol);  
        quotes.Add(symbol + ":" + q.Element("AskRealtime").Value);
      }

      return quotes;
    }
  }
}
</pre>

Our Consumer application will be similar to the one used in our logging example, but we’ll change the exchange name, queue name, and exchange type and put the processing of the messages within a while loop to continually display our any updates to our stock prices. Here’s the full listing for our Consumer app:

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

      channel.ExchangeDeclare("fanout-exchange-example", ExchangeType.Fanout, false, true, null);
      channel.QueueDeclare("quotes", false, false, true, null);
      channel.QueueBind("quotes", "fanout-exchange-example", "");

      var consumer = new QueueingBasicConsumer(channel);
      channel.BasicConsume("quotes", true, consumer);

      while (true)
      {
        try
        {
          var eventArgs = (BasicDeliverEventArgs) consumer.Queue.Dequeue();
          string message = Encoding.UTF8.GetString(eventArgs.Body);
          Console.WriteLine(message);
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

Setting our solution startup projects to run both the Producer and Consumer apps together, we should see messages similar to the following for the Consumer output:

<pre class="prettyprint">GOOG:611.62
HD:48.66
MCD:91.06
GOOG:611.58
HD:48.66
MCD:91.06
</pre>

To show our queue would receive messages published to the fanout exchange regardless of the routing key value, we can change the value of the routing key to “anything”:

<pre class="prettyprint">channel.QueueBind("quotes", "fanout-exchange-example", "anything");
</pre>

Running the application again shows the same values:

<pre class="prettyprint">GOOG:611.62
HD:48.66
MCD:91.06
GOOG:611.58
HD:48.66
MCD:91.06 
</pre>

That concludes our fanout exchange example. Next time, we’ll take a look at the topic exchange type.
