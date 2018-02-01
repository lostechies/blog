---
id: 4200
title: Script to Enable HTTP Compression (Gzip/Deflate) in IIS 6
date: 2010-01-08T05:09:00+00:00
author: Keith Dahlby
layout: post
guid: /blogs/dahlbyk/archive/2010/01/08/script-to-enable-http-compression-gzip-deflate-in-iis-6.aspx
dsq_thread_id:
  - "262493314"
categories:
  - HTTP Compression
  - IIS
  - Performance
---
One of the easiest ways to improve web site performance is to enable [HTTP compression](http://en.wikipedia.org/wiki/HTTP_compression) (often referred to as GZIP compression), which trades CPU time to compress content for a reduced payload delivered over the wire. In the vast majority of cases, the trade-off is a good one.

When implementing HTTP compression, your content will break down into three categories: 

  1. Content that should not be compressed because it is already compressed: images, PDF files, audio, video, etc.
  2. Static content that can be compressed once and cached for later.
  3. Dynamic content that needs to be compressed for every request.

Excluding already-compressed content will need to be considered regardless of the techniques used to compress categories 2 and 3.

Since [version 5](http://technet.microsoft.com/en-us/library/bb742379.aspx "Using HTTP Compression On Your IIS 5.0 Web Site"), IIS has included support for both kinds of HTTP compression. This can be enabled through the management interface, but you will almost certainly want to tweak the default configuration in the metabase (see script below). While IIS works great for compressing static files, its extension-based configuration is rather limited when serving up dynamic content, especially if you don&#8217;t use extensions (as with most ASP.NET MVC routes) or you serve dynamic content that should not be compressed. A better solution is provided in [HttpCompress](http://blowery.org/httpcompress/) by Ben Lowery, a configurable HttpModule that allows content to be excluded from compression by MIME type. A standard configuration might look something like this: 

<pre>&lt;configuration&gt;<br />  ...<br />  &lt;blowery.web&gt;<br />    &lt;httpCompress preferredAlgorithm="gzip" compressionLevel="normal"&gt;<br />      &lt;excludedMimeTypes&gt;<br />        &lt;add type="image/jpeg" /&gt;<br />        &lt;add type="image/png" /&gt;<br />        &lt;add type="image/gif" /&gt;<br />        &lt;add type="application/pdf" /&gt;<br />      &lt;/excludedMimeTypes&gt;<br />      &lt;excludedPaths&gt;&lt;/excludedPaths&gt;<br />    &lt;/httpCompress&gt;<br />  &lt;/blowery.web&gt;<br />  ...<br />&lt;/configuration&gt;<br /></pre>

To supplement the compressed dynamic content, you should also enable static compression for the rest of your not-already-compressed content. The script should be pretty self-explanatory, but I&#8217;ll draw attention to a few things: 

  * The **tcfpath** variable at the top is currently set to IIS&#8217;s default location, which you are free to change.
  * The **extlist** variable accepts a space-delimited list of file extensions that _should_ be compressed. Again, only include files types that are not already compressed, as recompressing a file wastes cycles and can actually make some files _larger_.
  * There are a few other [metabase properties](http://technet.microsoft.com/en-us/library/cc778146%28WS.10%29.aspx "Metabase Property Reference") that can also be set, including compression level, but these are the bare minimum.
  * I have been told repeatedly that IISRESET should be sufficient to apply the metabase changes, but I could not get it to work as consistently as manually restarting the IIS Admin Service &mdash; YMMV.
  * If all goes well, the nice arrow at the end will point to **True**.

If you have anything else to add, or have problems with the script, please let me know. 

<pre>@echo off<br />set adsutil=C:InetpubAdminScriptsadsutil.vbs<br />set tcfpath=%windir%IIS Temporary Compressed Files<br />set extlist=css htm html js txt xml<br /><br />mkdir "%tcfpath%"<br /><br />echo Ensure IIS_WPG has Full Control on %tcfpath%<br /><br />explorer "%tcfpath%.."<br />pause<br /><br />cscript.exe %adsutil% set w3svc/Filters/Compression/Parameters/HcDoStaticCompression true <br />cscript.exe %adsutil% set w3svc/Filters/Compression/Parameters/HcCompressionDirectory "%tcfpath%"<br />cscript.exe %adsutil% set w3svc/Filters/Compression/DEFLATE/HcFileExtensions %extlist%<br />cscript.exe %adsutil% set w3svc/Filters/Compression/GZIP/HcFileExtensions %extlist%<br /><br />echo Restart IIS Admin Service - IISRESET does not seem to work<br />pause<br /><br />echo Close Services to continue...<br />Services.msc<br /><br />cscript.exe %adsutil% get w3svc/Filters/Compression/Parameters/HcDoStaticCompression<br /><br />echo Should be True -----------------------------^^<br /><br />pause<br /></pre>