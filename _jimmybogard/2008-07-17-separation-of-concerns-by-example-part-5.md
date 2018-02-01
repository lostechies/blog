---
id: 207
title: 'Separation of Concerns by example: Part 5'
date: 2008-07-17T12:23:28+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/07/17/separation-of-concerns-by-example-part-5.aspx
dsq_thread_id:
  - "264715831"
categories:
  - LINQ2SQL
  - Refactoring
---
In our last example, disaster finally struck our quaint little application.&nbsp; A strange defect showed up, which would be almost impossible to reproduce back on our developer machine.&nbsp; But because we&#8217;ve broken out our dependencies, our CustomerFinder became easier to test.&nbsp; When it became easier, actually possible to test, we were able to reproduce the circumstances of the bug.

With the dependencies broken out, we were able to push in fake versions through the constructor.&nbsp; With our behavioral specifications in place, guarding us against this bug in the future, we can have complete confidence that this bug is fixed now and forever.

Other parts in this series include:

  * [Separation of Concerns &#8211; how not to do it](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/06/17/separation-of-concerns-how-not-to-do-it.aspx)
  * [Separation of Concerns by example: Part 1](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/06/19/separation-of-concerns-by-example-part-1.aspx) &#8211; Refactoring away from static class
  * [Separation of Concerns by example: Part 2](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/06/24/separation-of-concerns-by-example-part-2.aspx) &#8211; Specialized interface for Cache
  * [Separation of Concerns by example: Part 3](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/06/26/separation-of-concerns-by-example-part-3.aspx) &#8211; Creating the repository
  * [Separation of Concerns by example: Part 4](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/07/10/separation-of-concerns-by-example-part-4.aspx) &#8211; Fixing a bug with unit tests

There&#8217;s still one last bothersome piece of our application, the construction of the CustomerFinder.&nbsp; We split out the dependencies quite nicely, and told the clients of the CustomerFinder exactly what is needed for the class to function:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomerFinder
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ICustomerRepository </span>_customerRepository;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ICustomCache </span>_customCache;

    <span style="color: blue">public </span>CustomerFinder(<span style="color: #2b91af">ICustomerRepository </span>customerRepository, <span style="color: #2b91af">ICustomCache </span>customCache)
    {
        _customerRepository = customerRepository;
        _customCache = customCache;
    }
</pre>

[](http://11011.net/software/vspaste)

However, now it&#8217;s on the burden of the client to find the _right_ implementations of the dependencies to plug in.&nbsp; The problem is, clients often don&#8217;t care what gets plugged in, they too only care that they get a CustomerFinder.&nbsp; Sure, some users of this class might want some different implementation, but by and large, we&#8217;d like to encapsulate selection of dependencies away from CustomerFinder clients.

We have quite a few options for this complex construction:

  * An overloaded constructor that picks the right instances
  * A static creation method (CustomerFinder.CreateInstance())
  * A separate factory class
  * Dependency injection with an Inversion of Control container

All of these are valid options with their own advantages and disadvantages.&nbsp; However, the last option allows some interesting benefits, such as changing implementations out from configuration at runtime.&nbsp; Suppose we want to see how our application runs when the database is slow?&nbsp; Or a certain external service is down, slow, or not responding?

### Preparing for StructureMap

Here&#8217;s the offending code we&#8217;d like to fix:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomerManager
</span>{
    [<span style="color: #2b91af">DataObjectMethod</span>(<span style="color: #2b91af">DataObjectMethodType</span>.Select, <span style="color: blue">false</span>)]
    <span style="color: blue">public static </span><span style="color: #2b91af">Customer</span>[] GetCustomers(<span style="color: blue">int </span>startRowIndex, <span style="color: blue">int </span>maximumRows)
    {
        <span style="color: blue">var </span>finder = <span style="color: blue">new </span><span style="color: #2b91af">CustomerFinder</span>(<span style="color: blue">new </span><span style="color: #2b91af">CustomerRepository</span>(), <span style="color: blue">new </span><span style="color: #2b91af">CustomCache</span>());
        <span style="color: blue">return </span>finder.FindAllCustomers(startRowIndex, maximumRows);
    }
}
</pre>

[](http://11011.net/software/vspaste)

Everything to the right of the &#8220;var finder&#8221;, I&#8217;d like to replace with&#8230;something else.&nbsp; But first, I want to remove the dependency from CustomerManager to the specific CustomerFinder implementation.&nbsp; After all, the CustomerManager doesn&#8217;t really care about this specific CustomerFinder, but rather just something that finds customers.&nbsp; Let&#8217;s perform the [Extract Interface](http://www.refactoring.com/catalog/extractInterface.html) refactoring on CustomerFinder, by first creating &#8220;something that finds customers&#8221;, an ICustomerFinder:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">ICustomerFinder
</span>{
    <span style="color: #2b91af">Customer</span>[] FindAllCustomers(<span style="color: blue">int </span>startRowIndex, <span style="color: blue">int </span>maximumRows);
}
</pre>

[](http://11011.net/software/vspaste)

With ReSharper, this refactoring is just a couple of keystrokes away.&nbsp; Otherwise, I&#8217;ll:

  * Create the ICustomerFinder interface
  * Copy the signature of the public methods I want in the interface, and paste them in the ICustomerFinder interface
  * Make the CustomerFinder implement the ICustomerFinder interface

The last part is easy, just add a little section after the class declaration:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomerFinder </span>: <span style="color: #2b91af">ICustomerFinder
</span></pre>

[](http://11011.net/software/vspaste)

I don&#8217;t have to change anything about the CustomerFinder class other than this part.

Finally, I&#8217;ll change the CustomerManager method to remove the &#8220;var&#8221; keyword, making it explicit what the CustomerManager is trying to use:

<pre>[<span style="color: #2b91af">DataObjectMethod</span>(<span style="color: #2b91af">DataObjectMethodType</span>.Select, <span style="color: blue">false</span>)]
<span style="color: blue">public static </span><span style="color: #2b91af">Customer</span>[] GetCustomers(<span style="color: blue">int </span>startRowIndex, <span style="color: blue">int </span>maximumRows)
{
    <span style="color: #2b91af">ICustomerFinder </span>finder = <span style="color: blue">new </span><span style="color: #2b91af">CustomerFinder</span>(<span style="color: blue">new </span><span style="color: #2b91af">CustomerRepository</span>(), <span style="color: blue">new </span><span style="color: #2b91af">CustomCache</span>());
    <span style="color: blue">return </span>finder.FindAllCustomers(startRowIndex, maximumRows);
}
</pre>

[](http://11011.net/software/vspaste)

The GetCustomers method now _uses_ an ICustomerFinder, but _creates_ the whole CustomerFinder mess.&nbsp; Now we&#8217;re ready to introduce the fancy factory, StructureMap.

### Introducing StructureMap to the mix

With our CustomerManager (the class used by an ObjectDataSource to fill a web control) using only an ICustomerFinder, we can concentrate on the right part, the wiring up of dependencies.&nbsp; We have several options to configure the correct dependencies:

  * XML
  * Attributes
  * Code

After using StructureMap for some time, I find the code option tends to be the easiest to maintain, because:

  * It&#8217;s easy to edit
  * It plays nice with refactoring tools
  * It&#8217;s not XML
  * None of my classes become &#8220;infrastructure-aware&#8221;
  * All setup is in one place

With attributes, I can decorate my classes and interfaces, but the configuration is in at least two places with each class.&nbsp; Sometimes, I don&#8217;t have access to the underlying interface, so I can&#8217;t go back and put an attribute on it.

And XML is well, XML, and therefore automatically more difficult to maintain.&nbsp; No Intellisense for class names etc. means that typos and such cause problems more often.

#### Finding a home

Now that we&#8217;ve decided on the code route, where should this code go?&nbsp; We need to put all the configuration in the application startup part.&nbsp; Since we&#8217;re using ASP.NET, this means the Global.asax is a good candidate.&nbsp; We&#8217;ve already downloaded [the latest StructureMap release](http://sourceforge.net/project/showfiles.php?group_id=104740) (2.4.9) and added the reference to our ASP.NET project, now we just need to fill it in.

The basic idea behind our configuration is that we need to tell StructureMap what the interfaces and concrete types are.&nbsp; Whenever someone asks StructureMap for an instance of a specific type, that type along with all of its dependencies need to be configured.&nbsp; This means ICustomerFinder, ICustomCache and ICustomerRepository, along with all of the concrete types.

Here&#8217;s what I came up with:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Global </span>: <span style="color: #2b91af">HttpApplication
</span>{
    <span style="color: blue">protected void </span>Application_Start(<span style="color: blue">object </span>sender, <span style="color: #2b91af">EventArgs </span>e)
    {
        <span style="color: #2b91af">StructureMapConfiguration
            </span>.ForRequestedType&lt;<span style="color: #2b91af">ICustomerFinder</span>&gt;()
            .TheDefaultIsConcreteType&lt;<span style="color: #2b91af">CustomerFinder</span>&gt;();

        <span style="color: #2b91af">StructureMapConfiguration
            </span>.ForRequestedType&lt;<span style="color: #2b91af">ICustomCache</span>&gt;()
            .TheDefaultIsConcreteType&lt;<span style="color: #2b91af">CustomCache</span>&gt;();

        <span style="color: #2b91af">StructureMapConfiguration
            </span>.ForRequestedType&lt;<span style="color: #2b91af">ICustomerRepository</span>&gt;()
            .TheDefaultIsConcreteType&lt;<span style="color: #2b91af">CustomerRepository</span>&gt;();
    }
}
</pre>

[](http://11011.net/software/vspaste)

I put all of my configuration in the Global.asax code-behind, in the Application_Start event.&nbsp; That way the configuration happens only once at application startup.

Using the StructureMapConfiguration class, I tell StructureMap each requested type and the concrete type that should be injected.&nbsp; When someone asks for the ICustomerFinder, StructureMap will create the &#8220;real&#8221; type of CustomerFinder.&nbsp; But remember that CustomerFinder only had one constructor that took two _other_ dependencies:

<pre><span style="color: blue">public </span>CustomerFinder(<span style="color: #2b91af">ICustomerRepository </span>customerRepository, <span style="color: #2b91af">ICustomCache </span>customCache)
{
    _customerRepository = customerRepository;
    _customCache = customCache;
}
</pre>

[](http://11011.net/software/vspaste)

But since each of these two constructor argument types are _also_ configured in StructureMap, StructureMap is smart enough to wire the whole thing up for us.&nbsp; Notice we didn&#8217;t tell StructureMap what to put in specifically into the constructor, it just figured the whole object graph out.

Now that StructureMap&#8217;s configured, let&#8217;s go back to the CustomerManager class to fix that constructor mess.

#### Instantiating the component

With StructureMap, creating an instance configured in StructureMap is a cinch:

<pre>[<span style="color: #2b91af">DataObjectMethod</span>(<span style="color: #2b91af">DataObjectMethodType</span>.Select, <span style="color: blue">false</span>)]
<span style="color: blue">public static </span><span style="color: #2b91af">Customer</span>[] GetCustomers(<span style="color: blue">int </span>startRowIndex, <span style="color: blue">int </span>maximumRows)
{
    <span style="color: #2b91af">ICustomerFinder </span>finder = <span style="color: #2b91af">ObjectFactory</span>.GetInstance&lt;<span style="color: #2b91af">ICustomerFinder</span>&gt;();
    <span style="color: blue">return </span>finder.FindAllCustomers(startRowIndex, maximumRows);
}
</pre>

[](http://11011.net/software/vspaste)

That&#8217;s it, just the one call to ObjectFactory.GetInstance.&nbsp; Notice I only used the interface type, and not the concrete type.&nbsp; Our CustomerManager only really cares about finding customers, not about who actually does the finding.&nbsp; All it wants to do is ask StructureMap, &#8220;Give me something (ICustomerFinder) that can find customers&#8221;.&nbsp; CustomerManager doesn&#8217;t need to care about the concrete CustomerFinder, the caching business or the repository.

This leads us to a very flexible separation of concerns.&nbsp; No longer are our classes dependent on specific implementations, but only interfaces that expose a cohesive set of operations.

Once we have the constructor business out of the way, a quick view at our web applications confirms that the dependencies are wired up correctly.

### Wrapping it up

We&#8217;ve come a long way since our [original example](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/06/17/separation-of-concerns-how-not-to-do-it.aspx).&nbsp; The original application had three &#8220;tiers&#8221;, split between an ASPX page, a static method, and LINQ to SQL.&nbsp; Only one of these classes was something we created, the CustomerManager.

But this class still had too many responsibilities, which would have given us trouble when we needed to change it.&nbsp; Now we have many more classes (4 vs. 1) and interfaces (3 vs. 0).&nbsp; For those who don&#8217;t like more classes, GET OVER IT.&nbsp; High cohesion and less coupling means smaller classes with fewer, tighter concerns.&nbsp; More classes with high cohesion is far easier to maintain, since the responsibilities of each class can be easily discerned.&nbsp; I&#8217;ve seen far too many one-method classes with thousands of lines in the one method to convince me that more classes is better.

With separation of concerns in place, along with dependency inversion (dependencies given to the class through the constructor), the responsibilities _and_ dependencies are easy for both clients of the class and maintainers of the class to figure out.&nbsp; Someone looking at the CustomerFinder class can immediately see it needs a backing store and something with caching to function properly.

When we ran into a gnarly bug, we were able to diagnose, fix, and lock down the correct behavior with BDD-style behavioral specifications.&nbsp; As long as our specs are part of a continuous integration process, we can have confidence that the correct behavior won&#8217;t be undone.

Separation of concerns is easier with TDD, but TDD won&#8217;t separate the concerns for us.&nbsp; It only shows us where the friction and smells are, and it&#8217;s up to us to decide whether or not to act upon them.&nbsp; There have been plenty of times I run into a class with too many responsibilities, but can&#8217;t decide how to break it up.&nbsp; Later, when more responsibility needs to be added, the picture becomes clear(er) and I then break it up.

In the end, we care about developing for two people: the people using our software and the people maintaining our software.&nbsp; Separation of concerns leads to higher maintainability, as we saw in this series.&nbsp; With high maintainability, we&#8217;re able to satisfy both camps, as we can change software at a faster, continuous pace.