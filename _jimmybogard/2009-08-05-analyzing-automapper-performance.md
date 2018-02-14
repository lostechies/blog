---
wordpress_id: 341
title: Analyzing AutoMapper performance
date: 2009-08-05T00:07:16+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/08/04/analyzing-automapper-performance.aspx
dsq_thread_id:
  - "264716278"
categories:
  - AutoMapper
redirect_from: "/blogs/jimmy_bogard/archive/2009/08/04/analyzing-automapper-performance.aspx/"
---
One of the last things I wanted to look at [AutoMapper](http://automapper.codeplex.com/) before pushing it out to production was to get some idea of how it performed.&#160; One of the more difficult things in doing this is trying to come up with a good idea of what exactly I should measure.&#160; Especially with performance numbers, measuring them will lead you to improve them, so it’s important that what you measure is representative of how it will actually be used.

The other tough thing in looking at performance was trying to figure out what a good number is.&#160; Cost to improve performance (where cost is basically a lazy Sunday for me) increases exponentially as I improve a measurement.&#160; It might be trivial to increase a metric by 75%, but it might take four times as long to increase it another 75%.&#160; And at that point, I may only be able to squeeze another 10% improvement, which only represents an additional 0.625% improvement on the original time.&#160; So at some point, I’ll probably stop caring.&#160; But until then, I can still find some easy bottlenecks to improve.

### Setting up the profiling

Going in, I _knew_ that reflection wasn’t the bottleneck.&#160; Before I started looking at performance (around the 0.3.0 release), all mapping was done via old-school reflection.&#160; Instead, I figured that I just needed some caching of decisions and whatnot.&#160; But before I could profile, I needed a decent scenario.&#160; For this, I looked at a reasonably complex flattening scenario, mapping these set of complex types:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">ModelObject
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">DateTime </span>BaseDate { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">ModelSubObject </span>Sub { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">ModelSubObject </span>Sub2 { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">ModelSubObject </span>SubWithExtraName { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}

<span style="color: blue">public class </span><span style="color: #2b91af">ModelSubObject
</span>{
    <span style="color: blue">public string </span>ProperName { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">ModelSubSubObject </span>SubSub { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}

<span style="color: blue">public class </span><span style="color: #2b91af">ModelSubSubObject
</span>{
    <span style="color: blue">public string </span>IAmACoolProperty { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

To this flattened out DTO type:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">ModelDto
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">DateTime </span>BaseDate { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>SubProperName { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>Sub2ProperName { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>SubWithExtraNameProperName { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>SubSubSubIAmACoolProperty { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

I’m not terribly interested in the initialization time at this point (though I will look at it, eventually), so I just put into a loop calling AutoMapper about 100K times.&#160; I fiddled with this number a bit until I found a number where I wouldn’t get bored waiting.&#160; The profiling code is rather boring, but it’s in the trunk if you’re interested.

### Initial results

Much like I assumed, the actual time spent doing reflection was a small, but sizable percentage of performing a mapping operation:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_2CBCF037.png" width="322" height="318" />](http://lostechies.com/content/jimmybogard/uploads/2011/03/image_4DB062DE.png) 

Much of the time is spent making the decision of how to do the mapping.&#160; Because AutoMapper works by mapping based on source/destination type pairs, it has to decide what to do based on each pair.&#160; It turns out that the auto-mapped functionality of AutoMapper is only one of about a dozen different mapping algorithms to choose based on a source/destination type pair.&#160; Things like arrays, lists, dictionaries, enumerations, etc. all have their own mapping algorithm.

To get the times down, all it really took was analyzing the calls and figuring out where results can be stored and not precalculated.

_Note: If I was halfway-decent with funtional programming, this could be a memoized function.&#160; But, I digest._

The reflection part is still bad, as I see it, but still not too shabby.&#160; But, it can be improved.

### Tracking the improvements

The initial review of performance was about 40 something commits ago, so I wanted to get an idea of how performance has changed over time.&#160; The results are quite interesting:

<table border="1" cellspacing="0" cellpadding="2" width="200">
  <tr>
    <td valign="top" width="100">
      Revision
    </td>
    
    <td valign="top" width="100">
      Time (ms)
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="100">
      70
    </td>
    
    <td valign="top" width="100">
      30951
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="100">
      75
    </td>
    
    <td valign="top" width="100">
      11138
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="100">
      80
    </td>
    
    <td valign="top" width="100">
      7901
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="100">
      85
    </td>
    
    <td valign="top" width="100">
      7833
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="100">
      90
    </td>
    
    <td valign="top" width="100">
      7934
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="100">
      95
    </td>
    
    <td valign="top" width="100">
      8060
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="100">
      100
    </td>
    
    <td valign="top" width="100">
      9412
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="100">
      105
    </td>
    
    <td valign="top" width="100">
      9965
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="100">
      110
    </td>
    
    <td valign="top" width="100">
      10088
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="100">
      113
    </td>
    
    <td valign="top" width="100">
      8214
    </td>
  </tr>
</table>

So time dropped precipitously after 10 revisions of tweaking and caching, and steadily increased as I added other features (and other non-cached decisions).&#160; Then recently, I pushed the time back down again.&#160; So what went into these fixes?

  * Caching decisions in dictionaries, usually based around types.&#160; Decisions, once made for a type, do not change for the most part
  * Switching to compiled expression trees for reading values, instead of reflection
  * Switching to IL generation through DynamicMethod for writing values, instead of reflection

At this point, actually reading and writing information is a tiny fraction of what AutoMapper needs to do:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/03/image_thumb_11A42129.png" width="427" height="340" />](http://lostechies.com/content/jimmybogard/uploads/2011/03/image_0BC97D90.png) 

Only about 2.6% of the mapping operation is actually performing the mapping, by ditching reflection.&#160; So not only has the entire mapping operation gotten faster, the reflection code is down to a point where it’s nowhere near the bottleneck.

### Final numbers

Before making any enhancements, the benchmark I used compared hand-rolled mapping with AutoMapper.&#160; Before, AutoMapper took around 15 seconds what hand-rolled mappings take in about 15 milliseconds.&#160; That’s a rather large difference, three orders of magnitude difference.&#160; After enhancements, mapping is around 2 seconds, or almost an order of magnitude improvement.

Now, these numbers by themselves aren’t nearly as interesting as putting them in a real application.&#160; When I profiled our application under load, it was of course the database being the bottleneck.&#160; Focusing solely on AutoMapper to improve performance is local optimization, it’s not the bottleneck in our typical application usage.