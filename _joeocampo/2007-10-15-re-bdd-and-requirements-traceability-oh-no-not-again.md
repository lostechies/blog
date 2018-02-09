---
wordpress_id: 76
title: 'RE: BDD and Requirements Traceability &#8211; Oh No, Not Again'
date: 2007-10-15T04:02:00+00:00
author: Joe Ocampo
layout: post
wordpress_guid: /blogs/joe_ocampo/archive/2007/10/15/re-bdd-and-requirements-traceability-oh-no-not-again.aspx
dsq_thread_id:
  - "262089722"
categories:
  - 'Agile Project Coaching &amp; Management'
  - BDD (Behavior Driven Development)
  - Tools
redirect_from: "/blogs/joe_ocampo/archive/2007/10/15/re-bdd-and-requirements-traceability-oh-no-not-again.aspx/"
---
This is a response to <a href="http://codebetter.com/blogs/scott.bellware/default.aspx" target="_blank">Scott Bellware’s</a> recent post on “**<a href="http://codebetter.com/blogs/scott.bellware/archive/2007/10/14/169723.aspx" target="_blank">BDD and Requirements Traceability &#8211; Oh No, Not Again”</a>**

> It is true that we are inevitably doomed to repeat our past mistakes if subsequent generations are unaware of the travails of its previous generation, and requirements traceability is one form of Gen -1 travail that that I hope doesn&#8217;t get accidentally revived by this generation&#8217;s league of speculative scientists.

Seeing that I am one of the principle contributors to NBehave, I love that I can now dawn a lab coat and refer to myself as a “Speculative Scientist”. I say that tongue and cheek of course but my profoundness in my assertions of traceable requirements are in part based on my experience with (twitching in my seat) <a href="http://en.wikipedia.org/wiki/Rational_Software" target="_blank">Rational Rose</a> in the 90’s!

I am one of the idiots that were forced to use this monolithic monstrosity from hell to draft requirements (getting shortness of breath), UML documents and code that magically map to each other. Forget that it took a systems administrator 4 hours to lock on unlock requirements. Forget that when you reverse engineered the code back into the model that it broke the last 6 hours of modeling that had occurred. Forget that towards the end of the project you ended up decoupling the (coughing) <a href="http://en.wikipedia.org/wiki/Traceability" target="_blank">traceability</a> and said “$@&% it, let’s just code and get this darn thing done!” As you can tell I am little bitter about the whole experience.

I will say this. My entire professional career has been brought up in Government and Enterprise level development. I have had to deal with more regulatory flack over the last 14 years then I would care to talk about, yet here I am still in the hot seat. You might ask, “Why are you still there if you can’t stand it?” The short answer is 

> “Because I believe that despite regulatory or bureaucratic issues that arise in these arenas, I know software can be done right!”

This is why I am firmly committed to evangelizing pragmatic approaches to developing software at the enterprise level.

I don’t think just because we have failed in the past means that we shouldn’t revisit the present and learn from those mistakes.

> >I never want to go back to a context where traceability is seen by my organization as a reasonable course of action.

Neither do I which I why I am creating policy to insure that this does not happen. I know that in the past organizations have been tainted by the proverbial blame game that occurs through traceability. 

In dealing with Financial Enterprise systems it is imperative that business decisions are traced through code because of security and regulatory related issues of changing pricing or loan payment amount algorithms. These have serious implications if policy and procedures are not followed (take for instance the plot of <a href="http://www.imdb.com/title/tt0151804/" target="_blank">Office Space</a>.) So we have two opposing mindsets. Produce tons of documentation to track these changes? Or Find a way to make the process light weight and uninvasive.

I want to go on the record that NBehave was never intended to solve traceability issues. I simply saw this tool as well, just that, a tool that can help me the corporate AVP, deal with traceability issues in the most simplistic way possible. 

Traceability in financial enterprise systems is seen as a comfort indicator from an executive board level of insuring that business requirements have been followed and nothing has been injected that falls outside the boundary of essential, needed or exposure. They can safely go to our shareholders and check off one out of the 50 oversight constraints that it takes to deliver software to production.

I want to caution people that are reading this entry that if you are not in an enterprise level arena or for that matter if you are. You should still exercise the most simplistic means of developing software. By that I mean start off with index cards if they work for you use them. If they don’t evaluate your process, see if you need greater understanding or a new tool.

> >We don&#8217;t use stories as a way to talk about why some feature didn&#8217;t turn out the way a customer expected.

I agree. Why a story didn’t turn out a certain way is usually the result of not understanding the acceptance criteria. I am simply proposing, rather than creating a whole new story card, simply go back to the story and revise it with the customers till it meets their expectations. It is not a contract it is simply a reference point for communication.

I also find that RallyDev, VersionOne and Target Process have all built models around Agile Project Management where the focus is about documenting the story in an electronic medium that can be tracked. In an enterprise environment these tools are essential in communicating with distributed teams on projects.

> > This aspect of confrontational team process is part of what traceability is often concerned with.

Traceability can be used in this manner but for that matter anything can. I have witnessed several times where developers, analyst etc. argued with the product owners, story card in hand over implicit behavior that wasn’t meeting their expectations. The standard argument is that the story didn’t have any of those details. I am not saying that their behavior was in line with embracing change but people are people. So no this is not what I am intending traceability to solve. That aspect is all about managing people.

> > Traceability is theoretically also concerned with compliance and auditing, but in practice, traceability between user stories and code rarely serves compliance and auditing concerns to a greater extent than it hampers the primary customers of stories &#8211; the cross-functional team building the software application.

Possibly but I have not read any empirical evidence to support either side of the issue.

> > Payments to the bureaucratic ferryman should be made outside of the project&#8217;s main line of operational efficiency.
> 
> I&#8217;m not saying that we should avoid bureaucratic and regulatory pressures. I&#8217;m saying that we are called to find the right layer within which to encapsulate those kinds of processes. The team needs to be aware of regulatory issues, but they need to be supported through workflows other than those whose aims see to the satisfactory accountability to customer requirements for features and functionality &#8211; even features and functionality that directly serve compliance concerns.

I couldn’t agree with you more. In fact I feel it is absolutely impossible to practice Agile in the enterprise environment unless you do just that. I call this the Agile Project Management Façade layer. This layers acts as an anti corruption layer between traditional oversight and Agile processes. The difficult part is that concerning traceability or Software Engineering Development oversight, the façade layer sometimes leaks! I am sure I could find a way to somehow satisfy the traceability issues at this layer and have it not affect the development team but I am afraid it will come at a cost of man power or increased bureaucracy.

UPDATE: Apparently I am not the only person calling this a managment facade layer. D. P. Bullington uses this [term](http://blog.softwareishardwork.com/2007/10/you-need-agilefaade.html) as well. 

I am not about to disturb the atmosphere in the lab or the department for that matter at the expense of an idea or tool. If the tool (NBehave) proves to be a failure I will know early on since we practice one week iterations. So the loss will be marginal at best.

It is important to point out that I have not implemented NBehave in my organization (yet). I don’t think it is there yet. It solves certain issues but it creates new ones. I have proved that it can work with certain individual but I agree with Scott that we shouldn’t expect a product owner to learn how to code. That is why I am really excited about Jeremy Millers proposal to integrate Story Teller with NBehave. I believe it we can come up with an external DSL that compliments Story cards and acceptance testing that this will be of enormous value to the community at large. 

I want everyone to understand that this debate only deals with Automated Requirements and Tracebility. It does not have any bearing on BDD. Think of this issue as a distant cousin to BDD.