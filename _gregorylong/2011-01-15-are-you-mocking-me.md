---
id: 4793
title: Are you Mocking Me?
date: 2011-01-15T01:08:00+00:00
author: Gregory Long
layout: post
guid: /blogs/thatotherguy/archive/2011/01/14/are-you-mocking-me.aspx
dsq_thread_id:
  - "265387209"
categories:
  - System Testing
  - TDD
  - Test Doubles
  - Unit Testing
---
Jimmy has had a couple posts ([mocks](/blogs/jimmy_bogard/archive/2011/01/06/putting-mocks-in-their-place.aspx), [mocks](/blogs/jimmy_bogard/archive/2011/01/11/shifting-testing-strategies-away-from-mocks.aspx), and [less mocks](/blogs/jimmy_bogard/archive/2011/01/12/defining-unit-tests.aspx)) that prompted Derick to post [this](/blogs/derickbailey/archive/2011/01/13/mocks-stubs-and-unreadable-tests-clearly-i-m-doing-this-wrong.aspx) on his experience with tests &ndash; I&rsquo;d like to add my thoughts to mix.&nbsp; First, let me say I&rsquo;m not offering an answer to Derick&rsquo;s question (sorry Derick), simply some ideas to consider.&nbsp; If they help you, great.&nbsp; If not, please join the mix.

#### Not All Tests are created equal

If I told you there are only X types of programs you can write to solve any problem and they could only be created a certain way, etc. you&rsquo;d probably tell me to go do something rather unflattering and walk away.&nbsp; Yet when someone talks rigidly about Unit Tests and Integration Tests as solemnly as one might discuss religious rites our incredulity is significantly diminished.&nbsp; Is that a good thing?&nbsp; What are automated tests after all?&nbsp; Aren&rsquo;t they applications we create to achieve a specific goal?&nbsp; Is that goal always the same?&nbsp; I hosted a discussion on testing a few months ago at work.&nbsp; I began the session with a simple question, &ldquo;Why do we test?&rdquo;&nbsp; The answers from that group were fairly broad &ndash; from the expected &ldquo;to validate the expectations were met&rdquo; to &ldquo;to provide immediate feedback on an action we took&rdquo;.&nbsp; The next question was &ldquo;What kind of tests can we do?&rdquo;&nbsp; And again the responses were varied.&nbsp; I believe this is very healthy.

My in my current position I find I have the following goals for tests:

  * When designing the roles in a new area of the application 
      * Provide immediate feel for how my design choice shapes the behavior of the application 
      * Provide immediate feedback that I am meeting the expectations 
      * Keep my design focused on meeting the expectations for the Feature and no more 
  * When creating a new feature using existing roles 
      * Provide immediate feedback that I am meeting the expectations 
      * Warn me if I&rsquo;ve introduced a new role, altered an existing role, or broken existing features 
  * When deploying my application to a CI or other environment 
      * Provide assurance the environment is configured correctly 
      * Provide immediate feedback about my interaction with external dependencies 
      * Provide immediate feedback about how well my system meets the expected acceptable behavior 

There are a couple ideas I believe are valuable here:

  * Context &ndash; My goals and expectations vary by context; the context of what I&rsquo;m doing and even the context of where I&rsquo;m doing it (where I&rsquo;m employed) 
  * Roles &ndash; The behavior of a system is ultimately a collection of the data (nouns) and the roles (verbs) of a given feature.&nbsp; If those roles are not being changed, I&rsquo;m not designing anything new.&nbsp; If they do, then I am in a design context 
  * Scope &ndash; The scope of each context is important and should influence the scale of what I&rsquo;m trying to do.&nbsp; Being very specific in a broadly scoped context is an invitation for pain 

Because I have different contexts and goals I would be foolish to use the same tool for all of them, but isn&rsquo;t that often the trap we get into with testing?&nbsp; We say we follow a TDD, BDD, CYA, etc. style of testing and leave the conversation (and our minds) locked in a monolithic hell where nothing works quite right.&nbsp; What if we left the grand ideas behind and just stated simply what we want.&nbsp; When I&rsquo;m designing something new I want tests to help me explore the roles I&rsquo;m creating and how well they work together to create the expected behavior.&nbsp; When I&rsquo;m simply creating a new feature by composing the existing roles I just need to know I&rsquo;m creating the appropriate behavior and staying within my expected architecture.&nbsp; When I deploy, I want to see how the system behaves in it&rsquo;s environment and how the features flow.&nbsp; So, what does that look like?&nbsp; Let&rsquo;s take the code Jimmy posted in his original article and see.

