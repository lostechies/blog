---
wordpress_id: 3338
title: Testing Your Code to Test Yourself
date: 2009-01-15T11:57:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2009/01/15/testing-your-code-to-test-yourself.aspx
dsq_thread_id:
  - "262174727"
categories:
  - Testing
redirect_from: "/blogs/chrismissal/archive/2009/01/15/testing-your-code-to-test-yourself.aspx/"
---
<img alt="A rhinoceros beetle (aka bug) - CraigPJ" style="float: right;margin-left: 15px;margin-right: 15px" src="//lostechies.com/chrismissal/files/2011/03/beetle.jpg" />

There was a time not too long ago when I was in the same company I work
  
for today. I got my work done, I completed the tasks/projects assigned
  
to me, I got paid and I enjoyed what I was doing. None of this has
  
changed by the way, I still like my job and doing what I do; I also get
  
paid to do it. During these earlier times (again, not all that long
  
ago) I also didn&#8217;t write tests for my code, it [<span style="text-decoration: underline">isn&#8217;t required</span>](http://servicexen.wordpress.com/2008/09/06/which-sdlc-model-to-choose-waterfall-slamdunk-spiral-evolutionary-stage-gate-rapid-prototype-agile-and-sync-stable/ "See: Slam Dunk Model") (See: Slam Dunk Model) to do so and my code worked; sure there were bugs, but [<span style="text-decoration: underline">all code has bugs</span>](http://elegantcode.com/2009/01/02/the-life-and-times-of-a-bug/) right?

My first introduction to unit testing my code was: &#8220;So this thing will notify me with a &#8216;fail&#8217; message if I change something else later that might make it stop working?? Oh that&#8217;s cool!&#8221; While I was sold once it [saved my butt](http://www.eekim.com/blog/2003/07/19/unittestsuccess), I quickly found out that writings tests can be hard. It&#8217;s hard if you&#8217;re new to it _AND_ you&#8217;re not required to write them _AND_ the code you wrote is very difficult to test. It gets easier though and as the tests get easier to write, the code your write will naturally become more testable.

<h3 style="padding-left: 30px">
  Testable code is is FAR BETTER than untestable code.
</h3>

Sorry for the bold and caps lock, sorry for beating a dead horse. If you&#8217;re reading this and you don&#8217;t feel the tone of horses getting beaten to death, I hope this will benefit you. When I wasn&#8217;t writing tests, it wasn&#8217;t because I was against it, it was because I was ignorant of the benefits of unit testing. When I wasn&#8217;t writing tests, it was as simple as somebody showing me
  
how to write a test. That&#8217;s what got me started and it has helped me
  
immensely.

<h3 style="padding-left: 30px">
  I used to not write tests. I also used to write bad code.
</h3>

There&#8217;s plenty of people out there who do test, if you&#8217;re one of them,
  
let me propose something. See if you can find somebody in your
  
organization, user group, group of friends, etc, who doesn&#8217;t write
  
tests, introduce it to them. It could be as simple as &#8220;Hey you should
  
look up writing unit tests.&#8221; or as much effort as you&#8217;re willing to
  
share with them.

Please note that this whole time I never mention that I write great code. I never even use the word good. To me it&#8217;s about [continuous improvement](http://en.wikipedia.org/wiki/Kaizen) and I can see the quality of my skills improving. For any questions you may have on the subject, I hope you find the following links helpful:

  * [When should I write tests?](http://stevenharman.net/blog/archive/2008/12/17/when-should-i-write-tests.aspx) &#8211; Always. I saw some code from [Scott Reynolds](/blogs/scottcreynolds/default.aspx) yesterday that could &#8220;save the world&#8221; 😉
  * Can you tell me more about [Writing Testable Code](http://www.softdevtube.com/?p=540)? &#8211; No, but [Misko Hevery](http://misko.hevery.com/) gives a [good presentation](http://www.softdevtube.com/?p=540)
  * [Does my code suck?](http://www.artima.com/weblogs/viewpost.jsp?thread=71730) &#8211; Probably. I know a lot of mine does!
  * Are there libraries to help me? &#8211; I use [NUnit](http://www.nunit.org/index.php) for .Net, which is built on [JUnit](http://www.junit.org/) for Java. There&#8217;s also [QUnit](http://docs.jquery.com/QUnit) if you want to test your JavaScript.

This just scratches the surface and I won&#8217;t get into Mocking or Isolation frameworks, but [you need to start somewhere](http://blog.typemock.com/2008/12/how-to-start-unit-testing.html) if you&#8217;re not doing so already. There&#8217;s plenty of similar blog posts out there to tell you that you should; this time around I just wanted to share why it&#8217;s important to me. Personally, it&#8217;s the second of the 2 strong quotes from above.

There&#8217;s plenty of people out there who do test, if you&#8217;re one of them, let me propose something. See if you can find somebody in your organization, user group, group of friends, etc, who doesn&#8217;t write tests, introduce it to them. It could be as simple as &#8220;Hey you should look up writing unit tests.&#8221; or as much effort as you&#8217;re willing to share with them. It was pretty simple to get me on board.