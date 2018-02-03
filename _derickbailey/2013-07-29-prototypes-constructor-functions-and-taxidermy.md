---
wordpress_id: 1119
title: Prototypes, Constructor Functions And Taxidermy
date: 2013-07-29T08:25:59+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1119
dsq_thread_id:
  - "1544471380"
categories:
  - AntiPatterns
  - Backbone
  - Books
  - E-Books
  - JavaScript
  - Prototypal Inheritance
---
When overriding the base \`Backbone.View\` to create your own view types from the base views, there are some issues that you may run in to with inheritance. The inheritance of constructor functions can be broken in strange ways, and code that you override in the constructor or other base ModelView or CollectionView functions may not be called when you expect it to be. This can be a tremendously frustrating problem, as the code you write looks correct, but it does not fire like you expect.

Fortunately, the fix is simple. Unfortunately, it&#8217;s not obvious. Worse, though, is that the simple but not obvious nature of the fix often makes it look like the solution is unnecessary.

## The Problem

The short version of the problem is that replacing [the `constructor` method](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/constructor) on `Backbone.View.prototype` doesn&#8217;t work. The `prototype.constructor` attribute is part of the JavaScript prototypal inheritance system, and isn&#8217;t something you should replace at all. Doing so is essentially trying to replace the type itself, but only replacing a specific reference to the type. Backbone provides the ability to specify a `constructor` in it&#8217;s type definitions, and it uses that function as the constructor function for the type that is returned. But this is only a convenience if not a coincidental naming of a method.

## Taxidermy On Prototypes

Replacing the `prototype.constructor` is a bit like taxidermy &#8211; the end result of &#8220;stuffing&#8221; a dead bear may still look like a bear on the outside, but it&#8217;s not really a bear anymore. It just looks like one. In the case of `prototype.constructor` though, this is especially dangerous because you can break code that relies on type checking or prototypal inheritance features that look at the `prototype.constructor`.

Visualize this through code, again:

<div class="highlight">
  <pre><span class="kd">function</span> <span class="nx">MyObject</span><span class="p">(){}</span>

<span class="nx">MyObject</span><span class="p">.</span><span class="nx">prototype</span><span class="p">.</span><span class="nx">constructor</span> <span class="o">=</span> <span class="kd">function</span><span class="p">(){};</span>

<span class="nx">console</span><span class="p">.</span><span class="nx">log</span><span class="p">(</span><span class="nx">MyObject</span><span class="p">.</span><span class="nx">prototype</span><span class="p">.</span><span class="nx">constructor</span><span class="p">);</span>
<span class="nx">console</span><span class="p">.</span><span class="nx">log</span><span class="p">(</span><span class="nx">MyObject</span><span class="p">.</span><span class="nx">prototype</span><span class="p">.</span><span class="nx">constructor</span> <span class="o">===</span> <span class="nx">MyObject</span><span class="p">);</span>
</pre>
</div>

<img src="http://lostechies.com/derickbailey/files/2013/07/prototype_constructor-replacement.png" alt="Prototype constructor replacement" width="600" height="93" border="0" />

The `prototype.constructor` is no longer pointing to `MyObject`, so the original `MyObject` &#8220;constructor function&#8221; is not being applied to the new object instance.

## Super Solution

All of the problems associated with the `prototype.constructor` replacement may be a bit disheartening. But there is hope, and a fairly simple solution.

There are two things you will need, to solve the problem of overriding a Backbone object&#8217;s constructor function without any other code having to extend from it directly.

  1. A new type with the &#8220;super-constructor&#8221; pattern (where a type calls back to the `prototype.constructor` manually)
  2. A complete replacement of the base view who&#8217;s constructor you want to replace.

By creating a new type that calls back to the original type&#8217;s constructor, you can ensure the correct chain of inheritance and constructors is handled. Then to get your new type in place without forcing others to extend from your type, you will need to replace the type from which your plugin extends, prior to any other code using it.

### The Super-Constructor Pattern

The constructor function of a Backbone object looks like it would be even easier to replace than a normal method. If you extend from `Backbone.View`, you don&#8217;t need to access the prototype. You only need to apply `Backbone.View` as a function, to the current object instance.

Once you have your type set up, you will need to replace the original type with your new type. By doing this, any new type that tries to extend from the original named type, will get yours instead of the original. But you can&#8217;t just replace `Backbone.View` directly.

<div class="highlight">
  <pre><span class="c1">// define the new type</span>
<span class="k">var</span> <span class="n">MyBaseView</span> <span class="o">=</span> <span class="n">Backbone</span><span class="p">.</span><span class="n">View</span><span class="p">.</span><span class="n">extend</span><span class="p">({</span>
  <span class="nl">constructor:</span> <span class="k">function</span><span class="p">(){</span>
    <span class="k">var</span> <span class="n">args</span> <span class="o">=</span> <span class="n">Array</span><span class="p">.</span><span class="n">prototype</span><span class="p">.</span><span class="n">slice</span><span class="p">.</span><span class="n">apply</span><span class="p">(</span><span class="n">arguments</span><span class="p">);</span>
    <span class="n">Backbone</span><span class="p">.</span><span class="n">View</span><span class="p">.</span><span class="n">apply</span><span class="p">(</span><span class="k">this</span><span class="p">,</span> <span class="n">args</span><span class="p">);</span>
  <span class="p">}</span>
<span class="p">});</span>

<span class="c1">// replace Backbone.View with the new type</span>
<span class="n">Backbone</span><span class="p">.</span><span class="n">View</span> <span class="o">=</span> <span class="n">MyBaseView</span><span class="p">;</span>
</pre>
</div>

> The `args` line is in the super-constructor example to ensure compatibility with older browsers. Some versions of IE, for example, will throw an error if the `arguments` object is null or undefined, and you pass it in to the `apply` method of another function. To work around this, you can slice the `arguments` object in to a proper array. This will return an empty array if the `arguments` is null or undefined, allowing older versions of IE to work properly.

Unfortunately, this setup will fail horribly. When the call to `Backbone.View.apply` is made, it will find your new type&#8217;s constructor sitting in `Backbone.View`, causing an infinite loop.

## Correctly Overriding The Constructor Function

To fix the view replacement and associated problems, you need to store a reference to the original `Backbone.View` separately from the new view type. Then you will need to call this reference from your constructor function, and not the `Backbone.View` named function, directly.

<div class="highlight">
  <pre><span class="p">(</span><span class="kd">function</span><span class="p">(){</span>
  <span class="c1">// store a reference to the original view</span>
  <span class="kd">var</span> <span class="nx">Original</span> <span class="o">=</span> <span class="nx">Backbone</span><span class="p">.</span><span class="nx">View</span><span class="p">;</span>

  <span class="kd">var</span> <span class="nx">MyView</span> <span class="o">=</span> <span class="nx">Original</span><span class="p">.</span><span class="nx">extend</span><span class="p">({</span>
    <span class="c1">// override the constructor, and all the original</span>
    <span class="nx">constructor</span><span class="o">:</span> <span class="kd">function</span><span class="p">(){</span>
      <span class="kd">var</span> <span class="nx">args</span> <span class="o">=</span> <span class="nb">Array</span><span class="p">.</span><span class="nx">prototype</span><span class="p">.</span><span class="nx">slice</span><span class="p">.</span><span class="nx">call</span><span class="p">(</span><span class="nx">arguments</span><span class="p">);</span>
      <span class="nx">Original</span><span class="p">.</span><span class="nx">apply</span><span class="p">(</span><span class="k">this</span><span class="p">,</span> <span class="nx">args</span><span class="p">);</span>
    <span class="p">}</span>
  <span class="p">});</span>

  <span class="c1">// Replace Backbone.View with the new one</span>
  <span class="nx">Backbone</span><span class="p">.</span><span class="nx">View</span> <span class="o">=</span> <span class="nx">MyView</span><span class="p">;</span>
<span class="p">})();</span>
</pre>
</div>

Now the Backbone.View has been replaced with your view type, while still maintaining a reference to the original so that it can be called when needed. Provided the file that includes this code is loaded prior to any other code extending from Backbone.View, all views will receive any functionality defined in `MyView` &#8211; which is exactly what you wanted in the Automation ID view.

## An Excerpt From Building Backbone Plugins

This blog post is an excerpt and preview of [Chapter 5 in my Building Backbone plugins e-book](http://backboneplugins.com). The complete chapter includes a more meaningful problem statement and solution set: trying to inject behavior in to a Backbone application without requiring any part of the application to know about the new behavior. It&#8217;s an interesting and common problem, and the solution as shown here is simple but not at all obvious. 

For more information about the e-book, including additional samples of the content, head over to [BackbonePlugins.com](http://backboneplugins.com).