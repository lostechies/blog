---
wordpress_id: 7
title: Making your API behave like the big boys
date: 2015-04-15T20:34:29+00:00
author: Andrew Siemer
layout: post
wordpress_guid: http://lostechies.com/andrewsiemer/?p=7
dsq_thread_id:
  - "3758547921"
categories:
  - API
  - Scale
---
Everyone has written an API of some sort whether they know it or not. Many people might snap in a quick end point or two into their website that returns JSON or XML to support some simple front end validation or dynamic interactions. This is a loose API for the most part and if it solves the problem – great. Other folks might stand up a whole solution that is dedicated to supporting some disconnected clients like ios apps, android apps, or full blown SPA style javascript apps.

This second style of API is usually versioned separate from the consumers of it. And is most likely deploying at a different cadence from the client apps that are dependent on it. Also, when writing a rich API there are generally many concerns that one must take into account such as authentication and authorization, versioning of the contract between the client and the API, rate throttling, caching, etc. And if you are deploying API’s as different domains for a product suite, or as granular microservices, then you also need a way to uniformly present a consolidated API to the world. Analytics and reporting usually come into play as well.

For each of these concerns you could easily write some code (likely an extensive amount of it) to solve the problem. However, I find that letting my API worry about the business problem that it is trying to solve, and nothing else, makes iterating on my applications much less painful. For that reason I have turned to using infrastructure and 3rd party apps to solve many of these problems – **with little to no code!**

In this post we will take a look at proxys and gateways and some of the features that they expose to you. In future posts we will dig a little deeper into each of them and do more of an in depth comparison.

## Azure Austin Presentation



## Proxys and Gateways

A proxy is something that can act as an intermediary. It makes requests on behalf of something else which generally means in the API world that there is a running API behind the proxy. The proxy can’t do anything terribly fancy in terms of routing (in app routing), content transformation, mediation, or orchestration. It is essentially a forwarding device that can be used to do very simple but powerful things for your infrastructure and API. We will dig into that shortly.

A gateway on the other hand is an altogether different beast. Most gateways can do orchestration, DoS prevention, message based security, authorization, rate limiting, etc. They can be used to provide a richer feature set for your API without muddying up the code of your API. Essentially your API could just serve data and business processes.
  
There are also hardware routers and load balancers that can do some of these items for you. However, they are usually not entirely accessible to your app-dev team. Having some form of application routing closer to your run times provides greater control for some of the features we will discuss.

## What features you need drives the right solution

If you are a fan of doing just enough and no more then before you dig into any solution to augment you API you need to know what set of features you require. Once you know what you need you can consider some tools. Let’s take a look at some features you might consider for your api.

### Acceleration

We have all written some caching code in our application. You might cache the data layer to minimize trips to the database. You might cache the response from your query layer to minimize time building up the shapes to be returned. Or you might cache the rendered output to minimize the time processing the request entirely. But all of these types of caching strategies require a trip to your app server and at least a couple of hops in that process. This exact same story can be applied to the compression of the response.

But most of the API tools provide this type of feature set too. Both in a proxy and in a gateway you can usually have some form of caching and compression. This means that your app goes faster. And the amount of resources you need on hand to satisfy a request are less. A request will come to your proxy/gateway, and if there is a valid response in hand it will return that instead of passing that request on to your application server.

### Routing

My favorite use for simple routing is with regards to microservices. You might have a small API per discrete feature of your application. Product details. Pricing. Search. Etc. Each of these functionalities are expressed by way of API from a separate run time. With routing you can present the proxy/gateway end point as the canonical API that consumers use. And then configure internal routing to go to the correct API service.

### URL Rewriting

There are lots of rewriting scenarios that you may have with regards to your API. The simplest one might be where you make a simple name change to your end points. You have traffic coming in to ApiEndPoint. You want to rename the endpoint to ApiEndPointNew. The rename is not a breaking change other than the name. You could add an entry to rewrite the old name to the new name with no impact to your API consumers.

### Versioning

Any time you have a consumer of your API that is not directly under your control, meaning you don’t dictate when API versions are upgraded too, you will need a good versioning story. My preference is to have a run time per major.minor version of the API you are supporting. This allows you to not break down stream consumers while also exposing the latest and greatest new features of your API. Depending on the solution that you are using, this might be a routing implementation. But what it doesn’t have to be is custom code in your API. You could now use a versioned branch of code to support any active run times.

