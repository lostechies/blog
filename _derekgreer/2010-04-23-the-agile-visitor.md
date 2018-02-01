---
id: 9
title: The Agile Visitor
date: 2010-04-23T23:59:12+00:00
author: Derek Greer
layout: post
guid: /blogs/derekgreer/archive/2010/04/23/the-agile-visitor.aspx
dsq_thread_id:
  - "262468825"
categories:
  - Uncategorized
tags:
  - Design Patterns
---
When working with object structures, you may at times encounter the need to perform some operation across all the elements within the structure.&#160; For instance, given a compound piece of machinery, you may want to perform some operation which requires examining each part to create a parts manifest, compute the total price, or determine which parts may need special storage or handling needs.&#160; 

There may also be a need to easily add new cross-cutting operations across the elements which either aren&#8217;t related to the inherent responsibility of each of the elements and/or when no common base object exists allowing inheritance of the new behavior. The <a href="http://en.wikipedia.org/wiki/Visitor_pattern" target="_blank">Visitor</a> pattern is one approach which aids in facilitating these kinds of needs. 

## &#160;

## The Visitor Pattern

The Visitor pattern encapsulates common behavior within a single class which is applied to each of the elements of the object structure. The following diagram depicts the pattern structure: 

&#160;

[<img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="VisitorClassDiagram" src="http://lostechies.com/derekgreer/files/2011/03/VisitorClassDiagram_093E7956.png" />](http://lostechies.com/derekgreer/files/2011/03/VisitorClassDiagram_thumb_74BBBA88.png) 

&#160;

The Visitor pattern is comprised of three main types of participants: the Visitor, the Element, and the Object Structure. The Visitor encapsulates the common behavior needed across different types of elements.&#160; Elements are the types within an object structure for which common behavior is needed.&#160; The Object Structure is the element container and may take the form of a collection or composite.

Each visitor defines methods specific to each type of element within the object structure while elements define a method capable of accepting a Visitor.&#160; When a client desires to apply the visitor behavior to each of the elements, the object structure is used to orchestrate delivery of the visitor to each element.&#160; Upon receiving the visitor, each element calls a corresponding method on the visitor, passing a reference to itself as the method parameter.&#160; Once invoked, the visitor&#8217;s methods are capable of accessing state or invoking behavior specific to each type of element.&#160; 

&#160;

<table border="1" cellspacing="0" cellpadding="2" width="700">
  <tr>
    <td valign="top" width="700">
      Sidebar
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="700">
      <p>
        When first encountering the Visitor pattern, some may wonder why each element is implemented with an <em>Accept(Visitor)</em> method as opposed to just having the object structure pass each of the elements directly to the visitor.&#160; At first, this may seem to unnecessarily couple the elements to the visitor.
      </p>
      
      <p>
        This approach stems from the fact that many programming languages don&#8217;t support dynamic binding for method overloads.&#160; That is to say, the method invoked on an object is determined at compile time based upon the reference type of the method parameters, not at run-time based upon the type of the referenced object.&#160; When implementing the Visitor pattern in such cases, if an object structure were to pass in each element referenced through a common interface then only a Visitor method defined specifically for that interface type could be invoked.&#160; To overcome this limitation, a technique known as <a href="http://www.lostechies.com/blogs/derekgreer/archive/2010/04/18/double-dispatch-is-a-code-smell.aspx" target="_blank">Double Dispatch</a> is used to ensure that the correct Visitor method is statically dispatched.
      </p>
      
      <p>
        As of C# 4.0, the <a href="http://msdn.microsoft.com/en-us/library/dd264736.aspx" target="_blank">dynamic</a> keyword can be used as an alternate strategy to the traditional double dispatch pattern allowing the elements to be free of any coupling imposed by the classic Visitor pattern implementation.
      </p>
    </td>
  </tr>
</table>

&#160;

The following is an example application which uses the classic Visitor pattern structure to print a parts manifest and a dangerous goods manifest for a thermostat: 

<pre class="brush:csharp; gutter:false; wrap-lines:false; tab-size:2;">class Program
    {
        static void Main(string[] args)
        {
            var thermostat = new Thermostat();
            var partsManifestVisitor = new PartsManifestVisitor();
            var dangerousGoodsManifestVisitor = new DangerousGoodsManifestVisitor();
            thermostat.Accept(partsManifestVisitor);
            thermostat.Accept(dangerousGoodsManifestVisitor);

            Console.WriteLine("Parts List");
            Console.WriteLine("----------");
            partsManifestVisitor.PrintManifest(Console.Out);

            Console.WriteLine("nDangerous Goods List");
            Console.WriteLine("----------");
            dangerousGoodsManifestVisitor.PrintManifest(Console.Out);

            Console.ReadLine();
        }
    }

    interface IComponentVisitor
    {
        void Visit(Thermostat thermostat);
        void Visit(ThermostatCover thermostatCover);
        void Visit(CircutBoard circutBoard);
        void Visit(MercurySwitch mercurySwitch);
        void Visit(BimetallicStrip bimetallicStrip);
        void Visit(HeatAnticipator heatAnticipator);
    }

    interface IComponentElement
    {
        void Accept(IComponentVisitor visitor);
    }

    class Thermostat : IComponentElement
    {
        readonly IComponentElement[] _elements;

        public Thermostat()
        {
            _elements = new IComponentElement[]
                           {
                                new ThermostatCover(),
                                new CircutBoard(),
                               new MercurySwitch(),
                               new BimetallicStrip(),                               
                               new HeatAnticipator()                              
                           };
        }

        public void Accept(IComponentVisitor visitor)
        {
            visitor.Visit(this);

            foreach (var element in _elements)
            {
                element.Accept(visitor);
            }
        }
    }

    class ThermostatCover : IComponentElement
    {
        public void Accept(IComponentVisitor visitor)
        {
            visitor.Visit(this);
        }
    }

    class CircutBoard : IComponentElement
    {
        public void Accept(IComponentVisitor visitor)
        {
            visitor.Visit(this);
        }
    }

    class MercurySwitch : IComponentElement
    {
        public void Accept(IComponentVisitor visitor)
        {
            visitor.Visit(this);
        }
    }

    class BimetallicStrip : IComponentElement
    {
        public void Accept(IComponentVisitor visitor)
        {
            visitor.Visit(this);
        }
    }

    class HeatAnticipator : IComponentElement
    {
        public void Accept(IComponentVisitor visitor)
        {
            visitor.Visit(this);
        }
    }

    class PartsManifestVisitor : IComponentVisitor
    {
        IList&lt;string&gt; manifest = new List&lt;string&gt;();


        public void PrintManifest(TextWriter textWriter)
        {
            manifest.ToList().ForEach(x =&gt; textWriter.WriteLine(x));
        }

        public void Visit(Thermostat thermostat)
        {
            manifest.Add("Thermostat");
        }

        public void Visit(ThermostatCover thermostatCover)
        {
            manifest.Add("Thermostat cover");
        }

        public void Visit(CircutBoard circutBoard)
        {
            manifest.Add("Circut board");
        }

        public void Visit(MercurySwitch mercurySwitch)
        {
            manifest.Add("Mercury switch");
        }

        public void Visit(BimetallicStrip bimetallicStrip)
        {
            manifest.Add("Bimetallic strip");
        }

        public void Visit(HeatAnticipator heatAnticipator)
        {
            manifest.Add("Heat anticipator");
        }
    }

    class DangerousGoodsManifestVisitor : IComponentVisitor
    {
        IList&lt;string&gt; manifest = new List&lt;string&gt;();

        public void PrintManifest(TextWriter textWriter)
        {
            manifest.ToList().ForEach(x =&gt; textWriter.WriteLine(x));
        }

        public void Visit(Thermostat thermostat)
        {
        }

        public void Visit(ThermostatCover thermostatCover)
        {
        }

        public void Visit(CircutBoard circutBoard)
        {
        }

        public void Visit(MercurySwitch mercurySwitch)
        {
            manifest.Add("Mercury switch");
        }

        public void Visit(BimetallicStrip bimetallicStrip)
        {
        }

        public void Visit(HeatAnticipator heatAnticipator)
        {
        }
    }</pre>

&#160;

Running the application produces the following output: 

``

<pre>Parts List
----------
Thermostat
Thermostat cover
Circut board
Mercury switch
Bimetallic strip
Heat anticipator

Dangerous Goods List
----------
Mercury switch</pre></p> 

By using the Visitor pattern, the application was able to print a parts list and a dangerous goods list without adding any specific logic to the thermostat components.&#160; As new cross-cutting operations come up, a new visitor can be created without modification to the components.&#160; 

The down side of this example is that if any new components are added, each of the visitors will need to be updated.&#160; This violates the <a href="http://en.wikipedia.org/wiki/Open_Closed_Principle" target="_blank">Open/Closed</a> principle. Additionally, depending upon the type of behavior encapsulated by the visitor, the behavior for each element type may change for different reasons.&#160; In such cases, this would violate the <a href="http://en.wikipedia.org/wiki/Single_responsibility_principle" target="_blank">Single Responsibility</a> principle.&#160; What would be nice is to achieve a visitor implementation that satisfied both of these concerns. 

&#160;

## An Agile Visitor 

What if a visitor allowed us to replace the overloaded methods with <a href="http://en.wikipedia.org/wiki/Strategy_pattern" target="_blank">strategies</a>?&#160; Consider the following example: 

&#160;

<pre class="brush:csharp; gutter:false; wrap-lines:false; tab-size:2;">class Program
    {
        static void Main(string[] args)
        {
            // Declare visitors
            var partsManifestVisitor = new Visitor&lt;IVisitable&gt;();
            var dangerousGoodsManifestVisitor = new Visitor&lt;IVisitable&gt;();

            // Register parts manifest visitor strategies
            partsManifestVisitor.RegisterElementVisitor&lt;Thermostat&gt;(x =&gt; Console.WriteLine("Thermostat"));
            partsManifestVisitor.RegisterElementVisitor&lt;ThermostatCover&gt;(x =&gt; Console.WriteLine("Thermostat cover"));
            partsManifestVisitor.RegisterElementVisitor&lt;CircutBoard&gt;(x =&gt; Console.WriteLine("Circut board"));
            partsManifestVisitor.RegisterElementVisitor&lt;MercurySwitch&gt;(x =&gt; Console.WriteLine("Mercury switch"));
            partsManifestVisitor.RegisterElementVisitor&lt;BimetallicStrip&gt;(x =&gt; Console.WriteLine("Bimetallic strip"));
            partsManifestVisitor.RegisterElementVisitor&lt;HeatAnticipator&gt;(x =&gt; Console.WriteLine("Heat anticipator"));

            // Register dangerous goods manifest visitor strategies
            partsManifestVisitor.RegisterElementVisitor&lt;MercurySwitch&gt;(x =&gt; Console.WriteLine("Mercury switch"));

            var thermostat = new Thermostat();

            Console.WriteLine("Parts List");
            Console.WriteLine("----------");
            thermostat.Accept(partsManifestVisitor);

            Console.WriteLine("nDangerous Goods List");
            Console.WriteLine("----------");
            thermostat.Accept(dangerousGoodsManifestVisitor);            

            Console.ReadLine();
        }
    }</pre>

&#160;

In this example, the methods normally found on the classic visitor implementation have been replaced with lambda expressions registered for each type to be visited.&#160; There are several advantages to this approach:

First, the Visitor type is extensible and thus adheres to the Open/Closed principle. 

Second, the Visitor type is generic, thus enabling it to be used for many (all?) types of visitor implementations. 

Third, due to the fact that there are no concrete visitors coupled to a given object structure, new elements can be added to a given object structure without requiring that all visitors for that structure be modified to accommodate the new element. 

Forth, the behavior associated with each type is encapsulated in a single Visitor strategy, thus adhering to the single responsibility principle. 

Fifth, due to the fact that the Visitor isn&#8217;t itself coupled to any particular element type, the element types are likewise not coupled to any object structure specific visitor interface.&#160; This allows a given element to participate in unrelated object structure/visitor pattern implementations. 

There are a couple of drawbacks to this approach however: 

First, what happens when the behavior is more complex?&#160; For that, we could just add an overloaded RegisterElementVisitor<T>() to accept an IVisitor<T>:

&#160;

<pre class="brush:csharp; gutter:false; wrap-lines:false; tab-size:2;">class ThermostatVisitor : IVisitor&lt;Thermostat&gt;
    {
        public void Visit(Thermostat element)
        {
            Console.WriteLine("Thermostat");
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            var partsManifestVisitor = new Visitor&lt;IVisitable&gt;();

            partsManifestVisitor.RegisterElementVisitor&lt;Thermostat&gt;(new ThermostatVisitor());
     
            // snip
        }
    }</pre>

&#160;

That addresses the issue of how we might better encapsulate the more complex behaviors, but a second shortcoming is the loss of encapsulated state.&#160; One of the good things the classic Visitor pattern gives us is shared state for accumulating the results of our visitations.&#160; There are a few ways we could address this however.&#160; The first approach would be to just use closures:

&#160;

<pre class="brush:csharp; gutter:false; wrap-lines:false; tab-size:2;">// snip

            // Register parts manifest visitor strategies
            var partsManifest = new List&lt;string&gt;();

            partsManifestVisitor.RegisterElementVisitor&lt;Thermostat&gt;(x =&gt; partsManifest.Add("Thermostat"));
            partsManifestVisitor.RegisterElementVisitor&lt;ThermostatCover&gt;(x =&gt; partsManifest.Add("Thermostat cover"));
            partsManifestVisitor.RegisterElementVisitor&lt;CircutBoard&gt;(x =&gt; partsManifest.Add("Circut board"));
            partsManifestVisitor.RegisterElementVisitor&lt;MercurySwitch&gt;(x =&gt; partsManifest.Add("Mercury switch"));
            partsManifestVisitor.RegisterElementVisitor&lt;BimetallicStrip&gt;(x =&gt; partsManifest.Add("Bimetallic strip"));
            partsManifestVisitor.RegisterElementVisitor&lt;HeatAnticipator&gt;(x =&gt; partsManifest.Add("Heat anticipator"));

            var thermostat = new Thermostat();
            thermostat.Accept(partsManifestVisitor);

            Console.WriteLine("Parts List");
            Console.WriteLine("----------");
            partsManifest.ToList().ForEach(x =&gt; Console.WriteLine(x));

            // snip</pre>

&#160;

A second approach would be to inject a state service when registering IVisitor<T> strategies: 

&#160;

<pre class="brush:csharp; gutter:false; wrap-lines:false; tab-size:2;">class Manifest
    {
        public IList&lt;string&gt; Parts { get; private set; }

        public Manifest()
        {
            Parts = new List&lt;string&gt;();
        }

        public void RecordPart(string partName)
        {            
            Parts.Add(partName);
        }
    }

    class ThermostatVisitor : IVisitor&lt;Thermostat&gt;
    {
        Manifest _manifest;

        public ThermostatVisitor(Manifest manifest)
        {
            _manifest = manifest;
        }

        public void Visit(Thermostat element)
        {
            _manifest.RecordPart("Thermostat");
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            // Declare visitors
            var partsManifestVisitor = new Visitor&lt;IVisitable&gt;();

            // Register parts manifest visitor strategies
            var manifest = new Manifest();
            partsManifestVisitor.RegisterElementVisitor&lt;Thermostat&gt;(new ThermostatVisitor(manifest));
         
            // other strategies

            var thermostat = new Thermostat();
            thermostat.Accept(partsManifestVisitor);

            Console.WriteLine("Parts List");
            Console.WriteLine("----------");
            manifest.Parts.ToList().ForEach(x =&gt; Console.WriteLine(x));
        }
    }</pre>

&#160;

Things are starting to get strewn about though. Let&#8217;s bundle all of this up into a <a href="http://en.wikipedia.org/wiki/Facade_pattern" target="_blank">facade</a>: 

&#160;

<pre class="brush:csharp; gutter:false; wrap-lines:false; tab-size:2;">class PartsManifestVisitorFacade : IVisitor&lt;IVisitable&gt;
    {
        Manifest _manifest = new Manifest();
        Visitor&lt;IVisitable&gt; partsManifestVisitor = new Visitor&lt;IVisitable&gt;();
     
        public PartsManifestVisitorFacade()
        {           
            partsManifestVisitor.RegisterElementVisitor&lt;Thermostat&gt;(new ThermostatVisitor(_manifest));
            
            // Register other strategies  ...
        }

        public IList&lt;string&gt; Manifest
        {
            get
            {
                return _manifest.Parts;
            }
        }

        public void Visit(IVisitable element)
        {
            partsManifestVisitor.Visit(element);
        }
    }

    class Program
    {
        static void Main(string[] args)
        {           
            var partsManifestVisitor = new PartsManifestVisitorFacade();         
            var thermostat = new Thermostat();       
            thermostat.Accept(partsManifestVisitor);

            Console.WriteLine("Parts List");
            Console.WriteLine("----------");
            partsManifestVisitor.Manifest.ToList().ForEach(x =&gt; Console.WriteLine(x));

            Console.ReadLine();
        }
    }</pre>

&#160;

Alternately, we could use some DI registration magic to have an open generic visitor get closed-over, configured, and injected into wherever we are going to use it.&#160; Such an example is a tad bit beyond the intended scope of this article, however, so I&#8217;ll leave that as an exercise for the reader to explore. 

By this point, you may be wondering: "So where&#8217;s the actual Visitor code"?&#160; While I’m sure a better implementation is possible, here’s my working prototype: 

&#160;

<pre class="brush:csharp; gutter:false; wrap-lines:false; tab-size:2;">/// &lt;summary&gt;
    /// Defines a visitor.
    /// &lt;/summary&gt;
    /// &lt;typeparam name="TElement"&gt;the type of element to be visited&lt;/typeparam&gt;
    interface IVisitor&lt;TElement&gt;
    {
        void Visit(TElement element);
    }

    /// &lt;summary&gt;
    /// Defines a visitable element.
    /// &lt;/summary&gt;
    interface IVisitable
    {
        void Accept(IVisitor&lt;IVisitable&gt; visitor);
    }

    /// &lt;summary&gt;
    /// Represents an open/closed visitor.
    /// &lt;/summary&gt;
    /// &lt;typeparam name="T"&gt;the type of element to visit&lt;/typeparam&gt;
    class Visitor&lt;T&gt; : IVisitor&lt;T&gt;
    {
        readonly IDictionary&lt;Type, IVisitorInfo&gt; _visitorInfoDictionary = new Dictionary&lt;Type, IVisitorInfo&gt;();

        /// &lt;summary&gt;
        /// Visits the specified element.
        /// &lt;/summary&gt;
        /// &lt;param name="element"&gt;element to visit&lt;/param&gt;
        public void Visit(T element)
        {
            if (_visitorInfoDictionary.ContainsKey(element.GetType()))
            {
                IVisitorInfo visitorInfo = _visitorInfoDictionary[element.GetType()];
                object visitor = visitorInfo.Visitor;
                IVisitorInvoker invoker = visitorInfo.Invoker;
                invoker.Invoke(visitor, element);
            }
        }

        /// &lt;summary&gt;
        /// Registers an visitor action delegate for a specific type.
        /// &lt;/summary&gt;
        /// &lt;typeparam name="TElement"&gt;type of element&lt;/typeparam&gt;
        /// &lt;param name="action"&gt;the visitor action&lt;/param&gt;
        public void RegisterElementVisitor&lt;TElement&gt;(Action&lt;TElement&gt; action)
        {
            RegisterElementVisitor(new VisitorAction&lt;TElement&gt;(action));
        }

        /// &lt;summary&gt;
        /// Registers a &lt;see cref="IVisitor{TElement}"/&gt; strategy for a specific type.
        /// &lt;/summary&gt;
        /// &lt;typeparam name="TElement"&gt;type of element&lt;/typeparam&gt;
        /// &lt;param name="visitor"&gt;a visitor&lt;/param&gt;
        public void RegisterElementVisitor&lt;TElement&gt;(IVisitor&lt;TElement&gt; visitor)
        {
            var visitorInfo = new VisitorInfo&lt;TElement&gt;(
                visitor, new DelegateVisitorInvoker&lt;IVisitor&lt;TElement&gt;, TElement&gt;((x, y) =&gt; x.Visit(y)));

            _visitorInfoDictionary.Add(typeof(TElement), visitorInfo);
        }

        /// &lt;summary&gt;
        /// Nested class used to encapsulate a visitor action.
        /// &lt;/summary&gt;
        /// &lt;typeparam name="TVisitor"&gt;the type of visitor action&lt;/typeparam&gt;
        /// &lt;typeparam name="TElement"&gt;the type of element&lt;/typeparam&gt;
        class DelegateVisitorInvoker&lt;TVisitor, TElement&gt; : IVisitorInvoker
        {
            readonly Action&lt;TVisitor, TElement&gt; _action;

            public DelegateVisitorInvoker(Action&lt;TVisitor, TElement&gt; action)
            {
                _action = action;
            }

            public void Invoke(object action, object instance)
            {
                _action.Invoke((TVisitor)action, (TElement)instance);
            }
        }

        /// &lt;summary&gt;
        /// Nested interface used as the key to the internal dictionary for associating
        /// visitors with their invokers.
        /// &lt;/summary&gt;
        interface IVisitorInfo
        {
            IVisitorInvoker Invoker { get; }
            object Visitor { get; }
        }

        /// &lt;summary&gt;
        /// Nested interface used to encapsulate a visit action invocation.
        /// &lt;/summary&gt;
        interface IVisitorInvoker
        {
            void Invoke(object action, object instance);
        }

        /// &lt;summary&gt;
        /// Nested class used to encapsulate visitor actions.
        /// &lt;/summary&gt;
        /// &lt;typeparam name="TElement"&gt;the type of element to visit&lt;/typeparam&gt;
        class VisitorAction&lt;TElement&gt; : IVisitor&lt;TElement&gt;
        {
            readonly Action&lt;TElement&gt; _action;

            public VisitorAction(Action&lt;TElement&gt; action)
            {
                _action = action;
            }

            public void Visit(TElement element)
            {
                _action.Invoke(element);
            }
        }

        /// &lt;summary&gt;
        /// Nested class used as the key to the internal dictionary for associating
        /// visitors with their invokers.
        /// &lt;/summary&gt;
        /// &lt;typeparam name="TElement"&gt;the type of element to be visited&lt;/typeparam&gt;
        ///
        /// &lt;remarks&gt;
        /// This type is used as the internal dictionary key to associate visitors with
        /// a corresponding invoker and enables the specific type information to be
        /// maintained for each visitor/element pair.
        /// &lt;/remarks&gt;
        class VisitorInfo&lt;TElement&gt; : IVisitorInfo
        {
            public VisitorInfo(IVisitor&lt;TElement&gt; visitor, IVisitorInvoker invoker)
            {
                Visitor = visitor;
                Invoker = invoker;
            }

            public IVisitorInvoker Invoker { get; private set; }
            public object Visitor { get; private set; }
        }
    }</pre>

## &#160;

## Conclusion 

The structure of the classic Visitor pattern seem to reflect the design sensibilities and capabilities of the mainstream programming languages of its day. While the problem it seeks to address remains relevant, it seems prudent to reconsider such patterns from time to time in light of both the ever-evolving capabilities of mainstream development platforms and design principles of today.

&#160;

So, is this a better approach?&#160; Let me know what you think.
