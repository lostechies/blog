---
id: 328
title: Expressions Cheat Sheet
date: 2009-06-25T02:36:53+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/06/24/expressions-cheat-sheet.aspx
dsq_thread_id:
  - "264716221"
categories:
  - 'C#'
---
I started getting really tired of looking up the translation between the ExpressionType and concrete Expression type (they don’t match up), so I created this cheat sheet that has each ExpressionType, derived Expression type and a simple example.&#160; What’s interesting is a few are only available in VB.NET, but no one really wants non-short-circuited Or/And operators, do they?&#160; You can [download the PDF version](http://grabbagoftimg.s3.amazonaws.com/Expression Cheat Sheet.pdf), or just view the big list in all its glory:

<table border="0" cellspacing="0" cellpadding="0" width="746">
  <tr>
    <td width="128">
      ExpressionType
    </td>
    
    <td width="142">
      Type
    </td>
    
    <td width="474">
      Example
    </td>
  </tr>
  
  <tr>
    <td>
      Add
    </td>
    
    <td>
      BinaryExpression
    </td>
    
    <td>
      <pre><span style="color: blue">int </span>i = 2, j = 3;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = () =&gt; i + j;</pre>
      
      <p>
        <a href="http://11011.net/software/vspaste"></a></td> </tr> 
        
        <tr>
          <td>
            AddChecked
          </td>
          
          <td>
            BinaryExpression
          </td>
          
          <td>
            <pre><span style="color: blue">int </span>i = <span style="color: #2b91af">Int32</span>.MaxValue, j = 1;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = () =&gt; <span style="color: blue">checked</span>(i + j);</pre>
            
            <p>
              <a href="http://11011.net/software/vspaste"></a></td> </tr> 
              
              <tr>
                <td>
                  And
                </td>
                
                <td>
                  BinaryExpression
                </td>
                
                <td>
                  <pre><span style="color: blue">Dim </span>i <span style="color: blue">As Boolean </span>= <span style="color: blue">True</span>, j <span style="color: blue">As Boolean </span>= <span style="color: blue">False
Dim </span>sample <span style="color: blue">As </span>Expression(<span style="color: blue">Of </span>Func(<span style="color: blue">Of Boolean</span>)) = _
 <span style="color: blue">Function</span>() i <span style="color: blue">And </span>j</pre>
                  
                  <p>
                    <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                    
                    <tr>
                      <td>
                        AndAlso
                      </td>
                      
                      <td>
                        BinaryExpression
                      </td>
                      
                      <td>
                        <pre><span style="color: blue">bool </span>i = <span style="color: blue">true</span>, j = <span style="color: blue">false</span>;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">bool</span>&gt;&gt; example = () =&gt; i && j;</pre>
                        
                        <p>
                          <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                          
                          <tr>
                            <td>
                              ArrayLength
                            </td>
                            
                            <td>
                              UnaryExpression
                            </td>
                            
                            <td>
                              <pre><span style="color: blue">int</span>[] values = {1, 2, 3};
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = () =&gt; values.Length;</pre>
                              
                              <p>
                                <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                
                                <tr>
                                  <td>
                                    ArrayIndex
                                  </td>
                                  
                                  <td>
                                    MethodCallExpression
                                  </td>
                                  
                                  <td>
                                    <pre><span style="color: blue">int</span>[] values = {1, 2, 3};
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = () =&gt; values[1];</pre>
                                    
                                    <p>
                                      <a href="http://11011.net/software/vspaste"></a><a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                      
                                      <tr>
                                        <td>
                                          Call
                                        </td>
                                        
                                        <td>
                                          MethodCallExpression
                                        </td>
                                        
                                        <td>
                                          <pre><span style="color: blue">var </span>sample = <span style="color: blue">new </span><span style="color: #2b91af">Sample</span>();
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = 
    () =&gt; sample.Calc();</pre>
                                        </td>
                                      </tr>
                                      
                                      <tr>
                                        <td>
                                          Coalesce
                                        </td>
                                        
                                        <td>
                                          BinaryExpression
                                        </td>
                                        
                                        <td>
                                          <pre><span style="color: blue">int</span>? i = <span style="color: blue">null</span>, j = 5;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>?&gt;&gt; example = () =&gt; i ?? j;</pre>
                                          
                                          <p>
                                            <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                            
                                            <tr>
                                              <td>
                                                Conditional
                                              </td>
                                              
                                              <td>
                                                ConditionalExpression
                                              </td>
                                              
                                              <td>
                                                <pre><span style="color: blue">int </span>i = 3, j = 5;
