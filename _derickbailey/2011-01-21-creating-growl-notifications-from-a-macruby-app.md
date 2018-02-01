---
id: 208
title: Creating Growl Notifications From A MacRuby App
date: 2011-01-21T05:39:06+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2011/01/21/creating-growl-notifications-from-a-macruby-app.aspx
dsq_thread_id:
  - "262766683"
categories:
  - Growl
  - MacRuby
  - OSX
  - Ruby
  - Xcode
---
I&#8217;ve been wanting an excuse to learn how to code for OSX for a while now, and I finally thought of a project worth trying. In an effort to get up and running on XCode and Cocoa as quickly as possible, a number of people suggested I check out [MacRuby](http://www.macruby.org/). I have to say, I&#8217;m quite happy with it so far. I was able to find some simple tutorials to get me moving and started putting together some simple native OSX UIs pretty quickly, with UI elements that actually do things.

One of the goals of the app that I want to build is to show [Growl](http://growl.info/) notifications at various times, so I started digging into what this would take. I found a few tutorials, various forums and even a few bug tickets that generally gave me the information I needed, but I had to put it all together myself. So, in an effort to help the community a little more, I am going to try and post a complete tutorial on creating a MacRuby app with Growl notifications.

 

## Getting Started &#8211; Xcode And The Growl Frameworks

First, you need a Mac and you need to install the latest and greatest [Xcode](http://developer.apple.com/technologies/tools/xcode.html). Start up Xcode and create a new MacRuby project. Give it a name and save it somewhere. Next, you&#8217;ll need the Growl frameworks. Xcode comes with several examples of how to work with Growl, but I found them all to be difficult and couldn&#8217;t get them working correctly. A few google searches later and I realized Growl delivers a nice framework package from their website.

Go download the Growl SDK from the Growl website. Open the disk image, and in the Frameworks folder, copy both the &#8220;Growl.framework&#8221; and &#8220;Growl-WithInstaller.framework&#8221;. Paste these into /Library/Frameworks on your OSX drive. This will make them easier to find from within Xcode.

<img src="http://lostechies.com/derickbailey/files/2011/03/Screen-shot-2011-01-20-at-10.34.42-PM.png" border="0" alt="Screen shot 2011-01-20 at 10.34.42 PM.png" width="600" height="207" />

 

## Adding The Growl Framework To Your Project

Open Xcode and your project, and locate Frameworks in the project tree view. Pick one of the framework groups (I chose &#8220;Other&#8221; for no apparent reason), right click and &#8220;Add Existing Framework&#8221;. If you got copied the growl frameworks into the right folder, they will show up in the list. Otherwise you&#8217;ll have to hunt for them with the &#8220;Add Other&#8221; button.

<img src="http://lostechies.com/derickbailey/files/2011/03/Screen-shot-2011-01-20-at-10.36.07-PM.png" border="0" alt="Screen shot 2011-01-20 at 10.36.07 PM.png" width="535" height="310" />

Your projet now references Growl, but it won&#8217;t be able to find it at run time. We have to tell the project to copy the framework to the output folder so it can be found at runtime. Find the Targets node in the project treeview, and find your app&#8217;s name. Expand that portion of the tree and you will see several build phase. If you have an empty &#8220;Copy Files&#8221; step, great! If not, you need to right click your app name and &#8220;Add&#8221; a &#8220;New Build Phase&#8221; to &#8220;Copy Files&#8221;. If the Copy Files phase doesn&#8217;t open an &#8220;Info&#8221; screen, double click on it to open it. In this screen, set the &#8220;Destination&#8221; to &#8220;Frameworks&#8221; and leave the &#8220;Path&#8221; blank.

<img src="http://lostechies.com/derickbailey/files/2011/03/Screen-shot-2011-01-20-at-10.42.22-PM.png" border="0" alt="Screen shot 2011-01-20 at 10.42.22 PM.png" width="287" height="98" />

Close this window.

Now drag the Growl.framework from the &#8220;Frameworks/Other Frameworks&#8221; tree node, down into the &#8220;Copy Files&#8221; node that you just added. This will tell Xcode to copy the Growl.framework into your project&#8217;s output when it builds.

<img src="http://lostechies.com/derickbailey/files/2011/03/Screen-shot-2011-01-20-at-10.46.59-PM.png" border="0" alt="Screen shot 2011-01-20 at 10.46.59 PM.png" width="270" height="368" />

 

## Configuration Growl To Know About Your App

You can&#8217;t just send things to Growl and expect it to magically work. You have to configure your app to use Growl and let Growl know what your app wants to do with it &#8211; what notifications you want to set up, what you want on by default, etc. There are several ways to configure your app to work with Growl. I chose to use a .growlRegDict file &#8211; a Growl Registration Dictionary. It&#8217;s an XML file that defines your app in a manner that Growl understands. You could use code to do the registration as well. There are a lot of examples for doing this online.

Start by adding a filed called &#8220;Growl Registration Ticket.growlRegDict&#8221; to your project. I chose to put this in my Resources folder. I&#8217;m not sure if the file must be named this, exactly, but I am fairly certain it has to have the .growlRegDict extension.  Once you have the file in place, place the following XML in it:

> <p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
>   <?xml version=&#8221;1.0&#8243; encoding=&#8221;UTF-8&#8243;?>
> </p>
> 
> <p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
>   <!DOCTYPE plist PUBLIC &#8220;-//Apple Computer//DTD PLIST 1.0//EN&#8221; &#8220;http://www.apple.com/DTDs/PropertyList-1.0.dtd&#8221;>
> </p>
> 
> <p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
>   <plist version=&#8221;1.0&#8243;>
> </p>
> 
> <p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
>   <dict>
> </p>
> 
> <p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
>   <key>TicketVersion</key>
> </p>
> 
> <p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
>   <integer>1</integer>
> </p>
> 
> <p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
>   <key>AllNotifications</key>
> </p>
> 
> <p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
>   <array>
> </p>
> 
> <p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
>   <string>Test</string>
> </p>
> 
> <p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
>   </array>
> </p>
> 
> <p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
>   <key>DefaultNotifications</key>
> </p>
> 
> <p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
>   <array>
> </p>
> 
> <p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
>   <string>Test</string>
> </p>
> 
> <p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
>   </array>
> </p>
> 
> <p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
>   </dict>
> </p>
> 
> <p style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">
>   </plist>
> </p>

I&#8217;ll let you read all of the documentation on the settings you can supply here. The basics of what you need to know, though, is the &#8220;AllNotifications&#8221; and &#8220;DefaultNotifications&#8221; list. Under all notifications, you must supply the names of every notification type your app will send. If you send anything that is not in this list, Growl will ignore it. Under default notifications, you need to tell Growl which of the notification types to enable, by default.

Next, drag the .growlRegDict file from Resources down into &#8220;Targets/(project)/Copy Bundle Resources&#8221;.

<img src="http://lostechies.com/derickbailey/files/2011/03/Screen-shot-2011-01-20-at-10.57.36-PM.png" border="0" alt="Screen shot 2011-01-20 at 10.57.36 PM.png" width="349" height="192" />

This will copy the resource so that the Growl Application Bridge will be able to find it at runtime.

 

## Configuring Your App To Use Growl

From what I have read, a standard Xcode app will have various application delegates set up. I&#8217;m still not entirely sure how to describe these, other than they are classes that meet specific API needs and provide callback methods for various parts of your app. Perhaps the closest thing I can think of from my .NET days is the Event system, which does use delegates under the hood. However, there is a significant difference between a .NET delegate and an XCode/OSX delegate.

If you do not have an app delegate set up, you need to create one for two purposes:

  * To register your app with Growl, at startup
  * To use Growl callbacks for various events

Add a new ruby document to your project. I called it &#8220;ApplicationDelegate.rb&#8221; and placed it in the Classes folder of my project:

<img src="http://lostechies.com/derickbailey/files/2011/03/Screen-shot-2011-01-20-at-11.07.05-PM.png" border="0" alt="Screen shot 2011-01-20 at 11.07.05 PM.png" width="240" height="74" />

In this file, define a ruby class called ApplicationDelegate (though the name doesn&#8217;t matter that much at this point) and put the following code in it:

> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">framework <span style="color: #d12e1b">"Growl"</span></pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo"><br /></pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo"><span style="color: #bb2da2">class</span> ApplicationDelegate</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo"><br /></pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo"><span style="color: #bb2da2">  def</span> awakeFromNib()</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">GrowlApplicationBridge.setGrowlDelegate(<span style="color: #bb2da2">self</span>)</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo;color: #bb2da2">end</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo"><br /></pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo;color: #bb2da2">end</pre>

This code will tell Growl that your application is going to be sending notifications, once we have told the system that this class is an application delegate. To do that,open the Interface Builder by double clicking &#8220;MainMenu.xib&#8221; in the &#8220;Resources&#8221; folder of your project. Open the Library window by pressing &#8220;shift-cmd-L&#8221; (or however you want to get it open) and find an Object. Drag an Object over to your MainMenu.xib window, and drop it there. This adds an object that we can wire up to our UI.

<img src="http://lostechies.com/derickbailey/files/2011/03/Screen-shot-2011-01-20-at-11.13.07-PM.png" border="0" alt="Screen shot 2011-01-20 at 11.13.07 PM.png" width="600" height="284" />

Double click on the Object you just created to open the Info dialog. Set the &#8220;Class Identity&#8221; to your ApplicationController class.

<img src="http://lostechies.com/derickbailey/files/2011/03/Screen-shot-2011-01-20-at-11.17.36-PM.png" border="0" alt="Screen shot 2011-01-20 at 11.17.36 PM.png" width="600" height="289" />

Then hold down control on your keyboard and click-and-drag from &#8220;File&#8217;s Owner&#8221; down to the &#8220;Object&#8221; that you just added.

<img src="http://lostechies.com/derickbailey/files/2011/03/Screen-shot-2011-01-20-at-11.18.49-PM.png" border="0" alt="Screen shot 2011-01-20 at 11.18.49 PM.png" width="433" height="332" />

Let go of the mouse button and select &#8220;Delegate&#8221; from the resulting dialog. This will wire up your ApplicationDelegate so that the &#8220;awakeFromNib&#8221; method will fire when your app starts up, which will then register your app with Growl.

 

## Make Your App Growl

Now for the fun part&#8230; we get to make the app Growl! At a very basic level, it&#8217;s easy. All you need to do is call the &#8220;GrowlApplicationBridge.notifyWithTitle&#8221; method. Somewhere in your app, you need to have some code that calls this method. To start with, you can put it directly into your awakeFromNib method in your Application Delegate class. This will fire off a Growl notification as soon as your app starts up.

> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo"><span style="color: #bb2da2">def</span> awakeFromNib()</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">GrowlApplicationBridge.setGrowlDelegate(<span style="color: #bb2da2">self</span>)</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo"><br /></pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">GrowlApplicationBridge.notifyWithTitle(<span style="color: #d12e1b">"Our Growling Title"</span>,</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo;color: #d12e1b"><span style="color: #000000">    description: </span>"this is a really big description of really cool things! now you can take over the world with Growl from MacRuby!"<span style="color: #000000">,</span></pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">notificationName: <span style="color: #d12e1b">"Test"</span>,</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">iconData: <span style="color: #bb2da2">nil</span>,</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">priority: <span style="color: #252bd8"></span>,</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">isSticky: <span style="color: #bb2da2">false</span>,</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo">clickContext: <span style="color: #bb2da2">nil</span>)</pre>
> 
> <pre style="margin: 0.0px 0.0px 0.0px 0.0px;font: 11.0px Menlo"><span style="color: #bb2da2">end</span></pre>

You can read all the documentation on what these options do. For the most part, though, you need to pay attention to the first parameter and the &#8220;description&#8221; and &#8220;notificationName&#8221; in the hash.

The first parameter is the title of the notification. The remaining parameters are all technically a ruby hash using the succinct &#8220;key: value&#8221; syntax. The &#8220;description&#8221; is the large text body of the notification that is being sent. The &#8220;notificationName&#8221; is very important &#8211; it&#8217;s the name of the notification type that you are sending, and it must be one of the types that you set up in your &#8220;Growl Registration Ticket.growlRegDict&#8221; file. If you don&#8217;t use one that was set up in that file, Growl will ignore the notification.

Assuming my instructions are good, you should be able to run the app from Xcode and see a Growl notification!

<img src="http://lostechies.com/derickbailey/files/2011/03/Screen-shot-2011-01-20-at-11.31.58-PM.png" border="0" alt="Screen shot 2011-01-20 at 11.31.58 PM.png" width="309" height="105" />

That wasn&#8217;t too bad, was it?

 

## And There&#8217;s So Much More

I&#8217;ve only just started learning MacRuby, XCode, Cocoa, Growl and all the things related to all of this. I know there&#8217;s so much more that I&#8217;ll be picking up on in the next few weeks while I&#8217;m trying to put together my little app. I&#8217;ll try to keep posting walk throughs like this, to help out those who would like to learn a little more.

As a preview of what else I&#8217;ve learned, though, you can set up a callback from a Growl notification so that when you click on the notification a chunk of code in your app will be executed. This opens up nearly limitless possibilities of what you can do with a Growl notification &#8211; launch a web page, launch another app, move your app into a specific feature, and more!

I&#8217;ll show you [how to set up the click callback delegate](http://www.lostechies.com/blogs/derickbailey/archive/2011/01/23/responding-to-growl-notification-clicks-and-timeouts-with-macruby.aspx) in my next post.

 

## Resources

Here are some of the resources I used when figuring this out

  * <http://growl.info/documentation/developer/> &#8211; developer documentation with links to the SDK download
  * <https://github.com/psionides/MacBlip> &#8211; a complete MacRuby app, with Growl notifications. I learned a little more about the Growl registration dictionary and how to set up an Application Delegate by examining this project&#8217;s source code through Github, directly.
  * <http://quiteuseful.co.uk/post/99434588/how-to-make-a-growl-app> &#8211; the basic tutorial that I followed, after learning about the Growl.framework that the Growl developers provide. This is written specifically for XCode and Objective-C, so I had to improvise and interpret a few things in order to do it in MacRuby.
  * <http://groups.google.com/group/growldiscuss/browse_thread/thread/123037bedd9ee7e4> &#8211; discussion about a problem I ran into with the Growl-WithInstaller.framework. I ended up switching back to the plain Growl.framework for now. Hopefully I can get around the problem or find a solution to it, though. I would really like to deliver Growl with the app I&#8217;m building.