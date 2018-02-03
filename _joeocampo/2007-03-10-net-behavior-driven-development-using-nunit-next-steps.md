---
wordpress_id: 11
title: .Net Behavior Driven Development Using NUnit—Next Steps
date: 2007-03-10T03:35:00+00:00
author: Joe Ocampo
layout: post
wordpress_guid: /blogs/joe_ocampo/archive/2007/03/09/net-behavior-driven-development-using-nunit-next-steps.aspx
dsq_thread_id:
  - "262090229"
categories:
  - BDD (Behavior Driven Development)
---
<P class="MsoNormal">
  <A href="http://www.ayende.com/default.aspx"><FONT face="Calibri" size="3">Oren Eini</FONT></A><FONT face="Calibri" color="#000000" size="3"> left a comment on a recent </FONT><A href="http://blog.agilejoe.com/PermaLink,guid,ed4400d1-b36a-4dd4-a2ff-fa375bcfa71d.aspx"><FONT face="Calibri" size="3">post</FONT></A><FONT face="Calibri" color="#000000" size="3"> I did on Behavior Driven Development.<SPAN>&nbsp; </SPAN>At first the questions seemed very easy and I thought I would be able to answer it within 15 minutes but as pondered the different possibilities of answering the question, I wanted to make sure that I gave an answer that was true to BDD as it relates to C#.<SPAN>&nbsp; </SPAN>A day later, I finally came up with one but in the process I learned a great deal about the value of “context” and “behavior”, so I wanted to take this time to share what I have learned.</FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">The questions Oren asked:</FONT>
</P>


  


<P class="MsoQuote">
  <EM><FONT size="3"><FONT face="Calibri" color="#000000">How would you handle a case such as:<BR />The entity is valid IFF:<BR />&#8211; The name is not empty<BR />&#8211; The Date is greater than last year<BR />&#8211; At least one of the following contact methods must be filled (phone, mobile, email)</FONT></FONT></EM>
</P>


  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">Seems pretty easy right?<SPAN>&nbsp; </SPAN>Well let’s take from a TDD perspective first.</FONT>
</P>


  


## <FONT face="Calibri" color="#17365d" size="4">Test Driven Development</FONT>


  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">This is a pretty basic test but let’s examine its structure more than what it is asserting.</FONT>
</P>

<SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>TestFixture</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>class</SPAN><FONT color="#000000"> </FONT><SPAN>PersonValidatorTest</SPAN></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>Test</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>void</SPAN><FONT color="#000000"> ValidateThePersonWhenEmpty()</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Person</SPAN><FONT color="#000000"> person = </FONT><SPAN>new</SPAN><FONT color="#000000"> </FONT><SPAN>Person</SPAN><FONT color="#000000">();</FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Name = </FONT><SPAN>null</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.WhatEverDate = </FONT><SPAN>DateTime</SPAN><FONT color="#000000">.Today.Subtract(</FONT><SPAN>new</SPAN><FONT color="#000000"> </FONT><SPAN>TimeSpan</SPAN><FONT color="#000000">(362));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Phone = </FONT><SPAN>null</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Mobile = </FONT><SPAN>null</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Email = </FONT><SPAN>null</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Assert</SPAN><FONT color="#000000">.IsFalse(</FONT><SPAN>PersonValidator</SPAN><FONT color="#000000">.IsValid(person));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN>
  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">What can we gather from this test?</FONT>
</P>


  


<P class="MsoListParagraphCxSpFirst">
  <FONT color="#000000"><SPAN><SPAN><FONT size="3">·</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">We know from the test fixture name that this class contains test about the PersonValidator class</FONT></FONT>
</P>


  


<P class="MsoListParagraphCxSpMiddle">
  <FONT color="#000000"><SPAN><SPAN><FONT size="3">·</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">We know that the test has to do with validating the person object when it is empty</FONT></FONT>
</P>


  


<P class="MsoListParagraphCxSpMiddle">
  <FONT color="#000000"><SPAN><SPAN><FONT size="3">·</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">We know that the test sets up a person object and sets all the accessors to null and sets the date property to 1 year from today</FONT></FONT>
</P>


  


