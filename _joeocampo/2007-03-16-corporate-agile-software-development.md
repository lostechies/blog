---
id: 12
title: Corporate Agile Software Development
date: 2007-03-16T02:34:00+00:00
author: Joe Ocampo
layout: post
guid: /blogs/joe_ocampo/archive/2007/03/15/corporate-agile-software-development.aspx
dsq_thread_id:
  - "262088499"
categories:
  - Uncategorized
---
For those of you that don&#8217;t know, I am currently the&nbsp;software development manager for a fortune 500 financial company in the United States.&nbsp; Because I work in the financial industry most agile coaches are shocked that we even practice agile development.&nbsp; Most financial institutions are set in their ways when it comes to developing software.&nbsp; Usually it is the traditional waterfall (BDUF) process that plagues these institutions.


  


The most important aspect of introducing agile practices is to make sure to include everyone. By everyone I mean every stake holder. Usually in a large corporation you have business analyst who act as advocates for the customers in the field. Then you have systems analysts who act as proxies between the development team and the business analyst. Then you finally have the development team who actually builds the system. When introducing agile you have to make certain not to exclude or take away from given responsibilities that have been there long before you came along.
  


&nbsp;The information below is the beginning of a 6 part series on corporate agile development.
  


## Corporate Agile Development Life Cycle Stage Overview<A>&nbsp;</A>


  


Corporate Agile Development supports rapid iterative development with continuous learning and refinement. Product definition, development, and testing occur in the form of six phases resulting in the incremental completion of the project. These six phases form the foundation of a release. Different releases have different focus as the project approaches completion. One week iterations allow you to reduce the margin of error in your estimates and provide fast feedback about the accuracy of your project plans. The following list and illustration provide an overview of the process. The subsequent chapter will provide more guidance on how each phase is implemented.
  


