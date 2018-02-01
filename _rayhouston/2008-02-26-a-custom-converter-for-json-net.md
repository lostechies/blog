---
id: 9
title: A Custom Converter for Json.NET
date: 2008-02-26T02:36:00+00:00
author: Ray Houston
layout: post
guid: /blogs/rhouston/archive/2008/02/25/a-custom-converter-for-json-net.aspx
categories:
  - Uncategorized
---
{% raw %}
I was playing around with [Json.NET](http://james.newtonking.com/pages/json-net.aspx) while trying to move some data back and forth between .NET and Flex. I found that I needed to deserialize a string that looks something like:

<div>
  <pre><span>string</span> json = <span>@"{param1:{FirstName:'Jay',Age:2},param2:{FirstName:'Ray',Age:3}}"</span>;</pre>
</div>

where param1 and param2 are parameters to a method that I want to invoke as a remote service. I have two objects that I want to deserialize within a container object (the outer { }). I really don&#8217;t care about the container object but I have no way to tell Json.NET to ignore it. I have to have a real concrete to deserialize the container. I didn&#8217;t want to create specific objects for each call being made (there could be a lot) so I created a simple generic object that looks something like the following (error handling removed for clarity):

<div>
  <pre><span>public</span> <span>class</span> ParameterCollection<br />{<br />    <span>private</span> <span>readonly</span> Dictionary&lt;<span>string</span>, <span>object</span>&gt; parameters;<br /><br />    <span>internal</span> ParameterCollection(Dictionary&lt;<span>string</span>, <span>object</span>&gt; parameters)<br />    {<br />        <span>this</span>.parameters = parameters;<br />    }<br /><br />    <span>public</span> <span>object</span> <span>this</span>[<span>string</span> name]<br />    {<br />        get { <span>return</span> parameters[name]; }<br />    }<br /><br />    <span>public</span> <span>int</span> Count<br />    {<br />        get { <span>return</span> parameters.Count; }<br />    }<br />}<br /></pre>
</div>

In order to deserialize to a ParameterCollection object, I needed to create a converter class that inherits from JsonConverter. It ended up looking like the following (error handling removed for clarity):

<div>
  <pre><span>public</span> <span>class</span> ParameterCollectionJsonConverter : JsonConverter<br />{<br />    <span>private</span> <span>readonly</span> Type[] parameterTypes;<br />    <span>private</span> <span>readonly</span> Dictionary&lt;<span>string</span>, <span>object</span>&gt; parameterInstances;<br /><br />    <span>public</span> ParameterCollectionJsonConverter(<span>params</span> Type[] parameterTypes)<br />    {<br />        <span>this</span>.parameterTypes = parameterTypes;<br />        <span>this</span>.parameterInstances = <span>new</span> Dictionary&lt;<span>string</span>, <span>object</span>&gt;(parameterTypes.Length);<br />    }<br /><br />    <span>public</span> <span>override</span> <span>bool</span> CanConvert(Type objectType)<br />    {<br />        <span>return</span> objectType.IsAssignableFrom(<span>typeof</span>(ParameterCollection));<br />    }<br /><br />    <span>public</span> <span>override</span> <span>object</span> ReadJson(JsonReader reader, Type objectType)<br />    {<br />        reader.Read(); <span>// read past start object token</span><br /><br />        <span>for</span> (<span>int</span> i = 0; i &lt; parameterTypes.Length; i++)<br />        {<br />            <span>string</span> parameterName = reader.Value <span>as</span> <span>string</span>;<br /><br />            <span>this</span>.parameterInstances.Add(parameterName, <span>new</span> JsonSerializer().Deserialize(reader, parameterTypes[i]));<br />            reader.Read();<span>// read past end object token</span><br />        }<br /><br />        reader.Read();<span>// read past end object token</span><br /><br />        <span>return</span> <span>new</span> ParameterCollection(parameterInstances);<br />    }<br /><br />    <span>public</span> <span>static</span> ParameterCollection Deserialize(TextReader jsonTextReader, <span>params</span> Type[] types)<br />    {<br />        JsonSerializer serializer = <span>new</span> JsonSerializer();<br />        serializer.Converters.Add(<span>new</span> ParameterCollectionJsonConverter(types));<br /><br />        JsonReader reader = <span>new</span> JsonReader(jsonTextReader);<br />        <span>return</span> serializer.Deserialize(reader, <span>typeof</span>(ParameterCollection)) <span>as</span> ParameterCollection;<br />    }<br />}<br /></pre>
</div>

So now I can deserialize to a ParameterCollection by passing in the types of each parameter like so:

<div>
  <pre>TextReader tr = <span>new</span> StringReader(<span>@"{param1:{FirstName:'Jay',Age:2},param2:{FirstName:'Ray',Age:3}}"</span>);<br /><br />ParameterCollection paramCollection = ParameterCollectionJsonConverter.Deserialize(tr, <span>typeof</span>(SomeObject), <span>typeof</span>(SomeObject));<br /><br />SomeObject someObj1 = paramCollection[<span>"param1"</span>] <span>as</span> SomeObject;<br /></pre>
</div>

I&#8217;m sure as soon as I post this somebody will let me know of a built-in way to do the same thing. 😉

<div class="wlWriterSmartContent" style="padding-right: 0px;padding-left: 0px;padding-bottom: 0px;margin: 0px;padding-top: 0px">
  Technorati Tags: <a href="http://technorati.com/tags/.NET" rel="tag">.NET</a>,<a href="http://technorati.com/tags/Flex" rel="tag">Flex</a>,<a href="http://technorati.com/tags/JSON" rel="tag">JSON</a>
</div>
{% endraw %}
