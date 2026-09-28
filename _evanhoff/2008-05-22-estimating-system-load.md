---
wordpress_id: 4325
title: Estimating System Load
date: 2008-05-22T04:27:19+00:00
author: Evan Hoff
layout: post
wordpress_guid: /blogs/evan_hoff/archive/2008/05/22/estimating-system-load.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/evan_hoff/archive/2008/05/22/estimating-system-load.aspx/"
---
One of the initial steps that every non-trivial project should go through revolves around determining system usage requirements.

Here&#8217;s a no-nonsense method for tackling this issue head-on.

**1. Anticipate Usage and Usage Patterns**

A prudent developer or architect will find out who the end user will be.&nbsp; He will also find out the anticipated numbers of end users that will be accessing the system.&nbsp; In addition, he will look at the anticipated usage pattern to look for things like spikes (ie..all users log into the app at 8am on Monday..or users only log in once per year).&nbsp; 

_Note: Don&#8217;t forget to include integrated applications in the system usage numbers.&nbsp; They generate load just like human end users._

**2. Estimate Future Usage**

Assuming the number of end users isn&#8217;t fixed over time, you should also estimate future growth.&nbsp; If the application will be used in house, ask what the hiring trend will look like for the next year.&nbsp; If this is a web startup, you might look at future revenue (ie..$10/user per month) and determine what an acceptable cap for the system will be (1000 users = $10k/month).&nbsp; Spend time talking with the customer and find out what is acceptable and within reason.&nbsp; They will appreciate you setting realistic expectations for them.

Also take time to compare how the numbers change.&nbsp; Some systems (ie..internal systems) may exhibit growth in usage that&#8217;s linear (ie..adding&nbsp;5 additional users&nbsp;per year).&nbsp; Other applications may experience exponential growth (ie..the next hot social networking application).&nbsp; It&#8217;s important to be able to recognize those exponential growth apps, as extra care will be needed.

**3.&nbsp; Calculate Anticipated Load**

Taking your usage figures, try and give a rough estimate as to the number of calls/requests per second the numbers translate into.&nbsp; If this were an HR web app and there are 35 people in HR (with no anticipated hiring in the next year), you might estimate the number of calls per second for the entire department.&nbsp; 

35 people * 3 seconds between clicks = ~12 requests per second

**4.&nbsp; Include a Margin of Safety**

Taking load estimates and multiplying by 10 will give you a nice cushion for error in your estimates.&nbsp; In the fictitious example above, we need to validate that our system will handle at least 120 requests per second.

**5.&nbsp;&nbsp;Sanity Check&nbsp;Your Architecture**

The initial development done on any system should be a threading of the architecture.&nbsp; This means&nbsp;wiring each piece of the&nbsp;entire system together, from UI to database and everything between.&nbsp; This step allows you to vet the high level design of the system.&nbsp; It also allows you to&nbsp;sanity check your baseline architecture&nbsp;against the usage requirements.&nbsp; Can the technology you&#8217;ve chosen and the deployment you&#8217;ve designed handle the anticipated load?&nbsp; If not, it&#8217;s better to find out now, rather than develop the app and find out during the initial deployment.