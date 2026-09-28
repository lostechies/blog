---
wordpress_id: 4218
title: Code Review with Git Patches and Outlook via PowerShell
date: 2010-12-06T02:31:00+00:00
author: Keith Dahlby
layout: post
wordpress_guid: /blogs/dahlbyk/archive/2010/12/05/code-review-with-git-patches-and-outlook-via-powershell.aspx
dsq_thread_id:
  - "263678146"
categories:
  - git
  - Powershell
redirect_from: "/blogs/dahlbyk/archive/2010/12/05/code-review-with-git-patches-and-outlook-via-powershell.aspx/"
---
In the spirit of &#8220;simplest thing that works,&#8221; my team has a rather
  
low-fidelity approach to code reviews: patch files and e-mail. Nothing
  
fancy, but we find it works rather well. It&#8217;s even easier thanks to `git format-patch`, which lets me easily generate a patch per commit, but I was never able to get `send-email` to work quite like I wanted. Instead, I whipped together a PowerShell script in a few minutes that does just the trick:

<pre>function patch ($ref = 'master..', $Message = '', [switch]$KeepFiles) {<br />  $patchPaths = $(git format-patch -C -o C:/Temp/Patches $ref)<br />  if($patchPaths) {<br />    $outlook = New-Object -ComObject Outlook.Application<br />    $mail = $outlook.CreateItem(0)<br />    [void]$mail.Recipients.Add('myteam@mycompany.com')<br />    $mail.Subject = "Review - $Message"<br />    $commits = $(git log -C --pretty=format:'%s' --reverse $ref) | foreach {  "&lt;li&gt;$_&lt;/li&gt;" }<br />    $mail.HTMLBody = "&lt;ol style=`"font: 11pt Calibri`"&gt;$commits&lt;/ol&gt;"<br />    $patchPaths | foreach {<br />      [void]$mail.Attachments.Add($_)<br />      if(!$KeepFiles) { Remove-Item $_ }<br />    }<br />    $mail.Display()<br />  } else {<br />    Write-Warning 'Nothing to patch!'<br />  }<br />}</pre>

### Usage:

Create patch of everything on current branch since master:

<pre>patch -m "Issue 123 - This is neat"</pre>

Create patch of last two commits, without message:

<pre>patch HEAD~2..</pre>

Create patch of everything except the current commit, with message:

<pre>patch master..HEAD~1 'Refactoring for Story 234'</pre>