---
id: 110
title: 'Don’t Expose IList<T> Just So You Can Assert Against Its Contents'
date: 2010-03-06T17:05:17+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2010/03/06/don-t-expose-ilist-lt-t-gt-just-so-you-can-assert-against-its-contents.aspx
dsq_thread_id:
  - "262068465"
categories:
  - .NET
  - 'C#'
  - Pragmatism
  - Principles and Patterns
  - Unit Testing
---
Lately I’ve been trying to return IEnumerable<T> whenever I need a collection that will only be enumerated or databound to something. This prevents me from making changes to the collection outside the context of the collection’s parent entity. The problem with doing this is that I might need to write a unit test that looks for a specific item in the collection, checks the count of the collection or otherwise needs to do something that the IEnumerable<T> interface doesn’t provide. 

With tools like Resharper, It’s easy to change the return types of the methods that you’re getting the collection from and use an IList<T> or some other collection type that allows you to get at the information I want. However, this can lead to broken encapsulation and other potential problems in code. After all, I wanted to keep the collection encapsulated within the parent entity which is why I chose to use the IEnumerable<T> in the first place.

The good news is that there’s a super simple solution to this situation that does not require changing the IEnumerable<T> return type. Have your test code wrap the IEnumerable<T> in an IList<T>. 

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> IEnumerable&lt;MyObject&gt; myEnumerator = someService.GetStuff();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> var myCollection = <span style="color: #0000ff">new</span> List&lt;MyObject&gt;(myEnumerator);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span> [Test]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> my_test()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>   myCollection.Count.ShouldBe(1);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>   myCollection[0].ShouldEqual(myObject);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>   <span style="color: #008000">//etc.</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        &#160;
      </p>
      
      <p>
        If you’re doing interaction testing with an interface and a mock object, where the interface receives an IEnumerable<T>, you can still use this trick. For example, if I have this method on an interface defintion:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">void</span> ShowProductCodes(IEnumerable&lt;Lookup&gt; productCodes);</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              I can grab the output of this method via a stub and convert it to an IList<T>. Here’s one way to do it via RhinoMocks:
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> var view = Mock&lt;IAssetClassificationView&gt;();</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span> view.Stub(v =&gt; v.ShowProductCodes(Arg&lt;IEnumerable&lt;Lookup&gt;&gt;.Is.Anything))</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span>     .Callback((IEnumerable&lt;Lookup&gt; lookups) =&gt;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span>     {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span>         DisplayedProductCodes = <span style="color: #0000ff">new</span> List&lt;Lookup&gt;(lookups);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   6:</span>         <span style="color: #0000ff">return</span> <span style="color: #0000ff">true</span>;</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   7:</span>     });</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   8:</span> <span style="color: #0000ff">return</span> view;</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    Line 5 wraps up the IEnumerable<Lookup> into an IList<Lookup> object, letting me test the contents/count/etc on the collection.
                  </p>
                  
                  <p>
                    Now you never need to worry about whether you can test the IEnumerable<T> when you are passing it around in your code. Just wrap it in an IList<T> at test time and call your tests the way you need to.
                  </p>