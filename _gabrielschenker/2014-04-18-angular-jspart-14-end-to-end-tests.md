---
wordpress_id: 775
title: Angular JS–Part 14, End to end tests
date: 2014-04-18T11:08:52+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/?p=775
dsq_thread_id:
  - "2621822327"
categories:
  - AngularJS
  - E2E testing
  - introduction
  - Setup
---
{% raw %}
# Introduction

The list of earlier posts in this series about Angular JS can be found [here](http://lostechies.com/gabrielschenker/2014/02/26/angular-js-blog-series-table-of-content/).

Automated end to end tests are an important part of the continuous integration and continuous delivery cycle. Without automated end to end tests delivering a new release of an application becomes burdensome. Manual regression testing can take weeks depending how complex the application is. That implicates that code freeze has to happen a long time before the product is ready to be deployed or ready to ship. Not only does this slow down the development or improvement of the application, no, it is also very expensive.

Writing (good) end to end tests of course takes time too and as such costs money. But the investment pays off quickly. Automated tests &#8211; once written &#8211; can be run again and again in exactly the same way and with exactly the same boundary conditions. This deterministic behavior of automated tests is important in many ways and superior to the often erratic way of testing done manually where the boundary conditions and the way how a test is executed often varies greatly each time 

Good end to end tests are not easy to write. But the tasks at hand becomes much easier if our (complex) application is a composite application made-up of many autonomous components. In such a scenario end to end tests really only need to test all parts of a single component and any interaction with other autonomous components can then be mocked or stubbed. On the other hand it is very hard if not near to impossible to write good, stable and maintainable end to end tests for a complex monolithic application.

The Angular team has created [Protractor](https://github.com/angular/protractor), an end to end test framework which is built on top of [WebDriver JS](https://code.google.com/p/selenium/wiki/WebDriverJs). Protractor runs tests against our application in a real browser in exactly the same way as a user would do. Protractor is specifically build to test Angular applications. Protractor under the hood uses [Selenium](http://docs.seleniumhq.org/) and as such is a superset of the selenium commands to automate a browser.

# Prepare your system

Here I am assuming that you are using a Windows computer. Installation on OS-X or Linux should be straight forward too.

## Update Google Chrome

Please make sure you have the latest version of **Google Chrome** installed. This is very important since otherwise you might have conflicts with the Chrome web driver we’ll install shortly. To make sure you’re up-to-date open Chrome and navigate to **About Google Chrome**. If your browser is not yet up-to-date then the browser will start updating itself

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/image_thumb.png" width="369" height="242" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/image.png)

## Install the Java Development Kit

Once this is done we need to make sure we have the newest 32-bit Java Development Kit (JDK) installed. You can download the JDK from [here](http://www.oracle.com/technetwork/java/javase/downloads/index.html). JDK is needed to run Selenium (which is written in Java).

Install node JS

If you have not done so before please install node JS. You can do it from [here](http://nodejs.org/).

## Install Protractor & Selenium

To start using Protractor it you first need to install it (and implicitly Selenium) on your system. Thus open a bash console and install Protractor globally using the node package manger (npm)

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image001" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image001_thumb.png" width="318" height="35" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image001.png) 

This will install the protractor (node) module globally such as that you can use it from any directory. If you&#8217;re on a Windows machine it will most likely install it into your user profile. On my machine this is 

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image002" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image002_thumb.png" width="557" height="33" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image002.png) 

End to end tests will run hosted by node. To download the (stand-alone) selenium server run this command 

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image001[5]" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0015_thumb.png" width="307" height="37" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0015.png) 

The above command installs the Selenium standalone server as well as the driver for the Chrome browser. If you want to test on other browsers you need to download the corresponding driver(s) from [here](http://docs.seleniumhq.org/docs/03_webdriver.jsp#driver-specifics-and-tradeoffs). 

Now we can start the selenium server 

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image002[5]" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0025_thumb.png" width="297" height="36" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0025.png) 

and this is what you should see 

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/image_thumb1.png" width="917" height="534" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/image1.png) 

The Selenium server will start and (by default) listen at port 4444 (<http://localhost:4444/wd/hub>) 

To verify that Selenium is indeed up and working you can navigate with your browser to the above link. You should see the following [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/image_thumb2.png" width="603" height="341" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/image2.png) 

## Trouble shooting

If that doesn&#8217;t work then probably you must define the JAVA_HOME and update the path variable accordingly. Locate your Java SDK, e.g. 

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image001[7]" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0017_thumb.png" width="361" height="158" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0017.png) 

And then add %JAVA_HOME%\bin to your PATH variable 

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image002[7]" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0027_thumb.png" width="361" height="158" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0027.png) 

For more details see the following link 

<http://stackoverflow.com/questions/15796855/java-is-not-recognized-as-an-internal-or-external-command> 

Alternatively navigate to the selenium folder (on my machine) 

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image003" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image003_thumb.png" width="620" height="38" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image003.png) 

