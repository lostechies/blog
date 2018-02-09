---
wordpress_id: 37
title: 'Domain Specific Languages with Boo: AST Macros'
date: 2010-04-05T02:40:17+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2010/04/04/domain-specific-languages-with-boo-ast-macros.aspx
dsq_thread_id:
  - "425624416"
categories:
  - Boo
  - DSL
redirect_from: "/blogs/rssvihla/archive/2010/04/04/domain-specific-languages-with-boo-ast-macros.aspx/"
---
For those of you who don’t know what Boo is its a statically typed CLR language with Python like syntax that lets you extend it’s compiler, and the language itself easily by giving you access to the AST (Abstract Syntax Tree) and compiler’s context directly.&#160; This gives you very powerful tools for building your own language or Domain Specific Language or DSL from here on out. Some examples of DSL’s include rSpec and Fluent NHibernate. In fact the entire subject of what is a DSL and what types of DSL there are and how to create a proper DSL could be a book itself and a fascinating one at that.&#160; 

Which is why I’ve been reading Ayende’s book <a href="http://www.amazon.com/DSLs-Boo-Domain-Specific-Languages/dp/1933988606" target="_blank">DSLs in Boo: Domain Specific Languages in .NET</a>. To make sure I understood the concepts I’ve taken to building a toy BDD DSL called bSpec, it’s got a long way to go to be something useful and I may not care to take it that far, however I did get my brain wrapped around a really cool thing called AST Macros.&#160; 

AST macros give you FULL access to the compiler context and full AST of the code. I could describe this in more detail but a code sample goes light years to making this helpful.

