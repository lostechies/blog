---
wordpress_id: 37
title: Limitations of generic base classes
date: 2007-07-03T15:51:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/07/03/limitations-of-generic-base-classes.aspx
dsq_thread_id:
  - "324047335"
categories:
  - 'C#'
redirect_from: "/blogs/jimmy_bogard/archive/2007/07/03/limitations-of-generic-base-classes.aspx/"
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/07/limitations-of-generic-base-classes.html)._

I thought I had created something fairly useful with a [generic Value Object](http://www.lostechies.com/blogs/jimmy_bogard/archive/2007/06/25/generic-value-object-equality.aspx) in a previous post.&nbsp; Generic base classes are nice, and there are [several](http://msdn2.microsoft.com/en-us/library/ms132397.aspx) [recommended](http://msdn2.microsoft.com/en-us/library/ms132438.aspx) [base classes](http://msdn2.microsoft.com/en-us/library/ms132474.aspx) for creating collections classes.&nbsp; Whenever I try to make an interesting API with a generic base class, limitations and faulty assumptions always reduce the usefulness of that base class.&nbsp; Let&#8217;s first start with a couple of classes that we&#8217;d like to include in a generic API:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> Address<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">private</span> <span class="kwrd">readonly</span> <span class="kwrd">string</span> _address1;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">private</span> <span class="kwrd">readonly</span> <span class="kwrd">string</span> _city;<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> Address(<span class="kwrd">string</span> address1, <span class="kwrd">string</span> city)<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_address1 = address1;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_city = city;<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">string</span> Address1<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;get { <span class="kwrd">return</span> _address1; }<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">string</span> City<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;get { <span class="kwrd">return</span> _city; }<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
}<br />
<br />
<span class="kwrd">public</span> <span class="kwrd">class</span> ExpandedAddress : Address<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">private</span> <span class="kwrd">readonly</span> <span class="kwrd">string</span> _address2;<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> ExpandedAddress(<span class="kwrd">string</span> address1, <span class="kwrd">string</span> address2, <span class="kwrd">string</span> city)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: <span class="kwrd">base</span>(address1, city)<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_address2 = address2;<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">string</span> Address2<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;get { <span class="kwrd">return</span> _address2; }<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
}<br />
</pre>
</div>

Fairly basic classes, just two types of addresses, with one a subtype of the other.&nbsp; So what kinds of issues do I usually run in to with generic base classes?&nbsp; Let&#8217;s look at&nbsp;a few different types of generic base classes to see.

### Concrete generic implementations

A concrete generic implementation is a concrete class that inherits a generic base class:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> AddressCollection : Collection&lt;Address&gt;<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> AddressCollection() {}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> AddressCollection(IList&lt;Address&gt; list) : <span class="kwrd">base</span>(list) {}<br />
}<br />
</pre>
</div>

Following the [Framework Design Guidelines](http://www.amazon.com/Framework-Design-Guidelines-Conventions-Development/dp/0321246756), I created a concrete collections class by inheriting from [System.Collections.ObjectModel.Collection<T>](http://msdn2.microsoft.com/en-us/library/ms132397.aspx).&nbsp; I also have the ExpandedAddress class, so how do I create a specialized collection of ExpandedAddresses?&nbsp; I have a few options:

  * Create an ExpandedAddressCollection class inheriting from AddressCollection 
      * Create an ExpandedAddressCollection class inheriting from Collection<ExpandedAddress> 
          * Use the existing AddressCollection class and put ExpandedAddress instances in it.</ul> 
        All of these seem reasonable, right?&nbsp; Let&#8217;s take a closer look.
        
        #### Inherit from AddressCollection
        
        Here&#8217;s what the ExpandedAddressCollection class would look like:
        
        <div class="CodeFormatContainer">
          <pre><span class="kwrd">public</span> <span class="kwrd">class</span> ExpandedAddressCollection : AddressCollection<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> ExpandedAddressCollection() {}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> ExpandedAddressCollection(IList&lt;Address&gt; list) : <span class="kwrd">base</span>(list) {}<br />
}<br />
</pre>
        </div>
        
        That&#8217;s not very interesting, it didn&#8217;t add any information to the original AddressCollection.&nbsp; What&#8217;s more, this ExpandedAddressCollection ultimately inherits Collection<Address>, _not_ Collection<ExpandedAddress>.&nbsp; Everything I try to put in or get out will be an Address, not an ExpandedAddress.&nbsp; For example, this code wouldn&#8217;t compile:
        
        <div class="CodeFormatContainer">
          <pre>List&lt;ExpandedAddress&gt; addresses = <span class="kwrd">new</span> List&lt;ExpandedAddress&gt;();<br />