<P class="MsoListParagraphCxSpLast">
  <FONT color="#000000"><SPAN><SPAN><FONT size="3">·</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">We know that the test call the IsValid static method on the PersonValidator objects and asserts that the result is false</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">Hmm… There is a lot going on here in this simple test.<SPAN>&nbsp; </SPAN>But can anyone tell me “Why?” you are doing this test?<SPAN>&nbsp; </SPAN>Why are you asserting that the PersonValidator specification validates the Person object?<SPAN>&nbsp; </SPAN>You may know implicitly why you are creating this test but a year later would you know why?<SPAN>&nbsp; </SPAN>Ok maybe I am getting a little too deep here but the premise is we have lost something during TDD.</FONT>
</P>


  


## <FONT face="Calibri" color="#17365d" size="4">So how do we clarify the test to know the “Why”</FONT>


  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">I am going to have to expand on Oren’s question a little to gain greater incite.</FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">Taking a cue from </FONT><A href="http://dannorth.net/introducing-bdd"><FONT face="Calibri" size="3">Dan North</FONT></A><FONT face="Calibri" color="#000000" size="3"> again, we use the following template:</FONT>
</P>

<FONT face="Calibri" color="#000000" size="3">&nbsp;</FONT>**_<U><FONT size="3"><FONT color="#000000"><FONT face="Calibri">Scenario 1: Person information is filled in</FONT></FONT></FONT></U>_**
  


<P class="MsoNormal">
  <FONT size="3"><FONT color="#000000"><FONT face="Calibri"><B>Given</B> the user has filled out a person’s information</FONT></FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT color="#000000"><FONT face="Calibri"><B>When</B> the user is about to save the persons information</FONT></FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT color="#000000"><FONT face="Calibri"><B>Then</B> make sure the name is not empty</FONT></FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT color="#000000"><FONT face="Calibri"><B><I>and</I></B> the date is greater than the last year</FONT></FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT size="3"><FONT color="#000000"><FONT face="Calibri"><B><I>and</I></B> at least one of the following contact fields must be filled in (Phone, Mobile, Email)</FONT></FONT></FONT>
</P>

<FONT face="Calibri" color="#000000" size="3">&nbsp;</FONT>
  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">Let’s see how we would write a specification that captures the behavior of PersonValidator.<SPAN>&nbsp; </SPAN>Consider the following:</FONT>
</P>

<SPAN>namespace</SPAN><SPAN><FONT color="#000000"> Domain.PersonValidatorSpecifcation</FONT></SPAN><SPAN><FONT color="#000000">{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>TestFixture</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>class</SPAN><FONT color="#000000"> </FONT><SPAN>APersonWithInformationFilledIn</SPAN></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>Test</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>void</SPAN><FONT color="#000000"> MakeSureTheNameIsNotEmpty()</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><FONT color="#000000"><SPAN>}</SPAN><SPAN></SPAN></FONT>
  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">This BDD example gives us quite a bit of information.</FONT>
</P>


  


<P class="MsoListParagraphCxSpFirst">
  <FONT color="#000000"><SPAN><SPAN><FONT size="3">·</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">According to the namespace all of the “contexts” in this file deal with the PersonValidator object </FONT></FONT>
</P>


  


<P class="MsoListParagraphCxSpMiddle">
  <FONT color="#000000"><SPAN><SPAN><FONT size="3">·</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">We look at the test fixture to determine the context, in this case it is “A person with information filled in”</FONT></FONT>
</P>


  


<P class="MsoListParagraphCxSpLast">
  <FONT color="#000000"><SPAN><SPAN><FONT size="3">·</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">The first specification “Make sure the name is not empty”</FONT></FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">So let’s read it as if it would appear in the test runner:</FONT>
</P>

_<FONT size="3"><FONT color="#000000"><FONT face="Calibri">Domain.PersonValidatorSpecificaton.APersonWithInformationFilledIn.MakeSureTheNameIsNotEmpty</FONT></FONT></FONT>_
  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">I don’t know about you but that doesn’t read well to me, it needs to more explicit about why we need this specification.<SPAN>&nbsp; </SPAN>Remember we are declaring the Person object invalid if it is in this context. Does the spec name explain that concept? How about this?</FONT>
</P>

_<FONT size="3"><FONT color="#000000"><FONT face="Calibri">Domain.PersonValidatorSpecificaton.APersonWithInformationFilledIn.ShouldBeInValidIfTheNameIsBlank</FONT></FONT></FONT>_
  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">That’s much better.</FONT>
</P>


  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">So now the code reads like this:</FONT>
</P>

