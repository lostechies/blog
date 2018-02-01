---
id: 837
title: Handling DOM Events With EmberJS Views And Controllers
date: 2012-02-22T07:45:21+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=837
dsq_thread_id:
  - "585321956"
categories:
  - DOM
  - Ember
  - JavaScript
  - JQuery
  - Model-View-Controller
  - Model-View-Presenter
---
{% raw %}
Hot on the heels of [picking up Ember and starting to learn it](http://lostechies.com/derickbailey/2012/02/21/emberjs-initial-impressions-compared-to-backbone/), I think I&#8217;ve actually learned something useful! I certainly hope I have, at least. Otherwise, [I&#8217;m going to be in trouble soon](http://wekeroad.com/2012/02/21/alt-tekpub-a-transparent-learning-process/).

In my EmberCloneMail app, I have an <ul> tag with <li> tags that represent the list of emails you can click on and view &#8211; and that&#8217;s precisely the problem I ran in to. How do I handle a DOM &#8220;click&#8221; on each of the <li> elements, and know which of the Email objects is the one being clicked? Of course I know [how to do this in Backbone](http://lostechies.com/derickbailey/2011/10/11/backbone-js-getting-the-model-for-a-clicked-element/) already and I expected it to be as easy in Ember. It is just as easy &#8211; it&#8217;s just different and presents some options not available in Backbone.

## The View And Template Setup

The basics of getting this set up are the same no matter how I decide to handle the specific click. There will be some details of this that change with the different options, but this is a good starting point to render the view with a template.

The Handlebars template for the list and items looks like this:

[gist id=1880628 file=2.html]

Note that there&#8217;s two templates in this &#8211; one of the <ul> and the &#8220;collection&#8221; information, and one for individual <li> items that represent the emails I&#8217;ll be displaying. This follows the same idea that I&#8217;ve talked about with Backbone&#8217;s collection / child rendering, but it puts the loop directly in the template instead of in the JavaScript view object.

The Ember view then looks like this:

[gist id=1880628 file=1.js]

There are also two views &#8211; one for the <ul> list and one for each of the <li> items.

You can either use another Handlebars template block to render the list in to the HTML directly, or use JavaScript to instantiate, render and display the view in the right spot. How you do that makes no difference in handling the DOM clicks.

## Option 1: Let The View Handle It

This is pretty much &#8220;the Backbone way&#8221; and it can be done in Ember in much the same manner. In the view, you add a &#8220;click&#8221; method and it receives the standard jQuery &#8220;events&#8221; argument for jQuery DOM events.

[gist id=1880628 file=3.js]

From there, you can do things as you would expect &#8211; manipulating the view, manipulating the model and generally getting on about the job of working with the view and model. This is very much the &#8220;presenter&#8221; approach to view objects, creating the vertical path between Model -> Presenters -> View (HTML in this case) in an MVP style.

The problem with this approach is that it pretty listens to all of the clicks for any HTML element within the view template. If you have a very simple template and you want the click to behave this way, it works out well. But if you want to listen to a click on a specific element within the view, that&#8217;s where the next option comes in to play.

## Option 2: {{action}} Helpers

Handlebars lets you register view helper functions that can pretty much do anything you want. One of the helpers that comes with Ember is the {{action}} function that let&#8217;s you specify a method on your view to handle on a DOM event.

[gist id=1880628 file=4.html]

In this case, we&#8217;re putting the {{action}} on the &#8220;from&#8221; portion of the view, so that when you click the email sender&#8217;s name it will be handled by the view. Like the first option, the methods that you specify with an {{action}} are methods on the view, directly:

[gist id=1880628 file=5.js]

You can also specify a different view to handle the event using {{action target=&#8221;someOtherView&#8221;}} in the template.

The benefit here, as stated above, is that you can handle any DOM event you want with any method in the view that you want. This is largely the functionality as Backbone&#8217;s declarative &#8220;events&#8221; hash on a view, but has the added advantage that you can target a different view. You&#8217;re also specifying this in the template directly &#8211; which may or may not be an advantage, depending on your perspective.

## Option 3: Targeting A Controller Action

In looking through some of the example apps, I noticed that the several of the views included sub-view rendering of &#8220;Ember.Button&#8221; in order to create a button on the screen. These sub-views were then told to target a specific controller and action for the clicking of the button. I thought this sounded like a pretty cool option and I wanted to see what it would take to make my EmailPreview view work this way. Turns out, it was very easy.

I found [the Ember.Button view in the source code](https://github.com/emberjs/ember.js/blob/master/packages/ember-handlebars/lib/controls/button.js) with the help of Github&#8217;s awesome search feature (just hit &#8220;t&#8221; and then start typing. It will find file names in the current repo for you). From that code, I learned about the [Ember.TargetActionSupport](https://github.com/emberjs/ember.js/blob/master/packages/ember-runtime/lib/mixins/target_action_support.js) object. This is the object that let&#8217;s you specify the controller and action to target when you are setting up the view render in Handlebars templates.

To get your view to work with this, just extend the view with this object:

[gist id=1880628 file=6.js]

Then in your templates, when you call in to this view, you specify the target controller and action:

[gist id=1880628 file=7.html]

To finish this out, you need to handle the DOM event that will trigger the controller / action the way you would use option #1 above. In my case, I added a &#8220;click&#8221; method. Within this method, you call out to the target action:

[gist id=1880628 file=8.js]

The benefit in this case is that you can re-use a view and template across multiple behaviors in your app. When you specify which view you are rendering in the template, you tell it which controller and action to use. Therefore, when you are using the same view in multiple places, you can target different controllers and actions, based on what&#8217;s appropriate for the current use.

The drawback to this, though, is that you&#8217;re just about limited to a single controller and action target. This makes more sense when you consider that an HTML button typically only has the one click event. In the case of an HTML <li> like I&#8217;m using, it might not make quite as much sense to limit  your template and view to a single action. My use case called for this, though. I want to handle the click of the <li> and only the click of the <li>, so I was able to properly use the TargetActionSupport correctly.

## Option ???: Something Else ???

At this point, I&#8217;ve identified these three options for handling a DOM event. There&#8217;s obviously a lot of flexibility available, here. You aren&#8217;t stuck with one way to handle a DOM event when a given scenario may call for something different.

Are there any other options (other than handling the click w/ plain jQuery)? What am I missing?
{% endraw %}
