---
wordpress_id: 77
title: 'Vlad, RVM and Bundler sittin&#8217; in a tree'
date: 2010-09-17T05:21:00+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2010/09/17/vlad-rvm-and-bundler-sittin-in-a-tree.aspx
categories:
  - Bundler
  - Deployment
  - Ruby
  - rvm
  - vlad the deployer
redirect_from: "/blogs/joeydotnet/archive/2010/09/17/vlad-rvm-and-bundler-sittin-in-a-tree.aspx/"
---
<img alt="Vlad the Deployer" style="float: right;margin: 20px" src="//lostechies.com/joeybeninghove/files/2011/03/deployed.png" />(Thanks to Chad for nudging me to write this post 🙂

Up until now, my only experience with deploying Rails or any other Ruby-based web application
  
has been to use the &#8220;standard&#8221; [Capistrano](http://www.capify.org/index.php/Capistrano). &nbsp;For the main Rails 3 application I&#8217;ve been building
  
the past few months, Capistrano has been fine and was mostly a set it and forget it kinda thing.

One of my clients asked me to do a small side project to perform a simple task and naturally I chose
  
the most excellent [Sinatra](http://www.sinatrarb.com/) framework. I could go on and on about the awesomeness of Sinatra, but that&#8217;s
  
not the point of this post. Suffice it to say when I finished this small Sinatra application, I needed to
  
deploy it somehow. Manual deployments are for the birds, so my first knee-jerk reaction was to get
  
Capistrano wired up to do the automated deployment. But after taking a glance at my existing Capistrano
  
deployment script for my Rails 3 application, it seemed like overkill for this tiny Sinatra ditty.

The first alternative I ran across was a deployment tool named [Vlad the Deployer](http://rubyhitsquad.com/Vlad_the_Deployer.html)
  
(which clearly gets an award for the best name ever). What attracted me right off the bat was the simplicity of its usage
  
and configuration. I also liked the fact that it uses pure Rake for everything, instead of some of the
  
&#8220;magic&#8221; that Capristrano does under the hood. 

Getting Vlad up and running is pretty straightforward, but I did have a couple issues getting it integrated
  
into my particular deployment process. Like all good Ruby developers 2 of my must use tools are [RVM](http://rvm.beginrescueend.com)
  
& [Bundler](http://gembundler.com). &nbsp;Bundler is great for managing gem dependencies and RVM keeps you sane when working with many different versions
  
of Ruby and gems at the same time. 

One thing I like to do during deployments is make sure &#8220;bundle install&#8221; gets run on the server. &nbsp;This ensures that any new gems I&#8217;ve introduced in my Gemfile get automatically installed on the server
  
during deployment. Usually this wouldn&#8217;t be much of an issue, but I&#8217;m a pretty big fan of RVM, so much
  
so that I actually run it on my staging/production servers as well. RVM does some _serious_ magic under
  
the hood, including altering various environment variables affecting the path. Here is the series of
  
steps I had to take to get Vlad to properly run &#8220;bundle install&#8221; during deployment. (NOTE: I&#8217;m mainly
  
posting this to hopefully get feedback on a better way. I really don&#8217;t like my solution too much.)

## Minor server preparation

Before I show the deploy script itself, you do need to make sure your server is set up properly with
  
RVM and Bundler installed in the global gemset. Here are 2 great articles that describe this process:

  * [Thoughts in Computation &#8211; Using Phusion Passenger and Apache2 on Ubuntu with RVM and Gemsets](http://www.thoughtsincomputation.com/posts/using-phusion-passenger-and-apache2-on-ubuntu-with-rvm-and-gemsets)
  * [RVM and project-specific gemsets in Rails](http://everydayrails.com/2010/09/13/rvm-project-gemsets.html)

&nbsp;

[](http://www.thoughtsincomputation.com/posts/using-phusion-passenger-and-apache2-on-ubuntu-with-rvm-and-gemsets)

## Extend Vlad&#8217;s update Rake task

Since Vlad uses simple Rake tasks for everything, it&#8217;s easy to &#8220;tack on&#8221; steps before or after the
  
built in Vlad tasks. In this case I wanted to run my Bundler command right after the built in update
  
process was complete. Here&#8217;s one easy way to do that:</p> 

FYI, if you want to run something _before_ the update process starts, you can simply add a dependency
  
to the built in update task like so:</p> 

## Create a Bundler task

Next I created a separate task (see next section about remote_task) to perform the Bundler command I
  
needed to run on the server and invoked it inside of Vlad&#8217;s built in update task:</p> 

## Remotely running commands via SSH

Before I show the commands necessary, it&#8217;s important to understand that all of this will be run in
  
the context of an SSH session. Thankfully, there was a nice feature of Vlad that was extracted out
  
into its own gem known as [remote_task](https://github.com/seattlerb/rake-remote_task). &nbsp;This is a handy way to run Rake tasks in the context of remote
  
servers and is used heavily under the hood with Vlad. We&#8217;re also using it here for our custom Bundler
  
task and a &#8220;run&#8221; method can be called with whatever commands you want to be run on the remote server in
  
an SSH session.

## Step by step

For clarity I put each command into its own local variable, each of which I&#8217;ll describe below.

### Initialize RVM

When you login to a server via SSH, you have set of environment variables which include how paths
  
are resolved when running commands. Luckily, RVM takes care of all of that for us. Usually when using
  
RVM you simply [load it via your .bashrc](http://rvm.beginrescueend.com/rvm/install), but for some reason I couldn&#8217;t get this working in the
  
context of the SSH session used as part of the remote_task. I&#8217;m sure this is due to my lack of bash and
  
*nix skills which I&#8217;m actively trying to beef up. But to work around it for now, I just manually source
  
the RVM bootstrap script myself:</p> 

### Trust your RVM gemset

I&#8217;m not going to dive into [RVM gemsets](http://rvm.beginrescueend.com/gemsets/basics) as part of this post, but just think of it as a way to manage gems
  
in isolation from other applications and environments. I like to use project-specific gemsets for everything
  
I do to keep things nice and clean. A nice companion to gemsets is the use of an [.rvmrc file](http://rvm.beginrescueend.com/workflow/rvmrc) to
  
automatically switch to the correct gemset when navigating to your application&#8217;s directory. Creating a
  
.rvmrc is stupidly simple:</p> 

Starting in [version 1.0 of RVM](http://wayneeseguin.beginrescueend.com/2010/08/22/ruby-environment-version-manager-rvm-1-0-0),
  
there was a security measure put in place to force you to &#8220;trust&#8221; .rvmrc
  
files when changing into a directory with a .rvmrc for the first time. Normally this is fine, but it
  
presented an issue in the context of an automated script. This security measure can be disabled by this
  
next command:</p> 

This tells RVM that I explicity trust the .rvmrc located in my release_path which is the root of my
  
application on the server.

### Run bundle install &#8211; take 1

With RVM all loaded up, we can now issue our bundle command to install any new dependencies if necessary.
  
So naturally I tried the command below:</p> 

But this blew up in my face with a nasty exception:</p> 

### Run bundle install &#8211; take 2

I had read somewhere previously (sorry, can&#8217;t remember exactly where) about sometimes needing to
  
explicitly specify the target path for the &#8220;bundle install&#8221; command. In this case I can just use
  
the $BUNDLE_PATH environment variable that RVM manages for me:</p> 

This seems to fix the exception above, but I&#8217;ll be honest, I&#8217;m not exactly sure why yet. (And yes,
  
that does bug the heck out of me)

## Putting it all together

Now that we have all of our commands ready to go, we can simply call the built in &#8220;run&#8221; method
  
and pass in each command concatenated one after another:</p> 

If all is well, you should see a nice green message from Bundler saying your bundle is complete.

## </post>

As I mentioned before I&#8217;m not all that happy with this solution, as it seems like there is probably
  
a better way to get Vlad, RVM and Bundler all working nicely together. I&#8217;d be really interested
  
to know of a better way.

Anyways, I hope this post benefits somebody in the future. Even if it&#8217;s myself a year from now. 🙂