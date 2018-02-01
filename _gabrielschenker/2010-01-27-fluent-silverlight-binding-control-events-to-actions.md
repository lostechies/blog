---
id: 39
title: Fluent Silverlight – Binding control events to actions
date: 2010-01-27T14:01:43+00:00
author: Gabriel Schenker
layout: post
guid: /blogs/gabrielschenker/archive/2010/01/27/fluent-silverlight-binding-control-events-to-actions.aspx
dsq_thread_id:
  - "1069900065"
categories:
  - fluent Silverlight
  - How To
  - Silverlight
---
Please view the [table of content](http://www.lostechies.com/blogs/gabrielschenker/archive/2010/01/08/fluent-silverlight-table-of-content.aspx) of this series for reference.

## Introduction

A typical Silverlight application (or any application with a GUI) contains elements or controls like command buttons , menu items, text boxes etc. The user of the application interacts with the system via these controls. When the user interacts with a control like a command button this control raises events. In the case of a command button this would most probably be the **Click** event; in the case of a text box it might be the **TextChanged** event. As a developer we want to react to those events; we want to have some **action** happen as a consequence of the user clicking a button.

## Sample

Let’s call the element that raises an event a publisher. So we can implement a Publisher class with one event **BookReady**. This event is raised whenever the publisher has a new book ready. The code looks like this

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Publisher</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">event</span> EventHandler&lt;BookEventArgs&gt; BookReady;</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> PublishNewBook(<span style="color: #0000ff">string</span> bookTitle)</pre>
    
    <pre>    {</pre>
    
    <pre>        <span style="color: #0000ff">if</span> (BookReady != <span style="color: #0000ff">null</span>)</pre>
    
    <pre>            BookReady(<span style="color: #0000ff">this</span>, <span style="color: #0000ff">new</span> BookEventArgs(bookTitle));</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

Note that we have implemented a method **PublishNewBook** which when called raises the event. This makes sense since an event is always triggered after something has happened. In this case the publisher produces a new book and when it is ready he publicly announces this – he raises the event.

The **BookEventArgs** class used by the Publisher is given here

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> BookEventArgs : EventArgs</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> BookTitle { get; set; }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> BookEventArgs(<span style="color: #0000ff">string</span> bookTitle)</pre>
    
    <pre>    {</pre>
    
    <pre>        BookTitle = bookTitle;</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

Now the whole thing would be pretty useless if there weren’t interested readers or book stores around that react upon the event of the publisher, buy the book and read it. So lets implement a consumer of a book and call it the **BookLover**

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> BookLover</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> ReadBook(<span style="color: #0000ff">string</span> bookTitle)</pre>
    
    <pre>    {</pre>
    
    <pre>        <span style="color: #008000">// some code</span></pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

Most often the interested reader doesn’t go directly to the publish or is not directly connected with the publisher. The interested reader goes to a bookstore. The bookstore is the broker between a publisher and the readers. So let’s look at the code of the book store

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Store</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> MeetWithPublishers()</pre>
    
    <pre>    {</pre>
    
    <pre>        var publisherX = <span style="color: #0000ff">new</span> Publisher();</pre>
    
    <pre>        publisherX.BookReady += OnNewBookReady;</pre>
    
    <pre>&#160;</pre>
    
    <pre>        var titleForNewBook = <span style="color: #006080">"Introduction to Fluent Silverlight"</span>;</pre>
    
    <pre>        publisherX.PublishNewBook(titleForNewBook);</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> OnNewBookReady(<span style="color: #0000ff">object</span> sender, BookEventArgs e)</pre>
    
    <pre>    {</pre>
    
    <pre>        var personA = <span style="color: #0000ff">new</span> BookLover();</pre>
    
    <pre>        personA.ReadBook(e.BookTitle);</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

The book store organizes a meeting with the publisher (method **MeetWithPublisher**) and tells the publisher to produce a new book about fluent Silverlight. The store than registers itself with the publisher as a consumer&#160; of the **BookReady** event. Now whenever the book is ready the method **OnNewBookReady** is called by the publisher. In this method the store offers the book to its readers.

That’s a lot of code just to achieve one goal… we want to offer the book to an interested reader whenever it is available from the publisher. Can’t we reduce the code? Yes we can by using anonymous delegates. For a detailed introduction into anonymous delegates and lambda expressions please refer to [this](http://www.lostechies.com/blogs/gabrielschenker/archive/2009/02/03/step-by-step-introduction-to-delegates-and-lambda-expressions.aspx) post.</p> 

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Store</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> OrganizeNextPublisherMeeting()</pre>
    
    <pre>    {</pre>
    
    <pre>        var personA = <span style="color: #0000ff">new</span> BookLover();</pre>
    
    <pre>        var publisherX = <span style="color: #0000ff">new</span> Publisher();</pre>
    
    <pre>        </pre>
    
    <pre>        var titleForNewBook = <span style="color: #006080">"Advanced usage of Fluent Silverlight"</span>;</pre>
    
    <pre>&#160;</pre>
    
    <pre>        publisherX.BookReady += (sender, e) =&gt; personA.ReadBook(titleForNewBook);</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

In the above code snippet the action that is executed as a reaction on the event is defined as a lambda expression. By using this approach we don’t need to define an event handler method nor an extra **EventArgs** class and the code is much more compact.

## Introducing Commands

Now let us generalize this whole thing a little bit. On one side we have a publisher of events. This can be any event e.g. the **BookReady** event in the sample above or the click event of a Silverlight command button. In the latter case the publisher would be the Silverlight control. On the other side we have some logic that we want to execute as a reaction to the event. We can also say that we want to “trigger an action” by the event. Let’s wrap the code that we want to execute (that is the action) into its own class. This class we call “a command”. Let’s start by defining an interface that all types of commands will implement

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IFsCommand&lt;T&gt;</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">void</span> Execute(<font color="#0000ff">T</font> parameter);</pre>
    
    <pre>}</pre></p>
  </div>
</div>

The interface has a generic parameter T and thus is very flexible. The method Execute can be called with any type of parameter, be it a simple value type parameter or any reference type parameter, that is an instance of any type of class. We can then create a command class as follows

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> FsCommand&lt;T&gt; : IFsCommand&lt;T&gt;</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> Action&lt;T&gt; action;</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> FsCommand(Action&lt;T&gt; action)</pre>
    
    <pre>    {</pre>
    
    <pre>        <span style="color: #0000ff">this</span>.action = action;</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Execute(T parameter)</pre>
    
    <pre>    {</pre>
    
    <pre>        action(parameter);</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

This class expects an action with one parameter as parameter of the constructor. This action is executed whenever the method Execute of the command is called.

If we have a command button control and an instance of a command we can bind the click event of the button to this command like this

<div>
  <div>
    <pre>button.Click += (sender, e) =&gt; someCommand.Execute(someParameter);</pre></p>
  </div>
</div>

### Binding control events to commands defined in the view model

Imagine we have a Silverlight application with a view (i.e. UserControl) and a corresponding view model (see [Model-View-ViewModel pattern](http://en.wikipedia.org/wiki/Model_View_ViewModel) – MVVM). The view contains a button which we want to bind to a command defined on the model. The model is defined as follows

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Model</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">public</span> IFsCommand&lt;<span style="color: #0000ff">int</span>&gt; SaveCustomerAction;</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> Model()</pre>
    
    <pre>    {</pre>
    
    <pre>        SaveCustomerAction = <span style="color: #0000ff">new</span> FsCommand&lt;<span style="color: #0000ff">int</span>&gt;(p =&gt; OnSaveCustomer(p));</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> OnSaveCustomer(<span style="color: #0000ff">int</span> parameter)</pre>
    
    <pre>    {                              </pre>
    
    <pre>        <span style="color: #008000">// logic to save the customer...</span></pre>
    
    <pre>    }</pre>
    
    <pre>}                             </pre></p>
  </div>
</div>

and the view is defined like this

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> View</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">private</span> Model model;</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> View(Model model)</pre>
    
    <pre>    {</pre>
    
    <pre>        <span style="color: #0000ff">this</span>.model = model;</pre>
    
    <pre>&#160;</pre>
    
    <pre>        var saveCustomerButton = <span style="color: #0000ff">new</span> FsButton();</pre>
    
    <pre>&#160;</pre>
    
    <pre>        var parameter = 123;</pre>
    
    <pre>        saveCustomerButton.Click += (sender, e) =&gt; model.SaveCustomerAction.Execute(parameter);</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

Each time that the click event of the **saveCustomerButton** is raised the action **OnSaveCustomer** is executed on the view model. It very important to notice that the action is defined on the view model rather than on the view. We have a clear separation of layout code/logic (the view) and presentation logic (the view model). This makes it easy to unit test the logic since it is completely decoupled from the view. In Silverlight a view cannot be tested in isolation thus it is very important to take out any logic of the view and put it into the model.

### Availability and interactability of a command

A certain command can be available or not available depending on the context. This is a concept independent of a UI. But when a command is triggered by a visual element on a view then this availability can be represented by the visibility and/or interactability of the control. The availability of a command is usually governed by security requirements or the application or by the state in a workflow. Thus we’d rather set the availability of a command in the view model than in the view and we expect the bound controls to automatically set their state (visible and/or enabled) accordingly.

We can introduce a property **IsExecuatble** of type **bool** in the interface of our commands as well as an event **IsExecutableChanged** which is triggered whenever the value of the **IsExecutable** property changes.

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IFsCommand&lt;T&gt;</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">void</span> Execute(T parameter);</pre>
    
    <pre>    <span style="color: #0000ff">bool</span> IsExecutable { get; set; }</pre>
    
    <pre>    <span style="color: #0000ff">event</span> EventHandler IsExecutableChanged;</pre>
    
    <pre>}</pre></p>
  </div>
</div>

we can now change the code that binds the control to the command as follows

<div>
  <div>
    <pre>var action = model.SaveCustomerAction;</pre>
    
    <pre>saveCustomerButton.Click += (sender, e) =&gt; action.Execute(parameter);</pre>
    
    <pre>action.IsExecutableChanged += (sender, e) =&gt; saveCustomerButton.IsEnabled = action.IsExecutable;</pre>
    
    <pre><span style="color: #008000">// to initialze the button with the current value</span></pre>
    
    <pre>saveCustomerButton.IsEnabled = action.IsExecutable;</pre></p>
  </div>
</div>

From now on the button automatically updates its IsEnabled property whenever the property IsExecutable of the bound command changes.

We could now introduce a similar concept for the Visibility property of the control. How we do this depends on the specific context. In the applications we write at our company we have so called edit mode specifications which govern the interactability and visibility of commands or actions. These specification make a clear distinction between a command being visible but not interactable and a command not being visible at all. In this context we introduced the visibility as an extra property in the interface of the command analogous to the **IsExecutable** property. But your requirements may vary.

Our command class now looks like this

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> FsCommand&lt;T&gt; : IFsCommand&lt;T&gt;</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> Action&lt;T&gt; action;</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">bool</span> isExecutable;</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> FsCommand(Action&lt;T&gt; action)</pre>
    
    <pre>    {</pre>
    
    <pre>        <span style="color: #0000ff">this</span>.action = action;</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Execute(T parameter)</pre>
    
    <pre>    {</pre>
    
    <pre>        action(parameter);</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> IsExecutable</pre>
    
    <pre>    {</pre>
    
    <pre>        get { <span style="color: #0000ff">return</span> isExecutable; }</pre>
    
    <pre>        set </pre>
    
    <pre>        { </pre>
    
    <pre>            <span style="color: #0000ff">if</span>(isExecutable == <span style="color: #0000ff">value</span>) <span style="color: #0000ff">return</span>;</pre>
    
    <pre>&#160;</pre>
    
    <pre>            isExecutable = <span style="color: #0000ff">value</span>;</pre>
    
    <pre>            <span style="color: #0000ff">if</span> (IsExecutableChanged != <span style="color: #0000ff">null</span>)</pre>
    
    <pre>                IsExecutableChanged(<span style="color: #0000ff">this</span>, EventArgs.Empty);</pre>
    
    <pre>        }</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">event</span> EventHandler IsExecutableChanged;</pre>
    
    <pre>}</pre></p>
  </div>
</div>

There remains one problem though. If our application is multi-threaded then the setter method of the **IsExecutable** property might cause troubles. Remember that the properties of any (Silverlight) control can only be accessed from the UI thread (usually the main thread). Thus if another thread trigger the change of the **IsExecutable** property of the command we will have a cross thread access exception. To avoid this scenario we thus have to synchronize threads. We can use the Dispatcher class of Silverlight to do so.

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> IsExecutable</pre>
    
    <pre>{</pre>
    
    <pre>    get { <span style="color: #0000ff">return</span> isExecutable; }</pre>
    
    <pre>    set</pre>
    
    <pre>    {</pre>
    
    <pre>        <span style="color: #0000ff">if</span> (isExecutable == <span style="color: #0000ff">value</span>) <span style="color: #0000ff">return</span>;</pre>
    
    <pre>&#160;</pre>
    
    <pre>        isExecutable = <span style="color: #0000ff">value</span>;</pre>
    
    <pre>        OnIsExecutableChanged();</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre>
    
    <pre>&#160;</pre>
    
    <pre><span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> OnIsExecutableChanged()</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">if</span> (IsExecutableChanged == <span style="color: #0000ff">null</span>) <span style="color: #0000ff">return</span>;</pre>
    
    <pre>&#160;</pre>
    
    <pre>    var dispatcher = DispatcherProvider.Dispatcher();</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">if</span> (dispatcher != <span style="color: #0000ff">null</span> && !dispatcher.CheckAccess())</pre>
    
    <pre>        dispatcher.BeginInvoke(OnIsExecutableChanged);</pre>
    
    <pre>    <span style="color: #0000ff">else</span></pre>
    
    <pre>        IsExecutableChanged(<span style="color: #0000ff">this</span>, EventArgs.Empty);</pre>
    
    <pre>}</pre></p>
  </div>
</div></p> 

Note that we use a **DispatcherProvider** to decouple the command from the framework and thus make unit testing possible. The **DispatcherProvider** just returns null in the context of a unit test. We defined the provider like this

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">class</span> DispatcherProvider</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> Func&lt;Dispatcher&gt; Dispatcher = </pre>
    
    <pre>        () =&gt; Deployment.Current != <span style="color: #0000ff">null</span> ? Deployment.Current.Dispatcher : <span style="color: #0000ff">null</span>;</pre>
    
    <pre>}</pre></p>
  </div>
</div>

Now when unit testing a command we can simply configure the **DispatcherProvider** as follows

<div>
  <div>
    <pre>DispatcherProvider.Dispatcher = () =&gt; <span style="color: #0000ff">null</span>;</pre></p>
  </div>
</div>

In my next post I will continue with more details about binding control events to command/actions and will specifically discuss how we can weakly bind a control to an action. Stay tuned.