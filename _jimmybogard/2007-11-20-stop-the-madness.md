---
wordpress_id: 104
title: Stop the madness
date: 2007-11-20T22:01:14+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/11/20/stop-the-madness.aspx
dsq_thread_id:
  - "264715439"
categories:
  - Agile
  - LegacyCode
  - Testing
redirect_from: "/blogs/jimmy_bogard/archive/2007/11/20/stop-the-madness.aspx/"
---
I&#8217;ve been extending a legacy codebase lately to make it a bit more testable, and a few small, bad&nbsp;decisions have slowed my progress immensely.&nbsp; One decision isn&#8217;t bad in and of itself, but a small bad decision multiplied a hundred times leads to significant pain.&nbsp; It&#8217;s [death by a thousand cuts](http://en.wikipedia.org/wiki/Slow_slicing), and it absolutely kills productivity.&nbsp; Some of the small decisions I&#8217;m seeing are:

  * Protected/public instance fields
  * Inconsistent naming conventions
  * Try-Catch-Publish-Swallow
  * Downcasting

The pains of these bad decisions can wreak havoc when trying to add testability to legacy codebases.

### Public/protected instance fields

One of the pillars of OOP is encapsulation, which allows clients to use an object&#8217;s functionality without knowing the details behind it.&nbsp; From [FDG](http://www.amazon.com/Framework-Design-Guidelines-Conventions-Development/dp/0321246756):

> The principle states that data stored inside an object should be accessible only to that object.

Followed immediately by their guideline:

> **DO NOT** provide instance fields that are public or protected.

It goes on to say that access to simple public properties are optimized by the JIT compiler, so there&#8217;s no performance penalty in using better alternatives.&nbsp; Here&#8217;s an example of a protected field:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> Address
{
    <span class="kwrd">protected</span> <span class="kwrd">string</span> zip;

    <span class="kwrd">public</span> <span class="kwrd">string</span> Zip
    {
        get { <span class="kwrd">return</span> zip; }
    }
}

<span class="kwrd">public</span> <span class="kwrd">class</span> FullAddress : Address
{
    <span class="kwrd">private</span> <span class="kwrd">string</span> zip4;

    <span class="kwrd">public</span> <span class="kwrd">string</span> Zip4 
    {
        get
        {
            <span class="kwrd">if</span> (Zip.Contains(<span class="str">"-"</span>))
            {
                zip4 = zip.Substring(zip.IndexOf(<span class="str">"-"</span>) + 1);
                zip = zip.Substring(0, zip.IndexOf(<span class="str">"-"</span>));
            }
            <span class="kwrd">return</span> zip4;
        }
    }
}</pre>
</div>

There was an originally good reason to provide the derived FullAddress write access to the data in Address, but there are better ways to approach it.&nbsp; Here&#8217;s a better approach:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> Address
{
    <span class="kwrd">private</span> <span class="kwrd">string</span> zip;

    <span class="kwrd">public</span> <span class="kwrd">string</span> Zip
    {
        get { <span class="kwrd">return</span> zip; }
        <span class="kwrd">protected</span> set { zip = <span class="kwrd">value</span>; }
    }
}
</pre>
</div>

I&#8217;ve done two things here:

  * Added a protected setter to the Zip property
  * Changed the access level of the field to private

Functionally it&#8217;s exactly the same for derived classes, but the design has greatly improved.&nbsp; We should only declare private instance fields because:

  * Public/protected/internal violates encapsulation
  * When encapsulation is violated, refactoring becomes difficult as we&#8217;re exposing the inner details
  * Adding a property later with the same name breaks backwards binary compatibility (i.e. clients are forced to recompile)
  * Interfaces don&#8217;t allow you to declare fields, only properties and methods
  * C# 2.0 added the ability to declare separate visibility for individual getters and setters

There&#8217;s no reason to have public/protected instance fields, so **make all instance fields private**.

### Inconsistent naming conventions

Names of classes, interfaces, and members can convey a great deal of information to clients if used properly.&nbsp; Here&#8217;s a good example of inconsistent naming conventions:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> Order
{
    <span class="kwrd">public</span> Address address { get; set; }
}

<span class="kwrd">public</span> <span class="kwrd">class</span> Quote : Order
{
    <span class="kwrd">public</span> <span class="kwrd">void</span> Process()
    {
        <span class="kwrd">if</span> (address == <span class="kwrd">null</span>)
            <span class="kwrd">throw</span> <span class="kwrd">new</span> InvalidOperationException(<span class="str">"Address is null"</span>);
    }
}
</pre>
</div>

When I&#8217;m down in the &#8220;Process&#8221; method, what is the &#8220;address&#8221; variable?&nbsp; Is it a local variable?&nbsp; Is it a private field?&nbsp; Nope, it&#8217;s a property.&nbsp; Since it&#8217;s declared camelCase instead of PascalCase, it led to confusion on the developer&#8217;s part about what we were dealing with.&nbsp; If it&#8217;s&nbsp;local variable, which the name suggests, I might treat the value much differently than if it were a public property.

