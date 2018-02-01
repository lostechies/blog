---
id: 65
title: NHibernate + XML Columns
date: 2009-01-14T04:42:05+00:00
author: Joey Beninghove
layout: post
guid: /blogs/joeydotnet/archive/2009/01/13/nhibernate-xml-columns.aspx
categories:
  - NHibernate
---
One of the things I’ve been working on recently involves using XML columns in SQL Server.&#160; Starting out, it was simple and I was just doing vanilla ADO.NET (wrapped in a simple Query API) combined with XML serialization/deserialization, which worked pretty well for a while.&#160; 

But as the complexity has grown, it seemed like too much time was being spent enhancing the persistence infrastructure in this particular area of the application.&#160; In comes NHibernate, which is already integrated and available to me on this particular project.&#160; In fact, the only reason I didn’t use NHibernate for this particular feature from day one is because I didn’t see a lot of information available regarding NHibernate and XML columns.&#160; I did find one [old blog post by Ayende](http://ayende.com/Blog/archive/2006/05/30/NHibernateAndXMLColumnTypes.aspx) and a [seemingly outdated article](http://www.hibernate.org/368.html) on the NHibernate site.&#160; But I admit I’ve never jumped into creating custom user types in NHibernate and wasn’t yet comfortable moving forward with that approach.&#160; Since what I needed at the time was pretty simple, I went forward without NHibernate for the time being.

Without going into too much detail, I came to a point where I wanted to spike with NHibernate to see how it handles columns with an XML data type.&#160; I’ve only tried one of a couple approaches so far, but wanted to get some feedback on it so far.

First, a couple goals:

  * Store a set of data as XML in a SQL Server XML column 
  * Ability to deserialize the XML into strongly typed objects for use in the rest of the code base 

Warning: contrived example ahead.&#160; The real implementation is basically for lightweight messages.

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Person</pre>
    
    <pre><span style="color: #606060">   2:</span> {</pre>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> <span style="color: #0000ff">string</span> contactInformationXml;</pre>
    
    <pre><span style="color: #606060">   4:</span>&#160; </pre>
    
    <pre><span style="color: #606060">   5:</span>     <span style="color: #0000ff">public</span> Person(ContactInformation contactInformation)</pre>
    
    <pre><span style="color: #606060">   6:</span>     {</pre>
    
    <pre><span style="color: #606060">   7:</span>         <span style="color: #008000">// NOTE: SerializeToXmlStream extension method not shown</span></pre>
    
    <pre><span style="color: #606060">   8:</span>         contactInformationXml =</pre>
    
    <pre><span style="color: #606060">   9:</span>             <span style="color: #0000ff">new</span> StreamReader(contactInformation.SerializeToXmlStream()).ReadToEnd();</pre>
    
    <pre><span style="color: #606060">  10:</span>     }</pre>
    
    <pre><span style="color: #606060">  11:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  12:</span>     <span style="color: #0000ff">public</span> ContactInformation GetContactInformation()</pre>
    
    <pre><span style="color: #606060">  13:</span>     {</pre>
    
    <pre><span style="color: #606060">  14:</span>         var xmlDocument = <span style="color: #0000ff">new</span> XmlDocument();</pre>
    
    <pre><span style="color: #606060">  15:</span>         xmlDocument.Load(contactInformationXml);</pre>
    
    <pre><span style="color: #606060">  16:</span>&#160; </pre>
    
    <pre><span style="color: #606060">  17:</span>         <span style="color: #008000">// NOTE: DeserializeInto extension method not shown</span></pre>
    
    <pre><span style="color: #606060">  18:</span>         <span style="color: #0000ff">return</span> xmlDocument.DeserializeInto&lt;ContactInformation&gt;();</pre>
    
    <pre><span style="color: #606060">  19:</span>     }</pre>
    
    <pre><span style="color: #606060">  20:</span> }</pre></p>
  </div>
</div>

And an excerpt from an example NHibernate mapping for this:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">&lt;</span><span style="color: #800000">property</span> <span style="color: #ff0000">name</span><span style="color: #0000ff">="ContactInformationXml"</span> <span style="color: #ff0000">column</span><span style="color: #0000ff">="ContactInformation"</span> </pre>
    
    <pre><span style="color: #606060">   2:</span>           <span style="color: #ff0000">type</span><span style="color: #0000ff">="String"</span> <span style="color: #ff0000">not-null</span><span style="color: #0000ff">="true"</span> <span style="color: #ff0000">access</span><span style="color: #0000ff">="field.camelcase"</span> <span style="color: #0000ff">/&gt;</span></pre></p>
  </div>
</div>

So in the Person class above, the constructor accepts a strongly typed component for the contact information, serializes it to XML and stores it in a private field as a string.&#160; Then the NHibernate mapping takes care of persisting the serialized string to the XML column named ContactInformation in the database.&#160; To see how it would get used when NHibernate loads a Person, the GetContactInformation() method is an example of deserializing the string into the strongly typed ContactInformation object which it then returns.

Now, putting aside the reasons for or against using XML in this way, using XML columns in general or the fact that serialization concerns shouldn’t be placed inside a class like this…

I’m looking for feedback on this approach and if anyone else has any better ways of doing this.&#160; I’ve yet to go down the path of creating a custom NHibernate user type, even though I think doing it that way would be a bit cleaner and flexible in the future.

Anyone have any other good examples of using NHibernate for persisting data to XML columns?