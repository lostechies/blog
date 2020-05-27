---
title: 'Getting started with Cassandra: Data modeling in the brief'
date: 2020-02-05T20:23:00+00:00
author: Ryan Svihla
layout: post
categories:
  - cassandra
---
# Getting started with Cassandra: Data modeling in the brief

Cassandra data modeling isn't really something you can do "in the brief" and is itself a subject that can take years to fully grasp, but this should be a good starting point.

## Introduction

Cassandra distributes data around the cluster via the _partition_ _key_.

```sql
CREATE TABLE my_key.my_table_by_postal_code (postal_code text, id uuid, balance float, PRIMARY KEY(postal_code, id));
```

In the above table the _partition_ _key_ is `postal_code` and the _clustering_ _column_ is`id`. The _partition_ _key_ will locate the data on the cluster for us. The clustering column allows us multiple rows per _partition_ _key_ so that we can filter how much data we read per partition.
The 'optimal' query is one that retrieves data from only one node and not so much data that GC pressure or latency issues result. The following query is breaking that rule and retrieving 2 partitions at once via the IN parameter.

```sql
SELECT * FROM my_key.my_table_by_postal_code WHERE postal_code IN ('77002', '77043');
```

This _can_ _be_ slower than doing two separate queries asynchronously, especially if those partitions are on two different nodes (imagine if there are 1000+ partitions in the IN statement). In summary, the simple rule to stick to is "1 partition per query".

### Partition sizes

A common mistake when data modeling is to jam as much data as possible into a single partition.

* This doesn't distribute the data well and therefore misses the point of a distributed database.
* There are practical limits on the [performance of partition sizes](https://issues.apache.org/jira/browse/CASSANDRA-9754)

### Table per query pattern

A common approach to optimize around partition lookup is to create a table per query, and write to all of them on update. The following example has two related tables both to solve two different queries

```sql
--query by postal_code
CREATE TABLE my_key.my_table_by_postal_code (postal_code text, id uuid, balance float, PRIMARY KEY(postal_code, id));
SELECT * FROM my_key.my_table_by_postal_code WHERE postal_code = '77002';
--query by id
CREATE TABLE my_key.my_table (id uuid, name text, address text, city text, state text, postal_code text, country text, balance float, PRIMARY KEY(id));
SELECT * FROM my_key.my_table WHERE id = 7895c6ff-008b-4e4c-b0ff-ba4e4e099326;
```

You can update both tables at once with a logged batch:

```sql
BEGIN BATCH
INSERT INTO my_key.my_table (id, name, address, city, state, postal_code, country, balance) VALUES (7895c6ff-008b-4e4c-b0ff-ba4e4e099326, 'Bordeaux', 'Gironde', '33000', 'France', 56.20);
INSERT INTO my_key.my_table_by_postal_code (postal_code, id, balance) VALUES ('33000', 7895c6ff-008b-4e4c-b0ff-ba4e4e099326, 56.20) ;
APPLY BATCH;
```

### Source of truth

A common design pattern is to have one table act as the authoritative one over data, and if for some reason there is a mismatch or conflict in other tables as long as there is one considered "the source of truth" it makes it easy to fix any conflicts later. This is typically the table that would match what we see in typical relational databases and has all the data needed to generate all related views or indexes for different query methods. Taking the prior example, `my_table` is the source of truth:

```sql
--source of truth table
CREATE TABLE my_key.my_table (id uuid, name text, address text, city text, state text, postal_code text, country text, balance float, PRIMARY KEY(id));
SELECT * FROM my_key.my_table WHERE id = 7895c6ff-008b-4e4c-b0ff-ba4e4e099326;

--based on my_key.my_table and so we can query by postal_code
CREATE TABLE my_key.my_table_by_postal_code (postal_code text, id uuid, balance float, PRIMARY KEY(postal_code, id));
SELECT * FROM my_key.my_table_by_postal_code WHERE postal_code = '77002';
```

Next we discuss strategies for keeping tables of related in sync.

### Materialized views

Materialized views are a feature that ships with Cassandra but is currently considered rather experimental. If you want to use them anyway:

```sql
CREATE MATERIALIZED VIEW my_key.my_table_by_postal_code 
AS SELECT postal_code text, id uuid, balance float
FROM my_key.my_table 
WHERE postal_code IS NOT NULL AND id IS NOT NULL 
PRIMARY KEY(postal_code, id));
```

Materialized views at least run faster than the comparable BATCH insert pattern, but they have a number of bugs and known issues that are still pending fixes.

### Secondary indexes

This are the original server side approach to handling different query patterns but it has a large number of downsides:

* rows are read serially one node at time until limit is reached.
* a suboptimal storage layout leading to very large partitions if the data distribution of the secondary index is not ideal.

For just those two reasons I think it's rare that one can use secondary indexes and expect reasonable performance. However, you can make one by hand and just query that data asynchronously to avoid some of the downsides.

```sql
CREATE TABLE my_key.my_table_by_postal_code_2i (postal_code text, id uuid, PRIMARY KEY(postal_code, id));
SELECT * FROM my_key.my_table_by_postal_code_2i WHERE postal_code = '77002';
--retrieve all rows then asynchronously query the resulting ids
SELECT * FROM my_key.my_table WHERE id = ad004ff2-e5cb-4245-94b8-d6acbc22920a;
SELECT * FROM my_key.my_table WHERE id = d30e9c65-17a1-44da-bae0-b7bb742eefd6;
SELECT * FROM my_key.my_table WHERE id = e016ae43-3d4e-4093-b745-8583627eb1fe;
```

## Exercises

### Contact List

This is a good basic first use case as one needs to use multiple tables for the same data, but there should not be too many.

#### requirements

* contacts should have first name, last name, address, state/region, country, postal code
* lookup by contacts id
* retrieve all contacts by a given last name
* retrieve counts by zip code

### Music Service

Takes the basics from the previous exercise and requires a more involved understanding of the concepts. It will require many tables and some difficult trade-offs on partition sizing. There is no one correct way to do this.

#### requirements

* songs should have album, artist, name, and total likes
* The contact list exercise, can be used as a basis for the "users", users will have no login because we're trusting people
* retrieve all songs by artist
* retrieve all songs in an album
* retrieve individual song and how many times it's been liked
* retrieve all liked songs for a given user
* "like" a song
* keep a count of how many times a song has been listened to by all users

### IoT Analytics

This will require some extensive time series modeling and takes some of the lessons from the Music Service further. The table(s) used will be informed by the query.

#### requirements

* use the music service data model as a basis, we will be tracking each "registered device" that uses the music service
* a given user will have 1-5 devices
* log all songs listened to by a given device
* retrieve songs listened for a device by day
* retrieve songs listened for a device by month
* retrieve total listen time for a device by day
* retrieve total listen time for a device by month
* retrieve artists listened for a device by day
* retrieve artists listened for a device by month
