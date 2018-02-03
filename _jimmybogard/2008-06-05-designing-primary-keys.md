---
wordpress_id: 192
title: Designing primary keys
date: 2008-06-05T02:01:12+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/06/04/designing-primary-keys.aspx
dsq_thread_id:
  - "264715767"
categories:
  - DomainDrivenDesign
  - SQL
---
When creating a primary key for a table, we have a few options:

  * Composite key 
      * Natural key 
          * Surrogate key</ul> 
        Each has their own advantages and disadvantages, but by and large I always wind up going with the last option.
        
        ### Composite keys
        
        Composite keys are primary keys made up of multiple columns.&nbsp; For example, consider a system with and Order and LineItem table:  ![](http://grabbagoftimg.s3.amazonaws.com/PrimaryKeys_Composite.PNG)
        
        The LineItems table has an identity that is composed of two columns: the OrderID and the ProductID.&nbsp; This makes sense in that an Order can only have one LineItem per Product.
        
        The problem happens when I need to make a table that has a foreign key relationship to the LineItems table:
        
        ![](http://grabbagoftimg.s3.amazonaws.com/PrimaryKeys_Composite2.PNG)
        
        Blech! Now our composite key is invading every table that relates to it.&nbsp; Order is a natural aggregate root, but what happens if we decide later down the line that a LineItem is a standalone concept?
        
        I&#8217;ve seen this a few times in databases I&#8217;ve created and some legacy ones.&nbsp; You assume that a row&#8217;s identity is defined by its parent, but later it begins to have a life of its own.
        
        Unless the table is a junction table (one that holds a many-to-many relationship), and it doesn&#8217;t have and attributes of its own, a single primary key is the safest bet.
        
        ### Natural keys
        
        Ugh.
        
        Please don&#8217;t continue this (worst) practice going forward.&nbsp; Natural keys are keys with business uniqueness, such as Social Security Number, Tax ID, Driver&#8217;s License Number, etc.
        
        Besides performance issues with data like these as keys, one thing to keep in mind is that **an entity&#8217;s identity can never change**, from now until the end of time.
        
        Things like SSN&#8217;s and such are likely entered by humans.&nbsp; Ever mistype something?&nbsp; If something needs to be unique, there are other ways besides a primary key to ensure uniqueness.
        
        ### Surrogate keys
        
        Surrogate keys are computer-generated keys that likely have no meaning, or might never be shown to the end user.&nbsp; Typical types are seeded integers and GUIDs.
        
        Personally, I prefer GUIDs as they&#8217;re guaranteed to only to be unique to the table, but globally unique (it&#8217;s in the name for pete&#8217;s sake!)&nbsp; [Combed GUIDs](http://www.informit.com/articles/article.aspx?p=25862) provide comparable performance to integers or longs, as well as the added benefit that they can be created by the application instead of the database.&nbsp; GUIDs also play very nicely in replication scenarios.
        
        You can still use natural key information, such as SSN, to identify or search for a particular record, but a surrogate key ensures uniqueness and performance.
        
        ### Frankenstein keys
        
        Unfortunately I have found another kind of primary key: the Frankenstein key.&nbsp; Here&#8217;s a small taste: ![](http://grabbagoftimg.s3.amazonaws.com/PrimaryKeys_Frank.PNG)
        
        Hmmm&#8230;let&#8217;s see, a CUSTOMER table, an ADDRESS\_MASTER table, and one table that should join the two together, the CUST\_ADDR\_DTL.&nbsp; But it doesn&#8217;t have any foreign key relationships to the two tables it should have, it has a cryptic CUST\_ADDR_NO column instead.
        
        Looking at the data reveals a mind-boggling design:
        
        <pre>CUST_NUM
----------
     89480

ADDR_KEY
----------
    441839

CUST_ADDR_NO
--------------------
89480         441839
</pre>
        
        [](http://11011.net/software/vspaste)
        
        Wow.&nbsp; Fixed-length column values aren&#8217;t new, especially in databases ported from mainframes.&nbsp; The last value, instead of having two columns in a composite key, just jams both foreign key values into one single Frankenstein column.
        
        Just about the ugliest thing I&#8217;d ever seen, until I saw a SELECT statement, with where clauses using string functions to parse out the individual values.
        
        ### Surrogate GUIDs by default
        
        It doesn&#8217;t cost anything, and it&#8217;s the easiest and simplest choice to make going forward.&nbsp; Composite keys can still be represented as foreign keys and unique constraints, but it&#8217;s tough to add identity later.
        
        Not to mention, domain models look pretty terrible and are quite brittle with composite keys.&nbsp; As any system is so much more than data it contains, why not go with surrogate keys, which give so much flexibility to your design?