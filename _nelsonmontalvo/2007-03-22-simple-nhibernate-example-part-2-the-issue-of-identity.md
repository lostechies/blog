---
id: 4730
title: 'Simple NHibernate Example, Part 2&#8230;, the &#8220;Issue&#8221; of Identity'
date: 2007-03-22T16:36:00+00:00
author: Nelson Montalvo
layout: post
guid: /blogs/nelson_montalvo/archive/2007/03/22/simple-nhibernate-example-part-2-the-issue-of-identity.aspx
categories:
  - NHibernate
---
Before going into repositories, it is important to review the idea of identifying entities in the domain. In Domain Driven Design, by definition, an <span style="font-style: italic">Entity </span>is a domain object that is defined primarily by its identity.

Identity will play an important role in interacting with repositories; looking up, saving, and tracking entites.

Consider identity from a purely technical point of view:

  1. At the CLR level, identity is provided by the object reference. A domain object is considered the same as another, if they both point to the same object reference. 
    Given two objects and in a single NHibernate Session, then you can test to see if the two objects are the same with code such as:
    
    leadBuyer1 == leadBuyer2

  2. At the database level, there are many ways to define keys to uniquely define a row. But for our example, we&#8217;ll use a simple identity column and so we end up with two objects equal to each other when: <pre style="margin: 0px">leadBuyer1.Id.Equals(leadBuyer2.Id)<span style="font-family: georgia,serif"></span></pre>

The first example is <span style="font-style: italic">object identity</span>, but the second example is more relevant to us since this is <span style="font-style: italic">persistent (or database) </span><span style="font-style: italic">identity</span>.

From a Domain Driven Design perspective, we have similar identity concepts to those in a database. From the attributess of an entity, we can identify <span style="font-style: italic">natural candidate keys</span> <span style="font-weight: bold"></span><span style="font-style: italic">(or identifiers)</span><span style="font-weight: bold">. </span>These are combinations of attributes on the entity that provide the entity a unique identity within the domain. Whether or not the candidates are useful depends on many things such as the general usefulness of the candidates in the context of the domain, the stability of the underlying attributes (they cannot be null, change over time, and must guarantee uniqueness), and simply whether or not the entity has any candidate keys.

In the case where no candidates can be found, a <span style="font-style: italic">surrogate key</span> is often used on the entity. This identifier has no direct relationship with the attributes of the domain, but is guaranteed to identify the entity as unique.

However, the use of surrogate keys in instances where an entity DOES have candidate keys is fairly common practice. This makes sense because it is often difficult to guarantee that the attributes of the domain will never change. By default, domain objects are often purposefully &#8220;marred&#8221; with these surrogate keys &#8211; identifiers with no domain specific meaning, except to guarantee uniqueness of the entity.

Assume that the domain entity has the following specifications:

<div style="background: white none repeat scroll 0% 50%;color: black">
  <pre style="margin: 0px"><span style="color: blue">using</span> Foo.Domain;</pre>
  
  <pre style="margin: 0px"><span style="color: blue">using</span> NUnit.Framework;</pre>
  
  <pre style="margin: 0px"> </pre>
  
  <pre style="margin: 0px"><span style="color: blue">namespace</span> Tests.Foo.Domain</pre>
  
  <pre style="margin: 0px">{</pre>
  
  <pre style="margin: 0px">    [<span>TestFixture</span>]</pre>
  
  <pre style="margin: 0px">    <span style="color: blue">public</span> <span style="color: blue">class</span> <span>WhenSettingUpANewBuyer</span></pre>
  
  <pre style="margin: 0px">    {</pre>
  
  <pre style="margin: 0px">        <span style="color: blue">private</span> <span>Buyer</span> buyer;</pre>
  
  <pre style="margin: 0px"> </pre>
  
  <pre style="margin: 0px">        [<span>SetUp</span>]</pre>
  
  <pre style="margin: 0px">        <span style="color: blue">public</span> <span style="color: blue">void</span> SetUpContext()</pre>
  
  <pre style="margin: 0px">        {</pre>
  
  <pre style="margin: 0px">            buyer = <span style="color: blue">new</span> <span>Buyer</span>();</pre>
  
  <pre style="margin: 0px">        }</pre>
  
  <pre style="margin: 0px"> </pre>
  
  <pre style="margin: 0px">        [<span>Test</span>]</pre>
  
  <pre style="margin: 0px">        <span style="color: blue">public</span> <span style="color: blue">void</span> ShouldAllowFirstNameToBeCaptured()</pre>
  
  <pre style="margin: 0px">        {</pre>
  
  <pre style="margin: 0px">            buyer.Name = <span>"MyName"</span>;</pre>
  
  <pre style="margin: 0px">            <span>Assert</span>.AreEqual(<span>"MyName"</span>, buyer.Name, <span>"Buyer Name was not captured."</span>);</pre>
  
  <pre style="margin: 0px">        }</pre>
  
  <pre style="margin: 0px"> </pre>
  
  <pre style="margin: 0px">        [<span>Test</span>]</pre>
  
  <pre style="margin: 0px">        <span style="color: blue">public</span> <span style="color: blue">void</span> ShouldAllowEmailToBeCaptured()</pre>
  
  <pre style="margin: 0px">        {</pre>
  
  <pre style="margin: 0px">            buyer.Email = <span>"foo@nowhere.com"</span>;</pre>
  
  <pre style="margin: 0px">            <span>Assert</span>.AreEqual(<span>"foo@nowhere.com"</span>, buyer.Email, <span>"Buyer Email was not captured."</span>);</pre>
  
  <pre style="margin: 0px">        }</pre>
  
  <pre style="margin: 0px">    }</pre>
  
  <pre style="margin: 0px">}<br /></pre>
