---
wordpress_id: 26
title: Fluent Silverlight – Part 3 – Binding Events to Commands
date: 2009-06-08T21:50:17+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: /blogs/gabrielschenker/archive/2009/06/09/fluent-silverlight-part-3-binding-events-to-commands.aspx
dsq_thread_id:
  - "263908857"
categories:
  - commands
  - data binding
  - fluent Silverlight
  - Lambda Expressions
  - Silverlight
---
## Introduction

In the last two posts I [introduced](http://gabrielschenker.lostechies.com/blogs/gabrielschenker/archive/2009/06/01/fluent-silverlight-part-1.aspx) Fluent Silverlight which is a new framework designed to offer a strongly typed alternative to the XAML based definition of Silverlight views and its “magic string” based data binding of properties of the view controls and I explained in details how we provide [data binding](http://gabrielschenker.lostechies.com/blogs/gabrielschenker/archive/2009/06/02/fluent-silverlight-part-2-binding-properties.aspx) between the view model and the view. In this post I want to discuss the details on how we bind events of Silverlight controls to corresponding commands defined in the view model. Those events are mostly triggered by user actions like clicking on a menu item or button or entering text into a text box. One of our goals is to have an implementation of the MVVM pattern where the view is as humble as possible. In this context humble means that the view should contain the bare minimum possible of logic. And if ever the view contains logic this logic should be really simple and mostly of type display logic. Data binding of properties helps a lot in this regard. But also binding of events of controls to corresponding commands defined in the view model is an additional big step in the chosen direction.

## Binding Events to Commands

To demonstrate the binding of commands to events triggered by user actions let’s take a simple use case which should be familiar to all of you dear readers. It is the famous login screen. Usually when logging into an application the user has to provide a user name and a password. She can then either abort the use case by clicking on the cancel button of try to login by clicking on the login button. In our case the login button should only be enabled if the user has entered a valid user name and password. On the other hand the user should always be able to abort the operation. Thus the cancel button has always to stay enabled. 

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="91" alt="image" src="http://lostechies.com/gabrielschenker/files/2011/03/image_thumb_6ADF4BC4.png" width="317" border="0" />](http://lostechies.com/gabrielschenker/files/2011/03/image_0BD2BE6C.png) 

### The view

With the aid of our fluent interface we have defined the above view. The code in the view looks like this

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Initialize()</pre>
    
    <pre>{</pre>
    
    <pre>    Content = <span style="color: #0000ff">this</span>.GridFor(<span style="color: #006080">"Grid1"</span>)</pre>
    
    <pre>        .Background(Colors.White)</pre>
    
    <pre>        .Height(80)</pre>
    
    <pre>        .Margin(3, 10, 3, 5)</pre>
    
    <pre>        .AddColumn.Width(100)</pre>
    
    <pre>        .AddColumn.Star()</pre>
    
    <pre>        .AddRow.Auto()</pre>
    
    <pre>        .AddRow.Auto()</pre>
    
    <pre>        .AddRow.Auto()</pre>
    
    <pre>        .PlaceIntoCell(0, 0, <span style="color: #0000ff">this</span>.TextBlockFor(<span style="color: #006080">"User name:"</span>)</pre>
    
    <pre>                                 .FontWeight.Bold()</pre>
    
    <pre>                                 .Margin(5, 5, 0, 0)</pre>
    
    <pre>        )</pre>
    
    <pre>        .PlaceIntoCell(1, 0, <span style="color: #0000ff">this</span>.TextBlockFor(<span style="color: #006080">"Password:"</span>)</pre>
    
    <pre>                                 .FontWeight.Bold()</pre>
    
    <pre>                                 .Margin(5, 5, 0, 0)</pre>
    
    <pre>        )</pre>
    
    <pre>        .PlaceIntoCell(0, 1, <span style="color: #0000ff">this</span>.TextBoxFor(m =&gt; m.Username)</pre>
    
    <pre>                                 .Watermark(<span style="color: #006080">"Enter username"</span>)</pre>
    
    <pre>                                 .Width(200)</pre>
    
    <pre>                                 .Margin(0, 5, 5, 0)</pre>
    
    <pre>        )</pre>
    
    <pre>        .PlaceIntoCell(1, 1, <span style="color: #0000ff">this</span>.TextBoxFor(m =&gt; m.Password)</pre>
    
    <pre>                                 .Watermark(<span style="color: #006080">"Enter password"</span>)</pre>
    
    <pre>                                 .Width(200)</pre>
    
    <pre>                                 .Margin(0, 5, 5, 0)</pre>
    
    <pre>        )</pre>
    
    <pre>        .PlaceIntoCell(2, 1, <span style="color: #0000ff">this</span>.StackPanelFor()</pre>
    
    <pre>                                 .Orientation.Horizontal()</pre>
    
    <pre>                                 .HorizontalAlignment.Right()</pre>
    
    <pre>                                 .Margin(0, 10, 0, 5)</pre>
    
    <pre>                                 .AddChild(<span style="color: #0000ff">this</span>.Button(<span style="color: #006080">"Cancel"</span>)</pre>
    
    <pre>                                               .Width(70)</pre>
    
    <pre>                                               .Margin(0, 0, 5, 0)</pre>
    
    <pre>                                               .OnClick(m =&gt; m.CancelCommand))</pre>
    
    <pre>                                 .AddChild(<span style="color: #0000ff">this</span>.Button(<span style="color: #006080">"Login"</span>)</pre>
    
    <pre>                                               .Width(70)</pre>
    
    <pre>                                               .Margin(0, 0, 5, 0)</pre>
    
    <pre>                                               .OnClick(m =&gt; m.LoginCommand))</pre>
    
    <pre>        );</pre>
    
    <pre>}</pre></p>
  </div>
</div>

The above code defines a login view with two labels (instances of type TextBlock) and the two text entry fields for the user name and the password. Additionally we have two command buttons &#8211; one to request login and the other to abort the process.

I am not going to discuss the layout of the view in this post. I frankly admit being a terrible designer!

The important part of the code that I want to discuss here is the binding of the click event of a button to a respective command of the view model. The binding is defined by a lambda expression similar to the binding of properties described in the [previous post](http://gabrielschenker.lostechies.com/blogs/gabrielschenker/archive/2009/06/02/fluent-silverlight-part-2-binding-properties.aspx).

<div>
  <div>
    <pre><span style="color: #0000ff">this</span>.Button(<span style="color: #006080">"Login"</span>) </pre>
    
    <pre>        .OnClick(m =&gt; m.LoginCommand)</pre></p>
  </div>
</div>

that is, the click event of a button with content “Login” is bound to the **LoginCommand** in the view model. 

### The view model

In the view model we define the LoginCommand as a public field of type DelegateCommand<T>.

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> DelegateCommand&lt;<span style="color: #0000ff">object</span>&gt; LoginCommand;</pre></p>
  </div>
</div>

The delegate command is generic to allow for a parameter of any type to be passed when executing the command. In our case we don’t need a parameter thus we just defined the generic parameter of the delegate command to be of type object.

The LoginCommand must the be instantiated which usually is done in the constructor of the view model. When instantiating a delegate command one has to provide a delegate to an execute method which is called whenever the command is triggered. Optionally one can also pass a delegate to a method which determines the availability of the command in a given context.

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> LoginViewModel(ILoginView view)</pre>
    
    <pre>{</pre>
    
    <pre>    ...</pre>
    
    <pre>    LoginCommand = <span style="color: #0000ff">new</span> DelegateCommand&lt;<span style="color: #0000ff">object</span>&gt;(OnLogin, CanLogin);</pre>
    
    <pre>    ...</pre>
    
    <pre>}</pre></p>
  </div>
</div>

and then the corresponding methods in the view model

<div>
  <div>
    <pre><span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> OnLogin(<span style="color: #0000ff">object</span> obj)</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #008000">// define action here...</span></pre>
    
    <pre>}</pre>
    
    <pre>&#160;</pre>
    
    <pre><span style="color: #0000ff">private</span> <span style="color: #0000ff">bool</span> CanLogin()</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">return</span> IsValid();</pre>
    
    <pre>}</pre></p>
  </div>
