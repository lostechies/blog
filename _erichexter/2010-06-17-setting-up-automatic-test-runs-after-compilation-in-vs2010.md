---
wordpress_id: 3012
title: Setting up automatic test runs after compilation in VS2010
date: 2010-06-17T20:46:45+00:00
author: Eric Hexter
layout: post
wordpress_guid: /blogs/hex/archive/2010/06/17/setting-up-automatic-test-runs-after-compilation-in-vs2010.aspx
dsq_thread_id:
  - "262152326"
categories:
  - .NET
  - Agile
  - VS2010
redirect_from: "/blogs/hex/archive/2010/06/17/setting-up-automatic-test-runs-after-compilation-in-vs2010.aspx/"
---
I lifted some scripts from the interwebs so that after every compilation in visual studio unit tests are automatically run.&#160; I have been a long supporter of the TestDriven.Net addin and Resharper but I found auto running unit tests to be pretty freeing.&#160; Here&#8217;s the code.

So after a successful build the tests are run. Using this method you can automate any visual studio command or add in, including TestDriven.net or the Resharper Test runner.

&#160;

You can get the code from [CodePaste](http://codepaste.net/os62tt)

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="https://lostechies.com/content/erichexter/uploads/2011/03/image_thumb_42897E20.png" width="1028" height="488" />](https://lostechies.com/content/erichexter/uploads/2011/03/image_637CF0C7.png)