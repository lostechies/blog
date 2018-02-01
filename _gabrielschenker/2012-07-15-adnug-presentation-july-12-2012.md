---
id: 214
title: ADNUG Presentation July 9, 2012
date: 2012-07-15T17:29:56+00:00
author: Gabriel Schenker
layout: post
guid: http://lostechies.com/gabrielschenker/2012/07/15/adnug-presentation-july-12-2012/
dsq_thread_id:
  - "766768159"
categories:
  - CQRS
  - Event sourcing
  - presentation
---
I want to thank all people who attended my presentation about CQRS and Event Sourcing at the ADNUG meeting on July 9, 2012. It was a great experience for me and I was pleased about the many questions you had. The [slides](https://github.com/gnschenker/RecipesWithCqrsAndEs/tree/master/Slides) and the [sample code](https://github.com/gnschenker/RecipesWithCqrsAndEs) are now available on [GitHub](https://github.com/gnschenker). For more information about CQRS and ES please consult the following section.

# Training resources regarding CQRS and ES

At our company we use CQRS and ES. For the newer products fully implemented in this new architecture we do not use any database but just the file system as data store. This new way of developing requires a significant and somewhat radical mind shift. What used to be best-practice in the _traditional way_ of coding does not apply any more. Things are solved differently.

## Definitions

**DDD**: Domain Driven Design  
**CQRS**: Command Query Responsibility Segregation  
**ES**: Event Sourcing

# Web-Sites

  * Good site about DDD/CQRS/ES: <http://domaindrivendesign.org/cqrs> 
      * DDD sample of event sourcing in C# (accompanies Vaughn&#8217;s new book on IDDD): <http://lokad.github.com/lokad-iddd-sample/> 
          * DDD/CQRS Community around the world: <http://cqrsguide.com/world> 
              * Case studies of CQRS/DDD projects: <http://cqrsguide.com/case-studies></ul> 
            # Videos
            
              * 6-hour video about CQRS by Greg Young: <http://www.viddler.com/v/dc528842> 
                  * Video about DDD/CQRS by Greg Young: <http://www.youtube.com/watch?v=KXqrBySgX-s> 
                      * Search for other videos by Greg Young, e.g. on Sills Matter 
                          * <http://skillsmatter.com/podcast/design-architecture/simple-is-better>, 
                              * [http://skillsmatter.com/podcast/design-architecture/cqrs-not-just-for-server-systems?goback=.gde\_2470540\_member_49148769](http://skillsmatter.com/podcast/design-architecture/cqrs-not-just-for-server-systems?goback=.gde_2470540_member_49148769)</ul> 
                        # Videos of Greg Young, Udi Dahan, Eric Evans, et. al.: <http://skillsmatter.com/event/design-architecture/ddd-exchange-2011>
                        
                        # People and Blogs
                        
                        Important people to follow
                        
                          * Greg Young, <http://codebetter.com/gregyoung/,he> coined the term CQRS 
                              * Rinat Abdullin, <http://abdullin.com/,we> use a customized version of his “framework” (Lokad.CQRS &#8211; <http://lokad.github.com/lokad-cqrs/)> 
                                  * Jonathan Oliver, <http://blog.jonathanoliver.com/> 
                                      * Udi Dahan, <http://www.udidahan.com/?blog=true></ul> 
                                    # Discussion Groups
                                    
                                    Important discussions about and around DDD, CQRS and Event Sourcing happen in this Google group: <http://groups.google.com/group/dddcqrs?pli=1>
                                    
                                    Most of the people having some relevance in this area are present on this group and answering questions.