---
wordpress_id: 9
title: 'Unit Testing NHibernate DALs &#8211; What Are You *Really* Testing?'
date: 2007-05-17T11:19:53+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/05/17/unit-testing-nhibernate-dals-what-are-you-really-testing.aspx
categories:
  - NHibernate
  - Patterns
  - TDD
  - Tools
---
</p> 

Someone new to NHibernate&nbsp;recently asked me how to **unit** test their data access layer which uses NHibernate.&nbsp; I&#8217;ve already sent him my thoughts on it, but figured it may make for a good blog post to get some of the community&#8217;s reaction.&nbsp; 

#### What Are You \*Really\* Testing?

From my perspective, there are (at least) a couple questions you should always be asking yourself when practicing TDD or just testing in general: 

  1. What am I really testing here?&nbsp; My code or 3<sup>rd</sup> party/framework code?&nbsp; 
      * At some point you need to trust the frameworks your using or else you’ll end up testing the whole .NET framework…&nbsp;&nbsp; Not good! 
      * How much value is really being gained from this test that I am writing?&nbsp; A quick quiz&#8230; 
          * Which test do you think would bring the most value? 
              * a) A unit test which uses a mocked ISession to verify that when Save(entity) is called that NHibernate does what **it&#8217;s supposed to do**? 
                  * b) A unit test to make sure NHibernate is generating the correct sql for an HQL query or Criteria call which **it&#8217;s supposed to do**? 
                      * c) An integration test which verifies that the mapping files **you&#8217;ve written** are configured correctly to map **your** domain objects to **your** database tables?</ul> 
                      * Answer?&nbsp; More than likely, C is probably the best answer to this question.&nbsp; If all you have are unit tests with no state-based integration tests, that&#8217;s probably a bad sign.&nbsp; At some point you&#8217;ve got to write integration tests to make sure all your&nbsp;components&nbsp;work together, especially in your data access/persistence layer.</ul> </ol> 
                #### Exceptions
                
                Now, if for some reason you&nbsp;have another layer of abstraction in there like PersonRepository -> IPersistenceFacade -> NHibernate, then driving out the interaction between your PersonRepository and IPersistenceFacade is probably a good idea.&nbsp; But that&#8217;s probably as far down as I&#8217;d go for **unit** tests.
                
                Also, if you&#8217;re not using an ORM and have to use vanilla ADO.NET to hand roll your own data access/mapping layers, then I would most definitely recommend driving that out using TDD and unit tests.&nbsp; But hopefully this is not something you&#8217;re having to do for the most part.
                
                #### Final Thoughts
                
                So far in my current project, I&#8217;m&nbsp;only using integration tests for my persistence layer (aka DAL) to verify that my mapping files are correct.&nbsp; The nice thing is that NH makes this really easy with its SchemaExport tool to very easily generate your database schema from your mapping files.&nbsp; So I’m using that along with a couple hand-rolled utilities and factories for generating and inserting sample data to use for integration testing purposes.
                
                Of course, having automated unit tests for as much of your application as possible is still a great goal, but&nbsp;sometimes it needs to be weighed against how much business value it’s going to help you deliver in terms of increasing the maintainability and testability of **your** code.&nbsp; **However, when in doubt, write a test!** 
                
                #### Your Thoughts?