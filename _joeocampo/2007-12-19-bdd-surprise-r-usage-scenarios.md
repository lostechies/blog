---
wordpress_id: 92
title: 'BDD Surprise: R# Usage Scenarios'
date: 2007-12-19T07:25:58+00:00
author: Joe Ocampo
layout: post
wordpress_guid: /blogs/joe_ocampo/archive/2007/12/19/bdd-surprise-r-usage-scenarios.aspx
dsq_thread_id:
  - "262090946"
categories:
  - altnetconf
  - BDD (Behavior Driven Development)
redirect_from: "/blogs/joe_ocampo/archive/2007/12/19/bdd-surprise-r-usage-scenarios.aspx/"
---
I had to blog about this because it brought a smile to my face when I saw it.

After some discussion yesterday over the benefits of implementing a <a href="http://www.infoq.com/articles/rest-introduction" target="_blank">REST</a> model in <a href="http://weblogs.asp.net/scottgu/archive/2007/12/09/asp-net-3-5-extensions-ctp-preview-released.aspx" target="_blank">ASP.Net MVC</a>.&nbsp; I was up late last night looking over the <a href="http://www.codeplex.com/MVCContrib" target="_blank">MVCContrib</a> project.&nbsp; I came across <a href="http://abombss.com/" target="_blank">Adam Tybor&#8217;s</a> <a href="http://abombss.com/blog/2007/12/10/ms-mvc-simply-restful-routing/" target="_blank">SimplyRestful</a> contribution.

When I look at most OSS project I usually look at the objects implementation first and then I look for the test coverage.

I found a class named &#8220;RestfulActionResolver&#8221;, the name alone peek my curiosity.&nbsp; I noticed this class had a ResolveActionMethod that would seem to, resolve the action. 🙂&nbsp; I used <a href="http://www.jetbrains.com/resharper/" target="_blank">ReSharper</a> to find the usages of this method to see just how it was being acted upon by other objects(ctrl-alt-F7).&nbsp; 

What appeared next shocked me:

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="234" alt="image" src="https://lostechies.com/content/joeocampo/uploads/2011/03BDDSurpriseRUsageScenarios_1527/image_thumb.png" width="644" border="0" />](https://lostechies.com/content/joeocampo/uploads/2011/03BDDSurpriseRUsageScenarios_1527/image_2.png) 

&nbsp;

The top of the report read like a normal test suite no surprise there but then I quickly noticed the bottom two entries!

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="38" alt="image" src="https://lostechies.com/content/joeocampo/uploads/2011/03BDDSurpriseRUsageScenarios_1527/image_thumb_1.png" width="644" border="0" />](https://lostechies.com/content/joeocampo/uploads/2011/03BDDSurpriseRUsageScenarios_1527/image_4.png) 

Two things shocked me!

  1. Usage of BDD context/action/behavior (sweet!)
  2. How well it read from a usage report perspective (double sweet!)

Most of you that read my blog love OSS.&nbsp; I sometimes hate to go into a project and figure out how some OSS project actually works.&nbsp; Lets face it documentation is very pore on OSS projects.&nbsp; But by utilizing a BDD approach the test fixtures and test become self describing meta data for comprehending the intentions and actions of the code.&nbsp; 

I know there has been some debate on should the specification files contain multiple class entries defining context.

Ex:

  * File Name: SimplyRestfulSpecs.cs
[TestFixture]  
[Category(&#8220;SimplyRestfulSpecs&#8221;)]  
public class When\_The\_Form\_Is\_Posted\_With\_A\_Form\_Field\_Named\_Method\_And\_A\_Value\_Of_PUT 

[TestFixture]  
[Category(&#8220;SimplyRestfulSpecs&#8221;)]  
public class When\_The\_Form\_Is\_Posted\_With\_A\_Form\_Field\_Named\_Method\_And\_A\_Value\_Of_DELETE

Well chalk this one up in the &#8220;Favor&#8221; column for &#8220;multiple class entries defining context&#8221;.&nbsp; With out this I don&#8217;t know if the report would have read as well.

Happy coding!

&nbsp;