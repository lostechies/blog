---
id: 3347
title: 'Obvious Testing or: How I Learned to Stop Using the new keyword'
date: 2009-03-20T01:19:55+00:00
author: Chris Missal
layout: post
guid: /blogs/chrismissal/archive/2009/03/19/obvious-testing-or-how-i-learned-to-stop-using-the-new-keyword.aspx
dsq_thread_id:
  - "262174832"
categories:
  - Testing
---
Here’s a basic test; looks simple right? Well, that’s because it is. A new Order is given three different order items, each with a quantity of one. We assert (using nunit) that there are three OrderItems, then RemoveAllItems and assert that there are zero.

<pre style="background: black"><span style="background: black;color: white">        [</span><span style="background: black;color: yellow">Test</span><span style="background: black;color: white">]
        </span><span style="background: black;color: #ff8000">public void </span><span style="background: black;color: white">An_Order_should_be_able_to_remove_all_items()
        {
            </span><span style="background: black;color: #ff8000">var </span><span style="background: black;color: white">product1 = </span><span style="background: black;color: #ff8000">new </span><span style="background: black;color: yellow">Product</span><span style="background: black;color: white">(</span><span style="background: black;color: lime">"part1"</span><span style="background: black;color: white">, 10m);
            </span><span style="background: black;color: #ff8000">var </span><span style="background: black;color: white">product2 = </span><span style="background: black;color: #ff8000">new </span><span style="background: black;color: yellow">Product</span><span style="background: black;color: white">(</span><span style="background: black;color: lime">"part2"</span><span style="background: black;color: white">, 20m);
            </span><span style="background: black;color: #ff8000">var </span><span style="background: black;color: white">product3 = </span><span style="background: black;color: #ff8000">new </span><span style="background: black;color: yellow">Product</span><span style="background: black;color: white">(</span><span style="background: black;color: lime">"part3"</span><span style="background: black;color: white">, 30m);
            </span><span style="background: black;color: #ff8000">var </span><span style="background: black;color: white">order = </span><span style="background: black;color: #ff8000">new </span><span style="background: black;color: yellow">Order</span><span style="background: black;color: white">();
            order.AddOrderItem(product1, 1);
            order.AddOrderItem(product2, 1);
            order.AddOrderItem(product3, 1);
            </span><span style="background: black;color: yellow">Assert</span><span style="background: black;color: white">.That(order.OrderItems.Count(), </span><span style="background: black;color: yellow">Is</span><span style="background: black;color: white">.EqualTo(3));
            order.RemoveAllItems();
            </span><span style="background: black;color: yellow">Assert</span><span style="background: black;color: white">.That(order.OrderItems.Count(), </span><span style="background: black;color: yellow">Is</span><span style="background: black;color: white">.EqualTo(0));
        }</span></pre>

If you know where this is going, you’re at least one step ahead of me when I wrote the RemoveAllItems function. It does exactly what it is supposed to do, and this test passes. There’s more than one way to implement the RemoveAllItems function and initially I chose a bad one. The following is the original implementation. Looking back, it’s obvious that it is wrong, but at the time, it must have been “the way” to do it.

<pre style="background: black"><span style="background: black;color: white">    </span><span style="background: black;color: #ff8000">public class </span><span style="background: black;color: yellow">Order </span><span style="background: black;color: white">: </span><span style="background: black;color: #2b91af">IOrder
    </span><span style="background: black;color: white">{
        </span><span style="background: black;color: #ff8000">private </span><span style="background: black;color: #2b91af">IList</span><span style="background: black;color: white">&lt;</span><span style="background: black;color: #2b91af">IOrderItem</span><span style="background: black;color: white">&gt; orderItems;
        </span><span style="background: black;color: lime">// ...

        </span><span style="background: black;color: #ff8000">public </span><span style="background: black;color: white">Order()
        {
            orderItems = </span><span style="background: black;color: #ff8000">new </span><span style="background: black;color: yellow">List</span><span style="background: black;color: white">&lt;</span><span style="background: black;color: #2b91af">IOrderItem</span><span style="background: black;color: white">&gt;();
            </span><span style="background: black;color: lime">// ...
        </span><span style="background: black;color: white">}

        </span><span style="background: black;color: #ff8000">public virtual </span><span style="background: black;color: #2b91af">IEnumerable</span><span style="background: black;color: white">&lt;</span><span style="background: black;color: #2b91af">IOrderItem</span><span style="background: black;color: white">&gt; OrderItems
        {
            </span><span style="background: black;color: #ff8000">get </span><span style="background: black;color: white">{ </span><span style="background: black;color: #ff8000">return </span><span style="background: black;color: white">orderItems; }
        }

        </span><span style="background: black;color: #ff8000">public void </span><span style="background: black;color: white">RemoveAllItems()
        {
            orderItems = </span><span style="background: black;color: #ff8000">new </span><span style="background: black;color: yellow">List</span><span style="background: black;color: white">&lt;</span><span style="background: black;color: #2b91af">IOrderItem</span><span style="background: black;color: white">&gt;();
            </span><span style="background: black;color: lime">// ...
        </span><span style="background: black;color: white">}
    }
