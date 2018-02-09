---
wordpress_id: 1187
title: 'Semantics, Modules And Testing: Why (And How) I Test Internal Components, Not Private Methods'
date: 2014-01-03T12:36:41+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1187
dsq_thread_id:
  - "2089987239"
categories:
  - AntiPatterns
  - Behavior Driven Development
  - CommonJS
  - Community
  - JavaScript
  - Marionette
  - Modules
  - NodeJS
  - NPM
  - Principles and Patterns
  - Testing
  - Unit Testing
---
I saw someone tweet about a new-ish JavaScript library called [Autooc](https://github.com/dtao/autodoc). recently. I had not heard of it, so I clicked the link to find out more. It looks like an interesting project. I&#8217;ll have to look at it further when I have time. But one thing that stuck out and made m spidy-sense tingle was this line just after the first example:

> &#8220;Hey, this function is private but I want to test it anyway.&#8221;

To which, I responded with a tweet: 

<blockquote class="twitter-tweet" lang="en">
  <p>
    <a href="https://twitter.com/search?q=%23autodoc&src=hash">#autodoc</a>: &#8220;Hey, this function is private but I want to test it anyway.&#8221; &#8230; <a href="https://twitter.com/search?q=%23sigh&src=hash">#sigh</a> NO
  </p>
  
  <p>
    — derickbailey (@derickbailey) <a href="https://twitter.com/derickbailey/statuses/418753130965106688">January 2, 2014</a>
  </p>
</blockquote>

This sparked a question on from the library&#8217;s author, [Dan Tao](https://twitter.com/dan_tao), where he asked me to elaborate. At the time I couldn&#8217;t elaborate much because I was traveling. But [Dan put together a great post on why he tests internal methods](http://danieltao.com/ideas/testing-private-methods), and I promised him I would write up something too &#8211; this post. Before you read the rest of this post, though, you really need to read Dan&#8217;s post. It provides context for this post, and it is very well written. In fact, I agree with Dan&#8217;s reasoning, 100%. It&#8217;s at the point where even Dan is asking:

<blockquote class="twitter-tweet" lang="en">
  <p>
    <a href="https://twitter.com/derickbailey">@derickbailey</a> Wait&#8230; &#8220;test the internals without exposing them through the public api&#8221;: that&#8217;s what I&#8217;m doing. So do we even disagree?
  </p>
  
  <p>
    — Dan Tao (@dan_tao) <a href="https://twitter.com/dan_tao/statuses/419149065025097728">January 3, 2014</a>
  </p>
</blockquote>

I don&#8217;t think we disagree, when it comes to the practice of our craft. I think we use different words for the same things and our initial &#8220;argument&#8221; was over semantics and minor details that don&#8217;t matter. But I do want to explore my thoughts on testing private things in code, when I call things &#8220;internal&#8221; instead of private, and showing some of the things I&#8217;ve done to solve the problems of needing to test &#8220;private&#8221; or &#8220;internal&#8221; code. I think these things are important, and I&#8217;ve been trying to find a way to write about some of these details for a long time now. So, this discussion is only the impetus for me to write some of these thoughts, and not the generation of the ideas or a continuation in some inane internet fight over what to test. 🙂

## The Boilerplate Arguments

Dan starts his post by correctly boiling the typical &#8220;don&#8217;t test private methods&#8221; argument down in to two points:

  1. Private methods are implementation details and shouldn’t be tested
  2. If a method does need tests, it should be public (and potentially refactored into a separate class)

I believe that private methods and other private things should not be tested directly. Private things exist only to support other things that can (and should) be tested. Private things are tested transiently &#8211; through the testing of non-private behaviors, we are inherently testing the private things that support the non-private thing.

Dan goes on to say he generally agrees with #2 but that he doesn&#8217;t apply this as a hard and fast rule. He takes this and heads down the path of testing private methods, and does so in a very nice way with his [Autodoc](https://github.com/dtao/autodoc) library. I know a lot of people that would kill for the ability to directly test private methods in JavaScript apps, and this looks like it has potential for being really good at doing that. Again, I haven&#8217;t used it yet so I&#8217;m just speculating based on the samples. 

Where I differ from Dan in my reaction, though, is not by testing &#8220;private&#8221; methods. Rather, I prefer to modify point #2

  1. Private methods are implementation details and shouldn’t be tested
  2. If a method is sufficiently complex to warrant it&#8217;s own test directly, it might need to be refactored into a separate thing

The real difference in my version of #2 is that I don&#8217;t say anything about exposing it publicly. Like Dan, I think exposing something to the public just for testing is a bad idea.

## Don&#8217;t Expose &#8220;Private&#8221; Things. Test &#8220;Internal&#8221; Things.

There are a lot of options for solving the problem of needing tests on something that is private and Dan lists several of them in his post (my modifications noted in [square brackets] to make the idea more generic):

  1. create a separate [library] and depend on that from within [yours]
  2. create a separate [library] but pull it [in] as a build step to keep zero run-time dependencies
  3. just test the publicly exposed sites where it’s used

All three of these ideas are great, and valid. Each has a strength and weakness, and I use all of them at various times. [MarionetteJS](http://marionettejs.com), for example, does all three. I have many separated files that each have some chunk of code &#8211; much of which is &#8220;internal&#8221; or &#8220;private&#8221; code. I build them all in to one deployable file at the end, so you don&#8217;t have to rely on multiple files for Marionette (of course there are dependencies on jQuery and Backbone, so you do have to reference those). Marionette also has a few libraries spit out from it&#8217;s original code: Backbone.BabySitter and Backbone.Wreqr. Both of these are dependencies, and are built in to Marionette at build time. I generally approach testing private things by testing the behavior of the public things that use the private things. You don&#8217;t have to expose the private thing as something public to test it.

There is one thing that Dan is missing, though&#8230; something else that I do in Marionette which could be extracted in to a more general purpose tool quite easily:

> **use an internal module system to allow testing of internal components**

I know this doesn&#8217;t sound like much, off-hand. But there are some important semantic differences and functional differences in how I approach my testing, evidenced by the specific wording that I am using (and not using). 

## The Fallacy Of Testing Car Engines

One of the examples that I consistently see when talking about testing private things is that of a car and an engine. I guess Dan ran in to it, too, as he put the same basic analogy in to his post. This analogy falls apart with any cursory scrutiny, but most people don&#8217;t bother so they miss how this falls apart.

The basic logic of this analogy/argument is:

  * you have to test the engine
  * the engine is &#8220;private&#8221; within the car
  * therefore you must be able to test private things

**I believe this is fallacy propagated by people who have never worked on cars**, or at least by people who have never bothered to scrutinize the analogy. I have worked on cars &#8211; my dad is a mechanic and an engineer (among many other things) and I grew up with a wrench in my hand, helping him rebuilt most of the cars that I rode around in or drove until I moved away, after college. I have first hand knowledge of how engines are tested, and the first time they are tested is not after the car is assembled. Engines are not &#8220;private&#8221; components, in my experience. They are &#8220;internal&#8221; components of the car. They are complex, prone to faults from many parts, and must be rigorously tested prior to mounting them in the vehicle. Failure to do this leads to cars that have faulty engines.

The fallacy of testing car engines doesn&#8217;t apply to just cars, though. It goes far beyond that, and is something I&#8217;ve written about before. The core concept is that of [defect prevention, instead of quality inspection](http://lostechies.com/derickbailey/2009/01/31/favor-defect-prevention-over-quality-inspection-and-correction/). The gist of it is to prevent defects further down the assembly line by rigorously measuring and testing at every step of the process. If a part is off by more than the allowed variance, early in the manufacturing stages, then it will have a large ripple effect later on and cause huge problems. If early stages are very tightly controlled, with very small margins of error and variance, and with rigorous testing and measurement, later problems can be avoided entirely. 

This same concept is just as applicable in software development as it is in manufacturing. It&#8217;s part of the lean software development culture. It&#8217;s part of TDD / BDD. It&#8217;s part of other software development life cycle tools, too. I believe it&#8217;s part of Dan&#8217;s processes (he says so in his post), and my processes. Most importantly, though, it should be part of your processes.

Unfortunately, most people get the process wrong because they believe the fallacy of testing the engine after it&#8217;s installed in the car. I don&#8217;t think Dan believes this, based on what I am reading in his post and his code. I think it is unfortunate that he chose to repeat this analogy, though. It&#8217;s fallacy to think of testing engines like this. Of course you test the car as a whole and make sure the engine turns the transmission and everything else, correctly. But waiting to test the engine until it is mounted is a bad idea. 

But then, where Dan and I really disagree is in word choice &#8211; semantics. I can almost guarantee that Dan&#8217;s intention of using that analogy was not the way I read the analogy, only because of the difference in how I say &#8220;internal&#8221; when he says &#8220;private&#8221;. 

## Semantics And Languages (Human And Computer)

&#8220;Semantics will continue to be important, until we learn how to communicate in something other than language&#8221; &#8211; this is a quote from [Sharon Cichelli](https://twitter.com/scichelli) that I use A LOT. I love this quote as it expresses the importance of semantics in our languages &#8211; both human and computer. In human language, the difference between &#8220;apple&#8221; and &#8220;Apple&#8221; is a fruit vs a multi-billion dollar electronics corporation. Semantics are meaningful.

In computers, the difference between &#8220;internal&#8221; (my word) and &#8220;private&#8221; (Dan&#8217;s word). To me, &#8220;internal&#8221; is a component or thing that should not be exposed publicly. It may still need tests and other support code, though. In Dan&#8217;s example, the &#8220;Set&#8221; type for Lazy.js is an internal type. It needs to be tested because it is very important, and does some complex things. It should not be exposed publicly for those tests, though. Dan calls the Set &#8220;private&#8221;, which I think is a bad name for the type of code that it is. Private, to me, is an implementation detail and part of something else that is already tested / supported.

Again, semantics are meaningful. 

## On Modules, Private And Internal Components

To understand my definition of &#8220;internal&#8221; vs &#8220;private&#8221;, you have to look at other languages. C#, for example, allows us to have what I call &#8220;internal&#8221; vs &#8220;private&#8221; classes and other constructs. When you build code in C#, you produce an assembly. The assembly is a module of deployment. It allows you to package up many individual classes, interfaces and other constructs in to a single (or multiple) deployable file(s). One of the advantages that you get in this is the notion of [access modifiers for classes](http://msdn.microsoft.com/en-us/library/ms173121.aspx). Access modifiers allow us to explicitly say who can access the code in question:

  * **public**: any code
  * **private**: no one other than this class
  * **protected**: this class and any inheriting code
  * **internal**: this class and any code in this assembly
  * **protected internal**: any inheriting code and other code in this assembly

Sadly, JavaScript does not have any of these access modifiers built in to it at this point. JavaScript is improving and getting better scope management in upcoming versions, but I still haven&#8217;t seen much on access modifiers (if any &#8211; someone correct me, please!). My point, though, is that we need to take advantage of some of the ideas that other languages provide, even if we don&#8217;t have an explicit construct for these ideas. This is what we are doing with modules, after all. 

The AMD (Asynchronous Module Definite) module format, the &#8220;module pattern&#8221;, and all of the other types of &#8220;modules&#8221; (including the new ES6 module, and NodeJS modules) are borrowed ideas. Other than ES6&#8217;s and NodeJS, though, modules are an idiom and pattern more than an explicit construct. But even at that, we can take advantage of them to create &#8220;internal&#8221; vs &#8220;private&#8221; components and other code in our libraries and apps.

Without modules, we won&#8217;t be able to do &#8220;private&#8221; code. Without modules we won&#8217;t be able to do &#8220;internal&#8221; code. Without modules, we lose of things that other languages have in them. But that doesn&#8217;t mean modules are &#8220;one size fits all&#8221;. 

## Module Of Development vs Module Of Deployment

A module of deployment is what most JavaScript developers are familiar with. Deployment modules allow you to say &#8220;hey, I&#8217;ve got this great library that hides all this complexity from you, and gives you this simple, elegant API from which you can use all of that complexity&#8221;. This is where the C# assembly comes in to play &#8211; it is the module of deployment. In JavaScript, AMD is a great example of a deployment module. It gives us the ability to deploy large chunks of code as multiple files, but have them all brought in through the &#8220;require&#8221; directives, thus simulating the behavior of an assembly in C#.  

A module of development, on the other hand, would be a module that is only available within the library. In C#, a module of development is achieved through having separate files that are compiled down in to a single assembly. The individual folders, files, namespaces, constructs, etc. in the assembly are the &#8220;modules&#8221; of development &#8211; the things on which we work when we are creating C# code. 

Unfortunately, JavaScript&#8217;s AMD does not have a separation of development vs deployment. A module is a module is a module. There is no way to say that a given file is a module for development purposes, but should not be part of the public modules that are exposed for use by 3rd parties.

NodeJS and NPM modules fix this by allowing each file to be a module and providing an explicit way to expose your public API through a single parent module that is referenced in the package.json config file for a module folder. You can work on individual NodeJS files (development modules) within your NPM package (deployment module) without fear of exposing your internal stuff to the external world. Within your NPM package codebase, you can write tests that require(&#8220;../whatever&#8221;) each file that needs to be included in the tests. Then for deployment through NPM, you create a file that only exports the things that the rest of the world needs to see. Specify that file as the primary file for the NPM package and you&#8217;re done. You now have development vs deployment modules &#8211; but only in a NodeJS environment (maybe with Browserify &#8211; not sure how that works, honestly). 

What we need, to be able to test our internal components &#8211; is any JavaScript environment (NodeJS, Browser, etc) &#8211;  is a development module that is completely separate from a deployment module, like the NodeJS and NPM combination. We need this so that we can test our &#8220;internal&#8221; components before package up the deployment module and ship it. 

## Using Modules Of Development To Test Internal Components

As I&#8217;ve already said, NodeJS + NPM gives us development modules and deployment modules, already. In a browser, though, it&#8217;s not so clear-cut. There are no built in constructs for any module system, so we have to use idiomatic and pattern based development techniques to provide what we need.

In MarionetteJS, as I mentioned previously, I use development modules and deployment modules. The deployment module is a very simple module pattern &#8211; [the IIFE](http://benalman.com/news/2010/11/immediately-invoked-function-expression/) that exports a single object which contains references to all the public things. My development modules are actually namespaced objects contained in most of the files. If you open [the layout.js file](https://github.com/marionettejs/backbone.marionette/blob/master/src/marionette.layout.js), for example, you&#8217;ll see this  code:

<pre>Marionette.Layout = Marionette.ItemView.extend({
  // ... 
});</pre>

 

Using a simple namespace in each file gives me both a development module that I can use to test internal things, and an external deployment module exposed through the built backbone.marionette file, when I return the &#8220;Marionette&#8221; namespace from the IIFE. Truthfully, though, this isn&#8217;t a very good example of how development modules can be done. It&#8217;s a hard coded, somewhat convoluted mess when you look at the build scripts. A better way to do this would be to have a very small module definition / require setup that is only internally used by your code. Think micro-AMD-like modules with NodeJS-like `require` statement that can be used to pull internal code in to a test or another file that needs it. Then a build step would come along as compile all of the code in to a single file, wrapped up in a deployment module like AMD. 

For some pseudo-code with Jasmine and an internal module system might look like this:

<pre>MySys.module("Foo", function(){<br /> return {<br />  doFoo: function(){<br />   return true;<br />  }<br /> }<br />});<br /><br />describe("my test goes here", function(){<br /> var foo = MySys.require("Foo");<br /> var result;<br /><br /> beforeEach(function(){<br />  result = foo.doFoo();<br /> });<br /><br /> it("should be true", function(){<br />  expect(result).toBe(true);<br /> });<br />});<br /> </pre>

So that module looks an awful lot like AMD, eh? The difference is that this would be an internal module system that doesn&#8217;t have all the whistles and bells of AMD, RequireJS or the other AMD loaders. In fact, I would say that that this code should not include a loader. Use a script loader for loading scripts. The concern of module definition and script loading should not be stuck together, IMO. But the point is, having an internal module system would allow you to write tests against internal components without exposing those components to the public world. 

I once wrote an internal module system that worked like this, and used it in an open source project. I loved it. It made my life easier. Then I abandoned it because I thought people would be confused by it. Looking back, my abandoning it was a mistake. I need to re-build this internal module system, because I need a clear difference between modules for development vs modules for deployment. It is important.

## Testing, Semantics And Modules, OH MY!

When it comes down to it, there are a few primary points that I really want to make, here:

  * Pay attention to semantics, and learn better semantics by stepping outside of your current knowledge base
  * Test &#8220;internal&#8221; components, not private methods
  * Use a module of development that is separate from the module of deployment

Hopefully you&#8217;ll be able to pull something useful out of these three points and the epic length post that tried to create an interesting journey on how we get there.