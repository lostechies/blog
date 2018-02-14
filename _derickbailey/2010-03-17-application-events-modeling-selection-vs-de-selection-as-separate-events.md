---
wordpress_id: 116
title: 'Application Events: Modeling Selection vs De-Selection as Separate Events?'
date: 2010-03-17T14:08:12+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/03/17/application-events-modeling-selection-vs-de-selection-as-separate-events.aspx
dsq_thread_id:
  - "264729660"
categories:
  - Analysis and Design
  - AppController
  - Craftsmanship
  - Messaging
  - Model-View-Presenter
redirect_from: "/blogs/derickbailey/archive/2010/03/17/application-events-modeling-selection-vs-de-selection-as-separate-events.aspx/"
---
I’m using my [Event Aggregator](http://www.lostechies.com/blogs/derickbailey/archive/2009/12/22/understanding-the-application-controller-through-object-messaging-patterns.aspx) in my current project to manage communication between a custom control and it’s parent form. This is the same control I talked about in my [CQRS Performance Engineering](http://www.lostechies.com/blogs/derickbailey/archive/2010/03/08/cqrs-performance-engineering-read-vs-read-write-models.aspx) post. It has several drop down lists on it, and each one is progressively filled in based on the value selected in the previous one. 

&#160;

### Selection

When the user has selected an item from the final drop list (a “product code”), the presenter raises an event through the event aggregator, the parent form receives that event and it uses the information to display the selected item, etc.

&#160;<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_3939FFDD.png" width="520" height="350" />

&#160;

### De-Selection

On the flip side of this, if a user changes their selection on any of the previous drop down lists, the control needs to clear the current product code selection and notify the parent form that the selection has been cleared. 

 <img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_143C3F64.png" width="547" height="350" />

I’m currently handling the product code de-selection through the same event as the actual product code selection, but I’m passing a null value for the data inside of the event. The parent form checks for null and if it finds null, it knows to clear the currently selected product code and wait for a new one.

&#160;

### The Problem And Possible Solutions

I hate using null like this. It gives me hives and makes me punch my computer when I write code like this. 🙂 

Using a null to model a specific event or variation of an event is a poor choice for determining what behavior and functionality I want, because it is not explicit. The developer that is writing code to handle the product code selection event has to know to check for null and has to know that null means de-select or no selection, and handle it appropriately.

I have two thoughts on how to solve this at the moment:

  1. add some sort of status to the event to tell me if it’s a selection or de-selection or whatever else
  2. model the de-selection as it’s own event

Option #1 would require me to check the status of the event object, which is basically what I’m doing now – only it would be a little easier to know what to do because the status would be more explicitly stated. This is a simple option and would be easy to implement, but I tend to think it’s not the right option. 

I’m inclined to say #2 is the right thing to do because it would model two different actions as two different events. Selection and De-selection are not the same thing in my mind. They cause two very distinctly different, but related, sets of behavior in the parent form. It also seems that it would add a little more overhead to the client that needs to know about the events. I’ll have to subscribe to two events now. But that cost seems fair compared to the current implementation and compared to option #1 since I am gaining a better model for the process in question.

&#160;

### What Would You Do?

With all that being said, I wanted to toss this out to the world and ask what you would do. Would you leave as a null value in the event data? Would you go with a status on the event data? Would you model is as a separate event? Or would you do something else, entirely?