Six phases of a release:
  



  


  1. Storming Phase
  
      * Planning Phase
  
          * Development Iteration Phase
  
              * System Integration Testing (SIT) Phase
  
                  * User Acceptance Testing (UAT) Phase
  
                      * Closing Phase</OL>
                    
  
                    <IMG src="http://blog.agilejoe.com/content/binary/ASDLC_Overview.jpg" border="0" />
                    
                    
  
                    The entire process is geared around collaboration and communication. Subtle variations have been added to expand upon on already proven process.
                    
                    
  
                    While in general practice agile methodologies encourage change and adaptation, certain changes have greater impact and require careful consideration and coordination. It is not a matter of control—who gets to make the decisions—as much as it is a matter of coordination—making sure the team understands the total impact of a change and which groups are affected. The Business Analyst partner along with the Systems Analyst and Development Architects collaborate around requirement goals. The result of this partnership is the determination jointly if the requirement goals are viable enough to make it into a release planning phase.  
                    
                    
                    
  
                    The purpose of the storming phase is to clearly identify what is to be modeled and to uncover any user goals that require additional information. The following artifacts will be the result of the storming phase:
                    
                    
  
                    
  
                    
                    
                      * Field Request
  
                          * Requirement Goals
  
                              * Feature Cards
  
                                  * Feature Skeleton
  
                                      * Planning Preparation Meeting</UL>
                                    
  
                                    It is **not** a matter of control—who gets to make the decisions—as much as it is a matter of coordination—making sure the team understands the total impact of a change and which groups are affected. The Business Analyst partner along with the Systems Analyst and Development Architects collaborate around requirement goals. The result of this partnership is the determination jointly if the requirement goals are viable enough to make it into a release planning phase.
                                    
                                    
  
                                    The purpose of the storming phase is to clearly identify what is to be modeled and to uncover any user goals that require additional information. The following artifacts will be the result of the storming phase:
  
                                    
                                    
                                    ### What is a Field Request
                                    
                                    
  
                                    
                                    
                                    Every day new ideas or concepts for a system are brainstormed or thought of. These epiphanies lead to enhancement to an existing systems or the creation of an entirely new system. A field _request is nothing more than the culmination of these epiphanies manifested in a written,_ auditory or electronic medium.
  
                                    
                                    
                                    ##### <A>Responsible Ownership</A>
                                    
                                    
  
                                    
                                    
                                    The **Business Analysts** are responsible for aggregating the entire queue of field request for their customers. The queue should be prioritized from a business value perspective that allows the Business Analyst manager to quickly determine what field request warrant further investigation in becoming a Requirement Goal.
  
                                    
                                    
                                    ##### <A>Example of a Field Request</A>
                                    
                                    
  
                                    
                                    
                                    > **Field User Sally**: (Drafting and short email) 
  
                                    
                                    
                                    > I was wondering if you could please find a way for our clients to use some type of machine to draft money from their account and see their balances. 
  
                                    
                                    
                                    > Thank you, 
  
                                    
                                    
                                    > User Sally 
  
                                    
                                    
                                    ****
  
                                    
                                    
                                    #### <A>What is a Requirement Goals</A>
                                    
                                    
  
                                    
                                    
                                    It seems so easy to think that if everything is written down and agreed to then there can be no disagreements, developers will know exactly what to build, testers will know exactly how to test Customers will get the developers&#8217; interpretation of what was written down, which may not be exactly what they wanted.
  
                                    
                                    
                                    Before we talk about what a requirement goal is let’s talk about what it isn’t.
  
                                    
                                    
                                    ##### <A></A><A>Requirement Goals Are not IEEE 830</A> [Mike Cohn: User Stories Applied](http://www.amazon.com/User-Stories-Applied-Development-Addison-Wesley/dp/0321205685)
                                    
                                    
  
                                    
                                    
                                    The Computer Society of the Institute of Electrical and Electronics Engineers (IEEE) has published a set of guidelines on how to write software requirements specifications (IEEE 1998). This document, known as IEEE Standard 830, was last revised in 1998. The IEEE recommendations cover such topics as how to organize the requirements specification document, the role of prototyping, and the characteristics of good requirements. The most distinguishing characteristic of an IEEE 830-style software requirements specification is the use of the phrase &#8220;The system shall&#8230;&#8221; which is the IEEE&#8217;s recommended way to write functional requirements. A typical fragment of an IEEE 830 specification looks similar to the following:
                                    
                                    
  
                                    
                                    
                                    _4.6) The system shall allow a company to pay for a job posting with a credit card._
                                    
                                    
  
                                    
                                    
                                    _4.6.1) The system shall accept Visa, MasterCard and American Express cards._
                                    
                                    
  
                                    
                                    
                                    _4.6.2) The system shall charge the credit card before the job posting is placed on the site._ 
                                    
                                    
  
                                    
                                    
                                    _4.6.3) The system shall give the user a unique confirmation number._ 
                                    
                                    
  
                                    
                                    
                                    Documenting a system&#8217;s requirements to this level is tedious, error-prone, and very time-consuming. Additionally, a requirements document written in this way is, quite frankly, boring to read. Just because something is boring to read is not sufficient reason to abandon it as a technique. However, if you&#8217;re dealing with 300 pages of requirements like this (and that would only be a medium-sized system), you have to assume that it is not going to be thoroughly read by everyone who needs to read it. Readers will either skim or skip sections out of boredom. Additionally, a document written at this level will frequently make it impossible for a reader to grasp the big picture.
                                    
                                    
  
                                    
                                    
                                    Unfortunately, it is effectively impossible to write all of a system&#8217;s requirements this way. There is a powerful and important feedback loop that occurs when users see the software being built for them. When users see the software, they will come up with new ideas and change their minds about old ideas. When changes are requested to the software described in a requirements specification, we&#8217;ve become accustomed to calling it a &#8220;change of scope.&#8221; This type of thinking is incorrect for two reasons. First, it implies that the software was at some point sufficiently well-known for its scope to have been considered fully defined. It doesn&#8217;t matter how much effort is put into upfront thinking about requirements, we&#8217;ve learned that users will have different (and better) opinions once they see the software. Second, this type of thinking reinforces the belief that software is complete when it fulfills a list of requirements, rather than when it fulfills its intended users&#8217; goals. If the scope of the user&#8217;s goals changes then perhaps we can speak of a &#8220;change of scope,&#8221; but the term is usually applied even when it is only the details of a specific software solution that have changed.
                                    
                                    
  
                                    
                                    
                                    IEEE 830-style requirements have sent many projects astray because they focus attention on a checklist of requirements rather than on the user&#8217;s goals. Lists of requirements do not give the reader the same overall understanding of a product that stories do. It is very difficult to read a list of requirements without automatically considering solutions in your head as you read. Carroll (2000) suggests that designers &#8220;may produce a solution for only the first few requirements they encounter.&#8221; For example, consider the following requirements:
                                    
                                    
  
                                    
                                    
                                    _3.4) The product shall have a gasoline-powered engine._ 
                                    
                                    
  
                                    
                                    
                                    _3.5) The product shall have four wheels._ 
                                    
                                    
  
                                    
                                    
                                    _3.5.1) The product shall have a rubber tire mounted to each wheel._ 
                                    
                                    
  
                                    
                                    
                                    _3.6) The product shall have a steering wheel._
                                    
                                    
  
                                    
                                    
                                    _3.7) The product shall have a steel body._ 
                                    
                                    
  
                                    
                                    
                                    __
                                    
                                    
  
                                    
                                    
                                    Now imagine in your mind what type of vehicle this is and what it looks like. Is it red? How big are the tires? How fast does it go?
                                    
                                    
  
                                    
                                    
                                    But suppose that instead of writing an IEEE 830-style requirements specification, the user told us their goals for the product:
                                    
                                    
  
                                    
                                    
                                    As a landscaper I would like a product that makes it easy and fast for me to mow my lawn. I want to be comfortable while using the product.
                                    
                                    
  
                                    
                                    
                                    By looking at the user&#8217;s goals, we get a completely different view of the product and realize that the customer really wants a riding lawn mower, not an automobile or what ever else you imagined. These goals are not user stories, but where IEEE 830 documents are a list of requirements, requirement goals describe a user&#8217;s goals. By focusing on the user&#8217;s goals for the new product, rather than a list of attributes of the new product, we are able to design a better solution to the user&#8217;s needs.
                                    
                                    
  
                                    
                                    
                                    A final difference between user stories and IEEE 830-style requirements specifications is that with the latter the cost of each requirement is not made visible until all the requirements are written down. The typical scenario is that one or more analysts spend two or three months (often longer) writing a lengthy requirements document. This is then handed to the programmers who tell the analysts (who relay the message to the customer) that the project will take twenty-four months, rather than the six months they had hoped for. In this case, time was wasted writing the three-fourths of the document that the team won&#8217;t have time to develop, and more time will be wasted as the developers, analysts and customer iterate over which functionality can be developed in time. With requirement goals, an estimate is associated with each story right up front. The customer knows the velocity of the team and the story unit cost of each story. After writing enough stories to fill all the iterations, they know when they are done.
                                    
                                    
  
                                    
                                    
                                    To help author a requirement goal please consider the following template.
                                    
                                    
  
                                    
                                    
                                    <TABLE class="MsoNormalTable" cellSpacing="0" cellPadding="0" border="1">
                                      <br /> <br /> 
                                      
                                      <TR>
                                        <br /> 
                                        
                                        <TD class="" vAlign="bottom" width="576">
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <B><SPAN>Requirement Goal</SPAN></B>
                                          </P>
                                        </TD>
                                      </TR>
                                      
                                      <br /> 
                                      
                                      <TR>
                                        <br /> 
                                        
                                        <TD class="" vAlign="top" width="576">
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <A class="" title="_Toc70846610" name="_Toc70846610"></A><SPAN>Date<SPAN>&nbsp; </SPAN><B>{Insert Date}</B></SPAN>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <SPAN><SPAN>Desired Implementation Date <B>{Insert Date}</B></SPAN></SPAN>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <SPAN><SPAN>Business Analyst <B>{Business analyst name}</B></SPAN></SPAN>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <SPAN><SPAN>Executive Sponsorship <B>{Executive name and title}</B></SPAN></SPAN>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <SPAN><SPAN>&nbsp;</SPAN></SPAN>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <SPAN><B><SPAN>Goals</SPAN></B></SPAN>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <SPAN><B><I><SPAN>{User role}</SPAN></I></B><SPAN> would like <B>{feature(s)},</B> this <B>{feature}</B> should be able to <B>{action},</B> when implementing this <B>{action} </B>please check <B>{criteria}</B></SPAN></SPAN>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <SPAN><SPAN>&nbsp;</SPAN></SPAN>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <SPAN><B><SPAN>Benefit</SPAN></B></SPAN>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <SPAN><SPAN>By implementing this <B>{feature} </B>the business will be able to {<B>introduce business value}</B></SPAN></SPAN>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <SPAN><SPAN>&nbsp;</SPAN></SPAN>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <SPAN><B><SPAN>Detriment</SPAN></B></SPAN>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <SPAN><SPAN>If we fail to implement <B>{feature}</B> the business will <B>{introduce risk of failure to implement}</B></SPAN></SPAN><SPAN></SPAN>
                                          </P>
                                        </TD>
                                      </TR>
                                      
                                      <br /> 
                                      
                                      <TR>
                                        <br /> 
                                        
                                        <TD class="" vAlign="top" width="576">
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <B><SPAN>Example:</SPAN></B>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <I><SPAN>Date<B> 01/01/2007<BR /></B>Desired Implementation Date<B> 04/01/2007<BR /></B>Business Analyst<B> Susie Que<BR /></B>Executive Sponsorship<B> Jack Marshal Regional Director</B></SPAN></I>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <B><I><SPAN>Goals</SPAN></I></B><I><SPAN>:</SPAN></I>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <I><SPAN>The user would like to log into the ATM by first swiping their personal ATM card issued from the branch office and then key in a 4 digit PIN.<SPAN>&nbsp; </SPAN>When the user creates their pin we have to make certain that their pin does not match the last 4 digits of their SSN that we have in the system.</SPAN></I>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <I><SPAN>After the user logs into the ATM they should be presented with a home screen that displays a welcome message and their name.<SPAN>&nbsp; </SPAN>The client should then be able to see a menu list with the following options.</SPAN></I>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="style1">
                                            <SPAN><SPAN>•<SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><I><SPAN>Balance Inquiry</SPAN></I>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="style1">
                                            <SPAN><SPAN>•<SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><I><SPAN>Withdrawal </SPAN></I>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="style2">
                                            <SPAN><SPAN>•<SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><I><SPAN>Transfer</SPAN></I>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <B><I><SPAN>Benefit</SPAN></I></B><I><SPAN>:<BR />By implement ATM machines in our branches our company will be able to offer a competitive advantage over our competitors.</SPAN></I>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <B><I><SPAN>Detriment</SPAN></I></B><I><SPAN>:</SPAN></I>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <P class="MsoNormal">
                                            <I><SPAN>If we fail to implement ATM machines in our branches our company will be forced to stay open till 10 PM increasing resource cost by 35% nationwide.</SPAN></I>
                                          </P>
                                          
                                          <br /> 
                                          
                                          <H1>
                                            <SPAN>&nbsp;</SPAN>
                                          </H1>
                                        </TD>
                                      </TR>
                                    </TABLE>
                                    
                                    
  
                                    
                                    
                                    ##### <A>Responsible Ownership</A>
                                    
                                    
  
                                    
                                    
                                    The **Business Analysts** are responsible for authoring of a Requirement goal. If you refer to the field request section of this document you will notice that a field request does not always have a sufficient amount of detail to author a requirement goal. The business analyst will sometimes have to perform additional analysis to work toward drafting a more thorough requirement.
                                    
                                    
  
                                    
                                    
                                    > NOTE: The goal of the requirement goal is just that to convey a purpose. At no time should the requirement goal be treated as a concrete contract between ILS and the business. It is merely serves as a medium to convey information that helps in the creation of feature cards later in the process. During the feature card creation additional details may be uncovered that will require the business analyst to update the requirement goal. 
  
                                    
                                    
                                    #### <A>What is a Feature Card</A>
                                    
                                    
  
                                    
                                    
                                    Discussion is critical to understanding, which in turn is critical to estimating. Features cards are used to identify and define features at a high level. Feature cards act as concords between product owners and project team members to discuss (and document, to the extent necessary) detail elemental data that can be later formulated into stories that are subsequently scheduled into iterations. Feature cards identify features that the product owner would desire to have in the product.
                                    
                                    
  
                                    
                                    
                                    The purpose of feature cards is to provide a simple medium for gathering basic information about application or system specific features being requested from the business goals. This channel is intended to be a central conduit for all ILS activities to revolve around.
                                    
                                    
  
                                    
                                    
                                    Feature cards are comprised of the following key items of information:
                                    
                                    
  
                                    
                                    
                                    ##### <A>Key Items</A>
                                    
                                    
  
                                    
                                    
                                    
  
                                    
                                    
                                      * **Identifier**: an alphanumeric or numeric identifier that serves as a unique identifier for the feature.
  
                                          * **Name**: a short name or description of the feature
  
                                              * **Summary**: a paragraph or two describing high level functionality and modules that may comprise this feature
  
                                                  * **Type**: C = customer domain, T = technology domain
  
                                                    
  
                                                    
                                                    
                                                      * Customer domain – The customer domain are features that originate from the product owners of the project usually governed by more formal requirement documents.
  
                                                          * Technology domain – The technology domain are features that originate from the development group or systems analyst within the ILS department.</UL>
                                                        
  
                                                          * **Estimated work effort**: Aggregate of the following factors
  
                                                            
  
                                                            
                                                            
                                                              * Estimated work effort for requirements gathering
  
                                                                  * Estimated work effort for wire frame design
  
                                                                      * Estimated work effort for coding and unit testing
  
                                                                          * Estimated work effort for testing
  
                                                                              * Estimated work effort for documentation
  
                                                                                  * Estimated work effort for reporting</UL>
                                                                                
  
                                                                                  * **Planning Complexity:** This is a weighted measurement to determine the resource allocation and duration that the feature will require during a planning week.
  
                                                                                    
  
                                                                                    
                                                                                    
                                                                                      * **_High_** – 8 hours of planning time. One entire day is needed to break down the feature into a model and relative stories.
  
                                                                                          * **_Medium_** – 4 hours of planning time. Half a day is needed to break down the feature into a model and relative stories.
  
                                                                                              * **_Low_** – 2 hours of planning time. </UL>
                                                                                            
  
                                                                                              * **Requirements uncertainty (erratic, variable, regular, stable)**: an “exploration factor” for a specific feature. The requirements uncertainty is a subjective weight that is explored by both the Systems and Business Analyst to determine the viability of the feature being presented during a release planning session. The matrix below details the guidelines that can be used to determine the maturity of requirement being requested.</UL>
                                                                                            
  
                                                                                            **Requirement Uncertainty Guidelines**
                                                                                            
                                                                                            
  
                                                                                            **Erratic**
                                                                                            
                                                                                            
  
                                                                                            
  
                                                                                            
                                                                                            
                                                                                              * The requirement contains minimal information and the contents remain in an erratic state where business owners and field stakeholder cannot agree on the concept or idea that is being presented.****
  
                                                                                                  * Executive sponsorship has not been approved****</UL>
                                                                                                
  
                                                                                                **Variable**
                                                                                                
                                                                                                
  
                                                                                                
  
                                                                                                
                                                                                                
                                                                                                  * The requirements contain more information than the erratic state ****
  
                                                                                                      * There may still be outstanding variables that are still in question as to how the requirement should function when integrated into the system.****
  
                                                                                                          * A screen skeleton has been presented (if applicable)****
  
                                                                                                              * Executive sponsorship has not been approved****</UL>
                                                                                                            
  
                                                                                                            **Regular** (can be scheduled during a release planning week)
                                                                                                            
                                                                                                            
  
                                                                                                            
  
                                                                                                            
                                                                                                            
                                                                                                              * The requirements may contain more information than the variable state****
  
                                                                                                                  * The general requirement concept or idea is understood and can be talked to in a group setting to finalize greater details****
  
                                                                                                                      * A screen skeleton has been presented and general concepts annotated (If applicable)****
  
                                                                                                                          * Executive sponsorship has been approved****</UL>
                                                                                                                        
  
                                                                                                                        **Stable** (can be scheduled during a release planning week)
                                                                                                                        
                                                                                                                        
  
                                                                                                                        
  
                                                                                                                        
                                                                                                                        
                                                                                                                          * The requirements have been completely documented****
  
                                                                                                                              * All ideas and concepts are thoroughly understood and can be easily communicated in a written and verbal medium****
  
                                                                                                                                  * The screen skeleton has evolved to a more thoroughly documented wire frame that explicit details or references business rules****
  
                                                                                                                                      * Executive sponsorship has been approved****</UL>
                                                                                                                                    
  
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                      * Dependencies: A list of other external dependencies that could influence implementation sequencing.
                                                                                                                                    
  
                                                                                                                                    > NOTE: You should strive to get the feature to a state where it can exist on its own without having a dependency on other features. Dependency on other features should be an exception a not a rule. 
  
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                      * User Acceptance Tests: Criteria the product owner will use to accept or reject the feature
                                                                                                                                    
  
                                                                                                                                    > NOTE: It is important not to confuse feature cards with stories. The details captured in the feature cards serve as a launching pad for future planning sessions that uncover customer stories that can be instituted into release iterations. The feature cards form a conduit for all information to flow through and are weighted against the Requirement Goal. 
  
                                                                                                                                    #### <A>Acceptance Test</A>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    A features behavior is simply its acceptance criteria – if the system fulfills all the acceptance criteria, it’s behaving correctly; if it doesn’t, it isn’t.
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    Describe the acceptance criterion in terms of scenarios, which take the following form:&nbsp; [Influenced by Dan North](http://dannorth.net/introducing-bdd)
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      <B><I>Given</I></B> some initial context (the givens),<BR /><B><I>When</I></B> an event occurs,<BR /><B><I>Then</I></B> ensure some outcomes.<BR /><B>This is a</B> (Positive, Negative, Dimensional) <B>aspect</B>.
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    The aspect of the acceptance test helps to discern the overall test coverage that the feature has. It is important to touch on at least two different aspects for every feature.
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    To illustrate, let’s use the classic example of an ATM machine. One of the requirement goals might look like this:
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      Customer withdraws cash
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      As a customer,
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      I want to withdraw cash from an ATM,
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      so that I don’t have to wait in line at the bank.
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    So how do we know when we have delivered this feature? There are several scenarios to consider: the account may be in credit, the account may be overdrawn but within the overdraft limit, the account may be overdrawn beyond the overdraft limit. Of course, there will be other scenarios, such as if the account is in credit but this withdrawal makes it overdrawn, or if the dispenser has insufficient cash.
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    Using the given-when-then template, the first two scenarios might look like this:
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      <B>Scenario 1</B>: Account is in credit
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      <B><I>Given</I></B> the account is in credit
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      <B><I>And</I></B> the card is valid
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      <B><I>And</I></B> the dispenser contains cash
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      <B><I>When</I></B> the customer requests cash
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      <B><I>Then</I></B> ensure the account is debited
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      <B><I>And</I></B> ensure cash is dispensed
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      <B><I>And</I></B> ensure the card is returned
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      <B><I>This is a </I></B>positive <B><I>aspect</I></B>
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    > Notice the use of “and” to connect multiple givens or multiple outcomes in a natural way. 
  
                                                                                                                                    <P class="style3">
                                                                                                                                      <B>Scenario 2:</B> Account is overdrawn past the overdraft limit
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      <B>Given</B> the account is overdrawn
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      <B>And</B> the card is valid
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      <B>When</B> the customer requests cash
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      <B>Then</B> ensure a rejection message is displayed
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      <B>And</B> ensure cash is not dispensed
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      <B>And</B> ensure the card is returned
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="style3">
                                                                                                                                      <B><I>This is a </I></B>negative <B><I>aspect</I></B>
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    Both scenarios are based on the same event and even have some givens and outcomes in common. We want to capitalize on this by reusing givens, events, and outcomes.
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    The following is an example of a feature card based on the previous requirement goal.
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <TABLE class="style4" cellSpacing="0" cellPadding="0" border="1">
                                                                                                                                      <br /> <br /> 
                                                                                                                                      
                                                                                                                                      <TR>
                                                                                                                                        <br /> 
                                                                                                                                        
                                                                                                                                        <TD class="" vAlign="top" width="638">
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            Requirement Goal
                                                                                                                                          </P>
                                                                                                                                        </TD>
                                                                                                                                      </TR>
                                                                                                                                      
                                                                                                                                      <br /> 
                                                                                                                                      
                                                                                                                                      <TR>
                                                                                                                                        <br /> 
                                                                                                                                        
                                                                                                                                        <TD class="" vAlign="top" width="638">
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>Example:</SPAN></B>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <I><SPAN>Date<B> 01/01/2007<BR /></B>Desired Implementation Date<B> 04/01/2007<BR /></B>Business Analyst<B> Susie Que<BR /></B>Executive Sponsorship<B> Jack Marshal, Regional Director</B></SPAN></I>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>Goals</SPAN></I></B><I><SPAN>:</SPAN></I>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <I><SPAN>The user would like to log into the ATM by first swiping their personal ATM card issued from the branch office and then key in a 4 digit PIN.<SPAN>&nbsp; </SPAN>When the user creates their pin we have to make certain that their pin does not match the last 4 digits of their SSN that we have in the system.<SPAN>&nbsp; </SPAN>If the PIN does not match then store the PIN in the system and associate it with the ATM card.<SPAN>&nbsp; </SPAN>If it does match then display an error message with the following text “You may not use a PIN that matches the last 4 numbers of your social security number&#8221;</SPAN></I>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <I><SPAN>&nbsp;</SPAN></I>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <I><SPAN>After the user logs into the ATM they should be presented with a home screen that displays a welcome message and their name.<SPAN>&nbsp; </SPAN>The client should then be able to see a menu list with the following options.</SPAN></I>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="style1">
                                                                                                                                            <SPAN><SPAN>•<SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><I><SPAN>Balance Inquiry</SPAN></I>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="style1">
                                                                                                                                            <SPAN><SPAN>•<SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><I><SPAN>Withdrawal </SPAN></I>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="style2">
                                                                                                                                            <SPAN><SPAN>•<SPAN>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></SPAN></SPAN><I><SPAN>Transfer</SPAN></I>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>&nbsp;</SPAN></I></B>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>Benefit</SPAN></I></B><I><SPAN>:<BR />By implement ATM machines in our branches our company will be able to offer a competitive advantage over our competitors.</SPAN></I>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>Detriment</SPAN></I></B><I><SPAN>:</SPAN></I>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <I><SPAN>If we fail to implement ATM machines in our branches our company will be forced to stay open till 10 PM increasing resource cost by 35% nationwide.</SPAN></I>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            &nbsp;
                                                                                                                                          </P>
                                                                                                                                        </TD>
                                                                                                                                      </TR>
                                                                                                                                    </TABLE>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <P class="MsoNormal">
                                                                                                                                      <BR />
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    <TABLE class="style4" cellSpacing="0" cellPadding="0" border="1">
                                                                                                                                      <br /> <br /> 
                                                                                                                                      
                                                                                                                                      <TR>
                                                                                                                                        <br /> 
                                                                                                                                        
                                                                                                                                        <TD class="" vAlign="top" width="638">
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            Feature Card
                                                                                                                                          </P>
                                                                                                                                        </TD>
                                                                                                                                      </TR>
                                                                                                                                      
                                                                                                                                      <br /> 
                                                                                                                                      
                                                                                                                                      <TR>
                                                                                                                                        <br /> 
                                                                                                                                        
                                                                                                                                        <TD class="" vAlign="top" width="638">
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>Card No</SPAN></B><SPAN>: 052205</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>Name</SPAN></B><SPAN>: Branch 4 Digit PIN number creation</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>Summary</SPAN></B><SPAN>: The client will create a 4 digit pin number in the branch.</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>Type</SPAN></B><SPAN>: Customer</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>Requirements Uncertainty (erratic, variable, regular, stable)</SPAN></B><SPAN>: Regular</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>Dependencies</SPAN></B><SPAN>: None</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>User Acceptance Tests</SPAN></B><SPAN>:</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <SPAN>&nbsp;</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>Given </SPAN></I></B><SPAN>that the client is creating a 4 digit PIN number </SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>When</SPAN></I></B><SPAN> the client has keyed in a 4 digit pin that does not match the last 4 digits of their SSN</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>Then</SPAN></I></B><SPAN> the PIN is stored in the clients account profile.</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>This is a </SPAN></I></B><I><SPAN>Positive aspect</SPAN></I>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <SPAN>&nbsp;</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>Given </SPAN></I></B><SPAN>that the client is creating a 4 digit PIN number </SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>When</SPAN></I></B><SPAN> the client has keyed in a 4 digit pin that does match the last 4 digits of their SSN</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>Then</SPAN></I></B><SPAN> the client is presented with an error containing the text “</SPAN><I><SPAN>You may not use a PIN that matches the last 4 numbers of your social security number”</SPAN></I><SPAN>.</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>This is a </SPAN></I></B><I><SPAN>Negative aspect</SPAN></I>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            &nbsp;
                                                                                                                                          </P>
                                                                                                                                        </TD>
                                                                                                                                      </TR>
                                                                                                                                    </TABLE>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    &nbsp;
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    <TABLE class="style4" cellSpacing="0" cellPadding="0" border="1">
                                                                                                                                      <br /> <br /> 
                                                                                                                                      
                                                                                                                                      <TR>
                                                                                                                                        <br /> 
                                                                                                                                        
                                                                                                                                        <TD class="" vAlign="top" width="638">
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            Feature Card
                                                                                                                                          </P>
                                                                                                                                        </TD>
                                                                                                                                      </TR>
                                                                                                                                      
                                                                                                                                      <br /> 
                                                                                                                                      
                                                                                                                                      <TR>
                                                                                                                                        <br /> 
                                                                                                                                        
                                                                                                                                        <TD class="" vAlign="top" width="638">
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>Card No</SPAN></B><SPAN>: 052206</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>Name</SPAN></B><SPAN>: Welcome Screen</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>Summary</SPAN></B><SPAN>: After the user is authenticated to the system they should be presented with a welcome screen </SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>Type</SPAN></B><SPAN>: Customer</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>Requirements Uncertainty (erratic, variable, regular, stable)</SPAN></B><SPAN>: Regular</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>Dependencies</SPAN></B><SPAN>: 052207</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>User Acceptance Tests</SPAN></B><SPAN>:</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>&nbsp;</SPAN></I></B>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>Given </SPAN></I></B><SPAN>the user has just left the login screen </SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>And </SPAN></I></B><SPAN>they are authenticated</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>When</SPAN></I></B><SPAN> the welcome screen is presented</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>Then</SPAN></I></B><SPAN> <SPAN>&nbsp;</SPAN>the welcome message on the screen should be presented </SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>And</SPAN></I></B><SPAN> the user’s full name be presented in the following format {first name} {mi} {last name}</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>And </SPAN></I></B><SPAN>a menu list be displayed with the following options: Balance Inquiry, Withdrawal, Transfer</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>This is a </SPAN></I></B><I><SPAN>Positive aspect</SPAN></I>
                                                                                                                                          </P>
                                                                                                                                        </TD>
                                                                                                                                      </TR>
                                                                                                                                    </TABLE>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    <P class="MsoNormal">
                                                                                                                                      <BR />
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    <TABLE class="style4" cellSpacing="0" cellPadding="0" border="1">
                                                                                                                                      <br /> <br /> 
                                                                                                                                      
                                                                                                                                      <TR>
                                                                                                                                        <br /> 
                                                                                                                                        
                                                                                                                                        <TD class="" vAlign="top" width="638">
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            Feature Card
                                                                                                                                          </P>
                                                                                                                                        </TD>
                                                                                                                                      </TR>
                                                                                                                                      
                                                                                                                                      <br /> 
                                                                                                                                      
                                                                                                                                      <TR>
                                                                                                                                        <br /> 
                                                                                                                                        
                                                                                                                                        <TD class="" vAlign="top" width="638">
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>Card No</SPAN></B><SPAN>: 052207</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>Name</SPAN></B><SPAN>: Login Screen</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>Summary</SPAN></B><SPAN>: The client would like to log into the system using a login screen </SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>Type</SPAN></B><SPAN>: Customer</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>Requirements Uncertainty (erratic, variable, regular, stable)</SPAN></B><SPAN>: Regular</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>Dependencies</SPAN></B><SPAN>: 052205</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><SPAN>User Acceptance Tests</SPAN></B><SPAN>:</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            &nbsp;
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>Given </SPAN></I></B><SPAN>the user trying to log into the ATM</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>When</SPAN></I></B><SPAN> the user swipes his ATM card</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>And </SPAN></I></B><SPAN>the user inputs the correct PIN</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>Then</SPAN></I></B><SPAN> <SPAN>&nbsp;</SPAN>the system should log the time the user logged in </SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>And </SPAN></I></B><SPAN>the screen should go to the welcome screen</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>This is a </SPAN></I></B><I><SPAN>Positive aspect</SPAN></I>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            &nbsp;
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>Given </SPAN></I></B><SPAN>the user trying to log into the ATM</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>When</SPAN></I></B><SPAN> the user swipes his ATM card</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>And </SPAN></I></B><SPAN>the user inputs the incorrect PIN</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>Then</SPAN></I></B><SPAN> <SPAN>&nbsp;</SPAN>the login screen should display the following message “The PIN is incorrect, please try again”</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>This is a </SPAN></I></B><I><SPAN>Negative aspect</SPAN></I>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            &nbsp;
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>Given </SPAN></I></B><SPAN>the user trying to log into the ATM</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>When</SPAN></I></B><SPAN> the user swipes his ATM card incorrectly for the 3<SUP>rd</SUP> time</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>Then</SPAN></I></B><SPAN> <SPAN>&nbsp;</SPAN>the login screen should display the following message “Your card is no longer active, please call 1800-555-5555”</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>And </SPAN></I></B><SPAN>the system should lock the account ATM privileges</SPAN>
                                                                                                                                          </P>
                                                                                                                                          
                                                                                                                                          <br /> 
                                                                                                                                          
                                                                                                                                          <P class="MsoNormal">
                                                                                                                                            <B><I><SPAN>This is a </SPAN></I></B><I><SPAN>Dimensional aspect</SPAN></I>
                                                                                                                                          </P>
                                                                                                                                        </TD>
                                                                                                                                      </TR>
                                                                                                                                    </TABLE>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    <P class="MsoNormal">
                                                                                                                                      &nbsp;
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    ##### <A>Responsible Ownership</A>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    The **Systems Analysts** are responsible for authoring of a Feature cards. While the systems analysts are responsible for authoring the feature this engagement must not be done in vacuum. It is critical that the documentation of the feature be agreed upon by business and all other stakeholders. Remember all artifacts in the ILS software development lifecycle are living documents and are subject to change at any time pending the appropriate stakeholders all agree on the changes.
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    #### <A>What is a Screen Skeleton</A>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    Sometimes requirement goals may not capture the idea or concept that the business is trying to convey. Often a simpler medium of communication may be a sketch, diagram or picture. Pictures often speak volumes of information over written text. It is imperative that everyone understand that these forms of communication are acceptable at conveying an idea. Often the greatest ideas are thought of over lunch and quickly jotted down on a napkin. Let’s not limit creativity or the medium that it is conveyed in.
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    The purpose of screen skeletons is to provide a simple pictorial representation of the intended layout of how the requirement goal should take form as a graphical user interface. The screen skeleton will later be used as that foundation for the more detailed wire frame that is the result of a planning week.
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    This is a rather crude example of a screen skeleton but shows to reason what can be used as a screen skeleton.
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    {Figure 4: Screen Skeleton }
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    ##### <A>Responsible Ownership</A>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    The **Business Analysts** are responsible for the creation of the screen skeletons.
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    > NOTE: The screen skeletons are one of the optional artifacts of the ASDLC. They are not required in order to call a requirement goal complete. 
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    #### <A>What is the Planning Preparation Meeting</A>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    The final activity of the storming phase is preparing for the planning phase. To facilitate this goal the planning preparation meeting takes place.
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    This meeting is designed to be a collaborative engagement between the business analyst, systems analyst and development architects. The planning preparation meeting results in a schedule of events for the planning phase. This schedule will contain modeling session engagement and resources that have been assigned to each session.
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    Each feature card contains a “planning complexity” rating. This rating of High, Medium or Low are used determine the amount of time that will be required to adequately model and understand the business feature.
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    The figure below depicts a simple illustration of a planning meeting. A typical modeling team consists of five stake holders: one Modeler, one business analysts, one systems analyst and two developers. Utilizing everything we have done with the feature cards during the storming phase we will now use the planning complexity rating in conjunction with the dependency field to determine how we should plan the week.
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    Considering that the “Branch 4 digit PIN # creation” feature as at the top of the dependency tree it make logical sense to start with this feature first. You will notice that the planning complexity rating is a HIGH for this feature. This is a quick indication that the probability of this story lasting all day is great. Therefore we should not schedule any other features for this modeling team for the remainder of that day. The “Login Screen” and “Welcome Screen” planning complexity rating are MEDIUM. Since the medium rating tells us that this modeling session should last know longer than four hours, we can easily place both these stories into the next day and lower the risk of over taxing the modeling team.
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    <P align="center">
                                                                                                                                      <IMG src="http://blog.agilejoe.com/content/binary/PlanningMeeting.jpg" border="0" />
                                                                                                                                    </P>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    ##### <A>Responsible Ownership</A>
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    The **Business Analysts** are responsible for the final schedule of the Planning Phase. The **Systems Analyst** are responsible for scheduling the Planning preparation meeting. 
                                                                                                                                    
                                                                                                                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    The next post will be on the Planning Phase.