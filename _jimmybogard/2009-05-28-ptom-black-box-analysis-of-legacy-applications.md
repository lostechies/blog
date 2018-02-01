---
id: 318
title: 'PTOM: Black-box analysis of legacy applications'
date: 2009-05-28T03:20:33+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/05/27/ptom-black-box-analysis-of-legacy-applications.aspx
dsq_thread_id:
  - "264716166"
categories:
  - LegacyCode
---
It seems like such a great situation, you’ve been tasked with replacing an old legacy system with a shiny new Web 3.0 AJAX-ified replacement.&#160; It’s your chance for the limelight as the knight in shining armor to come charging in with a new system that will \*surely\* blow away the old one.&#160; That is, until you get mired in the problem of requirements coming in of “make it work like the other system”.

As a consultant, it can take quite a while to extract what “success” means, especially as you might have so many different roles with widely differing opinions of what the new system should do.&#160; The CIO wants whatever the buzzword of the month is, probably SOA or “Services”.&#160; The sales team wants something “frickin sweet” and “snazzy”, while the IT department likely hates your guts, as you’re replacing the system they built.&#160; Talk to the people actually _using_ the existing system, and they probably hate it, but don’t want to change.&#160; Listen solely to them and you’ll get another mainframe application, developed in .NET.

With a large existing system, replacing what already exists can’t come in one fell swoop.&#160; Often, you’ll need to carve out subsystems of functionality, each of which likely needed its own system to begin with.&#160; I never fault the original developers of these systems, as many were built at least 10 years ago, some 20.&#160; It’s hard to build an application to last 20 years, especially if your business grows beyond what anyone might have imagined.

Back to replacing a legacy system, we have to understand what the existing Godillapp does.&#160; Recently, I worked on a project to replace a large chunk of a huge legacy system.&#160; Some stats of the existing codebase were:

  * 1 million lines of SQL
  * 1.2 million lines of COBOL….NET
  * 800K lines of VB.NET

This system did _everything_ and was the lifeblood of a billion-dollar corporation.&#160; Of course, it wasn’t a billion-dollar corporation when the system was first written 20 years ago, and “replaced” 5 years ago, but it did take the company a long way.&#160; As a part of this experience, we gained a few nuggets and strategies for dealing with these types of engagements in the future, and what follows is a list of those lessons learned.

### 

### Lesson #1 – What it does versus how it’s used

When we talked to various people about this application, we encountered two different stories.&#160; One was from stakeholders who created the application, and one was from the people who used it.&#160; The people who created it could tell us exactly what the application did.&#160; They talked about major areas, features, database tables, screens and so on.

But one thing was missing – how did people _use_ the system?&#160; For that, we talked to the actual end users.

Which showed a completely different story.&#160; There was a lot of “[swivel chair](http://bill-poole.blogspot.com/2008/05/swivel-chair-integration-is-bad.html)” integration going on, and users’ cubicles were covered in little post-it notes, cheat sheets and reference guides to serve as a living instruction manual.&#160; Does that customer have a discount?&#160; Well, put a note in the order comments field so that Cheryl in accounting remembers to note that in the invoice.&#160; These insights into end-user behavior gave us knowledge that merely looking at the application, code and database would have obscured and even misled.&#160; This, combined with input from all stakeholders, along with vision of where the company wanted the application to go, gave us direction into the system we needed to build.

But we still needed to replicate existing functionality.

### Lesson #2 – Craft your own story of the data

The application’s database was about the most interesting I’d ever seen.&#160; It was ported from a mainframe, pretty much straight over.&#160; This meant:

  * Lots of fixed-width columns
  * No referential integrity
  * Evolving architectural style

For the core tables, we might have OLD\_NMNG\_OF\_CLMNS, where as new tables followed tbl\_hungarian notation.&#160; To get around this, we exported the schema into an entirely new database, and created associations between tables as we found them.&#160; We didn’t bother with all of the original columns, just associations, so that we could understand what related to what.&#160; We couldn’t modify the existing database, but a playground of just the schema let us create reference diagrams of the “real” relationships of the tables.

Next, we created searchable schema.&#160; We created a table that included:

  * Database name
  * Table name
  * Column name
  * Column data type

