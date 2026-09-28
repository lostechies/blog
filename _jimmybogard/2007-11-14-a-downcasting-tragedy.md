---
wordpress_id: 100
title: A downcasting tragedy
date: 2007-11-14T22:34:54+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/11/14/a-downcasting-tragedy.aspx
dsq_thread_id:
  - "264715422"
categories:
  - LegacyCode
  - Testing
redirect_from: "/blogs/jimmy_bogard/archive/2007/11/14/a-downcasting-tragedy.aspx/"
---
And now, for another tale of legacy code woe, here&#8217;s a gut-wrenching tragedy of [OCP](http://www.objectmentor.com/resources/articles/ocp.pdf) and [downcasting](http://www.vsj.co.uk/articles/display.asp?id=473), in [five acts](http://en.wikipedia.org/wiki/Dramatic_structure).

### Exposition

We have a feature we&#8217;re implementing that&nbsp;when the store&#8217;s configuration settings allow for a survey link to be shown, it should show up, otherwise, it shouldn&#8217;t.&nbsp; We put these settings in&nbsp;a simple interface (cut down for brevity):

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">interface</span> ISettings
{
    <span class="kwrd">bool</span> ShowSurvey { get; }
}
</pre>
</div>

Settings can come from many places, such as configuration files, database, or web service.&nbsp; This is a pretty nice example of OCP, as our app is open for extension for different &#8220;ISettings&#8221; implementations, but closed for modification as someone can&#8217;t decide&nbsp;to&nbsp;use something&nbsp;else besides &#8220;ISettings&#8221;.&nbsp; Since we have an interface, the source doesn&#8217;t matter.

We manage access to the settings through a static class:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">class</span> StoreContext
{
    <span class="kwrd">public</span> <span class="kwrd">static</span> ISettings Settings { get; set; }
}
</pre>
</div>

Actual instances are set during early in the ASP.NET pipeline, so later stages have that information.&nbsp; The original&nbsp;ISettings implementations are stored in ASP.NET Session.

Now, we need to provide functional and regression tests for this feature, using Selenium.

### Rising action

To help with functional and regression tests, I&#8217;m employing the record and playback state technique I [mentioned earlier](http://grabbagoft.blogspot.com/2007/11/record-and-playback-state-in-aspnet.html).&nbsp; I create an &#8220;ISettings&#8221; implementation that can be serialized and deserialized into XML, which helps when I want to manually edit the settings:

<div class="CodeFormatContainer">
  <pre>[XmlRoot(<span class="str">"Settings"</span>)]
<span class="kwrd">public</span> <span class="kwrd">class</span> SettingsDto : ISettings
{
    <span class="kwrd">public</span> SettingsDto() { }

    <span class="kwrd">public</span> SettingsDto(ISettings settings)
    {
        ShowSurvey = settings.ShowSurvey;
    }

    <span class="kwrd">public</span> <span class="kwrd">bool</span> ShowSurvey { get; set; }
}
</pre>
</div>

My &#8220;download.aspx&#8221; page combines both the cart and the settings information into a single [DTO](http://martinfowler.com/eaaCatalog/dataTransferObject.html), and streams this file to the client.&nbsp; In my &#8220;replay.aspx&#8221;&nbsp;page, I take the XML, deserialize it, and put it into Session.&nbsp; Finally, I redirect to the &#8220;shoppingcart.aspx&#8221; page, which pulls the ISettings implementation out of Session and sets the StoreContext variable to my deserialized SettingsDto instance.

This is all fairly straightforward, and I&#8217;m pretty happy about this solution as I can now plug in any settings I like and verify the results through automated tests.&nbsp; As it&nbsp;is with all legacy code, things just aren&#8217;t that simple.

### Climax

Running the code the first time, downloading and replaying goes smoothly, and all of my values are serialized and deserialized properly as my unit tests prove.&nbsp; However, when I get redirected to the &#8220;shoppingcart.aspx&#8221; page, I get a distressing exception:

> <pre>System.InvalidCastException:
  Unable to cast object of type 'BusinessObjects.SettingsDto'
  to type 'BusinessObjects.DbSettings'.</pre>

The dreaded invalid cast exception, something is making some really bad assumptions and killing my code.

### Falling action

Just when I thought I was making progress, the InvalidCastException came up and crushed my dreams.&nbsp; Looking at the stack trace, I see that my the exception is coming from the base Page class that all pages in our app derive from.&nbsp; Here&#8217;s the offending code:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">abstract</span> <span class="kwrd">class</span> StorePage : Page
{
    <span class="kwrd">protected</span> DbSettings Settings
    {
        get { <span class="kwrd">return</span> (DbSettings)StoreContext.Settings; }
    }
}
</pre>
</div>

A convenience property on the base class allowed derived classes to get at the static ISettings instance.&nbsp; But on closer inspection, this property is _downcasting_ the ISettings instance coming out of StoreContext to DbSettings.&nbsp; Downcasting is when you cast to a derived type from an instance of a base type.&nbsp; That&#8217;s a fairly large assumption to make, though.&nbsp; How do I know for sure that the instance is really the derived type, and not some other derived type of the base type?&nbsp; I can&#8217;t guarantee that assumption holds, as this example shows.

To make things worse, it explicitly casts instead of using the C# [&#8220;as&#8221; operator](http://msdn2.microsoft.com/en-us/library/cscsdfbt(VS.71).aspx) ([TryCast](http://msdn2.microsoft.com/en-us/library/zyy863x8(VS.80).aspx) for VB.NET folks).&nbsp; At least then it won&#8217;t fail when trying to downcast, it would just be null.&nbsp; Using the &#8220;as&#8221; operator is perfectly acceptable as a means of downcasting.&nbsp; I try to avoid it, as it can be a smell of [Inappropriate Intimacy](http://c2.com/cgi/wiki?InappropriateIntimacy).

Because the code assumes that the ISettings instance is _actually seriously for realz_ a DbSettings instance, I can never take advantage of OCP and swap out different &#8220;ISettings&#8221; implementations.&nbsp; Quite depressing.

### Denouement

As an experiment, and because I have a nice automated build process, I can just try to change the type referenced in the StorePage class to ISettings instead of DbSettings.&nbsp; Luckily, the build succeeded and I kept the change.

If it had failed and clients absolutely needed DbSettings, I might have to look at pushing up methods to the ISettings interface, if it&#8217;s possible.&nbsp; If I have access to ISettings that is.&nbsp; If I don&#8217;t, well, I&#8217;m hosed, and my denouement would turn into a catastrophe.

The moral of this story is:

**Avoid downcasting, as it makes potentially false assumptions about the underlying type of an object.&nbsp; Use the &#8220;as&#8221; operator instead, and perform null checking to determine if the downcasting succeeded or not.&nbsp; We can then perform safe downcasting and avoid using exceptions as flow control.**