---
wordpress_id: 438
title: 'Solving Backbone&#8217;s &#8220;this.model.view&#8221; Problem With Underscore.js'
date: 2011-06-15T20:59:16+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=438
dsq_thread_id:
  - "333542687"
categories:
  - Backbone
  - JavaScript
  - JQuery
  - Model-View-Controller
---
In my last post, I briefly touched on a small problem in the relationship between the view and the model. Here&#8217;s the relevant code, again:

{% gist 1028505 1-theproblem.js %}

 

This is some awful code, honestly. I didn&#8217;t like it when I first wrote it, and I still don&#8217;t like it. It coupled my view and my model together in ways that I don&#8217;t like. It broke the Law of Demeter. It also confused me &#8211; why would the &#8220;validated&#8221; method of the view execute in the context of the model?! This method is clearly not on the model&#8230; but &#8220;this&#8221; always evaluated as the model, not the view.

 

### Understanding This Problem

I&#8217;ve read about &#8220;this&#8221; in javascript a number of times. It represents the current scope of the code that&#8217;s executing, similar to &#8220;self&#8221; in ruby or &#8220;this&#8221; in C#. Like ruby and c#, javascript has some interesting rules about what &#8220;this&#8221; evaluates to depending on when and where you are executing code. In effect, &#8220;this&#8221; can change at times that you wouldn&#8217;t expect based on closures, callback methods, and other code that can modify the scope of the executing code.

Look at the following code for some examples of when you might expect &#8220;this&#8221; to be something other than what it actually is.

{% gist 1028505 2-thereisnospoon.js %}

 

And here&#8217;s the html to run this:

{% gist 1028505 3-thereisnospoon.html %}

 

Before you continue on to the next images, try to imagine what you&#8217;re going to see when you run this code in your browser. Load the page and watch the first two alert boxes go by, then type some text into the input box and tab or click out of it to see the third alert box. Here&#8217;s the results, in order:

<img title="Screen shot 2011-06-15 at 9.17.36 PM.png" src="http://lostechies.com/content/derickbailey/uploads/2011/06/Screen-shot-2011-06-15-at-9.17.36-PM.png" border="0" alt="Screen shot 2011 06 15 at 9 17 36 PM" width="459" height="193" />

<img title="Screen shot 2011-06-15 at 9.17.49 PM.png" src="http://lostechies.com/content/derickbailey/uploads/2011/06/Screen-shot-2011-06-15-at-9.17.49-PM.png" border="0" alt="Screen shot 2011 06 15 at 9 17 49 PM" width="503" height="208" />

 <span style="white-space: pre;"></span><img title="Screen shot 2011-06-15 at 9.18.11 PM.png" src="http://lostechies.com/content/derickbailey/uploads/2011/06/Screen-shot-2011-06-15-at-9.18.11-PM.png" border="0" alt="Screen shot 2011 06 15 at 9 18 11 PM" width="507" height="218" />

What did you expect to see in each of the alert boxes? What did you actually see? Personally, I expected all three text boxes to show me &#8220;foo&#8221;&#8230; or maybe the first one should have shown &#8220;foo&#8221;&#8230; but only 1 of the three did &#8211; the second call directly to &#8220;someView.showIt();&#8221; ?! So, what&#8217;s going on here? Why is this not behaving the way that you would expect? The answer is in the scope of &#8220;this&#8221;.

