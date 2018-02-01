---
id: 332
title: Re-learning The Meaning of ! in Ruby Methods
date: 2011-05-16T20:35:32+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=332
dsq_thread_id:
  - "305689161"
categories:
  - Community
  - Ruby
---
Hugo Bonacci has been [tweeting a lot about the Eloquent Ruby book](https://twitter.com/#!/hugoware/status/69971179498250240), so I decided to pick up a copy. In spite in my year or two of working with Ruby, I still feel like a n00b most of the time because I&#8217;m still stuck with a C# mentality most of the time. So, I decided to give this book a whirl and hope that I can finally cross the chasm of ruby idioms.

 

### My Misunderstanding Of ! Methods

Early in the book, Russ talks about some basic method naming conventions and idioms, including methods with a ! at the end of them. After reading what he has to say, I&#8217;ve realized that my understanding of these methods was slightly off.

I used to think that a method with a ! on it, for example \`Array#map!\`, meant that the method would modify the object that the method was called on. In the case of the map! method this is true. There&#8217;s a non-! version of the method that returns a new array with the changes made in it, but the ! version of map! does modify the array directly.

However, my understanding of the ! convention was not complete and it often left me questioning the use of the symbol in other methods on other objects. Things just didn&#8217;t quite match up to my understanding. For example, in Rails and ActiveModel, \`save!\` doesn&#8217;t necessarily change anything in the in-memory object. It saves changes to the underlying data store and throws exceptions if any validation or other errors have occurred. The non-! version does the same work, but instead of throwing exceptions, it stores messages in the .errors collection. This was very puzzling to me. Why would they use a ! method name for something that doesn&#8217;t always change the object?

 

### Adjusting My Understanding

Page 13 of the Eloquent Ruby book explains the ! convention in a manner that encapsulates my previous understanding and at the same time, expands what the convention covers so that methods like save! no longer seem odd to me. Here&#8217;s what Russ has to say:

> Ruby programmers reserve ! to adorn the names of methods that do something unexpected, or perhaps a bit dangerous.

Aha! That explains not only my understanding of the map! method but also the save! method.

In the case of map vs map!, the ! version is dangerous and/or has unexpected behavior and the non-! version is &#8220;safe&#8221;. The non-! version doesn&#8217;t modify anything in the original array. It creates a new array and returns it (this is a very common idiom in itself; do get data from parameters and return a new object with a modified version of the input). The ! version is dangerous because is overwrites the original array&#8217;s contents. This may also be considered &#8220;unexpected&#8221; behavior because it&#8217;s not the normal return-a-modified-copy behavior.

In the case of save vs save!, the ! version is unexpected behavior and/or dangerous because it will raise exceptions when validation fails. The non-! version, by contrast, won&#8217;t. It will only populate the .errors collection. Calling save! is potentially dangerous because it can crash an app due to throwing exceptions.

 

### Off To A Great Start

### <span style="font-weight: normal; font-size: medium;">I&#8217;m glad I made the investment in this book, if even for this one little nugget. I&#8217;m also optimistic about the rest of the book, too. If the rest of the book is as useful as the first chapter has been, then I&#8217;m sure I&#8217;ll be singing it&#8217;s praises and blogging more about what I&#8217;m learning, soon. </span>