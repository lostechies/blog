---
wordpress_id: 44
title: Implementing Domain Queries
date: 2010-01-30T05:48:23+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2010/01/30/implementing-domain-queries.aspx
dsq_thread_id:
  - "262055733"
categories:
  - DDD
  - LINQ
  - NHibernate
redirect_from: "/blogs/johnteague/archive/2010/01/30/implementing-domain-queries.aspx/"
---
My current Repository interface looks something like this:

<pre style="border-bottom: #cecece 1px solid;border-left: #cecece 1px solid;padding-bottom: 5px;background-color: #fbfbfb;padding-left: 5px;width: 622px;padding-right: 5px;height: 252px;overflow: auto;border-top: #cecece 1px solid;border-right: #cecece 1px solid;padding-top: 5px"><pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IRepository
</pre>


<pre>    {
</pre>


<pre>        T FindOne&lt;T&gt;(<span style="color: #0000ff">int</span> id);
</pre>


<pre>        T FindBy&lt;T&gt;(Expression&lt;Func&lt;T, <span style="color: #0000ff">bool</span>&gt;&gt; expression);
</pre>


<pre>        IEnumerable&lt;T&gt; FindAllBy&lt;T&gt;(Expression&lt;Func&lt;T, <span style="color: #0000ff">bool</span>&gt;&gt; expression);
</pre>


<pre>        IEnumerable&lt;T&gt; FindAll&lt;T&gt;();
</pre>


<pre>        T FindOneBy&lt;T&gt;(Expression&lt;Func&lt;T, <span style="color: #0000ff">bool</span>&gt;&gt; expression);
</pre>


<pre>        <span style="color: #0000ff">void</span> Save&lt;T&gt;(T target);
</pre>


<pre>        <span style="color: #0000ff">void</span> Update&lt;T&gt;(T target);
</pre>


<pre>        <span style="color: #0000ff">void</span> SaveOrUpdate&lt;T&gt;(T target);
</pre>


<pre>        <span style="color: #0000ff">void</span> Delete&lt;T&gt;(T target);
</pre>


<pre>        IEnumerable&lt;T&gt; Query&lt;T&gt;(Expression&lt;Func&lt;T, <span style="color: #0000ff">bool</span>&gt;&gt; expression);
</pre>


<pre>    }</pre>


<p>
  It’s modeled after the Repository class that Jeremy and Chad put in the early versions in Fluent NHibernate (now removed).&#160; It relies almost completely on Linq expressions for where statements, which make queries very easy to write and understand.&#160; Like this one:
</p>


<pre style="border-bottom: #cecece 1px solid;border-left: #cecece 1px solid;padding-bottom: 5px;background-color: #fbfbfb;padding-left: 5px;width: 595px;padding-right: 5px;height: 21px;overflow: auto;border-top: #cecece 1px solid;border-right: #cecece 1px solid;padding-top: 5px">_repository.FindBy&lt;User&gt;(user =&gt; user.Enabled == true);</pre>


<p>
  This works great for small where statements, but when you need more control over the query, the current implementation doesn’t really allow you to fully take advantage of NHibernate or the Linq provider.&#160; Another downside is your code is not really DRY when you have small where statements littered everywhere. 
</p>


<p>
  So to solve these problems I implemented a very simple Domain Query pattern.&#160; Domain Queries are classes that encapsulate complicated or common queries into self contained objects that can be reused throughout your application.&#160; I had some very simple goals for this implementation:
</p>


<ol>
  <li>
    Keep it simple to access from the executing code. 
  </li>
  
  
  <li>
    I wanted full access to all of Nhibernate’s functionality when I needed it. 
  </li>
  
  
  <li>
    Keep it testable. 
  </li>
  
</ol>


<p>
  So Let’s start with the end and then show the beginning.&#160; I wanted it really simple to access a domain query.&#160; This is what I had in mind for executing a domain query:
</p>


<pre style="border-bottom: #cecece 1px solid;border-left: #cecece 1px solid;padding-bottom: 5px;background-color: #fbfbfb;padding-left: 5px;width: 650px;padding-right: 5px;overflow: auto;border-top: #cecece 1px solid;border-right: #cecece 1px solid;padding-top: 5px"><pre>_repostiory.FindAll(Queries.GetAllActiveUsers());</pre>


<p>
  To&#160; get there I started with a really simple interface.&#160; Because there were two basic queries I wanted to execute: return a single object or a collection of an object (I don’t have a use case for things like GetScalar yet)&#160; I need two methods on my interface:
</p>


<pre style="border-bottom: #cecece 1px solid;border-left: #cecece 1px solid;padding-bottom: 5px;background-color: #fbfbfb;padding-left: 5px;width: 650px;padding-right: 5px;overflow: auto;border-top: #cecece 1px solid;border-right: #cecece 1px solid;padding-top: 5px"><pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IDomainQuery&lt;T&gt;
</pre>


