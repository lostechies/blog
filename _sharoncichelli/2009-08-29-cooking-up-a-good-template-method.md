---
id: 3857
title: Cooking Up a Good Template Method
date: 2009-08-29T16:53:00+00:00
author: Sharon Cichelli
layout: post
guid: /blogs/sharoncichelli/archive/2009/08/29/cooking-up-a-good-template-method.aspx
dsq_thread_id:
  - "263370911"
categories:
  - Design Patterns
---
The software concept of &#8220;raising the level of abstraction&#8221; has improved my skill and creativity in cooking, by teaching me to think about recipe components in terms of their properties and functions. Practicing abstraction-raising in cooking feeds back to help me with coding; for example, keeping me from going astray the other day with the [Template Method pattern](http://en.wikipedia.org/wiki/Template_method_pattern). This post is more about coding than cooking. The cooking&#8217;s a metaphor. (The cake is a lie.)

## Abstract Cooking

My skill with cooking grew from rote recipe following to intuitive creation when I started to think of it in terms borrowed from software: raising the level of abstraction.

Consider a week-night skillet dinner. If I told you to heat canola oil in a cast-iron skillet, saute slices of onion and chunks of chicken seasoned with salt and pepper, and toss in bell peppers cut into strips, you could probably follow along and make exactly that. But that&#8217;s pretty limiting. If instead I described the process as using a fat to conduct heat for sauteing a savory root, a seasoned protein, and some vegetables, then you could use that as a template, and make a week of dinners without repeating yourself.

Let&#8217;s dive into that step of using a fat for conduction, because it is a cool and useful bit of food science. To cook, you need to get heat onto food. The medium can be air, liquid, or fat. Each creates different results, hence the terms baking, boiling, and frying. When you toss cut-up bits of food in a skillet with oil and repeatedly jostle them, you&#8217;re sauteing (&#8220;saute&#8221; means &#8220;to jump&#8221;), and that oil is playing the role of the fat, which is conducting the heat. If you&#8217;ll pardon the metaphor, CanolaOil implements the IFat interface.

It&#8217;s useful to think of cooking this way, because if you know the properties of the various cooking fats, you can choose the right IFat implementation for the job. Canola oil is heart-healthy and stands up well to stove-top heat. Olive oil has wonderful health benefits, a bold flavor, and an intriguing green color, but those attributes are pretty much obliterated by heat, so save your expensive EVOO for raw applications like salads and dips. Butter makes everything taste better, browns up beautifully, but is harder on the heart and will burn at a low temperature; temper it with an oil like canola to keep it from burning. Peanut oil stands up to heat like a champ, so it&#8217;s popular for deep frying. Armed with this kind of knowledge, I don&#8217;t need to check a recipe when I&#8217;m cooking; I just think about what I&#8217;m trying to accomplish, and choose the right implementation.

Pam Anderson&#8217;s [_How to Cook Without a Book_](http://www.librarything.com/work/67701) got me thinking about food this way, and Harold McGee&#8217;s [_On Food and Cooking_](http://www.librarything.com/work/44636) provides a feast of food geekery to fill in all the particulars.

## Template Coding

Thinking about food this way, raising the level of abstraction, guides my thinking about code. My meal preparation follows the Template Method pattern, as does a class my teammate and I needed to modify recently.

In this example, our application sends instructions to various external systems. The specifics of how those systems like to hold their conversations vary between systems. However, the series of steps, when phrased in our core business terms, remain the same. You do A, then you do B, then you do C, in whatever way a particular instance likes to do A, B, and C.

Here&#8217;s my class with its template method, translated back to the dinner metaphor:

