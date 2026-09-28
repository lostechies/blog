---
wordpress_id: 238
title: NotImplementedException and the Interface Segregation Principle
date: 2008-10-12T18:50:53+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/10/12/notimplementedexception-and-the-interface-segregation-principle.aspx
dsq_thread_id:
  - "265314839"
categories:
  - CodeSmells
  - Design
redirect_from: "/blogs/jimmy_bogard/archive/2008/10/12/notimplementedexception-and-the-interface-segregation-principle.aspx/"
---
This week, Derrick Bailey will be in town (Austin) to talk about the [SOLID principles](https://lostechies.com/blogs/chad_myers/archive/2008/03/07/pablo-s-topic-of-the-month-march-solid-principles.aspx).&#160; One of the hardest ones to talk about, and find examples for, is the [Interface Segregation Principle](https://lostechies.com/blogs/rhouston/archive/2008/03/14/ptom-the-interface-segregation-principle.aspx).&#160; The ISP states:

> _CLIENTS SHOULD NOT BE FORCED TO DEPEND UPON INTERFACES THAT THEY DO NOT USE_

While this may be more difficult to recreate in software we both create and consume, you’ll see it pop up more in libraries meant for mass consumption, such as ASP.NET or NHibernate.&#160; I think I’m starting to notice a trend in the .NET space that provides us a bright flashing blue light to indicate violations of the ISP: usage of NotImplementedException.

When talking about ISP in the .NET space, one of the more widely-used targets is the massive [MembershipProvider](http://msdn.microsoft.com/en-us/library/system.web.security.membershipprovider.aspx) class.&#160; It has dozens of members, of which only a handful are used in custom implementations.&#160; The MembershipProvider allows just about every possible membership feature under the sun to be used, but you’re still stuck with providing implementations to everything.&#160; Don’t want to allow users to be locked out?&#160; Too bad, provide an implementation.&#160; Can’t figure out how many users are online?&#160; Too bad, provide an implementation.

Even ALT.NET-y frameworks like NHibernate (though ALT.NET is NOT NOT NOT about tools) has its own issues with ISP.&#160; In one recent project, we interacted with a legacy database to read about 80% of our entities as read-only.&#160; That is, a large portion of the tables we read from were never written to, and we turned off the ability to write back to from NHibernate.&#160; As it was a legacy database, we made extensive use of NHibernate’s custom user types, which allowed us to encapsulate the&#8230;more interesting parts of the database.&#160; Instead of “Y” and “N” in our system, we wanted booleans.&#160; Instead of integer dates (20080904), we wanted actual DateTime types.&#160; Custom user types allowed us to translate from the database to our types, completely transparent to our actual entities.&#160; Our entities were built with “real” types, and NHibernate took care of the translation.

Unfortunately, we still had quite a few of these around:

<pre><span style="color: blue">public override </span><span style="color: #2b91af">Type </span>ReturnedClass
{
    <span style="color: blue">get </span>{ <span style="color: blue">throw new </span><span style="color: #2b91af">NotImplementedException</span>(); }
}

<span style="color: blue">public override void </span>Set(<span style="color: #2b91af">IDbCommand </span>cmd, <span style="color: blue">object </span>value, <span style="color: blue">int </span>index)
{
    <span style="color: blue">throw new </span><span style="color: #2b91af">NotImplementedException</span>();
}

<span style="color: blue">public override </span><span style="color: #2b91af">Type </span>PrimitiveClass
{
    <span style="color: blue">get </span>{ <span style="color: blue">throw new </span><span style="color: #2b91af">NotImplementedException</span>(); }
}

<span style="color: blue">public override object </span>DefaultValue
{
    <span style="color: blue">get </span>{ <span style="color: blue">throw new </span><span style="color: #2b91af">NotImplementedException</span>(); }
}</pre>

[](http://11011.net/software/vspaste)

A bunch of features we didn’t need to support, all throwing NotImplementedExceptions.&#160; Instead of providing an empty implementation, we wanted to make sure these areas were never called, and if they did, something else was wrong.

These NotImplementedExceptions are pretty strong smells for ISP violations.&#160; We were _forced_ to provide an implementation, but the exception shows a refusal on our part to do so.&#160; Part of this is a design issue, and part of it is the unfortunate side-effect of designing an API that is used in a variety of situations.&#160; The NotImplementedExceptions are noisy, and I’d rather never see one in code (even temporarily in a test).&#160; In both the MembershipProvider and the NHibernate case, we were using 3rd-party libraries which we had no control over.&#160; It’s not like we could try and do something about the ISP violations.&#160; But in our client software, we can look out for NotImplementedExceptions, and examine the underlying type to see if there aren’t more concerns that need to be split out.