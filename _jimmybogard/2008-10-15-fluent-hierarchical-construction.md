---
wordpress_id: 240
title: Fluent hierarchical construction
date: 2008-10-15T11:12:48+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/10/15/fluent-hierarchical-construction.aspx
dsq_thread_id:
  - "264715949"
categories:
  - 'C#'
redirect_from: "/blogs/jimmy_bogard/archive/2008/10/15/fluent-hierarchical-construction.aspx/"
---
Building a hierarchy of objects doesn’t happen that often in code, but when it does, it can get pretty ugly.&#160; Most of the time, the hierarchy will come out of the database.&#160; Recently, we had a hierarchy that needed to be built straight in code.&#160; We had something like this going on:

<pre><span style="color: blue">public static </span><span style="color: #2b91af">Menu </span>BuildMenu()
{
    <span style="color: blue">var </span>menu = <span style="color: blue">new </span><span style="color: #2b91af">Menu</span>();

    <span style="color: green">// Main menu
    </span><span style="color: blue">var </span>products = <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>();
    products.Title = <span style="color: #a31515">"Products"</span>;

    <span style="color: blue">var </span>services = <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>();
    services.Title = <span style="color: #a31515">"Services"</span>;

    <span style="color: blue">var </span>support = <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>();
    support.Title = <span style="color: #a31515">"Support"</span>;

    <span style="color: blue">var </span>contact = <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>();
    contact.Title = <span style="color: #a31515">"Contact"</span>;

    menu.AddItem(products);
    menu.AddItem(services);
    menu.AddItem(support);
    menu.AddItem(contact);

    <span style="color: green">// Products menu
    </span><span style="color: blue">var </span>hardware = <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>();
    hardware.Title = <span style="color: #a31515">"Hardware"</span>;

    <span style="color: blue">var </span>software = <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>();
    software.Title = <span style="color: #a31515">"Software"</span>;

    products.AddItem(hardware);
    products.AddItem(software);

    <span style="color: green">// Hardware menu
    </span><span style="color: blue">var </span>computers = <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>();
    computers.Title = <span style="color: #a31515">"Computers"</span>;

    <span style="color: blue">var </span>printers = <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>();
    printers.Title = <span style="color: #a31515">"Printers"</span>;

    hardware.AddItem(computers);
    hardware.AddItem(printers);

    <span style="color: green">// Services menu
    </span><span style="color: blue">var </span>consulting = <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>();
    consulting.Title = <span style="color: #a31515">"Consulting"</span>;

    <span style="color: blue">var </span>onSiteSupport = <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>();
    onSiteSupport.Title = <span style="color: #a31515">"On-Site Support"</span>;

    services.AddItem(consulting);
    services.AddItem(onSiteSupport);

    <span style="color: blue">return </span>menu;
}</pre>

[](http://11011.net/software/vspaste)

Our example was different, but it’s the same idea of building a hierarchy of objects.&#160; In the above code, we’re trying to build out our menu structure for a website.&#160; This is a simple hierarchy, but more complex ones could go on for hundreds of lines.&#160; It’s almost impossible to see what’s going on there, and what is a child of what.&#160; You can try and create conventions inside the code, such as the comments and organization of the building.

There are some more fluent ways to build hierarchies out there, as shown by [LINQ to XML](http://msdn.microsoft.com/en-us/library/bb387061.aspx).&#160; Instead of manually setting up all of the objects, we use one statement to construct everything, making use of existing features around since .NET 1.0.

The basic idea behind fluent hierarchical construction is:

  * Create a constructor that takes all necessary properties to set up the individual item
  * Add a params parameter that takes all the children for the parent

First, we can switch our Menu class to use fluent construction:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">Menu
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">MenuItem</span>&gt; _menuItems = <span style="color: blue">new </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">MenuItem</span>&gt;();

    <span style="color: blue">public </span>Menu(<span style="color: blue">params </span><span style="color: #2b91af">MenuItem</span>[] menuItems)
    {
        _menuItems.AddRange(menuItems);
    }

    <span style="color: blue">public void </span>AddItem(<span style="color: #2b91af">MenuItem </span>menuItem)
    {
        _menuItems.Add(menuItem);
    }

    <span style="color: blue">public </span><span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">MenuItem</span>&gt; GetMenuItems()
    {
        <span style="color: blue">return </span>_menuItems;
    }
}</pre>

[](http://11011.net/software/vspaste)

We created a constructor that took a param array of child menu items, which are then added to its menu items collection.&#160; Next, we need to switch the child type to take both the Title as well as the child menu items:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">MenuItem
</span>{
    <span style="color: blue">private readonly </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">MenuItem</span>&gt; _menuItems = <span style="color: blue">new </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">MenuItem</span>&gt;();

    <span style="color: blue">public </span>MenuItem(<span style="color: blue">string </span>title, <span style="color: blue">params </span><span style="color: #2b91af">MenuItem</span>[] menuItems)
    {
        Title = title;
        _menuItems.AddRange(menuItems);
    }

    <span style="color: blue">public string </span>Title { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }

    <span style="color: blue">public void </span>AddItem(<span style="color: #2b91af">MenuItem </span>menuItem)
    {
        _menuItems.Add(menuItem);
    }

    <span style="color: blue">public </span><span style="color: #2b91af">IEnumerable</span>&lt;<span style="color: #2b91af">MenuItem</span>&gt; GetMenuItems()
    {
        <span style="color: blue">return </span>_menuItems;
    }
}</pre>

[](http://11011.net/software/vspaste)

All properties that we need to set on a hierarchy class need to go in the constructor for this technique to work.&#160; Optional or additional parameters can be added with overloaded constructors, with the additional parameters added just before the params one.

With our new constructors in place, our menu construction becomes quite a bit terser:

<pre><span style="color: blue">public static </span><span style="color: #2b91af">Menu </span>BuildMenu()
{
    <span style="color: blue">var </span>menu =
        <span style="color: blue">new </span><span style="color: #2b91af">Menu</span>(
            <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>(<span style="color: #a31515">"Products"</span>,
                <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>(<span style="color: #a31515">"Hardware"</span>,
                    <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>(<span style="color: #a31515">"Computers"</span>),
                    <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>(<span style="color: #a31515">"Printers"</span>)),
                <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>(<span style="color: #a31515">"Software"</span>)),
            <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>(<span style="color: #a31515">"Services"</span>,
                <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>(<span style="color: #a31515">"Consulting"</span>),
                <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>(<span style="color: #a31515">"On-Site Support"</span>)),
            <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>(<span style="color: #a31515">"Support"</span>),
            <span style="color: blue">new </span><span style="color: #2b91af">MenuItem</span>(<span style="color: #a31515">"Contact"</span>)
        );

    <span style="color: blue">return </span>menu;
}</pre>

[](http://11011.net/software/vspaste)

Not only is the number of lines of code reduced, but I can far more easily discern the structure of the hierarchy just by looking at the structure of the construction.&#160; You can literally see the tree of objects in the construction.&#160; No more temporary variables hang around, just so we can add children with individual method calls.&#160; Because we used the params keyword, we don’t even need to provide any children if they don’t exist.&#160; Params also allow us to create a comma-separated list of the children, instead of creating an array.

The nice thing is, all this technique used was application of the params keyword in the constructor for child objects.&#160; As long as we ensure that all properties needed to be set are available in an overloaded constructor, this technique should work.