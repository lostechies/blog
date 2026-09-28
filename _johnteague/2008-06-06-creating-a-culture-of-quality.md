---
wordpress_id: 10
title: Creating a Culture of Quality
date: 2008-06-06T20:28:33+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2008/06/06/creating-a-culture-of-quality.aspx
dsq_thread_id:
  - "262055517"
categories:
  - TDD
redirect_from: "/blogs/johnteague/archive/2008/06/06/creating-a-culture-of-quality.aspx/"
---
I&#8217;ve been testing my code for a long time.&nbsp; I finally got on the TDD / BDD bandwagon a year ago and haven&#8217;t looked back.&nbsp; But as much as I believe that testing is important, and I would never write professional code without an extensive suite of unit tests, I still find myself writing code at home without tests.&nbsp; The reality is that it takes discipline to keep a test driven approach to software development on track.&nbsp; When talking about a company that follows these practices and has the normal turnover of staff, it become even more important to have a culture that embraces, encourages and, when necessary, enforce quality at all stages of development.

So how do you create this culture of quality?&nbsp; It doesn&#8217;t happen overnight and it will definitely doesn&#8217;t happen on it&#8217;s own.&nbsp; You&#8217;re entire team has to work toward creating the culture that embraces it at every step.

### Make it Easy

It takes a great deal of work to incorporate quality from the beginning of the project.&nbsp; Don&#8217;t make it any harder than it needs to be.&nbsp; An automated build process is extremely important.&nbsp; You need to be able to be able to &#8220;push a button&#8221; and compile and run all unit test for your entire application.&nbsp; There are a lot productivity tools help with this too.&nbsp; In the .Net world, Resharper should be a required tool in your toolbox.&nbsp; The refactoring and navigation enhancement it provides make it possible to take a continuous design approach to your application.&nbsp; Integrated source control and testing tools are also important.&nbsp; It needs to be simple and easy to run a single or all unit tests, and if you can do that from within your IDE you are off to the races.

### Code Coverage

Having a high level code coverage percentage is one way to ensure that you have quality in your process.&nbsp; High coverage by itself is not an accurate measure of quality and 100% coverage is not going to guarantee it.&nbsp; However it is low hanging fruit, and it can give you a level of comfort when it&#8217;s time to refactor to a better design that you will not break existing functionality.

### Continuous Integration

[Continuous integration](http://en.wikipedia.org/wiki/Continuous_Integration) is the best tool you can use to help create culture that expects quality.&nbsp; In a CI process, you can set the build to fail if any of your test fails, or if you fall below your test coverage threshold.&nbsp; This gives the team immediate feedback when something goes wrong and can be fixed immediately.&nbsp; 

### Don&#8217;t Leave a Build Broken!!!

Even if you have a CI process in place that runs all your tests and measures your code coverage, if you allow the build to stay broken, all of your work is for nothing.&nbsp; At the same time, breaking a build should not be a criminal offense. You want your team&nbsp; members to commit their changes frequently.&nbsp; When they do this it&#8217;s okay to have a build fail.&nbsp; You don&#8217;t want developer to be overly cautious when committing, fearing a broken build.&nbsp; What you don&#8217;t want is to let a build stay broken.&nbsp; If you leave a build broken for a long period of time, it is a symptom of apathy about keeping the code base at a&nbsp; high level of quality.&nbsp; 

You should also never commit changes to a broken build.&nbsp; You don&#8217;t know what impact your changes will have on a systems that is not passing all of it&#8217;s tests.&nbsp; Also remember that the team has ownership of the code.&nbsp; Anyone can fix the build (that includes you), it doesn&#8217;t have the person who broke the test.

There are lots of ways to enforce this.&nbsp; The easiest way is that tools like CruiseControl and TeamCity (I think) let you attache sounds to build events.&nbsp; One thing [Jeffrey Palermo](http://codebetter.com/blogs/jeffrey.palermo/Default.aspx) does is to have everyone on the team choose a sound for build success and failure.&nbsp; This gives the team positive and negative feedback to the build process.

<img style="margin: 1px" height="90" src="http://tbn0.google.com/images?q=tbn:CXBmAiO9pz3q8M:http://www.electronics123.net/amazon/pictures/haa40r.jpg" width="120" align="left" />

Many people hook up a red strobe light to the build system.&nbsp; That way it is glaringly obvious to the team that something is wrong.&nbsp; A variation of this using a lava lamp and the goal is to fix the build before it starts bubbling.&nbsp; 

The danger here is that you don&#8217;t want your team to fear committing frequently.&nbsp; Life becomes much harder if people leave lots of code modified while they are working on a story or task.&nbsp; As I said, it&#8217;s okay to break the build, just don&#8217;t leave it broke.

### Bugs Are Blocking Issues

When working on a new project and you&#8217;re got all of these story cards for new features, it is not much fun to work on bugs.&nbsp; But it is essential that when bugs are found during the development phase that they are placed on the board as blocking issues.&nbsp; If there are any reported bugs on your task board, you finish those before starting a new story.

These are just a few techniques you can do to instill a culture of quality in your organization.&nbsp; I&#8217;m sure there are more.&nbsp; What do you do to create a culture that values quality?