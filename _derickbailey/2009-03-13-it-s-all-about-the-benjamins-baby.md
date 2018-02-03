---
wordpress_id: 42
title: It’s All About The Benjamins, Baby.
date: 2009-03-13T18:59:15+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/03/13/it-s-all-about-the-benjamins-baby.aspx
dsq_thread_id:
  - "284935262"
categories:
  - Lean Systems
  - Management
  - Philosophy of Software
  - Throughput
---
Puff Daddy <a href="http://en.wikipedia.org/wiki/It%27s_All_about_the_Benjamins" target="_blank">got it right</a>. No, I don’t mean having money and wealth. Never mind the actual lyrical content or intentions of those lyrics in this song. The title alone tells us everything we need to know about justifying anything in business – including the reasons that we must use when arguing the need to improve on the quality of our software development efforts. Every argument that has ever been made for the improvement of software development efforts should come down to this one, undeniable truth: Your company and your customers care about the cost of producing the software and the return on that investment, first. It would be irresponsible for your company or the customer not to consider this the top priority. Every other aspect of the software development processes that we use are ancillary to, and in support of, that simple truth.

### The Importance Of Cost Justifications

Cost justifications become more and more important in a down economy like we have today. There are far fewer resources to use, and we are expected to do more with what little we have. The good news is that if you understand how everything is centered around the money involved, it becomes really easy to cost-justify most of the things that we want to do. The bad news is, some of the things that we want to do don’t make sense when looked at through the lens of cost – or the lens we are using is simply too small and we need to see the bigger picture to really be able to justify it. What this really comes down to is what you want to do and why. Do you want to continue with the status quo? Do you want to advocate for your own personal advancement?&#160; Or do you truly put the Customer in the forefront of your recommendations, creating a system that benefits the customer first while still maintaining a viable business for yourself and your company?

Once you understand that there is a cost associated with every action we do and every process we have in place, quality becomes easy to cost-justify. All you need to do is track the actual cost of producing a single feature or customer-visible function, including the amount of rework involved. Every defect or requirements change is rework of some sort (very generically. the specifics of ‘rework’ are another subject matter for another time). Rework is inherently expensive – more expensive than getting the feature right the first time. Consider the following example…

### The Financial Cost Of Quality

Let’s say it takes 1 hour of effort to create the requirements for a feature, 2 hours of effort the analyze those requirements and design the feature’s implementation, 4 hours of effort to code and integrate the feature, 2 hours of effort to test the feature, and another hour to deliver the feature into production. If we assume an average billing rate of $50/hr for every person involved in the process, with a total of 10 hours involved – that feature cost $500 to produce. If the feature is what the customer(s) wanted, then we are good to go – no rework needed, no additional cost.

Next, take that same feature, time/effort and billing rate to start with. However, assume that after 1 hour of testing, the tester finds a problem with the feature. Now spend&#160; another 1 hour of analysis of the problem, involving a tester, an analyst, and a developer (for a total of 3 hours) to figure out what the system should do. Then add another hour for the developer to fix that problem and another 2 hours for the tester to run and end-to-end test of that feature. After that, it gets delivered to the customer(s). Given this situation, we have spent a total of 14 hours to produce this feature. The total cost of this feature is now $700. This is an increase of 40% over the cost of getting it right the first time. If it were my money, I’d rather not pay the extra 40% for that feature. It would be in my interest to ensure that the feature is built right, the first time.

This is obviously a fictitious example, with made up numbers. But how far from reality is it? Take that simple example out to your actual processes. Measure the real effort it takes to get a feature through all of your company’s steps. Be sure to include the amount of re-work done; that is, the number of times that the feature has to be “sent back” to a previous step or activity to be corrected, and the total time that the feature spends being pushed through the same processes again. Are you seeing a re-work cost of 20, 30, 40 percent for a given feature? or higher? 

### You Get What You Measure

What is the cost of getting it right the first time? What is the cost of ensuring that your process, tools and techniques are going to adequately define and implement the feature that is actually needed, the first time? And what is the cost of not getting it right the first time? How much money are you spending to re-work a feature? Unfortunately, most efforts fail to accurately measure the actual cost of developing a given feature, which prevents these questions from being correctly answered. 

The cost of producing a given feature is not just the cost of a developer writing code. Every single activity involved in software development has to be accounted for. This includes, in a very generic view: requirements gathering, analysis and design, construction, testing, and delivery. Every step along the way must be accurately measured for the cost of a feature to be known, but you have to be careful how you are measure. If you decide to measure the number of lines of code in the system as a sign of quality, for example, you will get more lines of code when fewer could have done the same job. Therefore, we should choose metrics that measure the throughput of software through the entire system – from concept, to cash. By measuring the system as a whole, we can avoid the pitfalls of local measurements, like lines of code.

Once you are able to measure correctly, you can show the true cost of quality – or the cost of the lack of quality.

### Optimize For The Entire System

When I talk about quality in software development, I’m not just talking about engineering practices. I’m talking about optimizing the entire system – a holistic approach to measuring quality in a software development system. The engineering practices, the analysis practices, the testing practices – every process, practice, and activity must be optimized to produce the required quality without sacrificing the efficiency of the system. The individual activities must subordinate themselves to the greater good – the efficiency of the entire system, to support the customer’s needs. The moment any individual activity sacrifices the system for the sake of the task, the model begins to fall apart and problems will pop up, causing rework and additional cost.

### Betting The Farm

I’m starting to do the math at my office, on many different fronts. I’m betting my career that the cost of rework is significantly more than the cost of building quality in the first time, and its paying off. I’m not blindly making that bet, though. I’m taking the time to work with others and define the correct metrics, to accurately measure, and to quantify the cost of not building quality in. It takes a long time, but its worth the effort. The company will listen when you provide financial data about the quality problems. It would be irresponsible for them to do otherwise. 

Once you have the actual numbers, justifying quality is easy. All you need to do is remember what P-Diddy said. It really is “all about the Benjamins.”