<div style="border: 1px solid #ccc;font-family: Courier New;font-size: 8pt;color: black;background: white;width: 500px">
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;3</span>&nbsp;&nbsp; &nbsp; <span style="color: blue">public</span> <span style="color: blue">abstract</span> <span style="color: blue">class</span> <span style="color: #2b91af">SkilletDinner</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;4</span>&nbsp;&nbsp; &nbsp; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;5</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">public</span> <span style="color: blue">void</span> Cook()
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;6</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;7</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; HeatFat();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;8</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; SauteSavoryRoot();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;9</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; SauteProtein();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;10</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; SauteVegetables();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;11</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;12</span>&nbsp;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;13</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">abstract</span> <span style="color: blue">void</span> HeatFat();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;14</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">abstract</span> <span style="color: blue">void</span> SauteSavoryRoot();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;15</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">abstract</span> <span style="color: blue">void</span> SauteProtein();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;16</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">abstract</span> <span style="color: blue">void</span> SauteVegetables();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;17</span>&nbsp;&nbsp; &nbsp; }
  </p>
</div>

But lo, I encountered an external system that needed to do one extra little thing. I needed a special step, just for that one instance. Like dinner the other night, where the vegetable was asparagus, the fat was bacon (oh ho!), and the final step was to toss some panko breadcrumbs into the pan to brown and toast and soak up the bacony love.

How do I extend my template method to accommodate an instance-specific step?

One idea that floated by was to make the method virtual, so that we could override it in our special instance. But we still wanted the rest of the steps, so we&#8217;d have to copy the whole method into the new instance, just to add a few lines. Also, anybody else could override that template, too, so that when they were told to do A, B, and C, they could totally fib and do nothing of the sort.

<div style="border: 1px solid #ccc;font-family: Courier New;font-size: 8pt;color: black;background: white;overflow: auto;height: 300px;width: 500px">
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;3</span>&nbsp;&nbsp; &nbsp; <span style="color: blue">public</span> <span style="color: blue">abstract</span> <span style="color: blue">class</span> <span style="color: #2b91af">SkilletDinner</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;4</span>&nbsp;&nbsp; &nbsp; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;5</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">public</span> <span style="color: blue">virtual</span> <span style="color: blue">void</span> Cook()
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;6</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;7</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="color: green">//Note: The Cook template method is now virtual,</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;8</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="color: green">//and can be overridden in deriving classes. </span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;9</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="color: green">//That&#8217;s not good.</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;10</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; HeatFat();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;11</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; SauteSavoryRoot();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;12</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; SauteProtein();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;13</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; SauteVegetables();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;14</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;15</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">abstract</span> <span style="color: blue">void</span> HeatFat();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;16</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">abstract</span> <span style="color: blue">void</span> SauteSavoryRoot();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;17</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">abstract</span> <span style="color: blue">void</span> SauteProtein();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;18</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">abstract</span> <span style="color: blue">void</span> SauteVegetables();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;19</span>&nbsp;&nbsp; &nbsp; }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;20</span>&nbsp;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;21</span>&nbsp;&nbsp; &nbsp; <span style="color: blue">public</span> <span style="color: blue">class</span> <span style="color: #2b91af">LazyDinner</span> : <span style="color: #2b91af">SkilletDinner</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;22</span>&nbsp;&nbsp; &nbsp; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;23</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">public</span> <span style="color: blue">override</span> <span style="color: blue">void</span> Cook()
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;24</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;25</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; OrderPizza();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;26</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="color: green">//We&#8217;re overriding the template and *cheating*!</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;27</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="color: green">//Although, if it&#8217;s Austin&#8217;s Pizza, </span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;28</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="color: green">//maybe that&#8217;s okay&#8230;</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;29</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;30</span>&nbsp;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;31</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">private</span> <span style="color: blue">void</span> OrderPizza()
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;32</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;33</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="color: green">//With extra garlic!</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;34</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;35</span>&nbsp;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;36</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">override</span> <span style="color: blue">void</span> HeatFat() { }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;37</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">override</span> <span style="color: blue">void</span> SauteSavoryRoot() { }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;38</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">override</span> <span style="color: blue">void</span> SauteProtein() { }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;39</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">override</span> <span style="color: blue">void</span> SauteVegetables() { }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;40</span>&nbsp;&nbsp; &nbsp; }
  </p>
</div>

That LazyDinner class isn&#8217;t really a SkilletDinner at all; its behavior is completely different. No, that option flouts the whole point of the Template Method pattern.

