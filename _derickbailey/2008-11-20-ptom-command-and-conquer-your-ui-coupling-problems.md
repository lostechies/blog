---
wordpress_id: 17
title: 'PTOM: Command and Conquer Your UI Coupling Problems'
date: 2008-11-20T02:23:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2008/11/19/ptom-command-and-conquer-your-ui-coupling-problems.aspx
dsq_thread_id:
  - "262067943"
categories:
  - .NET
  - Analysis and Design
  - Design Patterns
  - Principles and Patterns
---
This post is part of the <a href="/blogs/rhouston/archive/2008/11/05/pablo-s-topic-of-the-month-november-design-patterns.aspx" target="_blank">November 2008 Pablo&#8217;s Topic Of The Month (PTOM) &#8211; Design Patterns</a> and will outline a simple Command pattern, its implementation and use.

One of the core principles of object oriented software development is the idea of <a href="http://en.wikipedia.org/wiki/Coupling_(computer_science)" target="_blank">Coupling</a>, &#8220;the degree to which each program module relies on each one of the other modules&#8221; (Wikipedia). When we build software, we should strive to attain low coupling &#8211; keep the individual modules of the system as separated as possible. Of course, if there is zero coupling in a system, then the system won&#8217;t really do much for us. After all, you can&#8217;t write software that is very useful if you are not allowed to have any dependencies. 

### Setting Up Shop

Before we break down into the pattern, let&#8217;s consider the context of a Point Of Sale system at a coffee shop. In this system, we have a menu where your server can punch in your order with all of the options you want and produce an order that is fulfilled somewhere else. When the server starts pressing the menu items and the system begins to compile the order, there is a connection between the menu system that they are using, the various products that have been configured in the system, and the back-end ordering system. This is a rather obvious location where coupling can quickly become high &#8211; the UI, the products, and the back-end ordering system could very quickly become a spaghetti mess of tangled dependencies and tight coupling &#8211; but we don&#8217;t want that, do we?

To combat the coupling problems of this situation while still allowing dependencies, we need to introduce various forms of abstraction &#8211; simple dependencies that are not specific to any implementation, allowing us to change the implementation when we need to. In the case of a menu &#8211; be it a WinForms application, a touch screen point of sale system, or whatever else &#8211; a Command pattern is often employed to enable the system&#8217;s functionality without being directly coupled to the actual menu.

### The Command Pattern

Originally outlined by the infamous &#8220;Gang of Four&#8221;, the <a href="http://en.wikipedia.org/wiki/Command_pattern" target="_blank">Command</a> <a href="http://www.dofactory.com/Patterns/PatternCommand.aspx" target="_blank">Pattern</a> is described as an object that represents an action &#8211; a command that will be executed. Within the context of a command, we have several parts that need to be accounted for. 

<a target="_blank" href="http://en.wikipedia.org/wiki/Command_pattern#Structure"><img style="border-width: 0px;border: 0" alt="image" src="http://upload.wikimedia.org/wikipedia/en/8/8e/Command_Design_Pattern_Class_Diagram.png" border="0" /></a>

  * First and foremost, there is the actual command object &#8211; the action that is executed. 
  * Second, we have the command invoker &#8211; the object that depends on the commands existence, and knows how to execute the command. 
  * And lastly, we have the target of the invocation &#8211; the part of the system that needs to take action when the command is executed.

### A Simple Implementation

To facilitate the decoupling of specific modules in our system, our command pattern implementations will be created with a naming convention that represents the objects as commands. For example, a very basic command implementation in C# can be represented as an interface such as this:

<div style="border: 1px solid gray;margin: 20px 0px 10px;padding: 4px;overflow: auto;font-size: 8pt;width: 97.5%;cursor: text;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
  <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> ICommand</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">  <span style="color: #0000ff">void</span> Execute();</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">}</pre>
  </div>
</div>

By abstracting our command into an interface, we can provide any implementation we need at runtime. This lets us select a coffee from our point of sale system and have another part of the system actually create and handle the order. A pseudo-complete implementation of a command pattern to order a cup of coffee may look something like this:

<div style="border: 1px solid gray;margin: 20px 0px 10px;padding: 4px;overflow: auto;font-size: 8pt;width: 97.5%;cursor: text;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
  <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> ICommand</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">   <span style="color: #0000ff">void</span> Execute();</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">}</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> MenuItem</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">   <span style="color: #0000ff">private</span> ICommand _menuCommand;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">   <span style="color: #0000ff">public</span> Text { get; set; }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">   <span style="color: #0000ff">public</span> MenuItem(<span style="color: #0000ff">string</span> menuText, ICommand menuCommand)</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">   {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">       Text = menuText;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">       _menuCommand = menuCommand;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">   }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Click()</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">   {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">       _menuCommand.Execute();</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">   }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">}</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> RegularCoffeeCommand: ICommand</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">   <span style="color: #0000ff">private</span> SomeOrderingSystem _orderingSystem;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">   <span style="color: #0000ff">public</span> RegularCoffeeCommand(SomeOrderingSystem orderingSystem)</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">   {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">       _orderingSystem = orderingSystem;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">   }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Execute()</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">   {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">       Product regularCoffee = <span style="color: #0000ff">new</span> Product(<span style="color: #006080">"RegularCoffee"</span>, 2.99);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">       _orderingSystem.PlaceOrder(regularCoffee);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">   }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">}</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4"><span style="color: #008000">//... somewhere in the application UI</span></pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">MenuItem regularCoffeeMenuItem = <span style="color: #0000ff">new</span> MenuItem(<span style="color: #006080">"Regular Coffee"</span>, <span style="color: #0000ff">new</span> RegularCoffeeCommand());</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #008000">//... and when the menu item is clicked</span></pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">regularCoffeeMenuItem.Click();</pre>
  </div>
</div>

The real power of this implementation is that we have completely decoupled our menu system from any specific knowledge of the product ordering system in our coffee shop. All our menu item needs to know about is the ICommand interface. At the same time, our back-end implementation also knows about the ICommand interface &#8211; but the back-end also knows about the actual product ordering system. This allows us to create an implementation of the ICommand interface that knows how to invoke our target system. The end result is that we can independently vary the menu system for ordering coffee and our back-end product ordering system.

### More Complexity And More Flexibility

Great News! Our command pattern implementations don&#8217;t have to be limited to such a rigid interface. In fact, my current project has no less than 4 different ICommand interface variations. By introducing the use of generics in C#, we can create some very flexible commands. As an example, consider the following additional interface definitions:

<div style="border: 1px solid gray;margin: 20px 0px 10px;padding: 4px;overflow: auto;font-size: 8pt;width: 97.5%;cursor: text;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
  <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> ICommand&lt;T&gt;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">   T Execute();</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">}</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4"><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IParameterizedCommand&lt;V&gt;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">   <span style="color: #0000ff">void</span> Execute(V <span style="color: #0000ff">value</span>);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">}</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IParameterizedCommand&lt;T, V&gt;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">   T Execute(V <span style="color: #0000ff">value</span>);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">}</pre>
  </div>
</div>

These new interface definitions, in combination with the original definition above, can create a very flexible and very useful set of commands in a system. By creating a &#8220;parameterized command&#8221; interface, we can provide detail in the command execution that is not available at the time the command is instantiated. And by adding another non-parameterized command with a return value, we can create a system that is able to interact in more complex ways.

With these new command interfaces in mind, let&#8217;s take another look at our RegularCoffeeCommand. Instead of hard coding the price of the coffee into the command, let&#8217;s push that knowledge off to another part of the system.

<div style="border: 1px solid gray;margin: 20px 0px 10px;padding: 4px;overflow: auto;font-size: 8pt;width: 97.5%;cursor: text;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
  <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> RegularCoffeeCommand: IParameterizedCommand&lt;Price&gt;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">   <span style="color: #0000ff">private</span> SomeOrderingSystem _orderingSystem;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">   <span style="color: #0000ff">public</span> RegularCoffeeCommand(SomeOrderingSystem orderingSystem)</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">   {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">       _orderingSystem = orderingSystem;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">   }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Execute(Price coffeePrice)</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">   {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">       Product regularCoffee = <span style="color: #0000ff">new</span> Product(<span style="color: #006080">"RegularCoffee"</span>, coffeePrice);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">       _orderingSystem.PlaceOrder(regularCoffee);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">   }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">}</pre>
  </div>
</div>

By providing an interface that accepts a parameter, we can move the knowledge of the coffee&#8217;s price out to another part of the system and provide it at runtime &#8211; a database call, a web services call, or anything else we want.

### But Wait! There&#8217;s More!

As you can see, the command pattern can be very useful in helping us decouple our coffee shop&#8217;s point of sale system from the back-end product ordering system. Some very simple interface definitions can provide a lot of flexibility in how we compose our systems, as well. 

What&#8217;s more &#8211; we aren&#8217;t actually limited to interfaces or base classes for abstracting our commands in .NET. The built in delegate system in .NET provides a great way to encapsulate commands with method pointers. I&#8217;ve previously talked about <a href="/blogs/derickbailey/archive/2008/10/09/what-s-the-point-of-delegates-in-net.aspx" target="_blank">The Point of Delegates in .NET</a> where I mentioned that delegates provide us with a way of delaying the execution of code. Though it&#8217;s not strictly an &#8220;object&#8221; as the command pattern describes, a delegate certainly sounds like a command pattern implementation just waiting to break out of it&#8217;s skin. In fact, I have created a few command pattern implementations using nothing more than the built in delegates in .NET, several times. 

Whether you decide to use interfaces, delegates, abstract classes, or any other implementation method that you can come up with, I hope that you will think about including a command pattern implementation in your systems. It is an easy way of conquering the problems of high coupling between user interfaces and back-ends of the system.