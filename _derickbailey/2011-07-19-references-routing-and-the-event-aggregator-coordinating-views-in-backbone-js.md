---
id: 472
title: 'References, Routing, And The Event Aggregator: Coordinating Views In Backbone.js'
date: 2011-07-19T09:01:49+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=472
dsq_thread_id:
  - "362520369"
categories:
  - Backbone
  - Design Patterns
  - JavaScript
  - Model-View-Controller
  - Principles and Patterns
---
I recently found myself needing to facilitate communication between two backbone views. The first view is a medication &#8211; one that is currently being taken by a particular patient. The second view is the add/edit view that allows the patient to either add new medications or edit existing ones. When the edit icon is clicked for an existing medication, the edit form should be populated and the user should be able to edit the medication.

Here&#8217;s what the screen looks like after I click on the edit icon (the pencil):

<img title="Screen shot 2011-07-19 at 9.02.38 AM.png" src="http://lostechies.com/derickbailey/files/2011/07/Screen-shot-2011-07-19-at-9.02.38-AM.png" border="0" alt="Screen shot 2011 07 19 at 9 02 38 AM" width="600" height="498" />

## <span style="font-weight: normal; font-size: medium;">There are a number of ways to make this work &#8211; the most basic of which is to have the views reference each other so that they can either call methods on each other or raise events.</span>

### References

I&#8217;ve done this a number of times and it works well.

[gist id=1092444 file=1-referencing.js]

In this simple example, I have an event setup that listens to the edit icon click. When it&#8217;s clicked, I instantiate a new add/edit view with the model from the current medication display view. I then render it, and we&#8217;re on our way &#8211; the add/edit view will display the correct model and life is good.

In some cases, though, this isn&#8217;t really an option &#8211; or, it may be an option that would cause a little extra code and work to make sure it works correctly. The screen shot above is one of those cases. Both the &#8220;Add Medication&#8221; button and the add/edit form are part of the same view. I did this because it did not seem necessary to have a view just for the &#8220;Add Medication&#8221; button when something as simple as a jQuery click event would suffice. Rather than code the jQuery on it&#8217;s own, though, I decided to put the &#8220;Add Medication&#8221; button into my add/edit view. It makes sense to me &#8211; the button allows you to add a new medication, so it should be part of the add/edit view.

Because of the choice I made, though, having the edit button for a medication instantiate a new add/edit form was not an option for me. I could have the medication view reference the existing instance of the add/edit view, though.

[gist id=1092444 file=2-reference-instance.js]

This also works, giving me the functionality i need with one instance of the add/edit view. Not being satisfied with what works, though, I wanted to explore my other options to see what else would work. Specifically, I wanted to see if I could completely decouple these two views and still provide the functionality that I needed.

### Routing

My next thought was to take advantage of the routing in backbone. I thought I could have the edit button changed from a clickable button to a simple <a href=&#8221;#edit/id&#8221;> link. I could then have the router pick the correct model from the collection and pass it to the add/edit view.

[gist id=1092444 file=3-routing.js]

Once again, this would work perfectly fine. The router would pick up the change to the #hash url, use the id passed into it as the parameter to load the medication, and then send it over to the add/edit view.

However, I don&#8217;t need all of the functionality of the router in this case. I don&#8217;t need the browser back / forward button. I don&#8217;t need a url change to create some uniquely identifiable url for a user to hit directly, and I don&#8217;t need a router for anything else on this page. Since all of the medications are listed on the page and the add/edit view is on the page with them, there&#8217;s no need for me to route things around. Sure it works, but it comes with more functionality than I wanted.

### The Event Aggregator

