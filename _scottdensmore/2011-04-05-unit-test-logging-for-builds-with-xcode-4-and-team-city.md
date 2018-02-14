---
wordpress_id: 4615
title: Unit Test Logging for Builds with Xcode 4 and Team City
date: 2011-04-05T23:03:55+00:00
author: Scott Densmore
layout: post
wordpress_guid: http://lostechies.com/scottdensmore/?p=27
dsq_thread_id:
  - "272293830"
categories:
  - Apple
  - iOS
  - Xcode
---
One of the things I wanted to do after getting comfortable with the iOS/Mac platform(s) was trying to take my &#8220;agile&#8221; ways to the platforms (for this post specifically testing). I started learning all this in the Xcode 3 days. I really think with the release of Xcode 4, things are getting much better. WIth workspaces, schemes and better unit testing integration, I believe Xcode 4 is making my life as a developer easier on the platform.

All the code for this project can be found on github [here](https://github.com/scottdensmore/OCUnitLogger).

**Unit Testing**

**<span style="font-weight: normal">Unit testing is by far the lowest hanging fruit. I spent a good bit of time learning the shipping tools for Xcode (OCUnit). I also spent some time looking at the unit testing tools like <a href="https://github.com/gabriel/gh-unit">GHUnit</a> and <a href="http://code.google.com/p/google-toolbox-for-mac/">Google Toolbox for Mac (GTM)</a>, yet I am pretty pragmatic and found that for the most part, OCUnit did what I needed.  The only other tool that I use for testing is <a href="http://www.mulle-kybernetik.com/software/OCMock/">OCMock</a>. I know a lot of people also use <a href="http://code.google.com/p/hamcrest/">OCHamcrest</a> for extending the assertion macros, I just have not found I use it myself.</span>** **<span style="font-weight: normal">I know a lot of people are using specifications these days to do more user level testing. There are a few projects out there that you might find interesting:</span>**

  * **<span style="font-weight: normal"><a href="http://code.google.com/p/uispec/">UISpec</a></span>**
  * **<span style="font-weight: normal"><a href="https://github.com/unboxed/icuke">iCuke</a></span>**
  * **<span style="font-weight: normal">Instruments Automation Testing (another blog post on this later)</span>**

**Continuous Integration**

**<span style="font-weight: normal"><span style="font-weight: normal">This is where the rubber meets the road. Getting your software working on your machine is one thing (and sometimes a hard thing), yet having a repeatable automated build that can build and test your software on another machine is something that makes me feel all warm and fuzzy inside. I have been using <a href="http://www.jetbrains.com/teamcity/">JetBrain&#8217;s TeamCity</a> for a few years now and wanted to get my project building, archiving, reporting unit tests and possibly code coverage (more about code coverage in another post).</span></span>**

Getting TeamCity up and running is fairly straightforward.

  * Download the latest version of TeamCity
  * Open a Terminal Window
  * Change to the directory where you unzipped TeamCity (/Application/TeamCity)
  * Change to the bin directory
  * Run TeamCity by executing the runAll.sh script (./runAll.sh start)

The hard part was getting the project running with test output, which is what this long winded post is all about.

**Team City Project Setup**

Using a sample project based on the [bowling game unit testing example](http://www.objectmentor.com/resources/articles/xpepisode.htm), here is how the project is setup. This is based on the sample for the OCUnitLogger project. This is a very simple setup and you can make this as complicated (or as easy) as you need it to be.

_Setup a Project_   
I created a project called OCUnitLogger and give it a good description.

_Setup a Build Configuration_   
I created one called Bowling with a description.

<img src="/content/scottdensmore/uploads/2011/04/Project-Setup.png" border="0" alt="Project Setup" width="600" height="255" />

_Setup the General Settings_   
I left all the defaults on this one.

<img src="/content/scottdensmore/uploads/2011/04/General-Settings.png" border="0" alt="General Settings" width="600" height="365" />

_Setup the Version Control Settings   
_ I left the defaults on most of these

<img src="/content/scottdensmore/uploads/2011/04/Version-Control-Settings.png" border="0" alt="Version Control Settings" width="600" height="324" />

_Setup a VCS Root_   
I set this to use git and check out anonymously using the default polling policy.

<img src="/content/scottdensmore/uploads/2011/04/VCS-Root.png" border="0" alt="VCS Root" width="600" height="492" />

_Setup a Build Step_   
This build step is probably the most important part. Building the project is quite easy. You setup the build to build from the command line using xcodebuild. (You can see usage for xcodebuild using xcodebuild -usage.) I have setup this project to just build all targets for this project. Also, I setup the reporting for my tests as JUnit and where it can find the xml file (more on this later).

<img src="/content/scottdensmore/uploads/2011/04/Build-Step.png" border="0" alt="Build Step" width="600" height="392" />

_Setup a Build Trigger_   
We want the build to trigger every time a checkin occurs so we set that up.

 <img src="/content/scottdensmore/uploads/2011/04/Build-Trigger.png" border="0" alt="Build Trigger" width="527" height="532" />**The Logger**

OCUnit works using the NSNotificationCenter. By creating a new object to listen for the events, we can create an xml document that mimics JUnit output.

<pre>NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
[center addObserver:self selector:@selector(testSuiteStarted:) name:SenTestSuiteDidStartNotification object:nil];
[center addObserver:self selector:@selector(testSuiteStopped:) name:SenTestSuiteDidStopNotification object:nil];
[center addObserver:self selector:@selector(testCaseStarted:) name:SenTestCaseDidStartNotification object:nil];
[center addObserver:self selector:@selector(testCaseStopped:) name:SenTestCaseDidStopNotification object:nil];
[center addObserver:self selector:@selector(testCaseFailed:) name:SenTestCaseDidFailNotification object:nil];</pre>

The new object is called OCUnitToJUnitLogger. I create a static instance and in each notification we generate the required nodes. I am using the Google Data XML node so that this works in both a Mac and iOS project.

<pre>static OCUnitToJUnitLogger *instance = nil;

static void __attribute__ ((constructor)) OCUnitToJUnitLoggerStart(void)
{
    instance = [OCUnitToJUnitLogger new];
}

static void __attribute__ ((destructor)) OCUnitToJUnitLoggerStop(void)
{
    [instance writeResultFile];
    [instance release];
}</pre>

The output goes to a file called ocunit.xml. You can change this in the OCUnitToJUnitLogger.m on line 88.

It is pretty easy to use. Drag the Logger folder into your project for your unit testing bundle and build. You will also need to add the libxml2.2.7.3 (or the latest) library to your link phase and then add /usr/include/libxml2 to the header search path.

 <img src="/content/scottdensmore/uploads/2011/04/libxml2.png" border="0" alt="Libxml2" width="399" height="111" /><img src="/content/scottdensmore/uploads/2011/04/libxml2-Headers.png" border="0" alt="Libxml2 Headers" width="577" height="120" />

**The Bowling Project**

**<span style="font-weight: normal">The bowling project is a Coca Framework project created with Unit Tests. It is pretty standard stuff. The only thing I did was add the logger to the project and this is what I get from TeamCity:</span>**

<img src="/content/scottdensmore/uploads/2011/04/Tests.png" border="0" alt="Tests" width="600" height="261" />

**Conclusion**

This is a pretty simple add to any of your projects. If you are using TeamCity and want to have a good log for your unit tests, you can drop this in and have TeamCity do the rest. If you want to make it better please fork from [here](https://github.com/scottdensmore/OCUnitLogger) and pound away.