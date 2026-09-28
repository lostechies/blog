---
wordpress_id: 3205
title: 'Refactoring Day 11 : Switch to Strategy'
date: 2009-08-11T12:30:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2009/08/11/refactoring-day-11-switch-to-strategy.aspx
dsq_thread_id:
  - "262347277"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2009/08/11/refactoring-day-11-switch-to-strategy.aspx/"
---
Todays refactoring doesn&#8217;t come from any one source, rather I&#8217;ve used different versions over the years and I&#8217;m sure other have different variations of the same aim.

This refactoring is used when you have a larger switch statement that continually changes because of new conditions being added. In these cases it’s often better to introduce the strategy pattern and encapsulate each condition in it’s own class. The strategy refactoring I’m showing here is refactoring towards a dictionary strategy. There is several ways to implement the strategy pattern, the benefit of using this method is that consumers needn’t change after applying this refactoring.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">namespace</span> LosTechies.DaysOfRefactoring.SwitchToStrategy.Before</pre>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">public</span> <span class="kwrd">class</span> ClientCode</pre>
    
    <pre><span class="lnum">   4:</span>     {</pre>
    
    <pre><span class="lnum">   5:</span>         <span class="kwrd">public</span> <span class="kwrd">decimal</span> CalculateShipping()</pre>
    
    <pre><span class="lnum">   6:</span>         {</pre>
    
    <pre><span class="lnum">   7:</span>             ShippingInfo shippingInfo = <span class="kwrd">new</span> ShippingInfo();</pre>
    
    <pre><span class="lnum">   8:</span>             <span class="kwrd">return</span> shippingInfo.CalculateShippingAmount(State.Alaska);</pre>
    
    <pre><span class="lnum">   9:</span>         }</pre>
    
    <pre><span class="lnum">  10:</span>     }</pre>
    
    <pre><span class="lnum">  11:</span>&#160; </pre>
    
    <pre><span class="lnum">  12:</span>     <span class="kwrd">public</span> <span class="kwrd">enum</span> State</pre>
    
    <pre><span class="lnum">  13:</span>     {</pre>
    
    <pre><span class="lnum">  14:</span>         Alaska,</pre>
    
    <pre><span class="lnum">  15:</span>         NewYork,</pre>
    
    <pre><span class="lnum">  16:</span>         Florida</pre>
    
    <pre><span class="lnum">  17:</span>     }</pre>
    
    <pre><span class="lnum">  18:</span>&#160; </pre>
    
    <pre><span class="lnum">  19:</span>     <span class="kwrd">public</span> <span class="kwrd">class</span> ShippingInfo</pre>
    
    <pre><span class="lnum">  20:</span>     {</pre>
    
    <pre><span class="lnum">  21:</span>         <span class="kwrd">public</span> <span class="kwrd">decimal</span> CalculateShippingAmount(State shipToState)</pre>
    
    <pre><span class="lnum">  22:</span>         {</pre>
    
    <pre><span class="lnum">  23:</span>             <span class="kwrd">switch</span>(shipToState)</pre>
    
    <pre><span class="lnum">  24:</span>             {</pre>
    
    <pre><span class="lnum">  25:</span>                 <span class="kwrd">case</span> State.Alaska:</pre>
    
    <pre><span class="lnum">  26:</span>                     <span class="kwrd">return</span> GetAlaskaShippingAmount();</pre>
    
    <pre><span class="lnum">  27:</span>                 <span class="kwrd">case</span> State.NewYork:</pre>
    
    <pre><span class="lnum">  28:</span>                     <span class="kwrd">return</span> GetNewYorkShippingAmount();</pre>
    
    <pre><span class="lnum">  29:</span>                 <span class="kwrd">case</span> State.Florida:</pre>
    
    <pre><span class="lnum">  30:</span>                     <span class="kwrd">return</span> GetFloridaShippingAmount();</pre>
    
    <pre><span class="lnum">  31:</span>                 <span class="kwrd">default</span>:</pre>
    
    <pre><span class="lnum">  32:</span>                     <span class="kwrd">return</span> 0m;</pre>
    
    <pre><span class="lnum">  33:</span>             }</pre>
    
    <pre><span class="lnum">  34:</span>         }</pre>
    
    <pre><span class="lnum">  35:</span>&#160; </pre>
    
    <pre><span class="lnum">  36:</span>         <span class="kwrd">private</span> <span class="kwrd">decimal</span> GetAlaskaShippingAmount()</pre>
    
    <pre><span class="lnum">  37:</span>         {</pre>
    
    <pre><span class="lnum">  38:</span>             <span class="kwrd">return</span> 15m;</pre>
    
    <pre><span class="lnum">  39:</span>         }</pre>
    
    <pre><span class="lnum">  40:</span>&#160; </pre>
    
    <pre><span class="lnum">  41:</span>         <span class="kwrd">private</span> <span class="kwrd">decimal</span> GetNewYorkShippingAmount()</pre>
    
    <pre><span class="lnum">  42:</span>         {</pre>
    
    <pre><span class="lnum">  43:</span>             <span class="kwrd">return</span> 10m;</pre>
    
    <pre><span class="lnum">  44:</span>         }</pre>
    
    <pre><span class="lnum">  45:</span>&#160; </pre>
    
    <pre><span class="lnum">  46:</span>         <span class="kwrd">private</span> <span class="kwrd">decimal</span> GetFloridaShippingAmount()</pre>
    
    <pre><span class="lnum">  47:</span>         {</pre>
    
    <pre><span class="lnum">  48:</span>             <span class="kwrd">return</span> 3m;</pre>
    
    <pre><span class="lnum">  49:</span>         }</pre>
    
    <pre><span class="lnum">  50:</span>     }</pre>
    
    <pre><span class="lnum">  51:</span> }</pre></p>
  </div>
