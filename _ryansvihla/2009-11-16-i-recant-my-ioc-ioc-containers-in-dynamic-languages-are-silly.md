---
wordpress_id: 32
title: I recant my IoC! IoC containers in dynamic languages are silly.
date: 2009-11-16T22:28:33+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2009/11/16/i-recant-my-ioc-ioc-containers-in-dynamic-languages-are-silly.aspx
dsq_thread_id:
  - "425592900"
categories:
  - Dynamic Langs
  - IoC
  - Python
redirect_from: "/blogs/rssvihla/archive/2009/11/16/i-recant-my-ioc-ioc-containers-in-dynamic-languages-are-silly.aspx/"
---
After a year or so of solid Alt Dot Net infection (as far as infections go its a pretty awesome one to have), I decided to give Python a try again for more than one off sysadmin tasks, and to actually dive into it as a newly minted “Agilista”.&#160; 

However, I had&#160; a problem..there were no non-painful IoC containers in Python (sorry to the other authors of IoC frameworks in Python like Spring Python and Snake Guice, I know you try and I respect the effort).&#160; Ultimately, I could <u>**not**</u>&#160; imagine coding anymore without something to handle all my registration for me, that’d dynamically inject in my dependencies, give me hooks for contextual resolution, and give me rich interception support.

So I built my own, it was painful still, but I had some ideas to move it in an Convention Over Configuration direction, and ultimately get within shooting range of what fancy stuff we’ve come to expect in .Net that Windsor, StructureMap and many others provide.

Now as I got into the fancier aspects of dynamic languages, open classes and the ability to override **all** behavior easily I get it…a dynamic languages runtime is like a bit IoC container.

Now I’ve heard other people say this many times but rarely with explanation or example, or focus on frankly silly things like “Dependency Injection adds too many lines of code” which is a bit melodramatic. Two arguments to a constructor, two fields ,and then avoiding having to call new is not “adding too many lines of code”, especially with templates, IDE’s, scripting, etc to cut down the actual typing load.Today I’m going to actually try to explain how languages like Python, Ruby etc give us the same awesomeness we’ve come to expect in things like Windsor..but at a much cheaper cost of learning and dev time.

Take a typical resolution scenario where you want to output to a different file format depending on command line switches.&#160; With an IoC container you can either:

Change the resolution argument to load a different concrete type:

