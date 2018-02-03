---
wordpress_id: 3864
title: ReSharper Shortcut for Context-Sensitive Unit-Test Running
date: 2010-06-20T01:21:00+00:00
author: Sharon Cichelli
layout: post
wordpress_guid: /blogs/sharoncichelli/archive/2010/06/19/resharper-shortcut-for-context-sensitive-unit-test-running.aspx
dsq_thread_id:
  - "263370931"
categories:
  - Resharper
  - shortcut
  - Unit Testing
  - Visual Studio
---
For a keyboard shortcut to the context-sensitive ReSharper unit test runner (otherwise available via right-click > Run Unit Tests), map:

<p style="padding-left: 30px">
  ReSharper.ReSharper_UnitTest_ContextRun
</p>

<p style="padding-left: 30px">
  Edit: <a href="http://blogs.jetbrains.com/dotnet/2011/06/resharper-60-release-candidate/#comment-331090">In ReSharper 6, this has moved</a>. It is now<br /> ReSharper.ReSharper_ReSharper_UnitTest_RunContext.<br />(Note the extra ReSharper in there; that&#8217;s not a typo.)
</p>

(Thanks to [Clinton](http://handcraftsman.wordpress.com/) for mentioning it.)

## What This Solves

The slowest way to select and run unit tests is to click the green-yellow bubbles in the left margin and pick &#8220;Run&#8221; (or &#8220;Append to Session&#8221; to collect a bunch of them to run).

![](//lostechies.com/sharoncichelli/files/2011/03/ResharperTestRunner.png)

From the right-click menu, the &#8220;Run Unit Tests&#8221; option will run a test if your cursor is in a test, all tests in a fixture if your cursor is outside a test but within the fixture, or all tests in a file if you&#8217;re outside any fixtures.

Mapping the ReSharper.ReSharper\_UnitTest\_ContextRun to a keyboard shortcut achieves the context-sensitive behavior, mouse free. I chose Alt-T for mine, since that wasn&#8217;t in use for anything else. (Have a nice strategy for picking unique keyboard shortcuts and remembering them? Please share in the comments.)

## To Map the Shortcut

Tools > Options > Environment > Keyboard. In the &#8220;Show commands containing&#8221; textbox, enter some or all of the command, and select the command.

![](//lostechies.com/sharoncichelli/files/2011/03/MapResharperShortcut.png)

Set your focus to the &#8220;Press shortcut keys&#8221; textbox and type your shortcut just as if you were invoking it. If a command shows up in the &#8220;Shortcut currently used by&#8221; list, life will be simpler if you pick a different shortcut. When you have one you like, click &#8220;Assign&#8221; and &#8220;OK.&#8221; Good to go!