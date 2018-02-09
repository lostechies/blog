---
wordpress_id: 4059
title: 'How We Do Things &#8211; Specification (Using the right tools)'
date: 2009-11-13T14:41:52+00:00
author: Scott Reynolds
layout: post
wordpress_guid: /blogs/scottcreynolds/archive/2009/11/13/how-we-do-things-specification-using-the-right-tools.aspx
categories:
  - how we do it
  - improvement
  - lean
  - Management
  - mentoring
  - Quality
  - software
  - team
redirect_from: "/blogs/scottcreynolds/archive/2009/11/13/how-we-do-things-specification-using-the-right-tools.aspx/"
---
_This content comes solely from my experience, study, and a lot of trial and error (mostly error). I make no claims stating that which works for me will work for you. As with all things, your mileage may vary, and you will need to apply all knowledge through the filter of your context in order to strain out the good parts for you. Also, feel free to call BS on anything I say. I write this as much for me to learn as for you._

_This is part 7 of the [How We Do Things](http://www.lostechies.com/blogs/scottcreynolds/archive/2009/10/04/how-we-do-things-preamble-and-contents.aspx) series._

_This post was co-written with [Cat Schwamm](http://www.catschwamm.com), business analyst extraordinaire._

In the last post we talked about how we approach specification philosophically, as an iterative, JIT process. In this post we will take a look at the tools we use to create specifications.

### User Stories and Text

User stories and other text documents are the bread and butter of defining work, and we use them like crazy. Our story practice has evolved over time, and we have come to a place where we feel that, when used appropriately, our stories are very effective. For a deeper look at the guidelines we use to construct stories, I recommend you go check out [Cat’s post](http://catschwamm.com/2009/08/09/constructing-effective-user-stories-or-my-user-stories-bring-all-the-boys-to-the-yard/) on the subject. Go ahead. I’ll wait.

Okay, welcome back. Here’s the thing, stories and tasks are only part of the equation. Stories alone aren’t enough to define a system, and trying to define everything in text is a fool’s task. (I’ve been that fool). You need a full arsenal of specification tools to do the best job possible.

Story Pros: captures textual data well, tells the story

Story Cons: not everything is meant to be captured in text

### Mockups

Mockups are a very useful tool when specifying details of how things should work. With stories, you really can&#8217;t add a lot of design and implementation details or the signal to noise ratio becomes too high and shit gets overlooked. A basic rule of thumb we employ on the team is _&#8220;things that don&#8217;t get communicated well in text shouldn&#8217;t be forced into a text medium.&#8221;_ Basically, if you&#8217;re going to try to describe the way something should look in a story, a) it&#8217;s probably not going to look the way you actually picture it b) that story is now noisy as crap and people are going to ignore more important parts. With a mockup, you don&#8217;t have to take forever to do a flashy, literal, perfect screenshot in Fireworks or anything; you can just drag and drop Balsamiq controls around and voila. Ya got an aesthetically pleasing mockup that humans go nuts over. In five minutes I can mock something up in front of a developer, explain how it works, and they are ready to go.

Another great thing about mockups is that they are extremely useful for getting user feedback on specs without distracting the user that &#8220;this is the final product, no more input.&#8221; You can use a mockup to discuss workflow and layout without getting mired in fine-grained detail. The last time I was at the lab, I went back to my hotel room for a couple of hours and mocked up apps for 4 workspaces, brought them back to the supervisors and was able to get plenty of good feedback and make edits right there in front of them. Gold.

Mockup Pros: Time-saver, gives the gist of what you want, keeps your stories clean while still conveying what you want, good to show to users.

Mockup Cons: Can fall into the trap of putting everything on a mockup just like you would put everything into a story and it&#8217;s inappropriate

### High Fidelity Design

How easy is it to develop from what basically amounts to a screenshot? You know exactly how everything should look, you can strip images out, you don&#8217;t really have to think about it.

Wait a minute. There&#8217;s a red flag.

You don&#8217;t have to think about it? That&#8217;s a paddlin&#8217;. A high fidelity screenshot, while beautiful and easy to work from, gives developers a signal that this screen is a specification set in stone. They see what it needs to look like, they build it like that. It&#8217;s just like BDUF; the high level of detail and granularity means that people won&#8217;t think about what they&#8217;re actually building, they&#8217;ll just duplicate what they are given.

Screenshot Pros: Hotness, high level of detail, easy to work from

Screenshot Cons: Removes developer thought, can take a long time to create such a design 

### Conversation and Whiteboarding

While each of these mediums has plenty of merit and many benefits, conversation and whiteboarding are my (Cat&#8217;s..well, OK mine too) favorite method of specifying work. There is nothing like having the team (or pertinent members) together, talking through the workflow of a feature/app, mapping out how everything works, doodling out a rough idea of what things are going to look like and how things will come together. It is so damned valuable to have the working group together, talking through how things are going to work and getting their input. While business analysts and managers can come together to specify the general nature of how things need to work, having different members of the team around will help to eke out edge cases or problems that may not have been thought of in original discussion.

Conversation is obviously important by itself too; user stories are written to leave plenty of room for conversation. If you lose communication on your team and people just go off to code in the dark, a lot of the intent and original specification is lost.

Whiteboard Pros: Mapping workflow, multiple sources of input, easy to sketch out an idea/easy to change an idea, whiteboarding is fun as shit, conversation fully fleshes out ideas

Whiteboard Cons: Easy to get lost if not captured appropriately

While we’ve clearly chosen a favorite medium, you really can’t use just one. Each medium has a lot to offer depending on the scenario you are working with, and just like any other thing, you have to use what works naturally for the team in context with what you are doing.

<!-- Technorati Tags Start -->

Technorati Tags:
  
<a href="http://technorati.com/tag/how                   4e                  12o                   6t" rel="tag">how we do it</a>, <a href="http://technorati.com/tag/improvement" rel="tag">improvement</a>, <a href="http://technorati.com/tag/lean" rel="tag">lean</a>, <a href="http://technorati.com/tag/management" rel="tag">management</a>, <a href="http://technorati.com/tag/quality" rel="tag">quality</a>, <a href="http://technorati.com/tag/software" rel="tag">software</a>, <a href="http://technorati.com/tag/team" rel="tag">team</a>, <a href="http://technorati.com/tag/planning" rel="tag">planning</a> 

<!-- Technorati Tags End -->