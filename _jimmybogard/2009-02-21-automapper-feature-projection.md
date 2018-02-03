---
wordpress_id: 286
title: 'AutoMapper feature: projection'
date: 2009-02-21T21:54:22+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/02/21/automapper-feature-projection.aspx
dsq_thread_id:
  - "264716080"
categories:
  - AutoMapper
---
I’m slowly filling in documentation for [AutoMapper](http://www.codeplex.com/AutoMapper), which is turning out to be exactly as much fun as I estimated.

### Projection

Projection transforms a source to a destination beyond flattening the object model.&#160; Without extra configuration, AutoMapper requires a flattened destination to match the source type&#8217;s naming structure.&#160; When you want to project source values into a destination that does not exactly match the source structure, you must specify custom member mapping definitions.&#160; For example, we might want to turn this source structure:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CalendarEvent
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">DateTime </span>EventDate { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>Title { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

Into something that works better for an input form on a web page: 

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CalendarEventForm
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">DateTime </span>EventDate { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public int </span>EventHour { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public int </span>EventMinute { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>Title { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

Because the names of the destination properties do not exactly match up to the source property (CalendarEventForm.EventDate would need to be CalendarEventForm.EventDateDate), we need to specify custom member mappings in our type map configuration: 

<pre><span style="color: green">// Model
</span><span style="color: blue">var </span>calendarEvent = <span style="color: blue">new </span><span style="color: #2b91af">CalendarEvent
    </span>{
        EventDate = <span style="color: blue">new </span><span style="color: #2b91af">DateTime</span>(2008, 12, 15, 20, 30, 0),
        Title = <span style="color: #a31515">"Company Holiday Party"
    </span>};

<span style="color: green">// Configure AutoMapper
</span><span style="color: #2b91af">Mapper</span>.CreateMap&lt;<span style="color: #2b91af">CalendarEvent</span>, <span style="color: #2b91af">CalendarEventForm</span>&gt;()
    .ForMember(dest =&gt; dest.EventDate, opt =&gt; opt.MapFrom(src =&gt; src.EventDate.Date))
    .ForMember(dest =&gt; dest.EventHour, opt =&gt; opt.MapFrom(src =&gt; src.EventDate.Hour))
    .ForMember(dest =&gt; dest.EventMinute, opt =&gt; opt.MapFrom(src =&gt; src.EventDate.Minute));

<span style="color: green">// Perform mapping
</span><span style="color: #2b91af">CalendarEventForm </span>form = <span style="color: #2b91af">Mapper</span>.Map&lt;<span style="color: #2b91af">CalendarEvent</span>, <span style="color: #2b91af">CalendarEventForm</span>&gt;(calendarEvent);

form.EventDate.ShouldEqual(<span style="color: blue">new </span><span style="color: #2b91af">DateTime</span>(2008, 12, 15));
form.EventHour.ShouldEqual(20);
form.EventMinute.ShouldEqual(30);
form.Title.ShouldEqual(<span style="color: #a31515">"Company Holiday Party"</span>);</pre>

[](http://11011.net/software/vspaste)

The each custom member configuration uses an action delegate to configure each member.&#160; In the above example, we used the MapFrom option to perform custom source/destination member mappings.&#160; The MapFrom method takes a lambda expression as a parameter, which then evaluated later during mapping.&#160; The MapFrom expression can be any Func<TSource, object> lambda expression.