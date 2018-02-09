---
wordpress_id: 3376
title: Unit Testing Simple ASP.NET MVC Controllers
date: 2010-02-05T05:04:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2010/02/05/unit-testing-simple-asp-net-mvc-controllers.aspx
dsq_thread_id:
  - "262175143"
categories:
  - ASP.NET MVC
  - development
  - DRY
  - Moq
  - NUnit
  - RhinoMocks
redirect_from: "/blogs/chrismissal/archive/2010/02/05/unit-testing-simple-asp-net-mvc-controllers.aspx/"
---
I have created enough simple projects using ASP.NET MVC with unit tests to notice a very helpful pattern. The following is a sample of a test fixture using RhinoMocks and NUnit to test a controller.

<div style="border: 1px solid silver;margin: 20px 0px 10px;padding: 4px;overflow: auto;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 97.5%;font-family: 'Courier New',courier,monospace;direction: ltr;font-size: 8pt;cursor: text">
  <div style="border-style: none;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   1:</span> [TestFixture]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   2:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> AdminControllerTests</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   3:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   4:</span>     <span style="color: #0000ff">private</span> IFacilityRepository facilityRepository;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   5:</span>     <span style="color: #0000ff">private</span> IMeetingRepository meetingRepository;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   6:</span>     <span style="color: #0000ff">private</span> IUserSession userSession;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   7:</span>&nbsp; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   8:</span>     [SetUp]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   9:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SetUp()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  10:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  11:</span>         facilityRepository = MockRepository.GenerateMock&lt;IFacilityRepository&gt;();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  12:</span>         meetingRepository = MockRepository.GenerateMock&lt;IMeetingRepository&gt;();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  13:</span>         userSession = MockRepository.GenerateMock&lt;IUserSession&gt;();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  14:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  15:</span>&nbsp; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  16:</span>     [Test]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  17:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SaveMeeting_should_call_Add_on_MeetingRepository_if_MeetingId_is_zero()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  18:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  19:</span>         <span style="color: #008000">// Arrange</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  20:</span>         var meetingData = <span style="color: #0000ff">new</span> MeetingData { MeetingId = 0, FacilityId = 0 };</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  21:</span>         meetingRepository.Stub(x =&gt; x.GetById(0)).Return(<span style="color: #0000ff">new</span> Meeting());</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  22:</span>         facilityRepository.Stub(x =&gt; x.GetById(0)).Return(<span style="color: #0000ff">new</span> Facility());</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  23:</span>         var controller = GetController();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  24:</span>&nbsp; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  25:</span>         <span style="color: #008000">// Act</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  26:</span>         controller.SaveMeeting(meetingData);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  27:</span>&nbsp; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  28:</span>         <span style="color: #008000">// Assert</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  29:</span>         meetingRepository.AssertWasCalled(x =&gt; x.Add(Arg&lt;Meeting&gt;.Is.Anything));</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  30:</span>         meetingRepository.AssertWasNotCalled(x =&gt; x.Update(Arg&lt;Meeting&gt;.Is.Anything));</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  31:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  32:</span>&nbsp; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  33:</span>     [Test]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  34:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SaveMeeting_should_call_Update_on_MeetingRepository_if_MeetingId_is_not_zero()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  35:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  36:</span>         <span style="color: #008000">// Arrange</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  37:</span>         var meetingData = <span style="color: #0000ff">new</span> MeetingData { MeetingId = 1, FacilityId = 1 };</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  38:</span>         meetingRepository.Stub(x =&gt; x.GetById(1)).Return(<span style="color: #0000ff">new</span> Meeting());</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  39:</span>         facilityRepository.Stub(x =&gt; x.GetById(1)).Return(<span style="color: #0000ff">new</span> Facility());</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  40:</span>         var controller = GetController();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  41:</span>&nbsp; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  42:</span>         <span style="color: #008000">// Act</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  43:</span>         controller.SaveMeeting(meetingData);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  44:</span>&nbsp; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  45:</span>         <span style="color: #008000">// Assert</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  46:</span>         meetingRepository.AssertWasNotCalled(x =&gt; x.Add(Arg&lt;Meeting&gt;.Is.Anything));</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  47:</span>         meetingRepository.AssertWasCalled(x =&gt; x.Update(Arg&lt;Meeting&gt;.Is.Anything));</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  48:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  49:</span>&nbsp; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  50:</span>     <span style="color: #0000ff">private</span> AdminController GetController()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  51:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  52:</span>         <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> AdminController(userSession, meetingRepository, facilityRepository);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  53:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  54:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        &nbsp;
      </p>
      
      <p>
        The reason I&rsquo;m being explicit about the term &ldquo;simple&rdquo; in this case is that the controller above that I&rsquo;m testing doesn&rsquo;t have much going on. It has some constructor dependencies (like all controllers with dependencies should), but that&rsquo;s about it. The gist of the pattern is made up of three things:
      </p>
      
      <ol>
        <li>
          A SetUp method, via NUnit, runs before each test to create new, fake implementations of the dependencies. In this case I&rsquo;m using RhinoMocks, but you&rsquo;re not limited to that (see below). Declaring them at the class level is nice, it allows you to use or ignore them at your leisure.
        </li>
        <li>
          Creating the GetController() method constrains the creation of a controller to one place. This is good because your dependencies can change by adding more or removing existing dependencies. By creating one place to &ldquo;new up&rdquo; the controller, you only have to update one area when dependencies change instead of updating a constructor in each test. This isn&rsquo;t anything new for unit testing, just a good practice.
        </li>
        <li>
          Finally, your individual tests can get a new controller and stub/mock/fake the methods of your dependencies at any time during the test method and assert values or verify behavior at any time during the test.
        </li>
      </ol>
      
      <p>
        This pattern has helped me a lot; I wish I had this in mind when I was writing lots of unit tests for controllers a year and a half ago (so I didn&rsquo;t have to go back and change some of them later).
      </p>
      
      <p>
        Another isolation/mocking framework I like to use is Moq. For the above example, there is a slight difference in the way the same fixture is used. The following is the same tests using Moq.
      </p>
      
      <div style="border: 1px solid silver;margin: 20px 0px 10px;padding: 4px;overflow: auto;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 97.5%;font-family: 'Courier New',courier,monospace;direction: ltr;font-size: 8pt;cursor: text">
        <div style="border-style: none;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   1:</span> [TestFixture]</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   2:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> AdminControllerTests</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   3:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   4:</span>     <span style="color: #0000ff">private</span> Mock&lt;IFacilityRepository&gt; facilityRepository;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   5:</span>     <span style="color: #0000ff">private</span> Mock&lt;IMeetingRepository&gt; meetingRepository;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   6:</span>     <span style="color: #0000ff">private</span> Mock&lt;IUserSession&gt; userSession;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   7:</span>&nbsp; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   8:</span>     [SetUp]</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">   9:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SetUp()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  10:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  11:</span>         facilityRepository = <span style="color: #0000ff">new</span> Mock&lt;IFacilityRepository&gt;();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  12:</span>         meetingRepository = <span style="color: #0000ff">new</span> Mock&lt;IMeetingRepository&gt;();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  13:</span>         userSession = <span style="color: #0000ff">new</span> Mock&lt;IUserSession&gt;();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  14:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  15:</span>&nbsp; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  16:</span>     [Test]</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  17:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SaveMeeting_should_call_Add_on_MeetingRepository_if_MeetingId_is_zero()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  18:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  19:</span>         <span style="color: #008000">// Arrange</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  20:</span>         var meetingData = <span style="color: #0000ff">new</span> MeetingData { MeetingId = 0, FacilityId = 0 };</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  21:</span>         meetingRepository.Setup(x =&gt; x.GetById(0)).Returns(<span style="color: #0000ff">new</span> Meeting());</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  22:</span>         facilityRepository.Setup(x =&gt; x.GetById(0)).Returns(<span style="color: #0000ff">new</span> Facility());</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  23:</span>         var controller = GetController();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  24:</span>&nbsp; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  25:</span>         <span style="color: #008000">// Act</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  26:</span>         controller.SaveMeeting(meetingData);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  27:</span>&nbsp; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  28:</span>         <span style="color: #008000">// Assert</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  29:</span>         meetingRepository.Verify(x =&gt; x.Add(It.IsAny&lt;Meeting&gt;()));</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  30:</span>         meetingRepository.Verify(x =&gt; x.Update(It.IsAny&lt;Meeting&gt;(), Times.Never()));</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  31:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  32:</span>&nbsp; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  33:</span>     [Test]</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  34:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SaveMeeting_should_call_Update_on_MeetingRepository_if_MeetingId_is_not_zero()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  35:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  36:</span>         <span style="color: #008000">// Arrange</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  37:</span>         var meetingData = <span style="color: #0000ff">new</span> MeetingData { MeetingId = 1, FacilityId = 1 };</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  38:</span>         meetingRepository.Setup(x =&gt; x.GetById(1)).Returns(<span style="color: #0000ff">new</span> Meeting());</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  39:</span>         facilityRepository.Setup(x =&gt; x.GetById(1)).Returns(<span style="color: #0000ff">new</span> Facility());</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  40:</span>         var controller = GetController();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  41:</span>&nbsp; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  42:</span>         <span style="color: #008000">// Act</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  43:</span>         controller.SaveMeeting(meetingData);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  44:</span>&nbsp; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  45:</span>         <span style="color: #008000">// Assert</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  46:</span>         meetingRepository.Verify(x =&gt; x.Add(It.IsAny&lt;Meeting&gt;(), Times.Never()));</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  47:</span>         meetingRepository.Verify(x =&gt; x.Update(It.IsAny&lt;Meeting&gt;()));</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  48:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  49:</span>&nbsp; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  50:</span>     <span style="color: #0000ff">private</span> AdminController GetController()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  51:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  52:</span>         <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> AdminController(userSession.Object, meetingRepository.Object, facilityRepository.Object);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  53:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #606060">  54:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              Both of these examples are using the Arrange/Act/Assert (AAA) syntax. The idea is that you set up your context, run some code, then verify the results of your objects and/or system under test.
            </p>
            
            <p>
              This has been a very good to me and a simple pattern for testing most controllers in many of the simple MVC applications I&rsquo;ve worked.
            </p>