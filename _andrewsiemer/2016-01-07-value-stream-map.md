---
wordpress_id: 130
title: Value Stream Map
date: 2016-01-07T21:14:35+00:00
author: Andrew Siemer
layout: post
wordpress_guid: http://lostechies.com/andrewsiemer/?p=130
dsq_thread_id:
  - "4471180031"
categories:
  - Process
---
I read an article yesterday about [how SoundCloud migrated their product towards microservices](http://philcalcado.com/2015/09/08/how_we_ended_up_with_microservices.html).  It was the business reasoning for making that decision and the steps they went through to finally get to their goal.  It wasn&#8217;t so much about the technology.  I love this type of article as the thing we should all focus on more is generating business value &#8211; not shiny new technology toys (that nobody cares about) &#8211; out of our efforts each day.

In that article I was introduced to a new concept &#8211; [Value Stream Mapping](https://en.wikipedia.org/wiki/Value_stream_mapping).  This post won&#8217;t do that topic enough justice but should get your mind moving in the right direction.  If you think you have inefficiencies in your product/development process &#8211; pause what you are doing, read this post, do this exercise with your team.

I was so excited about this way of visualizing process and data that I did it with the team a few minutes ago.  At the end of the session we had a very messy whiteboard that was almost like a brainstorming bubble diagram with a little bit of workflow and a little bit of state machine and a little bit of timeline.  What was ugly to anyone not on the team was full of incite to the team.  Everyone learned something.  And whats best is that we all see some low hanging fruit ripe for the picking for immediate process improvements

# Why do Value Stream Mapping?

A Value Stream Map (VSM) allows you to visualize a process as it is &#8211; rather than how you think it is.  This allows you to see how long things generally take, and see where there might be an unneeded time suck in your day to day processing of a given type of work.  Specifically, how long on average does it take to implement one new feature and get it in front of your customers?  Who is doing the work?  Is the work being done being done by the right type of person?  Are there areas where efficiency can be gained quickly?  Do we have any churn in the process where the process is quick but since we never get it quite right we have to do the same steps over and over again?

## Examples

An example that might apply to you is receiving a new story in your product backlog that isn&#8217;t quite fleshed out.  This story might just be five words to summarize at a high level the problem that someone is having.  It doesn’t give enough detail however to understand the problem or define what an appropriate solution might be.  Additionally, as the work might get prioritized to be done now, the architect may not have a chance to see if the fix the engineer is putting into place is in alignment with the years technical road map for that problem area.  You may also find that the research is taking long periods of time, being done by an expensive development team member, rather than by someone in the business who knows the problem area or by a BA.  Quality might be another area where if we paid just 5 more minutes of attention to something prior to calling it done, we could save countless hours of deployment, testing, and validation work &#8211; let alone all the loop backs for rework.  The less back and forth the better.

# How?

This activity should be done by all members of the team for a given process over a given business area or application.  It should be informal.  And all people should be able to share their insights.  “The expert” should keep the conversation on track but should not be filling in the gaps along the way.  People that work in the process know the reality of the processes.

The goal is not to produce a sugar coated version of reality.  But instead to produce reality as it is today in all its ugly glory.  Expose the gaps and time sucks.

Here are the steps for creating a VSM:

  1. Select the process to be analyzed
  2. Use consistent symbols in the map to reduce complexity and gain rapid understanding
  3. Define the boundaries of the conversation 
      1. Perhaps the business does some product road mapping that don’t involve the dev teams &#8211; don&#8217;t include that
  4. Outline the known steps in the process within the boundary
  5. Add information flows to the VSM 
      1. This can be communication between parties
      2. How a process is initiated
      3. The frequency (back and forth) of a given step
  6. Collect process data 
      1. Cycle time (time taken to get through each step)
      2. Change over time
      3. Up-time
      4. Number of people involved
      5. Available working time
      6. Batch size
  7. Timeline 
      1. This gives us total process times and lead times
      2. Calculates total lead time
  8. Interpret the VSM
  9.   1. Excessive time spent by the wrong resource type
      2. Poor quality causes repeat cycle times
      3. Areas that can be automated
      4. Processes that can be removed or made more efficient

A quick google search for &#8220;Value Stream Map&#8221; will show you a lot of manufacturing maps.  Add &#8220;Software Development&#8221; and you will come up with some example drawings that are more applicable to your needs.

![](http://static.architech.ca/wp-content/uploads/2013/01/value_stream_waterfall.png)

# Ideal State

Once you have a VSM created that reflects your current state you can quickly identify inefficiencies in how your team is working today.  There are probably low value but quick wins (low hanging fruit) that can easily be solved for some immediate return.  Do those first.  Then there are going to be some obvious big wins but that are more complex to achieve.  Identify all the steps that you want to do to make improvements.  And as you make those improvements go back to the “collect process data” step and reevaluate the reality of your new process.  Ensure that the changes you make do add value and reduce time to market with your new features.

Usually some quick wins in the development process are some of the following:

  * Reduce friction going to production.  Manual processes take time and are error prone.  Add some form of continuously delivery or continuous deployment.
  * Determine how to improve quality.  This may be adding unit tests, code reviews, or developer isolation.  Or it may be automated functional testing.  Or it may be expanding your QA presence.  The answer here depends on how your shop is set up.  But stopping the back and forth between bugs that go to production is important as that is usually expensive across a large swatch of your product delivery team (product management, engineers, QA, devops, etc.).
  * Focus on finishing work over starting new work.  Having 50 things in progress doesn’t add as much value as shipping one new thing to your customers.  Set WIP limits in your process and continuously realign your team to focus on getting things done – regardless of where the blockage is.

Have you done this before?  Let us know how it went in the comments below.