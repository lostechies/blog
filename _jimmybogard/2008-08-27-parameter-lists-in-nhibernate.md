---
wordpress_id: 222
title: Parameter lists in NHibernate
date: 2008-08-27T00:39:14+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/08/26/parameter-lists-in-nhibernate.aspx
dsq_thread_id:
  - "264719531"
categories:
  - NHibernate
redirect_from: "/blogs/jimmy_bogard/archive/2008/08/26/parameter-lists-in-nhibernate.aspx/"
---
{% raw %}
Occasionally I need to return a set of entites that match a collection of parameters.&nbsp; In SQL, I would use the &#8220;IN&#8221; clause, then manually create each parameter in ADO.NET.&nbsp; With NHibernate, that&#8217;s not necessary anymore.&nbsp; NHibernate has built-in capabilities for a collection parameter, creating all the necessary ADO.NET parameters behind the scenes.

For example, suppose my database has the following structure (from Northwind):

 ![](http://grabbagoftimg.s3.amazonaws.com/nhib_params_01.PNG)

What I&#8217;m trying to do is to load up all Products for a certain set of Categories.&nbsp; My Product and Category class are nothing interesting:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Category
</span>{
    <span style="color: blue">public int </span>Id { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>Name { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}
</pre>

[](http://11011.net/software/vspaste)

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Product
</span>{
    <span style="color: blue">public int </span>Id { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>Name { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">Category </span>Category { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}
</pre>

[](http://11011.net/software/vspaste)

I didn&#8217;t bother mapping all of the properties, just the ones for the classes defined above.&nbsp; Here are the mapping files:

<pre><span style="color: blue">&lt;</span><span style="color: #a31515">class </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">Category</span>" <span style="color: red">table</span><span style="color: blue">=</span>"<span style="color: blue">Categories</span>"<span style="color: blue">&gt;
    &lt;</span><span style="color: #a31515">id </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">Id</span>" <span style="color: red">column</span><span style="color: blue">=</span>"<span style="color: blue">CategoryID</span>" <span style="color: red">type</span><span style="color: blue">=</span>"<span style="color: blue">int</span>"<span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">generator </span><span style="color: red">class</span><span style="color: blue">=</span>"<span style="color: blue">assigned</span>" <span style="color: blue">/&gt;
    &lt;/</span><span style="color: #a31515">id</span><span style="color: blue">&gt;
    &lt;</span><span style="color: #a31515">property </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">Name</span>" <span style="color: red">not-null</span><span style="color: blue">=</span>"<span style="color: blue">true</span>" <span style="color: red">column</span><span style="color: blue">=</span>"<span style="color: blue">CategoryName</span>" <span style="color: blue">/&gt;
&lt;/</span><span style="color: #a31515">class</span><span style="color: blue">&gt;
</span></pre>

[](http://11011.net/software/vspaste)

<pre><span style="color: blue">&lt;</span><span style="color: #a31515">class </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">Product</span>" <span style="color: red">table</span><span style="color: blue">=</span>"<span style="color: blue">Products</span>"<span style="color: blue">&gt;
    &lt;</span><span style="color: #a31515">id </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">Id</span>" <span style="color: red">column</span><span style="color: blue">=</span>"<span style="color: blue">ProductId</span>" <span style="color: red">type</span><span style="color: blue">=</span>"<span style="color: blue">int</span>"<span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">generator </span><span style="color: red">class</span><span style="color: blue">=</span>"<span style="color: blue">assigned</span>" <span style="color: blue">/&gt;
    &lt;/</span><span style="color: #a31515">id</span><span style="color: blue">&gt;
    &lt;</span><span style="color: #a31515">property </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">Name</span>" <span style="color: red">not-null</span><span style="color: blue">=</span>"<span style="color: blue">true</span>" <span style="color: red">column</span><span style="color: blue">=</span>"<span style="color: blue">ProductName</span>" <span style="color: blue">/&gt;
    &lt;</span><span style="color: #a31515">many-to-one </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">Category</span>" <span style="color: red">column</span><span style="color: blue">=</span>"<span style="color: blue">CategoryID</span>"<span style="color: blue">&gt;
    &lt;/</span><span style="color: #a31515">many-to-one</span><span style="color: blue">&gt;
&lt;/</span><span style="color: #a31515">class</span><span style="color: blue">&gt;
</span></pre>

[](http://11011.net/software/vspaste)

When using plain HQL, I need to use the SetParameterList method on the IQuery object:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_get_products_by_categories_correctly_using_HQL()
{
    <span style="color: #2b91af">ISession </span>session = GetSession();
    <span style="color: blue">string </span>hql = <span style="color: #a31515">@"from Product p
                   where p.Category in (:categories)"</span>;

    <span style="color: blue">var </span>categoriesToSearch = <span style="color: blue">new</span>[] {<span style="color: blue">new </span><span style="color: #2b91af">Category </span>{Id = 1}, <span style="color: blue">new </span><span style="color: #2b91af">Category </span>{Id = 2}};

    <span style="color: blue">var </span>query = session.CreateQuery(hql);
    query.SetParameterList(<span style="color: #a31515">"categories"</span>, categoriesToSearch);

    <span style="color: blue">var </span>products = query.List&lt;<span style="color: #2b91af">Product</span>&gt;();

    products.Count.ShouldEqual(24);
}
</pre>

[](http://11011.net/software/vspaste)

When using the Criteria API, I&#8217;ll need to use the InExpression:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_get_products_by_categories_correctly_using_criteria()
{
    <span style="color: #2b91af">ISession </span>session = GetSession();
    <span style="color: blue">var </span>criteria = session.CreateCriteria(<span style="color: blue">typeof</span>(<span style="color: #2b91af">Product</span>));

    <span style="color: blue">var </span>categoriesToSearch = <span style="color: blue">new</span>[] {<span style="color: blue">new </span><span style="color: #2b91af">Category </span>{Id = 1}, <span style="color: blue">new </span><span style="color: #2b91af">Category </span>{Id = 2}};
    criteria.Add(<span style="color: blue">new </span><span style="color: #2b91af">InExpression</span>(<span style="color: #a31515">"Category"</span>, categoriesToSearch));
    <span style="color: blue">var </span>products = criteria.List&lt;<span style="color: #2b91af">Product</span>&gt;();

    products.Count.ShouldEqual(24);
}
</pre>

[](http://11011.net/software/vspaste)

When I execute both of these, NHibernate produces the correct IN expression for each.&nbsp; Unfortunately, I am ashamed to say I initially tried to create the parameter list myself.&nbsp; Next time, I&#8217;ll know better.
{% endraw %}
