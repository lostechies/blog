---
wordpress_id: 13
title: A Discussion on Domain Driven Design
date: 2007-04-03T02:08:00+00:00
author: Joe Ocampo
layout: post
wordpress_guid: /blogs/joe_ocampo/archive/2007/04/02/a-discussion-on-domain-driven-design.aspx
dsq_thread_id:
  - "262090892"
categories:
  - Domain Driven Design (DDD)
redirect_from: "/blogs/joe_ocampo/archive/2007/04/02/a-discussion-on-domain-driven-design.aspx/"
---
</p> 

X Driven Development, is what we use to determine if the software we are building works in accordance with what we expect it to do.&nbsp; But how do we know what we are building is in accordance with the actual business domain?&nbsp; Do you look to the 500 page requirements document for the answers?&nbsp; Do you look at the wire frame that looks nothing like what you have actually designed?&nbsp; Do you trust the acceptance test that the product owner has authored&nbsp;and believes this is the way it should work?&nbsp; What do you do?&nbsp; 

[Domain Driven Design](http://domaindrivendesign.org/index.htm) complements X Driven Development as well as other agile software development practices by bringing to light the business model that the software is complimenting. By incorporating a model driven approach to software development we enlighten ourselves as well as the product owners and all additional stakeholders on how the system should behave and solve the business need. 

I believe that we should extend the already proven design methodology of Test Driven Development of “Red, Green, Refactor” by rephrasing it to “Model, Red, Green, Refactor, Refine”. 

  * **Model**: Construct a domain model based on DDD principles. 
      * **Red**: Write failing test or specifications that govern the intended behavior of the model. 
          * **Green**: Write just enough code to make the specification or test pass. 
              * **Refactor**: Refactor the passing code to design patterns that simplify the composition of the code decreasing technical debt. 
                  * **Refine**: Refine the model to greater incite based on the code you have written and verify with the product owner. 
                      * **Start Again**.</ul> 
                    Before I go any further let’s look at just what Domain Driven Design is. 
                    
                    I am not going to lie to any of you, when I first picked up Eric Evans book 2 years ago. I read it from cover to cover in about a week. When I was done I reflected on what I had read and nothing seemed to stick. I constantly had to read and reread chapters to figure out how Eric’s practices applied to my code. After all I have the TDD and refactoring stuff down how bad could it be? Well fast forward 3 months and I still didn’t quiet grasp many of the concepts. Now I don’t know what happened but one day I had an epiphany reread it again but this time pause after each chapter and reflect on your current architecture but not at the code level but from the business DOMAIN level. Eureka!! Now it all made sense. My code looks nothing like the domain. Don’t get me wrong I had classes that represented entities but the entities themselves weren’t cohesive from the contextual modularization of the domain. Not to mention the Ubiquitous language didn’t exist. Two years later and after rereading DDD for the third time and holding several training seminars I finally got it down. 
                    
                    You know&nbsp;they say a picture is worth a thousand words.&nbsp; So&nbsp;I would like introduce you&nbsp;to the navigational map of the Model Driven Design. 
                    
                    [<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="165" src="http://lostechies.com/content/joeocampo/uploads/2011/03ADiscussiononDomainDrivenDesign_13318/clip_image00241.jpg" width="240" border="0" />](http://lostechies.com/content/joeocampo/uploads/2011/03ADiscussiononDomainDrivenDesign_13318/clip_image00242.jpg) 
                    
                    Model Driven Design is broken down into the following artifacts: 
                    
                      * [Entities](http://www.lostechies.com/blogs/joe_ocampo/archive/2007/04/14/a-discussion-on-domain-driven-design-entities.aspx) 
                          * <a href="http://www.lostechies.com/blogs/joe_ocampo/archive/2007/04/23/a-discussion-on-domain-driven-design-value-objects.aspx" target="_blank">Value Objects</a> 
                              * Factories 
                                  * Services 
                                      * Aggregates 
                                          * Repositories</ul> 
                                        Each one of these artifacts complements one another and allows us to gain greater insight into the business domain. But before we start talking about these artifacts it is important to note that there is a backbone or glue rather that holds all these artifacts together. It is somewhat of an ethereal force that when applied correctly brings clarity to all that view the model but when not used correctly can wreak havoc and leave a sour taste with everyone involved in domain driven design. Ok that was a little too deep even for me. This glue is referred to as the “Ubiquitous Language”. 
                                        
                                        > “A domain model can be the core of a common language for a software project. The model is a set of concepts built up in the heads of people on the project, with terms and relationships that reflect domain insight. These terms and interrelationships provide the semantics of a language that is tailored to the domain while being precise enough for technical development. This is a crucial cord that weaves the model into development activity and binds it with the code.” Evans 2003
                                        
                                        The ubiquitous language forms a common thread where the names of classes and specific business operations or constraints are given a common terms that have been brought to fruition by the domain model and agreed upon by ALL stakeholders. 
                                        
                                        For instance in some development groups you are given a requirement. In the requirement it mentions that a potential clients, contact information be stored in the system. Having worked on many CRM systems, you create a class named “Lead”. Other members of the team create another object named “Contact”. Now let’s examine the paradox. You have 3 entities that mean the same thing. 
                                        
                                          * Potential Client 
                                              * Lead 
                                                  * Contact</ul> 
                                                Now when you have a conversation with the product owner and they mention the term “potential client”, you have two options. Rudely correct him by saying “you mean Lead” of which you will get a blank stare followed by “Well what every YOU call it. Yeah that thing” or you could simply translate in your head Potential Client equals Lead. Either way you have a breakdown in communication. 
                                                
                                                Not to mention if you are using a SQL server as your persistence mechanism the table may be called “Clients”. I know this is an extreme but I don’t know how many times I have seen this in production code. 
                                                
                                                Now let’s take a quick DDD approach. You take the time to meet the product owner and you agree that the you will refer to this entity as “Potential Client”. Nirvana has been achieved why, I will tell you why! Whenever anyone uses the term “Potential Client” in UML, documents, wire frame, CODE!! Everyone knows that this is the “Potential Client”. Ubiquity has been achieved. A moment of silence if you will… 
                                                
                                                Humans in general have a talent for understanding pictures and spoken words more than we do written text. I don’t know if this based on the fact that before written languages, knowledge was passed down from generation to generation based on spoken words (more like grunting) and drawings on wall. Perhaps our brains revert to time tested state of understanding when thought becomes unclear. That explains a majority of my code. But seriously let’s try something quickly to prove my point. Whatever you do, don’t think of a pink elephant! I mean don’t let that thought enter your head. If you are somewhat normal most of you found it impossible to keep such an IMAGE out of your head. The key was the term image. When we recall objects or ideas we tend to symbolize them in our brains with images. When we thought of the elephant we saw an animal with a long nose weighs 2 tons and has big floppy ears. I gave you the value of pink to contrast it even more than you normal train of thought. You didn’t recall the actual word letter for letter “P” “I” “N” “K” “E” “L” “E” “P” “H” “A” “N” “T”. If you did, what time is Judge Wapner coming on? 
                                                
                                                This is only the tip of the iceberg concerning the ubiquitous language and this post is a lot longer than I had intended it to be. More information will be elucidated on ubiquitous language in the next post on “[Entities](http://www.lostechies.com/blogs/joe_ocampo/archive/2007/04/14/a-discussion-on-domain-driven-design-entities.aspx)” and that’s when we really start to have some fun.