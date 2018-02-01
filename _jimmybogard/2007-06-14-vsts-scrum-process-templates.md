---
id: 30
title: VSTS Scrum process templates
date: 2007-06-14T13:21:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/06/14/vsts-scrum-process-templates.aspx
dsq_thread_id:
  - "265978478"
categories:
  - Agile
  - VSTS
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/vsts-scrum-process-templates.html)._

There have&nbsp;been some rumblings around that some in my company&nbsp;might be interested in Scrum and Team System, so I thought I&#8217;d compile a list of Scrum process templates and some highlights (and lowlights).&nbsp; The three Scrum process templates I&#8217;ve found are:

  * [Scrum for Team System](http://www.scrumforteamsystem.com/en/default.aspx) 
      * [Microsoft eScrum](http://www.microsoft.com/downloads/details.aspx?FamilyID=55a4bde6-10a7-4c41-9938-f388c1ed15e9&displaylang=en) 
          * [VSTS Scrum Process Template](http://www.codeplex.com/VSTSScrum), via [CodePlex](http://www.codeplex.com/)</ul> 
        Each process template adds custom work items and reports&nbsp;related to Scrum, but they all have their quirks and niceties.
        
        ### Scrum for Team System
        
        This process template was originally released a year ago by a company called [Conchango](http://www.conchango.com).&nbsp; You can find this template on the Scrum for Team System website at [http://www.scrumforteamsystem.com/](http://www.scrumforteamsystem.com/ "http://www.scrumforteamsystem.com/").&nbsp; I&#8217;ve personally used this template for about 10 months covering about a&nbsp;dozen Sprints.
        
        #### Pros
        
          * Great website with thorough process guidance and free training videos 
              * Mature, with several updates to the template 
                  * All sprint artifacts present, with automatic rollup calculations 
                      * Good reports, including: 
                          * Sprint Burndown 
                              * Product Burndown 
                                  * Product Backlog Composition 
                                      * and about a dozen more</ul> 
                                      * Portal reports, a set of smaller reports designed for the project SharePoint portal 
                                          * Support through forums 
                                              * Widely adopted 
                                                  * Includes tool to update warehouse (critical for up-to-date reports, as Team System only updates the warehouse ever hour or so)</ul> 
                                                #### Cons
                                                
                                                  * All&nbsp;artifacts created and managed through Visual Studio, which not all team members may have 
                                                      * Reports have a lot of custom code, making them&nbsp;difficult to tweak 
                                                          * Does not plug in to the Areas and Iterations constructs already present in Team System 
                                                              * Only one active project per Team Project 
                                                                  * i.e., everyone in the same Team Project will use the same sprints, work items, etc. with no good way to partition them 
                                                                      * This forces every new team to have a new Team Project</ul> 
                                                                ### Microsoft eScrum
                                                                
                                                                This one was just released from Microsoft, and from the description, looks like it&#8217;s been used internally at Microsoft.&nbsp; I found this on a [post on Rob Caron&#8217;s blog](http://blogs.msdn.com/robcaron/archive/2007/06/12/3261753.aspx).&nbsp; That post links to a download on Microsoft&#8217;s downloads site [here](http://www.microsoft.com/downloads/details.aspx?FamilyID=55a4bde6-10a7-4c41-9938-f388c1ed15e9&displaylang=en).&nbsp; I should note that I tested all of these process templates using a [Team System VHD](http://www.microsoft.com/downloads/details.aspx?FamilyID=9D60655E-814C-40A8-9762-53A40D8E7B37&displaylang=en), so I didn&#8217;t have to get access to our corporate Team System server.
                                                                
                                                                #### Pros
                                                                
                                                                  * Fantastic web portal for managing sprints and sprint artifacts.&nbsp; It&#8217;s all Ajax-y too. 
                                                                      * Pages for managing daily sprints, reports, etc.
                                                                      * Context-sensitive help in web portal 
                                                                          * Dynamic capacity calculations in portal 
                                                                              * All sprint artifacts present 
                                                                                  * Ability to have multiple &#8220;Products&#8221; in one Team Project in source control, allowing multiple teams to use Scrum for one Team Project 
                                                                                      * Allows definitions of each role (Project Member, Product Owner, etc.) 
                                                                                          * Some better options on each work item type, such as categories 
                                                                                              * Integrates with Areas and Iterations 
                                                                                                  * Areas are Products 
                                                                                                      * Iterations are Sprints</ul> 
                                                                                                #### Cons
                                                                                                
                                                                                                  * New, released only on June 12 
                                                                                                      * No support through forums, or anywhere else online (Google only found 2 relevant pages) 
                                                                                                          * Painful setup, lots of manual steps 
                                                                                                              * Not as many reports (~half&nbsp;a dozen)</ul> 
                                                                                                            ### VSTS Scrum Process Template from CodePlex
                                                                                                            
                                                                                                            I also found this one on the [post on Rob Caron&#8217;s blog](http://blogs.msdn.com/robcaron/archive/2007/06/12/3261753.aspx).&nbsp; At the bottom of the post, it links to the [CodePlex project](http://www.codeplex.com/vstsscrum).&nbsp; This project was intended to improve on the Scrum for Team System process template by taking advantage of Areas and Iterations.&nbsp; It&#8217;s being developed by a handful of TFS MVP&#8217;s.
                                                                                                            
                                                                                                            #### Pros
                                                                                                            
                                                                                                              * Lightweight, fits in well with Areas and Iterations 
                                                                                                                  * Good list of reports, some of them quite different than the other templates 
                                                                                                                      * Unplanned work 
                                                                                                                          * Quality Indicators 
                                                                                                                              * Project Velocity 
                                                                                                                                  * Builds</ul> 
                                                                                                                                  * Supports basic Scrum/Agile work items (User Story, Backlog Item, etc.) 
                                                                                                                                      * Custom work item for reviews 
                                                                                                                                          * Open source, so it&#8217;s updated frequently</ul> 
                                                                                                                                        Cons
                                                                                                                                        
                                                                                                                                          * Open source, so don&#8217;t look for great support 
                                                                                                                                              * Still in beta 
                                                                                                                                                  * Not a lot of people using it 
                                                                                                                                                      * No project portal 
                                                                                                                                                          * No installer</ul> 
                                                                                                                                                        ### Summing it up
                                                                                                                                                        
                                                                                                                                                        The Conchango process template is by far the most mature, so I&#8217;d usually go with that one, but the awesome portal site and the integration into Areas and Iterations make the eScrum process template a compelling alternative.&nbsp; As for the CodePlex template, it looks promising, but I&#8217;ll reserve judgement until a final version is released.&nbsp; Doesn&#8217;t look ready for prime time quite yet.&nbsp; The great thing about process templates is that you can edit them after you create the Team Project.&nbsp; If there&#8217;s a report missing you want, it&#8217;s pretty easy to look at one of the other process templates and see what others are doing, and add whatever you need.