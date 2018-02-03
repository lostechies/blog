---
wordpress_id: 7
title: Simple NHibernate Example utilizing various xDD Techniques, Part 1
date: 2007-03-21T16:36:00+00:00
author: Nelson Montalvo
layout: post
wordpress_guid: /blogs/nelson_montalvo/archive/2007/03/21/simple-nhibernate-example-utilizing-various-xdd-techniques-part-1.aspx
categories:
  - NHibernate
---
I wanted to present a simple NHibernate example utilizing some techniques I’ve learned along the way. This first post will provide some domain level background.

Let me know if you have any feedback, so that I can correct or extend this example.<u>  
</u>

<u>Domain Driven Design</u>

From Eric Evan’s “<a href="http://domaindrivendesign.org/books/index.html" target="_blank">Domain-Driven Design: Tackling Complexity in the Heart of Software</a>,” I will use the concept of the Ubiquituous Language to derive a Model-Driven Design. That is, begin by taking a common language between the domain experts and developers. Then translate the language into an abstract representation, the domain model.

As developers, we can derive our implementation from the domain model and still converse with domain experts and users in terms of the ubiquitous language and not through technical “mumbo-jumbo”. Well, most of the time.

Starting with a very, very simple example, we might have the following conversation between a domain expert and developer:

> **Domain Expert**: “I would like the system to take in a lead.”
> 
> **Developer**: “You mean store a person’s information in the database?”
> 
> **Domain Expert**: “A database? Sure, if that makes sense. All I really need is for you to save the lead’s information somehwere; first name, last name, and email address. Can you do that?”

And that’s it for now. Yes, I know that’s pretty dang simple. I&#8217;ll break this down a little.

The domain expert refers to two Domain-Driven Design (DDD) concepts. I will not into great detail regarding these two concepts since the DDD book does a great job (or have a look at this good introductory book, “<a href="http://www.infoq.com/minibooks/domain-driven-design-quickly" target="_blank">Domain-Driven Design Quickly</a>”):

  1. The first concept is that of an _Entity_, which in this case, I only have one. I will refer to the known entity as a **Lead**. 
  2. The second concept is that of the _Repository_. The **Lead** will be saved “somewhere.” I will use a **LeadRepository** to save the **Lead**. Repositories allow for the storage and retrieval of entities.

I would also note that there is the concept of a _Factory_ implied in this story, but I will not go into that for now. Also, I am not going to draw any UML models as this example is ridiculously easy and because I’m lazy.<u>  
</u>

<u>Test Driven Development</u>

