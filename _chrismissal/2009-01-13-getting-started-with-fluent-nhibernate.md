---
wordpress_id: 5
title: 'Fluent NHibernate&#8217;s AutoPersistenceModel'
date: 2009-01-13T01:39:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2009/01/12/getting-started-with-fluent-nhibernate.aspx
dsq_thread_id:
  - "262174713"
categories:
  - Fluent NHibernate
redirect_from: "/blogs/chrismissal/archive/2009/01/12/getting-started-with-fluent-nhibernate.aspx/"
---
### Much of this information may be out of date, please check <http://fluentnhibernate.org/> for current information.  


### Almost too Easy

I was really excited when I learned about this piece of the [Fluent NHibernate](http://code.google.com/p/fluent-nhibernate/) project. I&#8217;m working on a small project with some simple mappings. I started looking to [Castle&#8217;s Active Record](http://www.castleproject.org/activerecord/gettingstarted/index.html) for some quick persistence assistance, but I wasn&#8217;t thrilled with the Attributes, or the ActiveRecordMediator approach. I decided to go back to &#8220;plain old&#8221; NHibernate, but use this Fluent NHibernate project I&#8217;ve been hearing about lately.

[Ayende](http://wwww.ayende.com) posted last month about the [auto-mapping the AutoPersistenceModel provides](http://ayende.com/Blog/archive/2008/12/11/fluent-nhibernate.aspx) and how&#8217;s loving it. I too am loving it and it only gets better each day.

### Let&#8217;s Start With Conventions

Below is the code I&#8217;m using in my project to generate my persistence schema. First I&#8217;ll go over the Conventions class:

<pre>model = new AutoPersistenceModel<br />        {<br />            Conventions =<br />                {<br />                    DefaultLazyLoad = true,<br />                    GetPrimaryKeyName = (prop =&gt; prop.ReflectedType.Name + prop.Name),<br />                    GetForeignKeyNameOfParent = (type =&gt; type.Name + "Id"),<br />                    GetForeignKeyName = (prop =&gt; prop.ReflectedType.Name + "Id"),<br />                    GetTableName = (type =&gt; Inflector.Pluralize(type.Name)),<br />                    GetManyToManyTableName =<br />                        ((child, parent) =&gt;<br />                         parent.Name +  Inflector.Pluralize(child.Name))<br />                }<br />        };<br /></pre>

This is basically straight out of Ayende&#8217;s example, I modified the conventions a bit so it matches the conventions I was aiming for in the project. Most of these are very straightforward as to what they&#8217;re doing for you, but I&#8217;ll give a quick explanation to what these Conventions are doing for my mappings:

Among others, I have a Stat class and I have a Tag class. These are my primary objects and persisted data, so I&#8217;ll let you know what the Conventions will create for them: 

  * **GetPrimaryKeyName** 
      * Assigned the Func that will return the values &#8220;StatId&#8221; and &#8220;TagId&#8221; (Note: I&#8217;m using type.ReflectedType since this Func uses &#8216;type&#8217; as a PropertyInfo object, otherwise, I&#8217;d get &#8220;IdId&#8221;) 
  * **GetForeignKeyNameOfParent&nbsp;** 
  * **GetForeignKeyNameOfParent&nbsp;** 
      * Will return &#8220;StatId&#8221; and &#8220;TagId&#8221;
  * **GetForeignKeyName&nbsp;** 
      * Will return &#8220;StatId&#8221; and &#8220;TagId&#8221; as well. My Stat class has a Submitter Property, which makes sense in my code, but at the database level, I want it to be &#8216;UserId&#8217;. 
  * **GetTableName** 
      * Will return Stats and Tags (thanks to the Inflector class provided by Castle&#8217;s ActiveRecord) If you needed a convention to map here, such as S_ prefixed to table names for existing systems. Here&#8217;s where you&#8217;d do that.
  * **GetManToManyTableName** 
      * Asks you to provide the child and the parent Types to create a convention. My example will generate StatTags. You would use this to specify others such as &#8220;TagsToStats&#8221; or &#8220;Tags\_x\_Stats&#8221;

### Adding Your Entities

Ok, now that we have the Conventions (rules) set up. Time to tell this thing what we want to be persisting. I took yet another tidbit from Ayende and used his _entity.Namespace.EndsWith(&#8220;Models&#8221;)_ idea. My code is simple here, I don&#8217;t have a lot of stuff going on that needs special attention. I simply added my assembly like so:

<pre>model<br />    .AddEntityAssembly(Assembly.GetAssembly(typeof (User)))<br />    .Where(entity =&gt;<br />           entity.Namespace.EndsWith("Model") &&<br />           entity.GetProperty("Id") != null &&<br />           entity.IsAbstract == false<br />    )<br />    .Configure(configuration);<br /></pre>

That&#8217;s it, seriously. I still have to add my NHibernate configuration, so here is that:

<pre>configuration = MsSqlConfiguration.MsSql2000<br />    .ConnectionString.Is(connectionString)<br />    .UseReflectionOptimizer()<br />    .Cache.UseQueryCache()<br />    .Cache.ProviderClass()<br />    .ConfigureProperties(new Configuration());<br /></pre>

All I do from this point on is call NHibernate.Tool.hbm2ddl.SchemaExport(configuration) when I need a SQL file to update my database schema.

### Why is this better than Xml Configuration?

Before acquiring amazing tools like [JetBrains&#8217;s Resharper](http://www.jetbrains.com/resharper/), I would rename a property and then try to build to see where I couldn&#8217;t compile, and appropriately rename the usages of that property elsewhere. Now I can rename it and it will cascade to all my other usages, renaming them to the same thing. Whether you&#8217;re using a tool like this or not, you may still deal with &#8220;[Magic Strings](http://en.wikipedia.org/wiki/Magic_string_(programming))&#8220;. Using Fluent NHibernate eliminates these occurences by getting rid of the Xml files that store these nasty characters.

Another reason&#8230; Xml files as an embedded resource in order to compile the mappings? You don&#8217;t have to deal with that anymore.

### What&#8217;s to Come?

This project really excites me. It&#8217;s easy to use and it&#8217;s only getting better. Eventually it might be as simple as not having to tell the AutoPersistenceModel that: entities have a property Id as a Guid, and all my tables are going to be prefixed. I&#8217;m hoping it gets to a point where you just give it an assembly and you&#8217;re good to go (so long as you don&#8217;t have any crazy rules!)

Stay tuned to this project! There are a lot of talented people working on it and as I said earlier, you can expect new features all the time.

Here&#8217;s the link to the project: <http://code.google.com/p/fluent-nhibernate/>