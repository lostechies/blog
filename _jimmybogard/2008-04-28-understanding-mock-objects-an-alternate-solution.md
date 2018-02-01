---
id: 174
title: 'Understanding Mock Objects: an alternate solution'
date: 2008-04-28T01:27:53+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/04/27/understanding-mock-objects-an-alternate-solution.aspx
dsq_thread_id:
  - "264715651"
categories:
  - Testing
---
In [AzamSharp&#8217;s](http://geekswithblogs.net/AzamSharp/Default.aspx) recent post [Understanding Mock Objects](http://geekswithblogs.net/AzamSharp/archive/2008/04/27/121695.aspx), he poses a problem of testing with volatile data.&nbsp; His example extends on [an article on AspAlliance](http://aspalliance.com/1400_Beginning_to_Mock_with_Rhino_Mocks_and_MbUnit__Part_1.all), which exhibits the same problems with its solution.&nbsp; Suppose I have an image service that returns images based on the time of day:

<pre><span style="color: blue">public static class </span><span style="color: #2b91af">ImageOfTheDayService
</span>{
    <span style="color: blue">public static string </span>GetImage(<span style="color: #2b91af">DateTime </span>dt)
    {
        <span style="color: blue">int </span>hour = dt.Hour;

        <span style="color: blue">if </span>(hour &gt; 6 && hour &lt; 21) <span style="color: blue">return </span><span style="color: #a31515">"sun.jpg"</span>;

        <span style="color: blue">return </span><span style="color: #a31515">"moon.jpg"</span>;
    }
}
</pre>

[](http://11011.net/software/vspaste)

The initial test uses the current date and time to perform the test:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>should_return_sun_image_when_it_is_day_time()
{
    <span style="color: blue">string </span>imageName = <span style="color: #2b91af">ImageOfTheDayService</span>.GetImage(<span style="color: #2b91af">DateTime</span>.Now);
    <span style="color: #2b91af">Assert</span>.AreEqual(imageName, <span style="color: #a31515">"sun.jpg"</span>);
}
</pre>

[](http://11011.net/software/vspaste)

Since DateTime.Now is non-deterministic, this test will pass only some of the time, and will at other times.&nbsp; The problem is that this test has a dependency on the system clock.&nbsp; AzamSharp&#8217;s solution to this problem was to create an interface to wrap DateTime:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IDateTime
</span>{
    <span style="color: blue">int </span>GetHour();
}
</pre>

[](http://11011.net/software/vspaste)

Now the ImageOfTheDayService uses IDateTime to determine the hour:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>MOCKING_should_return_night_image_when_it_is_night_time()
{
    <span style="color: blue">var </span>mock = <span style="color: blue">new </span>Mock&lt;<span style="color: #2b91af">IDateTime</span>&gt;();
    mock.Expect(e =&gt; e.GetHour()).Returns(21); <span style="color: green">// 9:00 PM

    </span><span style="color: #2b91af">Assert</span>.AreEqual(<span style="color: #a31515">"moon.jpg"</span>, <span style="color: #2b91af">ImageOfTheDayService</span>.GetImage(mock.Object));
}
</pre>

[](http://11011.net/software/vspaste)

I _really_ don&#8217;t like this solution, as **the test had the external non-deterministic dependency**, not the image service.

### Alternative solution

Here&#8217;s another solution that doesn&#8217;t use mocks, and keeps the original DateTime parameter:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>should_return_night_image_when_it_is_night_time()
{
    <span style="color: #2b91af">DateTime </span>nightTime = <span style="color: blue">new </span><span style="color: #2b91af">DateTime</span>(2000, 1, 1, 0, 0, 0);

    <span style="color: blue">string </span>imageName = <span style="color: #2b91af">ImageOfTheDayService</span>.GetImage(nightTime);
    <span style="color: #2b91af">Assert</span>.AreEqual(imageName, <span style="color: #a31515">"moon.jpg"</span>);
}
</pre>

[](http://11011.net/software/vspaste)

Note that I eliminated the dependency on the system clock by simply creating a DateTime that represents &#8220;night time&#8221;.&nbsp; Another test creates a &#8220;day time&#8221; DateTime, and perhaps more to fill in edge cases.&nbsp; Instead of creating an interface to wrap something that didn&#8217;t need fixing, we used DateTime exactly how they were designed.&nbsp; DateTime.Now is not the only way to create a DateTime object.

Solving a non-deterministic test with mocks only works when it&#8217;s the component under test that has the non-deterministic dependencies.&nbsp; In the example AzamSharp&#8217;s example, it was the test, and not the component that had the non-deterministic dependency.&nbsp; Creating the DateTime using its constructor led to both a more readable test and a more cohesive interface for the image service.

It&#8217;s easy to believe everything is a nail if all you want to use is that shiny hammer.&nbsp; Keep in mind the purpose of mocks: to verify the indirect inputs and outputs of a component, not to fix every [erratic test](http://xunitpatterns.com/Erratic%20Test.html) under the sun.