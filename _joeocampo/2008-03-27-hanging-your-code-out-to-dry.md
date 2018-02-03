---
wordpress_id: 110
title: Hanging your code out to dry
date: 2008-03-27T20:31:00+00:00
author: Joe Ocampo
layout: post
wordpress_guid: /blogs/joe_ocampo/archive/2008/03/27/hanging-your-code-out-to-dry.aspx
dsq_thread_id:
  - "262090367"
categories:
  - 'Agile Project Coaching &amp; Management'
  - Agile Teams
---
I was speaking with <a href="http://www.lostechies.com/blogs/marcus_bratton/" target="_blank">Marcus Bratton</a> the other day about code reviews. We both agreed that they are very valuable but finding the time is probably the most difficult aspect of any code review. 

Paired Programming helps to eliminate the need for code reviews but paired programming caries waste of its own when it comes to menial task that need to be accomplished such as HTML. 

We practice an approach we coined “[Complexity Based Programming](http://www.lostechies.com/blogs/joe_ocampo/archive/2007/09/12/complexity-based-programming.aspx)”. The approach allows us to focus our pairing on highly sensitive areas of our code and leave the lower risk task to single individuals. A problem occurs with both approaches in that certain refactoring exercises have failed to be accomplished due to pressure from management or the project in general. So developers begin to cut corners and compromise the integrity of the code base resulting in technical debt. The issue is that the code base isn’t transparent enough that you could readily see this. 

As Agilest we look to our <a href="http://martinfowler.com/articles/continuousIntegration.html" target="_blank">CI server’s</a> state to give us feedback on the health of our code base. We also use tools such as <a href="http://www.ncover.com/" target="_blank">NCover</a> to give us the test coverage state. But this doesn’t necessarily give us our health. It is the equivalent of looking at Lance Armstrong when he had cancer and saying, “This guy’s health is great, look at all the races he is winning.” Little did you know he had cancer growing in his body that is slowly threatening his life? 

Technical Debt is like cancer. If you treat it early on, the health of your software will be tremendous. Let it go or turn a blind eye to it and it will slowly eat its way through every bowl in your code to the point of complete system shut down. 

Tools such as <a href="http://www.ndepend.com/" target="_blank">NDepend</a> are like the MRI scanners of medicine. They help to give us a picture into our codebase where we can view low cohesion and high coupling between software entities, which theoretically results in high technical debt. They ease the pains of understanding the [COCOMO](http://en.wikipedia.org/wiki/COCOMO) model and give us high degree of comfort when it comes to our overall health of our system. 

The problem with tools such as NDepend is you have to know how to decipher the data. Don’t get me wrong they do a great job of making it as painless as possible but there is a cost. You have to run the tool! You have to wait for the tool to complete its analysis. You have to be willing to sift through the data. A rewarding exercise but none the less an exercise. 

So we have lots of HiFi options but what LoFi options do we have. Well one that I <a href="http://basildoncoder.com/blog/2008/03/21/the-pg-wodehouse-method-of-refactoring/" target="_blank">read about recently</a> peeked my interest. 

As you can see this low friction high value approach is well within anyone’s skill set to produce. What I am recommending is at the end of a given coding session that you simply print out the classes you worked on. Place a string somewhere visible in the lab and hang your code on it. If it is several pages long, tape the pieces of paper on the vertical and hang it out to dry. 

Then developers can walk by the “code line” as tell if you missed a spot or quickly see the 20 page mess you created for the rest of them. Think I am smoking crack? Take a look at a quick test I just did. 

Here is a screen shot of a class file from an awesome OSS project! 

[<img src="http://lostechies.com/joeocampo/files/2011/03Hangingyourcodeouttodry_E640/Good_File_thumb.jpg" style="border: 0px none" alt="Good_File" border="0" height="383" width="644" />](http://lostechies.com/joeocampo/files/2011/03Hangingyourcodeouttodry_E640/Good_File_2.jpg) 

As you can see nice, if you just performed a cursory glance of this code hanging on a line you wouldn’t be too concerned about your teams code. 

Now check this out! 

[<img src="http://lostechies.com/joeocampo/files/2011/03Hangingyourcodeouttodry_E640/Bad_Need_Refactoring_thumb.jpg" style="border: 0px none" alt="Bad_Need_Refactoring" border="0" height="367" width="644" />](http://lostechies.com/joeocampo/files/2011/03Hangingyourcodeouttodry_E640/Bad_Need_Refactoring_2.jpg) 

Yes this 30 page monster is ONE class!!! 

Guess which file needed refactoring? If you were to see this hanging on a “code line” would you be worried if you were on this team? If you were a lead or manager what would you do? After all, the test are green!!! 

What??? You didn’t need any fancy tools to discern this premise! I am not trying to take any value away from tools such and NCover or NDepend because they are needed but at the same time light weight approaches are much more valuable from my experience. 

The <a href="http://basildoncoder.com/blog/2008/03/21/the-pg-wodehouse-method-of-refactoring/" target="_blank">post</a> I referenced before gives more insight into what to look for as far as margins and typography to determine possible refactoring opportunities. 

In the end all you tree huggers will be screaming fowl but at the same time if you are wasting tons of paper then that may be a indicator that your system is compositionally unstable. So the more you move towards wasting less paper and making the environmentalist happy, the more stable your system will become. 

Disclaimer: There were no trees harmed in the creation of this blog post. 🙂