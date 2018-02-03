---
wordpress_id: 907
title: Exploring TypeScript
date: 2016-08-30T17:55:14+00:00
author: Derek Greer
layout: post
wordpress_guid: https://lostechies.com/derekgreer/?p=907
dsq_thread_id:
  - "5107372092"
categories:
  - Uncategorized
---
<p dir="ltr">
  A proposal to use TypeScript was recently made within my development team, so I’ve taken a bit of time to investigate the platform.  This article reflects my thoughts and conclusions on where the platform is at this point.
</p>

&nbsp;

<h2 dir="ltr">
  TypeScript: What is It?
</h2>

<p dir="ltr">
  TypeScript is a scripting language created by Microsoft which provides static typing and a class-based object-oriented programming paradigm for transpiling to JavaScript.  In contrast to other compile-to-javascript languages such as CoffeeScript and Dart, TypeScript is a superset of JavaScript which means that TypeScript introduces syntax enhancements to the JavaScript language.
</p>

<p dir="ltr">
  <img src="https://lh4.googleusercontent.com/5dOim07aCnQUsvhT46DKVtw9T-gNq3djeIrZpGC_PABTOD1yEL8k-FzoND8lpEEmgGHU7LboXOnKA7YWZwLqB4ruWrw36-kKN1UznQ1O-XOa67fo1k5K_xAFozSN3KdfLWbtJY6I" alt="" width="470" height="468" />
</p>

&nbsp;

<h2 dir="ltr">
  Recent Rise In Popularity
</h2>

<p dir="ltr">
  TypeScript made it’s debut in late 2012 and was first released in April 2014.  Community interest has been fairly marginal since it’s debut, but has shown an increase since an announcement that the next version of Google’s popular Angular framework would be written in TypeScript.
</p>

<p dir="ltr">
  The following Google Trends chart shows the interest parallel between Angular 2 and TypeScript from 2014 to present:
</p>

<p dir="ltr">
  <img src="https://lh3.googleusercontent.com/lXJD30Ta9Zl1TL2HYqasJL_os6IzFdHurk9amcVSbUVnAQOg5hy4lyn0QfdwRCTcQTehdIoBnw7r5tpm_7N5Ai1flIVxiT7jLsxtY19loQWqW9AAQ5WtmbtAfFhQamZpYkjLy8sB" alt="" width="624" height="193" />
</p>

&nbsp;

<h2 dir="ltr">
  The Good
</h2>

<h3 dir="ltr">
  Type System
</h3>

<p dir="ltr">
  TypeScript provides an optional type system which can aid in catching certain types of programing errors at compile time.  The information derived from the type system also serves as the foundation for most of the tooling surrounding TypeScript.
</p>

<p dir="ltr">
  The following is a simple example showing a basic usage of the type system:
</p>

<pre class="prettyprint">interface Person {
    firstName: string;
    lastName: string;
}

class Greeter {
    greeting: string;
    constructor(message: string) {
        this.greeting = message;
    }
    greet(person: Person) {
        return this.greeting + " " + person.firstName + " " + person.lastName;
    }
}

let greeter = new Greeter("Hello,");
let person = { firstName: "John", lastName: "Doe" };

document.body.innerHTML = greeter.greet(person);
</pre>

<p dir="ltr">
  In this example, a Person interface is declared with two string properties: firstName and lastName.  Next, a Greeter class is created with a greet() function which is declared to take a parameter of type Person.  Next, instances of Greeter and Person are instantiated and the Greeter instance’s greet() function is invoked passing in the Person instance.  At compile time, TypeScript is able to detect whether the object passed to the greet() function conforms to the Person interface and whether the values assigned to the expected properties are of the expected type.
</p>

<h3 dir="ltr">
  Tooling
</h3>

<p dir="ltr">
  While the type system and programming paradigm introduced by TypeScript are its key features, it’s really the tooling facilitated by the type system that makes the platform shine.  Being notified of syntax errors at compile time is helpful, but it’s really the productivity that stems from features such as design-time type checking, intellisense/code-completion, and refactoring that make TypeScript compelling.
