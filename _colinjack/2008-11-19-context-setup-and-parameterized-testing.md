---
id: 4640
title: BDD and Parameterized testing
date: 2008-11-19T07:58:00+00:00
author: Colin Jack
layout: post
guid: /blogs/colinjack/archive/2008/11/19/context-setup-and-parameterized-testing.aspx
categories:
  - BDD
  - TDD
  - Unit Testing
---
Although I really like&nbsp;[Astels style BDD](http://blog.daveastels.com/files/BDD_Intro.pdf) still use a lot of [parameterized testing](http://xunitpatterns.com/Parameterized%20Test.html) and though I should give you an example why, using XUnit.net. 

Lets say we&#8217;re testing simple SPECIFICATION style rules, in&nbsp;[BDD](http://blog.daveastels.com/files/BDD_Intro.pdf) we might write:

<pre>[<span style="color: #2b91af">Concerning</span>(<span style="color: #0000ff">typeof</span>(<span style="color: #2b91af">ValidEmailRule</span>&lt;<span style="color: #2b91af">TestEntity</span>&gt;))]<br /><span style="color: #0000ff">public class </span><span style="color: #2b91af">When_using_rule_on_a_null_string </span>: <span style="color: #2b91af">SpecificationBase<br /></span>{<br />    <span style="color: #0000ff">protected </span><span style="color: #2b91af">TestEntity </span>_testEntity;<br />    <span style="color: #0000ff">private bool </span>_isSatisfied;<br /><br />    <span style="color: #0000ff">protected override void </span>EstablishContext()<br />    {<br />        _testEntity = <span style="color: #2b91af">ContextSetup</span>.CreateTestEntityWithValue(<span style="color: #0000ff">null</span>);<br />    }<br /><br />    <span style="color: #0000ff">protected override void </span>Act()<br />    {<br />        _isSatisfied = <span style="color: #0000ff">new </span><span style="color: #2b91af">ValidEmailRule</span>&lt;<span style="color: #2b91af">TestEntity</span>&gt;(_testEntity, x =&gt; x.Value).IsSatisfied();<br />    }<br /><br />    [<span style="color: #2b91af">Observation</span>]<br />    <span style="color: #0000ff">public void </span>is_satisfied()<br />    {<br />        _isSatisfied.ShouldBeTrue();<br />    }<br />}</pre>

[](http://11011.net/software/vspaste)[](http://11011.net/software/vspaste)

This just tests how the rule handles a null value, but we&#8217;d then want to test with all sorts of other values (valid and invalid). To compare lets thus look at how easy it is to test a variety of invalid e-mail address using one of [XUnit.net](http://www.codeplex.com/xunit)&#8216;s parameterized testing approaches (see [Ben Hall](http://blog.benhall.me.uk/labels/XUnit.html) for more options):

<pre>[<span style="color: #2b91af">Concerning</span>(<span style="color: #0000ff">typeof</span>(<span style="color: #2b91af">ValidEmailRule</span>&lt;<span style="color: #2b91af">TestEntity</span>&gt;))]<br /><span style="color: #0000ff">public class </span><span style="color: #2b91af">When_evaluating_invalid_email_addresses<br /></span>{<br />    [<span style="color: #2b91af">Theory</span>]<br />    [<span style="color: #2b91af">InlineData</span>(<span style="color: #a31515">"sddas.com"</span>)]<br />    [<span style="color: #2b91af">InlineData</span>(<span style="color: #a31515">"sddas@"</span>)]<br />    [<span style="color: #2b91af">InlineData</span>(<span style="color: #a31515">"@"</span>)]<br />    [<span style="color: #2b91af">InlineData</span>(<span style="color: #a31515">"@blah.com"</span>)]<br />    [<span style="color: #2b91af">InlineData</span>(<span style="color: #a31515">"sddas@@blah.com"</span>)]<br />    [<span style="color: #2b91af">InlineData</span>(<span style="color: #a31515">"1213231"</span>)]<br />    <span style="color: #0000ff">public void </span>is_not_satisfied(<span style="color: #0000ff">string </span>invalidEmailAddress)<br />    {<br />        <span style="color: #0000ff">var </span>testEntity = <span style="color: #2b91af">ContextSetup</span>.CreateTestEntityWithValue(invalidEmailAddress);<br /><br />        <span style="color: #0000ff">var </span>isSatisfied = <span style="color: #0000ff">new </span><span style="color: #2b91af">ValidEmailRule</span>&lt;<span style="color: #2b91af">TestEntity</span>&gt;(testEntity, x =&gt; x.Value).IsSatisfied();<br /><br />        isSatisfied.ShouldBeFalse();<br />    }<br />}</pre>

[](http://11011.net/software/vspaste)[](http://11011.net/software/vspaste)[](http://11011.net/software/vspaste)Now you may disagree with my approach here, this isn&#8217;t as readable as it could be, but I think you can see why you&#8217;d use this approach if you have a lot of values to validate.