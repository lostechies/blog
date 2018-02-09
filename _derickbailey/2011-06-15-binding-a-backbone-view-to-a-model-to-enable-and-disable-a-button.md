---
wordpress_id: 430
title: Binding A Backbone View To A Model, To Enable and Disable A Button
date: 2011-06-15T13:16:39+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=430
dsq_thread_id:
  - "333262875"
categories:
  - Backbone
  - JavaScript
  - Model-View-Controller
  - Principles and Patterns
---
Continuing the contrived example from yesterday &#8211; [a very simple login form](http://lostechies.com/derickbailey/2011/06/14/intro-to-backbone-js-how-a-winforms-developer-is-at-home-in-javascript/) &#8211; I wanted to show how Joey and I are using backbone&#8217;s events and models to enable and disable a button on the form.

 

### The Form Layout And Functionality

It&#8217;s a very simple form. It has a username and password text box, and a button. What I want to to is make the button disabled initially, and then enable it when a username and password have been supplied.

Here&#8217;s the form HTML and layout:

{% gist 1027710 1-form.html %}

 

<img title="Screen shot 2011-06-15 at 1.13.39 PM.png" src="http://lostechies.com/derickbailey/files/2011/06/Screen-shot-2011-06-15-at-1.13.39-PM.png" border="0" alt="Screen shot 2011 06 15 at 1 13 39 PM" width="216" height="82" />

 

### The Credentials Model

We need something on the credentials model for the view to pay attention to, to know when to enable and disable the button. A &#8220;validated&#8221; event would be a great way to listen to the model&#8217;s changes for this purpose. Then, if the model is valid we can enable the button and if the model is invalid, we can disable the button.

{% gist 1027710 2-credentials.js %}

 

In this code, we are setting up a &#8220;changed&#8221; even listener in the model&#8217;s initializer. The &#8220;changed&#8221; even fired any time an attribute on the model is being changed. For example, calling &#8220;model.set({something: &#8220;whatever&#8221;})&#8221; will change the model&#8217;s &#8220;something&#8221; attribute and cause the change event to fire. Within our change even handler, we are checking to see if the model has both a username and a password. If both are present, the model is valid. If one or both are missing, the model is not valid. We are then raising (triggering) the &#8220;validated&#8221; event and passing along the knowledge of whether or not the model is valid.

 

### The Login View

I&#8217;ve updated this a little from yesterday&#8217;s example and I&#8217;m using backbone&#8217;s built in event system instead JQuery&#8217;s for binding the username and password inputs. I&#8217;ve also added few lines to the initializer to bind to the model&#8217;s &#8220;validated&#8221; event and store the view on the model.

{% gist 1027710 3-loginview.js %}

 

Line 15 binds the view&#8217;s validated method to the model&#8217;s validated event. This gives us a way to have the view pay attention to the model so that we can change the login button&#8217;s disabled attribute. Line 14 is also assigning the view to the model&#8217;s .view attribute so that we can access the view in the validated event handler.

The validated function receives the valid argument to tell us whether or not the model is valid. If it is valid, we remove the &#8220;disabled&#8221; attribute. If it&#8217;s not valid, we add the &#8220;disabled&#8221; attribute.

Notice that the validated function is calling this.view.loginbutton to get to the login button. I&#8217;m doing this because &#8220;this&#8221; in the context of the event handler method is the object that raised the event. In this case, the object that raised the event is the model. I need the loginButton attribute from the view, though, so I have attached the view to the model in line 14 which makes &#8220;this.view&#8221; available in the validated method.

Honestly, this part confused me. I thought the context of &#8220;this&#8221; in the validated method was going to be the view itself, not the model. Can anyone explain why it&#8217;s the model and not the view?

 

### Putting It All Together

Now that our model has a validated event and our view is binding to it, we can enter a username and password to enable the login button:

<img title="Screen shot 2011-06-15 at 2.02.32 PM.png" src="http://lostechies.com/derickbailey/files/2011/06/Screen-shot-2011-06-15-at-2.02.32-PM.png" border="0" alt="Screen shot 2011 06 15 at 2 02 32 PM" width="221" height="81" />

and when we click on the login button, we get a pop up message telling us the username and password:

<img title="Screen shot 2011-06-15 at 2.03.24 PM.png" src="http://lostechies.com/derickbailey/files/2011/06/Screen-shot-2011-06-15-at-2.03.24-PM.png" border="0" alt="Screen shot 2011 06 15 at 2 03 24 PM" width="525" height="264" />

If you&#8217;re interested in seeing all of the code for this example, [head over to the gist and grab the last 2 files](https://gist.github.com/1027710). One is a javascript file and the other is the html file, with all of this running.

 

<h3 style="font-size: 1.17em;">
  A Small Problem: Blur vs Change
</h3>

There is a small problem with this example, though. You have to cause the username and password fields to lose focus before the changed events will fire and populate the model with the data. So, as you are typing into the password box (after setting a username), the login button is still disabled. Once you tab or click out of the password box, the button enables.

I thought the change even was supposed to fire for every keystroke that happened in an input box, while the blue event only fired on blur of the input. Can anyone clarify this for me or tell me what I&#8217;m doing wrong / how to fix it?

 

### Is There A Better Way With Backbone?

I have this sneaking suspicion that there&#8217;s a better, more declarative way to bind the view and model together, leading to less code than my example shows. If anyone knows how to get this done in a better way, please share!

 

<h3 style="font-size: 1.17em;">
  Still A Contrived Example
</h3>

One of the commenters on my previous post was asking why you would want to use backbone over JQuery for such simple functionality. In truth, I probably wouldn&#8217;t use backbone for such a small piece of functionality in a production application. You could accomplish the same thing with JQuery alone, in much less code. I realize that the examples I&#8217;m giving are contrived and not very real-world. They are just examples, though, and would hopefully spark a little more interest or help someone else find that &#8220;AHA!&#8221; moment on when, where and why they would want to use something like Backbone.