addresses.Add(<span class="kwrd">new</span> ExpandedAddress(<span class="str">"Address1"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>));<br />
<br />
ExpandedAddressCollection addressList = <span class="kwrd">new</span> ExpandedAddressCollection(addresses);<br />
</pre>
        </div>
        
        Because of limitations in generic variance, namely that C# [does not support](http://msdn2.microsoft.com/en-us/library/ms228359(vs.80).aspx) generic [covariance or contravariance](http://blogs.msdn.com/rmbyers/archive/2005/02/16/375079.aspx).&nbsp; Even though ExpandedAddress&nbsp;is a subtype of&nbsp;Address, and ExpandedAddress[] is a subtype of Address[],&nbsp;IList<ExpandedAddress> **is not** a subtype of IList<Address>.
        
        #### Inherit from Collection<ExpandedAddress>
        
        In this example, I&#8217;ll just implement the ExpandedAddressCollection in the same manner as AddressCollection:
        
        <div class="CodeFormatContainer">
          <pre><span class="kwrd">public</span> <span class="kwrd">class</span> ExpandedAddressCollection : Collection&lt;ExpandedAddress&gt;<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> ExpandedAddressCollection() {}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> ExpandedAddressCollection(IList&lt;ExpandedAddress&gt; list) : <span class="kwrd">base</span>(list) { }<br />
}<br />
</pre>
        </div>
        
        Now I my collection is strongly types towards ExpandedAddresses, so the example I showed previously would now compile.&nbsp; It seems like I&#8217;m on the right track, but I run into even more issues:
        
          * ExpandedAddressCollection is not a subtype of AddressCollection 
              * Collection hierarchy does not match hierarchy of Addresses (one is a tree, the other is flat) 
                  * I can&#8217;t pass an ExpandedAddressCollection into a method expecting an AddressCollection 
                      * Since there is no relationship between the two collection types, I can&#8217;t use many patterns where a relationship is necessary</ul> 
                    So even though my collection is strongly typed, it becomes severely limited in more interesting scenarios.
                    
                    #### Use existing AddressCollection class
                    
                    In this instance, I won&#8217;t even create an ExpandedAddressCollection class.&nbsp; Any time I need a collection of ExpandedAddresses, I&#8217;ll use the AddressCollection class, and cast as necessary.&nbsp; I won&#8217;t be able to pass an IList<ExpandedAddress> to the constructor because of the variance issue, however.&nbsp; If I need to include some custom logic in the collection class, I&#8217;ll run into the same problems highlighted earlier if I&#8217;m forced to create a new subtype of AddressCollection.
                    
                    So we&#8217;ve seen the limitations of concrete generic implementations, what other options do I have?
                    
                    ### Constrained generic base classes
                    
                    I&#8217;d like a way to propagate the concrete type parameter&nbsp;back up to the original Collection<T>.&nbsp; What if I make the AddressCollection generic as well?&nbsp; Here&#8217;s what that would look like:
                    
                    <div class="CodeFormatContainer">
                      <pre><span class="kwrd">public</span> <span class="kwrd">class</span> AddressCollection&lt;T&gt; : Collection&lt;T&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">where</span> T : Address<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> AddressCollection() {}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> AddressCollection(IList&lt;T&gt; list) : <span class="kwrd">base</span>(list) {}<br />
}<br />
<br />
<span class="kwrd">public</span> <span class="kwrd">class</span> ExpandedAddressCollection : AddressCollection&lt;ExpandedAddress&gt;<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> ExpandedAddressCollection() {}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> ExpandedAddressCollection(IList&lt;ExpandedAddress&gt; list) : <span class="kwrd">base</span>(list) { }<br />
}<br />
</pre>
                    </div>
                    
                    So now I have a constrained base class for an AddressCollection, and an implementation for an ExpandedAddressCollection.&nbsp; What do I gain from this implementation?
                    
                      * ExpandedAddressCollection is completely optional, I could just define all usage through an AddressCollection<ExpandedAddress> 
                          * Any AddressCollection concrete type will be correctly strongly typed for an Address type</ul> 
                        Again, with some more interesting usage, I start to run into some problems:
                        
                          * I can never reference only AddressCollection, as I always have to give it a type parameter. 
                              * Once I give it a type parameter, I run into the same variance issues as before, namely AddressCollection<ExpandedAddress> is not a subtype of AddressCollection<Address> 
                                  * Since I can never define any method in terms of solely an AddressCollection, I either need to make the containing class generic or the method generic.</ul> 
                                For example, I can write the following code:
                                
                                <div class="CodeFormatContainer">
                                  <pre><span class="kwrd">public</span> <span class="kwrd">void</span> TestGenerics()<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;AddressCollection&lt;Address&gt; addresses = <span class="kwrd">new</span> AddressCollection&lt;Address&gt;();<br />
