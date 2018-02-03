---
wordpress_id: 218
title: Convention, configuration and WCF
date: 2008-08-18T23:56:29+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/08/18/convention-configuration-and-wcf.aspx
dsq_thread_id:
  - "266052352"
categories:
  - WCF
---
Convention is something that&#8217;s fairly lacking in WCF.&nbsp; Here&#8217;s what I&#8217;d like to do:

<pre>[<span style="color: #2b91af">ServiceContract</span>]
<span style="color: blue">public interface </span><span style="color: #2b91af">ICustomerSearch
</span>{
    <span style="color: #2b91af">Customer </span>FindCustomerByName(<span style="color: blue">string </span>name);
}

<span style="color: blue">public class </span><span style="color: #2b91af">Customer
</span>{
    <span style="color: blue">public string </span>Name { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    <span style="color: blue">public </span><span style="color: #2b91af">CustomerType </span>Type { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}

<span style="color: blue">public enum </span><span style="color: #2b91af">CustomerType
</span>{
    Good,
    Canadian
}
</pre>

[](http://11011.net/software/vspaste)

I understand maybe just that one attribute.&nbsp; Here&#8217;s what I&#8217;m forced to do:

<pre>[<span style="color: #2b91af">ServiceContract</span>]
<span style="color: blue">public interface </span><span style="color: #2b91af">ICustomerSearch
</span>{
    [<span style="color: #2b91af">OperationContract</span>]
    <span style="color: #2b91af">Customer </span>FindCustomerByName(<span style="color: blue">string </span>name);
}

[<span style="color: #2b91af">DataContract</span>]
<span style="color: blue">public class </span><span style="color: #2b91af">Customer
</span>{
    [<span style="color: #2b91af">DataMember</span>]
    <span style="color: blue">public string </span>Name { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
    [<span style="color: #2b91af">DataMember</span>]
    <span style="color: blue">public </span><span style="color: #2b91af">CustomerType </span>Type { <span style="color: blue">get</span>; <span style="color: blue">set</span>; }
}

<span style="color: blue">public enum </span><span style="color: #2b91af">CustomerType
</span>{
    Good,
    Canadian
}
</pre>

[](http://11011.net/software/vspaste)

All those noisy attributes, none adding any information nor functionality.&nbsp; What&#8217;s consistently bothered me the most is how much configuration is necessary to get straightforward scenarios working.&nbsp; I&#8217;m tired of opting-in to every single piece of information on the contract side.&nbsp; I want to point to an interface, and just let the framework figure out the rest.

On the plus side, lots of vendors recognized this and [created products](http://www.neudesic.com/Main.aspx?SS=7&PE=75) on top of WCF to make it usable.&nbsp; Good for them.