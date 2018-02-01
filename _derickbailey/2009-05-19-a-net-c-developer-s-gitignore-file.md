---
id: 53
title: 'A .NET (C#) Developer’s .gitignore File'
date: 2009-05-19T02:55:26+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2009/05/18/a-net-c-developer-s-gitignore-file.aspx
dsq_thread_id:
  - "262068165"
categories:
  - git
---
As a recent convert to [the awesomeness that is git](http://git-scm.com/) (my current flavor is [msysgit](http://code.google.com/p/msysgit/)), I find myself continuously needing to update the [.gitignore](http://www.kernel.org/pub/software/scm/git/docs/gitignore.html) file that I copy and paste between my repositories. Here’s what my ignore file currently contains:

<div>
  <div>
    <pre>obj</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>bin</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>deploy</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>deploy/*</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>_ReSharper.*</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>*.csproj.user</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>*.resharper.user</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>*.resharper</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>*.suo</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>*.cache</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>~$*</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        The “~$*” line is for MS Office temp files. Other than that, it’s a pretty common list of files and folders that .NET (C#) developers would want to ignore in the git repositories.
      </p>
      
      <p>
        What does your .gitignore file look like? What am I missing from mine?
      </p>