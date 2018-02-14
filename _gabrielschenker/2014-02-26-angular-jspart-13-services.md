---
wordpress_id: 709
title: Angular JS–Part 13, Services
date: 2014-02-26T22:42:09+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/?p=709
dsq_thread_id:
  - "2328164459"
categories:
  - Uncategorized
---
# Introduction

In this post I am discussing services and how they are constructed and tested. The list of earlier posts in this series about Angular JS can be found [here](http://lostechies.com/gabrielschenker/2014/02/26/angular-js-blog-series-table-of-content/).

# What is a service?

In Angular a service is a function or an object and is used to share data and/or behavior across controllers, directives, filters, other services etc. A service is treated as a singleton, that is there is only one instance of a specific service available during the whole lifetime of the Angular application. This is different from e.g. a controller of which many instances can be created.

# How to create a service

There are different ways how we can define a service in Angular JS.

## The service recipe

The easiest way is to use the **Service** recipe of an angular module.

<pre><span class="kwrd">var</span> app = angular.module(<span class="str">'app'</span>, []);
app.service(<span class="str">'some-service'</span>, <span class="kwrd">function</span>(){…});</pre>

<div class="csharpcode">
  <font size="3" face="Georgia">In the above snippet the second parameter of the service function is the service constructor function where we would implement the behavior of the service.</font>
</div>

Once defined this service can be used in any place, e.g. a controller through dependency injection

<pre>app.controller(<span class="str">'some-controller'</span>, [<span class="str">'$scope'</span>, <span class="str">'some-service'</span>], <span class="kwrd">function</span>(scope, service){
    …
}]);
</pre>

A service can of course also have external dependencies similar to a controller. We can inject those dependencies accordingly. Here our service uses the $location service of Angular JS

<pre><span class="kwrd">var</span> app = angular.module(<span class="str">'app'</span>, []);
app.service(<span class="str">'some-service'</span>, [<span class="str">'$location'</span>, <span class="kwrd">function</span>($location){
    …
}]);</pre>

Here is a simple sample of a service that can calculate the **area** and the **circumference** of a circle give the radius. This service is not dependent on any other service.

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb64.png" width="613" height="310" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image64.png)

On line 4 we define some data, in this case the value of PI. Then we have a function **area** defined on line 6 to 8 and a function **circumference** on line 10 to 12.

## Testing the service

When doing TDD we need of course to know how we can test a service. This is straight forward. First we need to setup the context

<pre>describe(<span class="str">'testing the circle-service'</span>, <span class="kwrd">function</span>(){
    …
});</pre>

Then we make sure that the Angular $injector is fully configured by calling the **module** function defined on **window**. **module** is a shortcut for **angular.mock.module** which in turn is defined in the **angular-mocks.js** library that we use during testing.

<font face="Courier New">&nbsp; beforeEach(module(&#8216;app&#8217;));</font>

The **module** function parses the whole Angular module we defined and registers all controllers, services, etc. It sets up also mocks for some of the Angular services like $httpBackend, $timeout, $browser etc.

Next we use the $injector to resolve the service

<pre><span class="kwrd">var</span> service;
beforeEach(inject(<span class="kwrd">function</span>($injector){
    service = $injector.get(<span class="str">'circle-service'</span>);
}));</pre>

Finally we can formulate our expectations, first for the value of PI

<pre><span class="kwrd">var</span> pi = 3.141528;
it(<span class="str">'should return the value pi'</span>, <span class="kwrd">function</span>(){
    expect(service.pi).toBe(pi);
});</pre>

and then for the two functions calculating **area** and **circumference**

<pre>it(<span class="str">'should calculate the circumference'</span>, <span class="kwrd">function</span>(){
    expect(service.circumference(0)).toBe(0);
    expect(service.circumference(1)).toBe(2*pi);
    expect(service.circumference(2)).toBe(4*pi);
});

it(<span class="str">'should calculate the area'</span>, <span class="kwrd">function</span>(){
    expect(service.area(0)).toBe(0);
    expect(service.area(1)).toBe(pi);
    expect(service.area(2)).toBe(4*pi);
    expect(service.area(3)).toBe(9*pi);
});</pre>

## The factory recipe

Instead of defining the service directly using the **Service** recipe of the Angular module we can also use the **Factory** recipe and define a factory function which will create the service on request.

This is slightly more complicated but offers also some more fine grain control. To do this we use the factory function of the Angular module

<pre>app.factory(<span class="str">'some-service'</span>, <span class="kwrd">function</span>(){…});</pre>

The purpose of the service factory function is to generate the single object, or function, that represents the service to the rest of the application. 

### Returning an object as a service

Assuming we want to return an object as our service we can do so

<pre>app.factory(<span class="str">'some-service'</span>, <span class="kwrd">function</span>(){
    <span class="kwrd">var</span> obj = {
        foo: <span class="kwrd">function</span>(…){},
        bar: <span class="kwrd">function</span>(…){},
        baz: <span class="str">'some value'</span>
    };
    <span class="kwrd">return</span> obj;
});</pre>

here we have defined an object with 3 properties of which two are functions and one is just data.

Let&#8217;s provide a concrete sample. I have an interest service that can calculate the accrued interest given an amount, a yearly interest rate and a period in years. The service can also calculate the monthly rate I have to pay given a loan amount, a yearly interest rate and a payoff duration in years.

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb65.png" width="918" height="422" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image65.png)

How can we test this service? Well when testing it really doesn&#8217;t make a difference whether the service is resolved via a factory function or directly. Thus the tests look very similar to what we saw earlier in this section

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb66.png" width="900" height="613" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image66.png)

Please note that on line 2 I use the explicit **angular.mock.module** notation instead of just **module** to show that they are indeed equivalent. The latter is just an alias or shortcut defined in the **angular-mocks.js** library.

### Returning a function as service

If on the other hand we want our service to be just a simple function we can do so like this

<pre>app.factory(<span class="str">'some-service'</span>, <span class="kwrd">function</span>(){
    <span class="kwrd">var</span> fn = <span class="kwrd">function</span>(…){ <span class="kwrd">return</span> …; }
    <span class="kwrd">return</span> fn;
});
</pre>

Here is a simple sample of such a service. The service just sums an array of numbers and returns this value

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image001" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/clip_image001_thumb.png" width="1001" height="185" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/clip_image001.png)

Once again testing this service is straight forward

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image001[5]" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/clip_image0015_thumb.png" width="888" height="311" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/clip_image0015.png)