> <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
>   <div style="font-family:consolas,lucida console,courier,monospace">
>     <span style="color:#0000ff">if</span>(arg&#160;==&#160;<span style="color:#a31515">&#8220;XML&#8221;</span>)<br /> <span style="color:#0000ff">{</span><br /> &#160;&#160;container.Register(Component.For<IOutput>().ImpmentedBy<XmlOutput>());<br /> <span style="color:#0000ff">}</span><br /> <span style="color:#0000ff">else</span>&#160;if(arg&#160;==&#160;<span style="color:#a31515">&#8220;HTML&#8221;</span>)<br /> <span style="color:#0000ff">{</span><br /> &#160;&#160;container.Register(Component.For<IOutput>().ImpmentedBy<HtmlOutput>());<br /> <span style="color:#0000ff">}</span><br /> <span style="color:#0000ff">else</span><br /> <span style="color:#0000ff">{</span><br /> &#160;&#160;container.Register(Component.For<IOutput>().ImpmentedBy<NullOutput>());<br /> <span style="color:#0000ff">}</span>
>   </div>
> </div>

or resolve different arguments or keys using a service locator approach in later client code (thereby depending on the container)</p> 

> <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
>   <div style="font-family:consolas,lucida console,courier,monospace">
>     <span style="color:#0000ff">public</span>&#160;<span style="color:#0000ff">void</span>&#160;output(IKernel&#160;container,&#160;<span style="color:#2b91af">string</span>&#160;key)<br /> <span style="color:#0000ff">{</span><br /> var&#160;output&#160;=container.Resolve<IOutput>(key);<br /> output.save();</p> 
>     
>     <p>
>       <span style="color:#0000ff">}</span> </div> </div> </blockquote> 
>       
>       <p>
>         or implement a custom implementation of the resolver system (which I’ll leave out for the sake of brevity, but it’s not instant code).&#160; Also to do all this you have to depend on interfaces, add all your interchangeable code to the constructor and life is grand.&#160; You do this for many reasons in static languages, its the only way to get easy testability and code that is open to extension.&#160; In dynamic languages its <strong><u>always open for extension and easy to test</u></strong> . Let me demonstrate:
>       </p>
>       
>       <blockquote>
>         <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
>           <div style="font-family:consolas,lucida console,courier,monospace">
>             <span style="color:#008800"><b>import</b></span>&#160;<span style="color:#bb0066"><b>outputlib</b></span>&#160;<span style="color:#008800"><b>as</b></span>&#160;<span style="color:#bb0066"><b>o</b></span></p> 
>             
>             <p>
>               <span style="color:#008800"><b>def</b></span>&#160;<span style="color:#0066bb"><b>outputselect</b></span>(arg):<br /> <span style="color:#008800"><b>if</b></span>&#160;arg&#160;==&#160;<span style="color:#dd2200">&#8220;XML&#8221;</span>:<br /> o.Output&#160;=&#160;XmlOutput<br /> <span style="color:#008800"><b>elif</b></span>&#160;arg&#160;==&#160;<span style="color:#dd2200">&#8220;HTML&#8221;</span>:<br /> o.Output&#160;=&#160;HtmlOutput<br /> <span style="color:#008800"><b>else</b></span>:<br /> o.Output&#160;=&#160;NullOutput
>             </p>
>             
>             <p>
>               <span style="color:#008800"><b>def</b></span>&#160;<span style="color:#0066bb"><b>saveoutput</b></span>():<br /> o.Output().save()&#160;&#160;<span style="color:#888888">#will&#160;save&#160;whichever</span> </div> </div> </blockquote> 
>               
>               <blockquote>
>                 <p>
>                   Contextual resolution in a nutshell, and throughout your code if need be.&#160; “Interception” is even easier, take a look at <a title="http://docs.python.org/dev/library/functools.html" href="http://docs.python.org/dev/library/functools.html">http://docs.python.org/dev/library/functools.html</a> and then start playing you’ll see you can trivially apply logging and security to methods without explicitly adding it. A short logging example follows:
>                 </p>
>               </blockquote>
>               
>               <blockquote>
>                 <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
>                   <div style="font-family:consolas,lucida console,courier,monospace">
>                     <span style="color:#008800"><b>import</b></span>&#160;<span style="color:#bb0066"><b>types</b></span>&#160;<br /> <span style="color:#008800"><b>import</b></span>&#160;<span style="color:#bb0066"><b>functools</b></span></p> 
>                     
>                     <p>
>                       <span style="color:#888888">#applies&#160;a&#160;cepter&#160;to&#160;each&#160;non-underscored&#160;method.</span><br /> <span style="color:#008800"><b>def</b></span>&#160;<span style="color:#0066bb"><b>wrapcls</b></span>(cls,&#160;cepter):<br /> &#160;&#160;&#160;&#160;publics&#160;&#160;=&#160;[&#160;name&#160;<span style="color:#008800"><b>for</b></span>&#160;name&#160;<span style="color:#008800">in</span>&#160;<span style="color:#003388">dir</span>(cls)&#160;<span style="color:#008800"><b>if</b></span>&#160;<span style="color:#008800">not</span>&#160;name.startswith(<span style="color:#dd2200">&#8220;_&#8221;</span>)]&#160;<br /> &#160;&#160;&#160;&#160;methods&#160;=&#160;[<span style="color:#003388">getattr</span>(cls,method)&#160;<span style="color:#008800"><b>for</b></span>&#160;method&#160;<span style="color:#008800">in</span>&#160;publics&#160;<span style="color:#008800"><b>if</b></span>&#160;<span style="color:#003388">type</span>(<span style="color:#003388">getattr</span>(cls,method))&#160;==&#160;types.MethodType&#160;]<br /> &#160;&#160;&#160;&#160;<span style="color:#008800"><b>for</b></span>&#160;method&#160;<span style="color:#008800">in</span>&#160;methods:<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;intercepted_method&#160;=&#160;cepter(method)<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#003388">setattr</span>(cls,&#160;method.__name__,&#160;intercepted_method)&#160;<span style="color:#888888">#attaches&#160;intercepted_method&#160;to&#160;the&#160;original&#160;class,&#160;replacing&#160;non-intercepted&#160;one</span>
>                     </p>
>                     
>                     <p>
>                       <span style="color:#888888">#the&#160;magic&#160;all&#160;happens&#160;in&#160;the&#160;functools.wraps&#160;decorator</span><br /> <span style="color:#008800"><b>def</b></span>&#160;<span style="color:#0066bb"><b>loggingcepter</b></span>(func):<br /> &#160;&#160;&#160;&#160;<span style="color:#555555">@functools</span>.wraps(func)<br /> &#160;&#160;&#160;&#160;<span style="color:#008800"><b>def</b></span>&#160;<span style="color:#0066bb"><b>logafter</b></span>(*args,&#160;**kwargs):&#160;<span style="color:#888888">#for&#160;csharp&#160;devs&#160;view&#160;this&#160;as&#160;an&#160;inline&#160;delegate</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;result&#160;=&#160;func(*args,&#160;**kwargs)&#160;<span style="color:#888888">#invoking&#160;function</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008800"><b>print</b></span>&#160;<span style="color:#dd2200">&#8220;function&#160;name:&#160;&#8221;</span>&#160;+&#160;func.__name__<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008800"><b>print</b></span>&#160;<span style="color:#dd2200">&#8220;arguments&#160;were:&#160;&#8221;</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008800"><b>for</b></span>&#160;a&#160;<span style="color:#008800">in</span>&#160;args:<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008800"><b>print</b></span>&#160;<span style="color:#003388">repr</span>(a)<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008800"><b>print</b></span>&#160;<span style="color:#dd2200">&#8220;keyword&#160;args&#160;were:&#160;&#8221;</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008800"><b>for</b></span>&#160;kword&#160;<span style="color:#008800">in</span>&#160;kwargs:<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008800"><b>print</b></span>&#160;<span style="color:#003388">repr</span>(kword)&#160;+&#160;<span style="color:#dd2200">&#8220;&#160;:&#160;&#8221;</span>&#160;+&#160;<span style="color:#003388">repr</span>(kwargs[kword])<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008800"><b>print</b></span>&#160;<span style="color:#dd2200">&#8220;return&#160;value&#160;was:&#160;&#8221;</span>&#160;+&#160;<span style="color:#003388">repr</span>(result)<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008800"><b>return</b></span>&#160;result<br /> &#160;&#160;&#160;&#160;<span style="color:#008800"><b>return</b></span>&#160;logafter<br /> &#160;&#160;&#160;&#160;<br /> <span style="color:#888888">#default&#160;boring&#160;repository&#160;class</span><br /> <span style="color:#008800"><b>class</b></span>&#160;<span style="color:#bb0066"><b>StorageEngine</b></span>(<span style="color:#003388">object</span>):<br /> &#160;&#160;&#160;&#160;<span style="color:#555555">@property</span><br /> &#160;&#160;&#160;&#160;<span style="color:#008800"><b>def</b></span>&#160;<span style="color:#0066bb"><b>connections</b></span>(<span style="color:#003388">self</span>):<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008800"><b>pass</b></span><br /> &#160;&#160;&#160;&#160;<br /> &#160;&#160;&#160;&#160;<span style="color:#008800"><b>def</b></span>&#160;<span style="color:#0066bb"><b>_sessioncall</b></span>(<span style="color:#003388">self</span>):<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008800"><b>pass</b></span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<br /> &#160;&#160;&#160;&#160;<span style="color:#008800"><b>def</b></span>&#160;<span style="color:#0066bb"><b>create</b></span>(<span style="color:#003388">self</span>,user):<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008800"><b>print</b></span>&#160;<span style="color:#dd2200">&#8220;running&#160;create&#160;now&#160;from&#160;the&#160;method&#8221;</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<br /> &#160;&#160;&#160;&#160;<span style="color:#008800"><b>def</b></span>&#160;<span style="color:#0066bb"><b>delete</b></span>(<span style="color:#003388">self</span>,&#160;<span style="color:#003388">id</span>):<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008800"><b>print</b></span>&#160;<span style="color:#dd2200">&#8220;running&#160;delete&#160;now&#160;from&#160;the&#160;method&#8221;</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008800"><b>return</b></span>&#160;<span style="color:#dd2200">&#8220;deleted&#160;from&#160;the&#160;database&#8221;</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<br /> &#160;&#160;&#160;&#160;<span style="color:#008800"><b>def</b></span>&#160;<span style="color:#0066bb"><b>get</b></span>(<span style="color:#003388">self</span>,&#160;<span style="color:#003388">id</span>):<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008800"><b>pass</b></span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<br /> &#160;&#160;&#160;&#160;<span style="color:#008800"><b>def</b></span>&#160;<span style="color:#0066bb"><b>__init__</b></span>(<span style="color:#003388">self</span>):<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008800"><b>pass</b></span>
>                     </p>
>                     
>                     <p>
>                       <span style="color:#888888">#placeholder&#160;storage&#160;object</span><br /> <span style="color:#008800"><b>class</b></span>&#160;<span style="color:#bb0066"><b>User</b></span>(<span style="color:#003388">object</span>):<br /> &#160;&#160;&#160;&#160;<span style="color:#008800"><b>pass</b></span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<br /> wrapcls(StorageEngine&#160;,loggingcepter)<br /> repo&#160;=&#160;StorageEngine()<br /> <span style="color:#008800"><b>print</b></span>&#160;<span style="color:#dd2200">&#8220;calling&#160;count&#160;this&#160;should&#160;not&#160;be&#160;intercepted&#8221;</span><br /> cnncount&#160;=&#160;repo.connections<br /> <span style="color:#008800"><b>print</b></span>&#160;<span style="color:#dd2200">&#8220;now&#160;get&#160;should&#160;be&#160;intercepted&#8221;</span><br /> repo.get(<span style="color:#0000DD"><b>1</b></span>)<br /> <span style="color:#008800"><b>print</b></span>&#160;<span style="color:#dd2200">&#8220;we&#160;should&#160;see&#160;keyword&#160;arguments&#160;here&#8221;</span><br /> repo.delete(<span style="color:#003388">id</span>=<span style="color:#0000DD"><b>2</b></span>)<br /> <span style="color:#008800"><b>print</b></span>&#160;<span style="color:#dd2200">&#8220;session&#160;call&#160;should&#160;not&#160;be&#160;intercepted&#8221;</span><br /> repo._sessioncall()<br /> <span style="color:#008800"><b>print</b></span>&#160;<span style="color:#dd2200">&#8220;create&#160;should&#160;be&#160;intercepted&#160;and&#160;we&#160;should&#160;see&#160;a&#160;User&#160;object&#8221;</span><br /> repo.create(User()) </div> </div> </blockquote> 
>                       
>                       <p>
>                         &#160;
>                       </p>
>                       
>                       <p>
>                         Running the above script should result in the following output
>                       </p>
>                       
>                       <p>
>                         &#160;
>                       </p>
>                       
>                       <blockquote>
>                         <p>
>                           <a href="http://lostechies.com/ryansvihla/files/2011/03/Screenshot20091116at4.20.56PM_0C117192.png"><img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="Screen shot 2009-11-16 at 4.20.56 PM" src="http://lostechies.com/ryansvihla/files/2011/03/Screenshot20091116at4.20.56PM_thumb_49A1600C.png" width="625" height="530" /></a>
>                         </p>
>                         
>                         <p>
>                           So this is all very cool, but what does it mean or why do I care?&#160; For those of us used to using a proper IoC container like Windsor or StructureMap, we’ve gotten used to have capabilities like the above easily available to us when we’ve needed them. It’s nice to find that in Python (or really any dynamic language ) we can easily build our own similar functionality that we’ve come to depend on.&#160; We’re never coupled and we’re always able to test and mock out behavior.&#160; It was a long time coming but I think I finally get it now.
>                         </p>
>                       </blockquote>