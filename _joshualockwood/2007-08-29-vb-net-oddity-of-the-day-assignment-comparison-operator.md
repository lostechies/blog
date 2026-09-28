---
wordpress_id: 16
title: 'VB.Net oddity of the day &#8211; Assignment/Comparison operator'
date: 2007-08-29T14:56:00+00:00
author: Joshua Lockwood
layout: post
wordpress_guid: /blogs/joshua_lockwood/archive/2007/08/29/vb-net-oddity-of-the-day-assignment-comparison-operator.aspx
categories:
  - Programming
  - VB.Net
redirect_from: "/blogs/joshua_lockwood/archive/2007/08/29/vb-net-oddity-of-the-day-assignment-comparison-operator.aspx/"
---
On my current project I&#8217;m forced to code in VB.Net.&nbsp; Normally I&#8217;m pretty open to other languages, but VB.Net is irritating (more so than VB6 in my opinion).&nbsp; The language syntax&nbsp;is riddled with ambiguity (at least for a c-type guy like myself) and moving from c# to VB can be confusing.


  


Here&#8217;s my latest beef with VB.Net.&nbsp; There&#8217;s only one operator for assignment and comparisons.&nbsp; As a result, the compiler handles evaluation of the the language syntax in a subtle, but irritating way.


  


Here&#8217;s some code to illustrate my point, I had something like this in my program:

<FONT size="2"><br /> 

<P>
  </FONT><FONT color="#0000ff" size="2">Dim</FONT><FONT size="2"> oldValue, currentValue </FONT><FONT color="#0000ff" size="2">As</FONT><FONT size="2"> </FONT><FONT color="#0000ff" size="2">Integer</P></FONT><FONT size="2"><br /> 
  
  <P>
    oldValue = currentValue = 2
  </P></FONT>
  
  <br /> 
  
  <P>
    In C# this is cut and dry.&nbsp; The value 2 would be assigned to currentValue and the side effect would be the value assigned, or 2.&nbsp; I&#8217;ve long been in the habit of using assignment side effects in C#, but VB looks at this differently.&nbsp; In VB, the value 2 is assigned to currentValue, but the side effect is the comparison of the two values.&nbsp; In this case, currentValue initializes to 0, so the expression evaluates to false (or 0).&nbsp; Therefore, oldValue now equals 0.
  </P>
  
  <br /> 
  
  <P>
    Now, if I did this:
  </P>
  
  <FONT size="2"><br /> 
  
  <P>
    </FONT><FONT color="#0000ff" size="2">Dim</FONT><FONT size="2"> oldValue, currentValue </FONT><FONT color="#0000ff" size="2">As</FONT><FONT size="2"> </FONT><FONT color="#0000ff" size="2">Integer</P></FONT><FONT size="2"><br /> 
    
    <P>
      currentValue = 2
    </P>
    
    <br /> 
    
    <P>
      oldValue = currentValue = 2
    </P>
    
    <br /> 
    
    <P>
      When the statement is evaluated, it will first evaluate the expression currentValue = 2.&nbsp; 2 will be assigned to currentValue and the side effect will be the comparison of currentValue to the assigned value, 2.&nbsp; They are equal, so true will be returned and converted from bool to int as&nbsp;the non-zero value -1.
    </P>
    
    <br /> 
    
    <P>
      It&#8217;s no biggy, just annoying.
    </P></FONT>
  </p>