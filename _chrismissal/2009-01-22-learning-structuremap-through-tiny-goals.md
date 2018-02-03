---
wordpress_id: 3340
title: Learning StructureMap Through Tiny Goals
date: 2009-01-22T13:21:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2009/01/22/learning-structuremap-through-tiny-goals.aspx
dsq_thread_id:
  - "262878078"
categories:
  - IoC
  - StructureMap
---
While I&#8217;ve been using [Castle&#8217;s Windsor](http://www.castleproject.org/container/ "Castle's Windsor Inversion of Control Container") for a bit now, but wanted to get some [StructureMap](http://structuremap.sourceforge.net/Default.htm "StructureMap Home Page") code running just to get some exposure to it; I&#8217;ve heard good things. I decided to set a simple goal and try to achieve it using StructureMap. Here&#8217;s my goal:

&nbsp;&nbsp;&nbsp; 1. Request a concrete type of an interface and run a method.   
&nbsp;&nbsp;&nbsp; 2. Change the implementation of the interface (during runtime) and run the same method to compare against the original.  
&nbsp;&nbsp;&nbsp; 3. Toggle back to the originally configured class.  
&nbsp;&nbsp;&nbsp;   
I assumed that building a small &#8220;one-off&#8221; project that could do this would give me a good start to understanding the StructureMap syntax. The idea stemmed from thoughts of logging certain data using an administrative login. By swapping out the runtime type without rebuilding the application, you can apply different logic ([via a Decorator Patttern](http://codebetter.com/blogs/david.hayden/archive/2008/09/30/decorator-pattern.aspx "The Decorator Pattern")) to track timings and any other data available to you.

My example is quite boring and [unfortunately not useful or real-world](http://www.jasonbock.net/JB/Default.aspx?blog=entry.205091e477df424a81c0f498bed74f1a "Code is Always Sacred - Demo Code"), but it gets the job done to give me a base to get something like this set-up. I have my Interface and Classes code as the following:

<textarea name="code" cols="60" rows="10">public interface IPrinter<br /> {<br /> void Print();<br /> }<br /> public class NamePrinter : IPrinter<br /> {<br /> public void Print()<br /> {<br /> Console.WriteLine(GetType().Name);<br /> }<br /> }<br /> public class FullNamePrinter : IPrinter<br /> {<br /> public void Print()<br /> {<br /> Console.WriteLine(GetType().FullName);<br /> }<br /> }<br /> </textarea>

You&#8217;ll see the only difference is the output of the Print() function. Now swapping between the two, I&#8217;d expect different results, all during runtime, during my main method, as follows:

<textarea name="code" cols="60" rows="10">public class Program<br /> {<br /> private static void Main(string[] args)<br /> {<br /> Bootstrapper.Bootstrap();<br /> var runner = ObjectFactory.GetInstance<Runner>();<br /> runner.Print(4);<br /> ObjectFactory.Configure(x => x.ForRequestedType<IPrinter>().TheDefaultIsConcreteType<FullNamePrinter>());<br /> runner = ObjectFactory.GetInstance<Runner>();<br /> runner.Print(4);<br /> ObjectFactory.Configure(x => x.ForRequestedType<IPrinter>().TheDefaultIsConcreteType<NamePrinter>());<br /> runner = ObjectFactory.GetInstance<Runner>();<br /> runner.Print(4);<br /> }<br /> }<br /> </textarea>

![](//lostechies.com/chrismissal/files/2011/03/learnStructureMap.png)

This requests the concrete implementation of my interface and executes the method. The following step is to change to another type that implements the interface, thus [agreeing to the contract](http://devlicio.us/blogs/derik_whittaker/archive/2008/12/23/now-referring-to-interfaces-as-contracts-in-code-and-conversation.aspx "Now referring to Interfaces as Contracts in code and conversation") and running the same method. Obviously it implements it differently, only for visualization purposes, then toggle back to the original.

During this &#8220;swapping&#8221; all I&#8217;m doing is requesting another instance of the Runner class. The Runner class has a constructor dependency on IPrinter, which is &#8220;injected&#8221; during creation. This is how it gets the new version of the IPrinter object, which is now different, via StructurMap&#8217;s Inversion of Control; thus creating the differing output when asked to run the Print() method.

For anybody familiar with IoC and DI this might seem &#8220;old-hat&#8221;, but I thought this small sample forcing myself to use and IoC that I&#8217;m not familiar with, that would give me a decent base to look into using it for another project. So far I really like the syntax, it seems a lot more natural to me.

For a bit more on the topic, see: [Jan Van Ryswyck&#8217;s Post](http://elegantcode.com/2008/12/12/learning-about-structuremap/ "Jan Van Ryswyck's Post on Learning StructureMap") and [Jeremy Miller&#8217;s Post on Interception Capabilities](http://codebetter.com/blogs/jeremy.miller/archive/2009/01/21/interception-capabilities-of-structuremap-2-5.aspx "Interception capabilities of StructureMap 2.5 "); they helped me.