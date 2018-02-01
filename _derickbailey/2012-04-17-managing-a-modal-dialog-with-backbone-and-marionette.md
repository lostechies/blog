---
id: 891
title: Managing A Modal Dialog With Backbone And Marionette
date: 2012-04-17T07:02:21+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=891
dsq_thread_id:
  - "653060967"
categories:
  - Backbone
  - DOM
  - JavaScript
  - JQuery
  - Marionette
  - Twitter Bootstrap
---
My current client project is using [Twitter Bootstrap](http://twitter.github.com/bootstrap/), and I have to say I&#8217;m loving it. It provides a simple way to get started with common layout and design elements, and includes a handful of UI widgets and features that are easy to use as jQuery plugins. But enough about that… I want to manage a modal dialog that displays my Backbone view, which is a notoriously frustrating problem no matter what UI framework you&#8217;re using, it seems.

## The Problem: Moving DOM Elements

The core of the problem that people run in to when using a modal dialog is that the modal plugin removes the DOM element that wraps the modal, from the DOM. It usually gets added to some special holding location where the modal plugin can guarantee that the element won&#8217;t be visible until the modal dialog is opened. I&#8217;m over-generalizing this a bit, but many of the modal dialogs work this way or in a similar manner.

The problem that this usually causes is that a Backbone view will lose it&#8217;s event handling when the DOM element gets moved around by the modal dialog. When the modal dialog removes the view&#8217;s \`el\` from the DOM, the \`events\` configuration is lost because the DOM element has been moved or removed from the DOM and jQuery had to let go of the events. When the \`el\` is re-added to the DOM for displaying it as a modal, then, the \`events\` are not re-attached.

This is usually caused by a developer using the Backbone view itself as the modal dialog &#8211; which is not what you want to do.

## The Solution: Don&#8217;t Modal A Backbone View

No, really. That&#8217;s the solution.

I&#8217;m not saying you can&#8217;t use a Backbone view in a modal. I&#8217;m saying you shouldn&#8217;t try to modal the view itself. Instead, you should create a simple wrapper div for the modal plugin to use and then populate the contents of that div with the view&#8217;s \`el\`.

Let&#8217;s see an example of a Twitter Bootstrap modal dialog, displaying a Backbone view. First, the HTML and Underscore template:

[gist id=2359717 file=1.html]

Note that I have a &#8220;<div id=&#8217;modal&#8217;></div>&#8221; in there. This is explicitly for the Twitter Bootstrap modal dialog to use. This div is the modal. There&#8217;s no content in it, though. I will supply the content for the modal through a Backbone view, which looks like this:

[gist id=2359717 file=2.js]

How easy is that? I&#8217;m just rendering a view like I always do, stuffing the view&#8217;s \`el\` in to the &#8220;#modal&#8221; div, and then calling \`.modal\` on the jQuery selector object. And that&#8217;s it. My modal is done and my view&#8217;s \`events\` will still work.

## Managing A Modal With Backbone.Marionette

Yes, it always comes back to my [Marionette plugin](https://github.com/derickbailey/backbone.marionette), right? 🙂

In this case, I want to manage my modal dialogs as I do any other area of my screen. I want a single object that keeps track of what view is currently displayed within the modal, handles rendering it that view for me, calls the \`.modal\` dialog method for me, and correctly closes the modal when the &#8220;cancel&#8221; or &#8220;close&#8221; button on my view is clicked.

This largely sounds like a Region object in Backbone.Marionette: a way to manage the contents of a particular DOM element, by rendering and displaying a Backbone View in to that DOM element. Only in this case, it&#8217;s a very specialized Region that needs to manipulate the DOM element as a Twitter Bootstrap modal.

To do this, I&#8217;m going to take advantage of Marionette&#8217;s &#8220;Region&#8221; and extend it with the behavior that I need for managing the modal:

[gist id=2359717 file=3.js]

This is honestly more code than I wanted to write. There&#8217;s a few things that I need to clean up and add in my Region object to make this a little more elegant. But, it works! And that&#8217;s the important part.

The \`constructor\` function listens to the region&#8217;s &#8220;view&#8221;show&#8221; event, which is fired when a view&#8217;s contents are populated in to the \`el\` of the Region. In the event handler for this, I&#8217;m calling the \`modal\` plugin method on the \`el\` of the region.

I&#8217;m also setting up a &#8220;close&#8221; event handler on the view itself at this point. That way when I close the view from within my view&#8217;s code (a cancel button, or otherwise), the modal will shutdown. The handler for this simply hides the modal using the modal&#8217;s &#8216;hide&#8217; option.

As I said before, I want to reduce the amount of code that is required to make this happen. But for now, this is a functional modal dialog region. I&#8217;m using it in my application, like this:

[gist id=2359717 file=4.js]

Note that I&#8217;m registering my ModalRegion object in my Marionette.Application with my other regions. Instead of passing in a DOM selector, though, I passing in the ModalRegion type.

## More Than Just Twitter Bootstrap

The examples I&#8217;ve shown here cover the use of Twitter Bootstrap, but are applicable to more than that. You should be able to easily modify the ModalRegion object to work with any JavaScript modal dialog. I&#8217;ve used the same basic solution for [jQuery UI modals](http://jqueryui.com/demos/dialog/), and I expect that [KendoUI](http://demos.kendoui.com/web/window/index.html) and other modals would work in a similar manner as well (though I may be wrong about that).

The best part about this is that you&#8217;ll only need to modify the region object. You shouldn&#8217;t have to worry about changing your entire application to use a different modal system, because we&#8217;ve encapsulated the modal system in to our ModalRegion object, and our application makes use of that to display the modal dialog with any Backbone.View that we want.