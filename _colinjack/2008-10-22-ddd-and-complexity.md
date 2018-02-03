---
wordpress_id: 6
title: DDD and Complexity
date: 2008-10-22T20:00:29+00:00
author: Colin Jack
layout: post
wordpress_guid: /blogs/colinjack/archive/2008/10/22/ddd-and-complexity.aspx
categories:
  - Uncategorized
---
</p> 

There have been some interesting and entirely valid discussions on Twitter about the validity of DDD and about deciding when its useful and when its too complex (including good comments from [Casey Charlton](http://twitter.com/caseycharlton/statuses/970664982) and [Jimmy Bogard](http://twitter.com/jbogard/statuses/970667578)). I full agree with Casey and Jimmy and the comments, when combined with an interesting discussion on the topic at the latest ALT.NET UK discussion, let me wanting to blog about how I think DDD can be used in different types of projects.

First off I must admit that even for a simple business system I&#8217;d be thinking about using some of the patterns from DDD, in particular I think these usually have value:

  1. **Aggregate** 
      * **Repository** 
          * **Service** </ol> 
        For example I find that thinking about aggregates makes me think much more carefully about how to map those classes to the database, for example how far to cascade, which in my view is a good idea as not thinking about boundaries can lead you to some fairly annoying debugging sessions. You can take these three patterns and with a good ORM and create and map a simple domain model to a green fields database very quickly.&nbsp; 
        
        **Tradeoffs**
        
        Here&#8217;s some of the tradeoffs we&#8217;re making when using DDD on a system that it doesn&#8217;t necessarily suit:
        
          1. **Analysis/Design** &#8211; We map completely skip the analysis/design and in particular the discussions with the domain expert, instead starting from our requirements and letting TDD and our own design skills guides us to the correct design. 
              * **Encapsulation** &#8211; We might expose everything using getters and setters and the domain may be anaemic, for example validation may be in attributes and/or use a [custom framework](http://www.castleproject.org/activerecord/documentation/v1rc1/usersguide/validation.html). 
                  * **Design Clarity** &#8211; If our primary focus is on getting going fast then we&#8217;re going to have to cut some corners.&nbsp; We&#8217;d bind the domain to the GUI, design it to be as easy to map to the database, make it easy to create domain objects (default constructors) and generally make tradeoffs in the quality of the domain model to make our own lives easier. 
                      * **Flexibility** &#8211; A model that is quick to create/map/bind is not likely going to be flexible, this may or may not be a problem. 
                          * **Patterns** &#8211; We&#8217;re ignoring half the patterns in DDD, patterns that have a lot of value in a complex domain model but may not be justified when the domain is simpler/more closely bounded. </ol> 
                        We make these tradeoffs to make our lives easier and in particular I wanted to cover two of the tradeoffs you may choose to make.
                        
                        **Design Clarity**
                        
                        If we want to be able to bind your GUI to the domain and map it to the database quickly then we can being to fray our domain model:
                        
                          1. Value objects make binding and displaying validation errors trickier. 
                              * If our user interface uses wizards then the GUI will want to create domain objects early on in the wizard, possibly without giving us any meaningful data. We thus end up with default constructors or constructors with very few arguments. 
                                  * If we use an ORM with a unit of work it will probably fight against our need to validate aggregates before saving them. 
                                      * If we use an ORM we&#8217;ll find it hard to version the entire aggregate. </ol> 
                                    With discipline you can make these tradeoffs whilst still maintaining a comprehensible model but there is no doubt that we are making tradeoffs. 
                                    
                                    **Flexibility**
                                    
                                    We&#8217;re also sacrificing flexibility, for example a lot of talk about repositories right now focuses on generic repositories. For example we&#8217;d have a _Repository<T>_ class where T is an aggregate root and you&#8217;d have query methods on this repository that would take Linq specifications. That&#8217;s going to be fine for a lot of cases but in more complex models (or where we don&#8217;t control our environment fully) our repository can encapsulate complex logic, for example we should be able to ensure the following:
                                    
                                      1. Instances of aggregate are never deleted or they are simply archived. 
                                          * Instances of aggregate Y are built up from multiple data sources. 
                                              * Instead of mapping aggregate Z to a (legacy) DB we map some simple DTO&#8217;s and then in the repository convert them to our nicely designed aggregate. 
                                                  * Query Z is very expensive and needs to be done using SQL. </ol> 
                                                Those are all things I’ve had to be involved in when working with a moderately complex domain model and repositories helped encapsulate those details. So whilst I think generic repositories might have their place ins some systems I think you have to be aware of the choices your making.
                                                
                                                **What was the point of all this?**
                                                
                                                My point with all this is that you can get a lot of value from DDD without following it too closely, but you need to be aware of what tradeoffs your making and why. Choosing to go for a simple domain model when you have a complex problem to solve is a really bad choice and going from active record (true active record) to a real domain model is not going to be a smooth transition. 
                                                
                                                However I don&#8217;t think the choice is easy, for example there&#8217;s been a lot of discussion recently on whether DDD and complex models are suitable for CRUD related problems. In general I can see why using DDD on an average CRUD system is a mistake but sometimes it is worth using. For example we used DDD on a CRM system that among other things handled parties and their associations in a temporal manner. This was a complex modelling problem solved with a complex pattern but primarily we were handling CRUD (including constraints/validation) and setting the stage for other systems to use the information. Trying to do this using active record would, in my view, have been a big mistake.
                                                
                                                So as Casey pointed out DDD is expensive and whilst it can pay off you need to do in with eyes open fully aware of the tradeoffs involved.