### Rate limiting

Rate limiting is also a feature you will need when supporting public consumption of your API. If the only consumer of your API your product, you likely won’t impact the customer experience by rate limiting. But in the case where a consumer has the ability to do something nefarious to your API, you will need the ability to define yourself. Or, if you have a paid model where you have different pricing brackets based on data consumption of number of calls, this sort of feature support will be important to you.

### Security

Security is a big concept. You may initially want to tackle this one yourself. However, it is more code to get wrong. And this is a segment of your application that you absolutely don’t want to get wrong. In the case of supporting microservices, many run times with fine grained functionality, you will need to handle implementing authentication and authorization in a centralized way that can be coordinated across services. Many gateways (not usually proxies) provide functionality to manage both authentication and authorization at the gateway. This again keeps your service simple.

### Monitoring

I am probably still a fan of monitoring my applications with an APM tool like NewRelic, logging like LogEntries, and metrics like Statsd/Graphite (or similar). But if you haven’t yet gone down that road, you will very much want to be able to visualize users in your system to see what they are up too. There are many gateway products that can provide some of this story to you.

### A/B Testing

A/B testing, the ability to see if a new change to a feature works better where “works better” can be more performant, better converting, etc., can be done in your code with many tools. And likely if you are embracing A/B concepts in your application, you will have A/B in the front end all the way back into your back end. However, if you want to do an A/B split across versions of software, doing it at this level can be a nice feature. You can do this with server affinity in most cases (ensuring that you delivery the same experience to a person once they are dropped into one of the available experiences).

### Blue/Green deployments

A blue/green deployment is the ability to swap traffic from environment 1 to environment 2. The more granular your runtimes are the easier this is. It means you have at least two prod environments. And it assumes an understanding of where a breaking change might occur. But assuming that you are doing a simple deployment of a new version of your API – you would take production traffic to environment 1. Deploy the new version to environment 2. Then test environment 2 is AWEsome. And then push traffic over to environment 2. This is of course the simple case. But to do this you need to have a routing component that can do the cut over for you.

### Server Affinity

Server affinity is usually brought up when discussion session management (which nobody does anymore ever…right?). But there are other cases where server affinity can be useful. Perhaps there are some items that you might cache for a specific scenario for a specific user. Once you route that user over to server 1, in cabinet 1, you may want to keep that user there. Simply because you have warmed that cabinet up for that users scenario. We did this sort of concept at a certain texas commerce place I worked at! This can’t be done by your code. It needs to be handled by something up stream far enough to make decisions before getting into the cabinet for your application.

## Tools

There are all sorts of tools that you can use for fronting an API. Again this is driven by the features that you need. Let’s quickly go through a few tools to see what sorts of features they offer.

### Nginx, HAProxy, and httpd

Nginx, HAProxy, and httpd are the more popular open source options for solving some of our API woes. But how do we pick which one to build our applications behind? Before we get into it too much let’s look at a quick feature list.

[<img class="alignnone size-full wp-image-12" title="haproxy-nginx-httpd" src="http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/haproxy-nginx-httpd.png" alt="" width="555" height="660" srcset="http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/haproxy-nginx-httpd.png 555w, http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/haproxy-nginx-httpd-252x300.png 252w" sizes="(max-width: 555px) 100vw, 555px" />](http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/haproxy-nginx-httpd.png)

Collectively they look like there is quite a bit of crossover between. So how on earth do we figure out which is the winner in this space? Google Trends usually has close to the right answer:

[<img class="alignnone size-full wp-image-11" title="google-trends" src="http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/google-trends.png" alt="" width="865" height="511" srcset="http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/google-trends.png 865w, http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/google-trends-300x177.png 300w, http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/google-trends-768x454.png 768w" sizes="(max-width: 767px) 89vw, (max-width: 1000px) 54vw, (max-width: 1071px) 543px, 580px" />](http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/google-trends.png)

This tells me that there is a lot more activity lately on nginx. Let’s take a look at the activity in the code base.

