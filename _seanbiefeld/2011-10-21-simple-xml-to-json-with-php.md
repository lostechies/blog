---
wordpress_id: 30
title: Simple XML to JSON with PHP
date: 2011-10-21T15:14:16+00:00
author: Sean Biefeld
layout: post
wordpress_guid: http://lostechies.com/seanbiefeld/?p=30
dsq_thread_id:
  - "449674327"
categories:
  - JSON
  - PHP
  - Web Service
  - XML
---
<article> 

Hello all, it&#8217;s been a while since I have blogged anything, been extremely busy with personal events in my life. So to get back into the swing of things I am going to KISS this post.



I recently needed to convert XML to JSON in PHP. Thankfully, PHP has built in functionality to handle precisely this task.



First we need to get contents of the XML file, we need to use _file\_get\_contents()_ and pass it the URL to the XML file. We remove the newlines, returns and tabs.

<pre style="background-color:#222;color:#ddd;overflow:auto;padding:20px 10px;font-family:monospace;"><span style="color:#7587A6">$fileContents</span> <span style="color:#CDA869">=</span> file_get_contents<span style="color:#CDA869">(</span><span style="color:#7587A6">$url</span><span style="color:#CDA869">);</span>

<span style="color:#7587A6">$fileContents</span><span style="color:#CDA869"> = </span>str_replace<span style="color:#CDA869">(array(</span><span style="color:#8F9D6A;">"\n"</span><span style="color:#CDA869">,</span> <span style="color:#8F9D6A;">"\r"</span><span style="color:#CDA869">,</span> <span style="color:#8F9D6A;">"\t"</span><span style="color:#CDA869">),</span> <span style="color:#8F9D6A;">''</span><span style="color:#CDA869">,</span> <span style="color:#7587A6">$fileContents</span><span style="color:#CDA869">);</span></pre>



Next I replace double quotes with single quotes and trim leadign and trailing spaces, this helps to ensure the simple XML function can parse the XML appropriately. Then we call the _simplexml\_load\_string()_ function.

<pre style="background-color:#222;color:#ddd;overflow:auto;padding:20px 10px;font-family:monospace;"><span style="color:#7587A6">$fileContents</span> <span style="color:#CDA869">=</span> trim<span style="color:#CDA869">(</span>str_replace<span style="color:#CDA869">(</span><span style="color:#8F9D6A;">'"'</span><span style="color:#CDA869">,</span> <span style="color:#8F9D6A;">"'"</span><span style="color:#CDA869">,</span> <span style="color:#7587A6">$fileContents</span><span style="color:#CDA869">));</span>

<span style="color:#7587A6">$simpleXml</span> <span style="color:#CDA869">=</span> simplexml_load_string<span style="color:#CDA869">(</span><span style="color:#7587A6">$fileContents</span><span style="color:#CDA869">);</span></pre>



The final step we need is to convert the XML to JSON, for that we will use the _json_encode()_ function.

<pre style="background-color:#222;color:#ddd;overflow:auto;padding:20px 10px;font-family:monospace;"><span style="color:#7587A6">$json</span> <span style="color:#CDA869">=</span> json_encode<span style="color:#CDA869">(</span><span style="color:#7587A6"><span style="color:#7587A6">$simpleXml</span><span style="color:#CDA869">);</span></pre>


<p>
  
</p>


<p>
  That&#8217;s it! All together now:
</p>


<pre style="background-color:#222;color:#ddd;overflow:auto;padding:20px 10px;font-family:monospace;">&lt;?php

<span style="color:#CDA869">class</span> XmlToJson <span style="color:#CDA869">{</span>

	<span style="color:#CDA869">public function</span> Parse <span style="color:#CDA869">(</span><span style="color:#7587A6">$url</span><span style="color:#CDA869">) {</span>

		<span style="color:#7587A6">$fileContents</span><span style="color:#CDA869">=</span> file_get_contents<span style="color:#CDA869">(</span><span style="color:#7587A6">$url</span><span style="color:#CDA869">);</span>

		<span style="color:#7587A6">$fileContents</span><span style="color:#CDA869"> = </span>str_replace<span style="color:#CDA869">(array(</span><span style="color:#8F9D6A;">"\n"</span><span style="color:#CDA869">,</span> <span style="color:#8F9D6A;">"\r"</span><span style="color:#CDA869">,</span> <span style="color:#8F9D6A;">"\t"</span><span style="color:#CDA869">),</span> <span style="color:#8F9D6A;">''</span><span style="color:#CDA869">,</span> <span style="color:#7587A6">$fileContents</span><span style="color:#CDA869">);</span>

		<span style="color:#7587A6">$fileContents</span> <span style="color:#CDA869">=</span> trim<span style="color:#CDA869">(</span>str_replace<span style="color:#CDA869">(</span><span style="color:#8F9D6A;">'"'</span><span style="color:#CDA869">,</span> <span style="color:#8F9D6A;">"'"</span><span style="color:#CDA869">,</span> <span style="color:#7587A6">$fileContents</span><span style="color:#CDA869">));</span>

		<span style="color:#7587A6">$simpleXml</span> <span style="color:#CDA869">=</span> simplexml_load_string<span style="color:#CDA869">(</span><span style="color:#7587A6">$fileContents</span><span style="color:#CDA869">);</span>

		<span style="color:#7587A6">$json</span> <span style="color:#CDA869">=</span> json_encode<span style="color:#CDA869">(</span><span style="color:#7587A6">$simpleXml</span><span style="color:#CDA869">);</span>

		<span style="color:#CDA869">return</span> $json<span style="color:#CDA869">;

	}

}</span>

?&gt;
</pre>


<p>
  
</p>


<p>
  Now if we want to utilize our creation we can create a file which uses the class we created above, assuming we store the <em>XmlToJson</em> class in a file named <em>XmlToJson.php</em>. We can create a file for a specific XML web service, include our class and call it <em>XmlToJson::Parse($url)</em>. Just for fun we&#8217;ll point to the XML for the NFL scorestrip.
</p>


<pre style="background-color:#222;color:#ddd;overflow:auto;padding:20px 10px;font-family:monospace;">&lt;?php

<span style="color:#CDA869">include</span> <span style="color:#8F9D6A;">'XmlToJson.php'</span><span style="color:#CDA869">;

print</span> XmlToJson<span style="color:#CDA869">::</span>Parse<span style="color:#CDA869">(</span><span style="color:#8F9D6A;">"http://www.nfl.com/liveupdate/scorestrip/ss.xml"</span><span style="color:#CDA869">);</span>

?&gt;</pre>


<p>
  
</p>


<p>
  Now we can call our new file, say we name it <em>getNflDataAsJson.php</em>, it will return the converted JSON. Calling it from jQuery below:
</p>


<pre style="background-color:#222;color:#ddd;overflow:auto;padding:20px 10px;font-family:monospace;">$.getJSON<span style="color:#CDA869">(</span><span style="color:#8F9D6A;">'getNflDataAsJson.php'</span><span style="color:#CDA869">, function(</span>data<span style="color:#CDA869">) {</span> 
	<span style="color:#5F5A60">//do something</span>
<span style="color:#CDA869">});</span></pre>


<p>
  
</p>


<p>
  Thats all I&#8217;ve got, let me know if you have any questions, things you would do differently or general comments.
</p>


<p>
  <em>Thanks much!</em>
</p>
</article>