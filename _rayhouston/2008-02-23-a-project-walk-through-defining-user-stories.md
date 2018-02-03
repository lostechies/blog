---
wordpress_id: 8
title: 'A Project Walk Through &#8211; Defining User Stories'
date: 2008-02-23T23:04:28+00:00
author: Ray Houston
layout: post
wordpress_guid: /blogs/rhouston/archive/2008/02/23/a-project-walk-through-defining-user-stories.aspx
categories:
  - Uncategorized
---
One of the things that I&#8217;ve learned is that you shouldn&#8217;t start development until you&#8217;re ready. You shouldn&#8217;t start until you have a good idea of what you are building. You shouldn&#8217;t start until you have some reasonable idea of how long it&#8217;s going to take. You need to make sure the information is organized and that everyone knows what they&#8217;re supposed to be working on. 

I think Agile has gotten a bad reputation in some cases because it&#8217;s been used as a cover for disorganized teams with no process (I&#8217;ve been on one of those teams). Agile software development doesn&#8217;t mean anything goes software development. If the stakeholder asks &#8220;Where are we on the project?&#8221; and the answer is &#8220;Oh it&#8217;s agile, you wouldn&#8217;t understand.&#8221; then something is wrong.

I want to attempt to do a walk through of an imaginary project that gives some insight into situations that others may come across in their own projects. This will take me several posts, so bear with me.

> _A school district is planning an event for teachers where they can signup for different workshops on various topics. A development team has been asked to write a simple application to manage coordinating the workshops and the registrants._

This seems like a simple enough application and&nbsp; a developer might think they know how it should work. Most of the time they would be wrong unless they were the stakeholder as well as the developer. The stakeholder has a lot of information tied up in their brain that developers don&#8217;t know about. We all take for granted the information we keep in our heads and it&#8217;s often difficult to present detailed information in a format that is easily understandable to a person that has no background on the particular subject. Even if it&#8217;s written&nbsp; down in great detail, someone has to tear it apart, piece by piece and rebuild it into an understanding of the desired goal. Misinterpretation is often the result. To me, understanding requirements is one of the most challenging aspects of software development. Agile methodologies accepts a level of misinterpretation and addresses it by constantly challenging understanding through communication and reevaluation. You can&#8217;t have Agile without good communication.

At this point, it would be a mistake to jump right into coding because we haven&#8217;t talked about the details of what we&#8217;re building and we don&#8217;t have a good way to estimate how long it will take. If the event is in three months and development will end up taking six, then it may not be worth the effort to spend three months developing something we can&#8217;t use.

> _The stakeholders have heard a lot of buzz around agile software development and agree that it&#8217;s the way to go. They go off in a room for a couple of days and then emerge with a set of specifications written on index cards._

Unless the stakeholders have had experience writing user stories, it would probably be a mistake to start development at this point. More than likely, they have written waterfall type specifications and just put them on index cards and this just doesn&#8217;t work (been there, tried that). A possible example of a story coming out of this session might be: 

> _A workshop can have a name, location, and a start date and end date._ 

The problem with this sort of story is that it doesn&#8217;t put the information into a context that helps us to understand how it fits into the system. This information is indeed valuable, but it doesn&#8217;t belong in that initial story. The story needs to give us just enough information so that we can quickly look at them and understand the feature and the business value.&nbsp; [Dan North&#8217;s](http://dannorth.net/) post [What&#8217;s in a Story?](http://dannorth.net/whats-in-a-story), explains a BDD approach to defining stories, which I&#8217;m currently using on my projects. Dan implies that acceptance scenarios are a part of a story, but I like to think of them as a separate deliverable because you don&#8217;t necessarily have to have that much detail up front. I&#8217;ll post more on this later.

