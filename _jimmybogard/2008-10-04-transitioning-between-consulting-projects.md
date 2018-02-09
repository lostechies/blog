---
wordpress_id: 236
title: Transitioning between consulting projects
date: 2008-10-04T17:42:53+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/10/04/transitioning-between-consulting-projects.aspx
dsq_thread_id:
  - "264715919"
categories:
  - Misc
redirect_from: "/blogs/jimmy_bogard/archive/2008/10/04/transitioning-between-consulting-projects.aspx/"
---
Starting at Headspring gave me the first opportunity in my career to do consulting work.&#160; I had previously worked in a startup, a product team and a large IT department.&#160; In each of those cases, I didn’t leave a job until I gave my two weeks.&#160; It was more than a little strange to leave a place after six months, and not from quitting.&#160; Transitioning between projects is an interesting spot, having to both forget the old domain and learn a new one, all in a small amount of time.&#160; Before I forget, I wanted to look back both at my first project and my first transition.

### Project observations

It’s easy during a project to get caught up in delivery and never stop to look at how processes and events can affect delivery.&#160; When I used to work in the test and manufacturing industry, both measurements and events were combined to try and glean the source of success and failures.&#160; For example, if the manufacturing line switched to a higher quality assembler, you should expect to see an immediate decrease of assembly defects.

During a software project, no one will notice the correlation between events, processes and quality/throughput, unless they’re specifically paying attention.&#160; I didn’t pay attention _too_ closely, but these are some of the things I remember.

#### New team members have an initial net negative effect on velocity

We brought on some great people in our project as the work started ramping up.&#160; It didn’t matter how great the person was, it takes time to learn not only the codebase, but the domain, the team and the process.&#160; While we practice fairly strict XP/Scrum practices here at Headspring, no two working environments are the same, and some variables need to change.&#160; New people _will_ lower velocity, so it’s better to set expectations early before the new team members come on.

It’s also important not to blame the new team members for a lowered velocity.&#160; They have enough on their hands to be reminded, “hey thanks for slowing us down, jerk.”&#160; After one sprint/iteration, our velocity went higher than before, just as we expected.

#### New team members will affect team dynamics

I know it was wrong, but for some reason, I felt slightly resentful every time a new team member came on board.&#160; I don’t know anything about psychology, but conversations with other team members confirmed everyone felt about the same.&#160; An existing team gets comfortable not only with their predictable delivery, but also the personalities and dynamics of each team member.&#160; Adding a new team member rocks the boat, so to speak, and it can be difficult for the existing team to transition to a new dynamic that includes the new team members.&#160; It takes time to figure out where the new people fit, how the work will break down, how the new people interact with the existing team, the new team members likes/dislikes etc.

For the new team member, it’s also a stressful transition, as they have to be injected into an existing dynamic, where the existing team might work together very smoothly and you’re introducing an unknown.&#160; On top of that, you have a new domain, new codebase and new project to learn.

Organizations that treat people as resources/head count completely miss this issue, and never address the side effects of adding new team members.&#160; Teams are rarely static over the life of a project, but it’s important to understand how much new people have the potential for affecting velocity and delivery.

#### Complex domains require simple models

The last project had by far the most complex domain I’ve ever been involved with.&#160; Maybe it’s because I’m so familiar with the e-commerce space, that going outside that safety zone added complexity, but the last domain really trumped all in terms of complexity.

The early indications that it was complex was the amount of time it would take to get answers from the domain experts.&#160; Custom configurable pricing rules, different billing options, even product lists that changed per customer.&#160; It was still a system where a user would buy things, but without going into specifics, it wasn’t selling some simple widget.&#160; There were at least major product types, with prices coming from three different places.&#160; Prices could be affected in dozens of ways, and all had to match an existing legacy system.

In all of this, our team spent a great deal of time getting the model “right”.&#160; We didn’t try to design it perfectly up front, and we tried to design only as far as our current knowledge allowed.&#160; Guessing was not an option.

In the end, I think we worked on one of the best situations for domain-driven design, as our concepts and models needed to be representative of the complexity that was inherent in our domain.&#160; Our domain model was large, but simple.&#160; We worked diligently to ensure that our classes were highly cohesive, and concerns were clearly separated, each with a discernable business or domain concern.&#160; Product selection/entitlement was completely separate from pricing.&#160; Pricing complexity did not bleed into product-level concerns.&#160; Billing options (prorate, annual bills, prorate _and_ annual bills) did not bleed in to pricing nor product entitlement concerns.

