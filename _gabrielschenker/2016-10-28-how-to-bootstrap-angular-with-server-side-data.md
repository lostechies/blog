---
id: 2008
title: How To Bootstrap Angular with Server Side Data
date: 2016-10-28T16:31:09+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=2008
dsq_thread_id:
  - "5261552159"
categories:
  - AngularJS
  - How To
tags:
  - Angular
  - how-to
---
Today I needed to bootstrap our [Angular 1.x](https://angularjs.org/) Single Page Application (SPA) with some server side data. The data that I&#8217;m talking of is the set of **feature toggles** that are defined in our system. We need the value of those feature toggles to configure some of our Angular providers and services. This is the solution I came up with. Note, it has been heavily inspired by a sample found [here](https://jsfiddle.net/tuxmachine/t4d63vnw/).

The code to this post can be found [here](https://github.com/gnschenker/angular-custom-bootstrap)

If you like to read more posts of me where I talk about Angular please refer to [this index](https://lostechies.com/gabrielschenker/2014/02/26/angular-js-blog-series-table-of-content/)

# The Solution

The main idea is to not let Angular bootstrap itself auto-magically using the `ng-app` directive but to rather bootstrap the framework explicitly. This looks similar to this. First we define an element in our main page (e.g. index.html) with the `id` of the application, e.g. `app`. I would use the element that usually would contain the `ng-app` directive. Thus it would look along the line of this

    <div id='app'>
       ...
    </div>
    

And now we can add code like this to our main JavaScript file, e.g. `app.js`

    angular.element(document).ready(function () {
      var $injector = angular.injector(['ng','Flags']);
      var FeatureFlags = $injector.get('FeatureFlags');
      FeatureFlags.init().then(function () {
        var el = document.getElementById('app');
        angular.bootstrap(el, ['app']);
      });
    });
    

That is, as soon as the browser has loaded the DOM and is ready we execute the code above. First we get an Angular **injector** which contains all the modules that we need to be able to create the service that will load our server side data. In our case the service is called `FeatureFlags` and is implemented in an Angular module called `Flags`. We then use the `$injector` to retrieve/construct an instance of our service. Then we call the `init` function of the service which asynchronously loads the server data. Since the `init` method is asynchronous it returns a promise. We now define the success function of the promise which gets called when the data successfully has been loaded from the server. Inside this success function we identify the element with `id=='app'` in the DOM and use it to bootstrap angular. Note that we also declare in the bootstrap function that our main Angular module is `app`.

> It is important to notice that the `$injector` that we create in the snippet above is a **different instance** of the Angular injector than Angular itself will use once it is bootstrapped!

## The FeatureFlags Service

In a new file, let&#8217;s call it `flags.js` we add the following code

    angular.module('Flags',[])
        .factory('FeatureFlags', FeatureFlagsService);
    

This creates a new Angular module `Flags` with no external dependencies. We then add a factory called `FeatureFlags` to the module. The implementation of this factory is represented by the function `FeatureFlagsService`.

Now let&#8217;s turn to the implementation of the service. In this example we are simulating the server backend by using the `$timeout` service of Angular and not the `$http` service that we would typically use to make remote and asynchronous server calls. The `$timeout` service helps us to make everything asynchronous. Here is the skeleton of the service

    function FeatureFlagsService($q, $timeout) {
        var service = {
            timeoutService: $timeout,
            qService: $q
        };
        service.init = function(){
            return this.loadFeatureFlags();
        };
        service.getFeatureFlags = function(){
            return this.features = this.features || window.__otxp_featureFlags__;
        };
        service.getFeatureFlag = getFeatureFlag;
        service.loadFeatureFlags = loadFeatureFlags;
        return service;
    }
    

So, the `init` function uses the `loadFeatureFlags` function which returns a `promise` to load the feature flags from the server. Let&#8217;s look at the implementation of this beauty

    function loadFeatureFlags() {
        var features = [{
            "name": "sso",
            "active": 1
        },
        {
            "name": "abc",
            "active": 0
        }]
        return this.timeoutService(function(){
            // Avoid clash with other global properties 
            // by using a "fancy" name
            window.__otxp_featureFlags__ = features;
        }, 2000);
    };
    

First I&#8217;m defining some sample feature toggles (consisting each of a `name` and `active` property). Then I use the `$timeout` service to asynchronously return those features with a delay of 2000 ms and assigning them to a global variable on the `window` object. I have chosen a &#8220;fancy&#8221; name to avoid a clash with any other potential global variables.

In the real service we would use the `$http` service instead of the `$timeout` service like this

    var url = '[url to the server API]';
    $http.get(url).then(function(response){
        window.__otxp_featureFlags__ = response.data;
    });
    

Assuming that the server returns the feature flags as a JSON formatted object in the response body.

Finally the implementation of the `getFeatureFlag` function looks like this

    function getFeatureFlag(feature) {
        var result = this.getFeatureFlags().filter(function(x){ return x.name == feature; })[0];
        var featureIsOn = (result === undefined) ? false : result.active != 0;
        return featureIsOn;
    }
    

With this we have completely defined our service that is used to **asynchronously** load the server side data and make it available to us in the Angular application.

## The App Module

Now it is time to define the main Angular module. We called it `app`. Here is the skeleton of it. I have added this code to the file `app.js` where we also have the Angular bootstrap code

    angular.module('app', ['Flags'])
        .run(function ($rootScope, FeatureFlags) {
            $rootScope.features = FeatureFlags.getFeatureFlags();
            $rootScope.done = FeatureFlags.getFeatureFlags() ? 'Booted!' : 'Failed';
        })
        .provider('Auth', AuthProvider)
        .directive('ngLoading', LoadingDirective)    
        .controller('appCtrl', appCtrl)
    

Our `app` module is dependent on the `Flags` module where we have implemented the `FeatureFlags` service. In the `run` function of the module we use this service to retrieve the feature flags and assign them to the `features` property of the `$rootScope`.

We also add a provider `Auth`, a directive `ngLoad` and a controller `appCtrl` to the module. As we will see, we will need the feature flags in the definition of the `Auth` provider. Thus let&#8217;s start with the implementation of that provider

## The Auth Provider

The implementation of the `Auth` provider, as said above, depends of a feature flag. We have a legacy implementation if the feature flag is `OFF` and a new implementation if the flag is `ON`. I have organized the code for this in a file called `auth.js`.

    function AuthProvider(){
        return ({
            $get: function(FeatureFlags){
                var service;
                var isOn = FeatureFlags.getFeatureFlag('sso');
                if(isOn){
                    service = AuthFunc();
                } else{
                    service = LegacyAuthFunc();
                }
                return service;
            }
        });
    } 
    

The provider implements the `$get` function and in it uses the `FeatureFlags` service to evaluate whether or not the Single Sign On (sso) feature is enabled or not. Depending on the setting the provider returns a different implementation of the authentication service. In this simple demo app those implementations look like this

    function AuthFunc(){
        var service = {};
        service.getMessage = function(){
            return "I'm the Auth service";
        }
        return service;
    }
    
    function LegacyAuthFunc(){
        var service = {};
        service.getMessage = function(){
            return "I'm the *legacy* Auth service";
        }
        return service;
    }
    

Finally we come to the reason of all this effort. We want to inject the authentication provider into the controller `appCtrl` and of course expect to get the correct implementation there. Here is the code for my sample controller

    function appCtrl($scope, Auth){
        $scope.message = 'Hello: ' + Auth.getMessage();
    }
    

And as we can see when running the application in a browser we get the expected message back from the `Auth` service depending on the setting of the `sso` feature flag. The full sample can be found [here](https://github.com/gnschenker/angular-custom-bootstrap)

# Summary

In this post I have shown you how we can use custom bootstrapping for Angular to allow us to use server side data during the bootstrap of the application. I have tried many other options but this seems to be the only reliable and reasonable way I have come up with. Hope this helps. Stay tuned.

If you like to read more posts of me where I talk about Angular please refer to [this index](https://lostechies.com/gabrielschenker/2014/02/26/angular-js-blog-series-table-of-content/)