---
wordpress_id: 263
title: Domain Models in presentation frameworks
date: 2008-12-16T03:35:04+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/12/15/domain-models-in-presentation-frameworks.aspx
dsq_thread_id:
  - "264716002"
categories:
  - ASPNETMVC
  - DomainDrivenDesign
  - Patterns
---
One common question when applying DDD is how to interpret other architecture’s concepts of a “model”.&#160; For example, two common presentation architectures are MVC and MVP.&#160; In each of those acronyms, the “M” is short for “Model”.&#160; So what exactly is this Model?&#160; Is it the Domain Model?&#160; Presentation Model?&#160; Something else entirely?

This question came up recently [on the DDD list](http://tech.groups.yahoo.com/group/domaindrivendesign/message/9176), and naturally, a slew of wide ranging answers came pouring in.&#160; One of the problems with trying to marry these two concepts is that MVC is a rather old concept, with roots almost 30 years old now.&#160; The concept of a “domain model” certainly wasn’t invented by Eric Evans.&#160; However, it takes some sleuthing to understand if the DDD model concept applies to MVC.&#160; It’s rather clear that the original concept intended that the “M” **is** “domain model”.&#160; Randy Stafford pointed this out in one of the replies to the original question, also suggesting an alternative name to the separate Model concept, “[Model Model View Controller](http://c2.com/cgi/wiki?ModelModelViewController)”.&#160; Another is the concept of “[Model View ViewModel](http://blogs.msdn.com/johngossman/archive/2005/10/08/478683.aspx)”.

Personally, I don’t like either of these names.&#160; Rather than come up with a different name, the real question comes down to, “should I use my Domain Model as my Presentation Model?”&#160; Lately, I’ve leaned strongly towards NO.

### Keeping our POCOs safe

When programming in an MVC architecture, you’re often playing by someone else’s rules.&#160; We strive to make our entities POCOs (Plain Ol’ CLR Objects), and completely persistent ignorant.&#160; Just as the persistence layer is an infrastructure detail, the View and Controller technology are a similar type of infrastructure, just at the other end of the pipeline.&#160; If we create our POCOs, then expect them to be used in the Controller and View (especially as things like arguments to a controller action), limitations on the technologies make our objects look like all sorts of crazy.

Now, no one really suggested making entities as arguments to controller actions, as the MVC technology can’t support the richness of our POCO objects.&#160; But what about the model passed to the View?&#160; Still, because of the limitations of MVC technology, the Model used in a View must look a very certain way for binding to work correctly.&#160; For example, in MonoRail and ASP.NET MVC, collections usually need to be arrays, and properties need to be read-write for binding to hook up properly.&#160; The same holds in MVP architectures, where the View technology is very sophisticated, but needs a Model that “plays nice” with its expectations.&#160; Otherwise, you won’t get any of the benefit of the underlying technology.

But we don’t _want_ our entities to be sullied by these outside forces.&#160; We want to create rich models, untouched by persistence _and_ presentation concerns.&#160; But to take full advantage of our presentation/view frameworks, we have to create something else.&#160; That “something else” goes by a couple names, both “ViewModel” and “Presentation Model”.&#160; I _really_ like this concept, not only because of my zealotry for POCOs and DDD, but because it’s a natural manifestation of the Separation of Concerns principle.

### Separating our presentation concerns

In addition to presentation/view frameworks requiring their models to look a very certain way, often many concepts belong _only_ in the presentation layer.&#160; Things like required fields, type checking, and other invariants are a product of the task of interpreting user input.&#160; Since all data comes as text over the web, something has to translate these values to types like ints, decimals, enumerations, and so on.&#160; Presentation frameworks can go quite a long way to convert types, but what about non-trivial cases?

What about the web form that has an input for Hour and Minute, and you need to combine them?&#160; But “Hour” needs to be a real hour, not 5784.&#160; That rule has no business in the Domain Model, as my model cares about DateTime, not about individual Hour Minute values.

For things like invariants and validation, I don’t want my Domain Model stuffed with invalid values that I then have to check after the fact.&#160; But stuff a ViewModel with invalid data, no harm done.&#160; I can validate that object by itself, and report the errors back to the user in a way that most presentation frameworks have built-in support for.&#160; It’s clear that while we’d have to make sacrifices in our Domain Model to make it available in the view, it’s often advantageous to simply break free altogether and embrace a completely separate ViewModel.

### Crafting a wicked ViewModel

When crafting a ViewModel in MVC land, there are two main “models” you need to worry about: the ViewModel used by your View, and the ViewModel used in action parameters.&#160; When designing a GET ViewModel, I craft the ViewModel to contain **only what is needed by the View to display its data, and nothing more.**&#160; Some folks call these DTOs, some ViewModel, but the idea is that you don’t pass your entities to the View.&#160; Create some ViewModel, map your entity to it somehow, and pass the ViewModel to the View.&#160; In our current project, we’re using a fluent-y auto-mapped solution, so that we never need to configure our mapping from Domain Model to ViewModel (this should be in MVCContrib sometime soon).&#160; The nice thing about this ViewModel is that it can use things like MVC validation and binding technologies, gelling nicely with whatever View framework you’re using.

In the action parameter side, here it really depends if the request is GET or POST.&#160; For POST, I have only one action parameter, and this is the same ViewModel type that was used to construct the original form.&#160; For GET, my rules are relaxed, and I might use Controller technology to bind actual entities to the parameters, so that I don’t have to manually load them up myself.&#160; In any case, I make a hard distinction between what my Controller uses, and what my View uses.&#160; I have no issue with the Controller knowing about my entities.&#160; But when it comes to the View, it’s generally best to let the presentation/view technology do what it does best and not affect my POCOs.

One nice side effect of this approach is that you can design your ViewModel exactly around each screen, so that one entity could be used on several screens, but you’d never need to compromise on the design of each individual ViewModel.&#160; Since each View has its own ViewModel, no other View influences the data it displays.&#160; Separation of Concerns circling around again.

### Keeping it simple

If you’re in a domain where your domain model can be easily used in your Views, you should take a real, hard look at other ways of making your life easier like the Active Record pattern.&#160; But if you’re having trouble dealing with DDD, it often comes with the impedance mismatch between MVC technologies and the quest for POCOs.&#160; You’re not doing anything wrong, except trying to force that elegant square peg into that stubborn round hole.&#160; By letting MVC frameworks do what they do best, and use mapping to go between these layers, we can shield our model from the concerns of the presentation layer.