</span></pre>

[](http://11011.net/software/vspaste)

I’ve seen the ‘new’ keyword cause me trouble before, it usually gives me hard to test code. This time I fell short by not thinking enough about it. (This also could have been avoided if the code was written while pairing, but that’s another story). Why on Earth should the RemoveAllItems create a new List<T>? It shouldn’t, it should call orderItems.Clear(). The following test looks fairly trivial, but is now in place over some code that reared its ugly head at a really bad time.

<pre style="background: black"><span style="background: black;color: white">        [</span><span style="background: black;color: yellow">Test</span><span style="background: black;color: white">]
        </span><span style="background: black;color: #ff8000">public void </span><span style="background: black;color: white">An_Orders_Items_should_be_the_same_object_when_emptied()
        {
            </span><span style="background: black;color: #ff8000">var </span><span style="background: black;color: white">product = </span><span style="background: black;color: #ff8000">new </span><span style="background: black;color: yellow">Product</span><span style="background: black;color: white">(</span><span style="background: black;color: lime">"part1"</span><span style="background: black;color: white">, 10m);
            </span><span style="background: black;color: #ff8000">var </span><span style="background: black;color: white">order = </span><span style="background: black;color: #ff8000">new </span><span style="background: black;color: yellow">Order</span><span style="background: black;color: white">();
            </span><span style="background: black;color: #ff8000">var </span><span style="background: black;color: white">itemsAtCreation = order.OrderItems;

            order.AddOrderItem(product, 1);

            </span><span style="background: black;color: yellow">Assert</span><span style="background: black;color: white">.That(order.OrderItems.Count(), </span><span style="background: black;color: yellow">Is</span><span style="background: black;color: white">.EqualTo(1));
            </span><span style="background: black;color: yellow">Assert</span><span style="background: black;color: white">.That(order.OrderItems, </span><span style="background: black;color: yellow">Is</span><span style="background: black;color: white">.EqualTo(itemsAtCreation));

            order.RemoveAllItems();
            order.AddOrderItem(product, 1);

            </span><span style="background: black;color: yellow">Assert</span><span style="background: black;color: white">.That(order.OrderItems.Count(), </span><span style="background: black;color: yellow">Is</span><span style="background: black;color: white">.EqualTo(1));
            </span><span style="background: black;color: yellow">Assert</span><span style="background: black;color: white">.That(order.OrderItems, </span><span style="background: black;color: yellow">Is</span><span style="background: black;color: white">.EqualTo(itemsAtCreation));
        }
</span></pre>

[](http://11011.net/software/vspaste)

### Doing it the wrong way

With this new test in place here are the results I get:

<pre style="background: black"><span style="background: black;color: white">        </span><span style="background: black;color: #ff8000">public void </span><span style="background: black;color: white">RemoveAllItems()
        {
            orderItems = </span><span style="background: black;color: #ff8000">new </span><span style="background: black;color: yellow">List</span><span style="background: black;color: white">&lt;</span><span style="background: black;color: #2b91af">IOrderItem</span><span style="background: black;color: white">&gt;();
            </span><span style="background: black;color: lime">// ...
        </span><span style="background: black;color: white">}
</span></pre>

[](http://11011.net/software/vspaste)

<pre style="background: #dddddd">Expected and actual are both &lt;System.Collections.Generic.List`1[Company.Domain.Cart.ICartItem]&gt; with 1 elements
Values differ at index [0]
Expected: &lt;Company.Domain.Cart.CartItem&gt;
But was:  &lt;Company.Domain.Cart.CartItem&gt;</pre>

### And now the right way

[](http://11011.net/software/vspaste)

Now that it’s modified like the following, the test passes.

<pre style="background: black"><span style="background: black;color: white">        </span><span style="background: black;color: #ff8000">public void </span><span style="background: black;color: white">RemoveAllItems()
        {
            orderItems.Clear();
            </span><span style="background: black;color: lime">// ...
        </span><span style="background: black;color: white">}
</span></pre>

<pre style="background: #dddddd">1 passed, 0 failed, 0 skipped, took 1.41 seconds.</pre>

[](http://11011.net/software/vspaste)

### Why does it matter that the Object is the same?

Not only should it be the same object, in a sense that one order has one collection of order items for its lifetime, but let us imagine that we want to persist this data (reaching, I know). Let us also imagine that we NHibernate for persistence. Combine these factors and not using “all-delete-orphan” with <a href="http://www.hibernate.org/hib_docs/nhibernate/html/performance.html#performance-collections-oneshotdelete" target="_blank">one-shot-deletes</a>, and you’ve got yourself some fairly unexpected behavior.