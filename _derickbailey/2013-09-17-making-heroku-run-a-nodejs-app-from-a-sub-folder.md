---
wordpress_id: 1150
title: Making Heroku Run A NodeJS App From A Sub-Folder
date: 2013-09-17T12:50:57+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1150
dsq_thread_id:
  - "1770978084"
categories:
  - Deployment
  - ExpressJS
  - Heroku
  - JavaScript
  - JSON
  - KendoUI
  - NodeJS
  - SignalLeaf
---
Both [SignalLeaf](http://signalleaf.com) and a project I&#8217;m building for [my day job at Kendo UI](http://kendoui.com) are running on NodeJS/ExpressJS servers, deployed to [Heroku](http://heroku.com). I love Heroku and have been using it for a good number of years now. It makes deploying website as easy as &#8220;git push&#8221;. 

But I found myself in an interesting situation with both of these project. They both have some information, some assets, some code&#8230; something that does not belong directly in the NodeJS/ExpressJS app folder. Whether its data migration code, product plans and pricing information, raw images and vector art, or whatever it is, there should be a clean separation between the web app and the other parts of your system. 

Fortunately, Heroku makes this dirt simple even if it&#8217;s not completely obvious.

## Setting Up NodeJS On Heroku

There are a few small steps you need to take, to get a NodeJS / ExpressJS app up and running on Heroku. First off, you need a &#8220;package.json&#8221; file in the root folder of your repository. This contains all the usual suspects &#8211; app name, version, development and production dependencies.

For SignalLeaf, my package.json file looks like this: 

{% gist 6598696 package.json %}

There are a couple of key things in here, most notably is the inclusion of an &#8220;engines&#8221; section that tells Heroku which version of NodeJS and NPM to run. There&#8217;s a couple of other points to make as well, but I&#8217;ll cover those in a bit.

The other thing that you need is a &#8220;Procfile&#8221; in the same root folder of your repository. For both SignalLeaf and my Kendo UI project, the Procfile looks like this:

{% gist 6598696 Procfile %}

Did you notice the &#8220;www/&#8221; In both of these files?

## Running The App From A Sub-Folder

In both apps, I created a &#8220;www&#8221; folder inside of the repository. This is the folder where the actual NodeJS / ExpressJS web app run. You&#8217;ll find the standard &#8220;app.js&#8221; file, &#8220;routes&#8221; folder, &#8220;views&#8221; folder and everything else that you expect to see in an ExpressJS app in this folder. To make Heroku recognize this as the folder from which to run the web apps, then, both the &#8220;package.json&#8221; and &#8220;Procfile&#8221; files directly reference this folder.

In the case of package.json, this is done in the &#8220;scripts&#8221; section of the file. The &#8220;start&#8221; script that every ExpressJS app generates has been modified to run the &#8220;www/app.js&#8221; file instead of just &#8220;app.js&#8221;. This isn&#8217;t strictly required, but it allows me to run &#8220;npm start&#8221; from the root folder of the repository and my web app will still spin up as expected. Without this, I could simply &#8220;cd www&#8221; and then &#8220;node app.js&#8221; &#8211; or just run &#8220;node www/app.js&#8221; &#8211; but having this one single command makes it a bit more convenient.

The Procfile also references the the &#8220;www/app.js&#8221; folder/file combination. This file and configuration setting are critical for Heroku. It uses the Procfile to determine how to run the application. 

## Flexibility, Organization

The end result is that I can push my repository up to Heroku and it will know that I&#8217;m using a NodeJS app that runs a web server from the &#8220;www&#8221; folder. I couldn&#8217;t ask for an easier deployment experience.

Now that I have this in place, my apps code and other assets can remain properly organized. I don&#8217;t have a bunch of cluttered folders sitting inside of my web app. I only have the web app files in the &#8220;www&#8221; folder, and everything else is organized in to top level folders in the repository. 
