---
id: 4743
title: NHibernate Query Example using CreateCriteria
date: 2008-04-13T13:18:00+00:00
author: Nelson Montalvo
layout: post
guid: /blogs/nelson_montalvo/archive/2008/04/13/nhibernate-query-example-using-createcriteria.aspx
categories:
  - NHibernate
---
I&#8217;m a big fan of NHibernate. I love how it abstracts out the data portion of your application and allows you to work from the perspective of the domain rather than the database.

So in building my domain repositories, I have several options to query the database using NHibernate:

  * I can use HQL in CreateQuery.
  * I can use named queries in GetNamedQuery.
  * I can use SQL directly in CreateSqlQuery.
  * I can use the type of object in a CreateCriteria.

Short of using Ayende&#8217;s NHibernate Query Generator to strongly type my HQL queries, I like using the CreateCriteria call.

### The Example

To begin with, I&#8217;m not a fan of generic repository interfaces with a ton of generics-based CRUD operations (IRepository<T>). I&#8217;d rather just limit my repository code to what is needed for operating with that aggregate root (driven by the domain, of course).

For this example, I have an interface in my domain project called _CommissionPeriodRepository_ (yes, no &#8216;I&#8217; in front of my interfaces &#8211; again, personal preference&#8230; lol). The implementation class, _NHibernateCommissionPeriodRepository_, resides in an NHibernate specific project implementing the repository interfaces. Finally, I&#8217;m assuming that the NHibernate session (Unit of Work is used here, but is NHibernate specific) is managed by the calling application, committing and rolling back changes as necessary.&nbsp;

<div style="background: white none repeat scroll 0% 50%;font-size: 12pt;color: black;font-family: inconsolata">
  <pre style="margin: 0pt">    <span style="color: blue">public</span> <span style="color: blue">class</span> <span>NHibernateCommissionPeriodRepository</span> : <span>CommissionPeriodRepository</span></pre>
  
  <pre style="margin: 0pt">    {</pre>
  
  <pre style="margin: 0pt"><span style="color: blue">        #region</span> CommissionPeriodRepository Members</pre>
  
  <pre style="margin: 0pt"></pre>
  
  <pre style="margin: 0pt">        <span style="color: blue">public</span> <span>CommissionPeriod</span> GetCommissionPeriodFor(<span>DateTime</span> date)</pre>
  
  <pre style="margin: 0pt">        {</pre>
  
  <pre style="margin: 0pt">            <span style="color: blue">return</span> <span>UnitOfWork</span>.GetCurrentSession()</pre>
  
  <pre style="margin: 0pt">                .CreateCriteria(<span style="color: blue">typeof</span> (<span>CommissionPeriod</span>))</pre>
  
  <pre style="margin: 0pt">                .Add(<span>Expression</span>.Lt(<span>"Startdate"</span>, date))</pre>
  
  <pre style="margin: 0pt">                .Add(<span>Expression</span>.Ge(<span>"Enddate"</span>, date))</pre>
  
  <pre style="margin: 0pt">                .UniqueResult&lt;<span>CommissionPeriod</span>&gt;();</pre>
  
  <pre style="margin: 0pt">        }</pre>
  
  <pre style="margin: 0pt"></pre>
  
  <pre style="margin: 0pt"><span style="color: blue">        #endregion</span></pre>
  
  <pre style="margin: 0pt">    }</pre>
</div>

Pretty much all the code is doing is:

  1. Pulling the current NHibernate session.
  2. Creating a criteria object for a CommissionPeriod domain object.
  3. Pulling the unique CommissionPeriod object that has a start date less than that passed in date and an end date greater than or equal to it.

That&#8217;s it. Simple stuff. Gotta love it.