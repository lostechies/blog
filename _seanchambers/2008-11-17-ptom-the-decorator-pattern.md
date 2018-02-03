---
wordpress_id: 3186
title: 'PTOM: The Decorator Pattern'
date: 2008-11-17T04:23:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2008/11/16/ptom-the-decorator-pattern.aspx
dsq_thread_id:
  - "266341176"
categories:
  - Uncategorized
---
For the month of November, Pablo&#8217;s Topic of the Month is Design Patterns. I will be talking about the Decorator design pattern in this post.

[The Decorator Pattern](http://www.dofactory.com/Patterns/PatternDecorator.aspx) was originally coined by The Gang Of Four (GoF). It is a commonly used pattern for extending functionality dynamically at runtime. This is in contrast to a common OOP technique that everyone knows called inheritance. At it&#8217;s most basic level, think of the Decorator pattern as a wrapper with the intent to modify/attach additional behavior to an underlying class.

This is one of the easiest patterns to grasp and understand, as well as to put to use. We will use an example of a coffee shop, let&#8217;s start with a class that is used to represent a cup of coffee available in the shop. Here we have the ICoffee and Coffe interface and class:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="kwrd">public</span> <span class="kwrd">interface</span> ICoffee</pre>
    
    <pre>{</pre>
    
    <pre>    <span class="kwrd">string</span> Name { get; }</pre>
    
    <pre>    <span class="kwrd">decimal</span> Total { get; }</pre>
    
    <pre>}</pre>
    
    <pre>&nbsp;</pre>
    
    <pre><span class="kwrd">public</span> <span class="kwrd">class</span> Coffee : ICoffee</pre>
    
    <pre>{</pre>
    
    <pre>    <span class="kwrd">public</span> <span class="kwrd">string</span> Name</pre>
    
    <pre>    {</pre>
    
    <pre>        get { <span class="kwrd">return</span> <span class="str">"Coffee"</span>; }</pre>
    
    <pre>    }</pre>
    
    <pre>&nbsp;</pre>
    
    <pre>    <span class="kwrd">public</span> <span class="kwrd">decimal</span> Total</pre>
    
    <pre>    {</pre>
    
    <pre>        get { <span class="kwrd">return</span> 0.75m; }</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre>
  </div>
</div>

We have an interface that defines behavior for a cup of Coffee, and then we have a concrete class that represents a Coffee. Something to take note of here is the fact that the GoF sample uses an abstract base class for Coffee instead of my ICoffee interface. The abstract base class is then also used when implementing the decorator pattern. In other samples, people use interfaces instead of ABC&#8217;s, I usually opt for interfaces to start and then refactor to ABC if it is warranted. Use your judgement here. This is a pretty basic example so an ABC isn&#8217;t really needed.

Now let&#8217;s say we want to add the ability to have a customer add an extra shot of espresso to their latte. Normally you would do this with traditional inheritance like so:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="kwrd">public</span> <span class="kwrd">class</span> CoffeePlusEspresso : Coffee</pre>
    
    <pre>{</pre>
    
    <pre>    <span class="kwrd">public</span> <span class="kwrd">new</span> <span class="kwrd">decimal</span> Total</pre>
    
    <pre>    {</pre>
    
    <pre>        get { <span class="kwrd">return</span> <span class="kwrd">base</span>.Total + .5m; }</pre>
    
    <pre>    }</pre>
    
    <pre>    <span class="kwrd">public</span> <span class="kwrd">new</span> <span class="kwrd">string</span> Name</pre>
    
    <pre>    {</pre>
    
    <pre>        get { <span class="kwrd">return</span> <span class="kwrd">string</span>.Format(<span class="str">"{0} w/ Extra shot of espresso"</span>, <span class="kwrd">base</span>.Name); }</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre>
  </div>
</div>

This would work, however it&#8217;s not very desirable. Eventually as you add more and more permutations, (Coffee w/ Espresso, Coffee w/ Espress and Whip cream, etc..) it would lead to a class explosion and you would have a new class for every new combination of ingredients someone could have for a cup of coffee. A better option would be if we could add or &#8220;decorate&#8221; the original cost and name with our added options. Enter the Decorator Pattern.

The first step in implementing the decorator pattern is to define an abstract base class that all of your decorators can derive from. This helps enforce <a target="_blank" href="http://en.wikipedia.org/wiki/Don't_repeat_yourself">the DRY principle</a> by having the code that implements the ICoffee interface. Commonly, this ABC will only be calling the passed in or &#8220;decorated&#8221; object. This way, you only need to extend the properties/methods you want in the decorators and eliminates the need to return the decorated properties/methods in each decorator.

Here is our base class that I have called IngredientDecorator:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="kwrd">public</span> <span class="kwrd">abstract</span> <span class="kwrd">class</span> IngredientDecorator : ICoffee</pre>
    
    <pre>{</pre>
    
    <pre>    <span class="kwrd">protected</span> ICoffee _decoratedCoffee;</pre>
    
    <pre>&nbsp;</pre>
    
    <pre>    <span class="kwrd">protected</span> IngredientDecorator(ICoffee decoratedCoffee)</pre>
    
    <pre>    {</pre>
    
    <pre>        _decoratedCoffee = decoratedCoffee;</pre>
    
    <pre>    }</pre>
    
    <pre>&nbsp;</pre>
    
    <pre>    <span class="kwrd">public</span> <span class="kwrd">virtual</span> <span class="kwrd">string</span> Name</pre>
    
    <pre>    {</pre>
    
    <pre>        get { <span class="kwrd">return</span> _decoratedCoffee.Name; }</pre>
    
    <pre>    }</pre>
    
    <pre>&nbsp;</pre>
    
    <pre>    <span class="kwrd">public</span> <span class="kwrd">virtual</span> <span class="kwrd">decimal</span> Total</pre>
    
    <pre>    {</pre>
    
    <pre>        get { <span class="kwrd">return</span> _decoratedCoffee.Total; }</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre>
  </div>
</div>

As you can see here, our base decorator implements the ICoffee interface by just calling the underlying ICoffee properties that we passed in the constructor. Very simple and to the point. Now we can start to create our concrete decorators that will extend the behavior of our Coffee class. Lets start with our original Espresso example and create an EspressoShotDecorator class.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="kwrd">public</span> <span class="kwrd">class</span> EspressoShotDecorator : IngredientDecorator</pre>
    
    <pre>{</pre>
    
    <pre>    <span class="kwrd">public</span> EspressoShotDecorator(ICoffee decoratedCoffee) : <span class="kwrd">base</span>(decoratedCoffee)</pre>
    
    <pre>    {</pre>
    
    <pre>    }</pre>
    
    <pre>&nbsp;</pre>
    
    <pre>    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">string</span> Name</pre>
    
    <pre>    {</pre>
    
    <pre>        get { <span class="kwrd">return</span> <span class="kwrd">string</span>.Format(<span class="str">"{0}, shot of espresso"</span>, <span class="kwrd">base</span>.Name); }</pre>
    
    <pre>    }</pre>
    
    <pre>&nbsp;</pre>
    
    <pre>    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">decimal</span> Total</pre>
    
    <pre>    {</pre>
    
    <pre>        get { <span class="kwrd">return</span> <span class="kwrd">base</span>.Total + 0.50m; }</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre>
  </div>
</div>

We can now create a Coffee instance, pass it to an EspressoShotDecorator and print out the grand total and modified name by calling EspressoShotDecorator.Name/EspressoShotDecorator.Total as shown here:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre>Coffee plainCoffee = <span class="kwrd">new</span> Coffee();</pre>
    
    <pre>EspressoShotDecorator espressoShotDecorator = <span class="kwrd">new</span> EspressoShotDecorator(plainCoffee);</pre>
    
    <pre>&nbsp;</pre>
    
    <pre>Console.WriteLine(<span class="str">"Name of your coffee: {0}"</span>, espressoShotDecorator.Name);</pre>
    
    <pre>Console.WriteLine(<span class="str">"Cost: {0}"</span>, espressoShotDecorator.Total);</pre>
    
    <pre>&nbsp;</pre>
    
    <pre><span class="rem">// Name of your coffee: Coffee, shot of espresso</span></pre>
    
    <pre><span class="rem">// Cost: 1.25</span></pre>
  </div>
</div>

This is where it starts to become really flexible. Let&#8217;s say we also have a &#8220;Whip Cream&#8221; topping that we want to add as an ingredient. To add this functionality to our application, all we need to do is create a class that represents that single item and we can then begin to chain together the options when someone is asking for their cup of coffee with additional options. The options they have are now interchangable and dynamic. Here is the WhipCreamDecorator:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="kwrd">public</span> <span class="kwrd">class</span> WhipCreamDecorator : IngredientDecorator</pre>
    
    <pre>{</pre>
    
    <pre>    <span class="kwrd">public</span> WhipCreamDecorator(ICoffee decoratedCoffee) : <span class="kwrd">base</span>(decoratedCoffee)</pre>
    
    <pre>    {</pre>
    
    <pre>    }</pre>
    
    <pre>&nbsp;</pre>
    
    <pre>    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">string</span> Name</pre>
    
    <pre>    {</pre>
    
    <pre>        get { <span class="kwrd">return</span> <span class="kwrd">string</span>.Format(<span class="str">"{0}, whip cream"</span>, <span class="kwrd">base</span>.Name); }</pre>
    
    <pre>    }</pre>
    
    <pre>&nbsp;</pre>
    
    <pre>    <span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">decimal</span> Total</pre>
    
    <pre>    {</pre>
    
    <pre>        get { <span class="kwrd">return</span> <span class="kwrd">base</span>.Total + 0.25m; }</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre>
  </div>
</div>

Adding this to the mix and then chaining it on top of the EspressoShotDecorator would yield the following results:

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre>WhipCreamDecorator whipCreamDecorator = <span class="kwrd">new</span> WhipCreamDecorator(espressoShotDecorator);</pre>
    
    <pre>&nbsp;</pre>
    
    <pre>Console.WriteLine(<span class="str">"Name of your coffee: {0}"</span>, whipCreamDecorator.Name);</pre>
    
    <pre>Console.WriteLine(<span class="str">"Cost: {0}"</span>, whipCreamDecorator.Total);</pre>
    
    <pre>&nbsp;</pre>
    
    <pre><span class="rem">// Name of your coffee: Coffee, shot of espresso, whip cream</span></pre>
    
    <pre><span class="rem">// Cost: 1.50</span></pre>
  </div>
</div>

You can now see how this can be flexible in dynamically modifying and extending behavior at runtime. If you want to be really cool, you can hook up the classes to an IoC framework and chain together these objects through a configuration. This is even more flexible than the above approach because you could modify behavior by changing your configuration for the IoC framework. An excellent example of this was already posted by <a target="_blank" href="http://blog.bittercoder.com/PermaLink,guid,4863e460-2985-475c-9266-80b4895e80de.aspx">Alex Henderson (a.k.a The Bitter Coder) in his series on Castle Windsor tutorials</a>

As you can see the Decorator Pattern is a powerful, easy to use/implement, flexible design pattern that should be in everyones arsenal. Please post comments any derivations that you have found useful of the Decorator Pattern. Till next time!