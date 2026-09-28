---
wordpress_id: 3781
title: Using a Command Execution Style Architecture with a Domain Model
date: 2010-11-23T04:17:03+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2010/11/22/using-a-command-execution-style-architecture-with-a-domain-model.aspx
dsq_thread_id:
  - "262055766"
categories:
  - Command Processor Pattern
  - DDD
redirect_from: "/blogs/johnteague/archive/2010/11/22/using-a-command-execution-style-architecture-with-a-domain-model.aspx/"
---
Kyle Baley has an interesting [article](http://codebetter.com/blogs/kyle.baley/archive/2010/10/20/command-pattern-architecture-or-how-to-do-it-a-little-at-a-time.aspx) about how he’s using commands to break up the logic of his application into small manageable pieces. I’m using the same command processor pattern for a project I’ve working on as well.&#160; It&#8217;s a great way for breaking up those "service" classes that really just end up as great big lint collectors for various methods.

Kyle mentions that in his application, he still has a very anemic domain model and most of the work happens when a command is processed. However, it&#8217;s entirely possible to use a full domain model with the commands, and really make things easier in the long run.&#160; The commands do the same job the service methods did: collect information necessary for the domain models to do their job.&#160; Once that&#8217;s done, the info should be passed to your domain model to determine what to do with it. 

There are two reasons (that I can think of) why I think anemic domain models will cause problems in command based architectures.&#160; First, just as with service layer architecture, if you&#8217;re service layer is making decisions about what state your domain objects should be in, then the only way you can change the state of your domain object is by processing a command.&#160; Another problem is that, while using commands, makes it easier to understand what each command is doing, it also hides the process somewhat.&#160; When a command executor is responsible for finding the correct command to execute, it can be more difficult to manually fire off the correct command to execute.&#160; If there is important logic hidden in the command, it is more likely to be duplicated rather than referred.

Regardless of whether you use a Service Layer or a Command Processor architecture, the important part is to keep all of the logic that keeps your domain objects in a valid state within the domain object.&#160; This will promote the reuse of logic, increase the cohesion of you domain objects, and reduce the coupling to other components to maintain proper state of an object through it’s lifetime.