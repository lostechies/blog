---
id: 3389
title: Queue is Always Empty Using yield return
date: 2011-05-04T06:45:21+00:00
author: Chris Missal
layout: post
guid: http://lostechies.com/chrismissal/?p=69
dsq_thread_id:
  - "295025056"
categories:
  - ASP.NET MVC
  - LINQ
---
I ran into an issue in a C# application the other day. Thankfully I figured out what was going wrong right away, but it could have turned into a big headache potentially.

<!--more-->

The View was strongly typed as IEnumerable<string> and looked something like this:

<pre>&lt;% if(Model.Any()) { %&gt;
&lt;ul id="messages"&gt;
&lt;% foreach (var message in Model) { %&gt;
    &lt;li&gt;&lt;%: message %&gt;&lt;/li&gt;
&lt;% } %&gt;
&lt;/ul&gt;
&lt;% } %&gt;

</pre>

The code behind for putting the Model into the view was also pretty simple:

`</p>
<pre>
public ActionResult Messages()
{
	return PartialView(messageService.GetMessages());
}

` </pre> 

The implementation of MessageService was also very simple:

`</p>
<pre>
public IEnumerable<string> GetMessages()
{
	while (Queue.Count > 0)
		yield return Queue.Dequeue();
}

` </pre> 

I could set a breakpoint and see messages being queued up, but the list items weren't being rendered on the page. See the problem?

The issue isn't in the Messages() action or the GetMessages() method. In the view, when .Any() is called, it will enumerate the collection and dequeue all the messages. After that happens, there is nothing to loop through in the foreach. This was fixed easy enough with the following in MessageService:

`</p>
<pre>
public IEnumerable<string> GetMessages()
{
	return GetDequeuedMessages().ToArray();
}

private static IEnumerable<string> GetDequeuedMessages()
{
	while (Queue.Count > 0)
		yield return Queue.Dequeue();
}

` </pre> 

Hopefully this helps you from pulling your hair out if you didn't catch it right away!