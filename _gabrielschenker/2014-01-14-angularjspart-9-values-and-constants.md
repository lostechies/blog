---
wordpress_id: 511
title: AngularJS–Part 9, Values and constants
date: 2014-01-14T21:28:31+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/?p=511
dsq_thread_id:
  - "2123648711"
categories:
  - AngularJS
  - introduction
---
# Introduction

This is a series of posts about [AngularJS](http://angularjs.org/) and our experiences with it while migrating the client of a complex enterprise application from Silverlight to HTML5/CSS/JavaScript using AngularJS as a framework. Since the migration is a very ambitious undertaken I want to try to chop the overall problem space in much smaller pieces that can be swallowed and digested much more easily by any member of my team. So far I have published the following posts in this series 

  * [AngularJS – Part 1](http://lostechies.com/gabrielschenker/2013/12/05/angularjspart-1/) 
      * [AngularJS – Part 1, Feedback](http://lostechies.com/gabrielschenker/2013/12/07/angularjspart-1-feedback/) 
          * [AngularJS – Part 2, the controller](http://lostechies.com/gabrielschenker/2013/12/09/angularjspart-2-the-controller/) 
              * [AngularJS – Part 3, Inheritance](http://lostechies.com/gabrielschenker/2013/12/10/angularjspart-3-inheritance/) 
                  * [AngularJS – Part 4, Accessing server side resources](http://lostechies.com/gabrielschenker/2013/12/12/angularjspart-4-accessing-server-side-resources/) 
                      * [AngularJS – Part 5, Pushing data to the server](http://lostechies.com/gabrielschenker/2013/12/17/angularjspart-5-pushing-data-to-the-server/) 
                          * [AngularJS – Part 6, Templates](http://lostechies.com/gabrielschenker/2013/12/28/angularjspart-6-templates/) 
                              * [AngularJS – Part 7, Get ready to test](http://lostechies.com/gabrielschenker/2013/12/30/angularjspart-7-getting-ready-to-test/)
                              * [AngularJS – Part 8, More choice when testing](http://lostechies.com/gabrielschenker/2013/12/30/angularjspart-8-more-choice-when-testing/)</ul> 
                            Sometimes we need some data that is globally available but at the same time we do not want to pollute the global (window) namespace with the definition for this data. Angular provides us the value and constant services which can do exactly this. Values and constants declared in this way can be injected into any controller or service like any other dependency (e.g. $scope, $http, etc.).
                            
                            # Values
                            
                            In our application we frequently need access to different properties of the currently logged in user. This could be things like the full name of the user, it’s role and so on. Typically we would load this data after the user has successfully logged into the system and keep this data around as long as the user remains logged in.
                            
                            We can define any string, number, date-time, array or object as a value. We can even register a function as a value. To e.g. define a string value as a value service we use this code
                            
                            [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2014/01/image_thumb.png" width="488" height="76" />](http://lostechies.com/gabrielschenker/files/2014/01/image.png)
                            
                            On line 1 I define my Angular application (module). On line 3 I register a value **appTitle** with the value “My Angular Application”. If we now want to use this value say in a controller **TestCtrl** we can do so
                            
                            [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2014/01/image_thumb1.png" width="473" height="68" />](http://lostechies.com/gabrielschenker/files/2014/01/image1.png)
                            
                            Angular interferes which service to inject by looking at the name of the parameter. Thus our function parameter has to be named the same way as the registered value.
                            
                            _We will discuss dependency injection (DI) and how it is realized in Angular in a future post._
                            
                            As mentioned above, we can also e.g. register an object as value service.
                            
                            [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2014/01/image_thumb2.png" width="405" height="125" />](http://lostechies.com/gabrielschenker/files/2014/01/image2.png)
                            
                            The above code defines and initializes a value service called **user** and assigns it an object with some default values. We can now load the true values e.g. after a successful login of the user. I just quickly put together some pseudo code for this scenario (do not use this in production <img class="wlEmoticon wlEmoticon-winkingsmile" style="border-top-style: none;border-bottom-style: none;border-right-style: none;border-left-style: none" alt="Winking smile" src="http://lostechies.com/gabrielschenker/files/2014/01/wlEmoticon-winkingsmile.png" />)
                            
                            [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2014/01/image_thumb3.png" width="587" height="317" />](http://lostechies.com/gabrielschenker/files/2014/01/image3.png)
                            
                            The above code is assuming that the user entered a **user name** and a **password**, selected the **local** and the **connection** (in our application a user can connect to different sites which we distinguish via unique connection names). The user then clicks on a login button which triggers the execution of the above **login** function. The data the user has entered is posted to the backend and assuming the user can be authenticated the server will respond with a success status and send back the user data.
                            
                            **Note:** Make sure that you never overwrite the value service/object as a whole otherwise your assignment is lost. Always reassign the property values of the value object. The following assignment is wrong and does not lead to the expected behavior
                            
                            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2014/01/image_thumb4.png" width="188" height="36" />](http://lostechies.com/gabrielschenker/files/2014/01/image4.png)
                            
                            even if the layout of the response matches the user value object exactly. We have to do a mapping property by property, i.e.
                            
                            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2014/01/image_thumb5.png" width="368" height="75" />](http://lostechies.com/gabrielschenker/files/2014/01/image5.png)
                            
                            # Constants
                            
                            The difference between a value and a constant service is that the former can only be injected (and thus be used) in a **service** or a **controller** while the latter can also be injected into a module configuration function.. (I will discuss the **module configuration function** in a future post).
                            
                            # Summary
                            
                            Angular value and constant services are an ideal way to provide application wide access to shared data without having to pollute the global namespace. They can be injected similar to any other service into our controllers and services. The only real difference between a value and a constant is that the latter can be injected into&nbsp; a module configuration function while the former cannot.