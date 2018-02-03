---
wordpress_id: 4811
title: 'Part Three &#8211; A Response to “Traps &#038; Pitfalls of Agile Development – A Non-Contrarian View”'
date: 2009-02-10T12:37:00+00:00
author: Chris Taylor
layout: post
wordpress_guid: /blogs/agilecruz/archive/2009/02/10/part-three-a-response-to-traps-amp-pitfalls-of-agile-development-a-non-contrarian-view.aspx
categories:
  - Agile Development
  - Community
  - Extreme Programming
  - I.T. Management
---
In the previous two installments ([Part One](/blogs/agilecruz/archive/2009/02/10/part-one-a-response-to-traps-amp-pitfalls-of-agile-development-a-non-contrarian-view.aspx) and [Part Two](/blogs/agilecruz/archive/2009/02/10/part-two-a-response-to-traps-amp-pitfalls-of-agile-development-a-non-contrarian-view.aspx)), I wrote about Pitfalls 1 through 5 of [Sean Landis&rsquo; this blog entry](http://www.artima.com/weblogs/viewpost.jsp?thread=246513).&nbsp; I continue with Pitfall 6 here.

****Pitfall** 6**: Agile teams have a tendency to focus on tactical accomplishments at the expense of strategic goals.

**My opinion**: true, kind of.&nbsp; This is true on all types of teams I&rsquo;ve been on, Agile or not.&nbsp; The place I believe this statement **<span style="text-decoration: underline">might</span>** be relevant to Agile is in the word &ldquo;tendency&rdquo;. 

My
  
first response is to play somewhat of a Devil&rsquo;s advocate and ask, &ldquo;So
  
what?&rdquo;&nbsp; As long as the software does what it&rsquo;s supposed to do, is
  
maintainable and makes the business happy, why not leave the strategic
  
thinking up to the business experts?

However, what if a lack of
  
understanding of strategic goals on the part of the developers and
  
architects affects design, which in turn does affect extensibility and
  
maintainability?&nbsp; Now, we have an issue, and an issue to which I
  
believe Agile could be prone because of many proponents&rsquo; emphasis on
  
the principle affectionately termed &ldquo;YAGNI&rdquo; (You Ain&rsquo;t Gonna Need It).

A
  
lot has been written about YAGNI and I don&rsquo;t claim to have read it all
  
nor want to rehash it all here.&nbsp; Let me just offer two cents and how I
  
believe it relates to this pitfall.

If we are not careful, we
  
can end up practicing YAGNI as a knee-jerk reaction to
  
&ldquo;design-up-front&rdquo;.&nbsp; We must take care it does not infect our planning
  
and design of software.&nbsp; Very often our understanding of the overall
  
strategic goals, especially from a business-value perspective, helps
  
inform architecture and design. We must be careful not to overlook this
  
fact.&nbsp; 

At my previous company, we supported and extended a
  
system used to help originate mortgage loans.&nbsp; From the get-go, the
  
system was built around the concept of a Loan Application.&nbsp; Once
  
committed to a design that was Loan-Application-centric (by I don&rsquo;t
  
know how many millions of lines of code), it became evident to the
  
developers that the Loan Application really had a parent concept of a
  
Loan Package.&nbsp; The Loan Package could contain one or more Loan
  
Applications.&nbsp; 

I cannot describe to you the incredible
  
gymnastics we had to perform to retrofit the system to deal with Loan
  
Packages.&nbsp; Refactoring was a monumental effort that we were not given
  
time to address.&nbsp; To me, this was a clear example of the truth of this
  
pitfall, and a clear example of how YAGNI could get you in trouble.&nbsp; 

Had
  
the developers known the business concept of associating multiple loans
  
with a single property early on in the process (which might have
  
surfaced had they know the strategic direction of the business), we <span style="text-decoration: underline">may</span> have avoided this problem.

However,
  
I don&rsquo;t think Agile is responsible for this; I have seen the exact same
  
problem many times over many years in a number of different types of
  
shops.&nbsp; This is an age-old problem, one of which Agile is actually
  
trying to address.

On the other hand, I do think a YAGNI
  
mindset is very helpful, especially when practicing TDD/BDD.&nbsp; If you
  
work even half-way through [Kent Beck&rsquo;s Extreme Programming Explained](http://www.amazon.com/Extreme-Programming-Explained-Embrace-Change/dp/0321278658/ref=pd_bbs_sr_1),
  
for example, you will see how YAGNI, when practiced with TDD, helps
  
evolve a design in a simple, yet elegant way.&nbsp; In that context, YAGNI
  
makes sense.&nbsp; 

However, I have seen proponents of YAGNI go so
  
far with the concept that they kept themselves blinded to important
  
issues that were just over the horizon that, when discovered, cost a
  
lot in terms of refactoring, redesign, etc.&nbsp; It is my humble opinion
  
that too much YAGNI can be almost as bad as too much upfront design.
  
YAGNI is good, but must be balanced. Achieving that balance is hard and
  
very often comes only through experience, trial and error.&nbsp; Part of
  
learning that balance is to realize the contexts in which YAGNI makes
  
sense.

Agile or not, management has a responsibility to provide
  
leadership on maintaining the proper balance here and provide for a
  
process by which every relevant practitioner has an appropriate
  
understanding of the strategic goals the project is designed to support.

Last
  
point: the intimate relationship Agile practitioners develop with the
  
product ownership team can provide quite a bit of opportunity to
  
understand the strategic placement of the project simply because of the
  
continual dialogue that occurs.&nbsp; Inevitably, in my experience, business
  
context is very often communicated as a natural part of these
  
interactions.&nbsp; Not always, but often.

**Conclusion:**

Short and sweet: be careful with YAGNI and understand the business your software is being built to support.

I
  
remain a firm proponent of Agile methodologies because, in my
  
experience, they work and work well &ndash; better than other methodologies
  
I&rsquo;ve participated in.&nbsp; To me, Agile is NOT the issue.&nbsp; Managing
  
ourselves and the software-unfriendly human tendencies that we struggle
  
with in our profession, no matter the process or methodology, is the
  
issue.

[Original version of this was posted 1/12/2009 at http://agilecruz.blogspot.com]