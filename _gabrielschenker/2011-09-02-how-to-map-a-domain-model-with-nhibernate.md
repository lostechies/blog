---
wordpress_id: 61
title: How to map a domain model with NHibernate?
date: 2011-09-02T22:06:00+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/2011/09/02/how-to-map-a-domain-model-with-nhibernate/
dsq_thread_id:
  - "403360420"
categories:
  - How To
  - NHibernate
---
Today a friend of mine ask me the following (I am para-phrasing): 

> _“I have a question regarding NHibernate and mapping. In an application we want to access the database through NHibernate from inside a WCF service, thus lazy loading is not an option for us.&nbsp; To avoid to have to use the whole graph around an entity each time I want to use two domain models. The first model contains all entities without associations and the second one the model with all associations between the entities._
> 
> _Is this the usual approach people chose when dealing with similar problems? Are there any problems to be expected if two different entities are mapped to the same table?”_

Now, let me try to answer this question(s). First of all let’s try to clarify what thoughts might be behind those questions.

  1. If we turn **off** lazy loading in NHibernate and have a domain model where (almost) all entities are connected to each other through relations then we have a problem when loading telling NHibernate to load one of the entities of the domain model. Since lazy loading is turned off NHibernate would not only load the entity itself but all other entities that are related to the entity to be loaded. In an extreme case one would cause the whole database to be loaded. 
      * We can “kind of” solve this problem if we break the chain of relations in the model. In the extreme case we have a (degenerated) domain model with entities that are not related to each other. 
          * But if we only have a bunch of entities in our model that are not related to each other then we cannot easily navigate from one entity to another and thus using the domain for querying becomes unhandy if not impossible since when querying data to display on screen or in a report we most certainly need more data then the one that is stored in a single entity (e.g. when displaying the details of a product on screen we also want to display the categories the product is associated with as well as a photo of the product and maybe even related products.).</ol> 
        Now, what is the correct answer?
        
        As always I have to say: “It depends!” There is no good answer which fits any situation. That said, let’s try to give some possible guidelines for different scenarios
        
        ## Scenario 1: Relatively simple forms over data type application
        
        In this scenario we should keep things as simple as possible. We want to define only one model of the domain at hand and we want to use this model for data manipulation as well as for query operations. In this case I would recommend to use lazy loading of NHibernate (or any other ORM). All entities of the model are interconnected through relations. As a simple sample lets take the blog sample.
        
        [<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2011/09/image_thumb.png" width="475" height="418" />](http://lostechies.com/content/gabrielschenker/uploads/2011/09/image.png)
        
        ### Commands – that is writing data
        
        Now when we want to manipulate data we can have different scenarios
        
          1. Manipulating the blog entity 
              * create a new blog. 
                  * update an existing blog and change its title, add another author or add some more categories. etc. 
                      * delete the blog (with all its posts)</ul> 
                      * Authoring posts 
                          * write a new post. 
                              * edit a post to modify the content or add tags 
                                  * delete a post.</ul> 
                                  * Commenting a post 
                                      * reader adds a new comment to a blog post</ol> 
                                Each of the above operations is very limited in its extent. When manipulating the blog entity I am not interested in the post that were written as part of this blog and certainly I am not interested in the comments to each post. Thus I do not need to load any post or comment data. Since the relations from the blog entity to the posts are mapped as lazy I can load the blog entity without any side effects. Only the blog data is loaded and no other entity is populated by this operation
                                
                                > <font face="Courier New">var blog = session.Get<Blog>(1);</font>
                                
                                Specifically NHibernate does not populate the **Authors** nor the **Categories** collection of the blog entity
                                
                                On the other hand when authoring a new post I am not really interested in the details of the blog to which the post is associated. The only things I need to know when creating a new post are a) the content of the post, b) the key (ID) of the blog to which the post is associated and c) the collection of tags under which the post shall be classified. The code might then look like this:
                                
                                > <font face="Courier New">var post = new Post{ Content = dto.Content };</font>
                                > 
                                > <font face="Courier New">post.Blog = session.Load<Blog>(dto.BlogId);</font>
                                > 
                                > <font face="Courier New">foreach(var tag in dto.Tags) {</font>
                                > 
                                > <font face="Courier New">&nbsp;&nbsp;&nbsp; post.AddTag(tag);</font>
                                > 
                                > <font face="Courier New">}</font>
                                > 
                                > <font face="Courier New">session.Save(post);</font>
                                
                                Here dto is the data transfer object that contains the data coming from the client. 
                                
                                Please not the <font face="Courier New">session.Load<Blog>(…)</font> operation. This operation does not load any data from the database. It just creates a proxy of the blog entity in memory and populates the ID with the value provided, that is dto.BlogId. That’s enough for NHibernate to successfully make an association between the post and the blog.
                                
                                If we update an existing post we can load it like this
                                
                                > <font face="Courier New">var post = session.Load<Post>(postId);</font>
                                
                                Since we have lazy loading turned on no associated entities will be loaded and I can happily update my post entity.
                                
                                ### Queries – reading data
                                
                                When reading data to display on screen or in a report the situation is a little bit different. Now all of a sudden I need the relations between the entities to not only load an entity but also associated information stored in related entities. Samples:
                                
                                  1. Display blog details and a list of titles of the 10 most recent posts 
                                      * Display the content of a post and all its associated comments 
                                          * Display a list of the most popular blog posts of the last year 
                                              * etc.</ol> 
                                            How can we do that in knowing that we have NHibernate lazy loading turned on? And how can we do it efficiently and avoid such things as the infamous select-(n+1) problem? And please do not forget that we are querying the database from within a WCF service and thus need to make sure that all data has been loaded at the moment the (NHibernate) session is disposed.
                                            
                                            The answer is: use eager loading! Whether we use HQL, Criteria Queries or LINQ to retrieve the data, we always have the possibility to instruct NHibernate to eagerly load some associated data. Let’s give a sample: I want to load the details of a post and all its associated comments. Using LINQ the query would look similar to this:
                                            
                                            > <font face="Courier New">var post = session.Query<Post></font>
                                            > 
                                            > <font face="Courier New">&nbsp;&nbsp;&nbsp; .Fetch(p => p.Comments)</font>
                                            > 
                                            > <font face="Courier New">&nbsp;&nbsp;&nbsp; .Single(p => p.PostId = 101);</font>
                                            
                                            Note the Fetch function which instructs LINQ to load the collection of comments with the post.
                                            
                                            Although the relation between Post and Comment is mapped as lazy we were able to load post and comments in one go. Nice.
                                            
                                            ## Scenario 2: Complex domain with many complicated business rules
                                            
                                            This is a completely different situation than the previous one. Here we are probably talking about an enterprise application where we can justify some “overhead” if it helps us to decrease or manage the complexity of the overall system.
                                            
                                            In such a scenario I would highly recommend to use an architectural pattern known as CQRS (command query responsibility segregation). In this pattern data manipulation (commands) and data retrieval (query) operations are strictly separated. The commands operate on a domain model whereas the queries do NOT use the domain model but are sent as directly as possible to the database. Having this separation of concerns helps us to reduce the complexity of the domain. The domain is now not responsible to satisfy query request but can be fully optimized for data manipulation (i.e. business transaction).
                                            
                                            The domain model is carefully segregated into aggregates which represent the boundaries of a typical business transaction. Inside an aggregate entities are associated to each other through relations. Any associations to entities which are not part of the aggregate are achieved by using (foreign-) keys.
                                            
                                            Having defined these aggregates we do not need to use lazy loading since we always want to load the whole aggregate when operation on (part of) it.
                                            
                                            For the queries we don’t even necessarily need NHibernate to access the database but can use a thin data layer and ADO.NET to get to the required data.
                                            
                                            The data we want to read can be provided by various means. Each has its advantages and disadvantages
                                            
                                              * The application uses two databases. One for the write operations and the other one for the read operations. The read only database contains the de-normalized data of the write-only database (the two databases are synchronized through some services). One can think of this read-only database as being kind of a data warehouse. 
                                                  * The application only uses one database for writing and reading. We access the data through database views which provide a de-normalized view of the data which is optimized for read operations. 
                                                      * Here also we use only one database. Dynamic SQL is used to retrieve the data&nbsp; </ul>