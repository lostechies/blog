---
id: 4637
title: 'BDD &#8211; Files/Folders/Namespaces (BDD)'
date: 2008-10-28T15:30:00+00:00
author: Colin Jack
layout: post
guid: /blogs/colinjack/archive/2008/10/28/context-specification-files-folders-namespaces-bdd.aspx
categories:
  - BDD
  - TDD
---
<span style="font-weight: bold">Files/Folders</span>  
One thing that can be troublesome when moving to a&nbsp;BDD style approach is how to organize your files and folders, so far I&#8217;ve tried two approaches: 

  1. <span style="font-weight: bold">One class in each file</span> &#8211; So if you have <span style="font-style: italic">Whe</span><span style="font-style: italic">n_associating_an_order_with_a_customer </span>and <span style="font-style: italic">When_associating_an_order_with_a_preferred_customer</span> then they&#8217;d be in seperate files even though they are very closely related. If they share a base class, or a class they both compose, then that would be in yet another class (presumably).
  2. <span style="font-weight: bold">Multiple classes per file</span> &#8211; As an example you might group the <span style="font-style: italic">Order</span> addition contexts into a file called <span style="font-style: italic">OrderPlacementSpecifications</span>, the file could also contain the shared base class (if you went down that road).

To me the second approach has a couple of advantages: 

  1. <span style="font-weight: bold" class="Apple-style-span">Gives the reader extra information</span> &#8211; By grouping the two order placement classes we tell the reader that they are quite closely related.
  2. <span style="font-weight: bold">Simplifies folder structure</span> &#8211; If we go for the other approach, one class in each file, then we&#8217;re probably going to have to have more folders. The addition of the extra files and folders definitely makes the solution file harder to structure.

To give you an idea here&#8217;s a screen shot of a part of the folder structure for a sample app we&#8217;re doing:

<div style="text-align: left">
  <a href="http://1.bp.blogspot.com/_DTvjK44dn8U/SPdvGtdZY8I/AAAAAAAAAHs/Li5AAFMIZt4/s1600-h/BDDFolder.JPG"><img border="0" src="http://1.bp.blogspot.com/_DTvjK44dn8U/SPdvGtdZY8I/AAAAAAAAAHs/Li5AAFMIZt4/s320/BDDFolder.JPG" style="margin: 0px auto 10px;cursor: pointer;text-align: center" /></a><span style="font-weight: bold">Namespaces</span>
</div>

In addition to files/folders I&#8217;ve tried a few approaches to structuring namespaces but the approach I&#8217;m trying now groups related artifacts. For example:

  1. Specifications.Users.Domain 
  2. Specifications.Users.Domain.Contacts 
  3. Specifications.Users.Services 
  4. Specifications.Users.Domain.Repositories 
  5. Specifications.Users.UI.Controllers

The &#8220;Specifications&#8221; bit adds very little but I think grouping all specifications related to users is useful, not least as R# makes it easy to run all the specifications in a namespace. This can be useful if you have a big solution and only want to run the specifications for the area your working on. Its also worth saying that its &#8220;Users&#8221; to avoid clashing with the &#8220;User&#8221; class.

Folder wise however we&#8217;re using a standard approach where your Repositories are in a completely seperate folder from your controllers, even though they might both relate to a particular entity. To me the lack of relationship between our folders and namespaces isn&#8217;t a problem though, with R# its easy to find a file/type and in addition the folder/namespace tell you two different things about your codebase (one by &#8220;layer&#8221;, one by &#8220;feature&#8221;).

So I&#8217;m interested in peoples views? I&#8217;m guessing you&#8217;ll all dislike it though because from what I&#8217;ve seen no matter what you do people will be unhappy with your file/folder/namespace scheme. Pluse we&#8217;ll probably turn against this approach next week&#8230;.