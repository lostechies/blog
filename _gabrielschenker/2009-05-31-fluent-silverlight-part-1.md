---
wordpress_id: 24
title: Fluent Silverlight – Part 1
date: 2009-05-31T21:47:01+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: /blogs/gabrielschenker/archive/2009/06/01/fluent-silverlight-part-1.aspx
dsq_thread_id:
  - "264368714"
categories:
  - fluent Silverlight
  - introduction
  - Lambda Expressions
  - Patterns
  - practices
  - reflection
redirect_from: "/blogs/gabrielschenker/archive/2009/06/01/fluent-silverlight-part-1.aspx/"
---
## Introduction

We (that is [Ray Houston](https://lostechies.com/blogs/rhouston) and myself) want to introduce a new framework we developed in the past few months. This framework provides a fluent interface to [Microsoft Silverlight](http://www.silverlight.net). As we have been able to leverage a lot of OSS software in the past we found that it is time to give something back to the community too. This was the birth of the OSS project we call **“Fluent Silverlight”**. The code is publicly available and is hosted by Google Code. It can be found [here](http://code.google.com/p/fluent-silverlight/).

## Motivation

This past year our company developed a Silverlight client for our .NET web application. The Silverlight code base has grown quite large and we&#8217;ve started trying to improve some of our biggest pain points. One of the biggest that we&#8217;ve faced, is our implementation Model-View-Presenter (MVP). We ended up with a lot of "ping-pong" communication between the view and the presenter. 

We had a lot of code that: 

  * An event would happen on the view, 
  * be handled in the “code behind” of the view and tell the presenter, 
  * the presenter would make a decision and may tell the view to do something else
  * possibily repeat the whole cycle.

We tried creating tests, but they only really tested interactions and didn&#8217;t test the true intent of the view. They only verified that "yes, we have an implementation" and did not test that the view was working as a whole. We didn&#8217;t feel as if we were getting a good return on investment with the MVP tests, so we ultimately stopped writing them   
and just relied on integration tests to check the functionality. 

As we began to trust data binding in Silverlight (we had been burned in the past and we did not have any prior WCF experience), we started to look at Model-View-View Model (MVVM) as an alternative. We really like the strongly-type declarative style of [Fluent NHibernate](http://fluentnhibernate.org/) and [FuBu MVC](http://code.google.com/p/fubumvc/), so we tried to see if we could do something similar with   
Silverlight and MVVM. 

Fluent Silverlight is an attempt to make MVVM easier by using a fluent interface with strongly-typed reflection to define controls and bindings and avoid the XAML based "wiring" of the view to the view model. It hides the implementation details so that they are allowed to change without changing the view&#160; or the view models they are bound to. An example would be the way it hides the ugly event handlers and allows you to associate controls events directly to commands on the model.

This will be a multi-part post series. In this first part we want to introduce some of the basic concepts of our new framework. Especially we want to show how a user control can be bound to a view model.

## The Model-View-View Model Pattern

The model-view-view model pattern (MVVM) is often used when building WPF or Silverlight applications. We decided to use it as the primary pattern in our framework. The MVVM pattern is a variant of the MVP pattern. A good introduction into the MVVM can be found [here](http://msdn.microsoft.com/en-us/magazine/dd419663.aspx).

### The view model

The view binds to properties on a ViewModel, which, in turn, exposes data contained in model objects and other state specific to the view. The bindings between view and ViewModel are simple to construct because a ViewModel object is set as the DataContext of a view. If property values in the ViewModel change, those new values automatically propagate to the view via data binding.

The view model contains all the data a view needs for display. A view model in contradiction to a domain model can also expose display relevant properties. Examples of such properties are whether the content of e.g. UserName should be read only or not or whether a specific control displaying the content of a property should be visible or not in a certain context.

But the view model is not only a data container. Since it is a variant of a presenter it also contains behavior. It coordinates between the view, the (domain) model and the (backend-) services. As an important example it exposes commands that can be bound to an event of a control on the view.

Since data binding is used to update the controls on the view the view model must implement the **INotifyPropertyChanged** interface. Since every view model has to do this and since we wanted to keep or code DRY we decided to define a base view model class from which all other view models have to inherit.

#### Properties

We have been able to build an infrastructure such as that our ViewModel is very slick. Although we implement the **INotifyPropertyChanged** interface to make data binding possible we only need to implement each property as auto property in our ViewModel. Normally when implementing the said interface the code of a property looks similar to this

<div>
  <div>
    <pre><span style="color: #0000ff">private</span> <span style="color: #0000ff">string</span> userName;</pre>
    
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> UserName</pre>
    
    <pre>{</pre>
    
    <pre>    get { <span style="color: #0000ff">return</span> userName; }</pre>
    
    <pre>    set</pre>
    
    <pre>    {</pre>
    
    <pre>        <span style="color: #0000ff">if</span>(<span style="color: #0000ff">value</span> == userName) <span style="color: #0000ff">return</span>;</pre>
    
    <pre>        userName = <span style="color: #0000ff">value</span>;</pre>
    
    <pre>        PropertyChanged(<span style="color: #006080">"UserName"</span>);</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

in our framework we have reduced this to

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> UserName { get; set; }</pre></p>
  </div>
</div>

which we think is a significant improvement. The technique we use to make this possible is interception. Basically we wrap the view model with a proxy. This technique will be described in details in an upcoming post of [Ray](https://lostechies.com/blogs/rhouston).

#### Commands

To define a command in the ViewModel to which an event of a control can be bound we use so called DelegateCommands. 

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> DelegateCommand&lt;<span style="color: #0000ff">object</span>&gt; SaveCommand;</pre></p>
  </div>
</div>

A delegate command usually is instantiated in the constructor of the view model and requires two methods delegates when instantiated. The first one is a delegate to the method that is called when the command is invoked through the user action. The second one is a delegate to a method which determines whether the command is available in the given context or not. The first delegate is mandatory whereas the second one is optional.

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> SampleViewModel(...)</pre>
    
    <pre>{</pre>
    
    <pre>    ...</pre>
    
    <pre>    SaveCommand = <span style="color: #0000ff">new</span> DelegateCommand&lt;<span style="color: #0000ff">object</span>&gt;(OnSave, CanSave);</pre>
    
    <pre>    ...</pre>
    
    <pre>}</pre></p>
  </div>
</div>

By the way: the DelegateCommand has been introduced in the [Microsoft Prism](http://msdn.microsoft.com/en-us/magazine/cc785479.aspx) framework. We have slightly modified it to adapt it to our specific needs.

The controls bound to a command will be automatically enabled or disabled if the command is available or not.

The view model is an important cornerstone in our framework. We have provided it with many useful features such as that it merits it’s own post. The view model will be described in details in our next post.

## Fluently bind existing XAML user controls to a view model

Imagine having loads of Silverlight user controls that are written in XAML. You want to leverage these controls without having to port them right away and use a fluent API to bind these controls to a view model.

### Bind to a property

Lets assume that on the user control we have a TextBox called txtUsername. We want to bind the Text property of this TextBox to the property UserName of the view model. The syntax we would like to use to accomplish this binding is as follows

<div>
  <div>
    <pre><span style="color: #0000ff">this</span>.WithTextBox(txtUsername)</pre>
    
    <pre>    .Text(m =&gt; m.UserName)</pre></p>
  </div>
</div>

The binding is described with the aid of a lambda expression <font face="Courier New" color="#ff0000">m => m.UserName</font> in this case. I took the parameter **m** as it is an acronym for model. If you are not familiar with lambda expressions please refer to [this](http://gabrielschenker.lostechies.com/blogs/gabrielschenker/archive/2009/02/03/step-by-step-introduction-to-delegates-and-lambda-expressions.aspx) post for a detailed introduction into delegates and lambda expressions.

The **WithTextBox** function is an extension method of the **UserControl** and takes as an argument the element which we want to bind to our view model. 

But that’s not all. We want as well bind the IsReadOnly property of the same TextBox to the property UserNameIsReadOnly of the view model. Further more we want to bind the properties Visibility and Enabled to the corresponding model properties. Thus our code now should look similar to this

<div>
  <div>
    <pre><span style="color: #0000ff">this</span>.WithTextBox(txtUsername)</pre>
    
    <pre>    .Text(m =&gt; m.UserName)</pre>
    
    <pre>    .IsReadOnly(m =&gt; m.UserNameIsReadOnly)</pre>
    
    <pre>    .IsVisible(m =&gt; m.UserNameIsVisible)</pre>
    
    <pre>    .IsEnabled(m =&gt; m.UserNameIsEnabled)</pre></p>
  </div>
</div>

There is one important fact that I want to discuss here. Each **FrameworkElement** has a property **Visibility** which determines whether the corresponding control is visible or not. Unfortunately the **Visibility** is not a **boolean** but an **enum** although there exist only two possible states namely **visible** and **collapsed**. Since our view model should not contain any display specific logic we do not want to have properties of type Visibility in our view model but rather just use a boolean for properties concerning the visibility of a control. Fortunately Silverlight (as well as WPF of course) offer the possibility of so called value converters that one can use when binding a property of a control to a property of a model. We will make use of this possibility and write our own **VisibilityToBoolean** converter.

The above syntax look really nice and the code is fully type safe. If you have to refactor the view model and e.g. rename a bound property a tool like Resharper will automatically rename/refactor the above code for you too. Furthermore we can profit of full intellisense support.

### Bind to a command

We do not only want to bind certain properties of our Silverlight controls to the view model but we also want to be able to bind events to specific commands defined in the view model. Most of the time this will be the Click-event of controls derived from the ButtonBase control such as a Button or a Hyperlink control. The syntax we want to use should be similar to this one

<div>
  <div>
    <pre><span style="color: #0000ff">this</span>.WithButton(btnCancel)</pre>
    
    <pre>        .OnClick(m =&gt; m.CancelCommand);</pre></p>
  </div>
</div>

Again the binding of the event to the command in the view model is expressed with the aid of a lambda expression.

As soon as a user clicks the cancel button the CancelCommand defined in the view model is executed. No need to implement any further code in the view! Our view stays perfectly humble as desired.

Furthermore a command can or cannot be executed in a given context. This fact is determined by some business logic. If a command is not executable at the moment then the Silverlight controls bound to this control are automatically disabled.

## Fluently create and bind a user control

If we can start from scratch and create a new user control then we can do this by using the new fluent API. As an example we want to define a user control which contains a stack panel with some text blocks and some text boxes. Also there are two buttons save and cancel. In our user control (=view) we have an initialize method where we put the code to create the layout

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Initialize()</pre>
    
    <pre>{</pre>
    
    <pre>    var grid = <span style="color: #0000ff">this</span>.GridFor(<span style="color: #006080">"Grid1"</span>)</pre>
    
    <pre>        .Background(Colors.Cyan)</pre>
    
    <pre>        .Margin(3, 10, 3, 5);</pre>
    
    <pre>&#160;</pre>
    
    <pre>    var stackPanel = <span style="color: #0000ff">this</span>.StackPanelFor()</pre>
    
    <pre>        .Orientation.Vertical()</pre>
    
    <pre>        .Margin(4)</pre>
    
    <pre>        .AddChild(<span style="color: #0000ff">this</span>.TextBlockFor(<span style="color: #006080">"Book Title:"</span>))</pre>
    
    <pre>        .AddChild(<span style="color: #0000ff">this</span>.TextBoxFor(m =&gt; m.BookTitle))</pre>
    
    <pre>        .AddChild(<span style="color: #0000ff">this</span>.TextBlockFor(<span style="color: #006080">"Book Author:"</span>))</pre>
    
    <pre>        .AddChild(<span style="color: #0000ff">this</span>.TextBoxFor(m =&gt; m.Author)</pre>
    
    <pre>                      .FontWeight.Bold()</pre>
    
    <pre>                      .FontStyle.Italic())</pre>
    
    <pre>        .AddChild(<span style="color: #0000ff">this</span>.TextBlockFor(<span style="color: #006080">"Publisher Name:"</span>))</pre>
    
    <pre>        .AddChild(<span style="color: #0000ff">this</span>.TextBoxFor(m =&gt; m.PublisherName)</pre>
    
    <pre>                      .ReadOnly())</pre>
    
    <pre>        .AddChild(<span style="color: #0000ff">this</span>.TextBlockFor(<span style="color: #006080">"Price:"</span>)</pre>
    
    <pre>                      .FontWeight.ExtraBlack()</pre>
    
    <pre>                      .Cursor.Hand())</pre>
    
    <pre>        .AddChild(<span style="color: #0000ff">this</span>.TextBoxFor(m =&gt; m.Price)</pre>
    
    <pre>                      .Width(80)</pre>
    
    <pre>                      .HorizontalAlignment.Left())</pre>
    
    <pre>        .AddChild(<span style="color: #0000ff">this</span>.StackPanelFor()</pre>
    
    <pre>                      .Orientation.Horizontal()</pre>
    
    <pre>                      .AddChild(<span style="color: #0000ff">this</span>.Button(<span style="color: #006080">"Save"</span>)</pre>
    
    <pre>                                    .Width(70)</pre>
    
    <pre>                                    .OnClick(m =&gt; m.SaveCommand))</pre>
    
    <pre>                      .AddChild(<span style="color: #0000ff">this</span>.Button(<span style="color: #006080">"Cancel"</span>)</pre>
    
    <pre>                                    .Width(70)</pre>
    
    <pre>                                    .OnClick(m =&gt; m.CancelCommand)</pre>
    
    <pre>                      )</pre>
    
    <pre>        );</pre>
    
    <pre>&#160;</pre>
    
    <pre>    grid.AddChild(stackPanel);</pre>
    
    <pre>&#160;</pre>
    
    <pre>    Content = grid;</pre>
    
    <pre>}</pre></p>
  </div>
</div>

Usually this is the only code that is needed in a view. And as a result our view remains really humble. Please note as well that the only strings that are still present in the code are labels. Every thing else is strongly typed.

The above code does show some of the possibilities the framework offers. Layout elements as font styles, cursors, alignment or size can be set. Specific properties of controls can be bound to properties of the view model and the click event of button type controls can be bound to commands also defined in the view model.

We can even apply predefined templates to any control or a watermark to a text box as shown in the following sample

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Initialize()</pre>
    
    <pre>{</pre>
    
    <pre>    plainText = <span style="color: #0000ff">this</span>.TextBoxFor(m =&gt; m.TextAnswer)</pre>
    
    <pre>        .Interactable(m =&gt; m.TextAnswerInteractable)</pre>
    
    <pre>        .Visible(m =&gt; m.TextAnswerVisible)</pre>
    
    <pre>        .Template(<span style="color: #006080">"textBoxTemplate"</span>)</pre>
    
    <pre>        .Apply(TextBoxStyles.GetStandardFontStyles())</pre>
    
    <pre>        .Watermark(<span style="color: #006080">"Enter an answer please"</span>)</pre>
    
    <pre>        .VerticalAlignment.Top()</pre>
    
    <pre>        .HorizontalAlignment.Stretch();</pre>
    
    <pre>&#160;</pre>
    
    <pre>    Content = plainText;</pre>
    
    <pre>}</pre></p>
  </div>
</div>

A watermark is a text that is displayed in a textbox if the corresponding textbox is empty and does not own the focus. Often the watermark text is displayed in a different font style and/or color that normal text (e.g. in gray).

## Code

The project is called **fluent-silverlight** is hosted on Google Code. You can find it [here](http://code.google.com/p/fluent-silverlight/). Feel free to browse and/or download the code and experiment with it. Any constructive feedback is highly appreciated.

## Summary

In this post we have introduced a new OSS framework which provides an alternative way to implement a Silverlight application. The framework is built with TDD in mind and is meant to lead to scalable, maintainable and flexible applications. Views shall be as humble as possible since they are the only parts of the application that cannot be tested in isolation. All the presentation logic is implemented in the view model. Data and command binding is used between view and view model.

This framework is used in our internal application. We are still in a discovery phase. Many parts may change in the near future as we progress. Never the less we feel that it is worth to share our ideas with the community.

This post is the first part of a whole series of articles that will be published soon.