---
wordpress_id: 700
title: 'Messaging semantics: names and verbs'
date: 2012-12-06T07:57:44+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=700
dsq_thread_id:
  - "960712749"
categories:
  - NServiceBus
---
In most messaging systems I’ve worked with (synchronous or asynchronous), there are three general types of messages that arise:

  * Commands
  * Replies
  * Events

Queries can be thought of as a special kind of command where I ask for something and get a result. When moving from imperative languages to messaging patterns, it can be a bit of a leap to think in terms of interacting via messages, instead of just interacting with objects directly. In introducing messaging to developers, it’s common to have a bit of trouble making sure interactions match the message and naming semantics you intend.

In NServiceBus, we have three major means of telling NServiceBus to send a message:

  * Bus.Send
  * Bus.Reply
  * Bus.Publish

Each of these in turn corresponds to Commands, Replies, and Events, respectively. But we need to go one step further, and ensure that the _names_ of our messages matches the _intent_ of our communication. When names don’t match the semantics of an interaction, it’s a design smell and an indication that something in your design of interactions has gone awry.

One easy way to verify semantics is to simply check the naming of the message. Each message type has a very particular design in its name to be as explicit as possible about what the nature of the message and interaction is, 

  * Command: [Imperative verb](http://www.usingenglish.com/glossary/imperative.html)
  * Reply: Noun
  * Event: Past-tense verb (past simple, to be specific)

Examples:

  * Command: RegisterCustomer
  * Reply: RegisterCustomerResult
  * Event: CustomerRegistered

Replies often describe the result of a command, and are usually tied 1:1 with a specific command. Or, a more general result can be used.

So if you Bus.Send a message that is worded in past tense, or Bus.Publish a message that seems rather bossy (Bus.Publish<UpdateCache>) then your interaction and semantics are off.

Next up – ownership.

Happy messaging!