<span style="color: blue">bool </span>k = <span style="color: blue">false</span>;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>?&gt;&gt; example = () =&gt; k ? i : j;</pre>
                                                
                                                <p>
                                                  <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                  
                                                  <tr>
                                                    <td>
                                                      Constant
                                                    </td>
                                                    
                                                    <td>
                                                      ConstantExpression
                                                    </td>
                                                    
                                                    <td>
                                                      <pre><span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = () =&gt; 5;</pre>
                                                      
                                                      <p>
                                                        <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                        
                                                        <tr>
                                                          <td>
                                                            Convert
                                                          </td>
                                                          
                                                          <td>
                                                            UnaryExpression
                                                          </td>
                                                          
                                                          <td>
                                                            <pre><span style="color: blue">int </span>i = 5;
<span style="color: blue">object </span>j = i;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = () =&gt; (<span style="color: blue">int</span>) j;</pre>
                                                            
                                                            <p>
                                                              <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                              
                                                              <tr>
                                                                <td>
                                                                  ConvertChecked
                                                                </td>
                                                                
                                                                <td>
                                                                  UnaryExpression
                                                                </td>
                                                                
                                                                <td>
                                                                  <pre><span style="color: blue">long </span>i = 5;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = () =&gt; <span style="color: blue">checked</span>((<span style="color: blue">int</span>)i);</pre>
                                                                  
                                                                  <p>
                                                                    <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                    
                                                                    <tr>
                                                                      <td>
                                                                        Divide
                                                                      </td>
                                                                      
                                                                      <td>
                                                                        BinaryExpression
                                                                      </td>
                                                                      
                                                                      <td>
                                                                        <pre><span style="color: blue">int </span>i = 21, j = 3;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = () =&gt; i / j;</pre>
                                                                        
                                                                        <p>
                                                                          <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                          
                                                                          <tr>
                                                                            <td>
                                                                              Equal
                                                                            </td>
                                                                            
                                                                            <td>
                                                                              BinaryExpression
                                                                            </td>
                                                                            
                                                                            <td>
                                                                              <pre><span style="color: blue">int </span>i = 21, j = 3;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">bool</span>&gt;&gt; example = () =&gt; i == j;</pre>
                                                                              
                                                                              <p>
                                                                                <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                
                                                                                <tr>
                                                                                  <td>
                                                                                    ExclusiveOr
                                                                                  </td>
                                                                                  
                                                                                  <td>
                                                                                    BinaryExpression
                                                                                  </td>
                                                                                  
                                                                                  <td>
                                                                                    <pre><span style="color: blue">int </span>i = 12, j = 7;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = () =&gt; i ^ j;</pre>
                                                                                    
                                                                                    <p>
                                                                                      <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                      
                                                                                      <tr>
                                                                                        <td>
                                                                                          GreaterThan
                                                                                        </td>
                                                                                        
                                                                                        <td>
                                                                                          BinaryExpression
                                                                                        </td>
                                                                                        
                                                                                        <td>
                                                                                          <pre><span style="color: blue">int </span>i = 12, j = 7;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">bool</span>&gt;&gt; example = () =&gt; i &gt; j;</pre>
                                                                                          
                                                                                          <p>
                                                                                            <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                            
                                                                                            <tr>
                                                                                              <td>
                                                                                                GreaterThanOrEqual
                                                                                              </td>
                                                                                              
                                                                                              <td>
                                                                                                BinaryExpression
                                                                                              </td>
                                                                                              
                                                                                              <td>
                                                                                                <pre><span style="color: blue">int </span>i = 12, j = 7;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">bool</span>&gt;&gt; example = () =&gt; i &gt;= j;</pre>
                                                                                                
                                                                                                <p>
                                                                                                  <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                  
                                                                                                  <tr>
                                                                                                    <td>
                                                                                                      Invoke
                                                                                                    </td>
                                                                                                    
                                                                                                    <td>
                                                                                                      InvocationExpression
                                                                                                    </td>
                                                                                                    
                                                                                                    <td>
                                                                                                      <pre><span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>, <span style="color: blue">int</span>, <span style="color: blue">int</span>&gt;&gt; expr = (i, j) =&gt; i + j;
