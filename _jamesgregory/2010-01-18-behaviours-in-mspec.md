---
wordpress_id: 4503
title: Behaviours in MSpec
date: 2010-01-18T12:42:00+00:00
author: James Gregory
layout: post
wordpress_guid: /blogs/jagregory/archive/2010/01/18/behaviours-in-mspec.aspx
dsq_thread_id:
  - "274816223"
categories:
  - BDD
  - MSpec
---
[MSpec](http://github.com/machine/machine.specifications) is awesome, I think it&#8217;s praised by myself and others enough for that particular point to not need any expansion; however, there is a particular feature I would like to highlight that hasn&#8217;t really got a lot of press: behaviours.

Behaviours define reusable specs that encapsulate a particular set of, you guessed it, behaviours; you&#8217;re then able to include these specs in any context that exhibits a particular behaviour.

Lets go with the cliche&#8217;d Vehicle example. Given an `IVehicle` interface, with `Car` and `Motorbike` implementations; these all expose a `StartEngine` method and some properties reflecting the state of the vehicle. We&#8217;ll start the engine and verify that it is actually started, whether it&#8217;s got anything on the rev counter, and whether it&#8217;s killing our planet in the process (zing!).

<pre>public interface IVehicle
{
  void StartEngine();
  bool IsEngineRunning { get; }
  bool IsPolluting { get; }
  int RevCount { get; }
}

public class Car : IVehicle
{
  public bool IsEngineRunning { get; private set; }
  
  public void StartEngine()
  {
    // use your imagination...
  }
}

public class Motorbike : IVehicle
{
  public bool IsEngineRunning { get; private set; }

  public void StartEngine()
  {
    // use your imagination...
  }
}
</pre>

Those are our classes, if rather contrived, but they&#8217;ll do. Now what we need to do is write some specs for them.

<pre>public class when_a_car_is_started
{
  Establish context = () =&gt;
    vehicle = new Car();
  
  Because of = () =&gt;
    vehicle.StartEngine();
  
  It should_have_a_running_engine = () =&gt;
    vehicle.IsEngineRunning.ShouldBeTrue();
  
  It should_be_polluting_the_atmosphere = () =&gt;
    vehicle.IsPolluting.ShouldBeTrue();
  
  It should_be_idling = () =&gt;
    vehicle.RevCount.ShouldBeBetween(0, 1000);
  
  static Car vehicle;
}

public class when_a_motorbike_is_started
{
  Establish context = () =&gt;
    vehicle = new Motorbike();
  
  Because of = () =&gt;
    vehicle.StartEngine();
  
  It should_have_a_running_engine = () =&gt;
    vehicle.IsEngineRunning.ShouldBeTrue();

  It should_have_a_running_engine = () =&gt;
    vehicle.IsEngineRunning.ShouldBeTrue();

  It should_be_polluting_the_atmosphere = () =&gt;
    vehicle.IsPolluting.ShouldBeTrue();

  It should_be_idling = () =&gt;
    vehicle.RevCount.ShouldBeBetween(0, 1000);
  
  static Motorbike vehicle;
}
</pre>

Those are our specs, there&#8217;s not much in there but already you can see that we&#8217;ve got duplication. Our two contexts contain identical specs, they&#8217;re the same in what they&#8217;re verifying, the only difference is the vehicle instance. This is where behaviours can come in handy.

With behaviours we can extract the specs and make them reusable. Lets do that.

Create a class for your behaviour and adorn it with the `Behaviors` attribute &mdash; this ensures MSpec recognises your class as a behaviour definition and not just any old class &mdash; then move your specs into it.

<pre>[Behaviors]
public class VehicleThatHasBeenStartedBehaviors
{
  protected static IVehicle vehicle;
  
  It should_have_a_running_engine = () =&gt;
    vehicle.IsEngineRunning.ShouldBeTrue();

  It should_have_a_running_engine = () =&gt;
    vehicle.IsEngineRunning.ShouldBeTrue();

  It should_be_polluting_the_atmosphere = () =&gt;
    vehicle.IsPolluting.ShouldBeTrue();

  It should_be_idling = () =&gt;
    vehicle.RevCount.ShouldBeBetween(0, 1000);
}
</pre>

We&#8217;ve now got our specs in the behaviour, and have defined a field for the vehicle instance itself (it won&#8217;t compile otherwise). This is our behaviour complete, it defines a set of specifications that verify that a particular behaviour.

Lets hook that behaviour into our contexts from before:

<pre>public class when_a_car_is_started
{
  Establish context = () =&gt;
    vehicle = new Car();
  
  Because of = () =&gt;
    vehicle.StartEngine();
  
  Behaves_like&lt;VehicleThatHasBeenStartedBehaviors&gt; a_started_vehicle;
  
  protected static Car vehicle;
}

public class when_a_motorbike_is_started
{
  Establish context = () =&gt;
    vehicle = new Motorbike();
  
  Because of = () =&gt;
    vehicle.StartEngine();
  
  Behaves_like&lt;VehicleThatHasBeenStartedBehaviors&gt; a_started_vehicle;
  
  protected static Motorbike vehicle;
}
</pre>

We&#8217;ve now put to use the `Behaves_like` feature, which references our behaviour class and imports the specs into the current context. Now when you run your specs, the specs from our behaviour are imported and run in each context. We don&#8217;t need to assign anything to that field, just defining it is enough; the name you choose for the field is what&#8217;s used by MSpec as the description for what your class is behaving like. In our case this is translated roughly to _&#8220;when a motorbike is started it behaves like a started vehicle&#8221;_.

There are a couple of things you need to be aware of to get this to work: your fields must be `protected`, both in the behaviour and the contexts; and the fields must have identical names. If you don&#8217;t get these two correct your behaviour won&#8217;t be hooked up properly. It&#8217;s also good to know that the fields **do not** need to have the same type, as long as the value from your context is assignable to the field in the behaviour then you&#8217;re good; this is key to defining reusable specs for classes that share a sub-set of functionality.

In short, behaviours are an excellent way of creating reusable specs for shared functionality, without the need to create complex inheritance structures. It&#8217;s not a feature you should use lightly, as it can greatly reduce the readability of your specs, but it is a good feature if you&#8217;ve got a budding spec explosion nightmare on your hands.