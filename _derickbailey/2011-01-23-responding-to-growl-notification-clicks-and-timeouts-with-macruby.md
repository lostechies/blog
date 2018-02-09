---
wordpress_id: 209
title: Responding To Growl Notification Clicks With MacRuby
date: 2011-01-23T16:39:30+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2011/01/23/responding-to-growl-notification-clicks-and-timeouts-with-macruby.aspx
dsq_thread_id:
  - "264031242"
categories:
  - Growl
  - MacRuby
  - OSX
  - Ruby
  - Xcode
redirect_from: "/blogs/derickbailey/archive/2011/01/23/responding-to-growl-notification-clicks-and-timeouts-with-macruby.aspx/"
---
In my last post, I detailed the process of s[etting up a MacRuby app to send Growl notifications](http://www.lostechies.com/blogs/derickbailey/archive/2011/01/21/creating-growl-notifications-from-a-macruby-app.aspx). To get even more mileage out of Growl, though, it&#8217;s a good idea to response to various interactions with the notifications that you send. For example, you can have your application respond to your notice being clicked, or to the notice timing out and disappearing from the screen.

To get started, open the sample app that we created from the previous post.

 

## The Growl Delegate

Open the ApplicationDelegate.rb file &#8211; this is the file that responds to our general application events. In the &#8220;awakeFromNib&#8221; event, we set our Growl delegate to &#8220;self&#8221; &#8211; the ApplicationDelegate class. It turns out you don&#8217;t have to do this if you are not going to respond to any growl events. You can set the delegate to &#8220;&#8221; and Growl will not send any events to your app.

In our application, though, we want to set up a click event. Since we already have the delegate set to self, we can simply add the delegate method for clicked:

> <pre><p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
  <span style="color: #c22a9c">def</span> growlNotificationWasClicked(context)
</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
  <span style="color: #c22a9c">end</span>
</p></pre>

This method will be called any time a user clicks on a notification that our application sends. From this method, we can do anything we want &#8211; take our app to a specific screen, run a background process, kick off another app or process, send another growl notification or anything else that we can think of. It&#8217;s our code, after all, and we get to determine what it does.

 

## The Context Parameter

Having the method defined and the delegate set up is only part of what we need. The context parameter (which can be named anything you like) is also important.

Looking back at the growl notification that we are sending from our ApplicationDelegate, there is a clickContext key in the hash. At this point, we have set it to nil, but if we want to use any of the callback methods from Growl, we need to set this to something other than nil. When we set this value, it will be passed to our clicked callback method. This allows us to provide context to the method &#8211; hence the name of the parameter &#8211; which can be used to determine what actions to take.

For this example, set the value of clickContext to &#8220;You Clicked A Notification!&#8221;

> <pre style="margin: 0px;font: 11px Menlo">GrowlApplicationBridge.notifyWithTitle(<span style="color: #d12e1b">"Our Growling Title"</span>,</pre>
> 
> <pre style="margin: 0px;font: 11px Menlo;color: #d12e1b"><span style="color: #000000">    description: </span>"this is a really big description of really cool things! now you can take over the world with Growl from MacRuby!"<span style="color: #000000">,</span></pre>
> 
> <pre style="margin: 0px;font: 11px Menlo">notificationName: <span style="color: #d12e1b">"Test"</span>,</pre>
> 
> <pre style="margin: 0px;font: 11px Menlo">iconData: <span style="color: #bb2da2">nil</span>,</pre>
> 
> <pre style="margin: 0px;font: 11px Menlo">priority: <span style="color: #252bd8"></span>,</pre>
> 
> <pre style="margin: 0px;font: 11px Menlo">isSticky: <span style="color: #bb2da2">false</span>,</pre>
> 
> <pre style="margin: 0px;font: 11px Menlo">clickContext: <span style="color: #d12e1b">"You Clicked A Notification!"</span>)</pre>

If you do not provide some form of data for the context, the clicked callback will not execute.

 

## The Clicked Callback Method

As a simple example of using the clicked callback method, we can send another Growl notification. In this case, we will take the context and use it as the Growl description. The ApplicationDelegate class now looks like this:

> <pre><p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
  framework <span style="color: #d12e1b">"Growl"</span>
</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
   
</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
  <span style="color: #bb2da2">class</span> ApplicationDelegate
</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
  <span style="color: #bb2da2">  def</span> awakeFromNib()
</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
  GrowlApplicationBridge.setGrowlDelegate(<span style="color: #bb2da2">self</span>)
</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo;color: #bb2da2">
  <span style="color: #000000">  </span>end
</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
  <span style="font-family: monospace"><span style="font-size: medium"><span style="font-family: Menlo;font-size: small"><span style="font-size: 11px"><br /></span></span></span></span>
</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
  <span style="color: #bb2da2">  def</span> growlNotificationWasClicked(context)
</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
  <span style="font-family: monospace"><span style="font-size: medium">    </span></span>GrowlApplicationBridge.notifyWithTitle(<span style="color: #d12e1b">"Clicked Title"</span>,
</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo;color: #d12e1b">
  <span style="color: #000000">      description: context</span><span style="color: #000000">,</span>
</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
  notificationName: <span style="color: #d12e1b">"Test"</span>,
</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
  iconData: <span style="color: #bb2da2">nil</span>,
</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
  priority: <span style="color: #252bd8"></span>,
</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
  isSticky: <span style="color: #bb2da2">false</span>,
</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
  clickContext: <span style="color: #bb2da2">nil</span>)
</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo;color: #bb2da2">
  <span style="color: #000000">  </span>end
</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo;color: #bb2da2">
  end
</p></pre>

Note that we are setting the clickContext to nil for this send notification. If we set it to anything else, we would allow the user to click it and it would call back into this same method. This isn&#8217;t necessarily a bad thing &#8211; but could be if we aren&#8217;t careful.

 

## The End Results

Run the app from Xcode and when the first notification pops up, click on it. You will then see a second notification that should look like this:

<img src="http://lostechies.com/derickbailey/files/2011/03/Screen-shot-2011-01-23-at-10.36.10-AM.png" border="0" alt="Screen shot 2011-01-23 at 10.36.10 AM.png" width="327" height="83" />

 