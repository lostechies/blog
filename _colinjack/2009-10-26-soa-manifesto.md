---
wordpress_id: 29
title: SOA Manifesto
date: 2009-10-26T22:49:18+00:00
author: Colin Jack
layout: post
wordpress_guid: /blogs/colinjack/archive/2009/10/27/soa-manifesto.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/colinjack/archive/2009/10/27/soa-manifesto.aspx/"
---
I&#8217;ve just gotten through reading the [SOA Manifesto](http://soa-manifesto.org/) and reactions from (among others) [Jim Webber](http://jim.webber.name/2009/10/24/95bf2681-9a7a-4f94-94d6-2156a3a46411.aspx) and [Stefan Tilkov](http://www.innoq.com/blog/st/2009/10/comments_on_the_soa_manifesto.html) and I can&#8217;t help feeling the whole thing is a missed opportunity. 

In particular you&#8217;ll notice is that the manifesto doesn&#8217;t deal with the &#8220;what is a service&#8221; issue and so fails to deal with the [Service Oriented Ambiguity](http://martinfowler.com/bliki/ServiceOrientedAmbiguity.html) issue. Although Martin Fowler covers multiple ways of viewing services in his post I think two are probably most relevant when considering the manifesto:

  1. **Business Level SOA (B-SOA)** &#8211; Services for business capabilities/functions (think [Strategic Design in DDD](http://www.infoq.com/minibooks/domain-driven-design-quickly), [Enterprise SOA](http://www.infoq.com/minibooks/enterprise-soa)). This approach focuses on bringing IT and the business together and in my view should lead to large and loosely coupled autonomous services. 
      * **Technical Level SOA (T-SOA)** &#8211; Services here are the individual endpoints. These end-points could be Web Services (RPC/WS-*), they could be resources (REST), they could be messaging endpoints, or they could be something else.Each B-SOA service exposes one or more T-SOA services. </ol> 
    [Stefan Tilkov](http://www.innoq.com/blog/st/2007/09/27/faq_entry_whats_this_rest_vs_soa_debate_about.html) has a good blog entry about the two which is worth a read, and with these two types of SOA in mind its worth looking at the values in the manifesto to see how each apply in each context (context is king).
    
    **Values In Context**
    
    Whether considering T-SOA or B-SOA I agree with the first and last values, favouring business value and [evolutionary refinement](http://www.infoq.com/news/2008/09/EvolutionarySOA) are difficult to argue with. Intrinsic interoperability also makes sense in either case, especially as it is so vague, which leaves us with three other values:
    
      1. **Strategic goals** over project-specific benefits &#8211; At the B-SOA level this is certainly true but at the T-SOA level its a tradeoff as [Stefan points out](http://www.innoq.com/blog/st/2009/10/comments_on_the_soa_manifesto.html). 
          * **Shared services** over specific-purpose implementations &#8211; From a T-SOA angle this could be taken to refer to the argument that you should design your endpoints to be reusable in different contexts, such as when you go for an [entity service](http://www.infoq.com/news/2007/06/entity-services) based approach. However there are [arguments against](http://www.udidahan.com/2009/06/07/the-fallacy-of-reuse/) too much premature focus on reuse and use is far more important than reuse. I also think that reuse becomes less key if you view each T-SOA service as being within the context of a B-SOA service. In addition I&#8217;m not really sure what this value means when considering the B-SOA services themselves, probably not much. 
              * **Flexibility** over optimization &#8211; This one is very vague. You could read it about designing your T-SOA services to handle real variations in behaviour/data (patterns like [Workflodize](http://www.manning.com/rotem/) come to mind) and if so it is obviously entirely valid. However I think this is coming back to reuse again, specifically designing each T-SOA service to support reuse by making them more general purpose/agnostic. In addition at the T-SOA level optimisation does have to be considered because it is at this level that QOS becomes a consideration, but in many cases considering optimizations of individual T-SOA services won&#8217;t involved sacrificing flexibility. So I&#8217;m not sure how to take this one, in addition I&#8217;m unclear as to what this statement means in terms of B-SOA, again probably not much. </ol> 
            So although I can nod my head to most of the points in the manifesto someone with a completely different views on SOA could do exactly the same and even if we did have the dame views on SOA we&#8217;d need to be clear which type of SOA we&#8217;re considering when thinking about the manifesto. 
            
            That&#8217;s is a pity and I can&#8217;t help feeling that maybe [Martin Fowler had it right in 2005](http://martinfowler.com/bliki/ServiceOrientedAmbiguity.html):
            
            > So what do we do? For a start we have to remember all the time about how many different (and mostly incompatible) ideas fall under the SOA camp. These do need to be properly described (and named) independently of SOA. I think SOA has turned into a semantics-free concept that can join &#8216;components&#8217; and &#8216;architecture&#8217;. It&#8217;s beyond saving &#8211; so the concrete ideas that do have some substance need to get an independent life.
            
            With this in mind I actually think that [Steve Jones could be right](http://service-architecture.blogspot.com/2007/10/business-service-architecture-is-it.html), the term SOA is overloaded and too often used just for T-SOA so maybe its time to separate out the notion of B-SOA completely by using a term like Business Service Architecture.