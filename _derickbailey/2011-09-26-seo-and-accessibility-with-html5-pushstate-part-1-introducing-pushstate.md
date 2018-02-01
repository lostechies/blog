---
id: 575
title: 'SEO And Accessibility With HTML5 PushState, Part 1: Introducing PushState'
date: 2011-09-26T15:48:41+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=575
dsq_thread_id:
  - "426660449"
categories:
  - Accessibility
  - Backbone
  - JavaScript
  - SEO
  - User Experience
---
With the increasing popularity of JavaScript frameworks and highly functional, stateful javascript applications through frameworks such as Backbone.js, SproutCore, KnockOut.js, etc, more and more developers are starting to ask questions about search engine optimization (SEO) and accessibility. There are more and more questions popping up on StackOverflow on a regular basis, and more and more books and articles being written to cover these subjects. I&#8217;ve been digging into the subject matter recently, and I wanted to share my thoughts and an approach that I&#8217;ve used recently, through a small series of posts. This first post covers the problem space of SEO and Accessibility, with a second post covering an implementation example using Backbone.js and a Sinatra web server.

## SEO Friendly And Accessible Versions

Both SEO and accessibility have a similar underlying philosophy: semantically rich markup that is &#8220;accessible&#8221; (i.e. can be accessed, viewed, read, processed, or otherwise used) to different browsers. A screen reader, a search engine crawler or a user with javascript enabled, should all be able to use/index/understand your site&#8217;s core functionality without issue.

In the past, this has largely meant having multiple versions of an application &#8211; one that is SEO friendly and accessible, and one that is full-features and relies heavily on JavaScript. Fortunately, this is changing rapidly. With the advent of HTML5, better JavaScript libraries and easier integration between back-end servers and front-end browsers, we have more options for building sites that are both interactive and accessible.

## Hash Fragments

Many of the current JavaScript heavy frameworks support the use of URL hash fragments &#8211; those &#8220;#whatever&#8221; things that get appended to the end of the URL in your browser window.

These fragments have been around in web browsers and HTML for a very long time. Historically, they have been used to allow a browser to jump from one part of a page to another, without having to make a request back to the server. This made them ideal for dealing with interactive web pages. JavaScript could be set up to watch for changes in the hash fragment and the content of the page could be altered based on this. Browser history can also be manipulated so that you can move forward and backward through the hash fragments and get to the different parts of the app using the browser&#8217;s back and forward buttons.

As functional as this is, it does nothing for SEO or accessibility. In fact, it has quite a negative effect on these pretty much ensuring your site is not SEO friendly or accessible.

## HashBang URLs For SEO Friendliness

