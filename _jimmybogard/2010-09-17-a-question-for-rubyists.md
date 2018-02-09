---
wordpress_id: 433
title: A question for Rubyists
date: 2010-09-17T17:40:03+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/09/17/a-question-for-rubyists.aspx
dsq_thread_id:
  - "264716593"
categories:
  - 'C#'
  - Rails
redirect_from: "/blogs/jimmy_bogard/archive/2010/09/17/a-question-for-rubyists.aspx/"
---
I was checking out [this post from Derick Bailey](http://www.lostechies.com/blogs/derickbailey/archive/2010/09/10/design-and-testability.aspx) today, and something struck me rather odd.&#160; Not the “DI only enables testability” argument, but the ruby code:

<pre>class Foo<br />&#160;&#160;&#160; def bar<br />&#160;&#160;&#160;&#160; baz = Baz.new<br />&#160;&#160;&#160;&#160; baz.do_something<br />&#160;&#160; end
end</pre>

I’ve been very curious to see what real Ruby applications look like written by real Rubyists.&#160; From the code I’ve seen, Ruby code written by C# developers looks vastly different than Ruby code written by seasoned Ruby developers.&#160; For example, I can’t really recall ever seeing something like “Baz.new” on anything that wasn’t a Model object or other primitive.

From what I’ve seen, composition in Rails apps happens more through modules and duck-typing, rather than new’ing up a dependency.&#160; In the above example, the Baz type doesn’t have any state, so there’s not really a reason to instantiate it at all.

This is the piece that I always question when I see code like this.&#160; In Rails production apps I’ve had the privilege of seeing, Dependency Injection was never necessary simply because there weren’t any dependencies to begin with.&#160; At most there were some modules/duck typing for static services like encryption.&#160; Otherwise, it just didn’t happen.

So a question (or two) for Rubyists:

  * Would you ever write the above code in the first place?
  * In one sentence (ha ha), how do you apply SOLID to your Ruby applications?

I’m working under the assumption that SOLID principles still apply, but in just far different ways.&#160; From my JavaScript experience, I’ve seen that SOLID and OO are still important, but they’re applied much differently, so I assume the same holds true for Ruby.