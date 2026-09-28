---
wordpress_id: 780
title: Eventual consistency in REST APIs
date: 2013-05-15T19:57:08+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=780
dsq_thread_id:
  - "1290920616"
categories:
  - REST
---
Not picking on an API in particular, but…wait, yes I am. Octopus (an awesome product) has a proposed API on GitHub, and one of the things it describes is [how to deal with the fact that the backend is built on top of Raven DB](https://github.com/OctopusDeploy/OctopusDeploy-Api/blob/master/sections/links.md#collections), where eventual consistency its default mode for index results.

In it, the proposal includes an “IsStale” flag on the collection, as well as on the query itself, so you could do something like:

GET /api/environments?nonstale=true

Or similar. This presents a rather weird choice to the end user of the API – consistency as a choice, not on mutating operations (PUT/POST/DELETE) but on idempotent GET operations. I presume that this will use the “[WaitForNonStaleResults](http://ravendb.net/docs/2.0/client-api/querying/stale-indexes)” behavior of RavenDB – but this isn’t really something I’d expect to directly expose to clients.

Without directly exposing our persistence mechanism to our clients (i.e., what if we switched to SQL Server? Redis as a write-through cache to MondoDB? and so on), we have a number of options of dealing with eventual consistency in our REST APIs.

### Option 1: Do nothing

**The easiest approach for our API is to simply not care**. Non-stale results should only really appear when we’re dealing with queries and collections – if you’re dealing with stale resources from GET actions directly against a resource, you’ve really got a weird interaction model.

Looking at some other APIs, like Netflix or GitHub or Trello, you don’t really see any option for influencing the consistency choice on a read.

So we could just ignore it. This is what a lot of APIs do, accept the POST/PUT/DELETE, and make sure that my resource itself is affected correctly. If I do a DELETE /users/jbogard and then a GET /users/jbogard, I expect a 404. But if I query users or search them, then I might not expect those results to be reflected in that model. I can be explicit in this by having search be a completely separate set of resources/entry point (i.e. /search?entity=users&name=jbogard), so it’s completely explicit that search/query is different than interacting with resources.

This is similar to how a library with a card catalog might work. Do I synchronize the activity of checking out a book with checking the catalog? Or might someone have grabbed the book from when I checked the card catalog? Or do I have someone hold the card while checking out a book?

What I don’t do is allow a person looking for a book to either be disappointed OR have the choice of yelling out to everyone in the library, “DOES ANYONE HAVE THIS BOOK OR IS OTHERWISE WANTING TO CHECK THIS BOOK OUT”. I fix my interaction model and just be up front about it.

### Option 2: Provide feedback on consistency results

Instead of just punting on whether or not the collection/query is stale, we might provide that as feedback. We could return dates of last update, things like “results as of mm/dd/yyyy”. We often do this on printable reports so that when people print a report (and it is now preeeeeetty much as stale as it gets), we can include a timestamp of when it was printed so that anyone looking at it is informed of how fresh the data is.

Just a tidbit of information to the end user to let them know if their results are up to date or not. If the client made a mutating operation, they can compare the date of this mutation with the date on the query results to make a simple decision to query again, or just move on as planned. Again, the power is in the client not to affect how we query, but what decisions they can make.

### 

### Option 3: Return a 202 ACCEPTED status

If we really want to model an asynchronous operation in our REST API, we can look to the HTTP status codes to communicate this explicitly to our clients. We do this in a couple of places where processing is too expensive in the context of a request, so we return a 202 to let clients know that “we got your request, but it’s not getting processed at this moment.” The [description from the W3C reads](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#10.2.3):

> The request has been accepted for processing, but the processing has not been completed. The request might or might not eventually be acted upon, as it might be disallowed when processing actually takes place. There is no facility for re-sending a status code from an asynchronous operation such as this. 
> 
> The 202 response is intentionally non-committal. Its purpose is to allow a server to accept a request for some other process (perhaps a batch-oriented process that is only run once per day) without requiring that the user agent&#8217;s connection to the server persist until the process is completed. The entity returned with this response SHOULD include an indication of the request&#8217;s current status and either a pointer to a status monitor or some estimate of when the user can expect the request to be fulfilled.

We can return a pointer to an indication of the current status, or some estimate of completion. But we’re being 100% up front that your request is processed asynchronously. 

This is similar to any long-running transaction. You place an order at a fast-food restaurant, and are given a correlation identifier that represents your order. You can come back and ask the status of your order at any time. But the cashier certainly doesn’t cook our order while we’re standing in line! 

### Option 4: Write-through cache

If these operations are expected to succeed (or we verify that the transactional write has succeeded), we can do a simple trick that a lot of high-volume websites do. If we don’t have an AP-system like Dynamo (choosing availability and partitionability over consistency), we might choose consistency instead. To do so, we can cache index results, and write our updated value to that store along with our regular persistent store.

It’s not the most exciting of options, but if we know that writes are much less frequent than reads (and we’re not partitioning, i.e. we pick CA of CAP), then it’s not too far-fetched to write to both our cache and our document store.

Of course, if this is all to force us to bypass our consistency model of the database we’ve chosen, it’s a lot of work. But still, it’s an option nonetheless.

### 

### Option 5: Choose a database that matches our consistency needs

If we don’t like the consistency model that our database provides, or we feel like we want to allow clients to choose a consistency model, we might view this as a case where we’ve simply chosen the wrong model. If clients NEED consistency, why not pick something that gives that to them? Or don’t allow them to choose.

This would be like, on writes, allowing clients that interact with a database that uses a relational model to also indicate the isolation level on writes. That’s something that should really be encapsulated by the operation, and made with SLAs and contracts about the behavior.

### Conclusion

We have a lot of options here, and all are valid in some scenarios. In each example, we’ve chosen a consistency model that matches our needs, rather than have a compromised consistency model exposed from our database of choice. Before Amazon put out their Dynamo paper, it’s not like us as users of the website knew that this storage system existed in the back end. It was encapsulated. The most we could do was “Ctrl+F5” to force a request back to their servers, but that still had no real guarantees.

Instead of letting our database leak its consistency model to our API, it’s better to choose a model that makes this consistency model explicit, or offer no guarantees at all. But as a rule, I as a consumer should not care that you’ve chosen Raven DB instead of SQL Server for your back end. It’s just none of my business.