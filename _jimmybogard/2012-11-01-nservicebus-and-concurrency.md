---
wordpress_id: 685
title: NServiceBus and concurrency
date: 2012-11-01T16:57:10+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=685
dsq_thread_id:
  - "910018669"
categories:
  - NHibernate
  - NServiceBus
---
A while back, [Andreas](http://andreasohlund.net/) posted on [NServiceBus sagas and concurrency](http://andreasohlund.net/2012/09/19/nservicebus-sagas-and-concurrency/). In that post, he described both what to consider and how to change the concurrency model of NServiceBus and how it relates to sagas.

One thing that comes as a surprise to those new to NServiceBus (it was to me) is that [the default transaction isolation level that System.Transactions uses](http://msdn.microsoft.com/en-us/library/system.transactions.isolationlevel.aspx) is the highest level, Serializable. For a lot of applications, this is quite a bit of overkill.

Just to review the different IsolationLevel values:

Serializable </p> 
:   Volatile data can be read but not modified, and no new data can be added during the transaction. </p> 
    
    RepeatableRead </p> 
    
    :   Volatile data can be read but not modified during the transaction. New data can be added during the transaction. </p> 
        
        ReadCommitted </p> 
        
        :   Volatile data cannot be read during the transaction, but can be modified. </p> 
            
            ReadUncommitted </p> 
            
            :   Volatile data can be read and modified during the transaction. </p> 
                
                Snapshot </p> 
                
                :   Volatile data can be read. Before a transaction modifies data, it verifies if another transaction has changed the data after it was initially read. If the data has been updated, an error is raised. This allows a transaction to get to the previously committed value of the data. </p> 
                    
                    Chaos </p> 
                    
                    :   The pending changes from more highly isolated transactions cannot be overwritten. </p> 
                        
                        Unspecified </p> 
                        
                        :   A different isolation level than the one specified is being used, but the level cannot be determined. An exception is thrown if this value is set. </dl> 
                        
                        This is slightly more generic for than the [SQL Server description of these isolation levels](http://msdn.microsoft.com/en-us/library/ms173763.aspx). Looking at those statements, Serializable is likely not what we want. It’s the safest of all the levels, achieved by sacrificing concurrency. But with NServiceBus, we have the ability to scale our endpoints both up and out. In order to scale, we’ll need to revisit our concurrency strategy.
                        
                        ### 
                        
                        ### Choosing an isolation level
                        
                        The nice thing about isolation levels in NServiceBus is that you can tune these on an endpoint basis. If you have messages that require different concurrency needs, you’re better off putting those in their own endpoint as those messages likely have different SLAs than ones with other concurrency needs. To override the isolation level for a given endpoint, just use the IsolationLevel configuration method:
                        
                        [gist id=3993938]
                        
                        But I wouldn’t just choose an isolation level at random, it’s something we should carefully consider. In fact, if you expect to have any sort of concurrent users against a single entity, it’s wise to be explicit about your concurrency model. Having gone through the exercise of choosing an isolation level, I start to wonder if it shouldn’t always be explicit, no matter what your application (unless handled for you automatically by the underlying frameworks).
                        
                        In my system, concurrent users do access the same entities. Read Committed is a sensible default for these scenarios, as it prevents someone accessing a row I’m changing or access data that I’ve read (preventing dirty reads):
                        
                        > Specifies that statements cannot read data that has been modified but not committed by other transactions. This prevents dirty reads. Data can be changed by other transactions between individual statements within the current transaction, resulting in nonrepeatable reads or phantom data. This option is the SQL Server default.
                        
                        However, if we’re using ORMs, we can go to an even further to use the [built-in concurrency models](http://nhforge.org/blogs/nhibernate/archive/2009/04/14/nhibernate-mapping-concurrency.aspx) to further tune our isolation levels.
                        
                        With optimistic locking at the application level, tied with relaxed transaction isolation levels, we were able to fairly easily boost the performance of our system. In our case, we were able to go with Read Uncommitted and the optimistic concurrency strategy of using a [SQL rowversion column](http://msdn.microsoft.com/en-us/library/ms182776(v=sql.110).aspx) (only for entities that were truly mutable), allowing us to increase the number of concurrent threads in our endpoints from 1 each to 4 each.
                        
                        Choosing a concurrency strategy requires careful analysis and planning. Changing the models are quite easy, but it’s choosing that’s the difficult part.