&nbsp;&nbsp;&nbsp;&nbsp;addresses.Add(<span class="kwrd">new</span> Address(<span class="str">"132 Anywhere"</span>, <span class="str">"Austin"</span>));<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">int</span> count = NumberOfAustinAddresses(addresses);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;AddressCollection&lt;ExpandedAddress&gt; expAddresses = <span class="kwrd">new</span> AddressCollection&lt;ExpandedAddress&gt;();<br />
&nbsp;&nbsp;&nbsp;&nbsp;expAddresses.Add(<span class="kwrd">new</span> ExpandedAddress(<span class="str">"132 Anywhere"</span>, <span class="str">"Apt 123"</span>, <span class="str">"Austin"</span>));<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;count = NumberOfAustinAddresses(addresses);<br />
}<br />
<br />
<span class="kwrd">private</span> <span class="kwrd">int</span> NumberOfAustinAddresses&lt;T&gt;(AddressCollection&lt;T&gt; addresses)<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">where</span> T : Address<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">int</span> count = 0;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">foreach</span> (T address <span class="kwrd">in</span> addresses)<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">if</span> (address.City == <span class="str">"Austin"</span>)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;count++;<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return</span> count;<br />
}<br />
</pre>
                                </div>
                                
                                This isn&#8217;t too bad for the implementation nor the client code.&nbsp; I don&#8217;t even need to specify a generic parameter in the method calls.&nbsp; If I can live with generic methods, this pattern might work for most situations.
                                
                                The only other problem I&#8217;ll have is that I might need to create subtypes of AddressCollection, like I did above with ExpandedAddressCollection.&nbsp; In this case, I&#8217;d can continue to make each subtype generic and constrained to the derived type:
                                
                                <div class="CodeFormatContainer">
                                  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> ExpandedAddressCollection&lt;T&gt; : AddressCollection&lt;T&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">where</span> T : ExpandedAddress<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> ExpandedAddressCollection() {}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> ExpandedAddressCollection(IList&lt;T&gt; list) : <span class="kwrd">base</span>(list) { }<br />
}<br />
</pre>
                                </div>
                                
                                Again, if I can live with generic methods, I would be happy with this implementation, as I now keep the same hierarchy as my Addresses.&nbsp; It is a little strange declaring ExpandedAddressCollection with a type parameter (ExpandedAddressCollection<ExpandedAddress>), but I&#8217;ll live.
                                
                                There&#8217;s one more type of generic base class I&#8217;d like to explore.
                                
                                ### Self-constrained generic base classes
                                
                                Sometimes, I need to implement a certain generic interface, such as IEquatable<T>.&nbsp; I could&nbsp;simply pass in the concrete type into the generic parameter like this:
                                
                                <div class="CodeFormatContainer">
                                  <pre><span class="kwrd">public</span> <span class="kwrd">abstract</span> <span class="kwrd">class</span> ValueObject : IEquatable&lt;ValueObject&gt;<br />
</pre>
                                </div>
                                
                                But if I&#8217;m trying to create an abstract or a base class for subtypes to use, I&#8217;ll run into problems where derived types won&#8217;t implement IEquatable<DerivedType>.&nbsp; Instead, I can make this abstract class generic and self-constraining:
                                
                                <div class="CodeFormatContainer">
                                  <pre><span class="kwrd">public</span> <span class="kwrd">abstract</span> <span class="kwrd">class</span> ValueObject&lt;T&gt; : IEquatable&lt;T&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">where</span> T : ValueObject&lt;T&gt;<br />
</pre>
                                </div>
                                
                                Now, derived types will implement IEquatable<DerivedType>, as I showed in my [post on value types](http://www.lostechies.com/blogs/jimmy_bogard/archive/2007/06/25/generic-value-object-equality.aspx).&nbsp; Unfortunately, subtypes will only implement the correct IEquatable<T> for the first derived class:
                                
                                <div class="CodeFormatContainer">
                                  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> Address : ValueObject&lt;Address&gt;<br />
<span class="kwrd">public</span> <span class="kwrd">class</span> ExpandedAddress : Address<br />
</pre>
                                </div>
                                
                                In this case, ExpandedAddress is not a subtype of ValueObject<ExpandedAddress>, and therefore only implements IEquatable<Address>.&nbsp; I can&#8217;t use the same tricks with the constrained generic base class, as I would need to declare Address as generic, and therefore never instantiable by itself.&nbsp; The self-constrained generic base or abstract class is unfortunately only useful in hierarchies one level deep.
                                
                                ### Conclusion
                                
                                So generics aren&#8217;t the silver spoon I thought it would be, but there are some [interesting proposals to allow variance](http://research.microsoft.com/~akenn/generics/ECOOP06.pdf) for generic types out there.&nbsp; I might not be able to cover all of the scenarios I&#8217;d like for a generic base class, but by identifying several options and their consequences, I can make a better decision&nbsp;on solving&nbsp;the problem.