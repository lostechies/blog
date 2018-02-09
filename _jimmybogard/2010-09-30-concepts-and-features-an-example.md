---
wordpress_id: 437
title: Concepts and features – an example
date: 2010-09-30T13:41:16+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/09/30/concepts-and-features-an-example.aspx
dsq_thread_id:
  - "267430822"
categories:
  - Design
redirect_from: "/blogs/jimmy_bogard/archive/2010/09/30/concepts-and-features-an-example.aspx/"
---
One of my favorite posts by Ayende covers the idea of [concepts and features](http://ayende.com/Blog/archive/2009/03/06/application-structure-concepts-amp-features.aspx).&#160; Design occurs at the concept level, whereas features build on top of concepts.&#160; This can be a little abstract, but I recently ran into a situation where the presence of a concept in one area allowed for feature development, while the absence of a concept in another area made change difficult.

### Adding features to concepts

In this system, we integrate with many 3rd party vendors through file drops.&#160; Some data has changed in another system, or users have interacted with the system, or system-level events have occurred.&#160; When this happens, our system consumes these files and makes decisions based on what the data in the file represents.

These files come in a variety of formats, CSV, tab-delimited and XML.&#160; But one common concept in all of these files was that they represented a set of messages.&#160; We already introduced the concept of executing a “batch job”:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IBatchJob
</span>{
    <span style="color: blue">void </span>Execute();
}</pre>

[](http://11011.net/software/vspaste)

We then had a batch job executor that could execute any batch job.&#160; When a requirement came up to log exceptions when a batch job executed, this was a trivial task.&#160; We already created a system-wide concept of executing a batch job, it was now just a matter of adding that feature.

The next concept we needed to augment was the idea of handling a message.&#160; Each entry in the file was transformed into a message object, and a message broker located and executed the appropriate handler:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IMessageHandler</span>&lt;T&gt;
    <span style="color: blue">where </span>T : <span style="color: #2b91af">IMessage
</span>{
    <span style="color: blue">void </span>Handle(T message);
}</pre>

[](http://11011.net/software/vspaste)

We needed to know specifically when a handler failed, to log the specific message and exception so that the exception could be examined and the message potentially re-processed.&#160; Again, because all control for executing message handlers went to a single message broker, this is trivial to implement.&#160; **Applying the Single-Responsibility Principle and concepts of orthogonal design meant that no implementation needed to change to add this concept**.

### Absent concepts

The tipping point for identifying concepts comes when adding of a kind of feature becomes difficult, and needs architectural design work.&#160; In our case, it was the need to record the history of processing files.

We already have the concept of executing batch jobs and handling messages.&#160; The missing concept was processing a file.&#160; That is, locating a file, parsing it and converting to messages, and actually executing those messages.

There are about five different ways of doing this at the moment.&#160; In some cases we use a persistent batch object to represent the workflow of processing the file.&#160; In other cases, we just have some parser class that then invokes the message broker.

But in no place in our system architecture was the concept of processing a file.&#160; When it came time to add features to this concept, and the concept didn’t exist in our system, **it became pretty daunting to augment a non-existent design**.

In this case, **we waited too long to formalize the concept** of parsing files.&#160; We hadn’t needed to add new features to this absent concept, but building out the concept itself with the existing shape of disparate features would have made adding subsequent parsers much easier to think about and develop.

Concepts are quite similar to building blocks.&#160; Building on top of a concept means I already have a set of building blocks to start from.&#160; **Without concepts, I have a blank canvas**.&#160; This can be appropriate sometimes, but other times it leads to wildly different implementations.

Even though each implementation of the file parsing was self contained, overall ease of maintainability suffered because there was no common theme, no unifying concept, no design.

### Balancing design and YAGNI

It’s easy to put off concept design with the excuse of YAGNI.&#160; We waited until we needed the feature of recording the parsing outcome before we went down the road of designing the concept.&#160; Unfortunately, that left quite a bit of rework and redesign, as we had so many different ways of parsing files.

Instead, recognizing the concept of parsing files early would have made subsequent file parsing easier to understand.&#160; We wouldn’t have had to think about what pieces we needed to invent before putting together the puzzle.&#160; The outlines would have already been there, and we would have just needed to fill in the blanks.

I’m all for starting with blank canvases.&#160; But on a regular basis, **introspection is needed to search for common concepts to build upon**.&#160; Otherwise, we lead ourselves into wildly heterogeneous architecture.