The only difference regarding the other tests is that here I skipped the creation of a **beforeEach** because I really only have one single **it** function and thus I can do all the setup there.

## The provider recipe

The Angular [documentation](http://docs.angularjs.org/guide/providers) states the following

> … Each web application you build is composed of objects that collaborate to get stuff done. These objects need to be instantiated and wired together for the app to work. In Angular apps most of these objects are instantiated and wired together automatically by the injector service. …
> 
> The injector needs to know how to create these objects. You tell it by registering a &#8220;recipe&#8221; for creating your object with the injector. There are five recipe types. The most verbose, but also the most comprehensive one is a Provider recipe. The remaining four recipe types — Value, Factory, Service and Constant — are just syntactic sugar on top of a provider recipe. …

So far we have discussed the **Service** and **Factory** recipe. The **Value** and **Constant** recipe are discussed in detail [here](http://lostechies.com/gabrielschenker/2014/01/14/angularjspart-9-values-and-constants/). The last recipe which is the **Provider** recipe is fairly complex and rarely used. The Angular team recommends that we only use the Provider recipe if we need to expose an API for application-wide configuration that must be made (to the service) before the application starts. A possible scenario is a reusable service that is used in different modules (or applications/SPAs) and needs to vary slightly between those usages.

Let&#8217;s give a sample

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb67.png" width="936" height="448" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image67.png)

On line 2 we use the provider function to register our provider (recipe). On line 6 through 11 we define our service which in this case is an object having two functions sum and average. Since both of these functions need to sum up the array of numbers passed we have defined a helper function sumFn on line 3 to 5 which does exactly that. This function is then used on line 7 and line 10. We also need to implement a $get function which is done on line 13 to 15. Here we just return the service.

How can we test this service?

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/image_thumb68.png" width="1009" height="503" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/image68.png)

The tests look very similar to the tests we implemented for the services defined through the **Service** and the **Factory** recipe.

Now, a provider is only interesting if I need to be able to configure it. In our case I want to be able to configure how the result of the various service function calls are rounded. Thus I introduce a **precision** parameter and a function through which we can configure this value.

We can change our provider as follows

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image001[7]" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/clip_image0017_thumb.png" width="937" height="720" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/clip_image0017.png)

On line 3 to 6 we have introduced the configuration API with the function **setPrecision**. By default the precision is equal to 2. On line 15 and 20 we use the **toFixed** function to define the required precision of our return values.

Now we can use this configuration API during the configuration time of the Angular module to change the precision.

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image002" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/clip_image002_thumb.png" width="755" height="96" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/clip_image002.png)

To make all work we also need to change line 2 of our recipe where we define the provider function and use a named function instead of the anonymous function. In our sample we need to call the function **statisticsProvider** because that is what we are referencing on line 29 above. 

[<img style="border-top: 0px;border-right: 0px;border-bottom: 0px;padding-top: 0px;padding-left: 0px;border-left: 0px;padding-right: 0px" border="0" alt="clip_image003" src="http://lostechies.com/content/gabrielschenker/uploads/2014/02/clip_image003_thumb.png" width="810" height="66" />](http://lostechies.com/content/gabrielschenker/uploads/2014/02/clip_image003.png)

# Conclusion

Services are important elements of a typical Angular JS application. Services allow us to share data and behavior across other objects like controllers. There exist 5 recipes how a service instance can be created; in this post we have described the Service, Factory and Provider recipes. In the context of Angular services are singletons. It easy and straight forward to test services.