---
wordpress_id: 4684
title: You Have Nothing To Fear From Javascript
date: 2007-12-08T10:46:00+00:00
author: Colin Ramsay
layout: post
wordpress_guid: /blogs/colin_ramsay/archive/2007/12/08/you-have-nothing-to-fear-from-javascript.aspx
categories:
  - JavaScript
---
Building a web application consists of a number of discrete layers: server code, client code, HTML, and styling. If you cannot sit down with one of those layers and work on it, you are not fulfilling your role. If I hire a web developer, I don&#8217;t expect them to tell me that they know little of Javascript, but unfortunately there seems to be a fear of that language, where people are happy to hide it away behind a facade of server-side code which autogenerates it.

This is _wrong_. If you are working with Javascript, client side code, then you should be able to fully debug, understand, and tweak that code natively. Changing some C# code which you think will generate the right JS is such a horrific approach I can&#8217;t believe anyone would advocate it. In order to have a robust application you need full control of all aspect, from top to bottom.

Besides, Javascript is actually a _great_ language, though much maligned over the years. As the web matured, Javascript was often responsible for scrolling banners, page errors, and other affronts to the user. But as people have documented its browser support and language tricks, Javascript has matured with its environment. Check out this structure in Javascript:

    // Setup "static" structure<br>var Application = function() {<br><br>	var _privateVar = 0; <br><br><br>	return {<br><br>		someFunction : function() {<br>			_privateVar = 5;<br><br>		}<br><br>	}<br>    } <br>}();<br><br>// Run the function<br>Application.someFunction();

Organised, readable Javascript! Whatever next! You can even have psuedo-namespaces, classes, anonymous functions, loads of great dynamic language features which allow you to come up with flexible and concise code. Generating your JS isn&#8217;t just unwise, it means you&#8217;re missing out on all the fun!