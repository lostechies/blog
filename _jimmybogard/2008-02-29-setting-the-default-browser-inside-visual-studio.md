---
wordpress_id: 150
title: Setting the default browser inside Visual Studio
date: 2008-02-29T14:01:05+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/02/29/setting-the-default-browser-inside-visual-studio.aspx
dsq_thread_id:
  - "264715583"
categories:
  - Tools
---
My default browser is [Firefox](http://www.mozilla.com/en-US/firefox/), and has been for many, many years.&nbsp; But that&#8217;s not everyone&#8217;s favorite browser, nor is the one they have to use all day long.&nbsp; When developing web applications for clients, it&#8217;s important to know what their browser requirements are.&nbsp; Often, for LOB apps or intranet apps, it&#8217;s some version of IE.&nbsp; In this case, I need to develop my web app using IE.

This caused conflicts for me recently as my default browser is Firefox.&nbsp; Whenever I would start the app (Ctrl + F5), a new tab would pop up in my Firefox browser.&nbsp; I didn&#8217;t want that, I wanted IE to pop up.

One way to make IE pop up is to change the Web Application Project&#8217;s Web settings:

![](http://grabbagoftimg.s3.amazonaws.com/defbrowser_prop.PNG)

Here I can type in the path to IE with appropriate command-line arguments.&nbsp; But that&#8217;s annoying and brittle, as not everyone has IE in the same location.&nbsp; This option doesn&#8217;t work very well.

Instead, we can set the default Visual Studio default browser, which doesn&#8217;t conflict with the machine-wide default browser.&nbsp; To get this set up, we&#8217;ll need to open an ASPX file in our solution.

![](http://grabbagoftimg.s3.amazonaws.com/defbrowser_file.PNG)

If you don&#8217;t have one, just create one temporarily.&nbsp; For some reason, this option only shows up when you have an ASPX file open.&nbsp; The option we&#8217;re looking for isn&#8217;t anywhere in &#8220;Tools->Options&#8221;, or at least I couldn&#8217;t find it anywhere.

Finally, go to &#8220;File->Browse With&#8230;&#8221;:

 ![](http://grabbagoftimg.s3.amazonaws.com/defbrowser_menu.PNG)

This will bring the &#8220;Browse With&#8221; dialog up:

 ![](http://grabbagoftimg.s3.amazonaws.com/defbrowser_dialog.PNG)

Select whatever browser you want (IE for me) to be your default, and click &#8220;Set as Default&#8221;.&nbsp; Now whenever I start the application from Visual Studio, the correct browser pops up.&nbsp; This is a Visual Studio-wide setting, so you&#8217;ll need to use this property judiciously.