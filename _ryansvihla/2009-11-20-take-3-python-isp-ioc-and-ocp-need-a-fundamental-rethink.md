---
wordpress_id: 34
title: 'Take 3: Python, ISP, IoC, and OCP need a fundamental rethink.'
date: 2009-11-20T19:23:00+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2009/11/20/take-3-python-isp-ioc-and-ocp-need-a-fundamental-rethink.aspx
dsq_thread_id:
  - "425624375"
categories:
  - Dynamic Langs
  - IoC
---
In response to Julian’s thoughtful <a href="http://www.colourcoding.net/Blog/archive/2009/11/20/dynamic-languages-and-solid-principles.aspx" target="_blank">Dynamic Languages and SOLID Principles</a> I’d have to argue he is about 95% there but is missing the last critical links needed to view this in a whole different light. For ISP, Julian says it all:

> Ultimately, I don&#8217;t think ISP is changed by Python, it&#8217;s just kind of irrelevant, for better or worse.

Exactly!&#160; Why even bother mentioning in the context of dynamic languages. A developer that understands it fully and one that does not will code the same way. Whereas LSP is still taught in dynamic languages, I’ve never seen it called that but I’ve seen many admonishments about subclass consistency, and not making client code aware of the differences, and is something that requires mentioning. With ISP we could ignore it’s entire existence and developers would code the same.

For OCP:

> Well, the open closed principle is a goal, not a design practice, but let&#8217;s take a look at the danger points: 
> 
> &#160;&#160;&#160; * **You can&#8217;t have non-virtual methods, so Python wins this hands down.**   
> &#160;&#160;&#160; * **Your variable can&#8217;t be made too specific, so you&#8217;re safe there.**   
> &#160;&#160;&#160; * You can still compare against hard-coded values.&#160; It&#8217;s just as easy to get this wrong in Python as it is in C#.   
> &#160;&#160;&#160; * Same holds true for Law of Demeter violations.&#160; If you pass the wrong object around, your code will be just as fragile in Python as in C#. 
> 
> **Python certainly reduces the scope for some OC violations**, but you&#8217;ve still got lots of rope to hang yourself.&#160; Think you still need to bear the goal in mind.

Bolding emphasis is mine. Enough of OCP is stripped and the primary ways its taught and demonstrated do not apply to the language at all. Focus on Law of Demeter, but having something that stands for “Open for extension” whenever everything is open and “Closed for modification” when nothing is closed would fall on completely deaf ears when presenting any of the associated ideas to a Python developer.

For Dependency Inversion/ IoC:

> Let&#8217;s quote Ryan: 
> 
> &#160;&#160;&#160; Now all calls in this runtime, from any module, that reference the Output class will use XmlOutput or HtmlOutput instead. 
> 
> Yes, but what if I wanted only half of them?&#160; Maybe there&#8217;s Python techniques I don&#8217;t know about (I&#8217;m barely competent in the language) but as I see it, I&#8217;m going to need to change the code.&#160; I don&#8217;t think that dependencies can "always" be injected.&#160; They can only be done when it won&#8217;t cause damage.&#160; In his case, he&#8217;s worrying about testability.&#160; That&#8217;s fine, but we all agree there&#8217;s more to DI than testability.

Ok firstly, I didn’t just mention testability, in fact that the code you’re referencing there was no unit test for, it was about flexibility.&#160; Secondly, call Output an “Abstract Class”,and then call XmlOutput and HtmlOutput concrete types and then add them to an IoC container like Windsor then let me ask yourself the question you asked me “what if i wanted only half of them”.&#160; There would be a need for custom code to make this resolution work for this custom circumstance.&#160; All I’m advocating is taking that same exact custom code and place it somewhere else in Python (yes you can override per method, per instance, etc, etc).&#160; 

I think there needs to be a principle that addresses the benefits of **explicit** interfaces and well formed custom composition cases…and in those cases DI makes a lot more sense, but certainly not as a defacto convention and certainly is not required to provide flexibility to existing implementations.&#160; It certainly becomes apparent when you start looking into the actual way IoC works in static languages its <u>all too similar to how a dynamic language runtime works</u>. That code you’d use in a static language IoC to apply AOP, or custom composition rules, could just as easily be applied in a component in Python, <u>because the primary mechanism for an IoC to work is as a factory, and the benefits and features they bring are all derived from having access to how objects are created and then returned</u>, when you always have access to how objects are created and returned anyway as in dynamic languages, why should you implement it a second time. 100% DI’d code will be more effort to maintain because it would be in C# too…if not for that fact the language is so “structured” that the flexibility and testability benefits gained **far** outweigh the slightly increased cost (which is only brought down with the awesomeness of auto registering components).&#160; In a language already with flexibility and testability whether you use DI or not AND without auto registering IoC containers the cost to maintain a full DI code base is I’d argue unacceptable. 

Summary, for SOLID to make any sense whatsoever in a dynamic context it has to amended and modified to fit that world. Maybe make SOLID into SELL for:

S.RP 

E.xplicit empty class for required overrides

L.SP

L.aw of Demeter

Maybe there is something containing other more valid concepts for the dynamic world that I’m probably not qualified to design or come up with. Anyway, I’ve enjoyed the conversation and I hope it brings about a firmer understanding of SOLID, and whatever we’ve not come up with yet for dynamic languages.