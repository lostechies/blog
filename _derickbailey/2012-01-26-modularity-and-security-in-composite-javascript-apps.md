---
wordpress_id: 782
title: Modularity And Security In Composite JavaScript Apps
date: 2012-01-26T07:44:16+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=782
dsq_thread_id:
  - "553313488"
categories:
  - Backbone
  - Composite Apps
  - JavaScript
  - Marionette
  - Security
---
In one of my current apps for a client, I have [an activity based security system](http://lostechies.com/derickbailey/2011/05/24/dont-do-role-based-authorization-checks-do-activity-based-checks/) that determines what the user is allowed to do. The trick to this system is that all of the authorization checks happen on the server, but the functionality that is being secured runs on the client, in JavaScript.

This is a bit of a problem. If I send all of the JavaScript that is uses to run any part of the system to the browser, then it&#8217;s possible that a clever user could enable it and do things they aren&#8217;t supposed to do. Of course, when they send a request back to the server, the server will verify they can do what they requested and block it… but the user should not be able to even try to do things they aren&#8217;t authorized to do, in the first place.

The solution that I&#8217;ve come up with, at a very high &#8220;functional area of the application&#8221; level, is simply not to send JavaScript to the browser if the user is not allowed to use it. This keeps me from having to do extra security checks in the browser, keeps the download for the user smaller and generally makes the app appear snappier because there is less code to run. More importantly, though, it keeps the user from being able to try things they can&#8217;t do.

## Modules To The Rescue

I&#8217;m facilitating this through the use of modules in my JavaScript &#8211; both &#8220;module&#8221; as in the JavaScript module pattern, and &#8220;module&#8221; as in a packaged functional area of an application.

It&#8217;s worth noting, though, that I&#8217;m not using AMD (asynchronous module definitions), RequireJS, or any other &#8220;module&#8221; framework for JavaScript. The debate about the &#8220;right way&#8221; to do modules can rage on all it wants. I&#8217;m content with simple immediate functions and logical groupings of files while the more intelligent and invested people in the JS community figure that all out.

Each of the functional areas of my application is built in it&#8217;s own set of files. Each area has multiple files that it is composed within, but the files are grouped together for easy identification of what makes up a module. I also have an HTML template for each module which provides the needed <script> tags to include the code for that module.

## Only Render What Is Needed

When I need a functional area of my site to be sent down to the user, I tell my server side template language to include the correct HTML file. For example, I&#8217;m doing this in an ASP.NET MVC application:

{% gist 1680805 1.cshtml %}

In this code, I&#8217;m checking to see if the current user is allowed to manage locations. If they are, the extension method &#8220;LocationManagementScripts&#8221; is called. This in turn renders the &#8220;LocationManagementScript.html&#8221; file at this point in my HTML layout. That file contains all of the <script> tags for the location management JavaScript app. In the same way, I&#8217;m checking to see if the user can search through locations, and running the same basic process if they can.

## Self-Initializing Modules

When a functional module is included after passing one of these checks, it needs a way to get itself spun up and started so that it can do it&#8217;s magic. It may need to render something on to the screen. It may need to register itself with the application&#8217;s [event aggregator](http://lostechies.com/derickbailey/2011/07/19/references-routing-and-the-event-aggregator-coordinating-views-in-backbone-js/), or any of a number of other things. This is where my [Backbone.Marionette](https://github.com/derickbailey/backbone.marionette) add-on comes in to play for my Backbone apps.

Marionette has an explicit concept of an &#8220;initializer&#8221; tied to it&#8217;s Application objects. When you create an instance of an Application object, you can call &#8220;app.addInitializer&#8221; and pass a callback function. The callback function represents everything that your module needs to do, to get itself up and running. All of these initializer functions &#8211; no matter how many you add &#8211; get fired when you call &#8220;app.start()&#8221;.

{% gist 1680805 2.js %}

Each functional area of my application has it&#8217;s own initializer function. When a functional area has been included in the rendered <script> tags, the initializer gets added and when the &#8220;start&#8221; method is called, the modules for that functional area are fired up and they do there thing.

## A Composite App, And Sub-Apps

One of the tricks to making all of this work, is that I need to have a primary &#8220;app&#8221; object that all of my modules know about. In the above example, the &#8220;myApp&#8221; object is this. Each of the modules for each of the functional areas has direct knowledge of this object and can call public APIs on it &#8211; including the &#8220;addInitializer&#8221; method.

A better example of what a module definition and initializer might look like, would be this:

{% gist 1680805 3.js %}

In this example, I&#8217;m using the simple JavaScript module pattern to encapsulate my search functionality. I&#8217;m also providing an initializer for the module that instantiates a search view and shows it to the user using a [region manager](http://lostechies.com/derickbailey/2011/12/12/composite-js-apps-regions-and-region-managers/).

Each of these functional areas is basically a sub-application. Many sub-applications are used to compose a larger application and overall experience for the user. The composition of a larger application through various modules that are included / excluded based on some criteria are what really make this a composite application.

I also included the final call to &#8220;myApp.start()&#8221;, showing that I do this from my main HTML page and not from my JavaScript files. This provides a single point of entry for all of the registered modules, no matter which modules are registered. The &#8220;myApp&#8221; object really doesn&#8217;t care which modules are registered, honestly. It doesn&#8217;t need to care. It only needs to execute the initializers that happen to be present. If none are present because the user didn&#8217;t have permission to do anything, then nothing happens when this method is called and the user won&#8217;t see anything.

## Security: Don&#8217;t Let Them See It If They Can&#8217;t Do It

If the security check to see if the user is allowed to use the location search feature fails, the rendered HTML won&#8217;t include the <script> tags for the &#8220;locationSearch.js&#8221; file. If this file is not sent down to the browser, then it will never register itself. If a module has not registered itself for initialization, it&#8217;s views won&#8217;t show up on the screen and the user won&#8217;t be able to try and use the feature. Further, the user won&#8217;t be able to &#8220;view source&#8221; on the page and find any stray JavaScript that they shouldn&#8217;t be able to use.

## It&#8217;s Not Always That Easy

Of course there are other security concerns that are not this simple. When a functional area is closed off by authorization, it&#8217;s easy to keep things clean like this. We can compose the application at run time simply by including the right files and letting the code in those files register themselves for initialization. But when we have a functional area of the system that has finer grained authorization and permissions associated with it, things get a little more tricky.

I&#8217;m still learning and exploring this space. I have some ideas and am going to be implementing some of them soon. If anyone out there has any experience in handling finer grained security needs in JavaScript apps, I&#8217;d love to hear about it. Post links to your favorite resources for this, in the comments.

 
