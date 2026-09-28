---
wordpress_id: 4033
title: TDD Firestarter Wrapup
date: 2009-01-19T03:25:00+00:00
author: Scott Reynolds
layout: post
wordpress_guid: /blogs/scottcreynolds/archive/2009/01/18/tdd-firestarter-wrapup.aspx
categories:
  - Community
  - Testing
redirect_from: "/blogs/scottcreynolds/archive/2009/01/18/tdd-firestarter-wrapup.aspx/"
---
This weekend [Sean Chambers](http://schambers.lostechies.com) and I put on a day-long testing workshop at Microsoft in Tampa, FL. I want to thank all the attendees for giving up their Saturday to come out and learn about testing.

Special thanks to [Joe Healy](http://devfish.net) for putting on the event. He deserves a lot of credit for allowing us to come and use his space and eat his food and let us talk all day about something that wasn&#8217;t even Microsoft-specific. It&#8217;s because of the guys like him (and others) out in the trenches that I still have hope for Redmond.

Also major thanks to [Cory Foy](http://www.cornetdesign.com/), [Rob Eisenberg](http://devlicio.us/blogs/rob_eisenberg), [Chris Bennage](http://devlicio.us/blogs/christopher_bennage), [Josh Schwartzberg](http://twitter.com/dotjosh), [Scott Densmore](http://scottdensmore.typepad.com) and [Jose Bueno](http://twitter.com/kdebrain) for helping out with questions, running cameras, and providing moral support.

This event wouldn&#8217;t have happened if it weren&#8217;t for Sean, I checked out on the planning during my multi-month headache, so send mad props his way.

Some housekeeping from the event, I promised to throw up some links for some of the stuff we talked about.

First up is unit testing frameworks &#8211; all of which will do what we showed in the demo:

  * [NUnit (show in demo)](http://www.nunit.org)
  * [MBunit](http://mbunit.com)
  * [MSTest](http://microsoft.com)

Also there are plenty of unit testing frameworks for non-.net code. Search for [language]+Unit Testing in Google and you can find them for JavaScript, SQL, Java, Lua, Objective-C, C++, F#, Ruby, and just about anything else you&#8217;re using.
  
Next up we have Mocking/Isolation Frameworks:

  * [RhinoMocks (shown in demo)](http://ayende.com/projects/rhino-mocks.aspx) 
  * [Moq](http://code.google.com/p/moq/)

And don&#8217;t forget, you can always quickly write your own test doubles and fakes.    

  
Testing the UI: 

  * [Fitnesse (shown by Cory)](http://fitnesse.org) 
  * [Cucumber](http://wiki.github.com/aslakhellesoy/cucumber) 
  * [Selenium (web testing)](http://seleniumhq.org/) 
  * [Watir (web)](http://wtr.rubyforge.org/) 
  * [Watin (web)](http://watin.sourceforge.net/) 
  * [Test Run (the tool I couldn&#8217;t remember and you all thought I was insane)](http://msdn.microsoft.com/en-us/magazine/cc163864.aspx) 

And there are many more, these are just the ones I rememberd mentioning. Remember, if you need to test it, there&#8217;s a way to do it, it&#8217;s just about finding the right tools.

Additionally we talked about Continuous Integration, and mentioned that it could be done with tools such as [TeamCity](http://www.jetbrains.com), [CruiseControl.net](http://ccnet.thoughtworks.com), [Hudson](https://hudson.dev.java.net/) and Team Build with Team System.

If there&#8217;s anything I forgot to include post a comment and I will update. Thanks again to everyone who came, and I look forward to doing it again!