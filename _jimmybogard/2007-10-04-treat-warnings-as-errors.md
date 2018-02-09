---
wordpress_id: 72
title: Treat warnings as errors
date: 2007-10-04T21:25:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/10/04/treat-warnings-as-errors.aspx
dsq_thread_id:
  - "306939326"
categories:
  - Misc
redirect_from: "/blogs/jimmy_bogard/archive/2007/10/04/treat-warnings-as-errors.aspx/"
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/10/treat-warnings-as-errors.html)._

Compiler warnings can provide some additional insight and quality controls on your codebase.&nbsp; They can tell you about obsolete code, unused variables, and many other items that you wouldn&#8217;t necessarily see on visual inspection.&nbsp; Warnings can also surface bugs, such as possible null reference exceptions, or expressions that always evaluate to &#8220;true&#8221;.

However, compiler warnings can be easily ignored.&nbsp; Ignore them for long enough, and important warnings can be lost in a sea of &#8220;acceptable&#8221; warnings.&nbsp; For higher quality code, you can treat warnings as errors.&nbsp; When a compile time warning is found, the compilation fails.&nbsp; Warnings also have varying severity, from &#8220;0&#8221; (basically off) to &#8220;4&#8221;, which includes all warnings.&nbsp; Set your warning levels to &#8220;4&#8221; to get the most mileage.

To turn on &#8220;Treat warnings as errors&#8221;, go to the property pages for your a project and click the &#8220;Build&#8221; section.&nbsp; In the section &#8220;Treat warnings as errors&#8221;, set it to &#8220;All&#8221; and set the warning level to &#8220;4&#8221;:

 ![](http://s3.amazonaws.com/grabbagoftimg/TreatWarningsAsErrors_ProjectPage.PNG)

If you use the [aspnet_compiler](http://msdn2.microsoft.com/en-us/library/ms229863(vs.80).aspx) tool or [Web Deployment Projects](http://msdn2.microsoft.com/en-us/library/aa479568.aspx), you can also turn on &#8220;Treat warnings as errors&#8221; for these pre-compilation steps in the web.config file (.NET 2.0 in this example):

<div style="font-size: 10pt;background: white;color: black;font-family: consolas">
  <p style="margin: 0px">
    <span style="color: blue">&nbsp; <</span><span style="color: #a31515">system.codedom</span><span style="color: blue">></span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">&nbsp; &nbsp; <</span><span style="color: #a31515">compilers</span><span style="color: blue">></span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">&nbsp; &nbsp; &nbsp; <</span><span style="color: #a31515">compiler</span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">&nbsp; &nbsp; &nbsp; &nbsp; </span><span style="color: red">language</span><span style="color: blue">=</span>&#8220;<span style="color: blue">c#;cs;csharp</span>&#8220;
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">&nbsp; &nbsp; &nbsp; &nbsp; </span><span style="color: red">extension</span><span style="color: blue">=</span>&#8220;<span style="color: blue">.cs</span>&#8220;
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">&nbsp; &nbsp; &nbsp; &nbsp; </span><span style="color: red">type</span><span style="color: blue">=</span>&#8220;<span style="color: blue">Microsoft.CSharp.CSharpCodeProvider, System, </span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Version=2.0.3600.0, Culture=neutral, </span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; PublicKeyToken=b77a5c561934e089</span>&#8220;
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">&nbsp; &nbsp; &nbsp; &nbsp; </span><span style="color: red">compilerOptions</span><span style="color: blue">=</span>&#8220;<span style="color: blue">/warnaserror</span>&#8220;
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">&nbsp; &nbsp; &nbsp; &nbsp; </span><span style="color: red">warningLevel</span><span style="color: blue">=</span>&#8220;<span style="color: blue">4</span>&#8220;
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">&nbsp; &nbsp; &nbsp; /></span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">&nbsp; &nbsp; </</span><span style="color: #a31515">compilers</span><span style="color: blue">></span>
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">&nbsp; </</span><span style="color: #a31515">system.codedom</span><span style="color: blue">></span>
  </p>
</div>

The [compilers section](http://msdn2.microsoft.com/en-us/library/k6bttwes.aspx) allows me to fine tune&nbsp;my ASP.NET compilation options, including warning levels and treating warnings as errors.

By treating warnings as errors, I can start dialing up the quality of our code a little at a time, producing a more maintainable codebase.