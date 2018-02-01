---
id: 525
title: 'Don&#8217;t Execute A Backbone.js Route Handler From Your Code'
date: 2011-08-28T22:14:47+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=525
dsq_thread_id:
  - "398624206"
categories:
  - Analysis and Design
  - AntiPatterns
  - Backbone
  - JavaScript
  - Model-View-Controller
  - Principles and Patterns
---
I was working on a sample Backbone.js application and I ran into a scenario that seemed like it should have been simple on the surface, but was causing me a tremendous amount of headache. Here&#8217;s the basic functionality that I was trying to achieve:

  * Have a list of items displayed on the screen
  * When an item is clicked: 
      * the item is highlighted
      * the application routes to the item&#8217;s view url

This sounds like a fairly trivial list of requirements, right? I thought so, too, until I started got down into the weeds of the implementation. For the sake of this blog post, let&#8217;s say the application is a … blog. The list of items is a list of blog posts, and clicking on a blog post will highlight the post title in the list, and then display the contents of the post, etc.

### A Quick Note On Event-Driven Architecture

I&#8217;m a follower of the philosophy that a backbone.js application is an event-driven application that responds to changes in the state of our models. That is to say we don&#8217;t want to have our views manipulating themselves and referencing / controlling each other directly. Rather, we want to have our views call methods on our models that manipulate the state of our models. In response to the state of our models changing, our application does things. This could be updating some visual element, routing to a new hash fragment, and/or anything else we can do in a web page.

To facilitate this philosophy, I use a lot of events in my application design &#8211; but not just model events. I rely heavily on application level events, too. Before you go on, it&#8217;s worth your time to b familiar with the use of an event aggregator to facilitate application level events. [I&#8217;ve blogged about using an event aggregator with backbone.js in the past](http://lostechies.com/derickbailey/2011/07/19/references-routing-and-the-event-aggregator-coordinating-views-in-backbone-js/), and you should read that first, if you haven&#8217;t done so already.

### The First Implementation

In the first implementation of my requirements, I implemented the links to the blog posts not as hash fragment <a href> links directly, but as events handled by a view, which tell the model it was &#8220;selected&#8221;, triggering a &#8220;post:selected&#8221; application event which is handled by a method that called router.navigate. At a high level, here&#8217;s what that code looks like (I&#8217;ve left out a lot of detail from this code, to only show the important parts).

[gist id=1177645 file=1-firstimpl.js]

From what I&#8217;ve seen, this code is an example of how a lot of people are using a router to navigate directly to a url fragment instead of having an <a href> link that points directly to the hash fragment. Sure, I&#8217;m adding a few layers of indirection with my events in order to support the philosophy I want, but the end result is the same: click a link that is handled by a backbone view and (eventually) the router is triggered, to navigate to the right place.

### The Problem(s)

Honestly, there are a lot of problems with this code and with the idea of having a view call router.navigate in order to fire off the route&#8217;s handler method and display something (even if the router is called through a few layers of indirection). I could talk about coupling, encapsulation and other issues. However, there&#8217;s one very important functional problem, from the user&#8217;s perspective, that I want to focus on.

When the user clicks a post in the list, the click causes the model to become selected (line 35) which highlights the item in the list (line 22, 25-30). It also causes the router to navigate to a url hash fragment that will display the post by retrieving it from the list of posts and displaying it (line 4, 12, 55, 44). However, when a user navigates directly to the post url hash fragment by pasting it into the browser&#8217;s location, clicking a link from somewhere else on the web, or otherwise heading directly to it, the &#8220;selected&#8221; code is never fired.

You might think that it would be easy to fix this, like I thought. You can just add &#8220;post.select()&#8221; to line 46 (right after &#8220;var post = …&#8221; in the &#8220;showPost&#8221; method of the router) and everything will work, right? This will cause the model to be selected which will highlight the post in the list of posts. I did this at first, and I thought it was working. But there&#8217;s another set of problems that arise because of this.

When the router fires the showPost method for the first time, calling the model&#8217;s &#8220;select&#8221; method will eventually cause the event aggregator to fire the &#8220;post:selected&#8221; event which will then call the router.navigate to try and navigate to this url hash fragment again. Fortunately for us, the router is smart enough to know that it&#8217;s already sitting on that url hash fragment and it won&#8217;t fire the route&#8217;s handler again.

In addition, when we click the post from the list, having the router.navigate method called to set the url hash fragment and execute the router handler, we are duplicating some things in our process. First, the post is already loaded up in memory &#8211; we clicked on it after all (this may not be an issue in some systems, though. Perhaps it was only a PostPreview model that was bound to the list). Secondly, the post was already selected. Firing the route handler causes the post to be selected again, even though it&#8217;s already selected. If the application has some visual styling or behavior that is fired when the post is selected &#8211; my application slides things in / out &#8211; then you end up with duplicated effects and strange visual issues.