<pre>{
</pre>


<pre>   T ExecuteUniqueResult(ISession session);
</pre>


<pre>   IEnumerable&lt;T&gt; ExecuteList(ISession session);
</pre>


<pre>}</pre>


<p>
  I then added the following methods to my Repository:
</p>


<pre style="border-bottom: #cecece 1px solid;border-left: #cecece 1px solid;padding-bottom: 5px;background-color: #fbfbfb;padding-left: 5px;width: 643px;padding-right: 5px;height: 162px;overflow: auto;border-top: #cecece 1px solid;border-right: #cecece 1px solid;padding-top: 5px"><pre><span style="color: #0000ff">public</span> T FindOne&lt;T&gt;(IDomainQuery&lt;T&gt; query)
</pre>


<pre>{
</pre>


<pre>    <span style="color: #0000ff">return</span> query.ExecuteUniqueResult(Session);
</pre>


<pre>}
</pre>


<pre></pre>


<pre><span style="color: #0000ff">public</span> IEnumerable&lt;T&gt; Query&lt;T&gt;(IDomainQuery&lt;T&gt; query)
</pre>


<pre>{
</pre>


<pre>    <span style="color: #0000ff">return</span> query.ExecuteList(Session);
</pre>


<pre>}</pre>


<p>
  &#160;
</p>


<p>
  My repository is responsible for knowing how to access the session.&#160; Passing the ISession object to the domain query helps me meet two of my goals, I have full access to everything on the session and it is easy to test my domain queries since they are not responsible for managing the Unit of Work.&#160; I can create different UoW contexts in my application and my integration tests.
</p>


<p>
  To create the domain queries, I use the Template pattern to abstract the IDomainQuery aspects and allow the concrete classes only deal with the query construction.&#160; I have two abstract classes right now: LinqDomainQuery and CriteriaDomainQuery.&#160; It’s pretty obvious what each of these do.&#160; The CriteriaDomainQuery utilizes the DetachedCriteria functionality.&#160; The LinqDomainQuery obviously utilizes the Linq provider.&#160; I could easily create an HQLDomainQuery and an SQLDomainQuery as well, but following YAGNI I don’t need them yet.&#160; Here is the LinqDomainQuery:
</p>


<pre style="border-bottom: #cecece 1px solid;border-left: #cecece 1px solid;padding-bottom: 5px;background-color: #fbfbfb;padding-left: 5px;width: 650px;padding-right: 5px;overflow: auto;border-top: #cecece 1px solid;border-right: #cecece 1px solid;padding-top: 5px"><pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">abstract</span> <span style="color: #0000ff">class</span> LinqDomainQuery&lt;TResult&gt; : IDomainQuery&lt;TResult&gt;
</pre>


<pre>{
</pre>


<pre>    <span style="color: #0000ff">protected</span> <span style="color: #0000ff">abstract</span> IQueryable&lt;TResult&gt; GetQuery(ISession session);
</pre>


<pre></pre>


<pre>    <span style="color: #0000ff">public</span> TResult ExecuteUniqueResult(ISession session)
</pre>


<pre>    {
</pre>


<pre>        <span style="color: #0000ff">return</span> GetQuery(session).SingleOrDefault();
</pre>


<pre>    }
</pre>


<pre></pre>


<pre>    <span style="color: #0000ff">public</span> IEnumerable&lt;TResult&gt; ExecuteList(ISession session)
</pre>


<pre>    {
</pre>


<pre>        <span style="color: #0000ff">return</span> GetQuery(session).ToList();
</pre>


<pre>    }
</pre>


<pre>}</pre>


<p>
  Some important things to Note:&#160; Notice that I call the SingleOrDefault() and ToList() methods.&#160; This keeps me from having deferred execution bugs crop up.&#160; I had some issues during testing because I was closing the session faster than I was actually executing the query.&#160; Doing that here prevented that from happening.&#160; Also notice that it the generic type is TResult.&#160; With the Select statement, you can perform projections very easily. I can return DTO data directly from the query, giving me precisely the SQL statement I need and no need to map between complicated Entities to flattened DTOS.
</p>


<p>
  Here is an example of&#160; selecting a DTO from a Linq Query:
</p>


<pre style="border-bottom: #cecece 1px solid;border-left: #cecece 1px solid;padding-bottom: 5px;background-color: #fbfbfb;padding-left: 5px;width: 674px;padding-right: 5px;height: 585px;overflow: auto;border-top: #cecece 1px solid;border-right: #cecece 1px solid;padding-top: 5px"><pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> LoadBuilderDataQuery : LinqDomainQuery&lt;LoadBuilderData&gt;
</pre>


