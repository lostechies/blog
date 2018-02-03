---
wordpress_id: 37
title: Taxonomy of Interaction Models
date: 2008-03-30T18:01:02+00:00
author: Evan Hoff
layout: post
wordpress_guid: /blogs/evan_hoff/archive/2008/03/30/taxonomy-of-interaction-models.aspx
categories:
  - Uncategorized
---
We live and work&nbsp;a world where tech talk quick devolves into muddy, undefined&nbsp;communication revolving around one of three concepts: the object, the component, or the service.

While I&#8217;m not going to try and define each of these for you, I will say a word about how they collaborate to get work done..

  * Object interactions typically are reserved for in-process collaborations.
  * Component interactions attempt to mask whether the collaboration is in or out of process. In fact, a collaborating component may reside on a remote server in a Distributed Component Architecture.
  * Service interactions are explicitly cross-boundary.&nbsp; Many times they cross a network boundary.

I ran across a great taxonomy earlier today based on the model of interaction between the elements of a design, whether&nbsp;you&nbsp;happen to be looking at&nbsp;objects, components, or services.

&nbsp;

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="280" src="http://lostechies.com/blogs/evan_hoff/WindowsLiveWriter/TaxonomyofCooperationModels_9E2/interactionmodels_thumb[1].png" width="569" border="0" />](http://lostechies.com/blogs/evan_hoff/WindowsLiveWriter/TaxonomyofCooperationModels_9E2/interactionmodels[3].png) 

For this particular taxonomy, the consumer is the consumer of some information and the provider is the provider of that information.&nbsp; Direct addressing means that the initiator calls the other party by address (directly).&nbsp; Indirect addressing is a function provided, typically, by some form of Middleware.

I may come back and post more on the various interaction models, but for now, I&#8217;d rather leave this post at bite-sized.