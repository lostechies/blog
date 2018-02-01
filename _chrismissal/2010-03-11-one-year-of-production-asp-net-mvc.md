---
id: 3380
title: One Year of Production ASP.NET MVC
date: 2010-03-11T04:20:00+00:00
author: Chris Missal
layout: post
guid: /blogs/chrismissal/archive/2010/03/10/one-year-of-production-asp-net-mvc.aspx
dsq_thread_id:
  - "262175211"
categories:
  - ASP.NET MVC
  - development
---
Last week marked the one year anniversary our team’s first ASP.NET MVC application in production. We really have two different types of production. Internal and external. While an internal application might get used by 2 to 100 people, our external applications get used by millions. After chatting with some members of the team and looking at the source code from a year ago, I’d like to share some thoughts with you. Let’s take a look back into the past, all the way back to the year 2009.

## What Did We Learn?

### Sacrifices Were Made

I’ll be the first to admit that the project wasn’t where most of us wanted it a year ago, but the sacrifices we did make were consolations we were willing to live with. The easy one to point out is stuffing objects/data in ViewData. This seemed like a good idea at the time (and it was fast), but just gets messy in a hurry. You wont find this in many places anymore. We’ve been cleaning up that sort of thing while we’re in those areas and things look much tidier now.

### Flexibility Was Achieved

The ability to cover our code with tests in MVC was much easier than the previous code in WebForms. This has allowed our code to be quite malleable. There are still some areas that are harder to test, but they disappear each week as we simultaneously see our code coverage marks rising.

### Treat Routing With Respect

Routes are great, but they’re better when created earlier rather than later. If you’re starting on something new, be sure you thinking about your route conventions towards the beginning of the project and not as an afterthought. Wanting to change these up after the application is in production, you might have to end up breaking URLs or having to do some re-writing. The other big factor is realizing your site’s information architecture and how this is important to your site’s URL/directory structure. Big bonus points if you can nail this down right away and not have to worry about it after version 1.

### Comments From the Team

> With the ability to keep views small and concise I am left with significantly less (duplicated) code to wade through while working with CSS and jQuery. I&#8217;ve noticed a definite decrease in time spent working in individual files allowing me more time to spend on enhancements and improvements. This last year I&#8217;ve designed more pages and worked on far more new features than any other year before, and hoping to continue that trend into the next year. – <a href="http://twitter.com/jbertling" rel="nofollow">Jessica</a>
> 
> MVC provides the hooks to quickly and easily do what we want.&#160; Case in point, the other day using in our dev session looking at overriding a "default" page with a custom page just by the existence of the page (view). With webforms this is possible but it&#8217;s a pain with the page controller pattern dictating the flow of things.&#160; This allows us to more quickly respond to the needs of the business with less code in a more discoverable location &#8211; arguing the code we implemented is much clearer than an HttpModule (with webforms). &#8211; <a href="http://twitter.com/timbarcz" rel="nofollow">Tim</a>

## What am I Looking Forward to in the Coming Year?

### Conventions, Conventions, Conventions

Nothing new here. The more time we spend in our code, the more certain parts of it look alike. Humans are good at spotting patterns and our group is very “humany”. (If that word isn’t invented yet… patent pending!) In all seriousness though, adhering to conventions can greatly reduce the time to market for new features, just ask the Ruby crowd. We’re finding more and more opportunity for conventions all the time.

### Builders/Templates

Essentially just more conventions ideas. MVC2 will allow us to use model templates (like input builders in MvcContrib), that we’re likely going to be taking advantage of. The typical usage I’m seeing is input forms, but we don’t have tons of forms within our project. We do have a lot of code that can make use of jQuery and progressively enhanced displays as well as templating many of our repeated and/or similar models.

## Thanks…

Obviously we’re not the only ones out there who use MVC. There seems to be many that are blogging about the pros/cons as well as giving tips and tricks on how to make MVC work better. I just want to say thanks, and keep it up!