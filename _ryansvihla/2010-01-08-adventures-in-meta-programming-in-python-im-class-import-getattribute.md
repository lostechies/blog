---
id: 35
title: 'Adventures in Meta programming in Python: im_class, __import__, __getattribute__'
date: 2010-01-08T05:03:00+00:00
author: Ryan Svihla
layout: post
guid: /blogs/rssvihla/archive/2010/01/08/adventures-in-meta-programming-in-python-im-class-import-getattribute.aspx
dsq_thread_id:
  - "425574808"
categories:
  - Python
---
With my recent work in Python win32 programming I&rsquo;ve had a real need for AAA style mocking framework. Unable to find anything that I&rsquo;ve been completely happy with I started my own simple mocking framework and got to learn some Python style meta programming&nbsp; in the process. I&rsquo;ve found out a lot about the depth of the Python 2.x object model over the last 2 weeks and here are some of the nicer things I&rsquo;ve found (updated as per Chris Taveres below):

### function\_class = MyClass.foo.im\_class 

This is useful if you pass in an instance method&nbsp; somewhere and you want to be able to access its attached class.&nbsp; Decorators on instance methods normally use this, but I needed it to get a nicer syntax on my asserts, I wanted this:

&nbsp;

<div class="wlWriterEditableSmartContent" style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px">
  <div style="font-family:consolas,lucida console,courier,monospace">
    assertCalled(FakeRepo<span style="color:#303030">.</span>get)
  </div>
</div>

&nbsp;

So now when I want to track what class is passed in I just have to start with the following:

<div class="wlWriterEditableSmartContent" style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px">
  <div style="font-family:consolas,lucida console,courier,monospace">
    <span style="color:#008000"><strong>def</strong></span>&nbsp;<span style="color:#0060B0"><strong>assertCalled</strong></span>(method):<br /> &nbsp;&nbsp;&nbsp;&nbsp;classdef&nbsp;<span style="color:#303030">=</span>&nbsp;method<span style="color:#303030">.</span>im_class&nbsp;<span style="color:#808080">#I&nbsp;get&nbsp;the&nbsp;method&nbsp;and&nbsp;the&nbsp;class&nbsp;in&nbsp;one&nbsp;parameter!</span>
  </div>
</div>

### module = \_\_import\_\_(&ldquo;foomodule&rdquo;)

this creates a module import by string. This becomes super powerful say if you wanted to replace functionality on a module, but didn&rsquo;t know its name before hand.&nbsp; In my case I wanted to be able to patch in a replacement method for mocking and then put it back when I was done, and I didn&rsquo;t want to have to keep passing in the module name on resets. The only downside to it so far is it behaves a little quirky with packages and you have walk your module hierarchy to get it to do what you want

example of patching originals back into the module:

