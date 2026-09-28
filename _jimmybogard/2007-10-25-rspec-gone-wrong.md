---
wordpress_id: 88
title: RSpec gone wrong
date: 2007-10-25T14:35:29+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/10/25/rspec-gone-wrong.aspx
dsq_thread_id:
  - "351276187"
categories:
  - Misc
redirect_from: "/blogs/jimmy_bogard/archive/2007/10/25/rspec-gone-wrong.aspx/"
---
I&#8217;ve seen some weird things in code comments, but with [RSpec](http://rspec.rubyforge.org/), you can take programming humor to a different level.&nbsp; Don&#8217;t let your customers see these, though.&nbsp; Here are a few RSpec specifications gone completely wrong:

<pre>#this crap needs to be refactored. it makes no sense.
describe QueryFacade, "when querying for opportunities" do
  it "should be refactored" do
    flunk
  end
end</pre>

That was from [Terry](http://www.terrbear.org/), here&#8217;s another I found floating around somewhere:

<pre>describe "Buffalo Bill" do
  it "places the lotion in the basket" do
  end
end
</pre>

That a Silence of the Lambs reference, folks.&nbsp; And finally:

<pre>describe "our insane customer Initech" do
  it "should stop asking for ridiculous features and make up their $%^*ing mind" do
  end
end</pre>

Waaaay too much free time&#8230;