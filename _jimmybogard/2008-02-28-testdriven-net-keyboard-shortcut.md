---
id: 147
title: TestDriven.NET keyboard shortcut
date: 2008-02-28T01:42:55+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/02/27/testdriven-net-keyboard-shortcut.aspx
dsq_thread_id:
  - "264715564"
categories:
  - Tools
---
Continuing with the Palermo brain dump theme, [Jeffrey](http://codebetter.com/blogs/jeffrey.palermo/) introduced me to a keyboard shortcut for running [TestDriven.NET](http://www.testdriven.net/) tests from a keyboard shortcut.&nbsp; I had been right-clicking and going from the context menu:

![](http://grabbagoftimg.s3.amazonaws.com/tools_tdnet.PNG)

While the context menu is nice, it has me reaching for the mouse (like a chump).&nbsp;&nbsp; Instead, I can set a keyboard shortcut to perform the same context-sensitive testing.

To set the keyboard shortcut, first go to &#8220;Tools->Options&#8230;&#8221; to bring up the Visual Studio Options dialog, then select the &#8220;Environment->Keyboard&#8221; screen:

 ![](http://grabbagoftimg.s3.amazonaws.com/testdriven.PNG)

In the &#8220;Show commands containing:&#8221; text box, enter &#8220;TestDriven&#8221; to get the the TestDriven.NET command quickly.&nbsp; Select the &#8220;TestDriven.NET.RunTests&#8221; command and click the &#8220;Press shortcut keys:&#8221; text box.&nbsp; Now enter the keyboard shortcut you like (I use &#8216;Ctrl-T&#8217;) and **click the Assign button**.&nbsp; The shortcut key is not assigned until you click the &#8220;Assign&#8221; button.

Once you assign the shortcut, I additionally set the &#8220;Use new shortcut in:&#8221; to &#8220;Text Editor&#8221;.&nbsp; For some reason, setting &#8220;Global&#8221; wasn&#8217;t enough, I had to set the &#8220;Text Editor&#8221; command also.

With this keyboard shortcut in place, you don&#8217;t need to lift your hand to the mouse after writing your test.&nbsp; The shortcut also works everywhere the TestDriven.NET menu works, so I can select a file, project, or solution in the Solution Explorer and run all of the tests with a quick keystroke.&nbsp; Since the context menu gets pretty unruly, I save some time I normally spend searching through a menu that now stretches my entire screen.