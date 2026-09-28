---
wordpress_id: 367
title: How to annoy your teammates
date: 2009-11-13T14:22:55+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/11/13/how-to-annoy-your-teammates.aspx
dsq_thread_id:
  - "273166961"
categories:
  - Misc
redirect_from: "/blogs/jimmy_bogard/archive/2009/11/13/how-to-annoy-your-teammates.aspx/"
---
In 3 easy steps:

### Step 1: Perform a change that affects many, many files

My favorite is a namespace rename.&#160; Other choices include deleting a core marker interface, renaming a layer supertype class, or changing the folder structure in a project.

Typically, VisualStudio will crash when I do this, though I’m not sure if it’s VS choking or ReSharper.&#160; Either way, a large automatic refactoring will cause a crash.

### Step 2: After the VS crash, re-open the solution and choose to recover all unsaved files

ReSharper likely made it quite a ways through your refactoring before VS crashed.&#160; All those unsaved files were likely cached for recovery by VisualStudio, so you can probably get a lot of those changes back.&#160; Instead of choosing to revert your local changes, go ahead and recover all those files.&#160; It’s key for maximum annoyance.

### Step 3: Merge these recovered files back to trunk

Since this was an _enormous_ refactoring, maybe affecting hundreds of files, you’ll want to merge your changes back to trunk as soon as possible.&#160; After all, you don’t want to be the sucker merging after everyone else has finished their work.

When you’re done, your co-workers will be greeted with one annoying merge, and another fun dialog that never seems to quite go away:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="https://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_3AC50861.png" width="451" height="242" />](https://lostechies.com/content/jimmybogard/uploads/2011/03/image_74481858.png) 

Just when you think you caught the last of the recovered files that had its line endings screwed up, another one pops up.&#160; They’ll hate you once because of the core change that affected so many files, making it quite annoying to merge back to trunk.&#160; But they’ll form that long-lasting, persistent hate because of this dialog box that keeps coming up.&#160; Yes, there is that little checkbox at the bottom, but who reads these things anyway?