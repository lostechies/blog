---
id: 58
title: 'Legacy code testing techniques: subclass and override non-virtual members'
date: 2007-08-31T19:22:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/08/31/legacy-code-testing-techniques-subclass-and-override-non-virtual-members.aspx
dsq_thread_id:
  - "272368137"
categories:
  - 'C#'
  - LegacyCode
  - Testing
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/08/legacy-code-testing-techniques-subclass.html)._

One of the&nbsp;core techniques in [Michael Feathers&#8217;](http://www.michaelfeathers.com/) [Working Effectively With Legacy Code](http://www.amazon.com/Working-Effectively-Legacy-Robert-Martin/dp/0131177052) is the &#8220;Subclass and Override Method&#8221; technique.&nbsp; Basically, in the context of a test, we can subclass a dependency and override behavior on a method or property to nullify or alter its behavior as needed.&nbsp; This is especially useful if we can&#8217;t extract a dependency outside of a class under test.&nbsp; Mocking frameworks such as [Rhino.Mocks](http://ayende.com/projects/rhino-mocks.aspx)&nbsp;allow me to verify interactions, or simply put in some canned responses for dependencies.

Since we&#8217;re dealing with legacy code, paying down the entire technical debt at once isn&#8217;t an option.&nbsp; We have to make micro-payments&nbsp;by introducing seams into our codebase.&nbsp; It might make the code slightly uglier at first, but as Feathers notes in his book, sometimes surgery leaves scars.

#### Some problem code

I need to override a method to provide an alternate, canned value.&nbsp; However, in C#, members are not virtual by default.&nbsp; Members have to be explicitly marked &#8220;virtual&#8221;, otherwise subclassed members can only shadow base members.&nbsp; For instance, suppose we have class Foo and Bar:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> Foo : Bar
{
    <span class="kwrd">public</span> <span class="kwrd">decimal</span> CalculateDiscount()
    {
        <span class="kwrd">return</span> CalculateTotal() * 0.1M;
    }
}

<span class="kwrd">public</span> <span class="kwrd">class</span> Bar
{
    <span class="kwrd">public</span> <span class="kwrd">decimal</span> CalculateTotal()
    {
        <span class="rem">// Hit database, webservices, etc.</span>
        <span class="kwrd">return</span> PricingDatabase.GetPrice(itemId);
    }
}
</pre>
</div>

I&#8217;m trying to test some class that uses Foo.CalculateDiscount method to perform some figure out what shipping methods should be available.&nbsp; It uses the Foo discount to figure this out.&nbsp; However, CalculateDiscount calls a base class method (CalculateTotal), which then&nbsp;goes and hits the database!&nbsp; Not much&nbsp;of a unit test when it hits the&nbsp;database (or web service, or HttpContext,&nbsp;etc.).&nbsp; Worse, I don&#8217;t have access to the Bar class, it&#8217;s in another library that we don&#8217;t own.&nbsp; Here&#8217;s the test I&#8217;m trying to write:

<div class="CodeFormatContainer">
  <pre>[Test]
<span class="kwrd">public</span> <span class="kwrd">void</span> Should_add_shipping_option_when_discount_is_lower_than_50()
{
    MockRepository mocks = <span class="kwrd">new</span> MockRepository();

    Foo foo = mocks.CreateMock&lt;Foo&gt;();

    <span class="kwrd">using</span> (mocks.Record())
    {
        Expect.Call(foo.CalculateTotal()).Return(100.0M);
    }

    <span class="kwrd">using</span> (mocks.Playback())
    {
        <span class="kwrd">string</span>[] shippingMethods = ShippingService.FindShippingMethods(foo);

        Assert.AreEqual(shippingMethods[0], <span class="str">"OneDay"</span>);
    }
}
</pre>
</div>

I could try to remove the dependency on the Foo class somehow.&nbsp; But there&#8217;s a lot of information that my shipping method&nbsp;needs, so I can&#8217;t just pass in individual parameters for all of the Foo data.&nbsp;&nbsp;The Foo class is actually quite large, so trying to extract an interface wouldn&#8217;t really help either.&nbsp; In any case, I just want to override the behavior of the &#8220;CalculateTotal&#8221; call, and since it&#8217;s not marked &#8220;virtual&#8221;, I can&#8217;t override the behavior directly.&nbsp; For example, this won&#8217;t work in my test:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> FooStub : Foo
{
    <span class="kwrd">public</span> <span class="kwrd">new</span> <span class="kwrd">decimal</span> CalculateTotal()
    {
        <span class="kwrd">return</span> 100.0m;
    }
}
</pre>
</div>

The shipping service knows about &#8220;Foo&#8221;, not &#8220;FooStub&#8221;.&nbsp; Since the FooStub.CalculateTotal is shadowing the Bar method, only when I have a variable of type FooStub will its CalculateTotal get called.&nbsp; Since the shipping service knows Foo, it will use the Bar CalculateTotal method, _even if I_&nbsp;_pass in an instance of a FooStub_.&nbsp; Shadowing can cause weird things like this&nbsp;to happen, to I try to avoid it as much as possible.

#### Subclass and override

So subclassing and overriding, one of the main functions of mocking frameworks, won&#8217;t work at the test level.&nbsp; I need to get the override on or between the Foo and Bar classes.&nbsp; Why don&#8217;t we create a new BarSeam class between the Foo and Bar classes?

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> Foo : BarSeam
{
    <span class="kwrd">public</span> <span class="kwrd">decimal</span> CalculateDiscount()
    {
        <span class="kwrd">return</span> CalculateTotal() * 0.1M;
    }
}

<span class="kwrd">public</span> <span class="kwrd">class</span> BarSeam : Bar
{
    <span class="kwrd">public</span> <span class="kwrd">virtual</span> <span class="kwrd">new</span> <span class="kwrd">decimal</span> CalculateTotal()
    {
        <span class="kwrd">return</span> <span class="kwrd">base</span>.CalculateTotal();
    }
}

<span class="kwrd">public</span> <span class="kwrd">class</span> Bar
{
    <span class="kwrd">public</span> <span class="kwrd">decimal</span> CalculateTotal()
    {
        <span class="rem">// Hit database, webservices, etc.</span>
        <span class="kwrd">return</span> PricingDatabase.GetPrice(itemId);
    }
}
</pre>
</div>

The BarSeam class now sits between Foo and Bar in the inheritance hierarchy.&nbsp; BarSeam shadows the Bar.CalculateTotal, with one key addition, the &#8220;virtual&#8221; keyword.&nbsp; By making BarSeam.CalculateTotal virtual, I can now subclass&nbsp;Foo&nbsp;and override CalculateTotal, put in a canned response, and not worry about hitting the database.

Yes, BarSeam is ugly, but I want to bring ugly to the front of the class to make sure it doesn&#8217;t get swept under the rug.&nbsp; Since all client code either references Foo or Bar, no client code will be affected as BarSeam&#8217;s default implementation merely calls the base method.&nbsp; Think of it as [Adapter](http://www.dofactory.com/Patterns/PatternAdapter.aspx), but instead of incompatible interfaces, I&#8217;m dealing with a non-extensible interface.

#### Conclusion

When working with legacy code, it&#8217;s not feasible (or even wise) to try and rewrite the application.&nbsp; By making these micro-refactorings and introducing seams, we&#8217;re able to identify places in need of larger refactorings, as well as meeting our original goal of getting our legacy&nbsp;code under test.