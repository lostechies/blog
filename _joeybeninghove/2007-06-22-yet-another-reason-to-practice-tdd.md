---
wordpress_id: 18
title: Yet another reason to practice TDD
date: 2007-06-22T17:32:42+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/06/22/yet-another-reason-to-practice-tdd.aspx
categories:
  - Productivity
  - TDD
redirect_from: "/blogs/joeydotnet/archive/2007/06/22/yet-another-reason-to-practice-tdd.aspx/"
---
Things have been a little slow on the blog lately because this week is the start of a new job/company for me.&nbsp; I&#8217;m still getting a feel for things and of course one of the first things I&#8217;m trying to get folks interested in is TDD.&nbsp; I have a usual list of advantages and points that I use for getting across to folks the benefits of practicing TDD.&nbsp; Most of which center around the fact that TDD is primarily a design tool, and the fact that you get a nice set of automated regression tests is just a nice side effect.&nbsp; **TDD is not about testing!**

But today, after looking at some existing code, I thought of another example&nbsp;that does explain one way in which the &#8220;Test&#8221; part of TDD is very beneficial.

(For&nbsp;you fellow experienced&nbsp;TDD practitioners, this will be very obvious to you.&nbsp; So this is mainly for those who are still struggling with &#8220;why do I need TDD/Unit Testing?&#8221;&#8230;)

#### Non TDD/Unit Testing Approach

Let&#8217;s assume for a sec that you&#8217;re **not** using TDD,&nbsp;and not&nbsp;even TAD (Test-After Development).&nbsp; A typical set of steps to write a piece of code might be:

  1. Look at the requirements/use case/user story to figure out what feature needs to be implemented 
      * Use a modeling tool (or even better, a whiteboard) to design what you&#8217;re getting ready to code 
          * Write the code as you think it should be (hopefully not [generated](http://codebetter.com/blogs/jeffrey.palermo/archive/2007/06/22/xml-is-the-code-of-the-future-so-long-c-say-it-isn-t-so.aspx), but that&#8217;s a whole &#8216;nother discussion) 
              * Perform a series of manual steps to verify that your code works 
                  * Repeat 2 & 3 until your manual testing steps have verified the code works as you expect</ol> 
                Now, ask yourself a&nbsp;few questions:
                
                  1. &#8220;What is my confidence level that changes to this code **by me** won&#8217;t introduce bugs?&#8221; 
                      * &#8220;What is my confidence level that changes to this code **by others** won&#8217;t introduce bugs?&#8221; 
                          * &#8220;How long is it going to&nbsp;take to test future changes in this code?&#8221;</ol> 
                        Chances are, you may have a fairly high confidence level that **you** won&#8217;t introduce bugs since you wrote the code initially (although that is faulty logic as well).&nbsp; But what if **someone else** needs to make changes to that code?&nbsp; You&#8217;re probably not all that confident now.&nbsp; Because you know that in order to verify this piece code, you had to run a series of manual steps (probably in different variations) to verify it works as expected.&nbsp; And if you didn&#8217;t document those manual steps for anyone else, well, you can see where I&#8217;m going with this.
                        
                        But let&#8217;s just say you have been a good little developer and you have documented the manual steps needed to verify that a particular piece of code works.&nbsp; The time it&#8217;s going to take to go through those manual steps multiple times is probably not going to be very fast, and will soon become very tedious.&nbsp; And how often do you think folks are going to try and improve their design with refactoring if they have to run through&nbsp;a series of tedious manual steps just to verify they didn&#8217;t break anything?!?&nbsp; **Probably never!**
                        
                        #### TAD (Test-After Development) / Standard Unit Testing&nbsp;Approach
                        
                        Contrast that with an approach where you would write unit tests after you implemented the code to automate the steps needed to verify its result.&nbsp; 
                        
                          1. Look at the requirements/use case/user story to figure out what feature needs to be implemented 
                              * Use a modeling tool (or even better, a whiteboard) to design what you&#8217;re getting ready to code 
                                  * Write the code as you think it should be (hopefully not [generated](http://codebetter.com/blogs/jeffrey.palermo/archive/2007/06/22/xml-is-the-code-of-the-future-so-long-c-say-it-isn-t-so.aspx), but that&#8217;s a whole &#8216;nother discussion) 
                                      * Write unit test(s) that verify the code works as you expect 
                                          * Fix your code if necessary and re-run your (hopefully fast) unit tests until everything is verified</ol> 
                                        Now this is&nbsp;definitely &#8220;better than nothing&#8221;, as they say.&nbsp; But you&#8217;ll probably find that writing simple unit tests for code that&#8217;s already been written, turns out to not be so simple in a lot of cases.&nbsp; The reason behind this is that the code probably wasn&#8217;t written&nbsp;with testability in mind and is tightly coupled with the rest of the system.&nbsp; This usually equates to really complex set up code&nbsp;needed for your **unit** tests to run correctly.&nbsp; And at that point your tests are probably nothing short of an end to end **integration** test.&nbsp; Integration tests definitely have their place, but not during code design.
                                        
                                        But this is at least better in the fact that you have a set of automated tests that can be run (hopefully at any time) to verify that any changes to this code&nbsp;are still verified.
                                        
                                        #### TDD (Test-Driven Design/Development) Approach
                                        
                                        As you can probably guess, this is the approach I prefer for **all** of my development.&nbsp; 
                                        
                                          1. Look at the requirements/use case/user story to figure out what feature needs to be implemented 
                                              * Use a whiteboard (if necessary)&nbsp;to get a very rough idea of the interaction the new code will need with the rest of the system 
                                                  * Write&nbsp;a&nbsp;unit test (think executable specification), mocking out any dependencies, if necessary 
                                                      * Get the test to compile and pass 
                                                          * Refactor to remove duplication and improve design 
                                                              * Repeat 3-5 until the feature is implemented</ol> 
                                                            I usually find that making changes to code that was implemented using TDD is a joy.&nbsp; The tests are likely to run very fast, since they&#8217;re only testing a small block of code without hitting a database or some service and the code&#8217;s coupling to other parts of the system is probably pretty low.&nbsp;&nbsp;Now my confidence level in making changes is very high, because I have that safety net of executable specifications that verify the feature is working as expected.&nbsp; And even better, they are repeatable and can be run at any time.
                                                            
                                                            #### Conclusion
                                                            
                                                            Use those CPU cycles for what they&#8217;re good at&#8230; automation!&nbsp; One of the biggest time savers is automating as much of your tedious work as possible.&nbsp; Testing and deployment are prime candidates for automation.
                                                            
                                                            (I realize that my duplication of the list of steps in each section of this post, with slight modifications, clearly violates the DRY principle.&nbsp; Perhaps I could have introduced the Template Method pattern to consolidate the common items&nbsp;or a sprinkle of the&nbsp;Strategy pat&#8230;&nbsp; ok, I&#8217;m getting carried away&#8230;&nbsp; hehe&#8230;)