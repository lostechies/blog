---
id: 30
title: Playing With Haskell
date: 2009-09-02T03:53:00+00:00
author: Ryan Svihla
layout: post
guid: /blogs/rssvihla/archive/2009/09/01/playing-with-haskell.aspx
dsq_thread_id:
  - "1135229049"
categories:
  - Functional
  - GHC
  - Haskell
  - learning
---
My tech book club is starting to look at Haskell. I&#8217;m as big of a language addict as anyone so I wanted to dive in early and this is the overview of what I&#8217;ve found so far

### Statically Typed But Dynamically Inferred

for those of you familiar with Boo this is a familiar concept to you. Once a type is made that type will not autoconvert. For Example:

let i = 6 &#8211;this is now going to be an integer 

let f = 1.2 &#8211;this is now a float 

i + f /&#8211;will throw exception 

### Cannot set variable twice

this is from what I understand something that all functional languages share some concept of. (Erlang views the second attempt to set a variable as a &#8220;match&#8221; request).

x = 10

x = 11

when running the source file results in: 

Multiple declarations of \`Main.x&#8217; 

Declared at: functions.hs:1:0
                   
functions.hs:2:0 

Failed, modules loaded: none. 

### My Least Favorite Thing In Python AKA Significant Whitespace

In the above code file in my previous example I had an error with an extra whitespace hiding about. I got used to this in Python by using soft tabs and being aware of phantom white space. Not happy about this. 

### No Loops!

The two primary ways I&#8217;ve found to replace loops are recursion and map. Map is a standard of functional languages and pretty easy to grasp. It&#8217;s just a way of saying &#8220;run a specified function on each item in the list&#8221;. A quick example of map is as follows:

doubleList ls = map doubleInt ls &#8212; function named &#8220;doublelist&#8221; with parameter of ls  
&nbsp;&nbsp;&nbsp; where doubleInt x = x*2&nbsp;&nbsp; &#8211;doubles x which represents each value in list

doubled = doubleList [1,2,3,4,5] &#8211;set global variable with function applied

### At A Glance

Haskell seems to have an easier to learn syntax than Erlang, while still being less ceremonial than other languages I&#8217;ve used. I kinda dig the no parenthesis syntax of functions, and of course I don&#8217;t miss foreach loops with map.
  
Finally, I&#8217;ll be anxious to find out what the multi-core story is vs Erlang.