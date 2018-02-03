---
wordpress_id: 32
title: 'Programming Basics: The for loop can do more than increment an integer'
date: 2009-06-12T18:50:00+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2009/06/12/programming-basics-the-for-loop-can-do-more-than-increment-an-integer.aspx
dsq_thread_id:
  - "262055655"
categories:
  - Uncategorized
---
This is one of those small things that is easy to forget.&nbsp; Usually when we use a for loop, we&#8217;ll just incrment over an integer so that we can get a specific item out of some iteration.&nbsp; But you can do much more than that.&nbsp; My current project has a complicated scheduling component and I&#8217;m often working with a range of dates.&nbsp; I often need to do something with the days between two dates.&nbsp; I created a TimePeriod class that is created with a start and end date.

public class TimePeriod  
&nbsp;&nbsp;&nbsp; {  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; private readonly DateTime _start;  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; private readonly DateTime _end;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public TimePeriod(DateTime start, DateTime end)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _start = start;  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _end = end;  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &#8230;

}

Now what I need to do is iterate over all of the days that are between these two dates.&nbsp; I was struggling with this for a while, trying get a clean implementation.&nbsp; Then I remembered that the for loop could do this for me.&nbsp; Instead of using the standard i++ of the loop action, I add a day to the iteration variable.&nbsp; Now I can get every day between the start and end date.

public IEnumerable<DateTime> DaysInPeriod()  
{  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for(var d = \_start; d <= \_end; d = d.AddDays(1))  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; yield return d;  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }  
}

Once I had this in place, I was able to put on some more convenience methods to cut down on some repetitive tasks I was performing.

public bool Contains(DateTime dateTime)  
{  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return DaysInPeriod().Contains(dateTime);  
}

public bool ContainsTheDayOfWeek(DayOfWeek dayOfWeek)  
{  
&nbsp;&nbsp;&nbsp;&nbsp; return DaysInPeriod().Any(d => d.DayOfWeek == dayOfWeek);&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   
}

This was nothing Earth shattering, but a real simple abstraction made my life a lot easier.

&nbsp;

&nbsp;