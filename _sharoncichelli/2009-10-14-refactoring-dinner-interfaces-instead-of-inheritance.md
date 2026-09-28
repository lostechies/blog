---
wordpress_id: 3858
title: 'Refactoring Dinner: Interfaces instead of Inheritance'
date: 2009-10-14T02:03:00+00:00
author: Sharon Cichelli
layout: post
wordpress_guid: /blogs/sharoncichelli/archive/2009/10/13/refactoring-dinner-interfaces-instead-of-inheritance.aspx
dsq_thread_id:
  - "263370997"
categories:
  - Refactoring
  - Unit Testing
redirect_from: "/blogs/sharoncichelli/archive/2009/10/13/refactoring-dinner-interfaces-instead-of-inheritance.aspx/"
---
Last time, in [Cooking Up a Good Template Method](/blogs/sharoncichelli/archive/2009/08/29/cooking-up-a-good-template-method.aspx), I had a template method cooking our dinner. An abstract base class defined the template&mdash;the high level steps for preparing a one-skillet dinner&mdash;and a derived class provided the implementation for those steps. I&#8217;m currently reading [Ken Pugh&#8217;s _Interface Oriented Design_](http://www.pragprog.com/titles/kpiod/interface-oriented-design) (more on that after I finish the book), and it got me thinking of a way to change the design to use interfaces instead of inheritance.

I think there&#8217;s value in this refactoring because it allows future flexibility and testability. Let&#8217;s stroll through it, and I welcome your thoughts about how (and whether) this improves the code.

