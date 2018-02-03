---
wordpress_id: 993
title: 'A WinJS SpecRunner: Automating Script Tag Insertion For Unit Tests'
date: 2012-08-21T08:22:09+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=993
dsq_thread_id:
  - "813285830"
categories:
  - Jasmine
  - JavaScript
  - MochaJS
  - Productivity
  - Test Automation
  - Unit Testing
  - WinJS
---
Writing unit tests with Mocha or Jasmine is generally pretty easy. Once you have a test runner set up, it&#8217;s not much different than any other JavaScript environment, really. But the trick to this is getting a test runner set up.

## Getting A Test Project Set Up

Christopher Bennage has already blogged about [the basic set up that we put in to our project](http://dev.bennage.com/blog/2012/08/15/unit-testing-winjs/). The gist of it is that we have to manually add a linked file from our production app in to our test runner app, every time we need to write tests for that production file. We&#8217;ve also had to manually add the individual file reference as a <script> tag, along with a <script> tag for the tests for that file, in side of our &#8220;default.html&#8221; file. This tells the project to load and run the script and its associated tests. 

The result of all this manual <script> tag maintenance was painful at best, and nightmarish most of the time. Here&#8217;s an incomplete screenshot of all the files that we had to manually add as <script> tags. Note that I said _incomplete_ screenshot&#8230;

<img title="Screen Shot 2012-08-21 at 8.54.35 AM.png" src="http://lostechies.com/derickbailey/files/2012/08/Screen-Shot-2012-08-21-at-8.54.35-AM.png" alt="Screen Shot 2012 08 21 at 8 54 35 AM" width="339" height="600" border="0" />

## Reducing The Script Tag Nightmare

I got tired of this, as you can imagine, so I fixed it. Yesterday I introduced a bit of code that allowed me to reduce the number of <script> tags from what you see in the screenshot above, down to this:

<img title="Screen Shot 2012-08-21 at 8.59.33 AM.png" src="http://lostechies.com/derickbailey/files/2012/08/Screen-Shot-2012-08-21-at-8.59.33-AM.png" alt="Screen Shot 2012 08 21 at 8 59 33 AM" width="600" height="146" border="0" />

That&#8217;s much better! And the best part is, I don&#8217;t have to touch this file again. I can add specs to my app, and link production files in to the test runner all day long, and I never need to change this file. 

The key to the reduction of <script> tags is that last file I included: specRunner.js. This file takes advantage of the WinRT/WinJS runtime environment to examine the local file system that the code is running from, use a few very simple conventions along with a bit of configuration to find the files it needs, and dynamically generate the needed  <script> tags for me, inserting them in to the DOM.

## Configuring The SpecRunner

In the &#8220;default.js&#8221; page control, I have this code:

[gist file=default.js id=3415884]

Here you can see the few bits of configuration that I&#8217;m passing in &#8211; the folder that contains the source files, the spec files, and a helpers folder. This helpers folder is used to load up any helper scripts &#8211; extra libraries, common functions, and anything else you need that isn&#8217;t directly a test. Just drop a .js file in this folder and it will be included in the test runner.

I&#8217;ve also included an &#8220;error&#8221; event that gets dispatched from the spec runner object, as you can see. This uses [the eventMixin that I&#8217;ve blogged about before](http://lostechies.com/derickbailey/2012/07/31/winjs-event-aggregators-and-observableevented-objects/) to dispatch events. The purpose of this trigger is to let you know when the test runner configuration has failed. It does not report errors from Mocha or Jasmine or anything like that, only from the spec runner set up.

## Coding The SpecRunner

My implementation of the spec runner is fairly simple, but it does do quite a bit. The [heavy use of WinJS promises](http://lostechies.com/derickbailey/2012/07/19/want-to-build-win8winjs-apps-you-need-to-understand-promises/) necessitates a lot of callback functions which I like to organize in to a series of steps to perform.

[gist file=specRunner.js id=3415884]

You can the high level list of steps in the &#8220;run&#8221; method, with each of those primary steps being a breakdown of other steps to takes. I&#8217;ve also hard coded my version of the spec runner to configure and run Mocha tests. It would not be difficult to change this to run Jasmine tests, or to abstract this a little bit more and make the test runner configurable with callback functions or other means.

## Follow The Code; We&#8217;re Not Done Yet

I love this solution. It was easy to write and it works very well for our project. But we&#8217;re not done solving the unit testing problem, yet. I still have to manually link the files from the production app in to the test app. We&#8217;re thinking through solutions to that problem as well, but it&#8217;s proving to be much more difficult than we had hoped.

Also, if you&#8217;re interested in following along as we make project through this project (through the end of September, basically), you can get the code from [our CodePlex repository](http://hilojs.codeplex.com/). Be sure to check out the discussion list as well. There&#8217;s a lot of great discussion going on, and some very interesting insights in to the thought process of our project structure and architecture.