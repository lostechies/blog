---
id: 252
title: Where TDD fails for me
date: 2008-11-18T02:49:53+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/11/17/where-tdd-fails-for-me.aspx
dsq_thread_id:
  - "264715971"
categories:
  - TDD
---
TDD is by far the sharpest tool in my belt.&#160; The simplicity of client-driven design combined with the safety net of unit tests allow me to build software at a remarkable constant pace.&#160; At the edges of most of the applications I’ve worked on are areas where TDD has completely fallen flat on its face (for me).&#160; It’s a little disheartening when these areas are always around frameworks that I can’t change.&#160; These are areas where adding unit tests provides coverage, but completely fails in the “tests as documentation” category.&#160; Or, it’s in an area where testing is difficult or impossible, regardless of the available tools at your disposal.

My current TDD failures are around NHibernate and ASP.NET MVC, but they both center around a common theme – **I’m deep in the extensibility points of someone else’s framework.**&#160; These frameworks offer great extensibility points, but often at the cost of the final result making any sense whatsoever.&#160; Perhaps it’s how I practice TDD, as I like to start on the outermost visible behavior, and let client-driven code direct the design underneath.&#160; Often the outermost behavior leaves little point to TDD internal implementation details.&#160; Other times, the outermost visible behavior is voodoo to get set up, and verification impossible for the next developer to understand.

### Example 1 – Extensibility through inheritance

In NHibernate, mapping from types to the database at the property level is done through a set of IType implementations.&#160; These mappings provide the logic to map from System.Decimal to something out of an IDataReader.&#160; Often, we need to provide custom mapping types to do things like map values from enumerations, custom Value Object types, or dealing with legacy databases.&#160; NHibernate is fantastic in that regard, as there has not been a problem I’ve thrown at it that I haven’t been able to solve with an obvious extensibility point.&#160; _Side note – this is common with good OSS frameworks – feedback from the community funnels back in to further refine the design._

The one issue with these extensibility points is that it is completely non-obvious to unit test one of these implementations.&#160; Here’s one example of an implementation:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">DummyCustomType </span>: <span style="color: #2b91af">PrimitiveType
</span>{
    <span style="color: blue">public </span>DummyCustomType()
        : <span style="color: blue">base</span>(<span style="color: blue">new </span><span style="color: #2b91af">SqlType</span>(<span style="color: #2b91af">DbType</span>.String))
    {
    }

    <span style="color: blue">public override object </span>Get(<span style="color: #2b91af">IDataReader </span>rs, <span style="color: blue">int </span>index)
    {
        <span style="color: blue">var </span>o = rs[index];
        <span style="color: blue">var </span>value = o.ToString();
        <span style="color: blue">return </span>value;
    }

    <span style="color: blue">public override object </span>Get(<span style="color: #2b91af">IDataReader </span>rs, <span style="color: blue">string </span>name)
    {
        <span style="color: blue">int </span>ordinal = rs.GetOrdinal(name);
        <span style="color: blue">return </span>Get(rs, ordinal);
    }

    <span style="color: green">/* etc etc etc */
</span>}</pre>

[](http://11011.net/software/vspaste)

Blah blah blah.&#160; I can TDD individual pieces, but notice that I’m inheriting from PrimitiveType – an NHibernate extensibility point.&#160; But are unit tests valuable here&#8217;?&#160; I think not, as the true test as to whether this custom type works is in the context of where it is used – NHibernate.&#160; Instead of testing the individual class, I’ll define the behavior I want against NHibernate, usually by loading up entities that match up to the scenarios I’m interested in.

So it’s very rare that I TDD an extensibility point driven through inheritance.&#160; The voodoo going on underneath in the base type would put too much knowledge into the test of an implementation that I can’t often see without Reflector, so where is the value?&#160; I don’t really see any.&#160; Some of the pieces I have to implement I don’t even know why I need, so I leave “throw new NotImplementedException” in, and wait for my application to blow up and tell me why I need that piece.&#160; It’s another reason I see 100% coverage as a goal that has to be balanced against other concerns.

In cases of extensibility through inheritance, it’s only the macro behavior I care about.&#160; I could care less how the specific extensibility is used – all I care about is that the eventual result of my cog in the giant machine works as specified.

### Example 2 – Thorny observations

How do I TDD a custom WebForms control?&#160; Or an ASP.NET MVC ActionFilterAttribute?&#160; I know I can create the crazy dependencies required – such as the ActionExecutingContext – but what exactly is this telling me?&#160; The final result, or verification, is the action filter plugged in to the complete pipeline.&#160; Otherwise, I’m only verifying that it’s doing exactly what I told it to do – not what I _need_ it to do.&#160; In domain model specifications, I describe how I want the model to behave under specific conditions.&#160; I could TDD this:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">AdminRoleFilterAttribute </span>: <span style="color: #2b91af">ActionFilterAttribute
</span>{
    <span style="color: blue">public override void </span>OnActionExecuting(<span style="color: #2b91af">ActionExecutingContext </span>filterContext)
    {
        <span style="color: blue">if </span>(filterContext.HttpContext.User.IsInRole(<span style="color: #a31515">"Administrator"</span>))
        {
            filterContext.Result = <span style="color: blue">new </span><span style="color: #2b91af">RedirectResult</span>(<span style="color: #a31515">"/unauthorized"</span>);
        }
    }
}</pre>

[](http://11011.net/software/vspaste)

But honestly, only after a spike.&#160; And if I did spike this, how would I get back here?&#160; TDD would lead to a big disconnect between what I was verifying (that some Result is set under certain conditions) and what I actually want to happen.&#160; TDD’ing this part requires knowledge of _how_ the final result is used, leaving the eventual maintainer of the code to guess that this result hopefully has the desired effect.

What I’d _really_ like to verify is that a user gets redirected when they are not an administrator.&#160; However, I have to poke around a lot of framework pieces to get that.&#160; I understand those actions are part of using a framework, but it’s up to the next developer to make the jump that hopefully, I did my homework and that setting that Result to that value will have the desired end behavior.&#160; End behavior I can’t test easily, as it’s really a browser-level interaction test.

I usually still TDD these scenarios, but only after a spike.&#160; And all I’m really doing is TDD’ing back to the point where I knew things were working in my prototype.&#160; At that point, I still do manual, one-time-only verifications that what I did actually created the behavior I wanted.&#160; Because the unit tests didn’t really do that, they just verified I’m using the framework in the way I specified.

### Whack-a-mole

In the end, I’ve noticed my tests around framework interactions have the least amount of value.&#160; They definitely have value, but the act of TDD is severely stunted as I’m playing by someone else’s rules.&#160; I can verify my little cog behaves exactly how I specify in isolation, but that’s pointless if it fails when inserted back into the big machine.&#160; Sometimes I can verify the output of the big machine, as in NHibernate, and sometimes it’s very difficult, or slow, as in ASP.NET MVC’s example (and other web frameworks).

Not only do these tests have less value, but they tend to be far more brittle than tests against POCOs, or even services where I have the Dependency Inversion Principle in play.&#160; I create some custom NHibernate type, hooray!&#160; But what about the dozen other scenarios for legacy data I don’t know about?&#160; Or, when the only true verification is a manual or slow verification of an ASP.NET MVC implementation detail?

The unit tests themselves still provide value, but even tools like TypeMock wouldn’t solve the issue.&#160; The issue isn’t that I can’t mock the framework, it’s that the framework in action is the only true verification of the intended behavior.&#160; I’m not getting nearly as much, if any, client-driven design benefits when TDD’ing framework extensibility points.