---
wordpress_id: 3181
title: Designing Controllers
date: 2008-06-25T02:01:46+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2008/06/24/designing-controllers.aspx
dsq_thread_id:
  - "265346492"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2008/06/24/designing-controllers.aspx/"
---
<font face="Trebuchet MS" size="2">Once you wrap your head around using MVC in your web apps you tend to look at other ways to make your Controllers more descriptive. Specifically the way you structure and document your controllers.</font>

<font face="Trebuchet MS" size="2">I have noticed that a few portions of MVC design that I can highlight as to where you should pay extra attention and be more discrete in your decisions. These areas are:</font>

  * <font face="Trebuchet MS" size="2">Actions</font>
  * <font face="Trebuchet MS" size="2">View/PropertyBag variables</font>
  * <font face="Trebuchet MS" size="2">Controller/Action reuse</font>

<font face="Trebuchet MS" size="2">For this posting, I will be using MonoRail in any examples but these ideas are confined to any one MVC framework. You can apply it to your own custom MVC, ASP.NET MVC or anything other MVC framework for that matter.</font>

**<font face="Trebuchet MS" size="2">Actions</font>**

<font face="Trebuchet MS" size="2">Action naming is one area that I think deserves the most attention. There are a couple of different implications of your choices here. You may say, well I can just rename my actions but this drags along some pains because then you have to repoint any hyperlinks you have referring to those actions and refactor any controller code that uses those actions. You can mitigate the hyperlink problem by adding a new Routing Rule to point to the new action, but this should only be used as a temporary fix and shouldn&#8217;t be a permanent solution.</font>

<font face="Trebuchet MS" size="2">When naming my actions I always try to limit actions to one word. There are a couple of reasons for this. The less words the easier it is to convey intent of what the action is going to do. This is often hard to convey with one word so sometimes two words are necessary. I try to keep it to one and often cringe when I add that second word. Common action names I have on a controller are, View, List, Search, Find, New, Create so on and so forth. While using jQuery to do ajax calls I am considering prefixing all actions that are called via jQuery with &#8220;Ajax&#8221;. So if I want to perform a Get action that is called via ajax the action name would be AjaxGet, this way it reads like the jQuery methods for performing the calls to a remote page.</font>

<font face="Trebuchet MS" size="2">Next, I try to steer away from overloading Actions. Sometimes there are exceptions but as a rule of thumb, if I am overloading my actions I take a second look at why I am needing to do this and usually gives me a hint that I need to refactor some code on the controller like break it up into two seperate controllers. This is often the case.</font>

<font face="Trebuchet MS" size="2">Action names should always be performing that verb on the controller at hand. So for a Controller named UserController, any action should &#8220;usually&#8221; be working with a User. Some actions do turn out to be utility actions however so use your judgement as to when you can stray away from this idea.</font>

**<font face="Trebuchet MS" size="2">View/PropertyBag variables</font>**

<font face="Trebuchet MS" size="2">When I refer to &#8220;View/PropertyBag variables&#8221;, I am referring to data that is sent to the view from the Controller so we are all on the same page.</font>

<font face="Trebuchet MS" size="2">On naming of your ProperyBag variables, I always am careful to be consistent with my pluralizing here. If I am sending a collection of objects, be sure to make the variable plural so that you don&#8217;t mix yourself up. Other than that, I just remain consistent with entity/dto naming in my domain so that it is consistent across the board.</font>

**<font face="Trebuchet MS" size="2">Controller/Action Reuse</font>**

<font face="Trebuchet MS" size="2">This is one area that is a struggle. The easiest and most commonly used approach is Controller inheritance which works without a hitch. In my experience this works well for small scenarios with minimal reuse. Once you get into more complex Actions it becomes cumbersome and undesirable to attempt to apply inheritance to your Controllers. There are a couple of things that can help once you outgrow inheritance.</font>

<font face="Trebuchet MS" size="2">The first is MonoRails DynamicActions. DynamicActions are a way to create an action in it&#8217;s own class and then by using attributes, you can hook up the disconnected action to whichever Controllers you wish, passing in parameters that deal with the specific context the DynamicAction is being used in. This works extremely well if the code that needs to be reused is exactly the same except for the objects that it is working with. For instance, list and view actions.</font>

 <font face="Trebuchet MS" size="2">One area where I have found Controller inheritance to work very well is in the area of managing security in your Controllers. What I commonly do is make a &#8220;SecureControllerBase&#8221; that has an Authentication Filter applied to check if the current user context is authenticated or not, redirecting where appropriate. I commonly use these base controllers for applying filters/monorail attributes across all controllers. That comes in pretty handy.</font>

<font face="Trebuchet MS" size="2">That concludes my little blurb on Controller design/layout. If you have something to add please add a comment.</font>