---
wordpress_id: 467
title: Cohesion and Controller Ontology
date: 2011-05-31T12:30:03+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=467
dsq_thread_id:
  - "318430637"
categories:
  - Uncategorized
tags:
  - ASP.NET MVC
  - Object-Oriented Design
---
In my article: [Single Action Controllers with ASP.Net MVC](https://lostechies.com/derekgreer/2011/04/29/single-action-controllers-with-asp-net-mvc/), I presented a simple way of designing controllers within the ASP.Net MVC framework that represent discrete actions as opposed to classes which contain actions.&nbsp; This prompted a few questions about the motivations behind this strategy which this article will discuss in more detail. 

To explain, we’ll review the topics of Cohesion, Role Stereotypes and the Single Responsibility Principle.

## Cohesion

Cohesion is defined as the functional relatedness of the elements of a module.&nbsp; If all the methods on a given object pertain to a related set of operations, the object can be said to have high-cohesion.&nbsp; If an object has a bunch of miscellaneous methods which deal with unrelated concerns, it could be said to have low-cohesion.&nbsp; Cohesion can be further broken down into categories based upon how the responsibilities are related.&nbsp; The responsibilities of a given class may be similar in the sequence of operations they perform, in the dependencies they use, in the business domain concerns they facilitate, etc.&nbsp; What makes an object cohesive depends upon which aspect of relatedness you are measuring.&nbsp; 

## Role Stereotypes

Role Stereotypes concern the ontology of an object within object-oriented design.&nbsp; Role stereotypes can be thought of as role patterns which help us to rationalize the assignment of roles and responsibilities to objects within an architecture.&nbsp; One set of stereotypes set forth by Rebecca Wirfs-Brock is as follows:

  * **Information holder** &#8211; an object designed to know certain information and provide that information to other objects. 
      * **Structurer** &#8211; an object that maintains relationships between objects and information about those relationships. 
          * **Service provider** &#8211; an object that performs specific work and offers services to others on demand. 
              * **Controller** &#8211; an object designed to make decisions and control a complex task. 
                  * **Coordinator** &#8211; an object that doesn’t make many decisions but, in a rote or mechanical way, delegates work to other objects. 
                      * **Interfacer** &#8211; an object that transforms information or requests between distinct parts of a system. </ul> 
                    Another set of role stereotypes set forth by Steve Freeman and Nat Pryce as a heuristic for thinking about object roles within the context of collaboration is as follows:
                    
                      * **Dependencies** &#8211; Services that the object requires from its peers so it can perform its responsibilities. 
                          * **Notifications** &#8211; Peers that need to be kept up to date with the object’s activity. 
                              * **Adjustments** &#8211; Peers that adjust the object’s behavior to the wider needs of the system. </ul> 
                            Object stereotypes serve as an aid when considering what roles and responsibilities a particular object should have within a given context, but they shouldn&#8217;t be looked to as a set of rules governing how to design.&nbsp; Depending upon what aspect of a design is being considered, objects can serve in different contexts or may fit multiple stereotypes simultaneously.&nbsp; Additionally, stereotypes should not be confused with the responsibilities and characteristics prescribed by formal patterns and pattern participants which may happen to share similar naming.&nbsp; For example, Wirfs-Brock’s Controller&nbsp; stereotype shouldn’t be confused with Controllers described by the Model-View-Controller, Application Controller or Supervising Controller patterns.
                            
                            ## Single Responsibility Principle
                            
                            The Single Responsibility Principle states:
                            
                            > A class should have only one reason to change.
                            
                            The Single Responsibility Principle seeks to achieve cohesion by grouping concerns based upon the forces which cause them to change together.&nbsp; For example, consider an object whose purpose is to provide caching services to an application.&nbsp; It may have different behaviors for adding, retrieving, and removing items from a cache, but apart from each of these methods being functionally related (i.e. dealing with cache), they would also tend to change together based upon modifications to the underlying caching store implementation (e.g. changing the service to use a caching provider Strategy vs. a local dictionary field).&nbsp; If the caching service were extended to also encrypt the cached items, this could be reasoned to violate the Single Responsibility Principle.&nbsp; While the operations may be cohesive from the perspective of the responsibilities which are uniformly applied to the caching of items, persistence and encryption represent two different axes of change.
                            
                            While the concept of Cohesion and the Single Responsibility Principle are related, something can be considered cohesive by one measure of relatedness, but have multiple reasons to change.&nbsp; The Single Responsibility Principle measures one type of cohesion: how related the responsibilities of a module are with respect to their axes of change.
                            
                            ## Confluence of Principles
                            
                            So, how do all these abstract concepts relate to how one might decide to implement the Model-View-Controller pattern?&nbsp; Going back to Trygve Reenskaug’s [original design](https://lostechies.com/derekgreer/2007/08/25/interactive-application-architecture/) of the Model-View-Controller pattern, the Model’s role was to represent real world processes and entities; the View’s role was to provide the visualization of the model; the Controller’s role was to serve as an interface between the end user and the model.&nbsp; The Controller’s responsibilities were achieved by intercepting hardware signals in the form of keyboard and mouse events and translating them to operations upon the Model.&nbsp; As operations upon the Model changed its state, the View would be updated through the use of the Observer Pattern.&nbsp; The Controller’s role in interacting with the View was primarily presentation-specific concerns (navigation, the expanding and collapsing of menus, highlighting, etc.).&nbsp; As the MVC pattern was adapted for use with Web applications, the hardware signals were replaced by HTTP requests and the Controller took a more active role in communicating updates to the View due to the stateless nature of the Web.&nbsp; Though the Controller had to step up its responsibility a bit in this new manifestation of the MVC pattern, its purpose was still that of Model interface.
                            
                            While the Controller’s primary responsibility is to interpret signals and adapt those signals to meaningful operations upon the Model, the cohesiveness of the operations upon the Controller should be guided by the Single Responsibly Principle within the context of its role stereotype.&nbsp; That is to say, the role of the Controller within the Model-View-Controller pattern is not to mirror the Model’s responsibility in terms of HTTP requests and responses, but to serve as an adaptor whose responsibilities are organized based upon the relatedness of the technical needs to serve in this adapting role.&nbsp; For example, a single Domain object or service may have a number of operations which are grouped based upon their relatedness in representing a domain concept, but invoking the behavior of each may require that completely disparate dependencies be supplied to the Model.&nbsp; One may require an auditing service, another a discount strategy, and still another a caching service.&nbsp; These represent three separate axes of change which could affect the Controller for different reasons.&nbsp; The types of requests and responses represent yet another axis of change, as some requests utilize different protocols (e.g. delegation to a View template engine, JSON, binary stream, etc.)
                            
                            For simple applications, a single controller may adhere to the Single Responsibility Principle due to the singularity of protocol and dependencies required for the underlying Model it is tasked with interfacing (e.g. basic CRUD applications).&nbsp; As applications grow in complexity, more forces of change begin to be imposed upon the design.&nbsp; Therefore, applying the same sets of principles will lead you to different manifestations of Controllers depending on the style of application you are designing.
                            
                            ## Conclusion
                            
                            In summary, Cohesion is a measure of the relatedness of the elements of a module, but it is only until we provide context to an element’s purpose that we can begin to define cohesion in a meaningful way.&nbsp; By identifying the role stereotype of a component, we can then apply the Single Responsibility Principle to the behaviors of the role based upon the cohesiveness of each element’s reason for change.
