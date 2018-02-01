---
id: 103
title: Updates to NBehave
date: 2008-02-27T04:26:45+00:00
author: Joe Ocampo
layout: post
guid: /blogs/joe_ocampo/archive/2008/02/26/updates-to-nbehave.aspx
dsq_thread_id:
  - "262089201"
categories:
  - BDD (Behavior Driven Development)
---
What happened to NSpec? 

I am not sure if all of you know but the <a href="http://www.codeplex.com/NBehave" target="_blank">NBehave</a> project consolidated with the NSpec project a while back, since then we have been pretty silent about what we are doing because we wanted to give the community something they could simply drop in and not be to evasive in its implementation. Meaning we didn’t want you to have to learn how to use yet another runner. 

What we decided is that NSpec did a lot of cool things but at its heart was an assertion engine. We contemplated if we really wanted to go down the path of creating a whole new assertion engine. This is where <a href="http://weblogs.asp.net/astopford/archive/2007/11/30/mbunit-v3-and-gallio-alpha-1.aspx" target="_blank">Andrew Stopford’s</a> and <a href="http://blog.bits-in-motion.com/" target="_blank">Jeff Brown’s</a> <a href="http://code.google.com/p/mb-unit/wiki/GallioVision" target="_blank">MbUnit 3.0 Gallio engine</a> come in. 

&nbsp;

> “The Gallio platform is an open, extensible, and neutral system that provides a common object model, runtime services and tools (such as test runners) that may be leveraged by any number of test frameworks. In this vision of the world, MbUnit v3 itself is simply another test framework plugin with the same status as any other.”

NBehave will utilize the Gallio extensible test framework and employ as many of the BDD idioms as we can manage to squeeze in. 

This will enable us to offer: 

  * To use any of the 7 current Gallio test runners, including console, GUI, MSBuild, NAnt, PowerShell, ReSharper and TD.Net plus any new ones that are developed.
  * CCNet integration and most anything else that&#8217;s built around Gallio
  * NBehave with Gallio as a bundle.

Pretty cool right? Well as you can imagine this has been ongoing trial an error but the good part is we are working with the Gallio dudes to get something out there. 

So does that mean I have to wait to use BDD then? No… 

We wanted to give you all something now. 

One of the more important constructs of BDD is that we are now specifying how our code should behave under a governed context. Whether that context is story governed or system governed is particular to the situation that is eliciting the invocation. Laymen response it is not just about stories and acceptance testing. 

BDD is about creating a reentrant code base that can be understood by development teams working together to create great software. You should be able to perform a cursory glance at you specifications and understand intentions and expected behavior. The difficult part is that this is going to require the same type of self discipline that TDD fostered. 

So how do you take advantage of this now? 

Well the current repository on Google Code has several features that we think the community can take advantage of now. Thanks go out to David Laribee and JP Boodhoo for the help with the base spec fixture. 

Here is a list of some of the features we have completed and are working towards. 

  * · NUnitSpecBase – **Done**
  * · MbUnitSpecBase &#8211; **Done**
  * · NUnit assertion extensions &#8211; **Done**
  * · MbUnit assertion extensions &#8211; **Done**
  * · Automocking Container &#8211; **Done**
  * · Create MSTest assertion extensions (April 1<sup>st</sup>)
  * · Create xUnit assertion extensions (April 1<sup>st</sup>)
  * · TestDriven.NET integration (April 1<sup>st</sup>)
  * · XML output for stories (April 1<sup>st</sup>)
  * · XSLT for XML story runner output (April 1<sup>st</sup>)

So how do I use these new features? 

  * 1. Download the latest trunk from <a href="http://code.google.com/p/nbehave/" target="_blank">Google Code</a> or wait till April 1<sup>st</sup> for the official build
  * 2. Execute the go.bat
  * 3. Now create a new project and reference the following dll’s from the build folder (this is assuming you are using NUnit)
  * a. Castle.Core
  * b. Castle.DynamicProxy
  * c. Castle.DynamicProxy2
  * d. Castle.MicroKernal
  * e. Castle.Windsor
  * f. NBehave.Spec.Framework
  * g. NBehave.Spec.NUnit
  * h. NUnit.Framework
  * i. Rhino.Mocks
  * j. …The kitchen sink! 

As you can see there are a lot of dependencies but for the most part they are everything you would need to have the optimal BDD experience. 

At this point I am really jealous of <a href="http://www.rubygems.org/" target="_blank">Gem</a>! 🙂 

Here is how you would setup a basic specification fixture. 

Pseudo DSL: 

_these specs are concerning this [Type]  
&nbsp;&nbsp;&nbsp; when this [type] is in this [context]  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; then [specify] that it [should behave] this way_ 

The first thing is to setup the using aliases. 

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">using</span> Context = NUnit.Framework.TestFixtureAttribute;
<span style="color: #0000ff">using</span> Specification = NUnit.Framework.TestAttribute;
<span style="color: #0000ff">using</span> Concerning = NUnit.Framework.CategoryAttribute;
</pre>
</div>

