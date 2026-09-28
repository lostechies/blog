---
wordpress_id: 273
title: JavaScript decorator pattern
date: 2009-01-20T22:38:52+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/01/20/javascript-decorator-pattern.aspx
dsq_thread_id:
  - "264716053"
categories:
  - JavaScript
redirect_from: "/blogs/jimmy_bogard/archive/2009/01/20/javascript-decorator-pattern.aspx/"
---
I don’t care how many other places this is on the net, file this one under “so I won’t need to look ever again.”

I needed to augment an existing JavaScript function by applying a decorator to it, where I needed to dynamically add special behavior for this _one page_.&#160; Ideally, I could have bound to some event, but a decorator worked just as well.&#160; Instead of doing some custom JavaScript for decorating this one method, I modified the Function prototype, to add two new methods, “before” and “after”:

<pre>Function.prototype.method = <span style="color: blue">function</span>(name, func) {
    <span style="color: blue">this</span>.prototype[name] = func;
    <span style="color: blue">return this</span>;
};

Function.method(<span style="color: #a31515">'before'</span>, <span style="color: blue">function</span>(beforeFunc) {
    <span style="color: blue">var </span>that = <span style="color: blue">this</span>;
    <span style="color: blue">return function</span>() {
        beforeFunc.apply(<span style="color: blue">null</span>, arguments);
        <span style="color: blue">return </span>that.apply(<span style="color: blue">null</span>, arguments);
    };
});

Function.method(<span style="color: #a31515">'after'</span>, <span style="color: blue">function</span>(afterFunc) {
    <span style="color: blue">var </span>that = <span style="color: blue">this</span>;
    <span style="color: blue">return function</span>() {
        <span style="color: blue">var </span>result = that.apply(<span style="color: blue">null</span>, arguments);
        afterFunc.apply(<span style="color: blue">null</span>, arguments);
        <span style="color: blue">return </span>result;
    };
});</pre>

[](http://11011.net/software/vspaste)

Each decorator method captures the original method (in the “that” variable) and returns a new method that calls the original and new method passed in, all without modifying the original method.&#160; With these new Function prototype methods, I can do some highly interesting code:

<pre><span style="color: blue">var </span>test = <span style="color: blue">function</span>(name) { alert(name + <span style="color: #a31515">' is a punk.'</span>); };

test(<span style="color: #a31515">'Nelson Muntz'</span>);

test = test.before(<span style="color: blue">function</span>(name) { alert(name + <span style="color: #a31515">' is a great guy.'</span>); });

test(<span style="color: #a31515">'Milhouse'</span>);

test = test.after(<span style="color: blue">function</span>(name) { alert(name + <span style="color: #a31515">' has a fat head.'</span>); });

test(<span style="color: #a31515">'Jimmy'</span>);</pre>

[](http://11011.net/software/vspaste)

We see from this code, in succession, alerts:

  * “&#8217;Nelson Muntz is a punk”
  * “Milhouse is a great guy”
  * “Milhouse is a punk”
  * “Jimmy is a great guy”
  * “Jimmy is a punk”
  * “Jimmy has a fat head”

This code was brought to you by lessons learned from the awesome JavaScript book, “[JavaScript: The Good Parts](http://www.amazon.com/JavaScript-Good-Parts-Douglas-Crockford/dp/0596517742)”, and the magic of closures.