#### Design Mode

public class OrderProcessor   
{   
&nbsp;&nbsp;&nbsp; private readonly ISmtpClient _client;   
&nbsp;&nbsp;&nbsp; private readonly IOrderSpec _spec;

&nbsp;&nbsp;&nbsp; public OrderProcessor(ISmtpClient client, IOrderSpec spec)   
&nbsp;&nbsp;&nbsp; {   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _client = client;   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _spec = spec;   
&nbsp;&nbsp;&nbsp; }

&nbsp;&nbsp;&nbsp; public void PlaceOrder(Order order)   
&nbsp;&nbsp;&nbsp; {   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (_spec.IsMatch(order))   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; string body = &#8220;Huge frickin&#8217; order alert!!!rnOrder #:&#8221; + order.OrderNumber;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; MailMessage message =   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; new MailMessage(&#8220;sender@email.com&#8221;, &#8220;salesdude@email.com&#8221;,   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &#8220;Order processed&#8221;, body);

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _client.Send(message);   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; order.Status = OrderStatus.Submitted;   
&nbsp;&nbsp;&nbsp; }   
}   
When in design mode I want to start with a test that is focused on the expected behavior of the feature.&nbsp; Jimmy didn&rsquo;t supply that expectation so I&rsquo;m going to make one up.&nbsp; This feature is part of our commerce MVC application.&nbsp; The expected behavior is that when a large order is placed, sales will be notified of the order and the order will be placed.&nbsp; A controller action will take an order object and call our Order Processor object, save the order object, and decide which view to return based on order&rsquo;s status.&nbsp; For our purpose we&rsquo;ll hold a notion of the system beginning at the controller.&nbsp; Therefore, the behavior I want to create should be exposed solely by the OrderProcessor (let&rsquo;s assume persistence is cross-cutting concern and not unique or valuable to this test).&nbsp; Since it is the top level of our system I&rsquo;d start by creating a feature test that instantiates the controller with a fake persistence object that allows me to control the order object that is passed into the action method and read the &lsquo;saved&rsquo; order out.&nbsp; I&rsquo;ll let the IoC build the rest from the real objects.&nbsp; If I was doing this with NUnit it might* look like this:

using Autofac;   
using Moq;   
using NUnit.Framework;   
using Should;

namespace FakeOrderSystem   
{   
&nbsp;&nbsp;&nbsp; [TestFixture]   
&nbsp;&nbsp;&nbsp; public class BehaviorProcessOrder   
&nbsp;&nbsp;&nbsp; {   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; protected OrderController SUT;   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; protected Mock<ISmtpClient> MockSmtpClient;   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; protected IRepository<Order> FakeRepository;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [TestFixtureSetUp]   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public void CreateSystem()   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; var builder = new ContainerBuilder();   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; builder.RegisterType<OrderProcessor>().As<IProcessAnOrder>();   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; builder.RegisterType<OrderSpec>().As<IOrderSpec>();   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FakeRepository = new AFakeRepository();   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; MockSmtpClient = new Mock<ISmtpClient>(MockBehavior.Loose);   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; builder.Register(s => MockSmtpClient.Object).As<ISmtpClient>().SingleInstance();   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; var container = builder.Build();   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SUT = new OrderController(FakeRepository, container.Resolve<IProcessAnOrder>());   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [Test]   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public void Should\_Notify\_Sales\_When\_a\_Large\_Order\_is\_Placed()   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //Arrange   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; var largeOrder = new Order {OrderNumber = &#8220;O1234485&#8221;, Total = 300, Status = OrderStatus.New};

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //Act   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SUT.PlaceOrder(largeOrder);

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //Assert   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; MockSmtpClient.Verify(c => c.Send(It.IsAny<MailMessage>()));   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FakeRepository.GetById(largeOrder.OrderNumber).Status.ShouldEqual(OrderStatus.Submitted);   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   
&nbsp;&nbsp;&nbsp; }   
}

