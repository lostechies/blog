---
wordpress_id: 1274
title: 'How I Work Around The require(&#8220;../../../../../../../&#8221;) Problem In NodeJS'
date: 2014-02-20T06:00:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1274
dsq_thread_id:
  - "2291832581"
dsq_needs_sync:
  - "1"
categories:
  - JavaScript
  - NodeJS
  - NPM
---
Anyone building a large enough app in NodeJS will tell you that it gets really really really frustrating to have 3 or more lines of this in every module you build:

{% gist 9107152 1.js %}

It&#8217;s ugly. It&#8217;s hard to read. It&#8217;s hard to maintain. And when you need to refactor your file and folder structure, guess what you get to do to every one of these references? I spent a long time trying to find a way around this that was clean and elegant. There are no solutions that are both, at this point. So I picked the one that was the least ugly: modify the `NODE_PATH` environment variable to include a folder of my choosing.

## Modifying NODE_PATH

I now have this entry in my .bashrc file:

{% gist 9107152 2.sh %}

Having this allows me to put any of my apps&#8217; modules in to a ./lib folder, relative to the location from which I run the node executable. In other words, if my folder structure looks like this (from [SignalLeaf](http://signalleaf.com)):

<img src="http://lostechies.com/content/derickbailey/uploads/2014/02/NewImage2.png" alt="NewImage" width="100" border="0" />

Then all of my commands to execute code need to be run from the `app/` folder. This ensures all of the modules I&#8217;ve built in to the `app/lib` folder will be found when I use simple require statements like this:

{% gist 9107152 3.js %}

## Deploy NODE_PATH To Heroku

SignalLeaf, along with most of my other apps these days, is deployed to Heroku. In order to get the NODE_PATH to work on that setup, I have to use the `config:set` command from the Heroku toolbelt:

{% gist 9107152 4.sh %}

It&#8217;s a simple enough fix for Heroku and it ensures everything works when all commands are run from the root folder of the project. This means I have to set up my Procfile to do exactly that. Here&#8217;s what my Profile for the SignalLeaf web app looks like:

{% gist 9107152 5 %}

Notice that the commands are run with `folder/file/path.js` parameters. I do this to ensure the node command is run from the root folder, allowing the `NODE_PATH` to work correctly.

## I Would Prefer First Class Support From NPM

Ultimately, I would prefer first class support for local modules in NPM and package.json files. Right now, we can either specify a package that comes from NPMJS.org, or one that comes from a git repository. It would be optimal, in my opinion, to specify a relative folder path that points to my module.

{% gist 9107152 6.json %}

With that in place, NPM / Node&#8217;s `require` statement should use this local path to find the module. Yes, I understand that there are some issues in making this happen. Like I said &#8211; it would be my preferred way of handling it. I didn&#8217;t say it would be easy.

## Yes, There Are Other Solutions

Please don&#8217;t tell me to use NPM. I&#8217;ve read a lot of people suggesting this, and I think this is a terrible idea. Unless my understanding of NPM is wrong (and I don&#8217;t claim it isn&#8217;t &#8211; someone correct me, here!), this would expose code that should not be shared outside of the project / team by placing private code in a public repository. Yes, I know about &#8220;private&#8221; modules, but aren&#8217;t those still installable by anyone, as long as you know the name of it? They are just removed from the NPM directory, right? That&#8217;s a bad idea if I ever heard one. If new NPM company gives us private repositories that require authentication / authorization, and Heroku and other services support these private repositories, then maybe this will be an answer. But the idea of &#8220;private&#8221; NPM modules in a public repository is terrible, IMO. One good guess as to what your module name is, and the entire world can install it. This is simply not a viable option for software that isn&#8217;t open source.

As for the many other solutions &#8211; and there are a handful more &#8211; like I said, I chose the one that I found to be the least ugly and offensive. There were relatively few steps to get this working, and Heroku supports environment variables. So in the end, this is a win for me. I don&#8217;t doubt that other developers will prefer other solutions, though. I would love to hear how you&#8217;re solving this problem, actually. Drop a comment below and let me know what you&#8217;re doing to get around this issue.
