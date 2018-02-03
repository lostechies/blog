---
wordpress_id: 25
title: Fluent Silverlight – Part 2 – Binding Properties
date: 2009-06-01T21:22:26+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: /blogs/gabrielschenker/archive/2009/06/02/fluent-silverlight-part-2-binding-properties.aspx
dsq_thread_id:
  - "263908891"
categories:
  - data binding
  - fluent Silverlight
  - MVVM pattern
---
## Introduction

After having introduced the new Fluent Silverlight framework in [part 1](http://www.lostechies.com/blogs/gabrielschenker/archive/2009/06/01/fluent-silverlight-part-1.aspx) it is now time to dig a little bit deeper and discuss some implementation details. This time I’ll have a look into the details how we bind a property of a Silverlight control to a view model property.

As a reaction on our first post we have been asked why we prefer to define the binding in code rather than in XAML. We have different reasons for doing so. First of all we want to get rid of XAML as much as possible. Our application has a rather specific UI. The UI is hierarchical and highly dynamical. It’s not the type of UI one typically designs with tools like Microsoft Blend. Another reason is that XAML is not really wrist friendly and one defines the binding in XAML then one has to use a lot of “magic strings” and thus we have no compile time support regarding the correctness of the binding.

## Binding Properties

We want to be able to bind specific properties of a Silverlight control to a property exposed by the view model. The binding shall be defined with a lambda expression and NOT with “magic strings”. We are using C# as our language which is a static typed language and thus want to leverage as much as possible the possibilities that a statically typed language offers. Typically we bind the **Text** property of a TextBox or a TextBlock to a corresponding property of the view model. This binding is defined in the view and is similar to this

<div>
  <pre><span style="color: #0000ff">this</span>.WithTextBox(txtUsername)</pre>
  
  <pre>    .Text(m =&gt; m.UserName)</pre>
</div>

To give a few other examples we can also e.g. bind the **IsChecked** property of a CheckBox or the **Source** property of an Image in a similar way to a respective view model property.

But not only business relevant data can or will be bound to controls like this but also other properties defining the visibility and interactability of a control can be bound. As an example take this code snippet

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Initialize()</pre>
    
    <pre>{</pre>
    
    <pre>    plainText = <span style="color: #0000ff">this</span>.TextBoxFor(m =&gt; m.TextAnswer)</pre>
    
    <pre>        .Interactable(m =&gt; m.TextAnswerInteractable)</pre>
    
    <pre>        .Visible(m =&gt; m.TextAnswerVisible)</pre>
    
    <pre>        .Watermark(m =&gt; m.TextAnswerWatermark)</pre>
    
    <pre>        .VerticalAlignment.Top()</pre>
    
    <pre>        .HorizontalAlignment.Stretch();</pre>
    
    <pre>&#160;</pre>
    
    <pre>    Content = plainText;</pre>
    
    <pre>}</pre></p>
  </div>
</div>

In this sample besides the **Text** property we also bound the **IsReadOnly** and the **Visibility** properties of the TextBox to respective model properties. We even have something called **Watermark** which defines the text that is displayed in the TextBox if its content is empty and it does not currently have the focus.

The Visibility property of a Silverlight control is special in the sense that it is not of type boolean (that is visible = true or false) as one would naively expect but rather of type Visibility which is an enum defining the two values Visible and Collapsed. In a (view) model we rather prefer a property of type boolean to represent the fact whether a control displaying a certain business value is visible or not. Thus we need some kind of conversion happening when binding the control to the model. Fortunately the data binding used by Silverlight offers the possibility to defined so called value converters. The details of such a value converter are discussed in the next section.

**Note**: the visibility and interactability of a control displaying a business value is not a pure UI concern but rather determined by the given context. Part of the context are (among others) the current users rights.

### Defining a custom value converter</p> 

To create a custom value converter we have to implement a class that implements the interface **IValueConverter**. This interface has two methods **Convert**(…) and **ConvertBack**(…). We want to convert a value of type **boolean** to a value of type **Visibility** and vice versa. So the implementation is very simple and is given below

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> BooleanToVisibilityConverter : IValueConverter</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">object</span> Convert(<span style="color: #0000ff">object</span> <span style="color: #0000ff">value</span>, Type targetType, <span style="color: #0000ff">object</span> parameter, CultureInfo culture)</pre>
    
    <pre>    {</pre>
    
    <pre>        <span style="color: #0000ff">if</span>(<span style="color: #0000ff">value</span> == <span style="color: #0000ff">null</span>) <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> ArgumentException(<span style="color: #006080">"Cannot convert a null value to a visibility!"</span>);</pre>
    
    <pre>&#160;</pre>
    
    <pre>        var sourceType = <span style="color: #0000ff">value</span>.GetType();</pre>
    
    <pre>        <span style="color: #0000ff">if</span> (!(sourceType.Equals(<span style="color: #0000ff">typeof</span>(<span style="color: #0000ff">bool</span>)) && targetType.Equals(<span style="color: #0000ff">typeof</span>(Visibility))))</pre>
    
    <pre>            <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> ArgumentException(</pre>
    
    <pre>                <span style="color: #0000ff">string</span>.Format(<span style="color: #006080">"Cannot convert type '{0}' to '{1}'. Only can convert boolean to Visibility."</span>, </pre>
    
    <pre>                              sourceType.Name, targetType.Name));</pre>
    
    <pre>&#160;</pre>
    
    <pre>        <span style="color: #0000ff">return</span> (<span style="color: #0000ff">bool</span>) <span style="color: #0000ff">value</span> ? Visibility.Visible : Visibility.Collapsed;</pre>
    
    <pre>        </pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">object</span> ConvertBack(<span style="color: #0000ff">object</span> <span style="color: #0000ff">value</span>, Type targetType, <span style="color: #0000ff">object</span> parameter, CultureInfo culture)</pre>
    
    <pre>    {</pre>
    
    <pre>        <span style="color: #0000ff">if</span>(<span style="color: #0000ff">value</span> == <span style="color: #0000ff">null</span>) <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> ArgumentException(<span style="color: #006080">"Cannot back convert a null value to a boolean!"</span>);</pre>
    
    <pre>&#160;</pre>
    
    <pre>        var sourceType = <span style="color: #0000ff">value</span>.GetType();</pre>
    
    <pre>        <span style="color: #0000ff">if</span> (!(sourceType.Equals(<span style="color: #0000ff">typeof</span>(Visibility)) && targetType.Equals(<span style="color: #0000ff">typeof</span>(<span style="color: #0000ff">bool</span>))))</pre>
    
    <pre>            <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> ArgumentException(</pre>
    
    <pre>                <span style="color: #0000ff">string</span>.Format(<span style="color: #006080">"Cannot convert type '{0}' to '{1}'. Only can convert Visibility to boolean."</span>, </pre>
    
    <pre>                              sourceType.Name, targetType.Name));</pre>
    
    <pre>&#160;</pre>
    
    <pre>        <span style="color: #0000ff">return</span> (Visibility) <span style="color: #0000ff">value</span> == Visibility.Visible;</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

most of the above code is actually just there to prevent errors. The real meat is in the line

<div>
  <div>
    <pre><span style="color: #0000ff">return</span> (<span style="color: #0000ff">bool</span>) <span style="color: #0000ff">value</span> ? Visibility.Visible : Visibility.Collapsed;</pre></p>
  </div>
</div>

that converts a boolean value to a corresponding Visibility; and in this line

<div>
  <div>
    <pre><span style="color: #0000ff">return</span> (Visibility) <span style="color: #0000ff">value</span> == Visibility.Visible;</pre></p>
  </div>
</div>

which converts a Visibility back to a boolean value.

The above class can now used to e.g. bind the property UserNameIsVisible (bool) of the view model to the Visibility property of a Silverlight control (element) as follows</p> 

<div>
  <div>
    <pre>var binding = <span style="color: #0000ff">new</span> Binding(<span style="color: #006080">"UserNameIsVisible"</span>) { Mode = BindingMode.OneTime };</pre>
    
    <pre>binding.Converter = <span style="color: #0000ff">new</span> BooleanToVisibilityConverter();</pre>
    
    <pre>element.SetBinding(UIElement.Visibility, binding);                </pre></p>
  </div>
</div>

### The PropertyBinder helper class

Since we want to bind different properties of controls to the various properties of the view model we wanted to handle the intrinsic of the binding in one single place. Born was the **PropertyBinder** class. To define a binding we need 3 elements: 

  * the name of the property of the view model to which we want to bind, 
  * the property of the control which shall be bound and 
  * the binding mode (OneTime, OneWay or TwoWay). 

This leads us to the following method signature

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SetBinding(Expression&lt;Func&lt;TModel, <span style="color: #0000ff">object</span>&gt;&gt; expression, </pre>
    
    <pre>                       DependencyProperty property, </pre>
    
    <pre>                       BindingMode bindingMode)</pre>
    
    <pre>{...}</pre></p>
  </div>
</div>

The first parameter is a lambda expression and defines the name of the view model property to which we want to bind our control. From time to time we also need a custom value converter when binding a property. As a sample take the Visibility property discussed above. Thus we define an overload of the SetBinding method

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SetBinding(Expression&lt;Func&lt;TModel, <span style="color: #0000ff">object</span>&gt;&gt; expression, </pre>
    
    <pre>                       DependencyProperty property,</pre>
    
    <pre>                       BindingMode bindingMode, </pre>
    
    <pre>                       IValueConverter valueConverter)</pre>
    
    <pre>{...}</pre></p>
  </div>
</div>

The former method will call the latter one and just pass null at the place of the value converter. This leads us to the following implementation

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> PropertyBinder&lt;TModel&gt; <span style="color: #0000ff">where</span> TModel : <span style="color: #0000ff">class</span></pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> FrameworkElement element;</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> PropertyBinder(FrameworkElement element)</pre>
    
    <pre>    {</pre>
    
    <pre>        <span style="color: #0000ff">this</span>.element = element;</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SetBinding(Expression&lt;Func&lt;TModel, <span style="color: #0000ff">object</span>&gt;&gt; expression, DependencyProperty property)</pre>
    
    <pre>    {</pre>
    
    <pre>        SetBinding(expression, property, BindingMode.OneWay);</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SetBinding(Expression&lt;Func&lt;TModel, <span style="color: #0000ff">object</span>&gt;&gt; expression, DependencyProperty property, BindingMode bindingMode)</pre>
    
    <pre>    {</pre>
    
    <pre>        SetBinding(expression, property, bindingMode, <span style="color: #0000ff">null</span>);</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SetBinding(Expression&lt;Func&lt;TModel, <span style="color: #0000ff">object</span>&gt;&gt; expression, DependencyProperty property,</pre>
    
    <pre>                           BindingMode bindingMode, IValueConverter valueConverter)</pre>
    
    <pre>    {</pre>
    
    <pre>        var accessor = ReflectionHelper.GetAccessor(expression);</pre>
    
    <pre>&#160;</pre>
    
    <pre>        var binding = <span style="color: #0000ff">new</span> Binding(accessor.Name) { Mode = bindingMode };</pre>
    
    <pre>        <span style="color: #0000ff">if</span> (valueConverter != <span style="color: #0000ff">null</span>) binding.Converter = valueConverter;</pre>
    
    <pre>&#160;</pre>
    
    <pre>        element.SetBinding(property, binding);</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

Note that the name of the view model property which is described by the lambda expression is extracted from the expression with the aid of the **ReflectionHelper** utility class. This class we have “stolen” from the **FuBu MVC** project. 

The above class will be heavily used by the rest of the framework.

### The TextBoxBinder class – or – how to bind a property

Now that we have discussed the goals and paved the ground by defining the necessary utility or helper classes we finally want to define the logic needed to make this nice fluent interface possible that I showed above as well as in [part 1](http://www.lostechies.com/blogs/gabrielschenker/archive/2009/06/01/fluent-silverlight-part-1.aspx) of this article series.

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> TextBoxBinder&lt;TModel&gt; : ControlBinder&lt;TextBoxBinder&lt;TModel&gt;, TextBox, TModel&gt; </pre>
    
    <pre>    <span style="color: #0000ff">where</span> TModel : <span style="color: #0000ff">class</span></pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">public</span> TextBoxBinder(TModel model, TextBox control)</pre>
    
    <pre>        : <span style="color: #0000ff">base</span>(model, control)</pre>
    
    <pre>    {</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> TextBoxBinder&lt;TModel&gt; Text(Expression&lt;Func&lt;TModel, <span style="color: #0000ff">object</span>&gt;&gt; expression)</pre>
    
    <pre>    {</pre>
    
    <pre>        propertyBinder.SetBinding(expression, TextBox.TextProperty, BindingMode.TwoWay);</pre>
    
    <pre>        <span style="color: #0000ff">return</span> <span style="color: #0000ff">this</span>;</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #008000">// rest of code omitted for brevity...</span></pre>
    
    <pre>}</pre></p>
  </div>
</div>

In the constructor of the above class I have to pass the instance of the view model I want to bind to as well as the control which shall be bound. The class inherits from a **ControlBinder** which in turn inherits from a **FrameworkElementBinder**. The binder classes plus or minus copy the hierarchy of the controls. But I will discuss this in more detail in a subsequent post.

For the moment lets concentrate on the **Text**(…) method of the above class. The only parameter of the method is the lambda expression which defines to which model property I want to bind. I use the PropertyBinder class discussed above to define the binding. And then I just return **this** to make the fluent interface possible.

### The view

The code behind of a XAML based user control looks similar to this

<div>
  <div>
    <div>
      <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">partial</span> <span style="color: #0000ff">class</span> SampleView : IOpinionatedControl&lt;SampleViewModel&gt;</pre>
      
      <pre>{</pre>
      
      <pre>    <span style="color: #0000ff">public</span> SampleView()</pre>
      
      <pre>    {</pre>
      
      <pre>        InitializeComponent();</pre>
      
      <pre>    }</pre>
      
      <pre>&#160;</pre>
      
      <pre>    <span style="color: #0000ff">public</span> SampleViewModel Model</pre>
      
      <pre>    {</pre>
      
      <pre>        get { <span style="color: #0000ff">return</span> DataContext <span style="color: #0000ff">as</span> SampleViewModel; }</pre>
      
      <pre>    }</pre>
      
      <pre>&#160;</pre>
      
      <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SetModel(IViewModel viewModel)</pre>
      
      <pre>    {</pre>
      
      <pre>        DataContext = viewModel;</pre>
      
      <pre>    }</pre>
      
      <pre>&#160;</pre>
      
      <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Initialize()</pre>
      
      <pre>    {...}</pre>
      
      <pre>}</pre></p>
    </div></p>
  </div>
</div>

In the **Initialize**() method one would normally implement the code to bind the controls to the view model. That is code like this

<div>
  <pre><span style="color: #0000ff">this</span>.WithTextBox(txtUsername)</pre>
  
  <pre>    .Text(m =&gt; m.UserName)</pre>
</div>

Note that the user control (or let’s just call it view in the future) implements the generic interface **IOpinionatedControl<TModel>** where in this case the generic parameter **TModel** is equal to the view model **SampleViewModel**. This interface is defined as follows

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IOpinionatedControl&lt;TModel&gt; : IOpinionatedControl</pre>
    
    <pre>    <span style="color: #0000ff">where</span> TModel : <span style="color: #0000ff">class</span></pre>
    
    <pre>{</pre>
    
    <pre>    TModel Model { get; }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

and it inherits from this interface

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IOpinionatedControl</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">void</span> SetModel(IViewModel viewModel);</pre>
    
    <pre>    <span style="color: #0000ff">void</span> Initialize();</pre>
    
    <pre>}</pre></p>
  </div>
</div>

which is its non generic variant.

### Extension methods for the view

To permit us to easily create a TextBoxBinder instance for a given TextBox we now define extension methods for our views. Since all of our views implement the generic interface **IOpinionatedControl<TModel>** described above we will write the extension methods for objects which implement this interface.

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">class</span> ControlBinderViewExtensions</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> TextBoxBinder&lt;TModel&gt; WithTextBox&lt;TModel&gt;(<span style="color: #0000ff">this</span> IOpinionatedControl&lt;TModel&gt; view, TextBox control)</pre>
    
    <pre>        <span style="color: #0000ff">where</span> TModel : <span style="color: #0000ff">class</span></pre>
    
    <pre>    {</pre>
    
    <pre>        <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> TextBoxBinder&lt;TModel&gt;(view.Model, control);</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

Note that the TextBoxBinder constructor expects the model as a first parameter. We have access to the view model via the view. We can then implement an additional extension method for each type of control we want to use.</p> 

## Summary

In this post I have discussed the details how we bind a property of a Silverlight control to a property of the view model. The binding is declared via a lambda expression. A binding can optionally also contain a value converter to adapt UI specific types to more (view) model friendly types. As an example I have shown how we adapt the Visibility data type which is specific to Silverlight (and WPF) to the data type boolean which makes more sense in a model.