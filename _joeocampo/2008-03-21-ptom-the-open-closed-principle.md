---
wordpress_id: 108
title: 'PTOM: The Open Closed Principle'
date: 2008-03-21T23:47:50+00:00
author: Joe Ocampo
layout: post
wordpress_guid: /blogs/joe_ocampo/archive/2008/03/21/ptom-the-open-closed-principle.aspx
dsq_thread_id:
  - "262088470"
categories:
  - PTOM
---
The open closed principle is one of the oldest principles of Object Oriented Design. I won’t bore you with the history since you can find countless articles out on the net. But if you want a really comprehensive read please checkout Robert Martin’s excellent write up on the subject. 

The open closed principle can be summoned up in the following statement.

> open/closed principle states &#8220;software entities (classes, modules, functions, etc.) should be open for extension, but closed for modification&#8221;;[1] that is, such an entity can allow its behavior to be modified without altering its source code.

Sounds easy enough but many developers seem to miss the mark on actually implementing this simple extensible approach. I don’t think it is a matter of skill set as much as I feel that they have never been taught how to approach applying OCP to class design. 

## A case study in OCP ignorance

_Scenario: We need a way to filter products based off the color of the product._ 

All entities in a software development ecosystem behave a certain behavior that is dependent upon a governed context. In the scenario above you realize that you are going to need a Filter class that accepts a color and then filters all the products that have adhere to that color. 

The filter classes’ responsibility is to filter products (its job) based off the action of filtering by color (its behavior). So your goal is to write a class that will always be able to filter products. (Work with me on this I am trying to get you into a mindset because that is all OCP truly is at its heart.) 

To make this easier I like to tell developers to write the fill in the following template. 

&nbsp; 

_The {class} is responsible for {its job} by {action/behavior}_ 

The **_ProductFilter_** is responsible for **_filtering products_** by **_color_** 

&nbsp; 

Now let’s write our simple class to do this: 

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> ProductFilter
{
    <span style="color: #0000ff">public</span> IEnumerable&lt;Product&gt; ByColor(IList&lt;Product&gt; products, ProductColor productColor)
    {
        <span style="color: #0000ff">foreach</span> (var product <span style="color: #0000ff">in</span> products)
        {
            <span style="color: #0000ff">if</span> (product.Color == productColor)
                <span style="color: #0000ff">yield</span> <span style="color: #0000ff">return</span> product;
        }
    }
}</pre>
</div>

As you can see this pretty much does the job of filtering a product based off of color. Pretty simple but imagine if you had the following typical conversation with one of your users.

&nbsp;

> User: “We need to also be able to filter by size.”
> 
> Developer: “Just size alone or color and size? “
> 
> User: “Umm probably both.”
> 
> Developer: “Great!”

So let’s use our OCP scenario template again.

The **_ProductFilter_** is responsible for **_filtering products_** by **_color_**

The **_ProductFilter_** is responsible for **_filtering products_** by **_size_**

The **_ProductFilter_** is responsible for **_filtering products_** by **_color and size_**

Now the code:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> ProductFilter
{
    <span style="color: #0000ff">public</span> IEnumerable&lt;Product&gt; ByColor(IList&lt;Product&gt; products, ProductColor productColor)
    {
        <span style="color: #0000ff">foreach</span> (var product <span style="color: #0000ff">in</span> products)
        {
            <span style="color: #0000ff">if</span> (product.Color == productColor)
                <span style="color: #0000ff">yield</span> <span style="color: #0000ff">return</span> product;
        }
    }

    <span style="color: #0000ff">public</span> IEnumerable&lt;Product&gt; ByColorAndSize(IList&lt;Product&gt; products, 
                                                ProductColor productColor, 
                                                ProductSize productSize)
    {
        <span style="color: #0000ff">foreach</span> (var product <span style="color: #0000ff">in</span> products)
        {
            <span style="color: #0000ff">if</span> ((product.Color == productColor) && 
                (product.Size == productSize))
                <span style="color: #0000ff">yield</span> <span style="color: #0000ff">return</span> product;
        }
    }

    <span style="color: #0000ff">public</span> IEnumerable&lt;Product&gt; BySize(IList&lt;Product&gt; products,
                                        ProductSize productSize)
    {
        <span style="color: #0000ff">foreach</span> (var product <span style="color: #0000ff">in</span> products)
        {
            <span style="color: #0000ff">if</span> ((product.Size == productSize))
                <span style="color: #0000ff">yield</span> <span style="color: #0000ff">return</span> product;
        }
    }
}</pre>
</div>

This is great but this implementation is violating OCP. 

## Where&#8217;d we go wrong?

Let’s revisit again what Robert Martin has to say about OCP.

Robert Martin says modules that adhere to Open-Closed Principle have 2 primary attributes:

