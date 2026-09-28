---
wordpress_id: 35
title: Generic Value Object Equality
date: 2007-06-25T20:56:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/06/25/generic-value-object-equality.aspx
dsq_thread_id:
  - "265411959"
categories:
  - 'C#'
  - DomainDrivenDesign
redirect_from: "/blogs/jimmy_bogard/archive/2007/06/25/generic-value-object-equality.aspx/"
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/generic-value-object-equality.html)._

I read a post from [Oren](http://www.ayende.com/Blog/Default.aspx) the other day&nbsp;where he [posted some code](http://www.ayende.com/Blog/archive/2007/06/05/Generic-Entity-Equality.aspx) for a generic [Entity](https://lostechies.com/blogs/joe_ocampo/archive/2007/04/14/a-discussion-on-domain-driven-design-entities.aspx) base type that implemented the correct equality logic.&nbsp; I realized that I&#8217;ve needed a generic base type for [Value Objects](https://lostechies.com/blogs/joe_ocampo/archive/2007/04/23/a-discussion-on-domain-driven-design-value-objects.aspx) as well.

### Value Object Requirements

In the [Domain Driven Design](http://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215) space, a [Value Object](https://lostechies.com/blogs/joe_ocampo/archive/2007/04/23/a-discussion-on-domain-driven-design-value-objects.aspx):

  * Has no concept of an identity 
      * Two different instances of a Value Object with the same values are considered equal
      * Describes a characteristic of&nbsp;another thing 
          * Is immutable</ul> 
        Unfortunately, in nearly all cases I&#8217;ve run in to, we can&#8217;t use [Value Types](http://www.albahari.com/value%20vs%20reference%20types.html) in .NET to represent Value Objects.&nbsp; Value Types ([struct](http://msdn2.microsoft.com/en-us/library/aa664465(VS.71).aspx)) have some size limitations (~16 bytes or less), which we run into pretty quickly.&nbsp; Instead, we can create a Reference Type ([class](http://msdn2.microsoft.com/en-us/library/aa645599(VS.71).aspx))&nbsp;with Value Type semantics, similar to the .NET [String](http://msdn2.microsoft.com/en-us/library/system.string(VS.71).aspx) type.&nbsp; The String type is a Reference Type, but exhibits Value Type semantics, since it is immutable.&nbsp; For a Reference Type to exhibit Value Type semantics, it must:
        
          * Be immutable 
              * Override the Equals method, to implement equality instead of identity, which is the default</ul> 
            Additionally, [Framework Design Guidelines](http://www.amazon.com/Framework-Design-Guidelines-Conventions-Development/dp/0321246756) has some additional requirements I must meet:
            
              * Provide a reflexive, transitive, and symmetric implementation of Equals 
                  * Override GetHashCode 
                      * Implement IEquatable<T> 
                          * Override the equality operators</ul> 
                        ### Generic Implementation
                        
                        What I wanted was a base class that would give me all of the Framework Design Guidelines requirements as well as the Domain Driven Design requirements, without any additional logic from concrete types.&nbsp; Here&#8217;s what I ended up with:
                        
                        <div class="CodeFormatContainer">
                          <pre><span class="kwrd">public</span> <span class="kwrd">abstract</span> <span class="kwrd">class</span> ValueObject&lt;T&gt; : IEquatable&lt;T&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">where</span> T : ValueObject&lt;T&gt;<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">bool</span> Equals(<span class="kwrd">object</span> obj)<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">if</span> (obj == <span class="kwrd">null</span>)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return</span> <span class="kwrd">false</span>;<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;T other = obj <span class="kwrd">as</span> T;<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return</span> Equals(other);<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">override</span> <span class="kwrd">int</span> GetHashCode()<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;IEnumerable&lt;FieldInfo&gt; fields = GetFields();<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">int</span> startValue = 17;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">int</span> multiplier = 59;<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">int</span> hashCode = startValue;<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">foreach</span> (FieldInfo field <span class="kwrd">in</span> fields)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">object</span> <span class="kwrd">value</span> = field.GetValue(<span class="kwrd">this</span>);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">if</span> (<span class="kwrd">value</span> != <span class="kwrd">null</span>)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;hashCode = hashCode * multiplier + <span class="kwrd">value</span>.GetHashCode();<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return</span> hashCode;<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">virtual</span> <span class="kwrd">bool</span> Equals(T other)<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">if</span> (other == <span class="kwrd">null</span>)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return</span> <span class="kwrd">false</span>;<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type t = GetType();<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type otherType = other.GetType();<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">if</span> (t != otherType)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return</span> <span class="kwrd">false</span>;<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FieldInfo[] fields = t.GetFields(BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">foreach</span> (FieldInfo field <span class="kwrd">in</span> fields)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">object</span> value1 = field.GetValue(other);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">object</span> value2 = field.GetValue(<span class="kwrd">this</span>);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">if</span> (value1 == <span class="kwrd">null</span>)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">if</span> (value2 != <span class="kwrd">null</span>)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return</span> <span class="kwrd">false</span>;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">else</span> <span class="kwrd">if</span> (! value1.Equals(value2))<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return</span> <span class="kwrd">false</span>;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return</span> <span class="kwrd">true</span>;<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">private</span> IEnumerable&lt;FieldInfo&gt; GetFields()<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type t = GetType();<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;List&lt;FieldInfo&gt; fields = <span class="kwrd">new</span> List&lt;FieldInfo&gt;();<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">while</span> (t != <span class="kwrd">typeof</span>(<span class="kwrd">object</span>))<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fields.AddRange(t.GetFields(BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public));<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;t = t.BaseType;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return</span> fields;<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">bool</span> <span class="kwrd">operator</span> ==(ValueObject&lt;T&gt; x, ValueObject&lt;T&gt; y)<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return</span> x.Equals(y);<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">bool</span> <span class="kwrd">operator</span> !=(ValueObject&lt;T&gt; x, ValueObject&lt;T&gt; y)<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return</span> ! (x == y);<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
}<br />
</pre>
                        </div>
                        
                        I borrowed a little bit from the .NET [ValueType](http://msdn2.microsoft.com/en-us/library/system.valuetype.aspx) base class for the implementation of Equals.&nbsp; The ValueObject<T> type uses reflection to access and compare all internal fields for Equals, as well as for GetHashCode.&nbsp; All implementers will need to do is to ensure that their concrete type is immutable, and they&#8217;re done.
                        
                        I could probably optimize the reflection calls and cache them, but this implementation is mainly for reference anyway.
                        
                        ### The Tests
                        
                        Just for completeness, I&#8217;ll include the set of [NUnit](http://www.nunit.org/) tests I used to write this class up.&nbsp; I think the tests describe the intended behavior well enough.
                        
                        <div class="CodeFormatContainer">
                          <pre>[TestFixture]<br />
<span class="kwrd">public</span> <span class="kwrd">class</span> ValueObjectTests<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">private</span> <span class="kwrd">class</span> Address : ValueObject&lt;Address&gt;<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">private</span> <span class="kwrd">readonly</span> <span class="kwrd">string</span> _address1;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">private</span> <span class="kwrd">readonly</span> <span class="kwrd">string</span> _city;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">private</span> <span class="kwrd">readonly</span> <span class="kwrd">string</span> _state;<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> Address(<span class="kwrd">string</span> address1, <span class="kwrd">string</span> city, <span class="kwrd">string</span> state)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_address1 = address1;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_city = city;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_state = state;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">string</span> Address1<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;get { <span class="kwrd">return</span> _address1; }<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">string</span> City<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;get { <span class="kwrd">return</span> _city; }<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">string</span> State<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;get { <span class="kwrd">return</span> _state; }<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">private</span> <span class="kwrd">class</span> ExpandedAddress : Address<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">private</span> <span class="kwrd">readonly</span> <span class="kwrd">string</span> _address2;<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> ExpandedAddress(<span class="kwrd">string</span> address1, <span class="kwrd">string</span> address2, <span class="kwrd">string</span> city, <span class="kwrd">string</span> state)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: <span class="kwrd">base</span>(address1, city, state)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_address2 = address2;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">string</span> Address2<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;get { <span class="kwrd">return</span> _address2; }<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;[Test]<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">void</span> AddressEqualsWorksWithIdenticalAddresses()<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address = <span class="kwrd">new</span> Address(<span class="str">"Address1"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address2 = <span class="kwrd">new</span> Address(<span class="str">"Address1"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.IsTrue(address.Equals(address2));<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;[Test]<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">void</span> AddressEqualsWorksWithNonIdenticalAddresses()<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address = <span class="kwrd">new</span> Address(<span class="str">"Address1"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address2 = <span class="kwrd">new</span> Address(<span class="str">"Address2"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.IsFalse(address.Equals(address2));<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;[Test]<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">void</span> AddressEqualsWorksWithNulls()<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address = <span class="kwrd">new</span> Address(<span class="kwrd">null</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address2 = <span class="kwrd">new</span> Address(<span class="str">"Address2"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.IsFalse(address.Equals(address2));<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;[Test]<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">void</span> AddressEqualsWorksWithNullsOnOtherObject()<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address = <span class="kwrd">new</span> Address(<span class="str">"Address2"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address2 = <span class="kwrd">new</span> Address(<span class="str">"Address2"</span>, <span class="kwrd">null</span>, <span class="str">"TX"</span>);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.IsFalse(address.Equals(address2));<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;[Test]<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">void</span> AddressEqualsIsReflexive()<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address = <span class="kwrd">new</span> Address(<span class="str">"Address1"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.IsTrue(address.Equals(address));<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;[Test]<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">void</span> AddressEqualsIsSymmetric()<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address = <span class="kwrd">new</span> Address(<span class="str">"Address1"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address2 = <span class="kwrd">new</span> Address(<span class="str">"Address2"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.IsFalse(address.Equals(address2));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.IsFalse(address2.Equals(address));<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;[Test]<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">void</span> AddressEqualsIsTransitive()<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address = <span class="kwrd">new</span> Address(<span class="str">"Address1"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address2 = <span class="kwrd">new</span> Address(<span class="str">"Address1"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address3 = <span class="kwrd">new</span> Address(<span class="str">"Address1"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.IsTrue(address.Equals(address2));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.IsTrue(address2.Equals(address3));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.IsTrue(address.Equals(address3));<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;[Test]<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">void</span> AddressOperatorsWork()<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address = <span class="kwrd">new</span> Address(<span class="str">"Address1"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address2 = <span class="kwrd">new</span> Address(<span class="str">"Address1"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address3 = <span class="kwrd">new</span> Address(<span class="str">"Address2"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.IsTrue(address == address2);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.IsTrue(address2 != address3);<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;[Test]<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">void</span> DerivedTypesBehaveCorrectly()<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address = <span class="kwrd">new</span> Address(<span class="str">"Address1"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ExpandedAddress address2 = <span class="kwrd">new</span> ExpandedAddress(<span class="str">"Address1"</span>, <span class="str">"Apt 123"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.IsFalse(address.Equals(address2));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.IsFalse(address == address2);<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;[Test]<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">void</span> EqualValueObjectsHaveSameHashCode()<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address = <span class="kwrd">new</span> Address(<span class="str">"Address1"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address2 = <span class="kwrd">new</span> Address(<span class="str">"Address1"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(address.GetHashCode(), address2.GetHashCode());<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;[Test]<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">void</span> TransposedValuesGiveDifferentHashCodes()<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address = <span class="kwrd">new</span> Address(<span class="kwrd">null</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address2 = <span class="kwrd">new</span> Address(<span class="str">"TX"</span>, <span class="str">"Austin"</span>, <span class="kwrd">null</span>);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreNotEqual(address.GetHashCode(), address2.GetHashCode());<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;[Test]<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">void</span> UnequalValueObjectsHaveDifferentHashCodes()<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address = <span class="kwrd">new</span> Address(<span class="str">"Address1"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address2 = <span class="kwrd">new</span> Address(<span class="str">"Address2"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreNotEqual(address.GetHashCode(), address2.GetHashCode());<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;[Test]<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">void</span> TransposedValuesOfFieldNamesGivesDifferentHashCodes()<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address = <span class="kwrd">new</span> Address(<span class="str">"_city"</span>, <span class="kwrd">null</span>, <span class="kwrd">null</span>);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address address2 = <span class="kwrd">new</span> Address(<span class="kwrd">null</span>, <span class="str">"_address1"</span>, <span class="kwrd">null</span>);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreNotEqual(address.GetHashCode(), address2.GetHashCode());<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;[Test]<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">void</span> DerivedTypesHashCodesBehaveCorrectly()<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ExpandedAddress address = <span class="kwrd">new</span> ExpandedAddress(<span class="str">"Address99999"</span>, <span class="str">"Apt 123"</span>, <span class="str">"New Orleans"</span>, <span class="str">"LA"</span>);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ExpandedAddress address2 = <span class="kwrd">new</span> ExpandedAddress(<span class="str">"Address1"</span>, <span class="str">"Apt 123"</span>, <span class="str">"Austin"</span>, <span class="str">"TX"</span>);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreNotEqual(address.GetHashCode(), address2.GetHashCode());<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
}<br />
</pre>
                        </div>
                        
                        #### **UPDATE: 6/27/07**
                        
                          * Changed ValueObject<T> to implement IEquatable<T> instead of IEquatable<ValueObject<T>> 
                              * Equals reflects derived type instead of base type, since C# generics are not covariant (or contravariant), IEquatable<ValueObject<T>> != IEquatable<T>
                              * Changed GetHashCode algorithm to use&nbsp;a calculated hash to cover additional test cases 
                                  * Gather parent type field values 
                                      * Fix transposed value bug</ul> 
                                      * Fixed NullReferenceException bug when &#8220;other&#8221; is null for IEquatable<T>.Equals 
                                          * Added tests to cover bugs and fixes</ul>