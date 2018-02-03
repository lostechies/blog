---
wordpress_id: 165
title: 'PTOM: The Dependency Inversion Principle'
date: 2008-03-31T20:52:04+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/03/31/ptom-the-dependency-inversion-principle.aspx
dsq_thread_id:
  - "264715638"
categories:
  - PTOM
---
The Dependency Inversion Principle, the last of the Uncle Bob &#8220;SOLID&#8221; object-oriented design principles, can be thought of the natural progression of the Liskov Substitution Principle, the Open Closed Principle and even the Single Responsibility Principle.&nbsp; This post is the latest in the set of SOLID posts:

  * [PTOM: The Single Responsibility Principle](http://www.lostechies.com/blogs/sean_chambers/archive/2008/03/15/ptom-single-responsibility-principle.aspx) 
      * [PTOM: The Open Closed Principle](http://www.lostechies.com/blogs/joe_ocampo/archive/2008/03/21/ptom-the-open-closed-principle.aspx) 
          * [PTOM: The Liskov Substitution Principle](http://lostechies.com/blogs/chad_myers/archive/2008/03/11/ptom-the-liskov-substitution-principle.aspx) 
              * [PTOM: The Interface Segregation Principle](http://www.lostechies.com/blogs/rhouston/archive/2008/03/14/ptom-the-interface-segregation-principle.aspx)</ul> 
            The Dependency Inversion Principle, or DIP, is often used interchangeably with [Dependency Injection and Inversion of Control](http://martinfowler.com/articles/injection.html).&nbsp; However, following DIP does not mean we must automatically use a IoC container like Spring.NET, Windsor or StructureMap.&nbsp; IoC containers are tools to assist in applications adhering to DIP, but we can follow DIP without using IoC containers.
            
            The Dependency Inversion Principle states:
            
              * **High level modules should not depend upon low level modules.&nbsp; Both should depend upon abstractions.** 
                  * **Abstractions should not depend upon details.&nbsp; Details should depend upon abstractions.**</ul> </ul> 
                The DIP can be a little vague, as it talks about &#8220;abstractions&#8221; but doesn&#8217;t describe _what_ is being abstracted.&nbsp; It speaks of &#8220;modules&#8221;, which don&#8217;t have much meaning in .NET unless you consider &#8220;modules&#8221; to be assemblies.&nbsp; If you&#8217;re looking at Domain-Driven Design, modules mean something else entirely.
                
                The Dependency Inversion Principle, along with the other SOLID principles, are meant to alleviate the problems of bad designs.&nbsp; The typical software I run into in existing projects has code organized into classes, but it still isn&#8217;t easy to change.&nbsp; I usually see big balls of mud along with a crazy spider web of dependencies where you can&#8217;t sneeze without breaking code on the other side of the planet.
                
                ### Spider webs and bad design
                
                Bad designs and bad code is bad because it&#8217;s hard to change.&nbsp; Bad designs are:
                
                  * Rigid (change affects too many parts of the system) 
                      * Fragile (every change breaks something unexpected) 
                          * Immobile (impossible to reuse)</ul> 
                        Some people&#8217;s ideas of &#8220;bad design&#8221; would be something like seeing string concatenation instead of a StringBuilder.&nbsp; While this may not be the best performing choice, string concatenation isn&#8217;t necessarily a bad design.
                        
                        It&#8217;s pretty easy to spot bad designs.&nbsp; These are sections of code or entire applications that you dread touching.&nbsp; A typical example of rigid, fragile and immobile&nbsp; (bad) code would be:
                        
                        <pre><span style="color: blue">public class </span><span style="color: #2b91af">OrderProcessor
</span>{
    <span style="color: blue">public decimal </span>CalculateTotal(<span style="color: #2b91af">Order </span>order)
    {
        <span style="color: blue">decimal </span>itemTotal = order.GetItemTotal();
        <span style="color: blue">decimal </span>discountAmount = <span style="color: #2b91af">DiscountCalculator</span>.CalculateDiscount(order);

        <span style="color: blue">decimal </span>taxAmount = 0.0M;

        <span style="color: blue">if </span>(order.Country == <span style="color: #a31515">"US"</span>)
            taxAmount = FindTaxAmount(order);
        <span style="color: blue">else if </span>(order.Country == <span style="color: #a31515">"UK"</span>)
            taxAmount = FindVatAmount(order);
            
        <span style="color: blue">decimal </span>total = itemTotal - discountAmount + taxAmount;

        <span style="color: blue">return </span>total;
    }

    <span style="color: blue">private decimal </span>FindVatAmount(<span style="color: #2b91af">Order </span>order)
    {
        <span style="color: green">// find the UK value added tax somehow
        </span><span style="color: blue">return </span>10.0M;
    }

    <span style="color: blue">private decimal </span>FindTaxAmount(<span style="color: #2b91af">Order </span>order)
    {
        <span style="color: green">// find the US tax somehow
        </span><span style="color: blue">return </span>10.0M;
    }
}
</pre>
                        
                        [](http://11011.net/software/vspaste)
                        
                        The OrderProcessor sets out to do something very simple: calculate the total of an Order.&nbsp; To do so, it needs to know the item total of the order, any discounts applied, as well as the tax amount (which depends on the Order&#8217;s Country).
                        
                        #### 
                        
                        #### Too many responsibilities
                        
                        To see why the DIP goes hand-in-hand with the Single Responsibility Principle, let&#8217;s list out the responsibilities of the OrderProcessor:
                        
                          * Knowing how to calculate the item total 
                              * Finding the discount calculator and finding the discount 
                                  * Knowing what country codes mean 
                                      * Finding the correct taxing method for each country code 
                                          * Knowing how to calculate tax for each country (commented out for brevity&#8217;s sake) 
                                              * Knowing how to combine all of the results into the correct final total</ul> 
                                            If a single class (or a single method in this case) answers too many questions (how, where, what, why etc.), it&#8217;s a good indication that this class has too many responsibilities.
                                            
                                            To move towards a good design, we need to remove the external dependencies of this class to pare it down to its core responsibility: finding the order total.&nbsp; Offhand, the dependencies I see are:
                                            
                                              * DiscountCalculator 
                                                  * Tax decisions</ul> 
                                                In the future, we might need to support more countries, which means more tax services, and more responsibilities.&nbsp; To reduce the rigidity, fragility and immobility of this design, we need to move these dependencies outside of this class.
                                                
                                                ### Towards a better design
                                                
                                                When following the DIP, you notice that the Strategy pattern begins to show up in a lot of your designs.&nbsp; Strategy tends to solve the &#8220;details should depend on abstractions&#8221; part of the DIP.&nbsp; Factoring out the DiscountCalculator and the tax decisions, we wind up with two new interfaces:
                                                
                                                  * IDiscountCalculator 
                                                      * ITaxStrategy</ul> 
                                                    I&#8217;m not a huge fan of the &#8220;ITaxStrategy&#8221; name, but it will suffice until we find a better name from our model.
                                                    
                                                    #### Factoring out the dependencies
                                                    
                                                    To factor out the dependencies, first I&#8217;ll create a couple of interfaces that match the existing method signatures:
                                                    
                                                    <pre><span style="color: blue">public interface </span><span style="color: #2b91af">IDiscountCalculator
</span>{
    <span style="color: blue">decimal </span>CalculateDiscount(<span style="color: #2b91af">Order </span>order);
}

<span style="color: blue">public interface </span><span style="color: #2b91af">ITaxStrategy
</span>{
    <span style="color: blue">decimal </span>FindTaxAmount(<span style="color: #2b91af">Order </span>order);
}
</pre>
                                                    
                                                    [](http://11011.net/software/vspaste)
                                                    
                                                    Now that I have a couple of interfaces defined, I can modify the OrderProcessor to use these interfaces instead:
                                                    
                                                    <pre><span style="color: blue">public class </span><span style="color: #2b91af">OrderProcessor
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">IDiscountCalculator </span>_discountCalculator;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">ITaxStrategy </span>_taxStrategy;

    <span style="color: blue">public </span>OrderProcessor(<span style="color: #2b91af">IDiscountCalculator </span>discountCalculator, 
                          <span style="color: #2b91af">ITaxStrategy </span>taxStrategy)
    {
        _taxStrategy = taxStrategy;
        _discountCalculator = discountCalculator;
    }

    <span style="color: blue">public decimal </span>CalculateTotal(<span style="color: #2b91af">Order </span>order)
    {
        <span style="color: blue">decimal </span>itemTotal = order.GetItemTotal();
        <span style="color: blue">decimal </span>discountAmount = _discountCalculator.CalculateDiscount(order);

        <span style="color: blue">decimal </span>taxAmount = _taxStrategy.FindTaxAmount(order);

        <span style="color: blue">decimal </span>total = itemTotal - discountAmount + taxAmount;

        <span style="color: blue">return </span>total;
    }
}
</pre>
                                                    
                                                    [](http://11011.net/software/vspaste)
                                                    
                                                    The CalculateTotal method looks much cleaner now, delegating the details of discounts and tax to the appropriate abstractions.&nbsp; Instead of the OrderProcessor depending directly on details, it depends solely on the abstracted interfaces we created earlier.&nbsp; The specifics of how to find the correct tax method is now encapsulated from the OrderProcessor, as is the hard dependency on a static method in the DiscountCalculator.
                                                    
                                                    #### Filling out the implementations
                                                    
                                                    Now that we have the interfaces defined, we need actual implementations for these dependencies.&nbsp; Looking at the DiscountCalculator, which is a static class, I find that I can&#8217;t immediately change it to a non-static class.&nbsp; There are many other places with references to this DiscountCalculator, and since it&#8217;s the real world, none of these other places have tests.
                                                    
                                                    Instead, I can just use the Adapter pattern to adapt the interface I need for an IDiscountCalculator:
                                                    
                                                    <pre><span style="color: blue">public class </span><span style="color: #2b91af">DiscountCalculatorAdapter </span>: <span style="color: #2b91af">IDiscountCalculator
</span>{
    <span style="color: blue">public decimal </span>CalculateDiscount(<span style="color: #2b91af">Order </span>order)
    {
        <span style="color: blue">return </span><span style="color: #2b91af">DiscountCalculator</span>.CalculateDiscount(order);
    }
}
</pre>
                                                    
                                                    [](http://11011.net/software/vspaste)
                                                    
                                                    In applying the Adapter pattern, I just wrap the real DiscountCalculator in a different class.&nbsp; The advantage of the Adapter pattern in this case is that the existing DiscountCalculator can continue to exist, but <strike>if</strike> when the mechanism for calculating discounts changes, my OrderProcessor does not need to change.
                                                    
                                                    For the tax strategies, I can create two implementations for each kind of tax calculation being used today:
                                                    
                                                    <pre><span style="color: blue">public class </span><span style="color: #2b91af">USTaxStrategy </span>: <span style="color: #2b91af">ITaxStrategy
</span>{
    <span style="color: blue">public decimal </span>FindTaxAmount(<span style="color: #2b91af">Order </span>order)
    {
    }
}

<span style="color: blue">public class </span><span style="color: #2b91af">UKTaxStrategy </span>: <span style="color: #2b91af">ITaxStrategy
</span>{
    <span style="color: blue">public decimal </span>FindTaxAmount(<span style="color: #2b91af">Order </span>order)
    {
    }
}
</pre>
                                                    
                                                    [](http://11011.net/software/vspaste)
                                                    
                                                    I left the implementations out, but I basically moved the methods from the OrderProcessor into these new classes.&nbsp; Neither of the original methods used any instance fields, so I could copy them straight over.
                                                    
                                                    My OrderProcessor now has dependencies factored out, so its single responsibility is easily discerned from looking at the code.&nbsp; Additionally, the implementations of IDiscountCalculator and ITaxStrategy can change without affecting the OrderProcessor.
                                                    
                                                    ### Isolating the ugly stuff
                                                    
                                                    For me, the DIP is all about isolating the ugly stuff.&nbsp; For calculating order totals, I shouldn&#8217;t be concerned about where the discounts are or how to decide what tax strategy should be used.&nbsp; We did increase the number of classes significantly, but this is what happens when we move away from a procedural mindset to a true object-oriented design.
                                                    
                                                    I still have the complexity to solve of pushing the dependencies into the OrderProcessor.&nbsp; Clients of the OrderProcessor now have the burden of creating the correct dependency and giving them to the OrderProcessor.&nbsp; But that problem is already solved with Inversion of Control (IoC) containers like Spring.NET, Windsor, StructureMap, Unity and others.
                                                    
                                                    These IoC containers let me configure the &#8220;what&#8221; when injecting dependencies, so even that decision is removed from the client.&nbsp; If I didn&#8217;t want to go with an IoC container, even a simple creation method or factory class could abstract the construction of the OrderProcessor with the correct dependencies.
                                                    
                                                    By adhering to the Dependency Inversion Principle, I can create designs that are clean, with clearly defined responsibilities.&nbsp; With the dependencies extracted out, the implementation details of each dependency can change without affecting the original class.
                                                    
                                                    And that&#8217;s my ultimate goal: code that is easy to change.&nbsp; Easier to change means a lower total cost of ownership and higher maintainability.&nbsp; Since we know that requirements will eventually change, it&#8217;s in our best interest to promote a design that facilitates change through the Dependency Inversion Principle.