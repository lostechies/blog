---
wordpress_id: 4685
title: 'Javascript Patterns &#038; Practices'
date: 2008-01-17T22:17:00+00:00
author: Colin Ramsay
layout: post
wordpress_guid: /blogs/colin_ramsay/archive/2008/01/17/javascript-patterns-amp-practices.aspx
categories:
  - JavaScript
  - practices
redirect_from: "/blogs/colin_ramsay/archive/2008/01/17/javascript-patterns-amp-practices.aspx/"
---
My previous post on Javascript gave an insight into using the language in a more structured manner than you may 

have been used to in the past. I&#8217;m going to talk about a few more methods which I use a lot, and that help me keep 

my JS workable.

**Pattern**

Last time, I talked about the Object Literal pattern. If it helps, you can think about this as if it were a C# 

static class; you don&#8217;t need to instantiate it, it can have state, but it is application-wide. I will typically use 

Object Literal as a kind of &#8220;manager&#8221;, which controls what happens on a page, from a function which fires onload, 

to functions which get triggered on button clicks.&nbsp;

In other places, such as complex user interfaces, I will typically need &#8220;components&#8221;, which wrap up a lot of 

functionality and may be used multiple times within a page. An example of this might be a date picker control. For 

these components, I need to hold state, and so I need the equivalent of a standard C# class.

    function DatePicker(date) {<br><br>	if(date) {<br>		this.initial = date;<br>	} else {<br>		this.initial = new Date();<br>	}<br><br>	this.show = function(date) {<br>		alert(this.initial);<br>	}<br>}<br><br>var startDatePicker = new DatePicker();<br>var endDatePicker = new DatePicker(new Date('Jan 1, 2009'));<br><br>startDatePicker.show();<br>endDatePicker.show();

In this example, startDatePicker gets instantiated with a default date, but endDatePicker gets a different date 

passed in its &#8220;constructor&#8221;. You can see that both objects retain their own state when the show() functions get 

called and different dates are alerted.

**Practise**

You can do faux-namespaces in Javascript as well as faux-classes. I use them to package up related code and 

partition it, much as you might do with namespacing in other languages. There are a number of different ways of 

providing this functionality, and here&#8217;s one which is incredibly simple:

    var NAMESPACE = {};<br>NAMESPACE.utils = {};<br>NAMESPACE.interface = {}; // other namespaces<br><br>NAMESPACE.utils.fixIE = function() {<br>// code<br>}<br><br>NAMESPACE.utils.fixIE();

Other ways of organising your
  
javascript code can be pulled directly from C# best-practises, such as one-class-

per-file. Another beneficial approach is to avoid embedding your javascript code in your HTML. Code like this:

    <a href="/javascriptrequired.aspx" id="showPicker" onclick="showDatePicker();">Pick Date</a>

Can often be easier to maintain when written &#8220;unobtrusively&#8221;, with the following in a linked JS file:

    var document.getElementById('showPicker').onclick = showDatePicker;

And now this in your HTML:

    <a href="/javascriptrequired.aspx" id="showPicker" &gtPick Date</a>

This keeps your javascript confined to .js files and out of the HTML, which is generally a cleaner approach.

**Further Reading**

You can continue to develop well by [unit testing your javascript](http://www.jsunit.net/) and [documenting](http://jsdoc.sourceforge.net/) it fully. You can also [check it for errors](http://www.jslint.com/) and then [compress it](http://alex.dojotoolkit.org/shrinksafe/) for deployment. Javascript is an important tool in your arsenal; use it well!