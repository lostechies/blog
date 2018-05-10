---
wordpress_id: 188
title: Working with the web model
date: 2008-05-22T00:46:44+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/05/21/working-with-the-web-model.aspx
dsq_thread_id:
  - "264715756"
categories:
  - ASPdotNET
redirect_from: "/blogs/jimmy_bogard/archive/2008/05/21/working-with-the-web-model.aspx/"
---
Lots of comments from my [recent post](https://lostechies.com/blogs/jimmy_bogard/archive/2008/05/18/asp-net-officially-unmaintainable.aspx) on <strike>ASP.NET</strike> WebForms being officially unmaintainable noted that:

  * AJAX works with the ClientID property
  * I don&#8217;t care about HTML

One thing to remember about web applications is that **web applications are nothing more than HTTP, Cookies, HTML, CSS and JavaScript**.&nbsp; Let&#8217;s spell that out again.&nbsp; Web applications are:

  * HTTP
  * Cookies
  * HTML
  * CSS
  * JavaScript

You can create web applications without CSS and JavaScript, but the latter three represent the structure, style and behavior of a single web page.&nbsp; HTTP is engine that makes at all work, and the browser is the window into our application.&nbsp; The browser does not care, nor will ever care about:

  * Postbacks
  * Viewstate
  * Lifecycle events

All of these are a clever ruse on top of the four elements of a web application, an effort by the ASP.NET developers to make the web appear as a stateful application like the VB6 applications before it.&nbsp; One slight problem: **HTTP is inherently stateless**.

Many web application frameworks solve the stateless problem through Session objects, where a unique cookie value matches clients with state bags on the server.&nbsp; All persistent state lives completely on the server, hidden from view from the client except a cookie value.

Now the five components of a web application are simple in and of themselves.&nbsp; Combined, they can create very powerful client experiences.&nbsp; The browser, completely decoupled from the server, serves as a conduit for a myriad of applications, each supplying all the building blocks a browser needs. No matter what happens on the server, eventually all data must go across the HTTP wire, delivering HTML and the others.

And that&#8217;s the beauty of web development: browsers completely decoupled from the server technology used to serve the pages, and a set of standards covering each component (HTML, CSS, etc.)

### So why the WebForms abstraction?

ASP.NET needed to convert a mass of VB6 developers into web developers.&nbsp; To do so, WebForms mimicked a stateful web application through clever use of JavaScript, the FORM element&#8217;s TARGET attribute, and some hidden INPUT elements to persist state.&nbsp; These combined tricks enabled the PostBack model, where a page posts back to itself for processing.

Already, WebForms is subverting and abstracting the very nature of HTTP &#8211; statelessness of postbacks.&nbsp; Additionally, server controls abstracted the raw HTML being sent to the client.&nbsp; With WebForms, you lost control an important component of a web application: HTML.&nbsp; You also lost control of the FORM TARGET, which allowed for posting to specific URLs for specific controlling.

So what&#8217;s the big deal, right?&nbsp; HTML is annoying.&nbsp; It doesn&#8217;t render properly in every browser, and CSS tricks sometimes are the only way to get IE6 and lower to behave properly.

But the underlying concepts are dead simple.&nbsp; HTML to describe the structure of your information, and CSS style the information.&nbsp; When something doesn&#8217;t look right in the browser, no server technology matters.&nbsp; It&#8217;s only HTML, CSS and JavaScript.

By programming in the actual underlying language of the web, we don&#8217;t have to undergo the translation that Web Controls force, nor the behavior change that WebForms force.&nbsp; Since we&#8217;re constantly posting back to the same page, a single page has to be responsible for quite a few things:

  * Creating HTML to be rendered, through an elaborate server control hierarchy
  * Flow Control, through elaborate life cycle events

But the web is much, much simpler than server controls and life cycle events.&nbsp; HTTP GETs and POSTs are how users request information, not through a Button_Click event.

### Working with the model

The main problem I have with WebForms is that it tries to make the web something it&#8217;s not: a client application.&nbsp; Although events get fired on the server, it&#8217;s only through the hidden form variables and self-posting forms that this is possible.

WebForms works completely against the inherent nature of the web, which is why it can be such a pain to work with.&nbsp; WebForms did introduce a number of great concepts, including a component-based architecture, the request pipeline, caching, etc etc.

So how do you develop web applications outside of WebForms?&nbsp; For one, you don&#8217;t use the WebForms designer.&nbsp; The designer lies to you, as it is only the browser that is the singular truth to what your web application will look like.&nbsp; Instead, I structure my HTML directly, using CSS for styling.

How do you develop behavior and flow control?&nbsp; MVC frameworks do this by routing control to the Controller first.&nbsp; The Controller, after performing any flow logic it needs, can pass data to the View.&nbsp; The View is only responsible for taking in data and creating HTML, CSS and JavaScript.

By separating these concerns, we are both working with the model the web is built upon, and allowing complexity to vary independently between the Controller and the View.

When first coming over to ASP.NET from ASP 3.0 back in 2002, I both marveled at the cleverness of ASP.NET and disliked the control that was taken away.&nbsp; The difficulty in ASP development was the language (VBScript is not OO) and the unholy marriage of concerns, as Controller and View were in one single file.&nbsp; Not creating HTML, handling requests, or anything else to do with the components of the web.

Eventually, after seeing other web application frameworks come to the forefront, including Rails, I began to notice the cracks in the woodworks.&nbsp; HTML isn&#8217;t hard, it&#8217;s the flow control where the meat of the application resided.

Now, I&#8217;d rather work with the web model than against it.&nbsp; I recognize that HTML is all that matters in the end, so I might as well accept it and embrace it.