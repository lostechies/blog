---
wordpress_id: 9
title: IronPython how cool it is
date: 2009-05-28T05:08:00+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2009/05/28/ironpython-how-cool-it-is.aspx
dsq_thread_id:
  - "425624177"
categories:
  - IronPython
  - Python
---
Briefly, <a target="_blank" href="http://www.codeplex.com/IronPython">IronPython</a> is an implementation of Python in the .Net runtime. This allows you access to&nbsp; .Net framework goodness while programming in a dynamic language. The current stable version 2.0.1 maps to CPython 2.5.This allows me to do fun fun things like use my python project to access a c# project. follows is a python script using Pinsor and accessing a .net dll.

&nbsp;

C# code:

<pre><span style="background: #101010 none repeat scroll 0% 0%;color: #8ac5ff">public class </span><span style="background: #101010 none repeat scroll 0% 0%;color: #64b1ff">Command<br />    </span><span style="background: #101010 none repeat scroll 0% 0%;color: white">{<br />        </span><span style="background: #101010 none repeat scroll 0% 0%;color: #8ac5ff">private readonly </span><span style="background: #101010 none repeat scroll 0% 0%;color: #64b1ff">DoingStuff </span><span style="background: #101010 none repeat scroll 0% 0%;color: white">_stuff;<br /><br />        </span><span style="background: #101010 none repeat scroll 0% 0%;color: #8ac5ff">public </span><span style="background: #101010 none repeat scroll 0% 0%;color: white">Command (</span><span style="background: #101010 none repeat scroll 0% 0%;color: #64b1ff">DoingStuff </span><span style="background: #101010 none repeat scroll 0% 0%;color: white">stuff)<br />        {<br />            _stuff </span><span style="background: #101010 none repeat scroll 0% 0%;color: silver">= </span><span style="background: #101010 none repeat scroll 0% 0%;color: white">stuff;<br />        }<br />        </span><span style="background: #101010 none repeat scroll 0% 0%;color: #8ac5ff">public void </span><span style="background: #101010 none repeat scroll 0% 0%;color: white">Execute()<br />        {<br />            </span><span style="background: #101010 none repeat scroll 0% 0%;color: #64b1ff">Console</span><span style="background: #101010 none repeat scroll 0% 0%;color: silver">.</span><span style="background: #101010 none repeat scroll 0% 0%;color: white">WriteLine(_stuff</span><span style="background: #101010 none repeat scroll 0% 0%;color: silver">.</span><span style="background: #101010 none repeat scroll 0% 0%;color: white">Message);<br />        }<br />    }<br />    </span><span style="background: #101010 none repeat scroll 0% 0%;color: #8ac5ff">public class </span><span style="background: #101010 none repeat scroll 0% 0%;color: #64b1ff">DoingStuff<br />    </span><span style="background: #101010 none repeat scroll 0% 0%;color: white">{<br />        </span><span style="background: #101010 none repeat scroll 0% 0%;color: #8ac5ff">public string </span><span style="background: #101010 none repeat scroll 0% 0%;color: white">Message<br />        {<br />            </span><span style="background: #101010 none repeat scroll 0% 0%;color: #8ac5ff">get </span><span style="background: #101010 none repeat scroll 0% 0%;color: white">{ </span><span style="background: #101010 none repeat scroll 0% 0%;color: #8ac5ff">return </span><span style="background: #101010 none repeat scroll 0% 0%;color: #ff8040">"From the Doing Stuff Class, I'm doing stuff"</span><span style="background: #101010 none repeat scroll 0% 0%;color: white">; }<br />        }<br />    }</span></pre>

&nbsp;

&nbsp;

python code:

<pre><span style="background: #101010 none repeat scroll 0% 0%;color: white">from pinsor import *<br />import clr<br />clr.AddReference('csharpdemo')<br />from csharpdemo import *<br /><br /><br />kernel = PinsorContainer()<br />kernel.register( Component.oftype(DoingStuff),Component.oftype(Command).depends([DoingStuff])  )<br /><br />cmd = kernel.resolve(Command)<br />cmd.Execute()</span></pre>

<pre><span style="background: #101010 none repeat scroll 0% 0%;color: white"></span></pre>

[](http://11011.net/software/vspaste)[](http://11011.net/software/vspaste)

ouput is like:

<span style="color: #0000ff">C:ipyexmaple>&#8221;c:Program FilesIronPython 2.0.1ipy.exe&#8221; ipydemo.py</span>

<span style="color: #0000ff">From the Doing Stuff Class, I&#8217;m doing stuff</span>

<span style="color: #0000ff"></span>

I&rsquo;m sure you&rsquo;ll all asking yourselves &ldquo;what the heck&rdquo; so let me summarize:

  1. created c# dll
  2. placed a python script next to it named ipydemo.py
  3. in that script I imported the c# dll
  4. then I called my custom python IoC container Pinsor which is written in pure python
  5. added .Net objects to my python IoC container
  6. resolved a .Net object from my python IoC container
  7. then executed it with the expected results and dependencies.

When I did this test I stared at the screen completely stunned for a bit.&nbsp; Pinsor was very easy to implement, and it has some decent abilities considering its short life and my limited time.&nbsp; I doubt I could make the same thing in C# in twice as much time, and I&rsquo;m better in C#.&nbsp; This opens up some worlds for me.

With all this in mind has anyone had a chance to play with ironpython support in VS 2010?

Finally, I&rsquo;d like to thank <a target="_blank" href="http://www.voidspace.org.uk/cv.shtml">Micheal Foord</a> with his blog and book <a target="_blank" href="http://www.manning.com/foord/">IronPython In Action</a>. I highly recommend reading both if you&rsquo;re interested in quality programming, but especially if any of this intrigues you.