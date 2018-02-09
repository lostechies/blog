---
wordpress_id: 1071
title: Tips On Submitting A Conference Session
date: 2013-03-15T09:56:24+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1071
dsq_thread_id:
  - "1139432657"
categories:
  - AntiPatterns
  - Community
  - Education
  - Retrospectives
---
In the last 3 or so years, I&#8217;ve had every conference submission I&#8217;ve entered, rejected. Now that doesn&#8217;t mean I haven&#8217;t spoken at any conferences &#8211; I&#8217;ve been invited to a handful and have had a ton of fun at them. But for every conference that I&#8217;ve submitted a session too, I have not been selected. It&#8217;s not fun being rejected 6+ times in a row. The worst part, though, is not getting any valid feedback on why. I ranted about this for a while on Twitter yesterday, and got some interesting feedback.

## The Worst Part

The worst parts of the constant rejection include not getting any feedback on why, and the constant growing self doubt. But the absolute worst rejection was from CodeMash last year, where they passed me up in favor of some other guy that wanted to do a Marionette session. I heard reports that it didn&#8217;t go well… and they chose this guy over me, the creator of Marionette. That one still stands out as the most crushing rejection.

But enough self-pitty-crap. You&#8217;re here the find out WHY and how to fix it, right?

## The Submission