<span style="color: #2b91af">Expression </span>invoke = <span style="color: #2b91af">Expression</span>.Invoke(
    expr, 
    <span style="color: #2b91af">Expression</span>.Constant(5), 
    <span style="color: #2b91af">Expression</span>.Constant(4));
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = 
    <span style="color: #2b91af">Expression</span>.Lambda&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt;(invoke);</pre>
                                                                                                      
                                                                                                      <p>
                                                                                                        <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                        
                                                                                                        <tr>
                                                                                                          <td>
                                                                                                            Lambda
                                                                                                          </td>
                                                                                                          
                                                                                                          <td>
                                                                                                            LambdaExpression
                                                                                                          </td>
                                                                                                          
                                                                                                          <td>
                                                                                                            <pre><span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = 
    <span style="color: #2b91af">Expression</span>.Lambda&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt;(<span style="color: #2b91af">Expression</span>.Constant(5));</pre>
                                                                                                            
                                                                                                            <p>
                                                                                                              <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                              
                                                                                                              <tr>
                                                                                                                <td>
                                                                                                                  LeftShift
                                                                                                                </td>
                                                                                                                
                                                                                                                <td>
                                                                                                                  BinaryExpression
                                                                                                                </td>
                                                                                                                
                                                                                                                <td>
                                                                                                                  <pre><span style="color: blue">int </span>i = 8;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = () =&gt; i &lt;&lt; 1;</pre>
                                                                                                                  
                                                                                                                  <p>
                                                                                                                    <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                    
                                                                                                                    <tr>
                                                                                                                      <td>
                                                                                                                        LessThan
                                                                                                                      </td>
                                                                                                                      
                                                                                                                      <td>
                                                                                                                        BinaryExpression
                                                                                                                      </td>
                                                                                                                      
                                                                                                                      <td>
                                                                                                                        <pre><span style="color: blue">int </span>i = 12, j = 7;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">bool</span>&gt;&gt; example = () =&gt; i &lt; j;</pre>
                                                                                                                        
                                                                                                                        <p>
                                                                                                                          <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                          
                                                                                                                          <tr>
                                                                                                                            <td>
                                                                                                                              LessThanOrEqual
                                                                                                                            </td>
                                                                                                                            
                                                                                                                            <td>
                                                                                                                              BinaryExpression
                                                                                                                            </td>
                                                                                                                            
                                                                                                                            <td>
                                                                                                                              <pre><span style="color: blue">int </span>i = 12, j = 7;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">bool</span>&gt;&gt; example = () =&gt; i &lt;= j;</pre>
                                                                                                                              
                                                                                                                              <p>
                                                                                                                                <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                
                                                                                                                                <tr>
                                                                                                                                  <td>
                                                                                                                                    ListInit
                                                                                                                                  </td>
                                                                                                                                  
                                                                                                                                  <td>
                                                                                                                                    ListInitExpression
                                                                                                                                  </td>
                                                                                                                                  
                                                                                                                                  <td>
                                                                                                                                    <pre><span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">List</span>&lt;<span style="color: blue">int</span>&gt;&gt;&gt; example =
    () =&gt; <span style="color: blue">new </span><span style="color: #2b91af">List</span>&lt;<span style="color: blue">int</span>&gt; {1, 2, 3};</pre>
                                                                                                                                    
                                                                                                                                    <p>
                                                                                                                                      <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                      
                                                                                                                                      <tr>
                                                                                                                                        <td>
                                                                                                                                          MemberAccess
                                                                                                                                        </td>
                                                                                                                                        
                                                                                                                                        <td>
                                                                                                                                          MemberExpression
                                                                                                                                        </td>
                                                                                                                                        
                                                                                                                                        <td>
                                                                                                                                          <pre><span style="color: blue">var </span>c = <span style="color: blue">new </span><span style="color: #2b91af">Customer </span>{Name = <span style="color: #a31515">"Bob"</span>};
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">string</span>&gt;&gt; example = () =&gt; c.Name;</pre>
                                                                                                                                          
                                                                                                                                          <p>
                                                                                                                                            <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                            
                                                                                                                                            <tr>
                                                                                                                                              <td>
                                                                                                                                                MemberInit
                                                                                                                                              </td>
                                                                                                                                              
                                                                                                                                              <td>
                                                                                                                                                MemberInitExpression
                                                                                                                                              </td>
                                                                                                                                              
                                                                                                                                              <td>
                                                                                                                                                <pre><span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">Customer</span>&gt;&gt; example =
    () =&gt; <span style="color: blue">new </span><span style="color: #2b91af">Customer </span>{Name = <span style="color: #a31515">"Bob"</span>};</pre>
                                                                                                                                                
                                                                                                                                                <p>
                                                                                                                                                  <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                  
                                                                                                                                                  <tr>
                                                                                                                                                    <td>
                                                                                                                                                      Modulo
                                                                                                                                                    </td>
                                                                                                                                                    
                                                                                                                                                    <td>
                                                                                                                                                      BinaryExpression
                                                                                                                                                    </td>
                                                                                                                                                    
                                                                                                                                                    <td>
                                                                                                                                                      <pre><span style="color: blue">int </span>i = 5, j = 3;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = () =&gt; i % j;</pre>
                                                                                                                                                      
                                                                                                                                                      <p>
                                                                                                                                                        <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                        
                                                                                                                                                        <tr>
                                                                                                                                                          <td>
                                                                                                                                                            Multiply
                                                                                                                                                          </td>
                                                                                                                                                          
                                                                                                                                                          <td>
                                                                                                                                                            BinaryExpression
                                                                                                                                                          </td>
                                                                                                                                                          
                                                                                                                                                          <td>
                                                                                                                                                            <pre><span style="color: blue">int </span>i = 5, j = 3;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = () =&gt; i * j;</pre>
                                                                                                                                                            
                                                                                                                                                            <p>
                                                                                                                                                              <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                              
                                                                                                                                                              <tr>
                                                                                                                                                                <td>
                                                                                                                                                                  MultiplyChecked
                                                                                                                                                                </td>
                                                                                                                                                                
                                                                                                                                                                <td>
                                                                                                                                                                  BinaryExpression
                                                                                                                                                                </td>
                                                                                                                                                                
                                                                                                                                                                <td>
                                                                                                                                                                  <pre><span style="color: blue">int </span>i = 5, j = 3;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = () =&gt; <span style="color: blue">checked</span>(i * j);</pre>
                                                                                                                                                                  
                                                                                                                                                                  <p>
                                                                                                                                                                    <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                                    
                                                                                                                                                                    <tr>
                                                                                                                                                                      <td>
                                                                                                                                                                        Negate
                                                                                                                                                                      </td>
                                                                                                                                                                      
                                                                                                                                                                      <td>
                                                                                                                                                                        UnaryExpression
                                                                                                                                                                      </td>
                                                                                                                                                                      
                                                                                                                                                                      <td>
                                                                                                                                                                        <pre><span style="color: blue">int </span>i = 5;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = () =&gt; -i;</pre>
                                                                                                                                                                        
                                                                                                                                                                        <p>
                                                                                                                                                                          <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                                          
                                                                                                                                                                          <tr>
                                                                                                                                                                            <td>
                                                                                                                                                                              UnaryPlus
                                                                                                                                                                            </td>
                                                                                                                                                                            
                                                                                                                                                                            <td>
                                                                                                                                                                              UnaryExpression
                                                                                                                                                                            </td>
                                                                                                                                                                            
                                                                                                                                                                            <td>
                                                                                                                                                                              <pre><span style="color: blue">var </span>m = <span style="color: blue">new </span><span style="color: #2b91af">Money </span>{ Amount = -10m };
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">Money</span>&gt;&gt; example = () =&gt; +m;</pre>
                                                                                                                                                                              
                                                                                                                                                                              <p>
                                                                                                                                                                                <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                                                
                                                                                                                                                                                <tr>
                                                                                                                                                                                  <td>
                                                                                                                                                                                    NegateChecked
                                                                                                                                                                                  </td>
                                                                                                                                                                                  
                                                                                                                                                                                  <td>
                                                                                                                                                                                    UnaryExpression
                                                                                                                                                                                  </td>
                                                                                                                                                                                  
                                                                                                                                                                                  <td>
                                                                                                                                                                                    <pre><span style="color: blue">int </span>i = 5;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = () =&gt; <span style="color: blue">checked</span>(-i);</pre>
                                                                                                                                                                                    
                                                                                                                                                                                    <p>
                                                                                                                                                                                      <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                                                      
                                                                                                                                                                                      <tr>
                                                                                                                                                                                        <td>
                                                                                                                                                                                          New
                                                                                                                                                                                        </td>
                                                                                                                                                                                        
                                                                                                                                                                                        <td>
                                                                                                                                                                                          NewExpression
                                                                                                                                                                                        </td>
                                                                                                                                                                                        
                                                                                                                                                                                        <td>
                                                                                                                                                                                          <pre><span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">Customer</span>&gt;&gt; example = 
    () =&gt; <span style="color: blue">new </span><span style="color: #2b91af">Customer</span>();</pre>
                                                                                                                                                                                          
                                                                                                                                                                                          <p>
                                                                                                                                                                                            <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                                                            
                                                                                                                                                                                            <tr>
                                                                                                                                                                                              <td>
                                                                                                                                                                                                NewArrayInit
                                                                                                                                                                                              </td>
                                                                                                                                                                                              
                                                                                                                                                                                              <td>
                                                                                                                                                                                                NewArrayExpression
                                                                                                                                                                                              </td>
                                                                                                                                                                                              
                                                                                                                                                                                              <td>
                                                                                                                                                                                                <pre><span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>[]&gt;&gt; example = 
    () =&gt; <span style="color: blue">new</span>[] {1, 2, 3};</pre>
                                                                                                                                                                                                
                                                                                                                                                                                                <p>
                                                                                                                                                                                                  <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                                                                  
                                                                                                                                                                                                  <tr>
                                                                                                                                                                                                    <td>
                                                                                                                                                                                                      NewArrayBounds
                                                                                                                                                                                                    </td>
                                                                                                                                                                                                    
                                                                                                                                                                                                    <td>
                                                                                                                                                                                                      NewArrayExpression
                                                                                                                                                                                                    </td>
                                                                                                                                                                                                    
                                                                                                                                                                                                    <td>
                                                                                                                                                                                                      <pre><span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>[]&gt;&gt; example = () =&gt; <span style="color: blue">new int</span>[10];</pre>
                                                                                                                                                                                                      
                                                                                                                                                                                                      <p>
                                                                                                                                                                                                        <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                                                                        
                                                                                                                                                                                                        <tr>
                                                                                                                                                                                                          <td>
                                                                                                                                                                                                            Not
                                                                                                                                                                                                          </td>
                                                                                                                                                                                                          
                                                                                                                                                                                                          <td>
                                                                                                                                                                                                            UnaryExpression
                                                                                                                                                                                                          </td>
                                                                                                                                                                                                          
                                                                                                                                                                                                          <td>
                                                                                                                                                                                                            <pre><span style="color: blue">bool </span>val = <span style="color: blue">true</span>;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">bool</span>&gt;&gt; example = () =&gt; !val;</pre>
                                                                                                                                                                                                            
                                                                                                                                                                                                            <p>
                                                                                                                                                                                                              <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                                                                              
                                                                                                                                                                                                              <tr>
                                                                                                                                                                                                                <td>
                                                                                                                                                                                                                  NotEqual
                                                                                                                                                                                                                </td>
                                                                                                                                                                                                                
                                                                                                                                                                                                                <td>
                                                                                                                                                                                                                  BinaryExpression
                                                                                                                                                                                                                </td>
                                                                                                                                                                                                                
                                                                                                                                                                                                                <td>
                                                                                                                                                                                                                  <pre><span style="color: blue">int </span>i = 4, j = 7;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">bool</span>&gt;&gt; example = () =&gt; i != j;</pre>
                                                                                                                                                                                                                  
                                                                                                                                                                                                                  <p>
                                                                                                                                                                                                                    <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                                                                                    
                                                                                                                                                                                                                    <tr>
                                                                                                                                                                                                                      <td>
                                                                                                                                                                                                                        Or
                                                                                                                                                                                                                      </td>
                                                                                                                                                                                                                      
                                                                                                                                                                                                                      <td>
                                                                                                                                                                                                                        BinaryExpression
                                                                                                                                                                                                                      </td>
                                                                                                                                                                                                                      
                                                                                                                                                                                                                      <td>
                                                                                                                                                                                                                        <pre><span style="color: blue">Dim </span>i <span style="color: blue">As Boolean </span>= <span style="color: blue">True</span>, j <span style="color: blue">As Boolean </span>= <span style="color: blue">False
