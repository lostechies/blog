---
id: 447
title: Rendering jQuery Templates With Backbone Views
date: 2011-06-20T22:36:59+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=447
dsq_thread_id:
  - "337914457"
categories:
  - Backbone
  - JavaScript
  - JQuery
  - JSON
  - Model-View-Controller
---
In my previous examples of using views with [Backbone.js](http://documentcloud.github.com/backbone/), I showed a simple login form that was built directly in to the page&#8217;s html markup. In a more complex app, you are likely going to load content from a server via ajax / json calls and render that out to the browser all within the backbone / jQuery code. [jQuery&#8217;s template plugin](http://api.jquery.com/jQuery.template/) makes it really easy to render content directly in the browser, and combining that with Backbone makes it even easier to manage.

 

### Render A Template From A View

There&#8217;s a number of different ways to setup an html page so that you can render a template out to it. In this example, I have a div that will display a list of users and a template stuffed into a script block, for jQuery template to use.

[gist id=1037163 file=1-layout.html]

The div starts it&#8217;s life with a fieldset and an unsorted list, but no data in it. When you load this in your browser, you don&#8217;t see anything very interesting or useful:

<img title="Screen shot 2011-06-20 at 10.09.12 PM.png" src="http://lostechies.com/derickbailey/files/2011/06/Screen-shot-2011-06-20-at-10.09.12-PM.png" border="0" alt="Screen shot 2011 06 20 at 10 09 12 PM" width="539" height="62" />

We need to populate this with some information about our users. To get things rolling, we can hard code a few users as json documents and stuff them into a user collection.

[gist id=1037163 file=2-userlist.js bump=1]

Next, we need a view object that represents the list of users on the screen. We can use backbone&#8217;s &#8220;el&#8221; attribute to identify the &#8220;#user-list&#8221; element on the view, and we can provide our own &#8220;template&#8221; attribute that will reference the &#8220;#user-list-template&#8221; template.

[gist id=1037163 file=3-view.js bump=1]

The &#8216;el&#8217; attribute points to our currently empty, unordered list within our &#8216;#user-list&#8217; element. The &#8220;render&#8221; method is used to do the template rendering with the data that we provide the view &#8211; the list of users.

With the view in place, we can put it all together with a call to instantiate the view and pass in the data we have.

[gist id=1037163 file=4-initial-render.js bump=1]

We&#8217;re passing the user list into the user list view with a json document, and an attribute named &#8216;model&#8217;. Backbone recognizes this attribute and assigned the contents of the attribute to &#8216;this.model&#8217; within the view. The call to &#8216;userListView.render()&#8217; method then kicks in the jQuery template and reading the json data from this.model, producing a rendered user list and appending it to the inner html of &#8216;this.el&#8217; &#8211; the unordered list in our &#8216;#user-list&#8217; element.

The end result of this view rendering itself is a list of user names.

<img title="Screen shot 2011-06-20 at 10.50.00 PM.png" src="http://lostechies.com/derickbailey/files/2011/06/Screen-shot-2011-06-20-at-10.50.00-PM.png" border="0" alt="Screen shot 2011 06 20 at 10 50 00 PM" width="539" height="111" />

 

### Side Note On The Render Method

[The backbone documentation talks about the render method](http://documentcloud.github.com/backbone/#View-render) being a built in method in a backbone view that doesn&#8217;t do anything, with it&#8217;s default implementation. That&#8217;s fine &#8211; we may be talking about a template method pattern or something similar in the implementation. However, the presence of this method in the base View, and the documentation for it, are a little confusing to me. I have never seen the render method called for me. In every instance of every view I&#8217;ve built with backbone, I have always had to call the render method myself. If i always have to call it myself, why does it even exist on the base View object and why is it documented as a method that the base View knows about?

 

### Extracting The Render Method

The render method that we provided in this example is very simple &#8211; read the template from the html, render the data from the user list model into it, and append it in to the unordered list. With a small modification, though, we can extract this method into something that is not only simple, but more flexible.

All we need to do is move the &#8216;template&#8217; variable out of the render method and on to the view definition, directly.

[gist id=1037163 file=5-extract-template.js bump=1]

The rendered view is exactly the same. However, we no longer have to re-compile the template every time the view. We also no longer have anything view-specific in our render method. This makes the method a prime candidate for extracting into a base class, for a scenario where you have multiple views on a page &#8211; which is highly likely in a real backbone app.

To extract the &#8216;render&#8217; method, create another view called &#8216;TemplatedView&#8217;. This view will extend the usual &#8216;Backbone.View&#8217; but will only have 1 method in it &#8211; the &#8216;render&#8217; method.

[gist id=1037163 file=6-templated-view.js bump=1]

We also removed the &#8216;render&#8217; method from the &#8216;UserListView&#8217; and changed the object that it extends to the new &#8216;TemplatedView&#8217;. The end result is still the same as we previously had &#8211; a rendered list of user names. However, we now have the ability to re-use the rendering implementation across multiple views in our backbone page. Additionally, the &#8216;UserListView&#8217; has been reduced to 2 lines of configuration. This is much more appealing on a number of fronts.

 

### Overriding Render Without Losing The Templating

There are going to be times where you want to have a view that is rendered with the same templating mechanism, but has additional needs as well. For example, you may need to render a user edit view and need to attach to a &#8216;#save&#8217; and &#8216;#cancel&#8217; button after the view is rendered. In the world of object-oriented languages, you would normally call the super-class&#8217; implementation of the method that you have overridden. The same holds true for javascript, which is an object-oriented language. Unfortunately, javascript makes this a little more verbose than other languages.

[gist id=1037163 file=7-subclass-override.js bump=1]

Since javascript uses a prototype-based object inheritance system, we have to reference the prototype that our view inherits from and &#8216;.call&#8217; the &#8216;render&#8217; method from there. The &#8216;call&#8217; method accepts a parameter that is used as the method&#8217;s &#8216;this&#8217; object. We want to pass the current view into the &#8216;call&#8217; method so that the prototype class can reference the model from the current view. This allows the call to &#8216;TemplateView.prototype.render&#8217; to have access to the user model that the UserEditView instance is currently holding on to &#8211; the user that is supposed to be edited.

Instantiate a UserEditView and pass a user model into it with a &#8216;{model: user1}&#8217; json document, and the end result is our user edit view along side our user list view.

<img title="Screen shot 2011-06-20 at 11.22.50 PM.png" src="http://lostechies.com/derickbailey/files/2011/06/Screen-shot-2011-06-20-at-11.22.50-PM.png" border="0" alt="Screen shot 2011 06 20 at 11 22 50 PM" width="539" height="213" />

Now the instance of the UserEditView has access to the &#8216;Save&#8217; and &#8216;Cancel&#8217; buttons, allowing you to bind jQuery &#8216;click&#8217; events or anything else that you need to do. Toss in a little bit of data-binding code, as well, and we would have a simple form to edit users. I&#8217;ll leave that for another blog post, though.

 

### Download The Code

All of the code that I&#8217;ve written for this example is [available via github gists](https://gist.github.com/1037163). Go grab file numbers 8 and 9 for the final working version, with both the edit form and the list of users.