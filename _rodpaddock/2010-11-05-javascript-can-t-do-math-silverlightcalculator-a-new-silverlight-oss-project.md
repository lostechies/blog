---
id: 4479
title: 'JavaScript Can&#8217;t Do Math &#8211; SilverlightCalculator A New Silverlight OSS Project'
date: 2010-11-05T07:08:00+00:00
author: Rod Paddock
layout: post
guid: /blogs/rodpaddock/archive/2010/11/05/javascript-can-t-do-math-silverlightcalculator-a-new-silverlight-oss-project.aspx
dsq_thread_id:
  - "263003371"
categories:
  - JavaScript
  - JQuery
  - OSS
  - Silverlight
---
It&#8217;s amazing what a lack of sleep can do for the OSS World. Over the last year I have encountered numerous places where I wanted to do simple financial equations in my JavaScript applications. You know really complex stuff like adding and subtracting dollar amounts. Well if you have spent any time doing JavaScript work you soon realize that this is just a dream. Hence the creation of the SilverLight Calculator. This is a real simple application and is described by the contents of the README below. 

The GitHub Repo for this project is: <https://github.com/rodpaddock/SilverlightCalculator>

You can also try this application at <http://calculator.dashpoint.com/>

This is my first OSS project and I would appreciate any feedback or changes you may offer.

&nbsp;

**README FILE**

Welcome to the Silverlight Calculator.

This application was created for the simple reason: JAVASCRIPT CANNOT DO MATH

What this really means is that the basic numeric type in JavaScript is floating point. 

Floating Point math is very difficult if not impossible to use when doing basic financial calculations. 

Like Adding, Subtracting, Multiplying and Dividing dollar amounts.

This application solves this by creating a basic calculator that provides 4 basic calculations:

Add(number1, number2)  
Subtract(number1, number2)  
Multiply(number1, number2)  
Divide(number1, number2)

This application is written in C# and deployed via a Silverlight Plugin.

There is a fully functional example in the WebSample Folder.

You can also access a demo of this application at http://calculator.dashpoint.com

Using this application is very simple. You just add an OBJECT tag in your web page pointing at the SilverlightCalculator.xap file.

Then using Jquery (or whatever JavaScript library you use) grab a handle to the plug in and call the operator you need for math calculations.

<object id=&#8221;calculator&#8221; data=&#8221;data:application/x-silverlight-2,&#8221; type=&#8221;application/x-silverlight-2&#8243; width=&#8221;0%&#8221; height=&#8221;0%&#8221;>  
&nbsp;&nbsp;&nbsp; <param name=&#8221;source&#8221; value=&#8221;Silverlight/SilverlightCalculator.xap&#8221;/>  
&nbsp;&nbsp;&nbsp; <param name=&#8221;background&#8221; value=&#8221;white&#8221; />  
&nbsp;&nbsp;&nbsp; <param name=&#8221;minRuntimeVersion&#8221; value=&#8221;3.0.40818.0&#8243; />  
&nbsp;&nbsp;&nbsp; <param name=&#8221;autoUpgrade&#8221; value=&#8221;true&#8221; />  
&nbsp;&nbsp;&nbsp; <a href=&#8221;http://go.microsoft.com/fwlink/?LinkID=149156&v=3.0.40818.0&#8243; style=&#8221;text-decoration:none&#8221;>  
&nbsp;&nbsp;&nbsp; <img src=&#8221;http://go.microsoft.com/fwlink/?LinkId=108181&#8243; alt=&#8221;Get Microsoft Silverlight&#8221; style=&#8221;border-style:none&#8221;/>  
</object>

function getCalculatorHandle() {  
&nbsp;&nbsp;&nbsp; // code to grab a handle to the silverlight calculator  
&nbsp;&nbsp;&nbsp; var returnValue = document.getElementById(&#8220;calculator&#8221;).content.calculator;  
&nbsp;&nbsp;&nbsp; return returnValue;  
}

// sample call to the Add Function  
function addNumbers(){  
&nbsp; var factor_1 = $(&#8220;#addNumber1&#8221;).val();  
&nbsp; var factor_2 = $(&#8220;#addNumber2&#8221;).val();  
&nbsp; var calc = getCalculatorHandle().Add(factor\_1,factor\_2);  
&nbsp; alert(calc);  
}

&nbsp;