Dim </span>sample <span style="color: blue">As </span>Expression(<span style="color: blue">Of </span>Func(<span style="color: blue">Of Boolean</span>)) = _
 <span style="color: blue">Function</span>() i <span style="color: blue">Or </span>j</pre>
                                                                                                                                                                                                                        
                                                                                                                                                                                                                        <p>
                                                                                                                                                                                                                          <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                                                                                          
                                                                                                                                                                                                                          <tr>
                                                                                                                                                                                                                            <td>
                                                                                                                                                                                                                              OrElse
                                                                                                                                                                                                                            </td>
                                                                                                                                                                                                                            
                                                                                                                                                                                                                            <td>
                                                                                                                                                                                                                              BinaryExpression
                                                                                                                                                                                                                            </td>
                                                                                                                                                                                                                            
                                                                                                                                                                                                                            <td>
                                                                                                                                                                                                                              <pre><span style="color: blue">bool </span>i = <span style="color: blue">true</span>, j = <span style="color: blue">false</span>;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">bool</span>&gt;&gt; example = () =&gt; i || j;</pre>
                                                                                                                                                                                                                              
                                                                                                                                                                                                                              <p>
                                                                                                                                                                                                                                <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                                                                                                
                                                                                                                                                                                                                                <tr>
                                                                                                                                                                                                                                  <td>
                                                                                                                                                                                                                                    Parameter
                                                                                                                                                                                                                                  </td>
                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                  <td>
                                                                                                                                                                                                                                    ParameterExpression
                                                                                                                                                                                                                                  </td>
                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                  <td>
                                                                                                                                                                                                                                    <pre><span style="color: green">// (i, j) =&gt; i + j;