</div>

here the IsValid method makes a simple validation of the username and password properties and returns true if they are in a valid state. Remember that the control bound to a command in the view model is automatically enabled or disabled if the command to which it is bound is available or not.

### The ButtonBaseBinder class – or – how to bind a command

The ButtonBase class is the super class of Silverlight controls having a **click** event like Button, CheckBox, HyperLink, etc. We want to bind the click event of such a control to a (delegate) command defined in the view model. Such a command implements the following interface

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IFsCommand</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">bool</span> CanExecute();</pre>
    
    <pre>    <span style="color: #0000ff">void</span> Execute(<span style="color: #0000ff">object</span> parameter);</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">event</span> System.EventHandler CanExecuteChanged;</pre>
    
    <pre>}</pre></p>
  </div>
</div>

Whenever the click event of a bound control is raised the Execute(…) method of the bound command should be automatically invoked. Whether a command is available in a given context is determined by the CanExecute() method of the corresponding command. The bound controls should automatically be enabled or disabled depending on the response of this method.

Usually a command is exposed as a public field in the view model. In the view an event of a control is bound to a command in the view model with the aid of a lambda expression similar to this one

<div>
  <div>
    <pre>m =&gt; m.LoginCommand</pre></p>
  </div>
</div>

In our builder when having such a lambda expression we can get to the command instance with the following code fragment

