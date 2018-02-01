---
id: 17
title: 'Pop quiz on ref and out parameters in C#'
date: 2007-05-11T13:43:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/05/11/pop-quiz-on-ref-and-out-parameters-in-c.aspx
dsq_thread_id:
  - "265581561"
categories:
  - 'C#'
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/pop-quiz-on-ref-and-out-parameters-in-c.html)._

If you line up 100 C# developers, I would be willing to bet that the number of developers that could explain the difference between out and ref parameter keywords could be counted on one hand.&nbsp; When I first started .NET development coming over from pointer-centric languages such as C and C++, I used the ref keyword with reckless abandon.&nbsp; I started in VB.NET, which only exacerbated the problem with its ByVal and ByRef keywords.&nbsp; While working on a defect today, I spotted an interesting use of the ref keyword that took me back to my nascent days as a .NET developer:

<div class="CodeFormatContainer">
  <pre>SqlCommand cmd = <span class="kwrd">new</span> SqlCommand(<span class="str">"SELECT * FROM customers WHERE customer_name = @Name"</span>);<br />

AddInputParam(<span class="kwrd">ref</span> cmd, <span class="str">"@Name"</span>, SqlDbType.NVarChar, customer.Name);<br />
</pre>
</div>

The code went on to execute the query.&nbsp; But that last line really had me confused.&nbsp; Under what circumstances would I be getting a different SqlCommand object out of &#8220;AddInputParam&#8221;?&nbsp; After some investigation, it turned out that this was just an incorrect use of the ref parameter.

### So what are the ref and out keywords?

To understand what the ref and out keywords are, you have to know a little about pointers and reference types in .NET.&nbsp; In the snippet above, the variable &#8220;cmd&#8221; holds a **reference** to a SqlCommand object.&nbsp; When you specify the &#8220;ref&#8221; keyword on a method parameter, you are notifying the caller that the **reference** to the object they passed in can change.&nbsp; What this told me in the above snippet is that &#8220;cmd&#8221; could be pointing to a **completely different SqlCommand object**&nbsp;when the method returned.&nbsp; I&#8217;m pretty sure that&#8217;s not what the intention of this code is supposed to be.&nbsp; I don&#8217;t want to execute a different SqlCommand object, I want to execute the one I created.

With the &#8220;out&#8221; keyword, it is akin to extra return variables.&nbsp; It signifies that something extra is passed out of the method, and the caller should initialize the variable they are passing in as null.

  * Out params should be passed in as a null reference, and have to assign the value before exiting the method 
      * Ref params should be passed in as an instantiated object, and may re-assign the value before exiting the method </ul> 
    The problem with the snippet above was that the &#8220;ref&#8221; keyword was completely unnecessary.&nbsp; When you pass in a reference type by value to a method (the default), the variable reference itself can&#8217;t change, but the object itself can change.&nbsp; I could remove the &#8220;ref&#8221; keyword, and change the SqlCommand object all I wanted, and changes would get reflected in that object when the method returned.&nbsp; But if I set the &#8220;cmd&#8221; variable inside the method to a new SqlCommand object, the original SqlCommand object will still point to the original instance.
    
    ### Example using ref and out
    
    Let&#8217;s look at a trivial case highlighting the differences between ref, out, and value parameters.&nbsp; I have a simple Customer class that looks like this:
    
    <div class="CodeFormatContainer">
      &nbsp;&nbsp;&nbsp;&nbsp;</p> 
      
      <pre><span class="kwrd">public</span> <span class="kwrd">class</span> Customer<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">private</span> <span class="kwrd">string</span> _name;<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> Customer(<span class="kwrd">string</span> name)<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_name = name;<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="kwrd">string</span> Name<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;get { <span class="kwrd">return</span> _name; }<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;set { _name = <span class="kwrd">value</span>; }<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
}<br />
</pre>
    </div>
    
    Pretty simple, just a customer with a name.&nbsp; Now, some code with methods with out, ref, and value parameters:
    
    <div class="CodeFormatContainer">
      <pre><span class="kwrd">public</span> <span class="kwrd">void</span> RefAndOutParamExample()<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;Customer customer = <span class="kwrd">new</span> Customer(<span class="str">"Bob"</span>);<br />