</span><span style="color: #2b91af">ParameterExpression </span>param1 = 
    <span style="color: #2b91af">Expression</span>.Parameter(<span style="color: blue">typeof </span>(<span style="color: blue">int</span>), <span style="color: #a31515">"i"</span>);
<span style="color: #2b91af">ParameterExpression </span>param2 = 
    <span style="color: #2b91af">Expression</span>.Parameter(<span style="color: blue">typeof </span>(<span style="color: blue">int</span>), <span style="color: #a31515">"j"</span>);
<span style="color: blue">var </span>addExpression = <span style="color: #2b91af">Expression</span>.Add(param1, param2);
<span style="color: blue">var </span>example = <span style="color: #2b91af">Expression</span>.Lambda&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>, <span style="color: blue">int</span>, <span style="color: blue">int</span>&gt;&gt;(
    addExpression, param1, param2);</pre>
                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                    <p>
                                                                                                                                                                                                                                      <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                      <tr>
                                                                                                                                                                                                                                        <td>
                                                                                                                                                                                                                                          Power
                                                                                                                                                                                                                                        </td>
                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                        <td>
                                                                                                                                                                                                                                          BinaryExpression
                                                                                                                                                                                                                                        </td>
                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                        <td>
                                                                                                                                                                                                                                          <pre><span style="color: blue">Dim </span>i <span style="color: blue">As Integer </span>= 3, j <span style="color: blue">As Integer </span>= 2
