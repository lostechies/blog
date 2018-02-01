---
id: 223
title: Strategies and discriminators in NHibernate
date: 2008-08-27T03:44:12+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/08/26/strategies-and-discriminators-in-nhibernate.aspx
dsq_thread_id:
  - "264715886"
categories:
  - NHibernate
  - Patterns
---
I recently [posted about enumeration classes](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/08/12/enumeration-classes.aspx), and how I like to use them as a sort of &#8220;Enumerations with behavior&#8221;.&nbsp; Not every enumeration should be replaced with a class, but that pattern helps quite a bit when I find a lot of switch statements concerning my enumeration.&nbsp; Often, these strategies come from data.&nbsp; For example, I recently had a situation where individual Product instances had different PricingStrategies.&nbsp; Each PricingStrategy depended on specific rules around Product data, so the Product data owners would decide what PricingStrategy each Product was eligible for.

This was nice, as it seemed like they pretty much flipped a coin on how they wanted to do pricing.&nbsp; In any case, when the PricingStrategy is data-driven, it leaves a lot of flexibility on the business side to change pricing as they need to, with full confidence that each PricingStrategy type could handle its own pricing rules.

To handle this, we went with something very close to the enumeration classes I described earlier.&nbsp; First, here&#8217;s our Product class:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Product
</span>{
    <span style="color: blue">public int </span>Id { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public string </span>Name { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public decimal </span>UnitPrice { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public int </span>UnitsInStock { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }

    <span style="color: blue">public </span><span style="color: #2b91af">Category </span>Category { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">PricingStrategy </span>PricingStrategy { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }

    <span style="color: blue">public decimal </span>GetPrice()
    {
        <span style="color: blue">decimal </span>discountAmount = (UnitPrice * PricingStrategy.GetDiscountPercentage(<span style="color: blue">this</span>) / 100m);

        <span style="color: blue">return </span>UnitPrice - discountAmount;
    }
}
</pre>

[](http://11011.net/software/vspaste)

Note that the GetPrice uses the PricingStrategy to calculate the final price.&nbsp; The PricingStrategy (really, a discount strategy in this example) had various means of determining what he discount percentage would be.&nbsp; It used something of a double-dispatch to calculate this, passing the Product into the PricingStrategy.&nbsp; Our PricingStrategy class is our old enumeration class:

<pre><span style="color: blue">public abstract class </span><span style="color: #2b91af">PricingStrategy
</span>{
    <span style="color: blue">private int </span>_id;
    <span style="color: blue">private string </span>_name;
    <span style="color: blue">private string </span>_displayName;

    <span style="color: blue">public static readonly </span><span style="color: #2b91af">PricingStrategy </span>FullPrice = <span style="color: blue">new </span><span style="color: #2b91af">FullPriceStrategy</span>(1);
    <span style="color: blue">public static readonly </span><span style="color: #2b91af">PricingStrategy </span>LowStock = <span style="color: blue">new </span><span style="color: #2b91af">LowStockDiscountPriceStrategy</span>(2);

    <span style="color: blue">private </span>PricingStrategy() {}

    <span style="color: blue">protected </span>PricingStrategy(<span style="color: blue">int </span>id)
    {
        _id = id;
    }

    <span style="color: blue">public int </span>Id
    {
        <span style="color: blue">get </span>{ <span style="color: blue">return </span>_id; }
    }

    <span style="color: blue">public string </span>Name
    {
        <span style="color: blue">get </span>{ <span style="color: blue">return </span>_name; }
    }

    <span style="color: blue">public string </span>DisplayName
    {
        <span style="color: blue">get </span>{ <span style="color: blue">return </span>_displayName; }
    }

    <span style="color: blue">public override bool </span>Equals(<span style="color: blue">object </span>obj)
    {
        <span style="color: blue">var </span>otherValue = obj <span style="color: blue">as </span><span style="color: #2b91af">PricingStrategy</span>;

        <span style="color: blue">if </span>(otherValue == <span style="color: blue">null</span>)
        {
            <span style="color: blue">return false</span>;
        }

        <span style="color: blue">return </span>otherValue.Id.Equals(Id);
    }

    <span style="color: blue">public override int </span>GetHashCode()
    {
        <span style="color: blue">return </span>_id.GetHashCode();
    }

    <span style="color: blue">public abstract decimal </span>GetDiscountPercentage(<span style="color: #2b91af">Product </span>product);

    <span style="color: blue">private class </span><span style="color: #2b91af">FullPriceStrategy </span>: <span style="color: #2b91af">PricingStrategy
    </span>{
        <span style="color: blue">private </span>FullPriceStrategy() { }

        <span style="color: blue">public </span>FullPriceStrategy(<span style="color: blue">int </span>id)
            : <span style="color: blue">base</span>(id)
        {
        }

        <span style="color: blue">public override decimal </span>GetDiscountPercentage(<span style="color: #2b91af">Product </span>product)
        {
            <span style="color: blue">return </span>0.0m;
        }
    }

    <span style="color: blue">private class </span><span style="color: #2b91af">LowStockDiscountPriceStrategy </span>: <span style="color: #2b91af">PricingStrategy
    </span>{
        <span style="color: blue">private </span>LowStockDiscountPriceStrategy() { }

        <span style="color: blue">public </span>LowStockDiscountPriceStrategy(<span style="color: blue">int </span>id)
            : <span style="color: blue">base</span>(id)
        {
        }

        <span style="color: blue">public override decimal </span>GetDiscountPercentage(<span style="color: #2b91af">Product </span>product)
        {
            <span style="color: blue">if </span>(product.UnitsInStock &lt; 10)
                <span style="color: blue">return </span>10m;

            <span style="color: blue">return </span>0m;
        }
    }
}
</pre>

[](http://11011.net/software/vspaste)

It&#8217;s rather long, but the basic idea is that the only public type is PricingStrategy.&nbsp; The implementation types are completely private to anyone outside the abstract PricingStrategy.&nbsp; Anyone wanting to use a specific PricingStrategy can use the static readonly fields, which again hide the private types.&nbsp; No one refers to anything but the base PricingStrategy class.

The PricingStrategy values are stored in the database, here is what the tables look like:

 ![](http://grabbagoftimg.s3.amazonaws.com/nhib_disc_01.PNG)

In the database, each Product has a foreign key reference to the PricingStrategies table, which has only two entries right now.&nbsp; Each PricingStrategyID corresponds to the ID used in the static fields defined in the PricingStrategy class.&nbsp; That way, no matter if a user choose to pull from the database or from the static fields, each Value Object is equal to the other.&nbsp; The corresponding NHibernate mapping for PricingStrategy would be:

<pre><span style="color: blue">&lt;</span><span style="color: #a31515">class </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">PricingStrategy</span>" <span style="color: red">table</span><span style="color: blue">=</span>"<span style="color: blue">PricingStrategies</span>"<span style="color: blue">&gt;
    &lt;</span><span style="color: #a31515">id </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">Id</span>" <span style="color: red">column</span><span style="color: blue">=</span>"<span style="color: blue">PricingStrategyID</span>" <span style="color: red">type</span><span style="color: blue">=</span>"<span style="color: blue">int</span>"<span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">generator </span><span style="color: red">class</span><span style="color: blue">=</span>"<span style="color: blue">assigned</span>" <span style="color: blue">/&gt;
    &lt;/</span><span style="color: #a31515">id</span><span style="color: blue">&gt;
    &lt;</span><span style="color: #a31515">discriminator </span><span style="color: red">column</span><span style="color: blue">=</span>"<span style="color: blue">PricingStrategyID</span>" <span style="color: blue">/&gt;
    &lt;</span><span style="color: #a31515">property </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">Name</span>" <span style="color: blue">/&gt;

    &lt;</span><span style="color: #a31515">subclass </span><span style="color: red">discriminator-value</span><span style="color: blue">=</span>"<span style="color: blue">1</span>" <span style="color: red">extends</span><span style="color: blue">=</span>"<span style="color: blue">PricingStrategy</span>" <span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">PricingStrategy+FullPriceStrategy</span>" <span style="color: blue">/&gt;
    &lt;</span><span style="color: #a31515">subclass </span><span style="color: red">discriminator-value</span><span style="color: blue">=</span>"<span style="color: blue">2</span>" <span style="color: red">extends</span><span style="color: blue">=</span>"<span style="color: blue">PricingStrategy</span>" <span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">PricingStrategy+LowStockDiscountPriceStrategy</span>" <span style="color: blue">/&gt;
&lt;/</span><span style="color: #a31515">class</span><span style="color: blue">&gt;
</span></pre>

Note that each subclass is called out with the <subclass> element, with the corresponding discriminator value.&nbsp; The specific strategy is specified with the &#8220;name&#8221; attribute.&nbsp; At load time, NHibernate will check the discriminator column value and pull up the corresponding subclass that matches that found value.&nbsp; When the Product table has a &#8220;1&#8221; for the PricingStrategyID, NHibernate pulls up the FullPriceStrategy, and so on.

So how might this look in actual client code?&nbsp; Here are a couple of tests that pull out two different Product entries from the database, each with a different PricingStrategy:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Products_with_full_price_strategy_should_charge_full_price()
{
    <span style="color: #2b91af">ISession </span>session = GetSession();
    <span style="color: blue">var </span>product = session.Get&lt;<span style="color: #2b91af">Product</span>&gt;(22);

    product.PricingStrategy.ShouldEqual(<span style="color: #2b91af">PricingStrategy</span>.FullPrice);
    product.GetPrice().ShouldEqual(product.UnitPrice);
}

[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Products_with_low_stock_price_strategy_should_charge_discount_when_stock_is_low()
{
    <span style="color: #2b91af">ISession </span>session = GetSession();
    <span style="color: blue">var </span>product = session.Get&lt;<span style="color: #2b91af">Product</span>&gt;(8);

    product.UnitsInStock.ShouldBeLessThan(10);
    product.PricingStrategy.ShouldEqual(<span style="color: #2b91af">PricingStrategy</span>.LowStock);
    product.GetPrice().ShouldBeLessThan(product.UnitPrice);
}
</pre>

[](http://11011.net/software/vspaste)

The first Product uses the FullPrice strategy (proven by the first assertion).&nbsp; Its price should simply equal the UnitPrice.&nbsp; In the second test, that Product uses the LowStock pricing strategy.&nbsp; That strategy charges a discount when the stock gets low (maybe it&#8217;s a blue-light special?).&nbsp; Its final price should be lower than the original UnitPrice, and this is verified by our unit test above.

When strategies or enumeration classes aren&#8217;t completely code-driven, and are data driven as was in this case, NHibernate discriminators provide a nice means of a &#8220;strategy factory&#8221;.&nbsp; Each individual strategy instance is supplied with a distinct discriminator value, allowing me to add new strategy/enumeration class implementations as needed.&nbsp; The specific implementation is data-driven, which makes our product data owners happy.