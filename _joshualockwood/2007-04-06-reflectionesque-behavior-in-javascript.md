---
wordpress_id: 13
title: Reflectionesque behavior in JavaScript
date: 2007-04-06T22:53:00+00:00
author: Joshua Lockwood
layout: post
wordpress_guid: /blogs/joshua_lockwood/archive/2007/04/06/reflectionesque-behavior-in-javascript.aspx
categories:
  - JavaScript
  - jscript
  - scripting
redirect_from: "/blogs/joshua_lockwood/archive/2007/04/06/reflectionesque-behavior-in-javascript.aspx/"
---
&nbsp;


  


Here&#8217;s a little something in my continued investigation of JavaScript and its many wonders (man, that sounds strange!)&#8230;
  


Okay, so for today&#8217;s topic I&#8217;ll look at some &#8216;reflectionesque&#8217; behavior of JavaScript.&nbsp; As many know, the class Object can be used as an associative array.&nbsp; For instance:
  


var myvar = new Object();  
myvar[&#8220;value1&#8221;] = 42;  
assert(42, myvar[&#8220;value1&#8221;]);&nbsp; //would be true
  


What many may not know is that objects will behave as associative array whether we like it or not.&nbsp; Properties (fields or functions) that we add to an object&#8217;s prototype will show up in a foreach construct if we iterate over an object.&nbsp; This means that we could iterate over an object to see what&#8217;s supported by its prototype/interface&#8230;sort of like reflection in .Net.&nbsp; This can be helpful if we want to ensure that a property is supported by a given instance.&nbsp; If it&#8217;s not supported we can either inject the property/function at runtime so that the object doesn&#8217;t cause any problems or we could bypass behavior that depends on the property.&nbsp; Also, we could take disparate classes that support the same &#8220;interface&#8221; and apply polymorphic ideas.&nbsp; In the example I show an attempt at getting the value of the &#8216;name&#8217; property from three different classes.
  


So that joe has something to play with, I&#8217;ve attached a script file called [reflectionesque.js (zipped)](http://www.lostechies.com/files/folders/examplesource/entry111.aspx) that illustrates some of this.&nbsp;&nbsp;I&#8217;ve also attached a screen shot that shows the output:
  


<IMG height="448" src="http://lostechies.com/joshualockwood/files/2011/03ReflectionesquebehaviorinJavaScript_13309/clip_image002[2][2].jpg" width="450" />