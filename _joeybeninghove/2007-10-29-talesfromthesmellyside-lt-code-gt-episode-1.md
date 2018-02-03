---
wordpress_id: 49
title: 'TalesFromTheSmellySide&lt;Code&gt; &#8211; Episode #1'
date: 2007-10-29T17:47:00+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/10/29/talesfromthesmellyside-lt-code-gt-episode-1.aspx
categories:
  - tales from the smelly side
---
#### What is this?

Well, it was inevitable that my long stint of greenfield projects was going
  
to come to end at some point, especially since I&#8217;m in the consulting world.&nbsp; So
  
now that I&#8217;m starting to find myself working in some pretty scary code bases
  
again, [my
  
fellow LosTechies dude](http://www.lostechies.com/blogs/joe_ocampo/default.aspx) suggested I start blogging about my experiences.&nbsp; 

And since I&#8217;ve already seen many, many things that make me say &#8220;huh?&#8221; and, at
  
times, brings tears to my eyes, I figured I&#8217;d give this first&nbsp;post a number
  
(assuming there are many more coming).

_Ok, so really this is just an opportunity for my fellow developers to
  
perhaps not feel so bad about the code bases they are working in, because maybe,
  
just maybe, someone else out there has it worse.&nbsp; (As I&#8217;m sure there are folks
  
who are forced to work in stinkier code than I&#8230;)_

In order to make these somewhat useful, I&#8217;m making them all about the code.&nbsp;
  
Smells that I see, and&nbsp;hopefully some&nbsp;simple solutions for fixing them, leading
  
to more maintainable and readable code.

#### Episode #1

<div>
  <pre><span>catch</span> (Exception ex)<br />{<br />    <span>if</span> (ex.GetBaseException().Message.Contains(<span>"You gotta know this just *feels* wrong!"</span>))<br />    {<br />        <span>// do something</span><br />    }<br />}</pre>
</div>

This one definitely had me scratching my head.&nbsp; I can honestly say this is
  
the first time I&#8217;ve ever seen a conditional expression based on&nbsp;the actual
  
string message on an exception.&nbsp; &nbsp;Scary, is it not?

Of course the first way to correct this smell that jumped out at me was just
  
to simply create a custom exception and catch it in its own catch block.

<div>
  <pre><span>catch</span> (SomeCustomException ex)<br />{<br />    <span>// do something</span><br />}</pre>
</div>

&nbsp;

**What kind of smelly exception-related code have you seen and
  
corrected?**

&nbsp;
