---
wordpress_id: 155
title: 'Vim+Grep: Find All Occurrences Of Text In Your Project'
date: 2010-05-11T12:00:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/05/11/vim-grep-find-all-occurrences-of-text-in-your-project.aspx
dsq_thread_id:
  - "262042416"
categories:
  - Albacore
  - Productivity
  - Ruby
  - Smoke Test
  - Vim
redirect_from: "/blogs/derickbailey/archive/2010/05/11/vim-grep-find-all-occurrences-of-text-in-your-project.aspx/"
---
I’m in the middle of some sweeping changes in [albacore](http://albacorebuild.net) – changing the .path\_to\_command property to .command for all of the tasks that run an external tool. The core of the change is easy. I have a RunCommand module that contains the definition for .path\_to\_command. However, there are a lot of unit tests and example code chunks that use the .path\_to\_command attribute all throughout the code. Back when I was using E TextEditor or another editor that had the concept of a “project”, I would do a “find all occurrences” in the project and look for the .path\_to\_command property. In vim, I wasn’t sure how to do this, but I did know that I could accomplish the same thing using grep on the command line. A quick google search for “vim grep” turned up&#160; a page on the vim wikia and had me up and running with [vimgrep](http://vim.wikia.com/wiki/Find_in_files_within_Vim) (among other options) in no time.

From the wikia page:

> “_These commands all fill a list with the results of their search. "grep" and "vimgrep" fill the "quickfix list", which can be opened with <tt>:cw</tt> or <tt>:copen</tt>, and is a list shared between ALL windows. [… This] can be used to instantly jump to the matching line in whatever file it occurs in._”

The search pattern is as easy as any other / search, with a few different options:

> <pre>:vim[grep][!] /{pattern}/[g][j] {file} ...</pre>

  * The /pattern/ is a standard vim search pattern
  * The “g” option find all matches – including multiple matches on the same line.
  * The “j” option turns off the auto-goto first match feature.
  * The file list allows you to specify individual files, or wild-card searches, including recursive search with file globs

There are a lot of great tips and tricks on that wikia page. You’ll want to read up on them to get an idea of what you can really do with this.

&#160;

### Searching For .path\_to\_command In All Files

The working directory in vim can be considered the ‘project root’ in that all file / folder based commands work relative to the working directory. This makes a global find in all files of a project easy since I always start up vim in the working folder that I want. For example, using [NERDTree](http://www.vim.org/scripts/script.php?script_id=1658) I can see that I am in the root of my albacore project as the working directory:

&#160; <img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_065EE523.png" width="634" height="460" />

To search within the albacore ‘project’ folder and find all instances of ‘path\_to\_command’, I used vimgrep like this:

> :vimgrep /path\_to\_command/gj ./*\*/\*.rb

This told vim to grep for ‘path\_to\_command’ and return every result on every line, in any .rb file, recursively, starting at the project folder. Run the :cw command after the grep is done, and the list of files and locations will show up:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_thumb_524A45CF.png" width="634" height="267" />](http://lostechies.com/derickbailey/files/2011/03/image_1A7801AC.png) 

You can navigate the list with standard vim navigation (h,j,k,l, etc). Hit <enter> on the item you want and the top window split will jump to the file/line/column:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_thumb_1C18A7B3.png" width="634" height="266" />](http://lostechies.com/derickbailey/files/2011/03/image_1EA1D971.png) </p> </p> 

&#160;

### Macro’ing The Change To Speed Things Up

Now that I have an easy way to find the instances of ‘path\_to\_command’, I can easily macro the change to ‘command’. For this macro, I assume that my cursor is currently on the ‘p’ in ‘path\_to\_command’ and that my grep search results is in the window split below the current cursor selection:

> :qccwcommand<Esc>:w<Ctl-W>jj<Enter>q

This macro (which includes the record start / stop, if you’re wondering) will change the current ‘path\_to\_command’ word to ‘command’, write the file out to disk, change window splits to the grep search results, move down one line in the results and navigate to that result’s location. I ran the macro by hitting @c and then verifying the line selected was one that I wanted to change. For a few instances where I did not want to change the line, I manually navigated to the next search result and then re-ran the @c macro.

All told, I got through the changes in a few minutes with this macro. I would estimate that this saved me at least 30 minutes to an hour of trying to remember if I found all the places I needed to change prior to running the test suite to verify my changes.