Writing good stories takes a lot of practice and there will be a lot of questions. Some may be:

  * What goes in a story? &#8211; See Dan&#8217;s post. 
      * How big should a story be?&nbsp; &#8211; Keep them as short. 
          * How specific should a story be? &#8211; Start out general. You can always split a story later into more specific stories. 
              * Where do the business rules of a story go? &#8211; In Scenarios. See Dan&#8217;s post. 
                  * Can I have stories that depend on each other? &#8211; Sure. Some features depend on other features. 
                      * Can I create non feature related stories (like coding framework)? &#8211; Sure. But you probably won&#8217;t have much or any acceptance scenarios.</ul> 
                    > _The stakeholders go back into a room with a story writing coach and this time they emerge with a set of user stories._ 
                    > 
                    > > _As an Event Coordinator  
                    > > I want to enter event information  
                    > > So that it can be published online in order to attract potential registrants_
                    > > 
                    > > _As an Event Coordinator  
                    > > I want to define workshops for an event  
                    > > So that event registrants can signup to attend those workshops_
                    > > 
                    > > _As an Event Coordinator  
                    > > I want to define available rooms for an event  
                    > > So that workshops may be scheduled in those rooms_
                    > > 
                    > > _As an Event Coordinator  
                    > > I want to schedule workshops in available rooms  
                    > > So that I can be sure that two workshops don&#8217;t occur in the same room at the same time_
                    > > 
                    > > _&#8230;_
                    
                    These stories are much better. They are short and have a role, feature, and benefit. A person can read through them quickly without being overwhelmed. Once estimates have been placed on the stories, someone will have to go and prioritize them and you don&#8217;t want them to have to read a whole paragraph to understand the story. There is enough there to start a conversation and talk about some details so that the developers can come up with a rough estimate. Some of these stories may be too big to fit into a single iteration, but you shouldn&#8217;t care about that right now. You can always split them later. For now, we need a high level view of our goal and we can always refine it later when we plan an iteration. If a story seems too big to estimate, then go ahead and split it now.
                    
                    > _In order to get a rough estimate on approximately how long the project will take, the team meets and has a_ [_Release Planning Meeting_](http://www.extremeprogramming.org/rules/planninggame.html)_. The team goes through each story and gives them a point estimate._
                    
                    In this meeting, the goal is to educate the developers just enough on each story so that it can be given a general estimate. You can&#8217;t make estimates that are more accurate than the information presented, so there&#8217;s not much point in estimating in terms of time. By estimating in terms of points (size) you can later determine the unit of time that relates to a story point. The key is to estimate consistently and estimate the stories relative to each other. If a story is twice as hard as another story, it should have twice the estimate.
                    
                    Initially, to get a rough estimate for the completion of the whole project, you have to take an educated guess of how many story points you will be able to complete within a given iteration. This will be your initial velocity. If you have 1000 points to complete, your iterations are one month long and you can do 100 points per iteration, then you can estimate that you have 10 months of work. You may find that you will not have everything ready by a particular date, but you may have enough completed at an earlier date which will provide enough value to release. Remember this is a educated guess that needs to be refined as the project progresses. You have to do a couple of iterations before you really know your true velocity.
                    
                    > _The team makes an educated guess for the initial velocity and the stakeholders start prioritizing the stories into iterations. There is enough time for three iterations before the event and the estimates show that it will take six iterations to complete everything. It is obvious that everything cannot be completed by the deadline of the event, but it has been determined that there will be enough value coded at the end of the third iteration to have a release. Release 1 will only contain enough features to manage scheduling workshops._
                    
                    I&#8217;ll continue with the first iteration in a future post. Any thoughts, comments or questions on what I have so far are welcome.</p> 
                    
                    <div class="wlWriterSmartContent" style="padding-right: 0px;padding-left: 0px;padding-bottom: 0px;margin: 0px;padding-top: 0px">
                      Technorati Tags: <a href="http://technorati.com/tags/User%20Stories" rel="tag">User Stories</a>,<a href="http://technorati.com/tags/BDD" rel="tag">BDD</a>
                    </div>