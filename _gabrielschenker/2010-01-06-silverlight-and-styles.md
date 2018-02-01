---
id: 35
title: Silverlight and styles
date: 2010-01-06T13:43:40+00:00
author: Gabriel Schenker
layout: post
guid: /blogs/gabrielschenker/archive/2010/01/06/silverlight-and-styles.aspx
dsq_thread_id:
  - "263908912"
categories:
  - fluent Silverlight
  - Silverlight
  - Styles and Templates
---
This post is the result of a couple of frustrating moments passed yesterday. In our application we use the date picker control of the Silverlight toolkit. Unfortunately this control does not work exactly as we would like to thus I decided to redefine its template such as that the control better fits our needs. I didn’t want to put the new style into the app.xaml file but rather store it as a resource in the assembly where our new and improved date picker resides.

## The generic.xaml

The documentation about how this is to be done is incomplete at best. After Google-ing I quickly found out that we can put the styles in a file called **generic.xaml**; e.g. something like this

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">ResourceDictionary</span></pre>
    
    <pre>    <span style="color: #ff0000">xmlns</span><span style="color: #0000ff">="http://schemas.microsoft.com/winfx/2006/xaml/presentation"</span> </pre>
    
    <pre>    <span style="color: #ff0000">xmlns:x</span><span style="color: #0000ff">="http://schemas.microsoft.com/winfx/2006/xaml"</span> </pre>
    
    <pre>    <span style="color: #ff0000">xmlns:controls</span><span style="color: #0000ff">="clr-namespace:MyNamespace"</span> </pre>
    
    <pre><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">&lt;</span><span style="color: #800000">Style</span> <span style="color: #ff0000">TargetType</span><span style="color: #0000ff">="controls:SampleButton"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>        <span style="color: #0000ff">&lt;</span><span style="color: #800000">Setter</span> <span style="color: #ff0000">Property</span><span style="color: #0000ff">="BorderThickness"</span> <span style="color: #ff0000">Value</span><span style="color: #0000ff">="1"</span> <span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>        <span style="color: #0000ff">&lt;</span><span style="color: #800000">Setter</span> <span style="color: #ff0000">Property</span><span style="color: #0000ff">="Template"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>            <span style="color: #0000ff">&lt;</span><span style="color: #800000">Setter.Value</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>                <span style="color: #0000ff">&lt;</span><span style="color: #800000">ControlTemplate</span> <span style="color: #ff0000">TargetType</span><span style="color: #0000ff">="controls:SampleButton"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>                    <span style="color: #0000ff">&lt;</span><span style="color: #800000">Border</span> <span style="color: #ff0000">CornerRadius</span><span style="color: #0000ff">="2"</span> </pre>
    
    <pre>                            <span style="color: #ff0000">BorderThickness</span><span style="color: #0000ff">="{TemplateBinding BorderThickness}"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>                        <span style="color: #0000ff">&lt;</span><span style="color: #800000">ContentPresenter</span><span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>                    <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Border</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>                <span style="color: #0000ff">&lt;/</span><span style="color: #800000">ControlTemplate</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>            <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Setter.Value</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>        <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Setter</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>    <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Style</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">ResourceDictionary</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

Note that the above is just a sample style that I used to experiment with. The style for the date picker is much more complex.

In the constructor of my sample control I then just have to put this assignment

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> SampleButton()</pre>
    
    <pre>{</pre>
    
    <pre>    DefaultStyleKey = <span style="color: #0000ff">typeof</span>(SampleButton);</pre>
    
    <pre>}</pre></p>
  </div>
</div>

Ok, nice, so did I. But my application didn’t work any more; the style was not picked up as before (when it was defined in the app.xaml). After some more Google-ing I found out that the **Build Action** of the **generic.xaml** has to be of type **Resource**. Still no success. My custom control did not pick up the style.

Still more Google-ing was needed and some consumption of videos on the [official Silverlight site](http://silverlight.net). The next piece of information I got was that the generic.xaml file has to reside in a folder called **Themes**. Hurray, finally my custom control worked.

## Merging resources

Well, now if we have many custom controls with many different styles and other resources the generic.xaml file quickly gets crowded too. Luckily there exists a possibility how one can merge the generic.xaml from different sources. Thus I can define my styles for different controls in individual resource files. The syntax for this is

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">ResourceDictionary</span>     </pre>
    
    <pre>    <span style="color: #ff0000">xmlns</span><span style="color: #0000ff">="http://schemas.microsoft.com/client/2007"</span></pre>
    
    <pre>    <span style="color: #ff0000">xmlns:x</span><span style="color: #0000ff">="http://schemas.microsoft.com/winfx/2006/xaml"</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">&lt;</span><span style="color: #800000">ResourceDictionary.MergedDictionaries</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>        <span style="color: #0000ff">&lt;</span><span style="color: #800000">ResourceDictionary</span> <span style="color: #ff0000">Source</span><span style="color: #0000ff">="/FluentSilverlight;component/Themes/FsDatePicker.xaml"</span><span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>        <span style="color: #0000ff">&lt;</span><span style="color: #800000">ResourceDictionary</span> <span style="color: #ff0000">Source</span><span style="color: #0000ff">="/FluentSilverlight;component/Themes/FsComboBox.xaml"</span><span style="color: #0000ff">/&gt;</span></pre>
    
    <pre>    <span style="color: #0000ff">&lt;/</span><span style="color: #800000">ResourceDictionary.MergedDictionaries</span><span style="color: #0000ff">&gt;</span></pre>
    
    <pre>    </pre>
    
    <pre><span style="color: #0000ff">&lt;/</span><span style="color: #800000">ResourceDictionary</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

It is very important to note that there is an inconsistency in the way merge dictionaries are defined in the app.xaml and in the generic.xaml. Where in the former case the attribute **Source** of the tag **ResourceDictionary** is a relative URI in the latter **Source** must be an absolute URI and has the following structure

<div>
  <div>
    <pre><span style="color: #0000ff">&lt;</span><span style="color: #800000">ResourceDictionary</span> <span style="color: #ff0000">Source</span><span style="color: #0000ff">="/assemblyName;component/path/fileName.xaml"</span><span style="color: #0000ff">&gt;</span></pre></p>
  </div>
</div>

Where **_assemblyName_** is the name of the assembly where the xaml file is contained; _**component**_ is a keyword; **_path_** is the path to the file and **_fileName_** is the name of the xaml file to merge. So in the above sample the assembly is **FluentSilverlight** and the two xaml files reside in a folder inside the project called **Themes**

## Meaningful Exception text anybody?

One of the most annoying factors with Silverlight is that its exception texts are often pretty useless. If there is a mistake in the definition of a template you get a very cryptic error message. Some more love from Microsoft regarding exceptions would be highly appreciated.