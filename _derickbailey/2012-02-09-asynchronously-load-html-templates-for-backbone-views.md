---
wordpress_id: 805
title: Asynchronously Load HTML Templates For Backbone Views
date: 2012-02-09T09:30:47+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=805
dsq_thread_id:
  - "570114046"
categories:
  - Async
  - Backbone
  - JavaScript
  - JQuery
  - Marionette
  - Principles and Patterns
  - User Experience
---
**UPDATE: It turns out this is a really bad idea. Don&#8217;t async fetch individual templates.**

In the end, having done asynchronous fetching of individual templates on a few productions apps, it&#8217;s a really bad idea. The network latency and multiple requests that are made back to the server destroy any sense of speed or responsiveness that an app may have had, and the additional code that was necessary to do this added more layers of complexity and performance problems.

 

&#8212;

As JavaScript applications become larger and larger, we have to think about the download size, memory usage and other performance constraints for our end users. There are a number of aspects to consider, one of which is how to deliver the HTML templates that your application is using, to the user&#8217;s browser, so that your application can render the templates.

For my smaller applications, I tend to stuff a number of <script> blocks in to the HTML that the user downloads. This makes it easy for me to work with and I don&#8217;t have to worry about whether or not the template exists. But when the number of templates gets to be more than 5 or 6 small ones, this gets out of hand quickly. It makes it hard for me to manage them as I have to scroll through a lot of template code. Putting them in external files and then including them in the page with some server side technology helps the developer problem but it doesn&#8217;t solve the client problem of having to download all of these templates even if they are never used.

To deal with the issues surrounding templates in HTML files, we can split our templates in to separate files and then use asynchronous calls to our server to load them as needed.

## Backbone.View Render Semantics

One of my goals, other than the asynchronous template loading, is to keep the general semantics of a Backbone View&#8217;s \`render\` method. It&#8217;s a short list, but it&#8217;s an important list as most of the Backbone community expects the render method to work this way.

