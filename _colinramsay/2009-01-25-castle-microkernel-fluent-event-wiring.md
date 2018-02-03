---
wordpress_id: 4692
title: Castle MicroKernel Fluent Event Wiring
date: 2009-01-25T06:32:00+00:00
author: Colin Ramsay
layout: post
wordpress_guid: /blogs/colin_ramsay/archive/2009/01/25/castle-microkernel-fluent-event-wiring.aspx
categories:
  - 'C#'
  - microkernel
  - windsor
---
The Castle MicroKernel Registration API is also used in Windsor, and both have a facility to allow a components to subscribe to events exposed by each other. Right now, the only way to use the fluent API to configure the facility is to go right down and build the configuration nodes (taken from <http://blogger.forgottenskies.com/?p=266>):

<textarea name="code">container.Register(Component.For<PublisherClass>()<br /> .Configuration(Child.ForName(&#8220;subscribers&#8221;)<br /> .Eq(<br /> Child.ForName(&#8220;subscriber&#8221;).Eq(<br /> Attrib.ForName(&#8220;id&#8221;).Eq(&#8220;Subscriber&#8221;),<br /> Attrib.ForName(&#8220;event&#8221;).Eq(&#8220;Published&#8221;),<br /> Attrib.ForName(&#8220;handler&#8221;).Eq(&#8220;OnPublish&#8221;)<br /> ),<br /> Child.ForName(&#8220;subscriber&#8221;).Eq(<br /> Attrib.ForName(&#8220;id&#8221;).Eq(&#8220;Subscriber&#8221;),<br /> Attrib.ForName(&#8220;event&#8221;).Eq(&#8220;Published&#8221;),<br /> Attrib.ForName(&#8220;handler&#8221;).Eq(&#8220;OnPublish&#8221;)<br /> ),<br /> )<br /> )<br /> );<br /> </textarea>

This works fine, but it&#8217;s a little verbose for my liking. I&#8217;ve managed to get it down to:

<textarea name="code">container.Register(Component.For<PublisherClass>()<br /> .Subscribers(<br /> Subscriber.ForComponent(&#8220;Subscriber&#8221;, &#8220;Published&#8221;, &#8220;OnPublish&#8221;),<br /> Subscriber.ForComponent(&#8220;Subscriber&#8221;, &#8220;Published&#8221;, &#8220;OnPublish&#8221;)<br /> )<br /> );<br /> </textarea>

Much nicer! In effect all I&#8217;ve done is abstract away the building of the configuration nodes. Firstly I have a Subscriber class:

<textarea name="code">public class Subscriber<br /> {<br /> public class SubscriberInfo<br /> {<br /> public string Id { get; set; }<br /> public string EventName { get; set; }<br /> public string HandlerMethodName { get; set; }<br /> }<br /> public static SubscriberInfo ForComponent(string id, string eventName, string handlerMethodName)<br /> {<br /> return new SubscriberInfo{Id = id, EventName = eventName, HandlerMethodName = handlerMethodName};<br /> }<br /> }<br /> </textarea>

Then the actual business end of things is the Extension method which allows me to use this:

<textarea name="code">public static class EventWiringFacilityRegistrationExtensions<br /> {<br /> public static ComponentRegistration<S> Subscribers<S>(this ComponentRegistration<S> componentRegistration, params Subscriber.SubscriberInfo[] subscribers)<br /> {<br /> var subscriberNodes = from s in subscribers select<br /> Child.ForName(&#8220;subscriber&#8221;)<br /> .Eq(<br /> Attrib.ForName(&#8220;id&#8221;).Eq(s.Id),<br /> Attrib.ForName(&#8220;event&#8221;).Eq(s.EventName),<br /> Attrib.ForName(&#8220;handler&#8221;).Eq(s.HandlerMethodName)<br /> );<br /> var subs = Child.ForName(&#8220;subscribers&#8221;).Eq(subscriberNodes.ToArray());<br /> return componentRegistration.AddDescriptor(new ConfigurationDescriptor<S>(subs));<br /> }<br /> }<br /> </textarea>

As you can see, I&#8217;m just pulling out the data from the SubscriberInfo array and building up the configuration nodes. These are then passed to a ConfigurationDescriptor which is where the real business happens. Writing a custom descriptor would probably make for a more elegant solution, so if anyone&#8217;s got any suggestions then I&#8217;m all ears. When I work out how to write a test for this behaviour I&#8217;ll try and sort out a Castle patch.