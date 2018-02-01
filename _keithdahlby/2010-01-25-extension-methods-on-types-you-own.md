---
id: 4205
title: Extension Methods on Types You Own?
date: 2010-01-25T11:00:00+00:00
author: Keith Dahlby
layout: post
guid: /blogs/dahlbyk/archive/2010/01/25/extension-methods-on-types-you-own.aspx
dsq_thread_id:
  - "263510198"
categories:
  - Uncategorized
---
It&#8217;s no secret that I&#8217;m a fan of using extension methods to make
  
code more concise and expressive. This is particularly handy for
  
enhancing APIs outside of your control, from the base class library to
  
ASP.NET MVC and SharePoint. However, there are certain situations where
  
it might be useful to use extension methods even though you have the
  
option to add those methods to the class or interface itself. Consider
  
this simplified caching interface:

<pre>public interface ICacheProvider<br />{<br />    T Get&lt;T&gt;(string key);<br />    void Insert&lt;T&gt;(string key, T value);<br />}<br /></pre>

And a simple application of the [decorator pattern](http://en.wikipedia.org/wiki/Decorator_pattern "Decorator pattern - Wikipedia") to implement a cached repository:

<pre>public class CachedAwesomeRepository : IAwesomeRepository<br />{<br />    private readonly IAwesomeRepository awesomeRepository;<br />    private readonly ICacheProvider cacheProvider;<br /><br />    public CachedAwesomeRepository(IAwesomeRepository awesomeRepository, ICacheProvider cacheProvider)<br />    {<br />        this.awesomeRepository = awesomeRepository;<br />        this.cacheProvider = cacheProvider;<br />    }<br /><br />    public Awesome GetAwesome(string id)<br />    {<br />        var awesome = cacheProvider.Get&lt;Awesome&gt;(id);<br />        if(awesome == null)<br />            cacheProvider.Insert(id, (awesome = awesomeRepository.GetAwesome(id)));<br />        return awesome;<br />    }<br />}<br /></pre>

So far, so good. However, as caching is used more often it becomes
  
clear that there&#8217;s a common pattern that we might want to extract:

<pre>&nbsp;&nbsp;&nbsp; T ICacheProvider.GetOrInsert&lt;T&gt;(string key, Func&lt;T&gt; valueFactory)<br />    {<br />        T value = Get&lt;T&gt;(key);<br />        if(value == default(T))<br />            Insert(key, (value = valueFactory()));<br />        return value;<br />    }</pre>

Which would reduce `GetAwesome()` to a single, simple expression:

<pre>public Awesome GetAwesome(string id)<br />    {<br />        return cacheProvider.GetOrInsert(id, () =&gt; awesomeRepository.GetAwesome(id));<br />    }</pre>

Now I just need to decide where `GetOrInsert()` lives. Since I control `ICacheProvider`,
  
I could just add another method to the interface and update all its
  
implementers. However, after starting down this path, I concluded this
  
was not desirable for a number of reasons:

  1. The implementation of GetOrInsert within each cache provider was essentially identical.
  2. Tests using a mocked ICacheProvider now needed to know if the code
  
    under test used GetOrInsert() or Get() + Insert(), coupling the test
  
    too tightly to the implementation. Furthermore, natural tests along the
  
    lines of &#8220;Should return cached value&#8221; and &#8220;Should insert value from
  
    repository if not cached&#8221; were replaced with a single
  
    implementation-specific test: &#8220;Should return value from GetOrInsert&#8221;.
  3. Most importantly, I came to realize that GetOrInsert() really just
  
    isn&#8217;t something that a cache does, so why should it be part of the
  
    interface?

So instead I have a handy `GetOrInsert()` extension
  
method (conversion is left as an exercise for the reader) that I can
  
use to clean up my caching code without needing to change any of my
  
cache providers or tests for existing consumers.

The question is really analogous to whether or not `Select()` and `Where()` should be part of `IEnumerable<T>`. They are certainly useful ways to consume the interface, just as `GetOrInsert()` is, but they exist outside of what an `IEnumerable<T>` really is.