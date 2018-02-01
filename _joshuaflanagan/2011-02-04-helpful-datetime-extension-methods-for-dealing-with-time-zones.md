---
id: 3971
title: Helpful DateTime extension methods for dealing with Time Zones
date: 2011-02-04T03:29:05+00:00
author: Joshua Flanagan
layout: post
guid: /blogs/joshuaflanagan/archive/2011/02/03/helpful-datetime-extension-methods-for-dealing-with-time-zones.aspx
dsq_thread_id:
  - "262113273"
categories:
  - Uncategorized
---
This post is inspired by Scott Mitchell&#8217;s <a href="http://dotnetslackers.com/articles/aspnet/5-Helpful-DateTime-Extension-Methods.aspx" target="_blank">5 Helpful DateTime Extension Methods</a>. I built a couple extension methods while adding time zone support to our application. Since time zone math is never fun, I figure someone else may benefit from these.

### ToStartOfTimeZonesDayInUtc

The name is clunky because its really hard to describe succinctly. Given a time (in UTC) and a time zone, I want to know the time (in UTC) that the day started in that time zone. This is useful, for example, when you want to display a list of events, grouped by day, in the user&#8217;s time zone. If an event happened at 3:05am UTC on February 4th, it should be grouped in Feburary 4th when displayed to a user in Western European Time, but grouped in February 3rd for a user in Central Time (US).

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>/// &lt;summary&gt;
/// The time in UTC that the day started in the given time zone for a specific UTC time
/// &lt;/summary&gt;
/// &lt;param name="utcTime"&gt;A point in time, specified in UTC&lt;/param&gt;
/// &lt;param name="timezone"&gt;The time zone that determines when the day started&lt;/param&gt;
/// &lt;returns&gt;&lt;/returns&gt;
public static DateTime ToStartOfTimeZonesDayInUtc(this DateTime utcTime, TimeZoneInfo timezone)
{
    var startOfDayInGivenTimeZone = utcTime.ToLocalTime(timezone).Date;
    return startOfDayInGivenTimeZone.ToUniversalTime(timezone);
}</pre>
</div>

### StartOfTodayInUtc

A convenience method for determining the day, right now, in a given time zone.

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>/// &lt;summary&gt;
/// The time in UTC that the current day started in the given time zone
/// &lt;/summary&gt;
/// &lt;param name="timezone"&gt;The time zone that determines when the day started&lt;/param&gt;
/// &lt;returns&gt;&lt;/returns&gt;
public static DateTime StartOfTodayInUtc(this TimeZoneInfo timezone)
{
    return DateTime.UtcNow.ToStartOfTimeZonesDayInUtc(timezone);
}</pre>
</div>

### ToLocalTime and ToUniversalTime

These are pretty straightforward but I&#8217;ll include them because the methods above depend on them. DateTime already has ToLocalTime and ToUniversalTime methods, but they are flawed because they do not let you specify a time zone. I&#8217;m not sure why they were not added as overloads when the <a href="http://msdn.microsoft.com/en-us/library/system.timezoneinfo.aspx" target="_blank">TimeZoneInfo</a> type was introduced.

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>/// &lt;summary&gt;
/// Converts a UTC time to a time in the given time zone
/// &lt;/summary&gt;
/// &lt;param name="targetTimeZone"&gt;The time zone to convert to&lt;/param&gt;
/// &lt;param name="utcTime"&gt;The UTC time&lt;/param&gt;
/// &lt;returns&gt;&lt;/returns&gt;
public static DateTime ToLocalTime(this DateTime utcTime, TimeZoneInfo targetTimeZone)
{
    return TimeZoneInfo.ConvertTimeFromUtc(utcTime, targetTimeZone);
}

/// &lt;summary&gt;
/// Converts a local time to a UTC time
/// &lt;/summary&gt;
/// &lt;param name="sourceTimeZone"&gt;The time zone of the local time&lt;/param&gt;
/// &lt;param name="localTime"&gt;The local time&lt;/param&gt;
/// &lt;returns&gt;&lt;/returns&gt;
public static DateTime ToUniversalTime(this DateTime localTime, TimeZoneInfo sourceTimeZone)
{
    return TimeZoneInfo.ConvertTimeToUtc(localTime, sourceTimeZone);
}</pre>
</div>