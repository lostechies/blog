---
wordpress_id: 357
title: An AutoMapper success story
date: 2009-10-08T16:38:32+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/10/08/an-automapper-success-story.aspx
dsq_thread_id:
  - "264716325"
categories:
  - AutoMapper
redirect_from: "/blogs/jimmy_bogard/archive/2009/10/08/an-automapper-success-story.aspx/"
---
I got a cool message on the [AutoMapper mailing list](http://groups.google.com/group/automapper-users) from [Howard Van Rooijen](http://consultingblogs.emc.com/howardvanrooijen/) on how they used [AutoMapper](http://automapper.codeplex.com/) in a site they recently launched to production:

> Hello AutoMapper Community,
> 
> I just wanted to let you know that an e-commerce site which uses AutoMapper as part of it&#8217;s core architecture has just been released into the wild: 
> 
> [http://www.](http://www.fancydressoutfitters.co.uk/)[fancydressout](http://www.fancydressoutfitters.co.uk/)[fitters.co.uk](http://www.fancydressoutfitters.co.uk/)
> 
> And I wanted to say a HUGE thank-you to Jimmy & the Community for this wonderful tool &#8211; that helps remove so much commodity plumbing code from the solution. 
> 
> We were a little sceptical at the start of the project that AutoMapper would "cut the mustard" when it came to the performance requirements of a public facing, high load, e-commerce site because of the amount of reflection AutoMapper uses at its core, but we have been incredibly impressed with the performance of the solution under load.
> 
> The site is based on the S#arp Architecture Framework and its become very apparent how well AutoMapper fits into MVC style architecture as it enables easy separation of concerns with regards to object conversion (entities & ViewModels). Once we moved from hand-cranked converters to AutoMapper it was amazing how much cleaner our code became &#8211; so much so that we modified the overall solution architecture to incorporate explicit mapping layers (see attached image). Our general pattern of usage within MVC is as follows:
> 
> 1. Map input into Domain Entities in the Controller
> 
> 2. Pass Domain Entities into Task Layer to "do stuff"
> 
> 3. Map output of Task Layer (Domain Entities) into ViewModel
> 
> 4. Pass ViewModel to ViewEngine
> 
> Simple, slick and clean.
> 
> To formalise the Mapping Layer and make it testable we implemented a simple interface:
> 
> public interface IMapper<TInput, TOutput>
> 
> {
> 
> TOutput MapFrom(TInput input);
> 
> }
> 
> Next we&#8217;d implement a custom marker interface so that we could resolve the mapper from the DI container and we adopted the naming convention <Input Type><Output Type>Mapper:
> 
> public interface IEditModelEntityMapper : IMapper<EditModel, Entity>
> 
> {
> 
> }
> 
> Then finally implement the interface:
> 
> public class EditModelEntityMapper : IEditModelEntityMapper 
> 
> {
> 
> public EditModelEntityMapper()
> 
> {
> 
> Mapper.CreateMap<EditModel, Entity>()
> 
> .ForMember(x => x.Property, y => y.MapFrom(z => z.Property));
> 
> }
> 
> public Entity MapFrom(EditModel input)
> 
> {
> 
> return Mapper.Map<EditModel, Entity>(input);
> 
> }
> 
> }
> 
> Then to actually use it in the MVC app:
> 
> public class CustomController : Controller
> 
> {
> 
> private readonly ITasks tasks;
> 
> private readonly IEditModelEntityMapper editModelEntityMapper;
> 
> private readonly IOutputViewModelMapper outputViewModelMapper;
> 
> public CustomController(ITasks tasks, 
> 
> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; IEditModelEntityMapper editModelEntityMapper,
> 
> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; IOutputViewModelMapper outputViewModelMapper)
> 
> {
> 
> this.tasks = tasks;
> 
> this.editModelEntityMapper = editModelEntityMapper;
> 
> this.outputViewModelMapper = outputViewModelMapper;
> 
> }
> 
> public ActionResult Index(EditEntity input)
> 
> {
> 
> var entity = this.editModelEntityMapper.MapFrom(input);
> 
> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; var output = this.tasks.DoSomething(entity)
> 
> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; var viewModel = this.outputViewModelMapper.MapFrom(output);
> 
> return View(viewModel);
> 
> }
> 
> }
> 
> For those who are interested &#8211; here&#8217;s a little more info:
> 
> &#8211; We ran the project using Scrum and delivered in 20 weeks: 10 x 2 week iterations
> 
> &#8211; It&#8217;s based on the [S#arp Architecture](http://www.sharparchitecture.net/) framework, which we extended to support, AutoMapper, Spark and ViewModels   
> &#8211; Solution performs very well: 1000 concurrent users per web server, generating around 180 pages per second across 2x single quad core 64bit servers.
> 
> Again, many thanks,
> 
> Howard

Howard also shared a neat little diagram of his architecture:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/jimmybogard/files/2011/03/image_thumb_312FA5FF.png" width="478" height="484" />](http://lostechies.com/jimmybogard/files/2011/03/image_18A008AF.png) 

This is one of the greatest feelings from doing OSS – that something you created basically just for yourself can also help out other folks out there trying to deliver value for their customers.&#160; Thanks for all the feedback everyone, as well as kudos to the S#arp Architecture team for building such a great framework for MVC.