Semantics are generally important as they give us information about how methods and objects are expected to be used, as well. This, in turn, informs the method signature and behavior. And all of this comes back to the [Liskov Substitution Principle (LSP)](http://code-magazine.com/article.aspx?quickid=1001061&page=6) from the [SOLID principles](http://code-magazine.com/Article.aspx?quickid=1001061), which tells us that we need to pay attention to semantics so that we can drop in replacements as needed.

The general semantics and method signature of a view&#8217;s render include:

  * **No parameters**: the render method shouldn&#8217;t require any parameters. You should be able to call \`view.render()\` and have it work fine
  * **Chainable**: the render method should return \`this\` so that it can be chained with other method and attribute calls. This is most commonly done as \`view.render().el\` to grab the element that was rendered to
  * **Populate \`el\`, don&#8217;t replace it**: the render method should populate a view&#8217;s \`el\` with any contents that the view needs to display. It generally shouldn&#8217;t replace the \`el\` as a whole

Aside from these three items, there&#8217;s a lot of flexibility in how a view will typically be rendered. There&#8217;s also plenty of room for interpretation and divergence from this list. Many applications use a render method signature that takes parameters, or that replaces the \`el\` entirely. When changes like this are made, it&#8217;s a good idea to document them so that people will know why the changes are in place.

The benefit of keeping these semantics, though, is that you can swap out a synchronous, pre-loaded template rendering view with a view that uses an asynchronous template loading mechanism. Or, better yet, you can have an intelligent system that uses asynchronous calls to get the template the first time it needs it, and then uses caching to keep the template around and do synchronous rendering on subsequent requests for this view / template. If the semantics for the view are kept in place, it doesn&#8217;t matter how the view implements the rendering. The view can be dropped in or removed as needed, without having to change the surrounding code that uses it.

## Simple Async Template Retrieval

We can keep this very simple, to begin with, using jQuery&#8217;s AJAX calls to load the template with a callback to do the actual rendering after the template is loaded.

[gist id=1752642 file=1.js]

In this example, we&#8217;re assuming that the view has a \`template\` attribute. This attribute represents the file that will be loaded from the server, and that file contain the actual template to be used.

We&#8217;re also using a convention of \`/templates/{name}.html\` for the template location on the server. This can be implemented easily in many different web server technologies. In Sinatra, for example, you can create a &#8220;public/templates&#8221; folder and put your HTML template files directly in that folder. They will be available without having to do anything more than start the Sinatra server.

When the call to \`render\` is made, the code makes an AJAX call back to the server to retrieve the specified template. A callback method is provided &#8211; and at this point, it assumes a successful call to get the template. When the template is returned from the server, the callback is fired, and the standard render code (using jQuery templates in this example) is executed.

Note that the \`el\` for the view is populated inside of the callback, but we are still calling \`return this\` at the end of the function. Even if we chain access to the \`el\` from the \`render\` method and immediately add the el&#8217;s contents to the DOM, this will still work:

> $(&#8220;#content&#8221;).html(view.render().el);

The reason this works is that we are only populating the \`el\` with contents. We are not replacing it. When the AJAX call finally returns with the template, rendering it and populating the \`el\` will show the contents immediately because we&#8217;re setting the \`html\` method of an HTML element that is already attached to the DOM. It&#8217;s as if we had called \`$(&#8220;#content&#8221;).html(&#8220;<div>some html</div>&#8221;);\` directly.

## Caching Templates

Now that we have a template loading asynchronously, it would be nice to only load it once instead of every time it needs to be used. This will improve the overall performance of the application, from the user&#8217;s perspective.

To do this, we&#8217;ll need a little more than just some code in the render method. We want to re-use templates that we&#8217;ve already loaded, which means we can&#8217;t just store the template on the view instance. We need to store it in a place where any view instance can grab a copy of the template if it exists, or have an asynchronous call back to the server done to get the template when needed.

[gist id=1752642 file=2.js]

The template manager object has one primary method that we call: \`get\`. This method takes in a template name to be loaded and a callback method that is executed when the template is found. By using a callback method instead of returning a value directly, we can ensure both synchronous and asynchronous calls will work correctly.

When you call \`get\`, it will check a hash / object literal to see if the template you want is already loaded using the template name that you provide to make this check. If it exists, it executes the callback immediately and passes the template along. If it does not exist yet, an AJAX call is made with jQuery to get the template from the server. Once the template is loaded, the callback that you passed in will be executed and the template is passed to it.

We can now update our view to use the template manager:

[gist id=1752642 file=3.js]

This isn&#8217;t much of a change from the view&#8217;s perspective. It&#8217;s better encapsulated, though, and a little easier to read. The real work is now being done in the TemplateManager object and we can change how it behaves as needed without having to update our views.

## Beyond Simple Caching

There&#8217;s one remaining problem that this code has. If you have multiple instances of a view requesting the same template at roughly the same time, multiple AJAX calls will be made &#8211; one for each instance of the view. The net result is a slowdown in the application&#8217;s performance from too many network calls, and also a visual oddity where the views will appear one at a time as the AJAX calls finish. This can be a pretty big drag on performance and UI responsiveness.

Thanks to some previous digging in to jQuery&#8217;s deferred and some help from Steve Flitcroft ([@red_square](https://twitter.com/#!/red_square)), I was able to solve this problem fairly easily. I put [the following code](https://github.com/derickbailey/bbclonemail/blob/master/public/javascripts/bbclonemail.views.js#L28-52) in to my BBCloneMail app, which uses my [Backbone.Marionette](https://github.com/derickbailey/backbone.marionette) plugin. It&#8217;s not directly implemented in Marionette&#8217;s \`TemplateManager\` but most of what you need is already there. There&#8217;s only a few additional lines of code that you need to make this work.

[gist id=1752642 file=5.js]

The basic idea is that I&#8217;m using a jQuery deferred / promise to fire the callback method from the loadTemplate parameters. To prevent multiple requests for the same template heading back to the server, I&#8217;m caching the promises by the template id. When a call to loadTemplate is made through the template manager, I check to see if I have a promise for that template already. If I do, I register the loadTemplate&#8217;s callback parameter with the promise. If I don&#8217;t, I create the promise and then store it by the template&#8217;s Id. Either way, I register the callback with the promise which [guarantees it will be executed](http://lostechies.com/derickbailey/2012/02/07/rewriting-my-guaranteed-callbacks-code-with-jquery-deferred/). Once the template is returned from the server and the promise is fulfilled (resolved), all of the callbacks are fired off with the template data and everything renders correctly.

Note, though, that this code is not 100% safe. If you call the template manager from code that is already asynchronous, you can end up with a race condition where multiple promises are created and multiple calls to get the template are done. You&#8217;ll still get all of your views rendered just fine, but this will eliminate the benefit of using a promise to reduce network calls. Calling this code synchronously, though, won&#8217;t cause this race condition and the templates will only load once before they are cached and re-used.

<span style="font-size: 18px; font-weight: bold;">See It In Action</span>

If you&#8217;d like to see an example of this code in action (including the deferred/promise code from above), check out my [BBCloneMail](http://bbclonemail.heroku.com/) application and [it&#8217;s source code](https://github.com/derickbailey/bbclonemail). You&#8217;ll see the update to the TemplateManager&#8217;s \`loadTemplate\` function in the code. When you view the live site, switch to the Contacts view and refresh the page. There will be a small delay in the template loading, and then all of the contacts (which all individually requested the same contact template) will all display at once. Subsequent requests to those areas of the app will be cached, of course, improving the user experience and performance even more.