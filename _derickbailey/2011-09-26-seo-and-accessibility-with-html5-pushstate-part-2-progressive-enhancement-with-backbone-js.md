---
wordpress_id: 579
title: 'SEO And Accessibility With HTML5 PushState, Part 2: Progressive Enhancement With Backbone.js'
date: 2011-09-26T15:49:45+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=579
dsq_thread_id:
  - "426661314"
categories:
  - Backbone
  - JavaScript
  - User Experience
---
[In my previous post, I introduced the idea of HTML5&#8217;s PushState](http://lostechies.com/derickbailey/2011/09/26/seo-and-accessibility-with-html5-pushstate-part-1-introducing-pushstate/) &#8211; a way to manage a browser&#8217;s URL without making a round trip to the server to retrieve the information at that URL. In this post, I&#8217;ll be taking this information and showing a few example on how we can implement PushState with our Backbone.js applications, providing support for both search engine optimization (SEO) and with only a little more work, accessibility for access via screen-readers and other assistive technologies.

## Progressive Enhancement And PushState

PushState allows us to better implement search engine optimization (SEO) and accessibility in our sites by giving us an entry point into progressive enhancement for our pages. We can have our servers render HTML as if we were working with a site that has no enhanced JavaScript functionality. Then, when the browser receives the markup, the css and the JavaScript, we can enhance the user&#8217;s experience by providing more functionality within the page than HTML alone would allow.

## A Trivial Example: Say My Name!

Before we get into enabling PushState with our Backbone.js code, let&#8217;s take a look at a trivial example of progressive enhancement.

Start by having a web server produce a very simple HTML form with a single textbox and button:

{% gist 1243356 1-form.html %}

After the server renders this and delivers it down to the browser, the JavaScript for the page (a Backbone.js view in this case) would pick it up and run with it:

{% gist 1243356 2-sayname.js %}

When i instantiate the view after the page loads, I&#8217;m providing the existing content of the form that was rendered by the server to the view instance as the &#8216;el&#8217; of the view. I am not calling render or having the view generate an for me when the first view is loaded. I have a render method available for after the view is up and running and the page is all javascript, though. This lets me re-render the view later if i need to. (In all honestly, though, this example doesn&#8217;t need a render method and it could easily be left out).

Clicking the &#8220;Say My Name&#8221; button with JavaScript enabled will cause an alert box.

<img title="Screen Shot 2011-09-26 at 3.56.12 PM.png" src="http://lostechies.com/derickbailey/files/2011/09/Screen-Shot-2011-09-26-at-3.56.12-PM.png" border="0" alt="Screen Shot 2011 09 26 at 3 56 12 PM" width="479" height="238" />

Without javascript, it would post back to the server and the server could render the name to an html element somewhere.

## A Less Trivial Example: A List Of Users

Now say we have a list of users in a \`ul\` tag. This list is rendered by the server when the browser makes a request and the result looks something like this:

{% gist 1243356 3-list.html %}

Now we need to loop through this list and attach a backbone view and model to each of the \`<li>\` items. With the use of the \`data-id\` attribute, we can find the model that each tag comes from easily. We&#8217;ll then need a collection view and item view that is smart enough to attach to this html.

{% gist 1243356 4-list.js %}

In this example, the \`UserListView\` will loop through all of the \`<li>\` tags and attach a view object with the correct model for each one. It also sets up an event handler for the model&#8217;s \`change:name\` event and updates the displayed text of the element when a change occurs.

Then after we initialize everything and attach it to the HTML, we grab the first item in the collection and change the name. The list is then updated through the use of the event binding:

<img title="Screen Shot 2011-09-26 at 4.19.00 PM.png" src="http://lostechies.com/derickbailey/files/2011/09/Screen-Shot-2011-09-26-at-4.19.00-PM.png" border="0" alt="Screen Shot 2011 09 26 at 4 19 00 PM" width="144" height="95" />

With this pattern of implementation in place, it should be fairly easy to see how we can progressively enhance our server-generated HTML with JavaScript frameworks like Backbone.js. However, there&#8217;s one more issue to cover still &#8211; what happens when we need to render the same HTML from the server side as well as from the client side?

We don&#8217;t want to duplicate the HTML templates that our server uses, in our front-end HTML and JavaScript code. This would become a nightmare to maintain. Fortunately, we have some very sophisticated and malleable templating systems in both our server side frameworks and our client side frameworks, these days.

## Server Side And Client Side HTML Templates

Looking back at a few of my previous posts, we can see the beginnings of what we need to do, to handle this situation. In my post on [Rendering A Rails Partial As A jQuery Template](http://lostechies.com/derickbailey/2011/06/22/rendering-a-rails-partial-as-a-jquery-template/), I covered the subject of re-using an ERB template from a Rails application in the front-end JavaScript with jQuery Templates. In this post, I show how to use a Rails model and populate it with data that looks like the jQuery Template markers:

{% gist 1041780 some_controller.rb %}

You can see in this example that I&#8217;m populating a model&#8217;s \`value\` attribute with the data &#8220;${value}&#8221;. When this gets rendered into HTML via an ERB template, it will produce HTML that can be used with jQuery Templates.

In addition to this double-rendering technique, you may want to provide some functional or unit testing around your Backbone.js application code. To handle this with Jasmine-BDD and again re-use the existing templates in the Jasmine fixtures, you can combine the double-rendering of templates with my post on [test-driving Backbone views with jQuery Templates](http://lostechies.com/derickbailey/2011/09/06/test-driving-backbone-views-with-jquery-templates-the-jasmine-gem-and-jasmine-jquery/).

## Backbone.js And HTML5 PushState

With all of this in place &#8211; server rendered HTML and progressive enhancement to enable client side JavaScript &#8211; we can set our Backbone application up to use PushState. To do this, we only need to enable PushState via the \`Backbone.history.start\` function:

{% gist 1243356 5-pushstate.js %}

Using Backbone&#8217;s \`history\` requires a Router with at least one route, of course. While I haven&#8217;t shown how to use a router in this post, there are plenty of example of using routers out there on the web, including [my own blog posts on backbone.js](http://lostechies.com/derickbailey/category/backbone/) and [my training course](http://backbonetraining.net). Once a router is in place, though, and Backbone&#8217;s history is started, the browser will have it&#8217;s URL updated with full URLs instead of URL hash fragments.

If we have set everything up correctly, a user will be able to hit the root of our application and Backbone will pick up and start the application from there. Then, once the user has progressed through the application and the browser&#8217;s URL has been updated appropriately, they can either bookmark the URL, copy & paste it or simply hit the refresh button in their browser. Doing this will cause the browser to make a request back to the server for the page that the browser was previously looking at. Once the page is rendered by the server and sent down to the browser, our JavaScript will kick in and enhance the functionality of the page, allowing the full experience of the page for those browsers that can support it.

## The Result: SEO And Accessibility Friendly

By having the server side HTML rendered for us and delivered through standard URLs, our application is much friendlier when it comes to search engine optimizations. We&#8217;re most of the way down the path of creating accessibility within our application. The hard part of this is getting the server to render up the HTML that we want while still having the JavaScript enabled browsers make it work nicely. We know we&#8217;ve solved this problem simply by support PushState. Now we can head down the rest of the accessibility path by including the necessary html tags and attributes, such as the \`alt\` attribute for images, HTML5&#8217;s \`aria-live\` attribute, and other bits of information that assist the assistive technologies and other accessibility tools.
