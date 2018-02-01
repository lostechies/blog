---
id: 946
title: 'Anders Hejlsberg Is Right: You Cannot Maintain Large Programs In JavaScript'
date: 2012-06-04T14:38:55+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=946
dsq_thread_id:
  - "713887747"
categories:
  - AntiPatterns
  - Composite Apps
  - CQRS
  - Craftsmanship
  - JavaScript
  - Philosophy of Software
  - Pragmatism
  - Principles and Patterns
  - Risk Management
---
There&#8217;s a quote over on a Channel 9 video of Anders Hejlsberg:

> **Erik Meijer:** Are you saying you cannot write large programs in JavaScript?
> 
> **Anders Hejlsberg:** No, you can write large programs in JavaScript. You just can’t maintain them.

With [a follow-up post on DZone](http://css.dzone.com/articles/you-can-write-large-programs) asking if you agree with this quote or not. I haven&#8217;t listened to the interview so I honestly don&#8217;t know if the quote is taken out of context or not.  But honestly, I don&#8217;t think it matters if the quote is taken out of context because &#8230;

## Anders Is 100% Correct

No ifs, ands or buts about it. Maintaining large JavaScript apps is nearly, if not entirely, impossible.

## But Derick, You Write Large JavaScript Apps&#8230;

No, actually, I don&#8217;t.

I write JavaScript applications that appear to be large. They may be large systems, but in reality they are very small applications (&#8220;programs&#8221; as Anders says). In spite of 5 to 10 **thousand** lines of JavaScript code per system, easily, my applications follow the secret to building large applications:

> &#8220;The secret to building large apps is never build large apps. Break your applications into small pieces. Then, assemble those testable, bite-sized pieces into your big application&#8221; &#8211; **Justin Meyer, author JavaScriptMVC**

(Quote taken from <http://addyosmani.com/largescalejavascript/> )

And that&#8217;s what I do. I write dozens of small &#8220;applications&#8221; &#8211; modules, really &#8211; that are then composed in to larger functional systems at runtime.

## Improving Ander&#8217;s Quote

Like I said, Ander&#8217;s quote is 100% correct. I think Ander&#8217;s quote quote can be improved, though.

**Did you notice that Justin Meyer&#8217;s quote didn&#8217;t mention JavaScript at all?** The truth is, it doesn&#8217;t matter what language you&#8217;re writing in. This secret to writing large application is applicable to all of them. It&#8217;s why we have functions, objects, modules, classes, and other ways of grouping related sets of functionality and/or data together.

So, Ander&#8217;s quote should read:

> **Erik Meijer:** Are you saying you cannot write large programs in **[any language]**?
> 
> **Anders Hejlsberg:** No, you can write large programs in **[any language]**. You just can’t maintain them.

## Maintaining Large Systems

You&#8217;ll have to pardon the link-bait title of this post, and really pay attention to the semantics and language for a moment.

Anders is correct, but not because he is talking about JavaScript. He is correct because it is not possible to maintain large applications in any language / platform / runtime. Write small applications as modules, classes, assemblies, libraries, and/or any other type of modularization technique for your language and runtime environment. Then compose those small &#8220;applications&#8221; (modules, etc) in to large systems which are easier to write and maintain, in JavaScript or any other language.