---
wordpress_id: 436
title: Canonical URLs with Rack and Heroku
date: 2010-09-24T03:22:08+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/09/23/canonical-urls-with-rack-and-heroku.aspx
dsq_thread_id:
  - "264716598"
categories:
  - Ruby
redirect_from: "/blogs/jimmy_bogard/archive/2010/09/23/canonical-urls-with-rack-and-heroku.aspx/"
---
In my Heroku/Sinatra adventures, I wanted to make sure that I enforced canonical URLs.&#160; That is:

foo.com

Got [301’d](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.3.2) to:

www.foo.com

This helps with SEO optimization, because you don’t want [80 different ways to get to the same content](http://www.hanselman.com/blog/UsingISAPIRewriteToCanonicalizeASPNETURLsAndRemoveDefaultaspx.aspx).&#160; With Heroku, this is a snap, as [Heroku](http://heroku.com/) supports [Rack modules](http://rack.rubyforge.org/).&#160; Lo and behold, google found me [this great post](http://www.protectedmethod.com/blog/4c5f157999cf9f4cdd000004/ensure_the_correct_canonical_domain_in_sinatra) on using a simple Rack module, [ForceDomain](http://coderack.org/users/cwninja/middlewares/106-rackforcedomain), to do this.

I just followed the instructions on the site, fixed my config.ru:

<pre>require 'hello'
require 'rack/force_domain'
use Rack::ForceDomain, ENV["DOMAIN"]
run Sinatra::Application</pre>

A git push later and I was finished.&#160; Permanent 301 redirects to enforce canonical URLs from foo.com to [www.foo.com](http://www.foo.com).

Of course, the [ForceDomain code](http://github.com/cwninja/rack-force_domain) is up on GitHub if you’re interested in peaking behind the covers.&#160; Naturally it’s like 6 lines of Ruby code, the rest being the Rack/Gems stuff.