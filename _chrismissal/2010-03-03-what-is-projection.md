---
wordpress_id: 3378
title: What is Projection?
date: 2010-03-03T07:22:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2010/03/03/what-is-projection.aspx
dsq_thread_id:
  - "262175142"
categories:
  - Communication
  - LINQ
  - Reading Code
redirect_from: "/blogs/chrismissal/archive/2010/03/03/what-is-projection.aspx/"
---
I think there&rsquo;s great benefit in not only knowing how to design your code to use common patterns but also to be able to speak about them clearly and concisely to others. If I mention that the problem sounds like it could be solved using the Strategy Pattern, somebody who knows what I&rsquo;m talking about shouldn&rsquo;t need much more of an explanation than that. Knowing certain terms in code will help with communication. Obviously, the better your team is at communicating, the more successful you&rsquo;re going to be.

### Very Simple Projection

I&rsquo;ve seen the following code all over the place. It&rsquo;s very common to turn one collection into another or loop through and capture certain properties of the items you&rsquo;re enumerating. How often have you seen this code:

<div style="border: 1px solid silver;margin: 20px 0px 10px;padding: 4px;overflow: auto;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 97.5%;font-family: 'Courier New',courier,monospace;direction: ltr;font-size: 8pt;cursor: text">
  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #0000ff">public</span> IList&lt;<span style="color: #0000ff">string</span>&gt; GetNames(IEnumerable&lt;Person&gt; people)<br />{<br />    IList&lt;<span style="color: #0000ff">string</span>&gt; names = <span style="color: #0000ff">new</span> List&lt;<span style="color: #0000ff">string</span>&gt;();<br />    <span style="color: #0000ff">foreach</span> (var person <span style="color: #0000ff">in</span> people)<br />    {<br />        names.Add(person.Name);<br />    }<br />    <span style="color: #0000ff">return</span> names;<br />}<br /></pre>
  
  <p>
    </div> 
    
    <p>
      This is simple projection, but languages are seemingly giving you better ways to achieve this same thing. I&rsquo;ll get to that later.
    </p>
    
    <h3>
      Different types of projection
    </h3>
    
    <p>
      I see three basic types of projection. There are variations of these same ideas, but for the most part these cover the bulk.
    </p>
    
    <ul>
      <li>
        <b>Selection: </b>Imagine you have a collection of customers and you want only the email addresses, this is where selection projection would be used. This isn&rsquo;t always a one-to-one relationship, your customers may have more than one email address (if you allow it) and you&rsquo;ll end up with more items in the projected collection than the starting collection. <p>
          </li> 
          
          <li>
            <b>Creational:</b> This is the type of projection that returns new values from an existing collection. Below, you&rsquo;ll see two concrete examples in C#. <p>
              </li> 
              
              <li>
                <b>Transformation: </b>Given a list of numbers, you want those numbers squared. This is similar to creational, because you&#8217;ll be getting a new item, but it shouldn&rsquo;t modify the elements in the original collection.
              </li></ul> 
              
              <h3>
                Projection with LINQ in C#
              </h3>
              
              <p>
                An example that lends itself well to the concept of projection is the following:
              </p>
              
              <blockquote>
                <p>
                  My user interface allows strings to come into my application. I want to transform these strings into tags like any blog post, video or photo might have assigned to it. I don&rsquo;t want my tag service class to have to deal with strings, I want to give it a collection of Tag objects. How do I do this?
                </p>
              </blockquote>
              
              <p>
                With LINQ, this creational projection was very simple:
              </p>
              
              <div style="border: 1px solid silver;margin: 20px 0px 10px;padding: 4px;overflow: auto;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 97.5%;font-family: 'Courier New',courier,monospace;direction: ltr;font-size: 8pt;cursor: text">
                <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> SaveTags(IEnumerable&lt;<span style="color: #0000ff">string</span>&gt; tagNames)<br />{<br />    var tags = tagNames.Select(name =&gt; <span style="color: #0000ff">new</span> Tag(name));<br />    tagService.SaveOrUpdateTags(tags);<br />}</pre>
                
                <p>
                  </div> 
                  
                  <p>
                    Another great use of creational projection are some of the usages I&rsquo;ve seen with SelectListItems in the ASP.NET MVC space. Given a list of objects, create a list of HTML drop down items for a select list.
                  </p>
                  
                  <p>
                    K. Scott Allen has a good write up entitled <a href="http://odetocode.com/Blogs/scott/archive/2010/01/18/drop-down-lists-and-asp-net-mvc.aspx">Drop-down Lists and ASP.NET MVC</a> on this very thing. There are also many good examples over on the <a href="http://msdn.microsoft.com/en-us/vcsharp/aa336758.aspx">MSDN Visual C# Developer Center</a>.
                  </p>
                  
                  <h3>
                    Your Thoughts on Projection&hellip;
                  </h3>
                  
                  <p>
                    I see this pattern often enough but I don&rsquo;t hear the term &ldquo;projection&rdquo; nearly as often. Is there a more common name to this that I&rsquo;m not hearing or are people just not referring to it by this name?
                  </p>