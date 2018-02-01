---
id: 233
title: 'Encapsulation: You&#8217;re Doing It Wrong'
date: 2011-03-28T07:05:20+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=233
dsq_thread_id:
  - "264971589"
categories:
  - AntiPatterns
  - Principles and Patterns
---
Encapsulation, or Information Hiding, is one of the core principles of object oriented software development. It ranks up there with Cohesion, Polymorphism, Inheritance and all the other OO things we all hear about and learn about. Unfortunately, many of the software developers that I&#8217;ve encountered in my career don&#8217;t know what encapsulation actually is&#8230; honestly, it&#8217;s only been the last 2 to 3 years that I&#8217;ve really started to understand it, too, so how could I expect everyone else to get it right?

 

### A Definition

According to Wikipedia, [Encapsulation, as Information Hiding](http://en.wikipedia.org/wiki/Encapsulation_%28object-oriented_programming%29), is when:

> the internal representation of an object is generally hidden from view outside of the object&#8217;s definition. Typically, only the object&#8217;s own methods can directly inspect or manipulate its fields. Some languages like Smalltalk and Ruby only allow access via object methods, but most others (e.g. C++ or Java) offer the programmer a degree of control over what is hidden, typically via keywords like public and private.

While this definition and the rest of the section on information hiding is technically correct, it is also naive or short-sighted.

 

### A Common And Misguided, Misunderstanding

I&#8217;ve watched many developers &#8211; including myself &#8211; make arguments along the lines of &#8220;properties are encapsulation&#8221;. After all &#8220;I made the fields private, and only let my data be accessible via the public properties.&#8221; &#8230; and that means my objects are encapsulated, right? It gets even better when we hide a private List<T> field behind Add and Remove methods and only expose an IEnumerable<T> property to get the entire list. Sure, this may be a part of how encapsulation is done. However, a lot of people stop here. Saying that this represents encapsulation in it&#8217;s entirety, or stopping at this point and not even considering that this is short-sighted is dangerous.

If we were to take the Wikipedia definition as all we need, the result would be a spaghetti mess of code that becomes difficult to work with, quickly. We end up with a lot of objects that are nothing more than simple data structures that we pass around to the various UI components, data access components, web service integration points, etc. As a system grows, code gets duplicated and triplicated and then some. A well defined process suddenly has a dozen or more implementations because there are that many sections of the application that need all or part of that process. We introduce complexity and maintenance nightmares with this type of code and our ability to be productive with the code base tanks, rapidly.

There is a better way, though, and it starts by admitting this:

> **Encapsulation: I&#8217;m doing it wrong.**

 

### A Better Definition: Information Hiding

I&#8217;ll leave the first part of the definition I showed above, alone. It fits well with the right way to look at encapsulation:

> the internal representation of an object is generally hidden from view outside of the object&#8217;s definition.

Beyond this sentence fragment, though, we have to throw out the definition and re-examine two key words: information hiding.

First, &#8220;information&#8221;. What is information? Isn&#8217;t it the data that my class stores? Possibly&#8230; but that&#8217;s a very narrow view of information. I&#8217;ve heard many times in recent years that we have an abundance of data, and a lack of information. I like this perspective because it helps to draw a clear line between data and information. Data is all the bits &#8211; the facts, the figures, the snippets and quotes, and the raw pieces that can be put together and pulled apart in many different ways. Information, on the other hand, is the application of data as something meaningful and valuable.

Second is &#8220;hiding&#8221;. Ok, this doesn&#8217;t need much explanation. Hiding is making something not visible to those that don&#8217;t need to see it.

Now take the perspective of data versus information back to simple idea of encapsulation. What are the properties of a class? What do they represent? &#8230; data. They are bits that can be put together and pulled apart, and used in various ways. The data is necessary. We often need to have properties (whether or not we have &#8220;encapsulated&#8221; the data in a private field with a public property to wrap around it) that tell us something. However, the data alone cannot be called &#8220;information&#8221;.

For the data to be meaningful and valuable, we have to put it to use. We do that with additional code &#8211; by writing routines that know how to look at the data and do useful things with it. The business process, the logic and flow, the sequence of operations; these are all the things that turn data into information. While the process is a necessary part of creating information, is not sufficient on it&#8217;s own, either. In order to have information in our systems, we must have both the data and the process to transform it and apply it where it is meaningful and valuable.

 

### Correctly Applying Encapsulation

We know that both data and process are necessary to create information, and we know that neither of them are sufficient on there own. We also know that encapsulation is information hiding: preventing the outside world from knowing about the internal detail and implementation. With that in mind, we come to the conclusion that encapsulation is not just private fields with public properties, but it is both the data and the process (or behavior) being hidden or wrapped up in an implementation that is not exposed to the outside world. When we create a class, we do not stop at hiding the data with private fields. We also ensure that the process of converting the data into information is hidden within the class. We encapsulate the data and the process, creating an object that has both data and behavior.

A human being, for example, is not just height, weight, eye color, hair color, and other data points. A human being is also a set of behaviors (influenced by many things, including genetics, life experience, etc) which make each of us unique. Similarly, a car is not just a make, model, year, pain color, wheel size, etc. A car is also a set of behaviors that allow it to be driven.

 

### Encapsulation: Do It Right

Re-examine your current coding practices and ask yourself i you really are encapsulating correctly. Are you truly hiding _information_, or are you just creating public properties that wrap private fields? Yes, there are times when simple data structures &#8211; classes that have nothing more than properties to get and set data &#8211; are necessary. However, these are not representative of encapsulation.

Encapsulation is a powerful tool. Learn it. Practice it. Apply it to your code, correctly.

 

### Reaching For And Moving Beyond Encapsulation

There are many other object oriented principles, as I mentioned previously. Encapsulation is only one piece of writing good object oriented software. There are other principles that need to be applied and accounted for, as well. For example, I&#8217;m fond of the SOLID software development principles &#8211; not because I think they are the one true way (they aren&#8217;t, by the way), but because they provide a simple set of guidelines and stepping stones that help us move our code toward good object oriented design and implementation. There are dozens of other principles that are similar and related to SOLID and I encourage you to find and study all of them. Every principle you learn will help you understand the other principles that you have already encountered and the ones that you have yet to encounter.