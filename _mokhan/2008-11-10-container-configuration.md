---
wordpress_id: 24
title: Container Configuration
date: 2008-11-10T02:20:11+00:00
author: Mo Khan
layout: post
wordpress_guid: /blogs/mokhan/archive/2008/11/09/container-configuration.aspx
categories:
  - Design Patterns
redirect_from: "/blogs/mokhan/archive/2008/11/09/container-configuration.aspx/"
---
In [my last post](http://mokhan.ca/blog/2008/11/09/Lazy+Loaded+Interceptors.aspx) I briefly mentioned how we were wiring some components in to our container.&nbsp; The syntax looked like the following:

<pre>container.AddProxyOf(
                <span class="kwrd">new</span> ReportPresenterTaskConfiguration(), 
                <span class="kwrd">new</span> ReportPresenterTask(
                    Lazy.Load&lt;IReportDocumentBuilder&gt;(),
                    Lazy.Load&lt;IApplicationSettings&gt;())
                    );</pre>

We&#8217;re using [Castle Windsor](http://www.castleproject.org/container/index.html) under the hood, but we have an abstraction over it that allows us to configure it as we like. Even switching the underlying implementation. Which we did, from our hand rolled container to Castle Windsor. The implementation of the above method looks as follows:

<pre><span class="kwrd">public</span> <span class="kwrd">void</span> AddProxyOf&lt;Interface, Target&gt;(IProxyConfiguration&lt;Interface&gt; configuration, Target instance)
            <span class="kwrd">where</span> Target : Interface
        {
            var builder = <span class="kwrd">new</span> ProxyBuilder&lt;Interface&gt;();
            configuration.Configure(builder);
            AddInstanceOf(builder.CreateProxyFor(instance));
        }</pre>

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }

[Wikipedia defines the Proxy design pattern as](http://en.wikipedia.org/wiki/Proxy_pattern):

> A proxy, in its most general form, is a class functioning as an interface to another thing.

To understand the ProxyBuilder<Interface> implementation you can checkout [JP&#8217;s strongly typed selective proxies](http://blog.jpboodhoo.com/ExplicitStronglyTypedSelectiveProxies.aspx). The &#8220;AddProxyOf&#8221; method creates an instance of a proxybuilder. It then passes it to the configuration to allow it to configure the proxy builder before building the proxy. Then it registers the proxy as a singleton in to the container.

<pre><span class="kwrd">public</span> <span class="kwrd">interface</span> IConfiguration&lt;T&gt;
    {
        <span class="kwrd">void</span> Configure(T item_to_configure);
    }</pre>

<pre><span class="kwrd">public</span> <span class="kwrd">interface</span> IProxyConfiguration&lt;T&gt; : IConfiguration&lt;IProxyBuilder&lt;T&gt;&gt;
    {
    }</pre>

In this case the proxy configuration looks like:

<pre><span class="kwrd">public</span> <span class="kwrd">class</span> ReportPresenterTaskConfiguration : IProxyConfiguration&lt;IReportPresenterTask&gt;
    {
        <span class="kwrd">public</span> <span class="kwrd">void</span> Configure(IProxyBuilder&lt;IReportPresenterTask&gt; builder)
        {
            var constraint = builder.AddInterceptor&lt;DisplayProgressBarInterceptor&gt;();
            constraint.InterceptOn.RetrieveAuditReport();
        }
    }</pre>

This guy adds a progress bar interceptor, that displays a progress bar as the report is getting generated via the &#8220;RetrieveAuditReport&#8221; method on the IReportPresenterTask. 

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }

.csharpcode, .csharpcode pre
  
{
	  
font-size: small;
	  
color: black;
	  
font-family: consolas, &#8220;Courier New&#8221;, courier, monospace;
	  
background-color: #ffffff;
	  
/\*white-space: pre;\*/
  
}
  
.csharpcode pre { margin: 0em; }
  
.csharpcode .rem { color: #008000; }
  
.csharpcode .kwrd { color: #0000ff; }
  
.csharpcode .str { color: #006080; }
  
.csharpcode .op { color: #0000c0; }
  
.csharpcode .preproc { color: #cc6633; }
  
.csharpcode .asp { background-color: #ffff00; }
  
.csharpcode .html { color: #800000; }
  
.csharpcode .attr { color: #ff0000; }
  
.csharpcode .alt
  
{
	  
background-color: #f4f4f4;
	  
width: 100%;
	  
margin: 0em;
  
}
  
.csharpcode .lnum { color: #606060; }