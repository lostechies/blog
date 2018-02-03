---
wordpress_id: 3139
title: Organizing Namespaces with DDD
date: 2007-09-29T13:33:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2007/09/29/organizing-namespaces-with-ddd.aspx
dsq_thread_id:
  - "262671030"
categories:
  - DDD
---
About a week ago I posted a message to the Yahoo DDD group to see how other people were organizing their namespaces in their Domain Model. For the most part everyone had the same basic idea. You can read the <A class="" href="http://tech.groups.yahoo.com/group/domaindrivendesign/message/5873" target="_blank">message here</A>.


  


In the domain layer, the general consensus seems to be to organize your namespaces around aggregates and/or entities. Not around lower level ideas like &#8220;interfaces&#8221;, or &#8220;services&#8221;. You can do this once you break it out into entities, but the first layer or organization should not be around low level organization. Here is an example of how I would setup namespaces in a Blog engine project. After some refining and trying a couple of different ideas I find that this works best for me.


  


BlogEngine.Core (root namespace for domain model)  
  
BlogEngine.Core.Blog  
&#8211; IPost  
&#8211; BlogPost  
&#8211; PodcastPost  
&#8211; IComment  
&#8211; Comment BlogEngine.Core.Blog.Exceptions  
&#8211; BlogNotFoundException  
&#8211; CommentsNotAllowedException  
  
BlogEngine.Core.Blog.Repository  
&#8211; BlogRepository  
  
BlogEngine.Core.Blog.Services  
&#8211; SomeBlogService  
  
BlogEngine.Core.User  
&#8211; IUser  
&#8211; User  
&#8211; UserDetails  
  
BlogEngine.Core.User.Exceptions  
&#8211; UserNotFoundException  
  
BlogEngine.Core.User.Services  
&#8211; UserAuthenticationService


  


And so on. This gives you a nice clear view of your dependencies between aggregates. In each of the User/UserDetails classes, you can clearly see what other aggregates it depends on. I would go even further to say I would seperate interfaces within the aggregate. But this is a task for another day. I would be very interested to hear everyones comments on this. I think everyone uses the same basic ideas but perhaps someone has a better way of doing this that would help enlighten the rest of us =)