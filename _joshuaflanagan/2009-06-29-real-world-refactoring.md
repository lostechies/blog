---
wordpress_id: 3948
title: Real World Refactoring
date: 2009-06-29T00:35:29+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2009/06/28/real-world-refactoring.aspx
dsq_thread_id:
  - "262113180"
categories:
  - composition
  - Design
  - docu
  - StructureMap
redirect_from: "/blogs/joshuaflanagan/archive/2009/06/28/real-world-refactoring.aspx/"
---
If you’ve ever asked, or been asked, for an example to illustrate a software design principle, you know how frustrating it can be to work with a contrived example. There is rarely any depth to the example, and it lines up so neatly with the concept being explained that the student may have trouble recognizing similar situations in the wild. I’m going to try and relate a real world example of a recent refactoring effort, with the hope that the extra context and narrated walkthrough will help someone make a connection that has failed before.

### A little background

My discussion revolves around <a href="http://docu.jagregory.com/" target="_blank">Docu</a>, which is an open source project for converting .NET XML comments into HTML documentation. (_Note: I want to make clear is that this is not a criticism of any of the Docu code. All code is written with specific goals and constraints in mind. As the goals evolve, some designs that worked perfectly in early iterations may start to create friction, and deserve to be reconsidered._) <a href="http://msdn.microsoft.com/en-us/library/b2s063f7.aspx" target="_blank">.NET XML comments</a> are constructed by applying a set of top-level tags to code elements such as classes, methods, or properties. Top-level tags are things like <a href="http://msdn.microsoft.com/en-us/library/2d6dt3kf.aspx" target="_blank"><summary/></a>, <a href="http://msdn.microsoft.com/en-us/library/3zw4z1ys.aspx" target="_blank"><remarks/></a>, or <a href="http://msdn.microsoft.com/en-us/library/8cw818w8.aspx" target="_blank"><param/></a>. Within the contents of the top-level tags, you can use embedded tags to provide additional contextual information. Embedded tags are things like <a href="http://msdn.microsoft.com/en-us/library/acd0tfbe.aspx" target="_blank"><see/></a>, <a href="http://msdn.microsoft.com/en-us/library/x640hcd2.aspx" target="_blank"><para/></a>, or <a href="http://msdn.microsoft.com/en-us/library/wb7x2fhw.aspx" target="_blank"><paramref/></a>. The following example shows a top level <remarks/> tag, with embedded <paramref/> and <para/> tags: 

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>///&lt;remarks&gt;Make sure the &lt;paramref name=”maxValue” /&gt; is a positive number.
///&lt;para&gt;Do not call more than once.&lt;/para&gt;&lt;/remarks&gt; </pre>
</div>

