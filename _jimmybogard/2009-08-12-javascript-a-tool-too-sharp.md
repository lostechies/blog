---
wordpress_id: 343
title: 'JavaScript: A tool too sharp?'
date: 2009-08-12T03:08:57+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/08/11/javascript-a-tool-too-sharp.aspx
dsq_thread_id:
  - "264716282"
categories:
  - 'C#'
  - JavaScript
---
Ehhhh…no.

But, [Roy Osherove believes so](http://weblogs.asp.net/rosherove/archive/2009/08/11/script-script-sharp-solving-the-javascript-overload-problem.aspx).&#160; When I first started JavaScript, I thought so too.&#160; My problem was that **I approached JavaScript from the eyes of a C# developer.&#160;** But C#, JavaScript is not.&#160; So what are the main gripes of JavaScript?

  * No tooling
  * No refactoring support
  * No navigation support
  * It’s not C#

One solution is to use something like Script# to generate JavaScript from C#.&#160; This is similar to the approach of the Google Web Toolkit, with the exception that GWT has a whole ecosystem to basically be able to develop Swing-like applications on the web.

But something like Script#?&#160; If you’re looking to program C# on the web, that’s the way to go.&#160; But it’s a little unfortunate, as JavaScript is a _very_ powerful language with features you simply can’t find in many other places.&#160; The arguments against are very similar to what I’ve heard about other dynamic languages, yet the Rails developers seem to be productive.&#160; Why is that?

My opinion is that it’s simply a very different mindset working in a dynamic language.&#160; And before libraries like jQuery that really used JavaScript like it should, it was a lot more difficult to do interesting things.&#160; I can’t imagine giving up features like prototype for generics.&#160; In fact, I’d much prefer prototypes to generics, it’s just more powerful.&#160; So how do we close the gap?

First, drop any assumption on how developing JavaScript _should_ be.&#160; It’s not a static language like C#.&#160; It’s a dynamic, scripted language, not a static, compiled one.&#160; Next, if you already know OOP, dive into some great JavaScript resources:

  * [JavaScript: The Good Parts](http://www.amazon.com/JavaScript-Good-Parts-Douglas-Crockford/dp/0596517742/ref=pd_cp_b_2)
  * [Pro JavaScript Design Patterns](http://www.amazon.com/JavaScript-Design-Patterns-Recipes-Problem-Solution/dp/159059908X)
  * [jQuery in Action](http://www.amazon.com/jQuery-Action-Bear-Bibeault/dp/1933988355/ref=pd_sim_b_2)

JavaScript is a beautiful little language, but it is not a forgiving language.&#160; If you’re a procedural developer, or don’t know OO too well, JavaScript will eat you up.&#160; Working with a language that has functions as first-class citizens actually changed how I use C#, and it would be rather unfortunate to skip the JavaScript experience in favor of a static language.

So what’s missing in my JavaScript experience?

For one, I still don’t see a great TDD story.&#160; Most of the TDD examples I see go against a static, fake HTML page, which I don’t really see that proves anything.&#160; I know how to TDD C# code, but it’s still not the same experience doing JavaScript.&#160; Roy does have a great point, that your JavaScript files can get out of control.&#160; It’s hard to find great canonical examples of how to develop and organize a solid scripted website.&#160; I see a ton of small examples, but nothing on par of the DDD examples out there.&#160; But given a little patience and some good reference material, JavaScript is one of those languages that can really open your eyes on what is possible beyond the barriers of C#.