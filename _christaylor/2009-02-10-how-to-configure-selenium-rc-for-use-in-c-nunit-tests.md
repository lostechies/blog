---
wordpress_id: 7
title: 'How to Configure Selenium RC for Use In C# NUnit Tests'
date: 2009-02-10T12:24:00+00:00
author: Chris Taylor
layout: post
wordpress_guid: /blogs/agilecruz/archive/2009/02/10/how-to-configure-selenium-rc-for-use-in-c-nunit-tests.aspx
categories:
  - .NET
  - 'C#'
  - configuration
  - TDD
  - Tools
  - Unit Testing
redirect_from: "/blogs/agilecruz/archive/2009/02/10/how-to-configure-selenium-rc-for-use-in-c-nunit-tests.aspx/"
---
When I set about integrating Selenium into my test suites, I found all the information I needed to do that with but had to hunt and peck through my google searches to find it.&nbsp; So, as a point of reference, I figured I&#8217;d put what I needed to do all in one place:

**Two main activities:**

  1. <span style="text-decoration: underline">Set up Selenium RC server in Windows </span> 
      * Download latest Java SE from <http://java.sun.com/> and install 
      * Create a folder named Selenium under your jdk or jre bin file (example: C:Program FilesJavajre1.6.0_05bin). 
      * Download latest version of Selenium RC from <http://seleniumhq.org/download/> and extract into your newly created folder 
      * From the Command prompt run the following commands: 
          * cd \[your jdk/jre bin directory\] (example: C:Program FilesJavajre1.6.0_05bin). 
          * java -jar .Seleniumselenium-server.jar -interactive 
          * If you see the following messages your Selenium server is alive and kickin&rsquo;:   
            Entering interactive mode&#8230; type Selenium commands here (e.g: cmd=open&1=http:/   
            /www.yahoo.com) 
  2. <span style="text-decoration: underline">Place a reference to the ThoughtWorks.Selenium.Core.dll into your .NET test assembly</span> 
      * This
  
        can be found under the Selenium install directory (example: C:Program
  
        FilesJavajre1.6.0_05binSeleniumselenium-remote-control-1.0-beta-2selenium-dotnet-client-driver-1.0-beta-2ThoughtWorks.Selenium.Core.dll)

**Git &lsquo;Er Done With Some Tests**

Now, you&#8217;re up and ready to start writing NUnit tests using Selenium in C#.&nbsp; By the way, you can record your tests using the [Selenium IDE](http://seleniumhq.org/projects/ide/) and export the tests to a number of languages, including C#:

[<img style="border-width: 0px;float: none;margin-left: auto;margin-right: auto" alt="SeleniumExport" src="http://lh5.ggpht.com/_vRJChorZihY/SYh3SPcM14I/AAAAAAAABBM/qMFhuLT5gfg/SeleniumExport_thumb.jpg?imgmax=800" border="0" width="400" height="497" />](http://lh4.ggpht.com/_vRJChorZihY/SYifk3LYrII/AAAAAAAABBI/kaiLrzC5DcE/s1600-h/SeleniumExport[1].jpg) 

<span style="text-decoration: underline">Example Test Suite as Exported using the above</span>:

> using System;   
> using System.Text;   
> using System.Text.RegularExpressions;   
> using System.Threading;   
> using NUnit.Framework;   
> using Selenium; 
> 
> namespace SeleniumTests   
> {   
> &nbsp;&nbsp;&nbsp; [TestFixture]   
> &nbsp;&nbsp;&nbsp; public class NewTest   
> &nbsp;&nbsp;&nbsp; {   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; private ISelenium selenium;   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; private StringBuilder verificationErrors;   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [SetUp]   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public void SetupTest()   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; selenium = new DefaultSelenium(&#8220;localhost&#8221;, 4444, &#8220;*chrome&#8221;, &#8220;[http://sparkystestserver:48/&#8221;);](http://sparkystestserver:48/%22%29;)   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; selenium.Start();   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [TearDown]   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public void TeardownTest()   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; try   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; selenium.Stop();   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; catch (Exception)   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Ignore errors if unable to close the browser   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Assert.AreEqual(&#8220;&#8221;, verificationErrors.ToString());
> 
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [Test]   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public void TheNewTest()   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; selenium.Open(&#8220;/Home&#8221;);   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; selenium.Type(&#8220;loginname<span style="text-decoration: line-through">&#8220;</span>, <span style="text-decoration: line-through">&#8220;</span>sparky<span style="text-decoration: line-through">&#8220;</span>);   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; selenium.Type(&#8220;password&#8221;, &#8220;mooseButt<span style="text-decoration: line-through">&#8220;</span>);   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; selenium.Click(&#8220;ctl00\_MainContent\_loginButton&#8221;);   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Assert.AreEqual(&#8220;burp&#8221;, selenium.GetValue(&#8220;burpField&#8221;));   
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }   
> &nbsp;&nbsp;&nbsp; }   
> }

Hope that helps!

&nbsp;

[Originally posted on 2/3/2009 at http://agilecruz.blogspot.com]