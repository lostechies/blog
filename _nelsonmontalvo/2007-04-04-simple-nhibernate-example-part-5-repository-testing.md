---
id: 16
title: 'Simple NHibernate Example, Part 5: Repository Testing'
date: 2007-04-04T00:20:00+00:00
author: Nelson Montalvo
layout: post
guid: /blogs/nelson_montalvo/archive/2007/04/03/simple-nhibernate-example-part-5-repository-testing.aspx
categories:
  - NHibernate
---
<a href="http://devlicio.us/blogs/billy%5Fmccafferty/" target="_blank">Bill McCafferty</a> has released his updates to his NHibernate Best Practices article. <a href="http://www.codeproject.com/aspnet/NHibernateBestPractices.asp" target="_blank">The article</a> is fantastic. It is listed as an advanced topic, but if you follow every link and study the topics in his article, the article makes for as great&nbsp;a comprehensive introduction as any&#8230; Go <a href="http://www.codeproject.com/aspnet/NHibernateBestPractices.asp" target="_blank">read it</a> now. 

In the last few posts, we explored very simple concepts from the point of view of DDD and&nbsp;BDD/TDD. In this post, I will put together a very simple testing harness to show how to roll together these concepts&nbsp;in the context of&nbsp;NHibernate.

Begin by reviewing the interface created in <a href="http://www.lostechies.com/blogs/nelson_montalvo/archive/2007/03/30/simple-nhibernate-example-part-3-initial-repository-implementation.aspx" title="Simple NHibernate Example, Part 3" target="_blank">Part 3</a>. In that example, the Repository interface is placed at the domain level (Foo.Domain.Repositories.DealerRepository &#8211; and no, <a href="http://codebetter.com/blogs/jeremy.miller/archive/2006/04/26/143489.aspx" target="_blank">I don&#8217;t use the I in my interfaces</a>). Again, the idea is that a _Repository_ is a domain level concept for managing the lifecycle of _Entities_. However, the implementation of&nbsp;the persistence mechanism&nbsp;is abstracted from the domain&#8217;s point of view. 

We will create an implementation of the repository&nbsp;interface&nbsp;for&nbsp;NHibernate.&nbsp;I know there are <a href="http://www.ayende.com/Blog/archive/2007/03/20/Repositories-101.aspx" target="_blank">many ways to implement repositories</a>, but I&#8217;m keeping it easy for this example.

One other side note &#8211; this example is copying&nbsp;over the same&nbsp;specs/tests from Part 3 for my NHibernate tests, but you could imagine reusing them somehow by injecting in mock or NHibernate implementations of the interface. I really haven&#8217;t explored an idea like this, but if somebody has, let me know.

Everything needed for this repository example is in the sample zip file. Go <a href="http://groups.google.com/group/lostechies/web/Foo.Domain.zip" target="_blank">download the zip file</a>&nbsp;now. You will want to focus on the Foo.Data.NHibernate and Tests.Foo.Data.NHibernate projects to see how it all works. Post your questions here.

&nbsp;

<u>Supporting Items</u>

The&nbsp;database schema is included in the solution if you would like to run that to build the FooDomain database and Dealer table.

This Dealer domain object to table mapping file is located in the&nbsp;Foo.Data.NHibernate project under the DomainMappings folder.&nbsp;The file also&nbsp;contains a component mapping for a phone number&nbsp;Va_lue_ object (the fax number and contact phone number). Let&#8217;s just say that it is important for us to store the phone number broken down into its constituent parts (area code, exchange and SLID) for this example. 

In the mapping file,&nbsp;I&nbsp;use of the&nbsp;<span style="color: red">access</span><span style="color: blue">=</span><span style="color: black">&#8220;</span><span style="color: blue">nosetter.camelcase</span><span style="color: black">&#8220;</span> access attribute. This tells NHibernate to set the field values directly rather than through the properties (since no setter is available, as we would like to keep IDs and value object references immutable,&nbsp;as you will see in a moment).

I use a customized version of <a href="http://www.ndbunit.org/" target="_blank">nDbUnit</a> to allow for rollbacks of transactions rather than explicit delete. My customized version is included in the project file (which is what makes&nbsp;the&nbsp;zip file&nbsp;pretty big) and could use some cleanup if you want to take that on. 🙂 The project, Tests.Foo.Data.NHibernate contains the xsd used by nDbUnit and you can review the tests to see how it is read into. 

My customizations also reset the identity value on the Dealer table
  
after a DeleteAll is called. 

I did not explicitly call flush after the NHibernate save() calls, which
  
would immediately write the data to the database. The flush is done automatically since
  
NHibernate has to go to the database to pull the identity value and set
  
it on the domain object. This is an important point since NDbUnit needs
  
to have some data to read from the database. 🙂 

Finally, the tests show how to extract the
  
NHibernate transaction and pass it to NDbUnit in the GetTransaction()
  
method.  
&nbsp;