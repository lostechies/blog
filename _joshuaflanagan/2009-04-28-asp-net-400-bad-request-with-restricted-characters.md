---
wordpress_id: 3944
title: ASP.NET 400 Bad Request with restricted characters
date: 2009-04-28T03:36:00+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2009/04/27/asp-net-400-bad-request-with-restricted-characters.aspx
dsq_thread_id:
  - "262100433"
categories:
  - MVC
redirect_from: "/blogs/joshuaflanagan/archive/2009/04/27/asp-net-400-bad-request-with-restricted-characters.aspx/"
---
Today I had to hunt down a reported defect that said our advanced search functionality was returning a Bad Request error. On initial inspection, I was unable to reproduce the issue. After talking to our product manager, I learned that he was trying to seed the search with the text &ldquo;% %&rdquo;. We have a quick search text box that lets you enter your criteria, and it has some built in rules about which fields it applies the criteria to. If you need more control over the criteria, you can enable the advanced search, and your quick search criteria will automatically be populated in the advanced search page. The way we were doing that was by passing the criteria in the URL, as in: http://localhost/dovetailcrm/contacts/query/**yourbasiccriteria**.

To seed the advanced search for &ldquo;% %&rsquo;, it would load http://localhost/dovetailcrm/contacts/query/**%25%20%25** (% URI encodes as %25, space encodes as %20)

We were properly encoding the request, so what the problem? Attempting to load that URL would cause the error:

<span style="font-family: 'Cordia New';font-size: medium">400 Bad Request <br />ASP.NET detected invalid characters in the URL.</span>

## Proceed at your own risk

My first instinct was to suspect URLScan, or the IIS 7.0 equivalent. After a bit of googling, it became apparent that ASP.NET really didn&rsquo;t like it when you tried to pass a %, &, *, or : in the URL. The various fixes were scattered around different forum posts, but <a href="http://dirk.net/2008/06/09/ampersand-the-request-url-in-iis7/" target="_blank">summed up nicely at Dirk.Net</a>. Unfortunately, the only answer seemed to be &ldquo;make a registry change&rdquo; or &ldquo;don&rsquo;t pass those characters in your URL&rdquo;.

That didn&rsquo;t sit well with me &ndash; it didn&rsquo;t seem right that there was no way to pass those characters in the URL without having to change your server configuration which could potentially expose your site to security risks.

## Just because you can, doesn&rsquo;t mean you should

After a little bit of experimentation, I discovered that you certainly CAN pass those characters in a URL: they just have to be passed in the query string (the part after the question mark). It suddenly started to make sense why there was not a whole lot of information on this error, and why the little information that was available seemed to be related to ASP.NET MVC. Up until ASP.NET MVC (or more accurately, System.Web.Routing), you would almost always send parameterized data in the URL as part of the query string. It wasn&rsquo;t until we got Routing that we started putting parameters in the path portion of the URL.

So after making a short story long, the solution was to simply pass the information the old fashioned way, in the query string: http://localhost/dovetailcrm/contacts/query?search**=%25%20%25**