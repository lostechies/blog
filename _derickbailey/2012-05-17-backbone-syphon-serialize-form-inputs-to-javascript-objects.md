---
wordpress_id: 934
title: 'Backbone.Syphon: Serialize Form Inputs To JavaScript Objects'
date: 2012-05-17T06:57:13+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=934
dsq_thread_id:
  - "693403488"
categories:
  - Backbone
  - Backbone.Syphon
  - JavaScript
  - JQuery
  - JSON
---
Working with form elements in a Backbone view can become very tedious very quickly. You will either end up writing a lot of repetitive code to read values from the form, or end up using a key-value-observer or data-binding solution that automatically populates your model for you. While these are valid options and I highly recommend understanding how they work, there are times when these options are not the best choice for your application.

## jQuery

The most basic option in serializing a form&#8217;s elements in to use jQuery&#8217;s [serialize](http://api.jquery.com/serialize/) or [serializeArray](http://api.jquery.com/serializeArray/) methods. These methods work well and make it easy to get data out of your form. But they have limitations that I don&#8217;t like:

The serialize method encodes the values in to a URL encoding. This works well if you plan on using the data as URL parameters in an HTTP GET or other similar manner. But if you want to use the data in your JavaScript code, it&#8217;s a bit of a pain to work with.

The serializeArray method return a JavaScript array that contains objects each with a name and value key. So, a text input with a &#8220;name&#8221; of &#8220;foo&#8221; would return [{name: &#8220;foo&#8221;, value: &#8220;bar&#8221;}]. This works much better for dealing with the data in your JavaScript code, but is still severely constrained. You don&#8217;t have direct access to the key/value pairs based on the name of the input element. Instead, you have to search through the array of objects and find the one you want. 

What I want, instead, is a way to serialize a form into a plain JavaScript object where the object&#8217;s attributes (or keys) are the input element ids, with the key&#8217;s value set to the value of the input element.

## Backbone.Syphon

[Backbone.Syphon](https://github.com/derickbailey/backbone.syphon) aims to make it easy to serialize the form inputs of a Backbone.View in to a simple JSON object that contains all of the values from the form. All you need to do is call \`Backbone.Syphon.serialize(view)\` and it will return a JavaScript object to you with key / value pairs that match the input element ids and values.

For example, with this underscore template:

{% gist 2710848 1.html %}

And this Backbone.View setup:

{% gist 2710848 2.js %}

When you click the &#8220;save&#8221; button, the handler for the click calls \`Backbone.Syphon.serialize(this)\`. This returns an object that looks like this:

{% gist 2710848 3.js %}

The large benefit of this output is that you can immediately pass it to a Backbone.Model instance via the \`set\` method. There&#8217;s no need to sift through it and pull out the bits you need, like the jQuery serialize methods. Of course you can use it for more than just Backbone models, too. Anywhere that you need the data from your form, you can get it with Syphon and use it right away.

I use this plugin in several of my projects already &#8211; well, precursors that were poorly written and not tested thoroughly, at least. But I plan on continuing to use this plugin in scenarios where I need to get data out of my forms. Data-binding plugins just don&#8217;t interest me anymore, as I&#8217;ve gone down that path and abandoned it. 

## Serializes By Element Id

There are a handful of limitations in this first release. One of the largest is that all of the input elements will be serialized by the \`id\` attribute of the element. Look at the example above again, and you&#8217;ll notice that the text input with an id of &#8220;foo&#8221; was serialized in to a \`{foo: &#8220;bar&#8221;}\` attribute on the resulting object. I&#8217;m sure this will change over time, and become something more configurable. But for now, this was all I needed as I tend to use the id of a field as the key for my object&#8217;s data.

For more information on the current limitations, [see the documentation](https://github.com/derickbailey/backbone.syphon#current-limitation).

## Some-what Pluggable Serialization

I&#8217;ve built this plugin more than a few times at this point, starting with direct client needs and eventually turning in to the plugin that it is now. One of the lessons that I learned in rebuilding it a few times is that the process of serializing the input elements needs to be pluggable. I can&#8217;t limit how it reads the data from the input elements, because there are different needs for different situations. 

With that in mind, I built in the idea of &#8220;[Input Readers](https://github.com/derickbailey/backbone.syphon#register-your-own-input-readers)&#8220;. An Input Reader is a callback function that is registered against a particular input type, and is used to read the data from that type of input. 

At the moment, there are only two built in input readers: the default, which handles nearly everything, and the checkbox reader. The default reader uses jQuery&#8217;s \`val()\` function to get the value out of the input. This works for nearly every type of input. But there are some cases where this isn&#8217;t what you want to do. For example, I generally use checkboxes as boolean values instead of an actual text value. To handle this, then, I created the built in checkbox input reader. It uses jQuery&#8217;s \`prop()\` function to read the state of the checkbox and tell me whether or not the checkbox is checked. If you look at the previous example again, you&#8217;ll see that the &#8220;chk&#8221; checkbox is returning a boolean value.

## Initial Build And Release As A Screencast

There are several reasons that this initial release is so small and limited in scope and functionality. The largest of which is that it covers the majority of my needs, and like all of my plugins and add-ons, I figure out what I need and the common things that I do across projects first. Then when I have the majority of my cases covered, I start looking at what others need in order to get their projects up and running.

Another reason that this release is limited, is because I decided to record the creation of the plugin as a live screencast &#8211; a &#8220;prequel&#8221; of sorts, to the first &#8220;[Refactoring JavaScript](http://www.watchmecode.net/refactoring-javascript)&#8221; screencast that I released last year. In this case, the end product of the Backbone.Syphon plugin is more of a side effect than the purpose of the screencast. The real focus of the screencast is the tools and processes that I use to get a plugin like this off the ground, built and delivered. 

If you&#8217;re an audio/video learner and you want to see my process for creating something from nothing more than the ideas in my head, then you should check out Episode 7 of WatchMeCode: [Building A Backbone Plugin (Live)](http://www.watchmecode.net/backbone-plugin). And if you&#8217;re looking for a way to get up to speed with test-driven JavaScript, including a basic introduction to Jasmine and refactoring an existing application that is covered by Jasmine tests, then you might be interested in the [Jasmine Live! multi-pack](http://www.watchmecode.net/jasmine-live) of screencasts.

## Documentation, Downloads, And Moving Forward

If you&#8217;d like to get your hands on Syphon, head over to [the Github repository](https://github.com/derickbailey/backbone.syphon). There are links to the the downloads and a little bit of documentation to show how to use it (the same as what I showed here), as well as some discussion on the current limitations of the plugin.

I&#8217;m hoping to get some input and assistance from others that could use a plugin like this, moving forward. I&#8217;d like to see this project fleshed out so that it can be used in a broader set of scenarios, with more options for how the data is serialized from the input elements. At the same time, though, I&#8217;m going to be rather picky about how the implementation moves forward. I don&#8217;t want to end up with another 1,000 line blob of unmaintainable garbage, like my ModelBinding plugin. As it stands now, though, Syphon&#8217;s code is starting out on the right foot. I just need to keep it heading down a clean path as it moves forward.

 
