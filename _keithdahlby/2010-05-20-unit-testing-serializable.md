---
id: 4211
title: 'Unit Testing [Serializable]'
date: 2010-05-20T12:11:00+00:00
author: Keith Dahlby
layout: post
guid: /blogs/dahlbyk/archive/2010/05/20/unit-testing-serializable.aspx
dsq_thread_id:
  - "262493344"
categories:
  - NUnit
  - Serializable
  - Testing
---
<div class="content">
  <div class="snap_preview">
    <p>
      A common struggle with unit testing is<br /> figuring when to just assume somebody else&rsquo;s code works. One such example<br /> is serializability: for simple classes, it should &ldquo;just work&rdquo; so we<br /> shouldn&rsquo;t need to write a unit test for each of them. However, I still<br /> wanted to be able to verify that all classes in certain namespaces were<br /> marked as <code>[Serializable]</code>, so I wrote the following test:
    </p>
    
    <pre>[TestCase(typeof(Money), "Solutionizing.Domain")]<br />[TestCase(typeof(App), "Solutionizing.Web.Models")]<br />public void Types_should_be_Serializable(Type sampleType, string @namespace)<br />{<br />    var assembly = sampleType.Assembly;<br /><br />    var unserializableTypes = (<br />        from t in assembly.GetTypes()<br />        where t.Namespace != null && t.Namespace.StartsWith(@namespace, StringComparison.Ordinal)<br />        where !t.IsSerializable && ShouldBeSerializable(t)<br />        select t<br />        ).ToArray();<br /><br />    unserializableTypes.ShouldBeEmpty();<br />}</pre>
    
    <p>
      After we have a reference to the <code>Assembly</code> under test, we<br /> use a LINQ to Objects query against its types. If a type matches our<br /> namespace filter, we make sure it&rsquo;s serializable if it should be.<br /> Finally, by using <code>ToArray()</code> and <code>ShouldBeEmpty()</code><br /> we&rsquo;re given a nice error message if the test fails:
    </p>
    
    <pre>TestCase 'Solutionizing.Tests.SerializabilityTests.Types_should_be_Serializable(Solutionizing.Domain.Money, Solutionizing.Domain)'<br />failed:<br /> Expected: &lt;empty&gt;<br /> But was:&nbsp; &lt; &lt;Solutionizing.Domain.Oops&gt;, &lt;Solutionizing.Domain.OopsAgain&gt; &gt;<br /> SerializabilityTests.cs(29,0): at Solutionizing.Tests.SerializabilityTests.Types_should_be_Serializable(Type sampleType, String namespace)<br /></pre>
    
    <p>
      I use a few criteria to determine if I expect the type to be<br /> serializable:
    </p>
    
    <pre>private bool ShouldBeSerializable(Type t)<br />{<br />    if (IsExempt(t))<br />        return false;<br />    if (t.IsAbstract && t.IsSealed) // Static class<br />        return false;<br />    if (t.IsInterface)<br />        return false;<br />    if (!t.IsPublic)<br />        return false;<br /><br />    return true;<br />}<br /></pre>
    
    <p>
      Other than <code>IsExempt()</code>, the code should be more or less<br /> self-explanatory. If you had never bothered to check how static classes<br /> are represented in IL, now you know: abstract (can&rsquo;t be instantiated) +<br /> sealed (can&rsquo;t be inherited). Also, note that <code>!IsPublic</code> will<br /> cover compiler-generated classes for iterators and closures that we<br /> don&rsquo;t need to serialize.
    </p>
    
    <p>
      The final piece is providing a way we can exempt certain classes from<br /> being tested:
    </p>
    
    <pre>private bool IsExempt(Type t)<br />{<br />    return exemptTypes.Any(e =&gt; e.IsAssignableFrom(t));<br />}<br /><br />private Type[] exemptTypes = new []<br />{<br />    typeof(SomeClassWithDictionary), // Wrapped dictionary is not serializable<br />    typeof(Attribute) // Metadata are never serialized<br />};</pre>
    
    <p>
      Of course, this isn&rsquo;t a replacement for actually testing that custom<br /> serialization works correctly for more complicated objects, particularly<br /> if your classes may depend on others that aren&rsquo;t covered by these<br /> tests. But I have still found this test to be a useful first level of<br /> protection.
    </p>
  </div>
</div>