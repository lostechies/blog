---
wordpress_id: 419
title: Bulk processing with NHibernate
date: 2010-06-24T13:03:15+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/06/24/bulk-processing-with-nhibernate.aspx
dsq_thread_id:
  - "264716528"
categories:
  - NHibernate
redirect_from: "/blogs/jimmy_bogard/archive/2010/06/24/bulk-processing-with-nhibernate.aspx/"
---
On a recent project, much of the application integration is done through bulk, batch processing.&#160; Lots of FTP shuffling, moving files around, and processing large CSV or XML files.&#160; Everything worked great with our normal NHibernate usage, until recently when we had to process historical transactional data.

The basic problem is that we had to calculate historical customer order totals.&#160; Normally, this would be rather easy to do with a SQL-level bulk update.&#160; However, in our case, we had to process the items one-by-one, as each transaction could potentially trigger an event, “reward earned”.&#160; And naturally, the rules for this trigger are much too complex to attempt to do in straight T-SQL.

This meant that we still had to run our historical feed through the domain model.

A normal, daily drop of customer orders is processed fairly easily.&#160; However, historical data over just the past year totaled close to 5 million transactions, each transaction being a single line in a CSV file.

Since a normal daily file would take about 2 hours to process, we simply could not wait the projected time to process all these transactions.&#160; However, with some handy tips from the twitterverse, we were able to speed things up considerably.

### Bulk import and export

The first thing we found is that if you have to do bulk, set-based processing, it was important to determine if this data is a bulk import, or bulk process.&#160; Bulk import is extremely quick with tools like [SQL Bulk Copy](http://msdn.microsoft.com/en-us/library/ms188609.aspx).&#160; If you need to do a bulk import or export, use the right tool.&#160; A bulk import of these rows into a single table takes about 2.5 minutes, versus days and days one transaction at a time.

In another process we needed to bulk load customer data.&#160; The customer data matched fairly closely to our existing customer table, so we crafted a process that basically followed:

  * Create table to match shape of CSV file
  * Load CSV into table
  * Issue single UPDATE statement to target table with the WHERE clause joining to the CSV-imported table

In this manner we were able to very, very quickly import millions of customer records very quickly.&#160; However, if it’s not straight bulk import or export, we have to go through other channels.

### 

### Optimizing NHibernate for bulk processing

It was a lot of work tinkering with several different ideas, but ultimately the churn was worth it.&#160; Here’s a few tips I picked up along the way:

#### Utilize the Unit of Work pattern and explicit transactions

When I first started, all processing was done with implicit transactions, and copious use of the Flush() method on ISession.&#160; This meant that every. single. save. was in its own transaction.&#160; When you look at the number of roundtrips this entailed, our database was just getting completely hammered.

Additionally, an ISession instance was disposed after every write to the database.&#160; This meant that we could not take advantage of any of the first-level-cache support (aka, [identity map](http://martinfowler.com/eaaCatalog/identityMap.html)) inherent in ISession.

Instead, I switched the codebase to use an actual Unit of Work, where I created a class that controlled the begin, commit and rollback of a unit of work:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IUnitOfWork </span>: <span style="color: #2b91af">IDisposable
</span>{
    <span style="color: #2b91af">ISession </span>CurrentSession { <span style="color: blue">get</span>; }
    <span style="color: blue">void </span>Begin();
    <span style="color: blue">void </span>Commit();
    <span style="color: blue">void </span>RollBack();
    <span style="color: blue">bool </span>IsActive { <span style="color: blue">get</span>; }
}</pre>

[](http://11011.net/software/vspaste)

Before, we really had no control or understanding of the lifecycle of the ISession object.&#160; With this pattern, its lifecycle is tied to the IUnitOfWork, allowing me to take advantage of other NHibernate features.

#### Use MultiCriteria/MultiQuery to batch SELECTs

MultiCriteria and MultiQuery allow you to send multiple SELECTs down the wire.&#160; For each row in our table, we had to issue a SELECT, as processing a single transaction meant I needed to potentially affect the customer record as well as any previous order transaction records.&#160; Doing this one SELECT at a time can be quite chatty, so I batched several together using MultiCriteria.

Just going from 1 at a time to 10 at a time, while insignificant for <100 records, can really add up once you get into the millions.

#### Use statement batching

In addition to SELECTs, we can also batch together INSERTs and UPDATEs.&#160; In our case, we parameterized the processing of the file to a certain batch size (say, 250).&#160; We then enabled NHibernate’s statement batching in the hibernate.cfg file:

<pre><span style="color: blue">&lt;</span><span style="color: #a31515">property </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">adonet.batch_size</span>"<span style="color: blue">&gt;</span>250<span style="color: blue">&lt;/</span><span style="color: #a31515">property</span><span style="color: blue">&gt;</span></pre>

[](http://11011.net/software/vspaste)

And now instead of one INSERT being sent down the line at a time, we send a whole messload at once.&#160; Profiling showed us that statement batching alone dropped the time by 50%.

NHibernate is very, very smart about knowing when and in what order to save things, so as long as items are persistent, we only really need to commit the transaction for the bulk processing to go through.

#### Process bulk updates in batches

Finally, once we had a proper Unit of Work implementation in place, we could now process the giant file as if it were many, smaller files.&#160; We split the incoming work into batches of 250, then created a Unit of Work per batch.&#160; This meant that an entire set of 250 was processed in a single transaction, instead of 5 million individual transactions.

Without a proper Unit of Work in place, we would not be able to do this.

#### Profiling is your friend

Finally, we needed a way to test our processing and the resulting speed improvements.&#160; A simple automated test with stop watches in place let us tinker with the internals and observer the result.&#160; With tools like [NHProf](http://nhprof.com/), we could also observe what extra fetching we might need to do along the way.&#160; Its suggestions also keyed us in to the various improvements we added along the way.

### Wrapping it up

Bottom line is, if you can reduce the operation to a bulk import or export, the SQL tools will be orders of magnitude faster than processing one at a time.&#160; But if you’re forced to go through your domain model and NHibernate, just be aware that your normal NHibernate usage will not scale.&#160; Instead, you’ll need to lean on some of the built-in features that you don’t normally use to really squeeze as much performance as you can.