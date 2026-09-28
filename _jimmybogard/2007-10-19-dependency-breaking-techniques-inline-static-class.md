---
wordpress_id: 85
title: 'Dependency Breaking Techniques: Inline Static Class'
date: 2007-10-19T21:50:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/10/19/dependency-breaking-techniques-inline-static-class.aspx
dsq_thread_id:
  - "273845742"
categories:
  - LegacyCode
redirect_from: "/blogs/jimmy_bogard/archive/2007/10/19/dependency-breaking-techniques-inline-static-class.aspx/"
---
Often times I run into a class that has a dependency not on a [Singleton](http://www.dofactory.com/Patterns/PatternSingleton.aspx), but a static class.&nbsp; When refactoring away from a Singleton, a common approach is to use [Inline Singleton](http://industriallogic.com/xp/refactoring/inlinesingleton.html).&nbsp; With static classes, a slightly different approach needs to be taken because client code isn&#8217;t working with an instance of a type, but rather static methods on the type itself.

Dependency breaking techniques are used to get legacy code under test.&nbsp; The goal isn&#8217;t necessarily to break _all_ client dependencies out, but just the one I&#8217;m modifying to get under test.&nbsp; I&#8217;m not interested changing&nbsp;any of the other clients that may use this static class.&nbsp; Since nothing is under test, it&#8217;s too risky to make non-backwards compatible changes.

#### The pattern

_Code needs access to a method or property but doesn&#8217;t need a global point of access to it._

**Move Static&#8217;s features to instance methods of that type.  
** 

** ![](http://s3.amazonaws.com/grabbagoftimg/inline%20static%20class.PNG)**

#### Motivation

Helper methods tend to congregate into static classes with static methods.&nbsp; Over time, the responsibility grows for the static class until it becomes a dumping ground to any behavior that seems relevant to the name.&nbsp; The name of the static class usually is post-fixed by &#8220;Helper&#8221;, &#8220;Manager&#8221;, &#8220;Utility&#8221;,&nbsp;or other generic and obtuse names.

Eventually, this static class will have opaque dependencies of its own, where callers don&#8217;t know what&#8217;s happening behind the scenes when those helper methods are called.&nbsp; This can wreak havoc with unit testing, especially when trying to add tests to legacy code.

#### Mechanics

  1. Find the static method in the calling class and use [Extract Interface](http://www.refactoring.com/catalog/extractInterface.html) to extract an interface that contains only the static method being called in the client code. 
  2. Make the static class explicitly implement the new extracted interface.&nbsp; The static class should have two methods with identical signatures, one a static method, one an explicitly implemented interface method. 
  3. Use [Move Method](http://www.refactoring.com/catalog/moveMethod.html) to move the logic from the static method to the instance method. 
  4. Use [Hide Delegate](http://www.refactoring.com/catalog/hideDelegate.html)&nbsp;to delegate the static method calls to the use the instance method instead. 
  5. **Compile and test.** 
  6. Modify Client code using the static Operation method to instantiate an IStatic instance and call the interface Operation method. 
  7. **Compile and test.** 
  8. Use [Extract Parameter](http://www.industriallogic.com/xp/refactoring/extractParamter.html) to pass in the IStatic instance to the Client method.&nbsp; If IStatic is a [primal dependency](http://codebetter.com/blogs/scott.bellware/archive/2007/06/28/164867.aspx), extract the parameter to a constructor argument and set the variable to a local field. 
  9. **Compile and test.**

#### Example

In our e-commerce system, one of the pages the user is presented with is a payments page.&nbsp; It is in this page that the user decides how they want to pay for their order, whether it&#8217;s credit card, invoice, financing, etc.

Not all payment types should be displayed for all carts, and there is some complex business logic that determines who sees what payment types.&nbsp; There are several payment filtering strategies to encapsulate this business logic, and one type uses the user&#8217;s profile to filter the payments.&nbsp; Here&#8217;s the strategy class:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> AccountFilter
{
    <span class="kwrd">private</span> <span class="kwrd">readonly</span> <span class="kwrd">string</span>[] _paymentTypes;

    <span class="kwrd">public</span> AccountFilter(<span class="kwrd">string</span>[] paymentTypes)
    {
        _paymentTypes = paymentTypes;
    }

    <span class="kwrd">public</span> <span class="kwrd">void</span> AddPaymentOptions(ShoppingCart cart)
    {
        IPayment payment = ProfileManager.FindPaymentByType(_paymentTypes);

        <span class="kwrd">if</span> ((payment != <span class="kwrd">null</span>) &&
            (! <span class="kwrd">string</span>.IsNullOrEmpty(cart.AccountNumber)))
        {
            cart.PaymentFilters.Add(payment);
        }
    }

}
</pre>
</div>

The business has a new requirement for us: **Payment types should not be filtered using the user&#8217;s profile for existing quotes.**&nbsp; In our system, customers can save their cart as a &#8220;quote&#8221;, so that the unit cost information can be &#8220;locked&#8221; for a set amount of time.&nbsp; Enabling this change requires us to change the AccountFilter class.

Being a legacy code system, the AccountFilter class **has no tests defined on it.**&nbsp; It&#8217;s our goal to make the change and add tests to verify the new requirements, and that&#8217;s all.&nbsp; We&#8217;re not trying to add 100% unit test coverage for the AccountFilter class, just to test the changes we&#8217;re making.

Not knowing if I can unit test this class, the easiest way to see if it&#8217;s testable is to try using it in a test.&nbsp; Here&#8217;s the behavior I want, in a unit test:

<div class="CodeFormatContainer">
  <pre>[TestMethod]
<span class="kwrd">public</span> <span class="kwrd">void</span> Should_not_add_filter_when_basket_is_a_quote()
{
    ShoppingCart cart = <span class="kwrd">new</span> ShoppingCart();
    cart.IsQuote = <span class="kwrd">true</span>;
    cart.AccountNumber = <span class="str">"123ABCD"</span>;

    AccountFilter filter = <span class="kwrd">new</span> AccountFilter(<span class="kwrd">new</span> <span class="kwrd">string</span>[] { <span class="str">"CRD"</span>, <span class="str">"INV"</span> });
    filter.AddPaymentOptions(cart);

    Assert.AreEqual(0, cart.PaymentFilters.Count);
}
</pre>
</div>

I try running this test, and it fails spectacularly.&nbsp; The error I get is along the lines of &#8220;HttpContext.Current is null&#8221;, so something is dependent on the ASP.NET runtime being up.

Looking at the AddPaymentOptions method of the AccountFilter class, I notice the call to&nbsp;the static method FindPaymentByType on the&nbsp;ProfileManager class.&nbsp; That method is extremely hideous, with hard dependencies on HttpContext.Current, a web service, and a database.&nbsp; Instead of focusing on breaking those dependencies out, I can apply Inline Static Class and break out AddPaymentOptions&#8217; dependency on ProfileManager.&nbsp; The end goal is to break the dependencies of the class I&#8217;m trying to test, not all the sub-sub-sub dependencies that may be around.

**Step 1:**

ProfileManager is a huge class, with about 100 different methods.&nbsp; The only one I&#8217;m interested in is the FindPaymentByType method, so I&#8217;ll create an IProfileManager interface that includes only that method, matching signature and name.

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">interface</span> IProfileManager
{
    IPayment FindPaymentByType(<span class="kwrd">string</span>[] paymentTypes);
}
</pre>
</div>

**Step 2:**

Now that I have my IProfileManager, I&#8217;ll make the static class implement the new interface.&nbsp; Note that the static class itself isn&#8217;t marked &#8220;static&#8221;, only its methods.&nbsp; Additionally, I&#8217;ll need to explicitly implement that method so it doesn&#8217;t conflict with the existing static method.

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> ProfileManager : IProfileManager
{
    <span class="kwrd">public</span> <span class="kwrd">static</span> IPayment FindPaymentByType(<span class="kwrd">string</span>[] paymentTypes)
    {
        <span class="rem">// Hit web service for widget</span>
        <span class="rem">// Query database based on widget</span>
        <span class="rem">// Return database object</span>
    }

    IPayment IProfileManager.FindPaymentByType(<span class="kwrd">string</span>[] paymentTypes)
    {
        <span class="kwrd">return</span> <span class="kwrd">null</span>;
    }
}
</pre>
</div>

I compile, and everything looks good.&nbsp; Notice I didn&#8217;t add any access modifiers to the new IProfileManager method, and the inclusion of the interface name prefixed on the method name.&nbsp; That&#8217;s how I can [explicitly implement the interface](http://msdn2.microsoft.com/en-us/library/aa288461%28VS.71%29.aspx), and not get any compile errors even though these two methods have the exact same signature.

**Step 3, 4:**

Now I can move the existing implementation to the new interface method, and use Hide Delegate to change the static method to call the new interface method.&nbsp; I don&#8217;t want to introduce duplication and simply copy over the implementation, so Hide Delegate allows me to retain backwards compatibility and save a lot of work of changing all clients to use the new method.

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> ProfileManager : IProfileManager
{
    <span class="kwrd">public</span> <span class="kwrd">static</span> IPayment FindPaymentByType(<span class="kwrd">string</span>[] paymentTypes)
    {
        IProfileManager profileManager = <span class="kwrd">new</span> ProfileManager();
        <span class="kwrd">return</span> profileManager.FindPaymentByType(paymentTypes);
    }

    IPayment IProfileManager.FindPaymentByType(<span class="kwrd">string</span>[] paymentTypes)
    {
        <span class="rem">// Hit web service for widget</span>
        <span class="rem">// Query database based on widget</span>
        <span class="rem">// Return database object</span>
    }
}
</pre>
</div>

Now my static method delegates to the instance methods, and no other clients are affected by this change.&nbsp; Again, it&#8217;s not my goal to fix every client dependency on this static method, only the one I&#8217;m changing.

I compile and test, but my initial unit test is failing as it&#8217;s still calling the static method.

**Step 6:**

Now that I have an interface to depend upon instead of a static method, I&#8217;ll change the client code to use the interface instead of the static method.&nbsp; It looks much like the code inside the Hide Delegate of the static method:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">void</span> AddPaymentOptions(ShoppingCart cart)
{
    IProfileManager profileManager = <span class="kwrd">new</span> ProfileManager();
    IPayment payment = profileManager.FindPaymentByType(_paymentTypes);

    <span class="kwrd">if</span> ((payment != <span class="kwrd">null</span>) &&
        (! <span class="kwrd">string</span>.IsNullOrEmpty(cart.AccountNumber)))
    {
        cart.PaymentFilters.Add(payment);
    }
}
</pre>
</div>

I create a variable of type IProfileManager, instantiate it to a ProfileManager instance, and use the IProfileManager.FindPaymentByType method instead of the static method.&nbsp; I compile and test, but my unit test still fails as I still haven&#8217;t fully extracted the dependency on the ProfileManager, but that will be taken care of shortly.

**Step 8:**

I have two options, I can either pass in the IProfileManager as in the method call or I can pass it in through the constructor.&nbsp; I prefer to pass dependencies through constructors over method parameters, because I like a clear separation between queries, commands, and dependencies.&nbsp; Additionally, if I&#8217;m using an IoC container, I can wire up these dependencies a little more easily.&nbsp; I&#8217;ll use Preserve Signatures [Feathers 312] and [Chain Constructors](http://www.industriallogic.com/xp/refactoring/chainConstructors.html)&nbsp;to keep the original constructor, as there are still quite a few clients of my AccountFilter class that I don&#8217;t want to change:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> AccountFilter
{
    <span class="kwrd">private</span> <span class="kwrd">readonly</span> <span class="kwrd">string</span>[] _paymentTypes;
    <span class="kwrd">private</span> <span class="kwrd">readonly</span> IProfileManager _profileManager;

    <span class="kwrd">public</span> AccountFilter(<span class="kwrd">string</span>[] paymentTypes)
        : <span class="kwrd">this</span>(paymentTypes, <span class="kwrd">new</span> ProfileManager()) { }

    <span class="kwrd">public</span> AccountFilter(<span class="kwrd">string</span>[] paymentTypes, IProfileManager profileManager)
    {
        _paymentTypes = paymentTypes;
        _profileManager = profileManager;
    }

    <span class="kwrd">public</span> <span class="kwrd">void</span> AddPaymentOptions(ShoppingCart cart)
    {
        IPayment payment = _profileManager.FindPaymentByType(_paymentTypes);

        <span class="kwrd">if</span> ((payment != <span class="kwrd">null</span>) &&
            (!<span class="kwrd">string</span>.IsNullOrEmpty(cart.AccountNumber)))
        {
            cart.PaymentFilters.Add(payment);
        }
    }
}
</pre>
</div>

So I did&nbsp;a few&nbsp;things here:

  * Add a new constructor that took an IProfileManager, and created the backing field for it
  * Make the other constructor call the new one, passing in a new ProfileManager, which is what existing code would do
  * Make the AddPaymentOptions method use the field variable instead of a local variable

What this code allows me to do is pass in a different IProfileManager instance in my test methods to verify my behavior.&nbsp; I don&#8217;t really care what the ProfileManager does, all I care about is what it tells me.&nbsp; Somewhere down the line, I have an integration test that puts the two together, but until then, my unit test will suffice.&nbsp; Here&#8217;s my final unit test, which fails for the reason I want it to fail, because the assertion fails:

<div class="CodeFormatContainer">
  <pre>[TestMethod]
<span class="kwrd">public</span> <span class="kwrd">void</span> Should_not_add_filter_when_basket_is_a_quote()
{
    ShoppingCart cart = <span class="kwrd">new</span> ShoppingCart();
    cart.IsQuote = <span class="kwrd">true</span>;
    cart.AccountNumber = <span class="str">"123ABCD"</span>;

    <span class="kwrd">string</span>[] paymentTypes = <span class="kwrd">new</span> <span class="kwrd">string</span>[] { <span class="str">"CRD"</span>, <span class="str">"INV"</span> };

    MockRepository repo = <span class="kwrd">new</span> MockRepository();

    IProfileManager profileManager = repo.CreateMock&lt;IProfileManager&gt;();

    <span class="kwrd">using</span> (repo.Record())
    {
        Expect.Call(profileManager.FindPaymentByType(paymentTypes))
            .Return(<span class="kwrd">null</span>);
    }

    <span class="kwrd">using</span> (repo.Playback())
    {
        AccountFilter filter = <span class="kwrd">new</span> AccountFilter(paymentTypes, profileManager);
        filter.AddPaymentOptions(cart);
    }

    Assert.AreEqual(0, cart.PaymentFilters.Count);
}
</pre>
</div>

I use RhinoMocks to pass in a mock IProfileManager, and test-driven development to add the functionality desired.&nbsp; I broke the dependency of the class under test away from the ProfileManager static method, and was able to preserve existing functionality.&nbsp; By preserving existing interfaces and functionality, I can eliminate much of the risk involved in changing legacy code.&nbsp; I got my changes in, was able to test them, and kept out of the rabbit-hole that a larger refactoring would have thrown me into.