</p>

<p dir="ltr">
  TypeScript is currently supported by many popular IDEs including Visual Studio, WebStorm, Sublime Text, Brackets, and Eclipse.
</p>

<h3 dir="ltr">
  EcmaScript Foundation
</h3>

<p dir="ltr">
  One of the differentiators of TypeScript from other languages which transpile to JavaScript (CoffeeScript, Dart, etc.) is that TypeScript builds upon the JavaScript language.  This means that all valid JavaScript code is valid TypeScript code.
</p>

<h3 dir="ltr">
  Idiomatic JavaScript Generation
</h3>

<p dir="ltr">
  One of the goals of the TypeScript team was to ensure the TypeScript compiler emitted idiomatic JavaScript.  This means the code produced by the TypeScript compiler is readable and generally follows normal JavaScript conventions.
</p>

&nbsp;

<h2 dir="ltr">
  The Not So Good
</h2>

<h3 dir="ltr">
  Type Definitions and 3rd-Party Libraries
</h3>

<p dir="ltr">
  Typescript requires type definitions to be created for 3rd-party code to realize many of the benefits of the tooling.  While  the <a href="https://github.com/DefinitelyTyped/DefinitelyTyped">DefinitelyTyped </a>project provides type definitions for the most popular JavaScript libraries used today, there will probably be the occasion where the library you want to use has no type definition file.
</p>

<p dir="ltr">
  Moreover, interfaces maintained by 3rd-party sources are somewhat antithetical to their primary purpose.  Interfaces should serve as contracts for the behavior of a library.  If the interfaces are maintained by a 3rd-party, however, they can’t be accurately described as “contracts” since no implicit promise is being made by the library author that the interface being provided accurately matches the library’s behavior.  It’s probably the case that this doesn’t prove to be much of an issue in practice, but at minimum I would think relying upon type definitions created by 3rd parties would eventually lead to the available type definitions lagging behind new releases of the libraries being used.
</p>

<h3 dir="ltr">
  Type System Overhead
</h3>

<p dir="ltr">
  Introducing a typesystem is a bit of a double-edged sword.  While a type system can provide a lot of benefits, it also adds syntactical overhead to a codebase.  In some cases this can result in the code you maintain actually being harder to read and understand than the code being generated.  This can be illustrated using Anders Hejlsberg’s example presented at Build 2014.
</p>

<p dir="ltr">
  The TypeScript source in the first listing shows a generic sortBy method which takes a callback for retrieving the value by which to sort while the second listing shows the generated JavaScript source:
</p>

<pre class="prettyprint">interface Entity {
	name: string;
}

function sortBy&lt;T>(a: T[], keyOf: (item: T) => any): T[] {
	var result = a.slice(0);
	result.sort(function(x, y) {
		var kx = keyOf(x);
		var ky = keyOf(y);
		return kx > ky ? 1: kx &lt; ky ? -1 : 0;
	});
	return result;
}

var products = [
	{ name: "Lawnmower", price: 395.00, id: 345801 },
	{ name: "Hammer", price: 5.75, id: 266701 },
	{ name: "Toaster", price: 19.95, id: 400670 },
	{ name: "Padlock", price: 4.50, id: 560004 }
];
var sorted = sortBy(products, x => x.price);
document.body.innerText = JSON.stringify(sorted, null, 4);
</pre>

<pre class="prettyprint">function sortBy(a, keyOf) {
    var result = a.slice(0);
    result.sort(function (x, y) {
        var kx = keyOf(x);
        var ky = keyOf(y);
        return kx > ky ? 1 : kx &lt; ky ? -1 : 0;
    });
    return result;
}
var products = [
    { name: "Lawnmower", price: 395.00, id: 345801 },
    { name: "Hammer", price: 5.75, id: 266701 },
    { name: "Toaster", price: 19.95, id: 400670 },
    { name: "Padlock", price: 4.50, id: 560004 }
];
var sorted = sortBy(products, function (x) { return x.price; });
document.body.innerText = JSON.stringify(sorted, null, 4);
</pre>