<span style="color: blue">Dim </span>sample <span style="color: blue">As </span>Expression(<span style="color: blue">Of </span>Func(<span style="color: blue">Of Integer</span>)) = _
 <span style="color: blue">Function</span>() i ^ j</pre>
                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                          <p>
                                                                                                                                                                                                                                            <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                            <tr>
                                                                                                                                                                                                                                              <td>
                                                                                                                                                                                                                                                Quote
                                                                                                                                                                                                                                              </td>
                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                              <td>
                                                                                                                                                                                                                                                UnaryExpression
                                                                                                                                                                                                                                              </td>
                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                              <td>
                                                                                                                                                                                                                                                <pre><span style="color: blue">int </span>i = 3, j = 2;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; inner = () =&gt; i * j;
<span style="color: blue">var </span>quoted = <span style="color: #2b91af">Expression</span>.Quote(inner);
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt;&gt;&gt; example = 
    <span style="color: #2b91af">Expression</span>.Lambda&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt;&gt;&gt;(quoted);</pre>
                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                <p>
                                                                                                                                                                                                                                                  <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                  <tr>
                                                                                                                                                                                                                                                    <td>
                                                                                                                                                                                                                                                      RightShift
                                                                                                                                                                                                                                                    </td>
                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                    <td>
                                                                                                                                                                                                                                                      BinaryExpression
                                                                                                                                                                                                                                                    </td>
                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                    <td>
                                                                                                                                                                                                                                                      <pre><span style="color: blue">int </span>i = 8;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = () =&gt; i &gt;&gt; 1;</pre>
                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                      <p>
                                                                                                                                                                                                                                                        <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                        <tr>
                                                                                                                                                                                                                                                          <td>
                                                                                                                                                                                                                                                            Subtract
                                                                                                                                                                                                                                                          </td>
                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                          <td>
                                                                                                                                                                                                                                                            BinaryExpression
                                                                                                                                                                                                                                                          </td>
                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                          <td>
                                                                                                                                                                                                                                                            <pre><span style="color: blue">int </span>i = 8, j = 5;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = () =&gt; i - j;</pre>
                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                            <p>
                                                                                                                                                                                                                                                              <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                              <tr>
                                                                                                                                                                                                                                                                <td>
                                                                                                                                                                                                                                                                  SubtractChecked
                                                                                                                                                                                                                                                                </td>
                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                <td>
                                                                                                                                                                                                                                                                  BinaryExpression
                                                                                                                                                                                                                                                                </td>
                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                <td>
                                                                                                                                                                                                                                                                  <pre><span style="color: blue">int </span>i = 8, j = 5;
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">int</span>&gt;&gt; example = () =&gt; <span style="color: blue">checked</span>(i - j);</pre>
                                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                  <p>
                                                                                                                                                                                                                                                                    <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                    <tr>
                                                                                                                                                                                                                                                                      <td>
                                                                                                                                                                                                                                                                        TypeAs
                                                                                                                                                                                                                                                                      </td>
                                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                      <td>
                                                                                                                                                                                                                                                                        UnaryExpression
                                                                                                                                                                                                                                                                      </td>
                                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                      <td>
                                                                                                                                                                                                                                                                        <pre><span style="color: blue">var </span>c = <span style="color: blue">new </span><span style="color: #2b91af">Customer </span>{Name = <span style="color: #a31515">"Bob"</span>};
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: #2b91af">Person</span>&gt;&gt; example = () =&gt; c <span style="color: blue">as </span><span style="color: #2b91af">Person</span>;</pre>
                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                        <p>
                                                                                                                                                                                                                                                                          <a href="http://11011.net/software/vspaste"></a></td> </tr> 
                                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                                          <tr>
                                                                                                                                                                                                                                                                            <td>
                                                                                                                                                                                                                                                                              TypeIs
                                                                                                                                                                                                                                                                            </td>
                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                            <td>
                                                                                                                                                                                                                                                                              TypeBinaryExpression
                                                                                                                                                                                                                                                                            </td>
                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                            <td>
                                                                                                                                                                                                                                                                              <pre><span style="color: blue">var </span>c = <span style="color: blue">new </span><span style="color: #2b91af">Customer </span>{Name = <span style="color: #a31515">"Bob"</span>};
<span style="color: #2b91af">Expression</span>&lt;<span style="color: #2b91af">Func</span>&lt;<span style="color: blue">bool</span>&gt;&gt; example = () =&gt; c <span style="color: blue">is int</span>;</pre>
                                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                              <p>
                                                                                                                                                                                                                                                                                <a href="http://11011.net/software/vspaste"></a></td> </tr> </tbody> </table> 
                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                <p>
                                                                                                                                                                                                                                                                                  This is only for C# 3.0, the .NET 4.0 list should grow quite a bit.
                                                                                                                                                                                                                                                                                </p>