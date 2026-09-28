---
wordpress_id: 3974
title: Announcing HtmlTags 1.0
date: 2011-05-22T16:19:29+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: http://lostechies.com/joshuaflanagan/2011/05/22/announcing-htmltags-1-0/
dsq_thread_id:
  - "310893365"
categories:
  - FubuMVC
---
I&#8217;m pleased to announce the release of version 1.0 of the <a href="https://github.com/darthfubumvc/htmltags" target="_blank">HtmlTags</a> library. You can add it to your projects today using <a href="http://www.nuget.org/" target="_blank">nuget</a>.

<font face="Courier New">> Install-Package HtmlTags</font>

HtmlTags provides a simple object model for generating HTML from .NET code. The main premise is that you are much better off building a model of the HTML elements you want to produce (and serializing it to a string when needed), rather than building a string directly. It was created by <a href="http://codebetter.com/jeremymiller/" target="_blank">Jeremy Miller</a> as part of <a href="https://github.com/DarthFubuMVC/fubumvc" target="_blank">FubuMVC</a> to support the awesome <a href="https://lostechies.com/joshuaflanagan/2011/02/23/code-samples-from-my-adnug-talk-coding-with-conventions/" target="_blank">conventional HTML features I&#8217;ve talked about before</a>. I then pulled it out of FubuMVC and tightened up the API for a more general release. I strongly believe that regardless of which .NET web framework you are using, if you are generating snippets of HTML (think ASP.NET MVC HtmlHelper extensions), you should use HtmlTags.

Check out the <a href="https://github.com/DarthFubuMVC/htmltags/blob/master/readme.md" target="_blank">readme</a> for an overview and example usage of HtmlTags.

Big thanks to <a href="https://lostechies.com/sharoncichelli/" target="_blank">Sharon Cichelli</a> for helping me put the final touches on the codebase for the 1.0 release, and to <a href="http://blog.robertgreyling.com/" target="_blank">Robert Greyling</a> for the sharp new logo!