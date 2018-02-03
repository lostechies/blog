---
wordpress_id: 66
title: 'Database ID: Int vs. BigInt vs. GUID'
date: 2009-07-14T14:30:46+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/07/14/database-id-int-vs-bigint-vs-guid.aspx
dsq_thread_id:
  - "262726731"
categories:
  - Data Access
  - Principles and Patterns
---
I’ve been hearing a lot of talk about using a GUID as a database row ID, in recent months… last night I was talking with [Jeffrey Palermo](http://jeffreypalermo.com/) about this, specifically, and he brought up some interesting points about decoupling the ID of a record from the database implementation. We also talked briefly about scalability of Int vs. BigInt (Int64) vs. Guid, and how any type of replication for scalability would cause the need for a GUID identifier, anyways. Another good point he made was that getting away from a simple number for an ID often helps facilitate discussions of a “natural key” for database records – such as a customer account # that the business assigns – instead of relying 100% on a database generated key.

Then this morning, I round this article: <http://nhforge.org/blogs/nhibernate/archive/2009/03/20/nhibernate-poid-generators-revealed.aspx>, which basically says that we should avoid using “Native” (SQL Server) or “Sequence” (Oracle) ID generators with NHibernate, and goes into some good detail about why.

So, I wanted to toss this idea out to the world and ask, what are your thoughts? What Primary Key data type do you prefer, and why? What are the benefits and drawbacks of using a GUID, over your current favorite?

I’m beginning to lean toward using GUIDs, personally…