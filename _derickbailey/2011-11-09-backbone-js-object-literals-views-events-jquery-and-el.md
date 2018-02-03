---
wordpress_id: 646
title: 'Backbone.js: Object Literals, Views Events, jQuery, and `el`'
date: 2011-11-09T09:09:20+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=646
dsq_thread_id:
  - "466359167"
categories:
  - Backbone
  - JavaScript
  - JQuery
  - JSON
---
I&#8217;ve seen this question in various forms on StackOverflow, more than a few times:

> Why aren&#8217;t my view event callbacks are being fired?

or

> My view events won&#8217;t fire. What am I doing wrong?

or

> My view&#8217;s \`el\` is empty? Why? The HTML element is right there on the page.

While there are a number of possible problems that can cause these symptoms, it often comes down to an incorrect understanding of Backbone&#8217;s object definition syntax and using jQuery selectors to define the view&#8217;s \`el\`.

## A Caveat

Before I get in to the real meat of the post, I want to point something out: this post only applies to the situation where you actually need to assign an \`el\` in your view, instead of letting the view generate the \`el\` for you. In the vast majority of situations in a production application, [you shouldn&#8217;t be assigning an \`el\`](https://twitter.com/#!/jashkenas/status/134305026729451521) (thanks for reminding me, Jeremy!). One of the exceptions to this is [progressive enhancement](http://lostechies.com/derickbailey/2011/09/26/seo-and-accessibility-with-html5-pushstate-part-2-progressive-enhancement-with-backbone-js/) &#8211; when you need to take existing HTML and attach JavaScript functionality to it. Most of the time, though, you should let the view generate the \`el\` for you, and then append the view to an HTML element via jQuery or some other mechanism.

## Nothing. No Errors. No Events Firing. Just … Nothing

Look at this code:

[gist id=1351655 file=1.js]

along with this HTML:

[gist id=1351655 file=1.html]

and try to spot the bug. No, it&#8217;s not a syntax error of any kind. This code is perfectly valid and runs without any JavaScript errors being thrown. But, chances are, none of the events are going to fire and you&#8217;re never going to see an alert box.

[Let&#8217;s see that code in a JSFiddle](http://jsfiddle.net/derickbailey/UJmGD/), just to make sure:



So what&#8217;s going on here? Why isn&#8217;t the view registering the events correctly and calling the event handler callback method? The short answer is:

> **jQuery&#8217;s $ selector was called before the DOM was ready.**

To understand how we can solve the problem at hand, we need to understand why the problem happens in the first place.

## Backbone Object Definitions

A Backbone object definition consists of a few different parts. There&#8217;s the use of the \`extend\` method on the Backbone construct itself, and there&#8217;s the definition that you the developer provide to the construct so that the object will have all of your code and do what you want. At first glance &#8211; and coming from a more C-oriented world of C# or Java &#8211; this has a tendency to look like a class definition. Don&#8217;t be fooled, though. There are no classes in JavaScript. Period. Ever. End of discussion. Here, I&#8217;ll say it again:

> **THERE ARE NO CLASSES IN JAVASCRIPT**

Clear enough? Great.

What we have is a clever use of underscore.js&#8217; \`extend\` method with an object literal being passed in to the extend method call, returning a new instance of a constructor function &#8211; a JavaScript function that can be used to construct new object instances.

Since we&#8217;re passing an object literal in to the extend method, it can be separated out into a variable and method call. The code above is the equivalent of this:

[gist id=1351655 file=2.js]

This is important for a number of reasons.

## Object Literal Evaluation

Object literals in JavaScript are also known by a number of other names: hashes, associative arrays, key/value sets, JSON, and probably still other names I can&#8217;t think of off-hand. Whatever name you&#8217;re using to describe them, though, there is one very important aspect of the key / value syntax that you need to understand:

> **The values in an object literal are evaluated immediately**

The left hand side of the \`key: value\` pair is a static name. It never gets evaluated. Instead, it becomes the identifier (the &#8220;key&#8221;) for the value on the right hand side. The value on the right hand side, however, is evaluated immediately, when the JavaScript runtime steps through it.

Look at this example:

[gist id=1351655 file=3.js]

In this code, the key of &#8220;foo&#8221; is assigned to a literal string: &#8220;some value&#8221;. &#8220;Bar&#8221; on the other hand, is assigned to an expression: 1 + 1. The result of this expression is 2, so &#8220;bar&#8221; is assigned the value of 2. It is not assigned an expression that evaluates to the value of 2 every time you access &#8220;bar&#8221;. It is literally assigned the value of 2 because the &#8220;1 + 1&#8221; expression is executed immediately.

Let&#8217;s look at &#8220;bar&#8221; in another light:

[gist id=1351655 file=4.js]

In this example, I&#8217;ve created a function that returns the sum of two numbers. When we assign &#8220;bar&#8221; to &#8220;add(1, 1)&#8221;, the result will be 2. Note that we are assigning &#8220;bar&#8221; to the result of the add function (by calling the function with parenthesis and passing in parameters &#8211; we are executing the function). When we examine the value of &#8220;bar&#8221; we get the literal value of 2 because that&#8217;s the result of the function we called.

Because object literal values are evaluated immediately, the key we assign will have a value that represents the evaluated value we have supplied. We can use this to our advantage &#8211; and in fact, we already are taking advantage of this when we define our Backbone objects.

## Backbone, Object Literals, and jQuery

What&#8217;s the first thing you learned when someone showed you jQuery for the first time? Most likely, you saw something like this:

[gist id=1351655 file=5.js]

or

[gist id=1351655 file=6.js]

Then you put your jQuery selector code inside of the jQuery function or document ready function, and started manipulating the DOM like a boss. The reason we do this, of course, is that we need the DOM to be &#8220;ready&#8221; for jQuery&#8217;s selectors to work. Once it&#8217;s ready, we can select all day long and things work fine.

Back to the original problem: &#8220;my events are not firing&#8221;. Can you spot the problem with this sample code, now?

[gist id=1351655 file=1.js]

So… jQuery&#8217;s document ready function + object literals having their values evaluated immediately. The problem in this sample Backbone code, then, is that we are executing the jQuery selector for our view&#8217;s \`el\` before the DOM is ready.

Now that we understand the actual problem, we can look at some possibilities for solutions.

## Options And Deferring Execution

Ultimately, the solution we come up with &#8211; no matter what the code looks like &#8211; is going to be the same thing: deferred execution of the jQuery selector. We need to wait until after the DOM is loaded to run our jQuery selector, so that our view&#8217;s \`el\` will find the element we specify.

### Let The View Generate An \`el\`. Append It To An Element

As I said in the &#8220;caveat&#8221;, you generally don&#8217;t want to assign an \`el\` to your view. Instead, you should allow the view to generate the \`el\` and then attach the view&#8217;s \`el\` to an element in your HTML. This reduces the coupling between your JavaScript and your HTML, allowing you more flexibility and making it easier to update what is going where, without having to tear things apart before putting them back together.

Here is one way of accomplishing that goal:

[gist id=1352005 file=10.js]

In this example, the view is generating it&#8217;s own \`el\` and then the render method is populating it with additional HTML contents. Then in the DOM ready callback, the view is instantiated and rendered, and the existing HTML element is selected then populated with the contents from the rendered view.

Like I said &#8211; do it this way whenever you can. If you do need to assign an \`el\` to a view, though, you do have.

### Let Backbone Do It For You

Backbone is a very smart little library. It handles the vast majority of common scenarios itself. [Jordan Glasner reminded me, via twitter](https://twitter.com/#!/glasner/status/134294048906285056), that Backbone can handle the jQuery selector for you:

[gist id=1351804 file=10.js]

There may be times when you specifically want to use a jQuery selector to find your element, though. In this case, you still have options.

### Put Everything In the jQuery Function?

The first answer that most people come to is to put everything in the DOM ready / jQuery function:

[gist id=1351655 file=7.js]

This works &#8211; the jQuery selector will find the element and the events will be wired up correctly. However, this isn&#8217;t a very good solution. First off, this isn&#8217;t a very good practice for organizational reasons. You should limit the amount of code you have in your DOM ready callbacks. It keeps things clean and easy to understand. More importantly though, delaying the definition of your Backbone objects until the DOM is ready can cause a bit of a performance hit for the end user. The site may appear to be a bit slow to get running, even after the content loads. It would be better to have the Backbone objects already defined and only defer the jQuery selector execution.

### View Initializer

While it&#8217;s true that the value in a JavaScript object literal is evaluated immediately, that doesn&#8217;t mean it&#8217;s always executed immediately. Much of what we do when we define a Backbone object is specify a function as the value. We do this with the \`render\` function, the \`initialize\` function, and any of our own functions that we need to make our views work correctly.

Functions are a very special thing in JavaScript for many, many reasons. One of those reasons &#8211; like in most languages &#8211; is that functions are essentially deferred execution. You define a function whenever and wherever you want, and the code inside of that function is not executed until you actually call the function. You are deferring execution until you call the function.

We can take advantage of this deferred execution and move our jQuery selector into a function in our view. One of the common places to do this is the initializer of the view:

[gist id=1351655 file=8.js]

We only had to ensure that we are not creating an instance of this view until after the DOM is ready. That was easy enough, with the DOM ready callback instantiating the view. So, we&#8217;ve solved the problem of deferring the jQuery selector, and we&#8217;ve kept the DOM ready callback to a minimum. It&#8217;s a win-win (most of the time)!

### Passing \`el\` Into The View Constructor

There are time when it doesn&#8217;t make sense to specify the jQuery selector directly in your view. I won&#8217;t go in to all of the details on when, because I think that&#8217;s largely a question of style and preferences (which is a very large discussion on it&#8217;s own). I do find myself in a situation where I want to decouple the view from the knowledge of it&#8217;s \`el\`, fairly regularly, though. In this situation all we need to do is specify an \`el\` when we instantiate the view:

[gist id=1351655 file=9.js]

In this example, the view itself does not define an \`el\`. This means that we will get an \`el\` generated for us and end up with a div by default. If you were to instantiate this view without passing any options to the construction, you would get this result. However, by passing in the \`el\` option, we are overriding the \`el\` for that specific instance of the view. This means we can specify a jQuery selector to grab the element we want when we instantiate the view. Since we are instantiating the view in the DOM ready callback, the jQuery selector works fine and we get the functionality we expect.

### Other Options

There are still other options, I&#8217;m sure, for deferring the execution of the jQuery selector so that our view will be given the correct \`el\`. We could, for example, assign the \`el\` to a view object after it has been initialized. In the end, though, we are always deferring the execution of the jQuery selector until the DOM is ready, ensuring the availability of the elements we are looking for.

 