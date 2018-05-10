---
wordpress_id: 624
title: Rebuilding My Backbone.js Plugins With Modules, SRP and More
date: 2011-10-25T14:27:39+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=624
dsq_thread_id:
  - "453082764"
categories:
  - Backbone
  - Backbone.Memento
  - Backbone.ModelBinding
  - JavaScript
  - Refactoring
---
In the last few weeks, I&#8217;ve rebuilt and refactored a large amount of JavaScript code in both my [Backbone.ModelBinding](https://github.com/derickbailey/backbone.modelbinding) and [Backbone.Memento](https://github.com/derickbailey/backbone.memento) plugins. In the process, I re-learned several object oriented design principles and how they apply to JavaScript. I also brushed up on some of my JavaScript patterns and learned a little about writing good, functional unit tests. While I can&#8217;t write about everything that I did and why in one blog post, I wanted to at least share the highlights.

## A Big Ball Of Mud

Both of these plugins started out with great intentions, and good code. I was diving heavily into object oriented JavaScript with the help of the [Javascript Patterns book](http://www.amazon.com/JavaScript-Patterns-Stoyan-Stefanov/dp/0596806752) (high recommended reading) and also solving several problems that I was running into with my Backbone.js apps. As most big balls of mud do, both of the code bases started out small and clean. Over time, I added features and functionality. New and exciting ideas popped up and were introduced… all without regard for the structure and design of the code. I was hacking away, test-first mind you, and introducing more and more complexity to both of these projects, slowly turning a shiny pebble into a ball of mud. Eventually, I began to see feature requests and bug reports that I couldn&#8217;t solve easily.

## Filtering The Mud

People were requesting functionality that my code considered an &#8220;edge case&#8221; originally, but was in reality, something very useful. One such example is the &#8220;named states&#8221; request for my memento plugin. A user (and myself, honestly) want to be able to store state with a given name, so that the model can always be rolled back to it, by name. This is a feature that I still need to implement, mind you, but prior to refactoring the code for this plugin, I wouldn&#8217;t have been able to do it without serious headache.

I also saw bug reports that I couldn&#8217;t fix because there was no clear way to get to the information that I needed, at the time I needed it. For example, my modelbinding plugin would set up HTML DOM events and modify the model when the DOM elements changed. However, the &#8216;unbind&#8217; process was unable to handle the DOM event bindings (I&#8217;ll show you the detail in the &#8220;instances vs literals&#8221; section, later). After refactoring the code, though, the inclusion of this functionality was trivial &#8211; it was obvious that it should have been there, and it took only minutes to implement it.

## The Single Responsibility Principle

If you&#8217;ve paid attention to my blog for more than a few months, talked with me at a conference, or watched any of my presentations, you&#8217;ve probably heard me drone on and on about the [Single Responsibility Principle (SRP)](http://en.wikipedia.org/wiki/Single_responsibility_principle). It&#8217;s an important one, in my opinion. And yes, it applies to pretty much any language you code in &#8211; not just object oriented languages.

In this particular case, my memento plugin was in serious violation of SRP. I was originally very proud of myself for having written a very well encapsulated object to handle all of the memento&#8217;ing process. But encapsulation is not the only vector on which we judge the quality of code, and I failed miserably in the responsibility department.

As it turns out, the solution I created contains far more than just one responsibility. Here&#8217;s a small list of things that this code wraps up:

  * Create a memento (serialize the state of a model or collection)
  * Store the mementos (push on to a stack: first in, last out)
  * Retrieve the previous memento from storage (pop it off the stack)
  * Restore the model or collection&#8217;s state (deserialize)
  * Rollback all the way to the beginning of the model&#8217;s saved states (if there is one)

This list isn&#8217;t too bad. But when you have _all_ of this functionality wrapped up in only a handful of methods, all within the same object, it turns into a giant mess that is very difficult to read and understand. (If you&#8217;d like to take a moment to poke your eyes out, you can [read the code that I am talking about, here](https://github.com/derickbailey/backbone.memento/blob/v0.3.0/backbone.memento.js). Can you even find the public API in that mess?)

Let&#8217;s take a different look at the list of functionality, now, and pull things into a logical grouping based on the work that each of the above functions does:

  * A High level workflow: organize all of the parts, to make this thing function
  * A stack 
      * Push a memento
      * Pop a memento
      * Roll back to the first memento
  * A serializer 
      * Serialize
      * Deserialize

Suddenly the code starts to make more sense. The difference pieces of the puzzle start to fall in place, and we can start to compose the system out of many small pieces that do one thing well, and have one reason to change.

The end result of this refactoring can be summarized with the high level Memento class: the driver of all the workflow in this plugin:

{% gist 1314027 1.js %}

It&#8217;s easy to see what&#8217;s happening here. You don&#8217;t need to pick apart the guts of implementation in order to understand the high level process because this is the high level process. If you want to know the detail, you can dive down into it when you need to instead of being forced to wade through it constantly.

## Object Instances vs Object Literals And Functions

Probably the single largest mistake I made when building the modelbinding plugin was to use object literals and singleton objects throughout the code. I thought I was being clever, at first. The problem with &#8220;clever&#8221;, though, is that you&#8217;ll rarely find it coinciding with &#8220;intelligent&#8221; and &#8220;elegant&#8221; once you get past the initial implementation and need to add features and functionality.

Object literals are easy to build in JavaScript. Just set a bunch of key-value pairs, using a semi-colon, between opening and closing curly braces:

{% gist 1314027 2.js %}

You can add any amount of functionality that you want to an object literal, with the exception of not being able to create &#8220;private&#8221; variables (and I put &#8220;private&#8221; in quotes because it&#8217;s only private by the use of closures, not by a syntactical keyword called &#8220;private&#8221;). In order to create &#8220;private&#8221; variables, you have to enclose the object literal in another function to build the closure around the variable.

{% gist 1314027 3.js %}

This is often called the &#8220;revealing module&#8221; pattern (or something along those lines, I think) as it allows you to reveal an API that you want without having to expose all of the internals of your module. Object literals and modules have their usefulness, mind you. I use them frequently and recommend you read up on them. But like any other tool we have, these can be used and abused, and my modelbinding plugin was beating these patterns into the ground.

It all came to a head when I got the bug report saying my code was no unbinding the DOM element events. After digging into this, I realized that because I was using object literals everywhere, I had no way of storing the configuration data I needed for any given Backbone view and model. Without this configuration, there was no way for me to know which HTML elements had which DOM events firing for which models. I was stuck with event bindings that I couldn&#8217;t remove, without resorting to jQuery calls that would remove _all_ bindings (not what I wanted).

After some work (4 or 5 hours, total), I was finally able to remove the offending object literals from the modelbinding plugin, and switch over to object instances. Now, every call to the \`bind\` function of the plugin creates a new instance of a \`ModelBinder\` object. This object stores all of the configuration that it needs for the one specific view and model that it deals with. Then, when \`unbind\` is called, I don&#8217;t need to try and re-calculate the configuration. All I need to do is loop through the list of events configurations and call \`unbind\` on each of them individually. This worked for both the model and DOM element bindings, making it even easier.

([To see this code in action, go here](https://github.com/derickbailey/backbone.modelbinding/blob/master/backbone.modelbinding.js#L29))

## The Dynamic Nature Of JavaScript

There was another problem that I ran into with the modelbinding code, related to how I stored and retrieved the configuration for each ModelBinder instance.

In the previous version of the code, I recalculated everything when \`unbind\` was called. This obviously didn&#8217;t work, and I wanted to use a ModelBinder instance to store the configuration for me in the new version. However, I also wanted to keep the existing public API for my plugin: \`Backbone.ModelBinding.bind(view)\` and \`Backbone.ModelBinding.unbind(view)\`. This API relied on singleton object methods, instead of object instance methods &#8211; back to square one with the object literals problem, right?

Fortunately, I found a very simple solution in the dynamic nature of Javascript: attach the ModelBinder instance directly to the View instance.

Since the configuration of a given ModelBinder instance was for a specific View instance, it makes sense for these two items to be stored together &#8211; to use the View instance as a way to store and retrieve the ModelBinder. At first, I was going to use another object to store the View: ModelBinder as a key/value pair. But then I realized that I didn&#8217;t need to do this, either. Since the View itself is passed into both the \`bind\` and \`unbind\` functions, I can store the ModelBinder directly on the view.

{% gist 1314027 id=4.js %}

Then, when I call \`unbind\` and pass in the view, I only need to check for the existence of a \`modelBinder\` attribute on the view. If it exists, I can assume that it&#8217;s my ModelBinder class with all of the configuration for that view, and have it do all of the unbinding for me.

{% gist 1314027 id=5.js %}

Much cleaner, easier to understand, and it takes advantage of JavaScript&#8217;s dynamic nature, allowing me to use the objects I already have to store the configuration that I need.

## And So Much More &#8230;

There&#8217;s so much more that went into the refactoring and re-building of these plugins, still. I used techniques such as init-time branching instead of run-time branch. I wrapped my code in modules, providing a clean public API while hiding the internals of my code away from the outside world. And I relied on my test suite, written in Jasmine for both plugins, to tell me when I was breaking the functionality of the system and when I was putting it all back together, resulting in only 1 minor breaking changing to the public API in my modelbinding plugin (which I purposefully did, btw).

JavaScript, for me, has officially moved out of the &#8220;necessary evil&#8221; category of languages and into the realm of fun, first class languages. There&#8217;s enough knowledge floating around out there, enough tooling to work with, and enough passion and interest in building awesome things with Javascript, for me to consider it a significant part of my tools. If you haven&#8217;t done so, already, take some time to bone up on your JavaScript skills. It really is a great language once you get past the curly braces and semi-colons.

## A View Into My Thoughts And Process

If you&#8217;re interested in seeing some of the other tricks and tools that I used, you&#8217;re in luck! I decided to do a little more with my memento plugin when working on it. Instead of just cranking out the code and publishing it, I turned on Screenflow and hit record. It took 2 hours to explain what I was doing, why, and actually make it happen in the code, but I think it was worth the effort. The result is an unedited view into my thoughts and workflow when refactoring a JavaScript project, [available as a screencast](http://watchmecode.net). Check it out if you&#8217;d like to see more than just the end result, and want to know why it ended up the way it did.