When the first call to someModel.raiseIt(&#8220;foo&#8221;); is executed, the event &#8220;someEvent&#8221; is raised. The view has bound to it&#8217;s showIt method as an event handler for this event, so the showIt method is called. However, the method is not called by the view. It&#8217;s called by the model object. Notice on line 16 of the sample code that the event binding is happening by calling the model&#8217;s bind method. We&#8217;re effectively telling the model &#8220;when &#8216;someEvent&#8217; fires, call the showIt method from the view class&#8221;. This is a closure in action, combined with a function pointer, to make it all work. The end result is that when showIt does execute, &#8220;this&#8221; is not the view, it&#8217;s the model. Since &#8220;this&#8221; is the model, &#8220;this.model&#8221; is comes back as undefined, though i would have expected it to come back as the model that is attached to the view.

When the next call to someView.showIt(); is executed, the message box shows us the &#8220;foo&#8221; data that the previous line had supplied to the model. This really truly baffled me when I first ran my own example code &#8211; no joke. I thought I had set something up wrong. As it turns out, it&#8217;s correct. Since we are calling someView.showIt(); directly on the view, the scope of &#8220;this&#8221; evaluates to the view which means &#8220;this.model&#8221; evaluates to the model correctly. Since we had previously set the model&#8217;s &#8220;data&#8221; to &#8220;foo&#8221;, evaluating &#8220;this.model.get(&#8216;data&#8217;)&#8221; correctly gives us the value of &#8220;foo&#8221;.

You may be able to figure out what&#8217;s happening with the input box text change, by now. We&#8217;re using JQuery to bind to the text box&#8217;s change event on 17 of the example code. When you type something into the text box and tab or click out of it, JQuery is firing the showIt method for us. JQuery, as you may have guessed, provides it&#8217;s own scope for the method&#8217;s execution &#8211; the selected element. So, when JQuery fires the event, the scope of &#8220;this&#8221; is the text box itself, which means &#8220;this.model&#8221; will be undefined.

But there&#8217;s hope!

 

### Underscore.js To The Rescue!

Backbone is built with the Underscore.js library. This little library provides a lot of functionality for Backbone&#8217;s models, collections, view, controllers, etc. One of the things that it provides is the &#8220;_.bindAll&#8221; method, which as it turns out, is our savior to make the showIt method behave consistently.

The Backbone documentation has a brief discussion on [Binding &#8220;this&#8221;](http://documentcloud.github.com/backbone/#FAQ-this). It&#8217;s worth reading this section to see what Backbone has to say. The gist of it is that &#8220;_.bindAll&#8221; will allow you to change the context in which a method is fired, so that the scope of &#8220;this&#8221; is changed to any object you want. What this means for us, is that we can tell our view to always execute shotIt with &#8220;this&#8221; scoped to the view! Best of all, it&#8217;s a one line change:

{% gist 1028505 4-bindall.js %}

 

Line 2 was added to the initialize method of our view, to bind the view as the context in which showIt is executed. This gives us the view as &#8220;this&#8221; in the showIt method, and our problems are magically solved! Now when we execute the script again, we get the following results:

<img title="Screen shot 2011-06-15 at 9.42.01 PM.png" src="http://lostechies.com/content/derickbailey/uploads/2011/06/Screen-shot-2011-06-15-at-9.42.01-PM.png" border="0" alt="Screen shot 2011 06 15 at 9 42 01 PM" width="466" height="192" />

<img title="Screen shot 2011-06-15 at 9.42.14 PM.png" src="http://lostechies.com/content/derickbailey/uploads/2011/06/Screen-shot-2011-06-15-at-9.42.14-PM.png" border="0" alt="Screen shot 2011 06 15 at 9 42 14 PM" width="514" height="210" />

<img title="Screen shot 2011-06-15 at 9.42.32 PM.png" src="http://lostechies.com/content/derickbailey/uploads/2011/06/Screen-shot-2011-06-15-at-9.42.32-PM.png" border="0" alt="Screen shot 2011 06 15 at 9 42 32 PM" width="480" height="218" />

These results finally make sense!

The first call sets the model&#8217;s data to &#8220;foo&#8221;, which is then shown to us. The second call doesn&#8217;t change the data, it just calls the showIt method directly, which shows us &#8220;foo&#8221; again. The third call &#8211; facilitated by the change event from the input box &#8211; doesn&#8217;t change the model&#8217;s data either, so when showIt it called for a third time, &#8220;foo&#8221; is shown to us for a third time.

 

### Fixing this.model.view and this.view.loginButton

Now that we understand what&#8217;s really going on, we can finally get back to the original login example and fix it.

{% gist 1028505 5-fixingtheloginview.js %}

 

There&#8217;s only a couple of changes we made to the view. We added line 2 to bind the view as the validated method&#8217;s scope. We removed the line that assigned &#8220;this.mode.view = this;&#8221;. And then in the validated method, we changed &#8220;this.view.loginButton&#8221; to &#8220;this.loginButton&#8221; because &#8220;this&#8221; is now the view, which has our login button!

Our sample application still works the way we expect, but we&#8217;ve now cleaned up the coupling issue between the view and the model, fixed the Law of Demeter violation, and generally made the code more consistent in behavior by ensuring that the validated method always executes in the scope of the view.

 

### Update: How _.bindAll Works

Matt Shannon [sent me a note via twitter](https://twitter.com/#!/dmshann0n/status/81197632470523905), providing me with a few links that describe how the javascript language lets the _.bindAll method work. Of course, this isn&#8217;t a breakdown of the bindAll method itself, but they&#8217;re the underlying language features that enable it.

  * apply: <https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Function/apply>
  * call: <https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Function/Call>

Thanks, Matt!
