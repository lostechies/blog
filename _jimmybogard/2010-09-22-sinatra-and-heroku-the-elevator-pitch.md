---
id: 435
title: 'Sinatra and Heroku: the elevator pitch'
date: 2010-09-22T13:10:18+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2010/09/22/sinatra-and-heroku-the-elevator-pitch.aspx
dsq_thread_id:
  - "264716581"
categories:
  - Ruby
---
Recently, I needed to upgrade an old ASP.NET 2.0 site I’ve maintained for a family member.&#160; I built the original site back in 2000 or so with ASP and FrontPage (had the FrontPage Bible on my desk for that one).&#160; I later upgraded the site in 2005 to ASP.NET 2.0 with semantic HTML, XHTML and all that goodness.

But I had been reticent to touch it for the smallest requested change.&#160; Not because the change was difficult, but because it was so difficult to deploy an ASP.NET 2.0 application.&#160; Sure, there’s some web deployment project or something, but it was still annoying synchronizing production with development.

So I set about finding something better.&#160; I didn’t need anything in ASP.NET, as this was simply a brochure site.&#160; I needed to be able to upload content, theme and style it, and most importantly, control HTML, CSS and JavaScript.

### Choosing Heroku

I had heard about [Heroku](http://heroku.com/) a while back, but hadn’t given it much thought as I wasn’t building any web sites.&#160; I wanted to solve my deployment problems by simplifying deployment as much as possible.

Heroku is a cloud platform for hosting Ruby applications.&#160; What’s fantastic with Heroku is the insane simplicity of every interaction.&#160; It’s got a fantastic website, but the really interesting piece is that to deploy, you simply do a “git push”:

<pre>$ git push heroku master</pre>

There are no deployments, there is simply a push of my local git repository up to my Heroku repository.&#160; One way to handle deployments is to put a bunch of tooling support in.&#160; Or, another way is to remove the need to care about deployments and I just push my entire site up.

The coolest thing about Heroku is the entire platform has embraced “the Ruby way”.&#160; If you need a specific plugin, it’s just gem packages.&#160; Rake is available for database migrations, and Rack-based web frameworks are supported (including Sinatra).

Heroku is like many other cloud-based services like github, where the basic features are free, and add-ons cost extra.&#160; Looking at my requirements, I didn’t need any addons, so my hosting cost is ZERO.&#160; All I needed is a domain.

### Choosing Sinatra

When it came time to actually building my application out, I first started with Rails.&#160; When it came time to build my model, I stopped.&#160; I didn’t have a need for any model, this application didn’t have a database to begin with, so why would it need one now?&#160; So I ditched Rails, it wasn’t what I needed.

All I needed was to have some static routes and static content that I could have complete control over.&#160; There was some dynamic information shown, but nothing that required a database.&#160; I didn’t even need _controllers_.&#160; That’s just too much weight to drag around.&#160; All I really needed was to link up routes to content.

For these needs, [Sinatra](http://www.sinatrarb.com/) was the perfect fit.&#160; I have one code file that defines my routes and what to do to handle them:

<pre>require 'rubygems'
require 'sinatra'
get '/' do
  'Hello world!'
end</pre>

If I want to show a view, it’s:

<pre>get '/' do
  erb :index
end</pre>

I then can use erb as a view engine (or Haml or whatever).&#160; But I don’t need an IDE, projects, solutions or any junk like that.&#160; I just stick with a text editor like [e](http://www.e-texteditor.com/), and I’m done.

### Adios, ASP.NET

Unless I’m building on top of an existing application or are in an IT environment, I can’t really fathom why anyone would choose .NET for static websites these days.&#160; Platforms like Ruby and PHP are cheaper and simpler to develop, deploy and manage with fantastic hosting services like Heroku.&#160; I don’t have to open an IDE, which at that point is just to heavyweight for what I’m trying to do.&#160; Command line and a good text editor is much easier to deal with.&#160; Otherwise, my browser (Chrome) is my IDE.

My hosting cost wasn’t that much to begin with, but it’s now zero.&#160; I don’t even have to worry about deployments, I just push my entire repository up to Heroku with one git push and it manages the rest.&#160; If you’re about to create a new public site or upgrade an existing site, I highly recommend giving Heroku a look.&#160; If nothing else, it will depress you on how easy web site development and deployments can be.