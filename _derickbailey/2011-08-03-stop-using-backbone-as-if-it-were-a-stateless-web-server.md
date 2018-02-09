---
wordpress_id: 505
title: Stop Using Backbone As If It Were A Stateless Web Server
date: 2011-08-03T19:56:33+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=505
dsq_thread_id:
  - "376613889"
categories:
  - AntiPatterns
  - Backbone
  - JavaScript
  - JQuery
  - Model-View-Controller
  - Pragmatism
  - Principles and Patterns
---
In the web development world with MVC based back-end servers, nearly everything is kicked off with routes. Look at rails for example. If you want a list of items, you hit /items and the router executes the index method on ItemsController. Add a new item, view an item, edit an item and post the updates back to the server &#8211; even deleting an item works with a route.

Unfortunately I see the same patterns emerging in a lot of sample code for javascript MVC frameworks, like Backbone. Stop doing that. Now. You shouldn&#8217;t be using routes for functionality that can be achieved with a simple method call, a command, or an event.

## Why It Works For The Server

A web application is a stateless system. Your browser does not have a live connection to the server for any more time than is needed to transfer the rendered html, css, javascript, images, etc to your browser. Once that data transfer is done, you are viewing the page on your local system. The server is not holding a ton of resources in memory, allowing you to manipulate them directly through your browser. You&#8217;re manipulating a representation of those things, that has been turned into a combination of technologies that your browser knows how to deal with.

Because of the stateless nature of web servers, it makes sense for every action you want to do to have a route associated with it. The server needs to have some context to tell it what you are trying to do, so it can figure out what code you&#8217;re trying to run. All of this is necessary because the browser is disconnected from the server. The server doesn&#8217;t know that you&#8217;re looking at item #1 or the list of items. It knows nothing about what you&#8217;re doing until your browser tells the server to do something.

## State. Do You Speak It?

A Backbone app is closer to a desktop client application than a web application in a few respects. Not the least of which is that it has state. The objects and data that are loaded in memory will stay in memory. You can rely on the item that you loaded being there when you need it again, without having to reload based on an id every time you need it.

Because of the stateful nature of a Backbone application, there are times when it doesn&#8217;t make sense to use a route, though it technically works.

## Problem: Routing A Delete

I&#8217;ve seen this a number of times &#8211; and have built it at least once, myself. When a developer who normally works with rails or another MVC server technology gets to the point where they need to delete one of the Backbone models, they add a route for delete. Then they use a link in the html to hit the route and cause the delete to happen.

The delete route and view often look like this:

{% gist 1123795 1-routing-delete.js %}

With an HTML layout that looks like this (after being rendered):

{% gist 1123795 2-routing-delete.html %}

Yes, this is functional. You can click on that link and it will delete the model in question. The rendered view for that model will also be removed from the HTML that is displayed on the screen. As functional as this is, though, there are several problems with it.

### Browser History

One of the features that we get with Backbone&#8217;s router is the ability to control the browser&#8217;s history and the back button. Every time we send the browser to a new url#route, Backbone records it in the browser&#8217;s history. This allows us to move backward and forward in the application, using the browser&#8217;s backward and forward navigation button.

When we use a delete route, we get the deletion stuffed into our browser&#8217;s history. If we hit the back button, after navigating to another url#route, the router will try to find and delete the model again. It gets even worse if we are routing deletes of groups of things.  Assume that we routed to #/delete/green in order to delete all items that are colored green. Then the user adds several new items that are green. Now that they are done, they click through the back button history in order to get to where they started. Along the way, they hit the #/delete/green route again, and all of the work they had just done is destroyed.

To prevent these bad scenarios and prevent unwanted errors from models not existing when the router fires the delete code again, we have to put null checks around things. This makes our code a little uglier, a little less readable and gives us more to maintain over time.

### Bookmarks and Copy & Paste Urls

Another advantage of Backbone&#8217;s router and url#routes, is the ability to copy & paste the entire url or bookmark it, and get back to where we left at any time in the future. When we open that bookmark or paste the url with the url#route in it, the Backbone router will kick off the route&#8217;s code. Here, we end up in the same scenario as the browser history issue.

### Unnecessary Lookup To Find The Model For Deletion

Backbone is a stateful framework. This means that we have whatever objects are instantiated hanging around and waiting to do work or have work performed on them. By using a route to find the model that we want to delete, we are ignoring the state that our Backbone application has already provided in order to look up a model that is already in memory, waiting to be used.

The result of this is negligible in terms of memory and performance, in the example of deletion. However, the problem extends beyond the simple model and into the views.

### Breaking Encapsulation To Remove The View

The last line of the router&#8217;s delete method removes the view that was displaying the item because when you&#8217;re deleting an item, you will likely want to remove it from the view as well. By using a jQuery selector to find the view and remove the HTML that represents the view from the DOM directly, though, we are breaking the view&#8217;s encapsulation and creating spaghetti code which will likely become difficult to maintain over time.

