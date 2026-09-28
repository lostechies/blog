---
wordpress_id: 877
title: Creating an Angular application end-2-end – Part 1
date: 2015-01-05T07:58:29+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: http://lostechies.com/gabrielschenker/?p=877
dsq_thread_id:
  - "3392053490"
categories:
  - AngularJS
  - ASP.NET vNext
  - REST
  - Ubuntu
---
# Introduction

In this post series I want to demonstrate how to create a full blown application end-to-end which uses [Angular JS](https://angularjs.org/) on the client, [ASP.NET vNext](http://www.asp.net/vnext) and/or [Node JS](http://nodejs.org/) on the server. Architectural patterns that I am going to use are command query responsibility segregation ([CQRS](http://martinfowler.com/bliki/CQRS.html)), event sourcing ([ES](http://martinfowler.com/eaaDev/EventSourcing.html)) and (some light) domain driven design ([DDD](http://en.wikipedia.org/wiki/Domain-driven_design)). As a write store we will use [GetEventStore](http://geteventstore.com/). For our read models we use [MongoDB](http://www.mongodb.org/) and [ElasticSearch](http://www.elasticsearch.org/).

I will develop the application on Linux [Ubuntu](http://www.ubuntu.com/) 14.10 and also show that it runs without modifications on Windows 8.1 or Windows Server 2012.

# Installing the Prerequisites

Make sure you have ready my post about creating and configuring a Ubuntu VM on Hyper-V

  * [Creating an Ubuntu developer VM on Hyper-V](https://lostechies.com/gabrielschenker/2014/12/29/creating-an-ubuntu-developer-vm-on-hyper-v/)&nbsp; 
      * [Creating an Ubuntu developer VM on Hyper-V – Part 2](https://lostechies.com/gabrielschenker/2014/12/30/creating-an-ubuntu-developer-vm-on-hyper-v-part-2/) 
          * [Creating an Ubuntu developer VM on Hyper-V – Part 3](https://lostechies.com/gabrielschenker/2014/12/31/creating-an-ubuntu-developer-vm-on-hyper-v-part-3/) 
              * [Creating an Ubuntu developer VM on Hyper-V – Part 4](https://lostechies.com/gabrielschenker/2014/12/31/creating-an-ubuntu-developer-vm-on-hyper-v-part-4/) 
                If you are on a Mac the procedure should be very similar as described above except of course that you do not have to create a VM 🙂
                
                # Creating a server using ASP.NET vNext
                
                ## Installing Yeoman
                
                Yeoman is very helpful to jumpstart a new project. We can install it globally
                
                <font face="courier new">sudo npm install yo -g</font>
                
                Since we are going to develop our first version of the backend using ASP.NET vNext we also want to install the asp.net generator for Yeoman
                
                <font face="courier ">sudo npm install generator-aspnet -g</font>
                
                ## Creating and initializing a project folder
                
                Create a new project folder and navigate to it. Let’s call this folder **recipes**. In my case I create it in my ~/dev folder
                
                {% gist 9e7477f06d289ae8bb27 %}
                
                Let’s initialize a (local) git repository for this project
                
                <font face="courier new">git init</font>
                
                and create a **.gitignore** file containing the following entries (we might add other entries as we need them)
                
                {% gist 824f8bd7ae843da888f9 %}
                
                Next we init npm and bower
                
                <font face="courier new">npm init</font>
                
                <font face="courier new">bower init</font>
                
                ## Scaffolding the server side code
                
                Now we use Yeoman to generate an MVC type of application in a subfolder **server** of our project folder
                
                <font face="courier new">yo aspnet</font>
                
                when asked for the type of application select **MVC Application**. When asked for the name of the application type **server**. Yeoman will create a subfolder server in our recipes folder. Navigate to this folder and restore the nuget packages used by the project 
                
                <font face="courier new">cd server</font>
                
                <font face="courier new">kpm restore</font>
                
                and finally try to build the project
                
                <font face="courier new">kpm build</font>
                
                if that works we can now start kestrel (the development web server)
                
                <font face="courier new">k kestrel</font>
                
                and use e.g. Chrome to navigate to <http://localhost:5004> to test our sample application
                
                [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;border-top-width: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2015/01/image_thumb.png" width="759" height="556" />](https://lostechies.com/content/gabrielschenker/uploads/2015/01/image.png) 
                
                To stop kestrel simply press ENTER (and then CTRL-C) in the terminal where you started it.
                
                ## Defining a RESTful API
                
                All access to from the web client to the backend should be via a RESTful interface. 
                
                ### The read side
                
                Since we are dealing with recipes in our sample application let’s define a REST API which allows us to either retrieve a list of recipes or a single recipe. First we define 2 data transfer objects (DTOs) **NameId** and **RecipeDto** in the Models folder
                
                {% gist 1156b736827a7f088f7a %}
                
                and
                
                {% gist b02d6468797630c5374b %}
                
                In the controllers folder we add a **RecipesController** to our MVC project containing the following code
                
                {% gist f69d7d8baca141c02d99 %}<font face="courier new"></font>
                
                The two overloads of the Get methods just return some pre-canned recipes.
                
                Save the files and compile. Then we navigate to the URI <http://localhost:5004/api/recipes> and <http://localhost:5004/api/recipes/1> respectively and for the former should see something like this
                
                [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;border-top-width: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2015/01/image_thumb1.png" width="471" height="367" />](https://lostechies.com/content/gabrielschenker/uploads/2015/01/image1.png) 
                
                Ok, apparently the reading part works fine. Now let’s tackle the writing part. 
                
                ### The write side
                
                Since in this sample we are using CQRS and ES we will be sending commands from the client to the backend which will never contain the whole state of entities but rather the deltas of state change. We will be using the HTTP POST exclusively to send commands. We will also use routing to differentiate between different commands targeting the same type of object – here a recipe. That is if we have two commands “create a new draft recipe” and “submit recipe for review” then we will correspondingly define the two URIs 
                
                api/recipes/**create** and
                
                api/recipes/**submit**
                
                to which we post the respective commands. 
                
                Let’s implement the method for the create command. First we define the **CreateRecipeCommand** class in the Models folder
                
                {% gist ecf9a3ad0b4fb148ac8c %}
                
                The least amount of information we need to provide to create a new recipe is the name of the new recipe, the category to which we want to associate the recipe and the unique user name of the person wanting to create this new draft recipe.
                
                Then we add the following method to the RecipesController class
                
                {% gist 591b5eccafac3f224a25 %}
                
                and we can then test it by e.g. using the Postman plug-in for Chrome
                
                [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;border-top-width: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2015/01/image_thumb2.png" width="738" height="469" />](https://lostechies.com/content/gabrielschenker/uploads/2015/01/image2.png) 
                
                and in the console we should also get a feedback that the method has indeed been called
                
                [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;border-top-width: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2015/01/image_thumb3.png" width="469" height="82" />](https://lostechies.com/content/gabrielschenker/uploads/2015/01/image3.png) 
                
                ## The domain
                
                Now that we have successfully created and tested a read and write API we can start to implement the business logic. Here we are going to use concepts of domain driven design (DDD, see e.g. the [blue book](http://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215)), namely aggregates, application services, repositories and factories. We do not want to implement any type of domain related logic in the API controller. The API controller’s sole goal is to route external web requests to the domain.
                
                First we create an application service which is providing the infrastructure for an aggregate. An aggregate is very self centric and should be unaware of the specifics of the infrastructure (i.e. from where it comes and where it is persisted to just name two concerns). Thus we create an application service which is responsible for all the things the aggregate shouldn’t care about.
                
                For convenience our application service has a **When** method for each command it is supposed to handle. Thus we will have a multitude of When methods on this service, each one with a single parameter. We also need to make sure that we do not use the DTOs that are exposed to the outside world (e.g. the CreateRecipeCommand, etc.) in the domain. We want to stay as much decoupled as possible. Thus we first define a DTO that we will use internally
                
                {% gist f8d3cfbdbe5af4477402 %}
                
                now we define a helper class with an extension method to map the external DTO to the internal one
                
                {% gist f4c666ca19cbfdc3b7d9 %}
                
                We have now what we need to define the Recipe application service
                
                {% gist d23a51ca7610d5f635b2 %}
                
                Now, the application service will get a new instance of a Recipe aggregate from somewhere. For this we will use a repository represented by the interface IRepository that will be injected into the application service. The application service also needs to create a new unique id for the new aggregate. For this we use another service represented by the interface IUniqueKeyGenerator which will also be injected into the service. The code then looks like this
                
                {% gist d68c1a233b9e5fb52735 %}
                
                We have of course not yet defined the interfaces IRepository, IUniqueKeyGenerator, IAggregate and also we have not yet defined the recipe aggregate. Here they are
                
                {% gist b6896635d9912c32375f %}
                
                {% gist 50974ca1ef425b261a3d %}
                
                {% gist af62fa8b4299b8b334f5 %}
                
                {% gist 644f610a331fb4b08c29 %}
                
                Ok, now we can actually use this service in the RecipeController. Note that we also inject the RecipeApplicationService into the controller.
                
                {% gist 637e6d2ba8a29f1fa970 %}
                
                Now we need to implement the unique key generator service. For this sample we keep it simple and just use a dictionary to store the last given key per entity type in memory. In a productive system we will have to persist the values to be resilient to server crashes or reboot.
                
                {% gist f79ae618b5444c31b0eb %}
                
                Next in turn is the repository. We will use GetEventStore (GES) as our event store. But for the moment we just implement a fake repository that just uses a dictionary as an in-memory store. Later we will change the implementation and access GES
                
                {% gist 9a87bc3d5dbb281ab758 %}
                
                There is only one thing missing now until we can have a test run. We need to wire up the dependencies. For this we configure an IoC container, either the default container provided with ASP.NET vNext or a third party one like AutoFac. In this sample we use the default container. We just have to modify the Startup class and add the three lines which define our services (lines 5-7)
                
                {% gist 8b7038b77a76afc3077c %}
                
                We can now compile what we have so far (kpm build) and run (k kestrel).
                
                And now we are ready to try what we have implemented so far. Let’s return to our Postman client and try to send the same command again that we have used earlier when we tested the controller.
                
                [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;border-top-width: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2015/01/image_thumb4.png" width="492" height="376" />](https://lostechies.com/content/gabrielschenker/uploads/2015/01/image4.png) 
                
                In the console we should see a feedback, something like this
                
                [<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;border-top-width: 0px" border="0" alt="image" src="https://lostechies.com/content/gabrielschenker/uploads/2015/01/image_thumb5.png" width="469" height="159" />](https://lostechies.com/content/gabrielschenker/uploads/2015/01/image5.png) </p> 
                
                This is really cool! So, now the only piece missing until we have the write part of our server ready is the GES repository.
                
                # Summary
                
                In this first part of the series about writing an Angular application end-2-end I have shown how to use ASP.NET vNext on Ubuntu 14.x to create a RESTful backend. In the next part I will further develop the domain and also implement a repository for GetEventStore. Stay tuned!</p>