Our better idea was to make one small change to the template method, adding an extension point. That is, a call to a virtual method which in the base implementation does nothing, and can be overridden and told to do stuff in specific cases.

Back to dinner:

<div style="border: 1px solid #ccc;font-family: Courier New;font-size: 8pt;color: black;background: white;overflow: auto;height: 300px;width: 500px">
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;3</span>&nbsp;&nbsp; &nbsp; <span style="color: blue">public</span> <span style="color: blue">abstract</span> <span style="color: blue">class</span> <span style="color: #2b91af">SkilletDinner</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;4</span>&nbsp;&nbsp; &nbsp; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;5</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">public</span> <span style="color: blue">void</span> Cook()
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;6</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;7</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; HeatFat();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;8</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; SauteSavoryRoot();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp;9</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; SauteProtein();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;10</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; SauteVegetables();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;11</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; AddFinishingTouches(); <span style="color: green">//Here&#8217;s the hook.</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;12</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;13</span>&nbsp;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;14</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">virtual</span> <span style="color: blue">void</span> AddFinishingTouches()
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;15</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;16</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="color: green">//By default, do nothing.</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;17</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;18</span>&nbsp;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;19</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">abstract</span> <span style="color: blue">void</span> HeatFat();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;20</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">abstract</span> <span style="color: blue">void</span> SauteSavoryRoot();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;21</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">abstract</span> <span style="color: blue">void</span> SauteProtein();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;22</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">abstract</span> <span style="color: blue">void</span> SauteVegetables();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;23</span>&nbsp;&nbsp; &nbsp; }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;24</span>&nbsp;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;25</span>&nbsp;&nbsp; &nbsp; <span style="color: blue">public</span> <span style="color: blue">class</span> <span style="color: #2b91af">FancyBaconPankoDinner</span> : <span style="color: #2b91af">SkilletDinner</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;26</span>&nbsp;&nbsp; &nbsp; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;27</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">override</span> <span style="color: blue">void</span> AddFinishingTouches()
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;28</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;29</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="color: green">//In this case, override this extensibility hook:</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;30</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ToastBreadcrumbs();
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;31</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;32</span>&nbsp;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;33</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">private</span> <span style="color: blue">void</span> ToastBreadcrumbs()
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;34</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;35</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="color: green">//Toss in the bacon fat; keep &#8217;em moving.</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;36</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;37</span>&nbsp;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;38</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">override</span> <span style="color: blue">void</span> HeatFat()
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;39</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;40</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="color: green">//Cook bacon, set aside, drain off some fat.</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;41</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;42</span>&nbsp;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;43</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">override</span> <span style="color: blue">void</span> SauteSavoryRoot()
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;44</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;45</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="color: green">//Minced garlic, until soft but before browning</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;46</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;47</span>&nbsp;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;48</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">override</span> <span style="color: blue">void</span> SauteProtein()
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;49</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;50</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="color: green">//How about&#8230; tofu that tastes like bacon?</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;51</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;52</span>&nbsp;
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;53</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; <span style="color: blue">protected</span> <span style="color: blue">override</span> <span style="color: blue">void</span> SauteVegetables()
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;54</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; {
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;55</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="color: green">//Asparagus, cut into sections. </span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;56</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="color: green">//Make it bright green and a little crispy.</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;57</span>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; }
  </p>
  
  <p style="margin: 0px">
    <span style="color: #2b91af">&nbsp;&nbsp;&nbsp;58</span>&nbsp;&nbsp; &nbsp; }
  </p>
</div>

This maintains the contract of the template method, while allowing for special cases. With the right extensibility hooks in place, my dinner preparation happily follows the [Open-Closed Principle](/blogs/joe_ocampo/archive/2008/03/21/ptom-the-open-closed-principle.aspx)&mdash;open for extension, but closed for modification.

I enjoy the way my various hobbies feed into and reflect upon each other. I hope this post has given you some useful insight into the Template Method pattern, or dinner preparation, or both. Look for synergies amongst your own varied interests; it can be the springboard for some truly breakthrough ideas.

Mmm, bacon&#8230;