> 1. &#8220;Open For Extension&#8221; &#8211; It is possible to extend the behavior of the module as the requirements of the application change (i.e. change the behavior of the module).
> 
> 2. &#8220;Closed For Modification&#8221; &#8211; Extending the behavior of the module does not result in the changing of the source code or binary code of the module itself.

Let’s ask the following question to insure we **ARE** violating OCP.

Every time a user asks for a new criteria to filter a product do we have to modify the ProductFilter class?   
**_Yes! This means it is not CLOSED for modification._**

Every time a user asks for a new criteria to filter a product can we extend the behavior of the ProductFilter class to support this new criteria without opening up the class file again and modifying it?  
** _No! This means it is not OPEN for extension._**

## Solutions

One of the easiest ways to implement OCP is utilize a <a href="http://en.wikipedia.org/wiki/Template_method_pattern" target="_blank">template</a> or <a href="http://en.wikipedia.org/wiki/Strategy_pattern" target="_blank">strategy</a> pattern. If we still allow the Product filter to perform its job of invoking the filtering process we can put the responsibility of how the filtering is accomplished in another class by mixing in a little <a href="http://www.lostechies.com/blogs/chad_myers/archive/2008/03/11/ptom-the-liskov-substitution-principle.aspx" target="_blank">LSP</a> to accomplish this.

Here is the template for the ProductFilterSpecification

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">abstract</span> <span style="color: #0000ff">class</span> ProductFilterSpecification
{
    <span style="color: #0000ff">public</span> IEnumerable&lt;Product&gt; Filter(IList&lt;Product&gt; products)
    {
        <span style="color: #0000ff">return</span> ApplyFilter(products);
    }

    <span style="color: #0000ff">protected</span> <span style="color: #0000ff">abstract</span> IEnumerable&lt;Product&gt; ApplyFilter(IList&lt;Product&gt; products);
}</pre>
</div>

Let’s go ahead and create our first criteria, which is a color specification.

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> ColorFilterSpecification : ProductFilterSpecification
{
    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> ProductColor productColor;

    <span style="color: #0000ff">public</span> ColorFilterSpecification(ProductColor productColor)
    {
        <span style="color: #0000ff">this</span>.productColor = productColor;
    }

    <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> IEnumerable&lt;Product&gt; ApplyFilter(IList&lt;Product&gt; products)
    {
        <span style="color: #0000ff">foreach</span> (var product <span style="color: #0000ff">in</span> products)
        {
            <span style="color: #0000ff">if</span> (product.Color == productColor)
                <span style="color: #0000ff">yield</span> <span style="color: #0000ff">return</span> product;
        }
    }
}</pre>
</div>

Now all we have to do is extend the actual ProductFilter class to accept our template ProductFilterSpecification. 

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> IEnumerable&lt;Product&gt; By(IList&lt;Product&gt; products, ProductFilterSpecification filterSpecification)
{
    <span style="color: #0000ff">return</span> filterSpecification.Filter(products);
}</pre>
</div>

OCP goodness!

So lets make sure we are **NOT** violating OCP and ask the same questions we did before.

Every time a user asks for a new criteria to filter a product do we have to modify the ProductFilter class?  
 **No!** **Because we have marshaled the behavior of filtering to the ProductFilterSpecification**. &#8220;Closed for modification&#8221;

Every time a user asks for a new criteria to filter a product can we extend the behavior of the ProductFilter class to support this new criteria without opening up the class file again and modifying it?   
**Yes! All we simply have to do is pass in a new ProductFilterSpecification. &#8220;Open for extension&#8221;**

Now let’s just make sure we haven’t modified too much from our intentions of the ProductFilter. All we simply have to do is validate that our ProductFilter still has the same behavior as before. 

The **_ProductFilter_** is responsible for **_filtering products_** by **_color: Yes it still does that!_**

The **_ProductFilter_** is responsible for **_filtering products_** by **_size: Yes it still does that!_**

The **_ProductFilter_** is responsible for **_filtering products_** by **_color and size: Yes it still does that!_**

If you are a good TDD/BDD practitioner you should already have all these scenarios covered in your Test Suite.

