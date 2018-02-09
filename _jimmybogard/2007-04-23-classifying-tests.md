---
wordpress_id: 9
title: Classifying tests
date: 2007-04-23T12:57:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/04/23/classifying-tests.aspx
dsq_thread_id:
  - "305804401"
categories:
  - Agile
  - Testing
redirect_from: "/blogs/jimmy_bogard/archive/2007/04/23/classifying-tests.aspx/"
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/classifying-tests.html)._

When defining a testing strategy, it&#8217;s important to take a step back and look at what kinds of tests we would like to develop. Each type of test has a different scope and purpose, and can be developed by different roles in an organization. Most kinds of testing are concerned with verification and validation, also known as &#8220;V&V&#8221;. Verification deals with lower level, &#8220;am I building the software right&#8221; kinds of tests. This usually entails some form of unit testing. Validation answers the question &#8220;am I building the right software&#8221;, which focuses on higher level or business related tests. I&#8217;ve usually seen tests broken down into the following categories:

  * Unit tests 
      * Integration tests 
          * Functional tests</ul> 
        I&#8217;ve ignored regression and performance tests, because both of these tests take the form of any of the above test types. These test definitions come more from the [agile school of testing](http://www.io.com/~wazmo/papers/four_schools.pdf).
        
        ### Unit tests
        
        So you just wrote a piece of code to implement some feature. Does it work? Can you prove it? If I come back tomorrow, can you prove it again? What about next week, or next month, or next year? If another developer modifies your code, can they prove it still works, and didn&#8217;t break your functionality?
        
        Unit testing answers the first two questions. Namely, does my code do what I think it&#8217;s supposed to do? [Continuous Integration](http://www.martinfowler.com/articles/continuousIntegration.html) will answer the rest.
        
        #### Scope
        
        The scope of a unit test is a single unit, usually a single public member. Unit tests should only test that unit, with **no interaction with external dependencies**. Unit tests can be defined as:
        
          * Isolated from external dependencies 
              * Repeatable 
                  * Testing only one thing 
                      * Easily readable 
                          * Order independent 
                              * Side effect free 
                                  * Having only one reason to fail 
                                      * Written by the developer 
                                          * Fast to run</ul> 
                                        If a unit test hits the database, then it&#8217;s no longer a unit test because it depends on an external module. If the database goes down, I&#8217;m not testing the unit anymore, I&#8217;m testing to see if the database is up. Other external dependencies include:
                                        
                                          * Databases 
                                              * HttpContext items (Querystring, session, etc.) 
                                                  * Web services 
                                                      * File I/O 
                                                          * Anything else that accesses the network or the disk</ul> 
                                                        If I can remove external dependencies of a class during unit testing, I can greatly reduce the number of reasons for a unit test to fail. Ideally, my tests are also automated so they can be easily run. On my last project, we started writing unit tests on all new development, and regression tests on existing behavior. We wound up with over 1200 unit tests in about six months for about 30K lines of code, covering nearly 100% of new code (~98%) and about 50-75% of the existing codebase. It&#8217;s also typical to see a 1:1 or 1.5:1 ratio of unit test code to production code in a team practicing [TDD](http://www.testdriven.com/).
                                                        
                                                        #### Purpose
                                                        
                                                        Unit tests should test only one thing and have only one reason to fail. In a future post, I&#8217;ll dive more into unit testing with examples. Since programmers are human and make mistakes on a daily basis, unit tests are a developer&#8217;s back up to verify small, incremental and individual pieces of functionality are implemented the way the developer intended. Unit tests strive to answer the question &#8220;does my code do what I think it&#8217;s supposed to do?&#8221;
                                                        
                                                        ### Integration tests
                                                        
                                                        I&#8217;ve written a suite of unit tests that verify the functionality I was trying to create. I&#8217;ve abstracted external dependencies away so I can make sure that my tests have only one reason to fail. But in production, the web service does exist. The database is there. Emails are sent out, queue messages sent, files created and read. Integration tests put the different pieces together to test on a macro scale. Integration tests can be defined as:
                                                        
                                                          * Tests for dependencies between objects and external resources 
                                                              * Repeatable 
                                                                  * Order independent 
                                                                      * Written by an independent source (QA)</ul> 
                                                                    In other words, integration tests are more end-to-end to determine if the entire system is functioning correctly.
                                                                    
                                                                    #### Scope
                                                                    
                                                                    As you can see, integration tests are more on the &#8220;macro&#8221; scope of testing. These tests can be written in a [unit](http://nunit.org/) [testing](http://www.mbunit.com/) [framework](http://msdn2.microsoft.com/en-us/library/ms182516(VS.80).aspx), but are also written in other frameworks such as [FIT](http://fit.c2.com/) or [WATIR](http://wtr.rubyforge.org/). These are the tests to make sure that the database is written to correctly, that an email was sent, and a MSMQ message was written correctly.
                                                                    
                                                                    #### Purpose
                                                                    
                                                                    In the real world, we have external dependencies and we should test them. Integration tests verify that the code functions correctly in the presence of these external dependencies. We can test if a single module works with the external dependencies present, or if a group of modules works together correctly. Either way, integration tests are about putting the pieces together and determining if they fit.
                                                                    
                                                                    ### Functional tests
                                                                    
                                                                    We&#8217;ve developed some software and have tests that isolate dependencies and embrace them. But we&#8217;re still not guaranteed that we&#8217;ve written the software that business has demanded. Having unit and integration tests is fine and dandy, but if our software doesn&#8217;t meet business requirements, it&#8217;s just been a huge waste of time and money. Functional tests are:
                                                                    
                                                                      * Developed by, or with the direct assistance of, the [business owners](http://www.scrumforteamsystem.com/ProcessGuidance/Roles/ProductOwner.html) 
                                                                          * Focused on verifying business requirements 
                                                                              * Written in a very high-level language such as a [DSL](http://www.martinfowler.com/bliki/DomainSpecificLanguage.html)</ul> 
                                                                            #### Scope
                                                                            
                                                                            Functional tests are as end-to-end as tests come. These tests are performed on the topmost layers of an n-tier architecture, as these are the layers seen by the business or the customers. These tests are often the slowest, and can be a mix of automated and manual testing. These tests can also be used to sign off on project completion.
                                                                            
                                                                            #### Purpose
                                                                            
                                                                            Business has a set of requirements the software must meet, and functional tests are the way of verifying our software meets those requirements. Since requirements come in may forms, functional tests can be any kind of tests to verify those requirements, from &#8220;Does the website look good&#8221; to &#8220;When I check out, is the terms and conditions displayed&#8221;.
                                                                            
                                                                            ### Looking back, looking forward
                                                                            
                                                                            I&#8217;m sure there are more types of testing we could look at, including user acceptance or user interface testing. These testing types go outside the scope of verification and validation, so I left them out of this post. 
                                                                            
                                                                            Automating your tests will give you insight to information such as [code coverage](http://en.wikipedia.org/wiki/Code_coverage) and other [code metrics](http://www.thepragmaticarchitect.com/2006/12/15/code_metrics.html), especially if they are part of a nightly or continuous integration build. As the scope of tests grows from unit to functional, and the number of bugs discovered should decrease as well. It&#8217;s much easier to fix a bug in a unit test than in a functional test because of the scope of each type. If I have fewer places to look, I&#8217;ve cut the time to find and fix the bug dramatically. Since it isn&#8217;t enough just to deliver functionality to the business, but to also create a clean and maintainable codebase, a solid suite of tests is absolutely critical for enabling changes for future business requirements. And if they were automated, that would be really cool too :).