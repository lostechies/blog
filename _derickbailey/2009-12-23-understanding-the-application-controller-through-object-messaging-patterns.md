---
wordpress_id: 96
title: Understanding The Application Controller Through Object Messaging Patterns
date: 2009-12-23T03:06:01+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/12/22/understanding-the-application-controller-through-object-messaging-patterns.aspx
dsq_thread_id:
  - "262068407"
categories:
  - .NET
  - Analysis and Design
  - AppController
  - Messaging
  - Model-View-Presenter
  - Principles and Patterns
  - Workflow
redirect_from: "/blogs/derickbailey/archive/2009/12/22/understanding-the-application-controller-through-object-messaging-patterns.aspx/"
---
### 

Earlier in the year, I posted a few times on the [Application Controller](https://lostechies.com/blogs/derickbailey/archive/2009/04/18/decoupling-workflow-and-forms-with-an-application-controller.aspx) pattern that I was implementing, including some [workflow service](https://lostechies.com/blogs/derickbailey/archive/2009/05/19/result-lt-t-gt-directing-workflow-with-a-return-status-and-value.aspx) related posts, all leading up to the presentation on [decoupling workflow from forms](https://github.com/derickbailey/presentations-and-training/tree/master/Decoupling%20Workflow%20With%20App%20Controler/) that I gave at Austin Code Camp ‘09. I’ve been working with this style of architecture in my winforms apps since then, and have really grown to love it. And now with [my new job](https://lostechies.com/blogs/derickbailey/archive/2009/11/04/a-time-for-change.aspx) and my new team, I’ve recently had a chance to take the same patterns and port them over to the .net compact framework. The good news is that it took zero changes to the core architecture and code. The 2 things I had to do were re-write the form implementations in compact framework forms, and replace structuremap with a ninject version compiled for the compact framework. It was an easy port and the code is [available on github](https://github.com/derickbailey/appcontroller.cf), along with the [original winforms version](https://github.com/derickbailey/appcontroller).

One thing I don’t think I did very well with my original posts, or in the presentation I gave, was explaining when you should use which parts of this architecture. There’s nothing terribly difficult about understanding when to use what, honestly, but it may not be so obvious to someone that is new to the patterns and implementation details that I’ve included in the sample applications. Before we get into the detail on when to use what, though, I want to discuss the underlying patterns that make up the App Controller. This will help to facilitate the discussion on when each part of the App Controller should be used.

&#160;

## The Code Patterns

These patterns have been covered in depth, but I wanted to consolidate them here for ease of reference.

### [Command Pattern](https://lostechies.com/blogs/derickbailey/archive/2008/11/19/ptom-command-and-conquer-your-ui-coupling-problems.aspx)

> _Originally outlined by the infamous "Gang of Four", the_ [_Command_](http://en.wikipedia.org/wiki/Command_pattern) __[_Pattern_](http://www.dofactory.com/Patterns/PatternCommand.aspx) _is described as an object that represents an action &#8211; a command that will be executed._

The command patterns is implemented in the AppController via the Execute<T>(T args) method. You can pass any arbitrary command parameter information into this message as the T args parameter. The type of the args is then used to find an instance of an ICommant<T> interface and the ICommand<T> has the .Execute<T>(T args) command called on it, to execute the actual command object. This allows you to decouple the knowledge of work to be done from the worker doing it. 

&#160;

### [Event Aggregator](http://martinfowler.com/eaaDev/EventAggregator.html)

> _A system with lots of objects can lead to complexities when a client wants to subscribe to events. The client has to find and register for each object individually, if each object has multiple events then each event requires a separate subscription. An Event Aggregator acts as a single source of events for many objects. It registers for all the events of the many objects allowing clients to register with just the aggregator._

The Event Aggregator in the sample code is based on Jeremy Miller’s [Build Your Own CAB series](http://codebetter.com/blogs/jeremy.miller/archive/2007/07/25/the-build-your-own-cab-series-table-of-contents.aspx) ([here](http://codebetter.com/blogs/jeremy.miller/archive/2007/06/29/build-your-own-cab-11-event-aggregator.aspx), [here](http://codebetter.com/blogs/jeremy.miller/archive/2008/01/11/build-your-own-cab-extensible-pub-sub-event-aggregator-with-generics.aspx) and [here](http://codebetter.com/blogs/jeremy.miller/archive/2007/07/02/build-your-own-cab-12-rein-in-runaway-events-with-the-quot-latch-quot.aspx)), and is hidden behind the Raise<T> method of our AppController. We can easily create and publish events by calling the AppController.Raise<T> method, and we can easily subscribe to those events by implementing an IEventHandler<T> interface. This allows you to have multiple parts of the system respond to an event without having to be coupled directly to the part of the system that raises the event.

&#160;

### [Application Controller](http://martinfowler.com/eaaCatalog/applicationController.html)

> _“Some applications contain a significant amount of logic about the screens to use at different points, which may involve invoking certain screens at certain times in an application. This is the wizard style of interaction, where the user is led through a series of screens in a certain order. In other cases we may see screens that are only brought in under certain conditions, or choices between different screens that depend on earlier input._ 
> 
> _To some degree the various Model View Controller input controllers can make some of these decisions, but as an application gets more complex this can lead to duplicated code as several controllers for different screens need to know what to do in a certain situation._ 
> 
> _You can remove this duplication by placing all the flow logic in an Application Controller. Input controllers then ask the Application Controller for the appropriate commands for execution against a model and the correct view to use depending on the application context.”_

Now I know that my AppController doesn’t take on all of these responsibilities. That decision was made on purpose, to further decouple the workflow decisions. In keeping with the [Single Responsibility Principle](http://en.wikipedia.org/wiki/Single_responsibility_principle), I decided to move the “_logic about the screens to use at different points_” out of the AppController itself and into objects that can control the specific flow of screens for a specific need. The movement between screens, coordinating all of the resources that are needed for a given process, are encapsulated in what I call Workflow Services.

&#160;

### <u>Workflow Services</u>

I’m not sure if this is a legitimately recognized pattern in software development (hence no link). However, it’s a term that I’ve been using for over a year now and it fits with the intent very well. My definition of a Workflow Service, if I had to give one, is something a long the lines of:

> _An object that encapsulates the entire flow of work, from beginning to end, for a given action or sequence of actions. This includes the coordination of all required resources, such as the user interface, user input handling, object and domain model calls, repository and data access calls, and/or any other resource that is required to complete the action in question._ 

A workflow service is an object that represent the logic of how something happens from a 1,000 foot view. Imagine making a flowchart diagram that has a start, some work and some decisions, and a stop. Rather than haphazardly coding this flow of work as a tightly coupled set of forms which makes it difficult to change the flow of work, you can code the knowledge that is represented by the flowchart into an object. This object is a workflow service.

One thing you’ll notice is that the AppController has no explicit IWorkflow or IWorkflowStep or anything else related to worklow in it’s model. This is because workflow is a very application and task specific process. You cannot be hamstrung to a specific style of workflow in your application. Rather, you should be free to use any type of workflow process that you need: wizard style, single screen pop up style, or however else you want to flow.

&#160;

## Correlating Code Patterns To Messaging Patterns

I’ve done a lot of work with messaging systems in the last two years and it’s had a tremendous amount of influence on me. I’ve changed how I see the architecture of large scale, disconnected systems and even how I see small scale, in process systems. The idea of passing around various types of messages for various purposes has really settled well into my thinking and has helped me to create some systems that are very well abstracted, decoupled, and pieced back together at runtime.

There is a direct correlation between the code in the App Controller and a messaging system. Many of the principles and patterns that I’ve used to implement the App Controller are directly based on various patterns found in messaging systems. These are the core messaging patterns that I’ve used, and how they correlate. I haven’t really talked much about messaging patterns, even though it’s become an important part of what I do. You can find all you need to know and more in the [Enterprise Integration Patterns](http://www.enterpriseintegrationpatterns.com/) book and website. (Note: all the descriptions and images for these patterns come from the [Enterprise Integration Patterns](http://www.enterpriseintegrationpatterns.com/toc.html) website)

&#160;

### [Publish / Subscribe Channel](http://www.enterpriseintegrationpatterns.com/PublishSubscribeChannel.html)

> <img style="border-right-width: 0px;margin: 0px 10px 0px 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="http://www.enterpriseintegrationpatterns.com/img/PublishSubscribeIcon.gif" align="left" src="http://www.enterpriseintegrationpatterns.com/img/PublishSubscribeIcon.gif" />_A Publish-Subscribe Channel works like this: It has one input channel that splits into multiple output channels, one for each subscriber. When an event is published into the channel, the Publish-Subscribe Channel delivers a copy of the message to each of the output channels. Each output channel has only one subscriber, which is only allowed to consume a message once. In this way, each subscriber only gets the message once and consumed copies disappear from their channels._

The publish / subscribe channel lets you broadcast a message to any client that is listening to the channel. The publisher of the message shouldn’t care who is listening or how many listeners there are. There may be zero and the publisher does not do anything different than if there are many listeners. There is no durability in the messages published to this channel. If you are not actively listening to this channel when a message is published, then you will not receive the message.

A common use of the publish / subscribe channel is to broadcast event messages (see below) between systems. This allows systems that are not otherwise connected to respond to things that are happening in other places. The Event Aggregator in our App Controller provides us with a publish / subscribe mechanism.&#160; 

&#160;

### [Event Message](http://www.enterpriseintegrationpatterns.com/EventMessage.html)

> <img style="border-right-width: 0px;margin: 0px 10px 0px 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" align="left" src="http://www.enterpriseintegrationpatterns.com/img/EventMessageIcon.gif" />_When a subject has an event to announce, it will create an event object, wrap it in a message, and send it on a channel. The observer will receive the event message, get the event, and process it. Messaging does not change the event notification, just makes sure that the notification gets to the observer._

The event message is the data that describes the event that occurred. It allows the system that is responding to the event to know the details of what happened, so that it can make the appropriate choices in how to respond. In our AppController, the generics parameter <T> of the Raise<T>(T args) represents the event message. This allows the Event Aggregator to determine which event handlers need to be executed – based on the IEventHandler<T> interface implementation – so that the appropriate actions can be taken for the type of event that has occurred.

&#160;

### [Point To Point Channel](http://www.enterpriseintegrationpatterns.com/PointToPointChannel.html)

> _<img style="border-right-width: 0px;margin: 0px 10px 0px 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" align="left" src="http://www.enterpriseintegrationpatterns.com/img/PointToPointIcon.gif" />A Point-to-Point Channel ensures that only one receiver consumes any given message. If the channel has multiple receivers, only one of them can successfully consume a particular message. If multiple receivers try to consume a single message, the channel ensures that only one of them succeeds, so the receivers do not have to coordinate with each other. The channel can still have multiple receivers to consume multiple messages concurrently, but only a single receiver consumes any one message._

The point to point channel is commonly used when a publisher knows that there is one very specific end point that needs to receive a message, and the message needs to be delivered even if the subscriber on the other end is not currently available. For example, if you have two separate systems that need to talk to each other and exchange very specific information with each other, you will likely have Point To Point Channels open between the two systems. This allows each system to send a message specifically to the other system, without having to be coupled to the other system’s API.

In our AppController, the command pattern with the ICommand<T> interface acts as the Point To Point channel. The simplified command pattern implementation that I provide in the example code may not provide the durability of a full Point To Point messaging system, but it does provide most of the other constructs and uses. It allows your code to say “I need this to happen” and have another piece of code get it done, without coupling the two parts of the system together.

&#160;

### [Command Message](http://www.enterpriseintegrationpatterns.com/CommandMessage.html)

> <img style="border-right-width: 0px;margin: 0px 10px 0px 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" align="left" src="http://www.enterpriseintegrationpatterns.com/img/CommandMessageIcon.gif" />_There is no specific message type for commands; a Command Message is simply a regular message that happens to contain a command. In JMS, the command message could be any type of message; examples include an ObjectMessage containing a Serializable command object, a TextMessage containing the command in XML form, etc. In .NET, a command message is a Message with a command stored in it. A Simple Object Access Protocol (SOAP) request is a command message._

The command message is essentially an order to do something, describing what is to be done. The “how” of the work, though, is handled entirely by the code that is processing (executing) the command. In our AppController, the generics parameter T in the .Execute<T>(T args) method is the command message. The T parameter also has a second duty, though, helping to define the point to point channel. This argument is used by the AppController to determine which ICommand<T> should be executed – in other words, it determines which “channel” the message is sent through. The code that resides in the channel (the ICommand<T>) may or may not be the final executing code for the command. You can have an object register itself to execute for a given command message and then have it call out to another object as the receiver (subscriber) of the command, doing the actual work. In most cases, though, I prefer to combine the channel and subscriber into a single object – to have the object that implements the ICommand<T> be the object that executes the final code for that command.

&#160;

## When To Use Events Vs. Commands

Keep in mind that these are only suggested reasons and situations for use. From a technical standpoint, you can use any part of the AppController for anything you want. That doesn’t mean you should, though. It is good to keep a general set of guidelines in mind when using the AppController’s functionality vs. when to use other functionality and more direct calls into other pats of your system. This will help to create consistency in your system, which will help to make the entire system easier to learn.

&#160;

### Commands / Execute<T>(T args)

The command pattern is like a monitor in the kitchen of a fast food restaurant. When orders come in, the show up on the monitor. Each of the items on the monitor can be considered the parameter data – the “what to make” parameter &#8211; while the order itself showing up on the screen is the command “go make this”. The person executing the command – that is, the person who makes the food – is irrelevant to the customer. They don’t care who makes it as long as it is made correctly. Similarly, your code that needs a command executed may not care what code executes it. When this is the case, you can ask the AppController to execute the command that is registered for your parameter data.

An object that implements the ICommand<T> interface does not need to be ‘live’ for the AppController to execute it. The AppController uses the underlying IoC container to find the registered instance of the command handler and will instantiate it if the handler is not already alive. 

#### **When To Use It**

A good rule of thumb for executing a command is when you need an action to occur that is not part of the current process or workflow. Some good example of this are buttons or menu items that kick off another workflow or sub-workflow. In the example code for the AppController, I have a button on the main form that kicks off the process to add a new employee. Behind the scenes, this button causes an Execute(new AddNewEmployee()); call – telling the AppController to execute whatever command can handle the AddNewEmployee command message. The main form / presenter in this case know that the user is requesting for a new employee to be added to the system. However, the main form / presenter don’t know (and shouldn’t know!) how that actually occurs. They want to delegate the responsibility of adding the new employee to a part of the system that does know how to handle it, but they don’t want to be coupled directly to that part of the system. 

#### **When Not To Use It**

There are time when you know you need to call out to another process and you expect that process to return a known type of information to you. In situations like this, you may not want to use the commands. Commands are set up so that they do not provide any immediate response to the caller. This is done so that the commands be parallelized and / or otherwise handled out-of-process. The knowledge of whether a command is handled in-process or out-of-process should make no difference to the caller.

An example of when not to use a command may be saving an object to a database. You probably need to know if the save was successful or not – if any foreign key violations occurred, if any validation failed, etc. Most systems expect this type of information to be returned from the call, directly. Unless you are working in a larger scale or distributed system, a command may not be suitable here because it would introduce a lot of complexity in getting the return data to the caller, asynchronously.

Another example of when not to use a command would be when you expect multiple handlers for the message and don’t care whether one or all of them are ‘live’ to handle it. If you want to broadcast a message for multiple, unknown subscribers, you should use an Event message.

&#160;

### Events / Raise<T>(T args)

The Event Aggregator is used to notify many parts of the system when something has happened, so that those parts and each take the appropriate action. An example of an event would be a customer walking into a restaurant. At the time a customer walks in a host or hostess may respond by greeting them, a server may respond by grabbing some menus and silverware, and a cook may respond by prepping their workstation to make the orders for the customer. All of these responses are occurring because of the ‘event’ – a customer walking in. If no customers walk in, you won’t see the host or hostess greeting no one because they haven’t said their greeting for a while, and you won’t see the cook finishing up a bunch of food for orders that haven’t been placed (well, maybe at some fast food places). Rather, you will see these persons doing tasks that happen on a regular or scheduled basis, not an event-driven basis.

The event aggregator does not do any form of object lifecycle management and has no references to any IoC containers (service locator or dependency injection). If an object needs to be notified of an event being raises, that object must be alive and must have itself registered with the event publisher as a handler for the event in question, at the time that the event is raised. If any of these conditions is not met, then the object that needs to be notified will not be notified. The event aggregator is a true publish/subscribe model in this respect. It does not care if there are zero or many listeners – it publishes the event to any interested listener.

#### **When To Use It**

The Event Aggregator is best used in situations where a domain or application level event has occurred, and various parts of the already-running system need to react. The AppController’s wrapping up of the Event Aggregator does suggest that we are dealing with application level events, for the most part. These types of events are needed to coordinate the various application specific parts of the system – the parts that are there entirely for the user or other systems to interact with – and not the domain level events. Of course there is nothing wrong with raising domain level events from the Event Aggregator, either. You may wish to reference the IEventPublisher directly from your domain layer, though, rather than pushing the domain level events from the application layer.

A good example usage is at the end of the add new employee process in the sample application. The event aggregator raises a NewEmployeeAdded even which is caught by the main form’s presenter, and the presenter then refreshes the tree view of the org chart. This may de considered a domain level event, depending on how you see the add new employee service (if it’s part of the application layer or the domain layer).

Another great example of how an event aggregator can help decouple UI from process is found in the main form’s functionality. When you click on an employee in the tree view, the main form’s presenter raises an EmployeeSelected event. This event is then caught by the presenter of a custom user control on the same form – the display of the employee information. This example illustrates how power the event aggregator can be by helping us clean up our presenter->presenter communications, and keep them decoupled from each other. This is definitely an application level event. The entire purpose of this event is to facilitate a part of the application and it’s functionality – displaying the details of the selected employee.

#### **When Not To Use It**

The first thing to remember when using the event aggregator is that it is not intended to be used for simple button click handlers and text_changed events, or other simple UI->CodeBehind “events”. The event system built into .net is perfect for handling these simple UI level events. A domain level or application level event is one that allows the system’s functionality to be kicked off, not just at a UI level, but at any level of the system.

Secondly, the event aggregator should not be used when you want to guarantee the execution of something. An event is transient information that is only handled by objects that are currently alive. If you need to guarantee that a message is handled, you should consider using a point to point message like a command.

&#160;

### Do Something vs Something Happened

A good way to distinguish between an event and a command is to think about a command as an order to do something (future tense), while an event is a notification that something happened (past tense). If you need something to be done, you want a command. If you want to respond to something that happened, you want an event / event handler. 

&#160;

## When To Use Workflow Services

Workflow services are the 1,000 foot view of how things get done. They are the direct modeling of a flowchart diagram in code. 

### When To Use It

Any time you need to coordinate various resources through a specific flow of work, to complete an action or sequence of actions, a workflow service should be used. 

### When Not To Use It

Technically, a single UI form can have a work flow all on it’s own. How you should move throughout the completion of a single form is a type of work flow. However, a workflow service is geared toward a higher level view of the system than that. In a scenario where a single form is sufficient to accomplish the task, you may be looking at a scenario where a presenter or controller is sufficient.

&#160;

## Download The Code

Just in case you missed the links all the way back up at the top, here are the locations of the source code that I am referring to throughout this article.

> **For standard WinForms applications:** [**https://github.com/derickbailey/appcontroller**](https://github.com/derickbailey/appcontroller) ****
> 
> **For Compact Framework applications:** [**https://github.com/derickbailey/appcontroller.cf**](https://github.com/derickbailey/appcontroller.cf) 

The only significant differences between these two solutions are the forms implementation (full windows vs compact framework) and structuremap is used in the winforms version while ninject is used in the compact frmaework version.