<pre>{
</pre>


<pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> <span style="color: #0000ff">int</span> _page;
</pre>


<pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> <span style="color: #0000ff">int</span> _rows;
</pre>


<pre></pre>


<pre>    <span style="color: #0000ff">public</span> LoadBuilderDataQuery(<span style="color: #0000ff">int</span> page, <span style="color: #0000ff">int</span> rows)
</pre>


<pre>    {
</pre>


<pre>        _page = page;
</pre>


<pre>        _rows = rows;
</pre>


<pre>    }
</pre>


<pre></pre>


<pre>    <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> IQueryable&lt;LoadBuilderData&gt; GetQuery(ISession session)
</pre>


<pre>    {
</pre>


<pre>        <span style="color: #0000ff">return</span>
</pre>


<pre>            session.Linq&lt;OrderTicket&gt;()
</pre>


<pre>                .Skip(_page*_rows).Take(_rows)
</pre>


<pre>                .Select(t =&gt; <span style="color: #0000ff">new</span> LoadBuilderData()
</pre>


<pre>                                 {
</pre>


<pre>                                     LoadId = t.Id,
</pre>


<pre>                                     PromisedDate = t.PromisedDate,
</pre>


<pre>                                     Address = t.Destination.Address1,
</pre>


<pre>                                     City = t.Destination.City,
</pre>


<pre>                                     State = t.Destination.State,
</pre>


<pre>                                     Zip = t.Destination.Zip,
</pre>


<pre>                                     CustomerName = t.Order.Customer.CustomerName,
</pre>


<pre>                                     StoreNumber = t.FulfillingStore.StoreNumber,
</pre>


<pre>                                     OrderNumber = t.Order.OrderNumber,
</pre>


<pre>                                     OrderSuffix = t.OrderSuffix
</pre>


<pre>                                 });
</pre>


<pre>           
</pre>


<pre>                       
</pre>


<pre>                                            
</pre>


<pre>            
</pre>


<pre>            
</pre>


<pre>    </pre>


<p>
  &#160;
</p>


<p>
  I have fully tested this query as well.&#160; Here is an example, I’m leaving some of the setup and UoW handling out for brevity, you can get the idea.
</p>


<pre style="border-bottom: #cecece 1px solid;border-left: #cecece 1px solid;padding-bottom: 5px;background-color: #fbfbfb;padding-left: 5px;width: 796px;padding-right: 5px;height: 210px;overflow: auto;border-top: #cecece 1px solid;border-right: #cecece 1px solid;padding-top: 5px"><pre><span style="color: #008000">//do some setup in the base class</span>
</pre>


<pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> when_retrieving_first_result_set : LoadBuilderQueryTests
</pre>


<pre>{
</pre>


<pre>    <span style="color: #008000">//unit of work helper opens and closes the session for me</span>
</pre>


<pre>    <span style="color: #0000ff">private</span> Because of =
</pre>


<pre>        () =&gt; result = UnitOfWorkHelper.Use(session =&gt; <span style="color: #0000ff">new</span> LoadBuilderDataQuery(0, 10).ExecuteList(session));
</pre>


<pre></pre>


<pre>    <span style="color: #0000ff">private</span> It should_return_10_rows = () =&gt; result.ToArray().Length.Should().Equal(10);
</pre>


<pre></pre>


<pre>    <span style="color: #0000ff">private</span> It should_return_LoadBuilderData =
</pre>


<pre>        () =&gt; result.ToArray()[0].Should().Be.OfType(<span style="color: #0000ff">typeof</span> (LoadBuilderData));
</pre>


<pre>}</pre>


<p>
  &#160; Here is the SQL Query generated:
</p>


<p>
  <a href="https://lostechies.com/content/johnteague/uploads/2011/03/domain_query_sql_3794BB00.png"><img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="domain_query_sql" src="https://lostechies.com/content/johnteague/uploads/2011/03/domain_query_sql_thumb_0BE681B5.png" width="761" height="296" /></a>
</p>


<p>
  Now back to the beginning.&#160; To reduce some of the complexity of calling these classes, I wrapped then in static methods to make them easier to call:
</p>


<pre style="border-bottom: #cecece 1px solid;border-left: #cecece 1px solid;padding-bottom: 5px;background-color: #fbfbfb;padding-left: 5px;width: 662px;padding-right: 5px;height: 180px;overflow: auto;border-top: #cecece 1px solid;border-right: #cecece 1px solid;padding-top: 5px"><pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Queries
</pre>


<pre>{
</pre>


<pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> IDomainQuery&lt;LoadBuilderData&gt; GetLoadBuilderData(<span style="color: #0000ff">int</span> page, <span style="color: #0000ff">int</span> row)
</pre>


<pre>    {
</pre>


<pre>       <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> LoadBuilderDataQuery([page, row);
</pre>


<pre>    }
</pre>


<pre>}
</pre>


<pre></pre>


<p>
  This is just some syntactic sugar, but small things like that keep your application easy to read and understand.
</p>


<p>
  This is a very simple way to implement domain queries.&#160;&#160; You can go a lot further with this.&#160; <a href="http://lunaverse.wordpress.com/">Tim Scott</a> took my simple approach and really took the training wheels off.&#160; If I can’t get him to post about it it will.
</p>