---
wordpress_id: 8
title: Double Dispatch is a Code Smell
date: 2010-04-19T01:50:00+00:00
author: Derek Greer
layout: post
wordpress_guid: /blogs/derekgreer/archive/2010/04/18/double-dispatch-is-a-code-smell.aspx
dsq_thread_id:
  - "262468819"
categories:
  - Uncategorized
tags:
  - Design Patterns
---
If you&#8217;re using [Double Dispatch](http://en.wikipedia.org/wiki/Double_dispatch) in your code, this may be a symptom of an underlying design issue which may impact the maintainability of your application.&#160; Due to the fact that Double Dispatch is at times confused with a form of the [Strategy Pattern](http://en.wikipedia.org/wiki/Strategy_Pattern), an overview may be in order to elaborate on this assertion further.

&#160;

## What is Double Dispatch?

Technically, Double Dispatch refers to a technique used in the context of a polymorphic method call for mitigating the lack of [multimethod](http://en.wikipedia.org/wiki/Multimethods) support in programming languages.&#160; More simply, Double Dispatch is used to invoke an overloaded method where the parameters vary among an inheritance hierarchy.&#160; To explain fully, let&#8217;s start with a review of [polymorphism](http://en.wikipedia.org/wiki/Polymorphism_in_object-oriented_programming). 

&#160;

### Polymorphism

In the following example, a hierarchy of shapes are defined with each of the derived types overloading a base virtual `Draw()` method.&#160; Next, a console application is used to define a list of each of the shapes and iterate over each shape in the collection calling the `Draw()` method of each item in the list: 

<pre class="prettyprint">class Shape
    {
        public virtual void Draw()
        {
            Console.WriteLine("A shape is drawn.");
        }
    }

    class Polygon : Shape
    {
        public override void Draw()
        {
            Console.WriteLine("A polygon is drawn.");
        }
    }

    class Quadrilateral : Polygon
    {
        public override void Draw()
        {
            Console.WriteLine("A quadrilateral is drawn.");
        }
    }

    class Parallelogram : Quadrilateral
    {
        public override void Draw()
        {
            Console.WriteLine("A parallelogram is drawn.");
        }
    }

    class Rectangle : Parallelogram
    {
        public override void Draw()
        {
            Console.WriteLine("A rectangle is drawn.");
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            var shapes = new List&lt;Shape&gt;
                             {
                                 new Shape(),
                                 new Polygon(),
                                 new Quadrilateral(),
                                 new Parallelogram(),
                                 new Rectangle()
                             };

            foreach (Shape shape in shapes)
            {
                shape.Draw();
            }

            Console.ReadLine();
        }
    }</pre>

The following lines are printed to the console upon running the application:

<pre>A shape is drawn.
A polygon is drawn.
A quadrilateral is drawn.
A parallelogram is drawn.
A rectangle is drawn.</pre>

  
Note that the proper `Draw()` method is called for each item in the collection.&#160; In most object-oriented languages, this polymorphic behavior is achieved through the use of a [virtual table](http://en.wikipedia.org/wiki/Virtual_table) consulted at run-time to derive the proper offset address for an object&#8217;s method.&#160; This behavior is referred to as "[Dynamic Dispatch](http://en.wikipedia.org/wiki/Dynamic_dispatch)" or "Single Dispatch".&#160; So, how does this relate to Double Dispatch?&#160; To answer this question, let&#8217;s next review [method overloading](http://en.wikipedia.org/wiki/Function_overloading).

&#160;</p> 

### Method Overloading

In the following example, our `Shape` class is redefined to have two overloaded `Draw` methods: one with a parameter of type `Surface` and one with a parameter of type `EtchASketch`: 

<pre class="prettyprint">class Surface
    {
    }

    class EtchASketch : Surface
    {
    }

    class Shape
    {
        public void Draw(Surface surface)
        {
            Console.WriteLine("A shape is drawn on the surface with ink.");
        }

        public void Draw(EtchASketch etchASketch)
        {
            Console.WriteLine("The knobs are moved in attempt to draw the shape.");
        }
    }
  
    class Program
    {
        static void Main(string[] args)
        {
            var shape = new Shape();
            shape.Draw(new Surface());
            shape.Draw(new EtchASketch());

            Console.ReadLine();
        }
    }</pre>

When executed, the following lines are printed to the console: 

<pre>A shape is drawn on the surface with ink.
The knobs are moved in attempt to draw the shape.</pre>

  
Note that the parameter type determines which `Draw()` method is invoked.&#160; 

  
But what happens if we change the `Main()` method to the following?

<pre class="prettyprint">class Program
    {
        static void Main(string[] args)
        {
            var shape = new Shape();
            Surface surface = new Surface();
            Surface etchASketch = new EtchASketch();

            shape.Draw(surface);
            shape.Draw(etchASketch);

            Console.ReadLine();
        }
    }</pre>

Executing this produces the following:

<pre>A shape is drawn on the surface with ink.
A shape is drawn on the surface with ink.</pre>

  
What happened?&#160; The issue here is that the method to call was determined statically at compile time based upon the reference type, not at run-time based upon the object type.&#160; To resolve this issue, another technique is needed &#8230; Polymorphic Static Binding.

&#160;

### Polymorphic Static Binding

Polymorphic static binding is a technique where static method invocations are determined at run-time through the use of polymorphism.&#160; This can be demonstrated in our example by adding a new `Draw(Shape shape)` method to the `Surface` and `EtchASketch` types which call `shape.Draw()` with a reference to the current object: 

<pre class="prettyprint">class Surface
    {
        public virtual void Draw(Shape shape)
        {
            shape.Draw(this);
        }
    }

    class EtchASketch : Surface
    {
        public override void Draw(Shape shape)
        {
            shape.Draw(this);
        }
    }</pre>

To invoke the correct `Shape.Draw()` method, our console application needs to be modified to call the the method indirectly through a `Surface` reference:

<pre class="prettyprint">class Program
    {
        static void Main(string[] args)
        {
            var shape = new Shape();
            Surface surface = new Surface();
            Surface etchASketch = new EtchASketch();

            surface.Draw(shape);
            etchASketch.Draw(shape);

            Console.ReadLine();
        }
    }</pre>

Upon executing the application again, the following lines are now printed:

<pre>A shape is drawn on the surface with ink.
The knobs are moved in attempt to draw the shape.</pre>

  
This example achieves the desired result by effectively wrapping the static-dispatched method invocation (i.e. `Shape.Draw()`) within a virtual-dispatch method invocation (i.e. `Surface.Draw()` and `EtchASketch.Draw()`).&#160; This causes the static `Shape.Draw()` method invocation to be determined by which virtual `Surface.Draw()` method invocation is executed.

  
Although the above example now contains a method invocation using a reference to the current object as the method parameter (often seen with Double Dispatch), it should be noted that Double Dispatch has yet to be demonstrated.&#160; Thus far, only one level of virtual dispatching has been used.&#160; To demonstrate Double Dispatch, the techniques from both the polymorphism example and the polymorphic static binding example need to be combined as seen in the next section.

&#160;</p> 

### Double Dispatch

The following example contains a hierarchy of `Surface` types and a hierarchy of `Shape` types.&#160; Each `Shape` type contains an overloaded virtual `Draw()` method which contains the logic for how the shape is to be drawn on a particular surface.&#160; The example console application uses the polymorphic static binding technique to ensure the proper overload is called for each surface type: 

<pre class="prettyprint">class Surface
    {
        public virtual void Draw(Shape shape)
        {
            shape.Draw(this);
        }
    }

    class EtchASketch : Surface
    {
        public override void Draw(Shape shape)
        {
            shape.Draw(this);
        }
    }

    class Shape
    {
        public virtual void Draw(Surface surface)
        {
            Console.WriteLine("A shape is drawn on the surface with ink.");
        }

        public virtual void Draw(EtchASketch etchASketch)
        {
            Console.WriteLine("The knobs are moved in attempt to draw the shape.");
        }
    }

    class Polygon : Shape
    {
        public override void Draw(Surface surface)
        {
            Console.WriteLine("A polygon is drawn on the surface with ink.");
        }

        public override void Draw(EtchASketch etchASketch)
        {
            Console.WriteLine("The knobs are moved in attempt to draw the polygon.");
        }
    }

    class Quadrilateral : Polygon
    {
        public override void Draw(Surface surface)
        {
            Console.WriteLine("A quadrilateral is drawn on the surface with ink.");
        }

        public override void Draw(EtchASketch etchASketch)
        {
            Console.WriteLine("The knobs are moved in attempt to draw the quadrilateral.");
        }
    }

    class Parallelogram : Quadrilateral
    {
        public override void Draw(Surface surface)
        {
            Console.WriteLine("A parallelogram is drawn on the surface with ink.");
        }

        public override void Draw(EtchASketch etchASketch)
        {
            Console.WriteLine("The knobs are moved in attempt to draw the parallelogram.");
        }
    }

     class Rectangle : Parallelogram
    {
        public override void Draw(Surface surface)
        {
            Console.WriteLine("A rectangle is drawn on the surface with ink.");
        }

        public override void Draw(EtchASketch etchASketch)
        {
            Console.WriteLine("The knobs are moved in attempt to draw the rectangle.");
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            Surface surface = new Surface();
            Surface etchASketch = new EtchASketch();

            var shapes = new List&lt;Shape&gt;
                             {
                                 new Shape(),
                                 new Polygon(),
                                 new Quadrilateral(),
                                 new Parallelogram(),
                                 new Rectangle()
                             };

            foreach (Shape shape in shapes)
            {
                surface.Draw(shape);
                etchASketch.Draw(shape);
            }

            Console.ReadLine();
        }
    }</pre>

Executing this example produces the following:

<pre>A shape is drawn on the surface with ink.
The knobs are moved in attempt to draw the shape.
A polygon is drawn on the surface with ink.
The knobs are moved in attempt to draw the polygon.
A quadrilateral is drawn on the surface with ink.
The knobs are moved in attempt to draw the quadrilateral.
A parallelogram is drawn on the surface with ink.
The knobs are moved in attempt to draw the parallelogram.
A rectangle is drawn on the surface with ink.
The knobs are moved in attempt to draw the rectangle.</pre>

  
In the above example, virtual dispatch occurs twice for each call to one of the `Surface` references: Once when the `Surface.Draw()` virtual method is called and again when either calls the `Shape.Draw()` overloaded virtual method.&#160; Note again that while the second virtual dispatch is based on the type of `Shape` instance, the overloaded method called is still determined statically based upon the reference type.

&#160;

## Consequences

So, what&#8217;s wrong with Double Dispatch?&#160; The problem isn&#8217;t so much in the technique, but what design choices might be leading to reliance upon the technique.&#160; Consider for instance the hierarchy of shape types in our Double Dispatch example.&#160; What happens if we want to add a new surface?&#160; In this case, each of the shape types will need to be modified to add knowledge of the new Surface type.&#160; This violates the [Open/Closed Principle](http://en.wikipedia.org/wiki/Open_Closed_Principle), and in this case in a particularly egregious way (i.e. It&#8217;s violation is multiplied by the number of shape types we have).&#160;&#160; Additionally, it violates the [Single Responsibility Principle](http://en.wikipedia.org/wiki/Single_responsibility_principle).&#160; Changes to how shapes are drawn on a particular surface are likely to differ from surface to surface, thereby leading our shape objects to change for different reasons.

The presence of Double Dispatch generally means that each type in a hierarchy has special handling code within another hierarchy of types.&#160; This approach to representing variant behavior leads to code that is less resilient to future changes as well as being more difficult to extend.

&#160;

## The Matrix: Reloaded

Let&#8217;s take another stab at modeling our shape/surface intersection matrix.&#160; In the following example, several new concepts have been introduced to facilitate decoupling: line segments, points, and brushes: 

<pre class="prettyprint">interface ISurface
    {
        void Add(LineSegment segment);
    }

    class Paper : ISurface
    {
        readonly IList&lt;LineSegment&gt; _segments = new List&lt;LineSegment&gt;();

        public void Add(LineSegment segment)
        {
            _segments.Add(segment);
        }
    }

    class EtchASketch : ISurface
    {
        readonly IList&lt;LineSegment&gt; _segments = new List&lt;LineSegment&gt;();

        public void Add(LineSegment segment)
        {
            _segments.Add(segment);
        }
    }

    class Point
    {
        public Point(int x, int y)
        {
            X = x;
            Y = y;
        }

        public int X { get; set; }
        public int Y { get; set; }
    }

    class LineSegment
    {
        public LineSegment(Point point1, Point point2)
        {
            Point1 = point1;
            Point2 = point2;
        }

        public Point Point1 { get; set; }
        public Point Point2 { get; set; }
    }

    interface IShape
    {
        IList&lt;LineSegment&gt; GetLineSegments();
    }

    class Polygon : IShape
    {
        public IList&lt;LineSegment&gt; GetLineSegments()
        {
            var segments = new List&lt;LineSegment&gt;();
            segments.Add(new LineSegment(new Point(0, 0), new Point(0, 9)));
            segments.Add(new LineSegment(new Point(0, 9), new Point(3, 6)));
            segments.Add(new LineSegment(new Point(3, 6), new Point(6, 9)));
            segments.Add(new LineSegment(new Point(6, 0), new Point(6, 9)));
            segments.Add(new LineSegment(new Point(6, 0), new Point(3, 3)));
            segments.Add(new LineSegment(new Point(3, 3), new Point(0, 0)));

            return segments;
        }
    }

    class Quadrilateral : IShape
    {
        public IList&lt;LineSegment&gt; GetLineSegments()
        {
            var segments = new List&lt;LineSegment&gt;();
            segments.Add(new LineSegment(new Point(0, 0), new Point(0, 9)));
            segments.Add(new LineSegment(new Point(0, 9), new Point(4, 5)));
            segments.Add(new LineSegment(new Point(4, 0), new Point(0, 4)));
            segments.Add(new LineSegment(new Point(4, 0), new Point(0, 0)));

            return segments;
        }
    }

    class Parallelogram : IShape
    {
        public IList&lt;LineSegment&gt; GetLineSegments()
        {
            var segments = new List&lt;LineSegment&gt;();
            segments.Add(new LineSegment(new Point(0, 4), new Point(0, 9)));
            segments.Add(new LineSegment(new Point(0, 9), new Point(4, 5)));
            segments.Add(new LineSegment(new Point(4, 0), new Point(4, 5)));
            segments.Add(new LineSegment(new Point(4, 0), new Point(0, 4)));

            return segments;
        }
    }

    class Rectangle : IShape
    {
        public IList&lt;LineSegment&gt; GetLineSegments()
        {
            var segments = new List&lt;LineSegment&gt;();
            segments.Add(new LineSegment(new Point(0, 0), new Point(0, 9)));
            segments.Add(new LineSegment(new Point(0, 9), new Point(9, 4)));
            segments.Add(new LineSegment(new Point(4, 0), new Point(9, 4)));
            segments.Add(new LineSegment(new Point(4, 0), new Point(0, 0)));

            return segments;
        }
    }

    class Program
    {
        static readonly IDictionary&lt;Type, IBrush&gt; brushDictionary = new Dictionary&lt;Type, IBrush&gt;();

        static Program()
        {
            brushDictionary.Add(typeof (Paper), new Pencil());
            brushDictionary.Add(typeof (EtchASketch), new EtchASketchKnobs());
        }

        static void Main(string[] args)
        {
            var surfaces = new List&lt;ISurface&gt;
                               {
                                   new Paper(),
                                   new EtchASketch()
                               };

            var shapes = new List&lt;IShape&gt;
                             {
                                 new Polygon(),
                                 new Quadrilateral(),
                                 new Parallelogram(),
                                 new Rectangle()
                             };

            foreach (ISurface surface in surfaces)
                foreach (IShape shape in shapes)
                {
                    Console.WriteLine(string.Format("Drawing a {0} on the {1} ...", shape.GetType().Name,
                                                    surface.GetType().Name));
                    brushDictionary[surface.GetType()].Draw(surface, shape.GetLineSegments());
                    Console.WriteLine(Environment.NewLine);
                }

            Console.ReadLine();
        }
    }

    interface IBrush
    {
        void Draw(ISurface surface, IList&lt;LineSegment&gt; segments);
    }

    class Pencil : IBrush
    {
        public void Draw(ISurface surface, IList&lt;LineSegment&gt; segments)
        {
            foreach (LineSegment segment in segments)
            {
                Console.WriteLine(string.Format("Pencil used to sketch line segment {0},{1} to {2},{3}.",
                                                segment.Point1.X, segment.Point1.Y,
                                                segment.Point2.X, segment.Point2.Y));
            }
        }
    }

    class EtchASketchKnobs : IBrush
    {
        public void Draw(ISurface surface, IList&lt;LineSegment&gt; segments)
        {
            foreach (LineSegment segment in segments)
            {
                Console.WriteLine(string.Format("Knobs used to produce line segment {0},{1} to {2},{3}.",
                                                segment.Point1.X, segment.Point1.Y,
                                                segment.Point2.X, segment.Point2.Y));
            }
        }
    }</pre>

Executing this example produces the following:

<pre>Drawing a Polygon on the Paper ...
Pencil used to sketch line segment 0,0 to 0,9.
Pencil used to sketch line segment 0,9 to 3,6.
Pencil used to sketch line segment 3,6 to 6,9.
Pencil used to sketch line segment 6,0 to 6,9.
Pencil used to sketch line segment 6,0 to 3,3.
Pencil used to sketch line segment 3,3 to 0,0.


Drawing a Quadrilateral on the Paper ...
Pencil used to sketch line segment 0,0 to 0,9.
Pencil used to sketch line segment 0,9 to 4,5.
Pencil used to sketch line segment 4,0 to 0,4.
Pencil used to sketch line segment 4,0 to 0,0.


Drawing a Parallelogram on the Paper ...
Pencil used to sketch line segment 0,4 to 0,9.
Pencil used to sketch line segment 0,9 to 4,5.
Pencil used to sketch line segment 4,0 to 4,5.
Pencil used to sketch line segment 4,0 to 0,4.


Drawing a Rectangle on the Paper ...
Pencil used to sketch line segment 0,0 to 0,9.
Pencil used to sketch line segment 0,9 to 9,4.
Pencil used to sketch line segment 4,0 to 9,4.
Pencil used to sketch line segment 4,0 to 0,0.


Drawing a Polygon on the EtchASketch ...
Knobs used to produce line segment 0,0 to 0,9.
Knobs used to produce line segment 0,9 to 3,6.
Knobs used to produce line segment 3,6 to 6,9.
Knobs used to produce line segment 6,0 to 6,9.
Knobs used to produce line segment 6,0 to 3,3.
Knobs used to produce line segment 3,3 to 0,0.


Drawing a Quadrilateral on the EtchASketch ...
Knobs used to produce line segment 0,0 to 0,9.
Knobs used to produce line segment 0,9 to 4,5.
Knobs used to produce line segment 4,0 to 0,4.
Knobs used to produce line segment 4,0 to 0,0.


Drawing a Parallelogram on the EtchASketch ...
Knobs used to produce line segment 0,4 to 0,9.
Knobs used to produce line segment 0,9 to 4,5.
Knobs used to produce line segment 4,0 to 4,5.
Knobs used to produce line segment 4,0 to 0,4.


Drawing a Rectangle on the EtchASketch ...
Knobs used to produce line segment 0,0 to 0,9.
Knobs used to produce line segment 0,9 to 9,4.
Knobs used to produce line segment 4,0 to 9,4.
Knobs used to produce line segment 4,0 to 0,0.</pre>

  
By changing the `Shape` objects to be defined in terms of line segments, knowledge is removed from the shape concerning how to draw itself on any particular surface.&#160; Additionally, the `Surface` type now encapsulates a collection of line segments to simulate the lines being drawn onto the surface.&#160; To handle drawing the line segments onto the surfaces, we&#8217;ve introduced a `Brush` type which "draws" the line segments onto a surface in its own peculiar way.&#160; To configure which brushes are to be used with which surface, the console application defines a dictionary matching surfaces to brushes.

  
In contrast to the Double Dispatch example, none of the existing types need to be modified to add new surfaces, shapes, or brushes.

&#160;

## Conclusion

Since Double Dispatch is a technique for calling virtual overloaded methods based upon parameter types which exist within an inheritance hierarchy, its use may be a symptom that the Open/Closed and/or Single responsibility principles are being violated, or that responsibilities may otherwise be misaligned.&#160; This is not to say that every case of Double Dispatch means something is amiss, but only that its use should be a flag to reconsider your design in light of future maintenance needs.