<div class="wlWriterEditableSmartContent" style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px">
  <div style="font-family:consolas,lucida console,courier,monospace">
    <span style="color:#008000"><strong>for</strong></span>&nbsp;mod,&nbsp;original&nbsp;<span style="color:#000000"><strong>in</strong></span>&nbsp;_originals<span style="color:#303030">.</span>items():&nbsp;&nbsp;<span style="color:#808080">#key&nbsp;is&nbsp;a&nbsp;combination&nbsp;of&nbsp;module&nbsp;name&nbsp;and&nbsp;methodname,&nbsp;value&nbsp;is&nbsp;the&nbsp;original&nbsp;function&nbsp;itself</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;modulename&nbsp;<span style="color:#303030">=</span>&nbsp;mod[<span style="color:#6000E0"><strong></strong></span>]<br /> &nbsp;&nbsp;&nbsp;&nbsp;methodname&nbsp;<span style="color:#303030">=</span>&nbsp;mod[<span style="color:#6000E0"><strong>1</strong></span>]<br /> &nbsp;&nbsp;&nbsp;&nbsp;module&nbsp;<span style="color:#303030">=</span>&nbsp;<span style="color:#007020">__import__</span>(modulename)&nbsp;&nbsp;<span style="color:#808080">#this&nbsp;is&nbsp;the&nbsp;magic.&nbsp;if&nbsp;module&nbsp;name&nbsp;has&nbsp;no&nbsp;package&nbsp;aka&nbsp;:&nbsp;&ldquo;barmod&rdquo;&nbsp;this&nbsp;will&nbsp;work.&nbsp;if&nbsp;its&nbsp;&ldquo;foopackage.barmod&rdquo;&nbsp;it&rsquo;ll&nbsp;import&nbsp;the&nbsp;&ldquo;foopackage&rdquo;&nbsp;</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#008000"><strong>for</strong></span>&nbsp;i&nbsp;<span style="color:#000000"><strong>in</strong></span>&nbsp;modulename<span style="color:#303030">.</span>split(&#8220;.&#8221;)[<span style="color:#6000E0"><strong>1</strong></span>:]:&nbsp;<span style="color:#808080">#works&nbsp;down&nbsp;the&nbsp;chain&nbsp;</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;module&nbsp;<span style="color:#303030">=</span>&nbsp;<span style="color:#007020">getattr</span>(module,&nbsp;i)&nbsp;<span style="color:#808080">#resets&nbsp;the&nbsp;module&nbsp;variable&nbsp;with&nbsp;the&nbsp;lower&nbsp;hierarchy&nbsp;module&nbsp;</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#007020">setattr</span>(module,&nbsp;methodname,&nbsp;original)&nbsp;<span style="color:#808080">#actually&nbsp;pass&nbsp;the&nbsp;original&nbsp;function&nbsp;object&nbsp;back&nbsp;onto&nbsp;the&nbsp;module.</span>
  </div>
</div>

### 

&nbsp;

### MyClass.\_\_getattribute\_\_ = interception

\_\_getattribute\_\_ is called when any attribute is accessed on a class including \_\_getattribute\_\_ itself which is a bit silly.&nbsp; This was the primary engine of my mocking framework as it allowed me to record all calls to the methods on a mocked class.&nbsp; Just remember when you use this to have it not call itself or you&rsquo;ll be in endless recursion!

example:

<div class="wlWriterEditableSmartContent" style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px">
  <div style="font-family:consolas,lucida console,courier,monospace">
    <span style="color:#008000"><strong>class</strong></span>&nbsp;<span style="color:#B00060"><strong>MyClass</strong></span>(<span style="color:#007020">object</span>):</p> 
    
    <p>
      &nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#008000"><strong>def</strong></span>&nbsp;<span style="color:#0060B0"><strong>stuff</strong></span>(<span style="color:#007020">self</span>):<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#008000"><strong>pass</strong></span>
    </p>
    
    <p>
      <span style="color:#008000"><strong>def</strong></span>&nbsp;<span style="color:#0060B0"><strong>interceptor</strong></span>(<span style="color:#007020">self</span>,&nbsp;name):<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#008000"><strong>if</strong></span>&nbsp;name&nbsp;<span style="color:#303030">==</span>&nbsp;&#8220;__getattribute__&#8221;:&nbsp;<span style="color:#808080">#guard&nbsp;condition&nbsp;against&nbsp;calling&nbsp;itself</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#008000"><strong>return</strong></span>&nbsp;<span style="color:#007020">object</span><span style="color:#303030">.</span>__getattribute__(<span style="color:#007020">self</span>,&nbsp;name)<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#808080">#whatever&nbsp;interception&nbsp;logic&nbsp;you&nbsp;need&nbsp;here</span>
    </p>
    
    <p>
      MyClass<span style="color:#303030">.</span>__getattribute__&nbsp;<span style="color:#303030">=</span>&nbsp;interceptor<br /> m&nbsp;<span style="color:#303030">=</span>&nbsp;MyClass()<br /> m<span style="color:#303030">.</span>stuff()&nbsp;<span style="color:#808080">#interception&nbsp;logic&nbsp;will&nbsp;be&nbsp;called&nbsp;here</span> </div> </div> 
      
      <p>
        &nbsp;
      </p>
      
      <p>
        I&rsquo;m just starting to dip into the Python object model now and I&rsquo;ll try and share what I find over the next few weeks.
      </p>