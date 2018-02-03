---
wordpress_id: 4384
title: 'Really silly things to do with C# expression trees'
date: 2011-11-02T23:37:52+00:00
author: Ryan Rauh
layout: post
wordpress_guid: http://lostechies.com/ryanrauh/?p=54
dsq_thread_id:
  - "460393489"
categories:
  - Functional Programming
tags:
  - csharp
  - Lisp
---
As you may remember from my last [post](http://lostechies.com/ryanrauh/2011/10/24/til-everything-in-lisp-is-a-function/) I&#8217;m current reading [Structure and Interpretation of Computer Programs](https://docs.google.com/a/fitorbit.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BxVCLS4f8Sg5OGUwMmZlZjYtZWQ4Zi00ZThmLWFkMjYtNTIxZmY4ODhjNDdl&hl=en&authkey=CLnyyF4&pli=1) as part of a study group we started during Pablo&#8217;s Fiesta. 

I continue to find Lisp to be a fascinating language especially this really interesting piece of code.

[gist id=&#8221;1309414&#8243; file=&#8221;a\_plus\_abs_b.ss&#8221;]

Ok so what&#8217;s going on here?

  * if b > 0 
      * return +
  * else 
      * return &#8211;

In my previous [post](http://lostechies.com/ryanrauh/2011/10/24/til-everything-in-lisp-is-a-function/) I demonstrated how you might implement this in javascript. Well I found it so interesting that I decided to find out if I could do it in C# as well. The following is my attempt at trying to return the + or &#8211; symbol from an if statement. 

[gist id=&#8221;1313071&#8243; file=&#8221;symbol\_from\_if2.cs&#8221;]

>  <img src="http://cl.ly/3b1n2i321K1H0h3p2N3G/trollface.jpg" width="64px" style="float:left;padding:0;margin:0;" />&#8220;Why would you write it this way when (insert code here) works better?&#8221; 

Shut up troll! I&#8217;m not telling anybody to go off and write their code in expression trees when the following code is clear the correct why to write it.

[gist id=&#8221;1313071&#8243; file=&#8221;easy_way.cs&#8221;]

See that&#8217;s way easier, but this isn&#8217;t a post about smart things to do with expression trees now is it?

Let&#8217;s up the silliness some more and make it an extension method just for fun.

[gist id=&#8221;1313071&#8243; file=&#8221;extension_method2.cs&#8221;]

I was having so much fun with this that I even roped some of my teammates in on it. Heres  [Chad Myers](http://lostechies.com/chadmyers/) solution. 

[gist id=&#8221;1313071&#8243; file=&#8221;chads.cs&#8221;]

So I think its cool that you can _kind of_ return + or &#8211; from an if statement, but what started as a fun little exercise turned into an amazing adventure into learning expression trees.

So as my final brain beating exercise I tried make this into a Func<int,int,int> completely build using expression trees.

[gist id=&#8221;1313071&#8243; file=&#8221;finally.cs&#8221;]

So here&#8217;s a little challenge. In the comment section I invite you to completely school me in the ways of Expression Trees. Try and come up with a way more awesome version of a\_plus\_abs_b using expression trees or IL or whatever awesome sauce is in the .NET framework that I&#8217;m not aware of.

Herp Derp, 

-Ryan