&nbsp;&nbsp;&nbsp;&nbsp;Debug.WriteLine(customer.Name);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;Test1(customer);<br />
&nbsp;&nbsp;&nbsp;&nbsp;Debug.WriteLine(customer.Name);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;Test2(<span class="kwrd">ref</span> customer);<br />
&nbsp;&nbsp;&nbsp;&nbsp;Debug.WriteLine(customer.Name);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;Test3(<span class="kwrd">out</span> customer);<br />
&nbsp;&nbsp;&nbsp;&nbsp;Debug.WriteLine(customer.Name);<br />
}<br />
<br />
<span class="kwrd">private</span> <span class="kwrd">void</span> Test1(Customer customer)<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;customer.Name = <span class="str">"Billy"</span>;<br />
&nbsp;&nbsp;&nbsp;&nbsp;customer = <span class="kwrd">new</span> Customer(<span class="str">"Sally"</span>);<br />
}<br />
<br />
<span class="kwrd">private</span> <span class="kwrd">void</span> Test2(<span class="kwrd">ref</span> Customer customer)<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;customer.Name = <span class="str">"Larry"</span>;<br />
&nbsp;&nbsp;&nbsp;&nbsp;customer = <span class="kwrd">new</span> Customer(<span class="str">"Joe"</span>);<br />
}<br />
<br />
<span class="kwrd">private</span> <span class="kwrd">void</span> Test3(<span class="kwrd">out</span> Customer customer)<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="rem">// customer.Name = "Suzie"; // Compile error, I can't reference an</span><br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="rem">// out param without assigning it first</span><br />
&nbsp;&nbsp;&nbsp;&nbsp;customer = <span class="kwrd">new</span> Customer(<span class="str">"Chris"</span>);<br />
}<br />
</pre>
    </div>
    
    The output of the RefAndOutParamExample would be:
    
    <div class="CodeFormatContainer">
      <pre>Original:    Bob<br />
Value param: Billy<br />
<span class="kwrd">ref</span> param:   Joe<br />
<span class="kwrd">out</span> param:   Chris</pre>
    </div>
    
    ### So what happened?
    
    In all of these methods, I reassign the customer.Name property, then reassign the customer parameter to a new instance of a Customer object.&nbsp; All of the methods successfully change the Name property of the original customer instance, but only methods with the out and ref parameter can change what Customer object the original variable referenced.&nbsp; The final Test3 method can&#8217;t assign the Name property, and will get a compile error if I try to access it before assigning it.
    
    ### When to use ref and out parameters
    
    From [Framework Design Guidelines](http://www.amazon.com/Framework-Design-Guidelines-Conventions-Development/dp/0321246756/ref=pd_bbs_sr_1/002-0878740-0508014?ie=UTF8&s=books&qid=1178916826&sr=8-1), pages 156 and 157, I see two guidelines:
    
    >   * **AVOID** using out or ref parameters 
    >       * **DO NOT** pass reference types by reference </ul> </blockquote> 
    >     Framework Design Guidelines has 4 types of recommendations related to guidelines:
    >     
    >       * **DO** &#8211; should be always followed 
    >           * **CONSIDER** &#8211; should generally be followed, unless you really know what&#8217;s going on and have a good reason to break the rule 
    >               * **DO NOT** &#8211; should almost never do 
    >                   * **AVOID** &#8211; generally not a good idea, but there might be a few known cases where it makes sense </ul> 
    >                 So the FDG tells me that in general I should avoid out and ref parameters, and should never pass in reference types with the &#8220;ref&#8221; or &#8220;out&#8221; keyword.&nbsp; The problem with these keywords is that they require some knowledge of pointers and reference types, which can be easily confused. &nbsp;It also forces the caller to declare temporary variables.&nbsp; They hurt the readability of the code since it violates the common pattern of assigning a variable the result of a method call.
    >                 
    >                 If you feel the need to add a ref param, I&#8217;d suggest taking a look at [FDG](http://www.amazon.com/Framework-Design-Guidelines-Conventions-Development/dp/0321246756/ref=pd_bbs_sr_1/002-0878740-0508014?ie=UTF8&s=books&qid=1178916826&sr=8-1)&nbsp;to see the recommendations for these parameters in depth.&nbsp; You could also consider refactoring your code to return the entire result into a single object, instead of splitting the results into two objects in a return parameter and a ref parameter.&nbsp; The only time I&#8217;ve ever justified the need of a ref parameter was in the [Tester-Doer](http://msdn2.microsoft.com/en-us/library/ms229009.aspx) pattern, which is for a very specific scenario.&nbsp; To me, ref and out params remind me of Mr. Miyagi&#8217;s advice about karate in [The Karate Kid](http://www.imdb.com/title/tt0087538), &#8220;You learn karate so that you never need to use it&#8221;.