Let’s say I want to have a “shouldFail” method that fails my spec immediately how would I do that? 

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <div style="font-family:consolas,lucida console,courier,monospace">
    <span style="color:#408080"><i>#macro&#160;declaration</i></span><br /> macro&#160;should_fail:<br /> &#160;&#160;&#160;&#160;<span style="color:#408080"><i>#create&#160;code&#160;using&#160;Quasi&#160;Quotation&#160;(&#160;&#8221;[|&#8221;&#160;and&#160;&#8221;|]&#8221;&#160;)</i></span><br /> &#160;&#160;&#160;&#160;codeblock&#160;<span style="color:#666666">=</span>&#160;[<span style="color:#666666">|</span>&#160;<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000"><b>raise</b></span>&#160;AssertionError(<span style="color:#BA2121">&#8220;failed&#160;by&#160;request&#8221;</span>) <br /> &#160;&#160;&#160;&#160;<span style="color:#666666">|</span>]&#160;<span style="color:#408080"><i>#exit&#160;macro&#160;statement</i></span><br /> &#160;&#160;&#160;&#160;<span style="color:#008000"><b>return</b></span>&#160;codeblock&#160;<span style="color:#408080"><i>#now&#160;replace&#160;&#8221;should_fail&#8221;&#160;with&#160;&#8221;raise&#160;AssertionError()&#160;&#8221;</i></span></p> 
    
    <p>
      <span style="color:#408080"><i>#client&#160;code</i></span>
    </p>
    
    <p>
      should_fail&#160;<span style="color:#408080"><i>#throws&#160;AssertionError</i></span> </div> </div> 
      
      <p>
        &#160;
      </p>
      
      <p>
        In reflector in C# the code looks like so:
      </p>
      
      <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
        <div style="font-family:consolas,lucida console,courier,monospace">
          <span style="color:#008000"><b>throw</b></span>&#160;<span style="color:#008000"><b>new</b></span>&#160;<span style="color:#0000FF">AssertionError</span>(<span style="color:#BA2121">&#8220;automatic&#160;failure&#160;as&#160;requested&#160;by&#160;&#8217;should&#160;fail&#160;call'&#8221;</span>);
        </div>
      </div>
      
      <p>
        So how did this happen?&#160; Well as part of Boo’s compiler pipeline it will run the macros first and replace the macro statement itself with what the macro returns. So far this doesn’t seem particularly interesting until you try and actually manipulate and work with the AST itself or get access to compiler objects.&#160;&#160; For a simple example lets look at what I did with the “describe” macro.
      </p>
      
      <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
        <div style="font-family:consolas,lucida console,courier,monospace">
          <span style="color:#408080"><i>#Describe&#160;Macro&#160;</i></span></p> 
          
          <p>
            macro&#160;describe:<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#408080"><i>#creates&#160;a&#160;reference&#160;to&#160;the&#160;first&#160;argument</i></span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;itemtodescribe&#160;<span style="color:#666666">=</span>&#160;<span style="color:#008000"><b>cast</b></span>(ReferenceExpression,&#160;describe.Arguments[<span style="color:#666666"></span>])<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;
          </p>
          
          <p>
            &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#408080"><i>#using&#160;a&#160;simple&#160;trick&#160;to&#160;prevent&#160;compiler&#160;errors.&#160;I&#160;just&#160;want&#160;access&#160;to&#160;the&#160;body&#160;of&#160;&#8221;block&#8221;&#160;so</i></span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#408080"><i>#&#160;you&#160;can&#160;safely&#160;ignore&#160;block&#160;in&#160;my&#160;example</i></span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#408080"><i>#note&#160;the&#160;key&#160;is&#160;using&#160;$itemtodescribe&#160;.&#160;this&#160;is&#160;how&#160;you&#160;pass&#160;in&#160;macro&#160;variables&#160;to&#160;the&#160;AST</i></span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;logdescribe&#160;<span style="color:#666666">=</span>&#160;[<span style="color:#666666">|</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;block:<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;_spechash[$itemtodescribe]&#160;<span style="color:#666666">=</span>&#160;<span style="color:#008000">null</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#666666">|</span>].Body<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000"><b>yield</b></span>&#160;logdescribe&#160;&#160;&#160;<span style="color:#408080"><i>#this&#160;will&#160;become&#160;the&#160;first&#160;statement</i></span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000"><b>yield</b></span>&#160;describe.Body&#160;<span style="color:#408080"><i>#the&#160;specified&#160;code&#160;block&#160;after&#160;&#8221;describe&#160;FooBart:&#160;&#8221;&#160;will&#160;now&#160;be&#160;placed</i></span>
          </p>
          
          <p>
            <span style="color:#408080"><i>#Unit&#160;Test&#160;Code&#160;with&#160;asserts&#160;removed</i></span>
          </p>
          
          <p>
            <span style="color:#008000"><b>class</b></span>&#160;<span style="color:#0000FF"><b>DescribeSpecs_When_Not_Nested</b></span>:
          </p>
          
          <p>
            &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000"><b>private</b></span>&#160;_spechash&#160;<span style="color:#008000"><b>as</b></span>&#160;Hash<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000"><b>private</b></span>&#160;_called&#160;<span style="color:#008000"><b>as</b></span>&#160;List[<span style="color:#008000"><b>of</b></span>&#160;string]
          </p>
          
          <p>
            &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000"><b>public</b></span>&#160;<span style="color:#008000"><b>def</b></span>&#160;<span style="color:#0000FF">constructor</span>():<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;_spechash&#160;<span style="color:#666666">=</span>&#160;{}<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000">self</span>._called&#160;<span style="color:#666666">=</span>&#160;List[<span style="color:#008000"><b>of</b></span>&#160;string]()<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;describe&#160;FooBart:<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;_called.Add(<span style="color:#BA2121">&#8220;called&#160;from&#160;FooBart&#160;spec&#8221;</span>)&#160;<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
          </p>
          
          <p>
            <span style="color:#408080"><i>#compiled&#160;output&#160;via&#160;reflector</i></span>
          </p>
          
          <p>
            <span style="color:#008000"><b>class</b></span>&#160;<span style="color:#0000FF"><b>DescribeSpecs_When_Not_Nested</b></span>:
          </p>
          
          <p>
            &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000"><b>private</b></span>&#160;_spechash&#160;<span style="color:#008000"><b>as</b></span>&#160;Hash<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000"><b>private</b></span>&#160;_called&#160;<span style="color:#008000"><b>as</b></span>&#160;List[<span style="color:#008000"><b>of</b></span>&#160;string]
          </p>
          
          <p>
            &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000"><b>public</b></span>&#160;<span style="color:#008000"><b>def</b></span>&#160;<span style="color:#0000FF">constructor</span>():<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;_spechash&#160;<span style="color:#666666">=</span>&#160;{}<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000">self</span>._spechash[<span style="color:#008000">typeof</span>(FooBart)]&#160;<span style="color:#666666">=</span>&#160;<span style="color:#008000">null</span>;&#160;&#160;<span style="color:#408080"><i>#this&#160;is&#160;the&#160;key&#160;change</i></span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000">self</span>._called&#160;<span style="color:#666666">=</span>&#160;List[<span style="color:#008000"><b>of</b></span>&#160;string]()
          </p>
        </div>
      </div>
      
      <p>
        So our macro has replaced code again, but this time references a field in a class that it had no prior knowledge of, yet it safely compiles. However, it would not have if there had been no field called “_spechash”. Amazingly this simple trick is only one of many ways you can extend the Boo language in a late binding fashion yet still get all the benefits of the CLR and compile time error checking.&#160; Follow my blog in the coming weeks for more of the Boo language.
      </p>