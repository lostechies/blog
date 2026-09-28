---
wordpress_id: 1045
title: Managing Events As Relationships, Not Just References
date: 2013-02-06T12:00:01+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1045
dsq_thread_id:
  - "1069043023"
categories:
  - Analysis and Design
  - Backbone
  - JavaScript
  - Principles and Patterns
---
In my [Scaling Backbone Apps With Marionette](https://speakerdeck.com/derickbailey/scaling-backbone-dot-js-applications-with-marionette-dot-js) talk, I have some slides that deal with [JavaScript zombies in Backbone apps](https://speakerdeck.com/derickbailey/scaling-backbone-dot-js-applications-with-marionette-dot-js?slide=20). This isn&#8217;t a new subject by any means. It is one that I talk about a lot, and spend a lot of time explaining to others. But there is one aspect of this talk and the related material that I have only recently started using: the idea of managing event handlers as relationship and not simply object references. More importantly, though, correctly modeling the relationship between the observer (event handler) and the subject (event broadcaster) can give us insight in to our code and create a more natural representation of how we think about, understand, and observe the real world.

( **Note**: I&#8217;m going to use Backbone and JavaScript as the examples, but the core ideas for relationship management that I&#8217;m presenting are applicable to most object oriented languages and event systems. )

## The Observer Pattern

Event systems in the object oriented world are almost always based on the classic [Observer Pattern](http://en.wikipedia.org/wiki/Observer_pattern) from the [&#8220;Gang of Four&#8221; design patterns book](http://www.amazon.com/gp/product/0201633612/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0201633612&linkCode=as2&tag=derickbailey-20). If you don&#8217;t own this book, go buy it right now. I&#8217;ll wait for you to come back … Got it ordered? Great.

[According to Wikipedia](http://en.wikipedia.org/wiki/Observer_pattern), the observer pattern &#8220;is a software design pattern in which an object, called the subject, maintains a list of its dependents, called observers, and notifies them automatically of any state changes, usually by calling one of their methods.&#8221;

To put that a little more plainly: something triggers an event and other things listen to and respond to the event. The basic structural set up for this pattern includes three things:

  * Event: the thing that happened; the action or outcome that has already occured
  * Subject: an object that triggers or broadcasts the occurance of an event
  * Observer: an object (or function) that listens for, and responds to an event

Backbone.Events is an implementation of the observer pattern at some level. We could argue about whether or not Backbone implements a &#8220;pure&#8221; observer pattern, but the important point is that this pattern is the basis for what Backbone and most other event systems implement. It informs us of the design and implementation of Backbone.Events and the object references and relationships involved.

But what is an event? What are the &#8220;subjects&#8221; and &#8220;observers&#8221;?

### An Event: Moving A Ball Through A Round Metal Hoop

Think about basketball for a moment. When a player scores, the team&#8217;s points are increased, everyone adjusts their position to start the next play, fans cheer or complain, and the game goes on.

In this case, the &#8220;Subject&#8221; is the player &#8211; the person that scored the points. When the player is able to move the ball through the round metal hoop at the end of the court in an appropriate manner, a &#8220;points scored&#8221; event is triggered. The &#8220;observers&#8221;, then, are comprised of a number of people: the other players, the fans, the score keeper, the ref, and many more people that are paying attention to the game. They go about their business of cheering, updating the scoreboard, and doing anything else that they are responsible for doing in response to the points being scored.

Keep this analogy in mind as I&#8217;ll be coming back around to it in a bit. For now, though, this should give you a good idea of the various players involved in an Observer pattern.

## Backbone.Events And References

When we set up an observer in Backbone, we typically use the `.on` method to tell the Subject about the Observer. In other words, the object that triggers the event will hold a reference to the object or function that handles the event.In the case of an in-line callback function, the reference that we hand to the Subject is a simple function:

<div class="highlight">
  <pre><span class="nx">myObject</span><span class="p">.</span><span class="nx">on</span><span class="p">(</span><span class="s2">"some:event"</span><span class="p">,</span> <span class="kd">function</span><span class="p">(){</span>
  <span class="c1">// do stuff here because the "some:event" event was triggered</span>
<span class="p">});</span>
</pre>
</div>

This is a simple reference, and we have no other direct references to the function. When `myObject` goes out of scope, then, this function reference will be garbage collected.

When we use a method reference (that is, a function attached to another object) as the callback function, though, we are only handing the function reference to the Subject, still.

<div class="highlight">
  <pre><span class="nx">myObject</span><span class="p">.</span><span class="nx">on</span><span class="p">(</span><span class="s2">"some:event"</span><span class="p">,</span> <span class="nx">anotherObject</span><span class="p">.</span><span class="nx">someHandler</span><span class="p">);</span>
</pre>
</div>

In this case, the Subject is only directly handed a reference to the `someHandler` function. This function does not bring along a reference to `anotherObject,` but the someHandler function does not get cleaned up when the &#8220;anotherObject&#8221; goes out of scope. &#8220;myObject&#8221; has a reference to it, so it can&#8217;t be cleaned up. And this, as we know, is one of the most common causes of [zombie objects in JavaScript apps](https://lostechies.com/derickbailey/2011/09/15/zombies-run-managing-page-transitions-in-backbone-apps/). There are simple ways to solve this, though. We just need to remove the observer reference from the Subject when we&#8217;re done:

<div class="highlight">
  <pre><span class="nx">myObject</span><span class="p">.</span><span class="nx">off</span><span class="p">(</span><span class="s2">"some:event"</span><span class="p">,</span> <span class="nx">anotherObject</span><span class="p">.</span><span class="nx">someHandler</span><span class="p">);</span>
</pre>
</div>

This removes the observer reference and allows the objects to be properly garbage collected. It effectively double-taps the zombie before the zombie has a chance to re-animate.

There&#8217;s a problem with this code, though, that has nothing to do with object references. The relationship between the Subject and the Observer is wrong.

## Events And Relationships

When we call the `.on` and `.off` methods of a Backbone object, we are doing more than just setting up object references for an observer pattern implementation. We are setting up relationships and perspectives on those relationships in the mind of the developers reading and writing the code.

It&#8217;s natural for us to think about event relationships in when/then, cause and effect logic. This is what we are taught in early education: &#8220;when this, then that,&#8221; or in this case, &#8220;When this event fires, go do that.&#8221; Statements like this tells us that the action is the primary actor and the reaction is secondary. This is great when looking at cause and effect in natural language, because it&#8217;s true. Without the cause the effect would not be there. That&#8217;s how cause and effect works. But the cause and effect relationship falls apart when looking at events and reactions to events &#8211; both in code and in the real world.

How we see objects and their relationships can make or break the maintainability and flexibility of a design and implementation for a software system. It&#8217;s important to think through the relationships, then, and not just think about raw object references.

## Scoring Points And Notifying Everyone

Think back to the basketball analogy and what happens when a basketbal player scores. What did the player do? How do they react? If it was an amazing shot they may have celebrated. But, chances are they just moved on to the next play.

Now think about what the player didn&#8217;t do. They didn&#8217;t walk around to every other player on the court and tell them that they scored. The didn&#8217;t walk over to the ref and tell him that points were scored. They didn&#8217;t walk over to the score keeper and tell that person that points were scored. They didn&#8217;t go tell &#8230; you get the idea.

The basketball player didn&#8217;t tell anyone about the points being scored, because that is not the responsibility of the player. The ref, the score keeper, the other players, the fans &#8211; everyone involved in this sporting event observed the points being scored and reacted appropriately. The player that scored the points was not responsible for telling all of the observers that the event occured.

Why, then, do we model events in code as if the basketball player, or perhaps the basket itself, is responsible for telling everyone when points are scored? Why do we write code like this?

<div class="highlight">
  <pre><span class="nx">basket</span><span class="p">.</span><span class="nx">on</span><span class="p">(</span><span class="s2">"points:scored"</span><span class="p">,</span> <span class="kd">function</span><span class="p">(</span><span class="nx">team</span><span class="p">,</span> <span class="nx">player</span><span class="p">,</span> <span class="nx">points</span><span class="p">){</span>
  <span class="nx">team</span><span class="p">.</span><span class="nx">updateScore</span><span class="p">(</span><span class="nx">points</span><span class="p">);</span>
  <span class="nx">scoreboard</span><span class="p">.</span><span class="nx">updateScore</span><span class="p">(</span><span class="nx">team</span><span class="p">,</span> <span class="nx">points</span><span class="p">);</span>
  <span class="nx">player</span><span class="p">.</span><span class="nx">updatePointsScored</span><span class="p">(</span><span class="nx">points</span><span class="p">);</span>
  <span class="c1">// etc</span>
<span class="p">})</span>
</pre>
</div>

The answer is object references. The Subject that triggers the event needs references to the Observer objects so that the observers can be notified. Developers typically look at this need for references and design an API around that. The observer pattern pretty much tells us to do that, too. But this relationship is backward and it needs to be fixed if we are going to write maintainable software systems.

## The Relationship Problem: Who Owns It?

In the above basketball example, and in Backbone events in general, it&#8217;s the Subject that owns the reference and therefore, the relationship. By calling `basket.on` we are telling the `basket` object to wait for it&#8217;s own event to be triggered. When the event is triggered, it call the function that was supplied.

It it necessary for the `basket` object to hold a reference to the callback function because of the way object references work. If the Subject (`basket`) does not have a reference to the function that needs to be called&#8230; well&#8230; there&#8217;s nothing to call when the event is triggered.

The real problem, then, is not object references. The real problem is how we create the references and who controls the relationship facilitated by those references.

## Backbone.Events And Relationships

Calling `basket.on("points:scored", function(){...})` clearly sets up a relationship that is owned by the `basket` object. The basket is responsible for maintaining the reference, so it owns the relationship right? If we&#8217;re thinking in terms of references then this makes sense. But if we think in terms of relationships and how a basketball game actually operates, this doesn&#8217;t make any sense. We don&#8217;t want the Subject to own the relationships. We want the Observer to own the relationships.

A typical Backbone.View implementation illustrates why we want the Observer to own the relationship:

<div class="highlight">
  <pre><span class="nx">Backbone</span><span class="p">.</span><span class="nx">View</span><span class="p">.</span><span class="nx">extend</span><span class="p">({</span>

  <span class="nx">initialize</span><span class="o">:</span> <span class="kd">function</span><span class="p">(){</span>
    <span class="k">this</span><span class="p">.</span><span class="nx">model</span><span class="p">.</span><span class="nx">on</span><span class="p">(</span><span class="s2">"change:foo"</span><span class="p">,</span> <span class="k">this</span><span class="p">.</span><span class="nx">doStuff</span><span class="p">,</span> <span class="k">this</span><span class="p">);</span>
  <span class="p">},</span>

  <span class="nx">doStuff</span><span class="o">:</span> <span class="kd">function</span><span class="p">(</span><span class="nx">foo</span><span class="p">){</span>
    <span class="c1">// do stuff in response to "foo" changing</span>
  <span class="p">},</span>

  <span class="nx">remove</span><span class="o">:</span> <span class="kd">function</span><span class="p">(){</span>
    <span class="k">this</span><span class="p">.</span><span class="nx">model</span><span class="p">.</span><span class="nx">off</span><span class="p">(</span><span class="s2">"change:foo"</span><span class="p">,</span> <span class="k">this</span><span class="p">.</span><span class="nx">doStuff</span><span class="p">,</span> <span class="k">this</span><span class="p">);</span>

    <span class="c1">// call the base type's method, since we are overriding it</span>
    <span class="nx">Backbone</span><span class="p">.</span><span class="nx">View</span><span class="p">.</span><span class="nx">prototype</span><span class="p">.</span><span class="nx">remove</span><span class="p">.</span><span class="nx">call</span><span class="p">(</span><span class="k">this</span><span class="p">);</span>
  <span class="p">}</span>

<span class="p">})</span>
</pre>
</div>

A typical Backbone.Model lives much longer than a view that works with it. The model will be displayed, edited and used for other parts of the application many times while a single view instance that works with it is stood up and torn down relatively quickly.

The zombie problem is also illustrated here. In order to prevent this view from becoming a zombie, we have to unbind the event handler that is set up in the initialize function. This is typically done by overriding the `remove` method and calling the necessary `off` event, as shown above.

From a functional perspective, this works perfectly fine. It might be a little annoying to type all of those `off` method calls, but this will clean up the references just fine. It doesn&#8217;t model the relationship correctly, though. It still tells us that the model is in control of the references and relationship. The view has to ask the model to create the reference, and ask it to drop the reference. What we want instead, is a way for our view to say &#8220;I&#8217;m in control of this relationship. When I&#8217;m done, I&#8217;ll sever the relationship. You don&#8217;t have to worry about it, Model.&#8221;

## Inverting The Observer Relationship For Backbone.View

To invert the code structure and begin thinking about relationships, we need to have the view be in control. We need the view to say &#8220;I care about this event, and I will respond to it when it happens&#8221;. Fortunately, Backbone provides the means to do this: the `listenTo` and `stopListening` methods from Backbone.Events.

The view from above can be re-written with `.listenTo` and `.stopListening` instead of `.on` and `.off`, very easily.

<div class="highlight">
  <pre><span class="nx">Backbone</span><span class="p">.</span><span class="nx">View</span><span class="p">.</span><span class="nx">extend</span><span class="p">({</span>

  <span class="nx">initialize</span><span class="o">:</span> <span class="kd">function</span><span class="p">(){</span>
    <span class="k">this</span><span class="p">.</span><span class="nx">listenTo</span><span class="p">(</span><span class="k">this</span><span class="p">.</span><span class="nx">model</span><span class="p">,</span> <span class="s2">"change:foo"</span><span class="p">,</span> <span class="k">this</span><span class="p">.</span><span class="nx">doStuff</span><span class="p">);</span>
  <span class="p">},</span>

  <span class="nx">doStuff</span><span class="o">:</span> <span class="kd">function</span><span class="p">(</span><span class="nx">foo</span><span class="p">){</span>
    <span class="c1">// do stuff in response to "foo" changing</span>
  <span class="p">}</span>

  <span class="c1">// we don't need this. the default `remove` method calls `stopListening` for us</span>
  <span class="c1">// remove: function(){</span>
    <span class="c1">// this.stopListening();</span>
    <span class="c1">// ...</span>
  <span class="c1">//}</span>
<span class="p">})</span>
</pre>
</div>

There are a few things of note, from a code perspective, here:

  1. We are calling the `listenTo` method of the view
  2. We are passing `this.model` as an argument to the `listenTo` method
  3. We are no longer passing `this` as the context variable for the last argument of `listenTo`
  4. We no longer need to override the `remove` method, since the default implementation calls `stopListening` for us

But far more important than the code difference is the shift in perspective. Instead of having code that says &#8220;Hey model, I&#8217;d like to register a callback method with you,&#8221; we now have code that says, &#8220;I, the view, need to know when the model triggers this event and I, the view, will response appropriately.&#8221; We also have have the view saying, &#8220;I, the view, am ending all relationships that I have previously set up.&#8221; It&#8217;s a subtle difference in how the relationship is managed, but it&#8217;s a very important one as it more correctly models the relationships between the Subject and Observer.

Behind the scenes, the model is still being handed a reference to the view using the `on` method. There&#8217;s simply no way around this technical detail. But we can (and should) hide this technical detail behind the veil of abstraction, allowing our code to tell us what relationship matters and who is in control of the references.

## Zombie Killing Is My Business

There&#8217;s another benefit, as well. That one call to `.stopListening()` inside of the `remove` method will sever all relationships that have been set up with the `.listenTo` method of the view. This cleans up all of the references that the model has to the view, preventing zombie views from having a chance to infect our apps.

This little detail alone is worth it&#8217;s 100x its weight in the extra few characters that you have to type when using `.listenTo`.

## No Silver Bullet For Modeling Relationships

It&#8217;s tempting for me to say something like &#8220;stop using .on and .off&#8221; at this point, but that would be a bad idea. I think it would be safe to say that within the context of a Backbone.View, but there are other scenarios where this doesn&#8217;t make sense.

In my post about [modeling explicit workflow in JavaScript apps before](https://lostechies.com/derickbailey/2012/05/10/modeling-explicit-workflow-with-code-in-javascript-and-backbone-apps/), I talk about using a higher level object to coordinate the workflow of an application. This is a scenario where it might not make sense to use `.listenTo` and `.stopListening`.

<div class="highlight">
  <pre><span class="nx">MyApp</span><span class="p">.</span><span class="nx">someWorkflow</span> <span class="o">=</span> <span class="p">{</span>

  <span class="nx">show</span><span class="o">:</span> <span class="kd">function</span><span class="p">(){</span>
    <span class="kd">var</span> <span class="nx">layout</span> <span class="o">=</span> <span class="k">new</span> <span class="nx">MyApp</span><span class="p">.</span><span class="nx">LayoutView</span><span class="p">();</span>

    <span class="nx">layout</span><span class="p">.</span><span class="nx">on</span><span class="p">(</span><span class="s2">"render"</span><span class="p">,</span> <span class="k">this</span><span class="p">.</span><span class="nx">showDetail</span><span class="p">,</span> <span class="k">this</span><span class="p">);</span>

    <span class="k">this</span><span class="p">.</span><span class="nx">showView</span><span class="p">(</span><span class="nx">layout</span><span class="p">);</span>
  <span class="p">},</span>

  <span class="c1">// ... showDetail, showView, etc</span>
<span class="p">}</span>
</pre>
</div>

In this code, the layout will likely be closed relatively quickly, and the `someWorkflow` object will likely remain alive forever, as it has been attached to the global app object. This would be a bad place to tie the event reference cleanup to the higher level object. It would never get cleaned up. Instead, you would need to tie the lifecycle of the event handlers to the layout. The above code would be correct in using `.on` to set up the event, then The layout being closed will remove the reference to the event handler and things will be cleaned up nicely.

There are likely other scenarios where using `.on` and/or `.off` would make more sense for the relationship management and reference management, still. Instead of blindly applying a pattern for handling zombies and relationship management, we need to understand the actual relationship between the objects in question.

## Thinking In, And Modeling Relationships vs References

When we start working with relationships instead of just references, our code becomes easier to understand. We can model and code application and system designs that better express the way we think and the way we understand relationships in the real world. Under the hood, we still have to deal with references, but that doesn&#8217;t mean our API has to expose these raw object references as the relationship we are creating.

More than an API difference, though, the idea of thinking about relationships instead of just references is just that &#8211; an idea. It&#8217;s a shift in our mindset and in how we look at the code we are writing. It&#8217;s a change in perspective to give us better insight in to how the things we are modelling actually interact and relate to each other. It informs our system design, our API implementation, how we look for and create abstractions, and how we organize our system in to smaller sub-sets that can be composed in to the larger whole.