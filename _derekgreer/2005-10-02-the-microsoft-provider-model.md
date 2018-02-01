---
id: 457
title: The Microsoft Provider Model
date: 2005-10-02T20:00:00+00:00
author: Derek Greer
layout: post
guid: http://www.aspiringcraftsman.com/2005/10/the-microsoft-provider-model/
dsq_thread_id:
  - "315802110"
categories:
  - Uncategorized
---
For my first post of substance I thought I&#8217;d write about the new Microsoft Provider Model used within the .Net 2.0 framework. The Provider Model is a new construct for addressing extensibility within the .Net framework. I define the Provider Model as being three things: a pattern, a framework API, and a specification.

**The Provider Model Pattern**
  
The Provider Model is a pattern in the sense that it is a formalized blending and composition of existing patterns producing a unique construct for addressing extensibility.

**The Provider Model Framework API**
  
The Provider Model is a framework API in that the 2.0 .Net framework provides several abstract base classes for creating providers and provider-backed objects.

**The Provider Model Specification**
  
The Provider Model can be considered a specification because in addition to the base classes provided and the patterns composed, Microsoft provides an implementation specification for how providers are to be designed and how configuration should be handled.

The Provider Model is a construct which abstracts the facilitating implementation for some portion of functionality from the defining class. There are two parts to the use of the Provider Model: 1) The provider-backed class and 2) The provider itself. The provider-backed class is the portion of functionality which defines the features which a provider will implement. This class defines public static methods which proxy calls to a default provider. By convention, the class also exposes the default provider along with the collection of all additional configured providers for the class. This allows the consuming application to provide a list of available providers and call a specific provider if desired. Some examples of provider-backed classes within ASP.Net are the Membership and Roles classes. The provider is the implementation of the functionality defined by the provider-backed class. For the Membership class, Microsoft provides an SqlMembershipProvider which implements the Membership functionality based upon the use of a Microsoft SQL database. Other Membership providers might include an AccessMembershipProvider, a SybaseMembershipProvider, or an XmlMembershipProvider.

Aside from the extensibility the Provider Model achieves for some of the new ASP.Net features, probably the biggest benefit to be gained from the provider model is the standardization this construct provides for achieving extensibility concerns. The use of standard design patterns can achieve the same results, but after learning how one provider and provider-backed class is used and configured you will be familiar with all the other Provider Model based functionality within the .Net framework as well as any Provider Model based functionality following the Microsoft specifications.

For more information on the Provider Model, see Rob Howard&#8217;s article: [Provider Model Design Pattern and Specification, Part 1](http://msdn.microsoft.com/library/default.asp?url=/library/en-us/dnaspnet/html/asp02182004.asp).
