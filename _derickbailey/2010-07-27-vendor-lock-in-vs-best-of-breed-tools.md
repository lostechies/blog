---
wordpress_id: 176
title: Vendor Lock-In Vs. Best Of Breed Tools
date: 2010-07-27T12:00:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/07/27/vendor-lock-in-vs-best-of-breed-tools.aspx
dsq_thread_id:
  - "263607628"
categories:
  - Continuous Improvement
  - Pragmatism
  - Tools and Vendors
---
I posted the bulk of this on the Albacore group as a reason for my wanting to take Albacore down to it’s “core” as a suite of build related tasks (which I talked about in the [Preview1 post](http://www.lostechies.com/blogs/derickbailey/archive/2010/07/14/albacore-v0-2-0-preview-1-is-available.aspx)). However, I thought the information was enough to warrant it’s own post on my blog… so here it is: why I think best-of-breed tools that you tie together yourself tend to be better than the all-in-one vendor lock-in approach.

&#160;

As a .net developer, I’m used to seeing the "all in one" solutions being handed to us by various vendors. Microsoft gives us Visual Studio, they give of Office, they give us Team Foundation Server. Telerik gives us UI controls for WinForms, Web, WPF, and even an ORM and test framework. Oracle provides a database engine, business rules / erp system and much much more. It&#8217;s the nature of software-as-a-business model, to a certain extent – at least in the .NET world. Vendors want you to use their tools because they need to make money. So it makes sense for every vendor to offer complete solutions that work well with their own items. You see a lot of integration and interop between the products that one particular company produces. 

Unfortunately, this has a ripple-effect into the open source efforts in .NET as well. There tend to be a lot of the same things being done by many different people because everyone expects to see a one-stop-shop for the things that go hand-in-hand.   
In the ruby world (and in the *nix world in general), you don&#8217;t see this very often, if at all. You see many individual pieces being put together to create something that is larger than the sum of the individual parts. Many of the small pieces that one large system uses will be pulled from many different vendors, and each of them will do their one specific thing really really well. Look at Rails3 for example. There’s the core of Rails, but there’s also the direct use of Thor, the SQLite integration, the Test::Unit and RSpec integration, the Rake integration, etc. There are so many parts of what Rails is that most people outside of the ruby world tend to think that Rails is the only thing that ruby does (yes, I have heard people say things close to this).

Looking back at my development experience, I’ve been exposed to both worlds – the vendor lock-in world and the best-of-breed world. At this point in my career, I prefer the many-tools, best-of-breed approach. I&#8217;ve done the whole vendor-lockin thing with one stop shops and it has burned me more times than i can count. There are inevitably issues that I have with the toolset and/or things I want to do that the toolset just can’t do, and I’m stuck. I am using the tools that don’t do what I need and often can’t do anything about that. Having taken the other approach in the tools and vendors that i choose over the last 4 years or so, I find it to be overall better. Instead of locking me into VS+TFS and the "one microsoft way", for example, I found subversion + trac + apache. Later, trac no longer served my needs so i switched to redmine. When that no longer served, I dropped trac and apache and went to VersionOne (letting them host it). Now that subversion is no longer fitting my needs, I am in progress of dropping it for git.   
The best-of-breed mentality and capabilities of many small pieces gives me flexibility and control in situations like this.

Now this doesn’t mean that I won’t choose a vendor simply because they are an all-in-one package. There are times when that package is going to be the right tool for the job at hand, and those tools should be consider and used when appropriate. The point I’m making is that when you do select a tool – any tool – be sure that you are selecting the tool that fits your needs for what they are, and be sure to find tools that allow you to change according to how you need to change. Chances are, the big all-in-one tool (like TFS) is not going to be sufficient for every one of your needs unless you are willing to bend your needs to what the tool can do. And that, quite frankly, is the wrong thing to do. A good selection of the best-of-breed tools may take a little more time to set up and learn, but it will likely pay for itself in the long run when you are able to replace one or more pieces to keep up with your team’s needs.