*confession here &ndash; I didn&rsquo;t spend the time to get this passing.&nbsp; Do not consider this a &lsquo;real&rsquo; example.

I few things to point out here:

  1. The only test doubles here are for the SmtpClient (a mock because I only need to know it was called) and the Respository (a fake because I want more control) 
  2. I could&rsquo;ve used scanning to avoid specifying the interfaces (roles) involved and the objects acting in those roles.&nbsp; I like being specific when I&rsquo;m in design mode.&nbsp; Once I&rsquo;m done, I can always go back and replace this code with scanning/autowiring 
  3. I want the system to remain the same for each test &ndash; the inputs and results are what define the context and expectations 

What does this give me?&nbsp; For starters, it helps to clarify what I consider my system, what my expectations are of that system&rsquo;s behavior in a given context, and what roles I believe should be enacted by the system to fulfill those expectations.&nbsp; Once the design is complete (e.g. all expectations are met), I can re-use this test to confirm the system is unharmed by future additions to the application.&nbsp; Indeed, if I remove the explicit registration, I could potentially replace the implementations below the controller and re-use this test.&nbsp; It also helps me see the results of my design choices.&nbsp; A few thoughts there &ndash; IOrderSpec is a bit too vague for my taste.&nbsp; I&rsquo;d want to explore that bit of the system more.&nbsp; What is it&rsquo;s role in processing an order and how can that role be more clearly expressed?&nbsp; Second, I really don&rsquo;t like where the ISmtpClient sits.&nbsp; Even without seeing the implementation the order processor, I can spot a rub.&nbsp; Did you see it too?&nbsp; My expectation is that sales is notified, a behavior that is never expressed by an interface (role) in my system.&nbsp; I believe I&rsquo;m missing an abstraction &ndash; INotify.&nbsp; Doesn&rsquo;t change the need to use the mock for the mail client, but it does help to clarify how the expectation is met while providing more flexibility in the architecture for how that expectation is implemented (and maybe expanded in the future).&nbsp; As I implemented each role, I would create unit tests for that single class using test doubles for all dependencies.&nbsp; I would probably use an Automocking container (StructureMap has one, as does Autofac via the contrib project).&nbsp; I would do this to allow me to be specific about the interaction (how the roles behave) as I design the system.&nbsp; I might delete these tests after the design is finished, leave them alone as a warning for when my design has changed, or keep them in a separate test project I use when I&rsquo;m re-designing my system.

After re-factoring our system design test looks like this:

using Autofac;   
using NUnit.Framework;   
using Should;

