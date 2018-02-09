---
wordpress_id: 24
title: Creating a Silverlight Layout Panel
date: 2008-09-14T16:21:04+00:00
author: Ray Houston
layout: post
wordpress_guid: /blogs/rhouston/archive/2008/09/14/creating-a-silverlight-layout-panel.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/rhouston/archive/2008/09/14/creating-a-silverlight-layout-panel.aspx/"
---
On our current project, we came across the need to build some custom layout panels in Silverlight to achieve some complex fluid layouts that we could not get from the built in controls. I was amazed to see how easy it was to create your own. This panel that I&#8217;m going to show is nothing fancy, but it shows how simple it really is. It will layout it&#8217;s children in a diagonal direction from upper left to lower right.

The first thing we need to do is create a new class and inherit from Panel. Panel is the base class for the built-in layout controls such as Grid and StackPanel.

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">public class DiagonalStackPanel : Panel
{
}</pre>
</div>

The next thing is to override the MeasureOverride() method. In this method you should iterate through the Children collection and call the Measure() method on each child. After Measure() is called, the DesiredSize property of the child will be populated with the size in which the child wants to be rendered.

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">protected override Size MeasureOverride(Size availableSize)
{
    double totalWidth = 0;
    double totalHeight = 0;

    foreach (var child in Children)
    {
        child.Measure(availableSize);

        totalWidth += child.DesiredSize.Width;
        totalHeight += child.DesiredSize.Height;
    }

    return new Size(totalWidth, totalHeight);
}
</pre>
</div>

You can see that we&#8217;re adding up all the widths and heights of each child and returning the size (desired) for our Panel.

Next we override the ArrangeOverride() method. This is where we actually layout the children in the diagonal pattern. We do that by calculating the running total sizes of the child controls and calling Arrange() on each child with the appropriate sizing Rect object.

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">protected override Size ArrangeOverride(Size finalSize)
{
    double runningWidth = 0;
    double runningHeight = 0;

    foreach (var child in Children)
    {
        var width = child.DesiredSize.Width;
        var height = child.DesiredSize.Width;

        var finalRect = new Rect(runningWidth, runningHeight, width, height);
        child.Arrange(finalRect);

        runningWidth += width;
        runningHeight += height;
    }

    return new Size(runningWidth, runningHeight);
}
</pre>
</div>

Now we can use our panel like so:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">&lt;</span><span style="color: #800000">UserControl</span> <span style="color: #ff0000">x:Class</span><span style="color: #0000ff">="LayoutPanelExample.Page"</span>
    <span style="color: #ff0000">xmlns</span><span style="color: #0000ff">="http://schemas.microsoft.com/winfx/2006/xaml/presentation"</span> 
    <span style="color: #ff0000">xmlns:x</span><span style="color: #0000ff">="http://schemas.microsoft.com/winfx/2006/xaml"</span> 
    <span style="color: #ff0000">xmlns:c</span><span style="color: #0000ff">="clr-namespace:LayoutPanelExample"</span><span style="color: #0000ff">&gt;</span>
    <span style="color: #0000ff">&lt;</span><span style="color: #800000">Grid</span> <span style="color: #ff0000">x:Name</span><span style="color: #0000ff">="LayoutRoot"</span> <span style="color: #ff0000">Background</span><span style="color: #0000ff">="White"</span><span style="color: #0000ff">&gt;</span>
        <span style="color: #0000ff">&lt;</span><span style="color: #800000">c:DiagonalStackPanel</span><span style="color: #0000ff">&gt;</span>
            <span style="color: #0000ff">&lt;</span><span style="color: #800000">Button</span> <span style="color: #ff0000">Content</span><span style="color: #0000ff">="Button"</span><span style="color: #0000ff">/&gt;</span>
            <span style="color: #0000ff">&lt;</span><span style="color: #800000">Button</span> <span style="color: #ff0000">Content</span><span style="color: #0000ff">="Button"</span><span style="color: #0000ff">/&gt;</span>
            <span style="color: #0000ff">&lt;</span><span style="color: #800000">Button</span> <span style="color: #ff0000">Content</span><span style="color: #0000ff">="Button"</span><span style="color: #0000ff">/&gt;</span>
            <span style="color: #0000ff">&lt;</span><span style="color: #800000">Button</span> <span style="color: #ff0000">Content</span><span style="color: #0000ff">="Button"</span><span style="color: #0000ff">/&gt;</span>
            <span style="color: #0000ff">&lt;</span><span style="color: #800000">Button</span> <span style="color: #ff0000">Content</span><span style="color: #0000ff">="Button"</span><span style="color: #0000ff">/&gt;</span>
            <span style="color: #0000ff">&lt;</span><span style="color: #800000">Button</span> <span style="color: #ff0000">Content</span><span style="color: #0000ff">="Button"</span><span style="color: #0000ff">/&gt;</span>
        <span style="color: #0000ff">&lt;/</span><span style="color: #800000">c:DiagonalStackPanel</span><span style="color: #0000ff">&gt;</span>
    <span style="color: #0000ff">&lt;/</span><span style="color: #800000">Grid</span><span style="color: #0000ff">&gt;</span>
<span style="color: #0000ff">&lt;/</span><span style="color: #800000">UserControl</span><span style="color: #0000ff">&gt;</span></pre>
</div>

and we&#8217;ll get something that looks like:

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="226" alt="image" src="http://lostechies.com/rayhouston/files/2011/03CreatingaSilverlightLayoutPanel_A7C9/image_thumb.png" width="244" border="0" />](http://lostechies.com/rayhouston/files/2011/03CreatingaSilverlightLayoutPanel_A7C9/image_2.png) 

You could extend this by added Dependency Properties to the panel so that you can customize how each child reacts in the layout. This is how the Grid works. It looks at the properties set on the child elements and figures out what row and column to place them in.

<div class="wlWriterSmartContent" style="padding-right: 0px;padding-left: 0px;padding-bottom: 0px;margin: 0px;padding-top: 0px">
  Technorati Tags: <a href="http://technorati.com/tags/Silverlight" rel="tag">Silverlight</a>,<a href="http://technorati.com/tags/.NET" rel="tag">.NET</a>
</div>