---
wordpress_id: 143
title: 'Unit testing MonoRail controllers &#8211; Redirects'
date: 2008-02-19T02:40:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/02/18/unit-testing-monorail-controllers-redirects.aspx
dsq_thread_id:
  - "264715553"
categories:
  - MonoRail
  - Patterns
  - TDD
  - Testing
---
When developing with [MonoRail](http://www.castleproject.org/monorail/), one of the common operations is to redirect to other controllers and actions.&nbsp; Originally, I looked at the [BaseControllerTester](http://using.castleproject.org/display/MR/TDDingControllers) to help test, but it required a little too much knowledge of the inner workings of MonoRail for my taste.&nbsp; Instead, I&#8217;ll use a common [Legacy Code](http://www.amazon.com/Working-Effectively-Legacy-Robert-Martin/dp/0131177052) technique to achieve the same effect.

### The first attempt

The easiest way to see if a method is testable is just to try it out.&nbsp; Right now I don&#8217;t have much of an idea of what to test.&nbsp; I do know that the method I want to call in the Controller base class is &#8220;Redirect&#8221;.&nbsp; I don&#8217;t really know what that does underneath the covers, but I don&#8217;t much care.&nbsp; What I&#8217;d like to do is create a [PartialMock](http://www.ayende.com/Wiki/Default.aspx?Page=Rhino+Mocks+Partial+Mocks) for the AccountController, and just make sure that the &#8220;Redirect&#8221; method is called with the correct parameters.

A side note, PartialMock is great for mocking classes (as opposed to interfaces).&nbsp; I can selectively remove behavior for specific methods while leaving the other methods and behavior in place.

Here&#8217;s my first attempt at a test with AccountController getting mocked out:

<pre>[<span style="color: #2b91af">TestFixture</span>]<br /><span style="color: blue">public class </span><span style="color: #2b91af">When_authenticating_with_valid_credentials<br /></span>{<br />    <span style="color: blue">private </span><span style="color: #2b91af">MockRepository </span>_mocks;<br />    <span style="color: blue">private </span><span style="color: #2b91af">IUserRepository </span>_userRepo;<br />    <span style="color: blue">private </span><span style="color: #2b91af">AccountController </span>_acctCtlr;<br /><br />    [<span style="color: #2b91af">SetUp</span>]<br />    <span style="color: blue">public void </span>Before_each_spec()<br />    {<br />        _mocks = <span style="color: blue">new </span><span style="color: #2b91af">MockRepository</span>();<br /><br />        _userRepo = _mocks.CreateMock&lt;<span style="color: #2b91af">IUserRepository</span>&gt;();<br />        _acctCtlr = _mocks.PartialMock&lt;<span style="color: #2b91af">AccountController</span>&gt;(_userRepo);<br /><br />        <span style="color: #2b91af">User </span>user = <span style="color: blue">new </span><span style="color: #2b91af">User</span>();<br />        user.Username = <span style="color: #a31515">"tester"</span>;<br />        user.Password = <span style="color: #a31515">"password"</span>;<br /><br />        <span style="color: #2b91af">Expect</span>.Call(_userRepo.GetUserByUsername(<span style="color: #a31515">"tester"</span>)).Return(user);<br />        <span style="color: #2b91af">Expect</span>.Call(() =&gt; _acctCtlr.Redirect(<span style="color: #a31515">"main"</span>, <span style="color: #a31515">"index"</span>)).Repeat.AtLeastOnce();<br /><br />        _mocks.ReplayAll();<br />    }<br /><br />    [<span style="color: #2b91af">Test</span>]<br />    <span style="color: blue">public void </span>Should_redirect_to_landing_page()<br />    {<br />        _acctCtlr.Login(<span style="color: #a31515">"tester"</span>, <span style="color: #a31515">"password"</span>);<br /><br />        _mocks.VerifyAll();<br />    }<br />}<br /></pre>

[](http://11011.net/software/vspaste)

In the Before\_each\_spec method, I set up the appropriate mocks and use the PartialMock method to try and mock out the AccountController.&nbsp; Additionally, I set up expectations for the IUserRepository and additionally for the AccountController.

Unfortunately, the test fails, but not for the reasons I like.&nbsp; I get all sorts of exceptions from deep inside the MonoRail caves.&nbsp; The mocking should have worked, so what went wrong?

### A little workaround

Digging deeper into the MonoRail API, I find the culprit.&nbsp; Although I told Rhino Mocks to intercept the Redirect call, it will only work for virtual and abstract methods.&nbsp; The Redirect method is neither.

Pulling an old trick out of the hat, I wrote quite a while ago about [subclassing and overriding non-virtual methods](http://grabbagoft.blogspot.com/2007/08/legacy-code-testing-techniques-subclass.html).&nbsp; This trick will work just great here.&nbsp; I&#8217;ll create a seam between the AccountController and MonoRail&#8217;s SmartDispatcherController:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">BaseController </span>: <span style="color: #2b91af">SmartDispatcherController<br /></span>{<br />    <span style="color: blue">public virtual new void </span>Redirect(<span style="color: blue">string </span>controller, <span style="color: blue">string </span>action)<br />    {<br />        <span style="color: blue">base</span>.Redirect(controller, action);<br />    }<br />}<br /></pre>

[](http://11011.net/software/vspaste)

Additionally, I change the AccountController to inherit from this new [seam class](http://www.informit.com/articles/article.aspx?p=359417&seqNum=3).&nbsp; Since I just wrap and delegate to the base class, production code won&#8217;t be affected in the slightest.&nbsp; Since my test mocks AccountController, which has a virtual &#8220;Redirect&#8221; method, the test now fails correctly.&nbsp; And now that it fails correctly, I can fill out the implementation:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">AccountController </span>: <span style="color: #2b91af">BaseController<br /></span>{<br />    <span style="color: blue">private readonly </span><span style="color: #2b91af">IUserRepository </span>_repo;<br /><br />    <span style="color: blue">public </span>AccountController(<span style="color: #2b91af">IUserRepository </span>repo)<br />    {<br />        _repo = repo;<br />    }<br /><br />    <span style="color: blue">public void </span>Login(<span style="color: blue">string </span>username, <span style="color: blue">string </span>password)<br />    {<br />        <span style="color: #2b91af">User </span>user = _repo.GetUserByUsername(username);<br /><br />        <span style="color: blue">if </span>(user != <span style="color: blue">null</span>)<br />        {<br />            <span style="color: green">// check password<br />            </span>Redirect(<span style="color: #a31515">"main"</span>, <span style="color: #a31515">"index"</span>);<br />        }<br />    }<br />}<br /></pre>

[](http://11011.net/software/vspaste)

Although the BaseControllerTester provides a lot of out-of-the-box testing functionality, sometimes the implementation details can leak into my tests, which is what I don&#8217;t want to happen.&nbsp; I like to keep my tests coupled to frameworks as little as possible, and there&#8217;s nothing really specific to MonoRail in my tests.&nbsp; The method might change, but the MVC frameworks I&#8217;ve looked at all have some kind of &#8220;redirect to some other controller and action&#8221; method.

The subclass-and-override technique provides a quick way to introduce a seam into classes that don&#8217;t offer out-of-the-box testability in the places you want.&nbsp; Since this pattern doesn&#8217;t affect production code, I can feel confident testing my Controllers (or anything else similar) in this manner.