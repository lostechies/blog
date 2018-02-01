---
id: 829
title: 'EmberJS: Initial Impressions (Compared To Backbone)'
date: 2012-02-21T08:25:00+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=829
dsq_thread_id:
  - "584132764"
categories:
  - Backbone
  - Ember
  - Handlebars
  - JavaScript
  - Model-View-Controller
  - Model-View-Presenter
  - Rails
  - Ruby
  - Sinatra
---
<div style="display:block; background-color:#fff">
  <img src='http://emberjs.com/images/community/outdated.png' style="float:left;" /></p> 
  
  <p style="margin-left:115px; font-color:#1e1e1e;">
    <em>Hey!</em> This article references a pre-release version of Ember.js. Now that Ember.js has reached a 1.0 API the code samples below are no longer correct and the expressed opinions <em>may</em> no longer be accurate. Just keep that in mind when reading this. I hope to have time to dig in to Ember.js again in the near future, and will write an updated article if/when that happens!
  </p>
</div>

* * *

&nbsp;

It&#8217;s been a little less than a year since I dove heard-first in to [Backbone](http://backbonejs.org/). It seems there&#8217;s been a tremendous amount of movement on the JS-MV* front in that time, and one of the up and coming contenders for the web&#8217;s favorite JS framework is [EmberJS](http://emberjs.com/) (formerly known as AmberJS &#8211; formerly known as SprouteCore 2). There&#8217;s also quite a bit of debate going on between the Ember and Backbone communities &#8211; in particular, between the two project leaders: Yehuda Katz (EmberJS) and Jeremy Ashkenas (Backbone). So, not being one to rest on my current proficiencies, I decided to jump in to EmberJS and see what the brujahahahahalol was all about.

These are my first impressions and initial comparisons between Ember and Backbone. Note that I don&#8217;t claim to be an expert on Ember at this point, and what I&#8217;m offering here is probably going to be proven wrong to a large degree, as I continue to learn it.

## A Project: EmberCloneMail

The only way I can learn something is by doing it. Rather than start with the ubiquitous &#8220;Todo&#8221; example app, though, I wanted to jump in to something a little more substantial, where I can really see some opinions flowing. So I picked my BBCloneMail project and decided to rebuild it with Ember.

Thus, EmberCloneMail was born.

This project is perfect for me to start with because the original &#8211; BBCloneMail &#8211; contains pretty much all of my opinions on Backbone, wrapped up in one little demo application. Sure there are things that I need to add to it, still, but it&#8217;s a fairly sizable app and shows off a lot of what I like to do with Backbone.

EmberCloneMail, then, should be built from the JavaScript-ground up, using the same back-end, same HTML and CSS and producing the same functionality.

You can find what little code there is for it on Github: <https://github.com/derickbailey/emberclonemail>

And you can see what little there is to see on Heroku: <http://emberclonemail.heroku.com/>

## Philosophy: Rails vs Sinatra

