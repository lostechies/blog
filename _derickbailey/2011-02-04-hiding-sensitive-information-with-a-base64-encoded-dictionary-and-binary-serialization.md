---
wordpress_id: 213
title: Hiding Sensitive Information With A Base64 Encoded Dictionary And Binary Serialization
date: 2011-02-04T17:28:15+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2011/02/04/hiding-sensitive-information-with-a-base64-encoded-dictionary-and-binary-serialization.aspx
dsq_thread_id:
  - "262106517"
categories:
  - .NET
  - 'C#'
  - Data Access
redirect_from: "/blogs/derickbailey/archive/2011/02/04/hiding-sensitive-information-with-a-base64-encoded-dictionary-and-binary-serialization.aspx/"
---
I&#8217;ve been back in C# land for the last few weeks writing a small Winforms application that runs from a USB thumb drive.

 

## Need To Hide Some Data?

We have a need to store some slightly-sensitive information that changes whenever the app has an internet connection and is able to download updates. It&#8217;s nothing that needs true security with encryption, username & password, or anything like that. And there&#8217;s no existing database / data access in the app, so we don&#8217;t have a password protected database to dump it in, either.

We thought about several different options to handle our needs:

  * Ignore the possibility of someone reading / modifying the data. It&#8217;s not likely, and not super critical. Probably not a good choice.
  * Use a simple database like db4o or sqlite. Too much setup and extra work since we don&#8217;t need data access anywhere else.
  * Use .NET&#8217;s Isolated Storage. Great idea, but we can&#8217;t store data based on user. Any user with the thumb drive has to be able to get to it.
  * Real encryption / decryption and writing to a file. This is probably the best idea, honestly. The code to encrypt / decrypt a string isn&#8217;t that bad.

Given the simple needs of the situation, I found it was easiest to build a custom Dictionary class that base64 encodes all of the keys and values, and is able to read / write itself to a binary serialized file. It&#8217;s a simple chunk of code and it provides a small amount of information hiding that suits our needs just fine. If you do need a little more security, you could easily replace the base64 encode/decode with some type of encrypt/decrypt.

 

## A Base64Dictionary With Binary Serialization

The class is inheriting from a Dictionary<string, string> and I&#8217;m only overwriting the indexer because I&#8217;m not using any other methods to get data into or out of the dictionary at this point.

> <pre><pre><div class="line">
  <span class="k">public</span> <span class="kt">string</span> <span class="k">this</span><span class="p">[</span><span class="kt">string</span> <span class="n">key</span><span class="p">]</span>
</div>

<div class="line">
  <span class="p">{</span>
</div>

<div class="line">
      <span class="k">get</span>
</div>

<div class="line">
      <span class="p">{</span>
</div>

<div class="line">
          <span class="n">var</span> <span class="n">encoded_key</span> <span class="p">=</span> <span class="n">Convert</span><span class="p">.</span><span class="n">ToBase64String</span><span class="p">(</span><span class="n">Encoding</span><span class="p">.</span><span class="n">UTF8</span><span class="p">.</span><span class="n">GetBytes</span><span class="p">(</span><span class="n">key</span><span class="p">));</span>
</div>

<div class="line">
          <span class="n">var</span> <span class="n">encoded_value</span> <span class="p">=</span> <span class="k">base</span><span class="p">[</span><span class="n">encoded_key</span><span class="p">];</span>
</div>

<div class="line">
          <span class="k">return</span> <span class="n">Encoding</span><span class="p">.</span><span class="n">UTF8</span><span class="p">.</span><span class="n">GetString</span><span class="p">(</span><span class="n">Convert</span><span class="p">.</span><span class="n">FromBase64String</span><span class="p">(</span><span class="n">encoded_value</span><span class="p">));</span>
</div>

<div class="line">
      <span class="p">}</span>
</div>

<div class="line">
      <span class="k">set</span> 
</div>

<div class="line">
      <span class="p">{</span> 
</div>

<div class="line">
          <span class="n">var</span> <span class="n">encoded_key</span> <span class="p">=</span> <span class="n">Convert</span><span class="p">.</span><span class="n">ToBase64String</span><span class="p">(</span><span class="n">Encoding</span><span class="p">.</span><span class="n">UTF8</span><span class="p">.</span><span class="n">GetBytes</span><span class="p">(</span><span class="n">key</span><span class="p">));</span>
</div>

<div class="line">
          <span class="n">var</span> <span class="n">encoded_value</span> <span class="p">=</span> <span class="n">Convert</span><span class="p">.</span><span class="n">ToBase64String</span><span class="p">(</span><span class="n">Encoding</span><span class="p">.</span><span class="n">UTF8</span><span class="p">.</span><span class="n">GetBytes</span><span class="p">(</span><span class="k">value</span><span class="p">));</span>
</div>

<div class="line">
          <span class="k">base</span><span class="p">[</span><span class="n">encoded_key</span><span class="p">]</span> <span class="p">=</span> <span class="n">encoded_value</span><span class="p">;</span>
</div>

<div class="line">
      <span class="p">}</span>
</div>

<div class="line">
  <span class="p">}</span>
