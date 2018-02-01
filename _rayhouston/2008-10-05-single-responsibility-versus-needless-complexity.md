---
id: 27
title: Single-Responsibility Versus Needless Complexity
date: 2008-10-05T22:07:10+00:00
author: Ray Houston
layout: post
guid: /blogs/rhouston/archive/2008/10/05/single-responsibility-versus-needless-complexity.aspx
categories:
  - Uncategorized
---
At [Pablo&#8217;s Day of TDD](http://www.lostechies.com/blogs/chad_myers/archive/2008/09/15/announcing-pablo-s-days-of-tdd-in-austin-tx.aspx), we were discussing the [Single-Responsibility Principle (SRP)](http://www.lostechies.com/blogs/sean_chambers/archive/2008/03/15/ptom-single-responsibility-principle.aspx) while working through one of the labs and a question came up about a piece of code. The code in question looked something like the following (warning: this is over simplified code to show a point):

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> Login(<span style="color: #0000ff">string</span> username, <span style="color: #0000ff">string</span> password)
{
    var user = userRepo.GetUserByUsername(username);

    <span style="color: #0000ff">if</span>(user == <span style="color: #0000ff">null</span>)
        <span style="color: #0000ff">return</span> <span style="color: #0000ff">false</span>;

    <span style="color: #0000ff">if</span> (loginValidator.IsValid(user, password))
        <span style="color: #0000ff">return</span> <span style="color: #0000ff">true</span>;

    user.FailedLoginAttempts++;

    <span style="color: #0000ff">if</span> (user.FailedLoginAttempts &gt;= 3)
        user.LockedOut = <span style="color: #0000ff">true</span>;

    <span style="color: #0000ff">return</span> <span style="color: #0000ff">false</span>;
}
</pre>
</div>

This was from the a LoginService class and this was its only method. The question was whether or not this violates SRP because it&#8217;s in charge of incrementing FailLoginAttempts as well as locking the user out after 3 failed attempts. I believe we answered the question with a &#8220;depends&#8221;, but it bothered me that we didn&#8217;t have a better answer. Personally, I wouldn&#8217;t have busted this up into another class, but I didn&#8217;t have a good argument to stand on.

Today I went searching through [Agile Principle, Patterns, and Practices in C#](http://www.amazon.com/Principles-Patterns-Practices-Robert-Martin/dp/0131857258) looking for a better answer. In the chapter on SRP, the book gives an example of an interface of a modem that can Dial/Hang-up and Send/Receive. The former is connection management and the later is data communication. The book asks the question as to whether or not these responsibilities should be separated. The answer is

> _&#8220;That depends on how the application is changing.&#8221;_

It then gives an example to how a change might violate SRP, but then states:

> _&#8220;If, on the other hand,&nbsp; the application is not changing in ways that cause the two responsibilities to change at different times, there is no need to separate them. Indeed, separating them would smell of needless complexity.&#8221;_

Ah, there&#8217;s the backup wisdom that I needed to validate my gut feeling. Here&#8217;s one final quote from the book:

> _&#8220;There is a corollary here. An axis of change is an axis of change only if the changes occur. It is not wise to apply SRP (or any other principle, for that matter) if there is no symptom.&#8221;_

I think applying SRP is about applying good judgement. You certainly don&#8217;t want to wait until you have to make a change before you think about SRP, but you don&#8217;t want to over do it either and end up with classes with one method with each having only a couple lines of code.

<div class="wlWriterSmartContent" style="padding-right: 0px;padding-left: 0px;padding-bottom: 0px;margin: 0px;padding-top: 0px">
  Technorati Tags: <a href="http://technorati.com/tags/Principles" rel="tag">Principles</a>
</div>