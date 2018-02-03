---
wordpress_id: 176
title: 'Model Binding isn&#8217;t just for the web'
date: 2012-10-19T13:00:06+00:00
author: Josh Arnold
layout: post
wordpress_guid: http://lostechies.com/josharnold/?p=176
dsq_thread_id:
  - "891702501"
categories:
  - general
---
It&#8217;s a given that your web framework of choice has some form of model binding built-in. Maybe you&#8217;re lucky enough to have Content Negotation on top of that but regardless, there is some mechanism to transform the incoming HTTP message to a well-formed type for you to consume.

When I first started using these binding mechanisms, I found myself asking a few questions:

  * Is there a way to extend the standard converters?
  * Is there any easy way to distribute common extensions?

Frameworks at the time were working to answer those questions and that was fine. But then I started to wonder some more:

  * What if we could do conversions more conventionally?
  * What about common practices with value types?
  * How about we bind common properties via some known service for testing (e.g., CurrentDate, CurrentUser)?

You&#8217;re probably thinking that this the part where I do my obligatory plug for Fubu. Well, you&#8217;re absolutely right.

## Model Binding in Fubu

Most people are not aware of the separation between FubuMVC and FubuCore. That is, they hear about something in the world of Fubu and think that they would only be able to leverage it if they were using the whole stack. Well, that&#8217;s just not true and plenty users of HtmlTags would tell you all about it. I say this because Model Binding just happens to be another gem that is found in FubuCore.

Our binding uses the notion of a source of values (aka IValueSource). My common explanation for this is: &#8220;Imagine if you iterated over your design a few times going from a dictionary, to a value type, abstracted that, and then made everything compatible with testing and diagnostics&#8221;. That would be IValueSource.

So, why do you care? And why is this applicable outside of the web? Let&#8217;s look at some example IValueSource implementations:

#### Web

This one&#8217;s a no-brainer. There are value sources in FubuMVC that make route and request data available to the binder.

#### Settings

This one is a favorite that I take for granted. Settings data can come from anywhere (app/web config, database, etc.). You can adapt that information into an IValueSource (we have common structures for this &#8212; including a generic dictionary version) and feed it into the binding.  This makes complex property settings easily possible (e.g., MySettings.NestedObject.Name = &#8220;Test&#8221;)

#### Comma-Separated-Values

That&#8217;s right. Everyone&#8217;s favorite integration technique is something that&#8217;s supported OOTB in FubuCore. You can map your DTO classes using a FluentHibernate-esque column mapping and pull out your objects through the model binding subsystem to give you ultimate flexibility in your parsing.

#### Other examples I&#8217;ve seen

I&#8217;ve seen teams write custom rule engines that serialize data into dictionary-like formats for NoSQL storage and then pass the values back through model binding to execute the rules. I&#8217;ve also seen similar techniques used for widget-crazy-dashboards.

## If you take anything away from this, let it be this

Binding classes from data is a highly useful function. A binding subsystem that is configurable and DI-enabled is invaluable. If you haven&#8217;t checked out the binding in FubuCore, then I hope this will tug at your curiosity enough to make you take a look.

## Additional Resources

For further reading on how FubuCore&#8217;s model binding works and what you can do with it, I highly recommend Chad&#8217;s post:

  * <http://lostechies.com/chadmyers/2011/06/08/cool-stuff-in-fubucore-no-7-model-binding/>