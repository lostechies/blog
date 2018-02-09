---
wordpress_id: 3703
title: Principles and Patterns over Tools and Frameworks
date: 2007-11-15T16:41:43+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/11/15/principles-and-patterns-over-tools-and-frameworks.aspx
categories:
  - Patterns
  - Refactoring
  - Tools
redirect_from: "/blogs/joeydotnet/archive/2007/11/15/principles-and-patterns-over-tools-and-frameworks.aspx/"
---
It&#8217;s interesting to see what other developers value and/or what topics they are interested in regarding the development of software.&nbsp; I&#8217;m going to start doing some internal presentations and live coding sessions at my company for my fellow consultants.&nbsp; I&#8217;ve got a pretty long list of possible topics, but I offered up 2 topics today that pertain to some of the work I&#8217;m doing on my current project.

  1. Examples of how to apply some of the core OO principles (i.e. SRP, OCP) in a real world application and some of the patterns that complement them (i.e. Decorator, Proxy, CoR). 
      * Writing automated web tests using [WatiN](http://watin.sourceforge.net/) </ol> 
    Guess which one got the most response?&nbsp; If you guessed #1, you must be working with folks who are passionate about writing clean, maintainable code, regardless of the technology.&nbsp; Consider yourself blessed.&nbsp; As for the rest of us, I&#8217;d venture to say #2 would usually be the most &#8220;popular&#8221; choice among developers.&nbsp; At least that&#8217;s the response I&#8217;ve received so far.&nbsp; 
    
    Of course, learning (and showing) a new automated web testing tool is very cool and can be very useful.&nbsp; I really like the Watix line of web testing frameworks.&nbsp; 
    
    But I see much more value in learning how to adhere to some of [&#8220;uncle Bob&#8217;s&#8221; OOD principles](http://www.mattberther.com/2006/10/25/principles-of-ood/) (Robert Martin&#8217;s site seems to be down, so that link is from Matt Berther) and how patterns can help us along the way.&nbsp; I see so many bugs that pop up in existing systems that would be so much easier to find and fix if just SRP alone was applied at some level in the code base.&nbsp; And even more likely, many of those bugs probably wouldn&#8217;t have existed in the first place.&nbsp; **My recent experience has proven (once again) that the violation of SRP along with code duplication makes a fertile ground for those little &#8220;buggers&#8221; to grow.**
    
    <SRP tangent>
    
    More and more, when folks ask me why I coded something a certain way, SRP has most likely influenced my decision.&nbsp; I think SRP is one of the most important principles that developers should be applying when they are implementing new features and/or refactoring an existing code base.&nbsp; The principle itself is very easy to learn. **Code should only do one thing.**&nbsp; This can be applied as high up as the logical layer level all the way down to a single line of code.&nbsp; How far you take it is answered in the usual &#8220;it depends&#8221; response.&nbsp; The difficulty in applying this principle, on the other hand, can vary greatly depending on the code base and the comfort level of the team with other OO principles and the patterns that support them.
    
    </SRP tangent>
    
    Ok, I&#8217;m back.&nbsp; So it sounds like I&#8217;m going to be doing the WatiN session first, but you better believe I&#8217;m going to be stressing the importance of writing good, clean code even for automated web tests.&nbsp; They&#8217;re not going to get off that easy.&nbsp; 🙂