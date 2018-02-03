---
wordpress_id: 42
title: Working with code based templates in Silverlight
date: 2010-05-27T15:20:57+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: /blogs/gabrielschenker/archive/2010/05/27/working-with-code-based-templates-in-silverlight.aspx
dsq_thread_id:
  - "263908923"
categories:
  - fluent Silverlight
  - How To
  - Silverlight
  - Styles and Templates
---
## Introduction

In our **Silverlight** projects we are using the **[AgDataGrid](http://devexpress.com/Products/NET/Controls/Silverlight/Grid/)** of **DevExpress** to visualize data. I wrote some expressions that make it possible to use this data grid with **Fluent Silverlight**. During the writing of those expressions once again I hit some brick walls. In this post I want to show one specific solution to throw down such a wall and continue the journey…

Please refer to [this](http://www.lostechies.com/blogs/gabrielschenker/archive/2010/01/08/fluent-silverlight-table-of-content.aspx) post regarding more detail about Fluent Silverlight.

## Problem

Provide a check box column header whose click action can be bound to an action on the view model.

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="http://lostechies.com/gabrielschenker/files/2011/03/image_thumb_49443D59.png" width="192" height="185" />](http://lostechies.com/gabrielschenker/files/2011/03/image_779DC306.png) 

Sounds easy isn’t it? Just define a column header template and… err…

I want to be able to define a data grid having such a column in a way similar to this

<pre>var grid = <span class="kwrd">this</span>.AgGridFor&lt;Model, ChildModel&gt;()
                .AddColumn(...)
                .AddColumn(c =&gt; c.WithCheckBoxHeader(m =&gt; m.SelectAllCommand)
                                    .Value(m =&gt; m.Selected)
                                    .ColumnType.CheckColumn()
                                    .Width(50)
                )
                .AddColumn(...)
                ...
// more details...</pre>

Where **Model** represents the view model for the view on which the data grid resides and **ChildModel** represents the view model of an individual row in the data grid. The **SelectAllCommand** is a **DelegateCommand** (badically an action) defined on Model. Finally **Selected** is a property on the **ChildModel**.

**Problem 1**: Microsoft clearly states that all templates have to be written in XAML. There is no (official and supported) way to create a template in code.

**Problem 2**: How can I bind an event of a control in a template (the check box) to an action on my view model?

## Solution

I want to define my column header template in code and this is my example

<pre><span class="kwrd">public</span> <span class="kwrd">class</span> CheckBoxHeader : ContentControl
    {
        <span class="kwrd">public</span> CheckBoxHeader()
        {
            checkBox = <span class="kwrd">new</span> CheckBox { Margin = <span class="kwrd">new</span> Thickness(11, 0, 0, 0) };

            var layoutRoot = <span class="kwrd">new</span> Border
            {
                HorizontalAlignment = HorizontalAlignment.Stretch,
                VerticalAlignment = VerticalAlignment.Stretch,
                Child = checkBox,
            };

            Content = layoutRoot;
        }
    }</pre>

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }

I can overcome the limitation of the Silverlight framework and use the following helper class to instantiate a (named) data template

<pre><span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">class</span> TemplateHelper
{
    <span class="kwrd">public</span> <span class="kwrd">static</span> DataTemplate CreateNamedDataTemplate&lt;T&gt;(<span class="kwrd">string</span> name)
    {
        <span class="kwrd">return</span> InternalCreateDataTemplate(<span class="kwrd">typeof</span>(T), name);
    }

    <span class="kwrd">private</span> <span class="kwrd">static</span> DataTemplate InternalCreateDataTemplate(Type type, <span class="kwrd">string</span> name)
    {
        var nameAttribute = <span class="kwrd">string</span>.Format(<span class="str">"Name='{0}'"</span>, name);

        <span class="kwrd">const</span> <span class="kwrd">string</span> format = <span class="str">"&lt;DataTemplate xmlns='http://schemas.microsoft.com/client/2007'"</span> +
                              <span class="str">"              xmlns:controls='clr-namespace:{0};assembly={1}'&gt;"</span> +
                              <span class="str">"   &lt;controls:{2} {3} HorizontalAlignment='Stretch'/&gt;"</span> +
                              <span class="str">"&lt;/DataTemplate&gt;"</span>;
        var assemblyName = type.Assembly.FullName.Split(<span class="str">','</span>)[0];
        var xml = <span class="kwrd">string</span>.Format(format, type.Namespace, assemblyName, type.Name, nameAttribute);
        <span class="kwrd">return</span> (DataTemplate)XamlReader.Load(xml);
    }
}</pre>

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }

In the above code I use the XamlReader to instantiate an object from a XAML fragment. In this case it is a DataTemplate but it could as well be used to instantiate a ControlTemplate or a Style. In my case the template has to be named since a grid can potentially have multiple check box column headers and I need to be able to identify the right instance later on.

This code looks ugly but this doesn’t bother me since I write it only once and it is hidden in my framework. Whenever I define a grid with a check box column header I do this in a declarative way as shown later in this post and I am not confronted with this ugly code.

I can now define my grid column having a check box column header as follows

<pre>var column = <span class="kwrd">new</span> AgDataGridColumn();
var templateName = <span class="str">"checkBoxHeader"</span> + Guid.NewGuid().ToString();
var template = TemplateHelper.CreateNamedDataTemplate&lt;CheckBoxHeader&gt;(templateName);
column.HeaderContentTemplate = template;
...</pre>

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }

So far so good. But what about linking the click event of the check box defined in the template to the action defined on the view model? That is a problem since the template is instantiated by Silverlight during runtime and we have no seam to intercept this and do our binding… or don’t we?

After investigating quite a bit and banging my head against the wall I came out with the following solution:

<pre>dataGrid.Loaded += (sender, e) =&gt; Deployment.Current.Dispatcher.BeginInvoke(() =&gt; InitializeColumnHeader(dataGrid, model, templateName));</pre>

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }

I listen to the loaded event of the data grid and then use the Dispatcher to asynchronously call an column header initialization method. This method uses the visual tree to find an instance of type **CheckBoxHeader** with the expected template name

<pre><span class="kwrd">private</span> <span class="kwrd">void</span> InitializeColumnHeader(AgDataGrid dataGrid, TModel model, <span class="kwrd">string</span> templateName)
{
    var template = dataGrid.TunnelFindByType&lt;CheckBoxHeader&gt;().SingleOrDefault(h =&gt; h.Name == templateName);

    var fi = ((MemberExpression)CheckBoxHeaderClickExpression.Body).Member <span class="kwrd">as</span> FieldInfo;
    var command = (IFsCommand)fi.GetValue(model);
    Action&lt;<span class="kwrd">bool</span>?&gt; action = c =&gt;
                               {
                                   command.Execute(c);
                                   dataGrid.Refresh();
                               };
    template.SetClickAction(action);
}</pre>

If such a template instance is found then I call the **SetClickAction** on it and pass in as a parameter the action that shall be executed when the user clicks on the respective check box in the column header. The action is defined on the model that I pass in as the second parameter of the above function and we get to this action via the expression **CheckBoxHeaderClickExpression** which represents the expression <font face="Courier New">m => m.SelectAllCommand</font> shown earlier in this post. 

To make the picture complete I have to show once again the now extended code of header template

<pre><span class="kwrd">public</span> <span class="kwrd">class</span> CheckBoxHeader : ContentControl
{
    <span class="kwrd">private</span> Action&lt;<span class="kwrd">bool</span>?&gt; action;
    <span class="kwrd">private</span> <span class="kwrd">readonly</span> CheckBox checkBox;

    <span class="kwrd">public</span> CheckBoxHeader()
    {
        checkBox = <span class="kwrd">new</span> CheckBox { Margin = <span class="kwrd">new</span> Thickness(11, 0, 0, 0) };
        checkBox.Click += OnCheckBoxClick;

        var layoutRoot = <span class="kwrd">new</span> Border
        {
            HorizontalAlignment = HorizontalAlignment.Stretch,
            VerticalAlignment = VerticalAlignment.Stretch,
            Child = checkBox,
        };

        Content = layoutRoot;
    }

    <span class="kwrd">public</span> <span class="kwrd">void</span> SetClickAction(Action&lt;<span class="kwrd">bool</span>?&gt; clickAction)
    {
        action = clickAction; 
    }

    <span class="kwrd">private</span> <span class="kwrd">void</span> OnCheckBoxClick(<span class="kwrd">object</span> sender, RoutedEventArgs e)
    {
        action(checkBox.IsChecked);
    }
}</pre>

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }

Some more posts will follow showing other problems around creating expressions for the AgDataGrid and the solution I came up. Stay tuned.

Please tell me what you think about the solution presented and share your own solutions. Thanks for any feedback.