Previously, we had a base class SkilletDinner, which was extended by variants on that theme, such as chicken with onions and bell peppers or the FancyBaconPankoDinner. (If I&#8217;ve learned one thing from my readership, it is that blog posts should mention bacon. Mm, crispy bacon.) As the first step in the refactoring, I&#8217;ll create an interface, ISkilletCookable that provides the same methods that were previously abstract methods in SkilletDinner. By naming convention, the interface is prefixed with &#8216;I&#8217; and is an adjective describing how it can be used (-able).

<div style="font-family: Courier New;font-size: 8pt;color: black;background: white;border: 1px solid #ccc;overflow: auto;width: 500px">
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;4</span>&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">interface</span> <span style="color: #2b91af">ISkilletCookable</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;5</span>&nbsp;&nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;6</span>&nbsp;&nbsp; &nbsp; <span style="color: blue">void</span> HeatFat();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;7</span>&nbsp;&nbsp; &nbsp; <span style="color: blue">void</span> SauteSavoryRoot();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;8</span>&nbsp;&nbsp; &nbsp; <span style="color: blue">void</span> SauteProtein();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;9</span>&nbsp;&nbsp; &nbsp; <span style="color: blue">void</span> SauteVegetables();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;10</span>&nbsp;&nbsp; &nbsp; <span style="color: blue">void</span> AddSauceAndGarnish();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;11</span>&nbsp;&nbsp; }</pre>
</div>

Next, I&#8217;ll create a SkilletDinner constructor that accepts an ISkilletCookable, and change the SkilletDinner&#8217;s Cook() method to ask that cookable to do the work. SkilletDinner no longer needs to be abstract.

<div style="font-family: Courier New;font-size: 8pt;color: black;background: white;border: 1px solid #ccc;overflow: auto;width: 500px">
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;5</span>&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">class</span> <span style="color: #2b91af">SkilletDinner</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;6</span>&nbsp;&nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;7</span>&nbsp;&nbsp; &nbsp; <span style="color: blue">private</span> <span style="color: blue">readonly</span> <span style="color: #2b91af">ISkilletCookable</span> cookable;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;8</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;9</span>&nbsp;&nbsp; &nbsp; <span style="color: blue">public</span> SkilletDinner(<span style="color: #2b91af">ISkilletCookable</span> cookable)</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;10</span>&nbsp;&nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;11</span>&nbsp;&nbsp; &nbsp; &nbsp; <span style="color: blue">this</span>.cookable = cookable;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;12</span>&nbsp;&nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;13</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;14</span>&nbsp;&nbsp; &nbsp; <span style="color: blue">public</span> <span style="color: blue">void</span> Cook()</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;15</span>&nbsp;&nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;16</span>&nbsp;&nbsp; &nbsp; &nbsp; cookable.HeatFat();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;17</span>&nbsp;&nbsp; &nbsp; &nbsp; cookable.SauteSavoryRoot();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;18</span>&nbsp;&nbsp; &nbsp; &nbsp; cookable.SauteProtein();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;19</span>&nbsp;&nbsp; &nbsp; &nbsp; cookable.SauteVegetables();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;20</span>&nbsp;&nbsp; &nbsp; &nbsp; cookable.AddSauceAndGarnish();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;21</span>&nbsp;&nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;22</span>&nbsp;&nbsp; }</pre>
</div>

Then, FancyBaconPankoDinner implements ISkilletCookable and provides implementations for each of the methods that will be called by the Cook() method.

The first benefit from this refactoring is flexibility. While FancyBaconPankoDinner could not have inherited multiple classes (no multiple inheritance in C#), it _can_ implement multiple interfaces. For example, it could also implement the IShoppable interface, thereby providing a ListIngredients() method that would let me include it in my grocery list.

This refactoring also makes it easier for me to test the quality and completeness of my template method. I can verify&mdash;does it cover all of the requisite steps for cooking a skillet dinner?&mdash;by creating [behavior-verifying tests](http://martinfowler.com/articles/mocksArentStubs.html#ChoosingBetweenTheDifferences) that assess the SkilletDinner&#8217;s interactions with the ISkilletCookable interface. When I&#8217;m writing unit tests for the SkilletDinner class, I want to test its behavior because _the behavior is what&#8217;s important_.

To forestall objections, I tried writing a test around the old version, creating my own mock class that extends the old abstract SkilletDinner. It got pretty lengthy.

<div style="font-family: Courier New;font-size: 8pt;color: black;background: white;border: 1px solid #ccc;overflow: auto;height: 300px;width: 500px">
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;4</span>&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">class</span> <span style="color: #2b91af">SkilletDinnerSpecs</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;5</span>&nbsp;&nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;6</span>&nbsp;&nbsp; &nbsp; [TestFixture]</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;7</span>&nbsp;&nbsp; &nbsp; <span style="color: blue">public</span> <span style="color: blue">class</span> <span style="color: #2b91af">When_told_to_cook</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;8</span>&nbsp;&nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;9</span>&nbsp;&nbsp; &nbsp; &nbsp; <span style="color: blue">const</span> <span style="color: blue">string</span> heatFatMethod = <span style="color: #a31515">"HeatFat"</span>;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;10</span>&nbsp;&nbsp; &nbsp; &nbsp; <span style="color: blue">const</span> <span style="color: blue">string</span> sauteSavoryRootMethod = <span style="color: #a31515">"SauteSavoryRoot"</span>;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;11</span>&nbsp;&nbsp; &nbsp; &nbsp; <span style="color: blue">const</span> <span style="color: blue">string</span> sauteProteinMethod = <span style="color: #a31515">"SauteProtein"</span>;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;12</span>&nbsp;&nbsp; &nbsp; &nbsp; <span style="color: blue">const</span> <span style="color: blue">string</span> sauteVegetablesMethod = <span style="color: #a31515">"SauteVegetables"</span>;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;13</span>&nbsp;&nbsp; &nbsp; &nbsp; <span style="color: blue">const</span> <span style="color: blue">string</span> addFinishingTouchesMethod = <span style="color: #a31515">"AddFinishingTouches"</span>;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;14</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;15</span>&nbsp;&nbsp; &nbsp; &nbsp; [<span style="color: #2b91af">Test</span>]</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;16</span>&nbsp;&nbsp; &nbsp; &nbsp; <span style="color: blue">public</span> <span style="color: blue">void</span> Should_follow_dinner_preparation_steps_in_order()</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;17</span>&nbsp;&nbsp; &nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;18</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">var</span> systemUnderTest = <span style="color: blue">new</span> <span style="color: #2b91af">MockSkilletDinner</span>();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;19</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;20</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">var</span> expectedMethodCalls = <span style="color: blue">new</span> <span style="color: #2b91af">List</span>&lt;<span style="color: blue">string</span>&gt;();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;21</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; expectedMethodCalls.Add(heatFatMethod);</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;22</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; expectedMethodCalls.Add(sauteSavoryRootMethod);</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;23</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; expectedMethodCalls.Add(sauteProteinMethod);</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;24</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; expectedMethodCalls.Add(sauteVegetablesMethod);</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;25</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; expectedMethodCalls.Add(addFinishingTouchesMethod);</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;26</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;27</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; systemUnderTest.Cook();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;28</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;29</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: #2b91af">Assert</span>.AreEqual(expectedMethodCalls.Count, systemUnderTest.CalledMethods.Count, <span style="color: #a31515">"Expected number of called methods did not equal actual."</span>);</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;30</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;31</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">for</span> (<span style="color: blue">int</span> i = 0; i &lt; expectedMethodCalls.Count; i++)</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;32</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;33</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="color: #2b91af">Assert</span>.AreEqual(expectedMethodCalls[i], systemUnderTest.CalledMethods[i]);</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;34</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;35</span>&nbsp;&nbsp; &nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;36</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;37</span>&nbsp;&nbsp; &nbsp; &nbsp; <span style="color: blue">private</span> <span style="color: blue">class</span> <span style="color: #2b91af">MockSkilletDinner</span> : <span style="color: #2b91af">SkilletDinner</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;38</span>&nbsp;&nbsp; &nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;39</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">public</span> <span style="color: blue">readonly</span> <span style="color: #2b91af">List</span>&lt;<span style="color: blue">string</span>&gt; CalledMethods = <span style="color: blue">new</span> <span style="color: #2b91af">List</span>&lt;<span style="color: blue">string</span>&gt;();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;40</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;41</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">override</span> <span style="color: blue">void</span> HeatFat()</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;42</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;43</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; CalledMethods.Add(heatFatMethod);</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;44</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;45</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;46</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">override</span> <span style="color: blue">void</span> SauteSavoryRoot()</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;47</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;48</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; CalledMethods.Add(sauteSavoryRootMethod);</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;49</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;50</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;51</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">override</span> <span style="color: blue">void</span> SauteProtein()</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;52</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;53</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; CalledMethods.Add(sauteProteinMethod);</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;54</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;55</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;56</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">override</span> <span style="color: blue">void</span> SauteVegetables()</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;57</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;58</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; CalledMethods.Add(sauteVegetablesMethod);</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;59</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;60</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;61</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">override</span> <span style="color: blue">void</span> AddFinishingTouches()</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;62</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;63</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; CalledMethods.Add(addFinishingTouchesMethod);</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;64</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;65</span>&nbsp;&nbsp; &nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;66</span>&nbsp;&nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;67</span>&nbsp;&nbsp; }</pre>
</div>

In the new design, I can mock the ISkilletCookable interface with a mocking framework like Rhino.Mocks. The interface is easy to mock because interfaces, being the epitome of abstractions, readily lend themselves to being replaced by faked implementations. Rhino.Mocks takes care of recording and verifying which methods were called. 

<div style="font-family: Courier New;font-size: 8pt;color: black;background: white;border: 1px solid #ccc;overflow: auto;width: 500px">
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;7</span>&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">class</span> <span style="color: #2b91af">SkilletDinnerSpecs</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;8</span>&nbsp;&nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;9</span>&nbsp;&nbsp; &nbsp; [<span style="color: #2b91af">TestFixture</span>]</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;10</span>&nbsp;&nbsp; &nbsp; <span style="color: blue">public</span> <span style="color: blue">class</span> <span style="color: #2b91af">When_told_to_cook</span></pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;11</span>&nbsp;&nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;12</span>&nbsp;&nbsp; &nbsp; &nbsp; [<span style="color: #2b91af">Test</span>]</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;13</span>&nbsp;&nbsp; &nbsp; &nbsp; <span style="color: blue">public</span> <span style="color: blue">void</span> Should_follow_dinner_preparation_steps_in_order()</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;14</span>&nbsp;&nbsp; &nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;15</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">var</span> mocks = <span style="color: blue">new</span> <span style="color: #2b91af">MockRepository</span>();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;16</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">var</span> cookable = mocks.StrictMock&lt;<span style="color: #2b91af">ISkilletCookable</span>&gt;();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;17</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">var</span> systemUnderTest = <span style="color: blue">new</span> <span style="color: #2b91af">SkilletDinner</span>(cookable);</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;18</span>&nbsp;</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;19</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">using</span> (mocks.Record())</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;20</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;21</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">using</span> (mocks.Ordered())</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;22</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;23</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; cookable.HeatFat();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;24</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; cookable.SauteSavoryRoot();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;25</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; cookable.SauteProtein();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;26</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; cookable.SauteVegetables();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;27</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; cookable.AddSauceAndGarnish();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;28</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;29</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;30</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">using</span> (mocks.Playback())</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;31</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;32</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; systemUnderTest.Cook();</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;33</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;34</span>&nbsp;&nbsp; &nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;35</span>&nbsp;&nbsp; &nbsp; }</pre>
  
  <pre style="margin: 0px"><span style="color: #2b91af">&nbsp;&nbsp;&nbsp;36</span>&nbsp;&nbsp; }</pre>
</div>

The test relies on Rhino.Mocks to create a mock implementation of ISkilletCookable, and then verifies that the system under test, the SkilletDinner, interacts correctly with ISkilletCookable by telling it what steps to do in what order.

That test is quite cognizant of the inner workings of the SkilletDinner.Cook() method, but that&#8217;s specifically what I&#8217;m unit testing: Does the template method do the right steps? I don&#8217;t mind how the steps are done, but you have to start the onions before you add the meat, or else the onions won&#8217;t caramelize and flavor the oil.

By the way, if you had previously found the learning curve for Rhino.Mocks&#8217; record/playback model too steep a hill to climb (or to convince your teammates to climb), check out [Rhino.Mocks 3.5&#8217;s arrange-act-assert style](http://www.ayende.com/Wiki/Rhino%20Mocks%203.5.ashx). It creates more readable tests, putting statements in a more intuitive order. I really like it. I could not, however, use it here because I have not found a way to enforce ordering of the expectations (i.e., to assert that method A was called before B, and to fail if B was called before A) in A-A-A-style. So we have a record/playback test, instead.

Here&#8217;s a summary of the refactoring. I extracted an interface, ISkilletCookable, and composed SkilletDinner with an instance of that interface, liberating us from class inheritance. Because SkilletDinner is now given the worker it depends on (via dependency injection), I can give it a fake worker in my tests, so that my unit tests don&#8217;t need to perform the time- and resource-consuming operation of firing up the stove. And I managed to write another blog post that mentions bacon. Mm, bacon.