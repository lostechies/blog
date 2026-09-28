---
wordpress_id: 614
title: Tips For Using Backbone.js Routers With HTML5 PushState
date: 2011-10-17T07:02:07+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=614
dsq_thread_id:
  - "445849969"
categories:
  - Backbone
  - HTML5
  - JavaScript
  - PushState
---
**IMPORTANT UPDATE!**

Jeremy Ashkenas pointed out that this won&#8217;t work in Internet Explorer (or other browsers that don&#8217;t support PushState). I had tested this, but apparently I didn&#8217;t hit the Back button in IE, in my testing. The Back button, indeed, does not work in IE when setting things up this way. So, if you don&#8217;t care that IE users can&#8217;t use their Back button, this works great… otherwise… I think I need to re-work some of this and post a followup with corrections.

 

**Update #2**

To avoid further confusion, I&#8217;m striking through everything I said that is wrong, in this post. A new post will be up soon-ish, to provide some real tips.

 

&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8211;

I&#8217;ve already [introduced HTML5 PushState](https://lostechies.com/derickbailey/2011/09/26/seo-and-accessibility-with-html5-pushstate-part-1-introducing-pushstate/) and talked about [using progressive enhancement with Backbone.js](https://lostechies.com/derickbailey/2011/09/26/seo-and-accessibility-with-html5-pushstate-part-2-progressive-enhancement-with-backbone-js/) to make it all work. What I haven&#8217;t talked about, though, is how I got my Backbone router to work properly after enabling PushState. I spent some long hours fighting with my router all because of a few very small decisions I originally made in my app. Hopefully these tips will help other avoid the same mistakes I made.

<strike>

<span style="text-decoration: line-through;"></p> 

<h2>
  Tip #1: Don&#8217;t Use Backbone.Router
</h2>

<p>
  You don&#8217;t need a Backbone.Router if you&#8217;re using PushState. That&#8217;s pretty much the end of it. The rest of the &#8220;tips&#8221; I was originally going to write are pretty much useless because you don&#8217;t need to use a router when you&#8217;re using <a href="http://diveintohtml5.info/history.html">HTML5&#8217;s PushState</a>.
</p>

<h2>
  WHAT?! How Am I Supposed To … ?!
</h2>

<p>
  Here&#8217;s the secret: The Backbone.Router doesn&#8217;t give you much functionality. Most of what we use a router for is done through the Backbone.History object. Router.navigate? How about History.navigate instead? <a href="http://documentcloud.github.com/backbone/docs/backbone.html#section-85">Router.navigate delegates to this anyways</a>. Route callback methods? Yeah, those are also delegated to History. Routers give us a nice way to organize our route definitions and callbacks in a clean way &#8211; and that&#8217;s a very important role to play &#8211; but end up delegating the majority of their functionality to the History object, anyways.
</p>

<p>
  So, why not use the History object directly if we don&#8217;t need routes and callback methods?
</p>

<h2>
  Two Strings Attached: PushState And Navigate
</h2>

<p>
  There are two strings attached to this. The first is that you need to use PushState and use it properly. Secondly,
</p>

<p>
  </span>
</p>

<p>
  </strike>
</p>

<p>
   
</p>

<p>
  you need to stop using `router.navigate` to fire your route methods.
</p>

<p>
   
</p>

<p>
  <strike>
</p>

