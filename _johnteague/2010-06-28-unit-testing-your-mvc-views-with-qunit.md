---
wordpress_id: 3780
title: Unit Testing your MVC Views
date: 2010-06-28T14:23:00+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2010/06/28/unit-testing-your-mvc-views-with-qunit.aspx
dsq_thread_id:
  - "262076893"
categories:
  - Uncategorized
redirect_from: "/blogs/johnteague/archive/2010/06/28/unit-testing-your-mvc-views-with-qunit.aspx/"
---
{% raw %}
The story around testing your UI JavaScript is getting better and better.&nbsp; I&rsquo;ve been using QUnit for a couple of years and it&rsquo;s not hard to to test individual components of your UI.&nbsp; One thing that has always bothered me is that a typical testing setup is to have part of your html markup in your test page that you run your tests against.&nbsp; This is obviously not very DRY and I tend to refactor my HTML frequently while working, getting closer to semantic markup style and constantly cleaning up and fine tuning the UI.

What I really wanted was to render my actual markup in my test file and run my tests against that.&nbsp; Since all of my views are strongly typed, it would be cool if I could create test data and inject that into the rendered HTML too.&nbsp; That way I can test the view logic as well.

It turned out not to be too hard to do this.&nbsp; I created an HTMLHelper extension called RenderViewUnderTest.&nbsp; It takes a controller name, a view name and a view model you want passed in.&nbsp; It will then render the view action with the test data within your test page.&nbsp; It&rsquo;s a hybrid between the RenderAction and RenderPartial methods currently available.

Here is some sample usage.

<pre style="background-color: #e5e5e5;width: 650px;overflow: auto;border: #cecece 1px solid;padding: 5px"><pre style="background-color: #e5e5e5;margin: 0em;width: 100%;font-family: consolas,'Courier New',courier,monospace;font-size: 12px">&lt;div id="<span style="color: #8b0000">as-a-user</span>"&gt;
</pre>


<pre style="background-color: #e5e5e5;margin: 0em;width: 100%;font-family: consolas,'Courier New',courier,monospace;font-size: 12px"> &lt;%
</pre>


<pre style="background-color: #e5e5e5;margin: 0em;width: 100%;font-family: consolas,'Courier New',courier,monospace;font-size: 12px">   var data = <span style="color: #0000ff">new</span> TimeCardViewModel()
</pre>