I ended up [posting one of my recent submissions to a gist](https://gist.github.com/derickbailey/5166832) so that I could get some actual feedback. This is the basic session submission information that I&#8217;ve been using for a while now. I change it up from here, based on the specific talk that I&#8217;m going to give, but it generally looks like this:

> **Scaling JavaScript Apps With Backbone And Marionette**
> 
> Nearly everyone understands how to build a simple JavaScript application these days. From the classic “Todo” JavaScript app, to simple forms-over-data jQuery apps, we’ve all been around that block a few times. With the recent explosion of JavaScript MV* tools and frameworks, though, many of us find ourselves in over our heads, looking at patterns and practices that work well for small applications and pages but fail when scaling to anything substantial.
> 
> In this session, Derick Bailey will give you an introduction and walk through of many of the patterns and practices that your JavaScript applications need to be scalable. You’ll learn why copying Ruby on Rails’ pattern of “Models”, “Views” and “Controllers” folder names is wrong for scaling JavaScript apps, and how to correct that . You’ll learn about the necessity of separating the various concerns of your application. You’ll learn about patterns that aggregate and coordinate functionality from other parts of the system, how and when to properly decouple disparate areas of your application through messaging patterns, and more. And all of this will be illustrated with Backbone, MarionetteJS and additional plugins and patterns that can give you an edge in creating scalable applications in JavaScript.

I asked people to tear this apart for me, and tell me what I have been doing wrong. I got exactly what I wanted, and I have a lot of great tips to move forward, now. 

## The Raw Responses

There&#8217;s a lot of useful tips in the raw responses, and lessons that can be picked from the responses. Rather than just trying to summarize things, though, I&#8217;m just going to post the responses directly and add my reactions.

<blockquote class="twitter-tweet">
  <p>
    @<a href="https://twitter.com/derickbailey">derickbailey</a> I&#8217;ll be honest, it&#8217;s the beard man. They are Jealous of your testosterone.
  </p>
  
  <p>
    — Scott Koon (@lazycoder) <a href="https://twitter.com/lazycoder/status/312375144985288704">March 15, 2013</a>
  </p>
</blockquote>


  
Ok, Scott&#8217;s probably right. My beard is amazing. But it&#8217;s probably more likely:

<blockquote class="twitter-tweet">
  <p>
    @<a href="https://twitter.com/derickbailey">derickbailey</a> Ok, I&#8217;ll be actually honest here. I have no idea WHY code on the client needs to scale past a single user?
  </p>
  
  <p>
    — Scott Koon (@lazycoder) <a href="https://twitter.com/lazycoder/status/312375777649885185">March 15, 2013</a>
  </p>
</blockquote>


  
Here&#8217;s one of the problems: semantics. &#8220;Scalability&#8221; is an over-used and abused word these days. When I say &#8220;scalability&#8221; in that abstract, I mean scaling to 10&#8217;s of thousands of lines of code, dozens of feature areas, sub-applications and general code size. I&#8217;m not referring to number of users since this all runs on client-side, one-person-at-a-time browsers. 

<blockquote class="twitter-tweet">
  <p>
    @<a href="https://twitter.com/derickbailey">derickbailey</a> True, but you don&#8217;t say that in the abstract. I&#8217;m guessing you mean tons of data on the client w/complex cardinality.
  </p>
  
  <p>
    — Scott Koon (@lazycoder) <a href="https://twitter.com/lazycoder/status/312376394334208002">March 15, 2013</a>
  </p>
</blockquote>


  
Dually noted, and something I need to clarify in my abstract.

 

<blockquote class="twitter-tweet">
  <p>
    @<a href="https://twitter.com/derickbailey">derickbailey</a> @<a href="https://twitter.com/jbogard">jbogard</a> @<a href="https://twitter.com/robconery">robconery</a> Needs more excitement! Get me excited about something!
  </p>
  
  <p>
    — Kelly Sommers (@kellabyte) <a href="https://twitter.com/kellabyte/status/312375796973051904">March 15, 2013</a>
  </p>
</blockquote>

This is more likely the largest issue, and is the most common thread of feedback that I got. I spent years learning to take the emotion and extraneous fluff out of my written communications because I worked for large corporations where CEO&#8217;s wanted logical justification for me spending $100,000 on servers and software. Hand-waving doesn&#8217;t go over well in that environment, but apparently it&#8217;s what you need in a conference submission.

 

[Rob Conery responded](https://gist.github.com/derickbailey/5166832#comment-798819) to my gist, with this:

> ##Taking The Suck Out of Javascript with MarionetteJS
> 
> Many have heard of Single Page Applications and, even though most of us in the room might not admit it, have experimented with the idea late at night&#8230; only to face the inevitable self-loathing and vacant, soulless feeling the next day. In this talk Derick Bailey will show you a happier path for building Single Page Applications, using Marionette together with BackboneJS.
> 
> Marionette helps to structure your Javascript applications &#8211; doing the things you don&#8217;t want to do (or have tired of doing thousands of times over) &#8211; and it won&#8217;t leave your code feeling bloated and lifeless.

This sparked a small response line in twitter:

<img title="Screen Shot 2013-03-15 at 10.36.05 AM.png" src="http://lostechies.com/derickbailey/files/2013/03/Screen-Shot-2013-03-15-at-10.36.05-AM.png" alt="Screen Shot 2013 03 15 at 10 36 05 AM" width="519" height="559" border="0" />

Even if it bums people out, it&#8217;s a much more exciting and entertaining abstract. I would go to this session.

 

<blockquote class="twitter-tweet">
  <p>
    @<a href="https://twitter.com/robconery">robconery</a> @<a href="https://twitter.com/kellabyte">kellabyte</a> @<a href="https://twitter.com/derickbailey">derickbailey</a> just do what jon skeet did in his abstract “I’M JON SKEET. SCIENCE BITCHES!!”
  </p>
  
  <p>
    — Jimmy Bogard (@jbogard) <a href="https://twitter.com/jbogard/status/312377924433084416">March 15, 2013</a> 
  </p>
</blockquote>

hmm… I&#8217;m considering this, though I think Jon Skeet might have problems with me claiming to be him. 😀

 

<blockquote class="twitter-tweet">
  <p>
    @<a href="https://twitter.com/derickbailey">derickbailey</a> @<a href="https://twitter.com/jbogard">jbogard</a> @<a href="https://twitter.com/robconery">robconery</a> the abstract is too long. I liked the direction Rob was heading in the comments
  </p>
  
  <p>
    — Chad Myers (@chadmyers) <a href="https://twitter.com/chadmyers/status/312379238605012992">March 15, 2013</a> 
  </p>
</blockquote>

Also very true. Anyone that has read me blog or articles knows that I have a hard time being concise. I definitely need to work on the length of abstract, which would also help move it toward the goal of more excitement. Less to read means I have to pack more information and punch in to fewer words.

 

In a separate email conversation, Steve Smith ([@ardalis](http://twitter.com/ardalis)) had this to say:

> Rob’s comment is great. Short, exciting, attention-getting abstracts are the best, but they’re not easy to write. What’s at least as important to those selecting sessions for an event is the speaker themselves. If you’re well-known, especially for the topic, that matters far more than the abstract. It’s also helpful to include your speaking background, so that those who don’t know you at least know you’re not new to speaking. Including ratings can help, too, as in: “Presented a similar talk to 100 developers at XYZ code camp and was rated 9.2 out of 10”
> 
> My first pass at abstracts usually look a lot like your initial one, which is kind of like the standard Microsoft product naming convention of describe-what-it-is-in-general-terms. If I’m submitting to something I already know I’m accepted for, I usually won’t spend a lot of time trying to sex it up, either (like, for a user group, for instance). But for something like TechEd or any other larger event where I don’t necessarily already have an “in”, I’ll try to spend more time making the abstracts more exciting, and also demonstrating my past experience.

There&#8217;s a lot of great summary in here, for sure. I&#8217;m not sure I buy the &#8220;celebrity&#8221; angle at this point, though. In spite of being invited to speak about Marionette (among other things) and in spite of Marionette being the most watched Backbone framework on Github, with my name all over it, people still reject my sessions in favor of other people. 

Unless you&#8217;re Jon Skeet, Addy Osmani or Paul Irish, you&#8217;re going to have to beg your way in to most conference submissions. You&#8217;re going to have to pay attention to the detail and make the submission exciting, or you&#8217;ll be passed up in spite of your name being all over the project that they want to hear about.

 

Lastly, @kellabyte capped it off with a dose of reality for all of this advice:

<blockquote class="twitter-tweet">
  <p>
    @<a href="https://twitter.com/derickbailey">derickbailey</a> @<a href="https://twitter.com/robconery">robconery</a> @<a href="https://twitter.com/jbogard">jbogard</a> Nothing guarantees anything we say is worth a damn though 😛
  </p>
  
  <p>
    — Kelly Sommers (@kellabyte) <a href="https://twitter.com/kellabyte/status/312379489105637376">March 15, 2013</a>
  </p>
</blockquote>

 

While this is true, I&#8217;m grateful to have received this feedback! This is infinitely more useful than the generic, patronizing &#8220;we had too many great submissions to choose from&#8221; responses that conference organizers like to send.

## What Other Advice Do You Have?

I know I have a lot of work ahead of me to improve my submissions, and I&#8217;m still looking for more advice and more feedback. What else would you add to the conversation? What other tips and tricks do you have? 

I don&#8217;t want others to have to go through this. Help us all learn from your lessons and patterns in successful session submissions. Post in the comments here, or in a response blog post. Just be sure to share your tips with the world so that others can hopefully avoid the mistakes and learn from the successful lessons.