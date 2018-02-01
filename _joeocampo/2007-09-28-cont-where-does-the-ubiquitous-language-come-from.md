---
id: 65
title: 'Cont: Where does the Ubiquitous Language come from?'
date: 2007-09-28T06:08:00+00:00
author: Joe Ocampo
layout: post
guid: /blogs/joe_ocampo/archive/2007/09/28/cont-where-does-the-ubiquitous-language-come-from.aspx
dsq_thread_id:
  - "262089845"
categories:
  - Domain Driven Design (DDD)
---
[<img src="http://lostechies.com/joeocampo/files/2011/03ContWheredoestheUbiquitousLanguagecomefr_1E31/legos_thumb.jpg" style="border: 0px none;margin: 10px" alt="legos" align="right" border="0" height="167" width="240" />](http://lostechies.com/joeocampo/files/2011/03ContWheredoestheUbiquitousLanguagecomefr_1E31/legos_2.jpg) This is a follow up post to a question <a href="http://codebetter.com/blogs/scott.bellware/archive/2007/09/25/168685.aspx" target="_blank">Scott Bellware</a> asked me concerning origins of the Ubiquitous Language. To save you time with having to go back an forth between the post this was my response.

> _&#8220;We practice a hybrid approach to the planning phase which introduces another layer above the story.&nbsp; Cohn refers to this as an epic; we have elected to use the term Feature._

> _The interesting aspect to all this is that the product owner(s), in our case 8 Business analyst all ask for varying features some even overlap at times.&nbsp; The modeling teams which consist of a one BA, Modeler(developer), Developer, and QA all get together to model the feature from a high level.&nbsp; It is a wonderful exercise as the team practices DDD modeling with everyone involved.&nbsp; Spoken and written ideas form a HIGH LEVEL domain model.&nbsp; Don&#8217;t confuse our modeling with UML.&nbsp;_ 
> 
> _So we have a feature originating ubiquitous constructs a model that then refines those constructs into additional stories that can be prioritized in a backlog.&nbsp; All the while cultivating the &#8220;ubiquitous language&#8221;.&nbsp; At the end of the day the developers all get together and present their models to the development team.&nbsp; We distill the models to insure that other modeling teams are not coming up with the same ubiquitous terms and refine/clarify if needed.&nbsp; If their are any major changes we reengage the business with QA._
> 
> _Why did I give everyone all this detail.&nbsp; Because &#8220;it depends&#8221; on how your process originates terms that form the ubiquitous language.&nbsp; Even though the terms may have existed far beyond any developer showing up, the terms are galvanized when people talks towards them in the hope of producing better software.&#8221;_

And Scott Responded with:

> _&#8220;Good points, Joe._

> _My follow-up observation then is to your specific process.&nbsp; Or rather, it&#8217;s a question (or two):_
> 
> _What are the benefits to eschewing story practices as the initiation of the process and going with agile modeling?&#8221;_

This is a very good question that Scott has asked but you need to know some background before I answer it.

#### Background

Our team started with XP around 4 years ago.&nbsp; At first there was allot of resistance towards Agile in general.&nbsp; It was too esoteric in nature for anyone to even trust or try.&nbsp; Everyone was frustrated Developers, Business Analyst and Systems Analyst all where ready to give up.&nbsp; There were several attempts to return to a traditional methodology but several members of the team stood fast and helped the department at least TRY Agile.

As the team moved forward with developing systems for the business they learned to embrace Story cards but only to a certain extant.&nbsp; Design documents were still drafted and accompanied the story cards.&nbsp; This is a very bad thing!&nbsp; Once a design document appears it is gospel and dialog ceases to flow.&nbsp; It become very one sided and the discussion flows like this, &#8220;Make it work this way!&#8221;&nbsp; The birth of entropy!&nbsp; Time passed and we were able to convince them to discuss the stories with us prior to looking at design document.&nbsp; There was a dialog that was forming but it wasn&#8217;t ubiquitous.&nbsp; In fact we discovered that even amongst the domain experts they had several terms for the same artifact!&nbsp; Half of the country would call it one term while the other would call it another.&nbsp; Another aspect that was suffering were acceptance tests.&nbsp; The quality group didn&#8217;t have enough information gathered during the planning sessions to write effective acceptance test.&nbsp; We were practicing Agile but we were just getting by.&nbsp; Sure we were creating working software every 6 weeks and quality was at an all time high but understanding of the Domain outside of the business and amongst the business was slowing deteriorating.&nbsp; The system was getting so large that the business was stepping on each other.

At this point our solution was at about 300K lines of code and approximately 2500 unit tests.&nbsp; Pretty large.&nbsp; What happened next is what really tested our team and Agile.

We were given a new project that would extend and double the functionality of the current system.&nbsp; To make things worse this project was date driven! We only had 9 months to complete it.&nbsp; Based on the enormity of the project the team size practically tripled over night.&nbsp; We had 12 business analyst 3 of which were remote.&nbsp; We had a team of 7 quality technicians and 16 developers!&nbsp; 

Don&#8217;t forget we still had existing communication issues with what we were doing and this new effort only compounded that.&nbsp; We had to do something to streamline the communication and cultivate the design of the new system.&nbsp; Enter <a href="http://www.lostechies.com/blogs/joe_ocampo/archive/2007/04/02/a-discussion-on-domain-driven-design.aspx" target="_blank">Domain Driven Design</a>. 

We decided that if we were going to do this we needed a mechanism to flush the domain concepts out on the table and put the issues out there for everyone to see but we had to make sure it happened BEFORE we touched the code.&nbsp; Having read Domain Driven Design twice by this point, I decided to train not only the development team but the business and quality group as well on the activities.&nbsp; What happened next was simply amazing!

#### Storming

Before a release the team gets together with the business to discuss what &#8220;Features&#8221; the business is desiring.&nbsp; After the business gives us a summary of the functionality we give each Feature a weight of High, Medium or Low.&nbsp; What this signifies is an approximation of how long it will take to model each feature.&nbsp; A &#8220;high&#8221; is 8 hours, a &#8220;medium&#8221; is 4 hours and a &#8220;low&#8221; is 2 hours.

#### So what is a modeling session?

A modeling session consist of a Business Domain Expert, a developer , QA, and a developer who has the soft skills to lead a modeling session, we call this developer &#8220;the modeler.&#8221;&nbsp; 

It begins by asking the Domain Expert to talk about the features, establishing the bounded context.&nbsp; During the discussion the modeler is diagramming the model with colored note cards.&nbsp; Entities are green, Value Objects are yellow, services blue etc.&nbsp; The white cards typically notates the usage stereotypes of the model.&nbsp; During the discussion the group pays special attention to insure that the ubiquitous terms are being used.&nbsp; Because the dialog now has a tangible pictorial representation the team talks towards the model.&nbsp; Anyone can add a new Entity or change a behavior to help cultivate the &#8220;ubiquitous language&#8221;.&nbsp; Problematic business cases immediately come to fruition and are dealt with outside of writing code but not done in a vacuum as traditional UML is practiced today.&nbsp; The team has to pay additional focus in insuring that the modeling session stays within the features context.&nbsp; If there are any artifacts that spill outside of the context that are put in a parking lot box and reprioritized for later modeling sessions.

At the completion of the session the Modeler distills the model with the team into smaller stories that can exist on their own and deliver part of the feature.&nbsp; It is important that as the Stories are being created that the QA representative examine the model to look for all the acceptance test that are going to be needed to call this story done.&nbsp; If the QA representative can not figure out how to test it then it isn&#8217;t a story!&nbsp; 

What makes things complicated is that we have at any given point in time 4-5 modeling sessions happening concurrently.&nbsp; So what happens at the end of the day.

At the end of the day the modelers(developers) get together and compare their models.&nbsp; They go through them to find any duplicate concepts or issues that may arise as a result of blending certain models together.&nbsp; They take great care in using &#8220;Ubiquitous&#8221; terminology in expressing their models with one another.&nbsp; If an issue arises then both teams reengage (Dev, QA, BA) to figure out a solution.&nbsp; Usually it take a short time to refine both models so they play nice with one another.&nbsp; The awesome part is that everyone learns!&nbsp; The business understands their system much better and the developers have a greater understanding of what they are building as well.

Now that we have all the stories defined for the release, the <a href="http://www.lostechies.com/blogs/joe_ocampo/archive/2007/09/12/complexity-based-programming.aspx" target="_blank">traditional planning game commences with SWAGS</a> being given for how many points it is going to take to finish each story.&nbsp; A give and take occurs between the business and development team but the business has a better picture of how the &#8220;nice to have stories&#8221; fit in with the &#8220;must have stories&#8221; due to the modeling exercise.

**So how long is this modeling/planning phase?** Approximately a week.&nbsp; Releases look like this typically.

  * Storming Phase (1 Day)
  * Modeling/Planning Phase (Approximately a week)
  * Iteration A (One week long)
  * Iteration B (One week long)
  * Iteration C (One week long)
  * SIT (One week long)
  * UAT/Production (One week long)

**What do you do with the models after a release?&nbsp;** If you ask me this at work, I am going to tell you that we archive them for future reference and review them periodically to insure that are integrally sound.&nbsp; Outside of work.&nbsp; The are put in a file cabinet or on a shelf and we rarely go back to them.&nbsp; Usually if we have a&nbsp; new similar feature arise we model again to insure that &#8220;time&#8221; has not changed it intention or value.

**Why the hell did you give us so much detail to answer this question?** 

> _&#8220;What are the benefits to eschewing story practices as the initiation of the process and going with agile modeling?&#8221;_

Because (drum role) it depends!&nbsp; If you have a small shop and one to two domain experts on site then modeling may be over kill.&nbsp; Story cards should be all that you need to issue in discussion about the domain and still come up with a great design and a &#8220;ubiquitous language&#8221;.&nbsp; I gave you this detail to show you the evolution of the evaluation of circumstances that resulted in a domain modeling solution.&nbsp; As Agile practitioners you must think outside the box.&nbsp; Not one practice or methodology may make sense but don&#8217;t blame the methodology or the practice.&nbsp; Remember that &#8220;Agile&#8221; is an adjective not a noun.&nbsp; Be agile when you approach any software development issue.&nbsp; Use Agile development methodologies and **proven** agile software engineering practices as a chest of tools that help you to get your job done.&nbsp; Above all never be dogmatic, be agile.