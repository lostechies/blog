---
wordpress_id: 496
title: FAKE It Till You Make It
date: 2015-08-18T16:36:23+00:00
author: Chris Missal
layout: post
wordpress_guid: https://lostechies.com/chrismissal/?p=496
dsq_thread_id:
  - "4045174449"
categories:
  - .NET
  - Continuous Integration
  - Deployment
  - 'F#'
  - Open Source
tags:
  - 'f#-fake'
  - fsharp
---
I&#8217;ve been studying build systems in .NET recently. I believe that automation is one of the most important pieces to any successful software project. Previously I wrote about [Cake](https://lostechies.com/chrismissal/2015/07/22/who-wants-cake/) and how I liked the ease of use as well as how nice it was to contribute to the project. I mentioned in the comments of that post that I would be blogging about FAKE as well, and this post is that.

[FAKE](https://fsharp.github.io/FAKE/) isn&#8217;t anything new. In fact, it&#8217;s been around for well over 5 years. [Scott Hanselman](https://github.com/shanselman) had a [really good post](http://www.hanselman.com/blog/ExploringFAKEAnFBuildSystemForAllOfNET.aspx) about it back in March of last year. If you&#8217;ve been keeping up, this will be nothing new, but for the readers that haven&#8217;t been following the activity, I hope my thoughts about it will be helpful to you.

Last week I presented at [Headspring](http://www.headspring.com) on this same topic with [Patrick](https://twitter.com/loudandatwork). Patrick is a fan of FAKE and I won&#8217;t speak for him, but I&#8217;m fairly certain he agrees with me in that I&#8217;d like to see more people and teams using it. There were two objectives to the presentation:

  1. Introduce FAKE to those that aren&#8217;t familiar.
  2. Convince people to give it a shot.

Now I can&#8217;t make you or my coworkers use it; that&#8217;s not the point. I just want to show you what you may be missing and let you choose your own build strategy from here on. I like FAKE and think it&#8217;s the best solution to the build and automation problem we face in .NET every day. I&#8217;d like to go over a few reasons why I think so. Before I do that, I&#8217;m going to talk about a few reasons why you shouldn&#8217;t use it.

## Why You Shouldn&#8217;t be Using FAKE

### You&#8217;re a Pro at PowerShell

You can whip together some PS code in no time. You never forget the equality operators, you even know the commands for file manipulation without having to Google them. That&#8217;s awesome and I wish I had the same skills as you. PowerShell is a very powerful language and can do a ton of amazing things! I don&#8217;t want to take anything away from PowerShell, but I don&#8217;t spend a lot of time in it. Because of this, I&#8217;m not nearly as efficient when writing it. If you have no problems with these things, this post might not be for you, sorry I can&#8217;t give you much to read about.

If, however, you have the same problems I have, maybe you should keep going.

### You Don&#8217;t Want to Write F

The assumption that you need to be proficient in F# to use FAKE is a false one. I hear this often and I don&#8217;t know where it came from, and I can only easily assume why. The good thing about FAKE is that it doesn&#8217;t require a deep understanding of F#. It&#8217;s a [DSL](https://en.wikipedia.org/wiki/Domain-specific_language) built on F# and writing FAKE is much different, I&#8217;ll say easier, than writing F#.

### You&#8217;ve Adopted Gulp/Grunt

You might not want to give FAKE a try because you&#8217;re already invested in using JavaScript as your build language. I love JavaScript, don&#8217;t get me wrong, but these approaches require a bit more setup than your standard .NET build script. You need some extra dependencies that fall outside the default stack. (Yes, I realize that Gulp/Grunt tasks are now built in to Visual Studio. I&#8217;m not sure how I feel about this yet.) FAKE can be downloaded via NuGet, and you are off to the races. Sometimes a JavaScript dependency isn&#8217;t always ideal for a project because it&#8217;s possible that the only JS is in the build. You&#8217;re not really gaining anything at this point.

## Why You Should be Using FAKE

### It&#8217;s Best of Breed in .NET

There are several build tools out there, but through all the ones I&#8217;ve used, FAKE is winning. It has the biggest community around it, most built-in features (that I&#8217;m aware of), it&#8217;s still actively developed and maintained, and runs on Linux.

### The Help is Fantastic

When you need assistance, there are a lot of options available: great documentation, terrific responses on GitHub, and even Google and Stackoverflow are helpful. Oh, and let&#8217;s not forget the entire F# community!

### Faster and Easier

I&#8217;m still no veteran when it comes to writing FAKE scripts, but I can honestly say that it&#8217;s far more of an efficient use of my time than any other build tool I&#8217;ve used. With all the &#8220;Helpers&#8221; (over 100 in fact) there&#8217;s not much that you have to write on your own. You&#8217;re literally just putting building blocks together in the order and direction you want them.

## A Sample Script

Anyway, on with the sample code! This tiny little snippet comes directly from the [FAKE](https://fsharp.github.io/FAKE/) site, and I&#8217;ll leave it with you and let you browse on over there to check out more samples since that won&#8217;t get out of date as fast as this may.

    #r "tools/FAKE/tools/FakeLib.dll" // include Fake lib
    open Fake
    
    
    Target "Test" (fun _ ->
        trace "Testing stuff..."
    )
    
    Target "Deploy" (fun _ ->
        trace "Heavy deploy action"
    )
    
    "Test"            // define the dependencies
       ==> "Deploy"
    
    Run "Deploy"
    

## Closing Thoughts

Like other FAKE fans, it&#8217;s one of those &#8220;why wasn&#8217;t I using this long ago?!&#8221; thoughts. I could keep going on, but I&#8217;ll let you check it out and form your own opinions. As somebody who doesn&#8217;t like to change things up too often, I&#8217;m VERY glad I&#8217;ve made the switch from PowerShell (in my case) to FAKE.