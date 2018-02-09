---
wordpress_id: 274
title: 'AutoMapper: the Object-Object Mapper'
date: 2009-01-23T02:33:37+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/01/22/automapper-the-object-object-mapper.aspx
dsq_thread_id:
  - "264722682"
categories:
  - AutoMapper
redirect_from: "/blogs/jimmy_bogard/archive/2009/01/22/automapper-the-object-object-mapper.aspx/"
---
In Domain-Driven Design, creating a rich domain model in code is essential for capturing the richness and complexity of the real-world domain.&#160; These domain models, designed as [POCOs](http://en.wikipedia.org/wiki/Plain_Old_CLR_Object), are not very portable, nor should they be.&#160; Domain models live inside the domain layer, not to be exposed to the outside world.&#160; Very often, we don’t want to expose these models to other layers of our application.&#160; To mitigate this issue, we often create various sorts of other models, like DTOs, ViewModels, messages, and so on.&#160; Two things were in common with these objects:

  * Mapping code is tedious to write
  * Mapping code is tedious to test

In fact, some of the most boring code in the world to write is mapping between two objects, as it often looked something like this:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">OrderToOrderViewModelMapper
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">OrderViewModel </span>Map(<span style="color: #2b91af">Order </span>order)
    {
        <span style="color: blue">return new </span><span style="color: #2b91af">OrderViewModel
            </span>{
                CustomerFullName = order.Customer.GetFullName(),
                Total = order.GetTotal(),
                LineItems = order.GetLineItems()
                    .Select(x =&gt; <span style="color: blue">new </span><span style="color: #2b91af">OrderLineItemViewModel
                        </span>{
                            Price = x.Price,
                            Quantity = x.Quantity,
                            Total = x.GetTotal(),
                            ProductName = x.Product.Name
                        })
                    .ToArray()
            };
    }
}</pre>

[](http://11011.net/software/vspaste)

That’s quite a bit of code to write, test and maintain, especially when all I’m trying to do here is carve a slice out of my rich domain model for consumption for something else, whether it’s my MVC view, JSON, a reporting application, and so on.&#160; I hated writing this code over and over again, so instead our team brainstormed and decided to create an auto-mapper.

### Enter the AutoMapper

If you look closely at the mapping logic above, the design of my destination type looks awfully similar to our domain model, just flattened out.&#160; Let’s do that mapping code with AutoMapper:

<pre><span style="color: blue">public static void </span>Configure()
{
    <span style="color: #2b91af">Mapper</span>.CreateMap&lt;<span style="color: #2b91af">Order</span>, <span style="color: #2b91af">OrderViewModel</span>&gt;();
    <span style="color: #2b91af">Mapper</span>.CreateMap&lt;<span style="color: #2b91af">OrderLineItem</span>, <span style="color: #2b91af">OrderLineItemViewModel</span>&gt;();
}</pre>

[](http://11011.net/software/vspaste)

Whew, that was tough!&#160; I create two maps, for each source/destination pair (remember, I had to map the OrderLineItem to the child line items as well).&#160; Why don’t we actually use the Mapper to execute a map:

<pre><span style="color: blue">var </span>viewModel = <span style="color: #2b91af">Mapper</span>.Map&lt;<span style="color: #2b91af">Order</span>, <span style="color: #2b91af">OrderViewModel</span>&gt;(order);</pre>

[](http://11011.net/software/vspaste)

Sweet fancy Moses, I’m out of breath.&#160; But I lost my tests around the mapping code.&#160; How do I make sure my configuration is valid?&#160; From a feature I lifted from StructureMap:

<pre><span style="color: #2b91af">Mapper</span>.AssertConfigurationIsValid();</pre>

[](http://11011.net/software/vspaste)

This will throw an AutoMapperConfigurationException (with details on the offending source type, destination type, and offending property(s).&#160; AutoMapper enforces that for each type map (source/destination pair), **all of the properties on the destination type are matched up with something on the source type**.&#160; Since AutoMapper matches type members up by name, you’re really looking at misspelled/missing members.

You do lose a little refactoring friendliness, but you’ll get the one-line descriptive test to let you know where you went awry.

### AutoMapper conventions

Since AutoMapper flattens, it will look for:

  * Matching property names
  * Nested property names (Product.Name maps to ProductName, by assuming a PascalCase naming convention)
  * Methods starting with the word “Get”, so GetTotal() maps to Total
  * Any existing type map already configured

Basically, if you removed all the “dots” and “Gets”, AutoMapper will match property names.&#160; Right now, AutoMapper does not fail on mismatched types, but for some other reasons.

### AutoMapper feature rundown

AutoMapper supports:

  * Mapping of simple types
  * Mapping to arrays from any IEnumerable source
  * Custom member resolution, for that 1% case you have to do some extra mapping work
  * Polymorphic array mapping
  * Custom formatting for mapping from any type to a string
  * Global formatters
  * Null substitutes for formatting (i.e. a missing Product formats to “n/a”)
  * Profiles, for separating different sets of configurations (JSON vs. ViewModel vs. EditModel etc)

Other features include:

  * Convention of no null destination objects, ever.
  * No null destination array properties, ever. 
  * A fluent configuration, with both a method chaining syntax (through Mapper) and object scoping (through a Profile)

What’s missing:

  * Auto-registration (mainly because you then can’t test it easily)
  * Support for conversion operators, as these are compile-time, not run-time in C#.&#160; I can do it, but only by reflection and looking for crazy method names
  * Documentation

There are specs, mostly organized by feature area in the source code.&#160; AutoMapper was built completely with TDD, so there aren’t any features that don’t have a test (and aren’t used in a production system).&#160; You can find the latest release at the CodePlex site:

[http://www.codeplex.com/AutoMapper](http://www.codeplex.com/AutoMapper "http://www.codeplex.com/AutoMapper")

The source is hosted on my favorite free SVN host, Google Code:

[http://code.google.com/p/automapperhome/](http://code.google.com/p/automapperhome/ "http://code.google.com/p/automapperhome/")

Enjoy!