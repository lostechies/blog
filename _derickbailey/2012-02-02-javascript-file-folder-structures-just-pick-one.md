---
id: 795
title: 'JavaScript File &#038; Folder Structures: Just Pick One'
date: 2012-02-02T07:29:31+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=795
dsq_thread_id:
  - "561559798"
categories:
  - AntiPatterns
  - Backbone
  - JavaScript
  - Model-View-Controller
---
Rails wants you to put specific files in specific folder structures, based on the object type that will be in the file. Java demands that files in a folder structure are namespaced by that folder structure. VisualStudio also makes it seem like file / folder names should be the namespace / class name as well &#8211; but that&#8217;s just a good suggestion and not a requirement. Other languages and frameworks have some requirements for how you organize your files, too… with the exception of browser based JavaScript (… mostly…)

## JavaScript File Organization: You&#8217;re Doing It Right

The reality of JavaScript in general web-based development (not talking about server side at all, here) is that it makes absolutely no difference how your files and folders are organized. Zero difference at all… at least as far as the JavaScript runtime is concerned.

The only thing that matters is that you include your files in your HTML with a <script> block, correctly. You also need to pay attention to which order they are included in most cases, to make sure things are defined before they are used (tools like RequireJS and other script loaders and module definition / loaders help with this).

What does this really mean? It means:

> **_You&#8217;re Doing It RIGHT!_**

Yup. You&#8217;re doing it right, because it doesn&#8217;t matter how you do it.

What does matter, though, is that you and your team (if you have a team) pick an organizational convention and stick with it. It&#8217;s actually very more important for your team to have a good file and folder structure for your JavaScript. But you don&#8217;t need to worry about what that structure is. Pick a standard and use it. When it fails (and it will), re-work your structure so that it works within the newly understood constrains and move on.

Of course, that fact that your browser and it&#8217;s JavaScript runtime don&#8217;t care about your file and folder organization doesn&#8217;t I&#8217;m without _my_ opinions on how files and folders should be organized.

For example&#8230;

## M, V and C Folders

A lot of people organize JavaScript MV* application files in a folder structure like this (BackboneJS in this case):

<img title="Screen Shot 2012-02-01 at 9.43.16 PM.png" src="http://lostechies.com/derickbailey/files/2012/02/Screen-Shot-2012-02-01-at-9.43.16-PM.png" border="0" alt="Screen Shot 2012 02 01 at 9 43 16 PM" width="417" height="80" />

To the best of my knowledge, this folder structure is based on the &#8220;models&#8221;, &#8220;views&#8221; and &#8220;controllers&#8221; folder structure that was popularized by Ruby on Rails. Sure others may have had it first, but it was Rails that made it popular. Other MVC framework followed suit and demanded that you put your controller objects in the controllers folder, your model objects in your models folder, etc. But unless you&#8217;re Rails (or another framework that wants to be like Rails), this folder structure is stupid.

I&#8217;m pretty sure that Rails uses this folder structure to assume the types of objects that are found within the files. And I know for sure that it uses file names to assume the class that will be defined within the file. That is, when rails sees a file called &#8220;/app/controllers/foo_controller.rb&#8221;, it expects to find a class called &#8220;FooController&#8221; and it expects that this class will inherit from some Rails controller base class. If these expectations are not met, errors are thrown to say so.

I understand why Rails does it this way: file and folder based conventions make it easy to assume what a file will contain, and that makes it easy for the runtime to optimize for performance when pre-loading and caching the code contained within the files. This makes sense to me in Rails because the convention is based on good ideas for optimizing the way Rails works and the way it looks for files and how it loads them.

But, unless you&#8217;re Rails or another framework that wants to assume certain files in certain folder contain certain code, this is a terrible way to organize files.

## The Junk Drawer

There are some good examples of other standards along this line. For example, I tend to follow the convention of a &#8220;public&#8221; folder with &#8220;css&#8221;, &#8220;images&#8221;, and &#8220;javascripts&#8221; folders. But honestly, this folder structure exhibits many of the same problems of being stupid that organizing files in M, V, and C folders does.

The real problem with these types of folder structures is that they become junk drawers. Even DHH and the Rails core team recognize that this is a poor folder structure outside the confines of Rails+Ruby code. That&#8217;s one of the reasons they added the Asset Pipeline in Rails 3.1. DHH even called the &#8220;javascripts&#8221; folder a junk drawer, very directly, in a RailsConf keynote in 2011 (or was it 2010?) &#8211; complete with a slide showing a drawer full of junk.

With any application that moves beyond a trivial number of files, these content-type, mime-type, code-type and general type-based folder structures turn in to a bloated pile of junk that is very difficult to sift through. Who wants to look at a folder with 20, 50 or 100 files in it, when you only really care about 2, 5 or 10 of those files?

And what happens when you suddenly have an object type that doesn&#8217;t fit your pre-established conventions? You end with a &#8220;lib&#8221; folder, like Rails, which becomes the ultimate junk drawer. &#8220;It&#8217;s not a model? It&#8217;s not a controller? It goes in lib.&#8221; &#8211; no matter what the actual functionality contained within the file is. The &#8220;lib&#8221; folder is asking to be a junk drawer… demanding it, really. So, do you follow that same junk drawer convention for non-M, V or C type-based files in your JavaScript apps? That doesn&#8217;t any make sense to me.

