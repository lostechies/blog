---
id: 142
title: Eliminating obscure tests
date: 2008-02-16T23:47:44+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/02/16/eliminating-obscure-tests.aspx
dsq_thread_id:
  - "265635255"
categories:
  - BDD
  - BehaviorDrivenDevelopment
  - TDD
---
One of the purported benefits of unit tests and TDD in general is unit tests doubling as living documentation.&nbsp; Unit tests are documentation in the form of executable client code demonstrating small units of behavior.&nbsp; The idea is that if you wanted to understand how a class worked, you simply needed to look at the unit tests.

But documentation, whether in the form of user manuals or unit tests, is only as valuable as the clarity of its content.&nbsp; Obscure, vague tests can confuse developers trying understand behavior.&nbsp; For example, can anyone follow the ambiguity of the following test?

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Should_compare_based_on_last_name_then_company()
{
    <span style="color: #2b91af">Contact </span>contact1 = <span style="color: blue">new </span><span style="color: #2b91af">Contact</span>() 
        { FirstName = <span style="color: #a31515">"a"</span>, LastName = <span style="color: #a31515">"a"</span>, CompanyName = <span style="color: #a31515">"a" </span>};
    <span style="color: #2b91af">Contact </span>contact2 = <span style="color: blue">new </span><span style="color: #2b91af">Contact</span>() 
        { FirstName = <span style="color: #a31515">"a"</span>, LastName = <span style="color: #a31515">"a"</span>, CompanyName = <span style="color: #a31515">"a" </span>};

    <span style="color: #2b91af">Assert</span>.AreEqual(0, contact1.CompareTo(contact2));
    contact2.LastName = <span style="color: #a31515">"b"</span>;
    <span style="color: #2b91af">Assert</span>.AreEqual(-1, contact1.CompareTo(contact2));
    contact1.LastName = <span style="color: #a31515">"c"</span>;
    <span style="color: #2b91af">Assert</span>.AreEqual(1, contact1.CompareTo(contact2));
    contact2.LastName = <span style="color: #a31515">"c"</span>;
    contact2.CompanyName = <span style="color: #a31515">"b"</span>;
    <span style="color: #2b91af">Assert</span>.AreEqual(-1, contact1.CompareTo(contact2));
    contact1.CompanyName = <span style="color: #a31515">"c"</span>;
    <span style="color: #2b91af">Assert</span>.AreEqual(1, contact1.CompareTo(contact2));
    contact2.CompanyName = <span style="color: #a31515">"c"</span>;
    contact2.FirstName = <span style="color: #a31515">"b"</span>;
    <span style="color: #2b91af">Assert</span>.AreEqual(-1, contact1.CompareTo(contact2));
    contact1.FirstName = <span style="color: #a31515">"c"</span>;
    <span style="color: #2b91af">Assert</span>.AreEqual(1, contact1.CompareTo(contact2));
}
</pre>

