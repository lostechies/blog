---
wordpress_id: 219
title: On good design and defining success
date: 2008-08-20T00:27:01+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/08/19/on-good-design-and-defining-success.aspx
dsq_thread_id:
  - "264715896"
categories:
  - Agile
  - Design
redirect_from: "/blogs/jimmy_bogard/archive/2008/08/19/on-good-design-and-defining-success.aspx/"
---
This is for the most part a reaction to conversations on design:

  * [Testability in .Net](http://theruntime.com/blogs/jacob/archive/2008/08/15/testability-in-.net.aspx)
  * [Design and Testability](http://www.lostechies.com/blogs/chad_myers/archive/2008/08/16/design-and-testability.aspx)
  * [Good Design is not Subjective](http://www.lostechies.com/blogs/chad_myers/archive/2008/08/18/good-design-is-not-subjective.aspx)

Believe it or not, I largely agree with all of these posts.&nbsp; The conversation originally started around TypeMock (and [IoC before that](http://jeffreypalermo.com/blog/inversion-of-control-is-not-about-testability/)).

Missing from all these discussions, and hidden in the intent of comments, is the real discussion: defining and creating success.

### Defining success

The traditional definition for success in the software space is:

> Completed on time, on budget, with all features and functions as originally specified

Variations of this definition exist, mostly around &#8220;on time and under budget&#8221;.&nbsp; But anyone in the software in any length of time has seen far different definitions of success.&nbsp; An on-time project never used is not very successful.&nbsp; A late project that users love is very successful.&nbsp; Defining success strictly in terms time-to-market and functionality delivered as promised still won&#8217;t lead to happy users.&nbsp; Sounds like our definition of success is a little off.

I personally like James Shore&#8217;s definition of success, with three facets:

  * Personal success
  * Technical success
  * Organizational success

Total success is achieved by delivering value in these three areas.&nbsp; If we achieve organizational success but lose our minds in the process in an arcane system, we&#8217;ve missed complete success.&nbsp; Not all projects are capable of complete success, but Agile methodologies focus on striving for these three facets of success.&nbsp; Namely:

  * Delivering what the customer wants and needs
  * Creating software that&#8217;s both fun to write and fun to work with
  * Creating an inclusive, collaborative, and exciting atmosphere where individuals feel free to question and contribute

That isn&#8217;t to say that these aspects don&#8217;t come without Agile methodologies, but that Agile is intended to deliver this type of success.

On an old team of mine, a team member got an email that some error count exceeded its limit.&nbsp; It was some throwaway application that they wrote years ago, but was still providing value.&nbsp; As no one maintained it, no one asked to change it, but it still did its job and created its little pocket of success (that not many would have predicted).

Organizational value is defined by the business, and includes increased revenue, decrease costs, and many other items that can&#8217;t be measured as directly as dollars and cents.&nbsp; Sometimes the value needed is a small application, but sometimes value and success requires something else.

So where does good design come into play into all of this?

### Enabling success

Good design such as those espoused in the SOLID principles and reinforced through TDD, as well as the other XP practices, can enable success on certain projects.&nbsp; In other projects, as Jacob pointed out, these principles don&#8217;t matter as much.&nbsp; The problem is where to know when to make the transition to &#8220;good design&#8221; from &#8220;good enough&#8221; design.

In our projects, prototyping and &#8220;spiking&#8221; is common.&nbsp; This is where we throw out any design principles and try to prove a concept.&nbsp; Once we&#8217;re done from a time-boxed episode, we&#8217;ll take what we learn (throw it away Pragmatic Programmer-style), and incorporate the concepts into our project, using the principles and values we normally follow.&nbsp; What we do the second time around invariably improves on the original throwaway concept, but gave us a more complete knowledge.

As we design, we&#8217;re always mindful of creating success.&nbsp; I create success by trying to create a sustainable software ecosystem, where the rate of change stays high and level, ready to move in the face of changing business conditions and new information.&nbsp; However, I&#8217;m on projects where I don&#8217;t know the end state, ideal for Agile, and I optimize for change.&nbsp; Software ecosystems that aren&#8217;t optimized for change resist it at every turn.&nbsp; Such projects are easy the first release, but every release after delivers less and less.

This isn&#8217;t &#8220;ivory tower&#8221;, but a recognition of a simple fact: change is inevitable.&nbsp; Unless it isn&#8217;t.&nbsp; But as software professionals, we have to recognize when the application transitions from simple to complex, and change our tactics as necessary.

In the end, users don&#8217;t care about design directly.&nbsp; They want value, they want success.&nbsp; Good design can enable success, as it allows us to change software more quickly and easily than otherwise.&nbsp; For complex or changing systems, users care about design, they just might not know it.