Then use the namespace to define the concerning type:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">namespace</span> MathFlash.Core.EquationGenerator_Specs</pre>
</div>

In the case above the specs in this file are going to be concerning EquationGenerator_Specs.

Now let’s define our first context.

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">[Context, Concerning(<span style="color: #006080">"EquationGenerator"</span>)]</pre>
</div>

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> When_initializing_the_EquationGenerator_with_one_and_five : NUnitSpecBase</pre>
</div>

As you can see we have defined a class decorated with a Context attribute and a Concerning attribute. We have also inherited from the NUnitSpecBase. The name of the class is defining the context that will govern the expected behavior that we will assert on later.

Next we will define our first specification.

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">[Specification]
<span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Should_generate_equations_where_the_left_hand_side_is_greater_than_or_equal_to_the_lower_bound()
</pre>
</div>

So you have defined a context and specified expected behavior. What is so important about the NUnitSpecBase. Well for one it abstracts the use of the automocking container (I will have a post on that in the next couple of days). It also has several new method conventions that have their roots in rSpec.

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Before_each_spec()</pre>
</div>

This method will be called before\_each\_spec similar to the SetUpAttribute.

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> After_each_spec()</pre>
</div>

This method will be called after\_each\_spec similar to the TearDownAttribute.

Last but not least are the NUnit extension methods. You have two options. You can use the standard CamelCase notation or you can use to more readable underscore notation. For example:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">equation.LeftHandSide.ShouldBeGreaterThanOrEqualTo(_lowerBound);</pre>
</div>

or

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">equation.LeftHandSide.should_be_greater_than_or_equal_to(_lowerBound);</pre>
</div>

Why did we give you both? Because we just couldn’t decide on which one to use just yet. I am sure in the end we will decide on one but for now you will have both options. If anything it gets you ready for rSpec once IronRuby is baked! 

This is only the beginning. We have a lot more planned for future releases and Gallio will open the door for even more exciting possibilities.

For reference here are all the specs.

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">using</span> System.Collections.Generic;
<span style="color: #0000ff">using</span> MathFlash.Core.Domain;
<span style="color: #0000ff">using</span> NBehave.Spec.NUnit;
<span style="color: #0000ff">using</span> Context = NUnit.Framework.TestFixtureAttribute;
<span style="color: #0000ff">using</span> Specification = NUnit.Framework.TestAttribute;

<span style="color: #0000ff">namespace</span> MathFlash.Core.EquationGenerator_Specs
{
    [Context]
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> When_initializing_the_EquationGenerator_with_one_and_five : NUnitSpecBase
    {
        <span style="color: #0000ff">private</span> EquationGenerator _generator;
        <span style="color: #0000ff">private</span> <span style="color: #0000ff">int</span> _lowerBound = 1;
        <span style="color: #0000ff">private</span> <span style="color: #0000ff">int</span> _upperBound = 5;

        <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Before_each_spec()
        {
            _generator = <span style="color: #0000ff">new</span> EquationGenerator(_lowerBound, _upperBound);
        }

        [Specification]
        <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Should_generate_equations_where_the_left_hand_side_is_greater_than_or_equal_to_the_lower_bound()
        {
            <span style="color: #0000ff">foreach</span> (var equation <span style="color: #0000ff">in</span> _generator.GenerateEquations())
            {
                equation.LeftHandSide.should_be_greater_than_or_equal_to(_lowerBound);
            }
        }

        [Specification]
        <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Should_generate_equations_where_the_left_hand_side_is_less_than_or_equal_to_the_upper_bound()
        {
            <span style="color: #0000ff">foreach</span> (var equation <span style="color: #0000ff">in</span> _generator.GenerateEquations())
            {
                equation.LeftHandSide.should_be_less_than_or_equal_to(_upperBound);
            }
        }

        [Specification]
        <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Should_generate_equations_where_the_right_hand_side_is_greater_than_or_equal_to_the_lower_bound()
        {
            <span style="color: #0000ff">foreach</span> (var equation <span style="color: #0000ff">in</span> _generator.GenerateEquations())
            {
                equation.RightHandSide.should_be_greater_than_or_equal_to(_lowerBound);
            }
        }

        [Specification]
        <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Should_generate_equations_where_the_right_hand_side_is_less_than_or_equal_to_the_upper_bound()
        {
            <span style="color: #0000ff">foreach</span> (var equation <span style="color: #0000ff">in</span> _generator.GenerateEquations())
            {
                equation.RightHandSide.should_be_less_than_or_equal_to(_upperBound);
            }
        }

        [Specification]
        <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Should_generate_twenty_five_equations()
        {
            var equations = _generator.GenerateEquations();

            equations.Count.should_equal(25);
        }
    }
}</pre>
</div>