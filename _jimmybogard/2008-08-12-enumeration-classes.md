---
id: 215
title: Enumeration classes
date: 2008-08-12T12:05:15+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/08/12/enumeration-classes.aspx
dsq_thread_id:
  - "264715864"
categories:
  - 'C#'
  - DomainDrivenDesign
---
A [question came up](http://tech.groups.yahoo.com/group/altdotnet/message/13140) on the ALT.NET message board asking whether [Value Objects](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/05/20/entities-value-objects-aggregates-and-roots.aspx) should be used across service boundaries.&nbsp; Of course, the conversation took several detours, eventually coming to the question, &#8220;what do you do about enumerations crossing service boundaries.&#8221;&nbsp; I&#8217;m still ignoring that question, but I&#8217;ve found different ways to represent enums in my model.&nbsp; Now, enums are just fine in lots of scenarios, but quite poor in others.&nbsp; There are other options I like to use when enumerations break down, and many times in the domain model, I go straight to the other option.

For example, I&#8217;ve seen quite a few models like this:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Employee
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">EmployeeType </span>Type { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}

<span style="color: blue">public enum </span><span style="color: #2b91af">EmployeeType
</span>{
    Manager,
    Servant,
    AssistantToTheRegionalManager
}
</pre>

[](http://11011.net/software/vspaste)

The problem with a model like this is it tends to create lots of switch statements:

<pre><span style="color: blue">public void </span>ProcessBonus(<span style="color: #2b91af">Employee </span>employee)
{
    <span style="color: blue">switch</span>(employee.Type)
    {
        <span style="color: blue">case </span><span style="color: #2b91af">EmployeeType</span>.Manager:
            employee.Bonus = 1000m;
            <span style="color: blue">break</span>;
        <span style="color: blue">case </span><span style="color: #2b91af">EmployeeType</span>.Servant:
            employee.Bonus = 0.01m;
            <span style="color: blue">break</span>;
        <span style="color: blue">case </span><span style="color: #2b91af">EmployeeType</span>.AssistantToTheRegionalManager:
            employee.Bonus = 1.0m;
            <span style="color: blue">break</span>;
        <span style="color: blue">default</span>:
            <span style="color: blue">throw new </span><span style="color: #2b91af">ArgumentOutOfRangeException</span>();
    }
}
</pre>

[](http://11011.net/software/vspaste)

There are a few problems with enumerations like this:

  * Behavior related to the enumeration gets scattered around the application
  * New enumeration values require shotgun surgery
  * Enumerations don&#8217;t follow the Open-Closed Principle

Adding a new enumeration value is quite a large pain, as there are lots of these switch statements around to go back and modify.&nbsp; In the case above, we want the &#8220;default&#8221; behavior for defensive coding purposes, but a new enumeration value will cause an exception to be thrown.

With enumeration behavior scattered around, we can never bring it back to the source type, because enumeration types can&#8217;t have any behavior (or state for that matter).

Instead of an enumeration, I like to use an enumeration class.

### Creating the enumeration class

To move away from an enumeration to an enumeration class, I&#8217;ll first use the Enumeration layer supertype from our &#8220;default architecture&#8221; we use at Headspring, from [Tarantino](http://code.google.com/p/tarantino/):

<pre><span style="color: blue">public abstract class </span><span style="color: #2b91af">Enumeration </span>: <span style="color: #2b91af">IComparable
</span>{
    <span style="color: blue">private readonly int </span>_value;
    <span style="color: blue">private readonly string </span>_displayName;

    <span style="color: blue">protected </span>Enumeration()
    {
    }

    <span style="color: blue">protected </span>Enumeration(<span style="color: blue">int </span>value, <span style="color: blue">string </span>displayName)
    {
        _value = value;
        _displayName = displayName;
    }

    <span style="color: blue">public int </span>Value
    {
        <span style="color: blue">get </span>{ <span style="color: blue">return </span>_value; }
    }

    <span style="color: blue">public string </span>DisplayName
    {
        <span style="color: blue">get </span>{ <span style="color: blue">return </span>_displayName; }
    }

    <span style="color: blue">public override string </span>ToString()
    {
        <span style="color: blue">return </span>DisplayName;
    }

    <span style="color: blue">public static </span><span style="color: #2b91af">IEnumerable</span>&lt;T&gt; GetAll&lt;T&gt;() <span style="color: blue">where </span>T : <span style="color: #2b91af">Enumeration</span>, <span style="color: blue">new</span>()
    {
        <span style="color: blue">var </span>type = <span style="color: blue">typeof</span>(T);
        <span style="color: blue">var </span>fields = type.GetFields(<span style="color: #2b91af">BindingFlags</span>.Public | <span style="color: #2b91af">BindingFlags</span>.Static | <span style="color: #2b91af">BindingFlags</span>.DeclaredOnly);

        <span style="color: blue">foreach </span>(<span style="color: blue">var </span>info <span style="color: blue">in </span>fields)
        {
            <span style="color: blue">var </span>instance = <span style="color: blue">new </span>T();
            <span style="color: blue">var </span>locatedValue = info.GetValue(instance) <span style="color: blue">as </span>T;

            <span style="color: blue">if </span>(locatedValue != <span style="color: blue">null</span>)
            {
                <span style="color: blue">yield return </span>locatedValue;
            }
        }
    }

    <span style="color: blue">public override bool </span>Equals(<span style="color: blue">object </span>obj)
    {
        <span style="color: blue">var </span>otherValue = obj <span style="color: blue">as </span><span style="color: #2b91af">Enumeration</span>;

        <span style="color: blue">if </span>(otherValue == <span style="color: blue">null</span>)
        {
            <span style="color: blue">return false</span>;
        }

        <span style="color: blue">var </span>typeMatches = GetType().Equals(obj.GetType());
        <span style="color: blue">var </span>valueMatches = _value.Equals(otherValue.Value);

        <span style="color: blue">return </span>typeMatches && valueMatches;
    }

    <span style="color: blue">public override int </span>GetHashCode()
    {
        <span style="color: blue">return </span>_value.GetHashCode();
    }

    <span style="color: blue">public static int </span>AbsoluteDifference(<span style="color: #2b91af">Enumeration </span>firstValue, <span style="color: #2b91af">Enumeration </span>secondValue)
    {
        <span style="color: blue">var </span>absoluteDifference = <span style="color: #2b91af">Math</span>.Abs(firstValue.Value - secondValue.Value);
        <span style="color: blue">return </span>absoluteDifference;
    }

    <span style="color: blue">public static </span>T FromValue&lt;T&gt;(<span style="color: blue">int </span>value) <span style="color: blue">where </span>T : <span style="color: #2b91af">Enumeration</span>, <span style="color: blue">new</span>()
    {
        <span style="color: blue">var </span>matchingItem = parse&lt;T, <span style="color: blue">int</span>&gt;(value, <span style="color: #a31515">"value"</span>, item =&gt; item.Value == value);
        <span style="color: blue">return </span>matchingItem;
    }

    <span style="color: blue">public static </span>T FromDisplayName&lt;T&gt;(<span style="color: blue">string </span>displayName) <span style="color: blue">where </span>T : <span style="color: #2b91af">Enumeration</span>, <span style="color: blue">new</span>()
    {
        <span style="color: blue">var </span>matchingItem = parse&lt;T, <span style="color: blue">string</span>&gt;(displayName, <span style="color: #a31515">"display name"</span>, item =&gt; item.DisplayName == displayName);
        <span style="color: blue">return </span>matchingItem;
    }

    <span style="color: blue">private static </span>T parse&lt;T, K&gt;(K value, <span style="color: blue">string </span>description, <span style="color: #2b91af">Func</span>&lt;T, <span style="color: blue">bool</span>&gt; predicate) <span style="color: blue">where </span>T : <span style="color: #2b91af">Enumeration</span>, <span style="color: blue">new</span>()
    {
        <span style="color: blue">var </span>matchingItem = GetAll&lt;T&gt;().FirstOrDefault(predicate);

        <span style="color: blue">if </span>(matchingItem == <span style="color: blue">null</span>)
        {
            <span style="color: blue">var </span>message = <span style="color: blue">string</span>.Format(<span style="color: #a31515">"'{0}' is not a valid {1} in {2}"</span>, value, description, <span style="color: blue">typeof</span>(T));
            <span style="color: blue">throw new </span><span style="color: #2b91af">ApplicationException</span>(message);
        }

        <span style="color: blue">return </span>matchingItem;
    }

    <span style="color: blue">public int </span>CompareTo(<span style="color: blue">object </span>other)
    {
        <span style="color: blue">return </span>Value.CompareTo(((<span style="color: #2b91af">Enumeration</span>)other).Value);
    }
}
</pre>

[](http://11011.net/software/vspaste)

It&#8217;s a large class, but it gives us some nice functionality out of the box, such as equality operations and such.&nbsp; Next, I&#8217;ll create the subtype that will house all of my different enumeration values:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">EmployeeType </span>: <span style="color: #2b91af">Enumeration
</span>{
}
</pre>

[](http://11011.net/software/vspaste)

I&#8217;d still like individual employee types, such as Manager and Servant, and I can do this by exposing static readonly fields representing these employee types:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">EmployeeType </span>: <span style="color: #2b91af">Enumeration
</span>{
    <span style="color: blue">public static readonly </span><span style="color: #2b91af">EmployeeType </span>Manager 
        = <span style="color: blue">new </span><span style="color: #2b91af">EmployeeType</span>(0, <span style="color: #a31515">"Manager"</span>);
    <span style="color: blue">public static readonly </span><span style="color: #2b91af">EmployeeType </span>Servant 
        = <span style="color: blue">new </span><span style="color: #2b91af">EmployeeType</span>(1, <span style="color: #a31515">"Servant"</span>);
    <span style="color: blue">public static readonly </span><span style="color: #2b91af">EmployeeType </span>AssistantToTheRegionalManager 
        = <span style="color: blue">new </span><span style="color: #2b91af">EmployeeType</span>(2, <span style="color: #a31515">"Assistant to the Regional Manager"</span>);

    <span style="color: blue">private </span>EmployeeType() { }
    <span style="color: blue">private </span>EmployeeType(<span style="color: blue">int </span>value, <span style="color: blue">string </span>displayName) : <span style="color: blue">base</span>(value, displayName) { }
}
</pre>

[](http://11011.net/software/vspaste)

Notice I also get a much nicer display name with spaces.&nbsp; In the past, I always had to do a lot of finagling to put spaces in the names when I displayed them. When someone wants to assign the Employee&#8217;s type, it doesn&#8217;t look any different than before:

<pre>dwightSchrute.Type = <span style="color: #2b91af">EmployeeType</span>.AssistantToTheRegionalManager;
</pre>

[](http://11011.net/software/vspaste)

Now that I have a real class that acts like a Value Object, I have a destination for behavior.&nbsp; For example, I can tack on a &#8220;BonusSize&#8221; property:

<pre><span style="color: blue">public void </span>ProcessBonus(<span style="color: #2b91af">Employee </span>employee)
{
    employee.Bonus = employee.Type.BonusSize;
}
</pre>

[](http://11011.net/software/vspaste)

Yes, this is a rather silly example, but it illustrates that most, if not all, of the switch statements concerning the previous enum type go away.&nbsp; The behavior can be pushed down into the enumeration class, with each specific enumeration type supplying specific behavior.

This pattern can even be taken further, where I have subtypes for each individual EmployeeType.&nbsp; I&#8217;ll never need to expose them outside to anyone:

<pre><span style="color: blue">public abstract class </span><span style="color: #2b91af">EmployeeType </span>: <span style="color: #2b91af">Enumeration
</span>{
    <span style="color: blue">public static readonly </span><span style="color: #2b91af">EmployeeType </span>Manager 
        = <span style="color: blue">new </span><span style="color: #2b91af">ManagerType</span>();

    <span style="color: blue">protected </span>EmployeeType() { }
    <span style="color: blue">protected </span>EmployeeType(<span style="color: blue">int </span>value, <span style="color: blue">string </span>displayName) : <span style="color: blue">base</span>(value, displayName) { }

    <span style="color: blue">public abstract decimal </span>BonusSize { <span style="color: blue">get</span>; }

    <span style="color: blue">private class </span><span style="color: #2b91af">ManagerType </span>: <span style="color: #2b91af">EmployeeType
    </span>{
        <span style="color: blue">public </span>ManagerType() : <span style="color: blue">base</span>(0, <span style="color: #a31515">"Manager"</span>) { }

        <span style="color: blue">public override decimal </span>BonusSize
        {
            <span style="color: blue">get </span>{ <span style="color: blue">return </span>1000m; }
        }
    }
}
</pre>

[](http://11011.net/software/vspaste)

All of the variations of each enumeration type can be pushed down not only to the enumeration class, but to each specific subtype.&nbsp; The BonusSize now becomes an implementation detail of individual EmployeeType.

Enumerations work well in a variety of scenarios, but can break down quickly inside your domain model.&nbsp; Enumeration classes provide much of the same usability, with the added benefit of becoming a destination for behavior.

Switch statements are no longer necessary, as I can push that variability and knowledge where it belongs, back inside the model.&nbsp; If for some reason I need to check specific enumeration class values, the option is still open for me.&nbsp; This pattern shouldn&#8217;t replace all enumerations, but it&#8217;s nice to have an alternative.