</div>

Simple enough, but how do we want to guarantee that the entity is uniquely identified in the domain?

The user could look up the entity by Name or Email. In fact, Email for a user is most likely unique and tends to be a unique identifier for a users in web-based systems. However, think about the uniqueness of these attributes.

What if a buyer is really a corporate entity and the email address is associated with a single employee&#8217;s email. What happens then if he or she leaves the company? A system user could change the email address in that case. The email attribute is not necessarily guaranteed to be unique or to remain the same over time (unless we provide that specification, of course).

A surrogate system key is going to be the answer. In fact, to keep this potentially long-winded discussion short, a surrogate system key will be associated with ANY entity defined in the system. The system identifier will guarantee uniqueness and NHibernate will now be able to manage the domain entity.

Going back to the specification, the ID will simply be set to 0 (uninitialized) on a new buyer. Also, no specification will be made (can be made?) on setting the ID.

<div style="background: white none repeat scroll 0% 50%;color: black">
  <pre style="margin: 0px">        [<span>Test</span>]</pre>
  
  <pre style="margin: 0px">        <span style="color: blue">public</span> <span style="color: blue">void</span> ShouldNotHaveSystemIdSet()</pre>
  
  <pre style="margin: 0px">        {</pre>
  
  <pre style="margin: 0px">            <span>Assert</span>.AreEqual(0, buyer.Id, <span>"Buyer ID should not be set until saved to the repository."</span>);</pre>
  
  <pre style="margin: 0px">        }</pre>
</div>

The specifications result in the following domain entity:

<div style="background: white none repeat scroll 0% 50%;color: black">
  <pre style="margin: 0px"><span style="color: blue">namespace</span> Foo.Domain</pre>
  
  <pre style="margin: 0px">{</pre>
  
  <pre style="margin: 0px">    <span style="color: blue">public</span> <span style="color: blue">class</span> <span>Buyer</span></pre>
  
  <pre style="margin: 0px">    {</pre>
  
  <pre style="margin: 0px">        <span style="color: blue">private</span> <span style="color: blue">string</span> name;</pre>
  
  <pre style="margin: 0px">        <span style="color: blue">private</span> <span style="color: blue">string</span> email;</pre>
  
  <pre style="margin: 0px">        <span style="color: blue">private</span> <span style="color: blue">int</span> id;</pre>
  
  <pre style="margin: 0px"> </pre>
  
  <pre style="margin: 0px">        <span style="color: blue">public</span> <span style="color: blue">virtual</span> <span style="color: blue">string</span> Name</pre>
  
  <pre style="margin: 0px">        {</pre>
  
  <pre style="margin: 0px">            <span style="color: blue">get</span> { <span style="color: blue">return</span> name; }</pre>
  
  <pre style="margin: 0px">            <span style="color: blue">set</span> { name = <span style="color: blue">value</span>; }</pre>
  
  <pre style="margin: 0px">        }</pre>
  
  <pre style="margin: 0px"> </pre>
  
  <pre style="margin: 0px">        <span style="color: blue">public</span> <span style="color: blue">virtual</span> <span style="color: blue">string</span> Email</pre>
  
  <pre style="margin: 0px">        {</pre>
  
  <pre style="margin: 0px">            <span style="color: blue">get</span> { <span style="color: blue">return</span> email; }</pre>
  
  <pre style="margin: 0px">            <span style="color: blue">set</span> { email = <span style="color: blue">value</span>; }</pre>
  
  <pre style="margin: 0px">        }</pre>
  
  <pre style="margin: 0px"> </pre>
  
  <pre style="margin: 0px">        <span style="color: blue">public</span> <span style="color: blue">virtual</span> <span style="color: blue">int</span> Id</pre>
  
  <pre style="margin: 0px">        {</pre>
  
  <pre style="margin: 0px">            <span style="color: blue">get</span> { <span style="color: blue">return</span> id; }</pre>
  
  <pre style="margin: 0px">        }</pre>
  
  <pre style="margin: 0px">    }</pre>
  
  <pre style="margin: 0px">}</pre>
</div>

Note the <span style="font-weight: bold">virtual</span> modifiers on the properties. Marking the properties with virtual is recommended when using NHibernate or the Rhino Mocks mocking framework. Similar to the creating the surrogate key, this is a compromise for utilizing the tools &#8211; creating proxies from our original classes is now possible. 🙂

No specification has been made that would require the system to directly set the Id. NHibernate will set the Id property using reflection, so we do not need to worry about a setter.