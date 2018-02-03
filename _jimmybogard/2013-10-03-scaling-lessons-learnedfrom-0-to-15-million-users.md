---
wordpress_id: 828
title: Scaling lessons learned–from 0 to 15 million users
date: 2013-10-03T15:45:44+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=828
dsq_thread_id:
  - "1821206106"
categories:
  - Architecture
---
The bulk of my time in the last three or so years at Headspring has been building and architecting a loyalty reward system (think Best Buy Reward Zone). I’ve worked on Very Large Systems before, Fortune 50 e-commerce sites, but not one where I was **completely** responsible for the delivery and uptime of a system that supported millions of real, physical human beings nationwide.

Anyone following my blog over the past few years has seen that impact on me, through my posts on SOA, DDD, CQRS, messaging and NServiceBus. There were some other universal lessons I had, outside of technical challenges, that come from building a system used by such a large number of people.

Before I get too far into scaling, it’s critical to understand _how_ your system needs to scale. This system in particular has grown to 15 million members in about 3.5 years.

### Characterizing the load

The only thing constant in this system is change. We’ve had at least three different email service providers, different FTP servers, several versions of .NET, ASP.NET and on and on. Our system was once a coordinator between the 3rd-party system and the front-end loyalty system, but now is completely responsible for all loyalty activities and that 3rd-party system is gone.

We’re mainly a transactional processing system, powering the front-end system (built on Django and PostgreSQL). Basically this system’s only UI is a customer service portal.

