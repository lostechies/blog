---
wordpress_id: 327
title: AngularJS–Part 4, Accessing server side resources
date: 2013-12-12T22:19:17+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/?p=327
dsq_thread_id:
  - "2047243793"
categories:
  - AngularJS
  - introduction
---
# Introduction

This is a series of posts to describe our approach to slowly migrate a Silverlight based client of a huge and complex LOB&nbsp; to an HTML5/CSS3/JavaScript based client. These posts report on the lessons learnt and are meant to be used as a reference for our development teams. The first few post can be found here 

  * [AngularJS – Part 1](http://lostechies.com/gabrielschenker/2013/12/05/angularjspart-1/) 
      * [AngularJS – Part 1, Feedback](http://lostechies.com/gabrielschenker/2013/12/07/angularjspart-1-feedback/) 
          * [AngularJS – Part 2, the controller](http://lostechies.com/gabrielschenker/2013/12/09/angularjspart-2-the-controller/) 
              * [AngularJS – Part 3, Inheritance](http://lostechies.com/gabrielschenker/2013/12/10/angularjspart-3-inheritance/)</ul> 
            As mentioned above, this is about migrating a Silverlight based client of a LOB application and consequently we can assume that most if not all of the server side resources will be reused by the new client. How can we access all these resources in an easy and straight forward manner?
            
            # Background
            
            To communicate between our Silverlight client and the server we have been using a WCF service with custom binary serialization. For a developer this communication was completely transparent; a message is sent and an asynchronous response is obtained. All the “ugliness” of the communication was hidden behind a custom built framework. Although this kind of client server communication offered certain advantages it was a real pain when it came down to monitor and analyze the network traffic. As stated messages transported over the wire were not human readable since they were binary serialized. Well known tools like Fiddler or the now very powerful browser developer tools are near to useless in these scenarios.
            
            Also the whole communication infrastructure is way to heavy weight for what we are needing it. Sometimes it seems like killing a mosquito with a cannon. Our goal is to use a much leaner method of accessing resources. In this regard a REST API looks promising. It is not my intent to discuss the pros and cons of a REST API versus other methods in this series of posts. Let’s just assume that we did our homework and move on.
            
            AngularJS offers different built-in ways of communicating with a server. The service we want to discuss here is the so called $http service. It provides us an easy and elegant way to communicate via HTTP protocol with a web server. We get the $http service in a controller via dependency injection. 
            
            # A sample
            
            Let’s add a new HTML file to our sample and call it **step4.html**. We start with the usual setup which includes defining header and body and referencing the css and JavaScript files. We will also add a new JavaScript file called **step4.js** to our sample. Thus we have
            
            [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb37.png" width="509" height="365" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image39.png)
            
            I have added the **ng-app** directive to the <font face="Courier New">body</font> tag referencing an application called **step4App**. I have also added a <font face="Courier New">div</font> marking a region of the view which will be managed by the controller **FriendsCtrl**.
            
            The content of the JavaScript file looks like this
            
            [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb38.png" width="499" height="153" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image40.png)&nbsp;
            
            First we define our Angular app called **step4App**, then we define a **FriendsCtrl** controller. Currently the controller is just an empty hull but we will soon enrich it with functionality.
            
            Note that I’m using Visual Studio 2013 to edit my HTML and JavaScript files. The first line in the above code snippet shows the way how in Visual Studio we can have intellisense working for any JavaScript file. In this case we get intellisense for all Angular features. One could say that this statement corresponds somehow to the using statements in C#.
            
            Now lets add a button to the view that when clicked loads a list of friends from the server using the $http service. Thus add this to&nbsp; the div
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;margin: 0px 0px 24px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb39.png" width="603" height="53" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image41.png)
            
            and then define the function wired to the button click event in the controller
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb40.png" width="610" height="212" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image42.png)
            
            Ok, I agree, this is quite a bit of new stuff here. Let’s discuss each piece in turn. First of all we inject the **$scope** and the **$http** service into our **FriendsCtrl** controller. The **$scope** we have already discussed in previous posts and the **$http** service we will discuss in detail in this post. Suffice to say for now that we need the **$http** service to communicate with the server.
            
            On the **$scope** we define the **loadFriends** function. This function uses the **$http** service and its **get** helper function to access a resource located at the (relative) URL **api/friends** .
            
            > _In my case api/friends represents a resource provided by a_ [_ASP.NET Web API_](http://www.asp.net/web-api) _controller called **FriendsController.** Since this is a series about AngularJS I do not intend to go into details about how to create a_ [_RESTful_](http://en.wikipedia.org/wiki/Representational_state_transfer) _API using ASP.NET Web API_. 
            
            The **$http.get** function creates and HTTP GET request to the respective URL and accepts a response that is [JSON](http://en.wikipedia.org/wiki/Json) formatted. 
            
            Since all communication over the HTTP protocol is asynchronous the **$http.get** method is a non-blocking method call and returns a [promise](http://en.wikipedia.org/wiki/Futures_and_promises). _JavaScript promises are a very important concept and we will discuss promises in more detail in a future post._ 
            
            With this promise returned by the **$http.get** function we can register two callback functions that are executed once the call has either succeeded or failed. In our case I register this function for the success case
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb41.png" width="580" height="100" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image43.png)
            
            In the above function I just take the data that comes from the server and which is encoded as JSON and assign it to the **friends** variable on the **$scope**. We will see shortly what we can do with the **$scope.friends** model in the view.
            
            I also register this function for the case that the call fails (errors)
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb42.png" width="482" height="89" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image44.png)
            
            The above function just alerts the user that something terrible has happened.
            
            If I use Chrome and open the developers tools (Shift-Ctrl-J) I can analyze how the answer of my HTTP GET request looks like
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb43.png" width="583" height="181" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image45.png)
            
            As you can see, the data is indeed JSON encoded and we get an array of objects each having a **FirstName** and **LastName** property.
            
            # The ng-repeat directive
            
            Now that we can retrieve data from a (web) server we want to display it in our view. As we have seen above, our $http call returns an array of (friend) objects. Lets display this list as an unordered list. Angular offers us a very powerful directive called **ng-repeat** that we can use whenever we have to deal with list type data. Let’s use this new directive. Immediately after the button we add the following snippet
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb44.png" width="573" height="130" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image46.png)
            
            As I said, we display our friends model as an unordered list. We use the **ng-repeat** directive to create as many list items (<font face="Courier New"><li></font> tags) as we have items in the friends collection. The expression <font face="Courier New">“friend in friends”</font> can be compared with a **foreach** loop in C#. We use the mustache syntax described in my first post to display the full name of the friends. If we run the application the result looks like this
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb45.png" width="203" height="144" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image47.png)
            
            If we’d rather display the list of friends as a table then we can do so
            
            [<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2013/12/image_thumb46.png" width="506" height="272" />](http://lostechies.com/content/gabrielschenker/uploads/2013/12/image48.png)
            
            again we have used the **ng-repeat** directive to create as many table rows as there are items in the **friends** collection.
            
            # Success versus Error
            
            How do I know when the success function and when the error function is called? AngularJS calls the success function whenever the status code returned in the response header is in the range 200-299 other wise it calls the error function. There is one exception though, if the status code indicates a [redirection](http://en.wikipedia.org/wiki/URL_redirection) (3xx) then the HTTP request will (transparently) follow it instead of calling the error function. 
            
            # Summary
            
            In this post I have shown how we can use the $http service provided by AngularJS via dependency injection to retrieve data from a (web) server. The $http service makes it very easy to create asynchronous HTTP GET requests and subsequently handle the response. I also have introduced the ng-repeat directive which can be used to display list type data. This directive is one of the most powerful directives Angular offers.
            
            In the next post I will discuss how we can use the $http service to send data back to the server.