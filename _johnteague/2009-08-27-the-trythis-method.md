---
wordpress_id: 36
title: The TryThis method
date: 2009-08-27T04:19:27+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2009/08/27/the-trythis-method.aspx
dsq_thread_id:
  - "262055710"
categories:
  - 'C#'
redirect_from: "/blogs/johnteague/archive/2009/08/27/the-trythis-method.aspx/"
---
The more I learn and use dynamic languages like JavaScript and Ruby, the more I feel the constraints placed on me by the C# compiler.&#160; Today I needed to wrap a bunch of calls to a web service facade in some try catch statements.&#160; I really hated the idea of littering my code with these because a lot them make the code that much harder to read.&#160; What I really wanted was a method that would execute the statement in a try/catch and do the necessary exception handling for me. In this situation, the method calls were very different (number of parameters, return values), but the error handling was exactly the same.

What I really wanted was something like the block statement in Ruby, where I just pass in arbitrary code to a method that would then execute it.&#160; It was a little trickier in C# because of the variations in the method signture.&#160; A method that had a Func parameter wouldn’t work because I had varying number of parameters.&#160; Also the changing return value added a nice twist.&#160; In the end, it came out rather nice.

With this little method I can now pass in any method and 

<div style="padding-bottom: 5px;padding-left: 5px;width: 715px;padding-right: 5px;float: none;margin-left: auto;margin-right: auto;padding-top: 5px" class="wlWriterEditableSmartContent">
  <div style="border: #000080 1px solid;font-family: 'Courier New', Courier, Monospace;font-size: 10pt">
    <div style="background-color: #000000;overflow: scroll;padding: 2px 5px">
      <p>
        <span style="background:#000000;color:#ffffff"> </span><span style="color:#ff8000">private</span><span style="color:#ffffff"> </span><span style="color:#ff8000">bool</span><span style="color:#ffffff"> TryThis(</span><span style="color:#2b91af">Action</span><span style="color:#ffffff"> block)<br />         {<br />             </span><span style="color:#ff8000">try<br /> </span><span style="color:#ffffff">            {<br />                 block();<br />                 </span><span style="color:#ff8000">return</span><span style="color:#ffffff"> </span><span style="color:#ff8000">true</span><span style="color:#ffffff">;<br />             }<br />             </span><span style="color:#ff8000">catch</span><span style="color:#ffffff">(</span><span style="color:#ffff00">Exception</span><span style="color:#ffffff">)<br />             {<br />                 </span><span style="color:#00ff00">//do something with exception here<br /> </span><span style="color:#ffffff">                </span><span style="color:#ff8000">return</span><span style="color:#ffffff"> </span><span style="color:#ff8000">false</span><span style="color:#ffffff">;<br />             }<br />         </span>
      </p>
    </div>
  </div>
</div>

Here are a few tests to show what it looks like.</p> 

<div style="padding-bottom: 5px;padding-left: 5px;width: 715px;padding-right: 5px;float: none;margin-left: auto;margin-right: auto;padding-top: 5px" class="wlWriterEditableSmartContent">
  <div style="border: #000080 1px solid;font-family: 'Courier New', Courier, Monospace;font-size: 10pt">
    <div style="background-color: #000000;overflow: scroll;padding: 2px 5px">
      <p>
        <span style="background:#000000;color:#ff8000">public</span><span style="color:#ffffff"> </span><span style="color:#ff8000">interface</span><span style="color:#ffffff"> </span><span style="color:#2b91af">Foo<br /> </span><span style="color:#ffffff">    {<br />         </span><span style="color:#2b91af">DateTime</span><span style="color:#ffffff"> Bar(</span><span style="color:#ff8000">string</span><span style="color:#ffffff"> a, </span><span style="color:#ff8000">string</span><span style="color:#ffffff"> b);<br />         </span><span style="color:#ff8000">string</span><span style="color:#ffffff"> Bar2(</span><span style="color:#ff8000">int</span><span style="color:#ffffff"> a);<br />         </span><span style="color:#ff8000">void</span><span style="color:#ffffff"> Bar3(</span><span style="color:#ff8000">int</span><span style="color:#ffffff"> a, </span><span style="color:#ff8000">int</span><span style="color:#ffffff"> b);<br />     }<br />     [</span><span style="color:#ffff00">TestFixture</span><span style="color:#ffffff">]<br />     </span><span style="color:#ff8000">public</span><span style="color:#ffffff"> </span><span style="color:#ff8000">class</span><span style="color:#ffffff"> </span><span style="color:#ffff00">trythis_specs<br /> </span><span style="color:#ffffff">    {<br />         </span><span style="color:#ff8000">private</span><span style="color:#ffffff"> </span><span style="color:#2b91af">Foo</span><span style="color:#ffffff"> mock;</p> 
        
        <p>
                  [</span><span style="color:#ffff00">SetUp</span><span style="color:#ffffff">]<br />         </span><span style="color:#ff8000">public</span><span style="color:#ffffff"> </span><span style="color:#ff8000">void</span><span style="color:#ffffff"> setup()<br />         {<br />             mock = </span><span style="color:#ffff00">MockRepository</span><span style="color:#ffffff">.GenerateMock<</span><span style="color:#2b91af">Foo</span><span style="color:#ffffff">>();<br />         }<br />        [</span><span style="color:#ffff00">Test</span><span style="color:#ffffff">]<br />        </span><span style="color:#ff8000">public</span><span style="color:#ffffff"> </span><span style="color:#ff8000">void</span><span style="color:#ffffff"> should_return_true_when_there_is_no_exception()<br />        {<br />            mock.Stub(m => m.Bar(</span><span style="color:#00ff00">&#8220;a&#8221;</span><span style="color:#ffffff">, </span><span style="color:#00ff00">&#8220;b&#8221;</span><span style="color:#ffffff">)).Return(</span><span style="color:#2b91af">DateTime</span><span style="color:#ffffff">.Now);<br />            </span><span style="color:#2b91af">DateTime</span><span style="color:#ffffff"> output;<br />            </span><span style="color:#ff8000">bool</span><span style="color:#ffffff"> result = TryThis(() => output = mock.Bar(</span><span style="color:#00ff00">&#8220;a&#8221;</span><span style="color:#ffffff">, </span><span style="color:#00ff00">&#8220;b&#8221;</span><span style="color:#ffffff">));<br />            </span><span style="color:#ffff00">Assert</span><span style="color:#ffffff">.That(result);</p> 
          
          <p>
                   }<br />        [</span><span style="color:#ffff00">Test</span><span style="color:#ffffff">]<br />         </span><span style="color:#ff8000">public</span><span style="color:#ffffff"> </span><span style="color:#ff8000">void</span><span style="color:#ffffff"> can_get_the_value_from_executing_method()<br />        {<br />            </span><span style="color:#ff8000">var</span><span style="color:#ffffff"> time = </span><span style="color:#2b91af">DateTime</span><span style="color:#ffffff">.Now;<br />            mock.Stub(m => m.Bar(</span><span style="color:#00ff00">&#8220;a&#8221;</span><span style="color:#ffffff">, </span><span style="color:#00ff00">&#8220;b&#8221;</span><span style="color:#ffffff">)).Return(time);<br />            </span><span style="color:#2b91af">DateTime</span><span style="color:#ffffff"> output = </span><span style="color:#2b91af">DateTime</span><span style="color:#ffffff">.MinValue;<br />            </span><span style="color:#ff8000">bool</span><span style="color:#ffffff"> result = TryThis(() => output = mock.Bar(</span><span style="color:#00ff00">&#8220;a&#8221;</span><span style="color:#ffffff">, </span><span style="color:#00ff00">&#8220;b&#8221;</span><span style="color:#ffffff">));<br />            </span><span style="color:#ffff00">Assert</span><span style="color:#ffffff">.That(output, </span><span style="color:#ffff00">Is</span><span style="color:#ffffff">.EqualTo(time));<br />        }<br />        [</span><span style="color:#ffff00">Test</span><span style="color:#ffffff">]<br />         </span><span style="color:#ff8000">public</span><span style="color:#ffffff"> </span><span style="color:#ff8000">void</span><span style="color:#ffffff"> return_false_on_exception()<br />         {<br />            mock.Stub(m => m.Bar3(1,2)).Throw(</span><span style="color:#ff8000">new</span><span style="color:#ffffff"> </span><span style="color:#ffff00">Exception</span><span style="color:#ffffff">());<br />            </span><span style="color:#ff8000">var</span><span style="color:#ffffff"> result = TryThis(() => mock.Bar3(1,2));<br />            </span><span style="color:#ffff00">Assert</span><span style="color:#ffffff">.That(result, </span><span style="color:#ffff00">Is</span><span style="color:#ffffff">.False);<br />         </span>
          </p></div> </div> </div> 
          
          <p>
            That’s not quite as clean a block parameter in Ruby, but I can live with it for now.
          </p>