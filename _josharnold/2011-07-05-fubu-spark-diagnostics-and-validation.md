---
id: 14
title: Fubu, Spark, Diagnostics, and Validation
date: 2011-07-05T15:28:15+00:00
author: Josh Arnold
layout: post
guid: http://lostechies.com/josharnold/?p=14
dsq_thread_id:
  - "350165527"
categories:
  - Uncategorized
---
I&#8217;m going to cross post this while I finish up my next few posts. If you&#8217;ve read it before, I apologize.

I’ve been promising a few posts for a while now so I thought I would combine them all into one simple, concrete example. So, today we’re going to get these three components to play nice together and see what we can come up with.

The structure of this post is for you to walk through this with me. I’ll warn you, I’m going to intentionally gloss over things. I’m going to bring in conventions that I use frequently and it’s up to you to dig into the code to understand them. My goal is to provide you with enough examples of Fubu In Action to give you an idea of how to do it yourself. So, having said all that…

**What you should do first:**

  * Fork my Scratchpad repository: <https://github.com/jmarnold/scratchpad>
  * Clone your fork locally
  * Checkout the ‘setup’ tag (git checkout setup)

&nbsp;

#### The Setup

You should be in the setup tag to begin with. This is bare bones. We’ve got just enough structure in here to get us up and running. If you run the application, you can go to: “/_fubu” and you’ll get the baseline diagnostics.

You’ll want to make sure you can get this far before reading any further.

#### Some Conventions

Now, let’s checkout the endpoint-conventions tag. I haven’t added much, but this is close to how I usually have my url conventions setup. Let’s look at the Endpoints namespace: <https://github.com/jmarnold/scratchpad/tree/endpoint-conventions/src/Scratchpad.Web/Endpoints>

EndpointMarker is just a static type I use to mark the root of the namespace. All “controllers” follow a basic rule: The route is made up of the namespaces with “Endpoint” stripped from the handler type (e.g., DashboardEndpoint => /dashboard) and method names respond to the appropriate HTTP verb (e.g., Get, Post).

We’ve also made DashboardEndpoint our default route so running the application should present you with a simple “Hello, World!”.

#### Basic Views

Now, checkout the spark-engine tag. Let’s walk through how we got Spark up and running:

  * Added a reference to FubuMVC.Spark
  * Added an explicit this.UseSpark() in our registry

That’s it. Now, of course we added the actual views themselves, but the above steps are all that it currently takes to get Spark bootstrapped*(I explain this later).

Regarding the views, it’s a requirement for Spark that the model in your viewdata statement is the full name of the type (e.g., Scratchpad.Web.Endpoints.DashboardViewModel). We currently do not make use of the “use namespace” elements for this resolution.

Running the application now should show you a list of Users.

#### Advanced Diagnostics

I’m throwing this in here just as a side note because I know there’s not much documentation out there yet. Let’s checkout the adv-diag tag. You’ll now see a diagnostics.zip file in the root of your repo.

If you’re in the git console, do three quick commands:

  * cmd
  * install-diagnostics.bat
  * ctrl+c

This will install the FubuMVC.Diagnostics package to your application. Now run the application and go to: “/\_diagnostics” (instead of “/\_fubu”).

> Update:
  
> The latest NuGet packages allow you to install FubuMVC.Diagnostics into your application and it will replace the existing /_fubu routes.

#### Validation

We’ve covered Fubu, Spark, and Diagnostics. Now let’s checkout the validation tag.

Let’s look at a few things with this, as they warrants some explanation.

  * We’re adding the ValidationConvention in our FubuRegistry and telling it that it’s applicable for our calls that a) have input and b) have input models with a name that contains “Input”
  * We’ve added the ScratchpadHtmlConventions that modify the editors for elements based on the required rule
  * We’ve decorated our FirstName and LastName properties with the Required attribute
  * We’ve added two new registries of importance: 1) ValidationBootstrapRegistry and 2) ScratchpadValidationRegistry. #2 Configure FubuValidation and #1 adapts it to StructureMap
  * We’ve added a custom failure policy (we’re matching all failures) to hijack the request and send back a JsonResponse with the validation errors – (note the hijacking used to work differently and now requires some more ceremony. I’m looking into this soon – that’s why you’re seeing the JsonActionSource)
  * There’s no validation code in CreateEndpoint.Post. We get it for free!

As always, if you have any questions please take them to our [mailing list](http://groups.google.com/group/fubumvc-devel?hl=en&pli=1). I’d more than happy to answer them for you and/or clarify anything you’ve found here.