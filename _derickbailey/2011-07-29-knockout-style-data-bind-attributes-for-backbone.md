---
wordpress_id: 500
title: Knockout Style Data-Bind Attributes For Backbone
date: 2011-07-29T12:01:51+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=500
dsq_thread_id:
  - "372024806"
categories:
  - Backbone
  - Backbone.ModelBinding
  - JavaScript
  - Model-View-Controller
---
Hot on the heels of [my Backbone.ModelBinding plugin release](http://lostechies.com/derickbailey/2011/07/24/awesome-model-binding-for-backbone-js/), I pushed a significant update out to [the github repository](https://github.com/derickbailey/backbone.modelbinding). Included in this release is the rest of the form input types, including radio button groups, select boxes, etc (be sure to read the documentation in the readme for a more complete list of Backbone.ModelBinding supports now). More importantly, though, in order to get the rest of the form element conventions built, I had to create a pluggable architecture for my plugin.

That&#8217;s right, folks, my plugin allows plugins. 🙂

And with the ability to plug your own model binding conventions into Backbone.ModelBinding, I had the crazy idea of putting together some basic &#8216;data-bind&#8217; attribute binding for any and all html elements and attributes, ala [Knockout](http://knockoutjs.com/).

## Re-Rendering On Model Update

Let&#8217;s take a look at the example I keep using for this plugin, again:

<img title="Screen Shot 2011-07-29 at 12.44.29 PM.png" src="http://lostechies.com/derickbailey/files/2011/07/Screen-Shot-2011-07-29-at-12.44.29-PM.png" border="0" alt="Screen Shot 2011 07 29 at 12 44 29 PM" width="600" height="393" />

We all know that Backbone.ModelBinding will handle the binding between the form inputs and the model that is bound to the add/edit view. However, the big box that represents our medication in the &#8220;Current Medications&#8221; list was not updated automatically. In order to get this to update, we had to re-render the view with the updated model.

Here&#8217;s what that code looks like (using an [event aggregator](http://lostechies.com/derickbailey/2011/07/19/references-routing-and-the-event-aggregator-coordinating-views-in-backbone-js/) in this case):

{% gist 1114226 2-rerender.js %}

Not bad &#8211; pretty standard backbone code, really. My medication view re-renders itself when the model has been saved. Except I don&#8217;t think we should have to re-render the entire view just to update a few fields on the form.

## Data-Bind Your Way To Happiness

Let&#8217;s try this again with my new data bind convention in place.

{% gist 1114226 3-databind.js %}

from 27 lines of code down to 13? Now that&#8217;s more like it!

But more important than the number of lines of code, you&#8217;ll notice that there&#8217;s no view re-rendering happening for the medication view. I&#8217;ve also removed the use of the event aggregator from this scenario. That&#8217;s because we don&#8217;t need to re-render the entire view when the model is updated, and we don&#8217;t need to wait for the event aggregator to tell us that the model was updated. We can let our data-bind conventions work their magic and update the medication view as changes are being made!

So, then&#8230; how do we get this magic to work? First off, we need to build the data-bind convention:

{% gist 1114226 1-DataBindConvention.js %}

Drop this code into your project, somewhere. Be sure it is executed after the Backbone.ModelBinding.js file has been loaded so that the very last line can correctly attach the new DataBindConvention to the convention list (also [checkout the readme on the github repo](https://github.com/derickbailey/backbone.modelbinding#readme) for more information on this convention&#8217;s structure).

Once we have that in place, we just need to add some data-bind attributes to our html. Here&#8217;s an approximation of what the html for the above medication view looks like:

{% gist 1114226 4-databind.html %}

The key here is the &#8216;data-bind&#8217; attribute that I&#8217;ve added to the divs that are displaying the model&#8217;s data. The data-bind convention that we set up looks for this attribute and then parses the information in it to set up the databinding. The first word of the attribute&#8217;s value tells our convention how to modify the element. The second word tells the convention which model attribute to use for the element&#8217;s value. In this case, we&#8217;re setting the text attribute of the divs to the model attribute that represents the data we want: &#8216;trade_name&#8217; (the name of the drug), &#8216;dosage&#8217; and &#8216;route&#8217;.

Now when we update our form by typing into the text boxes and then causing the text box to lose focus (so that the &#8216;change&#8217; event can fire), our medication view updates instantly!

<img title="Screen Shot 2011-07-29 at 12.47.43 PM.png" src="http://lostechies.com/derickbailey/files/2011/07/Screen-Shot-2011-07-29-at-12.47.43-PM.png" border="0" alt="Screen Shot 2011 07 29 at 12 47 43 PM" width="600" height="393" />

As I tabbed out of the &#8220;Trade name&#8221; field and into the &#8220;Dosage&#8221; field, the medication view updated and showed the change in the medication&#8217;s name!

## A Pale Reflection, A Glimpse Of What&#8217;s To Come

I realize that what I&#8217;ve built is only a pale reflection of what Knockout offers for it&#8217;s data-binding capabilties. However, what I&#8217;ve shown is already helping me simplifiy my applications, reduce the amount of code that I&#8217;m writing, and improve the user experience.

There&#8217;s a lot of work left to do with this convention before I bake it in, permanently. There are some additional behaviors to add to this convention and there are some tweaks to be made to the existing code. For example &#8211; better handle drop lists which right now, always end up displaying the &#8220;value&#8221; of the seelction instead of the text of the selection. I also want to explore [what Brandon Satrom is building for Knockout](http://userinexperience.com/?p=633), to remove the use of the data-bind attributes. I may be able to leverage what he&#8217;s building to help improve what I&#8217;m building.

I need to talk about how to build a proper cancel operation for this form, as well.. After all, we don&#8217;t want the medication view to continue displaying the modified information if we hit the &#8220;close&#8221; link instead of the &#8220;Save&#8221; button&#8230; but that&#8217;s another blog post (coming soon).

For now, you can [grab the source for this data-binding convention from the gist](https://gist.github.com/1114226) and start playing with data-bind for backbone it in your own application!
