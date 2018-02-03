---
wordpress_id: 272
title: A new breed of magic strings in ASP.NET MVC
date: 2009-01-14T12:34:20+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/01/14/a-new-breed-of-magic-strings-in-asp-net-mvc.aspx
dsq_thread_id:
  - "264716034"
  - "264716034"
categories:
  - ASPNETMVC
---
One of the common patterns in Ruby on Rails is the use of hashes in place of large parameter lists.&#160; Instead of hashes, which don’t exist in C#, ASP.NET MVC uses anonymous types for quite a few HTML generators on the view side.&#160; For example, we might want to generate a strongly-typed URL for a specific controller action:

<pre>Url.Action&lt;<span style="color: #2b91af">ProductsController</span>&gt;(x =&gt; x.Edit(<span style="color: blue">null</span>), <span style="color: blue">new </span>{ productId = prodId })</pre>

[](http://11011.net/software/vspaste)

Now, this is an example where our controller action uses some model binding magic to bind Guids to an actual Product.&#160; We need to pass in route values to the helper method, which will eventually get translated into a RouteValueDictionary.

All special MVC terms aside, this is a trick used by the MVC team to simulate hashes.&#160; Since the dictionary initializer syntax is quite verbose, with lots of angly-bracket cruft, anonymous types provide a similar effect to hashes.&#160; However, don’t let the magic fool you.&#160; **Anonymous types used to create dictionaries are still dictionaries.**

See that “productId” property in the anonymous object above?&#160; **That’s a [magic string](http://en.wikipedia.org/wiki/Magic_string_(programming))**.&#160; It’s used to match up to the controller parameter name.&#160; Other anonymous types are used to add HTML attributes, supply route information, and others.&#160; It’s subtle, as it doesn’t _look_ like a string, it looks like an object.&#160; There aren’t any quotes, it just looks like I’m creating an object.

However, it suffers from the same issues that magic strings have:

  1. They don’t react well to refactoring 
  2. It’s rampant, pervasive duplication
  3. They’re easily broken with mispelling 

If I change the name of the parameter in the Edit method, all code expecting the parameter name to be something specific will break.&#160; This wouldn’t be so bad if I had to change just one location, but I need to fix _all_ places that use that parameter (likely with a Replace All command).&#160; I understand the desire to separate views from controllers, but I don’t want to go backwards and now have brittle views.

Luckily, there are some easy ways to solve this problem.

### Option #1 – Just use the dictionary

One quick way to not use magical anonymous types is to just use the dictionary.&#160; It’s a little more verbose, but at least we can apply the “Once and only once” rule to our dictionary keys – and store them in a constant or static field.&#160; We still have use the dictionary initializer syntax:

<pre>Url.Action&lt;<span style="color: #2b91af">ProductsController</span>&gt;(x =&gt; x.Edit(<span style="color: blue">null</span>), <span style="color: blue">new </span><span style="color: #2b91af">RouteValueDictionary </span>{ { <span style="color: #2b91af">ProductsController</span>.ProductId, prodId } })</pre>

[](http://11011.net/software/vspaste)

The ProductId field is just a constant we declared on our ProductsController.&#160; But at least it’s strongly-typed, refactoring-friendly and simple.&#160; It is quite a bit bigger than our original method, however.

### Option #2 – Strongly-typed parameter objects

Instead of an anonymous object, just use a real object.&#160; The object represents the parameters of the action method:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">EditProductParams
</span>{
    <span style="color: blue">public </span><span style="color: #2b91af">Guid </span>product { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}</pre>

[](http://11011.net/software/vspaste)

The name of this property matches the name of our parameter in the controller.&#160; In our ASPX, we’ll use this class instead of an anonymous one:

<pre>Url.Action&lt;<span style="color: #2b91af">ProductsController</span>&gt;(x =&gt; x.Edit(<span style="color: blue">null</span>), <span style="color: blue">new </span><span style="color: #2b91af">EditProductParams </span>{ product = prodId })</pre>

[](http://11011.net/software/vspaste)

We solve the “Once and only once” problem…almost.&#160; The parameter name is still duplicated on the controller action method and this new class.&#160; I might define this class beside the controller to remind myself, but the parameter still shows up twice.

In other applications of the anonymous object, this option really wouldn’t work.&#160; For things like Html.ActionLink, where an anonymous type is used to populate HTML attributes, the mere _presence_ of these properties may cause some strange things to happen.&#160; It works, but only partially.&#160; If the designers of MVC wanted to create parameter objects, they probably would have.

### Option #3 – Use Builders

We can use a Builder for the entire HTML, or just the RouteValueDictionary.&#160; Either way, we use a fluent builder to incrementally build the HTML or parameters we want:

<pre><span style="background: #ffee62">&lt;%</span><span style="color: blue">= </span>Url.Action&lt;<span style="color: #2b91af">ProductsController</span>&gt;(x =&gt; x.Edit(<span style="color: blue">null</span>, <span style="color: blue">null</span>), <span style="color: #2b91af">Params</span>.Product(product).Customer(customer)) <span style="background: #ffee62">%&gt;</span></pre>

[](http://11011.net/software/vspaste)

Instead of hard-coded strings, we use a builder to chain together all the information needed to build the correct route values.&#160; Our builder encapsulates all of the parameter logic in one place, so that we can chain together whatever parameters it needs.&#160; It starts with the chain initiator:

<pre><span style="color: blue">public static class </span><span style="color: #2b91af">Params
</span>{
    <span style="color: blue">public static </span><span style="color: #2b91af">ParamBuilder </span>Product(<span style="color: #2b91af">Product </span>product)
    {
        <span style="color: blue">var </span>builder = <span style="color: blue">new </span><span style="color: #2b91af">ParamBuilder</span>();

        <span style="color: blue">return </span>builder.Product(product);
    }

    <span style="color: blue">public static </span><span style="color: #2b91af">ParamBuilder </span>Customer(<span style="color: #2b91af">Customer </span>customer)
    {
        <span style="color: blue">var </span>builder = <span style="color: blue">new </span><span style="color: #2b91af">ParamBuilder</span>();

        <span style="color: blue">return </span>builder.Customer(customer);
    }
}</pre>

[](http://11011.net/software/vspaste)

The actual _building_ of the parameters is in our ParamBuilder class:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">ParamBuilder
</span>{
    <span style="color: blue">private </span><span style="color: #2b91af">Product </span>_product;
    <span style="color: blue">private </span><span style="color: #2b91af">Customer </span>_customer;

    <span style="color: blue">public </span><span style="color: #2b91af">ParamBuilder </span>Product(<span style="color: #2b91af">Product </span>product)
    {
        _product = product;
        <span style="color: blue">return this</span>;
    }

    <span style="color: blue">public </span><span style="color: #2b91af">ParamBuilder </span>Customer(<span style="color: #2b91af">Customer </span>customer)
    {
        _customer = customer;
        <span style="color: blue">return this</span>;
    }</pre>

[](http://11011.net/software/vspaste)

Because each new parameter method returns “this”, we can chain together the same ParamBuilder instance, allowing the developer to build whatever common parameters needed.&#160; Finally, we need to make sure our ParamBuilder can be converted to a RouteValueCollection.&#160; We do this by supplying an implicit conversion operator:

<pre><span style="color: blue">public static implicit operator </span><span style="color: #2b91af">RouteValueDictionary</span>(<span style="color: #2b91af">ParamBuilder </span>paramBuilder)
{
    <span style="color: blue">var </span>values = <span style="color: blue">new </span><span style="color: #2b91af">Dictionary</span>&lt;<span style="color: blue">string</span>, <span style="color: blue">object</span>&gt;();

    <span style="color: blue">if </span>(paramBuilder._product != <span style="color: blue">null</span>)
    {
        values.Add(<span style="color: #a31515">"p"</span>, paramBuilder._product.Id);
    }

    <span style="color: blue">if </span>(paramBuilder._product != <span style="color: blue">null</span>)
    {
        values.Add(<span style="color: #a31515">"c"</span>, paramBuilder._customer.Id);
    }

    <span style="color: blue">return new </span><span style="color: #2b91af">RouteValueDictionary</span>(values);
}</pre>

[](http://11011.net/software/vspaste)

The compiler will automatically call this implicit operator, so we don’t need any “BuildDictionary” or other creation method, the compiler does this for us.&#160; This is just an example of a builder method; the possibilities are endless for a design of “something that creates a dictionary”.

Each of these approaches has their plusses and minuses, but all do the trick of eliminating that **new breed of magic strings in ASP.NET MVC: the anonymous type**.