[<img class="alignnone size-full wp-image-15" title="nginx-source" src="http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/nginx-source.png" alt="" width="810" height="661" srcset="http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/nginx-source.png 810w, http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/nginx-source-300x245.png 300w, http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/nginx-source-768x627.png 768w" sizes="(max-width: 767px) 89vw, (max-width: 1000px) 54vw, (max-width: 1071px) 543px, 580px" />](http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/nginx-source.png)

Nginx looks to be a pretty active solution. How about HAProxy?

[<img class="alignnone size-full wp-image-13" title="haproxy-source" src="http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/haproxy-source.png" alt="" width="812" height="839" srcset="http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/haproxy-source.png 812w, http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/haproxy-source-290x300.png 290w, http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/haproxy-source-768x794.png 768w" sizes="(max-width: 767px) 89vw, (max-width: 1000px) 54vw, (max-width: 1071px) 543px, 580px" />](http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/haproxy-source.png)

Not quite as active but I wouldn’t quite call it old. And httpd?

[<img class="alignnone size-full wp-image-14" title="httpd-source" src="http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/httpd-source.png" alt="" width="819" height="918" srcset="http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/httpd-source.png 819w, http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/httpd-source-268x300.png 268w, http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/httpd-source-768x861.png 768w" sizes="(max-width: 767px) 89vw, (max-width: 1000px) 54vw, (max-width: 1071px) 543px, 580px" />](http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/httpd-source.png)

That’s not too bad actually!

I would suggest that nginx is the most popular of all these tools. But since the code bases are all fairly active you should be able to take a safe dependency on all of them. However, note that there are some features that are clearly lacking here or there. If you don’t function well in little black text based windows you might require an admin interface.

### Application Request Routing

Application Request Routing, also known as ARR, is a snap in for Microsoft IIS. If you are a windows guy and love working in windows IIS then this is likely the option for you. This nifty little tool is more of a feature rich gateway than it is a proxy. You can inspect connections, rewrite the requests, do some routing. Lot’s of options. And I know that this tool can scale to take “web scale”.

Given that the management of this tool is very UI centric though, managing it in an distributed fluid environment can be a bit more difficult. And if you are running multiple nodes to load balance all your traffic you should be aware that the deploy story is to take down a node, apply some text changes to the configuration, add the node back into rotation, etc. Unless you can justify having a cluster to support an A/B style deployment.

[<img class="alignnone size-full wp-image-8" title="arr-1" src="http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/arr-1.png" alt="" width="193" height="283" />](http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/arr-1.png)

[<img class="alignnone size-full wp-image-9" title="arr-2" src="http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/arr-2.png" alt="" width="557" height="420" srcset="http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/arr-2.png 557w, http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/arr-2-300x226.png 300w" sizes="(max-width: 557px) 100vw, 557px" />](http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/arr-2.png)

[<img class="alignnone size-full wp-image-10" title="arr-3" src="http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/arr-3.png" alt="" width="575" height="146" srcset="http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/arr-3.png 575w, http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/arr-3-300x76.png 300w" sizes="(max-width: 575px) 100vw, 575px" />](http://clayvessel.org/clayvessel/wp-content/uploads/2015/04/arr-3.png)

### Azure API Management

API Management is the solution that is readily available in the Azure space. This is a platform as a service that exposes a managed gateway with all of the cool bells and whistles we have talked about before. But this tool also provides you so much more (it truly is a rich gateway).

It pretty much allows you to “expose” azure-like features for your API from a management point of view. Everything has a clear interface to manage all aspects of the API’s. You could plug in an old XML returning API end point behind the API Management tool. Then you can rewrite the querystring parameters to something that looks more REST like. And you can turn the XML returned data into JSON.

You can see more about getting up and running with API Management quickly here on Azure Friday: Azure API Management [101](http://channel9.msdn.com/Shows/Azure-Friday/Azure-API-Management-101-with-Josh-Twist?wt.mc_id=player), [102](http://channel9.msdn.com/Shows/Azure-Friday/Azure-API-Management-102-with-Josh-Twist?wt.mc_id=player), [103](http://channel9.msdn.com/Shows/Azure-Friday/Azure-API-Management-103-with-Josh-Twist?wt.mc_id=player) with Josh Twist

&nbsp;