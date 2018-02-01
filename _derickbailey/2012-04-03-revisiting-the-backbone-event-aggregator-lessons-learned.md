---
id: 863
title: 'Revisiting The Backbone Event Aggregator: Lessons Learned'
date: 2012-04-03T07:14:28+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=863
dsq_thread_id:
  - "635009524"
categories:
  - Backbone
  - Composite Apps
  - JavaScript
  - Marionette
  - Messaging
---
It&#8217;s been a while since I originally talked about using an event aggregator in my Backbone applications. Since then, I&#8217;ve encapsulated the &#8220;vent&#8221; object in my Backbone.Marionette application and I&#8217;ve also realized that a lot of what I wrote originally is steeped in C# thinking. Specifically, the way I&#8217;m passing the vent object in as a dependency everywhere, gets really old and frustrating really fast. I&#8217;ve also read some interesting blog posts in recent months that take the basic idea of what I wrote and run in some interesting directions.

## Dependency Injection: Bad Idea

This is the first of the obvious mistakes that I made my original blog post and implementation. Passing around an event aggregator as a dependency for various objects is just plain painful in JavaScript. There&#8217;s no real value in doing this, either. The few benefits that it may provide are greatly outweighed by the flexibility inherent in JavaScript and our ability to work around the problem that dependency injection solves.

You can see the obvious problems in the original code, pretty easily:

[gist id=1092444 file=5-event-aggregation.js]