<div>
  <div>
    <pre>var fi = ((MemberExpression)expression.Body).Member <span style="color: #0000ff">as</span> FieldInfo;</pre>
    
    <pre><span style="color: #0000ff">if</span> (fi != <span style="color: #0000ff">null</span>)</pre>
    
    <pre>{</pre>
    
    <pre>    var command = (IFsCommand)fi.GetValue(model);</pre>
    
    <pre>}</pre></p>
  </div>
</div>

Here the model is an instance variable of the builder. Now we want to bind the click event of the control to the command. This can be done like this

<div>
  <div>
    <pre>control.Click += (sender, e) =&gt; command.Execute(<span style="color: #0000ff">null</span>);</pre></p>
  </div>
</div>

that is we register a lambda expression with the event. Note that the execute method expects one parameter. In this simplified case we just pass a null value. Depending on the situation we can pass a relevant value. In the case of a CheckBox we could e.g. pass the value of the IsChecked property as a parameter.

We have mentioned above that the visibility of the bound control should automatically be synchronized with the output of the CanExecute() method of the command. This is accomplished with the following code fragment

<div>
  <div>
    <pre>command.CanExecuteChanged += (sender, e) =&gt; { control.IsEnabled = command.CanExecute(); };</pre>
    
    <pre><span style="color: #008000">// the following line is needed such as that the initial setting is correct</span></pre>
    
    <pre>control.IsEnabled = command.CanExecute();</pre></p>
  </div>
</div>

Whenever the CanExecuteChanged event of the command is raised the IsEnabled property of the bound control is set to the value returned by the CanExecute() method of the command.

All in all we can summarize this and receive as a result

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">abstract</span> <span style="color: #0000ff">class</span> ButtonBaseBinder&lt;THIS, TControl, TModel&gt; : ContentControlBinder&lt;THIS, TControl, TModel&gt;</pre>
    
    <pre>    <span style="color: #0000ff">where</span> TModel : <span style="color: #0000ff">class</span></pre>
    
    <pre>    <span style="color: #0000ff">where</span> TControl : ButtonBase</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">protected</span> ButtonBaseBinder(TModel model, TControl element)</pre>
    
    <pre>        : <span style="color: #0000ff">base</span>(model, element)</pre>
    
    <pre>    {</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> THIS OnClick&lt;T&gt;(Expression&lt;Func&lt;TModel, DelegateCommand&lt;T&gt;&gt;&gt; expression)</pre>
    
    <pre>    {</pre>
    
    <pre>        var command = PrepareCommand(expression, <span style="color: #0000ff">true</span>);</pre>
    
    <pre>        control.Click += (sender, e) =&gt; command.Execute(<span style="color: #0000ff">null</span>);</pre>
    
    <pre>&#160;</pre>
    
    <pre>        command.CanExecuteChanged += (sender, e) =&gt; { control.IsEnabled = command.CanExecute(); };</pre>
    
    <pre>        <span style="color: #008000">// initial setting</span></pre>
    
    <pre>        control.IsEnabled = command.CanExecute();</pre>
    
    <pre>&#160;</pre>
    
    <pre>        <span style="color: #0000ff">return</span> thisInstance();</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">protected</span> IFsCommand PrepareCommand&lt;T&gt;(Expression&lt;Func&lt;TModel, DelegateCommand&lt;T&gt;&gt;&gt; expression)</pre>
    
    <pre>    {</pre>
    
    <pre>        var fi = ((MemberExpression)expression.Body).Member <span style="color: #0000ff">as</span> FieldInfo;</pre>
    
    <pre>        <span style="color: #0000ff">if</span> (fi != <span style="color: #0000ff">null</span>)</pre>
    
    <pre>        {</pre>
    
    <pre>            <span style="color: #0000ff">return</span> (IFsCommand)fi.GetValue(model);</pre>
    
    <pre>        }</pre>
    
    <pre>        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> ArgumentException(<span style="color: #006080">"The expression cannot be used to bind an action/delegate command to an event."</span>);</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

In a similar way as shown with the click event it is possible to bind a command to other events of a control. one example would be the TextChanged event of a TextBox.</p> 

## Summary

In this post I have show how to bind an event of a Silverlight control to a command defined in the view model. To really implement the MVVM pattern with a humble view it is important not only to bind the properties of the view model to respective properties of the view but also the actions a user can trigger via the view. Actions are most often triggered by various types of buttons like menu items, hyper links and normal command buttons. With the technique shown in this post the whole presentation logic can be handled in the view model. In such a way it is also possible to unit test the whole system since the view model can be easily tested and developed in isolation whereas the view cannot since it has to run embedded into the browser; that is the Silverlight framework.