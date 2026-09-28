---
wordpress_id: 4450
title: Developing at the Speed of Microsoft
date: 2009-03-03T08:07:00+00:00
author: Sean Biefeld
layout: post
wordpress_guid: /blogs/seanbiefeld/archive/2009/03/03/developing-at-the-speed-of-microsoft.aspx
dsq_thread_id:
  - "449608063"
categories:
  - .NET
  - ASP.NET
  - ASP.NET MVC
  - HTML
  - JavaScript
  - Microsoft
  - RESTful web service
redirect_from: "/blogs/seanbiefeld/archive/2009/03/03/developing-at-the-speed-of-microsoft.aspx/"
---
As .net developers do you ever feel like <a target="_blank" href="http://en.wikipedia.org/wiki/Microsoft">Microsoft i</a>s hindering your development by the development tools they impose on us. I have been thinking about this lately and decide to discuss it, or this might actually be a rant, forgive the rant. I aim to take a brief look at web development the Microsoft way, how it has evolved, and the hindrances imposed on the community.

## The Microsoft Web Development World

Now I have never developed Microsoft web applications pre-webforms, i.e. pre-<a target="_blank" href="http://en.wikipedia.org/wiki/ASP.NET">Asp.net</a>, so I am not going to comment on that. What I am going to focus on is Microsoft&#8217;s asp.net development frameworks. As a side note, I have not done much development on the windows side of things, but it seems that it has been stagnating. I would love to see Microsoft write some bindings for <a target="_blank" href="http://en.wikipedia.org/wiki/GTK%2B">GTK+</a> and/or <a target="_blank" href="http://en.wikipedia.org/wiki/Qt_(toolkit)">Qt</a>, and support those cross platform toolkits. Pie in the sky dreams, I know.

### ASP.NET &#8211; Web Forms  


Somehow in their brilliance, big brother decided that abstracting HTML and Javascript into a infinitely more complex framework would be a good idea. This is ludicrous, don&#8217;t introduce unnecessary bloat into a framework. The page life cycle is ridiculous, all the built in webform controls use some retarded infinite inheritance scheme. Also what&#8217;s Microsoft&#8217;s infatuation with span tags, they wrapped all their webform controls in them.

Lol, I know this is common knowledge and has been discussed at length before but I still have to deal with it on a daily basis and it feels like I&#8217;m trying to cut off my leg with a steak knife. My interest lies in finding the true reasoning behind this. I have to working theories. One is that Microsoft is so loving and kind towards their developers that they wanted to coddle them, and that coddling most likely stemmed from their lack of respect for us and our intelligence. The other theory is that Microsoft convoluted the framework without realizing it due to their arrogance, believing they own the world and the way they are doing things must be right.

### ASP.NET AJAX

Next the <a target="_blank" href="http://en.wikipedia.org/wiki/Web_2.0">web 2.0</a> boom arrived and everyone was clamoring for more interactive web UIs. The .net developers yelled loud enough and long enough that they wanted to have the same thing that they were witnessing in other web frameworks. The keyword here is <a target="_blank" href="http://en.wikipedia.org/wiki/ASP.NET_AJAX">ajax</a>. So what does Microsoft do, they don&#8217;t take this moment and think about totally redesigning their asp.net framework, they say lets create some more complex web controls and use them in conjunction with an uber-complex ajax framework. 

Awesome, we now how fresh steamy poo piled on top of old rotting, festering poo. Thanks big brother. Instead of realizing their mistakes they made with web forms they exacerbate the problem. Now we get a seemingly dumbed down ajax scheme, oh just wrap everything in an update panel and Microsoft will do the rest. Besides the fact that this removes all control you have over the interactions between the server and client, you also can not use any other javascript inside of these panels. So once again it boils down to arrogance, contempt, and a lack of foresight.

### ASP.NET MVC

Now, Microsoft sees a significant proportion of developers moving to <a target="_blank" href="http://en.wikipedia.org/wiki/Ruby_(programming_language)">ruby</a> utilizing the <a target="_blank" href="http://en.wikipedia.org/wiki/Ruby_on_Rails">ruby on rails framework</a>. Also the community is yelling and screaming again, must be appeasement time. Did Microsoft actually take an introspective look and realize how ass backwards webforms is? Doubtful, they just figured out that they better do something to try and hold onto market share and give the community some fools gold. So they copy ruby on rails, ooooh, way to go big brother, you&#8217;re so innovative!

