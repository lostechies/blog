---
wordpress_id: 3161
title: Evaluating TeamCity as a CC.net Replacement
date: 2008-01-06T21:26:09+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2008/01/06/evaluating-teamcity-as-a-cc-net-replacement.aspx
dsq_thread_id:
  - "262125678"
categories:
  - Uncategorized
---
Over the last week or so I have installed <a href="http://www.jetbrains.com/teamcity/index.html" target="_blank">TeamCity</a> at home and at work to replace CruiseControl.NET. My interest was originally sparked by <a href="http://blog.eleutian.com/2007/12/22/CruiseControlNETIsDeadLongLiveTeamCity.aspx" target="_blank">this posting</a> by Aaron at Eleutian. After playing with TeamCity for a week I must say I am very impressed.

First and foremost I was getting tired of how difficult it was to setup a new project in CruiseControl. It required a lot of steps and was full of hair pulling and screaming at the monitor. TeamCity eliminates all of this by making the whole process amazingly easy. This comes from the fact that they have pretty much included everything to setup in a 7 step process from start to finish.

You have a number of different options when it comes to build runners. TeamCity will automatically tag your builds with build number/svn revision number. It has support for all the major source control systems including subversion and vss. One really neat feature is the introduction of build agents. Unlike CruiseControl, you can have multiple other servers that are &#8220;build agents&#8221;. Once a build is triggered any of the compatible build agents will come in and begin compiling your code. By default the server that TeamCity is on is the only build agent but you can easily add more to spread the load of building your projects. The free version of TeamCity only allows for 3 build agents but liscences for more build agents are only $300 each. Not too bad.

All of the cool options and features aside, the real power comes from the amount of reporting you can get out of this tool automatically with minimal effort. Here is a screenshot of the statistics pane which gives you an overview of all builds of a specific build configuration of a project.

&nbsp;<img height="470" src="http://i184.photobucket.com/albums/x270/dkode8880/tc1.jpg" width="645" />

Here is another screenshot of an overview of what changes I have made to the project recently. This part is really neat as it integrates with your source control system. There is a user setting where you set what your source control username is and TeamCity automatically pulls the checkins for your account and compiles them in a tidy little list of changes.

 <img height="303" src="http://i184.photobucket.com/albums/x270/dkode8880/tc2.jpg" width="657" />

Another cool feature is the ability for TeamCity to compile VS 2008 SLN files. There are runners included with TeamCity that will also build VS 2005 SLN files. This way you are not obligated to use MsBuild if all you want to do is build&nbsp;a solution file. This makes life a lot easier. I was already using the nant msbuild task so this is a moot point for me, but I&#8217;m sure other people will find this part interesting.

To get your test data into TeamCity all you need to do is just add the test runner element to your build runner. TeamCity will detect that you are running tests and automatically pick up the output and include it in the report. In addition to this, TeamCity will show your running tests as they are being executed through the web interface.

Getting code cverage reports into TeamCity is a little more difficult. You can include custom reports into TeamCity by reading <a href="http://i184.photobucket.com/albums/x270/dkode8880/tc2.jpg" target="_blank">this link here</a>

TeamCity comes with a number of different notification utilities such as a windows tray notifier, visual studio plugin, jabber notifications and a lot more. I haven&#8217;t even begun to dig into all the features in TeamCity. What I have mentioned here is just scratching the surface. Definately check it out if you are tired of poking around in xml configuration files for hours on end.