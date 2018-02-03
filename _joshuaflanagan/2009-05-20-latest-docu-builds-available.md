---
wordpress_id: 3945
title: Latest Docu builds available
date: 2009-05-20T02:29:44+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2009/05/19/latest-docu-builds-available.aspx
dsq_thread_id:
  - "262113167"
categories:
  - docu
---
<a href="http://docu.jagregory.com/" target="_blank">Docu</a> is a tool to create documentation out of your .NET XML comments, much in the same way we used to use NDoc. If legend has it right, it was created by the prolific <a href="http://jagregory.lostechies.com" target="_blank">James Gregory</a> with the sole goal of generating the documentation for <a href="http://fluentnhibernate.org/" target="_blank">Fluent NHibernate</a>. It won’t ever compete with <a href="http://sandcastle.codeplex.com/" target="_blank">Sandcastle</a> on features or functionality, nor should it. If you just need to create developer-focused, HTML documentation for your API, docu is the perfect tool. If you need to create higher level end-user documentation in different formats, you’ll probably always be better off with something like Sandcastle.

Because of its original narrow focus, it doesn’t currently support all language elements completely, or all of the possible documentation tags. Fortunately, it has a solid codebase to build on, and there has been a lot of interest in it, as a simpler alternative to Sandcastle for simple tasks. Since it is under active development, and each change provides better and better support and stability, a single release can get outdated quickly. I thought it was important to make it easy for potential users to get the latest and greatest bits without having to get the code and compile it themselves.

I’m happy to announce that you can now do just that by visiting the awesome <a href="http://teamcity.codebetter.com" target="_blank">teamcity.codebetter.com</a>. Login as guest (or create an account for yourself, if you’d like to monitor the build status of your favorite open source projects) and click on Docu in the list of projects. On the Docu page you will see a list of all recent builds, with the build number in the leftmost column. Click on the “View” link (or the down-arrow next to it) within the Artifacts column for the build you are interested in to see the list of files created by that build. Just grab the zip file and extract it to a folder and and you are ready to go.

**UPDATE:** As of build #35, you can download a zip file for each build which contains everything needed to run docu. You no longer need to download an earlier release from the project site first.

Of course, you will be running from trunk, and so all the usual risks and disclaimers apply, but I think the project is still at an early enough stage that it actually gets more stable with each commit. That said, if you do run into problems, you can report issues to the <a href="http://docu.lighthouseapp.com/projects/27685-docu/tickets" target="_blank">docu issue tracker</a>, ask a question on the <a href="http://groups.google.com/group/docu-group" target="_blank">mailing list</a>, or just contact me through this blog and I’ll do my best to help you out.