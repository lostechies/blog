---
wordpress_id: 57
title: Template Delegate Pattern
date: 2007-08-30T00:51:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/08/29/template-delegate-pattern.aspx
dsq_thread_id:
  - "268581945"
categories:
  - 'C#'
  - Patterns
  - Refactoring
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/08/template-delegate-pattern_29.html)._

I&#8217;ve had to use this pattern a few times, most recently in [Behave#](http://www.codeplex.com/BehaveSharp).&nbsp; It&#8217;s similar to the [Template Method pattern](http://www.dofactory.com/Patterns/PatternTemplate.aspx), but doesn&#8217;t resort to using subclassing for using a template method.&nbsp; Instead, a delegate is passed to the Template Method to substitute&nbsp;different logic for portions of the algorithm.

#### The pattern

_Two methods in unrelated classes perform similar&nbsp;general algorithms, yet some&nbsp;parts of the algorithm&nbsp;are different._

**Generalize the algorithm by extracting their steps into a new class, then extract methods for&nbsp;the specialized parts into delegates to be passed in to the new class.**

<img src="http://s3.amazonaws.com/grabbagoftimg/template%20delegate%20pattern.GIF" border="0" />

#### Motivation

Helper methods tend to clutter&nbsp;a class with responsibilities orthogonal to its true purpose.&nbsp; Additionally, several methods in one class might need to perform the same algorithm in slightly different ways.&nbsp; While Template Method is concerned with removing _behavioral_ duplication, _algorithmic_ duplication can be just as rampant.&nbsp; 

Removing algorithmic duplication through Template Method can make the code more obtuse, as often the abstraction of the&nbsp;template class doesn&#8217;t add any meaning to the system.&nbsp; Additionally, sometimes duplicate algorithms are in completely separate classes, and it would be impossible or unwise to try to extract a common subclass from the two classes.&nbsp; We can remove algorithmic duplication by consolidating the algorithm into its own method or class, and pass in parts of the algorithm that might vary.

