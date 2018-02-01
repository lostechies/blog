---
id: 23
title: Lazy Loaded Interceptors
date: 2008-11-09T20:56:01+00:00
author: Mo Khan
layout: post
guid: /blogs/mokhan/archive/2008/11/09/lazy-loaded-interceptors.aspx
categories:
  - Books
  - Design Patterns
  - TDD
  - Tools
---
[<img src="http://mokhan.ca/blog/content/binary/51X1K7R6FGL._SL160_.jpg" align="left" border="0" />](http://www.amazon.com/gp/product/0321127420?ie=UTF8&tag=mokhthliofawa-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=0321127420) 

****

**[Patterns of Enterprise Application Architecture](http://www.amazon.com/gp/product/0321127420?ie=UTF8&tag=mokhthliofawa-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=0321127420)** defines **Lazy Load** as:

> An object that doesn&#8217;t contain all of the data you need but knows how to get it.
> 
> &nbsp;

A while back I was trying to figure out how to lazy load objects from a container, so that I didn&#8217;t need to depend on the objects dependencies needing to be wired up in the correct order. The syntax I was looking for was something like the following&#8230;.

<pre>&nbsp;</pre>

<pre>container.AddProxyOf(
    <span style="color: blue">new </span>ReportPresenterTaskConfiguration(),
    <span style="color: blue">new </span>ReportPresenterTask(
        <span style="color: #2b91af">Lazy</span>.Load&lt;IReportDocumentBuilder&gt;(),
        <span style="color: #2b91af">Lazy</span>.Load&lt;IApplicationSettings&gt;())
    );</pre>

Lazy.Load<T> will return a proxy in place of an actual implementation. This is just a temporary place holder that will forward the calls to the actual implementation. It wont load an instance of the actual type until the first time a call is made to it.

<pre><span style="color: blue">public class </span><span style="color: #2b91af">when_calling_a_method_with_no_arguments_on_a_lazy_loaded_proxy </span>: <span style="color: #2b91af">lazy_loaded_object_context
</span>{
    [<span style="color: #2b91af">Observation</span>]
    <span style="color: blue">public void </span>should_forward_the_original_call_to_the_target()
    {
        target.should_have_been_asked_to(t =&gt; t.OneMethod());
    }

    <span style="color: blue">protected override void </span>establish_context()
    {
        target = dependency&lt;<span style="color: #2b91af">ITargetObject</span>&gt;();

        test_container
            .setup_result_for(t =&gt; t.find_an_implementation_of&lt;<span style="color: #2b91af">ITargetObject</span>&gt;())
            .will_return(target)
            .Repeat.Once();
    }

    <span style="color: blue">protected override void </span>because_of()
    {
        <span style="color: blue">var </span>result = <span style="color: #2b91af">Lazy</span>.Load&lt;<span style="color: #2b91af">ITargetObject</span>&gt;();
        result.OneMethod();
    }

    <span style="color: blue">private </span><span style="color: #2b91af">ITargetObject </span>target;
}</pre>

So when the method &#8220;OneMethod&#8221; is called on the proxy. It should forward the call to the target, which can be loaded from the container. The implementation depends on [Castle DynamicProxy](http://www.castleproject.org/dynamicproxy/index.html), and looks like the following&#8230;

<pre><span style="color: blue">public static class </span><span style="color: #2b91af">Lazy
</span>{
    <span style="color: blue">public static </span>T Load&lt;T&gt;() <span style="color: blue">where </span>T : <span style="color: blue">class
    </span>{
        <span style="color: blue">return </span>create_proxy_for&lt;T&gt;(create_interceptor_for&lt;T&gt;());
    }

    <span style="color: blue">private static </span><span style="color: #2b91af">LazyLoadedInterceptor</span>&lt;T&gt; create_interceptor_for&lt;T&gt;() <span style="color: blue">where </span>T : <span style="color: blue">class
    </span>{
        <span style="color: #2b91af">Func</span>&lt;T&gt; get_the_implementation = <span style="color: #2b91af">resolve</span>.dependency_for&lt;T&gt;;
        <span style="color: blue">return new </span><span style="color: #2b91af">LazyLoadedInterceptor</span>&lt;T&gt;(get_the_implementation.memorize());
    }

    <span style="color: blue">private static </span>T create_proxy_for&lt;T&gt;(<span style="color: #2b91af">IInterceptor </span>interceptor)
    {
        <span style="color: blue">return new </span><span style="color: #2b91af">ProxyGenerator</span>().CreateInterfaceProxyWithoutTarget&lt;T&gt;(interceptor);
    }
}

<span style="color: blue">internal class </span><span style="color: #2b91af">LazyLoadedInterceptor</span>&lt;T&gt; : <span style="color: #2b91af">IInterceptor
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">Func</span>&lt;T&gt; get_the_implementation;

    <span style="color: blue">public </span>LazyLoadedInterceptor(<span style="color: #2b91af">Func</span>&lt;T&gt; get_the_implementation)
    {
        <span style="color: blue">this</span>.get_the_implementation = get_the_implementation;
    }

    <span style="color: blue">public void </span>Intercept(<span style="color: #2b91af">IInvocation </span>invocation)
    {
        <span style="color: blue">var </span>method = invocation.GetConcreteMethodInvocationTarget();
        invocation.ReturnValue = method.Invoke(get_the_implementation(), invocation.Arguments);
    }
}

<span style="color: blue">public static class </span><span style="color: #2b91af">func_extensions
</span>{
    <span style="color: blue">public static </span><span style="color: #2b91af">Func</span>&lt;T&gt; memorize&lt;T&gt;(<span style="color: blue">this </span><span style="color: #2b91af">Func</span>&lt;T&gt; item) <span style="color: blue">where </span>T : <span style="color: blue">class
    </span>{
        T the_implementation = <span style="color: blue">null</span>;
        <span style="color: blue">return </span>() =&gt; {
                   <span style="color: blue">if </span>(<span style="color: blue">null </span>== the_implementation) {
                       the_implementation = item();
                   }
                   <span style="color: blue">return </span>the_implementation;
               };
    }
}</pre>

&#8220;resolve&#8221; is a [static gateway](http://blog.jpboodhoo.com/TheStaticGatewayPattern.aspx) to the underlying IDependencyRegistry. This idea was totally inspired by JP&#8217;s [strongly typed selective proxies](http://blog.jpboodhoo.com/ExplicitStronglyTypedSelectiveProxies.aspx). If you haven&#8217;t already, you should definitely check it out.

[Download the source.](http://mokhan.ca/blog/content/binary/interceptors.rar)