Having to pass the \`vent\` object to every single constructor gets frustrating, fast. It turns in to a real nightmare, though, when you want to trigger an event from an object that is 5 or 6 levels deep in an object graph. If this is the only place that needs to trigger an event, you still have to pass the aggregator around to all of the objects in the graph.

### Solution: Application Level Aggregator

One of the solutions, and the easiest way to start using an event aggregator, is to attach the aggregator to your application&#8217;s namespace object. This becomes the application level event aggregator that any code in your application can attach to and trigger events from.

[gist id=2146930 file=1.js]

I&#8217;ve baked this idea directly in to my Marionette.Application object. When you instantiate a Marionette.Application, you get the \`vent\` attribute with it.

[gist id=2146930 file=2.js]

<span style="font-size: 14px; font-weight: bold;">Solution: Sub-Module Aggregators</span>

Along with the application level event aggregator, there are times when you&#8217;ll want to have some events tossed around within an application sub-module. When I run in to this need, I don&#8217;t rely on the application&#8217;s \`vent\`, instead I&#8217;ll build one specific to the module.

For example, if I were building an application module to manage users and I needed to run some events in between various parts of the user management screens, I might do it like this:

[gist id=2146930 file=3.js]

Note that I&#8217;m also showing the Marionette.EventAggregator object in this example. This object is a tiny bit more than the standard \`_.extend({}, Backbone.Events);\` that I typically use, but not by much.

I still have access to the application&#8217;s event aggregator, but now I also have access to an aggregator that is specific to the module. This lets me publish and subscribe to events that are local to the module. Other modules in the application are not able to see this aggregator, so they are not able to publish / subscribe with it. If I need this module to talk to other modules, then, I use the application&#8217;s aggregator.

 

## Multiple Channels For Events

This idea comes from [a blog post I read a while back](http://www.michikono.com/2012/01/11/adding-a-centralized-event-dispatcher-on-backbone-js/) that posits the idea of having multiple channels for events. Thinking back to my full-scale enterprise-service-bus development days, I can see the value in this. It allows you to have different subscribers on different channels, letting each of those channels act independently. But there&#8217;s a few problems with this in JavaScript that are solved in much more simple manners.

### The Idea

The basic idea behind &#8220;channels&#8221; is that you can have a single event aggregator or message bus that allows publishers and subscribers to communicate with each other in a segmented manner.

Think about a CB-radio for a moment. You can turn the CB to various channels. When you talk through your CB on a given channel, other people that are listening to that channel will hear you. If you are listening to a specific channel, you will hear other people that are talking on that channel. If you are talking on Channel 1, though, and someone else is listening on Channel 2, they will not hear you.

### The Problems

The same principle is often applied in service-bus architectures, where standing up multiple services buses for communication is expensive. But this doesn&#8217;t translate too well in to JavaScript &#8211; at least not with simple event aggregators like I&#8217;m using.

A simple use of an event aggregator that supports channels might look something like this:

[gist id=2146930 file=4.js]

In this example, we&#8217;re standing up an aggregator and then subscribing to an even on a channel. We then trigger the event on that channel, and our handler is called. This seems easy enough and it shouldn&#8217;t take that much work to implement channels.

The real problem, though, is that the number of publishers and subscribers using this one event aggregator can quickly get out of hand. Every time we trigger an event through a channel, we have to filter the list of subscribers so that we only publish the event to those listening on the correct channel. This filtering is going to take time. If we have a large number of subscribers in our aggregator, and we only need to send the event to one of them, why should we have to sift through the rest of them?

There are some optimizations that we can put in place, of course. We could set up the &#8220;on&#8221; method so that when you specify what channel to listen on, it stores your handler in a collection of listeners specifically for that channel. Then when you trigger an event, the channel can be matched to the collection of subscribers more quickly.

The odd part about this, though, is that we&#8217;re adding a lot of infrastructure and code to support what amounts to multiple event aggregators. We&#8217;re aggregating the aggregators and then using code to split apart the aggregate when we need to publish and subscribe.

Again, I understand why this seems like a good idea. When you&#8217;re dealing with actual network communications and distributed systems where a service bus is an expensive thing to stand up, you&#8217;ll want to make this kind of optimization. But when you&#8217;re dealing with an in-memory application and event aggregator, you&#8217;re adding overhead that is not needed. The easier option, instead, is to use multiple event aggregators: one per &#8220;channel&#8221;.

### A Simple Solution: Many Event Aggregators

By setting up multiple event aggregators, we can more effectively optimize the memory and performance of our application.

[gist id=2146930 file=5.js]

Now when we have many overall subscribers to many event aggregators, publishing to a single event aggregator doesn&#8217;t have to think about which subscribers should and should not be checked, based on channels. When you publish to a specific event aggregator, it checks all of the subscribers that it has registered, and that&#8217;s it.

### A Built In Solution: Event Namspacing

The other option that we see in Backbone events is the use of namespaced events. For example, when you set some data on a Backbone model, you get multiple events:

[gist id=2146930 file=6.js]

Now this isn&#8217;t truly a namespace in the event handler. There is no parsing of the event name to try and figure out where the : is in the event name, to filter out which subscribers should be receiving the event. This is only a convention that helps us, as developers, see which events belong together.

### But Events Will Be Filtered Anyways

In the end, the event aggregator object does have to filter out the subscribers that don&#8217;t care about the event being triggered. There&#8217;s simply no way around this. When you have an event subscriber, you tell it what specific event to listen to. If a different event is triggered, that subscriber doesn&#8217;t get called. This is filtering by it&#8217;s nature and we can&#8217;t reasonably get away from that. My argument, though, is that we should limit the filtering as much as possible because it&#8217;s more expensive to filter a larger list than it is to split the list out in to multiple, separate objects.

 

## Semantics: Separating Command Messages From Event Messages

This is a topic that [I tried to explore already](http://lostechies.com/derickbailey/2011/11/18/is-there-an-idiomatic-command-pattern-implementation-for-javascript/), but I never found a good answer. I&#8217;m still looking for a good way to separate the idea of a command system from an event system in JavaScript. Both of these are message-based patterns, but I think the semantics of the message types is very important. I don&#8217;t want to see my command messages being passed around with the &#8220;on&#8221; / &#8220;off&#8221; / &#8220;trigger&#8221; method semantics. It doesn&#8217;t fit and it can get confusing which will lead to bugs in a system.

## Client-Side Messaging Anti-Patterns

[Jim Cowart](https://twitter.com/#!/ifandelse) has [a great article on client side messaging anti-patterns](http://freshbrewedcode.com/jimcowart/2012/03/19/client-side-messaging-in-javascript-part-3-anti-patterns/). I&#8217;m not going to try and re-visit any more items in his list, as this post is getting long enough already. Instead, I would highly recommend reading his post. I&#8217;m not sure I 100% agree with every last detail, but I think this largely comes down to opinions and not real technical merit. I&#8217;m probably close to 99.9% agreement, though.

## A Better Way Forward

Hopefully this post will help clear up some of the confusion and problems that I caused in my original post, while also presenting some ideas that can help you build a better organization around your event aggregator usage. I&#8217;m sure this won&#8217;t be the last set of lessons I learn or opinions I form on the subject, though. As always, I reserve the right to realize the mistakes I&#8217;ve made and change my opinion, without warning.