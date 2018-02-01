---
id: 3223
title: 'Refactoring Day 29 : Remove Middle Man'
date: 2009-08-28T16:38:31+00:00
author: Sean Chambers
layout: post
guid: /blogs/sean_chambers/archive/2009/08/28/refactoring-day-29-remove-middle-man.aspx
dsq_thread_id:
  - "262356465"
categories:
  - Uncategorized
---
Today’s refactoring comes from Fowler’s refactoring catalog and can be <a href="http://refactoring.com/catalog/removeMiddleMan.html" target="_blank">found here</a>.

Sometimes in code you may have a set of “Phantom” or “Ghost” classes. Fowler calls these “Middle Men”. Middle Men classes simply take calls and forward them on to other components without doing any work. This is an unneeded layer and can be removed completely with minimal effort.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Consumer</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> AccountManager AccountManager { get; set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   4:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   5:</span>     <span class="kwrd">public</span> Consumer(AccountManager accountManager)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   6:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   7:</span>         AccountManager = accountManager;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   8:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   9:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  10:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> Get(<span class="kwrd">int</span> id)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  11:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  12:</span>         Account account = AccountManager.GetAccount(id);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  13:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  14:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  15:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  16:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> AccountManager</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  17:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  18:</span>     <span class="kwrd">public</span> AccountDataProvider DataProvider { get; set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  19:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  20:</span>     <span class="kwrd">public</span> AccountManager(AccountDataProvider dataProvider)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  21:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  22:</span>         DataProvider = dataProvider;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  23:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  24:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  25:</span>     <span class="kwrd">public</span> Account GetAccount(<span class="kwrd">int</span> id)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  26:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  27:</span>         <span class="kwrd">return</span> DataProvider.GetAccount(id);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  28:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  29:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  30:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  31:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> AccountDataProvider</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  32:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  33:</span>     <span class="kwrd">public</span> Account GetAccount(<span class="kwrd">int</span> id)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  34:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  35:</span>         <span class="rem">// get account</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  36:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  37:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        The end result is straightforward enough. We just remove the middle man object and point the original call to the intended receiver.
      </p>
      
      <div class="csharpcode-wrapper">
        <div class="csharpcode">
          <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> Consumer</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> AccountDataProvider AccountDataProvider { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   4:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   5:</span>     <span class="kwrd">public</span> Consumer(AccountDataProvider dataProvider)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   6:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   7:</span>         AccountDataProvider = dataProvider;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   8:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">   9:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  10:</span>     <span class="kwrd">public</span> <span class="kwrd">void</span> Get(<span class="kwrd">int</span> id)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  11:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  12:</span>         Account account = AccountDataProvider.GetAccount(id);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  13:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  14:</span> }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  15:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  16:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> AccountDataProvider</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  17:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  18:</span>     <span class="kwrd">public</span> Account GetAccount(<span class="kwrd">int</span> id)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  19:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  20:</span>         <span class="rem">// get account</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  21:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span class="lnum">  22:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              <em><span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</span></em>
            </p>