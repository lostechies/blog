---
wordpress_id: 363
title: MVC Web Testing Strategies – verifying content
date: 2009-10-28T01:51:46+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/10/27/mvc-web-testing-strategies-verifying-content.aspx
dsq_thread_id:
  - "264716338"
categories:
  - ASPNETMVC
redirect_from: "/blogs/jimmy_bogard/archive/2009/10/27/mvc-web-testing-strategies-verifying-content.aspx/"
---
Some of the questions during the C4MVC presentation concerned how I liked to locate data displayed in the rendered HTML for validation purposes.&#160; You have quite a few options for doing so, such as:

  * Traverse HTML directly through the DOM 
  * Using existing semantic HTML information 
  * Adding semantic HTML information 
  * Wrapping data with specific HTML 

I’ll dismiss the first option immediately, it’s quite brittle to traverse only the DOM to locate data on a screen.&#160; If I have to have intimate knowledge of the entire HTML document rendered, the test will become far too dependent on the layout on the screen.&#160; If I decide to move information out of a table and into a definition list, my test will likely break.

From there, I’m left with basically two options – semantic HTML, whether it’s existing or added, or wrapping each data piece with custom HTML.&#160; In the presentation, two questions came up:

  * When locating a piece of information in a row in a table, why not use something more meaningful, such as the underlying entity’s ID to tag the data? 
  * Again in the table, why not use semantic information on the row, instead of adding meaningless HTML? 

Before we look at the different ways to verify content, let’s first look at what we want to verify.

### The original content

In the scenario I highlighted in the screencast, I walk though editing some information, then verifying that data was changed correctly.&#160; I still have tests for controllers, repositories and so on, but I want a high level scenario-based test to make sure the entire pipeline is working as expected.&#160; We try and pull the information out of the HTML content rendered, using some sort of UI testing tool.&#160; Without modifying the content, here’s what we have to work with: 

<pre><span style="color: blue">&lt;</span><span style="color: #a31515">div </span><span style="color: red">id</span><span style="color: blue">="main"&gt;
    &lt;</span><span style="color: #a31515">h2</span><span style="color: blue">&gt;</span>Products<span style="color: blue">&lt;/</span><span style="color: #a31515">h2</span><span style="color: blue">&gt;
    &lt;</span><span style="color: #a31515">table</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">thead</span><span style="color: blue">&gt;
            &lt;</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>Details<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>Name<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>Manufacturer<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>Price<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
            &lt;/</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
        &lt;/</span><span style="color: #a31515">thead</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">tbody</span><span style="color: blue">&gt;
            &lt;</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;&lt;</span><span style="color: #a31515">a </span><span style="color: red">href</span><span style="color: blue">="/Product/Edit/1"&gt;</span>Edit<span style="color: blue">&lt;/</span><span style="color: #a31515">a</span><span style="color: blue">&gt;&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>Insignia® - 26" Class / 720p / 60Hz / LCD HDTV DVD Combo<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>Insignia<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>359.99<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
            &lt;/</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
            &lt;</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;&lt;</span><span style="color: #a31515">a </span><span style="color: red">href</span><span style="color: blue">="/Product/Edit/2"&gt;</span>Edit<span style="color: blue">&lt;/</span><span style="color: #a31515">a</span><span style="color: blue">&gt;&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>Insignia® - 19" Class / 720p / 60Hz / LCD HDTV<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>Insignia<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>189.99<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
            &lt;/</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
            &lt;</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;&lt;</span><span style="color: #a31515">a </span><span style="color: red">href</span><span style="color: blue">="/Product/Edit/3"&gt;</span>Edit<span style="color: blue">&lt;/</span><span style="color: #a31515">a</span><span style="color: blue">&gt;&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>Dynex® - 15" Class / 720p / 60Hz / LCD HDTV<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>Dynex<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>159.99<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
            &lt;/</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
        &lt;/</span><span style="color: #a31515">tbody</span><span style="color: blue">&gt;
    &lt;/</span><span style="color: #a31515">table</span><span style="color: blue">&gt;
</span></pre>

