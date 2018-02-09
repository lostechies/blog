---
wordpress_id: 271
title: Enabling success with opinionated architecture
date: 2009-01-11T20:18:05+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/01/11/enabling-success-with-opinionated-architecture.aspx
dsq_thread_id:
  - "264716039"
categories:
  - Design
redirect_from: "/blogs/jimmy_bogard/archive/2009/01/11/enabling-success-with-opinionated-architecture.aspx/"
---
One of my pet peeve questions I often see on various tech mailing lists is “How can I prevent situation XYZ”.&#160; In one recent case, it was “How can I prevent UI calls to mutable methods in the domain?”&#160; The specific situation is one where I have two methods, with the same name, but in different layers:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Order
</span>{
    <span style="color: blue">public void </span>AddOrderItem(<span style="color: #2b91af">Product </span>product, <span style="color: blue">int </span>quantity)
    {
        <span style="color: green">// Whatever
    </span>}
}

<span style="color: blue">public class </span><span style="color: #2b91af">OrderService
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IOrderRepository </span>_orderRepository;

    <span style="color: blue">public </span>OrderService(<span style="color: #2b91af">IOrderRepository </span>orderRepository)
    {
        _orderRepository = orderRepository;
    }

    [<span style="color: #2b91af">Transaction</span>]
    <span style="color: blue">public void </span>AddOrderItem(<span style="color: #2b91af">Order </span>order, <span style="color: #2b91af">Product </span>product, <span style="color: blue">int </span>quantity)
    {
        order.AddOrderItem(product, quantity);
        _orderRepository.Save(order);
    }
}</pre>

[](http://11011.net/software/vspaste)

Now, if what we’re concerned about at this point is preventing _developers_ from calling the “wrong” method, we’ve already lost.&#160; If the method is available for us to call, it’s quite confusing, no matter who the developer is, on which method is the right one to call.

But why are there two methods available to us in the first place?

Instead of a tacit agreement in the development team on what method to call where, why don’t we just design our software so that when we’re developing, we fall into the [pit of success](http://blogs.msdn.com/brada/archive/2003/10/02/50420.aspx)?&#160; When we’re designing or harvesting an architecture for our system, we’d like to ensure that not only do we have powerful seams for the ways our application deals with complexity, but our design is straightforward in dealing with everyday scenarios.

To do so, it’s paramount that your system’s architecture has strong opinions on the design of the system.&#160; Strong opinions puts the design and development of the system on a set of greased rails, making it easy to travel in the direction you’ve designed it to travel.&#160; If it’s difficult for the developer to travel in a different direction, either they’re going in the wrong direction or they’re on the wrong train.

### Crafting and enforcing strong opinions

Instead of trying to enforce an opinion after the fact, we can design our architecture so you can’t get yourself into that situation in the first place.&#160; **The best prevention for a bad design is a good design**.&#160; It’s far too difficult and costly to try and clean up after months of bad design and try to enforce an opinion on a system that will fight it kicking and screaming.

Of course, we often can’t understand what opinions we want before we start developing.&#160; Group and parallel design are key to narrowing down ideas, but one of the best ways to craft an opinionated design is through harvesting.&#160; Instead of a Big Design Up Front (not to be confused with Just Enough Design Up Front), we’ll let the software tell us what the right direction is.&#160; We wait until the [Last Responsible Moment](http://www.codinghorror.com/blog/archives/000705.html), where waiting any longer to make a decision would eliminate potential options because of the cost to retrofit.

[FubuMVC](http://fubumvc.pbwiki.com/) is one great example of enforcing strong opinions.&#160; In FubuMVC, it’s impossible to have anything but One View, One Model.&#160; That’s the pit of success, where the designers recognized the benefits of having just one model and not a dictionary of values.&#160; There are benefits to having the dictionary as well, but enforcing this opinion allowed more design optimizations around that direction.

Frameworks aren’t designed to enforce opinions.&#160; Frameworks allow us to craft opinions, so let’s not assume the designers of a framework know how best to develop _your_ system.

Going back to the first example, we don’t want developers calling the Domain methods in the Application layer.&#160; A straight-forward solution there is to not expose the domain to the application layer.&#160; Domain models get exposed to the application layer through projections or DTOs, and domain models get modified from the application layer through messages and services.&#160; With that opinion enforced, it’s not even _possible_ to call the “wrong” method.

If you want a certain design enforced in your system, the most efficient way to do so is to craft your design with strong opinions such that the only direction available is the direction you intended.&#160; Not only do you enforce your design, but you can make optimizations such that traveling on those rails in that direction is as easy and fast as possible.