Comparing the two signatures, which is easier to understand?

**TypeScript**

<p dir="ltr">
  function sortBy<T>(a: T[], keyOf: (item: T) => any): T[]
</p>

**JavaScript**

<p dir="ltr">
  function sortBy(a, keyOf)
</p>

It might be reasoned that the TypeScript version should be easier to understand given that it provides more information, but many would disagree that this is in fact the case.  The reason for this is that the TypeScript version adds quite a bit of syntax to explicitly describe information that can otherwise be deduced fairly easily.  In many ways this is similar to how we process natural language.  When we communicate, we don’t encode each word with its grammatical function (e.g. “I [subject] bought [past tense verb] you [indirect object] a [indefinite article] gift [direct object].”)  Rather, we rapidly and subconsciously make guesses based on familiarity with the vocabulary, context, convention and other such signals.

<p dir="ltr">
   In the case of the sortBy example, we can guess at the parameters and return type for the function faster than we can parse the type syntax.  This becomes even easier if descriptive names are used (e.g. sortByKey(array, keySelector)).  Sometimes implicit expression is simply easier to understand.
</p>

<p dir="ltr">
  Now to be fair, there are cases where TypeScript is arguably going to be more clear than the generated JavaScript (and for similar reasons).  Consider the following listing:
</p>

<pre class="prettyprint">class Auto{
  constructor(public wheels = 4, public doors?){
  }
}
var car = new Auto();
car.doors = 2;
</pre>

<pre class="prettyprint">var Auto = (function () {
    function Auto(wheels, doors) {
        if (wheels === void 0) { wheels = 4; }
        this.wheels = wheels;
        this.doors = doors;
    }
    return Auto;
}());
var car = new Auto();
car.doors = 2;
</pre>

<p dir="ltr">
  In this example, the TypeScript version results in less syntax noise than the generated JavaScript version.   Of course, this is a comparison between TypeScript and it’s generated syntax rather than the following syntax many may have used:
</p>

wheels = wheels || 4;

<span style="color: #000000; font-size: 1.4em; line-height: 1.5em;">Community Alignment</span>

<p dir="ltr">
  While TypeScript is a superset of JavaScript, this deserves some qualification.  Unlike languages such as CoffeeScript and Dart which also compile to JavaScript, TypeScript starts with the EcmaScript specification as the base of it’s language.  Nevertheless, TypeScript is still a separate language.
</p>

<p dir="ltr">
  A team’s choice to maintain an application in TypeScript over JavaScript isn’t quite the same thing as choosing to implement an application in C# version 6 instead of C# version 5.  TypeScript isn’t the promise: “Programming with the ECMAScript of tomorrow ... today!”.  Rather, it’s a language that layers a different programming paradigm on top of JavaScript.  While you can choose how much of the feature superset and programming paradigm you wish to use, the more features and approaches peculiar to TypeScript that are adopted the further the codebase will diverge from standard JavaScript syntax and conventions.
</p>

<p dir="ltr">
  A codebase that fully leverages TypeScript can tend to look far more like C# than standard JavaScript.  In many ways, TypeScript is the perfect front-end development environment for C# developers as it provides a familiar syntax and programming paradigm to which they are already accustomed.  Unfortunately, developers who spend most of their time in C# often struggle with JavaScript syntax, conventions, and patterns.  The same might be expected to be true for TypeScript developers who utilize the language to emulate object-oriented development in C#.
</p>

<p dir="ltr">
  Ultimately, the real negative I see with this is that (at least right now) TypeScript doesn’t represent how the majority of Web development is being done in the community.  This has implications on the availability of documentation, availability of online help, candidate pool size, marketability, and skill portability.
</p>

<p dir="ltr">
  Consider the following chart which compares the current job openings available for JavaScript and TypeScript:
</p>

<p dir="ltr">
  <img title="Points scored" src="https://lh3.googleusercontent.com/d4AA-5New_zh1zXkw4CJVkFmZR4jh8GkN-T0JRrdmaXuh4rysP0coWY7ukPLj3C_Yg-JEv72A96dwv2CrD7GZP2ZvzflFiOuvWdMlb4uVbIjRlYKM4jhxA4-1TDD6a7-90OSd1am" alt="" width="600" height="371" />
