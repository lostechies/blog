---
id: 16
title: Proper string comparison
date: 2007-05-11T13:42:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/05/11/proper-string-comparison.aspx
dsq_thread_id:
  - "267828237"
categories:
  - 'C#'
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/proper-string-comparison.html)._

It seems developers have a knack for collecting technical books.&nbsp; I have a system where books are available to me relative to their importance.&nbsp; Books I crack once every few months stay at home.&nbsp; If I start needing the book more than once a month, it goes on my bookshelf in my desk.&nbsp; There are a few books I need on almost a daily basis, and these books stay within arms reach.&nbsp; The two books I&#8217;ve always kept close to me are [Framework Design Guidelines](http://www.amazon.com/Framework-Design-Guidelines-Conventions-Development/dp/0321246756/)&nbsp;and [CLR via C#](http://www.amazon.com/CLR-via-Second-Pro-Developer/dp/0735621632/ref=pd_bbs_sr_1/002-0878740-0508014?ie=UTF8&s=books&qid=1178892880&sr=1-1).&nbsp; I would almost consider these books required reading for a .NET team, though the latter can be fairly low-level at times.&nbsp; One such situation I&#8217;ve needed these books close at hand is when I&#8217;m doing string comparisons.

### An exciting bug

I was looking at a defect that came down to data not being saved into the database properly.&nbsp; All of the&nbsp;fields in a record&nbsp;had a value, but one important field&nbsp;was conspicuously blank.&nbsp; A colleague hunted down the persistence code and noticed the following line (scrubbed somewhat):

<div class="CodeFormatContainer">
  <pre><span class="kwrd">if</span> (address.Other1.Type.Equals(<span class="str">"taxcode"</span>))<br />
&nbsp;&nbsp;&nbsp;&nbsp;AddInputParam(sqlCmd, <span class="str">"@tax_code"</span>, SqlDbType.Char, address.Other1.Value);<br />
<span class="kwrd">else</span><br />
&nbsp;&nbsp;&nbsp;&nbsp;AddInputParam(sqlCmd, <span class="str">"@tax_code"</span>, SqlDbType.Char, String.Empty);<br />
</pre>
</div>

This code seems innocuous.&nbsp; If the address&#8217;s Other1 property&#8217;s Type equals &#8220;taxcode&#8221;, then set the &#8220;@tax\_code&#8221; parameter to its value, otherwise set the &#8220;@tax\_code&#8221; parameter value to an empty string.&nbsp; This stored procedure requires a &#8220;@tax_code&#8221; parameter, but the address may or may not have a &#8220;taxcode&#8221; value.&nbsp; All very straightforward, and fairly explicit.

### Capital letters are fun

Oh snap.&nbsp; It looks like the value of &#8220;address.Other1.Type&#8221; isn&#8217;t &#8220;taxcode&#8221;, but rather &#8220;TAXCODE&#8221;.&nbsp; For this snippet of code, the intent was to ignore the case of the Type, but by default, string.Equals will do a character by character comparison in a **case-sensitive** fashion to determine equality.&nbsp; Since chars are 16-bit Unicode values, internally the char.Equals will just compare the 16-bit values of two characters to determine equality.&nbsp; So we need a good way to determine equality while taking into account case-sensitivity (hint: address.Other1.Type.ToUpper().Equals(&#8220;TAXCODE&#8221;) is NOT the right answer).

So how should we compare strings then?&nbsp; This is where the [CLR via C#](http://www.amazon.com/CLR-via-Second-Pro-Developer/dp/0735621632/ref=pd_bbs_sr_1/002-0878740-0508014?ie=UTF8&s=books&qid=1178892880&sr=1-1) book&nbsp;comes in extra-handy.&nbsp; The answer depends on the context of comparison you want to do.&nbsp; There are three types of comparisons we can perform on a string:

  * Current culture 
      * Invariant culture 
          * Ordinal</ul> 
        Additionally, each comparison type has a case-insensitive option available.
        
        ### So what should I have used instead?
        
        By far most string comparisons should use the Ordinal comparison types.&nbsp; Ordinal comparisons use the UTF-16 value of the string, character by character, while oridinal case-insensitive comparisons use invariant culture rules.&nbsp; Ordinal comparisons are also much faster than culture-aware comparisons.&nbsp; By default, string comparisons use the CultureInfo.CurrentCulture settings, which can change during the course of execution, unknown to the code performing the string comparison.&nbsp; That&#8217;s why we don&#8217;t want to ever use ToUpper() when we&#8217;re not dealing with user input, since&nbsp;the underlying culture can&nbsp;change without us knowing.&nbsp; Comparisons that were equal when executed in the US are now not in France.&nbsp; This can cause major headaches when dealing with global code.&nbsp; Ordinal comparisons are good for use in:
        
          * Path and file names 
              * Database object names (database, table, field, etc.) 
                  * XML tags and attribute names 
                      * Local constants, identifiers and &#8220;magic values&#8221;</ul> 
                    Notice that the defect was an example of the last entry.&nbsp; Since I wanted a case-sensitive comparison, I would have used StringComparison.OrdinalIgnoreCase.&nbsp; For simplicity and ease-of-use, the .NET Framework has static and member overloads of the following methods that will take the StringComparison enumeration:
                    
                      * Equals 
                          * Compare 
                              * StartsWith 
                                  * EndsWith</ul> 
                                So to fix the defect, I would have changed the code snippet to:
                                
                                <div class="CodeFormatContainer">
                                  <pre><span class="kwrd">if</span> (address.Other1.Type.Equals(<span class="str">"taxcode"</span>, StringComparison.OrdinalIgnoreCase))<br />
&nbsp;&nbsp;&nbsp;&nbsp;AddInputParam(sqlCmd, <span class="str">"@tax_code"</span>, SqlDbType.Char, address.Other1.Value);<br />
<span class="kwrd">else</span><br />
&nbsp;&nbsp;&nbsp;&nbsp;AddInputParam(sqlCmd, <span class="str">"@tax_code"</span>, SqlDbType.Char, String.Empty);<br />
</pre>
                                </div>
                                
                                ### So how do I compare strings in the future?
                                
                                When I&#8217;m performing string comparisons, I really only need to ask myself two questions:
                                
                                  * Where did each string come from?&nbsp; (Hard-coded value, user input, etc.) 
                                      * Do I care about the case?</ul> 
                                    The answer of each of the questions will point me to the correct StringComparison value.&nbsp; Just to be explicit, I _never_ use the default methods for ToUpper, Equals, etc.&nbsp; When you leave out the StringComparison or other culture information, you&#8217;re more likely to introduce bugs simply because you haven&#8217;t been explicit about what kind of comparison you&#8217;d like to do, regardless whether the default implementation does what you&#8217;d want it to do.&nbsp; If you&#8217;re explicit, the next developer to look at that code will understand immediately what the intention of the comparison was instead of trying to figure out what kind of comparison it _should_ have been.
                                    
                                    ### For further information
                                    
                                      * Consult [CLR via C#](http://www.amazon.com/CLR-via-Second-Pro-Developer/dp/0735621632/ref=pd_bbs_sr_1/002-0878740-0508014?ie=UTF8&s=books&qid=1178892880&sr=1-1) 
                                          * [Encoding and Localization](http://msdn2.microsoft.com/en-us/library/h6270d0z.aspx) on MSDN 
                                              * [StringComparison](http://msdn2.microsoft.com/en-us/library/system.stringcomparison.aspx) documentation 
                                                  * [String](http://msdn2.microsoft.com/en-us/library/system.string.aspx) documentation</ul>