---
wordpress_id: 72
title: 'Quick Fix (and a question): Mongoid Edge'
date: 2010-06-10T15:44:00+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2010/06/10/quick-fix-and-a-question-mongoid-edge.aspx
categories:
  - MongoDB
  - Mongoid
  - RSpec
  - Ruby
redirect_from: "/blogs/joeydotnet/archive/2010/06/10/quick-fix-and-a-question-mongoid-edge.aspx/"
---
I just went throught the process of upgrading my current app to the latest edge for Rails 3, Mongoid and all of my other
  
gems. And when I went to run my specs, I received this error:

<pre>Database command 'drop' failed: {"ns"=&gt;"your_db.system.indexes", "errmsg"=&gt;"assertion: can't drop system ns", "ok"=&gt;0.0}
</pre>

The only time a drop is called is in my **spec_helper.rb** file:

**/spec/spec_helper.rb**

<pre>Rspec.configure do |config|
      # other config stuff here

      config.before(:each) do
        Mongoid.master.collections.each(&:drop)
      end
    end
</pre>

What that block does is drop all of my Mongoid collections before each spec is run to ensure I have a &#8220;known state&#8221; for
  
my specs. This has always worked just fine as is, but it appears that something has changed in the latest Mongoid
  
causing it to error on attempting to drop &#8220;system.indexes&#8221;. After some tinkering, this is how I resolved it:

**/spec/spec_helper.rb**

<pre>Rspec.configure do |config|
      # other config stuff here

      config.before(:each) do
        Mongoid.master.collections.select { |c| c.name != 'system.indexes' }.each(&:drop)
      end
    end
</pre>

Simple fix, but it gets the job done. I just simply exclude &#8220;system.indexes&#8221; from the collections to drop and all is
  
well. Since this is only for my tests, I think this should be fine. But&#8230;

I want to know if anyone else knows _why_ this is happening and if there is a better way to resolve it. Anyone?