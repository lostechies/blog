---
wordpress_id: 25
title: Fighting Your Tooling Sucks
date: 2007-11-15T04:48:58+00:00
author: Evan Hoff
layout: post
wordpress_guid: /blogs/evan_hoff/archive/2007/11/14/fighting-your-tooling-sucks.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/evan_hoff/archive/2007/11/14/fighting-your-tooling-sucks.aspx/"
---
</p> 

Here&#8217;s a comment from Phil&#8217;s <a href="http://haacked.com/archive/2007/11/14/writing-testable-code-is-about-managing-complexity.aspx" target="_blank">testability post</a>: 

> &#8220;I have been working on a project trying to apply these principles and it seems that using the Entity Framework or Linq to Sql, it is hard to have a loose coupling between the UI and the data layer.  
> This would require the UI to talk only to interfaces so that the data layer&#8217;s implementation can be changed easily.  
> The designers are very nice, but they don&#8217;t generate these interfaces, so I had to extract them from the generated classes and make the partial class declarations inherit from these interfaces; this almost looks like a haack.  
> The interfaces then have to be kept in sync with the generated classes manually.  
> The good thing I realized in this process is that this way, I can overcome the limitation of the designers to put custom attributes on the entities properties (for validation for example), by applying these attributes to the interface&#8217;s property declaration.  
> Or is there a better way to do this? &#8221; 

He&#8217;s another user fighting his tools.. 

And all he wanted to do was decouple his UI from Data Access. 

Its too bad that that the tooling took him down&nbsp;the wide/easy road of drag and drop and then left him high and dry&nbsp;when he wanted to do something basic with his design (decoupling). 

One might argue that it&#8217;s not Visual Studio&#8217;s fault that he isn&#8217;t&nbsp;sure how to decouple this stuff, but it doesn&#8217;t have to be that way.&nbsp; In my opinion, the tooling should promote good practices (such as decoupling).