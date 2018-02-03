---
wordpress_id: 3354
title: Anti-Patterns and Worst Practices – Monster Objects
date: 2009-05-28T23:28:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2009/05/28/anti-patterns-and-worst-practices-monster-objects.aspx
dsq_thread_id:
  - "262069316"
categories:
  - Design Patterns
  - Design Principles
  - SOLID
  - Testing
---
[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;margin-left: 0px;margin-right: 0px;border-right-width: 0px" alt="monster" src="//lostechies.com/chrismissal/files/2011/03/monster_thumb_571B6822.jpg" width="240" align="right" border="0" height="214" />](//lostechies.com/chrismissal/files/2011/03/monster_275DBFA3.jpg) Monster objects (or <a href="http://en.wikipedia.org/wiki/God_object" target="_blank">God objects</a>) know too much, or do too much; monster objects are nasty beasts. The term God object was coined because these objects are said to be &ldquo;all-knowing&rdquo;. I&rsquo;m in favor of the term Monster objects because knowing something isn&rsquo;t a bad thing. These objects are usually bad things and Monsters are both big and bad, I find that more fitting. There are several problems with this anti-pattern. The two problems I most often see are testability problems and violating the Law(<a href="http://www.martinfowler.com/articles/mocksArentStubs.html#DesignStyle" target="_blank">Suggestion</a>) of Demeter.

### Defensive Coding

I try to do my best when adding new functionality to avoid creating a monster object by continually asking myself if this new code is going to add an &ldquo;and&rdquo; to this class. If you&rsquo;re tacking on code that makes the class do this &ldquo;and&rdquo; that, you&rsquo;re probably adding it in the wrong spot. If this continues, you&rsquo;re headed in the wrong direction. This is the primary tenet of the Single Responsibility Principle.

### Violating Law of Demeter

### 

You know you&rsquo;re dealing with one of these when you find yourself burrowing down the member/function chain like the following:

> <pre>orderItem.Product.Pricing.MembershipPrice</pre>

[](http://11011.net/software/vspaste)

Likely your tests include creating a lot of setup code: 

> <pre><span style="color: blue">var </span>price = <span style="color: blue">new </span><span style="color: #2b91af">Money</span>(35m);<br /><span style="color: blue">var </span>pricing = <span style="color: blue">new </span><span style="color: #2b91af">Pricing</span>() { MembershipPrice = price };<br /><span style="color: blue">var </span>product = <span style="color: blue">new </span><span style="color: #2b91af">Product</span>() { Pricing = pricing };<br /><span style="color: blue">var </span>orderItem = <span style="color: blue">new </span><span style="color: #2b91af">OrderItem</span>(product);</pre>

[](http://11011.net/software/vspaste)

Instead, you probably want to break this apart if possible. There&rsquo;s no benefit in having the OrderItem ask the Product to have its Pricing&hellip; you get the point.

For this example, you could likely remove the Pricing class entirely by incorporating some patterns here. The <a href="http://www.dimecasts.net/Casts/CastDetails/98" target="_blank">strategy pattern</a> is a good one to follow when you need to run some calculations given a specific set of criteria.

> <pre><span style="color: blue">var </span>calculatedPrice = orderItem.CalculatePrice(<span style="color: blue">new </span><span style="color: #2b91af">MembershipPricingStrategy</span>()); </pre>

[](http://11011.net/software/vspaste)

### Dealing With Monsters

A good way to deal with monster objects is to not deal with them. If you&rsquo;re stuck with one for a while, abstract out what need from it and use the abstraction. Wrap this functionality in some code that you own (or are more free to modify) like <a href="/blogs/colin_ramsay/default.aspx" target="_blank">Colin</a> does in <a href="/blogs/colin_ramsay/archive/2009/05/05/breaking-free-from-httpcontext.aspx" target="_blank">Breaking Free from HttpContext</a>.

### Monster Objects in the Wild

Lately, whenever I think of this anti-pattern, ASP.Net MVC&rsquo;s HttpContextBase comes to mind. What other objects have you encountered that are &ldquo;monsters&rdquo;?

[See more <a href="/blogs/chrismissal/archive/2009/05/25/anti-patterns-and-worst-practices-you-re-doing-it-wrong.aspx" target="_self">Anti-Patterns and Worst Practices</a>]