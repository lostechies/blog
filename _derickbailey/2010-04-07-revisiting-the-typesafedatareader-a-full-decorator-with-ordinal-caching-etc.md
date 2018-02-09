---
wordpress_id: 134
title: 'Revisiting The TypeSafeDataReader: A Full Decorator With Ordinal Caching, etc.'
date: 2010-04-07T19:21:47+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/04/07/revisiting-the-typesafedatareader-a-full-decorator-with-ordinal-caching-etc.aspx
dsq_thread_id:
  - "262068598"
categories:
  - .NET
  - 'C#'
  - Data Access
  - Design Patterns
redirect_from: "/blogs/derickbailey/archive/2010/04/07/revisiting-the-typesafedatareader-a-full-decorator-with-ordinal-caching-etc.aspx/"
---
In [my previous post on this subject](http://www.lostechies.com/blogs/derickbailey/archive/2010/03/15/a-type-safe-idatareader-wrapper.aspx), several people mentioned changing the type safe methods for my data reader class into extension methods on IDataReader. I had planned on doing this, but then I ran into a situation where I needed to implement caching of the column ordinal positions to squeak out just a little bit more performance in a scenario that has 4,000+ queries into the database. Because I needed caching of the column ordinal positions, an extension method set would not cut it (I only want to cache columns for the current data reader, not store a static list of ordinals for all data readers that are used, like an extension method would force me to do). To do this with my TypeSafeDataReader, I had to change it up a bit in terms of how and where it’s used. The changes include turning it into a full [decorator pattern](http://en.wikipedia.org/wiki/Decorator_pattern) and adding the ability to retrieve column information as more than just the raw data in the column, in addition to ability to do the caching of column ordinals when I know that I am looking for more than 1 result, but prevent caching when I know there I am looking for only 1 result.

&#160;

### The ITypeSafeDataReader Interface

I extracted an interface for this, and had it inherit from IDataReader so that I could decorate the IDataReader with my strongly typed methods.

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> ITypeSafeDataReader : IDataReader</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     ColumnInformation&lt;<span style="color: #0000ff">bool</span>&gt; GetBoolean(<span style="color: #0000ff">string</span> columnName);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>     ColumnInformation&lt;<span style="color: #0000ff">int</span>&gt; GetInt32(<span style="color: #0000ff">string</span> columnName);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>     ColumnInformation&lt;<span style="color: #0000ff">string</span>&gt; GetString(<span style="color: #0000ff">string</span> columnName);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>     ColumnInformation&lt;<span style="color: #0000ff">decimal</span>&gt; GetDecimal(<span style="color: #0000ff">string</span> columnName);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>     ColumnInformation&lt;DateTime&gt; GetDateTime(<span style="color: #0000ff">string</span> columnName);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>     ColumnInformation&lt;T&gt; GetColumnInformation&lt;T&gt;(<span style="color: #0000ff">string</span> columnName);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        &#160;
      </p>
      
      <h3>
        Using Data From The ColumnInformation Class
      </h3>
      
      <p>
        I use this class to give me all the information I need about a column. For example, there are scenarios where I need to know if the column data is DBNull or not, and do something different depending. The ColumnInformation class gives me a .HasValue property which tells me whether or not the column has a value (a column has a value when the column is not DBNull).
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> ColumnInformation&lt;T&gt;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> ColumnName { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">int</span> ColumnIndex { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> HasValue { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>     <span style="color: #0000ff">public</span> T Value { get; set; }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span>     <span style="color: #0000ff">public</span> ColumnInformation(<span style="color: #0000ff">string</span> columnName)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  10:</span>         ColumnName = columnName;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  11:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  12:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  13:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">implicit</span> <span style="color: #0000ff">operator</span> T(ColumnInformation&lt;T&gt; ci)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  14:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  15:</span>         T <span style="color: #0000ff">value</span> = <span style="color: #0000ff">default</span>(T);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  16:</span>         <span style="color: #0000ff">if</span> (ci != <span style="color: #0000ff">null</span> && ci.HasValue)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  17:</span>             <span style="color: #0000ff">value</span> = ci.Value;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  18:</span>         <span style="color: #0000ff">return</span> <span style="color: #0000ff">value</span>;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  19:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  20:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              Notice that I also supplied an implicit conversion operator to the generics type. This allows me to directly assign a ColumnInformation variable to a property or parameter of the generics type without having to call .Value. For example, assuming a property called SomeInt is an integer value, I can use this code:
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> var myColumn = tsdr.GetInt32(<span style="color: #006080">"MyColumn"</span>);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span> someObject.SomeInt = myColumn;</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    This ColumnInformation class also let’s me check for values and do something other than map to a property if I need to. For example, I may not want to set a property at all if a value is null:
                  </p>
                  
                  <div>
                    <div>
                      <pre><span style="color: #606060">   1:</span> var childIdColumn = tsdr.GetInt32(<span style="color: #006080">"ChildIdColumn"</span>);</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">if</span> (childIdColumn.HasValue)</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   3:</span> {</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   4:</span>   someObject.SomeProperty = LoadAChildObjectById(childIdColumn);</pre>
                      
                      <p>
                        <!--CRLF-->
                      </p>
                      
                      <pre><span style="color: #606060">   5:</span> }</pre>
                      
                      <p>
                        <!--CRLF--></div> </div> 
                        
                        <p>
                          This would leave the SomeProperty null if the child id column does not have a value (is DBNull).
                        </p>
                        
                        <p>
                          &#160;
                        </p>
                        
                        <h3>
                          The TypeSafeDataReaderDecorator
                        </h3>
                        
                        <p>
                          Here’s my current implementation of the type safe data reader decorator.
                        </p>
                        
                        <p>
                          It takes a standard IDataReader as a constructor parameter along with a boolean value that tells it whether or not to use column ordinal caching.I’ve used a few regions to wrap up the extraneous code that does nothing more than map to the underlying IDataReader calls. This makes it easier to hide that code and focus on the decorations that I’m adding in.
                        </p>
                        
                        <div>
                          <div>
                            <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> TypeSafeDataReaderDecorator : ITypeSafeDataReader</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   2:</span> {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> <span style="color: #0000ff">bool</span> _useColumnOrdinalCaching;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IDataReader _dataReader;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IDictionary&lt;<span style="color: #0000ff">string</span>, <span style="color: #0000ff">int</span>&gt; _ordinalCache = <span style="color: #0000ff">new</span> Dictionary&lt;<span style="color: #0000ff">string</span>, <span style="color: #0000ff">int</span>&gt;();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   6:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   7:</span>     <span style="color: #0000ff">public</span> TypeSafeDataReaderDecorator(IDataReader dataReader, <span style="color: #0000ff">bool</span> useColumnOrdinalCaching)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   8:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">   9:</span>         _dataReader = dataReader;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  10:</span>         _useColumnOrdinalCaching = useColumnOrdinalCaching;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  11:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  12:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  13:</span>     <span style="color: #0000ff">public</span> ColumnInformation&lt;<span style="color: #0000ff">bool</span>&gt; GetBoolean(<span style="color: #0000ff">string</span> columnName)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  14:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  15:</span>         <span style="color: #0000ff">return</span> GetColumnInformation&lt;<span style="color: #0000ff">bool</span>&gt;(columnName);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  16:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  17:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  18:</span>     <span style="color: #0000ff">public</span> ColumnInformation&lt;<span style="color: #0000ff">int</span>&gt; GetInt32(<span style="color: #0000ff">string</span> columnName)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  19:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  20:</span>         <span style="color: #0000ff">return</span> GetColumnInformation&lt;<span style="color: #0000ff">int</span>&gt;(columnName);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  21:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  22:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  23:</span>     <span style="color: #0000ff">public</span> ColumnInformation&lt;<span style="color: #0000ff">long</span>&gt; GetInt64(<span style="color: #0000ff">string</span> columnName)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  24:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  25:</span>         <span style="color: #0000ff">return</span> GetColumnInformation&lt;<span style="color: #0000ff">long</span>&gt;(columnName);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  26:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  27:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  28:</span>     <span style="color: #0000ff">public</span> ColumnInformation&lt;<span style="color: #0000ff">string</span>&gt; GetString(<span style="color: #0000ff">string</span> columnName)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  29:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  30:</span>         <span style="color: #0000ff">return</span> GetColumnInformation&lt;<span style="color: #0000ff">string</span>&gt;(columnName);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  31:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  32:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  33:</span>     <span style="color: #0000ff">public</span> ColumnInformation&lt;<span style="color: #0000ff">decimal</span>&gt; GetDecimal(<span style="color: #0000ff">string</span> columnName)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  34:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  35:</span>         <span style="color: #0000ff">return</span> GetColumnInformation&lt;<span style="color: #0000ff">decimal</span>&gt;(columnName);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  36:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  37:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  38:</span>     <span style="color: #0000ff">public</span> ColumnInformation&lt;DateTime&gt; GetDateTime(<span style="color: #0000ff">string</span> columnName)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  39:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  40:</span>         <span style="color: #0000ff">return</span> GetColumnInformation&lt;DateTime&gt;(columnName);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  41:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  42:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  43:</span>     <span style="color: #0000ff">public</span> ColumnInformation&lt;T&gt; GetColumnInformation&lt;T&gt;(<span style="color: #0000ff">string</span> columnName)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  44:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  45:</span>         var columnInfo = <span style="color: #0000ff">new</span> ColumnInformation&lt;T&gt;(columnName);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  46:</span>         columnInfo.ColumnIndex = GetColumnIndex(columnName);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  47:</span>         <span style="color: #0000ff">if</span> (columnInfo.ColumnIndex &gt; -1)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  48:</span>         {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  49:</span>             <span style="color: #0000ff">if</span> (!_dataReader.IsDBNull(columnInfo.ColumnIndex))</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  50:</span>             {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  51:</span>                 columnInfo.HasValue = <span style="color: #0000ff">true</span>;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  52:</span>             }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  53:</span>         }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  54:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  55:</span>         <span style="color: #0000ff">if</span> (columnInfo.HasValue)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  56:</span>         {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  57:</span>             columnInfo.Value = GetColumnValue(columnInfo);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  58:</span>         }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  59:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  60:</span>         <span style="color: #0000ff">return</span> columnInfo;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  61:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  62:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  63:</span>     <span style="color: #0000ff">private</span> T GetColumnValue&lt;T&gt;(ColumnInformation&lt;T&gt; columnInfo)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  64:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  65:</span>         var valueObject = _dataReader.GetValue(columnInfo.ColumnIndex);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  66:</span>         T <span style="color: #0000ff">value</span> = <span style="color: #0000ff">default</span>(T);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  67:</span>         <span style="color: #0000ff">if</span> (valueObject != <span style="color: #0000ff">null</span>)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  68:</span>             <span style="color: #0000ff">value</span> = (T)Convert.ChangeType(valueObject, <span style="color: #0000ff">typeof</span>(T), <span style="color: #0000ff">null</span>);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  69:</span>         <span style="color: #0000ff">return</span> <span style="color: #0000ff">value</span>;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  70:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  71:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  72:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">int</span> GetColumnIndex(<span style="color: #0000ff">string</span> columnName)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  73:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  74:</span>         <span style="color: #0000ff">int</span> columnIndex;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  75:</span>         <span style="color: #0000ff">if</span> (_useColumnOrdinalCaching)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  76:</span>         {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  77:</span>             <span style="color: #0000ff">if</span> (_ordinalCache.ContainsKey(columnName))</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  78:</span>                 columnIndex = _ordinalCache[columnName];</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  79:</span>             <span style="color: #0000ff">else</span></pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  80:</span>             {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  81:</span>                 columnIndex = _dataReader.GetOrdinal(columnName);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  82:</span>                 _ordinalCache.Add(columnName, columnIndex);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  83:</span>             }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  84:</span>         }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  85:</span>         <span style="color: #0000ff">else</span></pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  86:</span>         {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  87:</span>             columnIndex = _dataReader.GetOrdinal(columnName);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  88:</span>         }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  89:</span>         <span style="color: #0000ff">return</span> columnIndex;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  90:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  91:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  92:</span>     <span style="color: #cc6633">#region</span> Implementation of IDisposable</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  93:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  94:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Dispose()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  95:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  96:</span>         _dataReader.Dispose();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  97:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  98:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060">  99:</span>     <span style="color: #cc6633">#endregion</span></pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 100:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 101:</span>     <span style="color: #cc6633">#region</span> Implementation of IDataRecord</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 102:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 103:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> GetName(<span style="color: #0000ff">int</span> i)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 104:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 105:</span>         <span style="color: #0000ff">return</span> _dataReader.GetName(i);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 106:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 107:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 108:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> GetDataTypeName(<span style="color: #0000ff">int</span> i)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 109:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 110:</span>         <span style="color: #0000ff">return</span> _dataReader.GetDataTypeName(i);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 111:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 112:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 113:</span>     <span style="color: #0000ff">public</span> Type GetFieldType(<span style="color: #0000ff">int</span> i)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 114:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 115:</span>         <span style="color: #0000ff">return</span> _dataReader.GetFieldType(i);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 116:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 117:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 118:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">object</span> GetValue(<span style="color: #0000ff">int</span> i)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 119:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 120:</span>         <span style="color: #0000ff">return</span> _dataReader.GetValue(i);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 121:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 122:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 123:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">int</span> GetValues(<span style="color: #0000ff">object</span>[] values)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 124:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 125:</span>         <span style="color: #0000ff">return</span> _dataReader.GetValues(values);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 126:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 127:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 128:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">int</span> GetOrdinal(<span style="color: #0000ff">string</span> name)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 129:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 130:</span>         <span style="color: #0000ff">return</span> _dataReader.GetOrdinal(name);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 131:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 132:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 133:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> GetBoolean(<span style="color: #0000ff">int</span> i)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 134:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 135:</span>         <span style="color: #0000ff">return</span> _dataReader.GetBoolean(i);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 136:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 137:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 138:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">byte</span> GetByte(<span style="color: #0000ff">int</span> i)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 139:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 140:</span>         <span style="color: #0000ff">return</span> _dataReader.GetByte(i);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 141:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 142:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 143:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">long</span> GetBytes(<span style="color: #0000ff">int</span> i, <span style="color: #0000ff">long</span> fieldOffset, <span style="color: #0000ff">byte</span>[] buffer, <span style="color: #0000ff">int</span> bufferoffset, <span style="color: #0000ff">int</span> length)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 144:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 145:</span>         <span style="color: #0000ff">return</span> _dataReader.GetBytes(i, fieldOffset, buffer, bufferoffset, length);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 146:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 147:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 148:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">char</span> GetChar(<span style="color: #0000ff">int</span> i)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 149:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 150:</span>         <span style="color: #0000ff">return</span> _dataReader.GetChar(i);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 151:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 152:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 153:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">long</span> GetChars(<span style="color: #0000ff">int</span> i, <span style="color: #0000ff">long</span> fieldoffset, <span style="color: #0000ff">char</span>[] buffer, <span style="color: #0000ff">int</span> bufferoffset, <span style="color: #0000ff">int</span> length)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 154:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 155:</span>         <span style="color: #0000ff">return</span> _dataReader.GetChars(i, fieldoffset, buffer, bufferoffset, length);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 156:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 157:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 158:</span>     <span style="color: #0000ff">public</span> Guid GetGuid(<span style="color: #0000ff">int</span> i)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 159:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 160:</span>         <span style="color: #0000ff">return</span> _dataReader.GetGuid(i);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 161:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 162:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 163:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">short</span> GetInt16(<span style="color: #0000ff">int</span> i)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 164:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 165:</span>         <span style="color: #0000ff">return</span> _dataReader.GetInt16(i);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 166:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 167:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 168:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">int</span> GetInt32(<span style="color: #0000ff">int</span> i)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 169:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 170:</span>         <span style="color: #0000ff">return</span> _dataReader.GetInt32(i);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 171:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 172:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 173:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">long</span> GetInt64(<span style="color: #0000ff">int</span> i)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 174:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 175:</span>         <span style="color: #0000ff">return</span> _dataReader.GetInt64(i);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 176:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 177:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 178:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">float</span> GetFloat(<span style="color: #0000ff">int</span> i)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 179:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 180:</span>         <span style="color: #0000ff">return</span> _dataReader.GetFloat(i);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 181:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 182:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 183:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">double</span> GetDouble(<span style="color: #0000ff">int</span> i)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 184:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 185:</span>         <span style="color: #0000ff">return</span> _dataReader.GetDouble(i);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 186:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 187:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 188:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> GetString(<span style="color: #0000ff">int</span> i)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 189:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 190:</span>         <span style="color: #0000ff">return</span> _dataReader.GetString(i);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 191:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 192:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 193:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">decimal</span> GetDecimal(<span style="color: #0000ff">int</span> i)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 194:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 195:</span>         <span style="color: #0000ff">return</span> _dataReader.GetDecimal(i);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 196:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 197:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 198:</span>     <span style="color: #0000ff">public</span> DateTime GetDateTime(<span style="color: #0000ff">int</span> i)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 199:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 200:</span>         <span style="color: #0000ff">return</span> _dataReader.GetDateTime(i);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 201:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 202:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 203:</span>     <span style="color: #0000ff">public</span> IDataReader GetData(<span style="color: #0000ff">int</span> i)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 204:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 205:</span>         <span style="color: #0000ff">return</span> _dataReader.GetData(i);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 206:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 207:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 208:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> IsDBNull(<span style="color: #0000ff">int</span> i)</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 209:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 210:</span>         <span style="color: #0000ff">return</span> _dataReader.IsDBNull(i);</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 211:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 212:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 213:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">int</span> FieldCount</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 214:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 215:</span>         get</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 216:</span>         {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 217:</span>             <span style="color: #0000ff">return</span> _dataReader.FieldCount;</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 218:</span>         }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 219:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 220:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 221:</span>     <span style="color: #0000ff">object</span> IDataRecord.<span style="color: #0000ff">this</span>[<span style="color: #0000ff">int</span> i]</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 222:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 223:</span>         get { <span style="color: #0000ff">return</span> _dataReader[i]; }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 224:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 225:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 226:</span>     <span style="color: #0000ff">object</span> IDataRecord.<span style="color: #0000ff">this</span>[<span style="color: #0000ff">string</span> name]</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 227:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 228:</span>         get { <span style="color: #0000ff">return</span> _dataReader[name]; }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 229:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 230:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 231:</span>     <span style="color: #cc6633">#endregion</span></pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 232:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 233:</span>     <span style="color: #cc6633">#region</span> Implementation of IDataReader</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 234:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 235:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Close()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 236:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 237:</span>         _dataReader.Close();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 238:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 239:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 240:</span>     <span style="color: #0000ff">public</span> DataTable GetSchemaTable()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 241:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 242:</span>         <span style="color: #0000ff">return</span> _dataReader.GetSchemaTable();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 243:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 244:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 245:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> NextResult()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 246:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 247:</span>         <span style="color: #0000ff">return</span> _dataReader.NextResult();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 248:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 249:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 250:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> Read()</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 251:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 252:</span>         <span style="color: #0000ff">return</span> _dataReader.Read();</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 253:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 254:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 255:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">int</span> Depth</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 256:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 257:</span>         get { <span style="color: #0000ff">return</span> _dataReader.Depth; }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 258:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 259:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 260:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> IsClosed</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 261:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 262:</span>         get { <span style="color: #0000ff">return</span> _dataReader.IsClosed; }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 263:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 264:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 265:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">int</span> RecordsAffected</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 266:</span>     {</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 267:</span>         get { <span style="color: #0000ff">return</span> _dataReader.RecordsAffected; }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 268:</span>     }</pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 269:</span>&#160; </pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 270:</span>     <span style="color: #cc6633">#endregion</span></pre>
                            
                            <p>
                              <!--CRLF-->
                            </p>
                            
                            <pre><span style="color: #606060"> 271:</span> }</pre>
                            
                            <p>
                              <!--CRLF--></div> </div> 
                              
                              <p>
                                My core data access layer has methods that know whether I’m looking for a single result vs a list of results (for example, a method to get one object by id vs a method to get all of the objects for a given type). When the method that returns a single object decorates the IDataReader with my TypeSafeDataReaderDecorator, I pass a value of false into the constructor to tell it not to use column ordinal caching. This will prevent a few extra calls that don’t need to happen when I know it’s only 1 object being read. When the method that returns a list of objects decorates the IDataReader, though, it passes a value of true to the constructor so that the caching will take effect. This prevents the code from having to call GetOridinal on the underlying data reader multiple times for the same column. Note that the interface knows nothing about caching, though. That is purely an implementation concern.
                              </p>
                              
                              <p>
                                &#160;
                              </p>
                              
                              <h3>
                                Convenience Methods vs GetColumnInformation<T>
                              </h3>
                              
                              <p>
                                The specific method overloads for GetInt32, GetString, GetBoolean, etc. are simple convenience methods that do nothing more than call into the GetColumnInformation<T> method with the correct type. I added the convenience methods for the data types that our code is using the most often. It would be easy to add additional convenience methods as well, or you can just call GetColumnInformation<T> directly, telling it the type of data that you expect to be returned:
                              </p>
                              
                              <div>
                                <div>
                                  <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">int</span> myInt = tsdr.GetColumnInformation&lt;<span style="color: #0000ff">int</span>&gt;(<span style="color: #006080">"MyIntColumn"</span>);</pre>
                                  
                                  <p>
                                    <!--CRLF--></div> </div> 
                                    
                                    <p>
                                      &#160;
                                    </p>
                                    
                                    <h3>
                                      Use ITypeSafeDataReader In Place Of IDataReader
                                    </h3>
                                    
                                    <p>
                                      I’ve updated my data access layer to always use the ITypeSafeDataReader specifically. This lets me have direct access to the extra functionality in the repository implementations without having to remember to decorate the IDataReader with the TypeSafeDataReaderDecorator where ever I need to use it. Since the ITypeSafeDataReader inherits from IDataReader, though, you can still pass it around as a standard IDataReader interface – you just lose the benefits of column ordinal caching, etc.
                                    </p>