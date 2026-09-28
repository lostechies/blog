---
wordpress_id: 21
title: Code Is Obsolete in Visual Studio 10
date: 2007-10-30T23:40:50+00:00
author: Evan Hoff
layout: post
wordpress_guid: /blogs/evan_hoff/archive/2007/10/30/code-is-obsolete-in-visual-studio-10.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/evan_hoff/archive/2007/10/30/code-is-obsolete-in-visual-studio-10.aspx/"
---
Sorry, I can&#8217;t resist.

Hot off the presses is a new technology planned for Visual Studio 10, <a href="http://searchsoa.techtarget.com/originalContent/0,289142,sid26_gci1280299,00.html" target="_blank">Oslo</a>.&nbsp; It was announced today by the director of Microsoft&#8217;s Connected Systems Division, Burley Kawasaki (love the name).

> Microsoft today unveiled a futuristic vision of technology for service-oriented architecture (SOA) development where &#8220;the model is the application.&#8221;
> 
> &#8220;If you can make the model executable,&#8221; Kawasaki said, &#8220;where the model is the application, then you lose the gaps and handoffs. The model that business defines is the thing that actually executes.&#8221;

The next gen tools are supposed to be a form of model-driven development.&nbsp; It&#8217;ll be a mashup of BizTalk Server 6, Visual Studio 10, and System Center.

> The Microsoft approach, which will be embodied in the Oslo tooling, is to make modeling a collaborative effort among business analysts, architects and developers and eliminate the coding step.

No more coding?&nbsp; Looks like I&#8217;ll be needing to find a new job.&nbsp; Apparently the BA&#8217;s will be taking my place.

Here&#8217;s another <a href="http://money.cnn.com/news/newsfeeds/articles/prnewswire/AQTU036A30102007-1.htm" target="_blank">viewpoint</a>:

> &#8220;It&#8217;s time to help developers and IT professionals extend the capabilities of SOA to address the new &#8216;blended&#8217; world of software plus services and cross-boundary collaboration,&#8221; said Robert Wahbe, corporate vice president of the Connected Systems Division at Microsoft. &#8220;&#8216;Oslo&#8217; will enable a new class of applications that are connected and streamlined &#8212; from design through deployment &#8212; reducing complexity, aligning the enterprise and Internet, and simplifying interoperability and management.&#8221;

Enterprise internet alignment?&nbsp; Is that the next big thing? 😉

On a more serious note, if you want to know what&#8217;s \*really\* going to ship, you can read up on <a href="http://msdn2.microsoft.com/en-us/architecture/bb266335.aspx" target="_blank">Composite Applications</a>.&nbsp; In a nutshell, take a <a href="http://msdn2.microsoft.com/en-us/library/ms954595.aspx" target="_blank">Component Architecture</a>, convert the components to <a href="http://msdn2.microsoft.com/en-us/netframework/aa663324.aspx" target="_blank">services</a>, add Business Process <a href="http://msdn2.microsoft.com/en-us/netframework/aa663328.aspx" target="_blank">Workflow</a>&nbsp;to glue the services together in an <a href="http://www.microsoft.com/biztalk/default.mspx" target="_blank">Orchestrated fashion</a>, mix in some infrastructure services (such as <a href="http://en.wikipedia.org/wiki/Federated_identity" target="_blank">federated identity</a>), and add a dash of&nbsp;<a href="http://www.ibm.com/developerworks/rational/library/3100.html" target="_blank">MDA</a>&nbsp;all around.

Of course, then there&#8217;s always <a href="http://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215" target="_blank">the other form</a> of Model-Driven Development&#8211;where the modeling language is the programming language, but that won&#8217;t sell many tools.