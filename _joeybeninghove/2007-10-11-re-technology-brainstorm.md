---
wordpress_id: 44
title: 'RE: Technology Brainstorm'
date: 2007-10-11T01:47:00+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/10/10/re-technology-brainstorm.aspx
categories:
  - Castle
  - Domain Driven Design
  - MonoRail
  - Patterns
---
(Because I often get tired of writing my verbose comments in a 300&#215;300 text
  
box&#8230;) 

[Colin](http://colinramsay.co.uk/diary/) seems to [find
  
himself in a pretty good spot](http://colinramsay.co.uk/2007/10/10/technology-brainstorm/trackback/).&nbsp; The wonderful world of Greenfield
  
development.&nbsp; But of course with this comes&#8230;decisions.&nbsp; MVC or Web Forms?&nbsp;
  
ActiveRecord or PI (persistent ignorant)?&nbsp; .NET or Ruby?&nbsp; (the latter being the
  
question I&#8217;m starting to ask on new projects) 

Colin seems to be pretty set on Castle Windsor+MonoRail+ActiveRecord which is
  
a wonderful combination.&nbsp; The simplicity of AR is just dang nice.&nbsp; And with
  
things like the ActiveRecordMediator in Castle and the Repository<T>
  
techniques made popular by Ayende, it seems like you can remove some of the
  
&#8220;persistence tax&#8221; from your entities while still remaining pretty simple.&nbsp; I say
  
&#8220;it seems like&#8221; because unfortunately I haven&#8217;t had a chance to try out
  
ActiveRecordMediator+Repository<T> on my own yet.&nbsp; But it looks very
  
attractive. 

I still struggle with the decision between MR+AR vs. MR+PI (persistent
  
ignorant) myself, in the .NET world at least.&nbsp; (I&#8217;m finding this decision in a
  
dynamic language like Ruby to be a whole different kind of conversation
  
though.)&nbsp; The purist in me wants to have a 100% &#8220;pure&#8221; domain model and not let
  
any of that pesky &#8220;infrastructure&#8221; stuff pollute my precious domain model.&nbsp; And
  
then the simplicityness (yes, I made that up) in me says &#8220;is that really
  
necessary?&#8221;.&nbsp;&nbsp;Eric Evans himself recently [said he
  
noticed a lot of overuse of DDD](http://www.infoq.com/interviews/domain-driven-design-eric-evans), which I admit to being guilty of.&nbsp; But, I&#8217;m
  
still learning (something I hope I&#8217;m always doing&#8230;) 

So since Colin asked for suggestions, here are a couple things I&#8217;d look into
  
for use on a brand new MR project (most of which I haven&#8217;t used yet&#8230;): 

  * [Castle
  
    Generator](http://macournoyer.wordpress.com/category/castle/generator/) (Scaffolding, project file(s) builder,&nbsp;.NET&nbsp;DB Migrations) 
  * [Castle
  
    Contrib Code Generation](http://using.castleproject.org/display/Contrib/Castle.Tools.CodeGenerator) (strongly typed property bags/flash&#8230;I really need
  
    to start using this!)

Oh, and I&nbsp;absolutely agree on using Windsor from the start.&nbsp; That&#8217;s what I&#8217;ve
  
done on my current project and you start getting giggly once you realize how
  
easy it is to shift responsibilities among classes.&nbsp; Not to mention the nice
  
decorator chains that can be created to help you adhere closer to OCP. 

That&#8217;s it for now.&nbsp; After all, this **was** just supposed to be
  
a comment.&nbsp; 🙂