---
wordpress_id: 280
title: Using Mongo And Mongoid Without Rails
date: 2011-05-02T06:31:29+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=280
dsq_thread_id:
  - "293313991"
categories:
  - Bundler
  - Database
  - MongoDB
  - Ruby
---
In my previous post on [writing a thor application](http://lostechies.com/derickbailey/2011/04/29/writing-a-thor-application/), I mentioned the use of mongo db and the [mongoid document mapper](http://mongoid.org/), and how I am using these tools outside the context of a rails application. As I mentioned in that post, it&#8217;s turned out to a fairly simple thing to do. I was surprised at how easy it was to get set up, configure and use, honestly.

 

### Bundling Mongoid With My App

I use bundler and RVM together, to organize and manager my ruby versions and gems for my applications. It&#8217;s a powerful little combination and makes the setup and configuration of Mongoid really simple. Here&#8217;s the contents of the Gemfile for the application that I showed in my post on writing a thor app:

<pre>source :rubygems<br /><br />gem 'mongoid', '2.0.1'<br />gem 'ruby-hl7', '1.0.3'<br />gem 'thor', '0.14.6'<br />gem 'bson_ext', '1.3.0'<br />gem 'whenever', '0.6.7'<br />gem 'rake', '0.8.7'<br />gem 'vlad', '2.2.0'<br />gem 'vlad-git', '2.2.0'</pre>

 

It&#8217;s a fairly simple Gemfile, but even with such a small number of gems, it&#8217;s important to keep everything organized and on the right versions. Therefore, the use of a Gemfile is nearly essential to any ruby application &#8211; rails or not. Run &#8216;bundle install&#8217; with this Gemfile in place, and everything I need is installed &#8211; including the mongoid gem.

 

### Command Line vs YAML Configuration

Once mongoid is installed, you have a few options for configuring it, [according to the documentation](http://mongoid.org/docs/installation/configuration.html). You can either load up the configuration via a yaml file, or call \`Mongoid.configure\` to set things up.

The first pass I made at this was using a yaml file. I started by copying a mongoid.yml file out of a rails app, but that failed miserably. Apparently, the mongoid rails integration does some magic to handle a structured yml file with many different environments in it. However, with v1.x of mongoid, the standard .load! method does not parse an environment section. Perhaps v2.x does, but I haven&#8217;t had a chance to upgrade and try it, yet.

In the end, I went with the code configuration of Mongoid. This was done partially because I didn&#8217;t want a bunch of yml files around, and partially so that I could figure out the best way to supply the configuration from the environment that is running the application, at deploy time, or whenever (but that&#8217;s another post.)

I also didn&#8217;t use the code that was supplied in the documentation. Honestly, that code is a little lacking &#8211; it does nothing more than show you how to connect to a database. It doesn&#8217;t do anything to show you how to connect with a username and password, a server name and port, or anything else. Fortunately, Robin Mayfield has a [great little post](http://rujmah.posterous.com/using-mongoid-without-rails) with a nice little update at the bottom, showing an easy way to do all of this. I took his code and modified it to work with the optional command line parameters of my thor script, allowing no configuration to be passed in (which defaults the server to localhost and the database to my development database) or the options of username, password, server, database name, and port # to be passed in. The end result looks like this:

<pre>Mongoid.database = Mongo::Connection.new(options.server).db(options.database)
if options.user
  Mongoid.database.authenticate(options.user, options.password)
end</pre>

 

The options class comes from my post on [building a thor application](http://lostechies.com/derickbailey/2011/04/29/writing-a-thor-application/). This is the OpenStruct that I created out of the options hash that thor created for me. Also note that I&#8217;m never checking or defaulting the server and database values in this code, directly. I&#8217;m letting thor do that for my by using the :default => &#8220;value&#8221; option for the method_options in question.

These few lines of code are all I needed to configure mongoid in my little app, in combination with the options that the thor script provides.

 

### Model As If It Were A Rails App

From here, I&#8217;m able to model and use my models as if I were writing a rails app with mongoid. Creating a mongoid document is as simple as

<pre>class MyModel<br />  include Mongoid::Document<br /><br />  field :some_field<br />  field :a_date, :type =&gt; DateTime<br />  <br />  embeds_one :that_model<br />end </pre>

 

And I now have all the persistence that I need for my model, including the embedded that_model document. Of course, my models are no where near this simple. I&#8217;ve got a fair amount of business logic in most of them, multiple models to represent the hierarchy of data and process that my app needs, etc. However, I did not have to do anything special or learn anything new to build my models outside of the rails app. It was only the configuration of mongoid that needed anything different&#8230; yet another reason that I love mongoid. It&#8217;s just a pleasure to work with, most of the time.

 