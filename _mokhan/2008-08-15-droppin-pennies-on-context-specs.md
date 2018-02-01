---
id: 4564
title: 'Droppin&#8217; Pennies on context specs&#8230;'
date: 2008-08-15T14:08:32+00:00
author: Mo Khan
layout: post
guid: /blogs/mokhan/archive/2008/08/15/droppin-pennies-on-context-specs.aspx
categories:
  - TDD
---
First off I want to make it clear that I&#8217;m not a guru on the topic, but I do find it interesting. The topic of course is Context Based Specifications. I&#8217;ve seen an emergence in interest in writing context based specifications lately on the blogosphere. However, everyone seems to be advertising it slightly differently&#8230; 

One of the things that our team tries to aim for is to keep technical language out of our specifications. They should be human readable sentences, not "Yoda" speak. This is crucial if we want non technical people to actually read our specs to make sure the code is inline with what the business is attempting to do. The goal, in our humble opinions, is to work closer towards the ubiquitous language. The benefit is that documentation is updated along with the code, because it is the code.

Something that reads..

when\_the\_account\_controller\_is\_given\_valid\_arguments\_on\_the\_register\_account\_action

Doesn&#8217;t read as easy as:

when\_registering\_a\_new\_account

Another subtle change that our team made was to put the specs above establishing the context. In some cases it just seem to read better from top to bottom.

when\_creating\_a\_new\_account\_for\_a\_user\_with\_a\_valid_submission

&#8211; it\_should\_inform\_the\_user\_that\_the\_account\_was_created

&#8211; it\_should\_save\_the\_new\_account\_information

under\_these\_conditions

because_of

"It" being the system under test.

We don&#8217;t always get it right, but by trying to drop the technical language we force ourselves to step away and think about the problem that we are ultimately trying to address.

Again&#8230; this is just <del>my</del> our 2 cents.