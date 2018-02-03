---
wordpress_id: 8
title: NUnit Behavior Driven Development
date: 2007-03-06T03:39:00+00:00
author: Joe Ocampo
layout: post
wordpress_guid: /blogs/joe_ocampo/archive/2007/03/05/nunit-behavior-driven-development.aspx
dsq_thread_id:
  - "262086259"
categories:
  - BDD (Behavior Driven Development)
---
<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">I know it has been a while since I posted but I have been working on several projects lately one of which involves </FONT><A href="http://behaviour-driven.org/"><FONT face="Calibri" size="3">Behavior Driven Development</FONT></A><FONT face="Calibri" color="#000000" size="3">.</FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">I am enamored about the concept with BDD. I strongly believe it is a natural evolution of the TDD movement.<SPAN>&nbsp; </SPAN>Having practiced TDD over the last 3 years there have been many times where I have questioned how to test a certain component.<SPAN>&nbsp; </SPAN>The reason is as a developer I am focused on the Test and not the why.<SPAN>&nbsp; </SPAN>BDD’s expressiveness allows me to elucidate the why.</FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">Having had several conversations about BDD with of my colleagues, the misconception is that you simply replace [TestFixture] attribute with [Context] and replace all the [Test] attributes with [Spec].<SPAN>&nbsp; </SPAN>This cannot be further from the truth.</FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">The key concepts we must focus on are “context” and “expressive test names”.<SPAN>&nbsp; </SPAN>Just as Eric Evans gave us the concept of modeling an object model using a ubiquitous language based on the business domain.<SPAN>&nbsp; </SPAN>We as developers must focus on the contextual expression of the behavior of our object model as<SPAN>&nbsp; </SPAN>it relates to the business domain.</FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">At work I have begun to incorporate </FONT><A href="http://dannorth.net/introducing-bdd"><FONT face="Calibri" size="3">Dan North’s concept of the (Given, When, Then)</FONT></A><FONT face="Calibri" color="#000000" size="3"> template structures for acceptance test.<SPAN>&nbsp; </SPAN>So far there has been some hesitation on fully adopting these concepts.<SPAN>&nbsp; </SPAN>I believe it is more of a cultural constraint than anything else but like all change, you should always expect some resistance.<SPAN>&nbsp; </SPAN>Let’s examine the (Given, When, Then) constructs.<SPAN>&nbsp; </SPAN>I am taking the scenarios from the </FONT><A href="http://rspec.rubyforge.org/tutorials/stack_04.html"><FONT face="Calibri" size="3">RSpec tutorials</FONT></A><FONT face="Calibri" color="#000000" size="3"> so the concepts can flow easier.</FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3"></FONT>&nbsp;
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT color="#000000"><FONT face="Calibri"><B>Given</B> some initial context (the givens),</FONT></FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT color="#000000"><FONT face="Calibri"><B>When</B> and even occurs (the why),</FONT></FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT color="#000000"><FONT face="Calibri"><B>Then</B> ensure some outcome (the test)</FONT></FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">&nbsp;</FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">Example:</FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT color="#000000"><FONT face="Calibri"><B>Given</B> A new stack</FONT></FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT color="#000000"><FONT face="Calibri"><B>When</B> the new stack is created </FONT></FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT color="#000000"><FONT face="Calibri"><B>Then</B> it should be empty</FONT></FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">&nbsp;</FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">Now I strongly believe in reuse and having used NUnit over that pass 2 years and having invested in over 4200 units test in our architecture, I was not about to start using a new framework just for BDD.<SPAN>&nbsp; </SPAN>Oh what do…<SPAN>&nbsp; </SPAN>Luckily NUnit is extensible.<SPAN>&nbsp; </SPAN>Through the magic of the NUnit.Core.Extensions namespace I was able to incorporate my own attributes of “Context” and “Spec” into the test runner. Sweet!!!!<SPAN>&nbsp; </SPAN>This allowed me to utilize my entire TDD test suite and start using BDD.<SPAN>&nbsp; </SPAN>Not to mention I didn’t have to do anything with NAnt or CruiseControl.</FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">So I came up with the following test.</FONT>
</P>

