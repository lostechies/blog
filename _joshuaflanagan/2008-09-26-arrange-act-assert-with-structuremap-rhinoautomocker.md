---
wordpress_id: 3939
title: Arrange Act Assert with StructureMap RhinoAutoMocker
date: 2008-09-26T02:03:18+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2008/09/25/arrange-act-assert-with-structuremap-rhinoautomocker.aspx
dsq_thread_id:
  - "262113173"
categories:
  - Uncategorized
redirect_from: "/blogs/joshuaflanagan/archive/2008/09/25/arrange-act-assert-with-structuremap-rhinoautomocker.aspx/"
---
Fresh on the heels of finally figuring out <a href="https://lostechies.com/blogs/joshuaflanagan/archive/2008/09/25/the-rhino-mocks-assertwascalled-method-does-work.aspx" target="_blank">how to make the AAA syntax in Rhino.Mocks work</a>, I&#8217;ve added support to StructureMap&#8217;s RhinoAutoMocker. If you pass MockMode.AAA to the constructor of your RhinoAutoMocker, all of the mocks that it creates will be in replay mode. This is required to successfully use the AssertWasCalled extension method. By default, if you do not pass a MockMode to the constructor, mocks will be created in record mode so that you can continue to set expectations the old fashioned way.

<div>
  <pre>[Test]
<span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> TheAutoMockerOptionallyPushesInMocksInReplayModeToAllowForAAAsyntax()
{
    var autoMocker = <span style="color: #0000ff">new</span> RhinoAutoMocker&lt;ConcreteClass&gt;(MockMode.AAA);

    autoMocker.ClassUnderTest.CallService();

    autoMocker.Get&lt;IMockedService&gt;().AssertWasCalled(s =&gt; s.Go());
}</pre>
</div>

The code is in the <a href="http://sourceforge.net/svn/?group_id=104740" target="_blank">trunk</a>, and will be included in the eventual StructureMap 2.5 release.

**Updated Oct 8, 2008:** The MockMode enumeration to enable AAA syntax has been changed to MockMode.AAA to be more self-explanatory.