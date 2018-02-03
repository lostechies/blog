---
wordpress_id: 1009
title: 'JavaScript Mixins: Beyond Simple Object Extension'
date: 2012-10-07T07:02:29+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1009
dsq_thread_id:
  - "874597477"
categories:
  - ECMAScript
  - JavaScript
  - Marionette
  - Principles and Patterns
  - Underscore
---
Mixins are generally easy in JavaScript, though they are semantically different than [what Ruby calls a Mixin](http://www.ruby-doc.org/docs/ProgrammingRuby/html/tut_modules.html) which are facilitated through inheritance behind the scenes. If you need a good place to start to understand how to build mixins with JavaScript, Chris Missal has been writing up a series on different ways of [extending objects in JavaScript](http://lostechies.com/chrismissal/2012/09/27/extending-objects-with-javascript/). I highly recommend reading his series. It&#8217;s full of great tips. 

## Object Extension Is A Poor Man&#8217;s Mixin

I love the &#8220;extend&#8221; methods of [jQuery](http://api.jquery.com/jQuery.extend/) and [Underscore](http://underscorejs.org/#extend). I use them a lot. They&#8217;re powerful and simple and make it easy to transfer data and behavior from one object to another &#8211; the essence of a mixin. But in spite of my love of underscore.js and jQuery&#8217;s &#8220;extend&#8221; methods, there&#8217;s a problem with them in that they apply every attribute from one or more source objects to a target objects. 

You can see the effect of this in [Chris&#8217; underscore example](http://lostechies.com/chrismissal/2012/10/05/extending-objects-in-underscore/):

[gist id=3797198]

In this example, the first object contains a key named &#8220;values&#8221; and the third object also contains a key named &#8220;values&#8221;. When the extend method is called, the last one in wins. This means that the &#8220;values&#8221; from the third object end up being the values on the final target object.

So, what happens if we want to mix two behavioral sets in to one target object, but both of those behavior sets use the same underlying &#8220;values&#8221;, or &#8220;config&#8221;, or &#8220;bindings&#8221; (as reported in [this Marionette issue](https://github.com/marionettejs/backbone.marionette/issues/269))? One or both of them will break, and that&#8217;s definitely not a good thing.

## A Problem Of Context

The good news is there&#8217;s an easy way to solve the mixin problem with JavaScript: only copy the methods you need from the behavior set in to the target.

That is, if the object you want to mix in to another has a method called &#8220;doSomething&#8221;, you shouldn&#8217;t be forced to copy the &#8220;config&#8221; and &#8220;_whatever&#8221; and &#8220;foo&#8221; and all the other methods and attributes off this object just to get access to the &#8220;doSomething&#8221; method. Instead, you should only have to copy the &#8220;doSomething&#8221; method from the behavior source to your target.

[gist id=3847156 file=1.js]

But this poses it&#8217;s own challenge: the source of the behavior likely calls &#8220;this.config&#8221; and &#8220;this._whatever()&#8221; and other context-based methods and attributes to do it&#8217;s work. Simply copying the &#8220;doSomething&#8221; function from one object to another won&#8217;t work because the context of the function will change and the support methods / data won&#8217;t be found.

[Note: For more detail on context and how it changes, check out my [JavaScript Context screencast](http://www.watchmecode.net/javascript-context).]

## Solving The Mixin Problem

To fix the mixin problem then, we need to do two things: 

  1. Only copy the methods we need to the target
  2. Ensure the copied methods retain their original context when executing

This is easier than it sounds. We&#8217;ve already seen how requirement #1 can be solved, and requirement #2 can be handled in a number of ways, including the raw [ECMAScript 5 &#8220;bind&#8221;](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Function/bind) method, the use of [Underscore&#8217;s &#8220;bind&#8221;](http://underscorejs.org/#bind) method, writing our own, or by using one of a number of other shims and plugins.

The way to facilitate a mixin from one object to another, then, looks something like this:

[gist id=3847156 file=2.js]

In this example, both the source object and the target object have a &#8220;config&#8221; attribute. Each object needs to use that config attribute to store and retrieve certain bits of data without clobbering each the other one, but I still want the &#8220;baz&#8221; function to be available directly on the &#8220;foo&#8221; object. To make this all work, I assign a bound version of the &#8220;baz&#8221; function to foo where the binding is set to to the bar object. That way whenever the baz function is called from foo, it will always run in the context of the original source &#8211; bar. 

## A Real Example

Ok, enough &#8220;foo, bar, baz&#8221; nonsense. Let&#8217;s look at a real example of where I&#8217;m doing this: Marionette&#8217;s use of Backbone.EventBinder. I want to bring the &#8220;bindTo&#8221;, &#8220;unbindFrom&#8221; and &#8220;unbindAll&#8221; methods from the EventBinder in to Marionette&#8217;s Application object, as one example. To do this while allowing the EventBinder to manage it&#8217;s own internal state and implementation details, I use the above technique of assigning the methods as bound functions:

[gist id=3847156 file=3.js]

Now when I call any of those three methods from my application instance, they still run in the context of my eventBinder object instance and they can access all of their internal state, configuration and behavior. But at the same time, I can worry less about whether or not the implementation details of the EventBinder are going to clobber the implementation details of the Application object. Since I&#8217;m being very explicit about which methods and attributes are brought over from the EventBinder, I can spend the small amount of cognitive energy that I need to determine whether or not the method I&#8217;m creating on the Application instance already exists. I don&#8217;t have to worry about the internal details like &#8220;_eventBindings&#8221; and other bits because they are not going to be copied over.

## Simplifying Mixins

Given the repetition of creating mixins like this, it should be pretty easy to create a function that can handle the grunt work for you. All you need to supply is a target object, a source object and a list of methods to copy. The mixin function can handle the rest:

[gist id=3847156 file=4.js]

This should be functionally equivalent to the previous code that was manually binding and assigning the methods. But keep in mind that this code is not robust at all. Bad things will happen if you get the source&#8217;s method names wrong, for example. These little details should be handled in a more complete mixin function.

## An Alternate Implementation: Closures

An alternate implementation for this can be facilitated without the use of a &#8220;bind&#8221; function. Instead, a simple closure can be set up around the source object, with a wrapper function that simply forwards calls to the source:

[gist id=3847156 file=5.js]

I&#8217;m not sure if this version is really &#8220;better&#8221; or not, but it would at least provide more backward compatibility support and fewer requirements. You wouldn&#8217;t need to patch &#8216;Function.prototype.bind&#8217; or use a third party shim or library for older browsers. It should work with any browser that supports JavaScript, though I&#8217;m not sure how far back it would go. Chances are, though, that any browser people are still using would be able to handle this, including &#8211; dare I say it? &#8211; IE6 (maybe… I think… I&#8217;m not going to test that, though 😛 )

## Potential Drawbacks

As great as all this looks and sounds, there are some limitations and drawbacks &#8211; and probably more than I&#8217;m even aware of right now. 

We&#8217;re directly manipulating the context of the functions with this solution. While this has certainly provided a measured benefit, it can be dangerous. There may be (are likely) times that you just don&#8217;t want to mess with context &#8211; namely when you aren&#8217;t in control of the function context in the first place. Think about a jQuery function callback, for example. Typically, jQuery sets the context of a callback to the DOM element that was being manipulated and you might not want to mess with that.

In the case of my EventBinder with Marionette, I did run in to a small problem with the context binding. The original version of the code would default the context of callback functions to the object that &#8220;bindTo&#8221; was called from. This meant the callback for &#8220;myView.bindTo(…)&#8221; would be run with &#8220;myView&#8221; as the context. When I switched over to the above code that creates the bound functions, the default context changed. Instead of being the view, the context was set to the EventBinder instance itself, just like our code told it to. This had an effect on how my Marionette views were behaving and I had to work around that problem in another way.

There certainly some potential drawbacks to this, as noted. But if you understand that danger and you don&#8217;t try to abuse this for absolutely everything, I think this idea could work out pretty well as a way to produce a mixin system that really does favor composition over inheritance, and avoids the pitfalls of simple object extension.