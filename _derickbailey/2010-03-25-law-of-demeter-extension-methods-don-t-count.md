---
wordpress_id: 123
title: 'Law Of Demeter: Extension Methods Don’t Count'
date: 2010-03-25T14:10:16+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/03/25/law-of-demeter-extension-methods-don-t-count.aspx
dsq_thread_id:
  - "262068567"
categories:
  - .NET
  - 'C#'
  - Principles and Patterns
---
We all know the [Law of Demeter](http://en.wikipedia.org/wiki/Law_Of_Demeter), right? It’s the principle that says “don’t let the paperboy reach into your wallet when he wants to be paid. It’s your wallet, you decide what form of payment and how much without letting him have access to the contents of your wallet.”

A couple of days ago, a coworker told me to use this code for a specific situation:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> var asset = assets.FirstOrDefault().As&lt;RecordUniqueAsset&gt;();</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        He immediately followed that with a statement about Demeter screaming at him.
      </p>
      
      <p>
        It occurred to me at that point, that extension methods are just syntax sugar on top of what would otherwise take 10 or 15 lines of code and they don’t really count in the Law Of Demeter evaluation. Extension methods are typically just nice wrappers to help cut down on repeated code. For example, the “As” extension method in this snippet is one that we wrote to cast an object as the specified type (ignore how simple this extension is. it has it’s usefulness in some specific scenarios). Other extension methods that I write tend to be a little more involved, but still have the same basic idea behind them: take 4 or 5 lines of code that I use a lot and make it DRY.
      </p>
      
      <p>
        With that in mind, I say this:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> var asset = <span style="color: #0000ff">null</span>;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">if</span> (assets != <span style="color: #0000ff">null</span> && assets.Count &gt; 0)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>     asset = assets[0] <span style="color: #0000ff">as</span> RecordUniqueAsset;</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              is the same as the first code snippet in functionality and intent. The extension methods just makes it prettier, and does not violate the Law of Demeter.
            </p>
            
            <p>
              There probably are scenarios where the implementation of an extension method would violate LoD and thus the extension itself would… but for the simple scenario extension methods like this… I’m not convinced they violate LoD. What do you think? Does it violate LoD? If so, why? … and I’m also wondering if there are any similar constructs in other languages that would fall under the same exception.
            </p>