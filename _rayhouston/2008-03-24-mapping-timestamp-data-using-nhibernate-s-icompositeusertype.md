---
id: 14
title: 'Mapping Timestamp Data Using NHibernate&#8217;s ICompositeUserType'
date: 2008-03-24T02:21:18+00:00
author: Ray Houston
layout: post
guid: /blogs/rhouston/archive/2008/03/23/mapping-timestamp-data-using-nhibernate-s-icompositeusertype.aspx
categories:
  - Uncategorized
---
In my previous [post](http://www.lostechies.com/blogs/rhouston/archive/2008/03/23/mapping-strings-to-booleans-using-nhibernate-s-iusertype.aspx), I took some string data and mapped it directly to a boolean property on an entity. That was pretty simple, but I wanted to try it out on a little more complex object..

In our projects, most of the entities have a Timestamp property which is of type Timestamp:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> User
{
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> UserID { get; set; }
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> Username { get; set; }
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> Password { get; set; }
    <span style="color: #0000ff">public</span> Timestamp Timestamp { get; set; }
}</pre>
</div>

and here&#8217;s the Timestamp class:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Timestamp
{
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> CreatedByStaff { get; set; }
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> UpdatedByStaff { get; set; }
    <span style="color: #0000ff">public</span> DateTime? CreatedDateTime { get; set; }
    <span style="color: #0000ff">public</span> DateTime? UpdatedDateTime { get; set; }
}
</pre>
</div>

In the database, the USER table would have the obvious columns for UserID, Username, and Password, but also have the columns for the Timestamp which in my case are CREATED\_BY\_STAFF, UPDATED\_BY\_STAFF, CREATED\_DATETIME, and UPDATED\_DATETIME. Now this can easily be mapped as it is by using a component like so:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">&lt;</span><span style="color: #800000">component</span> <span style="color: #ff0000">name</span><span style="color: #0000ff">="Timestamp"</span> <span style="color: #ff0000">class</span><span style="color: #0000ff">="XYZ.Core.Timestamp, XYZ.Core"</span><span style="color: #0000ff">&gt;</span>
  <span style="color: #0000ff">&lt;</span><span style="color: #800000">property</span> <span style="color: #ff0000">name</span><span style="color: #0000ff">="CreatedByStaff"</span> <span style="color: #ff0000">type</span><span style="color: #0000ff">="String"</span> <span style="color: #ff0000">column</span><span style="color: #0000ff">="CREATED_BY_STAFF"</span> <span style="color: #ff0000">not-null</span><span style="color: #0000ff">="true"</span><span style="color: #0000ff">/&gt;</span>
  <span style="color: #0000ff">&lt;</span><span style="color: #800000">property</span> <span style="color: #ff0000">name</span><span style="color: #0000ff">="UpdatedByStaff"</span> <span style="color: #ff0000">type</span><span style="color: #0000ff">="String"</span> <span style="color: #ff0000">column</span><span style="color: #0000ff">="UPDATED_BY_STAFF"</span> <span style="color: #ff0000">not-null</span><span style="color: #0000ff">="false"</span><span style="color: #0000ff">/&gt;</span>
  <span style="color: #0000ff">&lt;</span><span style="color: #800000">property</span> <span style="color: #ff0000">name</span><span style="color: #0000ff">="CreatedDateTime"</span> <span style="color: #ff0000">type</span><span style="color: #0000ff">="DateTime"</span> <span style="color: #ff0000">column</span><span style="color: #0000ff">="CREATED_DATETIME"</span> <span style="color: #ff0000">not-null</span><span style="color: #0000ff">="true"</span><span style="color: #0000ff">/&gt;</span>
  <span style="color: #0000ff">&lt;</span><span style="color: #800000">property</span> <span style="color: #ff0000">name</span><span style="color: #0000ff">="UpdatedDateTime"</span> <span style="color: #ff0000">type</span><span style="color: #0000ff">="DateTime"</span> <span style="color: #ff0000">column</span><span style="color: #0000ff">="UPDATED_DATETIME"</span> <span style="color: #ff0000">not-null</span><span style="color: #0000ff">="false"</span><span style="color: #0000ff">/&gt;</span>
<span style="color: #0000ff">&lt;/</span><span style="color: #800000">component</span><span style="color: #0000ff">&gt;</span>
</pre>
</div>

That works well, but I hate having to repeat that all over the place. I would rather just have one single line that maps a Timestamp. I experimented with creating a custom mapping type using the [ICompositeUserType](http://www.surcombe.com/nhibernate-1.2/api/html/AllMembers_T_NHibernate_UserTypes_ICompositeUserType.htm) and got a little closer to the goal. Here&#8217;s the class:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> TimestampMappingType : ICompositeUserType
{
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> IsMutable
    {
        get { <span style="color: #0000ff">return</span> <span style="color: #0000ff">true</span>; }
    }

    <span style="color: #0000ff">public</span> Type ReturnedClass
    {
        get { <span style="color: #0000ff">return</span> <span style="color: #0000ff">typeof</span>(Timestamp); }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span>[] PropertyNames
    {
        get { <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span>[] { <span style="color: #006080">"CreatedByStaff"</span>, <span style="color: #006080">"UpdatedByStaff"</span>, <span style="color: #006080">"CreatedDateTime"</span>, <span style="color: #006080">"UpdatedDateTime"</span> }; }
    }

    <span style="color: #0000ff">public</span> IType[] PropertyTypes
    {
        get { <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span>[] { NHibernateUtil.String, NHibernateUtil.String, NHibernateUtil.DateTime, NHibernateUtil.DateTime}; }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">object</span> Assemble(<span style="color: #0000ff">object</span> cached, ISessionImplementor session, <span style="color: #0000ff">object</span> owner)
    {
        <span style="color: #0000ff">return</span> DeepCopy(cached);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">object</span> GetPropertyValue(<span style="color: #0000ff">object</span> component, <span style="color: #0000ff">int</span> property)
    {
        var timestamp = AsTimestamp(component);

        <span style="color: #0000ff">switch</span>(property)
        {
            <span style="color: #0000ff">case</span> 0:
                <span style="color: #0000ff">return</span> timestamp.CreatedByStaff;
            <span style="color: #0000ff">case</span> 1:
                <span style="color: #0000ff">return</span> timestamp.UpdatedByStaff;
            <span style="color: #0000ff">case</span> 2:
                <span style="color: #0000ff">return</span> timestamp.CreatedDateTime;
            <span style="color: #0000ff">case</span> 3:
                <span style="color: #0000ff">return</span> timestamp.UpdatedDateTime;
            <span style="color: #0000ff">default</span>:
                <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> YourException(<span style="color: #006080">"No implementation for property index of '{0}'."</span>, property);
        }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SetPropertyValue(<span style="color: #0000ff">object</span> component, <span style="color: #0000ff">int</span> property, <span style="color: #0000ff">object</span> <span style="color: #0000ff">value</span>)
    {
        <span style="color: #0000ff">if</span> (component == <span style="color: #0000ff">null</span>)
            <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> ArgumentNullException(<span style="color: #006080">"component"</span>);

        var timestamp = AsTimestamp(component);
        <span style="color: #0000ff">switch</span> (property)
        {
            <span style="color: #0000ff">case</span> 0:
                timestamp.CreatedByStaff = (<span style="color: #0000ff">string</span>)<span style="color: #0000ff">value</span>;
                <span style="color: #0000ff">break</span>;
            <span style="color: #0000ff">case</span> 1:
                timestamp.UpdatedByStaff = (<span style="color: #0000ff">string</span>)<span style="color: #0000ff">value</span>;
                <span style="color: #0000ff">break</span>;
            <span style="color: #0000ff">case</span> 2:
                timestamp.CreatedDateTime = (DateTime?)<span style="color: #0000ff">value</span>;
                <span style="color: #0000ff">break</span>;
            <span style="color: #0000ff">case</span> 3:
                timestamp.UpdatedDateTime = (DateTime?)<span style="color: #0000ff">value</span>;
                <span style="color: #0000ff">break</span>;
            <span style="color: #0000ff">default</span>:
                <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> YourException(<span style="color: #006080">"No implementation for property index of '{0}'."</span>, property);
        }           
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">object</span> NullSafeGet(IDataReader dr, <span style="color: #0000ff">string</span>[] names, ISessionImplementor session, <span style="color: #0000ff">object</span> owner)
    {
        var createdByStaff = NHibernateUtil.String.NullSafeGet(dr, names[0]);
        var updatedByStaff = NHibernateUtil.String.NullSafeGet(dr, names[1]);
        var createdDateTime = NHibernateUtil.DateTime.NullSafeGet(dr, names[2]);
        var updatedDateTime = NHibernateUtil.DateTime.NullSafeGet(dr, names[3]);

        <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> Timestamp
        {
            CreatedByStaff = (<span style="color: #0000ff">string</span>)createdByStaff,
            UpdatedByStaff = (<span style="color: #0000ff">string</span>)updatedByStaff,
            CreatedDateTime = (DateTime?)createdDateTime,
            UpdatedDateTime = (DateTime?)updatedDateTime
        };
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> NullSafeSet(IDbCommand cmd, <span style="color: #0000ff">object</span> <span style="color: #0000ff">value</span>, <span style="color: #0000ff">int</span> index, ISessionImplementor session)
    {
        <span style="color: #0000ff">if</span> (<span style="color: #0000ff">value</span> == <span style="color: #0000ff">null</span>)
        {
            ((IDataParameter)cmd.Parameters[index]).Value = DBNull.Value;
            ((IDataParameter)cmd.Parameters[index+1]).Value = DBNull.Value;
            ((IDataParameter)cmd.Parameters[index+2]).Value = DBNull.Value;
            ((IDataParameter)cmd.Parameters[index+3]).Value = DBNull.Value;
        }
        <span style="color: #0000ff">else</span>
        {
            var timestamp = AsTimestamp(<span style="color: #0000ff">value</span>);

            ((IDataParameter)cmd.Parameters[index]).Value = (<span style="color: #0000ff">object</span>)timestamp.CreatedByStaff ?? DBNull.Value;
            ((IDataParameter)cmd.Parameters[index + 1]).Value = (<span style="color: #0000ff">object</span>)timestamp.UpdatedByStaff ?? DBNull.Value;
            ((IDataParameter)cmd.Parameters[index + 2]).Value = (<span style="color: #0000ff">object</span>)timestamp.CreatedDateTime ?? DBNull.Value;
            ((IDataParameter)cmd.Parameters[index + 3]).Value = (<span style="color: #0000ff">object</span>)timestamp.UpdatedDateTime ?? DBNull.Value;
        }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">object</span> DeepCopy(<span style="color: #0000ff">object</span> <span style="color: #0000ff">value</span>)
    {
        <span style="color: #0000ff">if</span>(<span style="color: #0000ff">value</span> == <span style="color: #0000ff">null</span>) <span style="color: #0000ff">return</span> <span style="color: #0000ff">null</span>;

        var original = AsTimestamp(<span style="color: #0000ff">value</span>);

        <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> Timestamp
                   {
                        CreatedByStaff = original.CreatedByStaff, 
                        UpdatedByStaff = original.UpdatedByStaff,
                        CreatedDateTime = original.CreatedDateTime,
                        UpdatedDateTime = original.UpdatedDateTime
                    };
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">object</span> Disassemble(<span style="color: #0000ff">object</span> <span style="color: #0000ff">value</span>, ISessionImplementor session)
    {
        <span style="color: #0000ff">return</span> DeepCopy(<span style="color: #0000ff">value</span>);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">object</span> Replace(<span style="color: #0000ff">object</span> original, <span style="color: #0000ff">object</span> target, ISessionImplementor session, <span style="color: #0000ff">object</span> owner)
    {
        <span style="color: #0000ff">return</span> DeepCopy(original);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">new</span> <span style="color: #0000ff">bool</span> Equals(<span style="color: #0000ff">object</span> x, <span style="color: #0000ff">object</span> y)
    {
        <span style="color: #0000ff">if</span> (ReferenceEquals(x, y)) <span style="color: #0000ff">return</span> <span style="color: #0000ff">true</span>;

        <span style="color: #0000ff">if</span> (x == <span style="color: #0000ff">null</span> || y == <span style="color: #0000ff">null</span>) <span style="color: #0000ff">return</span> <span style="color: #0000ff">false</span>;

        <span style="color: #0000ff">return</span> x.Equals(y);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">int</span> GetHashCode(<span style="color: #0000ff">object</span> x)
    {
        <span style="color: #0000ff">return</span> x == <span style="color: #0000ff">null</span> ? <span style="color: #0000ff">typeof</span>(Timestamp).GetHashCode() + 321 : x.GetHashCode();
    }

    <span style="color: #0000ff">private</span> <span style="color: #0000ff">static</span> Timestamp AsTimestamp(<span style="color: #0000ff">object</span> <span style="color: #0000ff">value</span>)
    {
        <span style="color: #0000ff">if</span> (<span style="color: #0000ff">value</span> == <span style="color: #0000ff">null</span>) <span style="color: #0000ff">return</span> <span style="color: #0000ff">null</span>;

        var ts = <span style="color: #0000ff">value</span> <span style="color: #0000ff">as</span> Timestamp;

        <span style="color: #0000ff">if</span>(ts == <span style="color: #0000ff">null</span>)
            <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> YourException(<span style="color: #006080">"Expected '{0}' but recieved '{1}'."</span>, <span style="color: #0000ff">typeof</span>(Timestamp), <span style="color: #0000ff">value</span>.GetType());

        <span style="color: #0000ff">return</span> ts;
    }
}</pre>
</div>

Using this class in my mapping, I can now shorten the Timestamp mapping to:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">&lt;</span><span style="color: #800000">property</span> <span style="color: #ff0000">name</span><span style="color: #0000ff">="Timestamp"</span> <span style="color: #ff0000">type</span><span style="color: #0000ff">="XYZ.DataAccess.TimestampMappingType, XYZ.DataAccess"</span><span style="color: #0000ff">&gt;</span>
  <span style="color: #0000ff">&lt;</span><span style="color: #800000">column</span> <span style="color: #ff0000">name</span><span style="color: #0000ff">="CREATED_BY_STAFF"</span> <span style="color: #0000ff">/&gt;</span>
  <span style="color: #0000ff">&lt;</span><span style="color: #800000">column</span> <span style="color: #ff0000">name</span><span style="color: #0000ff">="UPDATED_BY_STAFF"</span> <span style="color: #0000ff">/&gt;</span>
  <span style="color: #0000ff">&lt;</span><span style="color: #800000">column</span> <span style="color: #ff0000">name</span><span style="color: #0000ff">="CREATED_DATETIME"</span> <span style="color: #0000ff">/&gt;</span>
  <span style="color: #0000ff">&lt;</span><span style="color: #800000">column</span> <span style="color: #ff0000">name</span><span style="color: #0000ff">="UPDATED_DATETIME"</span> <span style="color: #0000ff">/&gt;</span>
<span style="color: #0000ff">&lt;/</span><span style="color: #800000">property</span><span style="color: #0000ff">&gt;</span>
</pre>
</div>

That&#8217;s a little better but I was hoping I could get away with not having to define the columns (they&#8217;re the same on every table) but I don&#8217;t see a way to set defaults (maybe I&#8217;m in the wrong place?). In the end, I&#8217;m not sure this really buys me much more than just mapping Timestamp as a component, but I&#8217;ll poke around a little more to see if I can figure it out.

<div class="wlWriterSmartContent" style="padding-right: 0px;padding-left: 0px;padding-bottom: 0px;margin: 0px;padding-top: 0px">
  Technorati Tags: <a href="http://technorati.com/tags/NHibernate" rel="tag">NHibernate</a>,<a href="http://technorati.com/tags/.NET" rel="tag">.NET</a>
</div>