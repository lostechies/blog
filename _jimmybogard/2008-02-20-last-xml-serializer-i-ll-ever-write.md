---
wordpress_id: 144
title: 'Last XML serializer I&#8217;ll ever write'
date: 2008-02-20T03:35:28+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/02/19/last-xml-serializer-i-ll-ever-write.aspx
dsq_thread_id:
  - "264715561"
categories:
  - 'C#'
---
I&#8217;ve made this class probably a half dozen times, and I&#8217;m getting pretty tired of writing it.&nbsp; It seems like every application I write has to serialize and deserialize back and forth between XML strings and objects.&nbsp; For future reference, here it is:

<pre><span style="color: blue">public static class </span><span style="color: #2b91af">XmlSerializationHelper
</span>{
    <span style="color: blue">public static string </span>Serialize&lt;T&gt;(T value)
    {
        <span style="color: #2b91af">XmlSerializer </span>xmlSerializer = <span style="color: blue">new </span><span style="color: #2b91af">XmlSerializer</span>(<span style="color: blue">typeof</span>(T));
        <span style="color: #2b91af">StringWriter </span>writer = <span style="color: blue">new </span><span style="color: #2b91af">StringWriter</span>();
        xmlSerializer.Serialize(writer, value);

        <span style="color: blue">return </span>writer.ToString();
    }

    <span style="color: blue">public static </span>T Deserialize&lt;T&gt;(<span style="color: blue">string </span>rawValue)
    {
        <span style="color: #2b91af">XmlSerializer </span>xmlSerializer = <span style="color: blue">new </span><span style="color: #2b91af">XmlSerializer</span>(<span style="color: blue">typeof</span>(T));
        <span style="color: #2b91af">StringReader </span>reader = <span style="color: blue">new </span><span style="color: #2b91af">StringReader</span>(rawValue);

        T value = (T)xmlSerializer.Deserialize(reader);
        <span style="color: blue">return </span>value;
    }
}
</pre>

[](http://11011.net/software/vspaste)

I like this implementation as it&#8217;s generic so it removes some casting from the user.&nbsp; Yeah, I know this code is probably in a hundred other blogs.&nbsp; But at least now I know exactly where to find it.