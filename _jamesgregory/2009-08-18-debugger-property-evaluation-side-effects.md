---
wordpress_id: 4499
title: Preventing debugger property evaluation for side-effect laden properties
date: 2009-08-18T11:15:00+00:00
author: James Gregory
layout: post
wordpress_guid: /blogs/jagregory/archive/2009/08/18/debugger-property-evaluation-side-effects.aspx
dsq_thread_id:
  - "293292364"
categories:
  - debugger
  - fluent interface
redirect_from: "/blogs/jagregory/archive/2009/08/18/debugger-property-evaluation-side-effects.aspx/"
---
Property getters with side-effects, now there&#8217;s a controversial subject if ever I saw one. Don&#8217;t do it is the rule; as with any rule though, there&#8217;s generally an exception that proves it. If you&#8217;re in this situation and you genuinely do have a scenario that requires a property getter to have side-effects, then there&#8217;s a side-effect (ha!) that you should be aware of.

**The debugger evaluates property getters when showing it&#8217;s locals and autos windows.** While this feature is indispensable in most cases, it plays havoc with our property-with-side-effects. What the debugger does is call the getter to present it&#8217;s value in the autos window, at the same time firing our code that has a side-effect. From there you have pretty confusing behavior with code seemingly running itself.

My exception to the rule is mutator properties in a fluent interface. You can often find properties in fluent interfaces that when touched alter the behavior of the next method called.

For example:

<pre>string value = null;

Is.Null(value)      // returns true
Is.Not.Null(value)  // returns false
</pre>

The Is class would contain a value tracking whether the next call would be inverted or not, and the Not property would flip that value when called.

Now assume this, you&#8217;re using `Is.Null(value)` and you set a breakpoint on it. Your autos window has expanded Is and shows the Not property, what&#8217;s just happened? The debugger has now called Not and altered your state! Undesirable.

[DebuggerBrowsable attribute](http://msdn.microsoft.com/en-us/library/system.diagnostics.debuggerbrowsableattribute.aspx) to the rescue; this attribute when used with the DebuggerBrowsableState.Never parameter instructs Visual Studio to never inspect the property you apply it to. Your property won&#8217;t appear in the autos or locals window, and if you expand the tree of an instance containing the property it will show up with a Browsing Disabled message; you can then force it to evaluate the property, but at least it doesn&#8217;t do it automatically.

<pre>private bool inverted = true;

[DebuggerBrowsable(DebuggerBrowsableState.Never)]
public Is Not
{
  get
  {
    inverted = !inverted;
    return this;
  }
}
</pre>

Sticking the DebuggerBrowsable attribute on your Not property prevents the debugger from hitting it and inverting the switch.

So there you go, if your property-with-side-effects is being invoked by the debugger, you can use the DebuggerBrowsableAttribute to prevent it.

> By the way, I&#8217;m not advocating properties with side-effects&#8230;