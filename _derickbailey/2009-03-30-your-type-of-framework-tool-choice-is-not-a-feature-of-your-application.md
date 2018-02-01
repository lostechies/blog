---
id: 47
title: 'Your [type of framework / tool] Choice is Not a Feature of Your Application'
date: 2009-03-30T13:56:51+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2009/03/30/your-type-of-framework-tool-choice-is-not-a-feature-of-your-application.aspx
dsq_thread_id:
  - "448454355"
categories:
  - Philosophy of Software
  - Principles and Patterns
---
Tim Barcz posted a great article on how <a href="http://devlicio.us/blogs/tim_barcz/archive/2009/03/29/your-ioc-container-choice-is-not-a-feature-of-your-application.aspx" target="_blank">the specific choice of an IoC container doesn’t really mean much</a> in the grand scheme of the application. This line, at the bottom of the post, really sums it up for me:

> _“**Choosing one container over another won&#8217;t make your application a success, the architecture, or lack there of, will have far more of a say on your application than will your container choice.**”_

It’s far more important to have good patterns and practices that allow us to implement architectures that are maintainable and able to scale appropriately, than to have “that one specific framework” vs “that other framework” (or no framework at all). And it’s a fairly small step to apply this idea to any other framework or tool that we want to use in our application development. Change one word – “container” – in that quote above and see how it affects the decisions we make:

> Choosing one [type of framework / tool] over another won&#8217;t make your application a success. The architecture, or lack there-of, will have far more of a say on the success of your application than will your [framework / tool] choice.

Of course, there are times when there are specific needs and valid reasons for choosing one tool over another. Be sure to read the comments on Tim’s post – the subject of valid reasons for changing is discussed more, and I really like what Tim has to say about it.