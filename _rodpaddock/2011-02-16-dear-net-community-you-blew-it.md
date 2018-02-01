---
id: 4482
title: Dear .NET Community, You Blew It!
date: 2011-02-16T22:31:00+00:00
author: Rod Paddock
layout: post
guid: /blogs/rodpaddock/archive/2011/02/16/dear-net-community-you-blew-it.aspx
dsq_thread_id:
  - "263003380"
categories:
  - Uncategorized
---
<!--[if gte mso 9]>-->

Dear .NET Community,

<p class="MsoNormal" style="line-height: 150%">
  You Blew It!
</p>

A couple of weeks ago a critical tool in the .NET ecosystem went from free to
  
commercial. That tool is Reflector and the owner of said product is RedGate
  
software. A lot of members of the .NET Community complained that RedGate was
  
going back on its original deal with the .NET Community by taking Reflector
  
from free to commercial. <span></span>In all reality RedGate paid for the rights to Reflector fair and square and is within their rights to do exactly what they did. <span></span>

<p class="MsoNormal" style="text-align: center;line-height: 150%">
  <strong>&#8220;The chickens have come home to<br /> roost.&#8221;</strong>
</p>

<p class="MsoNormal" style="text-align: center;line-height: 150%">
  <strong>Translated : it&#8217;s your own damn fault.</strong>
</p>

<p class="MsoNormal" style="line-height: 150%">
  What happened is you found yourself warmed under the blanket of a commercial software vendor who decided it was time to kick you out of bed. What was once free is no longer and you are now paying the price (literally) for your lack of attention. Time and time again the .NET community abdicates control of its own destiny to commercial vendors. Almost every year Microsoft releases products that compete with open source applications that are already available and in most cases better than the commercial products that Microsoft releases.
</p>

<p class="MsoNormal" style="line-height: 150%">
  Here are a few examples:
</p>

  * <span style="font-family: Symbol"><span><span style="font: 7pt 'Times New Roman'"> </span></span></span>First there was Subversion and Git now there is TFS
  * <span style="font-family: Symbol"></span>First there was nHibernate, SubSonic, CSLA and
  
    db4o and  <span></span>now there is Entity Framework
  * <span style="font-family: Symbol"><span></span></span>First there was nUnit, xUnit now there is MSTEST
  * <span style="font-family: Symbol"></span>First there was StructureMap, Windsor, Ninject now there is Unity
  * <span style="font-family: Symbol"><span><span style="font: 7pt 'Times New Roman'"> </span></span></span>First there was Hudson and Cruise Control now
  
    there is TFS
  * <span style="font-family: Symbol"><span></span></span>First there was <put your OSS project here> Now there is <Some half baked tightly integrated products.

<p class="MsoNormal" style="line-height: 150%">
  Why we as a community do this to ourselves baffles my imagination. <span> </span>Let&#8217;s<br /> take a look at what happens to a commercial vendor when they get out of line.
</p>

<p class="MsoNormal" style="line-height: 150%">
  Last year Oracle bought Sun Microsystems.<span> </span>It did not take too long before Oracle overplayed their hand when it came to the many open source products that were in Sun Micro&#8217;s portfolio. What has happened since is a number of critical OSS projects have been forked and a new community was reborn.
</p>

<p class="MsoNormal" style="line-height: 150%">
  <span> </span>Many of you might know about the product OpenOffice. OpenOffice is an OSS project that competes with the Microsoft Office suite. A number of the members of the OpenOffice community created a fork of OpenOffice and LibreOffice was reborn. <a href="http://en.wikipedia.org/wiki/LibreOffice" target="_blank">http://en.wikipedia.org/wiki/LibreOffice</a>
</p>

<p class="MsoNormal" style="line-height: 150%">
  The second OSS project that has taken their ball elsewhere is the Hudson project. Hudson is a continuous integration server. What was once Hudson is now Jenkins CI.<span> </span>Basically Oracle overplayed its hand in this community as well and the members of that OSS community went elsewhere. The new project at: <a href="http://jenkins-ci.org/" target="_blank">http://jenkins-ci.org/</a>
</p>

<p class="MsoNormal" style="line-height: 150%">
  From these two examples you can see the real power of OSS. If the sponsors of a project get out of line the community can take their code and talent<span> </span>elsewhere. <span> </span>Is this even remotely possible in the Microsoft ecosystem ? Let&#8217;s take a look:
</p>

<p class="MsoNormal" style="line-height: 150%">
  When Microsoft<span> </span>decides to kill tools that you have adopted what can you do ? Pretty much nothing.<span> </span>Do you need a case in point ? OK here&#8217;s one for you: LINQ to SQL.<span> </span>In Oct 2008 Microsoft decided that LINQ to SQL would be deprecated.<span> </span>Here&#8217;s the<br /> post:
</p>

<p class="MsoNormal" style="line-height: 150%">
  <strong><em>http://blogs.msdn.com/b/adonet/archive/2008/10/29/update-on-linq-to-sql-and-linq-to-entities-roadmap.aspx</em></strong>
</p>

<p class="MsoNormal" style="line-height: 150%">
  So what is a developer to do ?<span> </span>Pretty much it&#8217;s a single choice. Abandon what you are doing and move onto the next &#8220;Promised Land&#8221; of data frameworks. Yes you can maintain your current code base but do you think it&#8217;s wise to continue development on technology you know is dead ?
</p>

<p class="MsoNormal" style="line-height: 150%">
  There is a real second choice but it takes a certain amount of bravery to do it. How about you abandon Microsoft when it comes to critical choices like data access and find an OSS project that meets your needs .
</p>

<p class="MsoNormal" style="line-height: 150%">
  Instead of using ASP.NET/MVC how about taking a serious look at FUBUMVC <a href="http://fubumvc.com/" target="_blank">(http://fubumvc.com/</a>). <span> </span>FUBUMVC is an MVC framework built by a team of developers that really use it. <span> </span>This makes more difference than you might imagine.<span> </span>How can a company really understand the pain of their own frameworks if they don&#8217;t use them ? As an analog Ruby on Rails (<a href="http://www.rubyonrails.org" target="_blank">http://www.rubyonrails.org</a>) is highly functional as a web framework because it was and is built by developers that actually use it.
</p>

<p class="MsoNormal" style="line-height: 150%">
  In this case I am picking on the ASP/MVC team a little. But I do commend that team for their behavior. The ASP.NET/MVC team is arguably the most transparent team at Microsoft.<span> </span>The ASP.NET/MVC framework is distributed under an open source license and you are free to download and modify the code as you see fit. Should the community decide to they could fork the code and follow their own path. In the case of ASP.NET/MVC it is nice to have choices.
</p>

<p class="MsoNormal" style="line-height: 150%">
  It is up to us as<span> </span>a community to quit abdicating our responsibility to the mother ship. We need to do the right thing and take our destinies into our own hands and start supporting existing open source projects. Heck if it&#8217;s an itch you need to scratch you might just want to start your own.
</p>