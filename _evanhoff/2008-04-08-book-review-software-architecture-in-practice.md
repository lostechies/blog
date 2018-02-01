---
id: 44
title: '[Book Review] Software Architecture in Practice'
date: 2008-04-08T02:14:31+00:00
author: Evan Hoff
layout: post
guid: /blogs/evan_hoff/archive/2008/04/07/book-review-software-architecture-in-practice.aspx
categories:
  - Uncategorized
---
Having stumbled onto some of the SEI&#8217;s material on software quality attributes, I decided I had to know more.&nbsp; That was the motivation that drove me to read <a href="http://www.amazon.com/Software-Architecture-Practice-2nd-Engineering/dp/0321154959/" target="_blank">Software Architecture in Practice</a>.&nbsp; It didn&#8217;t hurt when the book was shortly thereafter recommended to me&nbsp;by <a href="http://www.rgoarchitects.com/" target="_blank">Arnon</a>.

On the Amazon scale of rankings, I&#8217;d give this book 5 stars (of 5).&nbsp; Not only did it contain a wealth of information on software quality attributes, but it also contained a goldmine of other information as well.

Here&#8217;s a very short list:

  * **Software Quality Attributes** &#8211; a through introduction to software qualities (often referred to as nonfunctional requirements)&nbsp; In particular, the book has a strong focus on a particular core set: availability, modifiability, performance, security, testability, and usability.&nbsp; You might wonder why some other obvious qualities weren&#8217;t on that list, and that&#8217;s covered in the book as well (ie..scalability falls under the combination of performance and modifiability).
  * **Tactics** &#8211; a tactic is an approach you can use to tweak a particular software quality attribute.&nbsp; Localize Changes is an example of a tactic that&#8217;s described for increasing modifiability.&nbsp; Generally speaking, tactics involve compromise.&nbsp; As an example, using a security tactic often involves a negative tradeoff in performance (actually, almost everything involves a negative tradeoff in performance).
  * **Case Studies** &#8211; the book is not short on case studies, and it has some really interesting ones at that.&nbsp; If you&#8217;ve ever wondered what the architecture of a group of networked flight simulators (military grade) might look like, a good case study is included.&nbsp; Others include a study of the US air traffic control system and a software product line used to build submarines.
  * **Architecture evaluation** &#8211; the book serves as an introduction to the topic of architecture evaluation (through the lens of quality attributes and scenarios).&nbsp; It introduces two formal frameworks for evaluation, the ATAM (the Architectural Tradeoff Analysis Method) and the CBAM (the Cost-Based Analysis Method).&nbsp; While the two formal methods are too heavy for me to use practically, they serve as a good background for learning LAAAM (the Lightweight Architecture Alternatives Analysis Method).&nbsp; While I&#8217;m sure several people are snickering at the thought of doing architecture evaluations, I&#8217;ll just point out two facts: 1) <a href="http://www.thoughtworks.com/our-clients/case-studies/banking-architecture-evaluation.html" target="_blank">they are practiced by ThoughtWorks</a> (they are not anti-agile) 2) when applied appropriately, they have been known to save large amounts of money (Figures from AT&T were roughly $1M per 100k LOC &#8211; IEEE Software Apr-May 2005).
  * **Real-Time Systems** &#8211; This is a bit of a double edged sword.&nbsp; I really like the fact that the book had quiet a bit to say about real-time systems, but in practice, most of us don&#8217;t build real-time systems.&nbsp; This was due to the fact that the SEI is funded by the DoD and deals heavily with military systems.
  * **Software Product Lines** &#8211; the book briefly introduces the concepts (there&#8217;s another volume dedicated to SPLs) and provides a very nice case study.&nbsp; Software Product Lines is definitely a topic I&#8217;m interested in and I hope to expand myself in this area in the future.

Overall, I would highly recommend this book to developers who have honed their OO design skills and are looking to expand their horizons.&nbsp; This book sticks to fundamentals&nbsp;and covers quite a bit of breadth.&nbsp; I will warn you though, it&#8217;s quite thick (almost 500 pages) and can be dense in spots.