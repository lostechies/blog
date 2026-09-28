---
wordpress_id: 80
title: Fluent interface endgame
date: 2007-10-14T02:07:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/10/13/fluent-interface-endgame.aspx
dsq_thread_id:
  - "806302404"
categories:
  - Misc
redirect_from: "/blogs/jimmy_bogard/archive/2007/10/13/fluent-interface-endgame.aspx/"
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/10/fluent-interface-endgame.html)._

In a [conversation on BDD](http://tech.groups.yahoo.com/group/altnetconf/message/175) on the altnetconf message board, the topic switched to language-oriented syntax in the CLR, to which Scott notes:

> When IronRuby gets here, I think we should at least stop and consider the value to the community of encouraging them to try do language-oriented specification with tools and programming languages that don&#8217;t quite hit the mark. 
> 
> Or maybe we should be turning our focus to Boo or IronPython for achieving the solubility in specification code that we can&#8217;t have in C# and VB.

I&#8217;ve felt this for quite a while now, though I have reservations about focusing on Boo&#8217;s Specter&nbsp;or IronPython for the time being.&nbsp; My response was: 

> I think there&#8217;s an assumption among anyone developing language-oriented tools in CLR using extension methods, fluent interfaces, etc. that it&#8217;s all a poor man&#8217;s substitute for the clearer syntax that Ruby inherently provides. Once IronRuby hits some sort of beta/RC status, I don&#8217;t see much point at all continuing to try to wrestle a pig into a yoke while the farmers laugh &#8220;use an ox you moron&#8221;. 
> 
> I do like the readability the Boo macros provide, but I&#8217;m always reminded of that scene from King of the Hill when Hank meets his new neighbor Khan (who is from Laos) for the first time: 
> 
> Hank: So are you Chinese or Japanese?  
> Khan: No, we are Laotian.  
> Bill: The ocean? What ocean?  
> Khan: From Laos, stupid! It&#8217;s a landlocked country in Southeast Asia  
> between Vietnam and Thailand, population approximately 4.7 million!  
> Hank: &#8230; So are you Chinese or Japanese?  
> Kahn: D&#8217;oh 
> 
> As someone who wants to use BDD more, Specter looks like a promising CLR tool, but as a proponent of BDD, Boo might set the bar too high when there&#8217;s only Chinese or Japanese in the greater community. Then again, if curly-braces dilute a concept that is supposed to lie very close to the conversations BDD starts with, maybe it&#8217;s better to draw a line so the value isn&#8217;t diminished. 
> 
> I don&#8217;t really have any answers yet. Make it pure or make it accessible, tough choice&#8230;

Again, I don&#8217;t have anything against Boo, but I just don&#8217;t know how successful these efforts will be once IronRuby comes out.&nbsp; For example, why should I care about the [Boo Build System](http://www.ayende.com/Blog/archive/2007/09/22/Introducing-Boobs-Boo-Build-System.aspx)&nbsp;when I can use Rake in Visual Studio when IronRuby ships? 

Until these languages are officially supported by Microsoft, they are for the most part eliminated as an option for one reason or another, whether it be company policy, lack of adoption, or just apathy for learning a new language.&nbsp; Once they are supported, I will happily ditch my fluent interface and extension methods for a true natural-language friendly programming language.