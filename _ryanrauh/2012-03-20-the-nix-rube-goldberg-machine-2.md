---
id: 106
title: 'The *nix Rube Goldberg Machine'
date: 2012-03-20T15:54:55+00:00
author: Ryan Rauh
layout: post
guid: http://lostechies.com/ryanrauh/?p=106
dsq_thread_id:
  - "618053661"
categories:
  - Uncategorized
tags:
  - bash
---
# Learn your shell! 

Last time I posted a quick intro into basic shell programming. 

<blockquote style="overflow:hidden;">
  <p>
    <img src="http://cl.ly/3b1n2i321K1H0h3p2N3G/trollface.jpg" width="64px" style="float:left;padding:0;margin:5px;" /> &#8220;Bash isn&#8217;t programming, its scripting&#8230;&#8221;
  </p>
</blockquote>

<blockquote style="overflow:hidden;">
  <p>
    <img src="http://www.gravatar.com/avatar/29283ede6c447fdc62f0ceac42df33ea?s=64" width="64px" style="float:right;padding:0;margin:5px;" /> &#8220;Shut up troll, its programming&#8221;
  </p>
</blockquote>

This time I&#8217;d like to quickly explain loops.

I&#8217;ll give you a quick example of how you can use a loop to do some simple things. 

Lately I&#8217;ve been working on [FubuMVC](http://fubu-project.org/) and the project has a \*few\* [repositories](https://github.com/DarthFubuMVC) and it can be a pain in the ass to update all of the git repositories. Luckily bash is here to help. 

I happened to have all Fubu related project in one directory so bash makes this pretty simple.

 `~> cd ~/lecode/fubuproj`

 `~/lecode/fubuproj> ls` 
  
`<br />
.<br />
fubumvc<br />
FubuFastPack<br />
ripple<br />
bottles<br />
fubucore<br />
` 

Ok now lets test out a simple for loop.

 ``~/lecode/fubuproj> for d in `ls`; do echo $d; done`` 
  
`<br />
.<br />
fubumvc<br />
FubuFastPack<br />
ripple<br />
bottles<br />
fubucore<br />
` 

Ok awesome, now we are getting some where. 

<blockquote style="overflow:hidden;">
  <p>
    <img src="http://cl.ly/3b1n2i321K1H0h3p2N3G/trollface.jpg" width="64px" style="float:left;padding:0;margin:5px;" /> &#8220;But what if I have files as well as directories&#8230;&#8221;
  </p>
</blockquote>

 ``~/lecode/fubuproj> for d in `ls -d */`; do echo $d; done`` 

When you are working in bash, there are a lot of gotchas that can catch you off guard. One of those gotchas is aliases&#8230; I have ls aliased to \`ls &#8211;color -xXw80\` to make it look the way I want it to by default. The gotcha is &#8211;color that will bit you when you try and pipe color into other things. So to avoid aliases you can point to ls directly from /bin/ls

 ``~/lecode/fubuproj> for d in `/bin/ls -d */`; do echo $d; done`` 

Now you can cd into the directory and run \`git status\` to make sure you don&#8217;t have any outstanding changes.

 ``~/lecode/fubuproj> for d in `/bin/ls -d */`; do cd $d; git status; cd ..; done`` 

If everything is checked, I&#8217;ll make sure they are all on the master branch

 ``~/lecode/fubuproj> for d in `/bin/ls -d */`; do cd $d; git checkout master; cd ..; done`` 

Fetch the latest changes&#8230;

 ``~/lecode/fubuproj> for d in `/bin/ls -d */`; do cd $d; git fetch; cd ..; done`` 

And catch up my master branch

 ``~/lecode/fubuproj> for d in `/bin/ls -d */`; do cd $d; git rebase origin/master; cd ..; done`` 

Nice&#8230; Now all my projects are up to date.

HerpDerp

-Ryan