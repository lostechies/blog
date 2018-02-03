---
wordpress_id: 4568
title: Collecting Errors
date: 2008-10-28T15:12:03+00:00
author: Mo Khan
layout: post
wordpress_guid: /blogs/mokhan/archive/2008/10/28/collecting-errors.aspx
categories:
  - Design Patterns
---
Validation is a tough subject. One that I&#8217;m constantly trying to think of better ways of doing. Some suggest that all validation should occur in the domain, and some prefer to check if the object is valid before proceeding. I lean towards the idea of not allowing your objects to enter an invalid state. So far the easiest approach I have found to do this is to raise meaningful exceptions in the domain to ensure this. 

However, when there are several reasons why an object can be considered "invalid" and, those reasons need to be reflected in the UI, I haven&#8217;t been able to figure out a clean way to do this in the domain. Suggestions are welcome.

Here&#8217;s an approach that we&#8217;ve taken to some of our validation, when _user input_ needs to be checked so that we can provide meaningful error messages to the end user.

First we have 2 core validation interfaces:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IValidationResult
</span>{
    <span style="color: blue">bool </span>IsValid { <span style="color: blue">get</span>; }
    <span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: blue">string</span>&gt; BrokenRules { <span style="color: blue">get</span>; }
}</pre>

and

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IValidation</span>&lt;T&gt;
{
    <span style="color: #2b91af">IValidationResult </span>Validate(T item);
}</pre>

The IValidation<T> is in essence a form of a Specification. Now to collect the errors we use a visitor. The following are the core visitor interfaces. 

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IVisitor</span>&lt;T&gt;
{
    <span style="color: blue">void </span>Visit(T item_to_visit);
}</pre>

[](http://11011.net/software/vspaste)

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IValueReturningVisitor</span>&lt;TypeToVisit, TypeToReturn&gt; : <span style="color: #2b91af">IVisitor</span>&lt;TypeToVisit&gt;
{
    <span style="color: blue">void </span>Reset();
    TypeToReturn Result { <span style="color: blue">get</span>; }
}</pre>

We have an implementation of a IValueReturningVisitor that collects errors from visiting IValidations, then returns a validation result. 

<pre><span style="color: blue">public class </span><span style="color: #2b91af">ErrorCollectingVisitor</span>&lt;T&gt; : <span style="color: #2b91af">IValueReturningVisitor</span>&lt;<span style="color: #2b91af">IValidation</span>&lt;T&gt;, <span style="color: #2b91af">IValidationResult</span>&gt;
{
    <span style="color: blue">private readonly </span>T item_to_validate;
    <span style="color: blue">private readonly </span><span style="color: #2b91af">List</span>&lt;<span style="color: blue">string</span>&gt; results;

    <span style="color: blue">public </span>ErrorCollectingVisitor(T item_to_validate)
    {
        <span style="color: blue">this</span>.item_to_validate = item_to_validate;
        results = <span style="color: blue">new </span><span style="color: #2b91af">List</span>&lt;<span style="color: blue">string</span>&gt;();
    }

    <span style="color: blue">public void </span>Visit(<span style="color: #2b91af">IValidation</span>&lt;T&gt; item_to_visit)
    {
        <span style="color: blue">var </span>validation_result = item_to_visit.Validate(item_to_validate);
        <span style="color: blue">if </span>(!validation_result.IsValid)
        {
            results.AddRange(validation_result.BrokenRules);
        }
    }

    <span style="color: blue">public void </span>Reset()
    {
        results.Clear();
    }

    <span style="color: blue">public </span><span style="color: #2b91af">IValidationResult </span>Result
    {
        <span style="color: blue">get </span>{ <span style="color: blue">return new </span><span style="color: #2b91af">ValidationResult</span>(results.Count == 0, results); }
    }
}</pre>

And a handy extension method for returning the value from visiting a set of validations.

<pre><span style="color: blue">public static </span>Result ReturnValueFromVisitingAllItemsWith&lt;TypeToVisit, Result&gt;(
    <span style="color: blue">this </span><span style="color: #2b91af">IEnumerable</span>&lt;TypeToVisit&gt; items_to_visit, <span style="color: #2b91af">IValueReturningVisitor</span>&lt;TypeToVisit, Result&gt; visitor)
{
    visitor.Reset();
    items_to_visit.Each(x =&gt; visitor.Visit(x));
    <span style="color: blue">return </span>visitor.Result;
}</pre>

An example of the usage for the visit can be seen below:

<pre><span style="color: blue">public </span><span style="color: #2b91af">IValidationResult </span>Validate(<span style="color: #2b91af">IUser </span>user)
{
    <span style="color: blue">return </span>userValidations
        .Select(x =&gt; x <span style="color: blue">as </span><span style="color: #2b91af">IValidation</span>&lt;<span style="color: #2b91af">IUser</span>&gt;)
        .ReturnValueFromVisitingAllItemsWith(<span style="color: blue">new </span><span style="color: #2b91af">ErrorCollectingVisitor</span>&lt;<span style="color: #2b91af">IUser</span>&gt;(user));
}</pre>

[](http://11011.net/software/vspaste)