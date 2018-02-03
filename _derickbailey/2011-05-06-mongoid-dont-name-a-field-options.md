---
wordpress_id: 296
title: 'Mongoid: Don&#8217;t Name A Field :options'
date: 2011-05-06T13:07:57+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=296
dsq_thread_id:
  - "297170477"
categories:
  - Data Access
  - Debugging
  - MongoDB
  - Mongoid
---
Joey and I spent the last day or more upgrading our rails environment, specifically so that we could get from Mongoid v2.0.0.Beta.20 up to v2.0.1. In general, the upgrade went ok&#8230; with the exception of the Mongoid upgrade. There are a significant number of changes in how relationships work and the new polymorphic behavior is awesome! I&#8217;m really glad we took the time to do the upgrade because it&#8217;s already making our lives easier.

 

## A Nasty Little Bug

During the upgrade process, we ran into on really sticky issue that was causing a lot of pain and frustration.

<pre><pre><div class="line">
  wrong number of arguments (1 for 0)
</div>

<div class="line">
  /Users/joey/.rvm/gems/ruby-1.9.2-p180@vk/gems/mongoid-2.0.1/lib/mongoid/fields.rb:125:in `block (2 levels) in create_accessors'
</div>

<div class="line">
  /Users/joey/.rvm/gems/ruby-1.9.2-p180@vk/gems/mongoid-2.0.1/lib/mongoid/relations/accessors.rb:158:in `block (2 levels) in setter'
</div>

<div class="line">
  /Users/joey/.rvm/gems/ruby-1.9.2-p180@vk/gems/mongoid-2.0.1/lib/mongoid/extensions/object/yoda.rb:22:in `do_or_do_not'
</div>

<div class="line">
  /Users/joey/.rvm/gems/ruby-1.9.2-p180@vk/gems/mongoid-2.0.1/lib/mongoid/relations/bindings/embedded/many.rb:47:in `bind_one'
</div>

<div class="line">
  /Users/joey/.rvm/gems/ruby-1.9.2-p180@vk/gems/mongoid-2.0.1/lib/mongoid/relations/embedded/many.rb:72:in `bind_one'
</div>

<div class="line">
  /Users/joey/.rvm/gems/ruby-1.9.2-p180@vk/gems/mongoid-2.0.1/lib/mongoid/relations/embedded/many.rb:328:in `append'
</div>

<div class="line">
  /Users/joey/.rvm/gems/ruby-1.9.2-p180@vk/gems/mongoid-2.0.1/lib/mongoid/relations/embedded/many.rb:29:in `block (2 levels) in &lt;&lt;'
</div>

<div class="line">
  /Users/joey/.rvm/gems/ruby-1.9.2-p180@vk/gems/mongoid-2.0.1/lib/mongoid/relations/embedded/many.rb:27:in `each'
</div>

<div class="line">
  /Users/joey/.rvm/gems/ruby-1.9.2-p180@vk/gems/mongoid-2.0.1/lib/mongoid/relations/embedded/many.rb:27:in `block in &lt;&lt;'
</div>

<div class="line">
  /Users/joey/.rvm/gems/ruby-1.9.2-p180@vk/gems/mongoid-2.0.1/lib/mongoid/relations/embedded/atomic.rb:58:in `call'
</div>

<div class="line">
  /Users/joey/.rvm/gems/ruby-1.9.2-p180@vk/gems/mongoid-2.0.1/lib/mongoid/relations/embedded/atomic.rb:58:in `block in atomically'
</div>

<div class="line">
  /Users/joey/.rvm/gems/ruby-1.9.2-p180@vk/gems/mongoid-2.0.1/lib/mongoid/relations/embedded/atomic.rb:79:in `call'
</div>

<div class="line">
  /Users/joey/.rvm/gems/ruby-1.9.2-p180@vk/gems/mongoid-2.0.1/lib/mongoid/relations/embedded/atomic.rb:79:in `count_executions'
</div>

<div class="line">
  /Users/joey/.rvm/gems/ruby-1.9.2-p180@vk/gems/mongoid-2.0.1/lib/mongoid/relations/embedded/atomic.rb:57:in `atomically'
</div>

<div class="line">
  /Users/joey/.rvm/gems/ruby-1.9.2-p180@vk/gems/mongoid-2.0.1/lib/mongoid/relations/embedded/many.rb:26:in `&lt;&lt;'
</div></pre>


<p>
   
</p>


<h2>
  A New Rule For Mongoid
</h2>


<p>
  Joey had run into this issue previously and at the time, we didn&#8217;t have the time to work through it. I decided to spent all last night (til 1am) trying to get through the issue&#8230; after a lot of work, debugging and logging efforts I finally tracked the issue down to one little change / rule that you need to adhere to in Mongoid 2.0+
</p>


<blockquote>
  <h2>
    Don&#8217;t Name A Field :options, in Mongoid
  </h2>
  
</blockquote>


<p>
  Of the 90+ failing cucumber tests that we had after upgrading the gems, this one little lesson learned was the cause of more than half of them. The others were simple little things that kind of made sense as we analyzed each of them, given all of the changes in how embedded and referenced document relationships had changed.
</p>


<p>
   
</p>


<h2>
  Bug Hunting
</h2>


<p>
  The way I found this little rule, though, was a little odd. When I started the upgrade process, I knew that Joey was running into this issue. Instead of trying to upgrade to the 2.0.1 release immediately, I started by trying to go from beta.20 to rc.1, just to see if it would work with no issues; it didn&#8217;t. But I decided to try my luck and pushed through rc.2, rc.3, etc etc.
</p>


<p>
  Somewhere along the way, Mongoid threw an exception at me saying that I had named a field :options and that this wasn&#8217;t allowed because it&#8217;s an internal field that mongoid uses. Apparently creating a field called this overwrites the internal #options method and causes all kinds of havoc. Well, I didn&#8217;t make the connection immediately, as I was just trying to run through all of the rc&#8217;s and releases, to see what would happen. It wasn&#8217;t until some time later, after a lot of debugging and logging that I finally narrowed the &#8220;wrong number of arguments&#8221; exception down to a few specific classes. It was then that I noticed each of these classes had a field called :options. Once I changed this (and all of the subsequent places that used it), this error went away.
</p>


<p>
  Hopefully I can save someone else a little heart-ache with this blog post. It took us long enough to figure it out, and in the end it&#8217;s a fairly obnoxious bug. Honestly, I don&#8217;t think it was a good decision on the part of the mongoid team, but that&#8217;s another discussion probably best had on the mongoid mailing list.
</p>