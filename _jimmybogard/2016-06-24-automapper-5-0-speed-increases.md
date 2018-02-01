---
id: 1215
title: AutoMapper 5.0 speed increases
date: 2016-06-24T21:43:50+00:00
author: Jimmy Bogard
layout: post
guid: https://lostechies.com/jimmybogard/?p=1215
dsq_thread_id:
  - "4936594862"
categories:
  - AutoMapper
---
Just an update on the work we’ve been doing to speed up AutoMapper. I’ve captured times to map some common scenarios (1M mappings). Time is in seconds:

<table cellspacing="0" cellpadding="2" width="400" border="0">
  <tr>
    <td valign="top" width="80">
      &nbsp;
    </td>
    
    <td valign="top" width="80">
      Flattening
    </td>
    
    <td valign="top" width="80">
      Ctor
    </td>
    
    <td valign="top" width="80">
      Complex
    </td>
    
    <td valign="top" width="80">
      Deep
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="80">
      Native
    </td>
    
    <td valign="top" width="80">
      0.0148
    </td>
    
    <td valign="top" width="80">
      0.0060
    </td>
    
    <td valign="top" width="80">
      0.9615
    </td>
    
    <td valign="top" width="80">
      0.2070
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="80">
      5.0
    </td>
    
    <td valign="top" width="80">
      0.2203
    </td>
    
    <td valign="top" width="80">
      0.1791
    </td>
    
    <td valign="top" width="80">
      2.5272
    </td>
    
    <td valign="top" width="80">
      1.4054
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="80">
      4.2.1
    </td>
    
    <td valign="top" width="80">
      4.3989
    </td>
    
    <td valign="top" width="80">
      1.5608
    </td>
    
    <td valign="top" width="80">
      134.39
    </td>
    
    <td valign="top" width="80">
      29.023
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="80">
      3.3.1
    </td>
    
    <td valign="top" width="80">
      4.7785
    </td>
    
    <td valign="top" width="80">
      1.3384
    </td>
    
    <td valign="top" width="80">
      72.812
    </td>
    
    <td valign="top" width="80">
      34.485
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="80">
      2.2.1
    </td>
    
    <td valign="top" width="80">
      5.1175
    </td>
    
    <td valign="top" width="80">
      1.7855
    </td>
    
    <td valign="top" width="80">
      122.0081
    </td>
    
    <td valign="top" width="80">
      35.863
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="80">
      1.1.0.118
    </td>
    
    <td valign="top" width="80">
      6.7143
    </td>
    
    <td valign="top" width="80">
      n/a
    </td>
    
    <td valign="top" width="80">
      29.222
    </td>
    
    <td valign="top" width="80">
      38.852
    </td>
  </tr>
</table>

The complex mappings had the biggest variation, but across the board AutoMapper is \*much\* faster than previous versions. Sometimes 20x faster, 50x in others. It’s been a ton of work to get here, mainly from the change in having a single configuration step that let us build execution plans that exactly target your configuration. We now build up an expression tree for the mapping plan based on the configuration, instead of evaluating the same rules over and over again.

We \*could\* get marginally faster than this, but that would require us sacrificing diagnostic information or not handling nulls etc. Still, not too shabby, and in the same ballpark as the other mappers (faster than some, marginally slower than others) out there. With this release, I think we can officially stop labeling AutoMapper as “slow” 😉

Look for the 5.0 release to drop with the release of .NET Core next week!