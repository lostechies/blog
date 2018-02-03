---
wordpress_id: 483
title: Visualizing the entire flow
date: 2011-05-12T13:19:14+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2011/05/12/visualizing-the-entire-flow/
dsq_thread_id:
  - "301882634"
categories:
  - Agile
---
In the large agile project I talked about in the [last post](http://lostechies.com/jimmybogard/2011/05/10/ditching-planning-poker/), one of the biggest improvements in our process was combining our story workflow across all teams. At the start of the project, we didn’t really know what our cumulative development process would be. The dev team had a fairly established regimen on how to develop features. Our workflow wound up looking like:

[<img style="border-right-width: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px;padding-top: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/05/image_thumb.png" width="644" height="324" />](http://lostechies.com/jimmybogard/files/2011/05/image.png)

This workflow was on a whiteboard next to the dev team. The story boxes were large Post-It notes, but the actual stories we worked on were mini requirements documents (side note, the whole “card and a conversation” is just bunk, from my experience).

We established this workflow very early in the project, but there were two other major phases in the _entire_ workflow of getting a story from “[concept to cash](http://www.amazon.com/Implementing-Lean-Software-Development-Concept/dp/0321437381)”, so to speak. The three phases a story went through were:

  1. Analysis 
      * Development 
          * Acceptance</ol> 
        This project had many stakeholders and interested parties, so a lot of people needed input on the analysis and acceptance phases. Eventually, the acceptance and analysis teams settled on their own workflows. We found that a story card started on a workflow in the analysis team’s story wall:
        
        [<img style="border-right-width: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px;padding-top: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/05/image_thumb1.png" width="644" height="182" />](http://lostechies.com/jimmybogard/files/2011/05/image1.png)
        
        Stories that were ready for development were the stories in our backlog. This was a scrum project, so contractually stories didn’t make it into our backlog until the dev team committed for these stories to be delivered in that sprint (more on this later).
        
        On the acceptance side, where multiple parties who all had a financial stake in the claim, each accepted the story. They had their own workflow as well:
        
        [<img style="border-bottom: 0px;border-left: 0px;padding-left: 0px;padding-right: 0px;border-top: 0px;border-right: 0px;padding-top: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/05/image_thumb2.png" width="605" height="257" />](http://lostechies.com/jimmybogard/files/2011/05/image2.png)
        
        These separate workflows each took about 6 months to fully realize. But once they did, I had a bit of an epiphany (after reading [The Goal](http://www.amazon.com/Goal-Process-Ongoing-Improvement/dp/0884270610) and chats with [John Heintz](http://gistlabs.com/john)). Each of these workflows was in the one large team room we had, but were physically located in each of the team’s pods of desks. The Analysis workflow was in the Analysis team’s area, and so on.
        
        This led to two problems:
        
          * It encouraged behavior of “throwing things over the wall”. Each team was only concerned about its workflow, and no one else’s
          * No one could figure out current status of the entire project. It was scattered on multiple physical locations.
        
        So at one weekly retrospective, we brought up the idea of combining all of these workflows into one single physical workflow and onto one single board. Each of the three workflows was brought, unchanged, onto one really long story wall.
        
        What became interesting is that many of the “wait” stages disappeared between the boundaries of each team. Instead of a “Complete” stage in the dev team workflow, it moved straight to “Ready for Acceptance”. The boundary between the teams was removed. We were able to readily see which stages had stories backed up and which were starved.
        
        In the end, visualizing the story workflow helped create shared ownership and responsibility of the entire process. If stories were backed up in acceptance, everyone saw this in the morning stand up and could raise it as an issue. If we didn’t have a lot of stories in the pipeline for development, the executive sponsor could see this and make appropriate changes.
        
        It was a small change, and couldn’t really have been put in place at the get-go, but once trust was established and everyone got comfortable in their roles, we were able to take a step back and formulate the big-picture view with one combined, shared story wall.