#### Mechanics

  * Use Extract Method to separate the purely algorithmic section of each method from any surrounding behavioral code. 
      * Compile and test. 
          * Decompose the methods in&nbsp;each algorithm so that all of the steps in the algorithm are identical or completely different. 
              * For each step in the algorithm that is completely different, use [Extract Method](http://www.refactoring.com/catalog/extractMethod.html)&nbsp;to pull out the varying logic.&nbsp; Name these extracted methods the same. 
                  * Compile and test. 
                      * Optionally, use&nbsp;[Introduce Parameter Object](http://www.refactoring.com/catalog/introduceParameterObject.html) for each extracted algorithm method that does not match the same number of parameters for the other different algorithm steps.&nbsp; Compile and test. 
                          * If there is not an existing delegate type&nbsp;that matches the extracted variant methods of the algorithm, create a delegate type that matches both extracted methods. 
                              * Use [Add Parameter](http://www.refactoring.com/catalog/addParameter.html) and add a new parameter of the delegate type created earlier, and modify the algorithm to use the delegate method to execute the varying logic.&nbsp; Repeat for both algorithm methods.&nbsp; Each algorithm method should look exactly the same at this point, except for parameter and return types. 
                                  * Compile and test. 
                                      * Use [Extract Class](http://www.refactoring.com/catalog/extractClass.html) and [Move Method](http://www.refactoring.com/catalog/moveMethod.html) to move the two algorithm methods to a new, generalized (and optionally generic)&nbsp;class.&nbsp; Modify the calling class to use the new class and methods. 
                                          * Compile and test.</ul> 
                                        #### Example
                                        
                                        Suppose I find the two methods in different classes in a large codebase that do recursive searches.&nbsp; One finds a Control based on an ID, and the other searches for XmlNodes based on an attribute value:
                                        
                                        <div class="CodeFormatContainer">
                                          <pre><span class="kwrd">private</span> Control FindControl(ControlCollection controls)
{
    <span class="kwrd">foreach</span> (Control control <span class="kwrd">in</span> controls)
    {
        <span class="kwrd">if</span> (control.ID == txtControlID.Text)
            <span class="kwrd">return</span> control;

        <span class="kwrd">return</span> FindControl(control.Controls);
    }
}

<span class="kwrd">private</span> XmlNode FindElement(XmlNodeList nodes)
{
    <span class="kwrd">foreach</span> (XmlNode node <span class="kwrd">in</span> nodes)
    {
        <span class="kwrd">if</span> (node.Attributes[<span class="str">"ID"</span>].Value == <span class="str">"4564"</span>)
            <span class="kwrd">return</span> node;

        <span class="kwrd">return</span> FindElement(node.ChildNodes);
    }
}
</pre>
                                        </div>
                                        
                                        Both of these methods perform the exact same logic, a recursive search, but the details are slightly different.
                                        
                                        In this example,&nbsp;the first step is already complete and each method&nbsp;contains only&nbsp;the algorithm I&#8217;m interested in.&nbsp;&nbsp;From looking at these methods, it looks&nbsp;like there are 3 distinct parts: the loop, the comparison, and the actual matching logic.&nbsp; The two differing parts I see in the algorithm are:
                                        
                                          * Match 
                                              * Get the children based on the current item in the loop</ul> 
                                            I&#8217;ll apply Extract Method to pull out the varying logic and name these methods the same.&nbsp; Here are the extracted methods:
                                            
                                            <div class="CodeFormatContainer">
                                              <pre><span class="kwrd">private</span> <span class="kwrd">bool</span> IsMatch(Control control)
{
    <span class="kwrd">return</span> control.ID == txtControlID.Text;
}

<span class="kwrd">private</span> <span class="kwrd">bool</span> IsMatch(XmlNode node)
{
    <span class="kwrd">return</span> node.Attributes[<span class="str">"ID"</span>].Value == <span class="str">"4564"</span>;
}

<span class="kwrd">private</span> ControlCollection GetChildren(Control control)
{
    <span class="kwrd">return</span> control.Controls;
}

<span class="kwrd">private</span> XmlNodeList GetChildren(XmlNode node)
{
    <span class="kwrd">return</span> node.ChildNodes;
}
</pre>
                                            </div>
                                            
                                            Note that the names of each method is the same, as well as the number of parameters.&nbsp; Now the original algorithm methods call these extracted varying methods:
                                            
                                            <div class="CodeFormatContainer">
                                              <pre><span class="kwrd">private</span> Control FindControl(ControlCollection controls)
{
    <span class="kwrd">foreach</span> (Control control <span class="kwrd">in</span> controls)
    {
        <span class="kwrd">if</span> (IsMatch(control))
            <span class="kwrd">return</span> control;

        <span class="kwrd">return</span> FindControl(GetChildren(control));
    }
}

<span class="kwrd">private</span> XmlNode FindElement(XmlNodeList nodes)
{
    <span class="kwrd">foreach</span> (XmlNode node <span class="kwrd">in</span> nodes)
    {
        <span class="kwrd">if</span> (IsMatch(node))
            <span class="kwrd">return</span> node;

        <span class="kwrd">return</span> FindElement(GetChildren(node));
    }
}
</pre>
                                            </div>
                                            
                                            These algorithm methods are starting to look very similar.&nbsp; Next, I need to find a delegate type to represent the varying methods, namely &#8220;IsMatch&#8221; and &#8220;GetChildren&#8221;.&nbsp; Since I&#8217;m working with Visual Studio 2008, some good candidates already exist with the Func delegate types.&nbsp; I like these delegate types as they are generic and may lend to some better algorithm definitions in the future, so I&#8217;ll stick with Func.&nbsp; Here&#8217;s the FindControl method after I use Add Parameter to pass in the varying algorithm logic:
                                            
                                            <div class="CodeFormatContainer">
                                              <pre><span class="kwrd">private</span> Control FindControl(IEnumerable&lt;Control&gt; controls, 
    Func&lt;Control, <span class="kwrd">bool</span>&gt; predicate,
    Func&lt;Control, IEnumerable&lt;Control&gt;&gt; childrenSelector)
{
    <span class="kwrd">foreach</span> (Control control <span class="kwrd">in</span> controls)
    {
        <span class="kwrd">if</span> (predicate(control))
            <span class="kwrd">return</span> control;

        <span class="kwrd">return</span> FindControl(childrenSelector(control), predicate, childrenSelector);
    }
}
</pre>
                                            </div>
                                            
                                            I&nbsp;changed the type of the &#8220;controls&#8221; parameter to IEnumerable<Control> from ControlCollection, to reduce the number of types seen in the algorithm method.&nbsp; I change the client code of this algorithm to pass in the new parameters, compile and test:
                                            
                                            <div class="CodeFormatContainer">
                                              <pre><span class="kwrd">private</span> <span class="kwrd">void</span> SetLabelText()
{
    <span class="kwrd">string</span> text = txtLabelText.Text;
    <span class="kwrd">string</span> controlID = txtControlID.Text;

    <span class="kwrd">if</span> (<span class="kwrd">string</span>.IsNullOrEmpty(text) || <span class="kwrd">string</span>.IsNullOrEmpty(controlID))
        <span class="kwrd">return</span>;

    Control control = FindControl(page.Controls, IsMatch, GetChildren);
}
</pre>
                                            </div>
                                            
                                            Note that the &#8220;IsMatch&#8221; and &#8220;GetChildren&#8221; are method names in this class, so I&#8217;m passing the matching and children algorithms to the FindControl method for execution when needed.&nbsp; Finally, I use Extract Class and Move Method to move the two virtually identical algorithm methods to a single method on a new class.&nbsp; Here&#8217;s the final result, with some minor changes to use [extension methods](http://weblogs.asp.net/scottgu/archive/2007/03/13/new-orcas-language-feature-extension-methods.aspx):
                                            
                                            <div class="CodeFormatContainer">
                                              <pre><span class="kwrd">public</span> <span class="kwrd">static</span> T RecursiveSearch&lt;T&gt;(<span class="kwrd">this</span> IEnumerable&lt;T&gt; items,
    Func&lt;T, <span class="kwrd">bool</span>&gt; predicate,
    Func&lt;T, IEnumerable&lt;T&gt;&gt; childrenSelector)
{
    <span class="kwrd">foreach</span> (T item <span class="kwrd">in</span> items)
    {
        <span class="kwrd">if</span> (predicate(item))
            <span class="kwrd">return</span> item;

        <span class="kwrd">return</span> RecursiveSearch(childrenSelector(item), predicate, childrenSelector);
    }

    <span class="kwrd">return</span> <span class="kwrd">default</span>(T);
}
</pre>
                                            </div>
                                            
                                            <div class="CodeFormatContainer">
                                              &nbsp;
                                            </div>
                                            
                                            I&#8217;ve made the method generic, as the only final variant between the extracted algorithm methods was the type of the item I was finding.&nbsp; By making the method generic, the return type is strongly typed to the item I&#8217;m searching for.&nbsp; The final client code doesn&#8217;t look too much different from earlier:
                                            
                                            <div class="CodeFormatContainer">
                                              <pre><span class="kwrd">private</span> <span class="kwrd">void</span> SetLabelText()
{
    <span class="kwrd">string</span> text = txtLabelText.Text;
    <span class="kwrd">string</span> controlID = txtControlID.Text;

    <span class="kwrd">if</span> (<span class="kwrd">string</span>.IsNullOrEmpty(text) || <span class="kwrd">string</span>.IsNullOrEmpty(controlID))
        <span class="kwrd">return</span>;

    Control control = page.Controls.Cast&lt;Control&gt;().RecursiveSearch(IsMatch, GetChildren);
}
</pre>
                                            </div>
                                            
                                            The client code for the &#8220;FindElement&#8221; looks exactly the same, and now there is no duplication of the recursive search logic.&nbsp; I&#8217;ve extracted the varying logic into methods which can be passed in as delegates to the new, generic extracted algorithm.&nbsp; Since I&#8217;m using C# 3.0, I can go as far as using [lambda expressions](http://weblogs.asp.net/scottgu/archive/2007/04/08/new-orcas-language-feature-lambda-expressions.aspx) instead of the extracted &#8220;IsMatch&#8221; and &#8220;GetChildren&#8221; methods.
                                            
                                            #### Conclusion
                                            
                                            The Template Delegate pattern is used quite extensively with the new [Enumerable extension methods](http://msdn2.microsoft.com/en-us/library/system.linq.enumerable(VS.90).aspx) (such as the [Where](http://msdn2.microsoft.com/en-us/library/bb534803(VS.90).aspx) method).&nbsp; With delegate creation in C# 3.0 becoming much simpler with [lambda expressions](http://weblogs.asp.net/scottgu/archive/2007/04/08/new-orcas-language-feature-lambda-expressions.aspx), it&#8217;s becoming easier to compose generalized algorithms where varying portions are passed in as delegate parameters.&nbsp; By using the Template Delegate pattern, I can reduce the number of junk algorithmic methods into a single generic class that serves the needs of current and future client code.