<pre style="background-color: #e5e5e5;margin: 0em;width: 100%;font-family: consolas,'Courier New',courier,monospace;font-size: 12px">                  {
</pre>


<pre style="background-color: #e5e5e5;margin: 0em;width: 100%;font-family: consolas,'Courier New',courier,monospace;font-size: 12px"></pre>


<pre style="background-color: #e5e5e5;margin: 0em;width: 100%;font-family: consolas,'Courier New',courier,monospace;font-size: 12px">                    CanEdit = <span style="color: #0000ff">true</span>,
</pre>


<pre style="background-color: #e5e5e5;margin: 0em;width: 100%;font-family: consolas,'Courier New',courier,monospace;font-size: 12px">                    DateSelected = DateTime.Today,
</pre>


<pre style="background-color: #e5e5e5;margin: 0em;width: 100%;font-family: consolas,'Courier New',courier,monospace;font-size: 12px">                    UsersList = <span style="color: #0000ff">new</span>[] { <span style="color: #0000ff">new</span> SelectListItem { Text = "<span style="color: #8b0000">User</span>", Value = "<span style="color: #8b0000">1</span>" } },
</pre>


<pre style="background-color: #e5e5e5;margin: 0em;width: 100%;font-family: consolas,'Courier New',courier,monospace;font-size: 12px">                    TimeCardHistory = <span style="color: #0000ff">new</span>[]{<span style="color: #0000ff">new</span> TimeCardHistoryDto{ClockedDateTime = DateTime.Today.AddHours(6),Event = TimeCardEvent.StartOfDay,TimeCardEntryId = 1,UserId = 1}, 
</pre>


<pre style="background-color: #e5e5e5;margin: 0em;width: 100%;font-family: consolas,'Courier New',courier,monospace;font-size: 12px">                                              <span style="color: #0000ff">new</span> TimeCardHistoryDto{ClockedDateTime = DateTime.Today.AddHours(12),Event = TimeCardEvent.StartOfLunch,TimeCardEntryId = 2,UserId = 1}, 
</pre>


<pre style="background-color: #e5e5e5;margin: 0em;width: 100%;font-family: consolas,'Courier New',courier,monospace;font-size: 12px">                                              <span style="color: #0000ff">new</span> TimeCardHistoryDto{ClockedDateTime = DateTime.Today.AddHours(12).AddMinutes(30),Event = TimeCardEvent.EndOfLunch,TimeCardEntryId = 3,UserId = 1}, 
</pre>


<pre style="background-color: #e5e5e5;margin: 0em;width: 100%;font-family: consolas,'Courier New',courier,monospace;font-size: 12px">                                              <span style="color: #0000ff">new</span> TimeCardHistoryDto{ClockedDateTime = DateTime.Today.AddHours(18).AddMinutes(30),Event = TimeCardEvent.EndOfDay,TimeCardEntryId = 4,UserId = 1}}
</pre>


<pre style="background-color: #e5e5e5;margin: 0em;width: 100%;font-family: consolas,'Courier New',courier,monospace;font-size: 12px"></pre>


<pre style="background-color: #e5e5e5;margin: 0em;width: 100%;font-family: consolas,'Courier New',courier,monospace;font-size: 12px">                  };
</pre>


<pre style="background-color: #e5e5e5;margin: 0em;width: 100%;font-family: consolas,'Courier New',courier,monospace;font-size: 12px"> %&gt;
</pre>


<pre style="background-color: #e5e5e5;margin: 0em;width: 100%;font-family: consolas,'Courier New',courier,monospace;font-size: 12px"> &lt;%= Html.RenderViewUnderTest("<span style="color: #8b0000">TimeCard</span>", "<span style="color: #8b0000">Index</span>", data) %&gt;
</pre>


<pre style="background-color: #e5e5e5;margin: 0em;width: 100%;font-family: consolas,'Courier New',courier,monospace;font-size: 12px"> &lt;%=Html.Script("~/Scripts/<span style="color: #8b0000">Tests/TimeCardTests</span>") %&gt;
</pre>


<pre style="background-color: #e5e5e5;margin: 0em;width: 100%;font-family: consolas,'Courier New',courier,monospace;font-size: 12px">&lt;/div&gt;</pre>


<p>
  Now you can run test this with your favorite JavaScript testing framework.
</p>


<h2>
  Some Caveats
</h2>


<p>
  I really consider this to be more of a proof of concept than a finished library.&nbsp; Probably the biggest issue most people will have with this is that your test scripts live with your application.&nbsp; The way the VirtualPathProvider in the built in view engine works really expects them to be in the same project.&nbsp; I think it is possible to create a new PathProvider to overcome this, but it honestly doesn&rsquo;t bother me enough to work on it.&nbsp; In my project, I have one Controller and one route to handle tests and the rest is in the View folder.&nbsp; My deployment script simply ignores Views/Tests folder so they don&rsquo;t go to production.
</p>


<p>
  While I&rsquo;ve spiked this out and done some very complicated UI tests (drag and drop, micro templating, lots of AJAX), We have not yet incorporated this into our build or CI.&nbsp; That is something I definitely need to work on.
</p>


<p>
  More importantly, I&rsquo;ve found that my biggest problem is that I&rsquo;m not good at writing testable JavaScript.&nbsp; I&rsquo;m fixing that now, more to come.
</p>


<p>
  The source code is <a href="http://gist.github.com/421943">available here</a> if your interested.&nbsp; I want to point out that it was relatively easy to do this because the MVC source code was available for me to review and poke at.&nbsp; Like I said, I basically combined what the RenderAction and RenderPartial were doing.&nbsp; Because the source code was available I did this in about 2 hours.&nbsp; Otherwise it would have taken 3 times as long. 
</p>
{% endraw %}
