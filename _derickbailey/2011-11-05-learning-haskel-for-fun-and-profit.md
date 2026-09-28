---
wordpress_id: 632
title: Learning Haskel For Fun (and profit?)
date: 2011-11-05T07:12:40+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=632
dsq_thread_id:
  - "462638123"
categories:
  - 'C#'
  - Haskell
  - Ruby
---
I found a little spare time recently, so I started learning Haskell via [LearnYouAHaskell.com](http://learnyouahaskell.com/). I&#8217;m learning it specifically because it&#8217;s completely foreign to me. I&#8217;ve never done any functional programming and I wanted to bend my mind around and see what I could learn from that paradigm. So I asked what I should learn on twitter, and that was the overwhelming recommendation.

It&#8217;s been fun so far. I&#8217;ve only completed the &#8220;starting out&#8221; section &#8211; the very section of writing code, but already there are several things that I can do in Haskel that are making me see other languages a little differently.

## List Comprehensions

They&#8217;re basically the same thing as &#8220;select&#8221; and &#8220;map&#8221; from Ruby or from Underscore.js in JavaScript. And yes, CoffeeScript supports them directly, too. But they are much more compact and supported directly by the Haskell language instead of as functions in a library or pre-compiler. There&#8217;s also more too them than just select/map, but I still don&#8217;t quite get it all.

Here&#8217;s a list comprehension in Haskell, [borrowed from LearnYouAHaskell](http://learnyouahaskell.com/starting-out#im-a-list-comprehension):

{% gist 1341478 1.hs %}

Here&#8217;s the same thing in Ruby:

{% gist 1341478 1.rb %}

(I know you can do list comprehensions in CoffeeScript, too, but I don&#8217;t know CoffeeScript yet.)

## Tuples

I never understood the point of tuples in .NET. But after [seeing them in Haskell](http://learnyouahaskell.com/starting-out#tuples), it is starting to make sense &#8211; at least in Haskell.

A tuple is an anonymous type, defined at runtime, where the tuple&#8217;s type is built from the types of the individual pieces: Tuple<T1, T2, T3>, as an example in .NET terms. The semantics of a Tuple are that it must be the same number of types in the tuple and the same types of each item in the tuple, to be considered equal from a type perspective.

This means that Tuple<int, string> is the same type as Tuple<int, string> in .NET, but is different from Tuple<string, int>. I think I can see some uses for this to provide anonymous types and equality checks amongst them, in .NET &#8211; however, it seems to make more sense to me in Haskell where I can assign a tuple at runtime, building up an object type that never existed before, as an anonymous type.

Here&#8217;s a tuple in Haskell:

{% gist 1341478 2.hs %}

And the same thing in .NET 4:

{% gist 1341478 2.cs %}

Both of these create a tuple of type <int, string> (and both of these are statically typed languages). I&#8217;m still not 100% sure I see the point of a tuple in .NET since we have Expando and Dynamic… but there must be a use case for a semantically equivalent, anonymous type in .NET, somewhere. I&#8217;ve not run into it, but I know other people use the Tuple type in .NET.

I&#8217;m also not sure I can show a tuple in Ruby or JavaScript. Anyone know how to do this, and keep the same semantics of type equality?

## Other Great Things, Too

Whether or not I ever use Haskel on a project (highly unlikely), the experience will at least help me see different pieces of the other languages I use, in a new light. If you haven&#8217;t done any functional programming, check it out. It&#8217;s a mind-bender for sure.

## But What Do People Build With Haskell?

No, really… what do people write with Haskell? Is it used in real systems? Where? What types of applications and systems? I&#8217;d love to know more about it&#8217;s real-world uses.