I am not familiar enough with [Behavior-Driven Development](http://dannorth.net/introducing-bdd) (BDD) to fully utilize the technique in this example. I will stick to Test Driven Development (TDD). I am going to assume that <a href="http://codebetter.com/blogs/darrell.norton/articles/50337.aspx" target="_blank">you know enough about TDD</a>, so I&#8217;ll begin by implementing the **Lead** entity.

We know that we have to capture the **Lead**’s first name, last name and email. So I&#8217;ll write some very simple, yet necessary, tests.

Here are the tests (UPDATED: 3/11/2007):

<div style="background: white none repeat scroll 0% 50%;font-size: 10pt;color: black">
  <pre style="margin: 0px"><span style="color: blue">using</span> Foo.Domain;</pre>
  
  <pre style="margin: 0px"><span style="color: blue">using</span> NUnit.Framework;</pre>
  
  <pre style="margin: 0px"> </pre>
  
  <pre style="margin: 0px"><span style="color: blue">namespace</span> Tests.Foo.Domain</pre>
  
  <pre style="margin: 0px">{</pre>
  
  <pre style="margin: 0px">    [<span>TestFixture</span>]</pre>
  
  <pre style="margin: 0px">    <span style="color: blue">public</span> <span style="color: blue">class</span> <span>WhenSettingUpANewLead</span></pre>
  
  <pre style="margin: 0px">    {</pre>
  
  <pre style="margin: 0px">        <span style="color: blue">private</span> <span>Lead</span> lead;</pre>
  
  <pre style="margin: 0px"> </pre>
  
  <pre style="margin: 0px">        [<span>SetUp</span>]</pre>
  
  <pre style="margin: 0px">        <span style="color: blue">public</span> <span style="color: blue">void</span> SetUpContext()</pre>
  
  <pre style="margin: 0px">        {</pre>
  
  <pre style="margin: 0px">            lead = <span style="color: blue">new</span> <span>Lead</span>();   </pre>
  
  <pre style="margin: 0px">        }</pre>
  
  <pre style="margin: 0px"> </pre>
  
  <pre style="margin: 0px">        [<span>Test</span>]</pre>
  
  <pre style="margin: 0px">        <span style="color: blue">public</span> <span style="color: blue">void</span> ShouldAllowFirstNameToBeCaptured()</pre>
  
  <pre style="margin: 0px">        {</pre>
  
  <pre style="margin: 0px">            lead.FirstName = <span>"Foo"</span>;</pre>
  
  <pre style="margin: 0px">            <span>Assert</span>.AreEqual(<span>"Foo"</span>, lead.FirstName, <span>"First Name was not captured."</span>);</pre>
  
  <pre style="margin: 0px">        }</pre>
  
  <pre style="margin: 0px"> </pre>
  
  <pre style="margin: 0px">        [<span>Test</span>]</pre>
  
  <pre style="margin: 0px">        <span style="color: blue">public</span> <span style="color: blue">void</span> ShouldAllowLastNameToBeCaptured()</pre>
  
  <pre style="margin: 0px">        {</pre>
  
  <pre style="margin: 0px">            lead.LastName = <span>"Bar"</span>;</pre>
  
  <pre style="margin: 0px">            <span>Assert</span>.AreEqual(<span>"Bar"</span>, lead.LastName, <span>"Last Name was not captured."</span>);</pre>
  
  <pre style="margin: 0px">        }</pre>
  
  <pre style="margin: 0px"> </pre>
  
  <pre style="margin: 0px">        [<span>Test</span>]</pre>
  
  <pre style="margin: 0px">        <span style="color: blue">public</span> <span style="color: blue">void</span> ShouldAllowEmailToBeCaptured()</pre>
  
  <pre style="margin: 0px">        {</pre>
  
  <pre style="margin: 0px">            lead.Email = <span>"baz@test.com"</span>;</pre>
  
  <pre style="margin: 0px">            <span>Assert</span>.AreEqual(<span>"baz@test.com"</span>, lead.Email, <span>"Email was not captured."</span>);</pre>
  
  <pre style="margin: 0px">        }</pre>
  
  <pre style="margin: 0px">    }</pre>
  
  <pre style="margin: 0px">}</pre>
</div>

And the resulting entity class:

<div style="background: white none repeat scroll 0% 50%;font-size: 10pt;color: black">
  <pre style="margin: 0px"><span style="color: blue">namespace</span> Foo.Domain</pre>
  
  <pre style="margin: 0px">{</pre>
  
  <pre style="margin: 0px">    <span style="color: blue">public</span> <span style="color: blue">class</span> <span>Lead</span></pre>
  
  <pre style="margin: 0px">    {</pre>
  
  <pre style="margin: 0px">        <span style="color: blue">private</span> <span style="color: blue">string</span> firstName;</pre>
  
  <pre style="margin: 0px">        <span style="color: blue">private</span> <span style="color: blue">string</span> lastName;</pre>
  
  <pre style="margin: 0px">        <span style="color: blue">private</span> <span style="color: blue">string</span> email;</pre>
  
  <pre style="margin: 0px"> </pre>
  
  <pre style="margin: 0px">        <span style="color: blue">public</span> <span style="color: blue">string</span> FirstName</pre>
  
  <pre style="margin: 0px">        {</pre>
  
  <pre style="margin: 0px">            <span style="color: blue">get</span> { <span style="color: blue">return</span> firstName; }</pre>
  
  <pre style="margin: 0px">            <span style="color: blue">set</span> { firstName = <span style="color: blue">value</span>; }</pre>
  
  <pre style="margin: 0px">        }</pre>
  
  <pre style="margin: 0px"> </pre>
  
  <pre style="margin: 0px">        <span style="color: blue">public</span> <span style="color: blue">string</span> LastName</pre>
  
  <pre style="margin: 0px">        {</pre>
  
  <pre style="margin: 0px">            <span style="color: blue">get</span> { <span style="color: blue">return</span> lastName; }</pre>
  
  <pre style="margin: 0px">            <span style="color: blue">set</span> { lastName = <span style="color: blue">value</span>; }</pre>
  
  <pre style="margin: 0px">        }</pre>
  
  <pre style="margin: 0px"> </pre>
  
  <pre style="margin: 0px">        <span style="color: blue">public</span> <span style="color: blue">string</span> Email</pre>
  
  <pre style="margin: 0px">        {</pre>
  
  <pre style="margin: 0px">            <span style="color: blue">get</span> { <span style="color: blue">return</span> email; }</pre>
  
  <pre style="margin: 0px">            <span style="color: blue">set</span> { email = <span style="color: blue">value</span>; }</pre>
  
  <pre style="margin: 0px">        }</pre>
  
  <pre style="margin: 0px">    }</pre>
  
  <pre style="margin: 0px">}</pre>
</div>



&nbsp;

Simple enough! The interesting repository stuff will come in the next post, I promise. 🙂