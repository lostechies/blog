---
wordpress_id: 635
title: Using posh-git and posh-hg together
date: 2012-06-15T14:59:27+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2012/06/15/using-posh-git-and-posh-hg-together/
dsq_thread_id:
  - "727352732"
categories:
  - git
  - Mercurial
---
I use both Git and Mercurial for projects, as well as Powershell as a console for both. Both source control systems have awesome plugins in [posh-git](https://github.com/dahlbyk/posh-git) and [posh-hg](https://github.com/JeremySkinner/posh-hg) that provide nice statuses, tab expansions and so on. However, they don’t just automatically play nice with one another. I installed Github for Windows, and found that my posh-hg stuff went away.

However, thanks to [this Stack Overflow answer](http://stackoverflow.com/questions/4500134/posh-git-and-posh-hg-together), it’s easy to use both of these together. I cloned both repositories to my local box, and then just modified the script to point to that version:

{% gist 2936866 %}

Now I get both posh-hg and posh-git working together!