<SPAN><SPAN><br /> 

<P class="MsoNormal">
  <SPAN>namespace</SPAN><SPAN><FONT color="#000000"> Domain.Tests.Stack</FONT></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><FONT color="#000000">{</FONT></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>Context</SPAN><FONT color="#000000">]</FONT></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>class</SPAN><FONT color="#000000"> </FONT><SPAN>ANewStack</SPAN></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>private</SPAN><FONT color="#000000"> </FONT><SPAN>Stack</SPAN><FONT color="#000000"><</FONT><SPAN>int</SPAN><FONT color="#000000">> stack;</FONT></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><FONT color="#000000">&nbsp;</FONT></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>SetUp</SPAN><FONT color="#000000">]</FONT></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>void</SPAN><FONT color="#000000"> SetUp()</FONT></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>stack = </FONT><SPAN>new</SPAN><FONT color="#000000"> </FONT><SPAN>Stack</SPAN><FONT color="#000000"><</FONT><SPAN>int</SPAN><FONT color="#000000">>();</FONT></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><FONT color="#000000">&nbsp;</FONT></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>Spec</SPAN><FONT color="#000000">]</FONT></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>void</SPAN><FONT color="#000000"> ShouldBeEmpty()</FONT></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Assert</SPAN><FONT color="#000000">.IsEmpty(stack, </FONT><SPAN>&#8221; is not empty&#8221;</SPAN><FONT color="#000000">);</FONT></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><FONT color="#000000">}</FONT></SPAN>
</P>

<br /> 

<P>
  <IMG src="http://blog.agilejoe.com/content/binary/nunitbdd.jpg" /></SPAN></SPAN>
</P>

<SPAN><br /> 

<P>
  <FONT size="3"><FONT face="Calibri"><SPAN>Lets talk about the above code.<SPAN>&nbsp; </SPAN>Lets talk old school, Red, Green, Refactor.<SPAN>&nbsp; </SPAN>The concepts still apply but for the sake of this post I am already in the green state so you missed the most important part of the BDD experience.<SPAN>&nbsp;&nbsp; </SPAN>Remember I mentioned earlier about “</SPAN>expressive test names”, well when the test first failed this was the error message in the Test Runner.</FONT></FONT>
</P>

<br /> 

<P>
  <FONT face="Calibri" size="3">&nbsp;</FONT>
</P>

<br /> 

<P>
  <FONT face="Calibri" size="3">Domain.Tests.Stack.ANewStack.ShouldBeEmpty: is not empty</FONT>
</P>

<br /> 

<P>
  <FONT face="Calibri" size="3">&nbsp;</FONT>
</P>

<br /> 

<P>
  <FONT face="Calibri" size="3">This error message conveys several key concepts.</FONT>
</P>

<br /> 

<P>
  <SPAN><SPAN><FONT face="Calibri" size="3">1.</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">We are dealing with the Stack object</FONT>
</P>

<br /> 

<P>
  <SPAN><SPAN><FONT face="Calibri" size="3">2.</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">The context is a new stack</FONT>
</P>

<br /> 

<P>
  <SPAN><SPAN><FONT face="Calibri" size="3">3.</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">Since it is a new stack is should be empty</FONT>
</P>

<br /> 

<P>
  <SPAN><SPAN><FONT face="Calibri" size="3">4.</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">But it’s not.</FONT>
</P>

<br /> 

<P>
  <FONT face="Calibri" size="3">So at this point I created the stack and made the test pass.</FONT>
</P>

<br /> 

<P>
  <FONT face="Calibri" size="3">Here is my proposal in using NUnit and BDD.</FONT>
</P>

<br /> 

<P>
  <SPAN><SPAN><FONT size="3">·</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">Utilize the Namespace to categorize the domain entities</FONT>
</P>

<br /> 

<P>
  <SPAN><SPAN><FONT size="3">·</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">The class names should convey the context of the specification you are asserting.</FONT>
</P>

<br /> 

<P>
  <SPAN><SPAN><FONT size="3">·</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">The method name should convey the specification you are asserting.</FONT>
</P>

<br /> 

<P>
  <SPAN><SPAN><FONT size="3">·</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">If possible use the NUnit.Core.Extensions.BDD to decorate the class structure with “Context” and “Spec” attributes.</FONT>
</P>

<br /> 

<P>
  <FONT face="Calibri" size="3">Below is the final state of the test suite using BDD.</FONT>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN>using</SPAN><SPAN> System;</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN>using</SPAN><SPAN> System.Collections.Generic;</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN>using</SPAN><SPAN> NUnit.Core.Extensions;</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN>using</SPAN><SPAN> NUnit.Framework;</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN>using</SPAN><SPAN> NUnit.Framework.Extensions;</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN>&nbsp;</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN>namespace</SPAN><SPAN> Domain.Tests.Stack</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN>{</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>[<SPAN>Context</SPAN>]</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp; </SPAN><SPAN>public</SPAN> <SPAN>class</SPAN> <SPAN>ANewStack</SPAN></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>{</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN><SPAN>private</SPAN> <SPAN>Stack</SPAN><<SPAN>int</SPAN>> stack;</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN>&nbsp;</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[<SPAN>SetUp</SPAN>]</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN><SPAN>public</SPAN> <SPAN>void</SPAN> SetUp()</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>stack = <SPAN>new</SPAN> <SPAN>Stack</SPAN><<SPAN>int</SPAN>>();</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN>&nbsp;</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[<SPAN>Spec</SPAN>]</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN><SPAN>public</SPAN> <SPAN>void</SPAN> ShouldBeEmpty()</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN><SPAN>Assert</SPAN>.IsEmpty(stack, <SPAN>&#8221; is not empty&#8221;</SPAN>);</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN>&nbsp;</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN>&nbsp;</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[<SPAN>Spec</SPAN>]</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN><SPAN>public</SPAN> <SPAN>void</SPAN> ShouldNotBeEmptyAfterPush()</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>stack.Push(1);</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN><SPAN>Assert</SPAN>.IsNotEmpty(stack,<SPAN>&#8221; is empty&#8221;</SPAN>);</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN>&nbsp;</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>}</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN>&nbsp;</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>[<SPAN>Context</SPAN>]</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp; </SPAN><SPAN>public</SPAN> <SPAN>class</SPAN> <SPAN>AStackWithOneItem</SPAN></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>{</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN><SPAN>private</SPAN> <SPAN>Stack</SPAN><<SPAN>int</SPAN>> stack;</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN>&nbsp;</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[<SPAN>SetUp</SPAN>]</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN><SPAN>public</SPAN> <SPAN>void</SPAN> SetUp()</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>stack = <SPAN>new</SPAN> <SPAN>Stack</SPAN><<SPAN>int</SPAN>>();</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN>&nbsp;</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[<SPAN>Spec</SPAN>]</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN><SPAN>public</SPAN> <SPAN>void</SPAN> ShouldReturnTopWhenYouPop()</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>stack.Push(1);</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN><SPAN>Assert</SPAN>.AreEqual(1, stack.Pop(), <SPAN>&#8220;error when popping&#8221;</SPAN>);</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>}</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN>&nbsp;</SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN><SPAN>&nbsp;&nbsp;&nbsp; </SPAN></SPAN>
</P>

<br /> 

<P class="MsoNormal">
  <SPAN>}</SPAN>
</P>

<br /> 

<P>
  <FONT face="Calibri" size="3">To push the envelope even further once the .Net 3.5 framework is released it makes perfect sense to incorporate the </FONT><A href="http://codebetter.com/blogs/scott.bellware/archive/category/1293.aspx"><FONT face="Calibri" size="3">extensions that Scott Bellware</FONT></A><FONT face="Calibri" size="3"> has created for BDD.</FONT>
</P>

<br /> 

<P>
  <FONT face="Calibri" size="3">&nbsp;</FONT>
</P>

<br /> 

<P>
  <FONT face="Calibri" size="3">I plan to make the NUnit BDD extensions available I am just tweaking them before I host them on Google.</FONT>
</P>

<br /> 

<P>
  <BR />&nbsp;
</P></SPAN></p>