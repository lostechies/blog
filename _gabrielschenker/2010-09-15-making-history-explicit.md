---
wordpress_id: 46
title: Making history explicit
date: 2010-09-15T04:19:00+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: /blogs/gabrielschenker/archive/2010/09/15/making-history-explicit.aspx
dsq_thread_id:
  - "263908933"
categories:
  - Fluent NHibernate
  - How To
  - NHibernate
redirect_from: "/blogs/gabrielschenker/archive/2010/09/15/making-history-explicit.aspx/"
---
## Introduction

In one product of our solution we needed to record the full history of some entities. What does this mean? It means we create a history entry whenever the state of the corresponding entity changes. 

When doing this there are basically two ways one can choose – either implicitly generate the history records or doing it explicitly. To go the implicit route we could have used an interceptor mechanism to automatically and transparently create&#160; a history record whenever the entity changes and the change is persisted to the database.

Since we chose to go the explicit route creating a history for an entity became a domain concept.

## The domain

To show the concept I chose the sample of a Zoo whose management wants to keep track of the cages used throughout the facility as well as of the animals hosted in the cages. Let’s start with the simplified model of a cage and its cage history. In this model the cage entity represents the status quo that is the current state of the cage. Each cage has a collection of cage history entities which represent the full history of the cage from the moment it first appeared in the Zoo till the present day. Each cage history entity represents a snapshot of the cage’s state at a specific time in the past.

The current state (i.e. the cage) is important whenever the Zoo management wants to make an inventory (or census) of all cages and animals. On the other hand the history records (i.e. cage history entities) are important whenever the management wants to do retrospective reporting and/or billing. 

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2011/03/image_thumb_1C8E9EAA.png" width="601" height="360" />](https://lostechies.com/content/gabrielschenker/uploads/2011/03/image_5D30EB19.png) 

