---
id: 7
title: Using Database Repository Pattern with ActiveRecord with ActiveRecordMediator
date: 2008-05-28T01:45:00+00:00
author: John Teague
layout: post
guid: /blogs/johnteague/archive/2008/05/27/using-database-repository-pattern-with-activerecord-with-activerecordmediator.aspx
dsq_thread_id:
  - "262628957"
categories:
  - ActiveRecord
  - Repository Pattern
---
This is a Re-Post from my older blog at [geekswithblogs](http://geekswithblogs.net/johnteague/archive/2008/04/23/using-database-repository-pattern-with-activerecord-with-activerecordmediator.aspx).

Castle’s ActiveRecord frame work is an easy way to get introduced to NHibernate if you’re not familiar with setting up and using NHibernate (which I’m not). However many people are not fond of the ActiveRecord pattern. It can be a leaky abstraction, putting persistence related functions on your domain model is not a very clean separation of concerns for many people. I tend to agree with this. It really does depend on the complexity of your application. 

When learning about AR I read a lot of blog entries or the documentation, people elude to how you can use AR API in a repository fashion, but I could find very few examples of how to uses. 

It turns out there is an innocuous object within the API call ActiveRecordMediator<T>. This little guy has all of the persitance related methods you normally call directly on your ActiveRecord object. With this object you can use a Repository style DAL. Here is my simple BaseRepository that I inherit from to take advantage of ActiveRecordMediator. You can extend this further of course, but it’s all I need at the moment.

<pre><span style="color: blue">public class </span><span style="color: #2b91af">BaseRepository</span>&lt;T&gt; : <span style="color: #2b91af">IRepository</span>&lt;T&gt; <span style="color: blue">where </span>T :<span style="color: blue">class 
    </span>{
        <span style="color: blue">protected </span><span style="color: #2b91af">ActiveRecordMediator</span>&lt;T&gt; mediator;

        <span style="color: blue">public virtual void </span>Save(T item)
        {
            <span style="color: #2b91af">ActiveRecordMediator</span>&lt;T&gt;.Save(item);
            
        }
        <span style="color: blue">public virtual </span>T FindById(<span style="color: blue">object </span>id)
        {
            <span style="color: blue">return </span><span style="color: #2b91af">ActiveRecordMediator</span>&lt;T&gt;.FindByPrimaryKey(id);
        }
        <span style="color: blue">public virtual </span>T FindOne(<span style="color: blue">params </span><span style="color: #2b91af">ICriterion</span>[] criteria)
        {
            <span style="color: blue">return </span><span style="color: #2b91af">ActiveRecordMediator</span>&lt;T&gt;.FindOne(criteria);
        }</pre>

<pre><span style="color: blue">public virtual </span>T[] FindAll()
        {
            <span style="color: blue">return </span><span style="color: #2b91af">ActiveRecordMediator</span>&lt;T&gt;.FindAll();
        }

        <span style="color: blue">public virtual int </span>Count()
        {
            <span style="color: blue">return </span><span style="color: #2b91af">ActiveRecordMediator</span>&lt;T&gt;.Count();
        }
       
    }
}</pre>

[](http://11011.net/software/vspaste)