---
id: 195
title: A Response To “What Is An Interface” By John Sonmez
date: 2010-11-03T18:11:35+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2010/11/03/a-response-to-what-is-an-interface-by-john-sonmez.aspx
dsq_thread_id:
  - "264973710"
categories:
  - .NET
  - AntiPatterns
  - 'C#'
  - Principles and Patterns
  - Unit Testing
---
this started out as a very lengthy reply to john sonmez’ post on [What Is An Interface](http://simpleprogrammer.com/2010/11/02/back-to-basics-what-is-an-interface/). There’s enough that I want to say that I think it warrants me posting on my blog instead of blogging in his comment stream.

it’s a good post in general. i completely agree that we are overusing / abusing the interface construct in c# (i&#8217;m not a java guy, so no comment there). i have been dong my own exploration of this recently (as evidenced by my own blog posts). however, i think there are a few points of clarification that are needed for john’s post. he hinted around some of them but never quite said them directly. and there are a few things i don&#8217;t agree with, too.

&#160;

### Clarifying “Interface” In This Context

to deal with the "interface" of an object does not require an explicit construct. the public methods and attributes (properties in .net language) make up the interface. but "interface" in this context is the explicit interface construct as provided by C# and Java. other languages, like C, C++, Ruby, Python etc. may not provide an interface construct but they do provide an interface to the object. 

&#160;

### Interfaces Are Not Strictly “Contracts”

yes, this is a little pedantic and it’s splitting semantic hairs. i’m going to say it anyway. 

be careful of using the word "contract" and saying an interface construct means a class "meets certain expectations that other classes can rely on". this crosses over into design-by-contract and we don&#8217;t have that in c# (i don&#8217;t know about java). an interface may be present in a class, but there is no certainty in the interface implementation. you may receive NotImplementedExceptions. this is bad design and leaky abstractions with lots of principal violations, etc. but it&#8217;s the reality that we have to deal with since we don&#8217;t have real contracts. 

i like how scott bellware describes the interface construct: a protocol. "a convention or standard that controls or enables the connection, communication, and data transfer between computing endpoints" &#8211; from wikipedia. it keeps the lines&#160; between design by contract and the interface construct clean. 

&#160;

### Header Interfaces and Dependency Inversion

I generally don’t like header interfaces (an interface that describes the entire class implementing it&#8230; "class Foo: IFoo"). they are the big problem that john is talking about and i agree with his perspective here. 

we can also help resolve the problem of header interfaces by remembering the dependency inversion principle and by using role-specific interfaces (which you talked about already). if ClassA needs some external thing to do work for it, ClassA defines the protocol that it needs. let&#8217;s call it IDoSomething. when ClassA needs to change how it communicates with the external piece, it changes IDoSomething and anything that implements IDoSomething changes to match. not the other way around. We don&#8217;t change IDoSomething when the implementer changes, forcing ClassA to change how it communicates. 

I think Udi Dahan calls this a “role specific interface”, which is a great term for doing interfaces correctly.

&#160;

### DI, Unit Testing, and Abstraction

i am in 100% agreement with john when you say we abuse dependency injection and unit tests as a way to justify excessive amounts of interfaces.&#160; we can partially solve this problem by remembering that testing only requires isolation between parts of the system that need to be verified independently. we don&#8217;t have to isolate everything all the time.

but remember: abstraction and isolation do not require an interface all the times. a class is not sealed by default in c# and we can use delegates and even simple data types as abstractions to create testability, at times. of course, this doesn’t negate the problems that john is pointing out. it only gives us a few more options in a few specific scenarios.

&#160;

### Sometimes Isolation Is A Valid Reason For A Interface Construct

this is a very wide, gray area. 

there are times when the testability of a system or module is an appropriate reason for an interface construct. the easy scenario in this is to look at external systems like a database, network or file system. it’s obvious that we want isolation from these implementation details. remembering the dependency inversion principle will help us take care of this.

there are times, though, when parts of the same system should be isolated for testing purposes and creating an interface construct (again, using dependency inversion) is appropriate. the typical case for this is when a part of the system is complex, critical, or otherwise needs special attention and must be verified independently of anything that interacts with it, or anything that it interacts with.

&#160;

### In the end… 

I agree with the major points john is making. i just wanted to add a few of my own clarifications to give a little larger perspective into some of it. having worked with john for a while now, i doubt that we would disagree on anything important when it comes down to it. whether or not the points i’m bringing up are important… meh, i don’t know. i just felt like getting this out there.

now… this conversation gets even more interesting when we start talking about ruby, python, javascript and other dynamic languages… but that’s an entire book all on it’s own…