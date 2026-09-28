---
wordpress_id: 251
title: SystemTime versus ISystemClock – dependencies revisited
date: 2008-11-09T18:11:32+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/11/09/systemtime-versus-isystemclock-dependencies-revisited.aspx
dsq_thread_id:
  - "264851397"
categories:
  - Design
  - Testing
redirect_from: "/blogs/jimmy_bogard/archive/2008/11/09/systemtime-versus-isystemclock-dependencies-revisited.aspx/"
---
Yes, it’s true, I’m a big fan of the Dependency Inversion Principle and Dependency Injection.&#160; Scandalous!&#160; But there are some situations where DI can make your classes…rather interesting.

In one recent example, we needed to model an Occupation.&#160; A person living at a certain location for a certain time period represented an Occupation.&#160; In this system, a person could have occupied many locations, so many Occupations will have end dates.&#160; However, the current Occupation won’t have an end date.&#160; It would look something like this:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Occupation
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">DateTime </span>StartDate { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">DateTime</span>? EndDate { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

Obviously there is some other information like Location.&#160; But suppose we now want to calculate the length of stay for a given Occupation.&#160; Things work well when the person doesn’t occupy that location any more, but what if they still live there?&#160; We’ll need to go off of the current date.

Which brings us to our first problem.&#160; In .NET, this would be mean a call to DateTime.Now.&#160; But to write unit tests around this behavior, we’ll need to supply dummy values for DateTime.Now.&#160; Which isn’t really possible.

One option we have is to build something like this:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">ISystemClock
</span>{
    <span style="color: #2b91af">DateTime </span>GetCurrentTime();
}</pre>

[](http://11011.net/software/vspaste)

Better, now we have a place to supply a substitute.&#160; But do we need to give the Occupation the ISystemClock?&#160; Do we pass in the ISystemClock in the LengthOfStay method?&#160; That’s a little awkward.&#160; Now callers have to have this dependency ready and available, as opposed to it being injected by an IoC container.&#160; What tends to happen is the ISystemClock dependency becomes a little weed in our system, invading lots of places we really didn’t intend, but we need it because something underneath needs it.

The benefits are we get to see the explicit dependency, but it’s rather annoying as it’s just a dumb wrapper around DateTime.Now.&#160; Which really isn’t a dependency on a type, but a function.&#160; DateTime.Now is a static function that does some work underneath to do whatever, but it’s a function that returns a DateTime.

That’s where [Ayende’s SystemTime](http://ayende.com/Blog/archive/2008/07/07/Dealing-with-time-in-tests.aspx) comes into play – it exposes DateTime.Now as an instance of a function, that can be replaced in tests:

<pre><span style="color: blue">public static class </span><span style="color: #2b91af">SystemTime
</span>{
    <span style="color: blue">public static </span><span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">DateTime</span>&gt; Now = () =&gt; <span style="color: #2b91af">DateTime</span>.Now;
}</pre>

[](http://11011.net/software/vspaste)

If I want to replace SystemTime.Now in a test, it’s easy to do:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_calculate_length_of_stay_from_today_when_still_occupied()
{
    <span style="color: blue">var </span>startDate = <span style="color: blue">new </span><span style="color: #2b91af">DateTime</span>(2008, 10, 1);
    <span style="color: #2b91af">SystemTime</span>.Now = () =&gt; <span style="color: blue">new </span><span style="color: #2b91af">DateTime</span>(2008, 10, 5);

    <span style="color: blue">var </span>occupation = <span style="color: blue">new </span><span style="color: #2b91af">Occupation </span>{StartDate = startDate};

    occupation.LengthOfStay().ShouldEqual(4);
}</pre>

[](http://11011.net/software/vspaste)

Or, if I want to take advantage of Closures, I can set SystemTime.Now to any function that returns a DateTime:

<pre><span style="color: blue">var </span>startDate = <span style="color: blue">new </span><span style="color: #2b91af">DateTime</span>(2008, 10, 1);
<span style="color: #2b91af">SystemTime</span>.Now = () =&gt; startDate.AddDays(4);</pre>

[](http://11011.net/software/vspaste)

I don’t have to worry about SystemTime.Now being replaced in production, as other tests would fail if it were replaced.&#160; But the aspect I like the most about this approach is it’s both testable and elegant.&#160; I don’t have to litter the codebase with a system clock dependency, or worse, a DateTime holding the current date.&#160; I also don’t need to create a stub just for testing.&#160; There are advantages to an explicit ISystemClock dependency, but it still seems strange that I have to introduce constructor dependencies on what is essentially a dependency on a function.