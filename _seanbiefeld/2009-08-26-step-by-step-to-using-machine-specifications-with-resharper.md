---
wordpress_id: 16
title: Step by Step to Using MSpec (Machine.Specifications) with ReSharper
date: 2009-08-26T01:34:00+00:00
author: Sean Biefeld
layout: post
wordpress_guid: /blogs/seanbiefeld/archive/2009/08/25/step-by-step-to-using-machine-specifications-with-resharper.aspx
dsq_thread_id:
  - "449608166"
categories:
  - BDD
  - Behavior Driven Design
  - git
  - MSpec
  - Resharper
  - Specifications
  - Unit Test
redirect_from: "/blogs/seanbiefeld/archive/2009/08/25/step-by-step-to-using-machine-specifications-with-resharper.aspx/"
---
Whilst researching using MSpec with ReSharper I found it difficult to find all the resources I needed in one place. This is an attempt to condense everything into that one place and facilitate those seeking to accomplish the same task.

## Step 1 &#8211; Git It:

First thing&#8217;s first, grab the latest Machine Spec source from github. 

<pre style="background-color: #141414;font-family: Lucida Console;padding: 5px;border:solid 1px #333;overflow: auto;color: #BEBEC8;font-size: 10pt">$ git clone git://github.com/machine/machine.specifications.git mspec</pre>

## Step 2 &#8211; Build It:

Next, open it up in Visual Studio, set it to build in release mode and build it. Now the binaries will be ready for you. 

## Step 3 &#8211; Setup ReSharper:

Now we need to setup ReSharper to be able to utilize the MSpec framework and run the tests in ReSharper&#8217;s test runner. To do this we need to add a plugins directory to the &#8220;JetBrainsReSharperv4.5Bin&#8221; directory or the where ever the bin directory for your ReSharper is located. In the Plugins create a Machine.Specifications directory, so you should now have a path similar to; &#8220;JetBrainsReSharperv4.5BinPluginsMachine.Specifications&#8221;. Place the following dlls in the newly created folder: Machine.Specifications.ReSharperRunner.4.5.dll and Machine.Specifications.dll. 

## Step 4 &#8211; Write some Specifications:

Coolio, now to test some behaviors, the dlls needed in our test project; Machine.Specifications.dll, Machine.Specifications.NUnit.dll or Machine.Specifications.XUnit.dll, and the appropriate test framework dll.

Let&#8217;s take a look at a couple of examples to get used to the syntax. The most common keywords you want to pay attention to are **Subject, Establish, Because** and **It**. Declare the Subject of your Spec, Establish a context of the spec, Because x occurs, It should do something. For more complex scenarios you can use the keyword, **Behaves_like** and the **Behaviors** attribute which allows you to define complex behaviors. If you need to perform some cleanup use the **Cleanup** keyword.

Now for a couple of simple contrived examples&#8230;

This first specification looks at adding two numbers:

<pre style="background-color: #141414;font-family: Lucida Console;padding: 5px;border:solid 1px #333;overflow: auto;color: #BEBEC8;font-size: 10pt">[<span style="color: #7386a5">Subject</span>(<span style="color: #8f9d6a">"adding two operands"</span>)]
<span style="color: #cda869">public class</span> <span style="color: #7386a5">when_adding_two_operands</span>
{
	<span style="color: #cda869">static decimal</span> value;

	<span style="color: #7386a5">Establish</span> context <span style="color: #cda869">=</span> () <span style="color: #cda869">=&gt;</span>
		value <span style="color: #cda869">=</span> <span style="color: #9B7032">0m</span>;

	<span style="color: #7386a5">Because</span> of <span style="color: #cda869">=</span> () <span style="color: #cda869">=&gt;</span>
		value <span style="color: #cda869">= new</span> Operator().Add(<span style="color: #9B7032">42.0m</span>, <span style="color: #9B7032">42.0m</span>);

	<span style="color: #7386a5">It</span> should_add_both_operands <span style="color: #cda869">=</span> () <span style="color: #cda869">=&gt;</span>
		value.ShouldEqual(<span style="color: #9B7032">84.0m</span>);
}</pre>

The second specification looks at adding multiple numbers:

