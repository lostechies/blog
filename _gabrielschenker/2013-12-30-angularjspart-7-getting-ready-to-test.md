---
wordpress_id: 464
title: AngularJS–Part 7, Getting ready to test
date: 2013-12-30T00:00:49+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/?p=464
dsq_thread_id:
  - "2081100642"
categories:
  - AngularJS
  - introduction
  - Setup
  - TDD
---
# Introduction

This is a series of posts about [AngularJS](http://angularjs.org/) and our experiences with it while migrating the client of a complex enterprise application from Silverlight to HTML5/CSS/JavaScript using AngularJS as a framework. Since the migration is a very ambitious undertaken I want to try to chop the overall problem space in much smaller pieces that can be swallowed and digested much more easily by any member of my team. So far I have published the following posts in this series

  * [AngularJS – Part 1](https://lostechies.com/gabrielschenker/2013/12/05/angularjspart-1/) 
      * [AngularJS – Part 1, Feedback](https://lostechies.com/gabrielschenker/2013/12/07/angularjspart-1-feedback/) 
          * [AngularJS – Part 2, the controller](https://lostechies.com/gabrielschenker/2013/12/09/angularjspart-2-the-controller/) 
              * [AngularJS – Part 3, Inheritance](https://lostechies.com/gabrielschenker/2013/12/10/angularjspart-3-inheritance/) 
                  * [AngularJS – Part 4, Accessing server side resources](https://lostechies.com/gabrielschenker/2013/12/12/angularjspart-4-accessing-server-side-resources/) 
                      * [AngularJS- Part 5, Pushing data to the server](https://lostechies.com/gabrielschenker/2013/12/17/angularjspart-5-pushing-data-to-the-server/)
                      * [AngularJS – Part 6, Templates](https://lostechies.com/gabrielschenker/2013/12/28/angularjspart-6-templates/)</ul> 
                    Test driven development ([TDD](http://en.wikipedia.org/wiki/Test-driven_development)) is very important when developing a web application with a rich client since JavaScript is a dynamic language and thus there is no compiler making sure that our code behaves like expected. Tests are our only safety net. Writing tests in JavaScript and running them in a browser is not trivial. Lately the situation has improved quite a bit. Still, to get up and running for the first time is a non trivial task.
                    
                    # Setting up the system
                    
                    Please note that I am using a laptop with Windows 8.1 as the operating system. But the following setup should also work without any modifications on Windows 7 & 8.
                    
                    To run unit tests we are going to use [Karma](https://karma-runner.github.io/0.10/index.html) (previously named Testacular). Karma is a test runner created by the AngularJS team at Google. Similar to AngularJS itself it is open source. To write the tests we will use [Jasmine](https://jasmine.github.io/) which is a behavior driven JavaScript test framework or [DSL](http://en.wikipedia.org/wiki/Domain-specific_language).
                    
                    A prerequisite for Karma is node.js. Thus please install [node.js](http://nodejs.org/) on your computer
                    
                    Open a console in admin mode. Preferably use an advanced console like [Console2](http://sourceforge.net/projects/console/). Use the Node package manager (NPM) to install Karma. We want to install it globally thus use this command
                    
                    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb97.png" width="290" height="37" />](https://lostechies.com/content/gabrielschenker/uploads/2013/12/image99.png)
                    
                    Now we need to configure Karma for use in our project
                    
                    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb98.png" width="312" height="29" />](https://lostechies.com/content/gabrielschenker/uploads/2013/12/image100.png)
                    
                    This command generates a configuration file (it is a JavaScript file exporting a settings object) that defines 
                    
                      * which test framework to use (Jasmine in our case), 
                      * which files to monitor and use (this includes at least)
                      * angular.js
                      * angular-mocks.js (contains the definition for **module** and **inject**)
                      * our own code to test
                      * the files containing the tests or specifications
                    
                      * what browsers to use to run the test against (we’ll stick with Chrome)
                      * The port on which the server is listening
                      * whether to run the test automatically or manually when any of the monitored files changes
                    
                    This is my configuration file after manually tweaking it
                    
                    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb99.png" width="427" height="475" />](https://lostechies.com/content/gabrielschenker/uploads/2013/12/image101.png)
                    
                    Once we have configured Karma correctly we can run it (remember Karma is a test runner) by using the following command
                    
                    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb100.png" width="312" height="32" />](https://lostechies.com/content/gabrielschenker/uploads/2013/12/image102.png)
                    
                    Karma will now monitor all the files we have declared in the config file and run the tests if any of those files changes.
                    
                    When starting up Karma starts up an instance of the browser(s) we defined in the configuration file. The browser listens at the port also defined in the configuration file.
                    
                    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb101.png" width="564" height="246" />](https://lostechies.com/content/gabrielschenker/uploads/2013/12/image103.png)
                    
                    We do not need to observe the browser instance any further and can minimize (not close!) it, since it won’t show any test results. All test results will be shown in the console window where we started Karma. Since we do not yet have any files containing tests Karma will report an error that no matching files were found.
                    
                    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb102.png" width="611" height="195" />](https://lostechies.com/content/gabrielschenker/uploads/2013/12/image104.png)
                    
                    But we also know that we have correctly configured our system and we are now ready to write our first tests.
                    
                    # Writing our first test
                    
                    First we copy the two files **angular.js** and **angular-mocks.js** into our application directory. Then we create a new subfolder **js** and add a file **sample.js** to this new folder. Using e.g. [Sublime](http://www.sublimetext.com/3) we define a simple controller called **SampleCtrl** which does nothing else than initialize a property hello on the $scope of the controller.
                    
                    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb103.png" width="470" height="118" />](https://lostechies.com/content/gabrielschenker/uploads/2013/12/image105.png)
                    
                    This is the controller we want to write a test against. Create a new directory **test** and add a file **sampleSpec.js** to this directory. This file will contain our tests that we write using Jasmine. Please refer to the Jasmine [documentation](https://pivotal.github.io/jasmine/) for details about the syntax.
                    
                    We want to write tests against the **SampleCtrl** controller, thus we write
                    
                    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb104.png" width="616" height="140" />](https://lostechies.com/content/gabrielschenker/uploads/2013/12/image106.png)
                    
                    This roughly corresponds to a test class in C#. We provide a description of the scenario as the first parameter of the describe function and a function containing all our test **arrangements**, the test **act** and the test **assertions** (AAA = arrange, act, assert) as second parameter. 
                    
                    To arrange or prepare our tests we can call the method **beforeEach**. As first we need to make sure our application module is instantiated. Thus we write
                    
                    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb105.png" width="307" height="39" />](https://lostechies.com/content/gabrielschenker/uploads/2013/12/image107.png)
                    
                    Where we use the **module** function provided by **angular-mocks.js**.
                    
                    Next we need to configure our controller. In looking back at how the controller is coded we realize that it is a function that gets the $scope injected. To be able to test we need to replace the $scope with our own scope object which we can then later you to execute assertions against. Thus we write
                    
                    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb106.png" width="494" height="169" />](https://lostechies.com/content/gabrielschenker/uploads/2013/12/image108.png)
                    
                    Here we use the **inject** function defined in **angular-mocks.js** to provide us the $controller and the $rootScope service via injection. We then use the $rootScope as our scope and use the $controller service to get an instance of the **SampleCtrl** controller. The second parameter of the $controller service call is the parameters that get injected into the controller. In this case it is only one parameter – the $scope – which we provide here.
                    
                    Having configured everything we are now ready to write our first assertion. For this we can use the **it** function provided by Jasmine.
                    
                    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb107.png" width="404" height="67" />](https://lostechies.com/content/gabrielschenker/uploads/2013/12/image109.png)
                    
                    I have on purpose made a little mistake and I’m expecting “Hello John” without point instead of “Hello John.” with point. I want us to see how a broken test looks like in the output of Karma. The complete code of the specification should look like this
                    
                    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb108.png" width="601" height="389" />](https://lostechies.com/content/gabrielschenker/uploads/2013/12/image110.png)
                    
                    When we save this file and switch to Karma we should see the following output
                    
                    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb109.png" width="613" height="165" />](https://lostechies.com/content/gabrielschenker/uploads/2013/12/image111.png)
                    
                    The output clearly says that one test was executed and it failed since the expected value did not correspond to the actual value. Let’s correct this in the specification and save the file again. Karma will now output this
                    
                    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb110.png" width="609" height="43" />](https://lostechies.com/content/gabrielschenker/uploads/2013/12/image112.png)
                    
                    and we are happy and can go have a beer <img class="wlEmoticon wlEmoticon-smile" style="border-top-style: none;border-bottom-style: none;border-right-style: none;border-left-style: none" alt="Smile" src="https://lostechies.com/content/gabrielschenker/uploads/2013/12/wlEmoticon-smile.png" />
                    
                    Yes, I’m aware, this was not TDD what I demonstrated so far since I first wrote the code and then the test. But this post was mainly about getting our system setup correctly and ready to start TDD.
                    
                    # Summary
                    
                    In this post I have show how to setup our system to be able to write unit tests for an AngularJS application. We are using Jasmine as the test framework and Karma as the test runner. A crucial step in the whole setup is to author the correct configuration file for Karma.