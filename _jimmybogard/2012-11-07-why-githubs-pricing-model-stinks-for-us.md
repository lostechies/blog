---
wordpress_id: 689
title: Why GitHub’s pricing model stinks (for us)
date: 2012-11-07T23:22:25+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=689
dsq_thread_id:
  - "918089185"
categories:
  - git
---
I love GitHub. I use it for websites, I use it for OSS, I use it for a dump of blog post code. I love the website, I love the tools, I love the apps. I love that it’s in the cloud and I can get to it from anywhere with an internet connection.

However, the pricing model stinks for us at [Headspring](http://www.headspring.com/).

GitHub [prices plans](https://github.com/plans) based on where it considers the value to be: private repositories. Paid plans have unlimited collaborators and unlimited public repositories. The plan you pick defines how many private repositories you have. Additionally, business plans let you define unlimited teams (but still are priced based on number of private repositories:

<table width="400" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <th valign="top" width="133">
      Plan
    </th>
    
    <th valign="top" width="133">
      Private Repositories
    </th>
    
    <th valign="top" width="133">
      Price
    </th>
  </tr>
  
  <tr>
    <td valign="top" width="133">
      Micro
    </td>
    
    <td valign="top" width="133">
      5
    </td>
    
    <td valign="top" width="133">
      $7/mo
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="133">
      Small
    </td>
    
    <td valign="top" width="133">
      10
    </td>
    
    <td valign="top" width="133">
      $12/mo
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="133">
      Medium
    </td>
    
    <td valign="top" width="133">
      20
    </td>
    
    <td valign="top" width="133">
      $22/mo
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="133">
      Bronze (Business)
    </td>
    
    <td valign="top" width="133">
      10
    </td>
    
    <td valign="top" width="133">
      $25/mo
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="133">
      Silver
    </td>
    
    <td valign="top" width="133">
      20
    </td>
    
    <td valign="top" width="133">
      $50/mo
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="133">
      Gold
    </td>
    
    <td valign="top" width="133">
      50
    </td>
    
    <td valign="top" width="133">
      $100/mo
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="133">
      Platinum
    </td>
    
    <td valign="top" width="133">
      125
    </td>
    
    <td valign="top" width="133">
      $200/mo
    </td>
  </tr>
</table>

All very reasonable prices, but unfortunately, just don’t make sense for us at Headspring. As much as I like pull requests and GitHub issues, pricing based on what is for us a very unpredictable measure (# of private repositories) completely prevents us from considering GitHub. Since we’re a consulting company, on many projects, it’s difficult to track and predict how many private repositories we have going at any given time.

Repositories aren’t our asset, our people are. We can easily predict how many employees we have, so we’d much, much rather just pay by the user. It’s the pricing model of many of our other cloud services (but not all).

Bitbucket, on the other hand, gives us 100% predictable pricing, [based on users](https://bitbucket.org/plans):

<table width="362" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <th valign="top" width="199">
      Users
    </th>
    
    <th valign="top" width="161">
      Price
    </th>
  </tr>
  
  <tr>
    <td valign="top" width="220">
      5
    </td>
    
    <td valign="top" width="169">
      Free
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="225">
      10
    </td>
    
    <td valign="top" width="172">
      $10/mo
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="225">
      25
    </td>
    
    <td valign="top" width="174">
      $25/mo
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="224">
      50
    </td>
    
    <td valign="top" width="175">
      $50/mo
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="224">
      100
    </td>
    
    <td valign="top" width="175">
      $100/mo
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="224">
      Unlimited
    </td>
    
    <td valign="top" width="175">
      $200/mo
    </td>
  </tr>
</table>

We get unlimited private repositories for this plan, and a very predictable monthly cost. We did a quick price comparison, but it’s really hard to compare apples to oranges here when we really can’t know how many users we have.

I see this in quite a few SaaS providers, having a rigid pricing model on only one axis. Often it’s the pricing model, and not the overall price, that dictates what services we can use. Having a flexible pricing model would allow GitHub (and other companies with similar models) to reach a broader set of companies that simply predict costs on a different measure.

I understand that a lot of teams have more predictability on repositories (and not people), and GitHub makes more sense for them. However, I don’t ever really want the decision on whether or not to create a GitHub repository (or BaseCamp project for that matter) to come down to “are we at our limit?”. I see people sitting around, and they’re easy to count.

So while we can’t use GitHub right now, I’d love to in the future if their pricing model ever matched how we can truly predict costs.