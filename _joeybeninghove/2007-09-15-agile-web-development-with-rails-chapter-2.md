---
wordpress_id: 31
title: 'Agile Web Development with Rails &#8211; Chapter 2'
date: 2007-09-15T12:42:56+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/09/15/agile-web-development-with-rails-chapter-2.aspx
categories:
  - Books
  - Rails
  - Reviews
  - Ruby
redirect_from: "/blogs/joeydotnet/archive/2007/09/15/agile-web-development-with-rails-chapter-2.aspx/"
---
Got.&nbsp; To.&nbsp; Learn.&nbsp; Ruby.&nbsp; On.&nbsp; Rails.

#### Chapter 2

[Chapter 1](http://joeydotnet.com/blog/archive/2007/09/13/agile-web-development-with-rails---chapter-1.aspx) was mainly a high-level&nbsp;introduction to Ruby and the Rails framework.&nbsp; Chapter 2 starts off with some of the history behind the MVC pattern and how it was originally intended for &#8220;fat&#8221; client applications.&nbsp; It&#8217;s interesting that when developers first started building web applications, they seemed to largely ignore patterns like MVC and just shoved everything together.&nbsp; We developers soon wised up and came up with various frameworks like Struts and&nbsp;ASP.NET WebForms (which is a very poor implementation of MVC, IMHO).&nbsp; 

It then goes into the basics of how MVC works, which I won&#8217;t bother to repeat here,&nbsp;since most folks who read my blog are probably already familiar with it.&nbsp; But they do a fine job of introducing&nbsp;how the MVC pattern works&nbsp;in Chapter 2 which is&nbsp;obviously essential in order to use an MVC framework like Rails.

And&nbsp;now we come to the&nbsp;touchy subject of&nbsp;the&nbsp;Active Record pattern.&nbsp; I have a love/hate relationship with the Active Record pattern.&nbsp; While I love its simplicity and ability to get something running very quickly, I&#8217;m also a huge proponent of Domain-Driven Design and rich domain models with persistent ignorant (PI) domain objects.&nbsp; Castle&#8217;s ActiveRecord implementation is quite nice, however, especially since it allows you to use an ActiveRecordMediator instead of having to subclass your domain objects.&nbsp; Many folks have talked about DDD within the context of the Active Record pattern.&nbsp; [Nelson](https://lostechies.com/blogs/nelson_montalvo/default.aspx) shares his thoughts on&nbsp;[Castle&#8217;s ActiveRecord from a DDD perspective](https://lostechies.com/blogs/nelson_montalvo/archive/2007/04/16/castle-s-activerecord-not-for-the-domain-purist-in-you.aspx) on his blog.

At this point,&nbsp;Active Record in Rails is starting to grow on me, because I understand that the Rails framework is an &#8220;opinionated framework&#8221; and should only be used when it&#8217;s a good fit for your particular project.&nbsp; Although, if you haven&#8217;t watched it yet, I would highly recommend you watch [this keynote from DHH at RailsConf 2006](http://www.scribemedia.org/2006/07/09/dhh/).&nbsp; David makes some very interesting points about how often you may think something is not CRUD, when in fact it really could be.&nbsp; Then we get to see some more Ruby code, this time dealing with retrieving and saving objects using Active Record.&nbsp; Again, the elegance of the code just blows me away.&nbsp; 

And finally is what they call Action Pack.&nbsp; This pretty much encompasses the &#8220;V&#8221; & &#8220;C&#8221; parts of MVC.&nbsp; View and Controller.&nbsp; 

The 3 main view template types are explained a little, rhtml,&nbsp;rjs and rxml.&nbsp; Views using rhtml are basically the same as brail views (.brail) if you&#8217;re familiar with MonoRail.&nbsp; They are just html files with ruby code sprinkled in to make the pages dynamic.&nbsp; Rjs views are similar to brailjs views in MonoRail and are primarily used for javascript fragments and AJAX.&nbsp; Rxml views sound very interesting.&nbsp; Being that I&#8217;m not a fan of hand-writing XML files, I&#8217;m excited to see how I can use the ruby language to generate&nbsp;XML documents.

The Controller is where everything starts.&nbsp; It&#8217;s responsible for things like routing, caching and session management.&nbsp; It&#8217;s also where most of the interaction with your Model will take place.&nbsp; 

This chapter is wrapped up by telling you that now it&#8217;s time to start building some stuff.&nbsp; Schweet!&nbsp; 🙂