In Docu, the job of translating the XML contents of a single top-level tag into a semantic model is handled by the CommentParser. Let’s take a look at the <a href="https://github.com/jagregory/docu/blob/e5569e48aea80084f1f8c1abc0c77e9d26906e37/src/Docu.Console/Parsing/Comments/CommentParser.cs" target="_blank">original implementation</a>:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>public class CommentParser : ICommentParser
{
    private readonly IDictionary&lt;Func&lt;XmlNode, bool&gt;, Func&lt;XmlNode, bool, bool, IComment&gt;&gt; parsers =
        new Dictionary&lt;Func&lt;XmlNode, bool&gt;, Func&lt;XmlNode, bool, bool, IComment&gt;&gt;();

    private readonly InlineTextCommentParser InlineText = new InlineTextCommentParser();
    private readonly InlineCodeCommentParser InlineCode = new InlineCodeCommentParser();
    private readonly MultilineCodeCommentParser MultilineCode = new MultilineCodeCommentParser();
    private readonly SeeCodeCommentParser See = new SeeCodeCommentParser();
    private readonly ParagraphCommentParser Paragraph;
    private readonly ParameterReferenceParser ParameterReference = new ParameterReferenceParser();
    private readonly InlineListCommentParser InlineList;

    public CommentParser()
    {
        Paragraph = new ParagraphCommentParser(this);
        InlineList = new InlineListCommentParser(this);
        parsers.Add(node =&gt; node is XmlText, InlineText.Parse);
        parsers.Add(node =&gt; node.Name == "c", InlineCode.Parse);
        parsers.Add(node =&gt; node.Name == "code", MultilineCode.Parse);
        parsers.Add(node =&gt; node.Name == "see", See.Parse);
        parsers.Add(node =&gt; node.Name == "para", Paragraph.Parse);
        parsers.Add(node =&gt; node.Name == "paramref", ParameterReference.Parse);
        parsers.Add(node =&gt; node.Name == "list", InlineList.Parse);
    }

    public IList&lt;IComment&gt; Parse(XmlNodeList nodes)
    {
        var blocks = new List&lt;IComment&gt;();

        int count = nodes.Count;
        for(int i = 0; i &lt; count; i++)
        {
            XmlNode node = nodes[i];
            bool first = (i == 0);
            bool last = (i == (count - 1));

            foreach(var pair in parsers)
            {
                var isValid = pair.Key;
                var parser = pair.Value;

                if(!isValid(node))
                    continue;

                var block = parser(node, first, last);

                if(block != null)
                {
                    blocks.Add(block);
                    continue;
                }
            }
        }

        return blocks;
    }</pre>
</div>

You can see (lines 18-24 above) that in its constructor it builds up a collection of function (Func<>) pairs: one function that is used to identify a specific embedded tag, paired with another function that knows how to parse that tag into its model representation (an instance of IComment). The collection is used by the primary method in CommentParser, which iterates over all of the child nodes of a given chunk of XML, finds a parsing function that can handle that node, invokes the function, and collects the results. 

The functions that perform the parsing of individual embedded tags are implemented in separate classes (I’ll call them “node parsers”). The CommentParser creates an instance of each node parser and stores it in a field where it can be referenced by the collection of function pairs. The benefit of moving the embedded tag parsing into separate classes is that they can be developed and tested independent of CommentParser. Unfortunately, you need to make a number of changes to CommentParser every time you add a new node parser. Since there are still quite a few embedded tags that are not yet recognized by Docu, and each embedded tag (generally) requires a new node parser, the CommentParser class will be continuously modified and unstable. The primary goal of my refactoring effort is to create a more stable CommentParser that is open for extension (support for new embedded tags can be added) but closed for modification. 

### High Cohesion

As stated above, the logic for determining when a specific parsing function should be applied was inside of CommentParser, while the logic to implement that function was in the individual parsing classes. These two pieces of logic are tightly related to each other. You cannot safely apply an arbitrary node parser to any node – it only makes sense to apply a parser to the type of node it was designed for. We can make the node parsers and the CommentParser more cohesive by moving both pieces of logic into the node parsing classes. I’ll add a CanParse(XmlNode) method to each node parser. The method returns true if the parser knows how to parse a given comment node. I implement them by copying the logic for identifying specific tags from the Func<> pairs in CommentParser.

### Low Coupling 

We still have the problem that the CommentParser creates and stores an instance of each specific node parser class (lines 6-11 above). This high coupling between the CommentParser and the node parsing classes makes it impossible to execute in isolation. You cannot use a CommentParser without bringing all of the functionality of all node parsers along. You also have to modify the CommentParser every time a new type of node parser is added (as when adding support for a new type of comment tag).

I’ll reduce coupling between CommentParser and individual node parsers by introducing an interface (ICommentNodeParser) to describe the functionality exposed by the node parsers. The CommentParser will only interact with this interface, which exposes the CanParse and Parse methods. I then change the node parsers so that they implement the new interface. Since they already had all of the needed functionality, it was just a matter of making sure the method signatures matched correctly. 

### Slight detour

When I started to add the interface to all of the node parsing classes, I noticed they all derived from CommentParserBase. However, none of the code in the application referred to these classes through this base class. That’s a pretty good indicator that inheritance is being used to share common functionality rather than for polymorphism. Using inheritance just to share some common functionality can lead to more inflexible designs and less cohesive classes. You are usually better off using composition instead of inheritance in these scenarios. In this case, the only shared functionality was a single helper method that had some special logic for string trimming. Since the method didn’t make use of any instance data, it was easy to move it to a separate class as an extension method on string. Now that CommentParserBase was empty, there was no reason to keep it around, so it was eliminated. The fact that no code broke when the base class was deleted (without using a refactoring tool) is a good indicator that it was the right decision.

### Composition through dependency injection

At this point we have a bunch of node parsers that all implement a common interface. But the CommentParser is still tightly coupled to the various implementations because it has to create the instances. This is the perfect opportunity to use dependency injection to pass the node parser instances into the CommentParser. I just change the constructor of CommentParser to require an array of ICommentNodeParsers, and delete all the code that was creating the node parser instances. Whoever creates an instance of CommentParser will need to pass in the collection of node parser instances. CommentParser is no longer coupled to the specific node parsers and can be more easily used in isolation. You can see that the newer version is greatly simplified:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>public class CommentParser : ICommentParser
   {
       private readonly ICommentNodeParser[] _parsers;

       public CommentParser(ICommentNodeParser[] parsers)
       {
           _parsers = parsers;
       }

       public IList&lt;IComment&gt; Parse(XmlNodeList nodes)
       {
           var blocks = new List&lt;IComment&gt;();

           var count = nodes.Count;
           for(var i = 0; i &lt; count; i++)
           {
               var node = nodes[i];
               var first = (i == 0);
               var last = (i == (count - 1));

               var parser = _parsers.FirstOrDefault(p =&gt; p.CanParse(node));
               if (parser == null) continue;

               var block = parser.Parse(this, node, first, last);
               if (block != null)
               {
                   blocks.Add(block);
               }
           }

           return blocks;
       }</pre>
</div>

At this point you may be thinking I just “passed the buck” for creating the individual node parser instances to another class up the stack. Someone still needs to create them, and will therefore be tightly coupled to the implementations. That is true. However, if we can pass that responsibility up the stack far enough, it can be handled by code that has no other responsibility than to configure and bootstrap our application. That type of code doesn’t typically have any logic that would be re-used and doesn’t have the same concerns about designing for maintainability. Luckily, in the case of Docu, we already use <a href="http://structuremap.sourceforge.net/" target="_blank">StructureMap</a> to compose our object instances so we get this functionality for free. I simply had to add a single line to the StructureMap configuration to tell it to make use of any implementation of ICommentNodeParser it finds in the Docu assembly.

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <pre>public DefaultRegistry() {
  Scan(x =&gt;  {
    x.AssemblyContainingType&lt;DocumentationGenerator&gt;();
    x.WithDefaultConventions();
    x.AddAllTypesOf&lt;ICommentNodeParser&gt;();</pre>
</div>

Now when an instance of CommentParser is requested from StructureMap, it will automatically have the array of all node parsers injected to its constructor.

### Wrap up

So what did we gain? Let’s compare the stories for adding the ability to parse a new XML documentation tag. In the original implementation, we had to:

  1. Create a class with code that parses the new tag 
  2. Create a new field in CommentParser to hold an instance of the new parsing class 
  3. Modify CommentParser’s constructor to register the new class, along with a predicate that determines when it should be used 

And now we simply:

  1. Create a class that implements ICommentNodeParser with code that recognizes and parses the new tag 

Notice that you didn’t have to touch CommentParser? We just gave it new functionality without having to change (and potentially destabilize) the code. That’s the open-closed principle in action. The increased cohesion of the node parsers makes them easier to understand and helps localize any future changes to their implementation. We also saw that the use of dependency injection and a composition tool (StructureMap in this case) made it painless for us to pull code apart into separate classes. The code was made easier to maintain by applying a few established object oriented design principles. Hopefully this example helped clarify the application of these principles. Your feedback is appreciated.

For additional context, you can <a href="https://github.com/jagregory/docu/commit/41bf6458ed4297a355400b0ea2c465a1511122b0" target="_blank">view the commit</a> that contained the changes discussed above.