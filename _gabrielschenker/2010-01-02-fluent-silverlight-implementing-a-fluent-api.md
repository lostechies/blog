---
id: 33
title: Fluent Silverlight – Implementing a fluent API
date: 2010-01-02T10:04:00+00:00
author: Gabriel Schenker
layout: post
guid: /blogs/gabrielschenker/archive/2010/01/02/fluent-silverlight-implementing-a-fluent-api.aspx
dsq_thread_id:
  - "263908913"
categories:
  - fluent Silverlight
  - How To
  - introduction
  - Silverlight
  - tutorial
---
Please view the [table of content](http://www.lostechies.com/blogs/gabrielschenker/archive/2010/01/08/fluent-silverlight-table-of-content.aspx) of this series for reference.

## Introduction

Quite some time has passed since we published our [Fluent Silverlight](/blogs/gabrielschenker/archive/2009/06/01/fluent-silverlight-part-1.aspx) framework. In the mean time we have been very busy extending the framework and using it in our internal products. Unfortunately we have been so busy that there was no time left to publish the extension we made. 

Never the less there has been some interest in this framework lately such as that I decided to finally take a spin an bring the current version that we use internally in our company to a level where I can publish it. The updated framework will be published shortly.

Since code alone does not always show the possibilities how to use it I want to second it with a series of short articles.

## A fluent API

A good description on what a fluent API is can be found [here](http://martinfowler.com/bliki/FluentInterface.html). Generally spoken a fluent API makes the code more readable.

In our context we can identify four different categories that we want to define via the fluent interface. 

  * basic property values like strings, numbers, boolean values, dates, etc. 
  * enum type values like Visibility, HorizontalAlignment, BindingMode, etc. 
  * binding dependency properties to properties of the view model 
  * binding events to commands on the view model 

Let me show a simple sample of a fluent API which incorporates the first two categories mentioned above.

<div>
  <div>
    <pre>Car car = <span style="color: #0000ff">new</span> CarExpression()</pre>
    
    <pre>    .Make(<span style="color: #006080">"Kia Sorento"</span>)</pre>
    
    <pre>    .ListPrice(22500)</pre>
    
    <pre>    .Type.SUV()</pre>
    
    <pre>    .Build();</pre></p>
  </div>
</div>

First I create an instance of type CarExpression. Then I define the make and list price of the car which are standard properties of type string and decimal respectively. Next I define the type of the car which is an enum. Finally I tell the CarExpression to build the car with the given settings. The definition of the Car class is just

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Car</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> Make { get; set; }</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">decimal</span> ListPrice { get; set; }</pre>
    
    <pre>    <span style="color: #0000ff">public</span> CarTypes Type { get; set; }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

and the CarTypes enum is defined as follows

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">enum</span> CarTypes</pre>
    
    <pre>{</pre>
    
    <pre>    SportsCar, SUV, MiniVan, Sedan</pre>
    
    <pre>}</pre></p>
  </div>
</div>

having defined these two types I can then start implementing the CarExpression as shown below

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> CarExpression</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">string</span> make;</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">decimal</span> listPrice;</pre>
    
    <pre>    <span style="color: #0000ff">private</span> CarTypes carType;</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> CarExpression Make(<span style="color: #0000ff">string</span> <span style="color: #0000ff">value</span>)</pre>
    
    <pre>    {</pre>
    
    <pre>        make = <span style="color: #0000ff">value</span>;</pre>
    
    <pre>        <span style="color: #0000ff">return</span> <span style="color: #0000ff">this</span>;</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> CarExpression ListPrice(<span style="color: #0000ff">decimal</span> <span style="color: #0000ff">value</span>)</pre>
    
    <pre>    {</pre>
    
    <pre>        listPrice = <span style="color: #0000ff">value</span>;</pre>
    
    <pre>        <span style="color: #0000ff">return</span> <span style="color: #0000ff">this</span>;</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

We can see that for each property of the car that I want to define via the fluent API I have defined an internal field in the CarExpression. For normal properties like Make the definition of the corresponding method in the fluent API is simple. It’s always a method which returns an object of type CarExpression. Thus we will always have a **return this;** statement at the end of the method. Other than that the method just stores the passed in parameter value in the corresponding internal field for future use.

It is the fact that the methods are always returning “**this**” makes it possible to have a fluent interface. 

Enum type properties are a little bit more involved. We have to implement an expression on its own for each enum we want to use in our fluent API. Let me show the code used for the CarTypes enum

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> CarTypeExpression&lt;TParent&gt;</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> TParent parentExpression;</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> Action&lt;CarTypes&gt; action;</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> CarTypeExpression(TParent parentExpression, Action&lt;CarTypes&gt; action)</pre>
    
    <pre>    {</pre>
    
    <pre>        <span style="color: #0000ff">this</span>.parentExpression = parentExpression;</pre>
    
    <pre>        <span style="color: #0000ff">this</span>.action = action;</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> TParent SportsCar()</pre>
    
    <pre>    {</pre>
    
    <pre>        action(CarTypes.SportsCar);</pre>
    
    <pre>        <span style="color: #0000ff">return</span> parentExpression;</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> TParent SUV()</pre>
    
    <pre>    {</pre>
    
    <pre>        action(CarTypes.SUV);</pre>
    
    <pre>        <span style="color: #0000ff">return</span> parentExpression;</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> TParent Sedan()</pre>
    
    <pre>    {</pre>
    
    <pre>        action(CarTypes.Sedan);</pre>
    
    <pre>        <span style="color: #0000ff">return</span> parentExpression;</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> TParent MiniVan()</pre>
    
    <pre>    {</pre>
    
    <pre>        action(CarTypes.MiniVan);</pre>
    
    <pre>        <span style="color: #0000ff">return</span> parentExpression;</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

The points to mention are that the expression is generic. The generic parameter TParent will correspond to the expression in which context this enum expression is going to be used. In our simple sample this will be the CarExpression. The other point to mention is the constructor. The constructor expects 2 parameters, the first being the parent expression inside which this enum expression is used and the second parameter is the action that shall be executed by this enum expression whenever one of its methods is used. The enum expression is only a helper expression and thus must not store any values internally but rather pass selected values back to the parent expression. That is the reason why we have to define this action.

Now let’s have a look a one of those methods of the enum expression. In the first line we use the action mentioned above and pass as a parameter the correct enum value. Then we return the parent expression instance. This is very important! We want to continue working with the car expression once we have selected a car type. If we would instead return “this” then we could only select other types which makes absolutely no sense…

The reason why we have chosen the enum expression to be generic in TParent is that we might want to use an enum expression in different contexts, that is inside different parent expressions. If we are 100% sure that we are only going to use an enum expression inside a single type of expression then we could simplify the above enum expression and make it non-generic.

So let’s now show the missing parts of the car expression

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> CarExpression</pre>
    
    <pre>{</pre>
    
    <pre>    ...</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> CarTypeExpression&lt;CarExpression&gt; Type</pre>
    
    <pre>    {</pre>
    
    <pre>        get{ <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> CarTypeExpression&lt;CarExpression&gt;(<span style="color: #0000ff">this</span>, x =&gt; carType = x);}</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> Car Build()</pre>
    
    <pre>    {</pre>
    
    <pre>        <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> Car {Make = make, ListPrice = listPrice, Type = carType};</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

As you will notice we have implemented the Type as a readonly property and not as a method. Please also note the lamda expression which defines the action we pass to the enum expression

<div>
  <div>
    <pre>x =&gt; carType = x</pre></p>
  </div>
</div>

This lambda expression tells the system to take the parameter that the respective method in the enum expression will pass to the action and assign its value to the field carType of the car expression.

What I do not like in my fluent API that I have defined so far is the fact that I have to call a Build method to tell the expression to build an instance of a car. That seems something unnecessary to me… How can I let the expression know that I want to have my car built without explicitly telling it? Well if I don’t want to tell it explicitly then I have to tell it implicitly. What means do I have to tell something implicitly? Oh yes, i can use operator overloading to define an implicit type cast operation.

Whenever I assign an object of type CarExpression to a variable of type Car the system tries to do an implicit type conversion. If no such conversion is defined the system will throw a TypeCastException. But we can define such an implicit type conversion. In our sample the code needed looks like this

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">implicit</span> <span style="color: #0000ff">operator</span> Car(CarExpression expression)</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> Car</pre>
    
    <pre>               {</pre>
    
    <pre>                   Make = expression.make,</pre>
    
    <pre>                   ListPrice = expression.listPrice,</pre>
    
    <pre>                   Type = expression.carType</pre>
    
    <pre>               };</pre>
    
    <pre>}</pre></p>
  </div>
</div>

We can now update our usage of the expression like shown below

<div>
  <div>
    <pre>Car car = <span style="color: #0000ff">new</span> CarExpression()</pre>
    
    <pre>    .Make(<span style="color: #006080">"Kia Sorento"</span>)</pre>
    
    <pre>    .ListPrice(22500)</pre>
    
    <pre>    .Type.SUV();</pre></p>
  </div>
</div>

This is much more natural than explicitly calling some Build method.