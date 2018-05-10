---
wordpress_id: 906
title: 'Executing A Project-Specific Node/NPM Package A-la &#8220;bundle exec&#8221;'
date: 2012-04-24T06:52:13+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=906
dsq_thread_id:
  - "662324394"
categories:
  - Command Line
  - JavaScript
  - NodeJS
  - NPM
---
It&#8217;s no secret that I love NodeJS, though I really haven&#8217;t blogged about it much (if at all). Frankly, I think Node and NPM are going to be eating Ruby, RubyGems and Bundler&#8217;s $25,000 lunch &#8211; at least on OSX. But there&#8217;s at least one piece of bundler that I miss from NPM: the ability to say &#8216;bundle exec&#8217; and have it run a specific gem&#8217;s bin file (binary / executable) for the current project gem configuration and version.

If I run &#8220;npm install express&#8221; from within a folder, the &#8220;express&#8221; package will be installed in to my ./node_modules folder.

<img title="Screen Shot 2012-04-17 at 6.28.41 PM.png" src="https://lostechies.com/content/derickbailey/uploads/2012/04/Screen-Shot-2012-04-17-at-6.28.41-PM.png" alt="Screen Shot 2012 04 17 at 6 28 41 PM" width="600" height="222" border="0" />

But I can&#8217;t say &#8220;express foo&#8221; on the command line at this point, to run express. And I can&#8217;t say &#8220;npm express foo&#8221; or &#8220;npm exec express foo&#8221; or anything like that. This ability is sadly missing from NPM. There are a few ways to get around this, though.

## Global Modules

When you install a Node module with the \`-g\` option, it installs in to the global module list. Global modules can have their bin files run from the command line just like any other command. So if you install the &#8220;express&#8221; module, for example, with the global flag then you&#8217;ll be able to say &#8220;express foo&#8221; from the command line and watch it build a fresh new project for you in the &#8220;foo&#8221; folder.

<img title="Screen Shot 2012-04-17 at 6.30.23 PM.png" src="https://lostechies.com/content/derickbailey/uploads/2012/04/Screen-Shot-2012-04-17-at-6.30.23-PM.png" alt="Screen Shot 2012 04 17 at 6 30 23 PM" width="456" height="600" border="0" />

This is nice for packages that you want to have available for any application you&#8217;re building. I use global packages a lot because some of the tools that you can find in node packages are quite useful, even outside the context of a node project. But not every package should be installed in the global package repository for your computer.

## Run Bin From Relative Path

You can also run bin files from node modules by using the relative path of ./node_modules/.bin/ to find the command.

<img title="Screen Shot 2012-04-17 at 6.32.44 PM.png" src="https://lostechies.com/content/derickbailey/uploads/2012/04/Screen-Shot-2012-04-17-at-6.32.44-PM.png" alt="Screen Shot 2012 04 17 at 6 32 44 PM" width="442" height="125" border="0" />

This is a bit tedious, though it is functional. I&#8217;ve build a few simple command / shell scripts to execute some of my installed modules this way, for some of my projects. That makes it a bit easier overall, but you have to set up a shell script for each package you want.

## Run Bin From Generic Shell Script

Since all of the bin files for all of the node packages are installed in to ./node\_modules/.bin/ for a given project, why not build a generic &#8220;npm\_exec&#8221; shell script and just forward all the parameters?

Easy enough:

{% gist 2409904 npm_exec.sh %}

Just &#8220;chmod +x npm_exec&#8221; to make this file executable, and away we go.

Now I can run any arbitrary package binary I want. I could even put this little shell script in my /usr/local/bin folder and it would be available for all of my node projects, anywhere on my box.

<img title="Screen Shot 2012-04-17 at 6.35.03 PM.png" src="https://lostechies.com/content/derickbailey/uploads/2012/04/Screen-Shot-2012-04-17-at-6.35.03-PM.png" alt="Screen Shot 2012 04 17 at 6 35 03 PM" width="332" height="124" border="0" />

This is a nice little solution, even if it&#8217;s a work around for something that should be built in to npm.

## NPM Scripts In package.json

This last option is one that I&#8217;m using more and more often for project specific, recurring needs.

When you create an express app, it builds a package.json file for you. One of the pieces that it sticks in there is the &#8220;scripts&#8221; setting which contains a &#8220;start&#8221; setting, by default.

{% gist 2409904 package.json %}

It turns out you can use these &#8220;scripts&#8221; from the npm command line. When you call &#8220;npm start&#8221;, npm will execute the &#8220;scripts&#8221;/&#8221;start&#8221; configuration for you. By default, this is just a call to &#8220;node app&#8221; which runs the app.js file in node and gets your express.js app up and running.

You can do more with &#8220;scripts&#8221;, too. You can add your own named script, in fact.

{% gist 2409904 scripts.json %}

But you can&#8217;t just &#8220;npm foo&#8221;. The &#8220;start&#8221; script is recognized by npm explicitly. For other non-standard script names, you have to use the &#8220;run-script&#8221; command from node: npm run-script foo

<img title="Screen Shot 2012-04-17 at 6.38.18 PM.png" src="https://lostechies.com/content/derickbailey/uploads/2012/04/Screen-Shot-2012-04-17-at-6.38.18-PM.png" alt="Screen Shot 2012 04 17 at 6 38 18 PM" width="505" height="195" border="0" />

The other thing that this does for us, is give us direct access to all of the bin files that our node packages have installed. So within a &#8220;script&#8221; configuration, we can call any arbitrary package&#8217;s bin file.

For example, if I want to use the node-supervisor package to restart my app whenever any files change, I can set up my package.json file to look like this:

{% gist 2409904 supervisor.json %}

This will install the &#8220;supervisor&#8221; package for development only, and set up the &#8220;start&#8221; script to run &#8220;supervisor app&#8221;. Now from the command line, I can&#8217;t run &#8220;supervisor app&#8221; directly:

<img title="Screen Shot 2012-04-17 at 6.40.56 PM.png" src="https://lostechies.com/content/derickbailey/uploads/2012/04/Screen-Shot-2012-04-17-at-6.40.56-PM.png" alt="Screen Shot 2012 04 17 at 6 40 56 PM" width="448" height="60" border="0" />

But I can run &#8220;node start&#8221; and node will pick up the ./node_modules/.bin/ folder for me, allowing supervisor to be executed:

<img title="Screen Shot 2012-04-17 at 6.41.49 PM.png" src="https://lostechies.com/content/derickbailey/uploads/2012/04/Screen-Shot-2012-04-17-at-6.41.49-PM.png" alt="Screen Shot 2012 04 17 at 6 41 49 PM" width="542" height="495" border="0" />

This works well for recurring / repetitive tasks within a project. But if you want ad-hoc package commands, you&#8217;re going to be in for a little more work and will likely have to fall back to one of the other solutions I&#8217;ve mentioned.

## Other Options?

I really do miss the &#8220;bundle exec&#8221; feature of bundler. I honestly don&#8217;t know why npm doesn&#8217;t have an equivalent built in to it. Maybe it just needs someone to come along and contribute this feature. Maybe this feature was rejected. I don&#8217;t know. I haven&#8217;t looked in to it. But I wanted to get something in place now, so that I don&#8217;t have to install all of my project specific packages in the global package list.

There might be better option than the ones I&#8217;ve listed, as well. So, what am I missing? Is there something built in to npm to make this easier? Are there other ways that you&#8217;ve worked around this? Or am I going to stick with my &#8220;npm_exec&#8221; script and using npm &#8220;scripts&#8221; in my package.json fil?

 
