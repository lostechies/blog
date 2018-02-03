---
wordpress_id: 138
title: Flexibility and control
date: 2008-02-05T02:02:05+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/02/04/flexibility-and-control.aspx
dsq_thread_id:
  - "264715536"
categories:
  - Agile
---
At our recent [Headspring .NET Boot Camp](http://codebetter.com/blogs/jeffrey.palermo/archive/2008/02/02/first-headspring-net-boot-camp-wrap-up.aspx), [Jeffrey](http://codebetter.com/blogs/jeffrey.palermo/default.aspx) and I had an interesting conversation with a couple of attendees whose company was considering an all-out [VSTS](http://msdn2.microsoft.com/en-us/vsts2008/products/default.aspx) love fest.

Already using TFS source control, the company was looking at using the Work Item and Team Build features, specifically to get integration between the two.&nbsp; Most build systems (including CCNET) note what recent check-ins are included with each build.&nbsp; The Work Item integration goes one step further, linking persisted Work Items (which could be User Stories, Product Backlog Items, Sprint Backlog Items, etc.) to individual builds and check-ins.

Nearly simultaneously, Jeffrey and I asked: [And how are you going to USE that information?](http://processpeoplepods.blogspot.com/2007/09/and-how-are-you-going-to-use-that.html)&nbsp; Neither developer could answer, and they had to IM their manager to get an answer.&nbsp; The reply back was something about compliance, which was definitely not what this VSTS feature was designed to help with.&nbsp; What was more likely was that this feature was intended to be used to exhort more restrictive control over development, through [command-and-control management](http://www.joelonsoftware.com/items/2006/08/08.html).&nbsp; 

Check-ins would need to be associated with features, and builds would be checked to see what tasks were worked on and delivered.&nbsp; Needless to say, the developers weren&#8217;t too pleased with the extra burden of keeping up with all this extra information.

The manager had likely fallen under the **illusion of rigid control leading to more predictable success**.

### Two kinds of control

Think of the difference between an arrow and a guided missile.&nbsp; The arrow is aimed once and released, and accuracy is pretty high for short distances.&nbsp; Over longer distances, wind pushes the arrow astray, and the original trajectory, no matter how precise initially, becomes irrelevant.

With a guided missile, small or large corrections can be made during flight to ensure the missile hits its target.&nbsp; The initial aiming doesn&#8217;t have to be precise by any means, as long as it&#8217;s not pointing at the ground.

In the first example, **control is achieved through rigidity, leading to long term inaccuracy**.&nbsp; Taking five minutes to aim an arrow at a target a mile away isn&#8217;t going to help me hit the target any easier.

In the second example, **control is achieved through flexibility, leading to long term accuracy**.&nbsp; It doesn&#8217;t matter how much I aim the missile initially, as I&#8217;m likely wasting time.&nbsp; Instead, through regular feedback and correction, I can change and correct the course to achieve previously unheard of accuracy.

### Feedback and accountability

Instead of trying to manage daily tasks, the manager in the example above could have fostered feedback and accountability.&nbsp; The goal isn&#8217;t to have a list of features checked off at the end of six months, it&#8217;s to deliver value and achieve the customer&#8217;s business goals.

Through regular feedback, the team&#8217;s course can be shifted and corrected to aim at the customer&#8217;s often moving target.&nbsp; Through accountability, the team becomes responsible for acting on that feedback and ensuring the missile&#8217;s rudders aren&#8217;t stuck.

Jeffrey and I suggested the team use the lightest tools possible, story cards, until the need can be proven for more heavy-weight tools.&nbsp; The team needs to question their process and ceremony, always ensuring that their actions always work towards their stated goals.&nbsp; Applying rigidity and inflexibility to this system will most surely lead to wild and disappointing misses.