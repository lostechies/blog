---
wordpress_id: 73
title: From ALT.NET to NOT.NET
date: 2010-06-23T15:44:00+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2010/06/23/from-alt-net-to-not-net.aspx
categories:
  - ALT.NET
  - Community
  - microprenuer
  - Rails
  - Ruby
redirect_from: "/blogs/joeydotnet/archive/2010/06/23/from-alt-net-to-not-net.aspx/"
---
For a long time now I&#8217;ve been known as &#8220;joeyDotNet&#8221;. Of course I&#8217;ll never make the mistake tying my name to a
  
particular technology like that again. Especially given some of the recent changes I&#8217;ve made in my career. For the
  
past 10 years I&#8217;ve been primarily a web developer using Microsoft-based technologies. In the latter years I started
  
to grow pretty frustrated with both the Microsoft development stacks as well as their operating systems. The ALT.NET
  
&#8220;movement&#8221; helped a little, but for me, the bloat of the development tools and ceremony required in the languages
  
overshadowed the well-intentioned ALT.NET efforts. Of course this is merely my own personal opinion.

A couple months ago I made a pretty big change by leaving .NET completely to start focusing on learning and building
  
software using tools and frameworks that I enjoy and involve less friction. But instead of hearing me whine about my
  
specific issues with .NET development, I thought maybe I would give a glimpse into my experience so far as I&#8217;ve become
  
part of the NOT.NET crowd.

Perhaps I&#8217;m a glutton for punishment, but I find that in order to really learn something, I have to throw myself into
  
the lake and basically sink or swim. That&#8217;s pretty much what I&#8217;ve done by leaving .NET into the world of Ruby.
  
Today marks exactly 2 months that I&#8217;ve been working exclusively with Ruby/Rails and I have to say it has been a very
  
enjoyable experience so far (and frustrating at a few times). I&#8217;ve dabbled with the Ruby language and with Rails a bit
  
over the past couple years, so I had an idea of what I was getting into. Doing it 100% day in/out is a completely
  
different story though. But at this point, I&#8217;m not looking back a bit.

## Good

### Operating systems are cool again

One of things I&#8217;ve very much enjoyed is being able to completely ditch Windows as an operating system in favor of using
  
my MacBook Pro with OSX for everything. It&#8217;s no secret that I&#8217;m a pretty big Apple fan, and I think, for good reason.
  
The simplicity of the OS and the top notch software that is available for OSX makes the actual usage of the various
  
design and development tools fun and productive again.

### Simple tools, less friction

Since I&#8217;m a huge fan of Vim, I&#8217;m naturally using MacVim as my main editor, along with a few Terminal windows and a browser.
  
That&#8217;s it. No fancy IDEs or designers to get in my way. Just code. I am using a couple Vim plugins to allow better
  