Yes, I know this was available from the schema views, but we needed something that was super simple to query from.&#160; With a system of hundreds and hundreds of tables, it helped to do things like “SELECT * FROM dbSchema WHERE colname LIKE ‘%PRODUCT_NUM%’”.&#160; We didn’t know what was related to a product, but we could make an educated guess.&#160; Since the original database had zero foreign key constraints and thousands of stored procedures, we needed to be able to take large guesses of how data was related to each other.&#160; Existing developers might be able to give us direction, but with a system this big, we could only really rely on the actual system.

### Lesson #3 – The data don’t lie

This one’s from the phrase “[ball don’t lie](http://www.urbandictionary.com/define.php?term=ball%20don%27t%20lie)”.&#160; You come to the business owners and ask, “what shipping codes do we need to support?”.&#160; The answer is “all of them”.&#160; There aren’t that many shipping services in the world, yet you find a hundred different ship codes in the database lookup table.&#160; Do you really need to support all of these shipping codes?&#160; Probably not.

But to answer this, we need to gather more information on what these values mean.&#160; Are some of these just test shipping codes that some developer put in the system six years ago?&#160; Are some for obsolete shipping methods?&#160; Again, we turned to analyzing the existing data.&#160; It took a long time to run this batch process (around 4 hours), but we crafted another table that contained:

  * Column name
  * Column value
  * Number of occurrences
  * Percentage of total
  * Last date of value

Essentially, we would group a table by a column, one by one, gathering statistics on how much each value was used, and when it was last used.&#160; This gave us the hard data that said, “see that code ‘OC4’? It was last used 5 years ago, and only twice”.&#160; With that information, we could dive in to the original database, and find that the person who created these orders was “Cosmo Kramer”.&#160; With this information, we could figure out exactly what kinds of things we needed to support.

Additionally, we were able to provide hard data on who used what features.&#160; We might find a certain shipping code used only 100 times, a fraction of the total, but these were used by one of the company’s biggest customers, so it suddenly jumped in importance.&#160; It was still the customer who decided what to support, but we were able to give them a much, much better picture of the data than many of their seasoned veterans did not know.

If you can’t run a big batch data mining process against the database, I suggest you learn two SQL techniques: the GROUP BY clause, and derived tables.&#160; The general idea is to first create an inner query where you group by values, and then an outer query that performs additional grouping and statistics.&#160; This gives you quick information like “what percentage of total orders used the OC4 shipping code?”&#160; Very useful information for decision makers.

### Lesson #4 – Profile, profile, profile

In a codebase that’s large enough, debugging code is counterproductive.&#160; Instead, we can take the route of poking an application on one side, and seeing what comes out the other, while listening in to the conversation using a SQL profiler (or network profiler).&#160; In this manner, we can do things like add a line item to an order, and see how the application performs that operation.&#160; In one example, we added a single line item to an order and over 280 queries executed to perform that one operation.

We might find common stored procedure names, and go back the code armed with a textual search to see exactly what code was executed.&#160; While the SQL codebase had over a million lines, profiling told us that only a fraction of this was actually used.&#160; Because there was no database change management system in place, we saw a hundred different sprocs to retrieve an order.&#160; Instead of using an existing sproc, it was easier just to create a new one.

As we profiled more and more, we combined this knowledge back into our metadata database, adding comments to what the purpose of each table was.&#160; The list of “important” tables was eventually whittled down to what you might expect, and many were just a bunch of features that never panned out, cancelled projects and so on.&#160; With all of our information, we could almost look backwards in time to see the entire history of the company.

### Lesson #5 – Dump the negativity

Although it’s easy to trash-talk the existing system, it won’t make you any friends with the existing IT folks.&#160; No one likes having their baby called ugly, even it fell off the ugly tree and hit every branch on the way down.&#160; You don’t know the political situations for the last 20 years, nor the different forces at play.&#160; These systems put a lot of food on a lot of people’s plate, but no longer help the company grow.&#160; The only thing you can criticize is a failure to recognize when the existing system no longer matches the company’s needs.&#160; Other than that, best to keep positive, stay focused on delivering value, and just \*quietly\* make notes for future Daily WTF contributions.

### Wrapping it up

Replacing a legacy system is costly and risky.&#160; Anyone involved with projects like these can attest to the frequency of failures in this arena.&#160; But armed with a well-thought out strategy, we can maximize the possibility of success.&#160; Nothing’s guaranteed of course, but at the very least, we’ll have vastly increased the knowledge of the existing system.