---
id: 200
title: 'When a space isn&#8217;t a space'
date: 2008-06-26T11:15:09+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/06/26/when-a-space-isn-t-a-space.aspx
dsq_thread_id:
  - "264715817"
categories:
  - 'C#'
---
I ran into a scenario recently where this test failed:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>You_have_to_be_kidding_me()
{
    <span style="color: blue">string </span>a = <span style="color: #a31515">"You have to be kidding me       "</span>;
    <span style="color: blue">string </span>b = <span style="color: #a31515">"You have to be kidding me&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "</span>;

    a.ShouldEqual(b);
}
</pre>

[](http://11011.net/software/vspaste)

It took me quite a while to determine the problem, as it originally came from a column in the database with natural keys.

When a test like this fails, it&#8217;s time to call it a day.&nbsp; Any guesses as to the problem?