---
id: 20
title: Intercepting Business Transactions
date: 2008-11-04T01:58:53+00:00
author: Mo Khan
layout: post
guid: /blogs/mokhan/archive/2008/11/03/intercepting-business-transactions.aspx
categories:
  - Uncategorized
---
In [Patterns of Enterprise Application Architecture](http://www.amazon.com/Enterprise-Application-Architecture-Addison-Wesley-Signature/dp/0321127420), the Unit of Work design pattern is defined as:

> _Maintains a list of objects affected by a business transaction and coordinates the writing out of changes and the resolution of concurrency problems._

NHibernate seems to have a great implementation of the unit of work, but understanding when to start and commit the unit of work without repeating yourself can be a little tricky. One thing we&#8217;ve been doing is starting a unit of work using an interceptor.

<pre>[<span style="color: #2b91af">Interceptor</span>(<span style="color: blue">typeof </span>(<span style="color: #2b91af">IUnitOfWorkInterceptor</span>))]
<span style="color: blue">public class </span><span style="color: #2b91af">AccountTasks </span>: <span style="color: #2b91af">IAccountTasks
</span>{
    <span style="color: blue">public bool </span>are_valid(<span style="color: #2b91af">ICredentials </span>credentials)
    {
        <font color="#0000ff">...</font>
    }
}</pre>

[](http://11011.net/software/vspaste)

Account tasks is a service layer piece, that is decorated with an interceptor that will begin and commit a unit of work. 

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IUnitOfWorkInterceptor </span>: <span style="color: #2b91af">IInterceptor
</span>{}

<span style="color: blue">public class </span><span style="color: #2b91af">UnitOfWorkInterceptor </span>: <span style="color: #2b91af">IUnitOfWorkInterceptor
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IUnitOfWorkFactory </span>factory;

    <span style="color: blue">public </span>UnitOfWorkInterceptor(<span style="color: #2b91af">IUnitOfWorkFactory </span>factory)
    {
        <span style="color: blue">this</span>.factory = factory;
    }

    <span style="color: blue">public void </span>Intercept(<span style="color: #2b91af">IInvocation </span>invocation)
    {
        <span style="color: blue">using </span>(<span style="color: blue">var </span>unit_of_work = factory.create()) {
            invocation.Proceed();
            unit_of_work.commit();
        }
    }
}</pre>

The interceptor starts a new unit of work, before proceeding with the invocation. If no exceptions are raised the unit of work is committed. If a unit of work is already started, the unit of work factory returns an empty unit of work. This ensures that if a service layer method calls into another method that it doesn&#8217;t start another unit of work.

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IUnitOfWorkFactory </span>: <span style="color: #2b91af">IFactory</span>&lt;<span style="color: #2b91af">IUnitOfWork</span>&gt;
{}

<span style="color: blue">public class </span><span style="color: #2b91af">UnitOfWorkFactory </span>: <span style="color: #2b91af">IUnitOfWorkFactory
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IApplicationContext </span>context;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IDatabaseSessionFactory </span>factory;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">TypedKey</span>&lt;<span style="color: #2b91af">ISession</span>&gt; key;

    <span style="color: blue">public </span>UnitOfWorkFactory(<span style="color: #2b91af">IApplicationContext </span>context, <span style="color: #2b91af">IDatabaseSessionFactory </span>factory)
    {
        <span style="color: blue">this</span>.context = context;
        <span style="color: blue">this</span>.factory = factory;
        key = <span style="color: blue">new </span><span style="color: #2b91af">TypedKey</span>&lt;<span style="color: #2b91af">ISession</span>&gt;();
    }

    <span style="color: blue">public </span><span style="color: #2b91af">IUnitOfWork </span>Create()
    {
        <span style="color: blue">if </span>(unit_of_work_is_already_started()) {
            <span style="color: blue">return new </span><span style="color: #2b91af">EmptyUnitOfWork</span>();
        }

        <span style="color: blue">return </span>create_a_unit_of_work().start();
    }

    <span style="color: blue">private bool </span>unit_of_work_is_already_started()
    {
        <span style="color: blue">return </span>context.contains(key);
    }

    <span style="color: blue">private </span><span style="color: #2b91af">IUnitOfWork </span>create_a_unit_of_work()
    {
        <span style="color: blue">var </span>session = factory.create();
        context.add(key, session);
        <span style="color: blue">return new </span><span style="color: #2b91af">UnitOfWork</span>(session, context);
    }
}</pre>

[](http://11011.net/software/vspaste)

The implementation of the repository pulls the active session from the application context. 

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DatabaseRepository</span>&lt;T&gt; : <span style="color: #2b91af">IRepository</span>&lt;T&gt;
{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IApplicationContext </span>context;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IKey</span>&lt;<span style="color: #2b91af">ISession</span>&gt; session_key;

    <span style="color: blue">public </span>DatabaseRepository(<span style="color: #2b91af">IApplicationContext </span>context)
    {
        <span style="color: blue">this</span>.context = context;
        session_key = <span style="color: blue">new </span><span style="color: #2b91af">TypedKey</span>&lt;<span style="color: #2b91af">ISession</span>&gt;();
    }

    <span style="color: blue">public </span><span style="color: #2b91af">IQueryable</span>&lt;T&gt; all()
    {
        <span style="color: blue">return </span>the_current_session().Linq&lt;T&gt;();
    }

    <span style="color: blue">public void </span>save(T item)
    {
        the_current_session().SaveOrUpdate(item);
    }

    <span style="color: blue">public void </span>delete(T item)
    {
        the_current_session().Delete(item);
    }

    <span style="color: blue">private </span><span style="color: #2b91af">ISession </span>the_current_session()
    {
        <span style="color: blue">var </span>current_session = context.get_value_for(session_key);
        <span style="color: blue">if </span>(<span style="color: blue">null </span>== current_session || !current_session.IsOpen) {
            <span style="color: blue">throw new </span><span style="color: #2b91af">NHibernateSessionNotOpenException</span>();
        }
        <span style="color: blue">return </span>current_session;
    }
}</pre>

For more information on Interceptors check out the [Castle stack&#8230;](http://www.castleproject.org/container/documentation/trunk/usersguide/interceptors.html)