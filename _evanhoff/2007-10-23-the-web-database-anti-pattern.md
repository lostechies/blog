---
wordpress_id: 12
title: The Web Database Anti-Pattern
date: 2007-10-23T22:20:02+00:00
author: Evan Hoff
layout: post
wordpress_guid: /blogs/evan_hoff/archive/2007/10/23/the-web-database-anti-pattern.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/evan_hoff/archive/2007/10/23/the-web-database-anti-pattern.aspx/"
---
I&#8217;m just naming what I&#8217;ve seen over and over again.&nbsp; It&#8217;s&nbsp;the extreme polar opposite of&nbsp;the <a href="http://codebetter.com/blogs/david.hayden/archive/2005/03/29/60806.aspx" target="_blank">Smart UI Anti-Pattern</a>&nbsp;(in terms of layering) and a play on words of the popular&nbsp;term &#8220;Web Application&#8221;.

This anti-pattern most often exposes itself as an asp.net website (or a webservice/remoting tier)&nbsp;which is merely a thin veneer on top of a relational database.&nbsp; Logic may be deeply <a href="http://www.evanhoff.com/archive/2007/06/05/19.aspx" target="_blank">embedded in the database</a> or even very lightly embedded.&nbsp;&nbsp;The key distinguishing feature is the amount of reliance on the database.&nbsp; This may come in the form of direct database access in the asp.net code-behind or in a very thin implementation of Transaction Script.&nbsp; All forms of searching and sorting occur inside the database engine.&nbsp; Application logic rarely goes beyond property-setting and data validation.

While you can successfully build small websites using this anti-pattern, the architectural qualities of an application built with this anti-pattern force it to scale at the database level.&nbsp; At it&#8217;s worst, the database server will max out before the first webserver in load testing.&nbsp; In milder forms, you may get a web server or two in front of the database (but just barely).

From a conceptual standpoint, the data model is seen as &#8220;the one true model&#8221;.&nbsp; Thus any attempts to manipulate or access the model require database roundtrips.&nbsp; In the worst offenders, data validation only occurs through database constraints.

Refactoring an application using this antipattern is very hard to do.&nbsp; The bidirectional relationships available and used in the data model tend to break all attempts at using proper encapsulation when building a corresponding&nbsp;object model.

A team working on such an application should do a skills evaluation first and foremost.&nbsp; I think these types of applications are mostly built&nbsp;in ignorance.&nbsp; The team may have an expert command of css, html, javascript, and t-sql, but lack real exposure to things such as&nbsp;OOA/D&nbsp;and the basic patterns of application architecture.&nbsp; This results in a high number of tactical solutions with very&nbsp;few strategic decisions.

An application with an [anemic domain model](http://martinfowler.com/bliki/AnemicDomainModel.html)&nbsp;has a high&nbsp;probability to&nbsp;exhibit this anti-pattern.

If your application returns datasets from webservices, there is also a&nbsp;very strong probability that it falls prey to this anti-pattern.

If this does describe your application, don&#8217;t feel too bad.&nbsp; I&#8217;ve built plenty of these in my past (which is why I can recognize them pretty easily).&nbsp; It just takes a bit of reading and some practice to grow&nbsp;beyond this style of development.&nbsp; But I would recommend starting down the road to growth&nbsp;ASAP. 🙂