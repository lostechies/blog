---
wordpress_id: 1164
title: 'C# 6 Feature Review: Auto-Property Enhancements'
date: 2015-12-09T16:00:52+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: https://lostechies.com/jimmybogard/?p=1164
dsq_thread_id:
  - "4389457421"
categories:
  - 'C#'
---
With the release of Visual Studio 2015 came the (final) release of the Roslyn C# compiler and C# 6. This latest version of C#&#8217;s feature list seems to be&#8230;less than exciting, but it&#8217;s important to keep in mind that before Roslyn, none of these new features would have ever made it into a release. It was simply too hard to add a feature in C#, so higher impact/value features made it in while minor annoyances/enhancements would be deferred, indefinitely.

I&#8217;m less concerned about the new features themselves than how these features would actually enhance my code. With ReSharper, it&#8217;s pretty easy to see what the impact of these new features would be.

In this series, I&#8217;ll be looking at a long-lived codebase, AutoMapper, and walk through features of C#, their potential utility/impact, and when you should use them. First up are the auto-property enhancements.

### Initializers for auto-properties

The auto-property enhancements mainly center around making fields and properties on an even playing field. In a lot of my AutoMapper code, I have field initializers:

[gist id=d8d9507d2648dcd12713]

Property initializers would instead look like this:

[gist id=fee2ce04f0851d38ef94]

It looks&#8230;rather strange to me. The only place in my code where I could find that I could use property auto-property initializers were places I had existing private fields in place. And I&#8217;m not terribly keen on converting private fields into private properties. Properties are my window into exposing state to the others, otherwise I use private fields to encapsulate state. And no I&#8217;m not one of those weirdos that leaves off access modifiers, waaaaaay too easy to screw up.

**Verdict: Use sparingly**

### Getter-only automatic properties

One pattern I found all over the place in AutoMapper are immutable properties. In C# 5 and earlier, this involved creating a private readonly field and a get-only property. I have this all over the place:

[gist id=80b8cc739294273763a0]

Not \*horrible\* but it would be nice to encapsulate the idiom of an immutable property in the language. This is exactly what getter-only automatic properties do:

[gist id=606065995d16cd63ad29]

I&#8217;m only allowed to set the property in a constructor or initializer, and cannot set it anywhere else inside or outside my class. It has the same effect as a readonly field, just encapsulated. I use this pattern now all over the place.

**Verdict: Adopt immediately and replace obsolete pattern**