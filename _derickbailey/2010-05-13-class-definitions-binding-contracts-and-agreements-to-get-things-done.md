---
wordpress_id: 156
title: 'Class Definitions: Binding Contracts And Agreements To Get Things Done'
date: 2010-05-13T12:00:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/05/13/class-definitions-binding-contracts-and-agreements-to-get-things-done.aspx
dsq_thread_id:
  - "265083004"
categories:
  - .NET
  - 'C#'
  - Ruby
redirect_from: "/blogs/derickbailey/archive/2010/05/13/class-definitions-binding-contracts-and-agreements-to-get-things-done.aspx/"
---
I’ve been reading the [Metaprogramming Ruby](http://pragprog.com/titles/ppmetr/metaprogramming-ruby) book from Pragmatic Press off and on for a few months now. It’s really helped me understand a lot about how Ruby works and how I should go about using the language to do what I need. One of my personal favorite points that it makes is how Ruby treats a class definition as a change in the scope of executing code, rather than a contract definition. It’s especially interesting to me in comparison to how C# (and I assume, Java) work with class definitions. 

&#160;

### C#/.NET Class Definitions: Legally Binding Contracts

A class definition in C# is like a legal contract. You have to fill out a bunch of paperwork, create an outline with section names and numbers, use legalese language that no one other than a lawyer could even begin to understand, initial 12 different spots and sign your first born child away on the back page. Ok, maybe it’s not quite that bad… close, though. 

The compiler in C# creates a contract of sorts that is the metadata describing the class’s structure. This structure is defined by you, the developer, using the various semantics of the class keyword, methods and properties, etc. Every item that is defined in a class becomes a part of that class’ contract – whether it’s public or private or whatever else. 

At design / build time, the C# compiler uses that contract definition to determine what operations are allowed on the class, and how they are allowed to be called. This is akin to writing and signing the contract. You write the class definition in C# syntax, and you sign off on it being complete when you run the C# compiler. 

At runtime, that class definition is used to determine how the memory management works with the class – what goes on the heap, where and when, etc. This is akin to the contract being executed. Calling a method on a C# contract requires the specific contract section and paragraphs to be addressed and read, with the work being done according to the paragraph. A general C# class allows some freedom of implementation. If you include some of the Design By Contract features in C# 4, tough, the paragraphs get even more details as to what you are allowed to do, when. When you ask a C# object to do something, it must be something that the contract defined. If the class contract does not know about what you asked for, a runtime exception is thrown saying that the method could not be found.

Every time you modify the class and re-compile a class you are creating and executing a new contract. Fortunately, the .NET runtime is smart enough to know that the same contract name with the same signatures is probably a replacement for the old one. It lets you substitute the new contract for the old one in many cases. That is, unless you give the class a strong name or alter the signature of the class so badly that .NET can’t reconcile it. Throw in some strong naming of the class that you’re dealing with and you’ve got a contract that is notarized and stored in a vault with a security guard posted 24 hours a day. You’re never allowed to have the original contract back and you’re never allowed to change it. Ever. The only thing you can do is get a copy of the contract definition (your source code) and re-execute with a new notary signature / stamp, creating a new contract that is also locked into a vault with another security guard. For the most part, any change you make to a class with a strong name will cause the .NET runtime to consider this a new contract. There are probably some exceptions to that, but it’s not really important at the moment.

&#160;

### Ruby Class Definitions: Handshakes And Cooperative Agreements

A class definition in ruby is more like a friendly agreement – a handshake to represent two parties that want to work together to get something done. There is a general sense of the work that needs to be accomplished through communication with the class that is doing the work but the work is not limited to the original agreement. If the class doing the work doesn’t know how to do the work, it can be “taught” how to do it. The two parties in the agreement can modify the agreement at runtime and continue the work with the goal of getting things done, cooperating with each other instead of restricting each other’s actions to a set of legally binding contract clauses.

When a Ruby class does not know how to perform the work requested, a few different things can happen: 

  * the code requesting the work can tell the class how to do it using the open type system in Ruby and either extending the class or including a module in the class
  * the code requesting the work can directly modify the class at runtime and provide the knowledge of how to do the work
  * the class that is having work requested can forward the request up through it’s chain of modules and inheritance hierarchy to see if anything else in the chain knows how to do it
  * and probably some other things that i don’t remember at the moment

The open type system in Ruby (and other ‘dynamic’ languages) allows the code to work toward accomplishing the goals of the requester by allowing runtime modifications to be made. A quick discussion between the thing that needs work done and the thing doing the work can result in a new working relationship between them.

&#160;

### Compiled Contracts vs. Scope Of Execution

In C#, a class is a compiled contract stored in a class definition inside of an assembly. The class is set and can’t be altered at runtime. Code that executes does not execute from within the class definition, it executes from an object – an instance of the class definition. You cannot change the class definition at runtime. 

In Ruby, a class is not a compiled contract and it is not a meta-definition that is only used to create runtime objects. A class in Ruby is an object like any other object and is a first class citizen of the Ruby runtime like any other object. A Ruby class is still used to create instances of that class, but the details in ho this works are very different from how a C# object works (and are outside the scope of this discussion). An object in ruby – any object, including a class object – can be modified at runtime because the class and the object are not contracts to be fulfilled. The objects and class definitions are agreements to do work.

The key to understanding how Ruby accomplishes this is to think of a class definition as a scope of execution rather than a contract definition. Every line of code in a Ruby program operates within a specific scope. That scope is defined by various keywords and constructs including the module, class and method definition constructs. When you call “class Foo” in Ruby, don’t think of it as a contract definition. Rather, think of it as changing the scope in which the next lines of code will operate. You are not defining a class, you are opening that’s class’ scope so that it can be modified.

&#160;

### A Place For Contracts And Handshakes

Of course, the analogies and metaphors that I’m using do fall apart at some point. I’m not offering a complete guide to the technical details of any of these languages. I am trying to provide guidance and understand on the concepts behind the different systems, though. Gaining an understanding of the core differences between a dynamic language like Ruby and a static language like C# or Java, in terms of how class definitions are handled, can be an eye-opening and enlightening experience. With this knowledge at hand, the contexts in where each language shines becomes easier to see. Do you need a formal, legal contract to do business? Or do you just want to get things done? I’m not passing any judgment on either of these class definition systems, though. I’m only pointing out how they differ so that they can be used more effectively. There are positive and negative aspects of both types of systems and understanding all of these aspects will better prepare you to make the decision on which one is the right one to use in various circumstances.