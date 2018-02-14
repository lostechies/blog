---
wordpress_id: 77
title: How To Get Started With Selenium Core And ASP.NET MVC
date: 2009-08-27T19:02:22+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/08/27/how-to-get-started-with-selenium-core-and-asp-net-mvc.aspx
dsq_thread_id:
  - "262067004"
categories:
  - .NET
  - Model-View-Controller
  - Productivity
  - Quality
  - Selenium
  - Test Automation
redirect_from: "/blogs/derickbailey/archive/2009/08/27/how-to-get-started-with-selenium-core-and-asp-net-mvc.aspx/"
---
About a year and a half ago, my team and I tried to get some WaitiN UI tests up and running. We got some basic tests working on our local machines after a while, but we were never able to get them to run correctly in our CruiseControl.NET CI server. We spent near 2 months trying to get it to work with nothing but pain and heartache. Eventually we gave up on WatiN and left UI test automation out of our process. 

Recently, my interested in UI test automation has resurfaced. I wanted to find an easier way to get up and running, though, and see if anyone else out in the world had some suggestions on what to use and why. The twitter-verse was kind enough to offer more opinions than available frameworks, as I expected. In the end, some opinions of Selenium combined with previous demo I had seen and some discussion with Scott Bellware helped convinced me to give Selenium a shot. After 30 minutes of Googling for “how to get started with selenium” and finding nothing useful, I pulled up their built in test suite and just started hacking away at it. It only took about 10 minutes to get my first test up and running, from there. 

At this point, I’m still a complete n00b in terms of UI test automation with Selenium, but I at least understand how to get a test suite setup and running. With that in mind, I wanted to share my own quick-start tutorial to try and help others get up and running with Selenium Core as quickly as possible.

&#160;

### Step 1: Download Selenium Core

