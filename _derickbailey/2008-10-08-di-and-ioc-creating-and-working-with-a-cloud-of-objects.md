---
id: 7
title: 'DI and IoC: Creating And Working With A Cloud Of Objects'
date: 2008-10-08T00:18:31+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2008/10/07/di-and-ioc-creating-and-working-with-a-cloud-of-objects.aspx
dsq_thread_id:
  - "262067844"
categories:
  - .NET
  - Analysis and Design
  - Design Patterns
  - Principles and Patterns
  - Refactoring
  - Unit Testing
---
A few months ago, I posted <a href="http://www.derickbailey.com/2008/08/29/WhatIsTheCorrectUseOfADependencyInjectionFrameworkOrIoCContainer.aspx" target="_blank">some thoughts and questions on the proper use of Inversion of Control (IoC) containers and the Dependency Inversion (DI) principle</a>. Since then, I&#8217;ve had the opportunity to do some additional study and teaching of DI, and I&#8217;ve had that light bulb moment for the proper use of an IoC container. I haven&#8217;t talked about it or tried to present the info to my team(s) yet, because I had not verified my thoughts were on the right track &#8211; until recently. I got to spend a few hours at the <a href="http://www.dovetailsoftware.com/" target="_blank">Dovetail</a> office with <a href="http://www.lostechies.com/blogs/chad_myers/" target="_blank">Chad</a>, <a href="http://codebetter.com/blogs/jeremy.miller/" target="_blank">Jeremy</a>, <a href="http://www.lostechies.com/blogs/joshuaflanagan/" target="_blank">Josh</a>, etc, and had the pleasure of being able to pick their brains on some of the questions and thoughts that I&#8217;ve had around DI and IoC. In the end, Chad confirmed some of my current thoughts and helped me put into a metaphor that I find to be very useful in understanding what Dependency Inversion really is &#8211; a cloud objects that can be strung together into the necessary hierarchy, at runtime.

Consider a set of classes that need to be instantiated into the correct hierarchy so that we can get the functionality needed. It&#8217;s really easy to have the highest level class &#8211; the one that we really want to call method on &#8211; instantiate the class for next level down, and have that class instantiate it&#8217;s next level down, and so-on, like this: 

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="123" alt="image" src="http://lostechies.com/derickbailey/files/2011/03DependencyInversionAndTheCloudOfObjects_8D80/image_thumb_1.png" width="258" border="0" />](http://lostechies.com/derickbailey/files/2011/03DependencyInversionAndTheCloudOfObjects_8D80/image_12.png) 

This creates the necessary hierarchy, but breaks the core object oriented principle of loose coupling. We would not be able to use ThisClass without bringing ThatClass along with it, and we would not be able to use ThatClass without bringing AnotherClass along with it.

By introducing a better abstraction for each class and putting Dependency Inversion into play, we can break the spaghetti mess apart and introduce the ability to use any of these individual classes without requiring the specific implementation of the dependent class. 

For starters, let&#8217;s introduce an interface for ThisClass to depend on and an interface for ThatClass to depend on.

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="193" alt="Adding Dependent Interfaces" src="http://lostechies.com/derickbailey/files/2011/03DependencyInversionAndTheCloudOfObjects_8D80/image_thumb.png" width="260" border="0" />](http://lostechies.com/derickbailey/files/2011/03DependencyInversionAndTheCloudOfObjects_8D80/image_5.png) 

Now that we have an interface that both of these classes can depend on, instead of the explicit implementation of the child object, we need to have the expected child object implement the interface in question. For example, we expect ThatClass to be used by ThisClass, so we will want ThatClass to implement the IDoSomething interface. By the same notion, we want AnotherClass to implement the IWhatever interface. This will allow us to provide AnotherClass as the dependency implementation for ThatClass. Our object model now looks like this:

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="243" alt="Implementing Dependency Interfaces" src="http://lostechies.com/derickbailey/files/2011/03DependencyInversionAndTheCloudOfObjects_8D80/image_thumb_2.png" width="260" border="0" />](http://lostechies.com/derickbailey/files/2011/03DependencyInversionAndTheCloudOfObjects_8D80/image_7.png) 

What we have now is not just a set of classes that all depend on each other, but a &#8220;cloud&#8221; of objects with dependencies and interface implementations that will let us build the hierarchy we need, when we need it. 

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="216" alt="The Cloud Of Objects" src="http://lostechies.com/derickbailey/files/2011/03DependencyInversionAndTheCloudOfObjects_8D80/image_thumb_3.png" width="260" border="0" />](http://lostechies.com/derickbailey/files/2011/03DependencyInversionAndTheCloudOfObjects_8D80/image_9.png) 

The real beauty of this is that we no longer have to care about the implementation specifics of IDoSomething from ThisClass. ThisClass can focus entirely on doing it&#8217;s duty and calling into IDoSomething when it needs to. And, by passing in the dependency as an abstraction, we&#8217;re able to replace the dependency implementation at any time &#8211; runtime, unit test time, etc. This also makes our system much easier to learn and understand, and most importantly &#8211; easier to change. 

Now that we have our cloud of implementations and abstractions in place, we will need to reconstruct the hierarchy that we want so we can call into ThisClass and have it perform it&#8217;s operations. Here&#8217;s where Dependency Inversion meets up with Inversion of Control. 

  * To create ThisClass, we need an implementation of IDoSomething 
      * ThatClass implements IDoSomething, so we&#8217;ll instantiate it before ThisClass 
          * ThatClass needs an instance of IWhatever 
              * AnotherClass implements IWhatever, so we&#8217;ll instantiate it before ThatClass 
                  * Once we have AnotherClass instantiated, we can pass it into ThatClass&#8217;s constructor 
                      * Once we have ThatClass instantiated, we can pass it into ThisClass&#8217;s constructor</ul> 
                    We end up with a hierarchy of objects that is instantiated in reverse order, like this:
                    
                    [<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="243" alt="Reconstructing The Hierarchy Of Depdencies" src="http://lostechies.com/derickbailey/files/2011/03DependencyInversionAndTheCloudOfObjects_8D80/image_thumb_4.png" width="260" border="0" />](http://lostechies.com/derickbailey/files/2011/03DependencyInversionAndTheCloudOfObjects_8D80/image_11.png) 
                    
                    We have now successfully inverted our system&#8217;s construction &#8211; each implementation detail is created and passed into the the object that depends on it, re-creating our hierarchy from the bottom up. In the end, we have an instance of ThisClass that we can call into, with the same basic hierarchy of classes that we started with. The real difference is that now we can change this hierarchy at any time without worrying about breaking the functionality of the system.
                    
                    Once we have our Dependency Inversion and Inversion of Control in place, we can start utilizing the existing IoC frameworks to automatically create our hierarchy of objects based on the advertised dependencies (an advertised dependency is a dependency that is specified as a constructor parameter of a class). Tools like <a href="http://structuremap.sourceforge.net/Default.htm" target="_blank">StructureMap</a>, <a href="http://www.springframework.net/" target="_blank">Spring.net</a>, <a href="http://www.castleproject.org/container/index.html" target="_blank">Windsor</a>, <a href="http://ninject.org/" target="_blank">Ninject</a>, and others, all provide automagic ways of creating each dependency of the object that is requested, all the way up/down the hierarchy. Utilizing one of these IoC containers can greatly simplify our code base and eliminate the many object instantiations that would start to liter our code. As I said in my previous post, I know all about what not to do with IoC containers. Good IoC usage, though, is another subject for <a href="http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/09/12/some-ioc-container-guidelines.aspx" target="_blank">another post</a>.