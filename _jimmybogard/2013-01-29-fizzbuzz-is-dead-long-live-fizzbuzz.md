---
id: 714
title: FizzBuzz is dead. Long live FizzBuzz!
date: 2013-01-29T14:32:34+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=714
dsq_thread_id:
  - "1053218583"
categories:
  - Process
---
**UPDATE: It seems I was describing an out of date process, this is what we did a few months ago. Talking to folks doing interviews, we went back to live coding the Fizz Buzz exercise. Doing Fizz Buzz as a take-home exam actually told us nothing about the candidate – they would still bomb out during the exercise where we go over modifications. So the take-home exam was actually even more of a waste of time for everyone involved! One thing that isn’t different is that we’re upfront with the process – we set expectations. So you’re not surprised by the coding part.**

It seems silly, but to this day the easiest way to judge a person’s ability to code is to have them, you know, actually code. In our company, our livelihood is completely dependent on our ability to transform problems into solutions, usually by coding. What better way to understand if a potential employee can also perform this critical task than asking them?

That the landscape of developers is [extremely wide ranging is nothing new](http://www.codinghorror.com/blog/2007/02/why-cant-programmers-program.html). As an employer, we need some sort of (somewhat) objective measure to understand if one candidate does indeed possess the skills needed to do the job. It’s remarkably accurate for us as an indicator – bubble candidates that didn’t do well in FizzBuzz that did well in other things, wound up not working out for us. Putting it plainly – every employee that works for us has aced FizzBuzz.

Many, many programmers out there _hate_ FizzBuzz, even though it’s a simple problem:

> Write a program that prints the numbers from 1 to 100. But for multiples of 3 print “Fizz” instead of the number and for the multiples of five print “Buzz”. For numbers which are multiple of both 3 and 5, print “FizzBuzz”.

The kind of problem that someone with very basic skills of problem solving and programming should be able to solve it. Yet developers hate this test! Why is that?

### 

### Gotcha Interviewing

I see complaints about FizzBuzz generally fall into two categories:

  * I’m above FizzBuzz
  * I hate the pressure of live coding

In the first case – if you think you’re above FizzBuzz, then you’re putting yourself on a pedestal over all other employees. Pointing to your GitHub page doesn’t mean you can follow basic instructions – it just means you like to do OSS. Even pointing to OSS examples, while helpful, does not mean that you’re a good fit for day-to-day development. Our company doesn’t build OSS for its business, so we need a test that creates a level playing field.

The second point is absolutely valid. The last time I did FizzBuzz as a live coding exercise – it didn’t go well. I was so concerned about what questions I would ask, making a good impression and so on that it became difficult to relax and concentrate on a simple problem.

**Live coding from scratch is a form of gotcha interviewing**. Trying to stump the candidate, put them in a corner, put them under the bright lights to see if they respond is a harrowing experience. Moreover, it has **zero basis in reality of how normal development actually happens**.

We don’t do FizzBuzz like that – a live coding session doesn’t really tell us much about an employee. Our FizzBuzz strategy is a little bit different.

### FizzBuzz for success

Instead of asking the candidate to perform live coding acrobatics, we ask them after an initial screening call to do **FizzBuzz as a “take home” exam**. Candidates can time to ask questions, probe for answers, and even cheat (if they want to).

Some time later (a day or two), we circle back and have a discussion about the code. At this point, it’s more of a code review than anything else. Typically, solutions are sent to us via GitHub, which makes it easy to collaborate and discuss.

We’ll ask all sorts of questions about their code – does it handle scenario X or scenario Y. It’s really just to understand the thought process of the candidate. And believe it or not – no two submissions have been the same!

We do have some semi-live-coding at this point. Things like, “suppose we want to print Foo and Bar instead of Fizz and Buzz”. “Suppose we want the consumer of this application to decide Foo/Bar versus Fizz/Buzz”

Suppose we want to pick different numbers – 5 and 7 instead of 3 and 5.

Suppose we want to pick arbitrary ranges (100-200).

Suppose we want to pick arbitrary sets of number/word combinations (3 = Foo, 5=Bar, 7=Bazz, 11=Banana)

We don’t necessarily assume that you’ll code this all live – in fact, whiteboarding works just as fine. We’re mainly interested in how you might deal with changing requirements, unexpected complexity, and the questions you ask to solve the problem at hand.

Ultimately, we try to match our interviewing process to how we actually work with clients and develop projects internally. **Short of doing “trial runs” on real projects, FizzBuzz provides as accurate of a window into skills we need as we’ve been able to find**.

### All about respect

We at Headspring are big on respect. We respect your needs, your wants, but especially your time. We want interviewing to reflect as much as possible how we work, so that candidates understand exactly what they’d be joining.

If we throw some situation at you that we’ve never faced with clients, like a client staring at you while you code, then what are we really measuring?

However, if candidates don’t take the exercise seriously, if they think they’re too good or half-ass it, then it’s them that’s not giving respect. It takes time to interview, on both sides, so the least we try to do in assessing skills is make sure that neither of us are wasting each other’s time.