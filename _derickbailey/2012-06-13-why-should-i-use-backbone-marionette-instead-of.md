---
wordpress_id: 948
title: Why Should I Use Backbone.Marionette Instead Of … ?
date: 2012-06-13T08:22:10+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=948
dsq_thread_id:
  - "724324343"
categories:
  - Analysis and Design
  - Backbone
  - JavaScript
  - Marionette
  - Messaging
  - Open Source
  - Philosophy of Software
  - Tools and Vendors
---
There&#8217;s [a question on StackOverflow](http://stackoverflow.com/questions/10847852/what-are-the-real-world-strengths-and-weaknesses-of-the-many-frameworks-based-on) from someone that wants to know what the real differences are between the various Backbone-based application frameworks. While I can&#8217;t really answer the question in terms of what the differences are, I can provide more insight in to why Marionette exists and what it provides that some of the other frameworks may not.

Once again, I&#8217;m re-posting my answer on my blog because I think the answer is worthwhile and I want to share it. 

## Backbone&#8217;s Many Application Frameworks

The question lists the following frameworks as possibilities that the person is looking in to:

  * [Marionette](https://github.com/derickbailey/backbone.marionette)
  * [Geppetto](https://github.com/ModelN/backbone.geppetto) (based on Marionette)
  * [Chaplin](https://github.com/chaplinjs/chaplin)
  * [Vertebrae](https://github.com/hautelook/vertebrae)
  * [LayoutManager](https://github.com/tbranyen/backbone.layoutmanager)
  * [Thorax](https://github.com/walmartlabs/thorax)

Most of (all of?) these frameworks solve the same problems, but they do it in slightly different ways with slightly different goals.

I think it&#8217;s fair to say that all of these projects would solve the problems in these categories:

  * Provide sensible set of defaults
  * Reduce boilerplate code
  * Provide application structure on top of the BackboneJS building blocks
  * Extract patterns that authors use in their apps

## Marionette&#8217;s Goals And Influences

Marionette, which I&#8217;ve been building since December of 2011, has a few very distinct goals and ideals in mind, as well:

  * Composite application architecture
  * Enterprise messaging pattern influence
  * Modularization options
  * Incremental use (no all-or-nothing requirement)
  * No server lock-in
  * Make it easy to change those defaults
  * Code as configuration / over configuration

I&#8217;m not saying none of the other frameworks have these same goals. But I think Marionette&#8217;s uniqueness comes from the combination of these goals

## Composite Application Architecture

I spent more than 5 years working in thick-client, distributed software systems using WinForms and C#. I built apps for desktop, laptop (smart-client), mobile devices and web applications, all sharing a core functional set and working with the same server back-end many times. In this time, I learned the value of modularization and very rapidly moved down a path of composite application design.

The basic idea is to &#8220;compose&#8221; your application&#8217;s runtime experience and process out of many smaller, individual pieces that don&#8217;t necessarily know about each other. They register themselves with the overall composite application system and then they communicate through various means of decoupled messages and calls.

I&#8217;ve written a little bit about this on my blog, introducing Marionette as a composite application architecture for Backbone:

  * <https://lostechies.com/derickbailey/2011/11/17/introduction-to-composite-javascript-apps/>
  * <https://lostechies.com/derickbailey/2011/12/12/composite-js-apps-regions-and-region-managers/>

## Message Queues / Patterns

The same large scale, distributed systems also took advantage of message queuing, enterprise integration patterns (messaging patterns), and service buses to handle the messages. This, more than anything else, had a tremendous influence on my approach to decoupled software development. I began to see single-process, in-memory WinForms applications from this perspective, and soon my server side and web application development took influence from this.

This has directly translated itself in to how I look at Backbone application design. I provide an event aggregator in Marionette, for both the high level Application object, and for each module that you create within the application.

I think about messages that I can send between my modules: command messages, event messages, and more. I also think about the server side communication as messages with these same patterns. Some of the patterns have made their way in to Marionette already, but some haven&#8217;t yet.

  * <https://lostechies.com/derickbailey/2011/07/19/references-routing-and-the-event-aggregator-coordinating-views-in-backbone-js>
  * <https://lostechies.com/derickbailey/2012/04/03/revisiting-the-backbone-event-aggregator-lessons-learned/>
  * <https://lostechies.com/derickbailey/2009/12/23/understanding-the-application-controller-through-object-messaging-patterns/> (WinForms code, but still applicable)

## Modularization

Modularization of code is tremendously important. Creating small, well encapsulated packages that have a singular focus with well defined entry and exit points is a must for any system of any significant size and complexity.

Marionette provides modularization directly through it&#8217;s \`module\` definitions. But I also recognize that some people like RequireJS and want to use that. So I provide both a standard build and a RequireJS compatible build.

{% gist 2924369 1.js %}

(No blog post available for this, yet)

## Incremental Use

This is one of the core philosophies that I bake in to every part of Marionette that I can: no &#8220;all-or-nothing&#8221; requirement for use of Marionette.

Backbone itself takes a very incremental and modular approach with all of it&#8217;s building block objects. You are free to choose which ones you want to use, when. I strongly believe in this principle and strive to make sure Marionette works the same way.

To that end, the majority of the pieces that I have built in to Marionette are built to stand alone, to work with the core pieces of Backbone, and to work together even better.

For example, nearly every Backbone application needs to dynamically show a Backbone view in a particular place on the screen. The apps also need to handle closing old views and cleaning up memory when a new one is put in place. This is where Marionette&#8217;s \`Region\` comes in to play. A region handles the boilerplate code of taking a view, calling render on it, and stuffing the result in to the DOM for you. Then will close that view and clean it up for you, provided your view has a &#8220;close&#8221; method on it.

{% gist 2924369 2.js %}

But you&#8217;re not required to use Marionette&#8217;s views in order to use a region. The only requirement is that you are extending from Backbone.View at some point in the object&#8217;s prototype chain. If you choose to provide a \`close\` method, a \`onShow\` method, or others, Marionette&#8217;s Region will call it for you at the right time.

  * <https://lostechies.com/derickbailey/2011/12/12/composite-js-apps-regions-and-region-managers/>
  * <https://lostechies.com/derickbailey/2011/09/15/zombies-run-managing-page-transitions-in-backbone-apps/>

## No Server Lock-in

I build Backbone / Marionette apps on top of a wide variety of server technologies:

  * ASP.NET MVC
  * Ruby on Rails
  * Ruby / Sinatra
  * NodeJS / ExpressJS
  * PHP / Slim
  * Java
  * Erlang
  * &#8230; and more

JavaScript is JavaScript, when it comes to running in a browser. Server side JavaScript is awesome, too, but it has zero affect or influence on how I write my browser based JavaScript.

Because of the diversity in projects that I built and back-end technologies that my clients use, I cannot and will not lock Marionette in to a single server side technology stack for any reason. I won&#8217;t provide a boilerplate project. I won&#8217;t provide a ruby gem or an npm package. I want people to understand that Marionette doesn&#8217;t require a specific back-end server. It&#8217;s browser based JavaScript, and the back-end doesn&#8217;t matter.

Of course, I fully support other people providing packages for their language and framework. I list those packages in the Wiki and hope that people continue to build more packages as they see a need. But that is community support, not direct support from Marionette.

  * <https://github.com/derickbailey/backbone.marionette/wiki/Available-packages>

## Easily Change The Defaults

In my effort to reduce boilerplate code and provide sensible defaults (which is an idea that I directly &#8220;borrowed&#8221; from Tim Branyen&#8217;s LayoutManager), I recognize the need for other developers to use slightly different implementations than I do.

I provide rendering based on inline \`<script>\` tags for templates, using Underscore.js templating by default. But you can replace this by changing the \`Renderer\` and/or \`TempalteCache\` objects in Marionette. These two objects provide the core of the rendering capabilities, and there are wiki pages that show how to change this out for specific templating engines and different ways of loading templates.

With v0.9 of Marionette, it gets even easier. For example, if you want to replace the use of inline template script blocks with pre-compiled templates, you only have to replace one method on the Renderer:

{% gist 2924369 3.js %}

and now the entire application will use pre-compiled templates that you attach to your view&#8217;s \`template\` attribute.

I even provide a Marionette.Async add-on with v0.9 that allows you to support asynchronously rendering views. I continuously strive to make it as easy as possible to replace the default behaviors in Marionette.

## Code As Configuration

I&#8217;m a fan of &#8220;convention over configuration&#8221; in certain contexts. It is a powerful way of getting things done, and Marionette provides a little bit of this &#8211; though not too much, honestly. Many other frameworks &#8211; especially LayoutManager &#8211; provide more convention over configuration than Marionette does.

The avoidance of &#8220;convention over configuration&#8221; is done with purpose and intent, in Marionette.

I&#8217;ve built enough JavaScript plugins, frameworks, add-ons and applications to know the pain of trying to get conventions to work in a meaningful and fast way. It can be done with speed, but usually at the cost of being able to change it. To that end, I take a &#8220;code as configuration&#8221; approach to Marionette. I don&#8217;t provide a lot of &#8220;configuration&#8221; APIs where you can provide an object literal with static values that change a swath of behaviors. Instead, I document the methods that each object has &#8211; both through annotated source code and through the actual API documentation &#8211; with the intent of telling you how to change Marionette to work the way you want.

By providing a clean and clear API for the Marionette objects, I create a situation where replacing the behavior of a specific object or Marionette as a whole is relatively simple and very flexible. I sacrifice the &#8220;simple&#8221; configuration API calls for the flexibility of providing your own code to make things work in the way that you want.

You won&#8217;t find a &#8220;configure&#8221; or &#8220;options&#8221; API in Marionette. But you will find a large number of methods that each serve a very specific purpose, with clean signatures, that make it easy to change how Marionette works.

## Which One Is Right For Me?

In truth, though, the answer to the question &#8220;why Marionette over …&#8221;, or &#8220;which one should I use?&#8221; or any other variation, is more about your own personal style and preferences. Each of these frameworks solves the same core set of problems but they all do it in slightly different ways with different goals. I would not encourage you to blindly pick one &#8211; not even Marionette. I encourage you to read the documentation, try to find and understand the philosophies and approaches of at least a few of these frameworks, and pick the one that you think is going to best suit your needs and your preferences.