</div>

To apply this refactoring take the condition that is being tested and place it in it’s own class that adheres to a common interface. Then by passing the enum as the dictionary key, we can select the proper implementation and execute the code at hand. In the future when you want to add another condition, add another implementation and add the implementation to the ShippingCalculations dictionary. As I stated before, **this is not the only option to implement the strategy pattern**. I bold that because I know someone will bring this up in the comments :)&#160; Use what works for you. The benefit of doing this refactoring in this manner is that none of your client code will need to change. All of the modifications exist within the ShippingInfo class.

<a href="http://twitter.com/jaymed" target="_blank">Jayme Davis</a> pointed out that doing this refactoring really only ceates more classes because the binding still needs to be done via the ctor, but would be more beneficial if the binding of your IShippingCalculation strategies can be placed into IoC and that allows you to wire up strategies more easily.

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">using</span> System.Collections.Generic;</pre>
    
    <pre><span class="lnum">   2:</span>&#160; </pre>
    
    <pre><span class="lnum">   3:</span> <span class="kwrd">namespace</span> LosTechies.DaysOfRefactoring.SwitchToStrategy.After</pre>
    
    <pre><span class="lnum">   4:</span> {</pre>
    
    <pre><span class="lnum">   5:</span>     <span class="kwrd">public</span> <span class="kwrd">class</span> ClientCode</pre>
    
    <pre><span class="lnum">   6:</span>     {</pre>
    
    <pre><span class="lnum">   7:</span>         <span class="kwrd">public</span> <span class="kwrd">decimal</span> CalculateShipping()</pre>
    
    <pre><span class="lnum">   8:</span>         {</pre>
    
    <pre><span class="lnum">   9:</span>             ShippingInfo shippingInfo = <span class="kwrd">new</span> ShippingInfo();</pre>
    
    <pre><span class="lnum">  10:</span>             <span class="kwrd">return</span> shippingInfo.CalculateShippingAmount(State.Alaska);</pre>
    
    <pre><span class="lnum">  11:</span>         }</pre>
    
    <pre><span class="lnum">  12:</span>     }</pre>
    
    <pre><span class="lnum">  13:</span>&#160; </pre>
    
    <pre><span class="lnum">  14:</span>     <span class="kwrd">public</span> <span class="kwrd">enum</span> State</pre>
    
    <pre><span class="lnum">  15:</span>     {</pre>
    
    <pre><span class="lnum">  16:</span>         Alaska,</pre>
    
    <pre><span class="lnum">  17:</span>         NewYork,</pre>
    
    <pre><span class="lnum">  18:</span>         Florida</pre>
    
    <pre><span class="lnum">  19:</span>     }</pre>
    
    <pre><span class="lnum">  20:</span>&#160; </pre>
    
    <pre><span class="lnum">  21:</span>     <span class="kwrd">public</span> <span class="kwrd">class</span> ShippingInfo</pre>
    
    <pre><span class="lnum">  22:</span>     {</pre>
    
    <pre><span class="lnum">  23:</span>         <span class="kwrd">private</span> IDictionary&lt;State, IShippingCalculation&gt; ShippingCalculations { get; set; }</pre>
    
    <pre><span class="lnum">  24:</span>&#160; </pre>
    
    <pre><span class="lnum">  25:</span>         <span class="kwrd">public</span> ShippingInfo()</pre>
    
    <pre><span class="lnum">  26:</span>         {</pre>
    
    <pre><span class="lnum">  27:</span>             ShippingCalculations = <span class="kwrd">new</span> Dictionary&lt;State, IShippingCalculation&gt;</pre>
    
    <pre><span class="lnum">  28:</span>             {</pre>
    
    <pre><span class="lnum">  29:</span>                 { State.Alaska, <span class="kwrd">new</span> AlaskShippingCalculation() },</pre>
    
    <pre><span class="lnum">  30:</span>                 { State.NewYork, <span class="kwrd">new</span> NewYorkShippingCalculation() },</pre>
    
    <pre><span class="lnum">  31:</span>                 { State.Florida, <span class="kwrd">new</span> FloridaShippingCalculation() }</pre>
    
    <pre><span class="lnum">  32:</span>             };</pre>
    
    <pre><span class="lnum">  33:</span>         }</pre>
    
    <pre><span class="lnum">  34:</span>&#160; </pre>
    
    <pre><span class="lnum">  35:</span>         <span class="kwrd">public</span> <span class="kwrd">decimal</span> CalculateShippingAmount(State shipToState)</pre>
    
    <pre><span class="lnum">  36:</span>         {</pre>
    
    <pre><span class="lnum">  37:</span>             <span class="kwrd">return</span> ShippingCalculations[shipToState].Calculate();</pre>
    
    <pre><span class="lnum">  38:</span>         }</pre>
    
    <pre><span class="lnum">  39:</span>     }</pre>
    
    <pre><span class="lnum">  40:</span>&#160; </pre>
    
    <pre><span class="lnum">  41:</span>     <span class="kwrd">public</span> <span class="kwrd">interface</span> IShippingCalculation</pre>
    
    <pre><span class="lnum">  42:</span>     {</pre>
    
    <pre><span class="lnum">  43:</span>         <span class="kwrd">decimal</span> Calculate();</pre>
    
    <pre><span class="lnum">  44:</span>     }</pre>
    
    <pre><span class="lnum">  45:</span>&#160; </pre>
    
    <pre><span class="lnum">  46:</span>     <span class="kwrd">public</span> <span class="kwrd">class</span> AlaskShippingCalculation : IShippingCalculation</pre>
    
    <pre><span class="lnum">  47:</span>     {</pre>
    
    <pre><span class="lnum">  48:</span>         <span class="kwrd">public</span> <span class="kwrd">decimal</span> Calculate()</pre>
    
    <pre><span class="lnum">  49:</span>         {</pre>
    
    <pre><span class="lnum">  50:</span>             <span class="kwrd">return</span> 15m;</pre>
    
    <pre><span class="lnum">  51:</span>         }</pre>
    
    <pre><span class="lnum">  52:</span>     }</pre>
    
    <pre><span class="lnum">  53:</span>&#160; </pre>
    
    <pre><span class="lnum">  54:</span>     <span class="kwrd">public</span> <span class="kwrd">class</span> NewYorkShippingCalculation : IShippingCalculation</pre>
    
    <pre><span class="lnum">  55:</span>     {</pre>
    
    <pre><span class="lnum">  56:</span>         <span class="kwrd">public</span> <span class="kwrd">decimal</span> Calculate()</pre>
    
    <pre><span class="lnum">  57:</span>         {</pre>
    
    <pre><span class="lnum">  58:</span>             <span class="kwrd">return</span> 10m;</pre>
    
    <pre><span class="lnum">  59:</span>         }</pre>
    
    <pre><span class="lnum">  60:</span>     }</pre>
    
    <pre><span class="lnum">  61:</span>&#160; </pre>
    
    <pre><span class="lnum">  62:</span>     <span class="kwrd">public</span> <span class="kwrd">class</span> FloridaShippingCalculation : IShippingCalculation</pre>
    
    <pre><span class="lnum">  63:</span>     {</pre>
    
    <pre><span class="lnum">  64:</span>         <span class="kwrd">public</span> <span class="kwrd">decimal</span> Calculate()</pre>
    
    <pre><span class="lnum">  65:</span>         {</pre>
    
    <pre><span class="lnum">  66:</span>             <span class="kwrd">return</span> 3m;</pre>
    
    <pre><span class="lnum">  67:</span>         }</pre>
    
    <pre><span class="lnum">  68:</span>     }</pre>
    
    <pre><span class="lnum">  69:</span> }</pre></p>
  </div>
