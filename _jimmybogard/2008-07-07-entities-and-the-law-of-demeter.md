---
wordpress_id: 202
title: Entities and the Law of Demeter
date: 2008-07-07T11:51:56+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/07/07/entities-and-the-law-of-demeter.aspx
dsq_thread_id:
  - "264715834"
categories:
  - DomainDrivenDesign
  - Refactoring
redirect_from: "/blogs/jimmy_bogard/archive/2008/07/07/entities-and-the-law-of-demeter.aspx/"
---
The [Law of Demeter](http://en.wikipedia.org/wiki/Law_of_Demeter), and its corresponding code smell, [Inappropriate Intimacy](http://c2.com/cgi/wiki?InappropriateIntimacy), are some of the best bang-for-your-buck code smells that you can address.&nbsp; The basic idea behind each of these concepts is code related to an object should probably be inside that object.&nbsp; It&#8217;s also known as the Principle of Least Knowledge, and I&#8217;ve found it very helpful in creating objects with rich behavior.

It&#8217;s not always something I catch immediately, but I tend to notice later.&nbsp; For example, I noticed this code in one of my code behinds:

<pre><span style="color: blue">protected decimal </span>GetTotal()
{
    <span style="color: blue">return </span>_cart
             .GetItems()
             .Sum(item =&gt; item.Price * item.Quantity);
}
</pre>

[](http://11011.net/software/vspaste)

This method was then called by markup in the template file to display the current total in the cart.

Now, it seems rather obvious that something like the cart&#8217;s total should belong on the ShoppingCart object itself.&nbsp; In some situations, there might not even be a ShoppingCart class, only a generic list of ShoppingCartItems.&nbsp; In that case, the best thing to do would be to create the ShoppingCart class, if nothing else than to become a magnet for cart behavior.

With the [Move Method](http://www.refactoring.com/catalog/moveMethod.html) refactoring, I moved this behavior to the ShoppingCart class:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">ShoppingCart
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">ShoppingCartItem</span>&gt; _items;

    <span style="color: blue">public </span>ShoppingCart()
    {
        _items = <span style="color: blue">new </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">ShoppingCartItem</span>&gt;();
    }

    <span style="color: blue">public </span><span style="color: #2b91af">ShoppingCartItem</span>[] GetItems()
    {
        <span style="color: blue">return </span>_items.ToArray();
    }

    <span style="color: blue">public void </span>AddItem(<span style="color: #2b91af">Product </span>product, <span style="color: blue">int </span>quantity)
    {
        <span style="color: blue">var </span>item = <span style="color: blue">new </span><span style="color: #2b91af">ShoppingCartItem</span>(product);
        item.Quantity = quantity;
        _items.Add(item);
    }

    <span style="color: blue">public decimal </span>GetTotal()
    {
        <span style="color: blue">return </span>_items.Sum(item =&gt; item.Price * item.Quantity);
    }

}
</pre>

[](http://11011.net/software/vspaste)

Again, it seems like more total behavior is in the wrong place.&nbsp; Why should ShoppingCart have to perform the price/quantity calculation?&nbsp; Let&#8217;s move this to the ShoppingCartItem class:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">ShoppingCartItem
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">Product </span>_product;

    <span style="color: blue">public </span>ShoppingCartItem(<span style="color: #2b91af">Product </span>product)
    {
        _product = product;
    }

    <span style="color: blue">public int </span>Quantity { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }

    <span style="color: blue">public decimal </span>Price
    {
        <span style="color: blue">get </span>{ <span style="color: blue">return </span>_product.Price; }
    }

    <span style="color: blue">public </span><span style="color: #2b91af">Product </span>Product
    {
        <span style="color: blue">get </span>{ <span style="color: blue">return </span>_product; }
    }

    <span style="color: blue">public decimal </span>GetItemTotal()
    {
        <span style="color: blue">return </span>Quantity * Price;
    }
}
</pre>

[](http://11011.net/software/vspaste)

[](http://11011.net/software/vspaste)I also noticed several other places that cared way too much about the Product class.&nbsp; Here&#8217;s an example I found in the code-behind:

<pre><span style="color: blue">protected decimal </span>CalculateMargin(<span style="color: #2b91af">ShoppingCartItem </span>item)
{
    <span style="color: blue">return </span>item.Product.Price / item.Product.Cost;
}
</pre>

[](http://11011.net/software/vspaste)

Again, this is probably obvious to a lot of people (except me).&nbsp; This many dots poking into the ShoppingCartItem means the code behind class cares much too deeply about the inner workings of the ShoppingCartItem.&nbsp; Something like a margin seems like a fundamental concept of a Product, so let&#8217;s just move it there:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Product
</span>{
    <span style="color: blue">public string </span>Name { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public decimal </span>Price { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public decimal </span>Cost { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }

    <span style="color: blue">public decimal </span>CalculateMargin()
    {
        <span style="color: blue">return </span>Cost == 0 ? 0m : Price / Cost;
    }
}
</pre>

[](http://11011.net/software/vspaste)

I would also create a delegating method on ShoppingCartItem, so callers wouldn&#8217;t need to poke around the insides of Product to find what they needed.&nbsp; I find it best to expose exactly what&#8217;s needed on the container class, creating an explicit contract with the callers and telling them exactly what they should care about.

### 

### The behavior is out there

In many legacy code applications, I find lots of examples of [anemic domain models](http://martinfowler.com/bliki/AnemicDomainModel.html), where the &#8220;business objects&#8221; have zero behavior and lots of properties.&nbsp; Essentially, they just become containers of data.&nbsp; One step above DataSets, but that&#8217;s it.

Lots of duplication exists around these business objects, where I find the same methods and snippets poking around the business objects, getting the information they need.&nbsp; These helper methods often have nothing to do with the class they&#8217;re in, as we saw with the CalculateMargin method.&nbsp; They do something related to some other class, but for whatever reason, don&#8217;t exist on that class.

These data container classes don&#8217;t have any behavior on them, but their behavior is out there somewhere, scattered among the rest of the application.&nbsp; Moving behavior concerning a type actually to that type creates very cohesive domain models.&nbsp; Centralizing data _and_ behavior into a single type creates powerful domain models and a much richer client experience.