Deviations from FDG&#8217;s naming conventions cause confusion.&nbsp; When I&#8217;m using an .NET API that uses Java&#8217;s camelCase conventions, it&#8217;s just one more hoop I have to jump through.&nbsp; In places where my team had public API&#8217;s we were publishing, it wasn&#8217;t even up for discussion whether or not we would follow the naming conventions Microsoft used in the .NET Framework.&nbsp; It just happened, as **any deviation from accepted convention leads to an inconsistent and negative&nbsp;user experience**.

It&#8217;s not worth the time to argue whether interfaces should be prefixed with an &#8220;I&#8221;.&nbsp; That was the accepted convention, so we followed it.&nbsp; Consistent user experience is far more important than petty arguments on naming conventions.&nbsp; If I developed in Java, I&#8217;d happily use camelCase, as it&#8217;s the accepted convention.

Another item you may notice as there are no naming guidelines for instance fields.&nbsp; This reinforces the notion that they should be declared private, and the only people who should care about the names are the developers of that class and the class itself.&nbsp; In that case, just pick a convention, stick to it, and keep it consistent across your codebase so it becomes one less decision for developers.

### Try Catch Publish Swallow

Exception handling can really wreck a system if not done properly.&nbsp; I think developers might be scared of exceptions, given the number of useless try&#8230;catch blocks I&#8217;ve seen around.&nbsp; [Anders Heljsberg](http://en.wikipedia.org/wiki/Anders_Hejlsberg) [notes](http://www.artima.com/intv/handcuffs2.html):

> It is funny how people think that the important thing about exceptions is handling them. That is not the important thing about exceptions. In a well-written application there&#8217;s a ratio of ten to one, in my opinion, of try finally to try catch. Or in C#, `using` statements, which are like try finally.

Here&#8217;s an example of a useless try-catch:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> OrderProcessor
{
    <span class="kwrd">public</span> <span class="kwrd">void</span> Process(Order order)
    {
        <span class="kwrd">try</span>
        {
            ((Quote)order).Process();
        }
        <span class="kwrd">catch</span> (Exception ex)
        {
            ExceptionManager.Publish(ex);
        }
    }
}
</pre>
</div>

In here we have Try Catch Publish Swallow.&nbsp; We put the try block around an area of code that might fail, and catch exceptions in case it does.&nbsp; To handle the exception, we publish it through some means, and then nothing.&nbsp; That&#8217;s [exception swallowing](http://grabbagoft.blogspot.com/2007/06/swallowing-exceptions-is-hazardous-to.html).

Here&#8217;s a short list of problems with TCPS:

  * Exceptions shouldn&#8217;t be used to make decisions
  * If there is an alternative to making decisions based on exceptions, use it (such as the &#8220;as&#8221; operator in the above code)
  * Exceptions are exceptional, and logging exceptions should be done at the highest layer of the application
  * Not re-throwing leads to bad user experience and bad maintainability, as we&#8217;re now relying on exception logs to tell us our code is wrong

Another approach to the example might be:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> OrderProcessor
{
    <span class="kwrd">public</span> <span class="kwrd">void</span> Process(Order order)
    {
        Quote quote = order <span class="kwrd">as</span> Quote;
        
        <span class="kwrd">if</span> (quote != <span class="kwrd">null</span>)
            quote.Process();
    }
}
</pre>
</div>

The only problem this code will have is if &#8220;quote.Process()&#8221; throws an exception, and in that case, we&#8217;ll let the appropriate layer deal with those issues.&nbsp; Since I don&#8217;t any resources to clean up, there&#8217;s no need for a &#8220;try..finally&#8221;.

### Downcasting

I [already wrote about this](http://grabbagoft.blogspot.com/2007/11/downcasting-tragedy.html) recently, but it&#8217;s worth mentioning again.&nbsp; I spent a great deal of time recently removing a boatload of downcasts from a codebase, and it made it even worse that the downcasts were pointless.&nbsp; Nothing in client code was using any additional members in the derived class.&nbsp; It turned out to be a large pointless hoop I needed to jump through to enable testing.

### Regaining sanity

The problem with shortcuts and knowingly bad design decisions is that this behavior can become habitual, and the many indiscretions can add up to disaster.&nbsp; I had a&nbsp;high school&nbsp;band director who taught me **&#8220;Practice doesn&#8217;t make perfect &#8211; perfect practice makes perfect.&#8221;**

By making good decisions every day, it becomes a habit.&nbsp;&nbsp;Good habits practiced over time eventually become etched into your&nbsp;muscle memory so that it&nbsp;doesn&#8217;t require any thought.&nbsp; Until you run into a legacy codebase that is, and you realize how bad your old habits were.