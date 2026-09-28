---
wordpress_id: 48
title: How A .NET Developer Learned Ruby And Rake, To Build .NET Apps In Windows
date: 2009-04-08T15:01:51+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/04/08/how-a-net-developer-learned-ruby-and-rake-to-build-net-apps-in-windows.aspx
dsq_thread_id:
  - "262068125"
categories:
  - .NET
  - Continuous Integration
  - Education
  - Rake
  - Ruby
redirect_from: "/blogs/derickbailey/archive/2009/04/08/how-a-net-developer-learned-ruby-and-rake-to-build-net-apps-in-windows.aspx/"
---
I recently decided it was time for me to learn Ruby and Rake – with the specific goal of replacing my NAnt scripts in some projects, due to the high level of complexity and logic that I need in the build process. After asking around the LosTechies crew for advice, and receiving more advice than I had ever hoped for, here’s the basics of what I did to learn Ruby and Rake…

First and foremost – don’t use any kind of IDE. At most, use the “SciTE” text editor that comes with the One-Click installer. It provides simple highlighting, but doesn’t give you any crutches like Intellisense, debugging, etc. Learn the actual language, not an IDE.

  1. **Install** the Ruby language and runtime via <a href="http://rubyforge.org/projects/rubyinstaller/" target="_blank">One-Click Installer for Windows</a>. Be sure to enable Ruby Gems. 
  2. **Read** the Wikibooks information on <a href="http://en.wikibooks.org/wiki/Ruby_Programming" target="_blank">Ruby Programming</a>. The information provided is very easy to read and understand, even for an old VB / C# guy like me. Be sure to read up on the conventions and other basics like objects, methods, and logic constructs.&#160;&#160; 
  3. **Run** the “irb &#8211; Interactive Ruby Console” from your programs list   
    [<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="164" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_219C19E4.png" width="489" border="0" />](https://lostechies.com/content/derickbailey/uploads/2011/03/image_118D4B2D.png)   
    and start hacking away at the basic ruby concepts from the Wikibooks information. You can type in class and method definitions right there in the console and start executing code!   
    [<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="192" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_313EB5A6.png" width="613" border="0" />](https://lostechies.com/content/derickbailey/uploads/2011/03/image_681909EC.png) 
  4. **Run** a Ruby file: After you’re comfortable with the basics of Ruby, you can start using a text editor to save some code in .rb files, and run them via the ruby command line.   
    [<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="192" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_07CA7466.png" width="279" border="0" />](https://lostechies.com/content/derickbailey/uploads/2011/03/image_136031A5.png)   
    [<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="151" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_709EF9E7.png" width="618" border="0" />](https://lostechies.com/content/derickbailey/uploads/2011/03/image_472827F6.png) 
  5. **Get Rake** by running “gem install rake” from a command prompt. No really. It’s that simple. Isn’t the Gem system great?!   
    [<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="161" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_128A5C6C.png" width="618" border="0" />](https://lostechies.com/content/derickbailey/uploads/2011/03/image_7E050CED.png) 
  6. **Read** about how <a href="http://www.railsenvy.com/2007/6/11/ruby-on-rails-rake-tutorial" target="_blank">Rake turned Gregg into an alcoholic</a> (it’s a great Rake tutorial! I promise!) and go through the tutorial. 
  7. Then build your own Rake file! Call it “rakefile.rb” so the “rake” command will find it easily.   
    [<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="192" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_2D568278.png" width="466" border="0" />](https://lostechies.com/content/derickbailey/uploads/2011/03/image_14C6E528.png)   
    [<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="161" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_44185AB2.png" width="618" border="0" />](https://lostechies.com/content/derickbailey/uploads/2011/03/image_01A5B87C.png) 
  8. Read @<a href="http://twitter.com/laribee" target="_blank">laribee</a>’s post on <a href="http://codebetter.com/blogs/david_laribee/archive/2008/08/25/omg-rake.aspx" target="_blank">using Rake to build .NET apps</a> and learn how to shell out to an MSBuild call, and build your .NET app!   
    [<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="91" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_7EFF8D7B.png" width="604" border="0" />](https://lostechies.com/content/derickbailey/uploads/2011/03/image_316360FB.png) </p> </p> </p> 

From there, the world is yours! Rake is so stinking simple, and so powerful. You have complete access to all of the Ruby code you could ever want – logic, conditional statements, loops and collections! You can code your entire build process in Ruby, and then script it together with rake tasks! I’m so much happier with Rake than I was with nant. All the angle-bracket XML tax that nant makes you pay was really getting on my nerves, with the complex build systems that I need.

All together, it took me less than 4 hours to create my first usable Rake builds for a sample .NET application. I still have to refer to the language syntax of Ruby, via the Wikibooks entry – I am still learning, after all. But I know the process and how it works well enough, to start using Rake for my project build needs, now!