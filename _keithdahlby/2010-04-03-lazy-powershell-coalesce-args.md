---
wordpress_id: 4209
title: Lazy PowerShell Coalesce-Args
date: 2010-04-03T16:57:00+00:00
author: Keith Dahlby
layout: post
wordpress_guid: /blogs/dahlbyk/archive/2010/04/03/lazy-powershell-coalesce-args.aspx
dsq_thread_id:
  - "262493339"
categories:
  - posh-git
  - Powershell
redirect_from: "/blogs/dahlbyk/archive/2010/04/03/lazy-powershell-coalesce-args.aspx/"
---
A while back I posted a [coalesce function for PowerShell](http://solutionizing.net/2008/12/20/powershell-coalesce-and-powershellasp-query-string-parameters/ "PowerShell Coalesce and PowerShellASP Query String Parameters") that would try to return the first non-null argument passed to it. One drawback of this function is that each argument expression will be evaluated before being passed into the function. This didn&#8217;t work so well for [posh-git](http://github.com/dahlbyk/posh-git/), where each call to `git` adds undesirable delay to the prompt. To address this issue, I wrote a new ScriptBlock-aware version that allows us to defer execution of the fallback cases until we need them:

<pre>function Coalesce-Args {<br />&nbsp;&nbsp;&nbsp; $result = $null<br />&nbsp;&nbsp;&nbsp; foreach($arg in $args) {<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if ($arg -is [ScriptBlock]) {<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $result = & $arg<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; } else {<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $result = $arg<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if ($result) { break }<br />&nbsp;&nbsp;&nbsp; }<br />&nbsp;&nbsp;&nbsp; $result<br />}<br />Set-Alias ?? Coalesce-Args -Force</pre>

It&#8217;s worth pointing out that this is probably the first time I&#8217;ve actually used a `foreach` statement in PowerShell, specifically for `break` support. The vast majority of the time it&#8217;s preferred to use the pipeline and `ForEach-Object`.

For an example of usage, here&#8217;s how posh-git tries to determine the current branch name in [Get-GitBranch](http://github.com/dahlbyk/posh-git/blob/master/GitUtils.ps1 "GitUtils.ps1 at master from posh-git on GitHub"):

<pre>$b = ?? { git symbolic-ref HEAD 2&gt;$null } `<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; { "($(<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Coalesce-Args `<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; { git describe --exact-match HEAD 2&gt;$null } `<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $ref = Get-Content $gitDirHEAD 2&gt;$null<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if ($ref -and $ref.Length -ge 7) {<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return $ref.Substring(0,7)+'...'<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; } else {<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return $null<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; } `<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 'unknown'<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ))" }</pre>