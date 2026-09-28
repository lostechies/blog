---
wordpress_id: 184
title: Domain Models, Dependencies And Fighting Anemia
date: 2010-09-22T18:12:11+00:00
author: Derick Bailey
wordpress_guid: /blogs/derickbailey/archive/2010/09/22/domain-models-dependencies-and-fighting-anemia.aspx
dsq_thread_id: "262389923"
categories:
  - Analysis and Design
  - 'C#'
  - Design Patterns
  - Domain Driven Design
  - Principles and Patterns
aliases: "/blogs/derickbailey/archive/2010/09/22/domain-models-dependencies-and-fighting-anemia.aspx/"
---
For a long time now, I’ve been in the camp that says you shouldn’t have domain entities take dependencies… but at this point I’m having a hard time remembering why. I’m sure I could dig up my old notes and blog posts, but I don’t feel like doing that right now. Rather, I wanted to discuss a scenario that I run into a lot – and am currently facing – anemic domain models. The problem that I constantly run into is that I need to have access to a repository or some other functionality inside of my entities in order to get something done. If I decide to go down the path of not letting my entities have dependencies, then I end up pulling the logic that might belong in my entities out into a service class and my domain model becomes anemic – nothing more than simple data transfer objects with a few simple factory methods for the various collections and child objects on the entity. 

Here’s the scenario that I’m running into right now…

I have a Container with a collection of Assets. The Container class has an AddAsset method which takes a number of arguments that are used to create an Asset and then adds the new Asset to the Container’s collection. When a Container is first created, it has no Assets in yet. When the first asset is added to the container, I need to look up that Asset’s Family and set the Container’s Family to that. From that point forward, all Assets that are added to the Container must be in the same Family. If you try to add an Asset to the Container and it is not in the same Family, you get an error saying you can’t do that. 

Sounds pretty simple, right? Just grab the Family off the Asset and assign it to the Container… but here’s the catch: the Family is not a property on the Asset and it cannot be a property on the Asset. The Asset has various Classifications associated with it (which are properties on the Asset) and the determination of what Family the Asset belongs to is done with a lookup based on the Asset’s Classifications. The Family cannot be set as a property on the Asset because the Family can change at any point in time, based on the Classifications. Our customers maintain the Families based on Classifications, and they can change them Classification –> Family relationship whenever they want, and the change is immediately reflected on all Assets that are affected. We can’t cache the changes because there are millions of Assets in the system and the Families change on a regular basis. It would be too much work for the system to cache this and would cause other problems, anyways. 

And it gets even more fun: There are multiple ways to add an Asset to a Container, from the system’s perspective. You can scan an Asset onto a Container (using a barcode scanner), or you can import Assets from another Container to create a new Container. In either case, the very first Asset added must set the Container’s Family.

Long story short: in order to add an Asset to my Container, my Asset class must have a reference to the Family look up service. 

So… what do do? How would you approach this situation? What options, patterns, processes, and code examples do you find useful in situations like this?

The options that I can think of, off-hand, are:

  1. Go the anemic domain route and push all the logic of adding an Asset to a Container out of the Container, so that this lookup can occur
  2. Allow the Container entity to reference the Family lookup service so that I can encapsulate all the logic I need between my Container and Asset
  3. Use some kind of notification from within the Container to say “I need the Family for these Classifications”, so that the Container doesn’t have to know about the Family lookup service, but can be told what Family to use when it needs to know
  4. Forget OO design and principles entirely, and duplicate the code wherever I need it, violating “Tell, Don’t Ask”, creating a procedural system, and generally causing me to pull my hair out with maintenance issues and bug fighting

Option #1: I’m tired of this option. I’m tired of anemic models that don’t have anything but getters/setters and simple collection management. I don’t want to go down this path anymore.

Option #2: This goes against the things I was taught, but I’m seriously questioning why I was taught this. Is it such a horrible thing for an Entity to take in a dependency? Of course, this introduces some potential problems when we talk about using NHibernate to reconstitute our Entities from the database. Yes, I know newer versions of NH support dependencies and parameterized constructors. That’s great for the people who are using the newer version of NH. We’re not, and the upgrade path is terrible due to the size, complexity and age of this system.

Option #3: I’m not even sure how to go down this path without adding a dependency to the Entities, in the first place. Secondly – what patterns would be appropriate for this? A Domain Event is wrong because this isn’t an event, it’s a request for information that is external to the Entity. A Command is wrong because this isn’t a fire-and-forget situation. A request/reply scenario sounds like it would work because it is that… but there are a dozen or more ways to implement this concept. Any suggestions on how to approach this? Any insight as to whether or not this approach is even viable, or at least, under what circumstances it is?

Option #4: Ok, this really isn’t an option. I’ll gladly go the anemic model route before I go back to this style of coding. 🙂

I’m sure there are other options which is why I’m asking how you approach this. If you can, provide links to example source code that shows what you are talking about (please don’t paste code directly in the comments – it looks horrible and is difficult to read. Use [Pastie](http://pastie.org/) or [Github Gists](http://gist.github.com/) or something like that, and provide a description with a link in the comments here).