---
wordpress_id: 71
title: Daily routine with continuous integration
date: 2007-10-03T17:47:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/10/03/daily-routine-with-continuous-integration.aspx
dsq_thread_id:
  - "836888911"
categories:
  - Agile
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/10/daily-routine-with-continuous.html)._

I chuckled quite a bit after reading the [Top 5 Signs of Discontinuous Integration](http://notdennisbyrne.blogspot.com/2007/09/top-5-signs-of-discontinuous.html), though I think &#8220;dysfunctional integration&#8221; is a better word.&nbsp; So what&#8217;s my routine?

#### Start of the day

  1. Check if build is green 
      * Get latest if it is 
          * Fix build if it isn&#8217;t</ol> 
        #### Coding
        
          1. Code/write tests 
              * Run local build, make sure code compiles and&nbsp;tests pass 
                  * Get latest 
                      * Run local build again 
                          * Check in, with decent comments 
                              * Wait for CI build to finish 
                                  * If build is red, drop everything and fix 
                                      * Otherwise, go back to step 1</ol> 
                                    I&#8217;ll get latest several times per day.&nbsp; The more often I integrate (the &#8220;continuous&#8221; part), the easier it is do so.&nbsp; If you&#8217;re scared to get latest version when the build is green, you probably have some dysfunctional integration issues.&nbsp; If you don&#8217;t know what &#8220;the build is green&#8221; means, well, that&#8217;s a whole other ball of wax.