---
wordpress_id: 91
title: 'Huboard &#8211; Github issues made awesome'
date: 2012-01-13T22:47:59+00:00
author: Ryan Rauh
layout: post
wordpress_guid: http://lostechies.com/ryanrauh/?p=91
dsq_thread_id:
  - "538057299"
categories:
  - Uncategorized
tags:
  - huboard
---
# Meet <a title="Go to huboard its awesome!" href="http://huboard.com" target="_blank">Huboard</a> !

<img style="max-width: 100%;" src="http://f.cl.ly/items/2V300F3W1W20121x1q00/Image%202012-01-13%20at%203.48.44%20PM.png" alt="Issues" />

<img style="max-width: 100%;" src="http://f.cl.ly/items/1z42372T3R2H001k3D0T/Image%202012-01-13%20at%203.49.07%20PM.png" alt="Milestones" />

Huboard is a kanban style drag and drop task board built entirely _on top of_ the [github api](http://developer.github.com/v3/).

### How to get started

Its easy. Go to any of your github repositories and add issues as you normally would. Next create some labels that represent your business process. For example, at Dovetail we use a simple workflow.

  * 0 &#8211; Backlog
  * 1 &#8211; Development
  * 2 &#8211; Test
  * 3 &#8211; Done

Notice the labels follow a pattern of &#8216;{number} &#8211; {title}&#8217;? The number represents the order you want your column to appear in your process and the title represents the header of the column. Huboard will automatically use the lowest number column as the hidden drawer column on the task board.

<img style="max-width: 100%;" src="http://f.cl.ly/items/1f2k3E443j111z0b2V1J/Image%202012-01-13%20at%204.06.29%20PM.png" alt="Drawer" />

### <del>Move cards with git commits! weeeeeee</del>

<del><br /> One of the coolest features of huboard is the ability to move cards through your process with git commit messages. You can create a post receive hook in huboard by clicking Setup at the top and create hook. This will add a commit hook into github so that huboard knows when you have committed code. Just put &#8216;pushes GH-5&#8217; in your commit message and when you next push your changes up to github, Huboard will look for these commands and will move issue #5 into the next column in your process! Huboard also supports push, move, and moves as command names.</del>

### It&#8217;s open source!

That&#8217;s right! [Huboard](http://github.com/rauhryan/huboard) is open source hosted on [github](http://github.com/rauhryan/huboard)! And&#8230; Huboard uses huboard!

<img style="max-width: 100%;" src="http://cl.ly/1k0j3l1V0D1j2O0W123j/Image%202012-01-13%20at%204.18.40%20PM.png" alt="Huboard" />

### Sounds awesome, now tell me about the suck!

Huboard is in beta! (big surprise) Currently, it is open for everyone to use for free! We want to grow it slowly, which means we will be cutting off access after a certain amount of users to gauge how the site handles the traffic.

<del>Huboard does not work in IE. Sorry we tried, we really did but we can&#8217;t figure out or debug the problems with IE. <em>We !@#$ing hate IE</em></del>

Issues have to be opened and closed on [github.com](http://github.com), they are high on the backlog and coming soon! (in the mean time &#8216;gem install ghi&#8217; and bask in the awesome that is command line issue creation)

### Thats it!

Enjoy, feedback can be sent to [@huboard](http://twitter.com/huboard). Issues and feature requests can be logged on [github](https://github.com/rauhryan/huboard/issues/).