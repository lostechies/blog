---
wordpress_id: 543
title: Resources For, And How I Learned Backbone.js
date: 2011-09-13T19:54:47+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=543
dsq_thread_id:
  - "413864496"
categories:
  - Backbone
  - Education
  - JavaScript
  - Test Automation
  - Unit Testing
---
I received an email from [Mark Muskardin](http://fromthought2web.com/), today, asking me some questions centered around how I ramped up and learned backbone, and looking for some good resources, too. I&#8217;ve had similar questions a number of times in recent weeks, so with Mark&#8217;s permission, I&#8217;m posting his questions and my answers here.

**Update:** I&#8217;ve put together a more complete list of [resources on my BackboneTraining.net site](http://backbonetraining.net/resources), and will keep that page up to date. Be sure to check that list for more links and additional resources.

## 1) How did you ramp up on Backbone?

Mostly trial and error, honestly. I would try something to see if it worked or not and dig into the Backbone source code to find out why it didn&#8217;t in most cases. I also spent a lot of time looking at the example backbone code I could find in blog posts, in the documentation, etc.

In the end, though, it was really the throw-away applications I built that had the most impact for me. I would spend a few hours a night thinking about another way to approach a specific scenario in backbone, and try it out. In the process of doing this and exploring the different aspects of backbone, I learned a lot about how it works and how i like to work with it. (FWIW: I think this pretty well describe my learning style)

I also have a strong background in building windows applications with a model-view-presenter structure, in a composite application style. Backbone fits easily into my prior experience in this realm, so a lot of what i have been trying out and learning is stuff that i knew how to do previously, just putting it in to play in a different language and runtime. I think this gave me a pretty good advantage in terms of &#8220;things to try&#8221; in my throw-away apps.

Lastly &#8211; I started spending time keeping up with the Backbone mailing list, and the Backbone questions on StackOverflow. Try to answer questions, and seeing the answers that others provide has helped me a lot. Not knowing an answer often leads me to dig deeper into something in order to learn, so that I can answer, too.

## 2) Are they are any tutorials you&#8217;d recommend?

I tend to prefer tutorials that not only tell you what and how, but also why. So it shouldn&#8217;t be a surprise that I&#8217;m listing a handful of screencasts that I thought were tremendously informative. Every one of them has taught me a number of little details and/or given me a few ideas to try out.

(in no particular order)

  * **Peepcode**: episode 1) <http://peepcode.com/products/backbone-js> and episode 2) <http://peepcode.com/products/backbone-ii>. The Peepcode series takes a client-side-first approach, saving the server communications for later (I think that will be episode 3 &#8211; which is being produced now, I hear)
  * **Tekpub**: <http://tekpub.com/view/mvc3/6> &#8211; This one is centered around integrating backbone with asp.net mvc 3. If you&#8217;re doing asp.net mvc work, this screencast series is a must-have. Even if you&#8217;re not, the backbone episode is excellent. I&#8217;m not doing any .net work right now, and I picked up a few tricks and new perspectives that I&#8217;ve applied to my code.
  * **Joey Beninghove**: <http://joeybeninghove.com/2011/08/16/backbone-screencast-introduction-views/> and <http://webinars.developwithpassion.com/webinars/7> &#8211; Joey is a coworker of mine and is doing several screencasts / presentations on backbone. He takes a very detailed approach to each of the subject he&#8217;s doing. 
  * **Refactoring to backbone**: <http://www.refactoringtobackbone.com/> &#8211; by Joe Fiorini. it&#8217;s not released yet, but i&#8217;ve talked with him about this a few times, and i love what he&#8217;s doing with it. the ideas is not to start with a blank slate, but to convert existing javascript code over to backbone

(Note: i&#8217;m also working on a very extensive screencast, but it won&#8217;t be available until probably late this year or early next year…)

There&#8217;s also the thoughtbook book: <http://workshops.thoughtbot.com/backbone-js-on-rails>. It&#8217;s a work in progress, but it&#8217;s worth keeping up with the progress. They&#8217;re doing a really cool thing with community involvement. I&#8217;ve been reviewing the book from time to time and offering suggestions for how to improve the book, now and then &#8211; as have a number of other people who have pre-purchased the book. There&#8217;s a lot of value in the book already, but it&#8217;s still in it&#8217;s early stages with much of it not being started yet.

Other than the screencasts and book, there&#8217;s a wealth of good backbone knowledge in blog posts, on the mailing list, and in the example apps in the documentation. Search around and keep your eyes open as new information is continuously popping up.

## 3) How do you test your Backbone apps?

For integration tests with the rest of my system, I use Cucumber. Most of the testing I&#8217;ve done with Backbone has been through Cucumber since I already have that in my Rails application. I set the tests to use the Selenium driver and run them as part of my normal Cucumber suite.

For unit testing (which I&#8217;ve been doing more of, recently) I use Jasmine and the Jasmine-jQuery plugin. [My previous blog post](http://lostechies.com/derickbailey/2011/09/06/test-driving-backbone-views-with-jquery-templates-the-jasmine-gem-and-jasmine-jquery/) addresses this, specifically to get my views under test with my view templates in place. (I&#8217;m considering writing a small series and/or e-book on testing backbone, though this is also covered in my screencast, so i may not be able to write an entire e-book on it any time soon.)

## 4) I saw that your created a Backbone plugin.  Does Backbone have a similar plugin/gem ecosystem that jQuery/Rails has?  How can I get started?

While it&#8217;s not as extensive as jquery or rails, there is a growing backbone plugin ecosystem. There&#8217;s also no automatic installation or package management like gems (or npm for node.js) or anything like that. Mostly, people just [list their plugin in the backbone wiki](https://github.com/documentcloud/backbone/wiki/Extensions,-Plugins,-Resources), talk about it on their blog and on the backbone mailing list, too.

Before you start, you&#8217;ll need to understand object oriented javascript, if you don&#8217;t already. For this, I highly recommend the book [&#8220;Javascript Patterns&#8221; by Stoyan Stefanov](http://www.amazon.com/JavaScript-Patterns-Stoyan-Stefanov/dp/0596806752). Once you&#8217;ve got an understanding of how OOJS works, it becomes pretty easy to see how to extend backbone with your own code.

The real question, then, is not &#8220;how&#8221; but &#8220;what&#8221; or &#8220;why&#8221;… the two plugins i&#8217;ve written were built out of my own needs and desires to stop writing the same code over and over again. [Backbone.ModelBinding](http://github.com/derickbailey/backbone.modelbinding) is a collection of the patterns I was using for binding models to view elements, and grew from there. [Backbone.Memento](http://github.com/derickbailey/backbone.memento) started as a quick hack to enable a cancel button on an edit form that I had, turned into a full memento pattern implementation, and started growing from there.

So, to get started… identify the common patterns in your own code, first. Extract those into something that a single project can use immediately. Then build and grow from there, as you see similar needs and variations in more and more projects.

## Practice, Practice, Practice

The most important thing to take away from this, is that you won&#8217;t improve or really learn anything until you do it yourself. It&#8217;s great to talk theory all day long (and I love doing that), but without the experience that comes from practice &#8211; the art of doing for the sake of learning &#8211; it&#8217;s just an unproven theory. Get your hands dirty with some throw-away projects, see what works and what doesn&#8217;t, and begin to develop your own subtle and nuanced opinions and patterns based on this experience.