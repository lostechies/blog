---
wordpress_id: 11
title: Notes on defects
date: 2007-04-24T13:03:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/04/24/notes-on-defects.aspx
dsq_thread_id:
  - "265532396"
categories:
  - Misc
redirect_from: "/blogs/jimmy_bogard/archive/2007/04/24/notes-on-defects.aspx/"
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/notes-on-defects.html)._

Right now I&#8217;m working on defects for one version of a project, and soon to be starting development on the next version. Whenever I start work on defects, I always take a quick read from the [Software Defect Reduction Top 10 List.](http://www.cebase.org/www/resources/reports/usc/usccse2001-515.pdf) It was published a few years back by the [Center of Empirically Based Software Engineering](http://www.cebase.org/www/home/index.htm) from a grant from the National Science Foundation. The list is a summary of the top 10 techniques to help reduce flaws in code, based on empirical data gathered from a variety of sources. The paper is a quick read, only three pages, and there are some other interesting research papers on agile development and pair programming on the [CeBASE website](http://www.cebase.org/www/home/index.htm). Here&#8217;s the list:

  1. Finding and fixing a software problem after delivery is often 100 times more expensive than finding and fixing it during the requirements and design phase. 
      * About 40-50% of the effort on current software projects is spent on avoidable rework. 
          * About 80% of the avoidable rework comes from 20% of the defects. 
              * About 80% of the defects come from 20% of the modules and about half the modules are defect free. 
                  * About 90% of the downtime comes from at most 10% of the defects. 
                      * Peer reviews catch 60% of the defects. 
                          * Perspective-based reviews catch 35% more defects than non-directed reviews. 
                              * Disciplined personal practices can reduce defect introduction rates by up to 75%. 
                                  * All other things being equal, it costs 50% more per source instruction to develop high-dependability software products than to develop low-dependability software products. However, the investment is more than worth it if significant operations and maintenance costs are involved. 
                                      * It also notes that a typical life cycle cost is about 30% development and 70% maintenance.
                                      * About 40-50% of user programs enter use with nontrivial defects.</ol> 
                                    These numbers didn&#8217;t make a lot of sense to me until I worked on my first large-scale, many month project. When I noticed how much time I was spending fixing defects rather than delivering business value, I started taking this paper more seriously. The main points I was able to take out of the paper were:
                                    
                                      * Defects are expensive to fix 
                                          * Peer review and sound engineering practices can greatly reduce the number of defects 
                                              * Maintainability should be a top, if not _the_ top concern during development</ul> 
                                            Has anyone else run into these same types of numbers on projects?