<p>
  <span style="text-decoration: line-through;"></p> 
  
  <h3>
    The PushState Requirement
  </h3>
  
  <p>
    Without PushState<em>, you need a router to use hash fragments</em>. Without a router, your hash fragments won&#8217;t be able to fire callback methods. Of course you could built your routes into the Backbone.History object directly (once again, <a href="http://documentcloud.github.com/backbone/docs/backbone.html#section-84">Backbone.Router delegates to this</a>). But it gets a little more complicated when you do this yourself. It&#8217;s easier to use a router and makes more sense to another developer looking at your code.
  </p>
  
  <p>
    If you are using PushState, though, then you&#8217;ll never fire a router&#8217;s route methods. If you&#8217;re never firing a router&#8217;s route methods, what&#8217;s the point of having a router?
  </p>
  
  <h3>
    The Navigate Requirement
  </h3>
  
  <p>
    If you don&#8217;t have a router, you won&#8217;t be able to call `router.navigate(&#8220;…&#8221;, true)` with that pesky &#8216;true&#8217; parameter. But, this shouldn&#8217;t be an issue, anyways, You should be <a href="https://lostechies.com/derickbailey/2011/08/28/dont-execute-a-backbone-js-route-handler-from-your-code/">building your apps in a stateful manner with state-based workflow</a> instead of <a href="https://lostechies.com/derickbailey/2011/08/03/stop-using-backbone-as-if-it-were-a-stateless-web-server/">using Backbone as if it were a stateless web server</a>. You&#8217;ll still want to call `history.navigate(&#8220;…&#8221;)` to update your browser&#8217;s URL. This is done in response to the application being put into a specific state, and not done to put the application into a specific state. Don&#8217;t pass the `true` parameter as the second argument to navigate, and you&#8217;ll be fine.
  </p>
  
  <h2>
    Sample Code
  </h2>
  
  <p>
    Here&#8217;s a standard router implementation, not using PushState, with two routes that can be fired from two separate links on the page.
  </p>
  
  <p>
    {% gist 1290199 1.js %}
  </p>
  
  <p>
    {% gist 1290199 1.html %}
  </p>
  
  <p>
    When you click on a link, the route is fired and a message is printed out on the screen. Simple stuff.
  </p>
  
  <h3>
    Enabling PushState
  </h3>
  
  <p>
    Now look at the code with PushState enabled.
  </p>
  
  <p>
    {% gist 1290199 2.js %}
  </p>
  
  <p>
    {% gist 1290199 2.html %}
  </p>
  
  <p>
    The only differences in this version of the code are the two links and the use of `{pushState: true}` when starting the router. The two links are standard links without hash fragments. This means that they would make a request back to the server when you click on them. If you run this code and click on a link, it makes a full request back to the server to render the page because the links are full URLs.
  </p>
  
  <p>
    When the page loads from the server, you would expect the Backbone.Router to fire it&#8217;s route method, but it doesn&#8217;t. Backbone routers only fire route methods in two scenarios: 1) when a hash fragment is used as a route, and 2) when you call `navigate` with the second parameter of `true`. Since neither of these criteria are met, the router does not fire it&#8217;s route. If a router&#8217;s methods never fire, why do you have a router in your app? Delete it.
  </p>
  
  <h3>
    Hijacking The Links And Using History.navigate
  </h3>
  
  <p>
    To make use of Backbone&#8217;s capabilities with PushState turned on, and to update the URL without making a full request back to the server, we need to hijack the link clicks with a bit of JavaScript code and then use Backbone&#8217;s History object to update the URL.
  </p>
  
  <p>
    {% gist 1290199 3.js %}
  </p>
  
  <p>
    {% gist 1290199 3.html %}
  </p>
  
  <p>
    The browser URL updates when you click on a link, but the page does not have to do a full refresh from the server. Of course, if you decide to hit the refresh button on your browser, you&#8217;ll hit the full URL and <a href="https://lostechies.com/derickbailey/2011/09/26/seo-and-accessibility-with-html5-pushstate-part-1-introducing-pushstate/">the server will give you the page you expect</a>.
  </p>
  
  <p>
    <span style="font-size: 18px; font-weight: bold;">Conclusion: If You&#8217;re Using PushState, You Don&#8217;t Need A Router</span>
  </p>
  
  <p>
    Check out <a href="http://backbonetraining.net/javascripts/backbonetraining.js">the JavaScript for my BackboneTraining.net</a> site. There are no routers in site. There is only an instance of Backbone.History and a call being made to the history.navigate method to update the URL when a link is clicked. This works because I have PushState enabled and because I am not passing the `true` argument to the `navigate` method.
  </p>
  
  <p>
    Given these two assumptions &#8211; PushState and not passing &#8216;true&#8217; to &#8216;navigate&#8217; &#8211; Backbone Routers become far less important to our applications. And I believe this is a good thing as it leads us away from using Backbone as if it were a stateless web app, and toward using Backbone as it truly is &#8211; a stateful application framework running on top of a stateless, asynchronous technology stack.
  </p>
  
  <p>
    </span>
  </p>
  
  <p>
    </strike>
  </p>
