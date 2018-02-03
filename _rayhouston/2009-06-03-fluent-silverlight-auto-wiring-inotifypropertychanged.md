---
wordpress_id: 35
title: 'Fluent Silverlight &#8211; Auto Wiring INotifyPropertyChanged'
date: 2009-06-03T03:13:00+00:00
author: Ray Houston
layout: post
wordpress_guid: /blogs/rhouston/archive/2009/06/02/fluent-silverlight-auto-wiring-inotifypropertychanged.aspx
categories:
  - Dynamic Proxy
  - fluent Silverlight
  - INotifyPropertyChanged
  - MVVM
---
In [Gabriel&#8217;s introductory post for Fluent Silverlight](/blogs/gabrielschenker/archive/2009/06/02/fluent-silverlight-part-2-binding-properties.aspx), he showed that the code typically associated with implementing INotifyPropertyChanged can be reduced to a simple auto property. This can really improve the clarity of a large class as well as save some typing. I&#8217;m going to show you how to get it setup.

### INotifyPropertyChanged

First lets talk a little about normal INotifyPropertyChanged. This is an interface that is typically implemented on a ViewModel that you wish to participate in two way data binding between itself and some sort of DependencyProperty which typically lives on a control. The interface declaration looks like:

<div>
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4"><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> INotifyPropertyChanged<br />{<br />    <span style="color: #0000ff">event</span> PropertyChangedEventHandler PropertyChanged;<br />}<br /></pre>
</div>

<div>
  &nbsp;
</div>

<div>
  The PropertyChanged event on this interface is used to notify the control of any updates of properties that happen in your ViewModel so that the control can be refreshed with any updated data. Without the use of this interface, your updates will end up only being one way. Which means that the ViewModel will be updated with any changes from the control, but the control will not be updated with the changes from the ViewModel. A typical implementation may look like:
</div>

<div>
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> MyViewModel : INotifyPropertyChanged<br />{<br />    <span style="color: #0000ff">private</span> <span style="color: #0000ff">string</span> name;<br />    <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> Name<br />    {<br />        get { <span style="color: #0000ff">return</span> name; }<br />        set<br />        {<br />            <span style="color: #0000ff">if</span> (<span style="color: #0000ff">value</span> == name) <span style="color: #0000ff">return</span>; <br />            name = <span style="color: #0000ff">value</span>;<br />            OnPropertyChanged(<span style="color: #006080">"Name"</span>);<br />        }<br />    }<br /><br />    <span style="color: #0000ff">private</span> <span style="color: #0000ff">int</span> age;<br />    <span style="color: #0000ff">public</span> <span style="color: #0000ff">int</span> Age<br />    {<br />        get { <span style="color: #0000ff">return</span> age; }<br />        set<br />        {<br />            <span style="color: #0000ff">if</span> (<span style="color: #0000ff">value</span> == age) <span style="color: #0000ff">return</span>;<br />            age = <span style="color: #0000ff">value</span>;<br />            OnPropertyChanged(<span style="color: #006080">"Age"</span>);<br />        }<br />    }<br /><br />    <span style="color: #0000ff">public</span> <span style="color: #0000ff">event</span> PropertyChangedEventHandler PropertyChanged;<br /><br />    <span style="color: #0000ff">protected</span> <span style="color: #0000ff">void</span> OnPropertyChanged(<span style="color: #0000ff">string</span> propertyName)<br />    {<br />        <span style="color: #0000ff">if</span> (PropertyChanged != <span style="color: #0000ff">null</span>)<br />            PropertyChanged(<span style="color: #0000ff">this</span>, <span style="color: #0000ff">new</span> PropertyChangedEventArgs(propertyName));<br />    }<br />}<br /></pre>
</div>

<div>
  As you can see, it makes for a lot of noise. Also make note of the &#8220;Name&#8221; and &#8220;Age&#8221; strings which are not very refactor friendly.
</div>

### IAutoNotifyPropertyChanged

We got to thinking that if we could intercept the changes to the properties (AOP), then we could automatically throw the PropertyChanged event. One way to do this is to use Castle.DynamicProxy (the Silverlight edition). DynamicProxy allows us to create a runtime generated subclass of our ViewModel. The generated subclass allows interception of any virtual member where we can chose to do what we please. To get it all started, we needed an interface that would allow us to trigger the event:

<div>
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4"><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IAutoNotifyPropertyChanged : INotifyPropertyChanged<br />{<br />    <span style="color: #0000ff">void</span> OnPropertyChanged(<span style="color: #0000ff">string</span> propertyName);<br />}<br /></pre>
</div>

Next we updated our ViewModel to implement the new IAutoNotifyPropertyChanged interface and removed all the extras:

<div>
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> MyViewModel : IAutoNotifyPropertyChanged<br />{<br />    <span style="color: #0000ff">public</span> <span style="color: #0000ff">virtual</span> <span style="color: #0000ff">string</span> Name { get; set; }<br />    <span style="color: #0000ff">public</span> <span style="color: #0000ff">virtual</span> <span style="color: #0000ff">int</span> Age { get; set; }<br /><br />    <span style="color: #0000ff">public</span> <span style="color: #0000ff">event</span> PropertyChangedEventHandler PropertyChanged;<br /><br />    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> OnPropertyChanged(<span style="color: #0000ff">string</span> propertyName)<br />    {<br />        <span style="color: #0000ff">if</span> (PropertyChanged != <span style="color: #0000ff">null</span>)<br />            PropertyChanged(<span style="color: #0000ff">this</span>, <span style="color: #0000ff">new</span> PropertyChangedEventArgs(propertyName));<br />    }<br />}<br /></pre>
</div>

As you can see, there is a lot less noise here and we don&#8217;t have the magic strings for the property names laying around. Also note that we made the properties virtual so that they can be intercepted. To actually make the auto wiring work, we have to create an instance of the ViewModel class (actually it&#8217;s a generated subclass) using our AutoNotifyPropertyChangedProxyCreator. I&#8217;m not sure if we&#8217;ll stick with that name, but it will do for now. Take a look at the following little test:

<div>
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">[TestFixture]<br /><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> when_creating_viewmodel_with_creator<br />{<br />    <span style="color: #0000ff">private</span> MyViewModel model;<br />    <span style="color: #0000ff">private</span> <span style="color: #0000ff">string</span> lastPropChanged;<br /><br />    [SetUp]<br />    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SetUp()<br />    {<br />        model = <span style="color: #0000ff">new</span> AutoNotifyPropertyChangedProxyCreator().Create&lt;MyViewModel&gt;();<br /><br />        model.PropertyChanged += (s, e) =&gt; lastPropChanged = e.PropertyName;<br /><br />        lastPropChanged = <span style="color: #0000ff">null</span>;<br />    }<br /><br />    [Test]<br />    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> should_send_property_changed_for_given_property()<br />    {<br />        model.Name = <span style="color: #006080">"test"</span>;<br /><br />        Assert.That(lastPropChanged, Is.EqualTo(<span style="color: #006080">"Name"</span>));<br />        Assert.That(model.Name, Is.EqualTo(<span style="color: #006080">"test"</span>));<br />    }<br />}<br /></pre>
</div>

Because the proxy is a subclass, we can treat it as it&#8217;s original type MyViewModel. As the Name property changes, it fires the PropertyChanged event which is wired to update the lastPropChanged field.

### Summary

INotifyPropertyChanged is a handy interface for doing two way data binding but it causes a lot of extra noise in your classes. In [Fluent Silverlight](http://code.google.com/p/fluent-silverlight/), we have introduced the IAutoNotifyPropertyChanged interface which is used in conjunction with AutoNotifyPropertyChangedProxyCreator which uses Dynamic Proxy to intercept the calls and auto throw the PropertyChanged event. This allowed us to reduce the noise and completely remove the magic strings typically associated with standard INotifyPropertyChanged. 

In a future post I&#8217;ll demonstrate how you can do other things with this such as ignore certain properties, tap into the interception to execute methods and have an IoC container handle the proxy creation.

<div class="wlWriterSmartContent" style="padding-right: 0px;padding-left: 0px;padding-bottom: 0px;margin: 0px;padding-top: 0px">
  Technorati Tags: <a href="http://technorati.com/tags/Fluent%20Silverlight" rel="tag">Fluent Silverlight</a>,<a href="http://technorati.com/tags/INotifyPropertyChanged" rel="tag">INotifyPropertyChanged</a>,<a href="http://technorati.com/tags/Silverlight" rel="tag">Silverlight</a>
</div>