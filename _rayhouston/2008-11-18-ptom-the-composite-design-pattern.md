---
id: 31
title: 'PTOM: The Composite Design Pattern'
date: 2008-11-18T02:07:00+00:00
author: Ray Houston
layout: post
guid: /blogs/rhouston/archive/2008/11/17/ptom-the-composite-design-pattern.aspx
categories:
  - Patterns
  - Principles
  - Programming
  - PTOM
---
## The Composite Design Pattern

This post talks about the Composite Design Pattern and is part of [Pablo&#8217;s Topic of the Month &#8211; November: Design Patterns](/blogs/rhouston/archive/2008/11/05/pablo-s-topic-of-the-month-november-design-patterns.aspx). A Composite is a tree structure where each node can be represented as a common type so that they can be acted on in a consistent manner, regardless of their concrete implementations. This allows a consumer of the composite to avoid the complexity of having to distinguish the objects individually. I believe that the posts for PTOM are going to centered around a coffee shop, but I&#8217;m having a difficult time thinking of a good composite example around that, so let&#8217;s say I&#8217;m building coffee machines instead.

Lets pretend that I have a model of a coffee machine and all of its parts. Many of the parts are logical and are made up of only child parts. I might have a class that looks something like the following (simplistically implemented for example purposes):

<div>
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> CoffeeMachine<br />{<br />    <span style="color: #0000ff">public</span> FluxCapacitor FluxCapacitor { get; set; }<br />    <span style="color: #0000ff">public</span> PowerCord PowerCord { get; set; }<br />}<br /></pre>
</div>

<div>
  &nbsp;
</div>

<div>
  Lets say FluxCapacitor is a composite part made up of child parts and those child parts may have their own child parts. I want to build a class that allows me to output all the given parts for a machine, but I don&#8217;t want my part list generator to know about each specific details of the machine or any of its specific parts. If I did couple the list generator to those implementations, that would force me to modify the list generator every time we added or changed a part, which would be a violation of <a href="/blogs/joe_ocampo/archive/2008/03/21/ptom-the-open-closed-principle.aspx">OCP</a>. We can solve this problem by creating an interface that lets us traverse our structure as a composite.
</div>

<div>
  &nbsp;
</div>

<div>
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4"><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IPart<br />{<br />    IEnumerable&lt;IPart&gt; GetChildParts();<br />}</pre>
</div>

You will notice that the IPart returns child instances of other IParts. This gives us a recursive structure and lets us act on that structure as a composite. By implementing this interface on all of our parts, when can then walk the hierarchy and perform operations without knowing the details of each implementation. We can implement this on our CoffeeMachine and our other parts like the following:

<div>
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> CoffeeMachine : IPart<br />{<br />    <span style="color: #0000ff">public</span> FluxCapacitor FluxCapacitor { get; set; }<br />    <span style="color: #0000ff">public</span> PowerCord PowerCord { get; set; }<br /><br />    <span style="color: #0000ff">public</span> IEnumerable&lt;IPart&gt; GetChildParts()<br />    {<br />        <span style="color: #0000ff">yield</span> <span style="color: #0000ff">return</span> FluxCapacitor;<br />        <span style="color: #0000ff">yield</span> <span style="color: #0000ff">return</span> PowerCord;<br />    }<br />}<br /><br /><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> FluxCapacitor : IPart<br />{<br />    <span style="color: #0000ff">public</span> Switch Switch { get; set; }<br />    <span style="color: #0000ff">public</span> PowerBooster PowerBooster { get; set; }<br /><br />    <span style="color: #0000ff">public</span> IEnumerable&lt;IPart&gt; GetChildParts()<br />    {<br />        <span style="color: #0000ff">yield</span> <span style="color: #0000ff">return</span> Switch;<br />        <span style="color: #0000ff">yield</span> <span style="color: #0000ff">return</span> PowerBooster;<br />    } <br />}<br /><br /><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> PowerCord : IPart<br />{<br />    <span style="color: #0000ff">public</span> IEnumerable&lt;IPart&gt; GetChildParts()<br />    {<br />        <span style="color: #0000ff">yield</span> <span style="color: #0000ff">break</span>;<br />    }        <br />}</pre>
</div>

Now we can easily build a part list generator that uses a recursive method to walk through the hierarchy and outputs the names of the parts.

<div>
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> PartListGenerator<br />{<br />    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> OutpAllParts(IPart part, TextWriter textWriter)<br />    {<br />        OuputAllPartsByLevel(part, textWriter, 0);    <br />    }<br /><br />    <span style="color: #0000ff">private</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">void</span> OuputAllPartsByLevel(IPart part, TextWriter textWriter, <span style="color: #0000ff">int</span> level)<br />    {<br />        textWriter.WriteLine(<span style="color: #006080">"{0}{1}"</span>, <span style="color: #0000ff">new</span> <span style="color: #0000ff">string</span>(<span style="color: #006080">'t'</span>, level), part.GetType().Name);<br /><br />        <span style="color: #0000ff">foreach</span> (var childPart <span style="color: #0000ff">in</span> part.GetChildParts())<br />        {<br />            OuputAllPartsByLevel(childPart, textWriter, level + 1);<br />        }<br />    }<br />}</pre>
</div>

By running our CoffeeMachine through this class, we end up with something similar to the following output:

CoffeeMachine  
&nbsp;&nbsp;&nbsp; FluxCapacitor  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Switch  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; PowerBooster  
&nbsp;&nbsp;&nbsp; PowerCord 

&nbsp;

<div>
  You may have noticed that we have the GetChildParts() method implemented on the leaf parts as well (see PowerCord). This may be a slight violation of <a href="/blogs/rhouston/archive/2008/03/14/ptom-the-interface-segregation-principle.aspx">ISP</a>, but it is side effect free and it does not violate <a href="/blogs/chad_myers/archive/2008/03/09/ptom-the-liskov-substitution-principle.aspx">LSP</a> therefor it does not bother me too much. In the real world, IPart would probably have other functionality and you could split out the GetChildParts() into a separate interface such as ICompositePart which would only be implemented by non leafs. This would require the PartListGenerator to know about IParts and ICompositeParts which may or may not be desirable. It&#8217;s really a trade off here as to what makes the most sense for your needs.
</div>

<div>
  &nbsp;
</div>

<div>
  There are several variations of the Composite Design Pattern and my example can probably be considered one of them. The Composite can also be combined with other patterns such as the Specification or Command patterns. You can find lots of other examples on the web and in <a href="http://www.amazon.com/Design-Patterns-Object-Oriented-Addison-Wesley-Professional/dp/0201633612/ref=sr_11_1?ie=UTF8&qid=1207103933&sr=11-1">Design Patterns : Elements of Reusable Object-Oriented Software</a>. I recommend picking up that book for more information on the Composite and many other must know patterns.
</div>

<div>
  &nbsp;
</div>