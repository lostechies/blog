---
id: 27
title: Building the often needed anti-corruption layer
date: 2007-09-10T14:36:21+00:00
author: Joey Beninghove
layout: post
guid: /blogs/joeydotnet/archive/2007/09/10/building-the-often-needed-anti-corruption-layer.aspx
categories:
  - commerce server
  - Domain Driven Design
  - MonoRail
  - Patterns
---
> _The fear of the LORD is the beginning of knowledge, But fools despise wisdom and instruction.&nbsp; &#8212;_ [_Proverbs 1:7_](http://www.blueletterbible.org/cgi-bin/tools/printer-friendly.pl?book=Pro&chapter=1&version=NKJV#7)

&#8220;[Agile Joe](http://agilejoe.com)&#8221; and I were chatting about the challenges of building on top of existing application platforms, specifically ones like Microsoft CRM ([which Ayende is painfully dealing with](http://www.ayende.com/Blog/archive/2007/09/09/Microsoft-CRM-Frustrations.aspx)) and Commerce Server 2007, which is what I&#8217;m dealing with on my current project.&nbsp; Joe pointed out&nbsp;the importance of building an anti-corrruption layer.&nbsp; And I couldn&#8217;t agree more.&nbsp; In fact, since I&#8217;m using DDD as much as I can on this project, we&#8217;ve been able to deliver early customer demos showing working features, end to end, using stubbed repositories.&nbsp; 

To get&nbsp;a better picture, this is basically how the design of the system is shaping up so far:

<table cellspacing="0" cellpadding="2" width="600" border="1">
  <tr>
    <td valign="top" width="194">
      MVC Web UI
    </td>
    
    <td valign="top" width="403">
      MonoRail of course.&nbsp; 🙂
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="194">
      DTOs (Screen-specific)
    </td>
    
    <td valign="top" width="403">
      2 way databound using MonoRail&#8217;s most excellent DataBinder
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="194">
      Thin Service Layer
    </td>
    
    <td valign="top" width="403">
      To simply act as a facade to expose business operations and to handle the DTO => Domain Object mappings
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="194">
      Domain Model
    </td>
    
    <td valign="top" width="403">
      With all the entities, value objects, factories, specifications, etc. that you would expect.&nbsp; I also keep the public interfaces to my Repositories in my domain model, but the specific implementations of them in a Persistence layer.
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="194">
      Persistence Layer &#8211; Stubbed
    </td>
    
    <td valign="top" width="403">
      These are just some in-memory repository implementations which have allowed us to demonstrate working features to the customer very early in the project.
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="194">
      Persistence Layer &#8211; CS 2007?
    </td>
    
    <td valign="top" width="403">
      This one is yet to be, but is what I have in mind when we start integrating with CS 2007 soon.&nbsp; This would basically act as our &#8220;anti-corruption layer&#8221; between CS 2007 and our domain model.
    </td>
  </tr>
</table>

&nbsp;

It seems the recommended approach for implementing an anti-corruption layer is to treat is as another Service Layer.&nbsp; From our perspective, I don&#8217;t see much of a difference in using Repository implementations in the same way.&nbsp; Especially since in our case, most of our integration with&nbsp;Commerce Server will be dealing with persisting/retrieving data.&nbsp; On a related note, I&#8217;m starting to realize that **MS application platforms like Commerce Server&nbsp;are&nbsp;nothing more than a pre-built legacy database for your application**.&nbsp; Hence the need to localize the nastiness involved with extending and&nbsp;integrating with it, in an anti-corruption layer.

The one advantage I do see by treating this integration layer as another Service Layer, is in the fact that in reality there will be a lot more going on behind the scenes besides just a bunch of persistence method calls.&nbsp; Since Commerce Server has its own wannabe entities in the form of weakly-typed datasets (yes!&nbsp;you heard that right) and untestable classes, we&#8217;re going to have to build another set of mappers that can translate between our domain model and our extended CS 2007 &#8220;entities&#8221;.&nbsp; Along with things dealing with the CS 2007 context, etc.&nbsp; 

We&#8217;ve already identified the need to have an extensive set of automated integration tests to drive out this anti-corruption layer.&nbsp; So I&#8217;m sure I&#8217;ll have a lot more to say on that as we progress.&nbsp; Unfortunately it looks like it&#8217;s going to require some fairly complex test set up logic to get a test instance of CS 2007 configured in an automated fashion.

Like most instances where you have to extend and integrate with an existing platform such as Commerce Server, I keep wondering if all this time we&#8217;re having to spend will be worth it vs. &#8220;rolling our own&#8221; as they say.&nbsp; Guess we&#8217;ll see.

Any thoughts on this approach?&nbsp; Am I just completely mad?&nbsp; 🙂