As we can see in the above image a cage is of a certain cage type and is located at a specific location. The cage has many other properties which I do not show here to keep the sample as simple as possible. Now a cage is installed at some location but this location may change over time (imagine a fish tank that is move from floor A of building 1 to floor B. In such a situation a history record has to be generated.

To simplify things a little bit and to remain as DRY as possible **Cage** and **CageHistory** both derive from **VersionedEntity**<T>. **VersionedEntity**<T> in turn inherits from **Entity**<T>. Each entity in our domain inherits directly or indirectly from **Entity**<T> which provides the unique ID for the entity and implements equality based on this ID. If you want to know more about the implementation details of such a base class then please refer to [this](http://blogs.hibernatingrhinos.com/nhibernate/archive/2008/04/04/identity-field-equality-and-hash-code.aspx) post.

The **VersionedEntity**<T> simply provides a Version (int) property to the corresponding entity. We have chosen to represent the flow through time of the entities needing to be historized with this version property.

## Implementation of the model

xxx

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Cage : VersionedEntity&lt;Cage&gt;</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">int</span> lastVersion;</pre>
    
    <pre>    <span style="color: #0000ff">private</span> CageHistory currentHistory;</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> Cage(CageType cageType, Location location)</pre>
    
    <pre>    {</pre>
    
    <pre>        lastVersion = <span style="color: #0000ff">int</span>.MinValue;</pre>
    
    <pre>        CageType = cageType;</pre>
    
    <pre>        Location = location;</pre>
    
    <pre>        cageHistories = <span style="color: #0000ff">new</span> List&lt;CageHistory&gt;();</pre>
    
    <pre>&#160;</pre>
    
    <pre>        CreateOrUpdateHistoryRecord();</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">protected</span> Cage() { } <span style="color: #008000">// default constructor only needed to satisfy NHibernate</span></pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">virtual</span> CageType CageType { get; <span style="color: #0000ff">private</span> set; }</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">virtual</span> Location Location { get; <span style="color: #0000ff">private</span> set; }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">private</span> IList&lt;CageHistory&gt; cageHistories;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">virtual</span> IEnumerable&lt;CageHistory&gt; CageHistories { get { <span style="color: #0000ff">return</span> cageHistories; } }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">virtual</span> <span style="color: #0000ff">void</span> ChangeLocation(Location newLocation)</pre>
    
    <pre>    {</pre>
    
    <pre>        Location = newLocation;</pre>
    
    <pre>        CreateOrUpdateHistoryRecord();</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> CreateOrUpdateHistoryRecord()</pre>
    
    <pre>    {</pre>
    
    <pre>        <span style="color: #0000ff">if</span> (lastVersion != Version)</pre>
    
    <pre>        {</pre>
    
    <pre>            Version++;</pre>
    
    <pre>            currentHistory = <span style="color: #0000ff">new</span> CageHistory();</pre>
    
    <pre>            cageHistories.Add(currentHistory);</pre>
    
    <pre>            lastVersion = Version;</pre>
    
    <pre>        }</pre>
    
    <pre>        currentHistory.CreateFromCage(<span style="color: #0000ff">this</span>);</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

We want to only deal with cage entities that are always in a **valid** state (but for simplicity I do not show the validation code). A cage object can be instantiated in exactly two ways either through the constructor (if its a new cage) which expects a cage type and a location as arguments or it can be instantiated by NHibernate and populated with data from the database (if it already exists). We assume that the data in the database is valid.

### Creating or updating a history record

The method **CreateOrUpdateHistoryRecord** is responsible to either create a new or update an existing history record. Note that we create exactly one history record per unit of work if the cage entity is changed, independent of how many times the cage is changed. 

In our sample code we have exactly two places where the state of a cage changes namely during creation (constructor) and when the location changes. Each time we call the **CreateOrUpdateHistoryRecord**&#160; method.

### Why are all properties read-only?

In our applications we chose to not use property setters in the domain. Assigning values to properties of an entity is in many case not expressive enough. The assignment of a specific value to a given property is not intention revealing. The more complex a domain gets the more important is this fact. Thus we have methods to change state of an entity. In our simple sample this might be an overkill specifically since the method **ChangeLocation** only changes one property. But often we encounter situations where we have to change several interrelated properties in one atomic operation.

Let’s now have a look at the CageHistory class

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> CageHistory : VersionedEntity&lt;CageHistory&gt;</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">virtual</span> Cage Cage { get; set; }</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">virtual</span> CageType CageType { get; <span style="color: #0000ff">private</span> set; }</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">virtual</span> Location Location { get; <span style="color: #0000ff">private</span> set; }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">virtual</span> <span style="color: #0000ff">void</span> CreateFromCage(Cage cage)</pre>
    
    <pre>    {</pre>
    
    <pre>        Cage = cage;</pre>
    
    <pre>        Version = cage.Version;</pre>
    
    <pre>        CageType = cage.CageType;</pre>
    
    <pre>        Location = cage.Location;</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

We have chosen the **CageHistory** to be responsible to create itself as a snapshot of the current state of the cage. The method **CreateFromCage** is responsible for this and can be considered to be a factory method.

Other than that the **CageHistory** entity is a mirror of the **Cage** entity regarding its properties. It also contains a reference back to the Cage itself.

## Mapping of the model

To map our entities to the underlying database we choose **Fluent NHibernate**. To be more explicit we do not use the auto mapping functionality of Fluent NHibernate but rather use fluent mappings.</p> 

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> CageMap : ClassMap&lt;Cage&gt;</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">public</span> CageMap()</pre>
    
    <pre>    {</pre>
    
    <pre>        Id(x =&gt; x.Id).GeneratedBy.Assigned();</pre>
    
    <pre>        Map(x =&gt; x.Version).Not.Nullable();</pre>
    
    <pre>        References(x =&gt; x.CageType).Not.Nullable();</pre>
    
    <pre>        References(x =&gt; x.Location).Not.Nullable();</pre>
    
    <pre>        HasMany(x =&gt; x.CageHistories)</pre>
    
    <pre>            .Cascade.AllDeleteOrphan()</pre>
    
    <pre>            .Inverse()</pre>
    
    <pre>            .Access.CamelCaseField();</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

<div>
  In this sample we use client side generated IDs (Guids) which gives us a lot of flexibility; thus the mapping <strong>GeneratedBy.Assigned()</strong>. Everything else should be straight forward.
</div>

<div>
  &#160;
</div>

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> CageHistoryMap : ClassMap&lt;CageHistory&gt;</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">public</span> CageHistoryMap()</pre>
    
    <pre>    {</pre>
    
    <pre>        Id(x =&gt; x.Id).GeneratedBy.Assigned();</pre>
    
    <pre>        Map(x =&gt; x.Version).Not.Nullable();</pre>
    
    <pre>        References(x =&gt; x.Cage).Not.Nullable();</pre>
    
    <pre>        References(x =&gt; x.CageType).Not.Nullable();</pre>
    
    <pre>        References(x =&gt; x.Location).Not.Nullable();</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
  
  <p>
    Again the above mapping should be straight forward.
  </p>
</div>

## Testing

In this post I do not want to show the basic test e.g. mapping test. These kind of tests are well described in the Fluent NHibernate [wiki](http://wiki.fluentnhibernate.org/). What I want to show is how we can test whether the creation of history records is working as expected. To do the tests we use SqLite in InMemory mode as our database.</p> 

For all database related test we can use a fixture base class like this

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">abstract</span> <span style="color: #0000ff">class</span> database_fixture_base</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">private</span> ISessionFactory sessionFactory;</pre>
    
    <pre>    <span style="color: #0000ff">protected</span> ISession session;</pre>
    
    <pre>    <span style="color: #0000ff">private</span> Configuration configuration;</pre>
    
    <pre>&#160;</pre>
    
    <pre>    [TestFixtureSetUp]</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> TestFixtureSetup()</pre>
    
    <pre>    {</pre>
    
    <pre>        sessionFactory = Fluently.Configure()</pre>
    
    <pre>            .Database(SQLiteConfiguration.Standard.ShowSql().InMemory)</pre>
    
    <pre>            .Mappings(m =&gt; m.FluentMappings.AddFromAssemblyOf&lt;Cage&gt;())</pre>
    
    <pre>            .ExposeConfiguration(c =&gt; configuration = c)</pre>
    
    <pre>            .BuildSessionFactory();</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    [SetUp]</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Setup()</pre>
    
    <pre>    {</pre>
    
    <pre>        session = sessionFactory.OpenSession();</pre>
    
    <pre>        <span style="color: #0000ff">new</span> SchemaExport(configuration).Execute(<span style="color: #0000ff">false</span>, <span style="color: #0000ff">true</span>, <span style="color: #0000ff">false</span>, session.Connection, <span style="color: #0000ff">null</span>);</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    [TearDown]</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> TearDown()</pre>
    
    <pre>    {</pre>
    
    <pre>        session.Dispose();</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

Note how easy and expressibe the configuration of NHibernate becomes when using Fluent NHibernate. Before each test we create a new session and use this session to create the database schema by using the NHibernate **SchemaExport** class. After each test we dispose the session. The database schema is deleted when disposing the session when using SqLite in InMemory mode. This is exactly what we need to avoid any side effects from test to test.

<div>
  <div>
    <pre>[TestFixture]</pre>
    
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> cage_mapping_specs : database_fixture_base</pre>
    
    <pre>{</pre>
    
    <pre>    [Test]</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> creating_a_cage_creates_a_cage_history()</pre>
    
    <pre>    {</pre>
    
    <pre>        var cageType = <span style="color: #0000ff">new</span> CageType { Name = <span style="color: #006080">"Small lion cage"</span> };</pre>
    
    <pre>        var location = <span style="color: #0000ff">new</span> Location { Name = <span style="color: #006080">"House of Africa"</span> };</pre>
    
    <pre>        var cage = <span style="color: #0000ff">new</span> Cage(cageType, location);</pre>
    
    <pre>&#160;</pre>
    
    <pre>        session.Save(cageType);</pre>
    
    <pre>        session.Save(location);</pre>
    
    <pre>        session.Save(cage);</pre>
    
    <pre>        session.Flush();</pre>
    
    <pre>&#160;</pre>
    
    <pre>        session.Clear();</pre>
    
    <pre>&#160;</pre>
    
    <pre>        var fromDb = session.Get&lt;Cage&gt;(cage.Id);</pre>
    
    <pre>&#160;</pre>
    
    <pre>        Assert.That(fromDb.CageHistories.Count(), Is.EqualTo(1));</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    [Test]</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> changing_location_of_a_cage_creates_a_cage_history()</pre>
    
    <pre>    {</pre>
    
    <pre>        var cageType = <span style="color: #0000ff">new</span> CageType { Name = <span style="color: #006080">"Small lion cage"</span> };</pre>
    
    <pre>        var location = <span style="color: #0000ff">new</span> Location { Name = <span style="color: #006080">"House of Africa"</span> };</pre>
    
    <pre>        var location2 = <span style="color: #0000ff">new</span> Location { Name = <span style="color: #006080">"House of Madagaskar"</span> };</pre>
    
    <pre>        var cage = <span style="color: #0000ff">new</span> Cage(cageType, location);</pre>
    
    <pre>&#160;</pre>
    
    <pre>        session.Save(cageType);</pre>
    
    <pre>        session.Save(location);</pre>
    
    <pre>        session.Save(location2);</pre>
    
    <pre>        session.Save(cage);</pre>
    
    <pre>        session.Flush();</pre>
    
    <pre>&#160;</pre>
    
    <pre>        session.Clear();</pre>
    
    <pre>&#160;</pre>
    
    <pre>        var fromDb = session.Get&lt;Cage&gt;(cage.Id);</pre>
    
    <pre>        fromDb.ChangeLocation(location2);</pre>
    
    <pre>        session.Flush();</pre>
    
    <pre>        session.Clear();</pre>
    
    <pre>&#160;</pre>
    
    <pre>        var fromDb2 = session.Get&lt;Cage&gt;(cage.Id);</pre>
    
    <pre>        Assert.That(fromDb2.CageHistories.Count(), Is.EqualTo(2));</pre>
    
    <pre>        Assert.That(fromDb2.Version, Is.EqualTo(2));</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

The two tests above should be pretty much self describing.

## Summary

In this post I have shown how history of an entity can be made explicit by making it a domain concept. This approach is much more discoverable than a implicit approach where history is generated auto magically by e.g. using an interceptor mechanism at the database or ORM framework level.

In a following post I will introduce animals to populate the cages and discuss the implications to the model and mapping of the model.