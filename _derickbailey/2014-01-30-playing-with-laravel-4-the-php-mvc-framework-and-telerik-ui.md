---
id: 1250
title: Playing With Laravel 4 (the PHP MVC framework) And Telerik UI
date: 2014-01-30T15:17:13+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=1250
dsq_thread_id:
  - "2196920056"
categories:
  - Kendo
  - Laravel
  - Model-View-Controller
  - PHP
  - Telerik
---
It&#8217;s been a rough week, honestly. I&#8217;ve had to rebuild my development environment on my Mac twice because of compatibility issues with [Homebrew](http://brew.sh/) an XCode versions, I blew up my PHP install twice, set up [Vagrant](http://www.vagrantup.com/) with a VM to do things but it had the wrong version of PHP, and then couldn&#8217;t use MacVim because of a plugin that had to be rebuilt with the updated Homebrew and XCode versions. But I&#8217;m here. I&#8217;ve got [Laravel 4](http://laravel.com/) installed on my Mac, and it&#8217;s working finally! And I have to say, I really like what I see so far.

If you haven&#8217;t used or heard of Laravel before, think of it like Rails, Django or ASP.NET MVC, except for PHP. It&#8217;s a pretty classic looking MVC setup for web development, as far as I can tell. Maybe someone with more experience can say otherwise, but I found it to be a very comfortable place to write code from this perspective. 

## Why Laravel? Why Now?

I&#8217;m a sucker for learning, honestly. I love trying out new toys, banging them against walls and hitting them with hammers to see where they break, and wondering if I can put them back together. Laravel isn&#8217;t exactly new, of course, but it&#8217;s new to me. I&#8217;ve known about it for a while now, and have done a little bit of work with some raw PHP in the last year (raw == no framework other than what&#8217;s built in). So as I&#8217;m heading out the door of Telerik and Kendo UI this week, I thought I would try my hand at this lovely framework, see what it&#8217;s all about, and see what happens when I try to combine the [Telerik UI (FKA / AKA &#8220;Kendo UI&#8221;) PHP extensions](http://www.telerik.com/php-ui) to Laravel. 

## A Complete MVC Framework

My over-all impression of Laravel is that it is a well done, complete implementation of an MVC framework for a web server, in the vein of Ruby on Rails. It has that familiar structure of models, views and controllers for folders and objects. 

<img src="http://lostechies.com/derickbailey/files/2014/01/NewImage9.png" alt="NewImage" width="313" height="464" border="0" />

