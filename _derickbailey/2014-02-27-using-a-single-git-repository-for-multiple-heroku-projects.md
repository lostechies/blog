---
wordpress_id: 1293
title: Using A Single Git Repository For Multiple Heroku Projects
date: 2014-02-27T07:00:03+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1293
dsq_thread_id:
  - "2314195340"
categories:
  - Deployment
  - git
  - Heroku
---
[SignalLeaf](http://signalleaf.com) has 2 separate services, at this point: the web app and the media server. Both of these services are deployed to Heroku, each on their own Heroku app instance. This allows me to scale them as needed. I give more Heroku Dynos to the media service, for example, to ensure it can handle the traffic and serve the episodes. The web site doesn&#8217;t get used as often, so I keep those Dynos scaled back, in comparison. The trick to this setup and deployment, though, is that I&#8217;m using a single Git repository for both services and deploying them to separate app instances on Heroku. 

## One Repository To Rule Them All

SignalLeaf isn&#8217;t a huge system. Sure, I have a lot of modules and code files that are broken out in to many concerns. But it&#8217;s not huge. Many of my modules are only 1 file, for example. It doesn&#8217;t make sense for me to invest in a git repository for each 1-file module. I would end up with 30 git repositories to manage that. It&#8217;s not worth it. But I have multiple apps in this one repository, which makes things easy for me to manage from a code perspective. I have a lot of shared code between multiple apps but it&#8217;s not worth setting up individual git repositories or npm modules for them. It&#8217;s easier for me to manage code in one repository.

But this does make for a difficult time in deploying to Heroku, because Heroku is one app per git repository. I can&#8217;t deploy a single repository to multiple Heroku apps, expecting it to run anything different in the two separate apps. Heroku sees the one repository and the one Procfile in that repository and runs what that Procfile says to run. This creates some challenges.

## One Procfile Per Heroku App

To make my deployment work from a single repository, I need multiple Procfiles. Procfiles are the files that tell Heroku what services to launch within an app instance. Each Heroku app can use a single Procfile, but you can run as many services as you need in any given Heroku app instance.

The exception to the one Procfile, many services setup, is that only one of the services can be a web app that responds to HTTP requests. If you try to deploy multiple web apps within a single Heroku app, only one of them will run. 

To get around the one web app per Heroku app instance, you&#8217;ll need multiple Heroku apps. In my case, SignalLeaf has two web apps &#8230; and yes, you guessed it, the web site and the media server are both web apps that need to respond to HTTP requests. Since I have two apps that need to be web sites responding to HTTP requests, I have two Heroku app instances &#8211; one for each. This also means I have two Procfiles in my source code &#8211; one for each web site. But like I said before, I&#8217;m running both web sites from a single Git repository.

## One Master Repository, Multiple App Repositories

Deploying an app to Heroku is done through a git push. You commit your code, push the repository to Heroku and it spins up your app for you. Heroku looks at the one and only one Procfile at the root of the repository and uses that to launch services within the Heroku app instance. This means I need multiple git repositories in order to have multiple Heroku apps. I can&#8217;t push the same repository to multiple Heroku apps, expecting it to pick up different Procfiles.

The solution, then, is to have a single git repository as the master code base from which I work, but then have multiple git repositories for deployment of the various apps to the various Heroku services.

## Nested Repositories

The process I came up with to solve my deployment problem, is to have multiple git repositories inside of my master git repository. I&#8217;m not talking about git sub-modules. I&#8217;m just putting a few git repositories into a &#8220;deploy&#8221; folder of my master repository &#8211; but then I&#8217;m having the master repository .gitignore the &#8220;deploy&#8221; folder, so I never commit them to the master. 

Here&#8217;s what the folder structure looks like:

<img src="http://lostechies.com/derickbailey/files/2014/02/NewImage5.png" alt="NewImage" width="300" height="230" border="0" />

There are 4 folders in my &#8220;deploy&#8221; &#8211; 2 for production and 2 for staging. Each of these environments has 2 folders for deployment of the web site and media server. Each of these folders is a git repository. 

## Multiple Procfiles

In my environment configuration I have a folder that contains procfiles for each of the Heroku apps. The procfile for staging vs production is the same, so these procfile copies are stored in the &#8220;shared&#8221; configuration folder:

<img src="http://lostechies.com/derickbailey/files/2014/02/NewImage6.png" alt="NewImage" width="300" border="0" />

The media.procfile looks like this:

[gist id=9195285 file=media.procfile]

and the web.procfile looks like this:

[gist id=9195285 file=web.procfile]

(Yes, I have multiple services running in the web app)

Where this gets interesting is the deploy process, dealing with multiple nested repositories and multiple procfiles.

## Complex Deployment Scripts

To deploy multiple projects through multiple git repositories, using multiple procfiles, I need something more than just a git push. I need a deploy script that coordinates all the moving parts and ensures everything is in the right place at the right time. Thankfully, a nice shell script is easy enough to automate this for me.

My deployment process, from a high level, looks like this:

  1. Copy the needed code to the media deploy folder
  2. Copy the correct Procfile to the media deploy folder
  3. Commit all the code / files / assets to the media deploy folder&#8217;s git repository
  4. Push the git repository to the correct heroku app
  5. Repeat #1 &#8211; #4 for the web site

The shell script to automate it currently looks like this:

[gist id=9195285 file=deploy.sh]

This is 1 of 2 copies of the deploy script&#8230; I have one for the production environment and one for the staging environment. And yes, I know I need to refactor this shell script so that I don&#8217;t have so much duplication between the two environments and two apps in each environment. That&#8217;ll come eventually. This works for now.

## The Downside

The downside to this complex set up is &#8230; well&#8230; complexity. It does add complexity in the deploy process and configuration of the system in my development environment. But as you can see, that complexity is mostly managed through a simple shell script for the deploy process. Since I&#8217;m the only one coding on SignalLeaf, I don&#8217;t have to worry about anyone else needing to replicate this setup in their development environment. If it ever comes to that, I&#8217;m sure I will run in to some limitations and problems that I will then automate or simplify in some way. 

## The Upside

The upside to this complexity and setup, is that I can deploy just the files that I need for any given Heroku app, and I can deploy any number of Heroku apps from a single git repository! Those are both huge wins, right there.

## Another Solution: Procfile A Shell Script

I&#8217;ve seen other solutions, like using a shell script as your service in the Procfile. This would let you make a decision in the shell script based on an environment variable. The shell script can run a different server / service based on the configuration in the env var. 

The downside to this approach is that you have to deploy _everything_ to all of the heroku apps &#8211; all your files and assets. If you look at the folder structure in the above screenshots, you&#8217;ll see a lot of folders that are not related to the code for any given app that Heroku runs. For example, the database folder&#8230; I keep database scripts, seed data and database backups in this folder. I don&#8217;t want those deployed to Heroku, but I do want them in git. Having my deployment setup in place allows me to copy only the files and folders that I need, to the individual deploy repositories. I can ignore the database folder and other folders, and never worry about them taking up space for no reason, in Heroku&#8217;s limited slug size.

## Multiple Heroku Apps, Multiple Git Repositories For Deploy, Single Git Repository For Code

The end result of this setup allows me to have a single repository from which I build all of my services. I can share code between multiple Heroku apps without having to create a git repository or npm repository for the shared code. I just copy the shared code to the deploy repository, and it deploys with the rest of the code for that service. This cuts down on the number of git repositories that I need for managing my code. 

There may be other ways to do this. You might want to invest in multiple git repositories for your code. It doesn&#8217;t always make sense to configure things the way I have. Frankly, I wish Heroku would support multiple web apps from a single Procfile / Heroku app. That would make life easier for my deployments. But if you find yourself in a situation where you want to deploy multiple Heroku apps from a single git repository, this setup should work. It works for me, with [SignalLeaf](http://signalleaf.com) at least.