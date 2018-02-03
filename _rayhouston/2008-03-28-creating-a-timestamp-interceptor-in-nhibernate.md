---
wordpress_id: 16
title: Creating a Timestamp Interceptor in NHibernate
date: 2008-03-28T02:28:39+00:00
author: Ray Houston
layout: post
wordpress_guid: /blogs/rhouston/archive/2008/03/27/creating-a-timestamp-interceptor-in-nhibernate.aspx
categories:
  - Uncategorized
---
<div>
  In a previous <a href="http://www.lostechies.com/blogs/rhouston/archive/2008/03/23/mapping-timestamp-data-using-nhibernate-s-icompositeusertype.aspx">post</a>, I gave an example of a Timestamp class and how one might create an ICompositeUserType to map it within NHibernate. Here I want to show of an example of an <a href="http://www.hibernate.org/hib_docs/nhibernate/1.2/reference/en/html/manipulatingdata.html#manipulatingdata-interceptors">IInterceptor</a> which will automatically populate the values for my Timestamp class. OnSave is for the inserts, and OnFlushDirty is for the updates. There are a bunch of other methods that you can tap into for different things, so check out the NHibernate docs.
</div>

<div>
  &nbsp;
</div>

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> TimestampInterceptor : EmptyInterceptor
{
    <span style="color: #0000ff">private</span> <span style="color: #0000ff">const</span> <span style="color: #0000ff">string</span> TIMESTAMP_PROPERTY = <span style="color: #006080">"Timestamp"</span>;

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IDomainContext domainContext;
    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> ISystemClock clock;

    <span style="color: #0000ff">public</span> TimestampInterceptor(IDomainContext domainContext, ISystemClock clock)
    {
        <span style="color: #0000ff">this</span>.domainContext = domainContext;
        <span style="color: #0000ff">this</span>.clock = clock;
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">bool</span> OnSave(<span style="color: #0000ff">object</span> entity, <span style="color: #0000ff">object</span> id, <span style="color: #0000ff">object</span>[] state, 
        <span style="color: #0000ff">string</span>[] propertyNames, IType[] types)
    {
        var timestampable = entity <span style="color: #0000ff">as</span> ITimestampable;

        <span style="color: #0000ff">if</span>(timestampable == <span style="color: #0000ff">null</span>)
            <span style="color: #0000ff">return</span> <span style="color: #0000ff">false</span>;

        var timestamp = GetTimestamp(state, propertyNames);

        timestamp.CreatedDateTime = clock.Now();

        <span style="color: #0000ff">if</span> (domainContext.DomainUser != <span style="color: #0000ff">null</span>)
            timestamp.CreatedByStaff = domainContext.DomainUser.StaffName;

        <span style="color: #0000ff">return</span> <span style="color: #0000ff">true</span>;
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">bool</span> OnFlushDirty(<span style="color: #0000ff">object</span> entity, <span style="color: #0000ff">object</span> id, <span style="color: #0000ff">object</span>[] currentState, 
        <span style="color: #0000ff">object</span>[] previousState, <span style="color: #0000ff">string</span>[] propertyNames, IType[] types)
    {
        var timestampable = entity <span style="color: #0000ff">as</span> ITimestampable;

        <span style="color: #0000ff">if</span> (timestampable == <span style="color: #0000ff">null</span>)
            <span style="color: #0000ff">return</span> <span style="color: #0000ff">false</span>;

        var timestamp = GetTimestamp(currentState, propertyNames);

        timestamp.UpdatedDateTime = clock.Now();

        <span style="color: #0000ff">if</span>(domainContext.DomainUser != <span style="color: #0000ff">null</span>)
            timestamp.UpdatedByStaff = domainContext.DomainUser.StaffName;

        <span style="color: #0000ff">return</span> <span style="color: #0000ff">true</span>;
    }

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">static</span> Timestamp GetTimestamp(<span style="color: #0000ff">object</span>[] state, <span style="color: #0000ff">string</span>[] propertyNames)
    {
        var timestamp = state[Array.IndexOf(propertyNames, TIMESTAMP_PROPERTY)] <span style="color: #0000ff">as</span> Timestamp;

        <span style="color: #0000ff">if</span>( timestamp == <span style="color: #0000ff">null</span> )
        {
            timestamp = <span style="color: #0000ff">new</span> Timestamp();
            state[Array.IndexOf(propertyNames, TIMESTAMP_PROPERTY)] = timestamp;
        }

        <span style="color: #0000ff">return</span> timestamp;
    }
}</pre>
</div>

<div>
  &nbsp;
</div>

<div>
  I haven&#8217;t run this through the ringers yet, so let me know if you spot some problems.
</div>

<div class="wlWriterSmartContent" style="padding-right: 0px;padding-left: 0px;padding-bottom: 0px;margin: 0px;padding-top: 0px">
  Technorati Tags: <a href="http://technorati.com/tags/NHibernate" rel="tag">NHibernate</a>,<a href="http://technorati.com/tags/.NET" rel="tag">.NET</a>
</div>