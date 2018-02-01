---
id: 484
title: Awesome Model Binding For Backbone.js
date: 2011-07-24T13:19:37+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=484
dsq_thread_id:
  - "367270333"
categories:
  - Backbone
  - Backbone.ModelBinding
  - JavaScript
  - JQuery
  - Model-View-Controller
---
A few weeks ago, [Brandon Satrom](https://twitter.com/#!/BrandonSatrom) introduced me to Knockout.js by [pointing me to a video by Steve Sanderson](http://channel9.msdn.com/events/MIX/MIX11/FRM08). I haven&#8217;t had a chance to try KO, yet, but I have to say I was blown away by the data-binding capabilties. Then, Brandon puts up [this blog post and talks about how he made KO even more awesome](http://userinexperience.com/?p=633) by eliminating the data-* attributes that KO needs, from his HTML markup.

Needless to say, I was envious. KO&#8217;s data binding is impressive &#8211; especially compared to what we get out of the box with Backbone. Then this last week, [Neive](https://twitter.com/#!/nieveg) pointed me to a post by Brad Phelan that talks about [adding better model binding to Backbone](http://xtargets.com/2011/06/11/binding-model-attributes-to-form-elements-with-backbone-js/).

With all of this gong on, I was inspired! So I set out to build not just a manual configuration model binder, but a convention based binder that I can use in my apps to reduce the amount of view logic and code I need.

## Introducing Backbone.ModelBinding

I wanted to get rid of code that binds my model&#8217;s change events to the form input, and form input change event to the model attribute. And after a handful of hours hacking away, this weekend, I produced a Backbone plugin that does what I want.

[**Backbone.ModelBinding: Awesome Model Binding For Backbone.js**](https://github.com/derickbailey/backbone.modelbinding)

Head over to the link to check out the detail on how to get started, what prerequisites you&#8217;ll need, etc.

## An Example

In [one of my previous posts](http://lostechies.com/derickbailey/2011/07/19/references-routing-and-the-event-aggregator-coordinating-views-in-backbone-js/), I talked about a form that uses backbone to manage the add/edit process for patient medications. Since I already had this code in my head and there was a fair amount of backbone view code to manage all of the model binding between the form elements and model, I decided that this would be the first place I use my new plugin &#8211; this is what drove out the initial requirements and implementation.

Here is the screen shot from the previous post, showing a list of medications with an add/edit form above that.

<img title="NewImage.png" src="http://lostechies.com/derickbailey/files/2011/07/NewImage.png" border="0" alt="NewImage" width="600" height="498" />

There are 7 input fields and one select box on this form. To code to bind these fields to my model previously looked like this:

[gist id=1102944 file=1-old.js]

Given the number of inputs on this form, this code isn&#8217;t too bad. I was able to use some javascript and jQuery magic to reduce the amount of code I needed for each of the input boxes. However, I ended up with code to handle input fields and select fields, separately.

Now let&#8217;s look at this code with Backbone.ModelBinding in place.

[gist id=1102944 file=2-new.js]

Notice a small difference in the amount of code needed to bind all 8 of those fields (7 inputs, 1 select)? What this comparison doesn&#8217;t show is the code that would have been needed to bind a model change back out to the form&#8217;s input fields. The one line of code in the render function, though, to call the Backbone.ModelBinding plugin handles this as well.

Now I can not only get my form bound to my models with a simple convention, but I can also have any other code on the page update my model and if the model happens to be bound to the form, the form will be updated as well.

## A Simiple Convention, With Unconventional Support

The Backbone.ModelBinding convention to make this work is very simple. The #id of the html form element is used as the model&#8217;s attribute and vice-versa. For example, in the above screen shot my &#8220;Trade name&#8221; field has an id of #trade\_name. The model, then, has an attribute called trade\_name.

If you don&#8217;t have your fields and model attributes aligned to this convention, though, Backbone.ModelBinding still supports you! But you have to drop back to manual configuration of the binding.

[gist id=1102944 file=3-formBinding.js]

Still, this is pretty simple. All you need to do is specify which form element is being bound to which model attribute and Backbone.ModelBinding takes care of the rest for you. The only requirement is that the html element you specify must fire a &#8216;change&#8217; event that jQuery can bind to, and must be able to have it&#8217;s value set via jQuery&#8217;s &#8216;.val&#8217; method.

## What Are You Waiting For?

Well? What are you waiting for? [Go grab a copy of Backbone.ModelBinding and try it out!](https://github.com/derickbailey/backbone.modelbinding) It&#8217;s still verfdy early in it&#8217;s development, so it only supports input and select elements, right now. But! It&#8217;s open source &#8211; MIT License &#8211; and hosted on Github. If it doesn&#8217;t do what you need or does something you don&#8217;t want it to do, I&#8217;m always open to receiving pull requests.