[](http://11011.net/software/vspaste)

The name of the test is reasonable enough, it&#8217;s describing comparison behavior for a Contact object:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Contact </span>: <span style="color: #2b91af">IComparable</span>&lt;<span style="color: #2b91af">Contact</span>&gt;
{
    <span style="color: blue">public string </span>FirstName { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>LastName { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>CompanyName { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }

    <span style="color: blue">public int </span>CompareTo(<span style="color: #2b91af">Contact </span>other)
    {
        <span style="color: blue">int </span>compareResult = LastName.CompareTo(other.LastName);
        <span style="color: blue">if </span>(compareResult == 0)
            compareResult = CompanyName.CompareTo(other.CompanyName);
        <span style="color: blue">if </span>(compareResult == 0)
            compareResult = FirstName.CompareTo(other.FirstName);
        <span style="color: blue">return </span>compareResult;
    }
}
</pre>

[](http://11011.net/software/vspaste)

Unfortunately, the name of the test is about the only good thing about it.&nbsp; There are about a half-dozen asserts, sprinkled between changes to each objects state.&nbsp; To understand what each assert is actually testing, you have to trace back the history of the changes to see what the state of each object truly is.

This test is suffering from the [Obscure Test](http://xunitpatterns.com/Obscure%20Test.html) smell, the cause being Eager Test.&nbsp; It&#8217;s testing far too much at once, and in doing so, misses quite a few scenarios.&nbsp; If I change around the order of the comparisons in the Contact class, the test still passes!&nbsp; That&#8217;s a good sign of a bad test, if you can change the underlying behavior and the tests supposedly verifying behavior still passes.

### Test one thing

So let&#8217;s start over.&nbsp; We have a request from the business that they want their contacts sorted by CompanyName first, then LastName.&nbsp; Usually I keep my sorting concerns outside of the classes being sorted, but for posterity sake, let&#8217;s keep the behavior in the Contact class.

The main problem with the original test is that it tried to test a bunch of different scenarios at once.&nbsp; Unit test convention tells us to **test one thing** per test.&nbsp; It can be hard to define &#8220;one thing&#8221;, but I like to think of it as &#8220;**one context, one behavior**&#8220;.&nbsp; A single piece of code might behave differently in different scenarios, so tackling it from the context/behavior side tends to get you more branch coverage.

Now it&#8217;s time to think of one context, and describe the desired behavior given that context.

**When comparing Contacts with different last name and different company names, it should sort based on the company names**

We could write several more scenarios, but one will suffice for now.&nbsp; Using a BDD-style specification, this would result in the following specification:

<pre>[<span style="color: #2b91af">TestFixture</span>]
<span style="color: blue">public class </span><span style="color: #2b91af">When_comparing_Contacts_with_different_last_names_and_different_company_names
</span>{
    <span style="color: blue">private </span><span style="color: #2b91af">Contact </span>contact1;
    <span style="color: blue">private </span><span style="color: #2b91af">Contact </span>contact2;

    [<span style="color: #2b91af">SetUp</span>]
    <span style="color: blue">public void </span>Before_each_spec()
    {
        contact1 = <span style="color: blue">new </span><span style="color: #2b91af">Contact</span>() 
            { FirstName = <span style="color: #a31515">"a"</span>, LastName = <span style="color: #a31515">"b"</span>, CompanyName = <span style="color: #a31515">"a" </span>};
        contact2 = <span style="color: blue">new </span><span style="color: #2b91af">Contact</span>() 
            { FirstName = <span style="color: #a31515">"a"</span>, LastName = <span style="color: #a31515">"a"</span>, CompanyName = <span style="color: #a31515">"b" </span>};
    }

    [<span style="color: #2b91af">Test</span>]
    <span style="color: blue">public void </span>Should_sort_based_on_company_names()
    {
        contact1.CompareTo(contact2).ShouldEqual(-1);
    }
}
</pre>

[](http://11011.net/software/vspaste)

Now my <strike>test</strike> specification is not satisfied (i.e. failing), so I need to change the behavior of the Contact class to satisfy the new specification.&nbsp; A couple things to note:

  * All setup information is put in the SetUp method
  * The specification part only contains assertions

Now that I&#8217;ve explicitly partitioned the context (SetUp) from the specification (Test), it&#8217;s far easier to make the connection between desired behavior and the observed behavior.

### Punished by laziness

When I get lazy and try to test too much in a single unit test, I always pay more in the end.&nbsp; Obscure tests are a subtle form of technical debt, as I&#8217;m fooling myself into thinking I have a good design because I have unit tests with coverage.&nbsp; But if I can&#8217;t look at a test and understand what it&#8217;s testing, it probably put me in a worst spot than having no tests.&nbsp; Instead of having to decipher just the underlying class, I have to decipher the test as well.

Sticking to one context/specification of behavior helps me ensure that I can truly understand the underlying behavior of the system simply by reading the tests.