namespace FakeOrderSystem   
{   
&nbsp;&nbsp;&nbsp; [TestFixture]   
&nbsp;&nbsp;&nbsp; public class BehaviorProcessOrder   
&nbsp;&nbsp;&nbsp; {   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; protected OrderController SUT;   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; protected AFakeMailClient FakeSmtpClient;&nbsp; <span style="background-color: #ffff00"><&#8212;&#8212;-&nbsp; Now a Fake</span>   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; protected IRepository<Order> FakeRepository;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [TestFixtureSetUp]   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public void CreateSystem()   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; var builder = new ContainerBuilder();   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; builder.RegisterType<OrderProcessor>().As<IProcessAnOrder>();   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; builder.RegisterType<OrderExaminer>().As<IEvaluateOrdersForActions>();&nbsp;&nbsp; <span style="background-color: #ffff00"><&#8212;- New Role that was &lsquo;found&rsquo; by exploring the IOrderSpec role</span>   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; builder.RegisterType<LargeOrderSpec>().As<ISpecifyOrderActions>(); <span style="background-color: #ffff00"><&#8212; The re-factored IOrderSpec</span>   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; builder.RegisterType<RushOrderSpec>().As<ISpecifyOrderActions>(); <span style="background-color: #ffff00"><&#8212;- Also &lsquo;had&rsquo; a requirement for this state so put it in here to see how the design behaves <br /></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; builder.RegisterType<EmailNotifier>().As<INotify>(); <span style="background-color: #ffff00"><&#8212; we now have an abstraction that fulfills our missing &lsquo;notify&rsquo; role</span>   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FakeRepository = new AFakeRepository();   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FakeSmtpClient = new AFakeMailClient();   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; builder.Register(s => FakeSmtpClient).As<ISmtpClient>().SingleInstance();   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; builder.Register(r => FakeRepository).As<IRepository<Order>>().SingleInstance();   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; var container = builder.Build();   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SUT = new OrderController(container.Resolve<IProcessAnOrder>());   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [Test]   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public void Should\_Notify\_Sales\_When\_a\_Large\_Order\_is\_Placed()   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //Arrange   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; var largeOrder = new Order {OrderNumber = &#8220;O1234485&#8221;, Total = 300, Status = OrderStatus.New};   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //Act   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SUT.PlaceOrder(largeOrder);

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //Assert   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FakeSmtpClient.VerifyMessageSentTo(&#8220;sales@fakeemail.com&#8221;).ShouldBeTrue();   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FakeRepository.GetById(largeOrder.OrderNumber).Status.ShouldEqual(OrderStatus.Submitted);   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [Test]   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public void Should\_Notify\_Manufacturing\_When\_a\_Rush\_Order\_is\_Placed()   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //Arrange   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; var rushOrder = new Order {OrderNumber = &#8220;O1234486&#8221;, Total = 30, Status = OrderStatus.NewRush};   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //Act   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SUT.PlaceOrder(rushOrder);

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //Assert   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FakeSmtpClient.VerifyMessageSentTo(&#8220;manufacturing@fakeemail.com&#8221;).ShouldBeTrue();   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FakeRepository.GetById(rushOrder.OrderNumber).Status.ShouldEqual(OrderStatus.Submitted);   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }   
&nbsp;&nbsp;&nbsp; }

A consequence of this exercise is that I&rsquo;ve decided (and expressed in the test) that my system has three top level responsibilities (roles): 1) to evaluate which actions should be taken based on the order&rsquo;s state, 2) to set the status to submitted, and 3) to save the order (which will prompt other parts of the application to do things).&nbsp; I refactored the OrderProcessor to perform these roles and added other dependencies (IEvaluateOrdersForActions) to help clarify the roles of the system.&nbsp; I&rsquo;ve also decided that the truly meaningful part of the email client is that the message was sent to the right person (I could also examine other aspects of the message).&nbsp; This has removed my use of mocks completely as I need to retrieve the message from the client.&nbsp; I&rsquo;m now using two simple fake objects for more external dependencies.&nbsp; How about the class that started this whole thing?&nbsp; Our old friend OrderProcessor looks like this:

public class OrderProcessor : IProcessAnOrder   
{   
&nbsp;&nbsp;&nbsp; private readonly IEvaluateOrdersForActions _evaluator;   
&nbsp;&nbsp;&nbsp; private readonly IRepository<Order> _repository;

&nbsp;&nbsp;&nbsp; public OrderProcessor(IEvaluateOrdersForActions evaluator, IRepository<Order> repository)   
&nbsp;&nbsp;&nbsp; {   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _evaluator = evaluator;   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _repository = repository;   
&nbsp;&nbsp;&nbsp; }

&nbsp;&nbsp;&nbsp; public void PlaceOrder(Order order)   
&nbsp;&nbsp;&nbsp; {   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _evaluator.Evaluate(order);   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; order.Status = OrderStatus.Submitted;   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _repository.Update(order);   
&nbsp;&nbsp;&nbsp; }   
}

Revisiting Jimmy&rsquo;s statement on the value of test doubles I&rsquo;d say this:&nbsp; <span style="text-decoration: line-through"><strong>Mocks, stubs, fakes and the like are most valuable when they replace external dependencies</strong>.</span>&nbsp; **Mocks, stubs, and the like are most valuable when they play a role in achieving the purpose for which you wrote the test.**&nbsp; I&rsquo;m going to stop there for now.&nbsp; I hope this gives folks some ideas to chew on.&nbsp; A reminder, I&rsquo;m not saying this is The Right Way or even A Right Way.&nbsp; These are some ideas.&nbsp; They need to worked and challenged if they are to have any value for you (or me for that matter).&nbsp; I know I didn&rsquo;t provide examples for deployment testing.&nbsp; If I can find some time (and motivation) I&rsquo;ll try to post some ideas on those as well.&nbsp; Discuss.&nbsp; (ala [CoffeeTalk](http://en.wikipedia.org/wiki/Coffee_Talk))