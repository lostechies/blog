---
id: 590
title: Built-In Roles in NServiceBus
date: 2012-02-22T19:03:32+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/2012/02/22/built-in-roles-in-nservicebus/
dsq_thread_id:
  - "585676635"
categories:
  - NServiceBus
---
One common scenario we see with [NServiceBus](http://nservicebus.com/) is the desire to have different configuration in different environments. For frameworks and applications that rely on external configuration, such as the .config file or other external store, there’s an easy route to segregate configuration. For NServiceBus, much of its configuration is code-based.

To help fill the gap of different code-based configuration in different environments, the NServiceBus [Profiles](http://nservicebus.com/Profiles.aspx) allows the developer to apply different profiles in different environments through command-line arguments to the [NServiceBus Generic Host](http://nservicebus.com/GenericHost.aspx). To make things simpler for getting up and running, NServiceBus provides three built-in profiles:

  * Lite
  * Integration
  * Production

Each profile modifies logging and other behaviors (Lite is full-logging, in-memory sagas etc.) But there’s one other piece to this puzzle – the Generic Host also has the concept of roles. Roles are distinct from Profiles in that any given endpoint can only be one Role, whereas Profiles are cumulative. Roles and Profiles can work together – often times you’ll see Profiles check for roles and perform alternate configuration. But Roles are typically things that don’t change across environments.

NServiceBus has three built-in roles:

  * AsA_Client
  * AsA_Server
  * AsA\_Publisher (inherits AsA\_Server)

These are marker interfaces, which light up instances of IConfigureRole<TRole> for each specific role. So what do each of these provide? Let’s look at each individual role.

### Client Role

The client’s role is somewhat simple – it can send messages, it \*may\* receive messages, but any messages received are purged on startup. This is because a client only receives messages for replies – and replies are often contextual to a command, so it doesn’t make sense to address replies to things that have happened earlier. The client role handler is:

[gist id=1886612]

A few things to note – the inbox is cleared at startup, and reading from the inbox isn’t transactional. Again, this is because a client role receiving messages is only for replies, and for send-only endpoints, replies are all about acknowledgements. These kinds of acknowledgements are usually for contextual actions done by user.

### Server Role

Server role is a bit more involved. The server receives messages that are either sent to it or published to it. Typically, work is done from these handlers, so we want a bit more ACID-ty to our handlers. Our server role handler is:

[gist id=1886614]

The big changes here are that we’re enlisting in a transaction when consuming messages. Additionally, any sent/published messages are in the same transaction, so no message is sent unless the transaction succeed. Additionally, we configure ourselves to be able to handle sagas (but specifics are in the profiles).

### Publisher Role

The Publisher role in NServiceBus inherits from the Server role, so all Server configuration is applied. There is no specific Publisher role handler. Instead, some of the built-in profiles check for the publisher role to apply additional configuration. In each of the built-in profiles, they check to see if the configuration is a Publisher, and in that case, applies different subscription storage based on the profile:

  * Lite – In memory subscription storage
  * Integration – RavenDB (part of a distributor or master/slave deployment) or Msmq subscription storage
  * Production – RavenDB

It can be a bit confusing when moving from the built-in profiles/roles to custom configuration, but at least knowing the baseline helps to point what you get versus what you need to add.

Next, we’ll look at what profiles and roles are in NServiceBus and why we should care.