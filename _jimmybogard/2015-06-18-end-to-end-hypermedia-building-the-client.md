---
id: 1132
title: 'End-to-End Hypermedia: Building the Client'
date: 2015-06-18T12:41:30+00:00
author: Jimmy Bogard
layout: post
guid: https://lostechies.com/jimmybogard/?p=1132
dsq_thread_id:
  - "3858746442"
categories:
  - REST
---
Now that we&#8217;ve [built our hypermedia-rich server component](https://lostechies.com/jimmybogard/2015/06/03/end-to-end-hypermedia-building-the-server/ "End-to-End Hypermedia: Building the Server"), we can focus now on the client portion. Building the server piece, while somewhat involved, isn&#8217;t too much different than building a plain JSON API. We had to build a piece to translate our model to a richer hypermedia model, but I don&#8217;t see this as much different than what I have to do with views/templates.

The client is a completely different story. My payloads coming back from the server have a lot of metadata in them, and in order to achieve the loose coupling that REST can provide, my clients have to be driven off of that metadata.

Ultimately, my clients can&#8217;t be completely agnostic of what we&#8217;re doing on the server. A general-purpose client for a standard hypermedia format will look generic and boring. We&#8217;re not trying to build a generic client, we&#8217;re building one for a specific purpose.

In my case, I&#8217;d like to build a basic navigable details screen. Show a table of information, and supply links to drill down into further details.

First, I&#8217;ll need to have some understanding of what the server response looks like. I know I&#8217;ll have a list of instructors, then a list of courses, then a list of students attending those courses. Each of these will be a table, but I want a place to put that table on the screen. For this, I&#8217;ll create divs with IDs that match the RELs of the links in my collection+json response:

[gist id=36c9065e52be149007a4]

When the page loads, I want to kick off the rendering with an initial request:

[gist id=7d6fa3b55e17c95a35a6]

Nothing much going on here, I just call a method &#8220;fetchCollection&#8221;. I pass in the initial URL to hit, and the ID of DIV. The fetchCollection method:

[gist id=564b85f43197b8bf1ad1]

Will make a call to the API, return the result and render the result to the target DIV via the &#8220;renderCollectionJsonTable&#8221; method:

[gist id=6646f29e1b4140cb55b9]

This method is&#8230;quite involved. We&#8217;re trying to render a table, including the header and links. To render the header, I loop through the collection+json data elements and pluck off the prompt for the header text. If the data elements have links, then I render an extra column at the end.

I only render the header once, and since collection+json includes prompt information for every single element in the collection every single time, I have to just pluck off the first item in the collection and render the header row for it (assuming the prompts don&#8217;t change).

For rendering the actual data row, it&#8217;s pretty straightforward to loop through the data items and render the data portion for each one. Finally, if the item has links, I&#8217;ll render all the links together, using the link prompt and rel to indicate where to place the linked data on the screen.

The method to render a table of collection+json data is relatively decoupled from what the collection+data represents. The only real app-specific piece is how to navigate the collections and what to do in each case (render results in a new DIV).

Rendering the table was rather too involved for my taste, and I&#8217;d like to componentize it if I can. In the last post, I&#8217;ll look at using ReactJS to build React components for the different rendering pieces in the table.