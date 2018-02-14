---
wordpress_id: 1243
title: 'Killing Switch Statements With A Registry: An Example And Screencast'
date: 2014-01-28T07:45:34+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1243
dsq_thread_id:
  - "2182359238"
categories:
  - Design Patterns
  - JavaScript
  - Principles and Patterns
  - Screencast
  - WatchMeCode
---
In my video on [the SOLID principles applied to JavaScript](http://lostechies.com/derickbailey/2014/01/10/solid-javascript-in-a-wobbly-world-wide-web/), I showed a quick transformation from using a switch statement to using a registry instead, with the Open-Closed principle as the impetus for moving in that direction. It&#8217;s a good trick to get more flexibility out of your code by letting you add as many actions as needed, without having to change the way things work internally. You can reduce the &#8220;ugly&#8221; factor of a switch statement, create code that is easier to read, and claim your SOLID principles badge of honor all in one move. That&#8217;s a pretty sweet deal, if you ask me. 

## Open To Change, Closed To Modification

The Open-Closed Principle (OCP) says that code should be opened to change in behavior, but closed to modification.

As I said in the talk, the best example of this is to look at hardware. Nearly every computing and mobile device out there has some sort of USB connection on it, these days. Plugging a USB device in to a laptop or desktop computer is a great example of how hardware is open to extension and change in behavior, without being required to change the existing hardware. You just plug the thumb drive, headset, camera, network adapter, or whatever it is in to the USB port and now your computer has additional behavior available. You&#8217;ve changed the system without changing the existing hardware. 

Code works the same way. When we provide plugins, extensions, interface / protocol implementations or just pass objects as parameters in our code, we are providing a way to make that code extensible / extendable. We can change the behavior of the code by providing a different implementation of a given interface / protocol, without having to change the code that uses this interface / protocol. This is the essence of the open-closed principle (though there are a lot of other subtleties to watch when it comes to implementations).

## OCP As Applied To Switch Statements

Switch statements are a simple way of providing flow control in your program. They let you decide which code is going to run, based on a given value. In the talk, I showed the following switch statement as an example:

{% gist 8655816 1.js %}

There are several things I don&#8217;t like about switch statements, including the inability to change the behavior of the system without digging in to the switch statement itself. Every time you want to add a new thing to execute, you have to change the existing code. This clearly violates OCP by requiring changes to existing code instead of just allowing new behaviors to be added without changing existing code. 

In many (most: probably 9/10 times) cases, a switch statement can be replaced with a registry object.

{% gist 8655816 2.js %}

This cleans up the ugliness of the switch and also allows you to add and remove behaviors as needed, without changing the internals of the registry or the code that is calling the registry to get things done. 

## The Registry Object

The registry object itself is not complex. It takes in a named thing and allows that to be retrieved by name. Whether you call this a registry, a dictionary, a key/value store or whatever you want to call it, the code to implement it in JavaScript is small if not simple.

{% gist 8655816 3.js %}

This code gives you all the features you need to completely replace a switch statement, including default values (though, not including fall-through switches, which are a bad idea to begin with). 

## I Need More Cowbell

Being able to swap out a switch statement with a registry object is great. But what if you want to know why the registry was built the way it was? What if you need more cowbell?

<img src="http://lostechies.com/content/derickbailey/uploads/2014/01/NewImage7.png" alt="NewImage" width="374" height="281" border="0" />

 Well, don&#8217;t worry! I&#8217;ve got you covered. I built a screencast that covers the registry pattern in more detail, outlining how JavaScript gives us the ability to use simple object literals to store key/value pairs, showing some of the problems that this can cause, and then walking through the construction of the registry object that I used in this presentation. I also walk through some uses of the registry object that we create, including building your own event system by composing the registry in to an Events object. 

[<img src="http://lostechies.com/content/derickbailey/uploads/2014/01/NewImage8.png" alt="NewImage" width="300" height="225" border="0" />](http://www.watchmecode.net/registry-pattern)

 If you&#8217;re looking for info on how to build a registry, and why you would want to build it the way that I&#8217;ve shown, then checkout [WatchMeCode Episode 14: The Registry Pattern](http://www.watchmecode.net/registry-pattern).

 
