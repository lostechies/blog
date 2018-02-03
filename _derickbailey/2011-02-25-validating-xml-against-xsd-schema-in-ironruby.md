---
wordpress_id: 217
title: Validating Xml Against XSD Schema In IronRuby
date: 2011-02-25T04:06:35+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2011/02/24/validating-xml-against-xsd-schema-in-ironruby.aspx
dsq_thread_id:
  - "262106527"
categories:
  - .NET
  - IronRuby
  - Ruby
---
There&#8217;s a thousand examples of how to validate an xml document against an xsd schema in C# around the web, but I had a hard time finding one that worked in IronRuby. So I translated some of the C# examples I found into a working IronRuby version.<span style="line-height: 0px">﻿</span>

> <pre><div class="line">
  <span class="k">class</span> <span class="nc">XmlValidator</span>
</div>

<div class="line">
    <span class="nb">require</span> <span class="s1">'System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'</span>
</div>

<div class="line">
    <span class="nb">require</span> <span class="s1">'System.Xml, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'<br /> </span>
</div>

<div class="line">
    <span class="kp">include</span> <span class="no">System</span><span class="o">::</span><span class="no">Xml</span>
</div>

<div class="line">
    <span class="kp">include</span> <span class="no">System</span><span class="o">::</span><span class="no">Xml</span><span class="o">::</span><span class="no">Schema</span>
</div>

<div class="line">
    <span class="kp">include</span> <span class="no">System</span><span class="o">::</span><span class="no">IO<br /> </span>
</div>

<div class="line">
    <span class="k">def</span> <span class="nc">self</span><span class="o">.</span><span class="nf">validate</span><span class="p">(</span><span class="n">xml</span><span class="p">,</span> <span class="n">xsd_file</span><span class="p">)</span>
</div>

<div class="line">
      <span class="n">settings</span> <span class="o">=</span> <span class="no">XmlReaderSettings</span><span class="o">.</span><span class="n">new</span>
</div>

<div class="line">
      <span class="n">settings</span><span class="o">.</span><span class="n">validation_type</span> <span class="o">=</span> <span class="no">ValidationType</span><span class="o">.</span><span class="n">Schema</span><span class="p">;</span>
</div>

<div class="line">
      <span class="n">settings</span><span class="o">.</span><span class="n">schemas</span><span class="o">.</span><span class="n">add</span><span class="p">(</span><span class="kp">nil</span><span class="p">,</span> <span class="n">xsd_file</span><span class="p">)<br /> </span>
</div>

<div class="line">
      <span class="n">is_valid</span> <span class="o">=</span> <span class="kp">true</span>
</div>

<div class="line">
      <span class="n">settings</span><span class="o">.</span><span class="n">validation_event_handler</span> <span class="p">{</span> <span class="o">|</span><span class="n">s</span><span class="p">,</span> <span class="n">e</span><span class="o">|</span>
</div>

<div class="line">
        <span class="n">is_valid</span> <span class="o">=</span> <span class="kp">false</span> <span class="k">if</span> <span class="n">e</span><span class="o">.</span><span class="n">severity</span> <span class="o">==</span> <span class="no">XmlSeverityType</span><span class="o">.</span><span class="n">error</span>
</div>

<div class="line">
      <span class="p">}<br /> </span>
</div>

<div class="line">
      <span class="n">reader</span> <span class="o">=</span> <span class="no">XmlReader</span><span class="o">.</span><span class="n">create</span><span class="p">(</span><span class="no">StringReader</span><span class="o">.</span><span class="n">new</span><span class="p">(</span><span class="n">xml</span><span class="p">),</span> <span class="n">settings</span><span class="p">)</span>
</div>

<div class="line">
      <span class="k">while</span> <span class="n">reader</span><span class="o">.</span><span class="n">read</span>
</div>

<div class="line">
      <span class="k">end<br /> </span>
</div>

<div class="line">
      <span class="k">return</span> <span class="n">is_valid</span>
</div>

<div class="line">
    <span class="k">end</span>
</div>

<div class="line">
  <span class="k">end</span>
</div></pre>

This code runs against IronRuby 1.0 or higher, and runs against the .NET 2.0 versions of System and System.Xml assemblies. Here&#8217;s the example that I wrote to ensure this works:

> <pre><div class="line">
  <span class="n">xsd_file</span> <span class="o">=</span> <span class="s2">"schema.xsd"<br /> </span>
</div>

<div class="line">
  <span class="n">xml</span> <span class="o">=</span> <span class="s2">"&lt;some&gt;&lt;data&gt;goes here&lt;/data&gt;&lt;/some&gt;"</span>
</div>

<div class="line">
  <span class="nb">puts</span> <span class="no">XmlValidator</span><span class="o">.</span><span class="n">validate</span><span class="p">(</span><span class="n">xml</span><span class="p">,</span> <span class="n">xsd_file</span><span class="p">)</span> <span class="c1"># =&gt; true</span>
</div>

<div class="line">
  <span class="n"><br />xml2</span> <span class="o">=</span> <span class="s2">"&lt;something&gt;&lt;that&gt;should fail&lt;/that&gt;&lt;/something&gt;"</span>
</div>

<div class="line">
  <span class="nb">puts</span> <span class="no">XmlValidator</span><span class="o">.</span><span class="n">validate</span><span class="p">(</span><span class="n">xml2</span><span class="p">,</span> <span class="n">xsd_file</span><span class="p">)</span> <span class="c1"># =&gt; false</span>
</div></pre>

And here&#8217;s the schema file used to validate the xml:

> <pre><div class="line">
  <span class="cp">&lt;?xml version="1.0"?&gt;</span>
</div>

<div class="line">
  <span class="nt">&lt;xsd:schema</span> <span class="na">xmlns:xsd=</span><span class="s">"http://www.w3.org/2001/XMLSchema"</span><span class="nt">&gt;</span>
</div>

<div class="line">
     <span class="nt">&lt;xsd:element</span> <span class="na">name=</span><span class="s">"some"</span><span class="nt">&gt;</span>
</div>

<div class="line">
        <span class="nt">&lt;xsd:complexType&gt;</span>
</div>

<div class="line">
           <span class="nt">&lt;xsd:sequence&gt;</span>
</div>

<div class="line">
              <span class="nt">&lt;xsd:element</span> <span class="na">name=</span><span class="s">"data"</span> <span class="na">type=</span><span class="s">"xsd:string"</span><span class="nt">/&gt;</span>
</div>

<div class="line">
           <span class="nt">&lt;/xsd:sequence&gt;</span>
</div>

<div class="line">
        <span class="nt">&lt;/xsd:complexType&gt;</span>
</div>

<div class="line">
     <span class="nt">&lt;/xsd:element&gt;</span>
</div>

<div class="line">
  <span class="nt">&lt;/xsd:schema&gt;</span>
</div></pre>

For a syntax-highlited version of all this, [see this Gist](https://gist.github.com/843340).