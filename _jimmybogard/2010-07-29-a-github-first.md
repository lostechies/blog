---
wordpress_id: 424
title: A github first
date: 2010-07-29T13:02:19+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/07/29/a-github-first.aspx
dsq_thread_id:
  - "265396547"
categories:
  - git
redirect_from: "/blogs/jimmy_bogard/archive/2010/07/29/a-github-first.aspx/"
---
Like many [github](https://github.com/) users, I often create forks for projects whenever I want to pull down their code, rather than cloning from the source directly.&#160; This is pretty much the default way of working on github, as the site encourages collaboration through individualized repositories.&#160; On my github page, this is what you’d see for my repositories:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_74F0FC8A.png" width="361" height="384" />](http://lostechies.com/content/jimmybogard/uploads/2011/03/image_6EAA25FC.png) 

It’s front and center, right on my home page.&#160; Only two of those repositories were ones that I created completely fresh, and the rest are forks.

The other day, I posted a question on the StructureMap mailing list, but wound up getting a response in a github pull request!

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_45BF10F3.png" width="608" height="144" />](http://lostechies.com/content/jimmybogard/uploads/2011/03/image_664650A5.png) 

This is because it’s just as easy to fork a user’s repository as it is the central repository.&#160; Even the concept of a “central repository” isn’t ingrained in git (or github), there are only “blessed” repositories that the OSS project’s organizers agree upon.&#160; For example, the “blessed” AutoMapper repository is just the AutoMapper repository in my github.

Pretty sweet, I can pull in this request locally, as well as any upstream StructureMap changes (as Git allows me to have as many remotes as I want), and see if it works for me.&#160; If it does, I can then issue a pull request to the blessed StructureMap repository.&#160; But if it doesn’t go through, no worries, I have my own StructureMap repository 🙂

### </p> 

### Comparison to CodePlex

CodePlex is fantastic for a public-facing project hub, but it’s still not close to github on the OSS collaboration side.&#160; Here’s an example, my homepage for the AutoMapper repository looks like this:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_1D402EDF.png" width="972" height="357" />](http://lostechies.com/content/jimmybogard/uploads/2011/03/image_2537D141.png) 

I have a wealth of information at my disposal here.&#160; For new users, it’s a one-click operation to watch the project, fork it, create a pull request.&#160; I can see how many folks follow the project or forked it.&#160; All the information here is about the repository itself, rather than a project.&#160; Github has a separate page for that, but by default, it’s about collaboration rather than documentation.

On CodePlex, I get a list of checkins:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_3014B289.png" width="655" height="344" />](http://lostechies.com/content/jimmybogard/uploads/2011/03/image_036BF8B0.png) 

The list of forks isn’t that much better.&#160; CodePlex is definitely making strides, but you can definitely tell the difference between an OSS project hosting site built around DVCS versus one around centralized version control.&#160; In github, its design is built around distributed collaboration, centered around individual commiters.&#160; In CodePlex, its design is built around centralized projects.

Both definitely have their benefits, as it’s super-easy to get a URL to the CodePlex AutoMapper project page:&#160; <http://automapper.codeplex.com>.&#160; In fact, I kept the project on CodePlex because its support for project-centric activities I felt was better.&#160; However, its support for collaboration-centric workflows still is pretty far away from github.&#160; Unfortunately, CodePlex has to support both centralized (TFS) and distributed (Hg) source control systems, so I’m not sure how it’ll all shake out in the end…