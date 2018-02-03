---
wordpress_id: 3141
title: DesignByContract with Fluent Interfaces
date: 2007-10-07T03:37:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2007/10/06/designbycontract-with-fluent-interfaces.aspx
dsq_thread_id:
  - "268123695"
categories:
  - general
---
I was reading through some&nbsp;blog posts and through a recent post, stumbled&nbsp;across <a target="_blank" href="http://devlicio.us/blogs/billy_mccafferty/archive/2006/09/22/Design-by-Contract_3A00_-A-Practical-Introduction.aspx">this one</a>&nbsp;from <a target="_blank" href="http://devlicio.us/blogs/billy_mccafferty/default.aspx">Bill McCafferty</a>&nbsp;and took a look at the <a target="_blank" href="http://www.codeproject.com/csharp/designbycontract.asp">DesignByContract CodeProject article</a>. This is just a simple utility class to pass in assertions and get an exception to be thrown with a message if the contract has been violated. I did this manually in my last project using repetitive code that got to be a pain. On a new project I definately wanted to use a utility to perform these checks for me. The DesignByContract sample would seem to fit the solution. It is working fine thus far, but I didn&#8217;t like how the method calls looked and thought it would be a prime candidate for some fluent interfaces.

Here is my shabby attempt at a DesignByContract class to perform checks with fluent interfaces. Now instead of this:

Check.Require(!string.IsNullOrEmpty(username), &#8220;username is required&#8221;);

we can have this:

// with strings  
Check.Parameter(username).WithMessage(&#8220;username is required&#8221;).IsNotNullOrEmpty();

// with objects  
Check.Parameter(someObject).WithMessage(&#8220;some object is required&#8221;).IsNotNull();

A little longer to type, but with ReSharper&nbsp;who really types out whole method names anymore =) Theres probably a better way to do it with generics but for the time being I just needed to make sure that parameters were not null. So all this class does is check for null/not null. In the near future I will add assertion checks in there as well. I haven&#8217;t had a need for that yet and why write unnecessary code!

You can get the DesignByContract.cs and tests from my Google Source code repository here:

<span style="color: #808080;font-size: small"><a href="http://schambers.googlecode.com/svn/FluentDBC/">http://schambers.googlecode.com/svn/FluentDBC/</a></span>

If anyone has any additions please send me a patch and I will be happy to add it!<span style="font-size: small"></span>

<span style="font-size: small"></span>