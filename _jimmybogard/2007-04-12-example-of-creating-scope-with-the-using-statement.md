---
wordpress_id: 7
title: Example of creating scope with the using statement
date: 2007-04-12T12:36:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/04/12/example-of-creating-scope-with-the-using-statement.aspx
dsq_thread_id:
  - "265431409"
categories:
  - 'C#'
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/example-of-creating-scope-with-using.html)._

The using statement is widely used for cleaning up resources, such as a database connection or file handle.&nbsp; To use the using statement, the variable being scoped just needs to implement IDisposable.&nbsp; There are many times when I&#8217;ve needed to create a scope for behavior, and I&#8217;ve taken advantage of IDisposable to do this.

### The problem

When I&#8217;m writing unit tests for a specific module of code, often times I would like to inject a different implementation of certain services at runtime without having to change the original code. For example, I have a class that calls into the ConfigurationManager to set some internal configuration values: 

<div class="csharpcode">
  <pre><span class="kwrd">public class</span> <span class="idnt">DatabaseReader</span><br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="idnt">DataSet</span> GetOrdersForCustomer(<span class="idnt">Guid</span> customerId)<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">string</span> connString = <span class="idnt">ConfigurationManager</span>.AppSettings[<span class="str">"DBConnString"</span>];<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="idnt">OracleConnection</span> conn = <span class="kwrd">new</span> <span class="idnt">OracleConnection</span>(connString);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;…<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="rem">//return dataset</span><br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
}<br />
</pre>
</div>

Well, if I want to test this in a unit test, I won&#8217;t be able to because I&#8217;m coupled to the ConfigurationManager class, which requires a .config file. This file doesn&#8217;t exist in my test library, so this block will throw an exception. 

### Some refactoring

What if I try to move the configuration logic outside this class into its own implementation? Slap in an interface and a factory, and this is what we get: 

<div class="csharpcode">
  <pre><span class="kwrd">public interface</span> <span class="idnt">IConfigurationProvider</span><br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">string</span> GetValue(<span class="kwrd">string</span> key);<br />
}<br />
<br />
<span class="kwrd">public class</span> <span class="idnt">ConfigurationProviderFactory</span><br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public static</span> <span class="idnt">IConfigurationProvider</span> GetInstance()<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return new</span> <span class="idnt">SettingsConfigProvider</span>();<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">private class</span> <span class="idnt">SettingsConfigProvider</span> : <span class="idnt">IConfigurationProvider</span><br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public string</span> GetValue(<span class="kwrd">string</span> key)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return</span> <span class="idnt">ConfigurationManager</span>.AppSettings[key];<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
}<br />
<br />
<span class="kwrd">public class</span> <span class="idnt">DatabaseReader</span><br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> <span class="idnt">DataSet</span> GetOrdersForCustomer(<span class="idnt">Guid</span> customerId)<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="idnt">IConfigurationProvider</span> configProvider = <span class="idnt">ConfigurationProviderFactory</span>.GetInstance();<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">string</span> connString = configProvider.GetValue(<span class="str">"DBConnString"</span>);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="idnt">OracleConnection</span> conn = <span class="kwrd">new</span> <span class="idnt">OracleConnection</span>(connString);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;…<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="rem">//return dataset</span><br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
}<br />
</pre>
</div>

The GetOrdersForCustomer method now uses an IConfigurationProvider instance to get its configuration. A specific instance is provided by the ConfigurationProviderFactory. 

### My broken unit test

But I&#8217;m not much better off. I created a whole layer of indirection just so I could factor out the configuration code. Here&#8217;s the test code I&#8217;m trying to write: 

<div class="csharpcode">
  <pre>[Test]<br />
<span class="kwrd">public void</span> CustomerContainsCorrectOrders()<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="idnt">IConfigurationProvider</span> fakeProvider = CreateFakeConfigProvider(); <span class="rem">// returns a hard-coded implementation</span><br />
&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="idnt">DatabaseReader</span> reader = <span class="kwrd">new</span> <span class="idnt">DatabaseReader</span>();<br />
&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="idnt">Guid</span> customerId;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="rem">// Now I want to use my fake configuration provider instead of the built-in one</span><br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="idnt">DataSet</span> ds = reader.GetOrdersForCustomer(customerId);<br />
&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="idnt">Assert</span>.AreEqual(1, ds.Tables[0].Rows.Count);<br />
}<br />
</pre>
</div>

