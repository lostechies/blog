---
wordpress_id: 24
title: On Mobile Objects
date: 2007-11-10T04:09:28+00:00
author: Evan Hoff
layout: post
wordpress_guid: /blogs/evan_hoff/archive/2007/11/09/on-mobile-objects.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/evan_hoff/archive/2007/11/09/on-mobile-objects.aspx/"
---
</p> 

> It&#8217;s comments like this that give me pause and make me wonder if I should&nbsp;join this thread&#8230; Everyone&#8217;s gonna call me a moron, but I&#8217;m hoping to&nbsp;learn something here. 

You are most definitely not a moron. 🙂 

> We use mobile objects. (insert flame here) 

No flames from me. No questions are dumb questions. Well actually, I&#8217;ve asked quite a few dumb questions, but this question is \*definitely not\* a dumb one. 

> I&#8217;ve never really understood (and this is simply my lack of&nbsp;experience/exposure) the whole DTO/separate objects on the client/server&nbsp;thing. It seems like extra work to me to have to copy all of the properties&nbsp;from one object to another, just because one object was used to cross the&nbsp;wire and another wasn&#8217;t. I&#8217;ve tried to get a grasp on this and haven&#8217;t ever&nbsp;been able to see a &#8220;complete&#8221; enough example to get why this is beneficial&nbsp;or good design. I&#8217;m sure there&#8217;s a reason &#8211; otherwise everyone wouldn&#8217;t be&nbsp;championing this particular pattern so frequently. I just wish I could see a&nbsp;complete example and &#8220;get it&#8221;. 

It really depends on the scenario. In the &#8220;distributed object&#8221; context I was referring to, it was really a rail against Remoting style architecture. I can&#8217;t vouch for the product that Jeremy was describing in his message, but when I think of mobile objects, I think of distributed remoting designs. 

In that particular style of design, you might create an object on the server, and get a proxy to it on the client. The client invokes methods which then actually run on the server. 

The reason those styles of design are bad is that they tend to be very chatty with the traffic going across the network. You can imagine the amount of network traffic required when a property getter requires a roundtrip to the server. This ties directly into the Fallacies of Distributed Computing.   
<http://www.lostechies.com/blogs/evan_hoff/archive/2007/10/24/the-8-fallacies-of-distributed-computing.aspx> 

That style of design forgets that there is latency going across the network (among other things). 

You might google RPC for more information if you want. 

This is a slightly different topic from DTOs (Data Transfer Objects), however. 

The purpose of DTOs is primarily to decouple layers in your application. They insulate your UI and Domain Model from one another. You typically see it used in conjunction with a Service Layer, where the service layer manages database transactions, manipulates the domain model, and manages the copying of data from the domain model to the dtos. Other people might actually use two layers to accomplish the same thing (see PoEAA for a good discussion). 

Regarding the DTOs themselves: 

As an example, start with a Customer class with Address1 and Address2 fields. Then build the Customer forms. At some point down the road you decide to factor the Address fields on the Customer, User, Supplier, and other entities to use a common class, the Address class. When you perform the refactoring, you also have to fix your UI code (Address1 and Address2 are not properties of Customer any more). That&#8217;s when the DTO would have stepped in to save the day. You could continue to have the Address1 and Address2 properties on the DTO while modifying the Customer class (and all the others). Your UI code would still bind to the Address1 and Address2 fields on the DTO. The DTO provides a level of abstraction between the layers. 

Another example might be if you have a graph of objects with a complex relationship. You might have a Patient class with a collection of LabValue classes. Each of your LabValue classes references a LabTest (with the Lab name) class. This would be a key scenario to introduce a DTO. You don&#8217;t want your UI to have to know the complex relationships between these classes, and you don&#8217;t want to have to change your UI when/if the relationships change. 

In short, use of the DTO pattern is optional (as is the service layer). It&#8217;s up to you whether you need it for your application or not. It has its benefits, but it also requires additional coding. I pass no judgement on people who don&#8217;t use it (I know a few people whom I greatly respect that don&#8217;t use it&#8211;even though they are using a full blown Domain Model). 

Another slight variation would be on tiered applications where a client connects to a service somewhere (ie..a webservice running in the application tier). The DTO is actually quite handy in an application running a domain model behind a webservice. If you&#8217;ve ever dealt with ASMX webservices and the XmlSerializer, you know how picky the serializer can be. By decoupling the domain model objects from the WSDL, I gain two things: 

First, if I return a DTO from my webservice (and not a domain object) I decouple the WSDL (the external system contract) from the webservice consumers. This may seem like a minor issue, unless you have webservice consumers who are out of your control (say, an application in another company). You don&#8217;t want to force them to recompile their app when you deploy a change in your domain model (you can replay the Customer scenario above with Address1 and Address2 to see what I mean). In code-first webservices, the DTO allows you to tightly control the WSDL schema. 

Secondly (and more obvious), it allows you to use things like read-only properties and non-parameterless constructors in your domain model. The XmlSerializer is a bit fragile (for good reasons), so using the DTO allows me to loosen everything up for the serializer, while doing good class design for my actual domain objects (entities, etc). 

In terms of WCF, DTOs make good Data Contracts whereas model objects don&#8217;t (for the above reasons). Versioning my entities with WCF stuff is a bad idea. 

> If anyone wants to send me an email sometime and have a chat about my&nbsp;application&#8217;s architecture, and explain some of this stuff to me, I&#8217;d&nbsp;appreciate it. I don&#8217;t know if I feel like having my ignorance taken to task&nbsp;in a public setting. 

Kudos to you for asking. Now if only we could get more people asking questions. 🙂 

If anyone ever has a direct question for me, feel free to email me. It&#8217;s been giving me some topics to blog about of late.