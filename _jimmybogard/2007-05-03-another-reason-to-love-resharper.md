---
wordpress_id: 14
title: Another reason to love ReSharper
date: 2007-05-03T13:34:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/05/03/another-reason-to-love-resharper.aspx
dsq_thread_id:
  - "301825537"
categories:
  - Tools
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/another-reason-to-love-resharper.html)._

Whenever I look at a class in code for the first time, I try to figure out what its responsibilities are.&nbsp; Ideally, I would look at unit tests exercising the public interface.&nbsp; These unit tests will give&nbsp;me a description of functionality, code showing usage, and most likely some assertions describing&nbsp;and verifying behavior.&nbsp; If there aren&#8217;t any unit tests, I have to resort to&nbsp;figuring out what the&nbsp;code is doing&nbsp;by examining the code&nbsp;(which is about 10 times slower than looking at unit tests).

First off, I&#8217;ll look at the using directives at the top of the file.&nbsp; Using directives can provide a key insight into the behaviors and responsibilities of a class, since the using directives show me what the dependencies are.&nbsp; For highly cohesive, loosely coupled code, you probably won&#8217;t see a ton of using directives, as a general rule of thumb.&nbsp; I was a little disheartened when I saw these using directives:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">using</span> System;<br />
<span class="kwrd">using</span> System.Collections;<br />
<span class="kwrd">using</span> System.ComponentModel;<br />
<span class="kwrd">using</span> System.Data;<br />
<span class="kwrd">using</span> System.Diagnostics;<br />
<span class="kwrd">using</span> System.Web;<br />
<span class="kwrd">using</span> System.Web.Services;<br />
<span class="kwrd">using</span> System.DirectoryServices;<br />
<span class="kwrd">using</span> System.Data.SqlClient;<br />
<span class="kwrd">using</span> System.Drawing;<br />
<span class="kwrd">using</span> System.Drawing.Design;<br />
<span class="kwrd">using</span> System.ComponentModel.Design;<br />
<span class="kwrd">using</span> System.Configuration;<br />
<span class="kwrd">using</span> System.Xml.Serialization;<br />
<span class="kwrd">using</span> System.Xml;<br />
<span class="kwrd">using</span> System.IO;<br />
<br />
<span class="kwrd">using</span> GL = System.Globalization;<br />
<span class="kwrd">using</span> CMP = System.IO.Compression;<br />
<span class="kwrd">using</span> MSG = System.Messaging;<br />
<br />
<span class="kwrd">using</span> System.Web.SessionState;<br />
<span class="kwrd">using</span> System.Web.UI;<br />
<span class="kwrd">using</span> System.Web.UI.WebControls;<br />
<span class="kwrd">using</span> System.Web.UI.HtmlControls;<br />
<span class="kwrd">using</span> System.Security;<br />
<span class="kwrd">using</span> MyCompany.Commerce.BusinessObjects.Shipping;<br />
<span class="kwrd">using</span> MyCompany.Commerce.Core;<br />
<span class="kwrd">using</span> SCF = MyCompany.Commerce.StoreConfiguration;<br />
<span class="kwrd">using</span> MyCompany.Commerce.Core.BusinessObjectManager;<br />
<span class="kwrd">using</span> SH = MyCompany.Commerce.BusinessObjects.Ecomm.Security.SecurityHelper;<br />
<span class="kwrd">using</span> ctx = MyCompany.Commerce.BusinessObjects.StoreContext;<br />
<span class="kwrd">using</span> MyCompany.Sales.Security;<br />
<span class="kwrd">using</span> MyCompany.Sales.Profile;<br />
<span class="kwrd">using</span> Microsoft.ApplicationBlocks.ExceptionManagement;</pre>
</div>

Wow.&nbsp; That&#8217;s a lot of using directives.&nbsp; Boooo.&nbsp; It looks like this class cares about web services, ADO.NET, XML serialization, IO, session state, and the list goes on and on.&nbsp; Waaaay too much for one class to care about.&nbsp; If there were a such thing as code referees, this class would get red carded for a flagrant foul of the [Single Responsibility Principle](http://en.wikipedia.org/wiki/Single_responsibility_principle).&nbsp; Luckily, I have Resharper.

### ReSharper to the rescue

[ReSharper](http://www.jetbrains.com/resharper/) is pretty much crack for developers.&nbsp; Once you use it for a week or even a day, you&#8217;ll find it nearly impossible to develop without it.&nbsp; So how did ReSharper help me in this situation?&nbsp; With a nifty &#8220;Optimize using directives&#8221; refactoring of course.&nbsp; The &#8220;Optimize using directives&#8221; refactoring will remove unused using directives, and can also add new ones where you&#8217;ve qualified type names with namespaces.&nbsp; Here are the using directives after the refactoring:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">using</span> System;<br />
<span class="kwrd">using</span> System.IO;<br />
<span class="kwrd">using</span> System.Web.Services;<br />
<span class="kwrd">using</span> System.Xml.Serialization;<br />
<span class="kwrd">using</span> System.Web.SessionState;<br />
<span class="kwrd">using</span> System.Web.UI;<br />
<span class="kwrd">using</span> System.Web.UI.HtmlControls;<br />
<span class="kwrd">using</span> System.Web.UI.WebControls;<br />
<span class="kwrd">using</span> BO = MyCompany.Commerce.BusinessObjects;<br />
<span class="kwrd">using</span> Microsoft.ApplicationBlocks.ExceptionManagement;<br />
<span class="kwrd">using</span> MyCompany.Commerce.BusinessObjects.Shipping;<br />
<span class="kwrd">using</span> MyCompany.Commerce.Core;<br />
<span class="kwrd">using</span> SCF = MyCompany.Commerce.StoreConfiguration;<br />
<span class="kwrd">using</span> MyCompany.Commerce.Core.BusinessObjectManager;<br />
<span class="kwrd">using</span> SH = MyCompany.Commerce.BusinessObjects.Ecomm.Security.SecurityHelper;<br />
<span class="kwrd">using</span> ctx = MyCompany.Commerce.BusinessObjects.StoreContext;<br />
<span class="kwrd">using</span> MyCompany.Sales.Security;<br />
<span class="kwrd">using</span> MyCompany.Sales.Profile;<br />
</pre>
</div>

HUGE improvement in readability.&nbsp; Now I can be fairly certain what the external dependencies of this class are, as we reduced the number of using directives from 34 (!) to 18, around half.&nbsp; There&#8217;s still way too many dependencies, I&#8217;d like to see this number reduced to around 5 or so.&nbsp; ReSharper will also sort the using statements to group common directives together (it doesn&#8217;t work for using aliases).&nbsp;&nbsp;Now it&#8217;s not&nbsp;as big a leap&nbsp;as it was before to try and figure out what this class does.&nbsp; That&#8217;s one less ibuprofen I&#8217;ll need today :).&nbsp; Of course, if this class had been properly unit tested, I wouldn&#8217;t need the ibuprofen in the first place, but that&#8217;s another story.