[](http://11011.net/software/vspaste)

There’s more rendered than just this HTML, but this is the piece that really matters.&#160; We have some semantic CSS information, the DIV with an ID of “main”, but that’s about it.&#160; In our CSS, we style our tables based on an ID-Element selector, but we could have just have easily used a class name on the table.&#160; I’d like to verify that the price on the first product was changed correctly, but how do I verify this?&#160; How do I make sure that the value in that one cell is the new price?

### Choosing a strategy

I don’t want false positives or false negatives.&#160; I don’t want to look for just any table or any table cell in the markup, I want really the piece just around “359.99”.&#160; A few options to do so include:

  * Locating the outer DIV, finding the table, the first row, last cell, etc. 
  * Apply a special class to the TD just where that price is shown 
  * Add markup only around data-bound elements 

When I first started doing UI testing, I assumed that I wanted to be as semantic and pure as possible, and not try to change my markup just for tests.&#160; That idea lasted about an hour, and reality set in that in general, things not designed with testing in mind will be hard to test.&#160; Hard to write tests, hard to maintain tests.

My next idea was to add information as needed, perhaps a class name to an existing surrounding element that might double for styling.&#160; But I’ve moved completely away from that strategy as well, as **styling and UI testing are two different concerns that should not mix**.

Why keep these concerns separate?&#160; Frankly, because both concerns have two completely different reasons to change.&#160; Styling and behavior (such as IDs added for jQuery) are about design and interaction.&#160; UI testing is about verifying site behavior.&#160; Mixing the two concerns means my tests are more likely to break because I’ve changed the design.&#160; But design can change without behavior changing, so I don’t want to couple my tests to the visual design.&#160; Coupling UI tests to the site design is like unit testing using only the reflection API.

Instead, I’d rather couple my tests to something that better represents the view – and that would be the ViewModel.

### Strongly-typed views, strongly-typed tests

We use strongly-typed views because using a dictionary just leads to brittleness and fear of change.&#160; Strongly-typed views, along with the concept of the [Thunderdome Principle](http://codebetter.com/blogs/jeremy.miller/archive/2008/10/23/our-opinions-on-the-asp-net-mvc-introducing-the-thunderdome-principle.aspx), let us move past the issues of broken views and broken model binding.&#160; Instead of writing black-box tests against our UI, we can take advantage of the strongly-typed views, and modify our HTML rendered to get access to the rendered ViewModel.&#160; If you look at views from the point of view of “how to render a ViewModel”, then your UI tests can now talk in the language of the ViewModel.

But to help our UI tests out, we need to be able to locate information rendered from a ViewModel.&#160; Looking at our original HTML, the most fool-proof, straightforward way to do this would be to add HTML as close to the rendered ViewModel as possible.&#160; Let’s look at our view to see where this might be:

<pre><span style="color: blue">&lt;</span><span style="color: #a31515">h2</span><span style="color: blue">&gt;</span>Products<span style="color: blue">&lt;/</span><span style="color: #a31515">h2</span><span style="color: blue">&gt;
    </span><span style="background: #ffee62">&lt;%</span> <span style="color: blue">var </span>products = Model; <span style="background: #ffee62">%&gt;
</span>    
    <span style="color: blue">&lt;</span><span style="color: #a31515">table</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">thead</span><span style="color: blue">&gt;
            &lt;</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>Details<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>Name<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>Manufacturer<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>Price<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
            &lt;/</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
        &lt;/</span><span style="color: #a31515">thead</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">tbody</span><span style="color: blue">&gt;
        </span><span style="background: #ffee62">&lt;%</span> <span style="color: blue">foreach </span>(<span style="color: blue">var </span>product <span style="color: blue">in </span>products) { <span style="background: #ffee62">%&gt;
</span>            <span style="color: blue">&lt;</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span><span style="background: #ffee62">&lt;%</span><span style="color: blue">= </span>Html.ActionLink(<span style="color: #a31515">"Edit"</span>, <span style="color: #a31515">"Edit"</span>, <span style="color: blue">new </span>{ id = product.Id }) <span style="background: #ffee62">%&gt;</span><span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span><span style="background: #ffee62">&lt;%</span><span style="color: blue">= </span>product.Name <span style="background: #ffee62">%&gt;</span><span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span><span style="background: #ffee62">&lt;%</span><span style="color: blue">= </span>product.ManufacturerName <span style="background: #ffee62">%&gt;</span><span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span><span style="background: #ffee62">&lt;%</span><span style="color: blue">= </span>product.Price <span style="background: #ffee62">%&gt;</span><span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
            &lt;/</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
        </span><span style="background: #ffee62">&lt;%</span> } <span style="background: #ffee62">%&gt;
</span>        <span style="color: blue">&lt;/</span><span style="color: #a31515">tbody</span><span style="color: blue">&gt;
    &lt;/</span><span style="color: #a31515">table</span><span style="color: blue">&gt;
</span></pre>

[](http://11011.net/software/vspaste)

So what’s the ideal spot here?&#160; On the table?&#160; The table body?&#160; Row?&#160; Cell?&#160; These are all possible…and all coupled to the design of the UI, rather than the shape of the ViewModel.&#160; Instead of coupling to the design of the HTML, we can instead change every spot where we render the ViewModel directly to have extra HTML used only for UI tests.&#160; In the presentation, I move towards this model:

<pre><span style="color: blue">&lt;</span><span style="color: #a31515">tbody</span><span style="color: blue">&gt;
</span><span style="background: #ffee62">&lt;%</span> <span style="color: blue">var </span>i = 0; <span style="background: #ffee62">%&gt;
&lt;%</span> <span style="color: blue">foreach </span>(<span style="color: blue">var </span>product <span style="color: blue">in </span>products) { <span style="background: #ffee62">%&gt;
</span>    <span style="color: blue">&lt;</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span><span style="background: #ffee62">&lt;%</span><span style="color: blue">= </span>Html.ActionLink(<span style="color: #a31515">"Edit"</span>, <span style="color: #a31515">"Edit"</span>, <span style="color: blue">new </span>{ id = product.Id }) <span style="background: #ffee62">%&gt;</span><span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span><span style="background: #ffee62">&lt;%</span><span style="color: blue">= </span>Html.Span(m =&gt; m[i].Name) <span style="background: #ffee62">%&gt;</span><span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span><span style="background: #ffee62">&lt;%</span><span style="color: blue">= </span>Html.Span(m =&gt; m[i].ManufacturerName) <span style="background: #ffee62">%&gt;</span><span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span><span style="background: #ffee62">&lt;%</span><span style="color: blue">= </span>Html.Span(m =&gt; m[i].Price) <span style="background: #ffee62">%&gt;</span><span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
    &lt;/</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
</span><span style="background: #ffee62">&lt;%
</span>    i++;
} <span style="background: #ffee62">%&gt;
</span><span style="color: blue">&lt;/</span><span style="color: #a31515">tbody</span><span style="color: blue">&gt;</span></pre>

[](http://11011.net/software/vspaste)

In practice, I’ll use a similar concept to the [Opinionated Input Builders Eric highlighted a while back](https://lostechies.com/blogs/hex/archive/2009/06/09/opinionated-input-builders-for-asp-net-mvc-using-partials-part-i.aspx).&#160; Instead of input elements, I’ll solely render at the core, span tags.&#160; Here is the rendered HTML:

<pre><span style="color: blue">&lt;</span><span style="color: #a31515">div </span><span style="color: red">id</span><span style="color: blue">="main"&gt;
    &lt;</span><span style="color: #a31515">h2</span><span style="color: blue">&gt;</span>Products<span style="color: blue">&lt;/</span><span style="color: #a31515">h2</span><span style="color: blue">&gt;
    &lt;</span><span style="color: #a31515">table</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">thead</span><span style="color: blue">&gt;
            &lt;</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>Details<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>Name<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>Manufacturer<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;</span>Price<span style="color: blue">&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;

            &lt;/</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
        &lt;/</span><span style="color: #a31515">thead</span><span style="color: blue">&gt;
        &lt;</span><span style="color: #a31515">tbody</span><span style="color: blue">&gt;
            &lt;</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;&lt;</span><span style="color: #a31515">a </span><span style="color: red">href</span><span style="color: blue">="/Product/Edit/1"&gt;</span>Edit<span style="color: blue">&lt;/</span><span style="color: #a31515">a</span><span style="color: blue">&gt;&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;&lt;</span><span style="color: #a31515">span </span><span style="color: red">id</span><span style="color: blue">='_0__Name'&gt;</span>Insignia® - 26" Class / 720p / 60Hz / LCD HDTV DVD Combo<span style="color: blue">&lt;/</span><span style="color: #a31515">span</span><span style="color: blue">&gt;&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;&lt;</span><span style="color: #a31515">span </span><span style="color: red">id</span><span style="color: blue">='_0__ManufacturerName'&gt;</span>Insignia<span style="color: blue">&lt;/</span><span style="color: #a31515">span</span><span style="color: blue">&gt;&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;&lt;</span><span style="color: #a31515">span </span><span style="color: red">id</span><span style="color: blue">='_0__Price'&gt;</span>359.99<span style="color: blue">&lt;/</span><span style="color: #a31515">span</span><span style="color: blue">&gt;&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
            &lt;/</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
            &lt;</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;&lt;</span><span style="color: #a31515">a </span><span style="color: red">href</span><span style="color: blue">="/Product/Edit/2"&gt;</span>Edit<span style="color: blue">&lt;/</span><span style="color: #a31515">a</span><span style="color: blue">&gt;&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;&lt;</span><span style="color: #a31515">span </span><span style="color: red">id</span><span style="color: blue">='_1__Name'&gt;</span>Insignia® - 19" Class / 720p / 60Hz / LCD HDTV<span style="color: blue">&lt;/</span><span style="color: #a31515">span</span><span style="color: blue">&gt;&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;&lt;</span><span style="color: #a31515">span </span><span style="color: red">id</span><span style="color: blue">='_1__ManufacturerName'&gt;</span>Insignia<span style="color: blue">&lt;/</span><span style="color: #a31515">span</span><span style="color: blue">&gt;&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;&lt;</span><span style="color: #a31515">span </span><span style="color: red">id</span><span style="color: blue">='_1__Price'&gt;</span>189.99<span style="color: blue">&lt;/</span><span style="color: #a31515">span</span><span style="color: blue">&gt;&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
            &lt;/</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
            &lt;</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;&lt;</span><span style="color: #a31515">a </span><span style="color: red">href</span><span style="color: blue">="/Product/Edit/3"&gt;</span>Edit<span style="color: blue">&lt;/</span><span style="color: #a31515">a</span><span style="color: blue">&gt;&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;&lt;</span><span style="color: #a31515">span </span><span style="color: red">id</span><span style="color: blue">='_2__Name'&gt;</span>Dynex® - 15" Class / 720p / 60Hz / LCD HDTV<span style="color: blue">&lt;/</span><span style="color: #a31515">span</span><span style="color: blue">&gt;&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;&lt;</span><span style="color: #a31515">span </span><span style="color: red">id</span><span style="color: blue">='_2__ManufacturerName'&gt;</span>Dynex<span style="color: blue">&lt;/</span><span style="color: #a31515">span</span><span style="color: blue">&gt;&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
                &lt;</span><span style="color: #a31515">td</span><span style="color: blue">&gt;&lt;</span><span style="color: #a31515">span </span><span style="color: red">id</span><span style="color: blue">='_2__Price'&gt;</span>159.99<span style="color: blue">&lt;/</span><span style="color: #a31515">span</span><span style="color: blue">&gt;&lt;/</span><span style="color: #a31515">td</span><span style="color: blue">&gt;
            &lt;/</span><span style="color: #a31515">tr</span><span style="color: blue">&gt;
        &lt;/</span><span style="color: #a31515">tbody</span><span style="color: blue">&gt;
    &lt;/</span><span style="color: #a31515">table</span><span style="color: blue">&gt;
</span></pre>

[](http://11011.net/software/vspaste)

Notice that each data-bound output is wrapped with a span tag – and a special span tag at that.&#160; The span tag has a unique ID that represents the expression used to render that piece of data.&#160; The first product name shown comes from the expression “m => m[0].Name”.&#160; Because I know the ViewModel used to render this view, I can use an expression combined with a UI testing tool to locate the rendering of any piece of information on the screen.

The downside of this strategy is the amount of HTML added to the final document render.&#160; But since we’ve separated HTML used for styling and behavior, and HTML rendered strictly for testing, we can put a switch in our application so that for environments not doing UI testing, the span tag isn’t ever rendered!&#160; We can then get the best of both worlds – non-obtrusive JavaScript on top of semantic HTML, and flip a switch to be able to get to any piece of information on the rendered HTML.

Because our UI tests also use the ViewModel types and expressions to locate the same rendered ViewModels that the views used to render, we no longer run into the issue where our UI tests become disconnected from the views rendered.&#160; If we delete a property on our ViewModel, guess what, the UI test no longer compiles!

### Wrapping it up

Developing a UI testing strategy isn’t the easiest thing in the world.&#160; In our current project, I think we had three or four evolutions before we finally settled on a UI testing strategy we like.&#160; And it’s still not perfect – we’re still looking at ways to make UI testing easy, expressive, and more valuable.&#160; But gone are the days where a styling change broke our tests.&#160; When our UI tests fail now, it’s more along the lines of a new required field, changing business rules and so on.

I don’t like mixing styling and behavior with locating data-bound UI elements, simply because both have very different reasons for change.&#160; But by taking advantage of our strongly-typed views in our UI tests, we can render the ViewModel in such a way that makes it dirt-simple to locate individual pieces of our ViewModel on the final rendered page.