---
wordpress_id: 19
title: 'PTOM: Bend 3rd Party Libraries to Your Will With the Adapter Pattern'
date: 2008-11-25T05:43:00+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2008/11/25/ptom-bend-3rd-party-libraries-to-your-will-with-the-adapter-pattern.aspx
dsq_thread_id:
  - "262055542"
categories:
  - Design Patterns
  - PTOM
redirect_from: "/blogs/johnteague/archive/2008/11/25/ptom-bend-3rd-party-libraries-to-your-will-with-the-adapter-pattern.aspx/"
---
No matter what you do or where you work, there will always be the 3rd party library that your manager insists you use (you know, the one whose agreement was made on the golf course), or that old legacy code that is impossible to test.&nbsp; Now it might be easy to just throw your hands up in desperation, but you can shield your code from this big ugly untestable tangle by hiding it so that you will never know you are using the library.&nbsp; The easiest way is to use the [Adapter Pattern](http://en.wikipedia.org/wiki/Adapter_pattern).

&nbsp;

The definition of the adapter pattern, from [c2.com](http://c2.com/cgi/wiki?AdapterPattern) is: 

> ****_Convert_ the interface of some class _b_ into an interface _a_ that some client class _c_ understands.

Now this is definitely a very useful ability of this pattern, and can solve some problems very elegantly.&nbsp; One area where I used this pattern with this strict definition was to convert messages from one logging framework to another.&nbsp; But there is really much more potential behind this rather diminutive definition.&nbsp; It allows you to hide whatever you want behind your own interface and only have to slay those 3rd party or legacy code dragons in one place.&nbsp; Now the rest of your application go along it&rsquo;s merrily way.

Here is the UML for the Adapter pattern.

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" alt="image" src="//lostechies.com/johnteague/files/2011/03/image_thumb_6C8F7A3F.png" border="0" height="205" width="531" />](//lostechies.com/johnteague/files/2011/03/image_5157213E.png) 

I got to be honest, generic class diagrams do me almost know good.&nbsp; I&rsquo;m just not one of those visual learners I guess.&nbsp; Here&rsquo;s what the code structure looks like.

<div>
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> ThereBeDragonsHere{<br />    <span style="color: #0000ff">public</span> <span style="color: #0000ff">int</span> AMethodINeedToCallButCannotTest(xxx)<br />}<br /><br /><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IHideDragons{<br />    WhatTheIntReallyMeans CallMeInsteadOfUglyOne(xxx);<br />}<br /><br /><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> DragonHider : IHideDragons{<br />    <span style="color: #0000ff">private</span> ThereBeDragonsHere _dragons;<br />    <br />    <span style="color: #0000ff">public</span> DragonHider(Dependency dep){<br />        _dragons = <span style="color: #0000ff">new</span> ThereBeDragonsHere();<br />        setupDragon(dep);<br />    }<br />    <span style="color: #0000ff">public</span> WhatTheIntReallyMeans CallMeInsteadOfUglyOne(xxx){<br />        var answer = _dragons.AMethodINeedToCallButCannotTest(xxx);<br />        <span style="color: #0000ff">return</span> correctTheAnswer(answer);<br />         <br />    }<br />    <br />}</pre>
</div>

Now the dragons are safely hidden. What&rsquo;s more, you can transform the messages passed back and forth to the 3rd party library in whatever terminology that correctly defines the conversation in terms of your application. The rest of the application is now testable, mocking out your object when you need to.

In the [online open meeting](/blogs/chad_myers/archive/2008/11/21/alt-net-online-open-meeting.aspx) last week, someone asked how do you introduce testing into a legacy codebase.&nbsp; In this case, the speaker said that in order to introduce TDD into an app, he needed to change about 30 classes and was unsure about the implications of the changes as well as the scope creep it put on his time estimate.&nbsp; This is one way to introduce TDD into a code base [is](/blogs/jimmy_bogard/archive/2007/08/31/legacy-code-testing-techniques-subclass-and-override-non-virtual-members.aspx) [one](/blogs/jimmy_bogard/archive/2007/10/19/dependency-breaking-techniques-inline-static-class.aspx) technique that can help you get there.&nbsp; Through [continuous improvement](http://jamesshore.com/Articles/Technology/Continuous%20Design.abstract), you will have a system that is testable and maintainable.