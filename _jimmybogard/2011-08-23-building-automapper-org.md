---
wordpress_id: 515
title: Building AutoMapper.org
date: 2011-08-23T22:00:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2011/08/25/building-automapper-org/
dsq_thread_id:
  - "394207964"
categories:
  - AutoMapper
---
Simplicity is a good thing. Especially when you want to turn out a site that’s really only a couple of pages, max, you don’t want to spend much time (or any) futzing around with things that you don’t care about.

When it came time to build the [AutoMapper.org](http://automapper.org/) site, I wanted simple. Building the site, I really only wanted HTML, CSS and maaaaaybe some JavaScript. I wanted complete control over the look and feel, and didn’t want to mess around figuring out templates or someone else’s WYSIWYG editor. I’m maybe 3 on a scale of 10 for designing a website, but I know how to find good designs and borrow (steal) their design.

With this in mind, I selected a variety of technologies to build AutoMapper.org, all of which combined to have one really simple workflow for me iterating the development and deployment.

_Side note – all the code for the site is on a [git repository](https://github.com/AutoMapper/AutoMapper.website) under the [AutoMapper organization’s GitHub account](https://github.com/AutoMapper)._

### Site framework

I’ve put a couple of production applications into production with [Sinatra](http://www.sinatrarb.com/), so that was my first choice to look at for a web application framework. I don’t need a database, so Rails is out. ASP.NET MVC is still too bloated for a very small site, and its deployment story still can’t beat Ruby apps. [Nancy](https://github.com/NancyFx/Nancy) looks interesting, but it’s still too isolated from the rest of the .NET web application hosting story to be interesting to me.

I also looked at things like WordPress, Tumblr and GitHub pages. All of these didn’t have the flexibility that my favorite deployment scenario has, which would let me grow the site into more if I needed it.

Behind all of this is me thinking that if the site had a lot more in it, I want to be able to grow the site with the framework. Because Sinatra lets me own all the HTML in the site without application-specific templating engines, I can just use standard templates like ERB to build my pages. Here’s my Sinatra app:

<pre>require 'rubygems'
require 'sinatra'
require 'erb'

class HomeApp &lt; Sinatra::Base
  get "/" do
  	erb :index
  end
end</pre>

That whole HomeApp thing is something I’ll get to in a later post. One of the other things I like about Sinatra is that it’s built on top of [Rack](http://rack.rubyforge.org/), a very nice web server interface that a lot of Ruby web frameworks build on top of, and therefore play very nicely with each other.

### Host

[Heroku](http://www.heroku.com/). Why? How about this:

<pre>git push origin master;git push heroku master</pre>

That’s how I push to GitHub and then deploy. Also, I can get custom domains (like AutoMapper.org). GitHub pages, Tumblr and WordPress do this as well, but I wanted complete control over the site.

Plus, since Heroku supports a ton of Rack applications, I can be assured that I can add on whatever Rack app I might need on top of it. And no XML config files 😉

### DNS

Here, I asked around Twitter and got some recommendations for [dnsimple](https://dnsimple.com/r/18ba7dd8f1a214). A fantastic choice! Signing up was easy, and they can very easily add support for 3rd party application hosting. It was literally one button to add Heroku DNS records:

[<img style="display: inline; border: 0px;" title="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/08/image_thumb.png" border="0" alt="image" width="644" height="84" />](http://lostechies.com/content/jimmybogard/uploads/2011/08/image.png)

Just silly. There’s a ton of other applications supported, like Google Apps, Blogger etc. Crazy easy to get started, and I didn’t really even compare costs, since I care more about how easy it is to manage than how little the spokesmodels’ bikinis are. (Not even going to link to the host that shall not be named!)

### Blog

This is where things got a little tricky. I wanted to have a Blog page that shows news and announcements. I wanted this page to be completely integrated into the rest of the AutoMapper.org site, and not whisk you away to some other weird look and feel site. Sure, the wiki, mailing list and so on can be in different sites, but the blog belongs with the main site.

I looked at a hosted solution, like WordPress, GitHub pages, Tumblr, Blogger and a couple of others. But all of these were a bit of a beast to get their templates to look just like my site. I could work the DNS stuff out and do a subdomain, that was fine. But the templating was just a pain.

So I decided to use a Ruby blog engine instead. Lots of choices there, from [Typo](http://fdv.github.com/typo/), [scanty](https://github.com/adamwiggins/scanty), and [jekyll](http://jekyllrb.com/). Ultimately, I decided to go with [toto](http://cloudhead.io/toto), mostly because the authoring style matched my deployment method. With toto, you write posts in a [markdown](http://daringfireball.net/projects/markdown/) file, commit this to your git repository, and push the code to Github. Because toto is build on Rack, it integrated right in to my site.

Well, mostly. I’ll follow up with another post on integrating toto and Sinatra. It was a little bit of investigation and work, but it all worked out in the end. Rack lets you host multiple Rack applications in a single instance, so that let me host my toto blog in a “/blog” location, not affecting the rest of my site. No databases or anything like that, and I can still use [Disqus](http://disqus.com) to host my comments.

### Simple

So there you have it, soup to nuts the technology behind AutoMapper.org. The code is up on Github for all to ridicule. I like that I can pull the source from anywhere that I have my SSH key, and push the site back out. The total hosting cost to me is something like a couple of bucks a month for the DNS service. Other than that, the source control, build server, wiki, blog, mailing list and website hosting are all free.