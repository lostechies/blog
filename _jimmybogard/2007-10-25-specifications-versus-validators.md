---
wordpress_id: 87
title: Specifications versus validators
date: 2007-10-25T13:19:42+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/10/25/specifications-versus-validators.aspx
dsq_thread_id:
  - "264715384"
categories:
  - DomainDrivenDesign
  - Patterns
redirect_from: "/blogs/jimmy_bogard/archive/2007/10/25/specifications-versus-validators.aspx/"
---
[Joe](http://www.lostechies.com/blogs/joe_ocampo/) posed a great question on my recent [entity validation post](http://www.lostechies.com/blogs/jimmy_bogard/archive/2007/10/24/entity-validation-with-visitors-and-extension-methods.aspx):

> I question the term Validator in relation to DDD. &nbsp;Since the operation of the Validator seems to be a simple predicate based on business rule shouldn&#8217;t the term Specification [Evans Pg227] be used instead?

On the surface, it would seem that validation does similar actions as specifications, namely that it performs a set of boolean operations to determine if an object matches or not.

For those unfamiliar with the [Specification pattern](http://www.mattberther.com/?p=612), it provides a succinct yet powerful mechanism to match an object against a simple rule.&nbsp; For example, let&#8217;s look at an expanded version of the original Order class on that post:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> Order
{
    <span class="kwrd">public</span> <span class="kwrd">int</span> Id { get; set; }
    <span class="kwrd">public</span> <span class="kwrd">string</span> Customer { get; set; }
    <span class="kwrd">public</span> <span class="kwrd">decimal</span> Total { get; set; }
}
</pre>
</div>

A Specification class is fairly simple, it only has one method that takes the entity as an argument:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">interface</span> ISpecification&lt;T&gt;
{
    <span class="kwrd">bool</span> IsSatisfiedBy(T entity);
}
</pre>
</div>

I can then create specific specifications based on user needs.&nbsp; Let&#8217;s say the business wants to find orders greater than a certain total, but the total can change.&nbsp; Here&#8217;s specification for that:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> OrderTotalSpec : ISpecification&lt;Order&gt;
{
    <span class="kwrd">private</span> <span class="kwrd">readonly</span> <span class="kwrd">decimal</span> _minTotal;

    <span class="kwrd">public</span> OrderTotalSpec(<span class="kwrd">decimal</span> minTotal)
    {
        _minTotal = minTotal;
    }

    <span class="kwrd">public</span> <span class="kwrd">bool</span> IsSatisfiedBy(Order entity)
    {
        <span class="kwrd">return</span> entity.Total &gt;= _minTotal;
    }
}
</pre>
</div>

Specs by themselves aren&#8217;t that useful, but combined with the [Composite pattern](http://www.dofactory.com/Patterns/PatternComposite.aspx), their usefulness really shines:

<div class="CodeFormatContainer">
  <pre><span class="kwrd">public</span> <span class="kwrd">class</span> AndSpec&lt;T&gt; : ISpecification&lt;T&gt;
{
    <span class="kwrd">private</span> <span class="kwrd">readonly</span> List&lt;ISpecification&lt;T&gt;&gt; _augends = <span class="kwrd">new</span> List&lt;ISpecification&lt;T&gt;&gt;();

    <span class="kwrd">public</span> AndSpec(ISpecification&lt;T&gt; augend1, ISpecification&lt;T&gt; augend2) 
    {
        _augends.Add(augend1);
        _augends.Add(augend2);
    }

    <span class="kwrd">public</span> AndSpec(IEnumerable&lt;ISpecification&lt;T&gt;&gt; augends)
    {
        _augends.AddRange(augends);
    }

    <span class="kwrd">public</span> <span class="kwrd">void</span> Add(T augend)
    {
        _augends.Add(augend);
    }

    <span class="kwrd">public</span> <span class="kwrd">bool</span> IsSatisfiedBy(T entity)
    {
        <span class="kwrd">bool</span> isSatisfied = <span class="kwrd">true</span>;
        <span class="kwrd">foreach</span> (var augend <span class="kwrd">in</span> _augends)
        {
            isSatisfied &= augend.IsSatisfiedBy(entity);
        }
        <span class="kwrd">return</span> isSatisfied;
    }
}
</pre>
</div>

Adding an &#8220;OrSpec&#8221; and a &#8220;NotSpec&#8221;&nbsp;allows me to compose some arbitrarily complex specifications, which would otherwise clutter up my repository if I had to make a single search method per combination:

<div class="CodeFormatContainer">
  <pre>OrderRepository repo = <span class="kwrd">new</span> OrderRepository();
var joesOrders = repo.FindBy(
    <span class="kwrd">new</span> AndSpec(
        <span class="kwrd">new</span> OrderTotalSpec(100.0m),
        <span class="kwrd">new</span> NameStartsWithSpec(<span class="str">"Joe"</span>)
    ));
</pre>
</div>

Given the Specification pattern (fleshed out into excruciating detail), why can&#8217;t I compose validation into a set of specifications?&nbsp; Let&#8217;s compare and contrast the two:

**Specification**

  * Matches a single aspect on a single entity 
      * Performs positive matching (i.e., return true if it matches) 
          * Executed against a repository or a collection 
              * Can be composed into an arbitrarily complex search context, where a multitude of specifications compose one search context 
                  * &#8220;I&#8217;m looking for something&#8221;</ul> 
                **Validator**
                
                  * Matches as many aspects as needed on a single entity 
                      * Performs negative matching (i.e., returns false if it matches) 
                          * Executed against a single entity 
                              * Is intentionally not composable, a single validator object&nbsp;represents a single validation context 
                                  * &#8220;I&#8217;m validating this&#8221;</ul> 
                                So although validation and specifications are doing similar boolean operations internally, they have very different contexts on which they are applied.&nbsp; Keeping these separate ensures that your validation concerns don&#8217;t bleed over into your searching concerns.