You also have a router to configure, migrations to build, and lot of other common configuration and expected things inside of a modern MVC framework. It even looks like there is some sort of asset pipeline type of functionality. The `hello.blade.php` file, for example, gets parsed by the [Blade view engine](http://laravel.com/docs/templates). I&#8217;m not sure how far this functionality extends &#8211; I haven&#8217;t tried adding multiple steps via multiple . file extensions yet. But, I know that if you rename this file to just &#8220;hello.php&#8221; it won&#8217;t be parsed as a blade file. It will just be a standard PHP file.

## Controllers Done Right

One of the things I really like about Laravel is how it handles actions in controllers. In Express for NodeJS and Ruby on Rails, as counter-examples, an action in a controller is directly responsible for executing the action of the controller. If you want to render a view, you render the view in the controller&#8217;s action. If you want to redirect, you redirect right there in the action. This has a tendency to push people toward having a lot of code in their controllers, in my experience. Laravel does it right, in my opinion. It doesn&#8217;t want me to execute the action right there in the controller method. Instead, it wants me to build an action object that I return from the controller method. 

[gist id=8718366 file=1.php]

I know this doesn&#8217;t look very different off-hand, but under the hood it is different. I&#8217;m not executing the view rendering and manipulation in the controller method. This is evidenced by the call to `->with(...)` on the end of the view creation. If this line were executing the view rendering, I wouldn&#8217;t be able to call the `with` method at this point. I would have to pass the view parameters in as an argument to the `View::make` call (which is one way of doing this, for what it&#8217;s worth). 

If you look at [the code for the View object](http://laravel.com/api/source-class-Illuminate.View.View.html), you&#8217;ll see that the `with` method doesn&#8217;t perform any actions when it&#8217;s called. It stores information for later use, based on the parameters that are called. Later, when the View object&#8217;s render method is called, it calls out to the actual rendering services to get the job of rendering done. Since you never have to manually call render in your controller method, it can be deduced that the View object is a sort of command object that is being configured in the controller and then executed at a later point in time. 

This little difference &#8211; not actually executing the action during the controller method &#8211; can mean the difference between writing a ton of ugly code in a controller and extracting specific actions in to re-usable objects for your application. You&#8217;ll be able to consolidate similar controller method in to objects that you can use in multiple controllers, reducing code and maintenance in your controllers. This is definitely a good thing.

## Connecting PHP Extensions For Kendo UI

After playing with Laravel for a bit, I decided to grab the Kendo UI PHP extensions and see how much effort it would take to load this in. The download for these extensions comes directly from the Telerik.com site, and isn&#8217;t available as a Composer package at the moment (at least, not that I could see).

I started by copying the Kendo UI PHP files in to a &#8220;lib&#8221; folder:

<img src="http://lostechies.com/derickbailey/files/2014/01/NewImage11.png" alt="NewImage" width="600" height="217" border="0" />

I also set up the standard Kendo UI JavaScript and CSS files in the /public folder of the project, and added those references to my project layout.

<img src="http://lostechies.com/derickbailey/files/2014/01/NewImage10.png" alt="NewImage" width="600" height="251" border="0" />

You need the Kendo UI JavaScript and CSS to run any of this, because the PHP extensions don&#8217;t build the HTML output directly. They produce JavaScript that is used in your browser to configure and run your Kendo UI controls. You can learn a bit more about that in my [PHP demo videos for Kendo UI](http://www.telerik.com/videos/php-ui).

After getting the files in place, I updated my composer.json file to include the &#8220;lib&#8221; folder in the autoload paths.

[gist id=8718366 file=2.json]

I was trying to get the lib/Kendo/Autoload.php file to load automatically, as the name suggests, but I&#8217;m probably configuring the composer.json file incorrectly. What I ended up doing is adding a require_once to my /bootstrap/autoload.php file.

[gist id=8718366 file=3.php]

This works, so it&#8217;s good enough for me. Someone else will hopefully see this and correct me on how to make composer.json load things automatically. 🙂

**\*\*UPDATE\*\***

Thanks to Andrew MacKenzie, in the comments below, I now know that I can run `composer dump-autoload` after changing my `classmap` settings. This rebuilds the classmap and prevents me from having to add the `require_once` line in my autoload.php scripts. Thanks, Andrew! 🙂

## Using Kendo UI Controls

Having set all that up, getting a Kendo UI control in place was easy. To start with, I dropped in a DatePicker, because it is simple to create and doesn&#8217;t need a data source to show things. I was originally going to put this in my view directly, but decided that I wanted my `$datePicker` variable in the controller, and would just pass that to my view with the other args and data. This way I can configure the `$datePicker` with anything I need, and keep all that configuration and logic out of the view.

[gist id=8718366 file=4.php]

[gist id=8718366 file=5.php]

With that in place, reloading my view shows the DatePicker control as expected:

<img src="http://lostechies.com/derickbailey/files/2014/01/NewImage12.png" alt="NewImage" width="341" height="433" border="0" />

Now to get some data in place.

I started with the Laravel quickstart guide of adding a User table and model, and I added some junk data to my user table. This lets me load up data using the User model and assign it to the datasource of a Kendo UI control. 

[gist id=8718366 file=6.php]

[gist id=8718366 file=7.php]

The awesome thing to note here, is the use of `$users->toArray()`. The Kendo UI PHP wrappers are smart enough to take this array of objects and convert it in to a JSON document for you, in your HTML. When the page gets rendered, then, the browser has all the data it needs for the drop down list. The result is what you would expect, then. A nice drop down list with the data loaded from the `Users::allI()` call.

<img src="http://lostechies.com/derickbailey/files/2014/01/NewImage13.png" alt="NewImage" width="225" height="274" border="0" />

Of course this doesn&#8217;t cover loading data at runtime, using AJAX. But i&#8217;ll let [my videos on the PHP extensions](http://www.telerik.com/videos/php-ui) cover that for you.

## Fun Stuff, Lots more

In spite of my initial anger and frustration of not being able to get Laravel installed and working, I&#8217;m really enjoying this framework. My problems turned out to be my Homebrew install, anyways, so it really isn&#8217;t fair to say that Laravel was difficult to install. Honestly, it wasn&#8217;t &#8211; once I got homebrew fixed, Laravel installed pretty quickly and only took a few rounds of looking through [the quick start guide](http://laravel.com/docs/quick) and [installation docs](http://laravel.com/docs/installation) to get me up and running. 

If you&#8217;re considering a jaunt in to some PHP work, and need a good place to go for writing well structured, MVC style server code, check out Laravel. And if you want to add a modern UI framework to the front end of it, check out Telerik UI (&#8220;Kendo UI&#8221;) &#8211; you have the option of writing the JavaScript  yourself, or using the PHP extensions that I&#8217;ve shown here so that you don&#8217;t have to write any serious amount of JavaScript.

This is shaping up to be a great combination of tools &#8211; enough that I would almost feel comfortable taking on a project with Laravel and Telerik UI at this point. But there&#8217;s a lot more for me to learn about Laravel and how it really works before I do that. 🙂