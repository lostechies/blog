---
wordpress_id: 199
title: Replicating My OSX Terminal In Win7 with Git Bash (MinGW32) and Pik
date: 2010-11-25T17:14:16+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/11/25/replicating-my-osx-terminal-in-win7-with-git-bash-mingw32-and-pik.aspx
dsq_thread_id:
  - "262431042"
categories:
  - Command Line
  - git
  - Ruby
redirect_from: "/blogs/derickbailey/archive/2010/11/25/replicating-my-osx-terminal-in-win7-with-git-bash-mingw32-and-pik.aspx/"
---
After getting my [OSX Terminal prompt](http://www.lostechies.com/blogs/derickbailey/archive/2010/11/24/my-osx-terminal-prompt-reposted-from-tumblr.aspx) all set up and loving it, I decided I wanted to have the same basic prompt in my Win7 virtual machine when I use a [Git Bash (MinGW32) shell w/ MSysGit](http://code.google.com/p/msysgit/). Here&#8217;s what I came up with:

<img src="http://lostechies.com/content/derickbailey/uploads/2011/03/Screen-shot-2010-11-25-at-10.56.27-AM.png" border="0" alt="Screen shot 2010-11-25 at 10.56.27 AM.png" width="600" height="298" />

Note that all of the major components are available, with a few minor exceptions on the details.

 

## The Pieces Of The Prompt

The title of the window shows the user @ machine name (this is a virtual machine, so the name is irrelevant to me, which is why i didn&#8217;t rename the machine)

There is a blank line after the last command and before the current location / status indicators.

The first section of the prompt, in white, is the current folder. I added a trailing / to this. Makes it easier to understand when your at the root folder or at ~/

The second section, in green, shows the current branch and status of a git repository. This is built into git, which is cool. No more parsing out git status messages. You also don&#8217;t need to source a git completion bash script. Since this is a git bash shell, that&#8217;s already done. You can use the same exports as OSX to set up your info that is shown for the git repository you&#8217;re currently in. However, there is a bug in the remote status portion of the msysgit version. it throws an error every time it tries to get the info, even though it does retrieve it. I omitted this portion from my prompt because seeing the error is annoying. But I still get to see what branch I&#8217;m on.



The third section, in red, shows the [Pik](https://github.com/vertiginous/pik) ruby version that is currently being used. If you&#8217;re not using Pik on windows, and you&#8217;re using Ruby&#8230; shame on you. Pik let&#8217;s you set up and manage multiple versions of ruby on one machine, easily. It&#8217;s similar to RVM for OSX, but not as feature complete. For example, I don&#8217;t think pik has an equivalent of RVM&#8217;s &#8220;gem sets&#8221;, yet&#8230; there isn&#8217;t any built in prompt information for Pik either, so I had to create a custom function for this. A big thanks goes out to [@mendicant](http://twitter.com/#!/mendicant/statuses/7837485656702976) for helping me with this.

Finally, I drop to a new line before putting &#8220;$ &#8221; &#8211; yes, with a space &#8211; as my prompt. This keeps the prompt at the same place on the screen at all times.

 

## The .bashrc Code For This

To modify your prompt in a MinGW32 shell (Git Bash Shell), create a file called &#8220;.bashrc&#8221; in the &#8220;~/&#8221; folder&#8230; that&#8217;s the user&#8217;s home folder in bash terminology, or the C:Users(your username) folder in Windows terminology. The .bashrc file is used to load up all of your settings for the shell, and run any code or command that you want to always run when the bash shell is first opened.

Inside of the .bashrc file, put the following code:</p>