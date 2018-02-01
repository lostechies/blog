---
id: 32
title: 'Agile Web Development with Rails &#8211; Chapter 3'
date: 2007-09-15T17:50:01+00:00
author: Joey Beninghove
layout: post
guid: /blogs/joeydotnet/archive/2007/09/15/agile-web-development-with-rails-chapter-3.aspx
categories:
  - Books
  - Rails
  - Reviews
  - Ruby
---
Hmm, well I&#8217;ve already zoomed through to chapter 8 in my actual reading/coding.&nbsp; Better start getting these notes cranked out.&nbsp; Oh, and why not [purchase the book yourself](http://www.pragmaticprogrammer.com/title/rails/) and follow along.&nbsp; It&#8217;d be interesting to get comments from other folks who are currently going through the&nbsp;RoR learning experience.

#### Chapter 3

This chapter mainly deals with the infrastructure of&nbsp;getting Ruby and the Rails framework installed, along with MySQL.&nbsp; Luckily us &#8216;softies on Windows can just use the very cool InstantRails package, which is a 100% self-contained package of Ruby, Rails, MySQL and even an Apache web server with no actual installation required.&nbsp; Yep, this got added to my portable app library&nbsp;very quickly.&nbsp;&nbsp;Installation on Mac and Linux are also covered, which may come in handy one day when I&#8217;m able to get one of [these](http://www.apple.com/macbookpro/).&nbsp; (I am accepting donations&#8230;)&nbsp; 🙂

Using the command-line, a blip on version control and editors are covered next.&nbsp; It&#8217;s interesting to me that so far I have NOT missed my fancy VS 2005 IDE when coding Ruby.&nbsp; Dave points this out and offers a quick plug for TextMate, which is pretty much everyone&#8217;s favorite editor for coding in the Ruby community, and from what I&#8217;ve seen, I can understand.&nbsp; But alas, us Windows users are left out in the cold again.&nbsp; Although I have been using what might be the next best thing to TextMate for Windows which is the [e text editor](http://e-texteditor.com/).&nbsp; It seems to have a lot of the features of TextMate and can even use the exact same bundles, which is where most of the editing power comes from.

Database support is pretty good in Rails as well, with all the major ones supported.&nbsp; Most folks seem to stick with MySQL which is fine by me.&nbsp; But SQL Server is supported for all of you who feel like you just \*have\* to keep one foot in the Microsoft camp.&nbsp; 😉

And finally, we get a little taste of something called RubyGems.&nbsp; This is&nbsp;one of the really cool things that seems to be missing from every other framework I&#8217;ve worked with.&nbsp; The ability to issue a simple command at a command-line and have the entire framework and plugins downloaded and/or updated, including all of its dependencies is extremely useful.&nbsp; It even keeps a history of the previous versions.&nbsp; Genius, I say!&nbsp; In .NET, imagine how much time has been wasted by having to open a browser, finding the framework/plugin update you&#8217;re looking for, downloading it, unzipping it and copying the assemblies to your project folder.&nbsp; Oh, and don&#8217;t forget that you have to update your project &#8220;references&#8221;, blah, blah.&nbsp; 

<side_note>

_As I&#8217;m starting to build my first RoR application (even though it&#8217;s the sample from the book), I&#8217;m starting to realize just how much time is wasted on&nbsp;non-business related&nbsp;&#8220;things&#8221; when coding in .NET with VS 2005.&nbsp;_ 

_**NOT ONCE&nbsp;have I had to**:_

  * **_Add New Project_** 
      * **_Add Project References_** 
          * **_Even Compile!_**</ul> 
        _Of course, tools like ReSharper definitely help speed things up, coding-wise.&nbsp; But you still have to muck around all of the &#8220;features&#8221; of VS 2005 like projects and references.&nbsp;&nbsp;I&#8217;m starting to imagine&nbsp;how much faster I could deliver more business value if I didn&#8217;t have to worry about stuff like this._
        
        </side_note>