---
wordpress_id: 532
title: Building forms for deep View Model graphs in ASP.NET MVC
date: 2011-09-07T14:01:47+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2011/09/07/building-forms-for-deep-view-model-graphs-in-asp-net-mvc/
dsq_thread_id:
  - "407300056"
categories:
  - ASPNETMVC
---
ASP.NET MVC 2 introduced a multitude of strongly-typed helpers for building form elements for strongly-typed views. These strongly-typed helpers use lambda expressions to build a complete input element, including the correct name and value for the element.

The lambda expressions are quite powerful, allowing you to build quite complex edit models and have model binding put everything back together again. A complex view model type such as:

<pre class="code"><span style="color: blue">public class </span><span style="color: #2b91af">ProductEditModel
</span>{
    <span style="color: blue">public string </span>Name { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">PriceEditModel </span>Price { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }

    <span style="color: blue">public class </span><span style="color: #2b91af">PriceEditModel
    </span>{
        <span style="color: blue">public decimal </span>Value { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
        <span style="color: blue">public string </span>Currency { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    }
}
</pre>

Can be quite easily built in a view:

<pre class="code"><span style="background: yellow">@</span><span style="color: blue">using </span>(Html.BeginForm()) {
    <span style="color: blue">&lt;</span><span style="color: maroon">p</span><span style="color: blue">&gt;
        </span><span style="background: yellow">@</span>Html.LabelFor(m =&gt; m.Name)
        <span style="background: yellow">@</span>Html.TextBoxFor(m =&gt; m.Name)
    <span style="color: blue">&lt;/</span><span style="color: maroon">p</span><span style="color: blue">&gt;
    &lt;</span><span style="color: maroon">p</span><span style="color: blue">&gt;
        </span><span style="background: yellow">@</span>Html.LabelFor(m =&gt; m.Price.Currency)
        <span style="background: yellow">@</span>Html.TextBoxFor(m =&gt; m.Price.Currency)
    <span style="color: blue">&lt;/</span><span style="color: maroon">p</span><span style="color: blue">&gt;
    &lt;</span><span style="color: maroon">p</span><span style="color: blue">&gt;
        </span><span style="background: yellow">@</span>Html.LabelFor(m =&gt; m.Price.Value)
        <span style="background: yellow">@</span>Html.TextBoxFor(m =&gt; m.Price.Value)
    <span style="color: blue">&lt;/</span><span style="color: maroon">p</span><span style="color: blue">&gt;
</span>}
</pre>

As long as we’re using the full model expression from the top-most model type to build the input elements, the correct HTML will be built. Suppose that you want to now pull that PriceEditModel out into a partial, and keep its view separate from the parent view. We change our view to instead render a partial for the Price property:

<pre class="code"><span style="background: yellow">@</span><span style="color: blue">using </span>(Html.BeginForm()) {
    <span style="color: blue">&lt;</span><span style="color: maroon">p</span><span style="color: blue">&gt;
        </span><span style="background: yellow">@</span>Html.LabelFor(m =&gt; m.Name)
        <span style="background: yellow">@</span>Html.TextBoxFor(m =&gt; m.Name)
    <span style="color: blue">&lt;/</span><span style="color: maroon">p</span><span style="color: blue">&gt;
    </span><span style="background: yellow">@</span>Html.Partial(<span style="color: #a31515">"_PriceEditModel"</span>, Model.Price);
}
</pre>

And our partial is just the extracted view code, except now built against the PriceEditModel type:

<pre class="code"><span style="background: yellow">@model </span><span style="color: #2b91af">ProductEditModel</span>.<span style="color: #2b91af">PriceEditModel

</span><span style="color: blue">&lt;</span><span style="color: maroon">p</span><span style="color: blue">&gt;
    </span><span style="background: yellow">@</span>Html.LabelFor(m =&gt; m.Currency)
    <span style="background: yellow">@</span>Html.TextBoxFor(m =&gt; m.Currency)
<span style="color: blue">&lt;/</span><span style="color: maroon">p</span><span style="color: blue">&gt;
&lt;</span><span style="color: maroon">p</span><span style="color: blue">&gt;
    </span><span style="background: yellow">@</span>Html.LabelFor(m =&gt; m.Value)
    <span style="background: yellow">@</span>Html.TextBoxFor(m =&gt; m.Value)
<span style="color: blue">&lt;/</span><span style="color: maroon">p</span><span style="color: blue">&gt;
</span></pre>

However, the resultant HTML no longer matches up the model members correctly. Although the screen _looks_ right:

[<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/09/image_thumb.png" width="514" height="484" />](http://lostechies.com/content/jimmybogard/uploads/2011/09/image.png)

When we look at the actual HTML, something’s not right any more:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/09/image_thumb1.png" width="468" height="67" />](http://lostechies.com/content/jimmybogard/uploads/2011/09/image1.png)

Instead of our member name having the correct parent member in its name as “Price.Currency”, we only see “Currency”. Sure enough, when we get to our POST action, the Price member is null as model binding could not line things up any more:

[<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/09/image_thumb2.png" width="354" height="66" />](http://lostechies.com/content/jimmybogard/uploads/2011/09/image2.png)

Not exactly what we want to do here!

So what are our options? In order to make sure model binding works for models with partials, we can scope our models in our partials to the parent type. That is, make our partial’s model type “ProductEditModel” instead of “PriceEditModel”.

Not a very appealing option!

We do have a better option, with the MVC 2 feature of templated helpers. Templated helpers elegantly solve the deep View Model graph problem.

### Building with templated helpers

[Templated helpers](http://bradwilson.typepad.com/blog/2009/10/aspnet-mvc-2-templates-part-1-introduction.html) are different than partials in that special contextual information from the parent is passed down to the child as long as we’re using the Html.EditorXyz() HtmlHelper methods. To convert our view to use templated helpers, let’s just build an editor template for each view model type we have:

[<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/09/image_thumb3.png" width="231" height="97" />](http://lostechies.com/content/jimmybogard/uploads/2011/09/image3.png)

These are just normal partials in Razor, with the exception that they’re placed in the special EditorTemplates folder. In our ProductEditModel partial, we just move what we had in our Edit view over:

<pre class="code"><span style="background: yellow">@model </span><span style="color: #2b91af">ProductEditModel

</span><span style="color: blue">&lt;</span><span style="color: maroon">p</span><span style="color: blue">&gt;
    </span><span style="background: yellow">@</span>Html.LabelFor(m =&gt; m.Name)
    <span style="background: yellow">@</span>Html.TextBoxFor(m =&gt; m.Name)
<span style="color: blue">&lt;/</span><span style="color: maroon">p</span><span style="color: blue">&gt;
</span><span style="background: yellow">@</span>Html.EditorFor(m =&gt; m.Price)
</pre>

There is one slight difference here, however. Instead of rendering a partial for Price, we render the editor for the Price member. The PriceEditModel template is just what we had in our original partial with no changes needed:

<pre class="code"><span style="background: yellow">@model </span><span style="color: #2b91af">ProductEditModel</span>.<span style="color: #2b91af">PriceEditModel

</span><span style="color: blue">&lt;</span><span style="color: maroon">p</span><span style="color: blue">&gt;
    </span><span style="background: yellow">@</span>Html.LabelFor(m =&gt; m.Currency)
    <span style="background: yellow">@</span>Html.TextBoxFor(m =&gt; m.Currency)
<span style="color: blue">&lt;/</span><span style="color: maroon">p</span><span style="color: blue">&gt;
&lt;</span><span style="color: maroon">p</span><span style="color: blue">&gt;
    </span><span style="background: yellow">@</span>Html.LabelFor(m =&gt; m.Value)
    <span style="background: yellow">@</span>Html.TextBoxFor(m =&gt; m.Value)
<span style="color: blue">&lt;/</span><span style="color: maroon">p</span><span style="color: blue">&gt;
</span></pre>

The difference now is that our templated helper knows that the parent model used the “Price” member to build out this partial. In our parent Edit view, things become a bit simpler:

<pre class="code"><span style="background: yellow">@</span><span style="color: blue">using </span>(Html.BeginForm()) {
    
    <span style="background: yellow">@</span>Html.EditorForModel()

    <span style="color: blue">&lt;</span><span style="color: maroon">input </span><span style="color: red">type</span><span style="color: blue">="submit" /&gt;
    
</span>}
</pre>

ASP.NET MVC will look at the type of the model to see if an editor template exists for that specific model type when we call the EditorForModel method. Because we built editor templates for each specific model type, it doesn’t matter where in the hierarchy these nested types exist. ASP.NET MVC will keep passing in the parent’s context so that deep nested graphs contain the right context information.

Looking at the resultant HTML, we can confirm that everything looks good there:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/09/image_thumb4.png" width="549" height="67" />](http://lostechies.com/content/jimmybogard/uploads/2011/09/image4.png)

The input element’s name now has the correct parent property name in its value. Debugging into the POST action confirms that the model binding now works correctly:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/09/image_thumb5.png" width="472" height="100" />](http://lostechies.com/content/jimmybogard/uploads/2011/09/image5.png)

With the templates helpers of ASP.NET MVC 2, we can now build nested models in our views and still take advantage of features like partials. The only caveat is that we need to make sure we build our views using templates helpers and the Html.EditorXyz methods. Otherwise, our views are minimally impacted.

And just to get a side complaint in, this was _very_ annoying to build in MVC 1.0, to build nested hierarchies with strongly typed helpers respecting graphs including collection types all the way down. Just more code I got to delete with the later versions of MVC!