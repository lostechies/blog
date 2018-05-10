---
wordpress_id: 717
title: 'RabbitMQ for Windows: Exchange Types'
date: 2012-03-28T18:58:38+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=717
dsq_thread_id:
  - "628113181"
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
      RabbitMQ for Windows: Exchange Types
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

This is the fourth installment to the series: RabbitMQ for Windows.&nbsp; In the [last installment](https://lostechies.com/derekgreer/2012/03/18/rabbitmq-for-windows-hello-world-review/), we reviewed our Hello World example and introduced the concept of Exchanges.&nbsp; In this installment, we’ll discuss the four basic types of RabbitMQ exchanges. 

## Exchange Types

Exchanges control the routing of messages to queues.&nbsp; Each exchange type defines a specific routing algorithm which the server uses to determine which bound queues a published message should be routed to. 

RabbitMQ provides four types of exchanges: Direct, Fanout, Topic, and Headers. 

### Direct Exchanges 

The Direct exchange type routes messages with a routing key equal to the routing key declared by the binding queue.&nbsp; The following illustrates how the direct exchange type works: 

&nbsp; [<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="DirectExchange" border="0" alt="DirectExchange" src="https://lostechies.com/content/derekgreer/uploads/2012/03/DirectExchange_thumb1.png" width="600" height="219" />](https://lostechies.com/content/derekgreer/uploads/2012/03/DirectExchange1.png) 

&nbsp; 

The Direct exchange type is useful when you would like to distinguish messages published to the same exchange using a simple string identifier.&nbsp; This is the type of exchange that was used in our Hello World example.&nbsp; As discussed in part 3 of our series, every queue is automatically bound to a default exchange using a routing key equal to the queue name.&nbsp; This default exchange is declared as a Direct exchange.&nbsp; In our example, the queue named “hello-world-queue” was bound to the default exchange with a routing key of “hello-world-queue”, so publishing a message to the default exchange (identified with an empty string) routed the message to the queue named “hello-world-queue”. 

### Fanout Exchanges

The Fanout exchange type routes messages to all bound queues indiscriminately.&nbsp; If a routing key is provided, it will simply be ignored.&nbsp; The following illustrates how the fanout exchange type works: 

&nbsp; 

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="FanoutExchange" border="0" alt="FanoutExchange" src="https://lostechies.com/content/derekgreer/uploads/2012/03/FanoutExchange_thumb2.png" width="600" height="220" />](https://lostechies.com/content/derekgreer/uploads/2012/03/FanoutExchange2.png) 

&nbsp; 

The Fanout exchange type is useful for facilitating the [publish-subscribe pattern](http://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern).&nbsp; When using the fanout exchange type, different queues can be declared to handle messages in different ways.&nbsp; For instance, a message indicating a customer order has been placed might be received by one queue whose consumers fulfill the order, another whose consumers update a read-only history of orders, and yet another whose consumers record the order for reporting purposes. 

### Topic Exchanges

The Topic exchange type routes messages to queues whose routing key matches all, or a portion of a routing key.&nbsp; With topic exchanges, messages are published with routing keys containing a series of words separated by a dot (e.g. “word1.word2.word3”).&nbsp; Queues binding to a topic exchange supply a matching pattern for the server to use when routing the message.&nbsp; Patterns may contain an asterisk (“\*”) to match a word in a specific position of the routing key, or a hash (“#”) to match zero or more words.&nbsp; For example, a message published with a routing key of “honda.civic.navy” would match queues bound with “honda.civic.navy”, “\*.civic.\*”, “honda.#”, or “#”, but would not match “honda.accord.navy”, “honda.accord.silver”, “\*.accord.*”, or “ford.#”.&nbsp; The following illustrates how the fanout exchange type works: 

&nbsp; 

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="TopicExchange" border="0" alt="TopicExchange" src="https://lostechies.com/content/derekgreer/uploads/2012/03/TopicExchange_thumb2.png" width="600" height="220" />](https://lostechies.com/content/derekgreer/uploads/2012/03/TopicExchange2.png) 

&nbsp; 

The Topic exchange type is useful for directing messages based on multiple categories (e.g. product type and shipping preference ), or for routing messages originating from multiple sources (e.g. logs containing an application name and severity level). 

### Headers Exchanges

The Headers exchange type routes messages based upon a matching of message headers to the expected headers specified by the binding queue.&nbsp; The headers exchange type is similar to the topic exchange type in that more than one criteria can be specified as a filter, but the headers exchange differs in that its criteria is expressed in the message headers as opposed to the routing key, may occur in any order, and may be specified as matching any or all of the specified headers.&nbsp; The following illustrates how the headers exchange type works: 

&nbsp; 

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="HeadersExchange" border="0" alt="HeadersExchange" src="https://lostechies.com/content/derekgreer/uploads/2012/03/HeadersExchange_thumb2.png" width="600" height="220" />](https://lostechies.com/content/derekgreer/uploads/2012/03/HeadersExchange2.png) 

&nbsp; 

The Headers exchange type is useful for directing messages which may contain a subset of known criteria where the order is not established and provides a more convenient way of matching based upon the use of complex types as the matching criteria (i.e. a serialized object). 

## Conclusion

That wraps up our introduction to each of the exchange types.&nbsp; Next time, we’ll walk through an example which demonstrates declaring a direct exchange explicitly and take a look at the the push API. </b>