<SPAN>namespace</SPAN><SPAN><FONT color="#000000"> Domain.PersonValidatorSpecifcation</FONT></SPAN><SPAN><FONT color="#000000">{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>TestFixture</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>class</SPAN><FONT color="#000000"> </FONT><SPAN>APersonWithInformationFilledIn</SPAN></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>Test</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>void</SPAN><FONT color="#000000"> ShouldBeInValidIfTheNameIsBlank()</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><FONT color="#000000"><SPAN>}</SPAN><SPAN></SPAN></FONT>
  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">So like traditional TDD you go through the first two phases “Red”, “Green” But let’s talk about the “Refactoring” exercise.<SPAN>&nbsp; </SPAN>(I am not going to go into the actual validator code let’s just assume it does what it says.)</FONT>
</P>

<SPAN>namespace</SPAN><SPAN><FONT color="#000000"> Domain.PersonValidatorSpecifcation</FONT></SPAN><SPAN><FONT color="#000000">{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>TestFixture</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>class</SPAN><FONT color="#000000"> </FONT><SPAN>APersonWithInformationFilledIn</SPAN></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>Test</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>void</SPAN><FONT color="#000000"> ShouldBeInValidIfTheNameIsBlank()</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Person</SPAN><FONT color="#000000"> person = </FONT><SPAN>new</SPAN><FONT color="#000000"> </FONT><SPAN>Person</SPAN><FONT color="#000000">();</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Name = </FONT><SPAN>null</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.WhatEverDate = </FONT><SPAN>DateTime</SPAN><FONT color="#000000">.Today.Subtract(</FONT><SPAN>TimeSpan</SPAN><FONT color="#000000">.FromDays(367));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Phone = </FONT><SPAN>null</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Mobile = </FONT><SPAN>null</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Email = </FONT><SPAN>null</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Assert</SPAN><FONT color="#000000">.IsFalse(</FONT><SPAN>PersonValidator</SPAN><FONT color="#000000">.IsValid(person));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><FONT color="#000000"><SPAN>}</SPAN><SPAN></SPAN></FONT>
  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">This test works as is but this isn’t the only specification we are going to write and I don’t want to create the Person object every time. So let’s refactor. Remember unlike traditional TDD we are asserting within a context in BDD.<SPAN>&nbsp; </SPAN>The context of this fixture is “A person with information filled in” so we need to “SetUp” the context.</FONT>
</P>

<SPAN>namespace</SPAN><SPAN><FONT color="#000000"> Domain.PersonValidatorSpecifcation</FONT></SPAN><SPAN><FONT color="#000000">{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>TestFixture</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>class</SPAN><FONT color="#000000"> </FONT><SPAN>APersonWithInformationFilledIn</SPAN></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>private</SPAN><FONT color="#000000"> </FONT><SPAN>Person</SPAN><FONT color="#000000"> person; </FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>SetUp</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>void</SPAN><FONT color="#000000"> SetUp()</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person = </FONT><SPAN>new</SPAN><FONT color="#000000"> </FONT><SPAN>Person</SPAN><FONT color="#000000">();</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Name = </FONT><SPAN>null</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.WhatEverDate = </FONT><SPAN>DateTime</SPAN><FONT color="#000000">.Today.Subtract(</FONT><SPAN>TimeSpan</SPAN><FONT color="#000000">.FromDays(367));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Phone = </FONT><SPAN>null</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Mobile = </FONT><SPAN>null</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Email = </FONT><SPAN>null</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>Test</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>void</SPAN><FONT color="#000000"> ShouldBeInValidIfTheNameIsBlank()</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Assert</SPAN><FONT color="#000000">.IsFalse(</FONT><SPAN>PersonValidator</SPAN><FONT color="#000000">.IsValid(person));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><SPAN><FONT color="#000000">}</FONT></SPAN>
  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">Well that’s a lot better but wait a minute.<SPAN>&nbsp; </SPAN>The context reads “A person with information filled in” according to our setup there isn’t anything filled in.<SPAN>&nbsp; </SPAN>We must stay true to the context. So let’s continue to refactor.</FONT>
</P>

