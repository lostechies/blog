---
wordpress_id: 922
title: 'Wrapping $.ajax In A Thin &#8220;Command&#8221; Framework For Backbone Apps'
date: 2012-05-04T08:45:16+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=922
dsq_thread_id:
  - "675697216"
categories:
  - AJAX
  - Backbone
  - JQuery
  - Semantics
  - Underscore
---
A large number of my recent client applications, built on Backbone, have been using straight jQuery AJAX calls. Sometimes its in combination with Backbone&#8217;s persistence method, but other times I end up using AJAX calls in place of Backbone calls.

## Non-CRUD-y Apps

Now I don&#8217;t think that there&#8217;s anything wrong with Backbone&#8217;s &#8220;save&#8221;, &#8220;fetch&#8221; and &#8220;destroy&#8221; methods. They&#8217;re quite handy, and very well done. The deciding factor in using them is whether or not my application is CRUD-y or not. That is to say, many of my recent apps are taking more of a command approach to user interaction and data updates. Instead of just having simple Create, Read, Update and Delete forms on my apps, I tend to have smaller and more focused commands that are called.

For example, signing a terms of service agreement is a command to sign the agreement, not just a &#8220;create&#8221; on a resource. Sure, the implementation of that may be a &#8220;POST&#8221; on a resource location. But that doesn&#8217;t mean I need a full Backbone model, or need to think about the signature as a RESTful resource from my JavaScript code.

## Executing Commands vs Making AJAX Calls

As a result of all this, I end up using $.ajax a lot… and it&#8217;s getting really ugly and obnoxious seeing this all over my code:

{% gist 2595175 1.js %}

Not only is this ugly when you repeat the $.ajax calls all over the code, but it doesn&#8217;t really give the semantic benefit of knowing what the code is really doing. I&#8217;m not just making a call across an AJAX connection. I&#8217;m trying to execute a command &#8211; I&#8217;m trying to do something important, and I want my code to reflect that.

So I wrapped up my $.ajax calls in a thin &#8220;command&#8221; wrapper for my current client app (built with Backbone of course), and ended up with this instead:

{% gist 2595175 2.js %}

Looking at this in comparison to the original $.ajax calls, there are a few less lines of code. Since I have a thin wrapper around the ajax calls and setup, I can make a few assumptions about the calls and provide a little bit of default configuration. 

I can also move the registration of commands somewhere other than the execution of the commands, which is a huge win for readability and organization of the code when it comes time to execute a command.

Of course the handling of events for success, error and completed doesn&#8217;t give me any advantage over $.ajax and deferred objects. But the big benefit here and why I don&#8217;t mind the thin wraper around the done/fail/always deferred methods, is the semantic value of executing a named command vs configuring an ajax call.

And before you go in to a &#8220;semantics are not important&#8221; lapse of sanity, just think a little about this line that I once heard from [Sharon Cichelli](https://twitter.com/#!/scichelli):

> &#8220;_Semantics will continue to be important until we learn to communicate in something other than language._&#8220;

## Implementing The Command Structure

This implementation relies on Backbone, Underscore and jQuery, so it&#8217;s really only useful in Backbone applications at this point. It&#8217;s also important to note that this code is not unit tested at all. I&#8217;m using it in my current client application and it is functional for me, but I don&#8217;t recommend taking this code as a great implementation, yet. I have plans on turning this into a real plugin, with full testing around it. But like most of my plugins and libraries, it started out as a quick hack in order to get something cleaned up in one of my applications.

{% gist 2595175 backbone.ajaxcommands.js %}

There ar ea couple of things you&#8217;ll want to note in this code:

The call to &#8220;register&#8221; a command stores the configuration that you provide. The call to &#8220;get&#8221; a command creates a new command instance and hands it back to you. This is done so that you can have single-use command objects and not have to worry about unbinding events from the command after it has completed. If I held on to a single command instance and just handed that back to you, you would be responsible for unbinding the event handlers after executing the command. 

The wrapper events for &#8220;success&#8221;, &#8220;error&#8221;, and &#8220;complete&#8221; also don&#8217;t guarantee to fire if you subscribe to them after the command has been executed. So, it&#8217;s important to set up your event handlers before calling .execute on the command object.

I&#8217;ve also extracted the &#8220;getUrl&#8221; method specifically because I need to provide a very custom implementation of this method in my client&#8217;s application. I have another plugin that I&#8217;m looking at writing, which handles storage and retrieval of URLs in my Backbone apps, including :token replacement in the urls … but that&#8217;s another blog post and another plugin to write.

## A Timed Polling Mechanism

One of the more interesting things I&#8217;m doing with this is using it as a timed polling mechanism. I set up a command and then I wrap the commands &#8220;execute&#8221; function in another method that I can call from a setTimeout. When the command executes, I check the response. If I find the data I need, I move on. If I don&#8217;t find the data I need, I call the wrapper function again, inside of a setTimeout.

{% gist 2595175 3.js %}

There&#8217;s lot of fun little tricks you can do with a simple object wrapper like this, that would be a little more cumbersome and awkward when directly using $.ajax. 