### My ideal unit test

I&#8217;m going to add some functionality to the ConfigurationProviderFactory to be able to return an IConfigurationProvider instance I give it when GetInstance is called. Also, I&#8217;d like to encapsulate this behavior in a using block like so: 

<div class="csharpcode">
  <pre>[Test]<br />
<span class="kwrd">public void</span> CustomerContainsCorrectOrders()<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="idnt">IConfigurationProvider</span> fakeProvider = CreateFakeConfigProvider(); <span class="rem">// returns a hard-coded implementation</span><br />
&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="idnt">DatabaseReader</span> reader = <span class="kwrd">new</span> <span class="idnt">DatabaseReader</span>();<br />
&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="idnt">Guid</span> customerId;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">using</span> (<span class="idnt">ConfigurationProviderFactory</span>.CreateLocalInstance(fakeProvider)) <span class="rem">// use the fakeProvider instance inside this block</span><br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="idnt">DataSet</span> ds = reader.GetOrdersForCustomer(customerId);<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="idnt">Assert</span>.AreEqual(1, ds.Tables[0].Rows.Count);<br />
}<br />
</pre>
</div>

### The solution

So this code implies that CreateLocalInstance needs to return an IDisposable instance. I don&#8217;t have one yet, so let&#8217;s create one. What I&#8217;d like to happen is for CreateLocalInstance to save the IConfigurationProvider passed in as a local variable, and have the GetInstance return that instead. Once I&#8217;m outside the using block, GetInstance should revert back to normal. I need something that will allow custom code to be run at the end of the using block in the Dispose method to accomplish this. Here&#8217;s what I came up with, borrowed from ideas from [Ayende](http://www.ayende.com/blog/): 

<div class="csharpcode">
  <pre><span class="kwrd">public delegate void</span> <span class="idnt">DisposableActionCallback</span>();<br />
<br />
<span class="kwrd">public class</span> <span class="idnt">DisposableAction</span> : <span class="idnt">IDisposable</span><br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">private readonly</span> <span class="idnt">DisposableActionCallback</span> _callback;<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public</span> DisposableAction(<span class="idnt">DisposableActionCallback</span> callback)<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_callback = callback;<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public void</span> Dispose()<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_callback();<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
}<br />
</pre>
</div>

What DisposableAction allows me to do is to pass custom code via a callback method to be called whenever the DisposableAction goes out of scope. That will be what we return from our CreateLocalInstance method: 

<div class="csharpcode">
  <pre><span class="kwrd">public class</span> <span class="idnt">ConfigurationProviderFactory</span><br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">private</span> <span class="idnt">IConfigurationProvider</span> _localProvider = <span class="kwrd">null</span>;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public static</span> <span class="idnt">IConfigurationProvider</span> GetInstance()<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">if</span> (_localProvider != <span class="kwrd">null</span>)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return</span> _localProvider;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return new</span> <span class="idnt">SettingsConfigProvider</span>();<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">public static</span> <span class="idnt">IDisposable</span> CreateLocalInstance(<span class="idnt">IConfigurationProvider</span> localProvider)<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_localProvider = localProvider;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">return new</span> <span class="idnt">DisposableAction</span>(<span class="kwrd">delegate</span><br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_localProvider = <span class="kwrd">null</span>;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;});<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;...<br />
}<br />
</pre>
</div>

I actually added two things in this code block. First, I created the CreateLocalInstance method that uses a DisposableAction. It sets the private \_localProvider to what was passed in. Next, it returns a DisposableAction with an anonymous method callback to set the \_localProvider back to null. 

The other change I made was I modified the GetInstance method to be aware of the _localProvider variable and return it instead. The effect is a using block calling the CreateLocalInstance will make the GetInstance method return the new local IConfigurationProvider instead. 

### Closing comments

I was able to change the configuration code inside the GetCustomerOrders to use an abstraction of the IConfigurationProvider and created a factory which allowed me to inject custom IConfigurationProvider implementations without affecting any production code. And, I was able to take advantage of IDisposable and the using statement to do this. Obviously, I&#8217;ll need additional tests to confirm existing functionality isn&#8217;t broken. 

But my test passes, and in the meantime I&#8217;ve opened the DatabaseReader class for extensibility for other IConfigurationProvider implementations, like one from pulling from the database or from SiteInfo.