A Backbone view provides a significant amount of functionality and capabilities. One of the convenience features that is provided for us is the \`remove\` method of the view. This method, according to the documentation, calls \`$(this.el).remove()\`. This is essentially the same code that we have called in our router&#8217;s delete method. However, this remove method is encapsulated within the view and uses the context and knowledge that the view holds in order to do the delete. Even if this convenience method doesn&#8217;t exist in your version of Backbone, it is 1 line of code to add it and allow work against your view to be encapsulated correctly.

By making this call outside of the view, we are breaking encapsulation. We are also opening up the possibility of bugs being introduced to the app in ways that are difficult to track down. If we have code strewn throughout the app that removes HTML elements, but we are not cleaning up the view objects that represent (and own) those elements, there could be problems. If a view tries to access an element that is no longer there, the work it&#8217;s trying to do will at best, not do anything. At worst, it will cause unexpected errors and potentially ruin the work that the user has been doing.

### Other Issues

While the list of issues I&#8217;ve described is fairly comprehensive of the potential problems, it&#8217;s not complete. There are near countless combinatorial problems that can be put together between all of these and other potential issues that I haven&#8217;t expressed.

## Solution: Let The View Be In Control

Given the number of problems that have been identified, it should hopefully be apparent that a route for a delete is probably not the best thing to do. Fortunately, we can solve these problems by building our Backbone views the way they were meant to be built, allowing them to encapsulate control of a model, including the model&#8217;s deletion.

Here&#8217;s an example of the code that we can use to allow deletion of the model via the view, directly:

{% gist 1123795 3-view-delete.js %}

And the view can be simplified a little, too:

{% gist 1123795 4-view-delete.html %}

You&#8217;ll notice that this is roughly the same amount of code. There may be 1 or 2 lines less in the new version, but that&#8217;s negligible at best. We don&#8217;t get any advantage from this perspective. However, we do get a number of advantages with regards to the previous problems that I described.

### No Browser History For The Delete

We&#8217;ve changed the delete link in the HTML from &#8220;#/delete/1&#8221; to &#8220;#&#8221;. This could cause a browser history entry to be created, if the browser is currently pointing to a route other than &#8220;#&#8221;. However, there is a line of code in our delete method that will prevent this from happening. The first line, &#8220;e.preventDefault();&#8221;, tells jQuery to prevent the link from causing the browser to change it&#8217;s url. Thus, when we click the delete link, the item will be deleted but we will not navigate to &#8220;#&#8221; and therefore will not have a new route fired or a browser history entry created.

### No Bookmark or Copy & Paste Urls For Deletion

Again, we&#8217;ve changed the delete link in the HTML from &#8220;#/delete/1&#8221; to &#8220;#&#8221;. This will prevent a bookmark or url copy & paste from triggering any deletion. Since you can&#8217;t create a bookmark to a specific line of javascript code, or copy & paste a url that starts out on a specific line of javascript code, we don&#8217;t have to worry about this problem at all.

### No Unnecessary Lookup To Find The Model For Deletion

We&#8217;re taking advantage of Backbone&#8217;s stateful nature, in this case. When the view is instantiated and renders the HTML output, it stays around for us to use.

By using the declarative events of the view, we have bound the delete link to the view&#8217;s delete method with jQuery. When the link is clicked, the view is still around for us to execute code, and still has a reference to the model that was rendered. This allows us to call \`.destroy\` on the model directly, without having to do any lookups.

### No Breaking Encapsulation To Remove The View

Lastly, we&#8217;re letting the view take care of itself, as it should. When the delete link is clicked and after the model is destroyed, the view closes itself. Notice that we&#8217;re not using a jQuery selector, either. We&#8217;re letting Backbone&#8217;s built in \`.remove\` method handle that for us.

Since the view is handling the destruction of the model &#8211; which is owns &#8211; and itself, there are no encapsulation breaks. Our view can then let itself fall out of scope and we no longer have to worry about any zombie view objects looking for elements that aren&#8217;t around anymore.

### Other Niceties

Beyond the issues that I&#8217;ve addressed, there are additional benefits of building views and delete functionality in this manner. Backbone contains a tremendous amount of power and provides a lot of features for us to take advantage of. Every time we stay within the boundaries that Backbone outlines, it makes it that much easier for us to use the additional features provided to us.

## Where Routing Works With Backbone

There are plenty of examples of where routes work well with backbone, of course. Imagine your building a large website that contains articles, for example. You could try to load all of the articles into the browser, all at once, using Backbone&#8217;s models and collections. It&#8217;s trivially simple to load a Backbone collection, after all. But loading all of these articles into the browser would cause the browser to slow down to a crawl, eat up a ton of memory and possibly crash the browser depending on the quality of browser and memory handling. Whatever the actual effects are, they would likely not be good.

The router is perfect for situations like this. You don&#8217;t need to load all of the articles from the server all at once. Instead, you can use routes to figure out which article the user wants and only load the detail for the one specified from the server or other data store.

## Beyond This Simple Example

I&#8217;ve outlined a very simple example of a route that enabled some functionality while creating a slew of potential problems. This is a very simple example, as well. Imagine what could possibly go wrong if you have a very large Backbone app with nested views and the ability to move forward and backward in those views.

While there are some very distinct advantages of using a router, it should not be our default go-to object to enable functionality. MV* frameworks, like Backbone, give us the opportunity to bridge the gap between the web and the thick clients. We need to take off our stateless-web-server glasses and realize that Backbone opens a world of different principles and patterns. We need to look to the thick-client, desktop and native-mobile-device applications for guidance in some of these areas. Not every pattern we find will apply, of course. But many of them will, and they will help us produce much longer-lasting, maintainable solutions for our interaction-heavy web pages.