<pre style="background-color: #141414;font-family: Lucida Console;padding: 5px;border:solid 1px #333;overflow: auto;color: #BEBEC8;font-size: 10pt">[<span style="color: #7386a5">Subject</span>(<span style="color: #8f9d6a">"adding multiple operands"</span>)]
<span style="color: #cda869">public class</span> <span style="color: #7386a5">when_adding_multiple_operands</span>
{
	<span style="color: #cda869">static decimal</span> value;

	<span style="color: #7386a5">Establish</span> context <span style="color: #cda869">=</span> () <span style="color: #cda869">=&gt;</span>
		value <span style="color: #cda869">=</span> <span style="color: #9B7032">0m</span>;

	<span style="color: #7386a5">Because</span> of <span style="color: #cda869">=</span> () <span style="color: #cda869">=&gt;</span>
		value <span style="color: #cda869">= new</span> Operator().Add(<span style="color: #9B7032">42m</span>, <span style="color: #9B7032">42m</span>, <span style="color: #9B7032">42m</span>);

	<span style="color: #7386a5">It</span> should_add_all_operands <span style="color: #cda869">=</span> () <span style="color: #cda869">=&gt;</span>
		value.ShouldEqual(<span style="color: #9B7032">126m</span>);
}</pre>

The code being tested:

<pre style="background-color: #141414;font-family: Lucida Console;padding: 5px;border:solid 1px #333;overflow: auto;color: #BEBEC8;font-size: 10pt"><span style="color: #cda869">public class</span> <span style="color: #7386a5">Operator</span>
{
	<span style="color: #cda869">public decimal</span> Add(<span style="color: #cda869">decimal</span> firstOperand, <span style="color: #cda869">decimal</span> secondOperand)
	{
		<span style="color: #cda869">return</span> firstOperand <span style="color: #cda869">+</span> secondOperand;
	}

	<span style="color: #cda869">public decimal</span> Add(<span style="color: #cda869">params decimal</span>[] operands)
	{
		<span style="color: #cda869">decimal</span> value <span style="color: #cda869">=</span> <span style="color: #9B7032">0m</span>;

		<span style="color: #cda869">foreach</span> (<span style="color: #cda869">var</span> operand <span style="color: #cda869">in</span> operands)
		{
			value <span style="color: #cda869">+=</span> operand;
		}

		<span style="color: #cda869">return</span> value;
	}
}</pre>

## Step 5 &#8211; Create Templates to Improve Your Efficiency:

Using ReSharper templates is a good way to improve your spec writing efficiency, the following are templates I have been using.

This first one is for your normal behaviors:

<pre style="background-color: #141414;font-family: Lucida Console;padding: 5px;border:solid 1px #333;overflow: auto;color: #BEBEC8;font-size: 10pt">[Subject("$subject$")]
public class when_<span style="color: #cda869">$when$</span>
{
	Establish context =()=&gt;	{};

	Because of =()=&gt; {};		
	
	It should_$should$ =()=&gt; <span style="color: #7386a5">$END$</span>;
}</pre>

This one&#8217;s for assertions by themselves:

<pre style="background-color: #141414;font-family: Lucida Console;padding: 5px;border:solid 1px #333;overflow: auto;color: #BEBEC8;font-size: 10pt">It should_<span style="color: #cda869">$should$</span> =()=&gt; <span style="color: #7386a5">$END$</span>;</pre>

## Step 6 &#8211; Run the Report

The report generated is pretty much the exact same as the SpecUnit report. The easiest thing to do is place the following MSpec binaries and file in the directory where your test binaries are placed; CommandLine.dll, Machine.Specifications.ConsoleRunner.exe, Machine.Specifications.dll and CommandLine.xml. The command to run the report goes a little something like:

<pre style="background-color: #141414;font-family: Lucida Console;padding: 5px;border:solid 1px #333;overflow: auto;color: #BEBEC8;font-size: 10pt">machine.specifications.consolerunner --html &lt;the location you want the html report stored&gt; &lt;your test dll name&gt;</pre>

This is the report generated from the example specs:


<img src="//lostechies.com/seanbiefeld/files/2011/03/MSpecReportExample.PNG" style="border: solid 1px #ddd" /> 

Well, that&#8217;s about all for now, let me know if you have any questions.