Here is the final code:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">namespace</span> OCP_Example.Good
{
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> ProductFilter
    {
        [Obsolete(<span style="color: #006080">"This method is obsolete; use method 'By' with ProductFilterSpecification"</span>)]
        <span style="color: #0000ff">public</span> IEnumerable&lt;Product&gt; ByColor(IList&lt;Product&gt; products, ProductColor productColor)
        {
            <span style="color: #0000ff">foreach</span> (var product <span style="color: #0000ff">in</span> products)
            {
                <span style="color: #0000ff">if</span> (product.Color == productColor)
                    <span style="color: #0000ff">yield</span> <span style="color: #0000ff">return</span> product;
            }
        }

        [Obsolete(<span style="color: #006080">"This method is obsolete; use method 'By' with ProductFilterSpecification"</span>)]
        <span style="color: #0000ff">public</span> IEnumerable&lt;Product&gt; ByColorAndSize(IList&lt;Product&gt; products,
                                                    ProductColor productColor,
                                                    ProductSize productSize)
        {
            <span style="color: #0000ff">foreach</span> (var product <span style="color: #0000ff">in</span> products)
            {
                <span style="color: #0000ff">if</span> ((product.Color == productColor) &&
                    (product.Size == productSize))
                    <span style="color: #0000ff">yield</span> <span style="color: #0000ff">return</span> product;
            }
        }

        [Obsolete(<span style="color: #006080">"This method is obsolete; use method 'By' with ProductFilterSpecification"</span>)]
        <span style="color: #0000ff">public</span> IEnumerable&lt;Product&gt; BySize(IList&lt;Product&gt; products,
                                            ProductSize productSize)
        {
            <span style="color: #0000ff">foreach</span> (var product <span style="color: #0000ff">in</span> products)
            {
                <span style="color: #0000ff">if</span> ((product.Size == productSize))
                    <span style="color: #0000ff">yield</span> <span style="color: #0000ff">return</span> product;
            }
        }

        <span style="color: #0000ff">public</span> IEnumerable&lt;Product&gt; By(IList&lt;Product&gt; products, ProductFilterSpecification filterSpecification)
        {
            <span style="color: #0000ff">return</span> filterSpecification.Filter(products);
        }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">abstract</span> <span style="color: #0000ff">class</span> ProductFilterSpecification
    {
        <span style="color: #0000ff">public</span> IEnumerable&lt;Product&gt; Filter(IList&lt;Product&gt; products)
        {
            <span style="color: #0000ff">return</span> ApplyFilter(products);
        }

        <span style="color: #0000ff">protected</span> <span style="color: #0000ff">abstract</span> IEnumerable&lt;Product&gt; ApplyFilter(IList&lt;Product&gt; products);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> ColorFilterSpecification : ProductFilterSpecification
    {
        <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> ProductColor productColor;

        <span style="color: #0000ff">public</span> ColorFilterSpecification(ProductColor productColor)
        {
            <span style="color: #0000ff">this</span>.productColor = productColor;
        }

        <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> IEnumerable&lt;Product&gt; ApplyFilter(IList&lt;Product&gt; products)
        {
            <span style="color: #0000ff">foreach</span> (var product <span style="color: #0000ff">in</span> products)
            {
                <span style="color: #0000ff">if</span> (product.Color == productColor)
                    <span style="color: #0000ff">yield</span> <span style="color: #0000ff">return</span> product;
            }
        }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">enum</span> ProductColor
    {
        Blue,
        Yellow,
        Red,
        Gold,
        Brown
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">enum</span> ProductSize
    {
        Small, Medium, Large, ReallyBig
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Product
    {
        <span style="color: #0000ff">public</span> Product(ProductColor color)
        {
            <span style="color: #0000ff">this</span>.Color = color;
        }

        <span style="color: #0000ff">public</span> ProductColor Color { get; set; }

        <span style="color: #0000ff">public</span> ProductSize Size { get; set; }
    }

    [Context]
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Filtering_by_color
    {
        <span style="color: #0000ff">private</span> ProductFilter filterProduct;
        <span style="color: #0000ff">private</span> IList&lt;Product&gt; products;

        [SetUp]
        <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> before_each_spec()
        {
            filterProduct = <span style="color: #0000ff">new</span> ProductFilter();
            products = BuildProducts();
        }

        <span style="color: #0000ff">private</span> IList&lt;Product&gt; BuildProducts()
        {
            <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> List&lt;Product&gt;
                               {
                                   <span style="color: #0000ff">new</span> Product(ProductColor.Blue),
                                   <span style="color: #0000ff">new</span> Product(ProductColor.Yellow),
                                   <span style="color: #0000ff">new</span> Product(ProductColor.Yellow),
                                   <span style="color: #0000ff">new</span> Product(ProductColor.Red),
                                   <span style="color: #0000ff">new</span> Product(ProductColor.Blue)
                               };

        }


        [Specification]
        <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> should_filter_by_the_color_given()
        {
            <span style="color: #0000ff">int</span> foundCount = 0;
            <span style="color: #0000ff">foreach</span> (var product <span style="color: #0000ff">in</span> filterProduct.By(products, <span style="color: #0000ff">new</span> ColorFilterSpecification(ProductColor.Blue)))
            {
                foundCount++;
            }

            Assert.That(foundCount, Is.EqualTo(2));
        }
    }
}</pre>
</div>