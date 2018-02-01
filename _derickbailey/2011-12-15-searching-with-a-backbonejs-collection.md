---
id: 720
title: Searching With A BackboneJS Collection
date: 2011-12-15T08:18:31+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=720
dsq_thread_id:
  - "505389545"
categories:
  - Backbone
  - JavaScript
  - JSON
---
In my last post on composite JS apps, I mentioned needing a search and search results section of my app. I&#8217;m starting off with a very simple search box that will let a user enter a name or description of an item, and the back-end server will return a JSON result set that I display on the screen. Since Backbone can encapsulate all of the server communication for me, I wanted to take advantage of this and set up a Backbone.Collection to do the search.

## Fetch And Url

Calling the \`fetch\` method on a collection will cause the collection to make a call back to the server to retrieve the requested collection. The collection that is returned is determined by the \`url\` attribute of the collection. This attribute can either be a string or a function.

If you&#8217;re dealing with a model and a RESTful back-end, it&#8217;s often easy enough to set the collection&#8217;s url to a string, such as &#8220;/images&#8221;. This would load all of the images from the server, as a JSON document, and populate the collection.

If you&#8217;re doing something more complex and you need to figure out the url at runtime, though, you can set the \`url\` attribute to a function. My search process requires me to pass urls that look like this: &#8220;/items/{search-term}&#8221;, where {search-term} is the actual search term typed in to the search box. To get the url formatted like this, I need to append the search term to a base url string when the \`url\` function is called. Unfortunately, there&#8217;s no way to pass parameters to the \`url\` function. To make this work, then, I rely on my collection to hold the bits of search info that I need and then I have my \`url\` function read them:

[gist id=1481224 file=url.js]

With this function in place, I can create an instance of my collection, set the .searchTerm on it and then call .fetch:

[gist id=1481224 file=manualcall.js]

However, I&#8217;m not very happy with having to remember to do things like this whenever I want to do a search. I would rather have a simple &#8220;search&#8221; method that I can call, which handles all of these details for me.

## Encapsulating Search

To encapsulate the search process, including the creation of a collection, setting the .searchTerm and then calling .fetch, I want to create a function that hangs directly off of the SearchResults collection. This way I can simply call \`SearchResults.search(&#8230;)\` and get a result set back. To do this, I need to use the 2nd parameter of the Backbone.Collection.extend method. This parameter is an object literal, just like the first parameter. But, unlike the first parameter, it adds the functionality you specify directly to the collection&#8217;s constructor function, and not to an instance of the collection.

[gist id=1481224 file=searchresults.js]

Here you can see my SearchResults object with the \`url\` function in the collection instance, and the \`search\` function in the collection definition. I&#8217;ve also added a call to my event aggregator to notify my application when the search results have returned or have produced an error.

## Performing The Search

Now I can call my search and subscribe to the event that tells me when they have returned, so I can display them:

[gist id=1481224 file=search.js]

Of course, I&#8217;m sure there are many other ways of accomplishing the same thing with a Backbone.Collection. This is the solution that I&#8217;m currently using, but I would love to see the solutions that you&#8217;ve come up with for searches. Drop a comment here and let me know how you&#8217;re doing it!