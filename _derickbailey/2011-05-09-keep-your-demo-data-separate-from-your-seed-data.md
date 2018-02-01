---
id: 300
title: Keep Your Demo Data Separate From Your Seed Data
date: 2011-05-09T06:08:51+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=300
dsq_thread_id:
  - "299147849"
categories:
  - Data Access
  - Deployment
  - Model-View-Controller
  - Rails
  - Ruby
---
File this under the &#8220;duh&#8230;&#8221; category&#8230; I don&#8217;t know why this wasn&#8217;t obvious.

Joey and I have been working on our rather large app for a while now, with a bunch of demo accounts and data added with our seed files. When we finally started deploying versions of the app to our staging environment so that our client could watch as we made progress, we realized the need to keep our demo accounts and data separate from our seed data. The seed data was changing rapidly and we needed to re-seed the database on every deploy, but we didn&#8217;t want to lose the demo accounts or the accounts that we had created for the clients.

The answer to this is pretty simple / obvious, once [Brian Hogan showed me the way he handles it](http://pastie.org/private/4gkmylabnjltnxyxl2nhq): create a custom rake task that puts the demo accounts and data into the database, so that we can run it only when we need to. That way, when db:seed is run, we won&#8217;t wipe out our accounts.

<pre>namespace :bootstrap do

   task :foo =&gt; :environment do
     u = User.create :login =&gt; "foo", :password =&gt; "1234", :password_confirmation =&gt; "foo"
     u.roles &lt;&lt; Role.find_by_name "admin"
     u.roles &lt;&lt; Role.find_by_name "user"
     u.projects.create :name =&gt; "My test project"
   end

   task :demo =&gt; :environment do
     u = User.create :login =&gt; "demo", :password =&gt; "1234", :password_confirmation =&gt; "foo"
     u.roles &lt;&lt; Role.find_by_name "user"
     u.projects.create :name =&gt; "My demo project"
   end

   task :all do
      Rake::Task["db:schema:load"].invoke
      Rake::Task["db:seed"].invoke
      Rake::Task["bootstrap:demo"].invoke
      Rake::Task["bootstrap:foo"].invoke
   end
end</pre>

 

Now I can run \`rake bootstrap:demo\` any time I need to, or not at all when doing general deployments and re-seeding the staging database. As an added bonus, the demo data is created using our actual models. This means they are all validated at runtime, ensuring we had good demo data in place.

A much larger problem, though, is how to handle the maintenance of seed data over time in a rather large application. This is a much more difficult problem with a lot more context and consideration. I think we finally have a solution, though&#8230; and it&#8217;s much easier than expected. But, that&#8217;s another blog post hopefully coming soon; after we&#8217;ve had a chance to run this through it&#8217;s paces and verify it really does what we want.