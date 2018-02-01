---
id: 7
title: 'Ugh&#8230;&#8230;&#8217;Fun with JavaScript &#8211; Part 0&#8242;'
date: 2007-03-31T05:32:00+00:00
author: Joshua Lockwood
layout: post
guid: /blogs/joshua_lockwood/archive/2007/03/31/ugh-fun-with-javascript-part-0.aspx
categories:
  - JavaScript
  - jscript
  - scripting
---
I was working on using javascript as a system scripting tool using wscript.&nbsp; Here&#8217;s a quick summary of highlights:


  



  


  1. Worked on implementing an include mechanism to include other .js files from inside the js script (no real support for it).&nbsp; The implemention was a little on the ugly side, but I like it overall.&nbsp; Currently includes are defined in include.js, but am considering moving this to an XML config file.

  


  2. Played with WScript.Network.&nbsp; Just messed with the capabilities in general&nbsp;and went ahead and threw the current userid into the scripts.

  


  3. Investigated some of the OO features of javascript and started a couple of &#8216;class libraries&#8217;.&nbsp; These are just reusable .js files that I treat as libraries and call in the includes.&nbsp; Messed with inheritance&#8230;which is a little strange in javascript.

  


  4. Used the hell out of anonymous methods.

  


  5. Started mock libraries for web-based objects (such as window, document, etc).

  


  6. Began work on a simple test framework &#8211; Was going to use jsUnit, but saw that it required the tests to run in the browser&#8230;I didn&#8217;t want that as my scripts are made to run in the command shell&#8230;initially&nbsp;provided supported Assert.Equals because that&#8217;s all I needed

  


  7. Worked on Hashtable class (instead of using Array) &#8211; Array didn&#8217;t do it for me besause it manages the count in a strange way.&nbsp; For instance, you can add new items using the key (like session variables) like so.&nbsp; myArray[&#8220;keyVal&#8221;] = valueString;&nbsp; At that point you can accces valueString usinf the keyVal or you can say something like for(key in myArray(){ doSomething(myArray[key]);}.&nbsp; You&#8217;ve entered data and can take it back out&#8230;wich is great&#8230;except for the fact that myArray.length still evaluated to 0;&nbsp; I want to look at this more.&nbsp; Gotta firgure out how to do the key iterator.

  


  8. Skimmed the surface with BDD support &#8211; When writing a test with my half-assed test framework you define an object as type test then override the Run() method on the test and then add it to the TestSuite object.&nbsp; Once all tests are added the user calls. testSuite.Run() and all the suites tests fire off.&nbsp; Assertion object has been replaced with Context and the asserts read something like this now: Context(&#8220;Hashtable is instantiated&#8221;).ShouldBeEqual(expected, actual).&nbsp; As you see, I&#8217;ve only made a first pass but I want to continue to tweak it based on what I learn from rspec.&nbsp; I was pleased to find that I could use a javascript class as a method (Context is a class but you can call a class as a method if you don&#8217;t use the new operator and you aren&#8217;t trying to assign the return value to anything.

  


  9. Took brief look at log4js &#8211; It&#8217;s pretty lightweight and I may try to port core concepts and a console appender, rolling file appender&nbsp;and possibly a system event appender.&nbsp; log4js itself is geared toward web use only (like jsUnit) so wasn&#8217;t useful.

  


 10. Planned on writing an XML config file (mentioned above) to facilitate include paths for .js files.&nbsp; Right now include expected the filed to be either in the same directory or mapped through a PATH value.

  


 11. Added a puts() method to common.js, but would like to find a way to easily swap out the tarket resource (like puts to files instead of the console.


  


So, that it in a nutshell.&nbsp; I think that we might be able to use the command shell approach to run BDD-type tests agains individual .js files with needing to invoke the browser.&nbsp; 


  


Good morning to you all