</div>

To take this sample full circle, Here is how you would wire up your bindings if you were using Ninject as your IoC container in the ShippingInfo constructor. Quite a few things changed here, mainly the enum for the state now lives in the strategy and ninject gives us a IEnumerable of all bindings to the constructor of IShippingInfo. We then create a dictionary using the state property on the strategy to populate our dictionary and the rest is the same. (thanks to <a href="http://kohari.org/" target="_blank">Nate Kohari</a> and <a href="http://www.twitter.com/jaymed" target="_blank">Jayme Davis</a>)

<div class="csharpcode-wrapper">
  <div class="csharpcode">
    <pre><span class="lnum">   1:</span> <span class="kwrd">public</span> <span class="kwrd">interface</span> IShippingInfo</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   3:</span>     <span class="kwrd">decimal</span> CalculateShippingAmount(State state);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   4:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   5:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   6:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> ClientCode</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   7:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   8:</span>     [Inject]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">   9:</span>     <span class="kwrd">public</span> IShippingInfo ShippingInfo { get; set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  10:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  11:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> CalculateShipping()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  12:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  13:</span>         <span class="kwrd">return</span> ShippingInfo.CalculateShippingAmount(State.Alaska);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  14:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  15:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  16:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  17:</span> <span class="kwrd">public</span> <span class="kwrd">enum</span> State</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  18:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  19:</span>     Alaska,</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  20:</span>     NewYork,</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  21:</span>     Florida</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  22:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  23:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  24:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> ShippingInfo : IShippingInfo</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  25:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  26:</span>     <span class="kwrd">private</span> IDictionary&lt;State, IShippingCalculation&gt; ShippingCalculations { get; set; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  27:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  28:</span>     <span class="kwrd">public</span> ShippingInfo(IEnumerable&lt;IShippingCalculation&gt; shippingCalculations)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  29:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  30:</span>         ShippingCalculations = shippingCalculations.ToDictionary(calc =&gt; calc.State);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  31:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  32:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  33:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> CalculateShippingAmount(State shipToState)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  34:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  35:</span>         <span class="kwrd">return</span> ShippingCalculations[shipToState].Calculate();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  36:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  37:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  38:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  39:</span> <span class="kwrd">public</span> <span class="kwrd">interface</span> IShippingCalculation</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  40:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  41:</span>     State State { get; }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  42:</span>     <span class="kwrd">decimal</span> Calculate();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  43:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  44:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  45:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> AlaskShippingCalculation : IShippingCalculation</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  46:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  47:</span>     <span class="kwrd">public</span> State State { get { <span class="kwrd">return</span> State.Alaska; } }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  48:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  49:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> Calculate()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  50:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  51:</span>         <span class="kwrd">return</span> 15m;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  52:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  53:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  54:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  55:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> NewYorkShippingCalculation : IShippingCalculation</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  56:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  57:</span>     <span class="kwrd">public</span> State State { get { <span class="kwrd">return</span> State.NewYork; } }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  58:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  59:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> Calculate()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  60:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  61:</span>         <span class="kwrd">return</span> 10m;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  62:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  63:</span> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  64:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  65:</span> <span class="kwrd">public</span> <span class="kwrd">class</span> FloridaShippingCalculation : IShippingCalculation</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  66:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  67:</span>     <span class="kwrd">public</span> State State { get { <span class="kwrd">return</span> State.Florida; } }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  68:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  69:</span>     <span class="kwrd">public</span> <span class="kwrd">decimal</span> Calculate()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  70:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  71:</span>         <span class="kwrd">return</span> 3m;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  72:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span class="lnum">  73:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        <em><span style="font-size: xx-small"></span></em>
      </p>
      
      <p>
        <em><span style="font-size: xx-small">This is part of the 31 Days of Refactoring series. For a full list of Refactorings please see the <a href="/blogs/sean_chambers/archive/2009/08/01/31-days-of-refactoring.aspx" target="_blank">original introductory post</a>.</span></em>
      </p>