## How I Organize Files: By Functionality

I prefer to organize my JavaScript files the way I used to organize my C# files in .NET projects: by functional area of the application. That is, I group files together in folders based on the area of the application that they facilitate.

For example, my BBCloneMail application has the following folder structure for it&#8217;s JavaScript:

<img title="Screen Shot 2012-02-01 at 9.47.12 PM.png" src="http://lostechies.com/derickbailey/files/2012/02/Screen-Shot-2012-02-01-at-9.47.12-PM.png" border="0" alt="Screen Shot 2012 02 01 at 9 47 12 PM" width="418" height="112" />

Note that I&#8217;m still using the &#8220;javascripts&#8221; parent folder, but underneath of that I&#8217;m organizing by functional area of the application. In the root &#8220;javascripts&#8221; folder, are the primary application files &#8211; the ones that define the overall application bits. In the &#8220;mail&#8221; folder are all of the files that relate to the &#8220;mail&#8221; application. And, in the &#8220;contacts&#8221; folder are all of the files that relate to the &#8220;contacts&#8221; application.

I don&#8217;t care what &#8220;type&#8221; is contained in the file. That&#8217;s a completely irrelevant way to organize files to me. It makes no sense for me to organize files this way because many of my files contain more than one &#8220;type&#8221; of object. For example, I often put very simple model, collection and view definitions that are very closely related, in the same file.

## Why Type-Based Folders Might Be A Good Idea

In spite of all my over-opinionated hand-waiving above, there are some good reasons to use type based folders in JavaScript. One reason is asynchronous file loading based on conventions.

You might have a JavaScript app that makes use of a templating engine (of which there are dozens, these days). It&#8217;s not always a good idea to pre-load every possible template in to the user&#8217;s browser, for download size and performance reasons. Sometimes it makes sense to fetch the template that you want the first time it&#8217;s requested.

To do this, it might make sense to use a convention to retrieve the files. I&#8217;ve seen several Backbone apps that use a jQuery selector to load files, as one example of this. When a Backbone view specifies a template as &#8220;#my-view-template&#8221;, the application&#8217;s template manager would make a request to the server to load something along the lines of &#8220;/templates/my-view-template.html&#8221;.

If you&#8217;re trying to organize your templates in a functional area of the application, you&#8217;ll have the added overhead of inserting the functional area folder name, such as &#8220;/mail/templates/inbox-template.html&#8221; for an &#8220;Inbox&#8221; view in a &#8220;mail&#8221; app, trying to load an &#8220;#inbox-template&#8221; jQuery selector as the template to render.

So… there&#8217;s at least one possible reason to use a type-based folder. I would still stick the type-based folder name under my functional area, though. I don&#8217;t want to mix up the templates between my functional areas of the application, by accident.

## A Tradeoff: Folder Names vs File Names

Here&#8217;s one potential trade-off for using functional folder names vs type based folder names: you might have to specify the type in the file name. For example, if you have a model type name &#8220;Person&#8221;, a collection type named &#8220;Persons&#8221;, and a view to represent a single person or a collection of persons, what do you call that view? If you&#8217;re organizing things by type, you can call every &#8220;Person&#8221; and &#8220;Persons&#8221;

This can be very confusing. I was recently working with a client who was using an editor that only shows the file name for the open files, and none of the folder path for the files. He ended up with 4 &#8220;person.js&#8221; files in his open file list. Which one was the Person model, view, router, or controller file? We had to open each file to find the one we needed, every time. So, we took the hit on the file names. The &#8220;person.js&#8221; file contained the person model, while &#8220;persons.js&#8221; contained the collection, &#8220;personviews.js&#8221; contained the view definitions and &#8220;personrouter.js&#8221; contained the router. Thus, we&#8217;ve moved the need for specifying the object type from the folder structure (with all it&#8217;s bad ideas for using that) to the file name.

I&#8217;ve read at least one blog post that advocated using type-based folder names specifically to avoid the &#8220;ugliness&#8221; of having type names in your files. I seriously laughed out loud when I read that. Whether the type is in the file name or folder name is a moot point. You&#8217;re likely going to end up specifying the type somewhere. I would much rather have it in my file names because it&#8217;s easier for me to see things grouped together based on functionality, than based on the type of object contained in a file.

## It&#8217;s Just An Opinion, And A Loose One At That

My own use of these conventions and ideas is rather loose at this point. I don&#8217;t stick strictly to anything, and I mix and match based on the project type, number of files and other constraints that a given project presents. Because, like I said at the top of this egregiously long post, you&#8217;re doing it right.

No matter what file and folder structure you pick for you JavaScript apps (assuming you&#8217;re using a suite of libraries that doesn&#8217;t force you in to a specific folder structure), you&#8217;re doing it right. JavaScript in a browser environment really doesn&#8217;t care what the file and folder structure is. But that doesn&#8217;t mean we as developers shouldn&#8217;t care. Pick a file and folder structure that fits the constraints of your application and change the structure as your app&#8217;s constraints change.