</div></pre>
</blockquote>


<p>
  I also have a WriteTo(file) and ReadFrom(file) method set up. This is where the binary serialization / deserialization occurs.
</p>


<blockquote>
  <pre><pre><div class="line">
  <span class="k">public</span> <span class="k">void</span> <span class="nf">WriteTo</span><span class="p">(</span><span class="kt">string</span> <span class="n">file</span><span class="p">)</span>
</div>

<div class="line">
  <span class="p">{</span>
</div>

<div class="line">
      <span class="n">IFormatter</span> <span class="n">formatter</span> <span class="p">=</span> <span class="k">new</span> <span class="n">BinaryFormatter</span><span class="p">();</span>
</div>

<div class="line">
      <span class="k">using</span> <span class="p">(</span><span class="n">Stream</span> <span class="n">stream</span> <span class="p">=</span> <span class="k">new</span> <span class="n">FileStream</span><span class="p">(</span><span class="n">file</span><span class="p">,</span> <span class="n">FileMode</span><span class="p">.</span><span class="n">Create</span><span class="p">,</span> <span class="n">FileAccess</span><span class="p">.</span><span class="n">Write</span><span class="p">,</span> <span class="n">FileShare</span><span class="p">.</span><span class="n">None</span><span class="p">))</span>
</div>

<div class="line">
      <span class="p">{</span>
</div>

<div class="line">
          <span class="n">formatter</span><span class="p">.</span><span class="n">Serialize</span><span class="p">(</span><span class="n">stream</span><span class="p">,</span> <span class="k">this</span><span class="p">);</span>
</div>

<div class="line">
      <span class="p">}</span>
</div>

<div class="line">
  <span class="p">}</span>
</div>

<div class="line">
          
</div>

<div class="line">
  <span class="k">public</span> <span class="k">static</span> <span class="n">Base64Dictionary</span> <span class="nf">ReadFrom</span><span class="p">(</span><span class="kt">string</span> <span class="n">file</span><span class="p">)</span>
</div>

<div class="line">
  <span class="p">{</span>
</div>

<div class="line">
      <span class="n">Base64Dictionary</span> <span class="n">obj</span><span class="p">;</span>
</div>

<div class="line">
      <span class="n">IFormatter</span> <span class="n">formatter</span> <span class="p">=</span> <span class="k">new</span> <span class="n">BinaryFormatter</span><span class="p">();</span>
</div>

<div class="line">
      <span class="k">using</span> <span class="p">(</span><span class="n">Stream</span> <span class="n">stream</span> <span class="p">=</span> <span class="k">new</span> <span class="n">FileStream</span><span class="p">(</span><span class="n">file</span><span class="p">,</span> <span class="n">FileMode</span><span class="p">.</span><span class="n">Open</span><span class="p">,</span> <span class="n">FileAccess</span><span class="p">.</span><span class="n">Read</span><span class="p">,</span> <span class="n">FileShare</span><span class="p">.</span><span class="n">Read</span><span class="p">))</span>
</div>

<div class="line">
      <span class="p">{</span>
</div>

<div class="line">
          <span class="n">obj</span> <span class="p">=</span> <span class="p">(</span><span class="n">Base64Dictionary</span><span class="p">)</span> <span class="n">formatter</span><span class="p">.</span><span class="n">Deserialize</span><span class="p">(</span><span class="n">stream</span><span class="p">);</span>
</div>

<div class="line">
      <span class="p">}</span>
</div>

<div class="line">
      <span class="k">return</span> <span class="n">obj</span><span class="p">;</span>
</div>

<div class="line">
  <span class="p">}</span>
</div></pre>
</blockquote>


<p>
  Note that the ReadFrom(file) method is a static method. This lets you call Base64Dictionary.ReadFrom(file) directly and not have to instantiate a Base64Dictionary object first. The only other detail is to include the [Serializable] attribute and a deserialization constructor. After that, you can start writing and reading binary serialized files that hide the data in them a little.
</p>


<p>
   
</p>


<h2>
  No, It&#8217;s Not Secure
</h2>


<p>
  Remember, this is not a secure way of storing critical data. It&#8217;s only meant to hide the data from prying eyes. Anyone with half a sense of code could easily figure out the data is base64 encoded and decode it, gaining access to it.
</p>


<p>
  For the complete code, including a simple example of using it, <a href="https://gist.github.com/811336">see this gist</a>.
</p>