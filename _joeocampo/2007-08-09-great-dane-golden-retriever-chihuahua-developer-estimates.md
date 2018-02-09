---
wordpress_id: 42
title: Great Dane, Golden Retriever, Chihuahua == Developer Estimates
date: 2007-08-09T03:36:37+00:00
author: Joe Ocampo
layout: post
wordpress_guid: /blogs/joe_ocampo/archive/2007/08/08/great-dane-golden-retriever-chihuahua-developer-estimates.aspx
dsq_thread_id:
  - "262088178"
categories:
  - 'Agile Project Coaching &amp; Management'
  - Agile Teams
redirect_from: "/blogs/joe_ocampo/archive/2007/08/08/great-dane-golden-retriever-chihuahua-developer-estimates.aspx/"
---
I just read <a href="http://ayende.com/Blog/archive/2007/08/09/You-cant-estimate-a-month.aspx" target="_blank">Ayende&#8217;</a>s and <a href="http://udidahan.weblogs.us/2007/08/06/dont-trust-developers-with-project-management/" target="_blank">Udi&#8217;s</a>&nbsp;post on estimation.&nbsp; I was intrigued because over the last three year we have been using &#8220;story units&#8221; to estimate our work load for all our projects to great success.

Story Units (points, <a href="http://codebetter.com/blogs/scott.bellware/archive/2007/08/07/166507.aspx" target="_blank">Bellware calls them fibs</a>) are not for the faint at heart as there accuracy tends to increase as a team develops more software together.&nbsp; This is due in part to the <a href="http://en.wikipedia.org/wiki/Central_limit_theorem" target="_blank">central limit theorem</a>.

<a href="http://www.amazon.com/Agile-Estimating-Planning-Robert-Martin/dp/0131479415/ref=pd_bxgy_b_img_b/104-7137857-3969526" target="_blank">Mike Cohn</a> says it best: 

> The Central Limit Theorem tells us that the sum of a number of independent samples from any distribution is approximately normally distributed. 
> 
> For our purposes, this means that a team’s story-unit estimates can be skewed way towards underestimation, way towards overestimation, or distributed in any other way. But when we grab an iteration’s worth of stories from any of those distributions, the stories we grab will be normally distributed. This means that we can use the measured velocity of one iteration to predict the velocity of future iterations. 
> 
> Naturally, the velocity of one iteration is not a perfect predictor. For example, an iteration containing one ten unit story rather than ten one-unit stories would be a less accurate predictor. Similarly, velocity may change as a team learns new technology, a new domain, or becomes accustomed to new team members or new ways of working.

My own personal experiences proves that this theorem is factual.&nbsp; When the development&nbsp;team was forming, our story estimates were all over the map.&nbsp; One developers 1 unit (12 ideal&nbsp;hours)&nbsp;story would turn into an 8 unit story by the time the team completed it.&nbsp; Another developers 3 unit story would take 0.5 units. Over the course of each iteration our accuracy increased and the velocity became consistent. 

For those of&nbsp;you that have never heard of story point estimating let me break it down for you.&nbsp; 

Agile project terms differ from process to process but they have the same basic similarities. 

