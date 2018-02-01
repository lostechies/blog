---
id: 385
title: How do you handle simple pub-sub, evented architecture in rails apps?
date: 2011-06-08T21:23:54+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=385
dsq_thread_id:
  - "326300464"
categories:
  - Analysis and Design
  - AppController
  - Messaging
  - Principles and Patterns
  - Ruby
---
I&#8217;ve been asking this question in various forms, via twitter, for a few days now. I&#8217;ve received a number of answers from people and have spent some time talking with Jak Charlton about the patterns that I would have used in a .NET Winforms app vs what I should look at in a ruby / rails app. At this point, I&#8217;m still confused.

Rather than continue to ask bits and pieces of my questions via twitter, I want to try and get my thoughts out in something coherent&#8230; to explain the context of what I&#8217;m building and hopefully find some solid advice on how to handle this situation (and the many similar situations that I need to handle).

 

### The Context

Joey Beninghove and I are building a medical application. In one part of the system, we are dealing with patients and their current medications. We have to store the medications that they are currently taking. There are multiple places that can modify the medications a patient is taking. For example, the patient profile will have a current medications list and allow that list to be edited right there. In another part of the system, patient medications are selected as part of a treatment plan.

The medications selected in the treatment plan are not immediately applied to the patient, though. The system waits for a doctor to select all of the treatment options for the patient before signing off and saving those options as the patient&#8217;s current treatment plan. Once the treatment plan is signed off, the medications that were selected in the plan will get applied to the patient as part of their current medications list.

