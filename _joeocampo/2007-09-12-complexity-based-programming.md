---
id: 56
title: Complexity Based Programming
date: 2007-09-12T21:38:00+00:00
author: Joe Ocampo
layout: post
guid: /blogs/joe_ocampo/archive/2007/09/12/complexity-based-programming.aspx
dsq_thread_id:
  - "262089733"
categories:
  - 'Agile Project Coaching &amp; Management'
  - Agile Teams
  - Architechture
---
So what is it? As an Agile practitioner do you ever struggle having to justify <A href="http://en.wikipedia.org/wiki/Pair_programming" target="_blank">Paired Programming</A> to management? Typical management reaction to even the idea of Paired Programming is “Why would I pay two programmers to do something what one programmer can do?” You can rant and rave about quality and breadth of knowledge exchange but to management money talks and (you can fill in the rest). So what can you do to better explain the argument from a cost perspective as well as quality perspective?
  


Enter Complexity Based Programming. I don’t want you to think Complexity Based Programming is a radical departure or new concept of Paired Programming. On the contrary it is simply Paired Programming with a planning twist up front, that management usually byes off on.
  


Let’s think of a basic story _“As a user I want to have a login screen so I can authenticate users to my system.”_ Once you have the story written the development team usually takes it back and creates task in order to complete the story. A typical application has the following layers.
  


