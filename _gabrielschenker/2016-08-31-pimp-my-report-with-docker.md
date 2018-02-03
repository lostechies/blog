---
wordpress_id: 1719
title: Pimp my report with Docker
date: 2016-08-31T14:36:08+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=1719
dsq_thread_id:
  - "5109783117"
categories:
  - containers
  - docker
tags:
  - containers
  - Docker
  - reports
  - script
---
# Introduction

[<img src="https://lostechies.com/gabrielschenker/files/2016/08/report.jpg" alt="" title="report" width="322" height="259" class="alignleft size-full wp-image-1731" />](https://lostechies.com/gabrielschenker/files/2016/08/report.jpg)We are testing our Web portal with fully automated end-2-end tests against various combinations of Browsers and platforms. Today I had a task assigned which required to improve the quality of our [Sauce Labs](https://saucelabs.com/) test failure reports on [Bamboo](https://www.atlassian.com/software/bamboo). We are using the [Robot framework](http://robotframework.org/) to execute end-to-end tests and those tests are executed against various browsers on different platforms in [Sauce Labs](https://saucelabs.com/). Unfortunately the Robot framework doesn&#8217;t offer a direct way of manipulating the tests result output so I had to use some scripting foo to make it happen. To make things easier and platform independent I executed my scripts in a Docker container.

You can find more Docker related posts that I have written in [this index](https://lostechies.com/gabrielschenker/2016/08/26/containers-an-index/).

# The Goal

Bamboo by default shows a list of all failed tests on its dashboard. Each failed test is listed by name and some other attributes. The problem with our SauceLabs project was that this list did not indicate on which platform and for which browser the test was targeted. To find out more about this one had to drill down deeper in the artifacts (detail reports per platform/browser) of the test run which was painful.

The easiest solution seemed to be to change the name of the test and add a prefix which contains the platform and browser names.

The structure of a Robot generated test report (called `output.xml`) looks like this

[gist id=409844ced77a48dbfcd4b5a2851d63a9]

Thus I had to come up with a solution to find the value of the `name` attribute of all `<test>` tags in the XML document and concatenate this value with the prefix consisting of the browser and platform names. For this purpose I used `SED` and a bit of `Regex` foo. _I&#8217;m again and again baffled how powerful `Regex` is yet how easily I tend to forget everything about it&#8217;s syntax&#8230;_ The command I came up looks like this

[gist id=2cf1fcf7c168e9511fbe29572e735c65]

Here the variable `$prefix` contains the said combination of browser and platform name and `$file` is the test output file who&#8217;s test names need to be changed.

Now I have the detail results of all platform/browser combinations in respective sub-folders of my reports directory. The names of the subfolders are a combination of &#8220;[Platform]-[Browser]-[Browser Version]-[Test Run ID]-[Data]-[Time]&#8221;. Thus I need to loop over all `output.xml` files located in those sub-folders and modify them. The `$prefix` I can deduce from the folder name. The logic looks like this

[gist id=b2aa88736a9ec58a648301f74eaf0950]

Once I have modified all reports I can use the [Rebot](http://robot-framework.readthedocs.io/en/2.9.2/_modules/robot/rebot.html) tool of the Robot framework to generate a summary report. It looks like this

[gist id=f786a1d0747a8447014841e1dd5c167d]

That&#8217;s all.

# Docker enters the picture

Now why do I even want to consider using a container to run the above logic on Bamboo? First of all using a container allows me to test and run this logic on my laptop in exactly the same way as it will run on the build server Bamboo. Having a container I also do not depend on what is installed on the Bamboo build agent. The `sed` tool and `bash` are easy requirements but not so much `rebot` which is a Python application and needs the Robot framework library to be installed. That said, let&#8217;s define a `Dockerfile`

[gist id=dfce5ac563ab4aa61b6f6d9a5a8e2925]

The script `entrypoint.sh` contains the logic specified above. I can now build the Docker image

[gist id=5aa5e571d9fb5f95631a098942414f8a]

and then run it

[gist id=98d3009ea89a7566cf446a0093c93336]

Please note the volume mapping I&#8217;m using to mount the directory containing the test output into the container.

Finally I can add a script tasks in Bamboo to the Sauce Labs project to build and execute this container after all tests have run and before the final parsing of the test results by Bamboo.

This is a good sample showing that containers are not only useful to run our applications and application services but they are equally well suited to run quick one-time tasks.

If you liked this post then you can find more Docker related posts I have written in [this index](https://lostechies.com/gabrielschenker/2016/08/26/containers-an-index/).