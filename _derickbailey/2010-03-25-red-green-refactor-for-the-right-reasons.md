---
wordpress_id: 124
title: Red/Green/Refactor, For The Right Reasons
date: 2010-03-25T17:43:42+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/03/25/red-green-refactor-for-the-right-reasons.aspx
dsq_thread_id:
  - "264192775"
categories:
  - Agile
  - Analysis and Design
  - AntiPatterns
  - Pragmatism
  - Principles and Patterns
  - Refactoring
  - Unit Testing
redirect_from: "/blogs/derickbailey/archive/2010/03/25/red-green-refactor-for-the-right-reasons.aspx/"
---
First, let me say this: WHAAaa???? something _useful_ occurred on Google Buzz?! 🙂 Ok, now that I’ve got that over with… there was [a useful stream of comments](http://www.google.com/buzz/derickbailey/GNmueprNnTM/refactor-dont-forget-the-refactor-part-of-red) over on the [extended twitter reply network](http://twitter.com/derickbailey/status/9546697945) from one of my tweets a while back.

&#160;[<img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="Jeff Doolittle - that applies to all three! red (for the right reason), green (for the right reason), refactor (for the right reason)" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_16C7E00F.png" width="776" height="197" />](http://www.google.com/buzz/derickbailey/GNmueprNnTM/refactor-dont-forget-the-refactor-part-of-red) 

Jeff’s comment at the bottom is what I’m referring too as the useful bit, really. I often catch myself going through the motions of skip-right-to-green/refactor, or catch myself doing ignore-the-reason-why-it-failed/green/move-on-to-the-next-thing. Both of these test-first anti-patterns have bitten me in the butt on multiple occasions. I’d guess that they actually bite me pretty regularly, if not every time I fall into one of these anti-patterns. 

Jeff is right, and I know it from experience and personal pain… it’s not just red/green/refactor. It’s actually 

> <font color="#ff0000"><strong>Red</strong></font>: for the right reasons
> 
> <font color="#008000"><strong>Green</strong></font>: for the right reasons
> 
> **Refactor**: for the right reasons

What is the right reason? Well, that depends entirely on your circumstances and the code that you are writing and testing. 

&#160;</p> 

### <font color="#ff0000">Red</font>: For The Right Reasons

Red should happen because the conditions of the test were not matched… not for any other reason. As one example: this means that if you are expecting an interface method to be called, the test should fail because the method was not called. It should not fail for any other reason.

An null reference exception is usually not the right reason. There are times when checking null or not-null is the right thing to do, but you should not be getting exceptions to tell you whether its null or not… most of the time, anyways. There’s some exceptions to this, of course.

A “Throw NotImplementedException();” is _never_ the right reason. No, I do _not_ want to throw an exception from that method that I just generated. I want it to be empty, or return a null or some other default value if there is a return type. (and yes, i know there is an option for this in Resharper… but i’ve never seen that option work, no matter how many times i’ve tried to make it work).

There are plenty of other bad reasons for red, and each specific test has to be evaluated to understand the right reason for red. Context truly is king.

&#160;

### <font color="#008000">Green</font>: For The Right Reasons

A test should pass not just because the conditions stated in the assertions exist, but because [the simplest thing that could possibly meet the requirements](http://devlicio.us/blogs/tim_barcz/archive/2010/03/15/are-you-playing-checker-or-chess-yagni-revisited.aspx) was implemented.

Back when I was doing all state based testing, I would often make my test go “green” by hard coding a value into it. For example, if I was asserting that the output of some calculation was supposed to be 60, I would hard code a “return 60;” in the method that was being called. I did this to “calibrate” the test… to make sure that the test could pass for the right reasons, even if the implementation was not yet correct. I’m not sure I buy this anymore, really. Do I really need to know that “Assert.AreEqual(60, myOutputVariable);” will work because I hard coded a value of 60 into the method being called? I really don’t think so.

The simplest thing that could possibly work is a misnomer. Hard coding a value is the simplest thing, but it’s worthless. Setting up the very basics of structure and process, _without regard for any not-yet-coded functionality_ is a much more appropriate way to look at the simplest thing. You need to account for the actual requirements of what you are implementing, the core of the architecture that your team has standardized on, and any other bits and pieces of standards that make sense and should be in place for the system in question.

Did you get your test to pass? Good. Did it pass because you wrote production worthy code, without writing more than would make the test pass? Great! 

&#160;

### Refactor: For The Right Reasons

STOP! Hold on a second… before you go any further and before you even think about refactoring what you just wrote to make your test pass, you need to understand something: if your done with your requirements after making the test green, you are not _required_ to refactor the code. I know… I’m speaking heresy, here. Toss me to the wolves, I’ve gone over to the dark side! Seriously, though… if your test is passing for the right reasons, and you do not need to write any test or any more code for you class at this point, what value does refactoring add?

Just because you wrote some code to make a test pass, doesn’t mean you need to refactor it. There is no rule or law that says you must refactor your code after making it green. There is a principle that says you should leave the campsite cleaner than when you got there. Sometimes the process of adding code and functionality leaves it clean to begin with and you just don’t need to do any additional work to clean it up.

If you write your first chunk of code to make a test pass and it’s simple, elegant and easy to understand and modify, then stop. You’re done. You don’t need to refactor. If you are adding the 25th chunk of code based on the 25th test and the code remains simple, elegant and easy to understand and modify, then stop! You don’t need to refactor. If, however, you write some code that is a duplication or is using some nested if-thens and loops, or is using hard coded values, or for whatever other reason it does not conform to all of the principles and guidelines that you follow in order to make your code simple, elegant, easy to understand and modify… ok, then you need to refactor.

So why should you follow the refactor portion of red/green/refactor? When you have added code that makes the system less readable, less understandable, less expressive of the domain or concern’s intentions, less architecturally sound, less DRY, etc, then you should refactor it.

&#160;

### In Retrospect

Looking back at my tweet in the image at the top of this post, it’s obvious that I was painting an oversimplification of red/green/refactor. This mantra was never intended to be a simple mechanical checklist of things that you must do in order to be a TDD’er. The entire purpose of the mantra is to remind us that we need to not only write tests as specifications to prove that our system works, but also consider the changes that we are making to the system in the context of clarity and expressiveness of code. 

There is no simple answer for “what is the right reason?” when considering red/green/refactor. Each situation has to be evaluated based on its needs and its context. The examples that I’ve given for good and bad reasons are only examples to try and illustrate the principles behind the right and wrong reasons.

In the end, red/green/refactor is just a convenient statement that should remind us to think about what we are doing and apply pragmatism to our process by ensuring we are adding value, not just blindly following some simple platitude without regard for the consequences.