Where ~ denotes the home directory (in my case /c/users/gschenker) 

try to start the Selenium server explicitly with this command 

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image004" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image004_thumb.png" width="571" height="38" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image004.png) 

Note: if you want to start the Selenium stand-alone server from any location then you need to make sure that either 

  * the chrome driver binary is in the Path (ChromeDriver.exe) or 
      * You start the Selenium server with this added command line argument</ul> 
    -Dwebdriver.chrome.driver=c:\path\to\your\chromedriver.exe 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image005" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image005_thumb.png" width="921" height="65" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image005.png) 
    
    Please refer to [this link](http://code.google.com/p/selenium/wiki/ChromeDriver) for further details about the chrome driver. 
    
    ## Creating a sample test
    
    Create a new project folder, e.g. 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image001[9]" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0019_thumb.png" width="369" height="42" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0019.png) 
    
    In a bash console navigate to this folder and use **bower** to install angular. 
    
    <font face="Courier New">$bower install angular</font> 
    
    Create a simple Angular application where the JavaScript file (**app.js**) contains the following code 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image001[11]" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image00111_thumb.png" width="424" height="91" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image00111.png) 
    
    And the view (**index.html**) is defined as follows 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/image_thumb3.png" width="817" height="369" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/image3.png) 
    
    If we run this application then we can enter our first name into the input box and Angular will greet us. 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image001[13]" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image00113_thumb.png" width="244" height="58" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image00113.png) 
    
    Let&#8217;s write a test that will enter a name into the input box and verify that the correct greeting message is displayed on screen. 
    
    Let&#8217;s write the test. Create a new file **testCtrl_spec.js** to the project folder and add the following test 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image002[11]" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image00211_thumb.png" width="578" height="177" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image00211.png) 
    
    By default Protractor uses [Jasmin](https://jasmine.github.io/2.0/introduction.html) as the framework for authoring tests. Jasmin is a behavior-driven development framework (BDD) and as such follows the paradigm of given-when-then. On line 1 we **describe** what we want to do (the given). On line two we have the actual test defined by the **it** function. This function contains the when-then part. On line 3 we say: “when we navigate the browser to the given URL…”. On line 4 through 6 we define what we are expecting as a consequence (the **then** part). 
    
    On line 4 we use the **element** function combined with the **by.model** function to locate an (HTML) element on our page. In this case we locate the element which uses Angular data binding and is bound to the **firstName** property of the model. Once we have this element (which is our input tag) we simulate a user entering the text **John** by using the **sendKeys** function. 
    
    On line 5 we again use the **element** function this time combined with the **by.binding** function to locate the (HTML) element where our greeting is output. In out sample this is the **<p>** tag. Note, protractor is finding this element although the binding part **<font face="Courier New">{{firstName}}</font>** is only part of the content of the **<p>** tag! 
    
    Note that we expect a web server listening at port **44544** and serving us our **index.html** sample page. Let&#8217;s run **IIS Express** on this port with the following command 
    
    &#8220;C:\Program Files (x86)\IIS Express\iisexpress.exe&#8221; /path:c:\dev\prototypes\End2EndTesting /port:44544 
    
    **Also note**: on line 3 you need to put the full URL e.g.  
    <http://localhost:44544/index.html> and not some abbreviation like [localhost:44544/index.html](http://localhost:44544/index.html)! 
    
    Last we need a configuration file for protractor such as that the test runner knows which tests to run and how to run them. 
    
    Add a file called **spec.js** to the project folder and add the following information 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image003[5]" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0035_thumb.png" width="469" height="297" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0035.png) 
    
    Now we are ready to run the test. In the bash console navigate to the project folder and run this command 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image004[5]" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0045_thumb.png" width="241" height="33" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0045.png) 
    
    Protractor will automatically start Chrome, load our **index.html** page, fill in the input box and validate that the greeting is correct. 
    
    If we did everything right we should see this result in the console 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image005[5]" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0055_thumb.png" width="661" height="130" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0055.png) 
    
    If the test fails we should see something like this 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image006" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image006_thumb.png" width="654" height="344" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image006.png) 
    
    # A more complex test
    
    In this test we want to test what happens if we click on a button **Load Staff** which will load a list of staff from a backend. 
    
    Create a new project folder. Add a file **index.html** to the folder containing the following HTML. 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/image_thumb4.png" width="811" height="328" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/image4.png) 
    
    Add the following snippet under the **<div>** 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image001[15]" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image00115_thumb.png" width="915" height="130" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image00115.png) 
    
    Add a file **app.js** to the project and add this code to define a controller. 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/image_thumb5.png" width="580" height="112" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/image5.png) 
    
    Now define the **loadStaff** function in the controller 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image002[13]" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image00213_thumb.png" width="609" height="227" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image00213.png) 
    
    Of course in this sample we are only simulating the backend and are actually serving some pre-canned data. But rest assured the test would work also if there was a real backend call using e.g. the **$http** or the **$resource** service. 
    
    Now let&#8217;s look at the test code. Add a file **testCtrl_spec.js** to your project folder and add the following code snippet to this file 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/image_thumb6.png" width="973" height="271" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/image6.png) 
    
    In the test arrange part we load the **index.html** page (line 3). Then we act by locating the button via it&#8217;s ID and clicking on it (line 5). Finally we get all **<li>** elements that will be created by Angular. These elements are identified by the **ng-repeat** directive **staff in staffList** (line 7) and we assert that we have 5 items as expected (line 8). Finally on line 9 we make sure that the name in the first list item is **Miller**. Note the **element.all(…)** syntax used in line 7 to retrieve multiple elements instead of just a single one 
    
    Note: A more robust way of writing the same test is using promises (see [here](https://github.com/juliemr/protractor-demo/blob/master/test/spec.js) for inspiration; line 42ff) 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/image_thumb7.png" width="980" height="272" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/image7.png) 
    
    Do not forget to add the configuration file for protractor to the project. You can use the same file (content) that we introduced in the previous sample. 
    
    Now we can run protractor again 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image005[7]" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0057_thumb.png" width="241" height="33" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0057.png) 
    
    and we should see a test with two passing/fulfilled expectations. 
    
    # Using page objects
    
    When we are building up a library of end-to-end tests we might want to make sure that our tests are robust and maintainable. One possible and recommended way to improve tests is to abstract the details of a view and define so called Page Objects. These are simple JavaScript functions that provide a nice API to a view to test and encapsulate the &#8220;ugly&#8221; code needed to identify and/or manipulate DOM objects. 
    
    Let&#8217;s create a simple sample &#8211; a login page. Here is the HTML 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image001[17]" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image00117_thumb.png" width="846" height="587" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image00117.png) 
    
    Let&#8217;s call this view **login.html**. As we can see we have various elements on this view that we want to interact with; a username and password input element, a login button and a **<div>** with a status message. Let&#8217;s abstract this page/view. Add a new file **login-test.js** to the project and add this code 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image002[15]" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image00215_thumb.png" width="736" height="421" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image00215.png) 
    
    We now have a **LoginPage** object (in JavaScript a function is an object) with 3 properties **userName**, **password** and **status** and 4 methods **setUserName**, **setPassword**, **login** and **get**. 
    
    We can the write a test (or many different tests…) and use this page object. 
    
    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image003[9]" src="http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0039_thumb.png" width="696" height="300" />](http://lostechies.com/content/gabrielschenker/uploads/2014/04/clip_image0039.png) 
    
    Please note that the test looks much more readable. We can reason about the business or workflow logic much better if we do not have all the nasty Protractor and/or Selenium details littered through the code. Also it is much easier to maintain our tests in case we are going to change some details on the login view since we only will have to update the corresponding page object. 
    
    # Other samples
    
    Please make sure you look into code! Julie, the author of protractor has many sample tests. Some of them can be found here 
    
    <https://github.com/juliemr/protractor-demo/blob/master/test/spec.js> 
    
    For more samples regarding how to select elements on a page see here 
    
    <https://github.com/juliemr/protractor/blob/master/spec/basic/findelements_spec.js> 
    
    # Links
    
    <http://product.moveline.com/testing-angular-apps-end-to-end-with-protractor.html>
{% endraw %}
