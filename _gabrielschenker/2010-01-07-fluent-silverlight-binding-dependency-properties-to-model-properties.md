---
id: 36
title: Fluent Silverlight – Binding dependency properties to model properties
date: 2010-01-07T13:47:33+00:00
author: Gabriel Schenker
layout: post
guid: /blogs/gabrielschenker/archive/2010/01/07/fluent-silverlight-binding-dependency-properties-to-model-properties.aspx
dsq_thread_id:
  - "1070207468"
categories:
  - data binding
  - fluent Silverlight
  - introduction
  - Silverlight
---
Please view the [table of content](http://www.lostechies.com/blogs/gabrielschenker/archive/2010/01/08/fluent-silverlight-table-of-content.aspx) of this series for reference.

In my previous posts ([here](http://www.lostechies.com/blogs/gabrielschenker/archive/2010/01/02/fluent-silverlight-implementing-a-fluent-api.aspx) and [here](http://www.lostechies.com/blogs/gabrielschenker/archive/2010/01/03/fluent-silverlight-fluent-api-and-inheritance.aspx)) I discussed how one can build a fluent API for the definition of objects. In the context of Fluent Silverlight these objects are Silverlight controls. With the aid of the expressions we want to define and instantiate controls. But we also want to show some data in the controls like text box, text block, combo box, etc. The data that we want to display is defined in what we call “view model”. We want to use data binding to achieve this goal.

Silverlight defines the necessary infrastructure for data binding that we want to use. To bind a dependency property of a control (e.g. the TextProperty of a text box) to a property of the data context of the view in which the textbox is defined we use the following code

<div>
  <div>
    <pre>var firstName = <span style="color: #0000ff">new</span> TextBox{ Width = 100 };</pre>
    
    <pre>var binding = <span style="color: #0000ff">new</span> Binding(<span style="color: #006080">"FirstName"</span>) {Mode = BindingMode.TwoWay};</pre>
    
    <pre>firstName.SetBinding(TextBox.TextProperty, binding);</pre></p>
  </div>
</div>

In the above sample we bind the text property of the textbox to the property named FirstName of the data context of the view. The binding is two way, that is if either side of the link is changed then the other side is automatically updated.

Now I’d prefer to have a fluent API to create textbox controls for me where I can express my intent to bind certain dependency properties to properties on the view model with the aid of lambda expressions. I want to have something like this

<div>
  <div>
    <pre>TextBox lastName = <span style="color: #0000ff">new</span> TextBoxExpression&lt;ViewModel&gt;(m =&gt; m.LastName);</pre></p>
  </div>
</div>

the result will be the same as in the first sample but the syntax is much cleaner and concise. We use a lambda expression <font face="Courier New">m => m.LastName</font> to define the binding in an intellisense-friendly and type-safe manner. The model is defined as

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> ViewModel</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> LastName { get; set; }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

and the expression itself is defined like this

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> TextBoxExpression&lt;TModel&gt;</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">private</span> Expression&lt;Func&lt;TModel, <span style="color: #0000ff">object</span>&gt;&gt; textExpression;</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> TextBoxExpression(Expression&lt;Func&lt;TModel, <span style="color: #0000ff">object</span>&gt;&gt; expressions)</pre>
    
    <pre>    {</pre>
    
    <pre>        textExpression = expressions;</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">protected</span> <span style="color: #0000ff">virtual</span> <span style="color: #0000ff">void</span> BuildUp(TextBox element)</pre>
    
    <pre>    {</pre>
    
    <pre>        var accessor = textExpression.GetAccessor();</pre>
    
    <pre>        var binding = <span style="color: #0000ff">new</span> Binding(accessor.Name);</pre>
    
    <pre>        element.SetBinding(TextBox.TextProperty, binding);</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">implicit</span> <span style="color: #0000ff">operator</span> TextBox(TextBoxExpression&lt;TModel&gt; expression)</pre>
    
    <pre>    {</pre>
    
    <pre>        var element = <span style="color: #0000ff">new</span> TextBox();</pre>
    
    <pre>        expression.BuildUp(element);</pre>
    
    <pre>        <span style="color: #0000ff">return</span> element;</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

Please note that we use LINQ expressions and not just lambda functions to define the binding. This is necessary such as that we can use the meta data of the expression to define the binding. The method GetAccessor is an extension method for our LINQ expressions. The function uses the expression to retrieve important type information. The path for the binding is then just the name of the accessor returned by the extension method. I will talk more about this helper method in my next post.

We can add more methods to our fluent API to define bindings for more dependency properties. The usage will then be like this

<div>
  <div>
    <pre>TextBox lastName = <span style="color: #0000ff">new</span> TextBoxExpression&lt;ViewModel&gt;(m =&gt; m.LastName)</pre>
    
    <pre>                            .IsReadOnly(m =&gt; m.LastNameIsReadOnly)</pre>
    
    <pre>                            .Visibility(m =&gt; m.LastNameVisibility);</pre></p>
  </div>
</div>

the view model has two new properties

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> ViewModel</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> LastName { get; set; }</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> LastNameIsReadOnly { get; set; }</pre>
    
    <pre>    <span style="color: #0000ff">public</span> Visibility LastNameVisibility { get; set; }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

_**Remarks**: the view model, as it is defined above cannot participate in a two-way data binding since it is not implementing the **INotifyPropertyChanged** interface. However this topic I will address in a subsequent post where I will show you how we provide our view model this necessary functionality in a AOP way._

The textbox expression contains these new and extended methods

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> TextBoxExpression&lt;TModel&gt; IsReadOnly(Expression&lt;Func&lt;TModel, <span style="color: #0000ff">object</span>&gt;&gt; expression)</pre>
    
    <pre>{</pre>
    
    <pre>    isReadOnlyExpression = expression;</pre>
    
    <pre>    <span style="color: #0000ff">return</span> <span style="color: #0000ff">this</span>;</pre>
    
    <pre>}</pre>
    
    <pre>&#160;</pre>
    
    <pre><span style="color: #0000ff">public</span> TextBoxExpression&lt;TModel&gt; Visibility(Expression&lt;Func&lt;TModel, <span style="color: #0000ff">object</span>&gt;&gt; expression)</pre>
    
    <pre>{</pre>
    
    <pre>    visibilityExpression = expression;</pre>
    
    <pre>    <span style="color: #0000ff">return</span> <span style="color: #0000ff">this</span>;</pre>
    
    <pre>}</pre>
    
    <pre>&#160;</pre>
    
    <pre><span style="color: #0000ff">protected</span> <span style="color: #0000ff">virtual</span> <span style="color: #0000ff">void</span> BuildUp(TextBox element)</pre>
    
    <pre>{</pre>
    
    <pre>    var accessor = textExpression.GetAccessor();</pre>
    
    <pre>    var binding = <span style="color: #0000ff">new</span> Binding(accessor.Name);</pre>
    
    <pre>    element.SetBinding(TextBox.TextProperty, binding);</pre>
    
    <pre>&#160;</pre>
    
    <pre>    var accessor2 = isReadOnlyExpression.GetAccessor();</pre>
    
    <pre>    var binding2 = <span style="color: #0000ff">new</span> Binding(accessor2.Name);</pre>
    
    <pre>    element.SetBinding(TextBox.IsReadOnlyProperty, binding2);</pre>
    
    <pre>&#160;</pre>
    
    <pre>    var accessor3 = visibilityExpression.GetAccessor();</pre>
    
    <pre>    var binding3 = <span style="color: #0000ff">new</span> Binding(accessor3.Name);</pre>
    
    <pre>    element.SetBinding(TextBox.VisibilityProperty, binding3);</pre>
    
    <pre>}</pre></p>
  </div>
</div>

One thing that should be evident is that in the BuildUp method we have a lot of repetitive code. It would be nice if we could simplify this code and make it more concise. Why not create a fluent API to define a binding? The result could be this</p> </p> </p> </p> 

<div>
  <div>
    <pre><span style="color: #0000ff">using</span> (var binder = <span style="color: #0000ff">new</span> PropertyBinder&lt;TModel&gt;(element))</pre>
    
    <pre>{</pre>
    
    <pre>    binder.DependencyProperty(TextBox.TextProperty).BindTo(textExpression).Mode(BindingMode.TwoWay);</pre>
    
    <pre>    binder.DependencyProperty(TextBox.IsReadOnlyProperty).BindTo(isReadOnlyExpression);</pre>
    
    <pre>    binder.DependencyProperty(TextBox.VisibilityProperty).BindTo(visibilityExpression);</pre>
    
    <pre>}</pre></p>
  </div>
</div>

again a step in the right direction towards better readability! The definition of this new fluent API is shown below.

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> PropertyBinder&lt;TModel&gt; : IPropertyBinderExpression&lt;TModel&gt;, IDisposable</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">bool</span> elementHasBeenBound;</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> FrameworkElement element;</pre>
    
    <pre>    <span style="color: #0000ff">private</span> BindingInfo current;</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> List&lt;BindingInfo&gt; bindingInfos;</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> PropertyBinder(FrameworkElement element)</pre>
    
    <pre>    {</pre>
    
    <pre>        <span style="color: #0000ff">this</span>.element = element;</pre>
    
    <pre>        bindingInfos = <span style="color: #0000ff">new</span> List&lt;BindingInfo&gt;();</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> IPropertyBinderExpression&lt;TModel&gt; DependencyProperty(DependencyProperty dp)</pre>
    
    <pre>    {</pre>
    
    <pre>        current = <span style="color: #0000ff">new</span> BindingInfo { DependencyProperty = dp };</pre>
    
    <pre>        bindingInfos.Add(current);</pre>
    
    <pre>        <span style="color: #0000ff">return</span> <span style="color: #0000ff">this</span>;</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    IPropertyBinderExpression&lt;TModel&gt; IPropertyBinderExpression&lt;TModel&gt;.BindTo(Expression&lt;Func&lt;TModel, <span style="color: #0000ff">object</span>&gt;&gt; expression)</pre>
    
    <pre>    {</pre>
    
    <pre>        current.Expression = expression;</pre>
    
    <pre>        <span style="color: #0000ff">return</span> <span style="color: #0000ff">this</span>;</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    IPropertyBinderExpression&lt;TModel&gt; IPropertyBinderExpression&lt;TModel&gt;.Mode(BindingMode mode)</pre>
    
    <pre>    {</pre>
    
    <pre>        current.Mode = mode;</pre>
    
    <pre>        <span style="color: #0000ff">return</span> <span style="color: #0000ff">this</span>;</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Bind()</pre>
    
    <pre>    {</pre>
    
    <pre>        <span style="color: #0000ff">if</span>(elementHasBeenBound)</pre>
    
    <pre>            <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> InvalidOperationException(<span style="color: #006080">"Binding for this control has already been setup."</span>);</pre>
    
    <pre>&#160;</pre>
    
    <pre>        <span style="color: #0000ff">foreach</span> (var info <span style="color: #0000ff">in</span> bindingInfos)</pre>
    
    <pre>        {</pre>
    
    <pre>            var binding = <span style="color: #0000ff">new</span> Binding(info.Expression.GetAccessor().Name);</pre>
    
    <pre>            <span style="color: #0000ff">if</span> (info.Mode.HasValue) binding.Mode = info.Mode.Value;</pre>
    
    <pre>            element.SetBinding(info.DependencyProperty, binding);</pre>
    
    <pre>        }</pre>
    
    <pre>&#160;</pre>
    
    <pre>        elementHasBeenBound = <span style="color: #0000ff">true</span>;</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Dispose()</pre>
    
    <pre>    {</pre>
    
    <pre>        Bind();</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">class</span> BindingInfo</pre>
    
    <pre>    {</pre>
    
    <pre>        <span style="color: #0000ff">public</span> DependencyProperty DependencyProperty;</pre>
    
    <pre>        <span style="color: #0000ff">public</span> Expression&lt;Func&lt;TModel, <span style="color: #0000ff">object</span>&gt;&gt; Expression;</pre>
    
    <pre>        <span style="color: #0000ff">public</span> BindingMode? Mode { get; set; }</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

and the interface implemented by the above class is

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IPropertyBinderExpression&lt;TModel&gt;</pre>
    
    <pre>{</pre>
    
    <pre>    IPropertyBinderExpression&lt;TModel&gt; BindTo(Expression&lt;Func&lt;TModel, <span style="color: #0000ff">object</span>&gt;&gt; expression);</pre>
    
    <pre>    IPropertyBinderExpression&lt;TModel&gt; Mode(BindingMode mode);</pre>
    
    <pre>}</pre></p>
  </div>
</div>

To be able to use the nice using-syntax the property binder class implements the **IDisposable** interface. The implementation of the **Dispose** method then just calls the **Bind** method of the class. In the **Bind** method the whole bindings are executed. This method has been guarded such as that it can only be called once otherwise an exception is thrown.

Note that in my private class **BindingInfo** I have defined the field Mode as **BindingMode**? and NOT as **BindingMode**. This makes it easy for me to detect whether the user has set the binding mode or not when defining the binding for a dependency property.

Now if we need more functionality regarding binding we can just extend our fluent API, that is our property binder class. One scenario that comes to mind is the usage of value converters. For this case we can just add another method to the fluent API

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> IPropertyBinderExpression&lt;TModel&gt; WithValueConverter&lt;TConverter&gt;()</pre>
    
    <pre>    <span style="color: #0000ff">where</span> TConverter : IValueConverter, <span style="color: #0000ff">new</span>()</pre>
    
    <pre>{</pre>
    
    <pre>    current.ValueConverter = <span style="color: #0000ff">new</span> TConverter();</pre>
    
    <pre>    <span style="color: #0000ff">return</span> <span style="color: #0000ff">this</span>;</pre>
    
    <pre>}</pre></p>
  </div>
</div>

the BindingInfo class has an additional field

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> IValueConverter ValueConverter;</pre></p>
  </div>
</div>

and the Bind method contains this additional statement

<div>
  <div>
    <pre><span style="color: #0000ff">if</span> (info.ValueConverter != <span style="color: #0000ff">null</span>) binding.Converter = info.ValueConverter;</pre></p>
  </div>
</div>

In my next post I will explain the code we use to extract the needed meta information from a given lambda expression.