---
wordpress_id: 749
title: Composition Of Responsibility vs Interface Implementation
date: 2012-01-03T09:23:01+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=749
dsq_thread_id:
  - "525208939"
categories:
  - .NET
  - 'C#'
  - Mongoid
  - Philosophy of Software
  - Principles and Patterns
  - Rails
  - Ruby
---
This started out a comment in a Google+ stream, which is in response to the brujahahahahalols that have been going around concerning [ActiveRecord](http://blog.steveklabnik.com/posts/2011-12-30-active-record-considered-harmful), [FubuMVC](http://lostechies.com/chadmyers/2011/12/30/sweet-sweet-vindication/) and [Rails](http://wekeroad.com/2012/01/03/rails-has-turned-me-into-a-cannibalizing-idiot/). I&#8217;m not defending any of these posts or perspectives. I have my own opinions on the problems and benefits of the various things mentioned… but I wanted to specifically talk about something that Chad mentions: bloated object interfaces, or too many methods on an object.

It seems to me that claims of object bloat and Separation of Concerns (SoC) / Single Responsibility Principle (SRP) violations for languages like Ruby are often based on the idea of interface-based method dispatch&#8230; the idea that an object must implement an interface in order to have the method available. Now I&#8217;m not saying that all claims of these violations are from this perspective, by any means. I don&#8217;t know if this was Chad&#8217;s perspective or not. I can only assume based on how he worded things. And obviously there are some horrible chunks of code out there, in any language, with any type system or method dispatch system, that really do violate these principles.

Still… I wonder how much of the bloat or perception of bloat is based on the wrong perspective&#8230;

## SoC/SRP: 354 Methods On An Object!

ActiveRecord might truly be a horrible beast with far too many concerns in one given place. I haven&#8217;t dug into that source code very much. From what I remember of it, it&#8217;s huge and difficult for me to understand (but then, it does a metric-ton-squared of meta-programming, so I guess I&#8217;m not surprised that it&#8217;s hard for me to understand).

I have dug deep in to Mongoid, though (a MongoDB ODM for ruby), which sits on top of various pieces of ActiveRecord. I&#8217;ve submitted a handful of patches for Mongoid and have spent a fair amount of time studying it to learn how it works. On the surface, it also looks like a ton of bloat and SoC/SRP violations. Run &#8220;puts my_model.methods.sort&#8221;, and you&#8217;ll see 354 methods&#8230; it makes you wonder&#8230;

{% gist 1555221 mongoid.sh %}

But when I look at the source for Mongoid, it&#8217;s one of the most beautiful sets of code that i&#8217;ve seen in Ruby. From my perspective, it has a very clean separation of concerns and follows many other good OO principles to the core (at least until it has to interact w/ activerecord).

The interface bloat that we see on an object like the one above comes as a result of a few different things: Ruby base objects, and applying the many different Mongoid mixins to a Ruby model, via \`include Mongoid::Document\`.

## Perspective: Interface-based vs Message-based

The problem might not be ActiveRecord, or Mongoid, or any other &#8220;bloated framework that violates …&#8221; and how the objects that use these frameworks look when we list the interface of a model. The problem might really be that we are listing the interface to the model as if it were the truth of this object&#8217;s implementation. The problem might just be our perspective.

Does the object above really implement all of these methods? Or has it been composed from many different mixins, with many different hats to wear in different scenarios (Udi Dahan&#8217;s &#8220;role specific interfaces&#8221;, or dependency inversion in general)?

## Watch Where You&#8217;re Pointing That Perspective!

If we look at a message-based method dispatch in the same light and perspective as we do a interface-based dispatch, things look bad. If we look at the message-based, first-class-mixin system as a series of responsibilities, though, with each responsibility having it&#8217;s own protocol definition and each responsibility and protocol captured into an object that can be composed into a larger piece (again, mixins), things look much better.

Yes, my &#8220;Foo&#8221; object in the above example still has 354 methods on it. But how many of these do you really care about for a given scenario? What role do you expect this object to play, when? Ruby, Rails, ActiveRecord, Mongoid… Python, JavaScript, and the rest of the dynamic ecosystem give us a lot of power and flexbility. (Insert abused &#8220;Uncle Ben&#8221; quote from Spiderman… with great power come blah blah blah blah&#8230;)
