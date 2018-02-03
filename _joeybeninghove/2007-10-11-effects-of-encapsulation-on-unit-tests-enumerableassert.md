---
wordpress_id: 45
title: 'Effects Of Encapsulation On Unit Tests &#8211; EnumerableAssert'
date: 2007-10-11T16:13:00+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/10/11/effects-of-encapsulation-on-unit-tests-enumerableassert.aspx
categories:
  - 'C#'
  - mbunit
  - TDD
---
To keep your classes properly encapsulated,&nbsp;I&#8217;ve learned (from others and my
  
own experience)&nbsp;that it&#8217;s usually a good idea to expose collections only&nbsp;as
  
IEnumerable<T>, until the need arises to elevate it to a higher type.&nbsp; In
  
keeping with this, it can sometimes make your unit tests less elegant.&nbsp; Here are
  
some examples and&nbsp;a quick little helper that can make things more
  
readable&#8230;

So an extremely simple example would be something like this.

<div>
  <pre>[Test]<br /><span>public</span> <span>void</span> Should_add_item_to_basket()<br />{<br />    IBasket basket = <span>new</span> Basket();<br />    IBasketItem basketItem = <span>new</span> BasketItem();<br />    <br />    basket.AddItemToBasket(basketItem);<br /><br />    <span>// TODO: Assert that the item was added to the basket</span><br />}<br /></pre>
</div>

&nbsp;

For reference, here is the IBasket interface:

<div>
  <pre><span>public</span> <span>interface</span> IBasket<br />{<br />    IEnumerable&lt;IBasketItem&gt; Items { get; }<br />    <span>void</span> AddItemToBasket(IBasketItem itemToAdd);<br />}</pre>
</div>

&nbsp;

Ok, so of course there are a number of ways we could write this assertion.&nbsp;
  
Here are a couple examples using the out of the box MbUnit assertions.

<div>
  <pre>Assert.IsTrue(<span>new</span> List&lt;IBasketItem&gt;(basket.Items).Contains(basketItem));<br /><br />CollectionAssert.Contains(<span>new</span> List&lt;IBasketItem&gt;(basket.Items), basketItem);<br /><br /><span>foreach</span> (IBasketItem currentItem <span>in</span> basket.Items) Assert.AreEqual(currentItem, basketItem);<br /></pre>
</div>

&nbsp;

Don&#8217;t know about you, but those seem a little too verbose to me.&nbsp; I tend to
  
like something like this better.

<div>
  <pre>EnumerableAssert.Contains(basket.Items, basketItem);</pre>
</div>

&nbsp;

But you won&#8217;t find that in the MbUnit framework.&nbsp; Fortunately it&#8217;s easy
  
enough to write a little wrapper to &#8220;hide&#8221; the verbosity.

<div>
  <pre><span>public</span> <span>class</span> EnumerableAssert<br />{<br />    <span>public</span> <span>static</span> <span>void</span> Contains&lt;T&gt;(IEnumerable&lt;T&gt; enumerable, T actual)<br />    {<br />        CollectionAssert.Contains(<span>new</span> List&lt;T&gt;(enumerable), actual);<br />    }<br />}<br /></pre>
</div>

&nbsp;

Notice all I&#8217;m doing is leveraging one of MbUnit&#8217;s existing assertions
  
(CollectionAssert) to wrap an IEnumerable<T> and perform a contains
  
assertion.&nbsp; Pretty simple stuff, but it can help keep your tests more
  
readable.

&nbsp;