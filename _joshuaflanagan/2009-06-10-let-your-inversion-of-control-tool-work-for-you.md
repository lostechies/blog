---
wordpress_id: 3946
title: Let your Inversion of Control tool work for you
date: 2009-06-10T03:58:51+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2009/06/09/let-your-inversion-of-control-tool-work-for-you.aspx
dsq_thread_id:
  - "262113176"
categories:
  - composition
  - StructureMap
redirect_from: "/blogs/joshuaflanagan/archive/2009/06/09/let-your-inversion-of-control-tool-work-for-you.aspx/"
---
If you are just starting out exploring use of an Inversion of Control tool (IoC), its very easy to go down the wrong path, and make things harder for yourself. Today I had a conversation with a bright developer who was feeling the pain because doing it all wrong. And just a month or so ago, I had the same conversation with another bright developer who was also doing it the same, wrong, way.

The problem may be that people misinterpret the intent of an IoC tool. It is seen simply as a configuration tool – a way to swap out classes using some magical XML or a DSL. The thought is that as long as your code gets all of its dependencies out of the container, you can change the behavior just by configuring the container.

And then you end up with code that looks like this:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>public class OrderService : IOrderService
{
    private IRepository _repository;
    private ISystemClock _systemClock;

    public OrderService()
    {
        _repository = Container.Resolve&lt;IRepository&gt;();
        _systemClock = Container.Resolve&lt;ISystemClock&gt;();
    }
}

public class OrderController
{
    private IOrderService _orderService;

    public OrderController()
    {
        _orderService = Container.Resolve&lt;IOrderService&gt;();
    }
}</pre>
</div>

The OrderService needs an IRepository and an ISystemClock, so you pull them out of the container in the constructor. The OrderController needs an IOrderService, so you pull it out of the container in the constructor. You can now swap out actual implementations using some external configuration.

Except now you’ve got this annoying dependency on the magical Container class. And maybe the Container has a dependency on an external XML file.

And you discover that when you try to unit test your OrderService, you need to make sure you have a Container available, and that it has been configured to serve up whichever instances you want to use during testing.

Your simple, plain-old CLR object (POCO) now has this deadweight Container dependency dragging it down. The Container requires extra care and feeding, in the form of configuration, and now it has infected your entire codebase.

Hopefully, at this point you are feeling enough pain that you go seeking some advice, and hopefully you find out about auto-wiring.

Any IoC tool worth using will support auto-wiring dependencies for objects retrieved from the container. This means that the tool will build up all of the necessary objects needed to satisfy a request. This allows you to rewrite the above code as:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>public class OrderService : IOrderService
{
    private readonly IRepository _repository;
    private readonly ISystemClock _systemClock;

    public OrderService(IRepository repository, ISystemClock systemClock)
    {
        _repository = repository;
        _systemClock = systemClock;
    }
}

public class OrderController
{
    private readonly IOrderService _orderService;

    public OrderController(IOrderService orderService)
    {
        _orderService = orderService;
    }
}</pre>
</div>

But where did the Container go? Exactly. The majority of your code should never have to deal with the container directly. Ideally, you make a single call to the container which builds up an object graph that implements your program. For a console application, you might make a call to the container once in your static Main method. For an MVC web application, you might make a call to the container at the beginning of each request to retrieve the appropriate Controller. The rest of your code is blissfully ignorant of the container. When something asks the container for an OrderController, the container will detect the dependency on the IOrderService. So it goes to build an OrderService, and detects the dependencies on the IRepository and ISystemClock. So it builds up those instances, and any dependencies they may have, and so on.

By the way, my colleague <a href="http://codebetter.com/blogs/jeremy.miller/" target="_blank">Jeremy Miller</a> wrote this same post just a few months ago. But he assured me it was worth re-writing, because there are new people jumping on all the time, and they’re not likely to go back reading old blog posts. If you find yourself with the problem I describe above, go get the full details by reading his post about <a href="http://codebetter.com/blogs/jeremy.miller/archive/2009/01/07/autowiring-in-structuremap-2-5.aspx" target="_blank">auto-wiring in StructureMap</a>.

One thing that I’ll add is that I’ve heard a lot of talk lately that “container” is really a misnomer for what an IoC tool does, and that it should be more appropriately referred to as a “composer”. I think this argument has merit, and wonder if the name may be contributing to people going down the wrong path described above. A “container” sounds like something that stores a bunch of stuff for you, and it is your job to get stuff out of it, hence the explicit calls to the Container littered throughout your code. A “composer” sounds like something that takes little pieces of functionality in your application and puts them together into a usable whole. The bad code example above reflects “container” thinking. The better code example reflects “composer” thinking.