---
wordpress_id: 1075
title: 'Event Aggregator And/Or/vs Mediator: A Tale Of Two Patterns'
date: 2013-03-18T09:00:14+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1075
dsq_thread_id:
  - "1146857935"
categories:
  - AntiPatterns
  - Backbone
  - Design Patterns
  - JavaScript
  - JQuery
  - Principles and Patterns
  - Workflow
---
Design patterns often differ only in semantics and intent. That is, the language used to describe the pattern is what sets it apart, more than an implementation of that specific pattern. It often comes down to squares vs rectangles vs polygons. You can create the same end result with all three, given the constraints of a square are still met &#8211; or you can use polygons to create an infinitely larger and more complex set of things.

When it comes to the [Mediator](http://en.wikipedia.org/wiki/Mediator_pattern) and [Event Aggregator](http://martinfowler.com/eaaDev/EventAggregator.html) patterns, there are some times where it may look like the patterns are interchangeable due to implementation similarities. However, the semantics and intent of these patterns are very different. And even if the implementations both use some of the same core constructs, I believe there is a distinct difference between them. I also believe they should not be interchanged or confused in communication because of the differences.

## It&#8217;s All About Logic

The TL;DR version of this article is this: where does the logic live? An event aggregator has no logic, other than forwarding events from a publisher to a subscriber. A mediator, on the other hand, encapsulates the potentially complex logic of coordinating multiple other objects and/or services, to accomplish a goal. A mediator contains real application / business / workflow / process logic.

This is the line I&#8217;m drawing in the ever-shifting sands of implementation details and fuzzy heuristics.

## Event Aggregator

The core idea of the <a>Event Aggregator</a>, accoring to Martin Fowler, is to channel multiple event sources through a single object so that other objects needing to subscribe to the events don&#8217;t need to know about every event source.

### Backbone&#8217;s Event Aggregator

The easiest event aggregator to show is that of [Backbone.js](http://backbonejs.org) &#8211; it&#8217;s built in to the `Backbone` object directly.

<div class="highlight">
  <pre><span class="kd">var</span> <span class="nx">View1</span> <span class="o">=</span> <span class="nx">Backbone</span><span class="p">.</span><span class="nx">View</span><span class="p">.</span><span class="nx">extend</span><span class="p">({</span>
  <span class="c1">// ...</span>

  <span class="nx">events</span><span class="o">:</span> <span class="p">{</span>
    <span class="s2">"click .foo"</span><span class="o">:</span> <span class="s2">"doIt"</span>
  <span class="p">},</span>

  <span class="nx">doIt</span><span class="o">:</span> <span class="kd">function</span><span class="p">(){</span>
    <span class="c1">// trigger an event through the event aggregator</span>
    <span class="nx">Backbone</span><span class="p">.</span><span class="nx">trigger</span><span class="p">(</span><span class="s2">"some:event"</span><span class="p">);</span>
  <span class="p">}</span>
<span class="p">});</span>

<span class="kd">var</span> <span class="nx">View2</span> <span class="o">=</span> <span class="nx">Backbone</span><span class="p">.</span><span class="nx">View</span><span class="p">.</span><span class="nx">extend</span><span class="p">({</span>
  <span class="c1">// ...</span>

  <span class="nx">initialize</span><span class="o">:</span> <span class="kd">function</span><span class="p">(){</span>
    <span class="c1">// subscribe to the event aggregator's event</span>
    <span class="nx">Backbone</span><span class="p">.</span><span class="nx">on</span><span class="p">(</span><span class="s2">"some:event"</span><span class="p">,</span> <span class="k">this</span><span class="p">.</span><span class="nx">doStuff</span><span class="p">,</span> <span class="k">this</span><span class="p">);</span>
  <span class="p">},</span>

  <span class="nx">doStuff</span><span class="o">:</span> <span class="kd">function</span><span class="p">(){</span>
    <span class="c1">// ...</span>
  <span class="p">}</span>
<span class="p">})</span>
</pre>
</div>

In this example, the first view is triggering an event when a DOM element is clicked. The event is triggered through Backbone&#8217;s built-in event aggregator &#8211; the `Backbone` object. Of course, [it&#8217;s trivial to create your own event aggregator in Backbone](http://lostechies.com/derickbailey/2011/07/19/references-routing-and-the-event-aggregator-coordinating-views-in-backbone-js/), and there are some [key things that we need to keep in mind when using an event aggregator](http://lostechies.com/derickbailey/2012/04/03/revisiting-the-backbone-event-aggregator-lessons-learned/), to keep our code simple.

### jQuery&#8217;s Event Aggregator

Did you know that jQuery has a built-in event aggregator? They don&#8217;t call it this, but it&#8217;s in there and it&#8217;s scoped to DOM events. It also happens to look like Backbone&#8217;s event aggregator:

<div class="highlight">
  <pre><span class="nx">$</span><span class="p">(</span><span class="s2">"#mainArticle"</span><span class="p">).</span><span class="nx">on</span><span class="p">(</span><span class="s2">"click"</span><span class="p">,</span> <span class="kd">function</span><span class="p">(</span><span class="nx">e</span><span class="p">){</span>

  <span class="c1">// handle the event that any element underneath of our #mainArticle element</span>

<span class="p">});</span>
</pre>
</div>

This code sets up an event handler function that waits for an unknown number of event sources to trigger a &#8220;click&#8221; event, and it allows any number of listeners to attach to the events of those event publishers. jQuery just happens to scope this event aggregator to the DOM.

## Mediator

A [Mediator](http://en.wikipedia.org/wiki/Mediator_pattern) is an object that coordinates interactions (logic and behavior) between multiple objects. It makes decisions on when to call which objects, based on the actions (or in-action) of other objects and input.

### A Mediator For Backbone

Backbone doesn&#8217;t have the idea of a mediator built in to it like a lot of other MV* frameworks do. But that doesn&#8217;t mean you can&#8217;t write one in 1 line of code:

`var mediator = {};`

Yes, of course this is just an object literal in JavaScript. Once again, we&#8217;re talking about semantics here. The purpose of the mediator is to [control the workflow between objects](http://lostechies.com/derickbailey/2012/05/10/modeling-explicit-workflow-with-code-in-javascript-and-backbone-apps/) and we really don&#8217;t need anything more than an object literal to do this.

<div class="highlight">
  <pre><span class="kd">var</span> <span class="nx">orgChart</span> <span class="o">=</span> <span class="p">{</span>

  <span class="nx">addNewEmployee</span><span class="o">:</span> <span class="kd">function</span><span class="p">(){</span>

    <span class="c1">// getEmployeeDetail provides a view that users interact with</span>
    <span class="kd">var</span> <span class="nx">employeeDetail</span> <span class="o">=</span> <span class="k">this</span><span class="p">.</span><span class="nx">getEmployeeDetail</span><span class="p">();</span>

    <span class="c1">// when the employee detail is complete, the mediator (the 'orgchart' object)</span>
    <span class="c1">// decides what should happen next</span>
    <span class="nx">employeeDetail</span><span class="p">.</span><span class="nx">on</span><span class="p">(</span><span class="s2">"complete"</span><span class="p">,</span> <span class="kd">function</span><span class="p">(</span><span class="nx">employee</span><span class="p">){</span>

      <span class="c1">// set up additional objects that have additional events, which are used</span>
      <span class="c1">// by the mediator to do additional things</span>
      <span class="kd">var</span> <span class="nx">managerSelector</span> <span class="o">=</span> <span class="k">this</span><span class="p">.</span><span class="nx">selectManager</span><span class="p">(</span><span class="nx">employee</span><span class="p">);</span>
      <span class="nx">managerSelector</span><span class="p">.</span><span class="nx">on</span><span class="p">(</span><span class="s2">"save"</span><span class="p">,</span> <span class="kd">function</span><span class="p">(</span><span class="nx">employee</span><span class="p">){</span>
        <span class="nx">employee</span><span class="p">.</span><span class="nx">save</span><span class="p">();</span>
      <span class="p">});</span>

    <span class="p">});</span>
  <span class="p">},</span>

  <span class="c1">// ...</span>
<span class="p">}</span>
</pre>
</div>

This example shows a very basic implementation of a mediator object with Backbone based objects that can trigger and subscribe to events. I&#8217;ve often referred to this type of object as a &#8220;workflow&#8221; object in the past, but the truth is that it is a mediator. It is an object that handles the workflow between many other objects, aggregating the responsibility of that workflow knowledge in to a single object. The result is workflow that is easier to understand and maintain.

## Similarities And Differences

There are, without a doubt, similarities between the event aggregator and mediator examples that I&#8217;ve shown here. The similarities boil down to two primary items: events and third-party objects. These differences are superficial at best, though. When we dig in to the intent of the pattern and see that the implementations can be dramatically different, the nature of the patterns become more apparent.

### Events

Both the event aggregator and mediator use events, in the above examples. An event aggregator obviously deals with events &#8211; it&#8217;s in the name after all. The mediator only uses events because it makes life easy when dealing with Backbone, though. There is nothing that says a mediator must be built with events. You can build a mediator with callback methods, by handing the mediator reference to the child object, or by any of a number of other means.

The difference, then, is why these two patterns are both using events. The event aggregator, as a pattern, is designed to deal with events. The mediator, though, only uses them because it&#8217;s convenient.

### Third-Party Objects

Both the event aggregator and mediator, by design, use a third-party object to facilitate things. The event aggregator itself is a third-party to the event publisher and the event subscriber. It acts as a central hub for events to pass through. The mediator is also a thirdy party to other objects, though. So where is the difference? Why don&#8217;t we call an event aggregator a mediator? The answer largely comes down to where the application logic and workflow is coded.

In the case of an event aggregator, the third party object is there only to facilitate the pass-through of events from an unknown number of sources to an unknown number of handlers. All workflow and business logic that needs to be kicked off is put directly in to the the object that triggers the events and the objects that handle the events.

In the case of the mediator, though, the business logic and workflow is aggregated in to the mediator itself. The mediator decides when an object should have it&#8217;s methods called and attributes updated based on factors that the mediator knows about. It encapsulates the workflow and process, coordinating multiple objects to produce the desired system behaviour. The individual objects involved in this workflow each know how to perform their own task. But it&#8217;s the mediator that tells the objects when to perform the tasks by making decisions at a higher level than the individual objects.

An event aggregator facilitates a &#8220;fire and forget&#8221; model of communication. The object triggering the event doesn&#8217;t care if there are any subscribers. It just fires the event and moves on. A mediator, though, might use events to make decisions, but it is definitely not &#8220;fire and forget&#8221;. A mediator pays attention to a known set of input or activities so that it can facilitate and coordinate additional behavior with a known set of actors (objects).

## Relationships: When To Use Which

Understanding the similarities and differences between an event aggregator and mediator is important for semantic reasons. It&#8217;s equally as important to understand when to use which pattern, though. The basic semantics and intent of the patterns does inform the question of when, but actual experience in using the patterns will help you understand the more subtle points and nuanced decisions that have to be made.

### Event Aggregator Use

In general, an event aggregator is uses when you either have too many objects to listen to directly, or you have objects that are unrelated entirely.

When two objects have a direct relationship already &#8211; say, a parent view and child view &#8211; then there might be little benefit in using an event aggregator. Have the child view trigger an event and the parent view can handle the event. This is most commonly seen in Backbone&#8217;s Collection and Model, where all Model events are bubbled up to and through it&#8217;s parent Collection. A Collection often uses model events to modify the state of itself or other models. Handling &#8220;selected&#8221; items in a collection is a good example of this.

jQuery&#8217;s [on](http://api.jquery.com/on/) method as an event aggregator is a great example of too many objects to listen to. If you have 10, 20 or 200 DOM elements that can trigger a &#8220;click&#8221; event, it might be a bad idea to set up a listener on all of them individually. This could quickly deteriorate performance of the application and user experience. Instead, using jQuery&#8217;s `on` method allows us to aggregate all of the events and reduce the overhead of 10, 20, or 200 event handlers down to 1.

Indirect relationships are also a great time to use event aggregators. In Backbone applications, it is very common to have multiple view objects that need to communicate, but [have no direct relationship](http://lostechies.com/derickbailey/2011/07/19/references-routing-and-the-event-aggregator-coordinating-views-in-backbone-js/). For example, a menu system might have a view that handles the menu item clicks. But we don&#8217;t want the menu to be direcly tied to the content views that show all of the details and information when a menu item is clicked. Having the content and menu coupled together would make the code very difficult to maintain, in the long run. Instead, we can use an event aggregator to trigger &#8220;menu:click:foo&#8221; events, and have a &#8220;foo&#8221; object handle the click event to show it&#8217;s content on the screen.

### Mediator Use

A mediator is best applied when two or more objects have an indirect working relationship, and business logic or workflow needs to dictate the interactions and coordination of these objects.

[A wizard interface is a good example of this](http://lostechies.com/derickbailey/2012/05/10/modeling-explicit-workflow-with-code-in-javascript-and-backbone-apps/), as shown with the &#8220;orgChart&#8221; example, above. There are multiple views that facilitate the entire workflow of the wizard. Rather than tightly coupling the view together by having them reference each other directly, we can decouple them and more explicitly model the workflow between them by introducing a mediator.

The mediator extracts the workflow from the implementation details and creates a more natural abstraction at a higher level, showing us at a much faster glance what that workflow is. We no longer have to dig in to the details of each view in the workflow, to see what the workflow actually is.

## Event Aggregator And Mediator Together

The crux of the difference between an event aggregator and a mediator, and why these pattern names should not be interchanged with each other, is illustrated best by showing how they can be used together. The menu example for an event aggregator is the perfect place to introduce a mediator as well.

Clicking a menu item may trigger a series of changes throughout an application. Some of these changes will be independent of others, and using an event aggregator for this makes sense. Some of these changes may be internally related to each other, though, and may use a mediator to enact those changes. A mediator, then, could be set up to listen to the event aggregator. It could run it&#8217;s logic and process to facilitate and coordinate many objects that are related to each other, but unrelated to the original event source.

<div class="highlight">
  <pre><span class="kd">var</span> <span class="nx">MenuItem</span> <span class="o">=</span> <span class="nx">Backbone</span><span class="p">.</span><span class="nx">View</span><span class="p">.</span><span class="nx">extend</span><span class="p">({</span>

  <span class="nx">events</span><span class="o">:</span> <span class="p">{</span>
    <span class="s2">"click .thatThing"</span><span class="o">:</span> <span class="s2">"clickedIt"</span>
  <span class="p">},</span>

  <span class="nx">clickedIt</span><span class="o">:</span> <span class="kd">function</span><span class="p">(</span><span class="nx">e</span><span class="p">){</span>
    <span class="nx">e</span><span class="p">.</span><span class="nx">preventDefault</span><span class="p">();</span>

    <span class="c1">// assume this triggers "menu:click:foo"</span>
    <span class="nx">Backbone</span><span class="p">.</span><span class="nx">trigger</span><span class="p">(</span><span class="s2">"menu:click:"</span> <span class="o">+</span> <span class="k">this</span><span class="p">.</span><span class="nx">model</span><span class="p">.</span><span class="nx">get</span><span class="p">(</span><span class="s2">"name"</span><span class="p">));</span>
  <span class="p">}</span>

<span class="p">});</span>

<span class="c1">// ... somewhere else in the app</span>

<span class="kd">var</span> <span class="nx">MyWorkflow</span> <span class="o">=</span> <span class="kd">function</span><span class="p">(){</span>
  <span class="nx">Backbone</span><span class="p">.</span><span class="nx">on</span><span class="p">(</span><span class="s2">"menu:click:foo"</span><span class="p">,</span> <span class="k">this</span><span class="p">.</span><span class="nx">doStuff</span><span class="p">,</span> <span class="k">this</span><span class="p">);</span>
<span class="p">};</span>

<span class="nx">MyWorkflow</span><span class="p">.</span><span class="nx">prototype</span><span class="p">.</span><span class="nx">doStuff</span> <span class="o">=</span> <span class="kd">function</span><span class="p">(){</span>
  <span class="c1">// instantiate multiple objects here.</span>
  <span class="c1">// set up event handlers for those objects.</span>
  <span class="c1">// coordinate all of the objects in to a meaninful workflow.</span>
<span class="p">};</span>
</pre>
</div>

In this example, when the `MenuItem` with the right model is clicked, the &#8220;menu:click:foo&#8221; event will be triggered. An instance of the &#8220;MyWorkflow&#8221; object, assuming one is already instantiated, will handle this specific event and will coordinate all of the objects that it knows about, to create the desired user experience and workflow.

An event aggregator and a mediator have been combined to create a much more meaningful experience in both the code and the application itself. We now have a clean separation between the menu and the workflow through an event aggregator. And we are still keeping the workflow itself clean and maintainable through the use of a mediator.

## Pattern Language: Semantics

There is one overriding point to make in all of this discussion: semantics. Communicating intent and semantics through the use of named patterns is only viable and only valid when all parties in a communication medium understand the language in the same way.

If I say &#8220;apple&#8221;, what am I talking about? Am I talking about a fruit? Or am I talking about a technology and consumer products company? As [Sharon Cichelli](http://lostechies.com/sharoncichelli/) says: &#8220;semantics will continue to be important, until we learn how to communicate in something other than language&#8221;.