If I remember right, [Jeremy said that this comparison is incorrect](http://javascriptjabber.com/004-jsj-backbone-js-with-jeremy-ashkenas/). I don&#8217;t remember exactly why off-hand, but I can&#8217;t help but make this comparison anyways. This really does feel like the correct analogy.

Ember has a more opinionated, framework, &#8220;The Ember Way&#8221; approach to it. Yes, there is flexibility in it. Yes, you can do some of the same things in multiple ways. But Rails shares this same approach. It provides &#8220;The Rails Way&#8221; out of the box (which is why it&#8217;s called Rails, right?)

Backbone is more like Sinatra in that it&#8217;s a foundation to build from. It offers a convenient set of abstractions and tools that you can call in to when you need them to do something. Otherwise, it largely leaves things up to you. The result of this is that you end up writing a lot more &#8220;boilerplate&#8221; code for a Backbone project than an Ember project. I agree with that. But, like Sinatra, the community for Backbone steps up to fill in the boilerplate with different opinions on how to structure an app, provide relational modeling, validation, and more.

Neither of these philosophies is right or wrong. They are simply different approaches to solving similar (or the same) problems. Which of the two frameworks you would work best with, largely depends on your preferred philosophy and approach. Do you like being guided down the path? Or do you like to forge your own path because you know exactly what you need and nothing else? I suspect that there&#8217;s some of both in all of us. I tend to use Sinatra more often for my smaller projects because I don&#8217;t see a need for all of Rails, most of the time. But I&#8217;m never opposed to using Rails if I see the need for everything it offers, either.

## A Real MVC Framework

Ember easily fits within the philosophy and definition of &#8220;framework&#8221; and &#8220;MVC&#8221;. In fact, it looks like it&#8217;s closer to the old-school SmallTalk-80 MVC (at least, as I understand it [based on some articles](http://martinfowler.com/eaaDev/uiArchs.html)) than any other MV* framework that I&#8217;ve used.

[Backbone can be used so that it fits within the MV* family, of course](http://addyosmani.com/blog/understanding-mvc-and-mvp-for-javascript-and-backbone-developers/). It certainly provides good structure and lets you work in that manner. But we already know that [Backbone is not a framework, and is not MVC](http://lostechies.com/derickbailey/2011/12/23/backbone-js-is-not-an-mvc-framework/).

## HTML Templates: Handlebars vs (Pick Something)

Backbone doesn&#8217;t know anything about generating HTML, templating engines or anything along those lines. It leaves decision entirely up to the developer by having a no-op &#8220;render&#8221; method on it&#8217;s view that it expects you to implement when you need to.

Ember, on the other-hand, comes with [Handlebars](http://handlebarsjs.com/) out of the box. Ember is very much tied to Handlebars, in fact. You can specify a Handlebars template directly in your page and with a few Ember helpers, start your application from that template instead of from JavaScript code.

Now the documentation for Ember says that you can replace Handlebars with any template system you want. It shows you how to override the render method to do this, but it also gives you all kinds of warnings about what Ember won&#8217;t do for you if you deviate from the Handlebars path. This is akin to Rails saying you can use any template language you want. You better find a template language that has Rails integration built in, or you&#8217;re going to end up writing a lot of code to do this, yourself.

## Handlebars: Yes, Please

I like Handlebars. I really do. I&#8217;ve been a fan of the &#8220;no code in views&#8221; approach for a long time. Handlebars provides pretty much a perfect approach to this, from what I&#8217;ve seen so far. It combines a &#8220;no-code&#8221; approach with an ability to register helpers.  These helpers give you access to more advanced functionality when you need them, but prevent you from writing a bunch of logic and code in your views, directly.

Up til now, I&#8217;ve been primarily using jQuery Templates or UnderscoreJS templates for Backbone&#8217;s rendering needs. I&#8217;m fairly certain that I&#8217;m going to switch to using Handlebars for Backbone now that I&#8217;ve seen it in action. I&#8217;m going to at least give it a try and see if it gives me a better approach within Backbone.

## Controllers: Could Be Nice

I could live with or without controllers in Ember, regarding response to user input. You can do everything you want through the use of Views, the same way that you would do it in Backbone. This basically turns the &#8220;view&#8221; object in to a &#8220;presenter&#8221;, as I&#8217;ve noted before.

Controllers also seem to be used for more than just view responses, though, and may fit the Rails controller idea. For example, the &#8220;[Contacts](https://github.com/emberjs/examples/tree/master/contacts)&#8221; sample app uses an &#8220;ArrayController&#8221; to store the list of contacts. Views then iterate over the controller&#8217;s models and code can be called on the controller to do various things.

It&#8217;s nice to have the option of using a controller. There are times when it seems to make more sense to use a controller to respond to use input, than to use a view.

## A Boat Load Of Namespacing

Nick Gauthier points out in [his comparison of Pomodoro projects built in Backbone and Ember](http://ngauthier.com/2012/02/playing-with-ember.html), that Ember wants you to do a ton of namespacing and &#8220;global&#8221; vars for databinding and other things. In the comments, he and I discuss that briefly and he says he doesn&#8217;t like having to hang object instances off of namespaces. I understand his hesitations, as I&#8217;ve felt the same way. But if you&#8217;ve ever looked at my [BBCloneMail](https://github.com/derickbailey/bbclonemail) project, you&#8217;ll have noticed that I do this a lot. It&#8217;s more of a limitation of JavaScript than anything else, that forced me down that path. Frankly, I was surprised and a little happy to see that a team as smart as the Ember team had run into this and solved it the same way I did. 🙂

## Less Boilerplate Code

This is one point that gets talked about a lot by the Ember team, but I&#8217;m not sure I agree with it yet. There is certainly less boilerplate code in certain aspects of Ember: wiring views and controllers together, rendering views with templates, binding from models in to views. Honestly, these are the places that people are usually talking about with the mention of boilerplate code in Backbone. I think there&#8217;s room for interpretation of this through the rest of ember, though &#8211; at least right now with the lack of documentation and good sample apps to show otherwise.

## Things That Confuse Me

There are a number of things that still confuse me about Ember. I think this is largely due to the lack of documentation.

### Lack Of Documentation

Where are the docs and sample apps that do more than just show the most simple of Todo apps? A contacts app is no different than a todo app. It&#8217;s just a few extra fields with a slightly different layout. I want to see larger applications that show me how to &#8230;

### Manage Data Persistence

This is missing entirely from Ember, at the moment. There&#8217;s a &#8220;[data](https://github.com/emberjs/data)&#8221; project as an add-on that looks like it&#8217;s attempting to re-create ActiveModel/ActiveRecord in JavaScript. I&#8217;m not sure how I feel about this project. I should give it a try at least. But I&#8217;m very surprised to not see a simple option built in to Ember. I mean, it&#8217;s all of 50 lines of code in Backbone.

### Workflow

How do I manage workflow in an Ember app? With Backbone, it&#8217;s easy: write the workflow myself. But is there something built in to Ember? Am I supposed to use the state manager? Or am I supposed to just have controllers that show the next view? That seems like a terrible idea &#8211; mixing the high level work flow in to the detail of implementation just leads to brittle code and big problems.

I&#8217;m very likely just missing something here… but it&#8217;s hard to know when there&#8217;s NO DOCUMENTATION around any of this, and NO SAMPLE APPS that show anything of any significance.

### Single-Page Apps: Routing

My BBCloneMail project is a single-page app that makes use of routes to manage which page your browser thinks it&#8217;s on. I expected this to be supported out of the box with Ember and was surprised to find that it&#8217;s not there. There&#8217;s another add-on for it to bring routing in to the picture, but the add on still says &#8220;SprouteCore 2&#8221; all over the place. That makes me think its not very well supported or kept up to date. After all, it&#8217;s been a month or two or more since SC2 was renamed to Amber and then Ember.

### Application Initialization

Ember has an Application object that every app should instantiate. It&#8217;s used for a number of things, including the top level namespace of your app. I like this. It fits perfectly with how I use Backbone.Marionette&#8217;s Application object.

But I don&#8217;t see a good way to follow-through with this object and initialize my application after the page loads.

So far, I&#8217;ve found that I can instantiate an Ember view through a Handlebars template directly in the page, or I can use JavaScript code to instantiate a view and place it in to the page &#8211; but where am I supposed to do that? Where does this code go? There&#8217;s no obvious place, form what I can see, on how to initialize a large application to a particular state.

### File Size

Ember is 37K minified and gzipped !!!! O_O !!!! Ok, sticker-shock is over. That&#8217;s rather large in comparison to Backbone, but no worse than jQuery. I guess all of the functionality they provide needs that much code? Or perhaps the ways they&#8217;ve architected this leads to an abundance of boilerplate code that they simply include in the project for you? The jury is still out on this, for me.

### Code Organization, Documentation

The largest of the problems that I&#8217;ve outlined is the lack of good documentation and sample apps. I think Backbone largely suffers this same problem, looking at raw backbone. But the community around Backbone has stepped up and offered a variety of sample apps to show different ideas. I hope the Ember community does the same, but as of yet, I was unable to find good samples in my google searches.

Backbone has the added advantage of it&#8217;s total size and simplicity in source code. There&#8217;s a single file and it&#8217;s annotated very well. If you don&#8217;t know how something works, it doesn&#8217;t take much effort to read the code and find out. I do this on a very regular basis. Ember, on the other hand, is separated in to a very large number of files that are concatenated and minified during a build process. The code is well organized and well commented, but it can be a daunting task to even find what you&#8217;re looking for, let alone understand it. There are simply too many additional things that you have to look at, which is difficult when the files are so spread apart and the over-alll codebase is so large.

## Over-All Impression: Big Potential

My overall impression of Ember is that there&#8217;s big potential here. I&#8217;m excited to see this grow and plan on continuing to learn, blog and use it when I think it&#8217;s appropriate. I see it as a Rails vs Sinatra choice, still. Which one makes the most sense in which scenarios? Hopefully I&#8217;ll find out by using both, more.