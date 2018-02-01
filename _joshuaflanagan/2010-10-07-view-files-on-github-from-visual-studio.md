---
id: 3966
title: View files on GitHub from Visual Studio
date: 2010-10-07T02:31:31+00:00
author: Joshua Flanagan
layout: post
guid: /blogs/joshuaflanagan/archive/2010/10/06/view-files-on-github-from-visual-studio.aspx
dsq_thread_id:
  - "262113241"
categories:
  - git
---
My favorite way to view the history of a file in git is via the GitHub website. It gives me all the information I need, with convenient hyperlinks to to additional information. However, it was never easy to go from the file I’m currently viewing in Visual Studio, to the file’s page on GitHub. I had to manually open the browser to the repository’s GitHub page, the click the links as a I navigate the folder structure on the Source tab. If you have a deeply nested structure as we do, you know how painful this is.

My solution is a set of Visual Studio macros that let me jump directly to the commit history page (git log) or line-by-line history page (git blame) for the current file. The macros figure out your GitHub repository URL from your configured remotes, and then launch your default browser to the file’s page.

The code and installation instructions are in my <a href="http://github.com/joshuaflanagan/gitmacros" target="_blank">gitmacros GitHub repository</a>.

Try them out and let me know what you think. Feedback and patches (pull requests) are welcome.