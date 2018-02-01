---
id: 248
title: 'Maybe that shouldn&#8217;t be settable'
date: 2014-01-13T08:30:18+00:00
author: Sharon Cichelli
layout: post
guid: http://lostechies.com/sharoncichelli/?p=248
dsq_thread_id:
  - "2116900814"
categories:
  - Refactoring
---
I think this is pretty, and I wanted to share. I like classes where the compiler ensures they are always in a valid state&mdash;you can&#8217;t _help_ but use them correctly.

I was writing a class that needed to call a third-party service and then return a result that either indicated there was an error (with the error reason) or reported success and parsed the JSON into a collection of objects. The `Result` class could have been implemented as a dumb property bag:

[gist id=8375957]

The code that calls the service and constructs the result would set properties accordingly:

[gist id=8376006]

The syntactic brevity of auto-properties lulls us into writing `{ get; set; }` without thinking about it, providing public accessors without considering whether or not we&#8217;re flouting encapsulation. We lose the protection and power that properties had granted us, and might as well be using public fields. Talk about anemic classes.

The pitfall, then, is that consuming code has to check the IsSuccess property before accessing other members. If you try to use the Results collection when IsSuccess is false, you&#8217;ll get a null reference exception. And what if some code at runtime changed one of those properties, what would that even mean? If a `Result` had both an error message and a set of parsed results, that would mean… um…

Okay, I promised pretty. What did I do instead?

[gist id=8376021]

The constructor of the class is private. So are the setters on its properties. You can only get at this thing through the entry points I&#8217;m giving you. And those entry points are:

  * Make a Success response with a collection of results.
  * Make a Success response with only one result, but wrap it up as a collection-with-one-item so that consumers can just iterate over Results without worrying about what the third-party service returned.
  * Make an Error response with a consistently formatted error message.

It&#8217;s like a memo to my teammates with instructions for how to use this class. (It&#8217;s like a `///<comment>` without being a stupid _comment_.)

Consumers can even safely call `foreach` over the Results collection without checking whether the service call was successful or not. &#8220;Display all the ones you got, and if you didn&#8217;t get any, whatevs.&#8221;

Here&#8217;s what the consuming class looks like:

[gist id=8376113]

Briefer and clearer. #success

Code that uses this class needs less test coverage. There&#8217;s no wrong way to eat a Reese&#8217;s, and there&#8217;s no wrong way to construct this class. Therefore, I don&#8217;t need to test the code that is constructing it (&#8220;Make sure that IsSuccess gets set to false…&#8221;). The only thing I might get wrong is calling .Success() when I should have called .Error(), but _really_. And less test coverage, on code whose correctness is compiler-enforced, means the rest of the code is more amenable to refactoring.

The general concept here is encapsulation. Challenge yourself to make property setters private by default. Move property-setting logic into the class itself. Let the class protect _itself_ from getting into an invalid state. You get to write a lot fewer `if` statements that way, and your code becomes easier to read.