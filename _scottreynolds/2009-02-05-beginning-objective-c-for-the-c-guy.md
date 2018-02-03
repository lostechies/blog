---
wordpress_id: 4036
title: 'Beginning Objective-C for the C# Guy'
date: 2009-02-05T05:33:00+00:00
author: Scott Reynolds
layout: post
wordpress_guid: /blogs/scottcreynolds/archive/2009/02/05/beginning-objective-c-for-the-c-guy.aspx
categories:
  - Cocoa
  - mac
  - Objective-C
---
So my [new language of the year](http://www.pragprog.com/titles/tpp/the-pragmatic-programmer) is going to be Objective-C and Cocoa/CocoaTouch. This is actually a new language and a new IDE and a new platform and, well, everything. I&#8217;ve decided to document much of what I&#8217;m doing along the way. As you know I [switched my main platform to Mac](http://scottcreynolds.com/archive/2008/07/12/moving-to-the-macbook-pro.aspx) last year and have been doing my .Net development in a Virtual Machine. This has been great, working out extremely well, but part of what I wanted the Mac for was to branch out and explore some different ways of writing applications. Studying a new language is a great way to get a different view of how to accomplish programming tasks, and seeing how things are done on other platforms can only increase your skills as an application developer.

So with this post I wanted to go over some basics, compare some things in .Net to Objective-C, and kind of give a quickstart.

&nbsp;

### Environment Basics

Some housekeeping terminology. **XCode** is the IDE you use out of the box to develop mac applications. It&#8217;s a full-featured IDE that comes installed on your mac. In some senses it&#8217;s not nearly as mature as visual studio, and I find myself missing vs and particularly Resharper, however, you also don&#8217;t have to pay $2k for your dev tools, so, worth the tradeoff. 
	  
**Objective-C (ObjC)** is the standard language of choice for developing Mac applications. However it&#8217;s not the only one. There is support for Java and Ruby in _Cocoa_ and, of course, OSX being a *nix system, you can write programs for it in any language really. But for the purposes of talking about Cocoa/Mac dev, we&#8217;re talking mostly about ObjC.   

	  
**Cocoa (and CocoaTouch)** is your Mac development equivalent to the .NET framework basically. It provides a lot of framework base for mac development as well as the stuff that supports GUI hotness. CocoaTouch is Cocoa for iPhone/iPod Touch environments, with some differences in what it has and what is supported.

&nbsp;

### Objective-C Basic Information

Objective-C is a &#8220;strict superset&#8221; of C. This means that all valid C code is valid Objective-C code. Objective-C is an OO language. The Objective-C OO is more like SmallTalk OO than the C++ style OO you are used to. In Objective-C you talk to objects with _messages_ rather than calling methods. For instance the Objective-C code:

<pre>MyType *myType = [[MyType alloc] init];
[myType myTypeInstanceMethod:10];
</pre>


  
Is essentially the equivalent of the following C# code:

<pre>MyType myType = new MyType();
myType.myTypeInstanceMethod(10);
</pre>


  
So basically the method calls you are used to in C# turn into message passes in the [] brackets. 

The interesting thing about the messages is that you can send messages to an object that may not actually handle them. This is a dynamic typing feature borrowed from Smalltalk. You can choose to handle the message, or forward it on, but if you don&#8217;t do something with it you will get a runtime, not compile error. (xcode will give you a compile warning though to protect you from yourself a little.)

Some structural differences that might trip you up: if you have ever done any c/c++ you will be familiar with the practice of separating declaration from implementation on classes and methods and such. This is a luxury that is easy to overlook in C#, where you don&#8217;t have to do that. So in Objective-C you have to do that, but the thing you may trip up on is that the declaration of a class is called an &#8220;interface&#8221;. This is different from what you think of as an interface in C#. In Objective-C the &#8220;interface&#8221; is the signature of the class being implemented. If you want a C#-style interface that let&#8217;s you do composition over inheritance, you are looking for a &#8220;protocol&#8221; in Objective-C.

Declaring and Implementing a class in Objective-C:

<pre>@interface MyObject{
	
}
-(void) myTypeInstanceMethod:(int) integerMethodParam;
@end

@implementation MyObject
	
-(void) myTypeInstanceMethod:(int)integerMethodParam
{
	//do stuff
}
</pre>

Another thing you may be noticing looking at the code above is the slightly odd method signature. Let&#8217;s break it down. The &#8211; (minus) means &#8220;instance method&#8221;. A + would mean class method. Class methods in Objective-C are like statics in c# but they&#8217;re inheritance-friendly and can be overridden. (void) is your return type, just like C# but with parens. Then there&#8217;s the method name, then after the colon you have the parameters. You add more parameters by adding more colons:

<pre>-(void) myTypeInstanceMethodWith3Params:(int) integerParam1:(int)integerParam2:(int)integerParam3
</pre>


  
One thing you aren&#8217;t noticing is a visibility modifier. As far as I can tell, there&#8217;s no such thing as a private class method. You can do some tricks to hide it from the compiler, but because the class methods are really just there to respond to messages the object receives, if you send a message called the same thing as a class method it will get handled. 

&nbsp;

### Unit Tests

If you&#8217;re at all like me, hooking up tests is pretty second nature for you in c# now. Being able to write tests to verify my code helps me learn new things in new languages. The testing story is _interesting_ in xcode, especially if you are used to any of the standard test runners and frameworks in .net. 

XCode 3.1 comes bundled with a unit testing framework called OCUnit. OCUnit was a third-party open-source project that Apple got behind and took over responsibility for. (wait you mean the vendor doesn&#8217;t \*have\* to write their own test framework?) The mechanics of testing in xcode are a bit obtuse at first. I went [here](http://eschatologist.net/blog/?p=24) to figure out how to actually set up a testing system, and being totally new to the environment, it took me a while. But follow the steps and you&#8217;ll get there.

One thing to note is that there is no concept of a &#8220;test runner&#8221; like you have with tdd.net or resharper or mstest. In XCode, to do tests, you set up a new _build target_ that understands that it will be running tests. Then tests run as part of your build. That&#8217;s it. You build, it runs tests. All of them as far as I can tell. If a test fails, you get a build error. At first this feels like a much lamer experience than say the R# test runner, but on the positive side there&#8217;s no skipping tests and you do get the error inline with the code window. Either way, it takes some getting used to. As a side note, my homesickness for R# really kicks in as my &#8220;tdd workflow&#8221; in ObjC is clunky and very slow right now. 

Your tests in OCUnit are a convention-based thing, unlike a metadata (attribute) thing in .net. Your test methods must be void and must start with &#8220;test&#8221;. You also get a setup and teardown. This is a test fixture I wrote for doing the first [Project Euler](http://projecteuler.net) problem. It&#8217;s not really my typical style (I haven&#8217;t bothered trying to get a BDD flow going yet) but it shows the basics:

<pre>@implementation eulerproblemonespecs
EulerProblemOne *newProblemOne;
-(void) setUp
{
	newProblemOne = [[EulerProblemOne alloc]init];
}

-(void)tearDown
{
[newProblemOne release];

}

-(void) testItShouldFindMultiplesOfThreeAndFive
{
	//doing it with a variable
	bool isMultiple = [newProblemOne isMultipleOfThreeOrFive: 4];
	STAssertFalse(isMultiple,nil);
	
	//passing the message inline
	STAssertTrue([newProblemOne isMultipleOfThreeOrFive:3],nil);
	STAssertTrue([newProblemOne isMultipleOfThreeOrFive:5],nil);
	STAssertFalse([newProblemOne isMultipleOfThreeOrFive:23],nil);
}

-(void)testItShouldSumMultiplesOfThreeAndFiveInARange
{
	STAssertEquals([newProblemOne sumMultiplesInRange:0:10],23,nil);
}

@end
</pre>


		  
No other ceremony required other than the naming. In the declaration of the test fixture you just inherit from SenTestCase and go. 

So, to close this one out, I&#8217;m having a lot of fun learning this new environment. And it is interesting to care about memory management and performance again (very important for iPhone dev). And it&#8217;s interesting to think about OO in a different way. If you haven&#8217;t chosen a new language for the year, and you have the ability to try it, I&#8217;d say give ObjC/Cocoa a shot. Now is as good a time as any to learn Mac/iPhone dev, market share is going up and the AppStore is kicking. Plus maybe you&#8217;ll learn a little something from a development community that values user experience at a very high level which, let&#8217;s face it, is not a priority in the Microsoft ecosystem. Trying new things and delving into new communities can only be good for your career in a down economy as well, so what are you waiting for?

&nbsp;

<div>
  Technorati tags: <a rel="tag" href="http://technorati.com/tags/mac">Mac</a>,<a rel="tag" href="http://technorati.com/tags/Objective-C">Objective-C</a>,<a rel="tag" href="http://technorati.com/tags/Cocoa">Cocoa</a>
</div>