---
wordpress_id: 3963
title: Error detected while processing vimrc error when using UTF-8 characters in listchars variable
date: 2010-07-16T16:23:57+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2010/07/16/error-detected-while-processing-vimrc-error-when-using-utf-8-characters-in-listchars-variable.aspx
dsq_thread_id:
  - "262113254"
categories:
  - Vim
redirect_from: "/blogs/joshuaflanagan/archive/2010/07/16/error-detected-while-processing-vimrc-error-when-using-utf-8-characters-in-listchars-variable.aspx/"
---
This error stumped me for a while, and I didn’t find any good answers on Google, so hopefully this can help someone else. I’m running gVim 7.2 on Windows – this information may not apply to other versions/platforms.

### Problem

I’ve been slowly adding more functionality to my vimrc file. Today I learned about the listchars setting, which allows you to choose what placeholders to use when displaying whitespace (taking the tip from <a href="http://items.sjbach.com/319/configuring-vim-right" target="_blank">Configuring Vim right</a>). 

For my “trail” setting (spaces at the end of a line), I picked the Middle Dot Unicode character · (U+00B7 or RightAlt+0183). When I saved (:w) and reloaded the new settings (:so ~_vimrc), the setting took effect with no problem. However, when I closed gVim and re-opened it, I was greeted with the error message “Invalid argument: listchars…”

[<img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="https://lostechies.com/content/joshuaflanagan/uploads/2011/03/image_thumb_7404C0AC.png" width="392" height="137" />](https://lostechies.com/content/joshuaflanagan/uploads/2011/03/image_09627615.png) 

### Solution

After much trial an error, I determined that my \_vimrc file must be encoded as UTF-8 with Signature. It was previously encoded as UTF-8 (w/o Signature) – which is how gVim encodes the default file. To fix it, I opened \_vimrc in my old favorite <a href="http://www.flos-freeware.ch/notepad2.html" target="_blank">Notepad2</a>, clicked on the UTF8 in the status bar, selected UTF-8 Signature, and saved the file. The next time I started gVim, there was no error, and my trailing whitespace displayed with the Middle Dot.

**<font color="#008000">Update</font>**: A comment from John Weldon suggested a much simpler solution that you can do with vim (no Notepad2 required).

(Optional) If it isn’t already UTF-8 (mine was), set the encoding:

:set fileencoding=utf-8

Tell vim to store the encoding signature:

:set bomb

And of course :w to save the file.