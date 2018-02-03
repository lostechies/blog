---
wordpress_id: 350
title: 'DDD: Repository Implementation Patterns'
date: 2009-09-03T01:00:32+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/09/02/ddd-repository-implementation-patterns.aspx
dsq_thread_id:
  - "264716301"
categories:
  - DomainDrivenDesign
---
One of the major structural patterns encountered in DDD (and one of the most argued about) is the [Repository pattern](http://martinfowler.com/eaaCatalog/repository.html).&#160; You’ve created a persistent domain model, and now you need to be able to retrieve these objects from an encapsulated store.&#160; In Fowler’s PoEAA, the Repository pattern is described as:

> _Mediates between the domain and data mapping layers using a collection-like interface for accessing domain objects_.

In many DDD implementations, the use of a Repository is widened to go beyond retrieval, but the other pieces in the CRUD acronym.&#160; This is natural, as a Repository provides a centralized facade over some backing store, whether that backing store is a database, XML, SOAP, REST and so on.&#160; But what about the actual interface of the Repository?&#160; What kinds of options do we have for designing the actual Repository itself?&#160; There are quite a few different schools of thought here, each with their own benefits and drawbacks.

### The Generic Repository Interface

In the generic repository interface, the interface definition itself is generic, with implementations for individual entity types.&#160; The generic type parameter denotes the entity type of the repository.&#160; One example is in S#arp Architecture:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IRepositoryWithTypedId</span>&lt;T, IdT&gt;
{
    T Get(IdT id);

    <span style="color: #2b91af">IList</span>&lt;T&gt; GetAll();

    <span style="color: #2b91af">IList</span>&lt;T&gt; FindAll(<span style="color: #2b91af">IDictionary</span>&lt;<span style="color: blue">string</span>, <span style="color: blue">object</span>&gt; propertyValuePairs);

    T FindOne(<span style="color: #2b91af">IDictionary</span>&lt;<span style="color: blue">string</span>, <span style="color: blue">object</span>&gt; propertyValuePairs);

    T SaveOrUpdate(T entity);

    <span style="color: blue">void </span>Delete(T entity);

    <span style="color: #2b91af">IDbContext </span>DbContext { <span style="color: blue">get</span>; }
}</pre>

[](http://11011.net/software/vspaste)

If you want a repository for a specific type of entity, you create a derived type, closing the interface type with the entity:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">ICustomerRepository </span>: <span style="color: #2b91af">INHibernateRepositoryWithTypedId</span>&lt;<span style="color: #2b91af">Customer</span>, <span style="color: blue">string</span>&gt;
{
    <span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; FindByCountry(<span style="color: blue">string </span>countryName);
}</pre>

[](http://11011.net/software/vspaste)

Note that this repository supplies an additional, specialized query method for a specific find method.&#160; The nice thing about a generic repository interface is that a corresponding base repository implementation can be designed so that all of the data access code that doesn’t change from repository to repository can have a place to live.&#160; The actual implementation can then rely on a common base implementation for the non-changing behavior:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomerRepository </span>: <span style="color: #2b91af">NHibernateRepositoryWithTypedId</span>&lt;<span style="color: #2b91af">Customer</span>, <span style="color: blue">string</span>&gt;, <span style="color: #2b91af">ICustomerRepository
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt; FindByCountry(<span style="color: blue">string </span>countryName) {
        <span style="color: #2b91af">ICriteria </span>criteria = Session.CreateCriteria(<span style="color: blue">typeof</span>(<span style="color: #2b91af">Customer</span>))
            .Add(<span style="color: #2b91af">Expression</span>.Eq(<span style="color: #a31515">"Country"</span>, countryName));

        <span style="color: blue">return </span>criteria.List&lt;<span style="color: #2b91af">Customer</span>&gt;() <span style="color: blue">as </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Customer</span>&gt;;
    }
}</pre>

[](http://11011.net/software/vspaste)

But, we still get the type safety of generics.&#160; However, we tend to muddy the contract of the ICustomerRepository a little if our entity does not support all of the operations of the base repository interface.&#160; It’s basically a sacrifice of a common base implementation that you violate the Interface Segregation Principle for some simplification on the implementation side.&#160; For example, in my current domain, deleting an entity has legal ramifications, so we basically don’t allow it for quite a few entities.&#160; Instead, things are marked as various stages of “soft” deletes.

One big benefit is that most modern IoC containers allow configuring the container such that the most derived type of IRepository<T> can be resolved.&#160; I can ask the container for IRepository<Customer>, and the CustomerRepository implementation is returned.&#160; This is especially helpful in APIs where we might abstract “saving” to some base layer.&#160; Again, the downside is that our interface has methods to support every operation, whether we actually _want_ to support them or not.

### The Generic Method Repository

In the generic method repository, our repository implementations do not expose methods for specific queries.&#160; Additionally, no specific repository for an entity is defined.&#160; Instead, only general-purpose methods are exposed for querying, persisting and retrieval.&#160; The methods are generic, providing type safety, but there is only one implementation.&#160; Consider the Alt.Oxite repository implementation from FubuMVC Contrib:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IRepository
</span>{
    <span style="color: blue">void </span>Save&lt;ENTITY&gt;(ENTITY entity)
        <span style="color: blue">where </span>ENTITY : <span style="color: #2b91af">DomainEntity</span>;

    ENTITY Load&lt;ENTITY&gt;(<span style="color: #2b91af">Guid </span>id)
        <span style="color: blue">where </span>ENTITY : <span style="color: #2b91af">DomainEntity</span>;

    <span style="color: #2b91af">IQueryable</span>&lt;ENTITY&gt; Query&lt;ENTITY&gt;()
        <span style="color: blue">where </span>ENTITY : <span style="color: #2b91af">DomainEntity</span>;

    <span style="color: #2b91af">IQueryable</span>&lt;ENTITY&gt; Query&lt;ENTITY&gt;(<span style="color: #2b91af">IDomainQuery</span>&lt;ENTITY&gt; whereQuery)
        <span style="color: blue">where </span>ENTITY : <span style="color: #2b91af">DomainEntity</span>;
}</pre>

[](http://11011.net/software/vspaste)

In this implementation, the repository itself is not generic.&#160; A single repository dependency can perform all needed CRU (not D) operations against any well-known entity.&#160; Because most ORMs nowadays are generic, the implementation of a generic repository is very straightforward, it simply wraps the ORM.&#160; The actual definition of queries is left to something else.&#160; In the above case, LINQ queries utilize the Query method to retrieve persistent objects.

The advantage to this pattern is that we do not need to create an interface for each type of entity we create.&#160; Instead, we remove the responsibility of forming specific queries to the callers, including worrying about fetching, caching, projection and so on.&#160; Since this logic does not change, we don’t have to pull in a repository for every entity we want to retrieve.&#160; Instead, operations flow through one general-purpose interface.

The disadvantage to this pattern is we lose named query methods on our repository, as [Greg pointed out a while back](http://codebetter.com/blogs/gregyoung/archive/2009/01/16/ddd-the-generic-repository.aspx).&#160; The ICustomerRepository from the previous pattern exposed (and encapsulated) a well-known query with a intention-revealing name.&#160; With a generic method repository, there is only one implementation.&#160; Creating a derived ICustomerRepository of a generic method repository would be rather strange, as the base interface allows any entity under the sun.

### The Encapsulated Role-Specific Repository

Classes that use a repository rarely use every method inside of it.&#160; A class that does a query against Customers probably isn’t going to then go delete them.&#160; Instead, we’re likely querying for some other purpose, whether it’s to display information, look up information for business rules, and so on.&#160; Instead of a catch-all repository that exposes every method under the sun, we could alternatively apply the Interface Segregation Principle for role-based interfaces, and define interfaces that expose only what one class needs.&#160; With these repositories, you’ll much more likely find encapsulated query methods, that do not expose the ability to arbitrarily query a backing data store:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IProductRepositoryForNewOrder
</span>{
    <span style="color: #2b91af">Product</span>[] FindDiscontinuedProducts();
}</pre>

[](http://11011.net/software/vspaste)

A single repository implementation implements all Product repository interfaces, but only the single method needed is exposed and used by the caller.&#160; This way, you do not see Save, Delete, and other query operations that you do not care about.&#160; The down side is that this implementation tends to be more difficult to combine with IoC containers, as auto-wiring does not work as expected.&#160; At some point, it starts to look like these types of repositories are glorified query objects, a single class that represents a query.

### 

### Wrapping it up

In our projects, we’ve tended to use the generic repository interface, as it allows us to override implementations for custom behavior.&#160; We still will include a default implementation that gets wired in, a non-abstract RepositoryBase<T>.&#160; The IoC container is configured to pick the most specific implementation, but if one doesn’t exist, we don’t need to create a blank repository.&#160; Sometimes, things like Save or Delete need to do custom things, and I’d rather put this in the repository rather than some other anonymous domain service.

In the end, it really depends on the situation of each project.&#160; I’ve tended to stick with a generic interface, as it’s the easiest to scale complexity.&#160; However, quite a few smart folks use the generic method repository, and rely on external queries for the hard stuff.&#160; Complexity with saves and deletes is then handled by the cascading behavior of the underlying ORM.&#160; It’s quite intriguing, but I’ve been reticent to give up a tried-and-true pattern.&#160; I’m curious to see what other repository patterns people use out there.