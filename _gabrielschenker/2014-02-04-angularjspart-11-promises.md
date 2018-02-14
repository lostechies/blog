---
wordpress_id: 593
title: AngularJS–Part 11, Promises
date: 2014-02-04T22:24:02+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/?p=593
dsq_thread_id:
  - "2222760476"
categories:
  - AngularJS
  - asynchronous
  - introduction
---
# Introduction

This is a series of posts about [AngularJS](http://angularjs.org/) and our experiences with it while migrating the client of a complex enterprise application from Silverlight to HTML5/CSS/JavaScript using AngularJS as a framework. So far I have published the following posts 

  * [AngularJS – Part 1](http://lostechies.com/gabrielschenker/2013/12/05/angularjspart-1/) 
      * [AngularJS – Part 1, Feedback](http://lostechies.com/gabrielschenker/2013/12/07/angularjspart-1-feedback/) 
          * [AngularJS – Part 2, the controller](http://lostechies.com/gabrielschenker/2013/12/09/angularjspart-2-the-controller/) 
              * [AngularJS – Part 3, Inheritance](http://lostechies.com/gabrielschenker/2013/12/10/angularjspart-3-inheritance/) 
                  * [AngularJS – Part 4, Accessing server side resources](http://lostechies.com/gabrielschenker/2013/12/12/angularjspart-4-accessing-server-side-resources/) 
                      * [AngularJS – Part 5, Pushing data to the server](http://lostechies.com/gabrielschenker/2013/12/17/angularjspart-5-pushing-data-to-the-server/) 
                          * [AngularJS – Part 6, Templates](http://lostechies.com/gabrielschenker/2013/12/28/angularjspart-6-templates/) 
                              * [AngularJS – Part 7, Get ready to test](http://lostechies.com/gabrielschenker/2013/12/30/angularjspart-7-getting-ready-to-test/) 
                                  * [AngularJS – Part 8, More choice when testing](http://lostechies.com/gabrielschenker/2013/12/30/angularjspart-8-more-choice-when-testing/) 
                                      * [AngularJS – Part 9, value and constants](http://lostechies.com/gabrielschenker/2014/01/14/angularjspart-9-values-and-constants/)
                                      * [AngularJS – Part 10, Intermezzo](http://lostechies.com/gabrielschenker/2014/01/20/angluarjspart-10-intermezzo/)</ul> 
                                    The easiest way to write a program is when everything is sequential. We have one command or instruction executed after the other. But in most cases this is not the best way to code, specifically not in an application with a GUI. A user expects the application to remain responsive all the time, no matter what tasks are running. What this means is that the UI should not freeze, windows should be able to redraw themselves when e.g. moved or resized or the mouse pointer should react when we move the mouse, etc. To achieve this goal we structure our code in a way that it can run asynchronously or in a non-blocking way. When creating e.g. a native Windows application we can use multiple threads to achieve this goal. The main thread is used for all graphic operations whilst long running operations (that most often need no or only limited interaction with the UI) can run in so called worker or background threads. On our modern computers, tablets or phones with multi core processors several threads can run truly in parallel without interrupting each other.
                                    
                                    But here we are talking about JavaScript code running on the client in the context of a browser. In this scenario we only ever have one single thread available and thus we have to find other means of how to achieve asynchrony. 
                                    
                                    ## Callback functions
                                    
                                    The way how every JavaScript developer implements his/her first asynchronous code is by using callback functions. If you have ever used [jQuery](http://jquery.com/) Ajax calls you are certainly very familiar with this coding pattern
                                    
                                    ## Promise
                                    
                                    Using callback functions to achieve asynchrony in code becomes just way too complicated when you have to compose multiple asynchronous calls and make decisions depending upon the outcome of this composition. While handling the normal case is still somewhat feasible it starts to become very ugly when you have to provide rock solid exception handling.
                                    
                                    Comes the Promise to the rescue! According to [Promises/A+](http://promises-aplus.github.io/promises-spec/)
                                    
                                    > A _promise_ represents the eventual result of an asynchronous operation.
                                    
                                    <font>Ok, this is quite a mouth full. What does it mean in layman’s term? A promise is an object with a <strong>then</strong> method. The <strong>then</strong> method has two (optional) parameters of type function. The signature of the then method looks like this</font>
                                    
                                    [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb.png" width="343" height="35" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image.png)
                                    
                                    Both functions, the **onSuccess** and the **onFailure**, have one parameter. The **onSuccess** function is called whenever the asynchronous tasks ends successfully and the **onFailure** function is called if the tasks fails to execute. For each promise only one of the functions can ever be called. The task either succeeds or it fails; no other outcome is possible.
                                    
                                    # References
                                    
                                    There are some very good references available talking about JavaScript Promises in general or in the context of a specific library in particular.
                                    
                                      * [Promises/A proposal](http://wiki.commonjs.org/wiki/Promises/A) 
                                          * [Promises/A+](http://promises-aplus.github.io/promises-spec/). 
                                              * [Kristopher Kowal’s Q library](https://github.com/kriskowal/q)</ul> 
                                            to name just a few…
                                            
                                            # <font></font>Samples
                                            
                                            Now after all this theory let’s play with promises and create some samples that hopefully will make things clear. I have to admit that, although I have done a lot of asynchronous programming using all kinds of techniques it took me a while to get my head around promises. I think this is mostly due to the fact that there are hardly any good samples to find that introduce the concept in a didactically sound way. I truly hope that the following samples are doing a better job in this regard.
                                            
                                            In Angular we have the $q service that provide **deferred** and **promise** implementations. This $q service is heavily inspired by the [Q library](https://github.com/kriskowal/q) of Kris Kowal.
                                            
                                            Deferred represents a task that will finish in the future. We can get a new deferred object by calling the defer() function on the $q service.
                                            
                                            [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb1.png" width="257" height="32" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image1.png)&nbsp;
                                            
                                            Initially this task is in the status **pending**. Eventually the task completes successfully or it fails. In the former case the status of deferred will be **resolved** while in the latter case the status will be **rejected**. But who decides whether the task succeeds or fails, and how can this be achieved? Good question; the deferred object has two methods for this purpose. The first method **resolve(…)** is used to signal that the task has succeeded
                                            
                                            [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb2.png" width="245" height="37" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image2.png)
                                            
                                            Note that the method has one parameter. Whoever calls the method resolve can pass any type of information which shall be the result of the task. It can be a simple type like a string or a number or a complex object. Thus this is also valid
                                            
                                            [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb3.png" width="619" height="31" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image3.png)
                                            
                                            The second method reject(…) is used to signal that the task has failed. The reject method also takes one parameter, the reason of the failure. Again the parameter can be a simple type like a string or a complex type like an Error object.
                                            
                                            [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb4.png" width="246" height="37" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image4.png)
                                            
                                            or
                                            
                                            [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb5.png" width="567" height="38" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image5.png)
                                            
                                            The deferred object has a property promise which represents the promise of this task. With this promise we can register an on success and an on failure function. Both functions take a single parameter. The on success function gets the value that was provided by the caller of the resolve method while the on failure function gets the value (reason of failure) provided by the caller of the reject function
                                            
                                            [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb6.png" width="317" height="129" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image6.png)
                                            
                                            ## A simple promise
                                            
                                            Let’s make a working sample with what we have learned. Create a new Angular application with an index.html file containing the layout and an app.js file containing the logic. The content of the index.html should look like this
                                            
                                            [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb7.png" width="579" height="316" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image7.png)
                                            
                                            This is a simple view with a button bound to a **test**() method defined in the **SampleCtrl** controller and a checkbox bound to the property **fail** on the $scope of the controller. When the user clicks the button a deferred object should be created and either succeed or fail depending on the status of the checkbox. In both cases the result is shown in an alert box. Let’s see the code in app.js
                                            
                                            [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb8.png" width="527" height="390" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image8.png)
                                            
                                            On line 1 we create a new Angular app and on line 2 we define the **SampleCtrl** controller. In the controller we define the test function that is called when the user clicks the button on the view. On line 6 we create the deferred object. On line 8 we get hold of the promise object of the deferred. We then define on line 9 through 13 what shall happen if the promise either is resolved or rejected. Line 10 or 12 are not executed immediately since the deferred object is a task that will complete in the future.
                                            
                                            On line 15 through 18 we either reject the task or resolve the task depending whether or not the user has checked the checkbox on the view. If the checkbox is not checked the the alert with the text “Success: Cool” is displayed. If the checkbox is checked on the other hand the alert box with the test “Error: sorry” is displayed.
                                            
                                            Note although this sample is not an asynchronous sample it still shows the concept of promises.
                                            
                                            ## Chaining promises
                                            
                                            The return value of the then function of the promise is again a promise. This allows us to combine or chain asynchronous tasks. We can write
                                            
                                            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb9.png" width="180" height="72" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image9.png)
                                            
                                            With each then method we can register an on-success and an on-failure function. Let’s extend our sample. Add the following snippet to the view right after the first div containing the button and the checkbox
                                            
                                            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb10.png" width="515" height="104" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image10.png)
                                            
                                            Now we need to define the test2 function in the controller which will be executed whenever the user clicks on the button.
                                            
                                            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb11.png" width="612" height="450" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image11.png)
                                            
                                            On line 23 and 24 we define again a deferred object and reference its promise. On line 25 through 32 we register an on-success and an on-failure function. In both methods we set the value of the status2 field to an according value which is the result of a static text and the parameter passed to the function. On line 33 through 37 we have a chained then method where we register again an on-success and an on-failure function. On line 39 through 42 we either resolve or reject the promise depending on whether the user has checked the Fail checkbox or not.
                                            
                                            It is important to note that the first on-success function defined on line 25 gets the value ‘Hurray’ injected as defined when resolving the promise. On line 28 we define the return value of the promise which will be injected to the second on-success function defined on line 33. The same is true for the on-failure functions. If we omit to define a return value as on line 28 then the value of the _result_ parameter on line 33 would be _undefined_.
                                            
                                            Without running the application try to determine what message the alert boxes on line 34 and 36 will show.
                                            
                                            ## An asynchronous sample
                                            
                                            Up to now everything was synchronous and easy to follow. Now let’s introduce asynchrony into play. The easiest way to achieve this is to use the [setTimeout](http://www.w3schools.com/jsref/met_win_settimeout.asp) JavaScript function.
                                            
                                            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb12.png" width="339" height="90" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image12.png)
                                            
                                            Here the promise is resolved after a timeout of 1000 milliseconds. This simulates e.g. a server call to load some data which takes about 1 second. As usual we can then use the then method to register on-success and on-failure methods
                                            
                                            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb13.png" width="332" height="124" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image13.png)
                                            
                                            If we run this sample the alert box will show up after a delay of approximately 1 second.
                                            
                                            # Chaining multiple asynchronous (server-) calls
                                            
                                            Imagine having a user id in you application. Now you want to load the details of the staff associated with the user account. One way of doing this is to first load the user details which might contain the id of the associated staff. Once we have this id we can then load the details of this user. In this situation we have to chain two asynchronous tasks. Using callback function this would be a quite complicated undertaken resulting in ugly and difficult to understand code, specifically if we also have to implement a robust exception handling. Using promises on the other hand makes the implementation really simple. 
                                            
                                            Let’s first add another button to our view which when clicked triggers the loading of the data discussed above. This is the snippet we add to our view.
                                            
                                            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb14.png" width="533" height="65" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image14.png)
                                            
                                            and this is the definition of the **loadData** function triggered by the button click. We define it in our **TestCtrl** controller.
                                            
                                            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb15.png" width="479" height="161" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image15.png)
                                            
                                            Here we first load information for the currently logged in user (**loadUser** on line 64). The return value of this call contains amongst other values the id of the associated staff. Once we have that staff id we load the staff details (**loadStaff** on line 65). Finally we display the staff details as string in an alert box (line 67). In a real application we would probably use the Angular **$http** service or the **$resource** service to make a server call and get the data. In this sample we once again use the **setTimeout** function to simulate such an asynchronous server call and just return pre-canned data avoiding the need to setup a backend. The **loadUser** function then looks like this
                                            
                                            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb16.png" width="708" height="150" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image16.png)
                                            
                                            and the **loadStaff** like this
                                            
                                            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb17.png" width="872" height="145" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image17.png)
                                            
                                            The value that we pass to the **resolve** function on line 74 will be passed as parameter value to the **loadStaff** function on line 79.
                                            
                                            # Awaiting multiple promises running in parallel
                                            
                                            Assume having to call different backend services to collect data. The application can only continue once all the data has been successfully collected or if at least one of the server call fails. For maximum performance all tasks shall run in parallel. To await multiple tasks running in parallel the $q service offers us the all function. The all function in turn returns a promise. The promise is fulfilled if all parallel running tasks are fulfilled or the promise fails if at least one of the tasks fails. If we have three asynchronous tasks the code looks like this
                                            
                                            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb18.png" width="364" height="136" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image18.png)
                                            
                                            In this case **result** is an array of values that resolve from the individual promises.
                                            
                                            # Conclusion
                                            
                                            JavaScript promises are a very powerful concept that make handling of asynchronous tasks a breeze. Using promises multiple distinct asynchronous calls can easily be chained or executed in parallel and awaited. Implementing a robust exception handling is equally easy and straight forward. Using callback functions in asynchronous programming should be avoided in favor of using promises.