It is way too late in the game, <a target="_blank" href="http://en.wikipedia.org/wiki/ASP.NET_MVC_Framework">asp.net mvc</a> is something Microsoft should have done long ago. Back when they were formulating asp.net webforms. There is no excuse for Microsoft not to have created a framework like this when they introduced the asp.net ajax stuff. It&#8217;s ridiculous, and still they are losing market share, I wonder why. 

They ignore their base long enough and they won&#8217;t have a base. What are we supposed to drink the kool-aid and be satisfied, the <a target="_blank" href="http://en.wikipedia.org/wiki/Model-view-controller">MVC pattern</a> is how old? Oh, wow they are supporting a way to <a target="_blank" href="http://en.wikipedia.org/wiki/Unit_testing">unit test</a> the UI interactions, wow how progressive you are Microsoft. Where is the support for plugins, where is the support for <a target="_blank" href="http://en.wikipedia.org/wiki/Representational_State_Transfer">RESTful web services</a>? The point is there is nothing to be impressed about, it&#8217;s ridiculous that people are excited, this should have happened long ago.

## Conclusion

Now don&#8217;t get your panties in a wad I&#8217;m not all cynical, I like <a target="_blank" href="http://en.wikipedia.org/wiki/C_Sharp_(programming_language)">c#</a> as a language, even thought it is a static language and I like the <a target="_blank" href="http://en.wikipedia.org/wiki/Common_Language_Runtime">CL</a>R. Hopefully MVC is a sign that Microsoft is going to be moving at a less stagnant pace. I don&#8217;t think they will be. 

Things like <a target="_blank" href="http://www.mono-project.com/Main_Page">Mono</a>, <a target="_blank" href="/www.nhibernate.org/">NHibernate</a>, the <a target="_blank" href="http://altdotnet.org/">alt.net community</a> supplement the failings of the giant, but we should be fed up. Microsoft doesn&#8217;t listen, because of their corporate culture, which i doubt will change. Adding things to the web framework that should have been there long ago is nothing to celebrate, there i said it, <a target="_blank" href="http://www.youtube.com/watch?v=_6rAUUoaNZo">&#8220;Big whoop, want to fight about it&#8221;</a>. 

On a larger scale, why is Microsoft not listening to the community more, why are they not seeking to improve the community along the lines of the ruby community? Where is Microsoft&#8217;s version of package management like <a target="_blank" href="http://en.wikipedia.org/wiki/RubyGems">ruby gems</a>? Where&#8217;s their continuous integration/build tool? Where&#8217;s their testing framework? Where&#8217;s there promotion of best software practices, i.e. <a target="_blank" href="/blogs/chad_myers/archive/2008/03/07/pablo-s-topic-of-the-month-march-solid-principles.aspx">SOLID</a>, <a target="_blank" href="http://en.wikipedia.org/wiki/Test-driven_development">TDD</a>, <a target="_blank" href="http://en.wikipedia.org/wiki/Behavior_Driven_Development">BDD</a>, <a target="_blank" href="http://en.wikipedia.org/wiki/Agile_software_development">Agile methodologies</a>, <a target="_blank" href="http://blog.scottbellware.com/2009/02/decade-of-agile-dawn-of-lean.html">Lean methodologies</a>? The answer is no where, all of that exists inside the community without Microsoft&#8217;s support. 

The community is bettering ourselves in spite of Microsoft&#8217;s stagnation. Now think what could be accomplished if they actually fully embraced the community and threw their money and clout behind what the community stands for, it would be great. I am very doubtful that will happen, though, I think it will take mass exodus from .net development for Microsoft to ever get the message. If nothing happens the .net community will continue to stagger along at the pace of Microsoft, it will not reach its potential, and the community will wither and die. 

There is an entire software industry that needs to mature, the .net community is but a sub-section of it.&nbsp; It would be great if we could lead the industry in best practices and passion for our craft.