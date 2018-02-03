---
wordpress_id: 4682
title: 'Working with Interfaces Part Two &#8211; Decoupling'
date: 2007-10-09T20:47:00+00:00
author: Colin Ramsay
layout: post
wordpress_guid: /blogs/colin_ramsay/archive/2007/10/09/working-with-interfaces-part-one-decoupling.aspx
categories:
  - 'c# practices interfaces'
---
In the first part of this mini-series I talked about the basic use of interfaces, which is to provide a contract for your developers to work to. In this part, I&#8217;m going to try and demonstrate how interfaces can be used to make your application more flexible. This is probably the most common type of tutorial on interfaces you&#8217;ll see around the web, so forgive me for adding another.


  


Here&#8217;s an example of traditional style development, without interfaces:

`<PRE>public class YoGenerator<br />
{<br />
	public string Generate()<br />
	{<br />
		return &#8220;yo!&#8221;;<br />
	}<br />
}</p>
<p>public class Greeter<br />
{<br />
	public void SaySomething()<br />
	{<br />
		YoGenerator yoGenerator = new YoGenerator();</p>
<p>		Console.WriteLine(yoGenerator.Generate());<br />
	}<br />
}</p>
<p>public class Program<br />
{<br />
	public static void Main()<br />
	{<br />
		new Greeter().SaySomething();<br />
	}<br />
}</PRE>`
  


So we&#8217;ve got a program that creates a new Greeter class and calls the SaySomething method on it. The Greeter class in turn calls a YoGenerator&#8217;s Generate method to output &#8220;yo!&#8221; to the console. This should all be fairly straightforward so far and if not, well, you&#8217;ve got bigger worries than what an interface is for.


  


So, the first step on making this a more useful application (I say that in the loosest terms, I&#8217;m not sure how much mileage you can get out of an app that says &#8220;yo!&#8221;) is to refactor by extracting an interface from the YoGenerator class and make YoGenerator inherit it:

`<PRE>public interface IGreetingGenerator<br />
{<br />
	string Generate();<br />
}</p>
<p>public class YoGenerator : IGreetingGenerator<br />
{<br />
	public string Generate()<br />
	{<br />
		return &#8220;yo!&#8221;;<br />
	}<br />
}</PRE>`
  


In terms of what our app now does, nothing has changed. It still outputs &#8220;yo!&#8221; to the console and it still does it using the same mechanism. However, we can now make an additional change which opens up more options:

`<PRE>public class Greeter<br />
{<br />
	public void SaySomething(IGreetingGenerator greetingGenerator)<br />
	{<br />
		Console.WriteLine(greetingGenerator.Generate());<br />
	}<br />
}<br />
</PRE>`
  


That&#8217;s a fairly big jump if you&#8217;re not familiar with interfaces. We&#8217;re saying that SaySomething now takes one parameter &#8211; an instance of a class which implements IGreetingGenerator. That&#8217;s an important piece of information, because while you can&#8217;t directly create a new instance of IGreetingGenerator, you can pass implementing classes round in this way. And because IGreetingGenerator defines a method Generate, we&#8217;re able to call that on the instance we&#8217;re passing in. The final piece of the puzzle involves supplying SaySomething with an instance of a class that implements IGreetingGenerator. And remember how we changed YoGenerator to implement IGreetingGenerator&#8230;?

`<PRE>public class Program<br />
{<br />
	public static void Main()<br />
	{<br />
		new Greeter().SaySomething(new YoGenerator());<br />
	}<br />
}</PRE>`
  


So we instantiate a new YoGenerator which is also typeof IGreetingGenerator, and pass that to SaySomething. In the process, we&#8217;ve extracted SaySomething&#8217;s dependancy on YoGenerator&#8230; What does that mean for us? Well it means we can pass in new greeting generators to affect the behaviour of SaySomething, without actually having to change SaySomething&#8217;s code:

`<PRE>public class DrunkenGreetingGenerator : IGreetingGenerator<br />
{<br />
	public string Generate()<br />
	{<br />
		return &#8220;i lovzshh u mannn!!?!&#8221;;<br />
	}<br />
}</p>
<p>public class Program<br />
{<br />
	public static void Main()<br />
	{<br />
		new Greeter().SaySomething(new DrunkenGreetingGenerator());<br />
	}<br />
}</PRE>`
  


With a bit of forward thinking we can make the Greeter class work independently of other classes &#8211; we&#8217;ve _decoupled_ it from YoGenerator and given it freedom to work with any class that implements IGreetingGenerator.