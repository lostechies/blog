---
wordpress_id: 4738
title: 'Castle&#8217;s ActiveRecord: Not for the Domain Purist in you&#8230;'
date: 2007-04-17T00:45:26+00:00
author: Nelson Montalvo
layout: post
wordpress_guid: /blogs/nelson_montalvo/archive/2007/04/16/castle-s-activerecord-not-for-the-domain-purist-in-you.aspx
categories:
  - Castle
  - Domain Driven Design
  - NHibernate
---
&nbsp;I finally &#8220;broke down&#8221; and began using ActiveRecord just to try it out. <a href="http://www.castleproject.org/monorail/gettingstarted/ar.html" target="_blank">Here&#8217;s the tutorial</a> that I used. Now, don&#8217;t get me wrong &#8211;&nbsp;ActiveRecord is built on top of NHibernate and it&#8217;s one of the fastest ways to start working with your persistence layer.

So what&#8217;s the problem?

Well, it&#8217;s this:

<div style="font-size: 10pt;background: white;color: black;font-family:">
  <p style="margin: 0px">
    <span style="color: blue">using</span> Castle.ActiveRecord;
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">namespace</span> Foo.Domain
  </p>
  
  <p style="margin: 0px">
    {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; [<span style="color: #2b91af">ActiveRecord</span>]
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">class</span> <span style="color: #2b91af">Dealer</span> : <span style="color: #2b91af">ActiveRecordBase</span><<span style="color: #2b91af">Dealer</span>>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">private</span> <span style="color: blue">int</span> id;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">private</span> <span style="color: blue">string</span> contactFirstName;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">private</span> <span style="color: blue">string</span> contactLastName;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">private</span> <span style="color: blue">string</span> businessName;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">private</span> <span style="color: #2b91af">Address</span> address;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">private</span> <span style="color: blue">string</span> email;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">private</span> <span style="color: #2b91af">PhoneNumber</span> contactPhoneNumber;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">private</span> <span style="color: #2b91af">PhoneNumber</span> faxNumber;
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> Dealer()
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; address = <span style="color: blue">new</span> <span style="color: #2b91af">Address</span>();
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; contactPhoneNumber = <span style="color: blue">new</span> <span style="color: #2b91af">PhoneNumber</span>();
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; faxNumber = <span style="color: blue">new</span> <span style="color: #2b91af">PhoneNumber</span>();
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; [<span style="color: #2b91af">PrimaryKey</span>(<span style="color: #2b91af">PrimaryKeyType</span>.Identity, <span style="color: #a31515">&#8220;DealerId&#8221;</span>, Access=<span style="color: #2b91af">PropertyAccess</span>.NosetterCamelcase)]
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">int</span> Id
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">get</span> { <span style="color: blue">return</span> id; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; [<span style="color: #2b91af">Property</span>]
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">virtual</span> <span style="color: blue">string</span> BusinessName
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">get</span> { <span style="color: blue">return</span> businessName; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">set</span> { businessName = <span style="color: blue">value</span>; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; [<span style="color: #2b91af">Property</span>]
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">virtual</span> <span style="color: blue">string</span> ContactFirstName
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">get</span> { <span style="color: blue">return</span> contactFirstName; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">set</span> { contactFirstName = <span style="color: blue">value</span>; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; [<span style="color: #2b91af">Property</span>]
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">virtual</span> <span style="color: blue">string</span> ContactLastName
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">get</span> { <span style="color: blue">return</span> contactLastName; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">set</span> { contactLastName = <span style="color: blue">value</span>; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; [<span style="color: #2b91af">Property</span>]
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">virtual</span> <span style="color: blue">string</span> Email
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">get</span> { <span style="color: blue">return</span> email; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">set</span> { email = <span style="color: blue">value</span>; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; [<span style="color: #2b91af">Nested</span>(<span style="color: #a31515">&#8220;ContactPhoneNumber&#8221;</span>)]
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">virtual</span> <span style="color: #2b91af">PhoneNumber</span> ContactPhoneNumber
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">get</span> { <span style="color: blue">return</span> contactPhoneNumber; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">set</span> { contactPhoneNumber = <span style="color: blue">value</span>; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; [<span style="color: #2b91af">Nested</span>(<span style="color: #a31515">&#8220;FaxNumber&#8221;</span>)]
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">virtual</span> <span style="color: #2b91af">PhoneNumber</span> FaxNumber
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">get</span> { <span style="color: blue">return</span> faxNumber; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">set</span> { contactPhoneNumber = <span style="color: blue">value</span>; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; [<span style="color: #2b91af">Nested</span>]
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">virtual</span> <span style="color: #2b91af">Address</span> Address
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">get</span> { <span style="color: blue">return</span> address; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">set</span> { address = <span style="color: blue">value</span>; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    }
  </p>
</div>

Those attributes are tagging persistence concerns all over my domain object!!&nbsp;The class also inherits&nbsp;from ActiveRecordBase<T>, a persistence focused class having nothing to do with&nbsp;the domain itself.

Finally,&nbsp;the class if forced to expose a setter for&nbsp;the value objects: ContactPhoneNumber, FaxNumber, and Address.&nbsp;The class&nbsp;should not have to allow external objects to directly set properties that access value objects. An external object can directly overwrite the value object references managed by my Dealer aggregate. (Please tell me I&#8217;m wrong on this.)

Of course,&nbsp;these are&nbsp;known&nbsp;drawbacks to using AR&nbsp;and it&#8217;s really only a concern for domain purists out there (who me?). All in all, ActiveRecord is great for getting started with simple domains that map fairly easily to their relevant database tables.

Here&#8217;s all I had to do in my test to get AR Unit Testing working.

1. I borrowed and slightly modified the unit testing base class, **AbstractModelTestCase,** from <a href="http://wiki.castleproject.org/index.php/ActiveRecord:How_to:Unit_testing" target="_blank">this article</a>. I modified it to support usage of NDbUnit (the original, not my modified version):

<div style="font-size: 10pt;background: white;color: black;font-family:">
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; [<span style="color: #2b91af">SetUp</span>]
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">virtual</span> <span style="color: blue">void</span> Init()
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; sqlDbUnit = <span style="color: blue">new</span> <span style="color: #2b91af">SqlDbUnitTest</span>(GetConnectionString());
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; PrepareSchema();
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; CreateScope();
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
</div>

&nbsp;2. I wrote my&nbsp;specifications utilizing an NDbUnit schema and data file. It was as easy as:

<div style="font-size: 10pt;background: white;color: black;font-family:">
  <p style="margin: 0px">
    <span style="color: blue">using</span> Foo.Domain;
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">using</span> NUnit.Framework;
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">using</span> NDbUnit.Core;
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">namespace</span> Specifications.Foo.Domain.ActiveRecord
  </p>
  
  <p style="margin: 0px">
    {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; [<span style="color: #2b91af">TestFixture</span>]
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">class</span> <span style="color: #2b91af">ADealerListWithOneDealer</span> : <span style="color: #2b91af">AbstractModelTestCase</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">protected</span> <span style="color: blue">override</span> <span style="color: blue">void</span> PrepareSchema()
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; sqlDbUnit.ReadXmlSchema(<span style="color: #a31515">@&#8221;&#8230;.SchemasDealerSchema.xsd&#8221;</span>);
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; sqlDbUnit.ReadXml(<span style="color: #a31515">@&#8221;&#8230;.TestDataTestDataForADealerListWithOneDealer.xml&#8221;</span>);
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; sqlDbUnit.PerformDbOperation(<span style="color: #2b91af">DbOperationFlag</span>.CleanInsert);
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; [<span style="color: #2b91af">Test</span>]
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">void</span> ShouldHaveASizeOfOne()
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; FlushAndRecreateScope();
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: #2b91af">Dealer</span>[] dealers = <span style="color: #2b91af">Dealer</span>.FindAll();
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: #2b91af">Assert</span>.AreEqual(1, dealers.Length, <span style="color: #a31515">&#8220;Should have a length of 1, given the test data.&#8221;</span>);&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    }
  </p>
</div>

As you can see, almost no persistence code was written to accomplish this trivial bit of work.

<u>Repositories</u>

Repositories are not explicit using the AR method of persisting entities, as shown above. Persistence concerns are directly associated with the entity (via Find(), FindAll(), etc). Ayende has an Active Record repository implementation in his Rhino Commons library. The SVN url is [**https://svn.sourceforge.net/svnroot/rhino-tools/trunk/**](https://svn.sourceforge.net/svnroot/rhino-tools/trunk/ "https://svn.sourceforge.net/svnroot/rhino-tools/trunk/")&nbsp;and the code can be found under **rhino-commons/Rhino.Commons/Repositories**.

Ayende&#8217;s ARRepository&nbsp;implementation appears to be a way around inheriting from ActiveRecordBase<T>, but I&#8217;m not sure. Does anybody else know?