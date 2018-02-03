---
wordpress_id: 928
title: Modeling Explicit Workflow With Code, In JavaScript And Backbone Apps
date: 2012-05-10T07:02:23+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=928
dsq_thread_id:
  - "684111795"
categories:
  - AntiPatterns
  - Backbone
  - JavaScript
  - Principles and Patterns
  - Workflow
---
This post has been [revised and reposed](http://derickbailey.com/2015/08/07/making-workflow-explicit-in-javascript/) on DerickBailey.com blog.

&nbsp;

A long time ago, in what seems to be a previous life at this point, I wrote a small blog post about modeling and [creating an explicit return value from a dialog](http://lostechies.com/derickbailey/2009/05/19/result-lt-t-gt-directing-workflow-with-a-return-status-and-value/) form in a Windows application. Fast forward a lifetime (3 years) and I&#8217;m finding that this knowledge and experience is resurfacing itself on almost a daily basis with my work in Backbone and Marionette. In fact, I&#8217;ve used almost this exact pattern that I first used in WinForms, with several Backbone applications now. But I found it to be rather limiting in how I was able to implement it, because of the language and runtime differences. What I&#8217;ve settled on, though, is giving me the same benefit of explicit modeling, semantics, and encapsulating workflow: events.

## A Poorly Constructed Workflow

It seems to be common in the JavaScript applications world, to have very poorly defined and constructed workflow in applications. We take one object and build some functionality. Then when the next part of the app needs to fire up, we call the object that runs it directly from the first object. Then when the next part of the app is requested, we call that object from the second one. And we continue on down this path ad-infinitum, creating a mess of tightly coupled concerns, tightly coupled concepts, tightly coupled objects, and a brittle and fragile system that is dependent entirely on the implementation details to understand the higher level concept.

For example, might have a human resources application that allows you to add a new employee and select a manager for the employee. After entering a name and email address, we would show the form to select the manager. When the user clicks save, we create the employee. A crude, but all too common implementation of this workflow might look something like this:

[gist id=2651039 file=1.js]

Can you quickly and easily describe the workflow in this example? If you can, then you&#8217;re a better person than I am. I have to spend time looking at the implementation details of both views in order to see what&#8217;s going on and why. I have to piece together the bits from multiple places and form a more coherent high level overview in my head. It&#8217;s not easy for me to see what&#8217;s going on because every time I look at another part of the code, I have to put together the pieces again to make sure I am not breaking someone from the other parts.

## Too Many Concerns

We&#8217;ve mixed two different concerns in to very few objects, and we&#8217;ve taken those concerns and split them apart in some rather un-natural ways at that.

The first concern is the high level workflow:

  1. enter employee info
  2. select manager
  3. create employee

The second concern is the implementation detail:

  1. Show the EmployeeInfoForm
  2. Allow the user to enter a name and email address
  3. When &#8220;next&#8221; is clicked, gather the name and email address of the employee.
  4. Then show the SelectManagerForm with a list of possible managers to select from.
  5. When &#8220;save&#8221; is clicked, grab the selected manager
  6. Then take all of the employee information and create a new employee record on the server

And I haven&#8217;t even gone through any of the secondary and third level workflow in this. What happens when the user hits cancel on the first screen? Or on the second? What about invalid email address validation? If we start adding in all of those steps to the list of implementation details, this list of steps to follow is going to get out of hand very quickly.

By implementing both the high level workflow and the implementation detail in the views &#8211; the details and implementation &#8211; we&#8217;ve destroyed our ability to see the high level workflow at a glance. That will cause problems for us as developers, because we will forget some of those details when changing the system, and we will break things.

## Modeling An Explicit Workflow In Code

What we want to do, instead, is get back to that high level workflow with fewer bullet points and very little text in each point. But we don&#8217;t want to have to dig through all of the implementation details in order to get to it. We want to see the high level workflow in our code, separated from the implementation details. This makes it easier to change the workflow and to change any specific implementation detail without having to rework the entire workflow.

Wouldn&#8217;t it be nice if we could write this code, for example:

[gist id=2651039 file=2.js]

In this pseudo-code example, we can more clearly see the high level workflow. When we complete the employee info, we move on to the selecting a manager. When that completes, we save the employee with the data that we had entered. It all looks very clean and simple. We could even add in some of the secondary and third level workflow without creating too much mess. And more importantly, we could [get rid of some of the nested callbacks](http://wekeroad.com/2012/04/05/cleaning-up-deep-callback-nesting-with-nodes-eventemitter) with better patterns and function separation.

But let&#8217;s see what this would really look like in code that we could execute:

[gist id=2651039 file=2.js]

Yeah &#8211; turns out this is code that we can actually run, and it can be implemented fairly easily with a couple of Backbone views and a model for the details:

[gist id=2651039 file=3.js]

I&#8217;ve obviously omitted some of the details of the views and model, but you get the idea.

## The Benefits

There are a number of benefits to writing code like this. It&#8217;s easy to see the high level workflow. We don&#8217;t have to worry about all of the implementation details for each of the views or the model when dealing with the workflow. We can change any of the individual view implementations when we need to, without affecting the rest of the workflow ([as long as the view conforms to the protocol that the workflow defines](http://lostechies.com/derickbailey/2011/09/22/dependency-injection-is-not-the-same-as-the-dependency-inversion-principle/)). And there&#8217;s probably a handful of other benefits, as well.

But the largest single benefit of all these, in my experience, is being able to see the workflow at a glance. 6 months from now &#8211; or if you&#8217;re like me, 6 hours from now &#8211; you won&#8217;t remember that you have to trace through 5 different Views and three different custom objects and models, in order to piece together the workflow that you spun together in the sample at the very top of this post. But if you have a workflow as simple as the one that we just saw, where the workflow is more explicit within a higher level method, separated from the implementation details… well, then you&#8217;re more likely to pick up the code and understand the workflow quickly.

## The Drawbacks

Everything has a price, right? But the price for this is fairly small. You will end up with a few more objects and a few more methods to keep track of. There&#8217;s a mild overhead associated with this in the world of browser based JavaScript, but that&#8217;s likely to be so small that you won&#8217;t notice.

The real cost, though, is that you&#8217;re going to have to learn new implementation patterns and styles of development in order to get this working, and that takes time. Sure, looking at an example like this is easy. But it&#8217;s a simple example and a simple implementation. When you get down to actually trying to write this style of code for yourself, in your project, with your 20 variations on the flow through the application, it will get more complicated, quickly. And there&#8217;s no simple answer for this complication in design, other than to say that you need to learn to break down the larger workflow in to smaller pieces that can look as simple as this one.

## But It&#8217;s Worth It

In the end, in spite of potential drawbacks and learning curves, making an effort to explicitly model your workflow in your application is important. And it really doesn&#8217;t matter what language your writing your code in. I&#8217;ve shown these examples in JavaScript and Backbone because that&#8217;s what I&#8217;m using on a daily basis at this point. But I&#8217;ve been applying these same rules to C#/.NET, Ruby and other languages for years. The principles are the same, it&#8217;s just the implementation specifics that change.