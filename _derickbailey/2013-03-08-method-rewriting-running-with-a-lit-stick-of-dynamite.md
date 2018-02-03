---
wordpress_id: 1061
title: 'Method Rewriting: Running With A Lit Stick Of Dynamite'
date: 2013-03-08T11:27:19+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1061
dsq_thread_id:
  - "1125381538"
categories:
  - AntiPatterns
  - Backbone
  - JavaScript
  - Principles and Patterns
---
I had a problem I wanted to solve. I thought to myself, &#8220;I know! I&#8217;ll use function rewriting!&#8221; and it was good… I solved the problem. But I also introduced some other problems regarding method references and event handlers. 

## Method Rewriting

If you&#8217;re not familiar with method rewriting in JavaScript, it&#8217;s basically just replacing a method at runtime, from within the method itself.

[gist file=1.js id=5118183]

In this example, the &#8220;foo&#8221; method contains code to replace the &#8220;foo&#8221; method with a new method implementation. When the &#8220;foo&#8221; method is run the first time, it outputs &#8220;bar&#8221;. Then it replaces the &#8220;foo&#8221; method with the new implementation. Subsequent execution of this method will output &#8220;quux&#8221; instead of &#8220;bar&#8221; because the method has been rewritten.

## And BOOM Goes The Dynamite

The problem I ran into has to do with the way we set up event handlers in JavaScript, by passing function references around. Consider the following Backbone.View implementation:

[gist file=2.js id=5118183]

When the view is instantiated, a &#8220;change&#8221; event from the view&#8217;s model is handled. When the model changes, it calls the &#8220;render&#8221; function. This ensures the view is always up to date with the latest data from the model. It&#8217;s not a very good solution from a performance perspective, but it solves the general problem.

Now let&#8217;s introduce a more complicated scenario where the first time the view renders, it should do a little bit of extra work. Subsequent execution of the render method should not do that extra work. I&#8217;m not going to get in to detail about what the extra work might be in a real application, but I can illustrate the point using some simple console.log calls. 

When you run the above code, the first call to the render method logs the &#8220;extra work&#8221; message. Calling the render method a second time, directly, does not produce this message. That&#8217;s good. It means our function re-writing worked. However, changing any of the data on the model will produce the &#8220;extra work&#8221; message, which is not what we want.  Worse still, it will replace the &#8220;render&#8221; method on the view instance again, and again, and again, every time the change event fires.

## Lighting The Dynamite

The problem is the way we hand off a reference to the function for the event handler. When we call \`this.model.on(&#8220;change&#8221;, this.render, this);\`, we are handing a method pointer to the &#8220;on&#8221; function &#8211;  a callback that points directly to the current implementation of the &#8220;render&#8221; function. This is not a reference that gets evaluated every time the change method fires. It is evaluated immediately when the event handler is set up, and a direct reference to the render function itself (not the object that holds on to the render function) is passed through as the event handler.

When the render function is called later on, the render function itself replaces the view&#8217;s &#8220;render&#8221; function with a new function. It re-writes itself… except this is a bit of a misnomer. The function it not actually re-writing itself. What it is doing, really, is replacing the view&#8217;s reference to itself with a reference to another function. It&#8217;s the equivalent of this:

[gist file=3.js id=5118183]

In this code, it is very clear that the &#8220;render&#8221; method is being replaced. The original function is not being &#8220;re-written&#8221;, but only replaced. Method re-writing does exactly this, but does it from within the function that is being replaced. 

Now, getting back to the event handler… when the &#8220;render&#8221; function replaces itself, it only replaces the function on the view instance. It doesn&#8217;t have a reference to the &#8220;on&#8221; method and it doesn&#8217;t know how to replace that event handler with the new function reference. Therefore, the &#8220;on&#8221; event handler still references the original render function, even after the render function has replaced itself on the view.

The result is that the &#8220;change&#8221; event fired from the model will cause the original render function to be executed. Since the original render function contains the method re-writing code, it will replace the view&#8217;s render method again. Every time the &#8220;change&#8221; event fires from the model, this will happen. If the &#8220;change&#8221; event fires 3 times, the &#8220;render&#8221; function on the view will be replaced 3 times.

## Powerful But Dangerous

Lesson learned: method rewriting is like running with a lit stick of dynamite. It&#8217;s a powerful tool that serves a purpose &#8211; but the scope and references to the functions that are being re-written need to be controlled very tightly, or it will blow up in your face.