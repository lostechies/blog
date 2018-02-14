---
wordpress_id: 16
title: Organizing BDD Context/Specs For Findability
date: 2008-11-19T20:56:35+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2008/11/19/organizing-bdd-context-specs-for-findability.aspx
dsq_thread_id:
  - "262067914"
categories:
  - .NET
  - Agile
  - Behavior Driven Development
  - Continuous Integration
  - Resharper
  - Unit Testing
redirect_from: "/blogs/derickbailey/archive/2008/11/19/organizing-bdd-context-specs-for-findability.aspx/"
---
### Finding Classes With Resharper

It&#8217;s no secret that I&#8217;m a huge fan of <a href="http://www.jetbrains.com/resharper/" target="_blank">Resharper</a>. It rocks. I don&#8217;t like to code without it. One of the many features that I love is the Ctl-N shortcut to find a class. Resharper gives you this handy-dandy little search box:

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="58" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb.png" width="310" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_2.png) 

What I really love about this box is the ability to not know the entire class name when searching. If I know my class involves the word &#8220;Super&#8221; and &#8220;Sexy&#8221;, I can type the letters &#8220;SS&#8221; and the search box will pull up any class with matching uppercase letters. 

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="128" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_5.png" width="375" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_12.png) 

The same holds true for lowercase letters. I can do &#8220;SupSeV&#8221; and get results just matching those Upper/lower combinations.

### BDD Context Specifications Have Long Strange Names

It&#8217;s also no secret that I&#8217;m a fan of <a href="http://www.derickbailey.com/CategoryView,category,Behavior%2BDriven%2BDevelopment.aspx" target="_blank">BDD and Context/Specifications</a>. I love the language oriented nature of context specifications and how it&#8217;s easy for me to see what the behavior of the system is supposed to be, in any given context. I&#8217;ve been using BDD style syntax for many months now, and have amassed quite a collection of Context/Specification tests in my current code &#8211; especially with 4 other developers using BDD syntax. After having done several hundred tests in this manner, I&#8217;ve found that there is a pretty significant disconnect between how I use SpecUnit.NET and how Resharper&#8217;s class finder works &#8211; the names of my specification classes. Look at this specification class name for example:

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="79" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_2.png" width="671" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_6.png) 

How am I supposed to search for this class name? I can&#8217;t remember all those words, none of them are capitalized, and all those underscores are probably going to throw Resharper off in my search string. 

### Organizing Context/Specification Classes By Parent Class/File Name

To combat this problem, what I&#8217;ve started doing recently is throwing in the use of a parent specification class with the same name as the specification file that I&#8217;m working in. Since our team has standardized on the &#8220;Specs&#8221; suffix for all of our BDD tests, I know that a file name of &#8220;ValidationSpecs.cs&#8221; will have a class called &#8220;ValidationSpecs&#8221;. In the file itself, my specs will be subclasses, like this:

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="252" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_3.png" width="674" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_8.png) 

With the file name ValidationSpecs and the parent class ValidationSpecs, I now have much fewer words to remember and a much greater chance that I&#8217;ll be able to use Resharper&#8217;s class finder feature. All I need to know that I&#8217;m looking for the tests that deal with validation, so by our naming convention, I can type in &#8220;VS&#8221; or &#8220;ValSpecs&#8221; and get the list back that I want:

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="87" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_4.png" width="311" border="0" />](http://lostechies.com/content/derickbailey/uploads/2011/03/image_10.png)