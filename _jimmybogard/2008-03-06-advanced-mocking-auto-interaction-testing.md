---
wordpress_id: 152
title: 'Advanced mocking: auto-interaction testing'
date: 2008-03-06T02:44:45+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/03/05/advanced-mocking-auto-interaction-testing.aspx
dsq_thread_id:
  - "264715582"
categories:
  - LegacyCode
  - TDD
  - Testing
---
When dealing with legacy systems or those not designed with specific testability scenarios in mind, you have to test your changes in non-traditional means.&nbsp; In normal mocking (or [test double](http://xunitpatterns.com/Test%20Double.html)) scenarios, you have some kind of external dependency that you want to substitute for.

For example, you might have a OrderProcessingService that needs to send an email out when an order is completed.&nbsp; During testing, you don&#8217;t want actual emails being sent out, so you hide email sending behind an IMailSender interface, and use an imposter in its place.

But what happens when you&#8217;re working in a legacy system, or the difficult component you&#8217;re dependent upon is the class you&#8217;re testing?&nbsp; These scenarios are common when modifying legacy code, or you&#8217;re extending a third-party component or library.&nbsp; In these cases, I need to verify interactions of the class with itself, leading to auto-interaction tests.

### Modifications needed

We&#8217;re trying to extend an order processing system that was built several years ago, and has absolutely zero unit tests.&nbsp; The business has come with a request to introduce discounts to orders, and need the total to reflect the order.

To make this change, we need to create a DiscountPercentage property on the Order object, and call the UpdateTotal method when the DiscountPercentage is set:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Order
</span>{
    <span style="color: blue">private int </span>_discountPercentage;

    <span style="color: blue">public virtual void </span>UpdateTotal()
    {
        <span style="color: green">//hit database, tax service, etc.
    </span>}

    <span style="color: blue">public int </span>DiscountPercentage
    {
        <span style="color: blue">get </span>{ <span style="color: blue">return </span>_discountPercentage; }
        <span style="color: blue">set
        </span>{
             _discountPercentage = <span style="color: blue">value</span>;
            UpdateTotal();
        }
    }
}</pre>

[](http://11011.net/software/vspaste)

Now, for whatever reason, this is the exact change we have to make.&nbsp; The UpdateTotal method must be called in this architecture to update the OrderTotal on the Order object.&nbsp; Our resident system experts tell us that UpdateTotal must be called any time changes are made that could affect the OrderTotal.

Not the best architecture, but in legacy systems, we have to work with what&#8217;s given us.&nbsp; So where does the mocking come into play?

### Here come the mocks!

When we want to test the DiscountPercentage that calls the UpdateTotal method, we wind up hitting the database, the tax web service, maybe even a sherpa in Nepal.&nbsp; We could try to fake out all of these dependencies, but nothing in our Order object is built to do this.&nbsp; Additionally, there are many other places in our system that are in dire need of refactoring, so we can&#8217;t commit resources to &#8220;fix&#8221; the Order class.

Our resident system expert has assured us however, that all we need to care about is that the UpdateTotal method is called, the DiscountPercentage property will work.&nbsp; So what I&#8217;d like to do is create a test that sets the DiscountPercentage, and just makes sure that the UpdateTotal method is called.&nbsp; I don&#8217;t want the _real_ UpdateTotal method actually do its work, as it hits the database and whatnot, but just to verify that the method is called.

#### 

#### The manual way

First, I&#8217;ll try and do this without a mocking framework like [Rhino Mocks](http://www.ayende.com/projects/rhino-mocks.aspx).&nbsp; To do so, I&#8217;ll create a [test-specific subclass](http://xunitpatterns.com/Test-Specific%20Subclass.html) of the Order object:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">TestOrder </span>: <span style="color: #2b91af">Order
</span>{
    <span style="color: blue">public bool </span>UpdateTotalCalled = <span style="color: blue">false</span>;

    <span style="color: blue">public override void </span>UpdateTotal()
    {
        UpdateTotalCalled = <span style="color: blue">true</span>;
    }
}
</pre>

[](http://11011.net/software/vspaste)

I override the method interaction I&#8217;m interested in, &#8220;UpdateTotal&#8221;, and set a flag that simply checks to see if it was called.&nbsp; I also made sure I didn&#8217;t call the base method, as I don&#8217;t want to bother that sherpa.&nbsp; In my test, I&#8217;ll use the TestOrder class, and then make sure that the UpdateTotal method was called:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_update_the_total_when_applying_a_discount_the_manual_way()
{
    <span style="color: #2b91af">TestOrder </span>order = <span style="color: blue">new </span><span style="color: #2b91af">TestOrder</span>();

    order.DiscountPercentage = 15;

    <span style="color: #2b91af">Assert</span>.IsTrue(order.UpdateTotalCalled);
}
</pre>

[](http://11011.net/software/vspaste)

Since the DiscountPercentage property calls the UpdateTotal method correctly, my test passes.

Creating lots of these little subclasses gives me great control over the behavior I&#8217;m looking for, but it can get tedious having all these little test double classes lying around.&nbsp; Enter tools like Rhino Mocks (which do many more test doubles than just mocks), that can automate the creation of these test double classes.&nbsp; So how might we do this with a mocking framework?

#### Enter Rhino Mocks

Rhino Mocks (and other mocking frameworks) allows you to create [partial mocks](http://www.ayende.com/Wiki/Default.aspx?Page=Rhino+Mocks+Partial+Mocks), which are useful for testing concrete classes.&nbsp; With partial mocks, the existing behavior of the class being mocked will be preserved, except for members I explicitly set rules on.&nbsp; To make sure the original UpdateTotal method doesn&#8217;t get called, I&#8217;ll put an exception in temporarily:

<pre><span style="color: blue">public virtual void </span>UpdateTotal()
{</pre>

<pre><span style="color: green">//hit database, tax service, etc.
    </span><span style="color: blue">throw new </span><span style="color: #2b91af">Exception</span>(<span style="color: #a31515">"Shouldn't get here!!!"</span>);
}
</pre>

[](http://11011.net/software/vspaste)

I&#8217;ll take it out after I make sure my test works, but it&#8217;s a good gut-check to make sure the mocking works the way I expect it to.&nbsp; With Rhino Mocks, here&#8217;s what my test would look like:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_update_the_total_when_applying_a_discount()
{
    <span style="color: #2b91af">MockRepository </span>mocks = <span style="color: blue">new </span><span style="color: #2b91af">MockRepository</span>();
    <span style="color: #2b91af">Order </span>order = mocks.PartialMock&lt;<span style="color: #2b91af">Order</span>&gt;();

    <span style="color: blue">using </span>(mocks.Record())
    {
        order.UpdateTotal();
    }

    order.DiscountPercentage = 15;

    mocks.VerifyAll();
}
</pre>

[](http://11011.net/software/vspaste)

I create the partial mock by calling the PartialMock method on the MockRepository, telling Rhino Mocks what type to mock with the generic argument.&nbsp; Rhino Mocks will dynamically create a subclass of Order on the fly, and I don&#8217;t have to worry about dealing with another little class lying around.

Because the UpdateTotal method is virtual, Rhino Mocks is able to mock this method.&nbsp; If the method wasn&#8217;t virtual, I&#8217;d have to resort to such techniques like [subclass and override non-virtual methods](http://grabbagoft.blogspot.com/2007/08/legacy-code-testing-techniques-subclass.html).

In the Record section, I call the methods on the mocked Order object, essentially recording what I expect to get called later.&nbsp; Since I&#8217;m in the record phase, calling the UpdateTotal method doesn&#8217;t call the real implementation here, proven because no exception gets thrown.

Finally, I set the DiscountPercentage on the Order object and call VerifyAll to verify that all the expectations were met.&nbsp; The UpdateTotal method was called during the replay phase, so my test passes.&nbsp; Keep in mind that during execution in both the record and replay phases, the real UpdateTotal method is **never called**.&nbsp; Rhino Mocks has overridden the behavior, keeping track of what expectations are set and what has been called.

### Summary

Semantically, both testing techniques performed the same interaction test.&nbsp; All I cared about when testing was that the UpdateTotal method was called, but I didn&#8217;t care what the actual behavior is.&nbsp; For my purposes, UpdateTotal is a black box.&nbsp; In fact, I went out of my way to make sure that the real implementation was never called.

It&#8217;s a matter of personal preference which technique to use.&nbsp; The goal is to have an easily readable test that I can decipher what I&#8217;m testing at a quick glance.&nbsp; Whether you use Rhino Mocks or manual test double creation is up to the team, and always on a case-by-case basis.&nbsp; If manual creation is more explicit, I&#8217;ll opt for that.&nbsp; If creating through a mock framework is more clear, I&#8217;ll opt use it instead.

Auto- or self-interaction testing is a great technique when you need to modify legacy code or extend a third-party library.&nbsp; I&#8217;ve used this technique quite a bit recently when [testing MonoRail Controllers](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/02/18/unit-testing-monorail-controllers-redirects.aspx).&nbsp; It&#8217;s never a perfect world in TDD land, so having a few tricks like these up your sleeve can make the journey a little smoother.