---
wordpress_id: 3947
title: Integrating a custom test runner with TeamCity
date: 2009-06-11T00:45:15+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2009/06/10/integrating-a-custom-test-runner-with-teamcity.aspx
dsq_thread_id:
  - "262113192"
categories:
  - teamcity
redirect_from: "/blogs/joshuaflanagan/archive/2009/06/10/integrating-a-custom-test-runner-with-teamcity.aspx/"
---
JetBrains’ TeamCity build server provides a wealth of information about the tests that are run as part of your build. If you use one of the test runners that they support out of the box, you automatically get real-time individual test results, detailed timing reports, and historical performance metrics.

Up until recently, all of the tests for my team were run through NUnit – C# unit tests, QUnit JavaScript tests, and integration tests. Since NUnit is natively supported by TeamCity, we got used to the rich test reporting. However, we recently started to integrate our automated acceptance tests into the build. Our acceptance tests are written using StoryTeller, which are executed using its own test runner. The StoryTeller test runner has slightly different behavior than the NUnit runner. For one, a failed assertion does NOT stop execution of a test – it continues executing so that a single test can have multiple failed assertions. We also have the ability to mark individual tests with their state in the development lifecycle: they start as "acceptance” tests when they are first defined, and then are marked as “regression” once all supporting code has been correctly implemented. The idea is that you can drive your development with failing acceptance tests until they pass, at which point they become regression tests. This is relevant because a failed acceptance test does NOT fail the build – only a failed regression test will fail the build.

The StoryTeller test runner is a console application that will return an error code if any regression tests fail. It also generates an HTML report which contains the details for each test. Our initial attempt at integrating it into our build allowed us to fail the build if any test failed, but we didn’t get much feedback about why it failed. We would have to go searching through the build log messages or HTML report files for details.

I created a new StoryTeller ITestListener (<a href="http://storyteller.tigris.org/source/browse/storyteller/trunk/source/StoryTeller/Engine/TeamCityTestListener.cs?revision=401&view=markup" target="_blank">TeamCityTestListener</a>) which is used by the StoryTeller runner to log test results. It writes the test details to the console using TeamCity’s <a href="http://www.jetbrains.net/confluence/display/TCD4/Build+Script+Interaction+with+TeamCity#BuildScriptInteractionwithTeamCity-ReportingTests" target="_blank">Service Message API</a> (which <a href="https://lostechies.com/blogs/joshuaflanagan/archive/2008/09/10/monkey-patching-rake-for-use-with-teamcity.aspx" target="_blank">I mentioned previously</a>). TeamCity picks up these messages, and creates the nice individual test reports, complete with timing and history:

 <img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="378" alt="StoryTeller test results in TeamCity" src="https://lostechies.com/content/joshuaflanagan/uploads/2011/03/image_4C7407A7.png" width="644" border="0" />

Now we know exactly which tests failed, but we don’t know which assertions in the tests failed. As I mentioned, the complete details of the test execution are recorded in an HTML report. It’d be nice if we could view individual test reports right within TeamCity. Turns out, that is pretty easy to do as well. I followed the documentation for <a href="http://www.jetbrains.net/confluence/display/TCD4/Including+Third-Party+Reports+in+the+Build+Results" target="_blank">Including Third-Party Reports in the Build Results</a>, and added the following line to our <TEAMCITY>.ServerConfig.BuildServerconfigmain-config.xml file:

<div>
  <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">report-tab</span> <span style="color: #ff0000">title</span><span style="color: #0000ff">="StoryTeller"</span> <span style="color: #ff0000">basePath</span><span style="color: #0000ff">="st-results"</span> <span style="color: #ff0000">startPage</span><span style="color: #0000ff">="st-results.htm"</span> <span style="color: #0000ff">/&gt;</span></pre>
</div>

We now have a nice new StoryTeller tab next to the other build result tabs:

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="247" alt="image" src="https://lostechies.com/content/joshuaflanagan/uploads/2011/03/image_thumb_2E4649F3.png" width="644" border="0" />](https://lostechies.com/content/joshuaflanagan/uploads/2011/03/image_2B14620B.png) 

We configured the build to store all of the HTML reports as artifacts, and point our custom tab to the test results index HTML file generated by StoryTeller. Clicking the StoryTeller tab displays that index file with a color coded overview of all of the tests. Clicking a test brings up the report for that test so that I can see exactly which steps failed.