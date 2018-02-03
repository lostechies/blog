---
wordpress_id: 20
title: 'Python Web Framework Series – Pylons Part 7: Refactoring, Deployment And Wrap-Up'
date: 2009-07-04T12:00:00+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2009/07/04/python-web-series-pylons-part-7-refactoring-deployment-and-wrap-up.aspx
dsq_thread_id:
  - "425624235"
categories:
  - Authkit
  - Pylons
  - Python
---
Lets take a look at our existing site and what we can do to clean it up and add some badly needed functionality, however that is beyond the scope of my series. So I&rsquo;m going to leave some hints for the remaining functionality to get you started.

### Refactoring Ideas

### 

  1. Replace default authkit login with custom login. HINT: make a sign-in link on your public page. then redirect to a custom login page that uses authkit. Trying it any other way will make you lose hair.
  2. Refactor database access into a class or two. This will make the db access more testable and allow you to monkey patch in different behavior later. HINT: If your controllers can avoid having to know anything about SQLAlchemy you&rsquo;ve done your job.
  3. Replace return &ldquo;rsvihla&rdquo; in the users.py module with actual authkit user. HINT: just access pylons request object: &ldquo;request.environ.get(&#8220;REMOTE_USER&#8221;)&rdquo;
  4. Create admin ui for users, with roles. HINT: look at <a target="_blank" href="http://pylonsbook.com/en/1.0/simplesite-tutorial-part-3.html">Pylons Book</a> for Authkit ideas here.
  5. Split threads into categories and then give the ability to respond to posts. HINT: just more controllers and views.
  6. Makes parts of your view visible depending on if a user has certain rights or not. HINT: while this is not what you&rsquo;ll find in the Pylons Book I highly suggest not have gobs of if/else checks in your views. Make small functions that you can unit test easily which will change what is visible depending on role, then have your views call these. See what I did with my user.py module for a concept.

### Deployment

This almost completely depends on your situation with hosting. If you are using something like <a target="_blank" href="http://www.webfaction.com/">WebFaction</a> you just have to upload files and follow their directions. I found it trivial to have a production site up and running with them. 

Now if you are using your own dedicated server or want to shrink wrap the project I suggest using Python Eggs, this is not pylons specific at all and I&rsquo;ve built them for a number of other projects. There are some snags you can run into depend on your platform and how portable you want to make this but as long as your dev platform and production platform are the same all you need is &ldquo;python setup.py bdist\_egg&rdquo; and you should have a egg file in the dist directory which can be installed with easy\_install.

Finally, you&rsquo;ll want to build a production.ini . By and large you can copy your development.ini but you must must make your debug = false or you&rsquo;ll give people access to your application in all sorts of bad ways.&nbsp; Also, don&rsquo;t forget to make your secret strings actually secret strings. 

### Overall Impressions

Things I like:

  * Pretty easy to get up and running quickly.
  * paster and nose integration is pretty slick.
  * being able to functional test response including view is actually nice.&nbsp; Really wish I had this in Monorail as easily.
  * Component based to the hilt. If you really don&rsquo;t like something you can switch it out. 

Things I don&#8217;t like:

  * AuthKit is like all auth frameworks I&rsquo;ve used, just a lot to make work the way I want.
  * Too much violation of dry in the config. AuthKit being the main culprit here, while I may want to change which datasource I use, I&rsquo;m not sure how helpful it is to have to select &ldquo;form, cookie&rdquo; for each ini file I make.
  * Explicitly calling the view in my actions. Should have some convention over configuration here.

So I could certainly see using Pylons more once I get my own auth solution worked out, and get my own code flow working I could actually probably get work done more quickly in it than most web frameworks I&rsquo;ve learned.&nbsp; The majority of the time I wasted learning was dealing with authkit, in fact that took more time than everything else I studied combined.

Thank you for taking the time to get this far with my posts. If you have any specifics parts you want me to dive into more depth and/or suggestions for me on the next series (which will be Pyxer with Google App Engine) let me know.