---
wordpress_id: 626
title: Limits of performance optimization
date: 2012-05-03T13:31:26+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2012/05/03/limits-of-performance-optimization/
dsq_thread_id:
  - "674248953"
categories:
  - Architecture
---
<img style="display: inline; float: right" alt="Datasheet Thumbnail" align="right" src="http://www.datasheetarchive.com/ThumbnailsIndexer/Scans-004/tnScans-0088808.jpg" />Back in college, where I was an Electrical Engineering undergrad, I had an especially difficult professor for my microcontrollers course. In this course, we would hand-roll assembly language instructions and upload them to the [68HC12](http://en.wikipedia.org/wiki/Freescale_68HC12) testing board. (Side-note, I never, EVER want to hand-roll assembly language again. Or hand-compile C code to assembly).

In microcontrollers, onboard memory is a huge limiting factor. Modern devices have lots of available memory, but for embedded devices, your ROM pretty much decides how complicated your program can be.

As part of the course, we were graded on how _compact_ our code was, rather than merely how _correct_ it was. And this makes sense, since compactness can allow for more features/decisions etc.

So we all made reasonable efforts to compact our code using common tricks like shift-operators for multiplication and so on. However, what we didn’t know is that our professor had spent 20-30 years optimizing assembly code for compactness, and our efforts were being graded against his. Any deviation from his solution was a deduction in our grade. 

After receiving poor marks, and seeing why, we all as a class reviewed the (his) solution. And wouldn’t you know that while compact, **code optimized to its maximum is nearly impossible to understand or maintain**. No one in the class, viewing the code for the first time, would be able to decipher what it actually did.

### Long-term maintainability

Since we change code far more often than we write code, optimizing solely for performance can make it difficult or impossible to change that code in the future. In the case of our college course, we were being held to standards that were nearly impossible to reach, let alone understand. **Performance isn’t an accomplishment, it’s a feature**.

It’s a feature that needs to be balanced against all other constraints, like the ability to maintain the code in the future. Highly optimized code often becomes more difficult to understand or comprehend, making it difficult to tweak or refactor in the future.

So when looking at performance optimization, which is many times a necessary endeavor, always keep an eye on the true goal of the performance optimization. How much more optimized does it need to be? What is the threshold for success?

Performance optimization without a clear definition of success just leads down the path of obfuscation and unmaintainability. Optimization does have an upper limit, not only in terms of gains, but of losses in maintainability.