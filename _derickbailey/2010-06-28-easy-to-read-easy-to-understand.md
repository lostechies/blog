---
id: 171
title: Easy To Read != Easy To Understand
date: 2010-06-28T20:11:30+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2010/06/28/easy-to-read-easy-to-understand.aspx
dsq_thread_id:
  - "264671620"
categories:
  - Analysis and Design
  - AntiPatterns
---
I ran into this code a while back:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">abstract</span> <span style="color: #0000ff">class</span> ScanPrefixSpecification : IScanSpecification</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">abstract</span> IEnumerable&lt;<span style="color: #0000ff">string</span>&gt; BarcodePrefixesFilter { get; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>     </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> IsSatisfiedBy(<span style="color: #0000ff">string</span> item)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>         <span style="color: #0000ff">return</span> BarcodePrefixesFilter.Where(item.StartsWith).Any();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> GetScanFrom(<span style="color: #0000ff">string</span> scanString)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>         <span style="color: #0000ff">foreach</span> (var prefixFilter <span style="color: #0000ff">in</span> BarcodePrefixesFilter.Where(scanString.StartsWith))</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span>             <span style="color: #0000ff">return</span> scanString.Substring(prefixFilter.Length);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span>         <span style="color: #0000ff">return</span> <span style="color: #006080">""</span>;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  17:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  18:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        There isn’t anything wrong with this code from a technical standpoint. It does exactly what it needs to do and it provides a specific point of functionality in our system. By reading the code and by reading the tests around this code, I can see <em>what</em> this class does:
      </p>
      
      <ul>
        <li>
          it’s a basic specification pattern where the scanned item satisfies the specification when the “item” starts with any of the strings found in the BarcodePrefixesFilter list
        </li>
        <li>
          and it removes the first match found in the BarcodePrefixesFilter list from the beginning of the “scanString”; or returns an empty string if no matches were found
        </li>
      </ul>
      
      <p>
        Ok, that’s great… now, why does it do that? Where does this code express the needs of the business; the understanding of why those characters need to be removed from the front of the scanned string? How much additional code am I going to have to read to understand the context of this code? How long will it take me to understand what functionality this code facilitates, from a functional view of the system?
      </p>
      
      <p>
        … easy to read is not the same as easy to understand. Be sure your code is understandable, not just readable; and the only way to do that is for someone else to look at your code and work with it.
      </p>