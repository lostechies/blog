---
wordpress_id: 3366
title: Using the Specification Pattern for Querying
date: 2009-09-11T01:58:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2009/09/10/using-the-specification-pattern-for-querying.aspx
dsq_thread_id:
  - "262122441"
categories:
  - Design Patterns
  - Design Principles
  - DRY
  - SOLID
---
The [specification pattern](http://dimecasts.net/Casts/CastDetails/139) is great for adhering to the [Single Responsibility Principle (SRP)](http://en.wikipedia.org/wiki/Single_responsibility_principle). The reason it can be so powerful is that it encapsulates one piece of logic, and nothing more. I&#8217;ve decided to come up with some code that takes advantage of this very easily readable and maintainable code structure.

## **What Is the Specification Pattern**

At the time of writing this, Wikipedia has a pretty good code example for the [Specification Pattern in C#](http://en.wikipedia.org/wiki/Specification_pattern#C.23). I modified this a bit to use generics so that I can use the pattern with any Entity. Here&#8217;s my take:

All of my custom Specifications will derive from the CompositeSpecification. In doing so, whenever I call .And(), .Or(), or .Not() on my object, I&#8217;m returning another specification. This allows me to chain them together to create complex business rules that involve several rules that could be nested toegether.

 <span></span>

My examples will only use Specifications along with my Customer class, but I could use this same pattern with Orders or LineItems if the need arose.

<pre>public interface ISpecification&lt;T&gt;
    {
        bool IsSatisfiedBy(T candidate);
        ISpecification&lt;T&gt; And(ISpecification&lt;T&gt; other);
        ISpecification&lt;T&gt; Or(ISpecification&lt;T&gt; other);
        ISpecification&lt;T&gt; Not();
    }
    public abstract class CompositeSpecification&lt;T&gt; : ISpecification&lt;T&gt;
    {
        public abstract bool IsSatisfiedBy(T candidate);

        public ISpecification&lt;T&gt; And(ISpecification&lt;T&gt; other)</pre>

<pre>{
            return new AndSpecification&lt;T&gt;(this, other);
        }

        public ISpecification&lt;T&gt; Or(ISpecification&lt;T&gt; other)</pre>

<pre>{
            return new OrSpecification&lt;T&gt;(this, other);
        }

        public ISpecification&lt;T&gt; Not()</pre>

<pre>{
            return new NotSpecification&lt;T&gt;(this);
        }
    }
    public class AndSpecification&lt;T&gt; : CompositeSpecification&lt;T&gt;
    {
        private readonly ISpecification&lt;T&gt; left;
        private readonly ISpecification&lt;T&gt; right;

        public AndSpecification(ISpecification&lt;T&gt; left, ISpecification&lt;T&gt; right)
        {
            this.left = left;
            this.right = right;
        }

        public override bool IsSatisfiedBy(T candidate)
        {
            return left.IsSatisfiedBy(candidate) && right.IsSatisfiedBy(candidate);
        }
    }
    public class OrSpecification&lt;T&gt; : CompositeSpecification&lt;T&gt;
    {
        private readonly ISpecification&lt;T&gt; left;
        private readonly ISpecification&lt;T&gt; right;

        public OrSpecification(ISpecification&lt;T&gt; left, ISpecification&lt;T&gt; right)
        {
            this.left = left;
            this.right = right;
        }

        public override bool IsSatisfiedBy(T candidate)
        {
            return left.IsSatisfiedBy(candidate) || right.IsSatisfiedBy(candidate);
        }
    }
    public class NotSpecification&lt;T&gt; : CompositeSpecification&lt;T&gt;
    {
        private readonly ISpecification&lt;T&gt; other;

        public NotSpecification(ISpecification&lt;T&gt; other)
        {
            this.other = other;
        }

        public override bool IsSatisfiedBy(T candidate)
        {
            return !other.IsSatisfiedBy(candidate);
        }
    }<span style="font-size: small"><span>
</span></span></pre>

All of my custom Specifications will derive from the CompositeSpecification. In doing so, whenever I call .And(), .Or(), or .Not() on my object, I&#8217;m returning another specification. This allows me to chain them together to create complex business rules that involve several rules that could be nested toegether.

My examples will only use Specifications along with my Customer class, but I could use this same pattern with Orders or LineItems if the need arose.

## Types of Specifications

In these examples, I&#8217;ve created some customer specifications so that I can query my Customers based on the criteria that the business has set aside as the rules for defining Customer status. I have a Preferred Customer, Gold Customer and Platinum Customer. With these specifications in place, we can even extend our Customer class (with or without extension methods) to determine if they fit the criteria. Again, this keeps our code in one place, so any changes won&#8217;t need to be duplicated across the project.

<pre>public Customer
    {
        public bool IsPreferredCustomer()
        {
            return new PreferredCustomerSpecification().IsSatisfiedBy(this);
        }
    }</pre>

I probably wouldn&#8217;t add this property unless it was needed, but it shows how to keep your business logic for determining a preferred customer in one place.

 <span></span>

The customer status specifications are based on inheritance. You have to meet the previous criteria AND meet some new criteria to be satisfied by the next &#8220;tier&#8221;. These are fairly standard and have the benefit of being easy to write and be very expressive, but have the drawback of being quite inflexible. The other specification in my examples that is a Hard Coded Specification (as seen in [Martin Fowler&#8217;s Specifications paper](http://martinfowler.com/apsupp/spec.pdf)) is the BadCustomerSpecification.

<pre>public class BadCustomerSpecification : CompositeSpecification&lt;Customer&gt;
    {
        public override bool IsSatisfiedBy(Customer entity)
        {
            return (entity.AccountCredit &lt; 0m);
        }
    }</pre>

The SuspiciousCustomerSpecification is a parameterized specification. This can allow for a bit more flexibility than a hard coded specification since you&#8217;re able to pass in some data or objects. While this is a bit more flexible, it still requires special purpose classes.

<pre>public class SuspiciousCustomerSpecification : CompositeSpecification&lt;Customer&gt;
    {
        private readonly IEnumerable&lt;long&gt; suspiciousCustomerIDs;

        public SuspiciousCustomerSpecification(IEnumerable&lt;long&gt; suspiciousCustomerIDs)
        {
            this.suspiciousCustomerIDs = suspiciousCustomerIDs;
        }

        public override bool IsSatisfiedBy(Customer entity)
        {
            return suspiciousCustomerIDs.Contains(entity.ID);
        }
    }</pre>

In the SuspiciousCustomerSpecification we can pass in a list of customers that have been flagged due to activity, or other reasons.

## More Thoughts on Specification Querying

While these examples are a bit more advanced that the typical specification which with I&#8217;ve dealt. There is much, much more that you can do with this design pattern. It&#8217;s important to understand that you shouldn&#8217;t implement a pattern just to do so, use them when the situation fits the pattern that is evolving from the problems you&#8217;re facing. Specifications should adhere to a single rule that matches user voice.

<p style="padding-left: 30px">
  <em>If you can&#8217;t describe it in the user&#8217;s language, you should stop and think about whether or not you&#8217;re over engineering.</em>
</p>

and&#8230;

<p style="padding-left: 30px">
  <em>Staying in user voice makes it easier to ask a user how something in the system SHOULD behave, when you are unsure.</em>
</p>

These two quotes are from a blog post by [Lee Brandt at Codebucket.com](http://codebucket.org/archive/2009/07/06/behavior-driven-development-part-2-of-n-ndash-three-types.aspx) and I they are imperative to creating specifications.