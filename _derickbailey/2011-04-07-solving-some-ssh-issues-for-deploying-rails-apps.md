---
wordpress_id: 240
title: Solving Some SSH Issues For Deploying Rails Apps
date: 2011-04-07T14:39:19+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=240
dsq_thread_id:
  - "273890897"
categories:
  - Command Line
  - Deployment
  - git
  - Linux
  - OSX
  - Rails
  - Rake
  - Ruby
  - Vlad
---
So you think &#8220;The Rails Life&#8221; is all unicorns, rainbows and glitter? Yeah. Guess again. Right now it feels more like a glitter cannon shredding a unicorn into a rainbow colored bloody pulp&#8230;

[Joey](http://joeybeninghove.com/) and I are deploying our rails app with [Vlad The Deployer](http://www.rubyhitsquad.com/Vlad_the_Deployer.html). It&#8217;s a pretty sweet little deployment setup. He&#8217;s been doing the deployments, so far, but today I wanted to do a deploy. After adding my ssh key to my account on the server so that I could ssh into the server without requiring a username / password, we ran into some troubles. Note that these troubles were not related to Vlad itself but related to getting my SSH keys working with the server and with Github where our code is hosted.

 

### Username Is Different On Local Machine And Server

My local machine (OSX) runs me with a username of &#8220;derickbailey&#8221;. When I attempted to log into our server via ssh, I was prompted with a request to log in as derickbailey@my.server.com. However, on the server my username is &#8220;derick&#8221;. The easy answer here to to ssh with username@server, right?

Well, the only way to do that with vlad is to put the username into the ssh_flags option, in the deploy.rb file:

> <pre># {Rails.root}/config/deploy.rb</pre>
> 
> <pre>set :ssh_flags, "-l derick"</pre>

 

This isn&#8217;t a good solution because joey&#8217;s account name is not &#8220;derick&#8221;&#8230; obviously 🙂 &#8230; and we don&#8217;t want to hard code the user that we&#8217;re using to do the deploys. We want to have the logging and security and other neat things that come along with separate accounts.

After some searching, I found [this blog post that talks about SSH agent forwarding](http://jordanelver.co.uk/articles/2008/07/10/rails-deployment-with-git-vlad-and-ssh-agent-forwarding/). The majority of the article may not have been applicable to me, it talked about creating a config file for ssh.

On my local machine, I a file called ~/.ssh/config and put this into it:

> <pre># ~/.ssh/config</pre>
> 
> <pre>Host my.server.com</pre>
> 
> <pre>HostName my.server.com</pre>
> 
> <pre>User derick</pre>
> 
> <pre>IdentityFile ~/.ssh/id_rsa.pub</pre>
> 
> <pre>ForwardAgent yes</pre>

 

Now that I have this set up, I can do &#8220;ssh my.server.com&#8221; (without specifying a username@) and it will pull the correct username and rsa key for the server, logging me in automatically. This alows Vlad to do the same and we can leave the ssh_flags out of the deploy settings.

 

### Github&#8217;s And My SSH Key

We have to use the git@github.com ssh configuration for our remote because ours is a private repository. But I ran into another problem after getting my ssh config file setup:

> <pre>$ rake vlad:deploy</pre>
> 
> <pre>(in /Users/derickbailey/dev/vitalkey/vitalkey)</pre>
> 
> <pre>Host key verification failed.</pre>
> 
> <pre>fatal: The remote end hung up unexpectedly</pre>
> 
> <pre>rake aborted!</pre>
> 
> <pre>execution failed with status 128</pre>

 

At first I thought it was my ssh key failing against my server. Joey noted that it was likely an issue with connecting to github, though.

One thing that is very important here: the ssh key that I put on our server is the same ssh key that I use on github. This allows me to transparently log into the server via ssh and then perform git remote commands to our github repository. But it&#8217;s obviously not working at this point.

Another search brought me to t[his blog post](http://geekninja.blogspot.com/2008/09/capistrano-git-host-key-verification.html) where the author noted the same problem I was having (though he&#8217;s not using github). The solution to this is fairly simple:

  * ssh from my machine into my server
  * create a temp folder
  * clone our git repository from github to the temp folder
  * when git prompts me with an authenticity issue, accept the ssh key

Easy enough:

> <pre>$ ssh my.server.com</pre>
> 
> <pre>derick@my.server.com:~$ mkdir code</pre>
> 
> <pre>derick@my.server.com:~$ cd code</pre>
> 
> <pre>derick@my.server.com:~/code$ git clone git@github.com:some_user/some_repo.git .</pre>
> 
> <pre>Initialized empty Git repository in /home/derick/code/.git/</pre>
> 
> <pre>The authenticity of host 'github.com (207.97.227.239)' can't be established.</pre>
> 
> <pre>RSA key fingerprint is 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48.</pre>
> 
> <pre>Are you sure you want to continue connecting (yes/no)? yes</pre>
> 
> <pre>Warning: Permanently added 'github.com,207.97.227.239' (RSA) to the list of known hosts.</pre>

 

### Vlad Deploys &#8230; Are Still Awesome

Start with the standard SSH setup on our server, creating a user account for me, as assigning permissions to everything I need. Then add my ssh key to the server, setup my local ssh config file and accept the ssh key from github while logged into the server as me, and I can now run

> <pre>rake vlad:deploy</pre>

 

from my local machine, and deploy our site to our server.

Simple, right? &#8230; right? &#8230; \*sigh\*&#8230; but now that it works, it is pretty darn awesome. Automation is an absolute must, even if you have a napalm your way through a forest full of SSH issues to get there.