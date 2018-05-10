---
wordpress_id: 836
title: 'Put your controllers on a diet: defactoring'
date: 2013-10-22T15:42:12+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=836
dsq_thread_id:
  - "1887243867"
categories:
  - ASPNETMVC
---
Posts in this series:

  * [Redux](https://lostechies.com/jimmybogard/2013/10/10/put-your-controllers-on-a-diet-redux/)
  * Defactoring

Before getting to far in refactoring my controller, I want to spend a little bit of time doing some [defactoring](http://c2.com/cgi/wiki?HowToDefactor), removing abstractions and such until I can see the entire amount of non-framework code in one spot. Defactoring is often an important first step in refactoring; you really need a big picture view of your code so that you don’t get sucked in to abstraction-itis.

First up is getting rid of data access abstractions. Since I’m using mostly NHibernate directly and not abstractions there, it shouldn’t be too bad. I have three main interfaces, first representing a transactional boundary:

{% gist 7101620 %}

Not horrible, but the implementation is…strange. But there’s not really a big reason to have this abstraction. Transaction management should be taken care of through infrastructure, and not in your application layer. Transactions should be ambient, not imperatively managed in my controller. On top of that, NHibernate already includes transaction management and unit of work representation, through the ISession interface. Basically all we have above is an ISession wrapper with wonky internal semantics (I wrote the code, so I’m really talking to myself).

Next, we have ISessionSource:

{% gist 7101675 %}

To be perfectly honest, I don’t remember what I was thinking here. Dependency injection should take care of getting an ISession supplied to us. In the above interface, I don’t know if that method creates a new ISession or re-uses an existing one. Altogether, not a good spot to be in when you have to look at an implementation of an interface to understand behavior. Strike two.

Finally, we have our repository interface:

{% gist 7101728 %}

Again, not much value to this interface as an encapsulation. I still expose NHibernate out through the Query method (absolutely required if I want to do fetching etc.), and for some cases, I can’t even use this abstraction. NHibernate already provides an abstraction through ISession, so let’s just get rid of all these abstractions.

Ideally, I’d just depend directly in ISession in my controller and use it without any abstractions before we go down the road of refactoring. Removing these layers is like excavating down to the bedrock before laying foundation for a building. I need to strip away the muck and mud to get at the base. I can modify my StructureMap registration code to allow me to depend directly on ISession and encapsulate lifecycle management inside the container:

{% gist 7101788 %}

Now we don’t have to worry about error-prone lifecycle management code, locks and such. All that code can go away. Aren’t containers nice?

Let’s go back to our controller to see how this changed it:

{% gist 7102870 %}

From here, we have a much better target to start refactoring.

At this point, however, you might ask yourself “is there anything to refactor here”? Looking at this isolated controller, no. All behavior is neatly encapsulated inside this one class. However, if I have a dozen or two dozen controllers that look awfully similar, and we start to see cross-cutting concerns pop up, then we’ll look at refactoring (but not before).

In the next installment, we’ll look first at those immediately obvious cross cutting concerns, validation and transaction management.