We wound up with a very rich domain model, flexible in the ways it needed to change, rigid in the core concerns of each class.

#### Not everything is modeled equally well

There were areas of our system that weren’t modeled as well as others.&#160; That was fine, our most important areas, where we spent the most time and had the most important domain logic, were modeled very carefully and evolved over time.&#160; This worked out naturally, as we only addressed modeling in an area that needed to change or grow.&#160; Places that changed more were modeled better, and places that didn’t change either were correct (according to our assumptions at the time) or didn’t matter as much.

When passing off to another team, it’s important to realize that all they see is the current iteration, not any previous iterations of the domain.&#160; They weren’t involved in the deep design and domain conversations with the domain experts, nor do they have any insight on where most of the work occurred.&#160; When explaining the model to new people, and something looked strange, we always had the excuse “well, we just don’t look at that part often.”

It’s not possible to spend equal amounts of time on the entire model.&#160; By spending time in places where we were actually working or interacting with, those areas naturally got better.&#160; Other areas we didn’t touch or look at much, weren’t changed that often, simply because they didn’t need to.

### Transition observations

Along with the first big project ending, is the first transition to a new project with an existing team.&#160; Joining a team that’s already in progress gives me sympathy for those that joined the last project in the middle of development.

#### Don’t expect to be productive immediately

Along with a new project comes a new codebase, new domain, and in my case, a new laptop.&#160; We have fairly large list of items that need to be installed for a development machine to be ready to develop, including all of the other small add-ons like Fiddler, Firebug, etc.&#160; All of this takes about one working day, more if you need to install an operating system.&#160; There were still things I forgot to write down and transition from my old laptop, including my AutoHotKey scripts, R# live templates, and other transient files.&#160; Some folks I know use thumbdrives to keep all of these types of files, extensions and addons completely portable, and I think I’ll need to go down that route as well.

#### Expect some initial friction

Joining an existing team dynamic can be frustrating for both the existing team members and new team members.&#160; New people will change how the team works, and that small pang of resentment I felt on my last team is surely being felt on the new team.&#160; I don’t believe it’s wrong to feel that, as it’s probably a natural reaction in a team environment.&#160; I will decrease velocity, or at least average velocity per team member.&#160; I’m comfortable with that, as it’s only the initial transition period where this problem occurs.&#160; Once we all get comfortable again, it won’t be a problem.

One of my own personal problems of joining a new team/project is that I’ve noticed I start out by pointing out all of the differences and perceived inefficiencies.&#160; It’s something I can tell definitely annoys people, as it’s probably the last thing anyone wants to hear from someone new to the team.&#160; Every person adds new knowledge, and everyone appreciates that new knowledge, but probably not all at once.

#### No two environments will be the same

In my last project, we were housed in a bullpen and delivered in two week sprints.&#160; This is what the environment and team members allowed.&#160; In the new environment, developers and product owners are in one large room, delivering in one week iterations.&#160; Not all environments are exactly what we want, but eventually, we have to deliver software.&#160; We’ll create as an ideal environment as we can, but the time spent on environment change needs to be balanced against actually delivering value.&#160; We’re always watchful of areas of improvement and inefficiencies, but it can take a lot of work to create a completely new environment.&#160; As a consultant, I have to create the best environment I can and ensure that the environment is ready when we start the project.&#160; After the project starts, we can’t spend nearly as much time and money crafting a new environment.

#### 

#### I like good ergonomics

The new project has great chairs.&#160; I’ve never sat in a great chair, but mostly decrepit hand-me-downs.&#160; If good chairs in your office are being fought over, it’s an organization smell.&#160; I don’t think I could ever go back to bad chair, especially if I have to sit in it eight hours a day.

Also, desk size is important.&#160; Bumping elbows a hundred times a day increases frustration and can ultimately cause friction and affect velocity.&#160; If I’m thinking about how close the person next to me has to sit, and not about the problem at hand, I’m wasting time.

### Thinking I like this whole consulting thing

One of the most enjoying experiences I had at my last project was diving in to the business and domain problems.&#160; It was technically challenging, but learning about a completely new domain was the most interesting for me.&#160; Trying to learn the existing business processes, and how the technical processes were intended to support it were a lot of fun.