Of course, the end result is what we want &#8211; we have a highlighted post in the list and we have the post being displayed. However, I&#8217;m not happy with what we had to do in order to get to this point. I&#8217;m sure the users won&#8217;t be happy either, when they see the double-slide-in visual issue caused by the post being selected twice. Yes, there are some workarounds for the double-select, such as ensuring the post can only be selected if it&#8217;s not currently selected. However, this sort of &#8220;gate&#8221; is only a workaround and not really an elegant design or solution.

A good design and implementation, in my mind, would avoid these types of problems entirely. We wouldn&#8217;t have to put in checks to make sure we&#8217;re only selecting an item that isn&#8217;t currently selected. We wouldn&#8217;t have to worry about calling select twice because our app wouldn&#8217;t do that. We wouldn&#8217;t have to worry about strange doubled-up visual effects, or hitting a route twice, any of the other issues that i&#8217;ve describe, or any of the other issues such as coupling and encapsulation that I haven&#8217;t described. This, however, is not a good design.

### The &#8220;AHA!&#8221; Moment Regarding Router.Navigate&#8217;s Second Argument

The documentation for backbone describes the second argument for the router.navigate method as a way to trigger or not trigger the route&#8217;s handler method. In the past (and very recently) I&#8217;ve been really frustrated by the default of this second argument being &#8220;false&#8221;. That is, if you do not pass a second parameter to router.navigate, the url hash fragment and browser history will be modified but the route&#8217;s handler method will not be called. If you want the handler method to be called, you must pass true as the second parameter.

Why?! When would you ever want to call router.navigate and not have it call the route&#8217;s handler method?! And then it hit me like a brick wall that had been standing there the whole time, only I wasn&#8217;t paying attention and didn&#8217;t see it until I had already smacked into it: most of the problems that I was having were caused by the eventual call to the router.navigate, passing true as the second argument.

### A Better Implementation

I decided to try out a different implementation, then. Rather then have my application eventually call the router.navigate in order to fire the route&#8217;s handler method, I would instead have my application respond to the change in state in order to show the selected post. Then I could call router.navigate without the second parameter. This would update the url&#8217;s hash fragment and browser history, but it wouldn&#8217;t fire the route handler and I would avoid a lot of the problems that I was currently working around. I also need to allow the router to still work when a user gets a link from somewhere else, or types the url w/ hash fragment directly into their browser, etc. If I was going to facilitate both of these scenarios, then I would need a common chunk of code that could be called from either entry point.

Armed with this idea, I came up with a new implementation that looked more like this:

[gist id=1177645 file=2-betterimpl.js]

Notice that there are very few changes in this implementation. We&#8217;ve introduced a BlogController object &#8211; which, by the way, does not extend any backbone class because it does not need to &#8211; that removes the logic to display a post from the router (good encapsulation / single responsibility, etc). We&#8217;re no longer passing true as a second argument to the router.navigate function, in our handler for the &#8220;post:selected&#8221; event. And, the show post route&#8217;s handler method is not directly calling any view logic. Instead, the router is simply setting the state of the post by calling the post.select() method. From there, the standard logic to respond to the application&#8217;s state change kicks in, and the post is displayed.

Now, I know that calling &#8220;pos.select()&#8221; from within the route&#8217;s handler will still cause the router.navigate to fire. Once again, though, the router is smart enough to not do anything since we&#8217;re telling it to navigate to the hash fragment that we&#8217;re already on. This code isn&#8217;t &#8220;perfect&#8221;… but it&#8217;s still far better than what we started with.

### Learning A Lesson About Router.Navigate

A router serves two purposes in a backbone app. The first purpose is to be a clean entry point for urls with hash fragments that are entered directly into the address bar of a browser, or clicked as links from external sites. The second is to manage the history of the browser, as your application moves between pages. Don&#8217;t mix these two things together. You shouldn&#8217;t be executing the route&#8217;s handler from within your application, most of the time.

Sure, you will need to call router.navigate to set the url fragment to an appropriate value at times, but you should listen to the defaulted second argument value and ask yourself if you really need to override this or not.

<span style="font-size: 14px; font-weight: bold;">Don&#8217;t Fire Route Handler Methods From Within Your App</span>

In all but the smallest of sample applications and special cases where there simply is no alternative that could cause the app to function correctly, I say the default value of &#8220;false&#8221; is the correct value for the second argument of router.navigate. By removing the &#8220;true&#8221; argument from the call to router.navigate, I was forced to find a different way to enable my application&#8217;s functionality. In this case, the introduction of a &#8220;controller&#8221; object (which has been greatly simplified for this blog post) allowed me to keep my code well encapsulated and provide a single logic path for the selection and display of a post.