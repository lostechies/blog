---
id: 13
title: 'Mapping Strings to Booleans Using NHibernate&#8217;s IUserType'
date: 2008-03-23T05:03:26+00:00
author: Ray Houston
layout: post
guid: /blogs/rhouston/archive/2008/03/23/mapping-strings-to-booleans-using-nhibernate-s-iusertype.aspx
categories:
  - Uncategorized
---
_Update: I failed to realized that the functionality of converting &#8220;Y&#8221; or &#8220;N&#8221; to a boolean is already built into NHibernate by doing **type=&#8221;YesNo&#8221;** (see comments). I&#8217;ll leave this post up just for the academics of creating a IUserType. Go figure that I would come up with something that&#8217;s built in!_

We have some legacy data where boolean values are stored as strings. &#8220;Y&#8221; is true and &#8220;N&#8221; is no. We&#8217;re also creating entities which have properties that map to this data. It would be just plain evil to have to create all the boolean properties as strings! We previously solved this problem by creating our own .NET type that had a string property for the &#8220;Y&#8221; or &#8220;N&#8221; value. This type had an implicit cast defined as a bool, so we could treat it as a boolean in expressions and assignments. We mapped this in NHibernate as a component with the single string property and this worked pretty well, but I suspected that there was a better way. Today I bought the e-book version of [NHibernate in Action](http://www.manning.com/kuate/) and quickly read through the section on creating an implementation of IUserType. I then came up with the following class that allows me to keep my types as true booleans in the code.

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> YesNoType : IUserType
{
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> IsMutable
    {
        get { <span style="color: #0000ff">return</span> <span style="color: #0000ff">false</span>; }
    }

    <span style="color: #0000ff">public</span> Type ReturnedType
    {
        get { <span style="color: #0000ff">return</span> <span style="color: #0000ff">typeof</span>(YesNoType); }
    }

    <span style="color: #0000ff">public</span> SqlType[] SqlTypes
    {
        get { <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span>[]{NHibernateUtil.String.SqlType}; }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">object</span> NullSafeGet(IDataReader rs, <span style="color: #0000ff">string</span>[] names, <span style="color: #0000ff">object</span> owner)
    {
        var obj = NHibernateUtil.String.NullSafeGet(rs, names[0]);

        <span style="color: #0000ff">if</span>(obj == <span style="color: #0000ff">null</span> ) <span style="color: #0000ff">return</span> <span style="color: #0000ff">null</span>;

        var yesNo = (<span style="color: #0000ff">string</span>) obj;

        <span style="color: #0000ff">if</span>( yesNo != <span style="color: #006080">"Y"</span> && yesNo != <span style="color: #006080">"N"</span> )
            <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> YourException(<span style="color: #006080">"Expected data to be 'Y' or 'N' but was '{0}'."</span>, yesNo);

        <span style="color: #0000ff">return</span> yesNo == <span style="color: #006080">"Y"</span>;
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> NullSafeSet(IDbCommand cmd, <span style="color: #0000ff">object</span> <span style="color: #0000ff">value</span>, <span style="color: #0000ff">int</span> index)
    {
        <span style="color: #0000ff">if</span>(<span style="color: #0000ff">value</span> == <span style="color: #0000ff">null</span>)
        {
            ((IDataParameter) cmd.Parameters[index]).Value = DBNull.Value;
        }
        <span style="color: #0000ff">else</span>
        {
            var yes = (<span style="color: #0000ff">bool</span>) <span style="color: #0000ff">value</span>;
            ((IDataParameter)cmd.Parameters[index]).Value = yes ? <span style="color: #006080">"Y"</span> : <span style="color: #006080">"N"</span>;
        }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">object</span> DeepCopy(<span style="color: #0000ff">object</span> <span style="color: #0000ff">value</span>)
    {
        <span style="color: #0000ff">return</span> <span style="color: #0000ff">value</span>;
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">object</span> Replace(<span style="color: #0000ff">object</span> original, <span style="color: #0000ff">object</span> target, <span style="color: #0000ff">object</span> owner)
    {
        <span style="color: #0000ff">return</span> original;
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">object</span> Assemble(<span style="color: #0000ff">object</span> cached, <span style="color: #0000ff">object</span> owner)
    {
        <span style="color: #0000ff">return</span> cached;
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">object</span> Disassemble(<span style="color: #0000ff">object</span> <span style="color: #0000ff">value</span>)
    {
        <span style="color: #0000ff">return</span> <span style="color: #0000ff">value</span>;
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">new</span> <span style="color: #0000ff">bool</span> Equals(<span style="color: #0000ff">object</span> x, <span style="color: #0000ff">object</span> y)
    {
        <span style="color: #0000ff">if</span>( ReferenceEquals(x,y) ) <span style="color: #0000ff">return</span> <span style="color: #0000ff">true</span>;

        <span style="color: #0000ff">if</span>( x == <span style="color: #0000ff">null</span> || y == <span style="color: #0000ff">null</span> ) <span style="color: #0000ff">return</span> <span style="color: #0000ff">false</span>;

        <span style="color: #0000ff">return</span> x.Equals(y);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">int</span> GetHashCode(<span style="color: #0000ff">object</span> x)
    {
        <span style="color: #0000ff">return</span> x == <span style="color: #0000ff">null</span> ? <span style="color: #0000ff">typeof</span>(<span style="color: #0000ff">bool</span>).GetHashCode() + 473 : x.GetHashCode();
    }
}
</pre>
</div>

The mapping looks something like:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">&lt;</span><span style="color: #800000">property</span> <span style="color: #ff0000">name</span><span style="color: #0000ff">="Active"</span> <span style="color: #ff0000">type</span><span style="color: #0000ff">="NHTypes.YesNoType, NHTypes"</span> <span style="color: #ff0000">column</span><span style="color: #0000ff">="ACTIVE_YN"</span> <span style="color: #ff0000">not-null</span><span style="color: #0000ff">="false"</span> <span style="color: #0000ff">/&gt;</span></pre>
</div>

I&#8217;m not going to go into detail and explain what all the parts are and do (see [link](http://www.surcombe.com/nhibernate-1.2/api/html/AllMembers_T_NHibernate_UserTypes_IUserType.htm)), but I thought that I would share the class. Please let me know if you spot any problems.

<div class="wlWriterSmartContent" style="padding-right: 0px;padding-left: 0px;padding-bottom: 0px;margin: 0px;padding-top: 0px">
  Technorati Tags: <a href="http://technorati.com/tags/NHibernate" rel="tag">NHibernate</a>,<a href="http://technorati.com/tags/.NET" rel="tag">.NET</a>
</div>