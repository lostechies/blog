---
id: 141
title: Getting over the TDD hump
date: 2008-02-14T01:31:10+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/02/13/getting-over-the-tdd-hump.aspx
dsq_thread_id:
  - "264715546"
categories:
  - TDD
---
[Chad](http://lostechies.com/blogs/chad_myers/default.aspx) mentioned that the [first 2 hours of TDD are the hardest](http://lostechies.com/blogs/chad_myers/archive/2008/02/12/the-first-2-hours-of-tdd-are-the-most-painful.aspx).&nbsp; Without a good pair by your side, the pain can stretch well beyond a couple of hours.&nbsp; Maybe I had a rare experience, but my first experience with TDD was successful and had very few bumps.&nbsp; Looking back, I don&#8217;t know what exactly we did right, but maybe the whole story might put things in focus.

### Step 1: Gettin&#8217; my learn on

I hear a lot of questions about how to do TDD, what exactly TDD means and how it works.&nbsp; Well, [there&#8217;s a whole book on it](http://www.amazon.com/Test-Driven-Development-Addison-Wesley-Signature/dp/0321146530).&nbsp; If you&#8217;re done with that one and you have more questions, well there&#8217;s [this one that fills in the gaps](http://www.amazon.com/xUnit-Test-Patterns-Refactoring-Addison-Wesley/dp/0131495054).

I had read a lot on blogs about TDD, but let&#8217;s be honest.&nbsp; Blogs are great about focusing on a single topic, or a short introduction, but they don&#8217;t pull everything together in a single physical medium.&nbsp; There are very few writers quite as clear and concise as Kent Beck, the author of the original book.&nbsp; So if you hear any arguments about what TDD is, check out the original source.&nbsp; It&#8217;s very clearly defined.&nbsp; Without reading Kent Beck&#8217;s book, we were merely guessing on what TDD actually looked like.

### Step 2: Team buy-in

Many of us in the team looked at XP and liked its values, principles and practices.&nbsp; Another Kent Beck book laid out in clear terms what some good values are, and the value of agreeing on values.&nbsp; Teams have values, implicit, de facto, or explicit.&nbsp; Our team agreed to have some explicit values (feedback, communication, courage, etc.) and take time on regular occasions to reflect on whether we adhered to our values.

We were pretty lucky that everyone on our team had an open mind, but then again, that&#8217;s who we tried to hire.&nbsp; We valued passion and open-mindedness to years of experience.&nbsp; And in that case, we were successful.&nbsp; Everyone agreed to try TDD, but no one mandated it.&nbsp; We all agreed that people had success with it and we were capable of success, so there was really nothing stopping each of us from trying except for fear.&nbsp; That&#8217;s where our &#8220;courage&#8221; value kicked in.

### Step 3: A gentle introduction

We would have seriously crashed and burned if we tried to introduce ourselves to TDD against our existing legacy codebase.&nbsp; Nothing in our existing product was testable by any stretch of the imagination, and it seemed like that if we wanted to sneeze we needed the database up.&nbsp; In Kent Beck&#8217;s book, he introduces TDD in a pairing session tackling a simple problem, a bowling game.

Our team agreed to do something similar, and practice TDD on a simple problem.&nbsp; We decided the board game, &#8220;Connect Four&#8221; had simple enough rules for us to complete the game in a day.&nbsp; There were no rules for our practice except:

  * We must program in pairs
  * Code must be written test-first

We had no constraints on the interface of the game.&nbsp; My pair decided to use arrays and console output for the game, while other pairs went for a visual, WinForms experience.

At the end of the day, we got back together for a retrospective and compared code and tests.&nbsp; We also talked about what went well and didn&#8217;t go well, and what we could have done better.&nbsp; Finally, we all agreed we had a lot of fun doing it and wanted to have that much fun developing against our real-life codebase.

### And they&#8217;re off

The bell sounded and the horses were out of the gates.&nbsp; From that point forward, the bulk of our work was done test-first style.&nbsp; We weren&#8217;t great at first, but that wasn&#8217;t the point.&nbsp; We had committed as a team to give TDD a fair shot, and our codebase thanked us for it.&nbsp; When we started, we had zero unit tests and we ended a year later with well over a thousand.&nbsp; At first we would have little &#8220;woo hoos&#8221; when we hit milestones at the hundreds.&nbsp; As our velocity increased, we only celebrated hitting 1000.

Along the way, we had many questions answered simply through practice.&nbsp; We tried different styles, stumbled through many smells.&nbsp; Through our dedication to constant feedback and communication, we drove through any barriers we had.&nbsp; If there was a wrong way to do things, we found it.

But since we committed as a team to work together to improve ourselves (and deliver more value more often), the journey was far easier than it would have been flying solo.