<SPAN>namespace</SPAN><SPAN><FONT color="#000000"> Domain.PersonValidatorSpecifcation</FONT></SPAN><SPAN><FONT color="#000000">{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>TestFixture</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>class</SPAN><FONT color="#000000"> </FONT><SPAN>APersonWithInformationFilledIn</SPAN></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>private</SPAN><FONT color="#000000"> </FONT><SPAN>Person</SPAN><FONT color="#000000"> person; </FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>SetUp</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>void</SPAN><FONT color="#000000"> SetUp()</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person = </FONT><SPAN>new</SPAN><FONT color="#000000"> </FONT><SPAN>Person</SPAN><FONT color="#000000">();</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Name = </FONT><SPAN>&#8220;Joe Smith&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.WhatEverDate = </FONT><SPAN>DateTime</SPAN><FONT color="#000000">.Today.Subtract(</FONT><SPAN>TimeSpan</SPAN><FONT color="#000000">.FromDays(367));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Phone = </FONT><SPAN>&#8220;555-5555&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Mobile = </FONT><SPAN>&#8220;555-5555&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Email = </FONT><SPAN>&#8220;555-5555&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>Test</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>void</SPAN><FONT color="#000000"> ShouldBeInValidIfTheNameIsBlank()</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Assert</SPAN><FONT color="#000000">.IsFalse(</FONT><SPAN>PersonValidator</SPAN><FONT color="#000000">.IsValid(person);</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><FONT color="#000000"><SPAN>}</SPAN><SPAN></SPAN></FONT>
  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">Much better but wait, you run the unit test and it fails. You need to clear the Name property since this is what you are specifying on.</FONT>
</P>

<SPAN>namespace</SPAN><SPAN><FONT color="#000000"> Domain.PersonValidatorSpecifcation</FONT></SPAN><SPAN><FONT color="#000000">{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>TestFixture</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>class</SPAN><FONT color="#000000"> </FONT><SPAN>APersonWithInformationFilledIn</SPAN></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>private</SPAN><FONT color="#000000"> </FONT><SPAN>Person</SPAN><FONT color="#000000"> person; </FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>SetUp</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>void</SPAN><FONT color="#000000"> SetUp()</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person = </FONT><SPAN>new</SPAN><FONT color="#000000"> </FONT><SPAN>Person</SPAN><FONT color="#000000">();</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Name = </FONT><SPAN>&#8220;Joe Smith&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.WhatEverDate = </FONT><SPAN>DateTime</SPAN><FONT color="#000000">.Today.Subtract(</FONT><SPAN>TimeSpan</SPAN><FONT color="#000000">.FromDays(367));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Phone = </FONT><SPAN>&#8220;555-5555&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Mobile = </FONT><SPAN>&#8220;555-5555&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Email = </FONT><SPAN>&#8220;555-5555&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;</SPAN>[</FONT><SPAN>Test</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>void</SPAN><FONT color="#000000"> ShouldBeInValidIfTheNameIsBlank()</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Name = </FONT><SPAN>null</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Assert</SPAN><FONT color="#000000">.IsFalse(</FONT><SPAN>PersonValidator</SPAN><FONT color="#000000">.IsValid(person));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><SPAN><FONT color="#000000">}</FONT></SPAN><SPAN><FONT color="#000000">}</FONT></SPAN>
  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">Now everything passes again but let’s talk about passing. We know that the person object “ShouldBeInValidIfTheNameIsBlank” so can we infer that if it isn’t blank that it should pass.<SPAN>&nbsp; </SPAN>I believe we can as long as the domain specifications allow it and in this case they do.<SPAN>&nbsp; </SPAN>So you can assert on both aspects of the specification since you have isolated the context around the spec.</FONT>
</P>

<SPAN>namespace</SPAN><SPAN><FONT color="#000000"> Domain.PersonValidatorSpecifcation</FONT></SPAN><SPAN><FONT color="#000000">{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>TestFixture</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>class</SPAN><FONT color="#000000"> </FONT><SPAN>APersonWithInformationFilledIn</SPAN></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>private</SPAN><FONT color="#000000"> </FONT><SPAN>Person</SPAN><FONT color="#000000"> person; </FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>SetUp</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>void</SPAN><FONT color="#000000"> SetUp()</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person = </FONT><SPAN>new</SPAN><FONT color="#000000"> </FONT><SPAN>Person</SPAN><FONT color="#000000">();</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Name = </FONT><SPAN>&#8220;Joe Smith&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.WhatEverDate = </FONT><SPAN>DateTime</SPAN><FONT color="#000000">.Today.Subtract(</FONT><SPAN>TimeSpan</SPAN><FONT color="#000000">.FromDays(367));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Phone = </FONT><SPAN>&#8220;555-5555&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Mobile = </FONT><SPAN>&#8220;555-5555&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Email = </FONT><SPAN>&#8220;555-5555&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>Test</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>void</SPAN><FONT color="#000000"> ShouldBeInValidIfTheNameIsBlank()</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Name = </FONT><SPAN>null</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Assert</SPAN><FONT color="#000000">.IsFalse(</FONT><SPAN>PersonValidator</SPAN><FONT color="#000000">.IsValid(person));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Name = </FONT><SPAN>&#8220;John Glenn&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Assert</SPAN><FONT color="#000000">.IsTrue(</FONT><SPAN>PersonValidator</SPAN><FONT color="#000000">.IsValid(person));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><SPAN><FONT color="#000000">}</FONT></SPAN><FONT color="#000000"><SPAN>}</SPAN><SPAN></SPAN></FONT>
  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">At this point you I think we can finish the rest of the specifications.</FONT>
</P>

<SPAN>namespace</SPAN><SPAN><FONT color="#000000"> Domain.PersonValidatorSpecifcation</FONT></SPAN><SPAN><FONT color="#000000">{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>TestFixture</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>class</SPAN><FONT color="#000000"> </FONT><SPAN>APersonWithInformationFilledIn</SPAN></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>private</SPAN><FONT color="#000000"> </FONT><SPAN>Person</SPAN><FONT color="#000000"> person; </FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>SetUp</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>void</SPAN><FONT color="#000000"> SetUp()</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person = </FONT><SPAN>new</SPAN><FONT color="#000000"> </FONT><SPAN>Person</SPAN><FONT color="#000000">();</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Name = </FONT><SPAN>&#8220;Joe Smith&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.WhatEverDate = </FONT><SPAN>DateTime</SPAN><FONT color="#000000">.Today.Subtract(</FONT><SPAN>TimeSpan</SPAN><FONT color="#000000">.FromDays(367));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Phone = </FONT><SPAN>&#8220;555-5555&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Mobile = </FONT><SPAN>&#8220;555-5555&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Email = </FONT><SPAN>&#8220;billy@bob.com&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>Test</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>void</SPAN><FONT color="#000000"> ShouldBeInValidIfTheNameIsBlank()</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Name = </FONT><SPAN>null</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Assert</SPAN><FONT color="#000000">.IsFalse(</FONT><SPAN>PersonValidator</SPAN><FONT color="#000000">.IsValid(person));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Name = </FONT><SPAN>&#8220;John Glenn&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Assert</SPAN><FONT color="#000000">.IsTrue(</FONT><SPAN>PersonValidator</SPAN><FONT color="#000000">.IsValid(person));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>Test</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>void</SPAN><FONT color="#000000"> ShouldBeInValidIfTheWhatEverDateIsGreaterThanLastYear()</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.WhatEverDate = </FONT><SPAN>DateTime</SPAN><FONT color="#000000">.Today;</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Assert</SPAN><FONT color="#000000">.IsFalse(</FONT><SPAN>PersonValidator</SPAN><FONT color="#000000">.IsValid(person));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.WhatEverDate = </FONT><SPAN>DateTime</SPAN><FONT color="#000000">.Today.Subtract(</FONT><SPAN>TimeSpan</SPAN><FONT color="#000000">.FromDays(367));</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Assert</SPAN><FONT color="#000000">.IsTrue(</FONT><SPAN>PersonValidator</SPAN><FONT color="#000000">.IsValid(person));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>[</FONT><SPAN>Test</SPAN><FONT color="#000000">]</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>public</SPAN><FONT color="#000000"> </FONT><SPAN>void</SPAN><FONT color="#000000"> ShouldBeInValidIfAtLeastOneOfTheFollowingFieldsIsBlankPhoneMobileEmail()</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>{</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Phone = </FONT><SPAN>null</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Assert</SPAN><FONT color="#000000">.IsFalse(</FONT><SPAN>PersonValidator</SPAN><FONT color="#000000">.IsValid(person));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Phone = </FONT><SPAN>&#8220;555-5555&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Assert</SPAN><FONT color="#000000">.IsTrue(</FONT><SPAN>PersonValidator</SPAN><FONT color="#000000">.IsValid(person));</FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Mobile = </FONT><SPAN>null</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Assert</SPAN><FONT color="#000000">.IsFalse(</FONT><SPAN>PersonValidator</SPAN><FONT color="#000000">.IsValid(person));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Mobile = </FONT><SPAN>&#8220;555-5555&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Assert</SPAN><FONT color="#000000">.IsTrue(</FONT><SPAN>PersonValidator</SPAN><FONT color="#000000">.IsValid(person));</FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Email = </FONT><SPAN>null</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Assert</SPAN><FONT color="#000000">.IsFalse(</FONT><SPAN>PersonValidator</SPAN><FONT color="#000000">.IsValid(person));</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>person.Email = </FONT><SPAN>&#8220;Test@test.com&#8221;</SPAN><FONT color="#000000">;</FONT></SPAN><SPAN><SPAN><FONT color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN><SPAN>Assert</SPAN><FONT color="#000000">.IsTrue(</FONT><SPAN>PersonValidator</SPAN><FONT color="#000000">.IsValid(person));</FONT></SPAN><SPAN><FONT color="#000000">&nbsp;</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><SPAN><FONT color="#000000"><SPAN>&nbsp;&nbsp;&nbsp; </SPAN>}</FONT></SPAN><SPAN><FONT color="#000000">}</FONT></SPAN><SPAN><FONT face="Calibri" color="#000000" size="3">It is important to note that BDD allows the context and specifications of the test to be easily shared.<SPAN>&nbsp; </SPAN>The next steps would be to use the XML that NUnit produces and create a style sheet that will display the following information similar to </FONT><A href="http://agiledox.sourceforge.net/"><FONT face="Calibri" size="3">AgileDox</FONT></A><FONT size="3"><FONT color="#000000"><FONT face="Calibri">.</FONT></FONT></FONT></SPAN><SPAN><FONT color="#000000">Person Validator Specifcation</FONT></SPAN><FONT color="#000000"><SPAN><SPAN>&#8211;<SPAN>&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><SPAN>A person with information filled in</SPAN><SPAN></SPAN></FONT><FONT color="#000000"><SPAN><FONT face="Calibri" size="3">&#8212;</FONT></SPAN><SPAN> should be inValid if the name is blank : passed</SPAN></FONT><FONT color="#000000"><SPAN><FONT face="Calibri" size="3">&#8212;</FONT></SPAN><SPAN> should be inValid if the what ever date is greater than last year : passed</SPAN></FONT><FONT color="#000000"><SPAN><FONT face="Calibri" size="3">&#8212;</FONT></SPAN><SPAN> should be inValid if at least one of the following fields is blank phone mobile email : passed</SPAN></FONT>
  


## <SPAN><FONT size="4"><FONT color="#17365d"><FONT face="Calibri">Summary</FONT></FONT></FONT></SPAN>


  


<P class="MsoNormal">
  <FONT face="Calibri" color="#000000" size="3">I know I have covered a lot of concepts in this post but my hope, is that I sparked interest into the realm of Behavior Driven Development.<SPAN>&nbsp; </SPAN>I want to mention that by no means am I saying that this is the defacto way to practice BDD is .Net but merely an idea or concept that helps to gain the acceptance and value of BDD within the .Net community.</FONT>
</P>


  


## <FONT face="Calibri" color="#17365d" size="4">Guidelines to BDD in .Net</FONT>


  


<P class="MsoListParagraphCxSpFirst">
  <FONT color="#000000"><SPAN><SPAN><FONT face="Calibri" size="3">·</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">Utilize the Namespace to categorize the domain entities</FONT></FONT>
</P>


  


<P class="MsoListParagraphCxSpMiddle">
  <FONT color="#000000"><SPAN><SPAN><FONT face="Calibri" size="3">·</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">The class names should convey the context of the specification you are asserting.</FONT></FONT>
</P>


  


<P class="MsoListParagraphCxSpMiddle">
  <FONT color="#000000"><SPAN><SPAN><FONT face="Calibri" size="3">·</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">Keep the SetUp of the test fixture true to the context.</FONT></FONT>
</P>


  


<P class="MsoListParagraphCxSpMiddle">
  <FONT color="#000000"><SPAN><SPAN><FONT face="Calibri" size="3">·</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">The method name should convey the specification you are asserting.</FONT></FONT>
</P>


  


<P class="MsoListParagraphCxSpLast">
  <FONT color="#000000"><SPAN><SPAN><FONT face="Calibri" size="3">·</FONT><SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><FONT face="Calibri" size="3">Stay true to the principles of TDD Red, Green, Refactor!</FONT></FONT>
</P>