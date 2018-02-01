---
id: 67
title: Storage Size And Performance Implications Of A GUID PK
date: 2009-07-15T14:00:45+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2009/07/15/storage-size-and-performance-implications-of-a-guid-pk.aspx
dsq_thread_id:
  - "262068241"
categories:
  - Data Access
  - Database
---
I sent the same [Guid vs. Int. vs BigInt](http://www.lostechies.com/blogs/derickbailey/archive/2009/07/14/database-id-int-vs-bigint-vs-guid.aspx) question to a group of coworkers yesterday. One of the responses I got was from a DBA, and I thought was worth repeating for the world to hear. Keep in mind that these represent the opinions and research of my coworker, not me. Whether I agree with him or not, is not the point of posting his response for the world to see.

&#8212;&#8212;&#8212;

Just as with most other things, there is no one correct answer.&#160; I am a proponent of natural keys when they make sense.&#160; Occasionally, we find that the natural key of an relation becomes cumbersome to deal with on a regular basis and we opt to utilize a surrogate key.&#160; Surrogate key usage is a different discussion all together regardless of the data type chosen to represent it.

As far as size and scalability… in SQL Server, an int is 4 Bytes and can hold roughly 2 Billion positive unique numbers, bigint is 8 Bytes and can hold about&#160; 9.2 Quintillion (9,223,372,036,854,775,808) positive unique records.

GUIDs are typically 16 Bytes and can store 3.4 X10^38 unique values.&#160; 

There are several arguments for the use of&#160; GUID in databases utilized by applications that we write.&#160; 

  1. You can generate the pk in code.
  2. You don’t have to execute and additional DB call to retrieve the key, post insert.
  3. Should you need to merge databases between different environments, the keys ***should*** not collide
  1. This assumes that some other natural key, represented by a unique index, is not violated.

  4. You all can read the rest of the reasons in [[the article linked](http://nhforge.org/blogs/nhibernate/archive/2009/03/20/nhibernate-poid-generators-revealed.aspx) at NHForge].

That having been said, if you were to have a relation with 500 million records. The following would be true.

&#160;

> <table cellspacing="0" cellpadding="0" border="0">
>   <tr>
>     <td valign="bottom" width="79">
>       <p>
>         <b>Records</b>
>       </p>
>     </td>
>     
>     <td valign="bottom" width="87">
>       <p>
>         <b>PK Data Type</b>
>       </p>
>     </td>
>     
>     <td valign="bottom" width="97">
>       <p>
>         <b>Data Type Size</b>
>       </p>
>     </td>
>     
>     <td valign="bottom" width="68">
>       <p>
>         <b>Size Units</b>
>       </p>
>     </td>
>     
>     <td valign="bottom" width="67">
>       <p>
>         <b>Size of PK</b>
>       </p>
>     </td>
>     
>     <td valign="bottom" width="53">
>       <p>
>         <b>PK Unit</b>
>       </p>
>     </td>
>   </tr>
>   
>   <tr>
>     <td valign="bottom" width="79">
>       <p>
>         500,000,000
>       </p>
>     </td>
>     
>     <td valign="bottom" width="87">
>       <p>
>         Integer
>       </p>
>     </td>
>     
>     <td valign="bottom" width="97">
>       <p>
>         4
>       </p>
>     </td>
>     
>     <td valign="bottom" width="68">
>       <p>
>         Bytes
>       </p>
>     </td>
>     
>     <td valign="bottom" width="67">
>       <p>
>         1.863
>       </p>
>     </td>
>     
>     <td valign="bottom" width="53">
>       <p>
>         GB
>       </p>
>     </td>
>   </tr>
>   
>   <tr>
>     <td valign="bottom" width="79">
>       <p>
>         500,000,000
>       </p>
>     </td>
>     
>     <td valign="bottom" width="87">
>       <p>
>         Big Integer
>       </p>
>     </td>
>     
>     <td valign="bottom" width="97">
>       <p>
>         8
>       </p>
>     </td>
>     
>     <td valign="bottom" width="68">
>       <p>
>         Bytes
>       </p>
>     </td>
>     
>     <td valign="bottom" width="67">
>       <p>
>         3.725
>       </p>
>     </td>
>     
>     <td valign="bottom" width="53">
>       <p>
>         GB
>       </p>
>     </td>
>   </tr>
>   
>   <tr>
>     <td valign="bottom" width="79">
>       <p>
>         500,000,000
>       </p>
>     </td>
>     
>     <td valign="bottom" width="87">
>       <p>
>         GUID
>       </p>
>     </td>
>     
>     <td valign="bottom" width="97">
>       <p>
>         16
>       </p>
>     </td>
>     
>     <td valign="bottom" width="68">
>       <p>
>         Bytes
>       </p>
>     </td>
>     
>     <td valign="bottom" width="67">
>       <p>
>         7.451
>       </p>
>     </td>
>     
>     <td valign="bottom" width="53">
>       <p>
>         GB
>       </p>
>     </td>
>   </tr>
> </table>

&#160;

You can see that there is a significant different in the amount of space required to store a GUID vs Int or BigInt.&#160; Although disk-space is cheap,&#160; ultimately, that equates to physical contiguous blocks on a hard drive platter (until we all move to SS HDD’s) that have to be physically read or skipped during a seek event.&#160; This can have a negative impact on database seeks that require a table scan.&#160; Once the data is located, the GUID also consumes significantly more memory (RAM) during the retrieval…

If you are doing exact (indexed) fetches via the primary key (OLTP transactions), most of those arguments don’t hold water.&#160; Most of what we do **is** OLTP.&#160; In an OLAP environment, I strongly recommend the use of natural keys and the smallest data type available to store the data, for the reasons listed above.&#160; When you truly have a relation with 260 million rows and that needs to be joined with a relation containing 500 million rows, an 8-12 byte increase on one of the columns used in the join (on each row) can bring even a hefty db server to its knees.&#160; The likelihood of this happening in one of our OLTP systems is about the same as the likelihood that a GUID will be duplicated. 🙂

One last thought, db indexes on integer data types are EXTREMELY EFFICIENT, and extremely small.&#160; I honestly don’t know the size difference, but I do know that an index on a GUID is inherently more complex.

Long story short.&#160; Use your brain when you architect these things.&#160; When it makes sense to use a GUID for application architectural reasons, by all means, use them.&#160; However, be aware that the natural keys still exist, and your GUID may need to be done away with in a migration to a large aggregate OLAP reporting system.

&#8212;&#8212;&#8212;

Now, if I could only convince him (and the rest of my company) to blog about these things, on their own! 🙂