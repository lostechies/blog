---
wordpress_id: 4609
title: Singletons Are Evil Part 2
date: 2009-08-14T01:58:00+00:00
author: Scott Densmore
layout: post
wordpress_guid: /blogs/scottdensmore/archive/2009/08/13/singletons-are-evil-part-2.aspx
dsq_thread_id:
  - "270690804"
categories:
  - Uncategorized
---
<p style="clear: both">
  A while back I wrote a post about why <a href="http://blogs.msdn.com/scottdensmore/archive/2004/05/25/140827.aspx">singletons are evil</a>. I still agree with that statement, yet after my comment on twitter today, I think I need to show how you can solve this problem differently.
</p>

The first problem we need to solve is creating the instance itself. This can become difficult if we have dependencies and we are trying to limit the creation. For example we have class Foo that is our singleton:

<pre style="clear: both">public static class Foo
{
	static Foo instance;
	
	public static Foo Current
	{
		if (instance == null)
		{
			instance = new Foo();
		}
		return instance;
	}
	
	public void SomeMethod()
	{}
	
	public void SomeOtherMethod(int x, int y)
	{}
}
</pre>

<p style="clear: both">
  Great! Easy enough and no big issues other than this is quite contrived and nothing in the real world is this easy. So lets go ahead and tackle the next big problem: Multithreading. We fix our class with a double check lock and end up with this:
</p>

<pre style="clear: both">public static class Foo
{
	static volatile Foo instance;
	static object syncObj = new object();
	
	public static Foo Current
	{
		if (instance == null)
		{
			lock (syncObj)
			{
				if (instance == null)
					instance = new Foo();
			}
		}
		return instance;
	}
	
	public void SomeMethod()
	{}
	
	public void SomeOtherMethod(int x, int y)
	{}
}
</pre>

<p style="clear: both">
  I am starting to feel a little dirty, but I can handle a little dirt. Now we are good except that Foo now has a dependency: Bar. Why the dependency? Well that is the object that we use to get some of the information we want in our singleton. Ok, lets see what this looks like:
</p>

<pre style="clear: both">public static class Foo
{
	readonly Bar bar;
	static volatile Foo instance;
	static object syncObj = new object();
	
	private Foo(Bar bar)
	{
		this.bar = bar;
	}
	
	public static Foo Current
	{
		if (instance == null)
		{
			lock (syncObj)
			{
				if (instance == null)
					instance = new Foo(new Bar(new Baz()));
			}
		}
		return instance;
	}
	
	public void SomeMethod()
	{}
	
	public void SomeOtherMethod(int x, int y)
	{}
}
</pre>

<p style="clear: both">
  At this point alarm bells should be going off and your brain should be going to <a href="http://en.wikipedia.org/wiki/DEFCON">DEFCON 1</a>. We introduced Bar only to see that it needed a Baz. We have violated SRP and coupled all our classes together. Now imagine writing a test around any class that needed to use Foo. You get one Foo and all its dependencies that need to be cleared between tests. This causes you to write that clear method on your class that really is only needed to get rid of state you were trying to support anyway.
</p>

<p style="clear: both">
  So hopefully by now, we agree that this is evil. Yet, I agree that singletons are something useful in the right scenario. So how can you avoid <a href="http://en.wikipedia.org/wiki/WarGames">Global Thermonuclear War</a> when using a singleton? Well fire up your trusty IoC container and let it manage it for you. Here is an example in <a href="http://msdn.microsoft.com/en-us/library/dd203104.aspx">Unity</a>.
</p>

<pre style="clear: both">public class Baz{}
public class Bar
{
	readonly Baz baz;
	
	public Bar(Baz baz)
	{
		this.baz = baz;
	}
}

public class Foo
{
	readonly Bar Bar;

	public Foo(Bar bar, Baz baz)
        {
		Bar = bar;
		Baz = baz;
	}
	
	public void SomeMethod()
	{}
	
	public void SomeOtherMethod(int x, int y)
	{}
}
...
IUnityContainer container = new UnityContainer();
container.RegisterType(typeof(Baz), typeof(Baz));
container.RegisterType(typeof(Bar), typeof(Bar));
container.RegisterType(typeof(Foo), typeof(Foo), new ContainerControlledLifetimeManager());
</pre>

<p style="clear: both">
  Now we have separated the creation of the object and it&#8217;s life time from the object itself. This way we let the container handle the singletoness of the object and it&#8217;s creation. You still have to deal with multithreaded access to the dependencies of Foo, but when you decide that is just way to evil and there are better ways to solve this problem, you can change the lifetime management and go on about your business. This also frees you up to easily test this object and perform refactorings (like the ones <a href="/blogs/sean_chambers/">Sean</a> is talking about this month).
</p>

<p style="clear: both">
  Did I mention singletons are evil?
</p>

<p style="clear: both">
  <a href="http://www.last.fm/music/Opeth/_/Deliverance">Deliverance</a> by <a href="http://www.last.fm/music/Opeth">Opeth</a>
</p>

<br class="final-break" />