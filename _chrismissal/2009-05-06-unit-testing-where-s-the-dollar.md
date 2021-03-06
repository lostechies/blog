---
wordpress_id: 3350
title: Unit Testing “Where’s The Dollar?”
date: 2009-05-06T13:46:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2009/05/06/unit-testing-where-s-the-dollar.aspx
dsq_thread_id:
  - "262174968"
categories:
  - For Fun
  - Testing
redirect_from: "/blogs/chrismissal/archive/2009/05/06/unit-testing-where-s-the-dollar.aspx/"
---
I was given the following riddle today. I thought I&rsquo;d right a unit test in C# to &ldquo;prove&rdquo; it.

> _Three guys enter a hotel to stay for a night.&nbsp; The desk clerk tells them that one room is $30 per night.&nbsp; This is perfect as there are three men &#8212; they each decide to pay $10 a piece.&nbsp; They each pay the money and head to their room.&nbsp; A few minutes later, the clerk realizes his mistake as there is a special on rooms that week and they are only $25 a night.&nbsp; He gathers the five dollars and gives it to the bellboy to return to the men.&nbsp; As the bellboy is riding the elevator, he thinks &#8220;There&#8217;s three men and five dollars, they&#8217;ll never be able to split it equally.&nbsp; I&#8217;ll just keep two and they can have three to split equally.&#8221;&nbsp; He keeps two dollars for himself and gives each of the men $1 dollar in return.&nbsp; Here&#8217;s the fun.&nbsp; You have three men who paid 10 dollars a piece and received one dollar back&#8230;.this means they each paid nine dollars.&nbsp; The bellboy kept two dollars for himself.&nbsp; So, nine x 3 equals 27 plus the 2 dollars the bellboy kept equals 29 dollars &#8212; where&#8217;s the missing dollar?_

The quirk here is that there is one dollar unaccounted for. I wrote a unit test that proves in fact that there is a dollar missing. Therefore, this riddle has no answer.

<pre style="background: black"><span style="background: black none repeat scroll 0% 0%;color: white">[</span><span style="background: black none repeat scroll 0% 0%;color: yellow">Test</span><span style="background: black none repeat scroll 0% 0%;color: white">]<br /></span><span style="background: black none repeat scroll 0% 0%;color: #ff8000">public void </span><span style="background: black none repeat scroll 0% 0%;color: white">Wheres_the_dollar()<br />{<br />    </span><span style="background: black none repeat scroll 0% 0%;color: lime">// Initial Transaction<br />    </span><span style="background: black none repeat scroll 0% 0%;color: #ff8000">var </span><span style="background: black none repeat scroll 0% 0%;color: white">FrontDesk = 30;<br />    </span><span style="background: black none repeat scroll 0% 0%;color: #ff8000">var </span><span style="background: black none repeat scroll 0% 0%;color: white">GuyOne = 10;<br />    </span><span style="background: black none repeat scroll 0% 0%;color: #ff8000">var </span><span style="background: black none repeat scroll 0% 0%;color: white">GuyTwo = 10;<br />    </span><span style="background: black none repeat scroll 0% 0%;color: #ff8000">var </span><span style="background: black none repeat scroll 0% 0%;color: white">GuyThree = 10;<br />    </span><span style="background: black none repeat scroll 0% 0%;color: yellow">Assert</span><span style="background: black none repeat scroll 0% 0%;color: white">.That(GuyOne + GuyTwo + GuyThree, </span><span style="background: black none repeat scroll 0% 0%;color: yellow">Is</span><span style="background: black none repeat scroll 0% 0%;color: white">.EqualTo(30));<br /><br />    </span><span style="background: black none repeat scroll 0% 0%;color: lime">// Correction<br />    </span><span style="background: black none repeat scroll 0% 0%;color: #ff8000">var </span><span style="background: black none repeat scroll 0% 0%;color: white">BellBoy = 5;<br />    FrontDesk -= 5;<br />    </span><span style="background: black none repeat scroll 0% 0%;color: yellow">Assert</span><span style="background: black none repeat scroll 0% 0%;color: white">.That(GuyOne + GuyTwo + GuyThree - BellBoy, </span><span style="background: black none repeat scroll 0% 0%;color: yellow">Is</span><span style="background: black none repeat scroll 0% 0%;color: white">.EqualTo(FrontDesk));<br /><br />    </span><span style="background: black none repeat scroll 0% 0%;color: lime">// Reimbursement<br />    </span><span style="background: black none repeat scroll 0% 0%;color: white">BellBoy -= 3;<br />    GuyOne -= 1;<br />    GuyTwo -= 1;<br />    GuyThree -= 1;<br /><br />    </span><span style="background: black none repeat scroll 0% 0%;color: yellow">Assert</span><span style="background: black none repeat scroll 0% 0%;color: white">.That(BellBoy + GuyOne + GuyTwo + GuyThree, </span><span style="background: black none repeat scroll 0% 0%;color: yellow">Is</span><span style="background: black none repeat scroll 0% 0%;color: white">.EqualTo(29));<br />}<br /></span></pre>

[](http://11011.net/software/vspaste)

The test passes, but obviously $30 cannot be turned into $29 without each bill&rsquo;s location explained. Where is the flaw? Is it in the riddle, in the code, or in both?

_Note: Consider this an exercise in turning real-world situations into code. 😉_