Since our system deals with medical data for patients, we have to be HIPAA compliant (HIPAA is the &#8220;Health Insurance Portability and Accountability Act&#8221; in the United States). This compliance requires us to keep audit trails for who is reviewing and modifying patient information (among other things). This means that every time a medication is changed for a patient, we have to log who is making the change, when they are making it, and what it&#8217;s changing to.

 

### The Idea

I want to keep the various parts of the system decoupled, as much as possible. I don&#8217;t want the treatment plan to have to know about the patient profile and current medications list, directly. I don&#8217;t want the patient profile or treatment plan to have to know about HIPAA compliance auditing, either. The amount of work that it will take to process either parts of the system, in relation to changing the medications for a patient, would make it very difficult to keep the solution clean and maintainable if I just coded it all directly together (even using separate classes that get called from all these places).

Enter the idea of pub/sub and evented architecture&#8230;

In my .NET days, working with Winforms apps for several years, I fell in love with the event aggregator and command patterns. I even wrote up [several](http://lostechies.com/derickbailey/2009/04/18/decoupling-workflow-and-forms-with-an-application-controller/) [lengthy](http://lostechies.com/derickbailey/2009/12/23/understanding-the-application-controller-through-object-messaging-patterns/) [blog posts](http://lostechies.com/derickbailey/2010/04/15/adding-request-reply-to-the-application-controller/) on them and created [some sample implementations](https://github.com/derickbailey/appcontroller) that I put out on Github. I&#8217;ve used that code base many many times, to reduce the coupling in my .NET apps, with great success. I&#8217;ve also worked a lot with messaging architectures, using pub/sub, point to point messaging, etc. I&#8217;ve written my own service bus for one app. I&#8217;ve used MassTransit in another. I&#8217;ve played around with NService, too. In the end, the event aggregator and command patterns are in-process versions of the various messaging patterns, so the knowledge transfer between all of this made it easy to understand and cross-polinate ideas.

Given my success with these patterns in .NET, I wanted to look at using them in my ruby / rails app. What I want to do is raise a &#8220;MedicationsModified&#8221; event / message, and have an arbitrary (unknown from the source that raises the event / message) set of handler receive the message and process it correctly. This is exactly what pub/sub or the event aggregator should do for me.

I know very little about the pub/sub and messaging options in ruby, though. So I&#8217;ve been asking on twitter and I&#8217;ve been pointed to a number of different options. After some discussion with Jak Charlton, as well, I think the idea of using an EventAggregator may not what I need, either. There aren&#8217;t any real implementations of this around the ruby community, which makes Jak think that it&#8217;s not a solution that fits the ruby / rails problem space. I haven&#8217;t yet decided if I agree with this, but it&#8217;s good advice to take in as I&#8217;m looking for my solution. In either case, the principles of pub/sub to send an event message out to an unknown number of handlers is what I believe my system needs.

So&#8230; what are the pub / sub options that I&#8217;ve found, so far?

 

### The Problem

The majority of the options that I&#8217;ve been pointed at seem to fall into 1 of 3 categories:

  1. far too large and &#8220;scalable&#8221; for my needs, or 
  2. far too small and &#8220;do-it-yourself&#8221;
  3. delayed execution of existing model / methods

For example, Resque seems to be the hotness right now, for large scale background processing. After all, if github is building it, you know it&#8217;s going to be scalable and easy to use. Resque falls squarely in the first category. I don&#8217;t need a scalable redis server with a server farm to handle my needs.

On the opposite end of that spectrum, we have solutions like EventMachine and Cool.io. Both of these tools are super simple to get up and running and provide a nice back-end host to offload a job to. However, neither of them provides any kind of message or event handling system. I would have to either find a message handling system to host inside of EventMachine / Cool.io, or build one myself.

I&#8217;ve also had Observers and Fibers, from ruby 1.9, suggested. While these are both nice options to know about for the problems that they solve, I&#8217;m not sure if they are what I&#8217;m looking for. Observers seem to create a little more coupling between the observing object, and observed object. Fibers offer a nice asynchronous in-process solution, but don&#8217;t really offer any help with messaging / message handling.

Other systems, such as Delayed-Job and Background-Job seem a little more down to earth and more of my scale. However, they are examples of the third category that make me a bit nervous about coupling. For example, delayed job lets you turn any object&#8217;s method call into a background process by calling the object&#8217;s method with a .delay call in front of it: some\_object.delay.some\_method.

I don&#8217;t want my handling of the &#8220;MedicationsModified&#8221; even to be stripped away and boiled down to an implicit method call on the objects that need to be called. That would couple things together more than I want, and create maintenance problems in the future. Even if I created a &#8220;MedicationsModified&#8221; class and had a method on it that would call all the things I need to call, that class would still be coupled to the things that need to be called. Any time I need to change what has to happen when a medication is changed, I would only have to modify this one class, but I would have to deal with the knowledge of all places in the system that need to be notified of what&#8217;s going on.

I also don&#8217;t necessarily need my solution to be asynchronous or out of process. I just need it to be a simple pub/sub message handler &#8211; in or out of process. Though, as Jak pointed out in our conversations, a web server is already an asynchronous / out of process system (with the UI being the browser on the other end of the internet), so I&#8217;m not really opposed to an out of process solution. It just needs to be simple.

 

### The Questions

It&#8217;s obvious that my brain is still wired for the .NET and Winforms paradigms that I spent the last 3 or 4 years working in. I&#8217;m running into some serious mental roadblocks and unable to wrap my head around the available options and solutions for my scenario. So I&#8217;m asking you, dear reader:

  * How do you handle simple pub-sub, evented architecture, message handling in rails apps?
  * What options and suggestions do you have for my scenario and my needs?
  * How have you solved this problem, while keeping the complexity and sheer size of the solution within reason?

Any and all suggestions, gems to look at, links to blog posts, articles and presentations, are greatly appreciated.

 

### Use My Existing Rails Models

One constraint that I haven&#8217;t mentioned yet&#8230; I want to use my existing rails models in the message handlers, so that I don&#8217;t have to duplicate them in whatever the solution ends up being. Tools like DelayedJob do this for me, and I can even make it work with EventMachine (but I&#8217;m not sure of the ramifications of loading up config/environment.rb in my EventMachine server).  I wanted to mention this so that you can keep it in mind when suggesting solutions and answers to my questions.