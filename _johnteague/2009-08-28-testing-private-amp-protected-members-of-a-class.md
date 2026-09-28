---
wordpress_id: 37
title: 'Testing Private &#038; Protected Members of a Class'
date: 2009-08-28T04:48:39+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2009/08/28/testing-private-amp-protected-members-of-a-class.aspx
dsq_thread_id:
  - "262055706"
categories:
  - 'C#'
  - Testing
redirect_from: "/blogs/johnteague/archive/2009/08/28/testing-private-amp-protected-members-of-a-class.aspx/"
---
In my last blog post, someone asked me you can write unit tests for a private or protected method.&#160; I gave part of the response in a comment, but I need to give a more detailed description.

## Focus on the public API of your system

First and foremost, I focus on testing the public API.&#160; You should be able to test all of the code branches in your private methods by adequately testing the public methods in your system.&#160; Using tools like NCover can help you analyze how well your tests are actually testing your system.&#160; I don’t try to get 100% coverage, but I typically have above 80% as a normal target.

## Testing Protected Members

There are times when you do need to test protected members of a class.&#160; If you are inheriting from a class that you do have the source code to (like say Controller) and you override a protected method, it is possible to test that.&#160; While it should be possible to test protected member through the public api, it is relatively simple to do it and doesn’t really break any encapsulation rules in your application.

It is actually very easy.&#160; All you need to do is create a test class that inherits from you and add a public method that call the protected method in question.&#160; Here is an example.

<div style="padding-bottom: 5px;padding-left: 5px;width: 715px;padding-right: 5px;float: none;margin-left: auto;margin-right: auto;padding-top: 5px" class="wlWriterEditableSmartContent">
  <div style="border: #000080 1px solid;font-family: 'Courier New', Courier, Monospace;font-size: 10pt">
    <div style="background-color: #000000;overflow: scroll;padding: 2px 5px">
      <p>
        <span style="background:#000000;color:#ff8000">public</span><span style="color:#ffffff"> </span><span style="color:#ff8000">class</span><span style="color:#ffffff"> </span><span style="color:#ffff00">ClassWithProtectedMember<br /> </span><span style="color:#ffffff">    {<br />         </span><span style="color:#ff8000">protected</span><span style="color:#ffffff"> </span><span style="color:#ff8000">int</span><span style="color:#ffffff"> UltimateQuestionAnswer() { </span><span style="color:#ff8000">return</span><span style="color:#ffffff"> 42; }<br />     }</p> 
        
        <p>
              </span><span style="color:#ff8000">public</span><span style="color:#ffffff"> </span><span style="color:#ff8000">class</span><span style="color:#ffffff"> </span><span style="color:#ffff00">ProtectedMemberAccessor</span><span style="color:#ffffff"> : </span><span style="color:#ffff00">ClassWithProtectedMember<br /> </span><span style="color:#ffffff">    {<br />         </span><span style="color:#ff8000">public</span><span style="color:#ffffff"> </span><span style="color:#ff8000">int</span><span style="color:#ffffff"> ExecuteUltimateQuestionAnswer(){<br />             </span><span style="color:#ff8000">return</span><span style="color:#ffffff"> </span><span style="color:#ff8000">base</span><span style="color:#ffffff">.UltimateQuestionAnswer();}<br />     }<br />     [</span><span style="color:#ffff00">TestFixture</span><span style="color:#ffffff">]<br />     </span><span style="color:#ff8000">public</span><span style="color:#ffffff"> </span><span style="color:#ff8000">class</span><span style="color:#ffffff"> </span><span style="color:#ffff00">ProtectedMemberSpecs</span><span style="color:#ffffff"> {</p> 
          
          <p>
                    [</span><span style="color:#ffff00">Test</span><span style="color:#ffffff">]<br />         </span><span style="color:#ff8000">public</span><span style="color:#ffffff"> </span><span style="color:#ff8000">void</span><span style="color:#ffffff"> should_give_us_the_answer_to_life_universe_and_everything()<br />         {<br />             </span><span style="color:#ff8000">var</span><span style="color:#ffffff"> wrapper = </span><span style="color:#ff8000">new</span><span style="color:#ffffff"> </span><span style="color:#ffff00">ProtectedMemberAccessor</span><span style="color:#ffffff">();<br />             </span><span style="color:#ffff00">Assert</span><span style="color:#ffffff">.That(wrapper.ExecuteUltimateQuestionAnswer(),</span><span style="color:#ffff00">Is</span><span style="color:#ffffff">.EqualTo(42));<br />         }<br />     </span>
          </p></div> </div> </div> 
          
          <p>
            This is a very simple and straightforward approach, but is very effective in testing some hidden members in you system.
          </p>