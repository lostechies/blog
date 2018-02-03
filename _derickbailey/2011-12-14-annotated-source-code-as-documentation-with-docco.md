---
wordpress_id: 712
title: Annotated Source Code As Documentation, With Docco
date: 2011-12-14T09:27:59+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=712
dsq_thread_id:
  - "504301405"
categories:
  - Uncategorized
---
With the first bits of my [Backbone.Marionette](https://github.com/derickbailey/backbone.marionette) plugin being available on Github now, I wanted to try out the Backbone-style of annotated source code as documentation. I like the way [Backbone has this set up](http://backbonejs.org/docs/backbone.html), and I often refer to it when I want to know how something works internally, or find a specific piece of code to copy.

You can find [the annotated code for Backbone.Marionette here](http://derickbailey.github.com/backbone.marionette/docs/backbone.marionette.html).

Note that this only part of the documentation solution for a project, though. If you expect to annotate your source code and call your documentation done, you&#8217;re a scumbag oss coder:

<img title="ScumbagCoder.jpg" src="http://lostechies.com/derickbailey/files/2011/12/ScumbagCoder.jpg" border="0" alt="ScumbagCoder" width="400" height="402" />

That being said… commenting your code is a great way to provide additional documentation. It will help people understand the code they are reading, and help them write better code using your library or framework.

## Docco

To generate the annotated document for Backbone.Marionette, I used [Jeremy Ashkenas&#8217; &#8220;Docco&#8221; tool](http://jashkenas.github.com/docco/) &#8211; the same one he uses to generate Backbone&#8217;s annotated source code. The great thing about this project site: it&#8217;s build using the Docco tool. 🙂

There are a number of different ports for this tool available, so you can run it in NodeJS, Ruby, Python, .NET and more. I decided to use the NodeJS version that Jeremy built, mostly because I&#8217;m always looking for an excuse to use NodeJS tools. The process of getting this up and running was surprisingly simple, though it did involve a few steps and a bit of guess work on my part. Hopefully this blog post will help others get around the guess work.

## The Source Code

If you read through the source code for Backbone.Marionette, you&#8217;ll find a bunch of standard // comments throughout the code. This is pretty normal stuff, for the most part. I&#8217;ve added some comments above my objects and methods, to help explain what they are and how to call them.

The only significant difference between a normal command and a Docco ready comment is that some of the comments have a //&#8212;&#8212;&#8212;&#8212;&#8212; line underneath of them. This tells Docco that this is going to be a section header, in the compiled documentation. Using a fixed with font, set the number of &#8211; in that comment line to the same width as your header title:

[gist id=1476877 file=comments.js]

Other than that, comment your code as you normally would. You can also do some cool tricks like using \`bacticks\` around code, and the generated document will encompass that inside of a &lt;code&gt; tag, with CSS set accordingly. There&#8217;s likely some other tricks you can do, too, as this is all run through a Markdown processor to build the docs.

Side note: if you haven&#8217;t learned Markdown yet, do yourself a favor and learn it. It&#8217;s becoming the ubiquitous documentation and code commenting style around the development community. I think this is largely due to Github supporting it and encouraging it&#8217;s use in readme files and Github wiki pages. I&#8217;m at the point where I take notes in Markdown, when attending technical sessions or taking notes from conversations.

## Docco Prerequisites

There are a few things you&#8217;ll need to install if you want to use the NodeJS version of Docco:

  * NodeJS
  * NPM (Node Package Manager)
  * CoffeeScript
  * Python
  * Pygments

If you&#8217;re on a Windows machine, you can find installation instructions for NodeJS, NPM and Python around the web fairly easily. Here&#8217;s the instructions for OSX:

**NodeJS (via Homebrew):**

[gist id=1476877 file=nodejs.sh]

**NPM:**

[gist id=1476877 file=npm.sh]

**CoffeeScript:**

[gist id=1476877 file=coffeescript.sh]

**Python:** 

May be included in OSX… might be part of XCode. I&#8217;m on OSX Lion and I have the latest XCode. I didn&#8217;t need to install anything for Python to be available to me. Python is needed for the &#8220;easy_install&#8221; tool, which is Python&#8217;s package manager (similar to NPM or RubyGems).

**Pygments:**

[gist id=1476877 file=pygments.sh]

I&#8217;m not actually sure if you need to install the NPM pygments… I did, and things worked well for me. I&#8217;m assuming this is needed so NodeJS can run the Pygments tool.

## Installing Docco

Once you have all the prerequisites in place, installing Docco is a one liner:

[gist id=1476877 file=docco.sh]

Now you have access to the \`docco\` command line tool.

## Running Docco On Your Code

This is super easy. Just run \`docco {file pattern}\` from the command line. For example, the above \`comments.js\` file can be run like this:

[gist id=1476877 file=commandline.sh]

You can also use file patterns such as \`*.js\`

## Setting Up A Rake Task

I don&#8217;t like to run things manually when I don&#8217;t have to. Since my Marionette project uses Sinatra and Rake to run it&#8217;s Jasmine test suite, I decided to create a Docco task. Here&#8217;s what that would look like, for the above comments.js file:

[gist id=1476877 file=rake.rb]

Now I can run \`rake docco\` from the command line and it will build the docs for me. … yeah, this is probably overkill, but I wanted to do it anyways. 🙂

## The Results

Here&#8217;s the results of running Docco against the above comments.js file ([view it here, if you&#8217;re in an RSS reader](http://jsfiddle.net/eHEPS/)):
