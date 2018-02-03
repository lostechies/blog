---
wordpress_id: 886
title: 'ClassyObjects: A JavaScript Class-y Inheritance Example'
date: 2012-04-12T07:15:06+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=886
dsq_thread_id:
  - "646427279"
categories:
  - Backbone
  - Classy Inheritance
  - Ember
  - JavaScript
  - Prototypal Inheritance
---
I recently released a screencast that covers [JavaScript Objects & Prototypes](http://www.watchmecode.net/javascript-objects) on my [WatchMeCode](http://www.watchmecode.net/) site. In this screencast, I go through all of the basics of working with objects in JavaScript, including prototypal inheritance. Toward the end of the video, I also create an example framework that sort of brings a class-like or &#8220;class-y&#8221; inheritance system in to JavaScript. I&#8217;ve decided to open source that code and you can find it in [my ClassyObjects repository](https://github.com/derickbailey/classyobjects) at Github.

## DANGER, WILL ROBINSON!

Before I go any further, I want you to know that I do not endorse this type of inheritance scheme in JavaScript, and more explicitly, I do not recommend the use of this ClassyObjects framework for any purpose other than learning. It is not suitable for any other use. There are bugs, design and implementation limitations, and in general, class-y inheritance frameworks should be avoided in JavaScript. We&#8217;ll see why in a moment.

## An Example

There&#8217;s a small example in the Readme for the project, which illustrates the use of the framework:

[gist id=2351847 file=1.js]

In this example, I&#8217;m using the \`define\` method to create a new &#8220;class&#8221; (re: constructor function), using \`extend\` to inherit from that object and create yet another &#8220;class&#8221; (re: constructor function), and then use those objects to do some work &#8211; including the ability to call the \`super\` object of the one that I&#8217;ve extended in to.

It works fairly well. The few bits of functionality that you see in this case show the proper results. But there&#8217;s some pretty serious problems with writing code this way.

## Classy Frameworks: A Mistake

From [Douglas Crockford](http://javascript.crockford.com/prototypal.html):

> &#8220;_Five years ago I wrote Classical Inheritance in JavaScript. It showed that JavaScript is a class-free, prototypal language, and that it has sufficient expressive power to simulate a classical system. My programming style has evolved since then, as any good programmer&#8217;s should. I have learned to fully embrace prototypalism, and have liberated myself from the confines of the classical model._&#8220;

He also says at the bottom of his [Classical Inheritance](http://javascript.crockford.com/inheritance.html) page:

> &#8220;_I have been writing JavaScript for 8 years now, and I have never once found need to use an uber function. The super idea is fairly important in the classical pattern, but it appears to be unnecessary in the prototypal and functional patterns. I now see my early attempts to support the classical model in JavaScript as a mistake._&#8220;

Frankly, I agree with him. I think there&#8217;s some potential value in a framework like this, in specific scenarios. But the uses of it seem to be more and more limited, the more I learn about good prototypal inheritance patterns.

From my [Objects & Prototypes](http://www.watchmecode.net/javascript-objects) screencast:

> &#8220;_More than just the remaining bugs [in the ClassyObjects framework], though, wether or not a class-y framework is a good idea to begin with is a subject of intense debate._
> 
> _<img title="JSObjects-ClassyObjects.029.png" src="http://lostechies.com/derickbailey/files/2012/04/JSObjects-ClassyObjects.029.png" border="0" alt="JSObjects ClassyObjects 029" width="400" height="225" />_
> 
> _A class-y framework like this is powerful, indeed, and there are times when it can come in handy. [Backbone](http://backbonejs.org) is a good example, again. Jeremy Ashkenas &#8211; the creator of Backbone &#8211; recognized the need to provide a simple inheritance mechanism for the objects in Backbone so he provided one. But at the same time, he didn&#8217;t split the inheritance framework out in to it&#8217;s own library. I remember reading a comment at one point where he said he didn&#8217;t want to impose that style or it&#8217;s limitations on anyone outside of Backbone._ 
> 
> _For all of the convenience that we created, the class-y objects framework imposes a lot of overhead and brings it&#8217;s own limitations and issues. So I say we should embrace prototypes and prototypal inheritance and relegate the class-y frameworks, like the one we just wrote, to the special cases where the advantages may outweigh the disadvantages_.&#8221;

## Overhead And Other Concerns

Ok, enough of the nebulous rhetoric… there are a few real problems that I see in code like this. Chief among them are:

  * Implying a &#8220;class&#8221; definition, which can be dangerous for inexperienced JS devs
  * The overhead of defining the multiple layers of inheritance
  * The overhead of managing the &#8220;super&#8221; context correctly

### Implying A Class Definition

This is probably the worst of the problems that I&#8217;ve mentioned &#8211; at least in my opinion. I consistently run in to questions on StackOverflow where the person asking the question is looking at something like Backbone, assuming that they have a class definition because of the way it looks, and winding up with problems that are directly caused by not understanding object literal syntax. Now I&#8217;m not blaming Backbone or saying that these developers should know better. Doing either of those would get us nowhere. The point of using this as an example is to show that a class-like inheritance structure in JavaScript can be very deceiving.

When a developer brings years of experience with a language like Java, C#, C++ or other class-based systems, class-y JavaScript frameworks can be very deceptive. They look so much like class definitions that it&#8217;s easy to fall in to the trap of thinking that they are classes. Of course, there are no classes, so [we are really looking at object literals](http://lostechies.com/derickbailey/2011/11/09/backbone-js-object-literals-views-events-jquery-and-el/).

## Overhead Of Inheritance Layers

When a JavaScript object has a method called on it, that method might not exist on the object itself. It may exist on a prototype in the inheritance chain. When that is the case, the runtime must search up the prototype chain to find the method and call it from the prototype. In a small inheritance chain, this happens so fast that you&#8217;ll likely never notice it. But when we introduce a class-y inheritance framework like ClassyObjects, we add a lot more overhead for each layer of inheritance in order to protect the object we are extending from the one we have extended in to.

Look at it this way: when you have a standard prototypal inheritance chain going on, you have at most the number of objects that you are directly working with:

[gist id=2351847 file=2.js]

In this example, there are two objects that we defined and used: MyObject and InheritingObject. InheritingObject&#8217;s prototype is MyObject, directly. Any change we make to MyObject will be directly reflected in InheritingObject.

Now look at the the &#8220;inherits&#8221; function from the ClassyObjects framework, and a very simple usage of it:

[gist id=2351847 file=3.js]

In the example usage, it might look like we are only dealing with two objects. But the truth is we are dealing with no less than 5 objects: MyObject, ConstructorFunction, ConstructorFunction.prototype, the &#8220;definition&#8221; object literal, and finally the object instance that we create from the resulting &#8220;class-y&#8221; object.

We&#8217;ve added 2.5 times the number of layers to our system, so that we can create a class-like structure.

But there are some benefits to this. We&#8217;re not adding all of these layers for the sake of adding them. In the prototype example where we only have two objects in use, modifying MyObject will result in changes being available to InheritingObject. This might not be the desired behavior, and the ClassyObjects framework solves that with the additional overhead.

When we call &#8220;inherits&#8221; to create a new constructor function (&#8220;class&#8221;), we add the extra &#8220;inhertingInstance&#8221; object as the prototype of our ConstructorFunction specifically so that we can isolate the prototype of the new objects from the original object we extended. This means we can directly modify the &#8220;MyClass.prototype&#8221; object and have it affect all of our MyClass instances, while still isolating the original MyObject from those changes.

### Overhead Of Managing &#8220;this&#8221; in &#8220;super&#8221;

Both Backbone and ClassyObjects have a problem with context, directly caused by the way JavaScript respects the context of the called function. If you have a setup like this:

[gist id=2351847 file=4.js]

You&#8217;re going to end up with an infinite loop and a stack overflow problem. The problem is caused the use of &#8220;this.super&#8221;. In the call to &#8220;bar.baz&#8221;, the context of the call is set to the &#8220;bar&#8221; object. But the &#8220;baz&#8221; function doesn&#8217;t exist on &#8220;bar&#8221;, so it looks at &#8220;foo&#8221; for the function. Now the method definition for &#8220;foo.baz&#8221; calls &#8220;this.super.baz()&#8221;, which looks like it should call &#8220;root.baz&#8221;, right? After all, the &#8220;super&#8221;-class of &#8220;foo&#8221; is &#8220;root&#8221;. But since the function execution context has been set to &#8220;bar&#8221;, &#8220;this&#8221; still refers to &#8220;bar&#8221;. Therefore, &#8220;this.super.baz&#8221; will effectively call &#8220;bar.baz&#8221; &#8211; which is the original call that we made to start this whole thing off, thus resulting in an infinite loop.

You can fix this, though. You can add the overhead of wrapping &#8220;super&#8221; as a function and then wrapping the &#8220;super&#8221; function of each object in a bound context function. [EmberJS does this,](http://stackoverflow.com/a/10014310/93448) for example, and there&#8217;s a tremendous amount of overhead involved again. It&#8217;s akin to the way we created additional inheritance layers in order to isolate the prototype of a &#8220;class-y&#8221; constructor from the object that it extends.

More layers, more overhead, more potential for slowing down your application and your framework. No thanks.

## Still, It Has it&#8217;s Uses (I Think)

For all the class-y bashing that I&#8217;m doing here, I still think there&#8217;s some valid use of a class-like inheritance structure in JavaScript. Specifically, when creating a larger framework with it&#8217;s own need for behavior re-use and simplified object extension. That is, I don&#8217;t think a class-y framework should be built for the sake of itself. Instead, I think frameworks like Ember and Backbone have it right when they take advantage of a class-like infrastructure in order to make the larger purpose of the MV* style framework and library easier to use.

Sure, there are likely ways in which Backbone and Ember could facilitate their inheritance without the use of a class-like infrastructure. I don&#8217;t know that it would serve the needs of the end-user as well as a class-like framework, though. But then, I haven&#8217;t seen an MV* framework or library that takes this approach, yet. Maybe they are out there &#8211; and I&#8217;d love to see one. If one doesn&#8217;t exist, though, maybe it&#8217;s time to write one.

## For More Info On Prototypes&#8230;

If you&#8217;re interested in learning more about JavaScript objects and prototypes, check out [my 40 minute screencast on the subject](http://www.watchmecode.net/javascript-objects) (paid). I walk through the basics of object literals, functions, constructor functions, prototypes, the inheritance chain, building [the ClassyObjects framework](https://github.com/derickbailey/classyobjects), and type checking in JavaScript.