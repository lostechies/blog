---
wordpress_id: 200
title: 'Don&#8217;t Make Me Choose To Follow The Standards'
date: 2010-12-01T02:09:04+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/11/30/don-t-make-me-choose-to-follow-the-standards.aspx
dsq_thread_id:
  - "265053504"
categories:
  - Analysis and Design
  - Management
  - Pragmatism
  - Principles and Patterns
  - Security
  - Standardized Work
  - User Experience
redirect_from: "/blogs/derickbailey/archive/2010/11/30/don-t-make-me-choose-to-follow-the-standards.aspx/"
---
Most systems that involve humans making decisions have a set of standards: guidelines, rules and/or policies that help people make good decisions. These standards are usually in place for good reason &#8211; to prevent bad things from happening or to encourage good things. Software development and the software that we use every day are no different. For example, we set standards in how we develop our software: what language, what frameworks, the architectures, the application partitioning, and much much more. We also set standards in how people use our software &#8211; the user interface and how users interact with the system. Standards are all around us every day, even if we don&#8217;t recognize them.

 

## Don&#8217;t Make Me Choose To Follow The Standards

In the process of creating the standards and the system that is built around those standards, we often have a choice in how we implement the system and standards that is overlooked: whether or not the standards are the defaults. We can implement a system so that we must explicitly choose to follow the standards, or explicitly choose to deviate from the standards. The right choice &#8211; which isn&#8217;t alway obvious &#8211; is to set up the system so that the standards we want to follow are the defaults. We should not have to think about too much about implementing them. It should be easy and natural &#8211; the default way &#8211; to use the standards that are in place. Thus, when we need to deviate from the standards, it must be an explicit choice.

 

## Helping Users Make Good Decisions

By making a system default to the standards and making deviation from the standards an explicit choice, we employ human psychology to help police the system and encourage users to make good decisions.

For example, Joey and I have been talking about security in our app lately. We have 2 major roles in our authorization system: managers and admins. At this point in time, a manager can work with patients in the system and an admin can create and edit managers. When we first started discussing this setup, we made the assumption that admins could do anything in the system. After all, they are admins&#8230; if they can create and edit the other types of users in the system, why not just let them have free reign to do whatever they want?

After some discussion, though, we realized that there are some potential issues with the way we wanted to set up admins. We don&#8217;t want admins to have free reign over the patients, directly. We need more accountability in our system than that, and we need to ensure that only the managers who are assigned to the patients can work with them. An admin may also be a manager, but we wanted to make that an explicit choice. In the end, we separated the role of manager and admin and require an explicit selection of both if a person is both. If you are only an admin, you cannot manage patients. If you are only a manager, you cannot create and edit other managers.

The net result of this decision is that it is now an explicit choice for an admin to create a manager (or assign themselves the role of manager) and work with patients. By having this be a decision that the admin must make, and not the default, we are encouraging admins to think about whether or not they need the rights to work with patients. Of course, it&#8217;s still simple for the admin to modify their own account or create a junk account with the rights to work with patients. At the very least, though, we&#8217;ll help keep the honest people honest.

 

## Helping Developers Make Good Decisions

The same principle applies to the code that we are writing in our software systems, too. We can make decisions and implement parts of our system so that it must be an explicit choice to follow or deviate from the standards.

In the same app that Joey and I are working on, we had to make a decision concerning how we wanted to secure all of the pages in the system. At first, we set up a single controller (in Rails) to require authentication. When we got to the next controller that needed authentication we stopped and discussed our options. The basic options we came up with were to either duplicate the one line of code in every controller that turned on authentication requirement, or wrap that up in a help method or module and include that in every controller. Either way, the approach required us to remember that we needed to secure the pages via the controller. The second way would at least abstract away the specific authentication mechanism we were using, making it easy to change later.

Neither of us liked either of these options, though. Not only would it mean code that we had to remember to put in place in our controllers, but it also meant potential problems by forgetting to secure things. This lead to the realization that we would need to write a test for every controller, to ensure that we had the authentication requirement in place &#8211; more tedious repetition and things to remember. Ugh.

After some additional discussion, though, we realized that the app we are working on is going to have very few pages that are not secure. In fact, there&#8217;s only 2 pages in the system that are not secure right now: the home page and the sign in page. All of the other pages and all of the other controllers are secured. Therefore, the rule is that controllers must be secure, and the exception is that a few pages are not.

With this in mind, we decided to implement the authentication requirement in the base controller (ApplicationController) and provide a way to ignore that requirement in the base controller, when needed. This solved several of the problems that we were running into with the other options.

  1. It prevented us from having to remember to put in the authentication requirement on every controller
  2. It prevented us from having to remember to write a test to prove the authentication was there, on every controller
  3. It allowed us to create a very small number of tests around only the base controller, to prove that we required authentication in our system
  4. It made the need for a non-secure page an explicit choice, instead of making the need for a secure page (the standard we needed to follow) a choice

Now our system is nice and secure, and we don&#8217;t have to worry about whether or not we put authentication into any given controller. Of course, authorization still has to be added to the individual controllers, but we expected that. Authorization is much more fine-grained than authentication in our system and we are not yet sure if we can generalize it to the base controller (seems unlikely, off-hand).

 