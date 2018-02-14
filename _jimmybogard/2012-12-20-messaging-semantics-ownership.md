---
wordpress_id: 712
title: 'Messaging Semantics: Ownership'
date: 2012-12-20T15:51:44+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=712
dsq_thread_id:
  - "984414031"
categories:
  - DomainDrivenDesign
  - NServiceBus
  - SOA
---
In the last post, I covered [naming of messages](http://lostechies.com/jimmybogard/2012/12/06/messaging-semantics-names-and-verbs/) for the different kinds of messages we typically see:

  * Commands 
      * Replies 
          * Events</ul> 
        The names of messages is the first clue I look in to see if boundaries are correct. Often, when names are strange or don’t make sense in regards to their semantics, something is off. The flip side to the names of messages would be the owners of messages. In messaging systems, someone has to own what the messages are named, what they look like, and how they are used.
        
        In NServiceBus, there is always one logical endpoint that owns any particular message. This is a bit different in the real, physical world of messaging where humans communicate. Human communication is a dynamic conversation, where back and forth communication doesn’t necessarily have a well-defined path. In our messaging world, we have to develop these paths, leading to the need of actual ownership.
        
        This isn’t unlike formal communications in the real world, such as things like visa application forms, magazine subscriptions, or communications between airline pilots and air traffic controllers. In the real world, we do have to deal with things like emotions, so luckily our systems don’t have to ask nicely to accomplish anything.
        
        Let’s look at two parties engaged in communication via messaging:
        
        [<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2012/12/image_thumb.png" width="171" height="291" />](http://lostechies.com/content/jimmybogard/uploads/2012/12/image.png)
        
        We have a client needing to communicate to the server, and vice versa. And depending on the type of message, the direction of the message will be different, but ownership will stay the same. Let’s look first at command (and request/reply).
        
        ### Command ownership
        
        In the context of a command, someone has to own the handling of that command. We might think that this is something like a boss telling employees to put their vacation in, or a general issuing orders to a group of sergeants. In the messaging world, it doesn’t quite work that way. Someone has to own not only the shape of the message, but the handling as well.
        
        With commands, this means that someone has to own the handler, but I can’t force _clients_ to handle a message in a specific manner. Instead, I can merely expose that _I_ have the ability to perform some activity and _you_ can direct me to do so by sending me a message.
        
        This implies that our server not only owns the handler, but owns the message as well:
        
        [<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2012/12/image_thumb1.png" width="223" height="291" />](http://lostechies.com/content/jimmybogard/uploads/2012/12/image1.png)
        
        If we have some website exposing the ability to place an order, or a mail-order catalog, that order form is the command to place and order. The server owns the message and the ability to place the order. Clients then interact with the server via commands. But the server owns the commands, and clients can’t change that fact.
        
        Responses, when they exist, are usually tied to commands:
        
        [<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2012/12/image_thumb2.png" width="329" height="291" />](http://lostechies.com/content/jimmybogard/uploads/2012/12/image2.png)
        
        Responses/replies are always tied to an original message. You can only reply in your email client when you’re looking at some individual email message first. That’s why replies are also owned by the server, it’s tied to a specific initial command/request. Even though the handling has swapped, the server owns the conversation, so it owns the message.
        
        ### Events
        
        Events are published via pub/sub. When you subscribe to a mailing list, you first express intent by signing up to the mailing list. When new messages are posted to the mailing list, those messages are sent to every subscriber.
        
        This is just like subscribing to print magazines – the message is delivered to the client/subscriber:
        
        [<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2012/12/image_thumb3.png" width="238" height="291" />](http://lostechies.com/content/jimmybogard/uploads/2012/12/image3.png)
        
        But now the server can deliver the same message to _many_ clients, as many as have subscribed. But the server still owns the message. You can’t write into a magazine publisher and request a new type of magazine – that’s not how the world works.
        
        ### Ownership, intent and semantics
        
        The common mistake I see people make as they move from RPC-style communication of web services to messaging is confusing the semantics of their message. They know that message Foo needs to be delivered from machine A to machine B, but what is that message? Is it a sent command, or published event?
        
        It all comes back to semantics, intent, and ownership. With commands, the server owns the message and ability. I’m instructing clients of my abilities, and the means of interacting with my abilities.
        
        With events, I’m telling clients that I can notify them when things have happened in my system. What they do with that information, I don’t care. Here it is, something happened, take it and go.
        
        It all comes back to coupling. With commands, I’m coupled to other peoples abilities (that’s not a BAD thing necessarily). With events, servers are decoupled from what clients want to do with the message.
        
        Next up: SOA, DDD, boundaries and messages