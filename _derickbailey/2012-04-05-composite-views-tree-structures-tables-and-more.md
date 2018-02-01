---
id: 866
title: 'Composite Views: Tree Structures, Tables, And More'
date: 2012-04-05T06:58:17+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=866
dsq_thread_id:
  - "637572566"
categories:
  - Backbone
  - Composite Apps
  - Design Patterns
  - JavaScript
  - JQuery
  - JSFiddle
  - Marionette
---
One of the more recent features that I added to my [Backbone.Marionette](https://github.com/derickbailey/backbone.marionette) framework is the CompositeView. It&#8217;s actually been in the code for a while now, but in a recent version I extracted it out of the CollectionView and in to it&#8217;s own object type directly. This helped to give the functionality better exposure and helped to clean things up quite a bit.

## Composite Structures

The CompositeView combines both the ItemView and the CollectionView in to one convenient structure. But what does that really mean? To understand this, you have to step back to the core design patterns outline by the [GoF](http://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612), and look at the [Composite structure pattern](http://en.wikipedia.org/wiki/Composite_pattern).

The basic idea behind this pattern is most easily understood as a tree structure where every &#8220;leaf&#8221; &#8211; or end point &#8211; may also a &#8220;branch&#8221; &#8211; or collection of leaves and branches. We&#8217;re all familiar with this, whether or not we realize it:

<img title="Screen Shot 2012-03-23 at 4.41.06 PM.png" src="http://lostechies.com/derickbailey/files/2012/03/Screen-Shot-2012-03-23-at-4.41.06-PM.png" alt="Screen Shot 2012 03 23 at 4 41 06 PM" width="344" height="459" border="0" />

The basic folder structure of your computer is a composite structure. Every folder is itself a leaf and a branch. That is, a folder can be the end of the line with nothing further, or it can be a container for other leaves and branches (files and folders).

## TreeViews: Recursive / Hierarchical View Structures

The core idea behind the CompositeView in Marionette is that it represents a visualization of a composite structure. The folder view in a tree structure can easily be rendered with a nested hierarchy of CompositeView and ItemView combinations.

For example:

[gist id=2226605 file=1.js]

In this example, I&#8217;ve defined a CompositeView called \`TreeView\`. By default, a CompositeView is recursive. For every item in the collection that the composite view is handed, the same CompositeView type will be used to render the item. Of course you can override the item view by specifying an \`itemView\` attribute. In this case, though, we want the recursive structure.

This recursive reference structure will allow the CompositeView to render a tree structure from top to bottom. The only real limitation in the structure&#8217;s depth will be the call stack limitations of your JavaScript runtime.

The other view that I&#8217;ve defined is the TreeRoot, which is based on a CollectionView. A CompositeView and CollectionView are very similar in functionality. The difference is that a CompositeView renders a single model and template as a wrapper around the collection, while the CollectionView only renders the collection. In this case, I&#8217;m using a CollectionView as the tree&#8217;s root because the top level of the tree structure is a collection of nodes. I don&#8217;t want any wrapper HTML structure rendered around the top level of the collection &#8211; I just want the collection to render.

For the TreeRoot, note that I am specifying an \`itemView\` and I have it set to the \`TreeView\` type. This means that every item in the top level of the collection will render as a TreeView type, and since the TreeView type is a recursive composite view, the entire tree structure will be rendered.

Here&#8217;s the TreeView example [running in a JSFiddle](http://jsfiddle.net/derickbailey/AdWjU/):



But there are more uses for the CompositeView than just nested hierarchies. In fact, I rarely use CompositeView for this purpose, because I rarely need nested hierarchies. The most common use case that I have for the CompositeView is a simple collection rendered within an outer template.

**UPDATE:** Chris Hoffman pointed out, in the comments, that this version of the code renders a <ul> tag around every <li> in the result. I did some digging and managed to create a version that doesn&#8217;t have this problem. But my version left an empty <ul></ul> at the bottom of every branch of the tree. Chris then created a version that looks for empty <ul> tags and removes them.

  * My updated version: <http://jsfiddle.net/derickbailey/xX9X3/>
  * Chris&#8217; updated version: <http://jsfiddle.net/hoffmanc/NH9J6/>

## Grid Views: Collections With Wrapper Templates

It seems fairly common, at least in my applications, to need an area of your application rendered with some information that contains a collection or list. For the most basic implementations, a CollectionView will work fine. But sometimes you need to have more than just the list of items. Sometimes you need the extra wrapper around the list.

For example, you might have a list of users that you want to put in a table or grid. The easiest way to do this is to use a CompositeView where the &#8216;itemView&#8217; is a row, and the CompositeView is the table / grid itself:

[gist id=2226605 file=2.js]

In this example, the &#8216;template&#8217; that I defined on the CompositeView directly contains the raw <thead> and <tbody> definitions. This puts the basic table structure in place. The &#8216;GridRow&#8217;, then, has a template of &#8216;row-template&#8217; and renders with a &#8216;tagName&#8217; of &#8220;tr&#8221;. This produces the needed &#8220;<tr>&#8221; tag with the &#8220;<td>&#8221; tags from the template getting stuffed in to the table row.

The last thing to note is the &#8220;appendHtml&#8221; method in the CompositeView definition. By default, the appendHtml method will do what the name suggests: append the HTML for each item to the end of the template from the composite view. By overriding this method with my own implementation for this structure, though, I can make sure that I am stuffing the rendered HTML for each item / row in to the table&#8217;s &#8220;<tbody>&#8221; tag, and end up with the table structure that I need.

Here&#8217;s what that looks like, [running in a JSFiddle](http://jsfiddle.net/derickbailey/me4NK/):



## A Drop-Down Menu

[A Marionette user](https://twitter.com/jobseriously/status/187958745991626753) created a drop-down menu structure with the CompositeView. I love this example so I wanted to share [the JSFiddle](http://jsfiddle.net/Sjrgy/8/) along with the others that I built.



## An Accordion View

[Another Marionette user](https://twitter.com/#!/bordev) has created an accordion view in [this JSFiddle](http://jsfiddle.net/bordev/xzeHb/):



I particularly like the way he separated the base accordion widget implementation from the specific instance being displayed.

## A Model For The Composite Wrapper

You can specify a &#8216;model&#8217; for a CompositeView to render, as well. When the CompositeView is rendering the &#8216;template&#8217; that you specify, the &#8216;model&#8217; that you hand to the composite view will be used as the data source for the template. This means you can create a parent / children relationship with data from both the parent and children showing up.

## Events For The Composite Wrapper

DOM event can also be handled in the composite view&#8217;s wrapper. Specify the standard &#8220;events&#8221; declaration in the composite view definition and you&#8217;re good to go. Just keep in mind that your composite view may pick up events from the nested children if your selectors are not written carefully. This can be used to your advantage at times, but can also cause problems if you&#8217;re not careful.

## One View, Many Uses

There are more uses for the CompositeView, still. When you start combining this view with other view types, and then throw in the idea of [Regions](http://lostechies.com/derickbailey/2011/12/12/composite-js-apps-regions-and-region-managers/) and [Layouts](http://lostechies.com/derickbailey/2012/03/22/managing-layouts-and-nested-views-with-backbone-marionette/) to manage the display of views, you can quickly see how this becomes a very flexible tool to use. Of course, it&#8217;s not the only tool you should use. There certainly are scenarios where it&#8217;s not the right choice, but that&#8217;s why I have so many available view types in Marionette, and why I support any object that extends from Backbone.View with my Region objects.