---
id: 103
title: ReSharper in VS 2008
date: 2007-11-20T19:21:40+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/11/20/resharper-in-vs-2008.aspx
dsq_thread_id:
  - "264715444"
categories:
  - Tools
---
**UPDATE 11/26/2007**

**[Jeffrey Palermo](http://codebetter.com/blogs/jeffrey.palermo/) notes that you can use R# in VS 2008 by [turning off a couple of features](http://codebetter.com/blogs/jeffrey.palermo/archive/2007/11/21/tips-for-immediately-using-r-3-0-2-with-vs-2008.aspx).**

**[Ilya Ryzhenkov](http://resharper.blogspot.com/), product manager at JetBrains, [gives detailed information](http://resharper.blogspot.com/2007/11/resharper-and-visual-studio-2008.html) on R# support in VS 2008 and talks about R# 4.0.**

After installing VS 2008 Team Suite yesterday, I thought I&#8217;d try the [ReSharper 3.0 for VS 2008 download](http://www.jetbrains.com/resharper/download/index.html#VS2008).&nbsp; The verdict?&nbsp; Works great unless you use any C# 3.0 feature.&nbsp; Here&#8217;s one example of it blowing up (but not crashing):

![](http://grabbagoftimg.s3.amazonaws.com/resharper_orcas_1.PNG)

I&#8217;m using:

  * var keyword 
      * anonymous types 
          * LINQ</ul> 
        That was a simple LINQ query to count the number of types in the .NET Framework that implement IDisposable and end in the word &#8220;Context&#8221; (to settle a bet).&nbsp; Here&#8217;s another example:
        
        ![](http://grabbagoftimg.s3.amazonaws.com/resharper_orcas_2.PNG)
        
        That&#8217;s an experimental API for pre- and post-conditions (for pseudo-design-by-contract) that uses:
        
          * extension methods 
              * lambda expressions</ul> 
            From JetBrains&#8217; website, they clearly state in the download page:
            
            > ReSharper 3.0 for Visual Studio 2008 (Codename &#8220;Orcas&#8221;) only supports C# 2.0 and Visual Basic .NET 8 language features. C# 3.0 will be supported in the next major release of ReSharper.
            
            Now I have a dilemma.&nbsp; Using Visual Studio without ReSharper is like taking a trip&nbsp;in a&nbsp;horse and buggy instead of a car.&nbsp; Sure, it&#8217;ll get you there, but you&#8217;ll have to deal with a lot of crap along the way.&nbsp; Until R# v.Next comes out, I&#8217;ll just have to&nbsp;deal with it.&nbsp; **If you&#8217;re using VS 2008, don&#8217;t install R# 3.0&nbsp;if you plan on using C# 3.0.&nbsp;** Hopefully it&#8217;ll come out soon, but I haven&#8217;t seen any roadmaps yet, so I&#8217;ll just wait.