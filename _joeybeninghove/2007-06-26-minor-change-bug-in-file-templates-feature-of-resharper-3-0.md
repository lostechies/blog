---
wordpress_id: 20
title: Minor change (bug?) in file templates feature of ReSharper 3.0
date: 2007-06-26T10:25:20+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/06/26/minor-change-bug-in-file-templates-feature-of-resharper-3-0.aspx
categories:
  - Resharper
---
Notice anything wrong with this?

[<img alt="resharper30_file_template_incorrect" src="http://static.flickr.com/1300/630293741_963abbad60.jpg" border="0" />](http://www.flickr.com/photos/74595743@N00/630293741/ "resharper30_file_template_incorrect")

That &#8220;File Template 5&#8221; is suppose to say &#8220;Class&#8221; instead.&nbsp; I recently upgraded to [ReSharper 3.0](http://blogs.jetbrains.com/dotnet/2007/06/come-one-come-all-resharper-30-is-here/) from 2.5, and of course brought along all of [my ReSharper template libraries](http://joeydotnet.com/blog/archive/2007/04/14/ReSharper-Template-Library---Updated.aspx) that I&#8217;ve built up.&nbsp; One of the things I did for my file templates when I created them&nbsp;was put accessibility shortcuts into the names using ampersands (&) like&#8230;

[<img alt="resharper30_file_template_with_ampersand" src="http://static.flickr.com/1199/630293859_6ccd87f2b2.jpg" border="0" />](http://www.flickr.com/photos/74595743@N00/630293859/ "resharper30_file_template_with_ampersand")

That way I always knew that, for example,&nbsp;doing an Alt-R-N-C would create me a new class and Alt-R-N-I would create me a new interface, etc.&nbsp; But ReSharper 3.0 doesn&#8217;t seem to like those ampersands anymore.&nbsp; So removing them from the file template name fixes the problem and what ReSharper will now do, that it didn&#8217;t do in the past, is automatically assign accessibility shortcuts to the file templates in your quick access list.

[<img alt="resharper30_file_template_without_ampersand" src="http://static.flickr.com/1108/630325073_ef51f7dca3.jpg" border="0" />](http://www.flickr.com/photos/74595743@N00/630325073/ "resharper30_file_template_without_ampersand")

[<img alt="resharper30_file_template_new_behavior" src="http://static.flickr.com/1036/630293989_c42b0089a0.jpg" border="0" />](http://www.flickr.com/photos/74595743@N00/630293989/ "resharper30_file_template_new_behavior")

In the end, I&#8217;m not sure whether this is a bug or feature, but nevertheless, something to keep in mind if you&#8217;re a heavy user of the keyboard and the file templating features of ReSharper.