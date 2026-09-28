---
wordpress_id: 147
title: 'The *nix Rube Goldberg machine &#8211; functions!'
date: 2012-04-23T15:44:07+00:00
author: Ryan Rauh
layout: post
wordpress_guid: http://lostechies.com/ryanrauh/?p=147
dsq_thread_id:
  - "661018955"
categories:
  - Shell
tags:
  - bash
---
# Learn your shell! 

So a couple weeks ago I finally decided to learn how to use bash functions. I knew they existed but I decided to ignore them for the longest time. 

Often times you find yourself typing the same things over and over again into the shell. In our app we deploy 3 windows services and managing them can get really tedious. 

`~/lecode>sc query DovetailEmail-default`
  
`~/lecode>sc stop DovetailEmail-default`
  
`~/lecode>sc delete DovetailEmail-default`

`~/lecode>sc query DovetailRulesEngine-default`
  
`~/lecode>sc stop DovetailRulesEngine-default`
  
`~/lecode>sc delete DovetailRulesEngine-default`

`~/lecode>sc query DovetailMessaging-default`
  
`~/lecode>sc stop DovetailMessaging-default`
  
`~/lecode>sc delete DovetailMessaging-default`

That&#8217;s a lot of typing, granted its not that bad when you use your bash history. But you end up hitting the up arrow and changing one word a lot. 

### Functions! 

So when you keep repeating yourself over and over again you can quickly write a function that can save you precious keystrokes

`~/lecode>function fsc() {<br />
    for name in Email RulesEngine Messaging<br />
    do<br />
        sc $1 Dovetail$name-$2<br />
    done<br />
}<br />
` 

Now I can happily type
  
`~/lecode>fsc query default`
  
`~/lecode>fsc stop default`
  
`~/lecode>fsc start default`

It works for other repetitive tasks as well, ie the steps to deploy our app is as follows

`~/lecode>rm -rf mydefault`
  
`~/lecode>bottles create-all`
  
`~/lecode>bottles bundle mydefault -profile default`
  
`~/lecode>mydefault/BottleRunner.exe deploy -profile default`

Again&#8230; pretty easy to just use my bash history and hit the up arrow to run all the commands
  
but its really easy to make a function

`~/lecode>function fdeploy() {<br />
    rm -rf my$1<br />
    bottles create-all<br />
    bottles bundle my$1 -profile $1<br />
    my$1/BottleRunner.exe deploy -profile $1<br />
}<br />
` 

Then bam!

`~/lecode>fdeploy default`
  
`~/lecode>fdeploy storyteller`
  
`~/lecode>fdeploy hrdemo`

See thats way mo &#8216;betta than creating a .bat file cause then you have run in cmd.exe, you have to ignore it in git repository, clean up after yourself later&#8230;.

And I just don&#8217;t like that, not one bit.

-Ryan