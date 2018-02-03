---
wordpress_id: 3187
title: Starting with BDD vs. starting with TDD
date: 2008-12-07T14:37:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2008/12/07/starting-with-bdd-vs-starting-with-tdd.aspx
dsq_thread_id:
  - "262110465"
categories:
  - Uncategorized
---
Yesterday I did a presentation on TDD/BDD at the [Tamp Code Camp](http://www.tampacodecamp.com). I have done several TDD presentations in the past but this was the first time I also showed the attendees BDD at the same time. In actuality I didn&#8217;t even show them a traditional TDD test. Not to my surprise, newcomers seem to grasp BDD much quicker and easier than from a TDD perspective. I did touch on that some tests would still be driven from a technical aspect, but from a business requirements they should try to use BDD. Another thing I very briefly touched on was Mocks/Stubs. I try not to go too in depth as you can discuss mocks and stubs for an hour by themselves and isn’t worth it to dive into when all you have is an hour.

The best description I came up with for what is "BDD", it&#8217;s nothing more than two things:

  1. A language shift in traditional TDD
  2. Driving your tests from a domain/user story perspective rather than technical perspective

<div>
  When this was explained to a group of people that have never even used TDD, their heads nodded and I saw about 30 lightbulbs come on in the room. They just seemed to "get it" right away.
</div>

<div>
</div>

<div>
  As I dive further into a description here. I should note that there is <strong>ALOT</strong> of differing opinions on what the proper way to do BDD is and what the proper “language” is. Much like TDD, it comes down to personal preference. Using a simple BDD tool like <a href="http://code.google.com/p/specunit-net/">SpecUnit</a> helped me a lot to figure out how to structure my tests in the beginning. From there, It breaks down to what you find works.
</div>

<div>
  &#160;
</div>

<div>
  SpecUnit lays a pretty good foundation on what your language is. Let’s take a look at the language real quick. We’ll compare traditional TDD test naming vs. BDD test naming. Here’s how you would layout a test class and test for an AddressBook application with traditional TDD:
</div>

<div>
  &#160;
</div>

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre>[TestFixture]</pre>
    
    <pre><span class="kwrd">public</span> <span class="kwrd">class</span> addressbook_tests</pre>
    
    <pre>{</pre>
    
    <pre>    [SetUp]</pre>
    
    <pre>    <span class="kwrd">public</span> <span class="kwrd">void</span> SetUp()</pre>
    
    <pre>    {</pre>
    
    <pre>        <span class="rem">// setup code for test</span></pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    [Test]</pre>
    
    <pre>    <span class="kwrd">public</span> <span class="kwrd">void</span> can_add_person_to_addressbook()</pre>
    
    <pre>    {</pre>
    
    <pre>        <span class="rem">// test assertions</span></pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

As you can see. We have TestFixture/Test attributes. This is pretty straightforward and if you’ve been doing TDD you know how it works. Now let’s look at the same test using SpecUnit and with BDD language adjustments:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre>[Concern(<span class="str">"Address Book"</span>), TestFixture]</pre>
    
    <pre><span class="kwrd">public</span> <span class="kwrd">class</span> when_adding_a_person_to_an_addressbook : ContextSpecification</pre>
    
    <pre>{</pre>
    
    <pre>    [Context]</pre>
    
    <pre>    <span class="kwrd">protected</span> <span class="kwrd">override</span> <span class="kwrd">void</span>  Context()</pre>
    
    <pre>    {</pre>
    
    <pre>        <span class="kwrd">base</span>.Context();</pre>
    
    <pre>&#160;</pre>
    
    <pre>        <span class="rem">// setup code for test</span></pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    [Observation, Test]</pre>
    
    <pre>    <span class="kwrd">public</span> <span class="kwrd">void</span> addressbook_contains_person()</pre>
    
    <pre>    {</pre>
    
    <pre>        <span class="rem">// test assertions</span></pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

<div>
  Its a minor shift but a couple of things are important here.
</div>

  1. I have both Concern/TestFixture and Observation/Test attributes on the class/method. This reason I am doing this is because I am using Resharper. At the moment, resharper doesn’t recognize that Concern/Observation derive from TestFixture/Test and thus needs to be added so the Resharper test runner recognizes the tests. I have filed a bug with JetBrains and this will be fixed on the next release. It also helps to show what was a testfixture and test in the first example
  2. Instead of [SetUp] attribute you now have the [Context] attribute.
  3. There are other methods you can override from ContextSpecification like “Context\_BeforeAllSpecs”, “Context\_AfterAllSpecs” and so on.
  4. SpecUnit has a number of extremely useful extension methods that make for a much more readable assertions like: somevalue.ShouldEqual(“whatever”).

In BDD one of the biggest shifts is that your testfixture classes are now grouped together into “Concerns” and your classes are broken out into Contexts. So in the TDD example our individual tests defined the context, now we pull that context up to the class level and the tests then become the acceptance criteria for the context.

BDD has a much better alignment with business concerns and allows us to create tests that are parallel with User Stories/Acceptance criteria. This allows us to write software that is directly inline with what our stakeholders want rather than writing code that may or may not be necessary.

Moving on, lets look at another important part of BDD which has to do with reusing contexts in your tests. Ok, so lets say we are creating an addressbook in our “when\_adding\_a\_person\_to\_an\_addressbook” like so:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre>[Concern(<span class="str">"Address Book"</span>), TestFixture]</pre>
    
    <pre><span class="kwrd">public</span> <span class="kwrd">class</span> when_adding_a_person_to_an_addressbook : ContextSpecification</pre>
    
    <pre>{</pre>
    
    <pre>    <span class="kwrd">private</span> AddressBook addressBook;</pre>
    
    <pre>&#160;</pre>
    
    <pre>    [Context]</pre>
    
    <pre>    <span class="kwrd">protected</span> <span class="kwrd">override</span> <span class="kwrd">void</span>  Context()</pre>
    
    <pre>    {</pre>
    
    <pre>        <span class="kwrd">base</span>.Context();</pre>
    
    <pre>&#160;</pre>
    
    <pre>        addressBook = <span class="kwrd">new</span> AddressBook();</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

<div>
  Now lets say we have another user story and we have to create another context for “when_searching_for_a_person_in_an_addressbook”. Instead of creating a class with a context setup that matches the one above, we want to enforce DRY and create a “behaves_like_addressbook” class that both test classes can utilize:
</div>

<div>
  &#160;
</div>

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="kwrd">public</span> <span class="kwrd">class</span> behaves_like_addressbook : ContextSpecification</pre>
    
    <pre>{</pre>
    
    <pre>    <span class="kwrd">protected</span> AddressBook addressBook;</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span class="kwrd">protected</span> <span class="kwrd">override</span> <span class="kwrd">void</span> Context()</pre>
    
    <pre>    {</pre>
    
    <pre>        <span class="kwrd">base</span>.Context();</pre>
    
    <pre>&#160;</pre>
    
    <pre>        addressBook = <span class="kwrd">new</span> AddressBook();</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

Now both of the context test classes can derive from this class like so:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre>[Concern(<span class="str">"Address Book"</span>), TestFixture]</pre>
    
    <pre><span class="kwrd">public</span> <span class="kwrd">class</span> when_adding_a_person_to_an_addressbook : behaves_like_addressbook</pre>
    
    <pre>&#160;</pre>
    
    <pre>[Concern(<span class="str">"Address Book"</span>), TestFixture]</pre>
    
    <pre><span class="kwrd">public</span> <span class="kwrd">class</span> when_searching_for_a_person_in_an_addressbook : behaves_like_addressbook</pre></p>
  </div>
</div>

So now any setup of the context that our classes share can be placed in the behaves\_like\_addressbook “Context Base class”. This is a part of bdd that comes from rspec. The ruby guys reuse their contexts in exactly this way. Then if you have additional context base classes along the way if you have two or more contexts that share behavior/setup. For instance. lets say we had a shared context further down we can set it up like this:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="kwrd">public</span> <span class="kwrd">class</span> behaves_like_address_book_with_some_other_context : behaves_like_addressbook</pre>
    
    <pre>{</pre>
    
    <pre>    <span class="kwrd">protected</span> <span class="kwrd">override</span> <span class="kwrd">void</span> Context()</pre>
    
    <pre>    {</pre>
    
    <pre>        <span class="kwrd">base</span>.Context();</pre>
    
    <pre>&#160;</pre>
    
    <pre>        <span class="rem">// modify our context that was</span></pre>
    
    <pre>        <span class="rem">// created in behaves_like_addressbook</span></pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

This really helps to promote reuse among the context setups in your tests. Also take a look at the SpecUnit.report.exe in the specunit project. It allows you to generate an html document from the name of your tests to hand to stakeholders. Very useful form of documentation.

Thats it for an introduction to bdd and to get the gist of it. Now heres a list of resources to get you started not only for the people that were in my presentation yesterday but also for any newcomers to BDD.

[SpecUnit](http://code.google.com/p/specunit-net/) : BDD testing tool that was described in this post

[schambers googlecode](http://schambers.googlecode.com/svn/) : My google code repository with my resharper templates and AddresBook sample for BDD

[AutoHotKey](http://www.autohotkey.com/download/) : install this and execute the “TestNamingMode.ahk” from my google code repository, then you do crtl+shift+u to turn on test naming mode where spaces are turned into underscores for you. Thanks to jpboodhoo for this!

[Jean-Paul Boodhoo’s Blog](http://blog.jpboodhoo.com/) : this guy is a BDD master. He has excellent posts on BDD and if your not already, you should definately read his blog.

[JetBrains ReSharper](http://www.jetbrains.com/resharper/) : alot of the people in my presentation were blown away when I showed them what resharper was capable of. For anyone that is interested you can obtain a 30-day trial

Any feedback would be greatly appreciated! till next time