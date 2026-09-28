---
wordpress_id: 63
title: Convention Based Filters
date: 2011-06-12T21:43:16+00:00
author: John Teague
layout: post
wordpress_guid: http://lostechies.com/johnteague/?p=63
dsq_thread_id:
  - "329890204"
categories:
  - Uncategorized
---
Title: Convention Based Filters

Not too long ago [Joshua Flanagan](http://joshflanagan.lostechies.com) spoke at the [Austin .Net User Group](http://adnug.org) about how the Dovetail crew use conventions to simplify their development process. The approach is simple in concept (of course the devil’s in the details)

This inspired me to apply the approach in my current project. Our project has several screens that very similar: a table, some buttons to perform actions, and a set of filters. When we implemented the first screen, it was obvious that building the filters were going to get old really fast. This looked like a good place to try and make things a little easier.

I started by creating a class for the fields that were on a filter and used the properties in the class to create an NHibernate Criteria search. The only real requirement here is that the property names in the filter class had to match the names in the Nhiberante mapped object.

This was pretty easy to setup. All we needed to do was build up the Criteria from the property names and the values.

<pre>public IEnumerable&lt;ICriterion&gt; CreateFilter(object filter, Type objectToFilter)
{
  var criterion = new List&lt;ICriterion&gt;();
  var props = filter.GetType().GetProperties();
  foreach (var pi in props)
  {
    var val = pi.GetValue(filter, null);
    if (ShouldNotAddToFilter(pi, val)) continue;
    criterion.Add(new SimpleExpression(pi.Name, val, "="));
    return criterion;
}</pre>

Now this will create a very simple criteria by creating where statement with a bunch of Property = value OR Property2 = value2. While this is functional and does cover most of our needs, it is pretty limited in what it could do. One issue is that it only goes one level deep in your persistence model hiearchy. You would not be able to apply filters to anything modeled as components. Also there were a few fields that needed to be queried using expressions other than equals. We needed to do like filters as well as greater than / less than queries too. So we need to provide some metadata for the properties to make variations on the criteria output. The easiest way to do that is to decorate the filter properties with some attributes.

We created a set of Attribute classes that allowed us to create different types of Criteria Expressions.  The type of expression needed was created inside the attribute.  We can then use the power of polymorphism to avoid a big [if or switch](http://www.antiifcampaign.com/) statement and keeps the query building code clean.

<pre>public class QueryFilterAttribute : Attribute
{
  public virtual ICriterion GetCriteria(string propertyName, object val)
  {
    return Restrictions.Eq(propertyName, val);
  }
  public Type ComponentModel { get; set; }
}</pre>

<pre>public class LikeQueryFilterAttribute : QueryFilterAttribute
{
  public override ICriterion GetCriteria(string propertyName, object val)
  {
    return new LikeExpression(propertyName, val.ToString(), MatchMode.Anywhere);
  }
}</pre>

These attributes allow us to change the Criteria Expression or Apply the filter to a Component Type. The full source code is at the [gist](https://gist.github.com/1007612) below.

This relatively simple construct saved us a lot time, especially when you think about how much code we would have written after about 10 or 12 of these by hand. When you start to put these types of conventions in your entire codebase, they add up to a lot of time savings. Just another example of how working smarter, not harder can make your life a little bit easier.

    {% gist 1007612 %}

&nbsp;