On a daily basis, we process:

  * Registrations 
      * Purchases 
          * Communications (emails to members) 
              * Reward issuance/expiration/redemption</ul> 
            Our customer is ultimately the marketing department of the nationwide retail chain we support, with hundreds of stores nationwide. In addition to our normal daily load, we’ll have crazy spikes at certain times. The one month between Thanksgiving and New Years is half our load in particular, with days of nearly zero activity when stores are closed for holidays.
            
            Other spikes were just due to changes in how the loyalty program was built. We had birthday rewards for members, and at one point, switched to issuing on a monthly basis instead of daily basis. Instead of a daily load of 10K rewards, we’d have spikes on the first of each month to now several hundred thousand. Occasionally, we’d have one-off campaigns, direct mail or mass emailed to ALL members, where we’d issue millions of rewards in one go.
            
            We’d also have to answer highly varying questions from the business. Analytics are set up when you know what questions you need to answer, but if you don’t know what questions about your data you need to answer, it pays to have a highly flexible data model to query off of.
            
            But enough of that, let’s look at some lessons learned.
            
            ### Lesson 1: Separate the decision from the result
            
            Early on, we wanted to make sure the front end was not reliant on other systems to function. So many times I see systems couple themselves to web services they don’t own – and wonder why their system crashes and burns when that other web service goes down.
            
            In this system, most decisions need to be surfaced to the customer on a daily basis, not an hourly, minute-ly or second-ly basis. Because these are physical stores, there’s a built-in latency to drive around and purchase things. If someone buys something in a store, there’s no reasonable expectation that your transaction should result in points in your account within seconds, minutes or even a day.
            
            Additionally, since much of our data is governed by dates and times (reward good from date A to date B), there’s no real need to deliver things at an exact point in time. Systems instead just respect the dates.
            
            ### Lesson 2: Solutions aren’t universal
            
            To access data in our system, we have a number of different approaches, based on the use case. It’s a mistake to think that one ORM is going to solve all your problems, or one approach to data will. We have in our system:
            
              * NHibernate 
                  * PetaPoco 
                      * SQL Bulk Copy</ul> 
                    Depending on what we want to do. We settled early on that reads were different than writes, and when we needed to make a read and NOT modify data, loading an entity through NHibernate was just a waste of time. But even inside NHibernate there are a number of ways to access data:
                    
                      * Entity-by-entity 
                          * Entity queries (criteria, HQL, QueryOver, LINQ) 
                              * SQL queries projected</ul> 
                            If we had NHibernate in a solution, but needed to bypass the entity layer (as we wanted to just do SQL), we still USED NHibernate, but just another feature inside it. In other projects in this system, NHibernate didn’t exist, we just needed to do some SQL, so we wound up using PetaPoco.
                            
                            And for getting lots of data in and out of our system, we really couldn’t beat SQL Bulk Copy. It’s blindingly fast.
                            
                            On a side note, flexibility is one of the reasons that if I had to do it over again, I wouldn’t go with a document database. I need flexibility, and there are SO many tools, add-ons, enhancements etc. with SQL Server, I would just lose too much going with something else.
                            
                            ### Lesson 3: Consistency is a business decision
                            
                            The real world is a messy, inconsistent, confusing place. And yet business gets done (and has gotten done) for hundreds and thousands of years. We went in thinking that all operations needed to be ACID, but in reality, this was just not the case. When volume really started to get high, relaxed concurrency and consistency were the only true ways to go forward.
                            
                            And we see this in real life all the time. Real life introduces compensations, cancellations, reconciliations and more. Not because many of these decisions were intentional, but that these are the natural ways to increase throughput.
                            
                            When we moved to processing more and more in a given day, we couldn’t just throw hardware at the problem. Just increasing our worker count isn’t going to help when we’re all talking to the same database.
                            
                            So we started relaxing constraints. Those FK constraints were now only enforced in very specific boundaries (mainly, aggregate roots). Otherwise, we’d do a loose joining of data, that may or may not be there yet. Messages are received out of order, sometimes weeks after the fact. Stores might lose their connection to the central AS400, and we don’t receive transactions until weeks later. Files get corrupted, messages get dropped. We have to handle this, just like the real world does.
                            
                            But a more decoupled, less consistent system paradoxically resulted in a more reliable system. A system with 100% consistency is a system with hidden bottlenecks. Once we realized that consistency is a business decision, it allowed us to explore other operating modes (ditching coordinated transactions etc.) that would have otherwise sunk our system.
                            
                            ### Lesson 4: People are unpredictable
                            
                            A system with a few dozen, hundred or thousand users doesn’t really have to deal with unpredictability as a standard operating mode. When you have a system with millions of people using it, unpredictability is the norm. A certain percentage of the population is:
                            
                              * Bipolar 
                                  * Schizophrenic 
                                      * Manic-depressive 
                                          * Sociopathic 
                                              * Psychopathic 
                                                  * Just plain jerks and want to game the system <- more than the others and more than you’d think</ul> 
                                                A small system might just have a couple in the above categories. A system with millions of users has thousands and thousands of people using it in highly unpredictable ways. Going in we had some idea how we’d handle customer service requests for normal users. But there are a significant group of people that will email every day complaining about something outside your normal resolution paths.
                                                
                                                Whether it’s people trying to game the system (interesting, until you see there are real dollars at stake here), people lying to get things for free, and everything in between, we had to be flexible in both our data capturing/recording and our reporting so that our customer service representatives could adequately service requests.
                                                
                                                It’s also why we push back a lot on complexity in requirements. If a person walking into the store can’t figure out how it works, they just won’t use it. If a customer service rep can’t explain to a customer, it won’t be supported. A developer can create complex software, but if it needs to be understood from a end-user perspective that DOESN’T use your software every day, everything needs to be simplified.
                                                
                                                ### Lesson 5: Messaging keeps you sane
                                                
                                                Early on in the system, everything was done effectively as batch files running as cron jobs. Which basically meant that if one thing failed it was quite hard to retry something.
                                                
                                                Today, just about every activity is governed, activated, communicated and controlled via asynchronous durable messaging. Why? It gave us the greatest control, insight and ability to scale. Non-durable messages were very difficult to manage, as you then have to build in mechanisms to track completion/acknowledgement. Non-durable is faster and more efficient, however complexity is now transferred to client code managing these channels.
                                                
                                                Durable messages also gave us a dirt simple means of managing failures. With NServiceBus, we can rely on the failure/retry policy in place for the vast majority of operations. Before, we’d get some email notification and dig through an error log to figure out how to re-do the work that failed. With NServiceBus, I never, ever lose work. That’s a huge win.
                                                
                                                On top of that, with messaging, I never really have to worry about deploying the system. With cron jobs, I had to be extremely careful about shutting jobs down, unless my jobs were explicitly coded to know how to start back where they left off. With messaging, each operation is a distinct message, so I can deploy any time of day without worrying about losing work.
                                                
                                                ### What I would have done differently
                                                
                                                Nothing. Every step along the way, we made the best decision we could based on the information we had on hand. We tried to stay flexible since our system was rather unpredictable on where it was going. What will it look like in a year? I have no idea. A year ago I couldn’t have predicted where we would be today. There were some mistakes made from unfamiliarity, but some things just take experience to know the right way to go.
                                                
                                                So it’s best not to try TOO much to architect for the distant future. I know what I see today, I know what’s immediately in front of me, but that’s about it.
                                                
                                                Those are just a few of the lessons learned, there were a lot more of course, but most of the others I’ve gone into more detail in previous blogs.