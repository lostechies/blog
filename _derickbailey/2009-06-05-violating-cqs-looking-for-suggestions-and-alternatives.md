---
wordpress_id: 58
title: Violating CQS. Looking For Suggestions And Alternatives.
date: 2009-06-05T18:50:32+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/06/05/violating-cqs-looking-for-suggestions-and-alternatives.aspx
dsq_thread_id:
  - "262068197"
categories:
  - Analysis and Design
  - 'C#'
  - Principles and Patterns
---
When doing simple input validation on forms, I often end up writing a lot of code like this:

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SaveRequested()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>{</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> <span style="color: #0000ff">bool</span> descriptionIsValid = ValidateDescription();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> <span style="color: #0000ff">bool</span> abbreviationIsValid = ValidateAbbreviation();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> <span style="color: #0000ff">bool</span> isValid = (descriptionIsValid && abbreviationIsValid);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> <span style="color: #0000ff">if</span> (isValid)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   VisitType visitType = <span style="color: #0000ff">new</span> VisitType(Description, Abbreviation);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   VisitTypeRepository.Save(visitType);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>}</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>&#160;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #0000ff">private</span> <span style="color: #0000ff">bool</span> ValidateAbbreviation()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>{</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> <span style="color: #0000ff">bool</span> isValid = !<span style="color: #0000ff">string</span>.IsNullOrEmpty(Abbreviation);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> <span style="color: #0000ff">if</span> (isValid)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   View.HideAbbreviationRequiredMessage();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> <span style="color: #0000ff">else</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   View.ShowAbbreviationRequiredMessage();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> <span style="color: #0000ff">return</span> isValid;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>}</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>&#160;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #0000ff">private</span> <span style="color: #0000ff">bool</span> ValidateDescription()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>{</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> <span style="color: #0000ff">bool</span> isValid = !<span style="color: #0000ff">string</span>.IsNullOrEmpty(Description);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> <span style="color: #0000ff">if</span> (isValid)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   View.HideDescriptionRequiredMessage();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> <span style="color: #0000ff">else</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   View.ShowDescriptionRequiredMessage();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> <span style="color: #0000ff">return</span> isValid;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>}</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        I recognize the violations of <a href="http://en.wikipedia.org/wiki/Command-query_separation">Command-Query-Separation</a> in this code, and potentially other issues in design and implementation. The ValidateDescription and ValidateAbbreviation methods are fairly horrendous, from a CQS perspective. They are both querying the data to see if it’s valid, and also executing commands if it is or is not valid. Then on top of that, the SaveRequested method is executing another set of commands if both Description and Abbreviation are valid.
      </p>
      
      <p>
        The requirements of this functionality are:
      </p>
      
      <ul>
        <li>
          If Description is null or empty, show the “Description Required” message
        </li>
        <li>
          If Abbreviation is null or empty, show the “Abbreviation Required” message
        </li>
        <li>
          If both Description and Abbreviation are ok, allow the save to happen.
        </li>
      </ul>
      
      <p>
        I’m not considering the difference between active and passive validation (on typing, vs on clicking save) in this example. That’s a different discussion for a different time.
      </p>
      
      <p>
        So, how do you handle this type of input validation, accounting for CQS, code readability, testability, etc? I’m looking for suggestions and alternatives to this type of ugly code. I have a lot of my own ideas, but before I travel too far down the road, I want input from the rest of the world.
      </p>
      
      <p>
        <strong>Note On Responses:</strong> As a suggestion for responding – if your response will take more than a few lines of very simple code and text, I’d really like to see your full response on your blog. Post a comment here (or pingback/trackback from your post) when you have your post up. If you don’t have a blog to respond with – shame on you! Blogspot.com is free. Go get a blog and respond. 🙂
      </p>