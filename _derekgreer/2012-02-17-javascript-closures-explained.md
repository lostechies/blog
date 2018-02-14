---
wordpress_id: 645
title: JavaScript Closures Explained
date: 2012-02-17T03:40:29+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=645
dsq_thread_id:
  - "579172872"
categories:
  - Uncategorized
tags:
  - Closures
  - ECMAScript
  - JavaScript
---
If you write any code in JavaScript then you’ve probably used closures, but do you actually understand what they are and how they work?&nbsp; Taking the time to understand closures and how they’re implemented can add a deeper dimension to your understanding of the JavaScript language.&nbsp; In this article, I’ll discuss what closures are and how they’re specified for the JavaScript language.

## What Are Closures?

A _closure_ is a pairing of a function along with its referencing environment such that identifiers within the function may refer to variables declared within the referencing environment.

Let’s consider the following example:

<pre class="prettyprint">var createGreeting = function(greeting) {
    return function(name) {
        document.write(greeting + ', ' + name + '.');
    };
};


helloGreeting = createGreeting("Hello");
howdyGreeting = createGreeting("Howdy");

helloGreeting("John");  // Hello, John.
helloGreeting("Sally"); // Hello, Sally.
howdyGreeting("John");  // Howdy, John.
howdyGreeting("Sally"); // Howdy, Sally.
</pre>

&nbsp;

In this code, a function named _createGreeting_ is defined which returns an anonymous function.&nbsp; When the anonymous function is executed, it prints a greeting which consists of the outer function’s _greeting_ parameter along with the inner function’s _name_ parameter.&nbsp; While the greeting parameter is neither a formal parameter&nbsp; nor a local variable of the inner function (which is to say it is a _free variable_), it is still resolved when the function executes.&nbsp; Moreover, the createGreeting function object is no longer in scope and may have even been garbage collected at the point the function executes.&nbsp; How then does this work?

The inner function is capable of resolving the greeting identifier due to a closure which has been formed for the inner function.&nbsp; That is to say, the inner function has been paired with its referencing (as opposed to its calling) environment.

Conceptually, we can think of our closure as the marriage between a function and the environment in which it was declared within:

[<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: block; float: none; border-top-width: 0px; border-bottom-width: 0px; margin-left: auto; border-left-width: 0px; margin-right: auto; padding-top: 0px" title="closure2" border="0" alt="closure2" src="http://lostechies.com/content/derekgreer/uploads/2012/02/closure2_thumb.png" width="329" height="153" />](http://lostechies.com/content/derekgreer/uploads/2012/02/closure2.png)

&nbsp;

Exactly what this marriage looks like at an implementation level differs depending on the language.&nbsp; In C# for instance, closures are implemented by the instantiation of a compiler-generated class which encapsulates a delegate and the variables referenced by the delegate from its declaring scope. In JavaScript, the function object itself contains a non-accessible property pointing to an object containing the variables from its declaring scope.&nbsp; While each implementation differs, both render a function that has access to what its environment looked like at the point it was created.

Let’s move on to examining how JavaScript closures work from a specification perspective.

## JavaScript Closures

To understand how closures work in JavaScript, it helps to have a grasp of the underlying concepts set forth within the [ECMAScript Language Specification](http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-262.pdf).&nbsp; I’ll be using Edition 5.1 (ECMA-262) of the specification as the basis for the following discussion.

### Execution Contexts

When a JavaScript function is executed, a construct referred to as an _Execution Context_ is created.&nbsp; The Execution Context is an abstract concept prescribed by the specification to track the execution progress of its associated code.&nbsp; As an application runs, an initial Global Execution Context is created.&nbsp; As each new function is created, new Execution Contexts are created which form an Execution Context stack.

There are three primary components prescribed for the Execution Context:

  1. The LexicalEnvironment
    
      * The VariableEnvironment
        
          * The ThisBinding</ol> </ol> 
        
        Only the LexicalEnvironment and VariableEnvironment components are relevant to the topic of closures, so I’ll exclude discussion of the ThisBinding.&nbsp; (For information about how the ThisBinding is used, see sections 10.4.1.1, 10.4.2, and 10.4.3 of the [ECMAScript Lanauage Specification](http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-262.pdf).)
        
        ### LexicalEnvironment
        
        The _LexicalEnvironment_ is used to resolve identifier references made by code associated with the execution context.&nbsp; Conceptually, we can think of the LexicalEnvironment as an object containing the variables and formal parameters declared within the code associated by the current Execution Context.
        
        A LexicalEnvironement itself is comprised of two components: An _Environment Record_, which is used to store identifier bindings for the Execution Context, and an _outer_ reference which points to a LexicalEnvironment of the declaring Execution Context (which is null in the case of the Global Execution Context’s LexicalEnvironment outer reference).&nbsp; This forms a chain of LexicalEnvironments, each maintaining a reference to the outer scope’s environment:
        
        &nbsp;
        
        <p align="center">
          <a href="http://lostechies.com/content/derekgreer/uploads/2012/02/LexicalEnvironmentChain.png"><img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="LexicalEnvironmentChain" border="0" alt="LexicalEnvironmentChain" src="http://lostechies.com/content/derekgreer/uploads/2012/02/LexicalEnvironmentChain_thumb.png" width="322" height="483" /></a>
        </p>
        
        &nbsp;
        
        ### VariableEnvironment
        
        The _VariableEnvironment_ is used to record the bindings created by&nbsp; variables and function declarations within an execution context.&nbsp; Upon reading that description, you may be thinking: “_but I thought the LexicalEnvironment held the bindings for the current execution context_”.&nbsp; Technically, the VariableEnvironment contains the bindings of the variables and function declarations defined within an Execution Context and the LexicalEnvironment is used to resolve the bindings within the Execution Context.&nbsp; Confused?&nbsp; The answer to this seemingly incongruous approach is that, in most cases, the LexicalEnvironment and VariableEnvironment are references to the same entity.
        
        The LexicalEnvironment and VariableEnvironment components are actually references to a LexicalEnvironment type.&nbsp; When the JavaScript interpreter enters the code for a function, a new LexicalEnvironment instance is created and is assigned to both the LexicalEnvironment and VariableEnvironment references.&nbsp; The variables and function declarations are then recorded to the VariableEnvironment reference.&nbsp; When the LexicalEnvironment is used to resolve an identifier, any bindings created through the VariableEnvironment reference are available for resolution.
        
        ### Identifier Resolution
        
        As previously discussed, LexicalEnvironments have an outer reference which, except for the Global Execution Context’s LexicalEnvironment, points to a LexicalEnvironment record of the declaring Execution Context (i.e. a function block’s “parent” scope).&nbsp; Functions contain an internal scope property (denoted as [[Scope]] by the ECMAScript specification) which is assigned a LexicalEnvironment from the declaring context.&nbsp; In the case of function expressions (e.g. var doStuff = function() { …}), the [[Scope]] property is assigned to the declaring context’s LexicalEnvironment.&nbsp; In the case of function declarations (e.g. function doStuff() { … }), the [[Scope]] property is assigned to the declaring context’s VariableEnvironment.&nbsp; We’ll discuss the reasons for this disparity shortly, but for now let’s just focus on the fact that the function has a [[Scope]] which points to the environment in which is was created.&nbsp; This is our pairing of a function with its referencing environment, which is to say, this is our closure.&nbsp; 
        
        If we recall our previous conceptualization of a function paired with its environment, the JavaScript version of this conceptualization would look a little like this:
        
        &nbsp;
        
        <p align="center">
          <a href="http://lostechies.com/content/derekgreer/uploads/2012/02/closure3.png"><img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="closure3" border="0" alt="closure3" src="http://lostechies.com/content/derekgreer/uploads/2012/02/closure3_thumb.png" width="546" height="377" /></a>
        </p>
        
        When resolving an identifier, the current LexicalEnvironment is passed to an abstract operation named _GetIdentiferReference_ which checks the current LexicalEnvironment’s Environment Record for the requested identifier and if not found calls itself recursively with the LexicalEnvironment’s outer reference.&nbsp; Each link of the chain is checked until the top of the chain is reached (the LexicalEnvironment of the Global Context) in which case the binding is resolved or a reference of undefined is returned.
        
        ### A Distinction Without a Difference … Usually
        
        As mentioned, the LexicalEnvironment and the VariableEnvironement references point to the same LexicalEnvironment instance in most cases.&nbsp; The reason for maintaining these as separate references is to support the _with_ statement.
        
        The _with_ statement facilitates block scope by using a supplied object as the Environment Record for a newly created LexicalEnvironment.&nbsp; Consider the following example:
        
        <pre class="prettyprint">var x = {
    a: 1
};

var doSomething = function() {
    var a = 2;
    
    with(x) {
        console.log(a);
    };
};
doSomething(); // 1
</pre>
        
        &nbsp;
        
        In this code, while the doSomething function assigns the variable a the value of 2, the console.log function logs the value of 1 instead of 2.&nbsp; What is happening here is that, for the enclosing block of code, the with statement is inserting a new LexicalEnvironment at the front of the chain with an Environment Record set to the object x.&nbsp; When the code within the with statement executes, the first LexicalEnvironment to be checked will be the one created by the with statement whose Environment Record contains a binding of x with the value of 1.&nbsp; Once the with statement exits, the LexicalEnvironment of the current Execution Context is restored to its previous state.
        
        According to the ECMAScript specification, function expressions may be declared within a with statement, but not function declarations (though most implementations allow it with varied behavior).&nbsp; Since function expressions may be declared, their declaration should form a closure based upon the declaring environment’s LexicalEnvironment because it is the LexicalEnvironement which might be changed by a with statement.&nbsp; This is the reason why Execution Contexts are prescribed&nbsp; two different LexicalEnvironment references and why function declarations and function expressions differ in which reference their [[Scope]] property is assigned upon function creation.
        
        ## Conclusion
        
        This concludes our exploration of closures in JavaScript.&nbsp; While understanding the ECMAScript Language Specification in detail certainly isn’t necessary to have a working knowledge of closures, I find taking a peek under the covers now and again helps to broaden one’s understanding about a language and its concepts.
