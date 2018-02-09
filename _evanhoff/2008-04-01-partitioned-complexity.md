---
wordpress_id: 40
title: Partitioned Complexity
date: 2008-04-01T23:38:34+00:00
author: Evan Hoff
layout: post
wordpress_guid: /blogs/evan_hoff/archive/2008/04/01/partitioned-complexity.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/evan_hoff/archive/2008/04/01/partitioned-complexity.aspx/"
---
Roger Sessions has some good material I wanted to take a moment to highlight.&nbsp; This is part of his work around&nbsp; a new Enterprise Architecture framework, Simple Iterative Partitions (SIP).

**Correlating Complexity to State**

First, let&#8217;s look at how complexity grows based on the number of significant states in a given program.&nbsp; I&#8217;m not a math geek, so we are going to go with an oversimplified example.&nbsp; If you are a math geek, feel free drop a note in the comments for whatever reason.

In his example, we first look at a coin-tossing application.&nbsp; In short, the requirements state that the program should detect a coin-toss and inform the user if the coin landed heads or tails up.&nbsp; The user will be dropping their penny into a specially designed sensor which our program will read data from.

Here&#8217;s our pseudo code:

> PennyState state = sensor.GetState();
> 
> if (state == PennyState.HeadsUp)  
> {  
> &nbsp;&nbsp; MessageBox.Show(&#8220;Heads Up&#8221;);  
> }  
> else if (state == PennyState.TailsUp)  
> {  
> &nbsp;&nbsp; MessageBox.Show(&#8220;Tails Up&#8221;);  
> }

Now that&#8217;s a pretty trivial program, but if we look closely, we have two states the program can go through, heads or tails up.&nbsp; In order to test our application, we would need to drop the penny in the sensor in both positions and check the output.

Let&#8217;s increase the scope of our trivial application to include that of checking a dime at the same time.&nbsp; Now the user will drop a dime in the dime reader and a penny in the penny reader.&nbsp; Our application will tell the user the result.

> CoinState pennyState = pennySensor.GetState();  
> CoinState dimeState = dimeSensor.GetState();
> 
> if (pennyState == CoinState.HeadsUp && dimeState == CoinState.HeadsUp)  
> {  
> &nbsp;&nbsp; MessageBox.Show(&#8220;both coins are heads up&#8221;);  
> }  
> else if (pennyState == CoinState.TailsUp && dimeState == CoinState.HeadsUp)  
> {  
> &nbsp;&nbsp; MessageBox.Show(&#8220;the penny is tails up and the dime is heads up&#8221;);  
> }  
> else if (pennyState == CoinState.HeadsUp && dimeState == CoinState.TailsUp)  
> {  
> &nbsp; MessageBox.Show(&#8220;the penny is heads up and the dime is tails up&#8221;);  
> }  
> else if (pennyState == CoinState.TailsUp && dimeState = CoinState.TailsUp)  
> {  
> &nbsp;&nbsp; MessageBox.Show(&#8220;both coins are tails up&#8221;);  
> }

You can see now that we&#8217;ve increased our number of basic states.&nbsp; We went from 2 states to 4 by adding the second variable (the dime&#8217;s state).

This isn&#8217;t really earth shattering, but **we can begin to see the correlation between the number of states in the program and the amount of complexity**.&nbsp; In fact, you can generally calculate the number of states using basic math.

Where x is the number of variables, s is the number of states, and t is the number of total states of the program:

> t = s^x

As you can see, we are dealing with an exponential problem.

Here are the numbers when dealing with an application made of variables who can have 6 states:

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="323" src="http://lostechies.com/blogs/evan_hoff/WindowsLiveWriter/PartitionedComplexity_DC2E/states_thumb1.png" width="291" border="0" />](http://lostechies.com/blogs/evan_hoff/WindowsLiveWriter/PartitionedComplexity_DC2E/states3.png) 

> 
That&#8217;s quite a lot of states for a program with only 12 variables.

**Managing State and Complexity Through Partitioning**

Looking at the chart above, we can generally know that any non-trivial application will have a huge number of possible states.&nbsp; What can we do about it?

Well, the trick is that while a single program with&nbsp;4 variables of 6 states will have a total number of just over&nbsp;a thousand&nbsp;states (1296), it doesn&#8217;t have to be that way.&nbsp; Here is where partitioning comes to our rescue.&nbsp; In fact, if we only create one partition and split the program into two programs, we significantly reduce the number of possible states:

> Single Program of 4: 1296 states
> 
> Single Program of 2: 36 states  
> Two Programs of 2 states: 72 states

**The reduction is pretty staggering.&nbsp; We went from 1296 possible states down to only 72!&nbsp; That&#8217;s a reduction of over 94%!**

Now if the correlation between the number of states and the amount of complexity holds true, you can just imagine the resulting change to the application.

So what can we take away from this, without trying to calculate the number of states in our applications?

Here&#8217;s the generalized principle:

> **Partitioning is a technique for significantly reducing complexity.**

And I&#8217;ll create a corollary:

> **Partitioning an application into Modules&nbsp;is a technique for significantly reducing its complexity.**

Now, we know that not all means of partitioning are equal, but I&#8217;ll leave that for another post.

If you want a bit more on SIP or the math behind partitioning (as described by Roger Sessions), I would encourage you to take a look at <a href="http://www.objectwatch.com/white_papers.htm#SIP" target="_blank">his website</a>.