navigation around the code. [NERDTree](http://www.vim.org/scripts/script.php?script_id=1658) and
  
[Command-T](http://www.vim.org/scripts/script.php?script_id=3025) which I would highly recommend. I&#8217;ve also jumped head
  
first into Git as my primary source control and I continue to be very happy with that decision. All those years wasted
  
on Subversion, which incidentally performs subversive acts on the instituion of actually getting things done!

### Doing more with less

One of the common themes I&#8217;ve found so far in working with Ruby in general and Rails in particular is how much work you
  
can actually get done with so little code/effort. In 2 months time I&#8217;ve been able to build a fairly sizable greenfield
  
Rails app from the ground up and almost ready for the first production deployment next week. All while I do a TON of
  
learning in the process. I have no clue how long
  
this would&#8217;ve taken me in .NET, but I&#8217;m certain it would have been significantly longer. Once you don&#8217;t have to deal
  
with IDEs, solutions, project files, unnecessarily complex build scripts, high-ceremony languages or even compilation,
  
you really start to realize how much overhead all of that stuff adds, preventing you from getting real work done, fast!

### Buh-bye IoC containers

In my experience with C# over the years, it became apparent to me that in order to be productive in building flexible
  
software in .NET that the use of an IoC container to handle dependency resolution was pretty much required. And I
  
totally bought into it, using them heavily for many years. And for the most part, I think it was a good idea. However
  
I will freely admit that a lot of my usage of them was to enable mocking and easier testing. I think if a lot of
  
developers were honest about it, they&#8217;d say the same thing. That&#8217;s not to say that&#8217;s the only reason of course. IoC
  
has its place in doing some crazy stuff with decorators/proxies and all kinds of other useful jazz.
  
Contrast that with Ruby and I can honestly say I have not missed IoC containers one bit. Being able to work in a much
  
more open language has been a joy. Composition over Inheritance is the real deal in Ruby and it&#8217;s being demonstrated
  
more and more in frameworks like Rails 3 and Mongoid. Being able to open up and extend any class in Ruby is also
  
extremely powerful (and dangerous!).

### Feeling the love

Perhaps one of the more feel-good things about working with open technologies like Ruby is the community. I honestly
  
have never experienced a community who is more willing to help out with _anything_ like I&#8217;ve seen in the Ruby community
  
so far. I&#8217;ve made a great many friends so far and hope that I can start contributing back to the community once I get
  
my head above water. Open source in the .NET world has grown a bit over the years, but it still seems light years away
  
from the Ruby and related communities. And I&#8217;m not sure why, but I can&#8217;t help but think it has something to do with a certain corporate
  
entity behind .NET.

### Making dreams come true

For quite a few years now I&#8217;ve had an increasing urge to go &#8220;out on my own&#8221; and be &#8220;independent&#8221;. More specifically
  
I&#8217;ve dreamed for a long time now about making a living by building my own software. A
  
[Microprenuer](http://www.micropreneur.com), if you will.
  
But the whole time I pretty much knew there is absolutely NO way I would build my own software products using Microsoft
  
technology. In my opinion technologies like Rails, Node.js and MongoDB are much better suited to building next generation
  
web applications than anything on the Microsoft stack right now. I&#8217;m sure many will differ with that opinion, but
  
that&#8217;s just how I see it. So in order to move closer to my dreams and goals, I knew I would have to move away from the
  
Microsoft world at some point. I&#8217;ll always wish I had done it sooner, but with Rails 3 getting ready to &#8220;ship&#8221; it seems
  
like a great time to be focusing my efforts there.

## Bad

### Becoming one with the *nix

I admit it. Early on, it has been tough to get up to speed on the _nix tools and setting up Linux servers, etc. I&#8217;ve
  
always been a pretty big command line junkie. But I&#8217;ve learned that being a *Windows_ command line dude is a whole lot
  
different than sitting down at a Bash shell for the Linux slice you just bought and now need to get setup with a full
  
Rails stack. Nevertheless, I&#8217;ve forced my way through it thanks to the interwebs and honestly in great part due to the
  
great articles over on [Slicehost](http://articles.slicehost.com). I still have a lot more to learn, but I&#8217;m starting
  
to realize that those crazy bearded Linux heads are onto something. 🙂

### Living on the edge

In accordance with my sink or swim style, I decided to jump on the edge of quite a few things including Rails 3 beta
  
and all of the associated &#8220;pre&#8221; gems for testing, persistence and others. That has been painful at times. Sometimes it
  
takes you a little bit to troubleshoot a huge stack trace of errors to find an issue with an incompatible gem. Lots of
  
times it was fixed by just updating the gem or actually applying specific patches. All in all, it hasn&#8217;t been too bad
  
though and it has forced me to dig into the actual code of the frameworks I&#8217;m using which has only increased my learning
  
of the Ruby language and certain patterns used in the language.

## Ugly

Well about the only thing ugly so far is probably some of my Ruby code. I&#8217;ve hit a few roadblocks here and there
  
because of my lack of some of the advanced capabilities of Ruby as a language. And sometimes I&#8217;ve had to just get it
  
working and move on until I get more proficient with Ruby. Often times I just &#8220;know&#8221; that there is a better way to do a
  
particular thing, even if I don&#8217;t know exactly what that way is. Like anything else, I&#8217;m sure I&#8217;ll come back a month
  
later, a year later and throw up a little in my mouth when I see some of the Ruby I&#8217;m writing. But I&#8217;m down with the
  
continuous improvement lifestyle, so I&#8217;ll just keeping moving forward. 🙂

Well this was basically a stream of consciousness post, but perhaps it will give some insight into the life of a fellow
  
geek that is striving to reinvent his career.