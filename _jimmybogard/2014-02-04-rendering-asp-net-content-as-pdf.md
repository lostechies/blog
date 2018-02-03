---
wordpress_id: 863
title: Rendering ASP.NET content as PDF
date: 2014-02-04T14:25:06+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=863
dsq_thread_id:
  - "2219941426"
categories:
  - ASPNETMVC
---
I work on quite a few line of business applications, and a common ask is for printable reports. I could use a tool like SQL Server Reporting Services, but to be honest the report building and styling of those tools is difficult to say the least. Instead, I’d much rather work with HTML and CSS, and in particular, MVC and Razor as templating. My ideal would be to build PDFs as I would regular web pages.

Luckily, this is quite straightforward with HTML to PDF conversion tools. The one I’ve been using recently is [EVO HTML to PDF Converter](http://www.evopdf.com/), which lets me work directly with streams (also available [via NuGet](http://www.nuget.org/packages/EvoPDF)).

The general idea is to take advantage of media queries in CSS to provide specific [CSS for “print”](https://developer.mozilla.org/en-US/docs/Web/CSS/@media) that removes colors, headers, navigation, buttons and so on. With Chrome, I can enable/disable CSS media emulation with a simple checkbox, making it very simple to use my normal web developer tools to tweak styling in a browser and push updates to my SASS/LESS files.

To make it super simple to output PDF from any page, I’d like to just use a querystring parameter to turn PDF generation on/off for any page in my site. This allows us to re-use pages for viewing/printing/saving, and provide a consistent look and feel from printing or saving as a PDF.

We want to have this:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2014/02/image_thumb.png" width="530" height="480" />](http://lostechies.com/jimmybogard/files/2014/02/image.png)

Look like this:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2014/02/image_thumb1.png" width="530" height="480" />](http://lostechies.com/jimmybogard/files/2014/02/image1.png)

The print media version, but output as PDF.

### 

### Integrating PDF Generation

At the very heart of ASP.NET, we have our HTTP module pipeline. What we’d like to do is handle a request, let ASP.NET MVC handle it, and then modify it as the request goes out the door using a response filter:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2014/02/image_thumb2.png" width="446" height="203" />](http://lostechies.com/jimmybogard/files/2014/02/image2.png)

We’ll attach our filter at the beginning of the request, wait for the normal MVC HTTP Handler to execute, and modify the stream as it gets writing to the Response stream. Here’s our PDF module:

[gist id=8803982]

First, we attach ourselves to an “early enough” event. In this case, PreRequest worked for me. I detect to see if there is a “Pdf” request parameter (the value doesn’t matter), and if it doesn’t, I just return and leave the request alone. I could pick anything here, as long as it doesn’t interfere with any other potential request parameters my application might need to use.

If I do happen to find that request parameter, I clear the response and add a header to indicate this is now a PDF. Finally, I instantiate my custom PdfFilter class, passing in the current response filter (to preserve any existing behavior) and the base URL of the site. This is used to resolve CSS and images, as the HTML to PDF converter acts as a mini-browser, rendering the content using WebKit.

Response filters are interesting in that they’re only [Streams](http://msdn.microsoft.com/en-us/library/system.io.stream(v=vs.110).aspx). Some HTML to PDF generators include custom Stream classes, but this one doesn’t. Our custom stream will write the underlying response stream to a memory stream, and once it’s done writing, will use our PDF converter to convert that underlying ASP.NET MVC-generated stream of content to PDF. The entire class can be found here: 

[https://gist.github.com/jbogard/8804255](https://gist.github.com/jbogard/8804255 "https://gist.github.com/jbogard/8804255")

First, when I create the filter, I capture the existing filter and create a new MemoryStream to temporarily save the MVC output:

[gist id=8804285]

As ASP.NET writes to my filter (effectively, the output of our MVC handler), I just capture the output as it writes:

[gist id=8804310]

Finally, when ASP.NET closes my filter stream, I invoke the converter, outputting the result of my conversion into the original ASP.NET response filter:

[gist id=8804333]

The PDF converter has a ton of options, and even is able to allow Javascript to execute in the page. I opt to disable URLs, as it’s a bit strange to click links inside a PDF document for internal business applications, where these documents are often just saved and shared around. With this in place, I can just modify the URL of any page in my site to have a PDF version, matching the styling of the CSS print media:

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2014/02/image_thumb3.png" width="530" height="480" />](http://lostechies.com/jimmybogard/files/2014/02/image3.png)

I love that I can still use MVC, HTML, Razor and CSS to generate my PDFs, and I’m able to use all modern CSS3 whether or not the user’s browser actually supports it. With Chrome tools, I can tweak the print version of my site until it looks great, then just modify the URL to verify the PDF version.

If you’re using CSS frameworks, you might need to do a bit of modification to your print CSS, as the responsive CSS doesn’t necessarily translate to the viewport of the PDF document generated. Most tools, including this one, offer tons of customization to rendering. And the best part is, I never have to deal with direct PDF tools, ever, ever again.