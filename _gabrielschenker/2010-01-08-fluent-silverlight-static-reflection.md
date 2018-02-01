---
id: 37
title: Fluent Silverlight – static reflection
date: 2010-01-08T13:29:31+00:00
author: Gabriel Schenker
layout: post
guid: /blogs/gabrielschenker/archive/2010/01/08/fluent-silverlight-static-reflection.aspx
dsq_thread_id:
  - "1070105430"
categories:
  - data binding
  - fluent Silverlight
  - introduction
  - Lambda Expressions
  - reflection
  - Silverlight
---
Please view the [table of content](http://www.lostechies.com/blogs/gabrielschenker/archive/2010/01/08/fluent-silverlight-table-of-content.aspx) of this series for reference.

In my [last post](http://www.lostechies.com/blogs/gabrielschenker/archive/2010/01/07/fluent-silverlight-binding-dependency-properties-to-model-properties.aspx) about binding dependency properties of a Silverlight control to a view model I used LINQ expressions to define the binding. I have written in the [past](http://www.lostechies.com/blogs/gabrielschenker/archive/2009/02/03/dynamic-reflection-versus-static-reflection.aspx) about static reflection and the advantage of it versus dynamic reflection thus I do not want to repeat those arguments here. The main two reasons to use lambda expressions are

  * the binding can be defined in a strongly typed manner 
  * the availability of meta information through the expression 

When defining a data binding between a dependency property of a Silverlight control and a property on the view model we want to be able to use lambda expressions of the following type

  1. simple member (property or field on the view model) access, e.g. <font color="#ff0000" face="Courier New">m => m.Description</font> 
  2. access of a nested member of of the view model, e.g. <font color="#ff0000" face="Courier New">m => m.Name.Last</font> 
  3. any of the above but with a type casting, e.g. <font color="#ff0000" face="Courier New">m => (decimal)m.NumberOfItems</font> 

there might be other types of expressions that make sense in certain scenarios but we found that in our applications we only need the three types mentioned above. Given one or the other of the above expressions we need to extract the name (or path) to the corresponding member (property or field). We need this information to define the binding. Remember that the Binding class expects this information as parameter in the constructor; that is to define a binding to the property of name Description of the data context of the view (which will be the view model in our case) we use the following code

<div>
  <div>
    <pre>var binding = <span style="color: #0000ff">new</span> Binding(<span style="color: #006080">"Description"</span>);</pre></p>
  </div>
</div>

and to define a binding to the nested property Last of the data context we would have the following code

<div>
  <div>
    <pre>var binding = <span style="color: #0000ff">new</span> Binding(<span style="color: #006080">"Name.Last"</span>);</pre></p>
  </div>
</div>

If we use the debugger we can easily see that the **NodeType** of the expression body is **MemberAccess** for the first two expression types described above whereas it is **Convert** for the third type of expression.

In any case we want to get the –>MemberExpression “embedded” in the lambda expression. In the former case this is just the body of the lambda expression, thus

<div>
  <div>
    <pre>var memberExpression = expression.Body <span style="color: #0000ff">as</span> MemberExpression;</pre></p>
  </div>
</div>

and in the latter case a type cast operation is a so called unary expression an thus we can get to the interesting part (the member expression) via the code below

<div>
  <div>
    <pre>var body = (UnaryExpression)expression.Body;</pre>
    
    <pre>var memberExpression = body.Operand <span style="color: #0000ff">as</span> MemberExpression;</pre></p>
  </div>
</div>

once we have extracted the member expression from our lambda expression we can use it to get access to the **PropertyInfo** (or **FieldInfo** if the member is a field – but we only use properties for data binding) via 

<div>
  <div>
    <pre>var propertyInfo = (PropertyInfo)memberExpression.Member;</pre></p>
  </div>
</div>

and from the **PropertyInfo** we can get the name (or path) of the corresponding property (of the model)

<div>
  <div>
    <pre>var path = propertyInfo.Name;</pre></p>
  </div>
</div>

Wait a second, now this is not so easy for the nested&#160; property… there we effectively have a **property chain**. What we want is the path to the nested property to look like “Name.Last”. It turns out that we can just recursively iterate over a given member expression and extract the respective member to get a list of property info objects. This list of property info objects (in reverse order) can then be used to create the path. 

Let’s first create this list of property info objects from the member expression</p> </p> </p> 

<div>
  <div>
    <pre>var list = <span style="color: #0000ff">new</span> List&lt;PropertyInfo&gt;();</pre>
    
    <pre>&#160;</pre>
    
    <pre><span style="color: #0000ff">while</span> (memberExpression != <span style="color: #0000ff">null</span>)</pre>
    
    <pre>{</pre>
    
    <pre>    list.Add((PropertyInfo)memberExpression.Member);</pre>
    
    <pre>    memberExpression = memberExpression.Expression <span style="color: #0000ff">as</span> MemberExpression;</pre>
    
    <pre>}</pre></p>
  </div>
</div>

and now from this list we create the path

<div>
  <div>
    <pre>var path = <span style="color: #0000ff">string</span>.Empty;</pre>
    
    <pre><span style="color: #0000ff">foreach</span> (var info <span style="color: #0000ff">in</span> list.Reverse())</pre>
    
    <pre>    path += path Length &gt; 0 ? <span style="color: #006080">"."</span> + info.Name : info.Name;</pre></p>
  </div>
</div>

That’s it; quite easy yet powerful isn’t it? Below I give the full code I use in my samples. To facilitate the whole thing a bit I introduced a **SingleProperty** and a **PropertyChain** class (both implement the interface **Accessor**). Their respective code is also given below. First I use an extension method GetAccessor for our lambda expressions

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">class</span> ExpressionExtensions</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> Accessor GetAccessor&lt;TModel&gt;(<span style="color: #0000ff">this</span> Expression&lt;Func&lt;TModel, <span style="color: #0000ff">object</span>&gt;&gt; self)</pre>
    
    <pre>    {</pre>
    
    <pre>        var memberExpression = GetMemberExpression(self);</pre>
    
    <pre>        <span style="color: #0000ff">return</span> GetAccessor(memberExpression);</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">static</span> MemberExpression GetMemberExpression&lt;TModel, T&gt;(Expression&lt;Func&lt;TModel, T&gt;&gt; expression)</pre>
    
    <pre>    {</pre>
    
    <pre>        MemberExpression memberExpression = <span style="color: #0000ff">null</span>;</pre>
    
    <pre>        <span style="color: #0000ff">if</span> (expression.Body.NodeType == ExpressionType.Convert)</pre>
    
    <pre>        {</pre>
    
    <pre>            var body = (UnaryExpression)expression.Body;</pre>
    
    <pre>            memberExpression = body.Operand <span style="color: #0000ff">as</span> MemberExpression;</pre>
    
    <pre>        }</pre>
    
    <pre>        <span style="color: #0000ff">else</span> <span style="color: #0000ff">if</span> (expression.Body.NodeType == ExpressionType.MemberAccess)</pre>
    
    <pre>        {</pre>
    
    <pre>            memberExpression = expression.Body <span style="color: #0000ff">as</span> MemberExpression;</pre>
    
    <pre>        }</pre>
    
    <pre>&#160;</pre>
    
    <pre>        <span style="color: #0000ff">if</span> (memberExpression == <span style="color: #0000ff">null</span>) <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> ArgumentException(<span style="color: #006080">"Not a member access"</span>, <span style="color: #006080">"expression"</span>);</pre>
    
    <pre>        <span style="color: #0000ff">return</span> memberExpression;</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">static</span> Accessor GetAccessor(MemberExpression memberExpression)</pre>
    
    <pre>    {</pre>
    
    <pre>        var list = <span style="color: #0000ff">new</span> List&lt;PropertyInfo&gt;();</pre>
    
    <pre>&#160;</pre>
    
    <pre>        <span style="color: #0000ff">while</span> (memberExpression != <span style="color: #0000ff">null</span>)</pre>
    
    <pre>        {</pre>
    
    <pre>            list.Add((PropertyInfo)memberExpression.Member);</pre>
    
    <pre>            memberExpression = memberExpression.Expression <span style="color: #0000ff">as</span> MemberExpression;</pre>
    
    <pre>        }</pre>
    
    <pre>&#160;</pre>
    
    <pre>        <span style="color: #0000ff">if</span> (list.Count == 1)</pre>
    
    <pre>        {</pre>
    
    <pre>            <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> SingleProperty(list[0]);</pre>
    
    <pre>        }</pre>
    
    <pre>&#160;</pre>
    
    <pre>        list.Reverse();</pre>
    
    <pre>        <span style="color: #0000ff">return</span> <span style="color: #0000ff">new</span> PropertyChain(list.ToArray());</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

and here is the definition for the **Accessor** interface

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> Accessor</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">string</span> Name { get; }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

and the code for the **SingleProperty** class

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> SingleProperty : Accessor</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> PropertyInfo propertyInfo;</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> SingleProperty(PropertyInfo property)</pre>
    
    <pre>    {</pre>
    
    <pre>        propertyInfo = property;</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> Name</pre>
    
    <pre>    {</pre>
    
    <pre>        get { <span style="color: #0000ff">return</span> propertyInfo.Name; }</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

and for the **PropertyChain** classes

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> PropertyChain : Accessor</pre>
    
    <pre>{</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> PropertyInfo[] chain;</pre>
    
    <pre>    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> SingleProperty innerProperty;</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> PropertyChain(PropertyInfo[] properties)</pre>
    
    <pre>    {</pre>
    
    <pre>        chain = <span style="color: #0000ff">new</span> PropertyInfo[properties.Length - 1];</pre>
    
    <pre>        <span style="color: #0000ff">for</span> (var i = 0; i &lt; chain.Length; i++)</pre>
    
    <pre>        {</pre>
    
    <pre>            chain[i] = properties[i];</pre>
    
    <pre>        }</pre>
    
    <pre>&#160;</pre>
    
    <pre>        innerProperty = <span style="color: #0000ff">new</span> SingleProperty(properties[properties.Length - 1]);</pre>
    
    <pre>    }</pre>
    
    <pre>&#160;</pre>
    
    <pre>    <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> Name</pre>
    
    <pre>    {</pre>
    
    <pre>        get</pre>
    
    <pre>        {</pre>
    
    <pre>            var returnValue = <span style="color: #0000ff">string</span>.Empty;</pre>
    
    <pre>            <span style="color: #0000ff">foreach</span> (var info <span style="color: #0000ff">in</span> chain)</pre>
    
    <pre>                returnValue += returnValue.Length &gt; 0 ? <span style="color: #006080">"."</span> + info.Name : info.Name;</pre>
    
    <pre>&#160;</pre>
    
    <pre>            returnValue += returnValue.Length &gt; 0 ? <span style="color: #006080">"."</span> + innerProperty.Name : innerProperty.Name;</pre>
    
    <pre>&#160;</pre>
    
    <pre>            <span style="color: #0000ff">return</span> returnValue;</pre>
    
    <pre>        }</pre>
    
    <pre>    }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

Enjoy