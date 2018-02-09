---
wordpress_id: 114
title: A Type Safe IDataReader Wrapper
date: 2010-03-15T20:43:19+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/03/15/a-type-safe-idatareader-wrapper.aspx
dsq_thread_id:
  - "262068497"
categories:
  - .NET
  - 'C#'
  - Data Access
  - Design Patterns
  - Pragmatism
redirect_from: "/blogs/derickbailey/archive/2010/03/15/a-type-safe-idatareader-wrapper.aspx/"
---
I don’t always use NHibernate… it’s true… in fact, plain old ADO.NET, DataSets, DataTables and IDataReaders can offer [some nice advantages](http://www.lostechies.com/blogs/derickbailey/archive/2010/03/08/cqrs-performance-engineering-read-vs-read-write-models.aspx) when used in the right way at the right time. Today, I found myself writing more IDataReader code and getting tired of having to get the ordinal, check for dbnull, and then retrieve the data. So, I wrote a quick wrapper around that functionality, giving me the specific types of data that I want based on my column name. I know this has been done a thousand times before, but I wanted to share anyways. It’s not “complete” if you’re looking for all of the IDataReader functionality. It fills my current needs, though, and is easy to extend when you need to.

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> TypeSafeDataReaderWrapper</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IDataReader dataReader;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">public</span> TypeSafeDataReaderWrapper(IDataReader dataReader)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>         <span style="color: #0000ff">this</span>.dataReader = dataReader;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">bool</span> GetBoolean(<span style="color: #0000ff">string</span> columnName)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>         <span style="color: #0000ff">return</span> GetValue&lt;<span style="color: #0000ff">bool</span>&gt;(columnName);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">int</span> GetInt32(<span style="color: #0000ff">string</span> columnName)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  17:</span>         <span style="color: #0000ff">return</span> GetValue&lt;<span style="color: #0000ff">int</span>&gt;(columnName);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  18:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  19:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  20:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> GetString(<span style="color: #0000ff">string</span> columnName)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  21:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  22:</span>         <span style="color: #0000ff">return</span> GetValue&lt;<span style="color: #0000ff">string</span>&gt;(columnName);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  23:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  24:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  25:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">decimal</span> GetDecimal(<span style="color: #0000ff">string</span> columnName)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  26:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  27:</span>         <span style="color: #0000ff">return</span> GetValue&lt;<span style="color: #0000ff">decimal</span>&gt;(columnName);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  28:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  29:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  30:</span>     <span style="color: #0000ff">private</span> T GetValue&lt;T&gt;(<span style="color: #0000ff">string</span> columnName)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  31:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  32:</span>         T <span style="color: #0000ff">value</span> = <span style="color: #0000ff">default</span>(T);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  33:</span>         <span style="color: #0000ff">int</span> columnIndex = dataReader.GetOrdinal(columnName);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  34:</span>         <span style="color: #0000ff">if</span> (columnIndex &gt; -1)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  35:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  36:</span>             <span style="color: #0000ff">if</span> (!dataReader.IsDBNull(columnIndex))</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  37:</span>             {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  38:</span>                 <span style="color: #0000ff">value</span> = (T) dataReader.GetValue(columnIndex);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  39:</span>             }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  40:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  41:</span>         <span style="color: #0000ff">return</span> <span style="color: #0000ff">value</span>;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  42:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  43:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div>