[<IMG height="307" alt="image" src="http://lostechies.com/joeocampo/files/2011/03ComplexityBasedProgramming_F85D/image_thumb_1.png" width="364" border="0" />](http://lostechies.com/joeocampo/files/2011/03ComplexityBasedProgramming_F85D/image_1.png)
  


As you can see there are many layers that this login screen story will have to traverse in order to call it complete? But let’s think about each layer. I like to start in the middle at the domain layer.
  



  


  * The presentation layer simply needs some html.

  


  * Because you are an awesome shop you have an MVC framework of some kind to call into your Domain Layer and exchange view information into the presentation tier.

  


  * At the Domain Layer you are probably going to need a “User Entity” that uses a “User Login Service” to Authenticate.

  


  * The “User Login Service” is going to have to use a “User Repository” of some kind.

  


  * The “User Repository” is going to talk to a SQL Backend and use the “User Mapper” to map data elements to the User Object etc. (Note: you may not need this step if you are utilizing an ORM framework)

  


  * The SQL Server is going to have to have the User Table created.


  


Ok so I have a list of task to do in order to support the completion of this story.


  



  


  * Story: User login Screen

  



  


  * Tasks

  



  


  * Create html (View)of login screen

  


  * Create Controller

  


  * Create User Domain Object (Model)

  


  * Create User Login Service

  


  * Create User Repository

  


  * Create User Mapper

  


  * § Create SQL for User Table


  


Wow that’s quite a list! But let’s think about how the work is accomplished in an Agile development shop.
  


### &nbsp;


  


### Organic Self Organization


  


Tasks are **NEVER** dictated and assigned to developers. Agile perpetuates organic self organizing teams. As a manger you simply insure that your back log is prioritized and explain to your team the Goals of that week.
  


[<IMG height="127" alt="image" src="http://lostechies.com/joeocampo/files/2011/03ComplexityBasedProgramming_F85D/image_thumb_2.png" width="357" border="0" />](http://lostechies.com/joeocampo/files/2011/03ComplexityBasedProgramming_F85D/image_2.png)
  


The team will figure out how to accomplish the stories on their own. They understand that they can’t move on to the next story until one story is complete or two there isn’t enough work for the remaining members of the team. The end result looks like this.
  


[<IMG height="175" alt="image" src="http://lostechies.com/joeocampo/files/2011/03ComplexityBasedProgramming_F85D/image_thumb_3.png" width="194" border="0" />](http://lostechies.com/joeocampo/files/2011/03ComplexityBasedProgramming_F85D/image_3.png)
  


So as teams self organize around completing story task, they typically pair on each one of the task and then move on to the next upon completion.
  


I bet you already Pair Program to some degree and don’t know it. Ever been in a cube and you needed help figuring out an issue, so you asked your buddy next to you to come and help (Humility)? Is that some variation on Pair Programming? Well to some degree it is but let’s investigate this a little further. Why did you ask for help on this particular task? You added some simple html earlier. You created a simple SQL statement to create Table and a couple of fields. Did you not know that this particular component was going to be more complex than the fore mentioned? Nine times out of ten you did. When someone mentioned in the planning session that the team was going to have to create a Repository, SQL Mapper you cringed. There in&nbsp;is the beauty of Complexity Based Programming. Observe.
  


Let’s look at the same User Login Story from above and imagine you are in the planning phase of a release. You see that the team has given it an estimate of 2 Units to complete.
  



  


  * Story: User login Screen **[2 Units]**


  


That’s great but my team likes to estimate at a more granular level. What they do is put ideal person hours to complete a given task. Remember that this is an approximation.
  


**NOTE: Completion of task assumes that there are unit test created as well.**
  



  


  * Story: User login Screen [2 Units]
  
    
  
    
    
      * Tasks
  
        
  
        
        
          * Create html (View)of login screen **[1 Hour]**
  
              * Create Controller **[2 Hour]**
  
                  * Create User Domain Object (Model) **[1 Hour]**
  
                      * Create User Login Service **[1 Hour]**
  
                          * Create User Repository **[2 Hour]**
  
                              * Create User Mapper **[2 Hour]**
  
                                  * Create SQL for User Table **[1 Hour]**</UL></UL></UL>
                        
  
                        Now that you have your task estimated lets rate them on their complexity. What do you mean by complexity? The Complexity is a subjective rating given to each task based on the teams experience level with the task and or their feelings about the complexity of a given task. To keep things simple the team gives each task a rating of **[L]**ow or {**H}**igh. Don’t make this any more complicated than it needs to be. Meaning don’t starting counting lines of code or measuring Cyclomatic complexity ratings on existing classes! Just allow the **developers** to use their best judgment.
  
                        
                        
                        
  
                        
                        
                          * Story: User login Screen [2 Units]
  
                            
  
                            
                            
                              * Tasks
  
                                
  
                                
                                
                                  * **[L]** Create html (View)of login screen [1 Hour]
  
                                      * **{H}** Create Controller [2 Hour]
  
                                          * **[L]** Create User Domain Object (Model) [1 Hour]
  
                                              * **{H}** Create User Login Service [1 Hour]
  
                                                  * **{H]** Create User Repository [2 Hour]
  
                                                      * **{H}** Create User Mapper [2 Hour]
  
                                                          * **[L]** Create SQL for User Table [1 Hour] </UL></UL></UL>
                                                
  
                                                So what do the complexity ratings give us? They allow you to plan upfront on what tasks are going to need more than one programmer to insure the integrity of the system is working correctly. Yup that right tell management you planned to have two resources on that task. They also allow you to justify the person hours that are needed in order to complete each task. How? Like this.
  
                                                
                                                
                                                
  
                                                
                                                
                                                  * Story: User login Screen [2 Units]
  
                                                    
  
                                                    
                                                    
                                                      * Tasks
  
                                                        
  
                                                        
                                                        
                                                          * [L] Create … screen [1 Hour] **x 1 Developer = 1 Hour**
  
                                                              * {H} Create Controller [2 Hour] **x 2 Developers = 4 Hours**
  
                                                                  * [L] Create … (Model) [1 Hour] **x 1 Developer = 1 Hour**
  
                                                                      * {H} Create … Service [1 Hour] **x 2 Developers = 2 Hours**
  
                                                                          * {H} Create … Repository [2 Hour] **x 2 Developers = 4 Hours**
  
                                                                              * {H} Create … Mapper [2 Hour**] x 2 Developers = 4 Hours**
  
                                                                                  * [L] Create … Table [1 Hour] **x 1 Developer = 1 Hour**</UL>
                                                                                
  
                                                                                  * **Total Estimated Person Hours = 17 Hours**</UL></UL>
                                                                            
  
                                                                            If you are really seasoned team you can take your Total Estimated Person Hours to determine the weight of your story. **I don’t encourage this unless you are a really seasoned team.** Why? Because the purpose of the planning game is not about accuracy of estimation it is about approximation based on experience of the team with system under development. **_Velocity will be adjusted based on the team’s delivery of working software not on their estimates._** All this scale gives you&nbsp;is the equivalent of a target but that doesn’t mean&nbsp;the team will hit it nor should they be reprimanded if they don’t hit it. Team dynamics of forming, storming, norming and performing affect all these variables. All I am trying to give is options for how to justify 2 people at one keyboard to management in terms they will understand.****
  
                                                                            
                                                                            
                                                                            [<IMG height="57" alt="image" src="http://lostechies.com/joeocampo/files/2011/03ComplexityBasedProgramming_F85D/image_thumb_4.png" width="374" border="0" />](http://lostechies.com/joeocampo/files/2011/03ComplexityBasedProgramming_F85D/image_4.png)
  
                                                                            
                                                                            
                                                                            If you don’t like this approach to paired programming, you may want to consider [Alistar Cockburn’s Crystal Clear](http://www.amazon.com/Crystal-Clear-Human-Powered-Methodology-Development/dp/0201699478) approach of Side by Side programming. As Agile Teams mature they eventually end up here anyway.