---
wordpress_id: 183
title: Intuition And Complexity
date: 2010-09-20T19:57:41+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/09/20/intuition-and-complexity.aspx
dsq_thread_id:
  - "271197050"
categories:
  - Analysis and Design
  - Craftsmanship
  - User Experience
---
I just ran into a situation where I had to describe an easy, but not intuitive process to a coworker. The net result of the conversation is that I realized I would much rather have software or process that it intuitive yet difficult, rather than simple yet not intuitive.

If a process is intuitive yet difficult, the user will be able to find there way through the process with minimal (if any) any external guidance. The user will be able to see the on-screen cues that have been built into the software, to facilitate the process, and they will be able to make informed decisions based on the on-screen cues. This holds true even if the process is difficult – for example, filing my taxes every year. This is a tremendously difficult thing to do and it takes a wealth of knowledge to know and understand everything that is happening in the process. However, the online tax filing service that I choose to use had made the process so darn intuitive that I have not required the assistance of a professional accountant or other tax advisor in years. I follow the on-screen cues, I read the instructions that they lay out in front of me, and I make informed decisions because they have made the process intuitive.

But, on the other hand, a process that is easy but not intuitive will often result in mistakes and may cause problems that are difficult to fix. In this case, the process involved a few mouse clicks on our Hudson build server to get the parameters that were supplied to the previous build. As I went through the process of describing how to get the information and how to use it, I realized that the process was simple, but not intuitive. It was simple because the links are clearly available and the information is easy to find and use. It is not intuitive, though, because you really shouldn’t have to go back to previous builds to figure out what you need for the new build. Hudson should be able to pre-populate the parameters for you, or you shouldn’t have to worry about previous builds at all. The end result is that I have to log into several servers, delete several files and remove several database records. All because the process was not intuitive.

The greatest compliment I ever heard a customer pay to a development team (from UX and BA down to coders and DBAs) was that the software was “intuitively obvious”. The customer knew how to use the software without having to be trained, because it modeled the reality of the user’s job and functions. It provided what the user needed, when the user needed it.

So, how do we create a system that is intuitive, regardless of the complexity? Feedback, feedback, feedback! Talk to the end users, if you can. Talk to the product owners and business analysts. Get something in front of them as quickly as possible – even if it’s just a picture of a whiteboard drawing or a sketch on paper. Get feedback early and often, and incorporate that feedback along with the entire knowledge base of the system and the business being modeled, into the software’s process. Pick your favorite development methodology and extend it out beyond developers, into the business and user interaction processes, to include your customers as often as possible. It’s only with this constant feedback that you’ll be able to know whether or not your software is intuitive or not.