Digging back into my Winforms development days of the last 4 years, I decided to go after a tried and true pattern that I&#8217;ve used more times than I can remember: the event aggregator. If you&#8217;re not familiar with event aggregators, here&#8217;s a handful of links that talk about them in-depth including my own blog post posts and sample code for Winforms (C#/.NET).

  * [Martin Fowler: Event Aggregator](http://martinfowler.com/eaaDev/EventAggregator.html)
  * [Jeremy Miller: Braindump On The Event Aggregator](http://codebetter.com/jeremymiller/2009/07/22/braindump-on-the-event-aggregator-pattern/)
  * [Jeremy Miller: &#8220;Latching&#8221; an Event Aggregator Subscriber](http://codebetter.com/jeremymiller/2009/08/01/latching-an-event-aggregator-subscriber/)
  * [Me: Understanding The Application Controller Through Object Messaging Patterns](http://lostechies.com/derickbailey/2009/12/23/understanding-the-application-controller-through-object-messaging-patterns/)
  * [Me: An example App Controller Implementation (code via Github)](https://github.com/derickbailey/appcontroller)

The gist of the event aggregator is that you have a central object that manages the raising of events and the subscribers for those events. In terms of messaging patterns, the event aggregator is an in-memory, object based publish-subscribe model. It allows you have to have disparate parts of your system react to the events of other parts of the system, without having them directly coupled. I use event aggregators in my winforms apps to communication between various parts of my views and and other parts of my apps that are already up and running and need to be notified of changes that have happened.

Given my experience with event aggregators, it felt like a perfect fit for my desire to decouple the views in my medication screen. All I needed was an event aggregation object &#8211; one that could have many event subscribers and /  or publishers. Fortunately, backbone provides just the thing I need with it&#8217;s event system. All I had to do was create an object that could be shared between my views.

Here&#8217;s the entire code listing for my event aggregator object, built with [backbone&#8217;s event system](http://documentcloud.github.com/backbone/#Events):

[gist id=1092444 file=4-vent.js]

That&#8217;s it! No, really. That&#8217;s all I needed, because backbone already handles events very well. To make use of this, though, I need each of the event publishers and / or subscribers to have a reference to my &#8216;vent&#8217; object. Once they have a reference, they can either subscribe or publish events as needed.

[gist id=1092444 file=5-event-aggregation.js]

When the edit icon is clicked, the the vent is triggered with an &#8220;editMedication&#8221; event, passing the model that needs to be edited directly to any subscribers. The add/edit view has subscribed to the &#8220;editMedication&#8221; event and receives the medication directly as a parameter. Note that I also used [the underscore.js bindAll method](http://lostechies.com/derickbailey/2011/06/15/solving-backbones-this-model-view-problem-with-underscore-js/) to ensure that the editMedication method is executed in the correct context. If you omit this line, the editMedication method will execute with &#8216;this&#8217; being the event aggregator, not the view.

Now that&#8217;s some code that I can really fall in love with! My application functions perfectly &#8211; I can click the edit icon and have the correct medication populated into the add/edit view, for editing. Yet my views know nothing about each other. I have completely decoupled them from each other. The only thing the views need to know about is the event aggregator object.

### Decoupling The Views

With the event aggregator in place, my views are decoupled from each other. This means that they can change independently of each other. In fact, the MedicationView can go away entirely if I want it to.

I can rename this class, change it&#8217;s implementation, delete it and put something else in place or whatever else I want to do. As long as something in my backbone code triggers the &#8220;editMedication&#8221; event and provides and provides a model as an argument for that event, my add/edit view will respond correctly.

Conversely, I can also modify or remove the add/edit view as needed. As long as some part of my backbone code binds to the &#8220;editMedication&#8221; event from the event aggregator, and expects to receive a model as the argument for the event handler method, things will continue to work fine.

This set up also lets me have multiple parts of my app listen to the event and respond accordingly. I could easy add other views or other other javascript objects that bind to the &#8220;editMedication&#8221; event. Each of these binding objects would then be able to respond to the edit click and manipulate the medication model in any way necessary &#8211; and all without having to couple any additional views together.

### I&#8217;ll Take The Event Aggregator, Thanks

The event aggregator is a powerful little pattern. I&#8217;m glad I was able to lean on my prior experience with this pattern and introduce it into my backbone code. It made my code significantly easier to work with. Bringing along a simple implementation of a pattern like the event aggregator can help you keep your code clean and maintainable.

The other options I&#8217;ve shown do work, of course. There is nothing technically wrong with writing backbone code like that. However, I don&#8217;t like having my views coupled together like that. It tends to create a mess when you have multiple nested views and that all need to coordinate with each other.