</p>

<p dir="ltr">
  Source: simplyhired.com - August 2016
</p>

Now, the fact that there may be far less TypeScript jobs out there than JavaScript jobs doesn’t mean that TypeScript isn’t going to be the next big thing.  What it does mean, however, is that you are going to experience less friction in the aforementioned areas if you stick with standard EcmaScript.
  
&nbsp;

<h2 dir="ltr">
  Alternatives
</h2>

<p dir="ltr">
  For those considering TypeScript, the following are a couple of options you might consider before converting just yet.
</p>

<h3 dir="ltr">
  ECMAScript 2015
</h3>

<p dir="ltr">
  If you’re  interested in TypeScript and currently still writing ES5 code, one step you might consider is to begin using ES2015.  In John Papa’s article: “<a href="https://johnpapa.net/es5-es2015-typescript/">Understanding ES5, ES2015 and TypeScript</a>”, he writes:
</p>

Why Not Just use ES2015?  That’s a great option! Learning ES2015 is a huge leap from ES5. Once you master ES2015, I argue that going from there to TypeScript is a very small step.

In many ways, taking the time to learn ECMAScript 2015 is the best option even if you think you’re ready to start using TypeScript.  Making the journey from ES5 to ES2015 and then later on to TypeScript will help you to clearly understand which new features are standard ECMAScript and which are TypeScript … knowledge you’re likely to be fuzzy on if you move straight from ES5 to TypeScript.

<h3 dir="ltr">
  Flow
</h3>

<p dir="ltr">
  If you’ve already become convinced that you need a type system for JavaScript development or you’re just looking to test the waters, you might consider a lighter-weight alternative to the TypeScript platform: Facebook’s <a href="https://flowtype.org/">Flow </a>project.  Flow is a static type checker for JavaScript designed to gain static type checking benefits  without losing the “feel” of coding in JavaScript and in some cases <a href="https://djcordhose.github.io/flow-vs-typescript/2016_hhjs.html#/">it does a better job</a> at catching type-related errors than TypeScript.
</p>

For the most part, Flow’s type system is identical to that of TypeScript, so it shouldn’t be too hard to convert to TypeScript down the road if desired.  Several IDEs have Flow support including Web Storm, Sublime Text, Atom, and of course Facebook’s own Nuclide.

As of August 2016, [Flow also supports Windows](https://flowtype.org/blog/2016/08/01/Windows-Support.html).  Unfortunately this support has only recently become available, so Flow doesn’t yet enjoy the same IDE support on Windows as it does on OSX and Linux platforms.  IDE support can likely be expected to improve going forward.
  
&nbsp;

<h3 dir="ltr">
  Test-Driven Development
</h3>

<p dir="ltr">
  If you’ve found the primary appeal of TypeScript to be the immediate feedback you receive from the tooling, another methodology for achieving this (which has far greater benefits) is the practice of Test-Driven Development (TDD). The TDD methodology not only provides a rapid feedback cycle, but (if done properly) results in duplication-free code that is more maintainable by constraining the team to only developing the behavior needed by the application, and results in a regression-test suite which provides a safety net for future modifications as well as documentation for how the system is intended to be used. Of course, these same benefits can be realized with TypeScript development as well, but teams practicing TDD may find less need for TypeScript’s compiler-generated error checking.
</p>

&nbsp;

<h2 dir="ltr">
  Conclusion
</h2>

<p dir="ltr">
  After taking some time to explore TypeScript, I’ve found that aspects of its ecosystem are very compelling, particularly the tooling that’s available for the platform.  Nevertheless, it still seems a bit early to know what role the platform will play in the future of Web development.
</p>

<p dir="ltr">
  Personally, I like the JavaScript language and, while I see some advantages of introducing type checking, I think a wiser course for now would be to invest in learning EcmaScript 2015 and keep a watchful eye on TypeScript adoption going forward.
</p>
