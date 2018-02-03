---
wordpress_id: 47
title: Analyzing historical data and playing with interactive extensions
date: 2010-09-21T14:07:38+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: /blogs/gabrielschenker/archive/2010/09/21/analyzing-historical-data-and-playing-with-interactive-extensions.aspx
dsq_thread_id:
  - "1073173410"
categories:
  - Fluent NHibernate
  - interactive extensions
  - NHibernate
  - Reporting
---
## Introduction

In my [last post](http://www.lostechies.com/blogs/gabrielschenker/archive/2010/09/15/making-history-explicit.aspx) I showed you how we make history an explicit domain concept. This time I want to show you how we use the history of the cages to generate bills. In our Zoo each cage has an associated per diem rate (dollars per day). This per diem rate reflects the cost associated with space occupied by the cage as well as the hosting of animals in the cage (feeding, cleaning, etc.)

## Calculate Time Intervals

To provide a monthly bill to the Zoo management per cage type we have to retrieve the history data we have collected over the specific time range and aggregate the cost over the time span.

In our history records we only have/store the creation date of each record. To calculate costs we need time ranges during which a specific state is valid. Now the start date of an interval corresponds to the creation date of the specific record. The end date of the interval corresponds to the creation date of the next history record in the sequence. We can easily calculate these intervals using a for loop

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> var list = cageHistoryList.ToArray();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">for</span>(var i = 0; i &lt; list.Length - 1; i++)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>     list[i].EndDate = list[i+1].StartDate;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        but this is not a very declarative way of doing set based operations and can quickly become very difficult to read if we add some more logic. On the other hand we all have come to love LINQ. So let’s utilize what the new interactive extensions (which are part of the <a href="http://msdn.microsoft.com/en-us/devlabs/ee794896.aspx">Rx framework</a>) provide us
      </p>
      
      <p>
        We can use the <strong>Zip</strong> function to build pairs of two source streams. In our case we want the two source streams both be the cage history records but shifted by one element; that is we want to have a series of pairs
      </p>
      
      <p>
        <a href="http://lostechies.com/gabrielschenker/files/2011/03/image_7D067644.png"><img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2011/03/image_thumb_6ABDAF82.png" width="244" height="39" /></a>
      </p>
      
      <p>
        assuming that our source stream is <strong>cageHistoryList</strong> and that the source stream only contains the history of one cage we can then write
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> var list = cageHistoryList.Zip(cageHistoryList.Skip(1), </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span>                                (h1, h2) =&gt; <span style="color: #0000ff">new</span> {H1 = h1, H2 = h2})</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>          .Do(pair =&gt; pair.H1.EndDate = pair.H2.StartDate)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>          .Select(pair =&gt; pair.H1);</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              The <strong>Do</strong> function introduces side effects onto the stream of data but remains in the <a href="http://en.wikipedia.org/wiki/Monad_(functional_programming)">monad</a>.
            </p>
            
            <p>
              The problem of the above function is that the resulting list does not contain the last element of the source stream. To fix this we can use two other handy new functions of the interactive extensions, namely the <strong>Concat</strong> and the <strong>TakeLast</strong> function.
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> var list2 = list.Concate(cageHistoryList.TakeLast(1))</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    Please not that the <strong>TakeLast</strong> function is very different from the well known <strong>Last</strong> function in that it remains in the monad and returns part of the tail of the source stream whereas Last() exits the monad and returns a single element (the last one).
                  </p>
                  
                  <p>
                    Now if we have more than one cage then the end date of the last record of each cage has to be equal to the end date of the billing period. We can easily adjust our expression to handle this
                  </p>
                  
                  <div>
                    <div>
                      <pre><span style="color: #606060">   1:</span> var cageHistoryList.Last().EndDate = billingIntervalEndDate;</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   2:</span>&#160; </pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   3:</span> var list = cageHistoryList.Zip(cageHistoryList.Skip(1), (h1, h2) =&gt; <span style="color: #0000ff">new</span> {H1 = h1, H2 = h2})</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   4:</span>     .Do(pair =&gt; pair.H1.EndDate = pair.H1.CageId != pair.H2.CageId ? billingIntervalEndDate : pair.H2.StartDate)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   5:</span>     .Select(pair =&gt; pair.H1)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   6:</span>     .Concat(cageHistoryList.TakeLast(1))</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   7:</span>     .Do(x =&gt; x.NumberOfDays = (x.EndDate - x.StartDate).Days;</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          Also note that I have added another Do function at the end of the expression to calculate the number of days in the interval. Of course we could also filter, sort or group the resulting stream…
                        </p>