A basic project looks like this: 

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="383" alt="image" src="http://lostechies.com/joeocampo/files/2011/03GreatDaneGoldenRetrieverChihuahuaDevelop_9D2/image_thumb.png" width="640" border="0" />](http://lostechies.com/joeocampo/files/2011/03GreatDaneGoldenRetrieverChihuahuaDevelop_9D2/image.png) 

As you can see there is a basic inception phase that the project team uses to estimate the duration and cost of the project.&nbsp; The product owner gives a high level scope of what the application will accomplish.&nbsp; From this high level overview a vision statement is created by the entire team.&nbsp; During this phase the product owner outlines the high level features of how the application will function.&nbsp; Try to not confuse this with a work&nbsp;break down structure exercise it is similar but doesn&#8217;t go into that level of detail.&nbsp; So lets say the team came up with the following list of features. 

  * Welcome Screen 
      * Login Screen 
          * Create Customer 
              * Look up customer 
                  * Create lead 
                      * Admin: Create Campaign 
                          * etc&#8230;.</ul> 
                        From these list of features the development team gets together and plays <a href="http://www.planningpoker.com/" target="_blank">planning poker</a> with each feature.&nbsp;When the team comes to a general consensus on the size of the feature,&nbsp;a unit&nbsp;value is assigned to it.
                        
                        Here is where my dog analogy comes into play.
                        
                        Lets say the first feature is valued as a Golden Retriever.&nbsp; You simply look at the next feature in relation to the first and ask yourself one simple question,   
                        &#8220;Is it bigger or smaller than the Golden Retriever?&#8221; If it is smaller how smaller? Chihuahua or Poodle?&nbsp; Well I am sure you get the picture, the point here is not about accuracy as more as it is volume.
                        
                        After you have gone through all the features you simply add the units up.
                        
                          * Welcome Screen &#8211;&nbsp;1 Units 
                              * Login Screen &#8211; 3 Units 
                                  * Create Customer &#8211; 8 Units 
                                      * Look up customer &#8211; 6 Units 
                                          * Create lead &#8211; 6 Units 
                                              * Admin: Create Campaign &#8211; 8 Units 
                                                  * **Total: 32 Units**</ul> 
                                                Now you have your units for all the features.&nbsp; This is where I am going to diverge from traditional agile practices simply because I am in a enterprise environment and I answer to a PMO so I have to come up with a target completion date and estimated cost.&nbsp; To do this I am going to have to rely on iteration velocity.
                                                
                                                Within each release there are a certain number of development iterations. Most teams typical iteration length is 2 weeks, I prefer 1 week iterations as it accelerates the feedback loop. Each iteration is given a development velocity.&nbsp; Velocity is a measure of how much work the team can accomplish in an iteration.&nbsp; As an example lets say you have a team of 4 developers and they have been working together for sometime.&nbsp; Their velocity is 8 units per week.&nbsp; On the other&nbsp;hand lets say you have a new development team of 4 developers.&nbsp; Their velocity would probably be half of the seasoned teams velocity.&nbsp; It would probably (hope) take around 6 iterations by the time this new team is able to match the velocity of the seasoned team.&nbsp; There is a huge theorem I use at work to predict this but I don&#8217;t want to bore you here.&nbsp; The main point is velocity is not a constant it is simply a measurement of estimated performance.
                                                
                                                A typical release&nbsp;might look like this.
                                                
                                                [<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="407" alt="image" src="http://lostechies.com/joeocampo/files/2011/03GreatDaneGoldenRetrieverChihuahuaDevelop_9D2/image_thumb_2.png" width="640" border="0" />](http://lostechies.com/joeocampo/files/2011/03GreatDaneGoldenRetrieverChihuahuaDevelop_9D2/image_2.png) 
                                                
                                                So you have the following phases in a release:
                                                
                                                  * Storming 
                                                      * Planning 
                                                          * Development Iterations A (8 Units) 
                                                              * Development Iterations&nbsp;B (8 Units) 
                                                                  * SIT 
                                                                      * UAT 
                                                                          * Production Deployment</ul> 
                                                                        Velocity for the release is 16 units and the release is approximately 3 weeks in duration.&nbsp; So in 3 weeks you can have 16 units worth of working&nbsp;software ready to go into production.
                                                                        
                                                                        Lets go back to our Feature list example. You know the total count is 32 units, based on how awesome your team performs the entire projects is going to take approximately 2 releases to complete.&nbsp; Because you are a seasoned project manger you plan for one additional release in reserve.&nbsp; The total project estimate is 9 weeks.&nbsp; From there you can figure out person hours on your own.
                                                                        
                                                                        ### Release Planning Estimation: Planning Poker Part Duex
                                                                        
                                                                        Great now you are into your first release but what are you going to work on.&nbsp; 
                                                                        
                                                                        > **_DO NOT make the fatal mistake of using&nbsp;the high level estimates you did during the inception phase to plan the actual stories for the release, those where just estimates!_** 
                                                                        
                                                                        For the sake of time lets assume that your project owner has given you a list of features&nbsp;they would like&nbsp;accomplished for this&nbsp;release.&nbsp; What you do now is sit down with your product owner and go over each feature that has been prioritized for this release utilizing DDD modeling you break the feature into stories.&nbsp;&nbsp;Once each story has been defined.&nbsp; The developers take some time to break the story into task and estimate them at a finer of level of course using the planning poker scheme as before.
                                                                        
                                                                        Story: Blah blah blah &#8211; Original Estimate (3 units)
                                                                        
                                                                          * Task: create Blah entity&nbsp; &#8211;&nbsp; 0.25 units 
                                                                              * Task: create blah database table &#8211; 0.25 units 
                                                                                  * Task: create UI mapper for Blah &#8211; 2 units 
                                                                                      * Task: create web page elements for blah &#8211; &nbsp;2 units 
                                                                                          * Task: create blah validation service &#8211;&nbsp;0.5 units</ul> 
                                                                                        New Estimate after task analysis &#8211; 5 Units
                                                                                        
                                                                                        Story:&nbsp;foo foo foo&nbsp;&#8211; Original Estimate (5 units)
                                                                                        
                                                                                          * Task: create Foo entity&nbsp; &#8211;&nbsp; 0.25 units 
                                                                                              * Task: create Foo database table &#8211; 0.25 units 
                                                                                                  * Task: create UI mapper for Foo &#8211;&nbsp;1 units 
                                                                                                      * Task: create web page elements for Foo &#8211;&nbsp;&nbsp;1 units 
                                                                                                          * Task: create Foo validation service &#8211;&nbsp;0.5 units</ul> 
                                                                                                        New Estimate after task analysis &#8211;&nbsp;3 Units
                                                                                                        
                                                                                                        You do this with each story that the product owner has assigned to the release.&nbsp; The product owner simply evaluates how many points they have to work with and&nbsp;assigns&nbsp;the stories&nbsp;until&nbsp;the iteration velocity budget is exhausted.
                                                                                                        
                                                                                                          * Iteration A &#8211; Velocity 8 Units 
                                                                                                              * Story A: 1 Unit 
                                                                                                                  * Story B: 2 Units 
                                                                                                                      * Story C: 0.5 Units 
                                                                                                                          * Story D: 5 Units</ul> </ul> 
                                                                                                                    &nbsp;
                                                                                                                    
                                                                                                                    > NOTE:&nbsp; It is very important to track the target vs actual of each story as I tend to see in my team that they are very accurate with 0-3.5 unit stories anything above that and there accuracy starts to diminish exponentially.&nbsp;&nbsp;To minimize the&nbsp;this risk&nbsp;we ask the developers to determine if a 4 unit story and above is an epic and can it be broken into smaller stories? Of course we ok this with the product owner before simply breaking out even more stories.
                                                                                                                    
                                                                                                                    Another important aspect is plan to the horizon.&nbsp; Meaning you can plan for iteration B but understand that it will more than likely change. &#8220;Embrace Change&#8221;&nbsp; Sometimes this change is for the good and sometimes not so good the point is reflect after every iteration and determine if the stories in the back log are still what you estimated them to be.&nbsp; Some may have gotten smaller based on frameworks and patterns you may have introduced during iteration A.&nbsp; Some may have increased because of an issue you came across in iteration A.
                                                                                                                    
                                                                                                                    What I love most about Agile is you can&#8217;t hide!&nbsp; It brings everything to the forefront for you to deal with now, not later but now!
                                                                                                                    
                                                                                                                    I hope I haven&#8217;t confused anyone with I have outlined.&nbsp; I am use to it since I deal with a PMO on a regular basis. 🙂