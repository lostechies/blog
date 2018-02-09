---
wordpress_id: 6
title: 'Coding C# in Style'
date: 2007-09-25T20:38:00+00:00
author: Colin Ramsay
layout: post
wordpress_guid: /blogs/colin_ramsay/archive/2007/09/25/coding-in-style.aspx
categories:
  - 'C#'
  - Resharper
  - style guidelines
redirect_from: "/blogs/colin_ramsay/archive/2007/09/25/coding-in-style.aspx/"
---
I admit it; I&#8217;ve got problems. I get itchy when my code isn&#8217;t arranged in the right order, I get the shakes when I open a file and see code sprawling all over the place, I get nervous when my fields aren&#8217;t prefixed with an underscore. So I work to my own personal style, strictly adhering to some key guidelines.


  


**Private Fields Are Underscored**


  


This helps me tell at a glance whether the variable I&#8217;m assigning to is class-level or method level. It provides a little bit of context and a reminder of where a variable belongs in a class &#8211; is a throwaway variable or could other methods be working with it?


  


**Tabs, Not Spaces**


  


This is probably the subject of a thousand flame-wars on forums and mailing lists across the internet, but I opt for tabs. I also work with Visual Studio&#8217;s &#8220;View White Space&#8221; option switched on so I can check for excess tabs and line breaks more easily. I told you I had a problem.


  


**Regions Are Your Friend**


  


When I open a class file, I&#8217;ve usually got a purpose in mind, and seeing reams of code is a surefire way to make me dismay. On the other hand, opening a file which is organised using regions means I can quickly focus on the area I want to act upon. It also allows me to collapse the code I&#8217;ve been investigating back to an &#8220;overview&#8221; state using Visual Studio&#8217;s CTRL+M, CTRL+O shortcut.


  


**Save Me, Resharper**


  


As with most Visual Studio operations, Resharper is there to help. In this case, JetBrains provided a great new feature for R#3 &#8211; the Type Members Layout options. By supplying an XML layout, you can tell R# to reorganise your code into a specific order within specific regions. I&#8217;ve [uploaded my current Layout XML](http://www.lostechies.com/blogs/colin_ramsay/rs.txt){.}, which will reorganise your code in my style &#8211; fields, properties, constructors then methods &#8211; all within their own region. If only JetBrains could come up with something to enforce naming conventions and other coding styles!


  


**Conclusion**


  


I&#8217;ve heard people a number of times that it&#8217;s better to enforce any coding style, even if your team doesn&#8217;t agree with some aspects, than to not enforce anything at all. I totally agree with this statement &#8211; from C# to Javascript to CSS and SQL, if you make sure your developers work to a single standard you can be sure they can jump into a file and not be terrified. Ok, not be _really_ terrified anyway. Let me know about the guidelines your company enforces and which tools, if any, you use to do so!