Then, a few year ago, Google released some documents that describe [a way for JavaScript applications that use hash url fragments to be crawled and indexed by search engines, making them SEO friendly](http://code.google.com/web/ajaxcrawling/docs/specification.html). This became known as HashBang URLs because it uses a # (hash) and ! (bang) in the URL&#8217;s hash fragment.

For example, Twitter uses hashbangs for it&#8217;s user pages:

<img title="Screen Shot 2011-09-26 at 12.19.25 PM.png" src="http://lostechies.com/derickbailey/files/2011/09/Screen-Shot-2011-09-26-at-12.19.25-PM.png" border="0" alt="Screen Shot 2011 09 26 at 12 19 25 PM" width="552" height="259" />

This helped things along, but presented a new problem as a three-headed monster.

  1. It in&#8217;t an official standard. It&#8217;s just a recommendation from Google for developers and other search engines to work with
  2. It requires potentially strange and painful code to be written on the back-end server. The server must know how to respond to a request with a specially formatted &#8220;\_escaped\_fragment_&#8221; URL parameter
  3. It does almost nothing for accessibility and only addresses SEO directly, as it&#8217;s likely only a search engine would implement the needed &#8220;\_escape\_fragment_&#8221; request

## HTML5&#8217;s PushState To The Rescue

PushState is a new standard, with HTML5, that helps us solve all of these problems. What was once a URL such as http://example.com/#images/1 to tell a JavaScript application to load image #1 on to the screen, can now be represented as a standard URL: http://example.com/images/1 &#8211; no hash fragment required.

There is no magical, mysterious technology that suddenly makes everything accessible and SEO friendly, though. In fact, we still have to do all of the work to ensure that our sites are accessible and SEO friendly. In fact, PushState is really nothing more than a standard API for JavaScript, that allows us to manipulate the browser history by &#8220;push&#8221;ing full URLs into the browser&#8217;s URL without making a round trip to the server, and respond to changes in the URL with Javascript &#8211; all without the use of URL hash fragments. PushState does gives us an easier entry-point into both SEO friendliness and accessibility, though.

(For a complete introduction to the new history management API in HTML5, affectionately known as &#8220;PushState&#8221;, check out the [Dive Into HTML5 guide on History](http://diveintohtml5.info/history.html))

## Working With PushState URLs

Since we no longer rely on URL hash fragments, when working with PushState, we have to change how we build our applications in a manner that supports PushState directly, and by virtue of this, creates an SEO friendly version of our application and allows us to implement other accessibility enhancements with greater ease.

If a url was previous set up to load as http://example.com/#images/1 in order to load image #1 from a list and display it, then the PushState version would simply be http://example.com/images/1. With our JavaScript application using PushState, the browser&#8217;s URL can be updated to point to this location without making a round trip to the server. This allows us to have a much more interactive web page while still a friendlier URL for the user and for search engines.

We can&#8217;t stop at just removing the # and enabling PushState, though. Since the URL that our browser now points at is a standard URL and not a hash fragment URL, this means we need to have our server be able to respond to a request directly to that URL. For example, the previous hash fragment of &#8220;/#images/1&#8221; would be interpreted by the browser as a request to &#8220;http://example.com&#8221; and then the hash fragment would be handled by the browser, once the contents of the default document for example.com were loaded. With the change to a standard URL, when a browser makes a request to example.com/images/1, the server must be able to respond to that request and provide the rendered HTML and content for the entire page, to display the requested image.

To do this, we need our server to render up the same content as the browser would have rendered with JavaScript, and send that rendered version down to the requesting browser. This is where the real magic of PushState gives us SEO friendliness and accessibility. Since we&#8217;re sending a complete rendered version of the page down to the requesting browser (screen reader, search engine, or whatever), we no longer have to rely on JavaScript to render the contents of the page for us. This means we no longer have to worry about a search engine not being able to index the content or a screenreader having to deal with JavaScript.

With PushState enabled and the requisite work to support it in both the browser and server, we can create an entry point for SEO friendliness, accessibility, and still provide a rich and meaningful experience with JavaScript through the use of progressive enhancement of our rendered content.

## Progressive Enhancement And PushState

Progressive enhancement is a term used to describe a website that is functional with even the most remedial of text-based browsers, screen readers and search engine crawlers, but offers more and more functionality as the capabilities of the browser allow for it. There has been a wealth of knowledge written on progressive enhancement over the last few years, and it is one of the core tenets of building web applications that are both SEO friendly and accessible.

The basic idea behind progressive enhancement with JavaScript, is that our server will render the raw HTML for a given page request. Then when the browser receives this markup along with the CSS and JavaScript that goes along with it, the browser&#8217;s capabilities determine how the page will look and act, using the existing markup. This goes against a lot of the current trend in making the browser do the majority of the work to render the page content with frameworks like Backbone, Knockout, etc. However, it&#8217;s critical to SEO and accessibility.

PushState does not change the need for progressive enhancement. Rather, it brings the need for progressive enhancement out of the low priority list and &#8220;if we have time&#8221; schedule, out to the front of the development process where it should be. And, like other accessibility and SEO issues, doing this requires up-front planning or it will become a significant burden. It should be baked in to the page and application architecture from the start &#8211; retrofitting is painful and will cause more duplication than is necessary. Working with PushState in mind from the start, though, allows us to make better decisions about our back-end implementations, the template systems we use for both the server and client, and how we approach progressive enhancement in our JavaScript code.

## Implementing PushState And Progressive Enhancement With Backbone.js

[In the next part of this small series](http://lostechies.com/derickbailey/2011/09/26/seo-and-accessibility-with-html5-pushstate-part-2-progressive-enhancement-with-backbone-js/), I&#8217;ll walk through some of the implementation details of using PushState with a Backbone.js application. I&#8217;ll show how to enable PushState with Backbone&#8217;s routers and how to attach an already-rendered chunk of HTML to a Backbone view with a Backbone model in place. I&#8217;ll also look back at a few of my previous blog posts and bring them all together to help create HTML templates that can be rendered by a back-end server framework as well as a front-end JavaScript templating framework.