---
wordpress_id: 800
title: AngularJS–Part 15, End to end tests and mocking
date: 2014-04-21T19:03:41+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/?p=800
dsq_thread_id:
  - "2629182044"
categories:
  - AngularJS
  - E2E testing
  - introduction
---
In my [previous post](https://lostechies.com/gabrielschenker/2014/04/18/angular-jspart-14-end-to-end-tests/) I introduced end-to-end testing (E2E testing) of Angular applications using Protractor. In this post I will show how we solve the problem when we need to write an E2E test that involves connecting to and getting some data from an external service provider that is either not under our control or that we explicitly do not want to include in our tests. One possibility is to fake or mock this external service provider. This is exactly the approach that we are taking in our team and that I am going to explain here in detail. Of course one can say that mocking a part of the system defeats the purpose of E2E testing. This is a valid point but we have to see and also acknowledge that it is not always possible to include all parts of a system in a comprehensive test, reasons are either of technical nature or of negative cost versus benefit ratio. Let’s just assume we are using a service from a credit card provider to check whether or not a credit card is valid and if so execute a transaction. In such a situation we should assume that the external service has been tested and is reliable. We can thus mock this service. When we talk about writing E2E tests then we really mean testing all the stuff that we (my teams) build and we thus control from end to end. 

You can find the list of all previous posts of this series about Angular JS [here](https://lostechies.com/gabrielschenker/2014/02/26/angular-js-blog-series-table-of-content/).

# Implementation Details

## Server side

In our application we use a service as a façade to access external RESTful resources. This service has the following (simplified) interface

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2014/04/image_thumb8.png" width="512" height="131" />](https://lostechies.com/content/gabrielschenker/uploads/2014/04/image8.png)

In our application we might use this service (that we get via [dependency injection](http://en.wikipedia.org/wiki/Dependency_injection)) as follows

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2014/04/image_thumb9.png" width="803" height="351" />](https://lostechies.com/content/gabrielschenker/uploads/2014/04/image9.png)

On line 10 and 11 we get the list of [ISO currency codes](http://en.wikipedia.org/wiki/ISO_4217) from the REST API of the external service provider [www.acme.com](http://www.acme.com). 

Now let’s assume that the above call would cost us 10 cents each time we call it. Thus it makes sense avoid that call during our automated test runs and replace it by a faked call which serves pre-canned data. Another scenario might be that we want to simulate the situation where this external service provider is down and/or the call times out. Another scenario we might want to test is when the external provider delivers data not in the expected format or quality. Given all this we have to come to the conclusion that it is really best if we fake this call.

In our application we are using [Autofac](https://code.google.com/p/autofac/) as our IoC container (the technique shown her can easily be applied to any other popular IoC container!). When we bootstrap our application (which I should rather call an **autonomous component** or AC [cf. [Udi Dahan](http://www.udidahan.com/)]) we register the façade service as a singleton

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2014/04/image_thumb10.png" width="617" height="89" />](https://lostechies.com/content/gabrielschenker/uploads/2014/04/image10.png)

The idea is to write a REST API through which we can reconfigure our IoC container and register a different implementation of the interface **IExternalDataProvider** with the container. We are using ASP.NET Web API to implement our REST API and thus such a service can be as simple as this

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2014/04/image_thumb11.png" width="696" height="463" />](https://lostechies.com/content/gabrielschenker/uploads/2014/04/image11.png)

On line 5 I get the existing IoC container instance via dependency injection (we use the Autofac adapter for Web API to enable DI in the controllers). On line 12 we create a new instance of the mocked service and stub it with the data provided to the Post method on line 13. Then on line 14 through 16 we create a new component builder, register the service mock with this builder and update the container with this registration. The new registration for **IExternalDataProvider** will replace the default one.

The parameter type **E2eSetup** is defined as

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2014/04/image_thumb12.png" width="474" height="155" />](https://lostechies.com/content/gabrielschenker/uploads/2014/04/image12.png)

Now, how does our service mock look like? Here is the (simplified) implementation

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2014/04/image_thumb13.png" width="795" height="439" />](https://lostechies.com/content/gabrielschenker/uploads/2014/04/image13.png)

On line 3 we define a dictionary as cache, where the **key** is the URI and the **value** is the pre-canned data for the specific URI. We use this cache on line 16 to serve our pre-canned data whenever the **Get** method is called with a certain URI. We can configure the cache by calling the **DefineStub** method and passing a value of type **E2eSetup**. This parameter contains the URI of the external service we want to call, the full name of the type used as return value of the **Get** method and the pre-canned data that we want this fake service to return for the given URI. We use this information on line 8 on line to construct the type of the return value and then on line 9 & 10 de-serialize the data from its representation as JSON formatted object into a .NET type. Finally on line 11 we cache the value using the URI as key.

## Client side

Now that we have finished our server side implementation we are ready to tackle the client side. 

Assume that we have the following view (index.html) in our client

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2014/04/image_thumb14.png" width="778" height="392" />](https://lostechies.com/content/gabrielschenker/uploads/2014/04/image14.png)

and this code in the app.js file

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2014/04/image_thumb15.png" width="848" height="162" />](https://lostechies.com/content/gabrielschenker/uploads/2014/04/image15.png)

Remember, the goal is to write E2E tests that instead of using the real service façade **IExternalDataProvider** used the mock that we just described above. How can we achieve that?

First we need an HTTP client in our test environment that we can use to pre-configure the backend. Specifically we want to do an HTTP POST request to the **E2eTestSetupController**. For this we install the [request js](https://github.com/mikeal/request) node module

<font face="Courier New">npm install request</font>

Now in our end to end test file we define the following helper method

&nbsp;[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2014/04/image_thumb16.png" width="715" height="535" />](https://lostechies.com/content/gabrielschenker/uploads/2014/04/image16.png)

In all our tests we can now use this helper function to easily call the backend and just pass the payload (body) for the **post** method. Note that on line 5 we assume that our web server that we use during the automated test run listens on port 9000. Also note that in order to work correctly we need to set the **content-type** to **application/json** (line 6) as well as set **json** to **true** (line 7) although to me this seems somewhat redundant… Any call to the above **post** method will be handled by our **E2eTestSetupController** introduced above.

We also introduce the **navigate** helper method which should be self-describing

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2014/04/image_thumb17.png" width="643" height="83" />](https://lostechies.com/content/gabrielschenker/uploads/2014/04/image17.png)

Finally we can write some real test. This test should simulate that the external service provider returns a list of ISO currency codes

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2014/04/image_thumb18.png" width="948" height="759" />](https://lostechies.com/content/gabrielschenker/uploads/2014/04/image18.png)

On line 5 we define the data that we want to post to the **E2eTestSetupController** and on line 17 we call the **post** method passing this data. The call to the post method is asynchronous and to make sure that the call is completed before the navigate function is called (line 19) we need to serialize the function calls. We can do this by using the infrastructure provided by protractor. Protractor gives us access to the control flow (line 15) which manages this for us. We can just add our asynchronous function calls to the flow using its **execute** method.

Finally on line 22ff we can write a test that verifies our expectations.

# Summary

In this post I have shown how we mock or fake external dependencies during our end-to-end tests. With this technique we are able to simulate any boundary condition for a system that is not under our direct control or that we purposely do not want to include in the end-to-end test.