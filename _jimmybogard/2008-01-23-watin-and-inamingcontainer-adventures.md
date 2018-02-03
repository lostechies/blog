---
wordpress_id: 134
title: WatiN and INamingContainer adventures
date: 2008-01-23T20:16:02+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/01/23/watin-and-inamingcontainer-adventures.aspx
dsq_thread_id:
  - "264927116"
categories:
  - ASPdotNET
  - Testing
---
I decided to add a simple [WatiN](http://watin.sourceforge.net/) acceptance test today to validate our login page.&nbsp; When a user enters invalid credentials, the page should show an error message.

To test this, I need to set the text of the username and password, and click the Login button.&nbsp; Since I didn&#8217;t want just any textbox, but specifically the username and the password, I like to use the element ID&#8217;s to find them.

We&#8217;re using the [ASP.NET Login control](http://msdn2.microsoft.com/en-us/library/system.web.ui.webcontrols.login(VS.85).aspx) to provide the login interface, which has the textboxes, the button, and the error message in one package.&nbsp; When I want to get the ID, this is what it winds up being:

<pre>ctl00_ctl00_ContentPlaceHolderMain_CenterContent_ctl00_ctlLogin_UserName</pre>

Well that&#8217;s no fun.&nbsp; The [INamingContainer](http://msdn2.microsoft.com/en-us/library/system.web.ui.inamingcontainer.aspx) interface puts out some crazy HTML element IDs to guarantee uniqueness.&nbsp; Luckily I can use regular expressions to search for elements ending in &#8220;UserName&#8221;, and that works for the button, too.

However, the error message does _not_ have an ID around it, so I have to dig into the login control manually to fish it out:

<pre><span style="color: #2b91af">Table </span>loginControl = browser.Table(<span style="color: blue">new </span><span style="color: #2b91af">Regex</span>(<span style="color: #a31515">"._ctlLogin$"</span>));
<span style="color: #2b91af">TableCell </span>errorCell =
    loginControl.TableBodies[0].TableRows[0].TableCells[0].
        Tables[0].TableBodies[0].TableRows[3].TableCells[0];
</pre>

[](http://11011.net/software/vspaste)

Since I don&#8217;t have access to the innards of the HTML in the Login control, this is what I have to resort to.

I&#8217;m really looking forward to MVC framework, where I can take back control over the HTML generated.&nbsp; At least WatiN will be easier.