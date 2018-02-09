---
wordpress_id: 282
title: Deploying A Thor Application With Vlad, From Github, Run As A Cron Job
date: 2011-05-03T06:21:35+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=282
dsq_thread_id:
  - "294135520"
categories:
  - Bundler
  - Command Line
  - Deployment
  - Linux
  - Rake
  - Ruby
  - Thor
  - Vlad
---
The previous 4 blog posts, in combination with a few others, have basically been a series of posts all leading up to this one. If you read them all in the right order (and possibly a few of the links in each), you should be able to step away from your browser / rss reader and build a complete command line ruby application that is executed through a cron job, and deployed to your various servers and environments.

This final post in the somewhat-series of posts will cover the deployment topic and what I had to do to get the whenever gem to play nice with my thor script, configure each environment&#8217;s settings for the app, and push it all to the server with vlad.

But first, the index of posts in the order I think you should read them:

  1. [Getting Started With Thor](http://lostechies.com/derickbailey/2011/04/15/getting-started-with-thor/)
  2. [Writing A Thor Application](http://lostechies.com/derickbailey/2011/04/29/writing-a-thor-application/)
  3. [The Whenever Gem: Making Cron Easy](http://lostechies.com/derickbailey/2011/04/27/the-whenever-gem-making-cron-easy/)
  4. [Cleaning Up Log Files On Linux, With Logrotate](http://lostechies.com/derickbailey/2011/04/28/cleaning-up-log-files-on-linux-with-logrotate/)
  5. [Using Mongo And Mongoid Without Rails](http://lostechies.com/derickbailey/2011/05/02/using-mongo-and-mongoid-without-rails/)
  6. [Solving Some SSH Issues For Deploying Rails Apps](http://lostechies.com/derickbailey/2011/04/07/solving-some-ssh-issues-for-deploying-rails-apps/)
  7. Joey Beninghove&#8217;s [Vlad, RVM and Bundler sittin&#8217; in a tree](http://joeybeninghove.com/2010/09/17/vlad-rvm-and-bundler-sitting-in-a-tree/)
  8. &#8230; this one

 



### How To Use RVM And Bundler With Vlad The Deployer

I had written half of this information as another blog post at the start of this series. In the middle of that effort, though, I did a google search to find a blog post describing how to trust an rvmrc file with no user interaction. Well, googling &#8220;rvm trust rvmc&#8221; happened to turn up Joey Beninghove&#8217;s blog post on [using Vlad, Bundler and RVM to deploy sinatra applications](http://joeybeninghove.com/2010/09/17/vlad-rvm-and-bundler-sitting-in-a-tree/) &#8211; nearly exactly what I was writing, minus the sinatra portion. Rather than duplicate what he&#8217;s already said so well, I would recommend that you start there. It&#8217;s a great post.

I&#8217;ll try not to repeat too much of what Joey has said already. I&#8217;m deploying a thor application that needs to be run from a cron job, instead of a web app, as well. There are some specific things I needed to do to get this work correctly, regarding thor and cron. I also want to talk about some of the general vlad and deployment related topics.

 

### Release Folders And Symlinks For Fast App Version Switching

There are several deployment systems out there that make use of release folders and symlinks to provide fast app version switching, including roll back to previous versions. Both Vlad and Capistrano come to mind, initially, but I&#8217;ve also worked with .NET teams that did this, including my previous job at TrackAbout.

The idea is simple. Every time you do a release of your web app, you create a new folder for that release, on the server. You can spend all day uploading files and setting permissions and getting everything ready to go without affecting the production code. Once the new folder structure is ready to go, you set a symlink (a Symbolic Link) that points the web server to the correct version of the application. (Yes, this is even supported on Windows &#8211; just google &#8220;windows symlinks&#8221;).

To keep everything organized, you typically need a project home on the server &#8211; a folder that will contain all releases, the symlink to the current release, and any support files that the application needs. Vlad will handle the release folders and symlink for you, but you still need to create the home folder, first. You&#8217;ll want to configure vlad to point to your app&#8217;s home folder, as well. This way vlad does it&#8217;s ssh into the server, it will know where to go and do the deploy, etc.

Even though my app is not actually a web app, I still want to take advantage of this setup. If I happen to deploy any changes while the app is running &#8211; and that&#8217;s very likely, since I will be running the app on a very frequent schedule &#8211; then I won&#8217;t interrupt it with file changes that could possibly break the current execution. The already in-memory app will continue to run to completion and the next time it&#8217;s queued up, the symlink will have changed to point to the new version and the new version will be run.

 

<span style="font-size: 14px;font-weight: bold">Vlad-Git And Vlad Configuration For A Specific Environment</span>

We&#8217;re using a privte Github repository to host the application, which makes it easy for us. We provided an ssh key to our github repository as a &#8220;deploy key&#8221;, which let&#8217;s that ssh key read the private repository but not update it.

We also need to use vlad-git to support this setup. This little extension to Vlad tells it to use Git as the source control system instead of the default (which I think is Subversion, but am not 100% certain of that). It&#8217;s easy to use, too. You only need to call the &#8220;vlad:update&#8221; rake task after setting the repository location.

Here&#8217;s an example of our vlad configuration, housed in our &#8216;deploy.rb&#8217; files for each environment folder that we have (you can see the folder structure in the [Writing A Thor Application](http://lostechies.com/derickbailey/2011/04/29/writing-a-thor-application/) blog post).

<pre>set :application, "app_name"<br />set :repository, "git@github.com:username/repositoryname.git"<br />set :domain, "dev.example.com"<br />set :deploy_to, "/home/app_staging_account/app_name"</pre>

 

Vlad and Vlad-Git know how to read these configuration settings and use them to do the deploy. We have multiple copies of this settings file, too &#8211; one for each environment that we are deploying to. This lets us change the configuration to point to the correct server and folder locations, as well as any other changes we might want to make for vlad&#8217;s configuration. Each of the configuration files for the environments is housed in a ./config/environmentname folder and the proper configuration is included via the rake task that we call to do the deploy.

 

### Organizing Vlad Tasks And Rake Tasks

In addition to the environment specific configuration, we have a generic deploy.rb file in our app that sits in the ./config/ folder, directly. This file contains all of the actual vlad task definitions. We include this file in our rakefile with a &#8216;require config/deploy&#8217; line. We don&#8217;t provide a desc (description) for any of the vlad tasks directly, so they are not advertised when you call rake -T from the command line. Instead, we provide a &#8220;vlad:deploy&#8221; task in the rakefile, which knows how to handle the environment targeting.

Here&#8217;s the rake task that I created to do kick off the deploy:

<pre>require 'vlad/core'
require 'vlad/git'
require "./config/deploy"

namespace :vlad do
  desc "Deploy and start the import job"
  task :deploy, [:environment] do |t, args|
    args.with_defaults :environment =&gt; :staging
    require "./config/#{args.environment}/deploy"
    Rake::Task["bioref:deploy"].invoke(args.environment)
  end
end</pre>

 

Note the use of the :environment task argument and the args variable in the code block definition. This let&#8217;s us call the deploy task with an environment specified. I&#8217;ve also defaulted the argument to &#8220;staging&#8221; so that we can run the task without an environment specified and it will deploy to staging.

This task is also responsible for requiring the appropriate environment configuration. The require statement in the task uses the environment argument to include the correct deploy configuration. It them calls the &#8220;bioref:deploy&#8221; task, which we have defined in our ./config/deploy.rb file. This task makes use of the configuration values that were set in the environment specific configuration.

Our deploy.rb file is set up with a namespace and various tasks, to organize it better. It also calls the vlad:update task that vlad includes, to update our source code on the server.

<pre>namespace :bioref do
  remote_task :bundle do
    # run bundle install with explicit path and without test dependencies
    run "#{goto_app_root} && bundle install $BUNDLE_PATH --without development test"
  end

  remote_task :clear_cron do
    run "#{goto_app_root} && whenever -c"
  end

  remote_task :set_cron do
    run "#{goto_app_root} && whenever -w"
  end

  remote_task :copy_cron, [:env] do |t, args|
    run "#{goto_app_root} && cp config/#{args.env}/schedule.rb config/"
  end

  task :deploy, [:env] do |t, args|
    Rake::Task['vlad:update'].invoke
    Rake::Task['bioref:bundle'].invoke
    Rake::Task['bioref:copy_cron'].invoke(args.env)
    Rake::Task['bioref:clear_cron'].invoke
    Rake::Task['bioref:set_cron'].invoke
  end
end

def goto_app_root
    # loads RVM, which initializes environment and paths
    init_rvm_cmd = "source /usr/local/rvm/scripts/rvm"

    # automatically trust the gemset in the .rvmrc file
    trust_rvm = "rvm rvmrc trust #{release_path}"

    # ya know, get to where we need to go
    # ex. /var/www/my_app/releases/12345
    "#{init_rvm_cmd} && #{trust_rvm} && cd #{release_path}"
end</pre>

 

Most of this is just re-posting what Joey already showed and explained in his post. At a high level, though, the :deploy task will ssh into the server, update the source code from github, run bundler against the code that was pulled down, copy the environment specific schedule.rb (which I&#8217;ll explain next), clear any old cron jobs using the whenever gem, and then create the cron jobs specified in the schedule.rb file using the whenever gem again.

(I&#8217;m sure there are ways that we can improve this file, too. If you have any suggestions, let me know. 🙂

 

### Handling Whenever / Cron On The Remote Machine

This part of the process was a little tricky to get right. I went through several iterations of my whenever script before it worked. I need to have the whenever script called through ssh, on the remote machine. I also need it to set up a cron job that will call the correct version of the script &#8211; the one in the release folder that represents the current release.

From my previous post on [writing a thor application](http://lostechies.com/derickbailey/2011/04/29/writing-a-thor-application/), I have a ./bioref executable script set up and I decided it would be easier for me to call this than to call the thor tool directly. I don&#8217;t really have any reasoning for saying that, but it&#8217;s what I decided and I stuck with it. To make sure that I am calling the correct ./bioref script, I needed to get the full path of the executable when the whenever script was called. This turned out to be easy with the \_\_FILE\_\_ macro and File.expand_path. Here&#8217;s what my final schedule.rb, from the ./config/staging/ folder looks like:

<pre><span style="line-height: 0px">dir = File.expand_path(File.dirname(__FILE__))

set :output, {:standard =&gt; '/var/log/bioref.import.log', :error =&gt; '/var/log/bioref.import.errors.log'}

every 1.minutes do
  command "cd #{dir} && ./bioref import /home/bioref/labs/ -d app_staging -k"
end</span><span style="line-height: 0px">﻿</span></pre>

<div>
  <p>
     
  </p>
  
  <p>
    (Notice that I&#8217;m also setting the output for the log files as discussed in my post on <a href="http://lostechies.com/derickbailey/2011/04/27/the-whenever-gem-making-cron-easy/">using the whenever gem</a>.  And yes, I am running this app every minute in my staging environment. We are doing a lot of testing right now, and I want to have this process kick off on a very regular basis so that I don&#8217;t have to sit around for too long and wait for it. In the future, I&#8217;m likely going to reduce this to once every 30 minutes to an hour. )
  </p>
  
  <p>
    The first part of the file uses File.expand_path to get the current folder. Then in the scheduled command, I use that to change to the correct directory and then run the ./bioref app that I built, with all of the correct parameters (never mind what they do &#8211; that isn&#8217;t important to this discussion). Remember that this whenever file is executed on the server, through an ssh tunnel, by my vlad task. Therefore, the File.expand_path will give me the new release folder and ensure that the new cron job is set up correctly, running the app from the correct folder.
  </p>
  
  <p>
     
  </p>
  
  <h3>
    The Whole And The Sum Of The Parts&#8230;
  </h3>
  
  <p>
    I realize that there are a lot of moving parts in this series of blog posts. This is a part of the *nix culture and philosophy, though; to use many small tools that each accomplish one thing very well, and to orchestrate them into something much more than the individual pieces. Thor is a great command line processing tool and is likely one of the most under-rated additions to the rails community. Mongoid is a tremendous document mapper that proved to be simple to setup and use outside of rails. Whenever make it easy to work with cron jobs &#8211; even on a remote server through ssh. And Vlad makes the deployment process for nearly any server-based application simple to automate.
  </p>
  
  <p>
     
  </p>
  
  <h3>
    Ruby: It&#8217;s Not Just A Web Developer&#8217;s Toy
  </h3>
  
  <p>
    I do believe it was worth the time and effort to build the app the way I did. I am not building just another script to automate some redundant task. Rather, I am building a full-fledged ruby application; one that has models and business logic, configuration and deployment environments, and happens to not be a web application running rails or sinatra. I hope that by the time you have read through this entire series of posts, that you will have the confidence and knowledge that you need to try your hand at writing a ruby app other than rails or sinatra, too.
  </p>
</div>