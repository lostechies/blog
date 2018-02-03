---
wordpress_id: 417
title: 'Intro To Backbone.js: How A Winforms Developer is At Home In Javascript'
date: 2011-06-14T23:10:35+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=417
dsq_thread_id:
  - "332620677"
categories:
  - Backbone
  - Design Patterns
  - JavaScript
  - JQuery
  - Model-View-Controller
  - Model-View-Presenter
---
Today, I was introduced to Backbone.js and I almost immediately fell in love with it. It&#8217;s powerful. It&#8217;s elegant. But most of all, it&#8217;s a set of design and interaction patterns that I have a lot of experience using.

[<img title="NewImage.png" src="http://lostechies.com/derickbailey/files/2011/06/NewImage.png" border="0" alt="NewImage" width="385" height="126" />](http://documentcloud.github.com/backbone/#)

 

### MV* In Winforms

Prior to going indy and into rails work full time, I spent 4 years working with Winforms applications in .net &#8211; both desktop and mobile with Windows Mobile 6. In those 4 years (and various other projects in the past) I learned a lot about building winforms applications with various architectural patterns. In the end, I settled into the use of the various MV* patterns as I found them to be the most useful, long-term.

I&#8217;ve implemented apps with MVP and MVVM, including variations of these like Passive-View and Active-Presenter, etc. All of these MV* patterns are just various degrees of implementation differences but they all have the same goal: separating the concerns of view layout and display from the view&#8217;s logic and processing and the model(s) that provide the business value.

I&#8217;ve become very comfortable with these patterns and I know how to make them work well in a very organized manner, keeping the code clean and easy to understand.

 

### Hack-And-Slash Javascript

On the other side of the dev world, though, I&#8217;ve always struggled with writing good javascript. I&#8217;ve been using javascript in various forms since Netscape 2.0 introduced it to the world back in the mid 90&#8217;s&#8230; but I&#8217;ve never really felt comfortable or productive with it.

Even with the wonderful things that jquery has done for javascript in the last few years, when I get more than just a few dozen lines of javascript into a page, my code quickly becomes a mess. I almost invariably resort to hacking and mashing things together in order to get things to work. Sure, I use callbacks and cool jquery code&#8230; but it&#8217;s an unorganized, procedural mess with callbacks mixed in.

Even after spending the weekend learning more about object-oriented javascript, the result of my efforts were little more than procedural-callback-laden hacks in the guise of an object, hidden behind a namespace. But, I was learning and I continued on. The good news about my effort to learn more OOJS this weekend was that it made what I was about to see, much easier to understand.

 

### Enter Backbone.js: MV* In Javascript

I&#8217;m not going to get into a discussion about whether Backbone is MVC, MVP, MVVM, MV-YourMinisculeDifferenceNamedHere or whatever&#8230; backbone is an MV* implementation in javascript, plain and simple.

After spending the afternoon working with Joey and using backbone, I finally feel like I&#8217;m writing good, organized, easy to understand javascript. So far, I&#8217;ve used Models, Collections and Views with backbone. It also supports controllers, but I haven&#8217;t yet played with them. I&#8217;m sure there&#8217;s some great use for them but I&#8217;ll get to them later.

Now, I&#8217;m not going to try and lull you into a sense of security and say that if you&#8217;ve ever written a line of MV\* patterns in .NET Winforms apps, you&#8217;ll get off the ground running with Backbone in no time. There is still a significant learning curve &#8211; or, at least there was for me &#8211; because you have to know the core of object oriented javascript to really understand what Backbone is doing. However, if you are familiar with object oriented javascript and MV\* implementations in Winforms applications, you should have no trouble seeing the same patterns of usage and implementation emerging in your Backbone code. For now, I&#8217;ll assume you know enough about javascript and jump right into some very simple Backbone examples.

 

### Models: More Than JSON

When working with JQuery, I tend to work directly with JSON documents as DTOs. These documents are very useful for a number of reasons. They can transport data around, they have methods that manipulate the data, and JQuery can use them to populate templates with the JQuery template plugin. However, there are some things that are distinctly lacking in JSON documents. For example, there&#8217;s no event system to know when your models are changing. While it&#8217;s not terribly difficult to build some functionality like this, it can get tedious to repeat the code through your documents and troublesome to add it to documents that come out of back-end web servers such as Rails or ASP.NET MVC.

Backbone models to the rescue!

Here&#8217;s an example of how you can build a model in Backbone and listen to an event to know when a field has been changed:

[gist id=1026406 file=1-ModelWithChangedEvents.js]

 

The result of running this example is that you&#8217;ll have an alert box:

<img title="Screen shot 2011-06-14 at 10.36.07 PM.png" src="http://lostechies.com/derickbailey/files/2011/06/Screen-shot-2011-06-14-at-10.36.07-PM.png" border="0" alt="Screen shot 2011 06 14 at 10 36 07 PM" width="426" height="160" />

You&#8217;ll notice in the code that there&#8217;s a few obvious JSON documents (easy to see w/ the { } brackets) but that the model we&#8217;ve defined doesn&#8217;t use the standard JSON object notation to get and set attributes. Rather, you have to call the .get and .set methods to get and set attributes. I&#8217;m not 100% sure of why this is, but I&#8217;m assuming it is to facilitate all of the other functionality (like events) that the backbone models support. This takes a bit of getting used to, but I think I can see why it&#8217;s necessary.

There&#8217;s an easy way to get a JSON document out of this model, though, in case you want to get back to something a little more simple:

[gist id=1026406 file=2-ModelToJSON.js]

 

There are a lot of things you can do with models, in Backbone. This little example doesn&#8217;t really show much, though, because a model in isolation is less useful than one used in the page somewhere.

 

### Views: No, Not The One That You Rendered From Your MVC Back-end

Remember, Backbone is a complete MV* setup in your javascript, and it supports the idea of views. While a view in Rails or ASP.NET MVC represents pretty much the entire chunk of HTML that will be sent down to the browser, a view in Backbone seems to represent a smaller piece. From the examples I&#8217;ve seen and the code that Joey and I wrote earlier today, a view tends to be a logical chunk of the larger page. For example, you may have a small form on a login page where you enter your username and password. This form may be represented as a view, while the dozens of other logical groupings of visual elements may or may not be represented as other views.

Here&#8217;s the super-simple html that you may see for a login form:

[gist id=1026406 file=3-SimpleLoginForm.html]

 

This produces an amazing UI, of course:

<img title="Screen shot 2011-06-14 at 10.59.58 PM.png" src="http://lostechies.com/derickbailey/files/2011/06/Screen-shot-2011-06-14-at-10.59.58-PM.png" border="0" alt="Screen shot 2011 06 14 at 10 59 58 PM" width="213" height="81" />

You could turn this simple form into a Backbone view and have that view process the login request with an AJAX/JSON request back to the server. To keep things simple, though, I&#8217;ll just show an alert with the data that you populate into the form fields:

[gist id=1026406 file=4-LoginView.js]

 

Run this, enter a username of &#8220;qwer&#8221; and a password of &#8220;asdf&#8221;, then click the Login button and you&#8217;ll see this:

<img title="Screen shot 2011-06-14 at 11.36.12 PM.png" src="http://lostechies.com/derickbailey/files/2011/06/Screen-shot-2011-06-14-at-11.36.12-PM.png" border="0" alt="Screen shot 2011 06 14 at 11 36 12 PM" width="512" height="244" />

I&#8217;am mixing both Backbone and JQuery into this example. I find JQuery a little easier to deal with in some cases, and I also wanted to show that it&#8217;s entirely possible to mix the two together. Many of the examples that you&#8217;ll find online also mix the two together &#8217;cause frankly, JQuery is awesome. It solves a different set of problems than Backbone does, as well, so why not mix them together?

There are a number of things to pay attention to, other than mixing JQuery and Backbone, though.

I&#8217;m creating a Credentials model that we are using to store the username and password that are entered. The View is then defined as a JSON object with a few key bits of data and a few functions of our own.

The first bit of data is the &#8220;el&#8221; attribute. This is an attribute that Backbone recognizes as the element that the view encompasses. There are other ways of saying this and getting the view to know which part of the HTML document it represents, but for this example, &#8220;el&#8221; is all we need. In this case, I&#8217;m assigning the entire form to the view&#8217;s element.

The next bit of data is a list of events that the Backbone view will listen to. In this example, I only chose to listen to the click event of the #login button with Backbone. I could have listened to the change event for the username and password entry as well, but I wanted to show how you can mix JQuery in for those events. The click event for the #login button fires the login function as the event handler.

The initialize function is the constructor of the the view. When initializing the view in the very last line, I am passing a {mode: new Credentials()} JSON document in. &#8216;model&#8217; is a recognized part of Backbone. When I call &#8220;new LoginView({model: new Credentials()});&#8221;, I am assigning the view.Model to the new Credentials object. This gives me access to &#8220;this.model&#8221; all throughout the view&#8217;s code &#8211; like in line 21.

I&#8217;m using JQuery to find the username and password fields, and binding to the change events for them. Once the change events fire, I&#8217;m populating the value from the input boxes into &#8220;self.model&#8221;. Notice the discrepancy between the word &#8220;this&#8221; and the word &#8220;self&#8221;? This is a workaround for the scoping of &#8220;this&#8221; in javascript. When switching scopes between a Backbone object and a JQuery callback method, &#8220;this&#8221; changes to the JQuery object that fired the event. The work around is to assign a local variable to &#8220;this&#8221; prior to entering the JQuery code. Line 11 does this, setting &#8220;self = this&#8221;. Then in the JQuery callbacks, I can still reference the Backbone view as &#8220;self&#8221; and get to the view&#8217;s model to set the attributes as needed.

Once all of the work is done to bind the input boxes to the model, the login function uses it to display the alert box with the correct information.

Lastly, setting &#8220;window.LoginView&#8221; on the last line is a way to keep the view object alive. For a brief and insightful discussion on what &#8220;window&#8221; does, see [this question that I asked on StackOverflow](http://stackoverflow.com/questions/6349232/whats-the-difference-between-a-global-var-and-a-window-variable-in-javascript/) earlier today.

 

### The Complete Working Example

If you&#8217;re interesting in seeing the entire example that I showed here, [head over to the gist](https://gist.github.com/1026406) and look at the last file. It&#8217;s everything &#8211; the html and javascript &#8211; all in one.  You&#8217;ll just need to download the right versions of [Backbone](http://documentcloud.github.com/backbone/#), [JQuery](http://jquery.com/), [JSon2](https://github.com/douglascrockford/JSON-js), and [Underscore](http://documentcloud.github.com/underscore/).

 

### Finding My Comfort Zone With Javascript

Although the syntax and implementation detail are significantly different than any w[informs project I&#8217;ve ever written with an MV* pattern](https://github.com/derickbailey/appcontroller), there is a strong familiarity with the patterns that determine how I&#8217;m implementing this example. I&#8217;m used to seeing an event driven viewmodel (the &#8220;View&#8221;) that sets up databinding and other functionality. I&#8217;m used to having a clean separation between the view, a viewmodel, and a model representing the data. The patterns of interaction between these various pieces are comfortable to me and I was able to leverage my experience with these patterns to help Joey and I move our Rails project forward today, creating a very complex set of interactions with a very well structured javascript file.

In the end, I realize that I have a lot more to learn about Backbone. I&#8217;ve only touched the surface with these examples, but I&#8217;ve already done much more in my actual app. I&#8217;ve also realized just how terrible my old jquery-heavy javascript code really is. I look back at the javascript file that I put together over the weekend, while building the interactions I needed for a medication list, and I want to tear my hair out. But when I look at what I&#8217;ve built with this example and what I helped Joey build in our app, I see hope and I see a way out of the mess that I&#8217;ve previously caused in my apps.

I finally feel at home, working with Javascript. And that&#8217;s a good feeling.