---
wordpress_id: 4636
title: 'DDD &#8211; Making meaningful relationships'
date: 2008-10-28T03:35:00+00:00
author: Colin Jack
layout: post
wordpress_guid: /blogs/colinjack/archive/2008/10/28/ddd-making-meaningful-relationships.aspx
categories:
  - DDD
---
A recent [discussion on the DDD forum](http://tech.groups.yahoo.com/group/domaindrivendesign/message/8276) made me want to post about what I consider to be an under-appreciated aspect of domain modelling, namely relationships. In the [thread](http://tech.groups.yahoo.com/group/domaindrivendesign/message/8276) Randy Stafford said the following:

> Note that RoleRegistration is an example of a Relationship Object &ndash; arguably a fourth archetype of domain object alongside Entity, Value Object, and Aggregate.

I couldn&#8217;t agree more with this, in a domain model I worked on recently we had a stack of very useful and very meaningful relationship objects that served a range of purposes. 

For example if a <span style="font-style: italic" class="Apple-style-span">Client </span>has <span style="font-style: italic" class="Apple-style-span">Accounts </span>then it is possible that you can get away with just having that as a direct relationship but its equally possible that the relationship itself is meaningful and carries its own data/behavior. In this case you might have a type association with the relationship that would explain if the <span style="font-style: italic" class="Apple-style-span">Client </span>owns the <span style="font-style: italic" class="Apple-style-span">Account</span><span style="font-style: italic" class="Apple-style-span">,</span> or whethery just manage it, or whether they are actually just one of several owners.

<div>
  <span style="font-weight: bold" class="Apple-style-span">Aggregates</span>
</div>

You need to consider aggregate boundaries especially carefully when using Relationship Objects.

In the case of an association between a <span style="font-style: italic" class="Apple-style-span">Client </span>and an <span style="font-style: italic" class="Apple-style-span">Account </span>the relationship<span style="font-style: italic" class="Apple-style-span">&nbsp;</span>probably belongs to the <span style="font-style: italic" class="Apple-style-span">Client </span>aggregate. 

Then again if you choose to model the association between a <span style="font-style: italic" class="Apple-style-span">Client </span>and <span style="font-style: italic" class="Apple-style-span">SalesAdvisor </span>using a full blown [party/role/relationship](http://www.amazon.co.uk/Enterprise-Patterns-MDA-Archetype-Technology/dp/032111230X/ref=sr_1_1?ie=UTF8&s=books&qid=1225226806&sr=8-1) approach then things become a big more complex. Are all parties and roles and relationships different aggregates or does a relationship own the two roles it composes?

If its the latter then you may be breaking an aggregate design rule because the party now refers to a piece of the relationship aggregate other than root. 

<div>
  <p>
    <strong>Temporal Associations</strong>
  </p>
  
  <p>
    Another common case is that the relationship is temporal which brings with it a lot of complexity and should only be done with extreme care.&nbsp; If your sure you need temporal associations then you will find <a href="http://martinfowler.com/ap2/timeNarrative.html">Martin Fowlers patterns</a> invaluable.
  </p>
</div>

<span style="font-weight: bold" class="Apple-style-span"></span>

<div>
  <span style="font-weight: bold" class="Apple-style-span">Encapsulating Relationships</span>
</div>

<div>
</div>

Most of the relationships have real meaning in their own right but sometimes they are just an artifact of the design, in those cases you can demote the associations to being just an encapsulated detail.

Take the association between <span style="font-style: italic" class="Apple-style-span">Client </span>and <span style="font-style: italic" class="Apple-style-span">Account</span>, maybe when you ask for the <span style="font-style: italic" class="Apple-style-span">Accounts </span>for a <span style="font-style: italic" class="Apple-style-span">Client</span> you want to get the <span style="font-style: italic" class="Apple-style-span">Account </span>objects rather than the <span style="font-style: italic" class="Apple-style-span">ClientAccountRelationship </span>objects. 

If this were the case you could keep the <span style="font-style: italic" class="Apple-style-span">ClientAccountRelationship </span>class, which has its own data/behaviour and makes mapping easier, but entirely hide it from users of the domain. One way to do this is to create [custom collection](http://colinjack.blogspot.com/2008/09/nhibernate-mapping-custom-collections.html) called <span style="font-style: italic" class="Apple-style-span">ClientAccounts <span style="font-style: normal" class="Apple-style-span">and have it </span><span style="font-style: normal" class="Apple-style-span">wrap and <em>IList</em> of <em>ClientAccountRelationships</em> whilst acting like it is just a simple <em>IList</em> of <em>Accounts</em>, it can also provide helpful methods like <span style="font-style: italic" class="Apple-style-span">FindPrimaryOwner.</span></span></span>

<div>
  <span style="font-weight: bold" class="Apple-style-span">Summary</span>
</div>

<div>
</div>

I mention all of this because when I got started with DDD relationship objects bothered me especially as we were working with a legacy database and I saw the relationship objects as being a problem caused by the number of join tables. At the time my plan was to get rid of a lot of them by taking advantage of NHibernate magic. 

However as I got a bit more experience I realized that they were key and although we encapsulated some (when they <span style="font-style: italic" class="Apple-style-span">were</span> just an artifact of the design) we made others totally key parts of the design. In both cases the relationships themselves were very useful.