---
wordpress_id: 4449
title: 'Making c# lambda expressions more readable'
date: 2009-02-20T00:35:00+00:00
author: Sean Biefeld
layout: post
wordpress_guid: /blogs/seanbiefeld/archive/2009/02/19/making-c-lambda-expressions-more-readable.aspx
dsq_thread_id:
  - "449608049"
categories:
  - 'C#'
  - Lambda Expressions
  - Rhino Mocks
  - Unit Test
---
How often do you use lambda expressions? I use them a great deal, mostly when I am making method assertions in [Rhino Mocks](http://ayende.com/projects/rhino-mocks.aspx). Their use is also on the rise with the popularity of fluent interfaces growing. If you do the bare minimum, which i see a lot, the expression can be somewhat cryptic.
  

  
Less readable:

<pre style="border: 1px solid #333333;padding: 5px;overflow: auto;background-color: #000000;font-family: Lucida Console;color: #aaaaaa;font-size: 10pt">Users.Find(x =&gt; x.Id == selectedUserId)</pre>

I am guilty of doing this as well, without even realizing. Maybe I am just being nit picky.
  

  
I think it is much more readable if you use something more descriptive than some arbitrary letter in the alphabet.
  

  
More readable:

<pre style="border: 1px solid #333333;padding: 5px;overflow: auto;background-color: #000000;font-family: Lucida Console;color: #aaaaaa;font-size: 10pt">Users.Find(user =&gt; user.Id == selectedUserId)</pre>

This becomes much more useful when you are coding more complex lambda expressions. One example is when making a method assertion using [Rhino Mocks](http://ayende.com/projects/rhino-mocks.aspx).
  

  
Less readable:

<pre style="border: 1px solid #333333;padding: 5px;overflow: auto;background-color: #000000;font-family: Lucida Console;color: #aaaaaa;font-size: 10pt">_userRepository.AssertWasCalled<br />(<br />     x =&gt; x.Save(newUser),<br />     o =&gt; o.IgnoreArguments()<br />);</pre>

With that assertion we have two arbitrary letters, what the heck does &lsquo;x&rsquo; and &lsquo;o&rsquo; represent. Are we talking about hugs and kisses. I don&rsquo;t think so.
  

  
So to remedy this, lets change &lsquo;x&rsquo; to &lsquo;userRepository&rsquo; and &lsquo;o&rsquo; to &lsquo;method assertion&rsquo;. I believe these terms will make the assertion much more readable and concise.
  

  
More readable:

<pre style="border: 1px solid #333333;padding: 5px;overflow: auto;background-color: #000000;font-family: Lucida Console;color: #aaaaaa;font-size: 10pt">_userRepository.AssertWasCalled<br />(<br />     userRepository =&gt; userRepository.Save(newUser),<br />     assertionOptions =&gt; assertionOptions.IgnoreArguments()<br />);</pre>

With that little change it is much easier to understand what is being asserted and what options are being set on that assertion.
  

  
The hardest part is breaking the habit of using arbitrary letters. In the long run a more descriptive expression improves the readability of the code. It will also decrease the amount of time it takes a new person to understand the lambda expressions in the code base.