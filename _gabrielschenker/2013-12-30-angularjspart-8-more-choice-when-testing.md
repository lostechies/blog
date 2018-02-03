---
wordpress_id: 496
title: AngularJS–Part 8, More choice when testing
date: 2013-12-30T23:26:46+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/?p=496
dsq_thread_id:
  - "2083062997"
categories:
  - AngularJS
  - How To
  - introduction
  - Setup
  - TDD
---
# Introduction

This is a series of posts about [AngularJS](http://angularjs.org/) and our experiences with it while migrating the client of a complex enterprise application from Silverlight to HTML5/CSS/JavaScript using AngularJS as a framework. Since the migration is a very ambitious undertaken I want to try to chop the overall problem space in much smaller pieces that can be swallowed and digested much more easily by any member of my team. So far I have published the following posts in this series 

  * [AngularJS – Part 1](http://lostechies.com/gabrielschenker/2013/12/05/angularjspart-1/) 
      * [AngularJS – Part 1, Feedback](http://lostechies.com/gabrielschenker/2013/12/07/angularjspart-1-feedback/) 
          * [AngularJS – Part 2, the controller](http://lostechies.com/gabrielschenker/2013/12/09/angularjspart-2-the-controller/) 
              * [AngularJS – Part 3, Inheritance](http://lostechies.com/gabrielschenker/2013/12/10/angularjspart-3-inheritance/) 
                  * [AngularJS – Part 4, Accessing server side resources](http://lostechies.com/gabrielschenker/2013/12/12/angularjspart-4-accessing-server-side-resources/) 
                      * [AngularJS- Part 5, Pushing data to the server](http://lostechies.com/gabrielschenker/2013/12/17/angularjspart-5-pushing-data-to-the-server/) 
                          * [AngularJS – Part 6, Templates](http://lostechies.com/gabrielschenker/2013/12/28/angularjspart-6-templates/)
                          * [AngularJS – Part 7, Get ready to test](http://lostechies.com/gabrielschenker/2013/12/30/angularjspart-7-getting-ready-to-test/)</ul> 
                        # Another test runner
                        
                        While digging a bit deeper into the world of testing in and around Angular I was made aware of [testem](https://github.com/airportyh/testem), another awesome framework agnostic test runner. This test runner is extremely simple to setup and we are up and running in no time.
                        
                        I am assuming that you have installed [node.js](http://nodejs.org/download/) on your system (if not, what are you waiting for?). Open a console and run the following command to use the node package manager to install **testem**.
                        
                        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb111.png" width="318" height="42" />](http://lostechies.com/gabrielschenker/files/2013/12/image113.png)
                        
                        That’s all. Really! It will install **testem** on your system and make it available globally.
                        
                        # A first test
                        
                        Create an empty directory, e.g. **HelloWorld** and navigate to this directory
                        
                        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb112.png" width="212" height="124" />](http://lostechies.com/gabrielschenker/files/2013/12/image114.png)
                        
                        Now run **testem**
                        
                        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb113.png" width="244" height="39" />](http://lostechies.com/gabrielschenker/files/2013/12/image115.png)
                        
                        you will be presented by a console output similar to this
                        
                        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb114.png" width="591" height="346" />](http://lostechies.com/gabrielschenker/files/2013/12/image116.png)
                        
                        Now start your favorite browser(s) and point them to the URL shown in the console (here <http://localhost:7357>). Now the console changes and we’re getting the feedback that the browser(s) are connected. I this sample I have started Chrome and Firefox.
                        
                        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb115.png" width="591" height="346" />](http://lostechies.com/gabrielschenker/files/2013/12/image117.png)
                        
                        Everything is ready to go. As soon as there are any tests available **testem** will run them on both connected browsers. We can use right and left key in the console to switch between the output for the two browsers.
                        
                        Let’s write a very simple test using [Jasmine](http://pivotal.github.io/jasmine/). For this create a new file **testSpec.js** and add this code
                        
                        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb116.png" width="443" height="116" />](http://lostechies.com/gabrielschenker/files/2013/12/image118.png)
                        
                        In the above test we want to make sure that when calling a function **hello()** the return value is “Hello John”. The moment you save this file testem is triggered and runs the test. The output on my system looks like this
                        
                        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb117.png" width="607" height="266" />](http://lostechies.com/gabrielschenker/files/2013/12/image119.png)
                        
                        The test obviously has failed since we didn’t implement a function **hello** so far. The error clearly states this fact. Let’s implement the function **hello**. Add another file called **test.js** to the directory and add the following code to it
                        
                        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb118.png" width="270" height="79" />](http://lostechies.com/gabrielschenker/files/2013/12/image120.png)
                        
                        When you now save this file **testem** is again triggered and runs the test. This time the test succeeds.
                        
                        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb119.png" width="520" height="254" />](http://lostechies.com/gabrielschenker/files/2013/12/image121.png)
                        
                        # A unit test for Angular
                        
                        Now let’s write a unit test for Angular. For brevity will just copy the test from my [last post](http://lostechies.com/gabrielschenker/2013/12/30/angularjspart-7-getting-ready-to-test/). Add a new file **sampleSpec.js** to the directory and add the following code
                        
                        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb120.png" width="609" height="361" />](http://lostechies.com/gabrielschenker/files/2013/12/image122.png)
                        
                        With this code we want to test a simple Angular controller and verify that the controller initializes a property hello on its $scope with the value “Hello John.”. Once we save this file **testem** shows us the following error
                        
                        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb121.png" width="608" height="285" />](http://lostechies.com/gabrielschenker/files/2013/12/image123.png)
                        
                        Of course, we forgot to provide the **angular.js** and **angular-mocks.js** to the sample (and to testem). Thus let’s copy those two files into our **HelloWorld** directory. Once we have done so, **testem** still is not happy and reports this error
                        
                        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb122.png" width="609" height="301" />](http://lostechies.com/gabrielschenker/files/2013/12/image124.png)
                        
                        This error is somewhat similar to the previous one but the last line in the stack trace give us a hint that something is wrong with the **angular-mocks.js** file. It seems that testem picks the two angular files up in the wrong order. It should first load **angular.js** and only then **angular-mocks.js** since the latter depends on the former. Ok, what can we do? Searching the internet did not help much… But wait a second, there is an option to explicitly configure **testem** by defining a **testem.json** file in the working directory. Let’s try this and add the following configuration to this file
                        
                        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb123.png" width="280" height="200" />](http://lostechies.com/gabrielschenker/files/2013/12/image125.png)
                        
                        Quit the currently running instance of **testem** by pressing “q” in the console and restart it such as that it can pick up the just defined configuration. The test still fails, but this time not because of angular or angular-mocks because but because the controller is not yet defined. Let’s add a file **sample.js** to the working directory and add this code
                        
                        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb124.png" width="465" height="93" />](http://lostechies.com/gabrielschenker/files/2013/12/image126.png)
                        
                        When we now save the file the test will pass and **testem** will output this
                        
                        [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2013/12/image_thumb125.png" width="503" height="240" />](http://lostechies.com/gabrielschenker/files/2013/12/image127.png)
                        
                        # Conclusion
                        
                        In this post I have introduced [testem](https://github.com/airportyh/testem), another very powerful test runner besides [karma](http://karma-runner.github.io/0.10/index.html) for JavaScript tests. This runner is easy to install and straight forward to use. Now we have at least two ways how we can run our unit tests while developing our Angular SPA application, both of which are pretty much friction less.