Ok, that’s probably a Step 0… but I’ll go head and include it anyways. Head on over to [SeleniumHQ](http://seleniumhq.org/) and download the latest Selenium Core. At this time, I’m using v1.0.1. Once you have that package downloaded, you can unzip the contents into a folder that is accessible to your web server. You’ll end up with a folder structure that contains everything you need to get started, and have all of the built in selenium tests available for you to run. 

 <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_1F6CB2E8.png" width="592" height="318" />

You can open the index.html file in a browser and see all of the tests run. This isn’t terribly interesting to me, though, since it only shows the tests running and not how to work with them or write them.

&#160;

### Step 2: Setup an ASP.NET MVC Application

For this example, we are just using the default project structure for a sample ASP.NET MVC web application. I called my project “MyFirstMVCSeleniumTest”. 

I’m not going to touch any of the forms and database related stuff, though, so you don’t need to worry about putting an actual database behind the site, if you don’t want to. I’m also not going to both with a unit test suite at this point. After all, this is not a production-ready example test. I’m only intending this as a very quick “how to get started with selenium” tutorial. 

Once you’ve got the MVC project setup, you should be able to hit the home page of the app and see this:

 <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_7EE57335.png" width="730" height="275" />

&#160;</p> 

### Step 3: Setup A Test Suite Web Application

For this step, we’re going to add another Web Application to our solution in Visual Studio. My test suite was called “MyFirstMVCSeleniumTest.UITestSuite”. 

I like to set up a separate project so that I don’t have to ship my UI test suite with the application if I don’t want to. It also helps me to easily see where my test suite is vs. the actual application. It really doesn’t matter if you add an MVC or WebForms web app for this step – we’re not going to use either of those UI technologies. In fact, once you have the web application for your test suite created, you can delete all of the default files and folders that were created – we don’t need them.

The end result of having both projects in your visual studio solution should look something like this:

&#160; <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_508BED88.png" width="283" height="331" />

Notice that the UITestSuite project is empty – no App_Data, no web.config, no nothing… we don’t need any of that because we’re dealing with plain HTML files, not an ASP.NET codebase. The reason I used an ASP.NET application here, was to make management of the files easier in Visual Studio.

&#160;

### Step 4: Add Selenium To Your UI Test Suite Project

Remember those 7 folders and 6 files that you unpacked at the root level of the selenium distribution, as shown above? The good news is you don’t need most of that. All you need for this basic test suite is the “core” folder. Copy the “core” folder from the location that you unzipped it, into your UITestSuite. For clarity on what this folder actually is, I renamed it to “Selenium”. 

The result looks like this:

 <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_7E0D0D4B.png" width="285" height="350" />

&#160;

### Step 5: Setup A Test Suite

This was probably the most difficult part of figuring out how to use selenium, for me. I think it took all of 5 minutes to realize that I need to have a “test suite” and a “test” as separate HTML files, so that selenium knows what to run.

To start with, create a plain old HTML file called “TestSuite.html” in the root of your UITestSuite project. This will contain the location of the actual tests, so that selenium knows what tests to run. The contents of this file are about as simple as you can get: an html table with a link to a test file.

Here’s the screenshot of the project:

&#160; <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_169CAA9C.png" width="285" height="369" />

and here’s the contents of the TestSuite html file:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">&lt;</span><span style="color: #800000">html</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">&lt;</span><span style="color: #800000">head</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">&lt;</span><span style="color: #800000">title</span><span style="color: #0000ff">&gt;</span>Test Suite<span style="color: #0000ff">&lt;/</span><span style="color: #800000">title</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span> <span style="color: #0000ff">&lt;/</span><span style="color: #800000">head</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span> <span style="color: #0000ff">&lt;</span><span style="color: #800000">body</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">&lt;</span><span style="color: #800000">table</span> <span style="color: #ff0000">id</span><span style="color: #0000ff">="suiteTable"</span> <span style="color: #ff0000">cellpadding</span><span style="color: #0000ff">="1"</span> <span style="color: #ff0000">cellspacing</span><span style="color: #0000ff">="1"</span> <span style="color: #ff0000">border</span><span style="color: #0000ff">="1"</span> <span style="color: #ff0000">class</span><span style="color: #0000ff">="selenium"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>         <span style="color: #0000ff">&lt;</span><span style="color: #800000">tbody</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>             <span style="color: #0000ff">&lt;</span><span style="color: #800000">tr</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;&lt;</span><span style="color: #800000">b</span><span style="color: #0000ff">&gt;</span>Test Suite<span style="color: #0000ff">&lt;/</span><span style="color: #800000">b</span><span style="color: #0000ff">&gt;&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>             <span style="color: #0000ff">&lt;/</span><span style="color: #800000">tr</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>             <span style="color: #0000ff">&lt;</span><span style="color: #800000">tr</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;&lt;</span><span style="color: #800000">a</span> <span style="color: #ff0000">href</span><span style="color: #0000ff">="./SomeTest.html"</span><span style="color: #0000ff">&gt;</span>My First MVC/Selenium Example Test!<span style="color: #0000ff">&lt;/</span><span style="color: #800000">a</span><span style="color: #0000ff">&gt;&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>             <span style="color: #0000ff">&lt;/</span><span style="color: #800000">tr</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span>         <span style="color: #0000ff">&lt;/</span><span style="color: #800000">tbody</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span>     <span style="color: #0000ff">&lt;/</span><span style="color: #800000">table</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span> <span style="color: #0000ff">&lt;/</span><span style="color: #800000">body</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  17:</span> <span style="color: #0000ff">&lt;/</span><span style="color: #800000">html</span><span style="color: #0000ff">&gt;</span></pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        &#160;
      </p>
      
      <h3>
        Step 6: Add A Test
      </h3>
      
      <p>
        You can see in the html from the test suite that I have included a file called “SomeTest.html”. This is a test that selenium will execute for us. We can include multiple tests in a test suite – we just need to add new table rows pointing to the other test files. For now, though, let’s just start with the one test.
      </p>
      
      <p>
        <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_5D199AA4.png" width="257" height="108" />
      </p>
      
      <p>
        A test in selenium is not a simple, single command. Rather, it is a series of simple commands that are formatted in three columns of a table. These columns contain the commands and up to two optional parameters. You can read all about the ‘seleniumese’ over at the <a href="http://seleniumhq.org/docs/index.html">documentation</a> site.
      </p>
      
      <p>
        To start with, we’ll create a simple test that does a few things with our ASP.NET MVC website:
      </p>
      
      <ol>
        <li>
          Open the website
        </li>
        <li>
          verify that we’re on the ASP.NET MVC site by looking for the “Welcome to ASP.NET MVC!” text
        </li>
        <li>
          verify that we have an “About” link
        </li>
        <li>
          click on the “About” link and wait for the about page to load
        </li>
        <li>
          Verify that we are on the About page by looking for the “About” text
        </li>
        <li>
          Verify that we are on the About page by looking for the “About Us” title in the browser window
        </li>
      </ol>
      
      <p>
        The HTML that we need to put into our SomeTest file, is this:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">&lt;</span><span style="color: #800000">html</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">&lt;</span><span style="color: #800000">head</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">&lt;</span><span style="color: #800000">title</span><span style="color: #0000ff">&gt;</span>My First MVC/Selenium Example Test!<span style="color: #0000ff">&lt;/</span><span style="color: #800000">title</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span> <span style="color: #0000ff">&lt;/</span><span style="color: #800000">head</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span> <span style="color: #0000ff">&lt;</span><span style="color: #800000">body</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">&lt;</span><span style="color: #800000">table</span> <span style="color: #ff0000">cellpadding</span><span style="color: #0000ff">="1"</span> <span style="color: #ff0000">cellspacing</span><span style="color: #0000ff">="1"</span> <span style="color: #ff0000">border</span><span style="color: #0000ff">="1"</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>         <span style="color: #0000ff">&lt;</span><span style="color: #800000">tbody</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span>             <span style="color: #0000ff">&lt;</span><span style="color: #800000">tr</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span> <span style="color: #ff0000">rowspan</span><span style="color: #0000ff">="1"</span> <span style="color: #ff0000">colspan</span><span style="color: #0000ff">="3"</span><span style="color: #0000ff">&gt;</span>This Is My First MVC/Selenium Example Test!<span style="color: #0000ff">&lt;</span><span style="color: #800000">br</span><span style="color: #0000ff">&gt;&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  10:</span>             <span style="color: #0000ff">&lt;/</span><span style="color: #800000">tr</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  11:</span>             <span style="color: #0000ff">&lt;</span><span style="color: #800000">tr</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  12:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span>open<span style="color: #0000ff">&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  13:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span>http://localhost/MyFirstMVCSeleniumTest<span style="color: #0000ff">&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  14:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  15:</span>             <span style="color: #0000ff">&lt;/</span><span style="color: #800000">tr</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  16:</span>             <span style="color: #0000ff">&lt;</span><span style="color: #800000">tr</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  17:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span>verifyTextPresent<span style="color: #0000ff">&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  18:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span>Welcome to ASP.NET MVC!<span style="color: #0000ff">&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  19:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  20:</span>             <span style="color: #0000ff">&lt;/</span><span style="color: #800000">tr</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  21:</span>             <span style="color: #0000ff">&lt;</span><span style="color: #800000">tr</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  22:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span>verifyElementPresent<span style="color: #0000ff">&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  23:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span>link=About<span style="color: #0000ff">&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  24:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  25:</span>             <span style="color: #0000ff">&lt;/</span><span style="color: #800000">tr</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  26:</span>             <span style="color: #0000ff">&lt;</span><span style="color: #800000">tr</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  27:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span>clickAndWait<span style="color: #0000ff">&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  28:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span>link=About<span style="color: #0000ff">&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  29:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  30:</span>             <span style="color: #0000ff">&lt;/</span><span style="color: #800000">tr</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  31:</span>             <span style="color: #0000ff">&lt;</span><span style="color: #800000">tr</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  32:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span>verifyTextPresent<span style="color: #0000ff">&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  33:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span>About<span style="color: #0000ff">&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  34:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  35:</span>             <span style="color: #0000ff">&lt;/</span><span style="color: #800000">tr</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  36:</span>             <span style="color: #0000ff">&lt;</span><span style="color: #800000">tr</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  37:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span>assertTitle<span style="color: #0000ff">&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  38:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span>About Us<span style="color: #0000ff">&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  39:</span>                 <span style="color: #0000ff">&lt;</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;&lt;/</span><span style="color: #800000">td</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  40:</span>             <span style="color: #0000ff">&lt;/</span><span style="color: #800000">tr</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  41:</span>         <span style="color: #0000ff">&lt;/</span><span style="color: #800000">tbody</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  42:</span>     <span style="color: #0000ff">&lt;/</span><span style="color: #800000">table</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  43:</span> <span style="color: #0000ff">&lt;/</span><span style="color: #800000">body</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  44:</span> <span style="color: #0000ff">&lt;/</span><span style="color: #800000">html</span><span style="color: #0000ff">&gt;</span></pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              You should be able to correlate the commands and parameters from this file – represented as table rows and columsn – to the list of steps that I outlined above.
            </p>
            
            <p>
              Now I know that this isn’t the most exciting test in the world. I wasn’t going for exciting. In fact, I wasn’t even going for ‘valuable’ in this test. I only wanted to show how simple it is to get a test like this up and running.
            </p>
            
            <p>
              &#160;
            </p>
            
            <h3>
              Step 7: Run The Test
            </h3>
          </p></p> </p> 
          
          <p>
            Running a selenium test suite is as easy as hitting a web page.
          </p>
          
          <p>
            First, Make sure you have built the ASP.NET MVC app and that you can open it in your browser. Then we’ll point your browser to the location of the test suite. To tell selenium to run, we want to hit the “Selenium/TestRunner.html” file that is included in the “core” folder that we renamed to “Selenium”. The TestRunner file expects to find a “test” parameter attatched to the end of it, to tell it what test suite to run (if you don’t provide this, it will default to something like Test.html).
          </p>
          
          <p>
            Assuming that we are using localhost IIS for our test suite, the URL would look like this:
          </p>
          
          <p>
            <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_67D6F1F9.png" width="664" height="32" />
          </p>
          
          <p>
            Notice the “../” in the test parameter – this is because the “TestSuite.html” file lives one folder above the TestRunner.html file.
          </p>
          
          <p>
            By pulling up this URL, you should see the following screen:
          </p>
          
          <p>
            <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_35731E7A.png" width="811" height="726" />
          </p></p> 
          
          <p>
            To run the test, click the “Play all” ( <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_26C87295.png" width="24" height="13" /> )button in the Selenium TestRunner section of the windows. You’ll see the bottom half of this page switch over to your MVC app, the page will change from the home page to the About us page, and the tests in the middle top of the screen should all turn green!
          </p>
          
          <p>
            <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_4D9688D5.png" width="813" height="729" />
          </p>
          
          <p>
            If you would like to “see” all of this happen, you can move the slider in the Selenium TestRunner from Fast over to Slow. You can also check the “Highlight elements” box, which will turn the element yellow when it is being worked on. This will let you see what’s really going on, in much more detail.
          </p>
          
          <p>
            &#160;
          </p>
          
          <h3>
            Step 8: Verify The Results
          </h3></p> 
          
          <p>
            After running the test suite, we can see some results and metrics shown in the Selenium TestRunner section of the screen.
          </p>
          
          <p>
            <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_3AE18F1E.png" width="282" height="231" />
          </p>
          
          <p>
            It took a total of 5 seconds to run this test suite, i had 1 test run and there were 4 commands that executed and passed.
          </p>
          
          <p>
            Did you notice that the number of “commands” is not the same as the number of steps in our test? This is because some of the steps in the test are actions that do things, not commands that check for things. In our list of 6 steps, step #1 and #4 are actions – open the website, click the about link – and the other 4 steps are the commands that assert or verify state. You can see this distinction in the center column of the test suite, as light green items for the actions and green items for the commands:
          </p>
          
          <p>
            <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/content/derickbailey/uploads/2011/03/image_015E7F27.png" width="336" height="160" />
          </p></p> 
          
          <h3>
            Download The Sample Code
          </h3>
          
          <p>
            If you’re interested in downloading the complete solution that I created, here, you can grab it from my GitHub account:
          </p>
          
          <blockquote>
            <p>
              <strong>Download </strong><a href="http://github.com/derickbailey/MyFirstMVCSeleniumTest/tree/master"><strong>My First MVC Selenium Test</strong></a>
            </p>
          </blockquote>
          
          <p>
            I did this in Visual Studio 2008 with Service Pack 1 and the <a href="http://www.asp.net/mvc/">ASP.NET MVC Framework v1.0</a>.
          </p>
          
          <h3>
            Conclusion
          </h3>
          
          <p>
            Congratulations, you now have a working Selenium Core test suite for your ASP.NET MVC application! There are lot of lessons to learn beyond just these basics, though. We have to consider filling out forms, submitting them, working with ajax callbacks, integrating the test suite into a continuous integration server, and many many other aspects of our testing strategy.
          </p>
          
          <p>
            As a final note &#8211; I have no misunderstandings about the limitations of HTML based testing, like this. The more we tie ourselves to the specific HTML of a page, the more brittle our tests become. I don’t want anyone to think that the examples I have shown here are in any way production-ready. This was only a “get started fast” tutorial, created by a guy who is just now learning how to use Selenium. Please remember that good tests take a lot of effort to plan and maintain over time. There is no shortcut for the planning and maintenance of the tests. It seems, though, that selenium is a great way to simplify the writing of the tests.
          </p>