---
id: 132
title: 'A Good Night&#8217;s Rest'
date: 2012-11-27T07:26:46+00:00
author: Sharon Cichelli
layout: post
guid: http://lostechies.com/sharoncichelli/?p=132
dsq_thread_id:
  - "946371027"
categories:
  - Uncategorized
tags:
  - lifehack
  - PowerShell
---
I am not the only techie who struggles to get enough sleep. I&#8217;ve recently instituted a lifehack that is giving me some relief, and I want to share it. To my sleep-deprived sisters and brothers, this one&#8217;s for you.

Although I have no trouble falling asleep (quite the contrary), I am dogged by insomnia because I delay and delay going to bed. And&mdash;as you well know&mdash;that makes every other aspect of life more difficult.

So, c&#8217;mon, we owe this to ourselves. To fully be our true awesome selves, we need a full night of sleep.

## Sleep hygiene

The key to transforming sleep from a battle to a balm is regular routine. [Sleep hygiene](http://en.wikipedia.org/wiki/Sleep_hygiene), like dental hygiene, is a collection of healthy habits, a pattern that signals &#8220;sleepy time&#8221; to your brain. Same bed time, same nightly routine, a restful wind-down to the day.

&#8220;I stay up until I&#8217;m sleepy,&#8221; you protest. But here&#8217;s the thing: shining light into your eyes tells your [suprachiasmatic nucleus](http://en.wikipedia.org/wiki/Suprachiasmatic_nucleus), &#8220;It&#8217;s daytime! Stay awake. _Stay awaaaaaake!_&#8221; If you&#8217;re punting on the internet, you&#8217;re not going to _get_ sleepy. Not at the right time, anyway.

I&#8217;ve read up a lot on good sleep habits and, previously, practiced them rigorously, to get debilitating daytime sleepiness under control. In college I underwent an all-night-and-all-day sleep study (ugh, it was _awful_); results were inconclusive but various pharmacological solutions were bandied about. And I thought: I don&#8217;t need to be medicated; I can beat this. For more than a decade, I have, but habits have been sloppy lately, with bedtime slipping later and later. Time to change that.

As important as flossing and folic acid, make sleep hygiene a habit. Close the laptop, perform your nightly ablutions, and _get into bed_.

## Take willpower out of the equation

My sage friend [Aneel](http://loathe.org/aneel/) gave me the most useful advice on sleep hygiene. Willpower, he says, is a resource you deplete. At the end of the day, you&#8217;re tapped out. Therefore, any decision that relies on willpower&mdash;the decision to go to bed, for example&mdash;is likely to be made&#8230; poorly.

The solution is to take the decision out of your hands. To wit, automate it. Schedule the computer to shut down.

## Script those zees

(Outside the US, do people &#8220;catch some zeds&#8221;?) I need something taken care of without having to think about it? PowerShell!

I created a PowerShell script that warns me to wrap up my work, then sets the computer to sleep. I call that script from a Windows scheduled task.

[gist id=4151973]

Caveat emptor. To write this script, I picked up pieces of PowerShell and stuck them together with mud and spit. Please make a better version, put it in a [gist](https://gist.github.com/), and link to it in the comments. Sleepy nerds will thank you.

Start the Task Scheduler, select Create Task, create a daily trigger a little before bedtime, and set the action to run your PowerShell script.

[<img src="http://lostechies.com/sharoncichelli/files/2012/11/sleepScheduledTask1-300x223.png" alt="Create Task in Windows Task Scheduler" width="300" height="223" class="aligncenter size-medium wp-image-145" />](http://clayvessel.org/clayvessel/wp-content/uploads/2012/11/sleepScheduledTask1.png)

[<img src="http://lostechies.com/sharoncichelli/files/2012/11/sleepScheduledTaskAction-277x300.png" alt="Create new Action, set action type to Run a Program, enter PowerShell as the command" width="277" height="300" class="aligncenter size-medium wp-image-134" />](http://clayvessel.org/clayvessel/wp-content/uploads/2012/11/sleepScheduledTaskAction.png)

It&#8217;s currently set later than I&#8217;d ultimately like, but if I made too drastic a change all at once, I&#8217;d just flout myself and restart the computer. So this is a compromise, a deal I&#8217;m making with myself for now. Incremental improvements.

I won&#8217;t tell you what time it was when I wrote that script. Heh.