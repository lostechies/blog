---
wordpress_id: 43
title: My Current BDD / SpecUnit Live Templates
date: 2009-03-19T16:57:17+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/03/19/my-current-bdd-specunit-live-templates.aspx
dsq_thread_id:
  - "262068124"
  - "262068124"
categories:
  - .NET
  - Behavior Driven Development
  - 'C#'
  - Resharper
  - Unit Testing
redirect_from: "/blogs/derickbailey/archive/2009/03/19/my-current-bdd-specunit-live-templates.aspx/"
---
**UPDATE 3-30-2009**: FYI, I’ve made a few minor updates to my templates. They are now a little more intelligent – the “spec” templates automatically inherits from the parent spec file’s superclass, and all of the templates now have more intelligent placing of cursors for the “When” and “Should” text. I’ve also updated the “When” and “Should” variables to default to a blank (empty) state, so you can start typing without any existing text highlighted by the cursor. All of the “constant value” macros below are defaulted to nothing (empty). The zip file linked at the bottom has been updated with these changes.

&#160;

&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;

I use <a href="http://www.jetbrains.com/resharper" target="_blank">Resharper</a>’s <a href="http://www.jetbrains.com/resharper/features/codeTemplate.html" target="_blank">Live Templates</a> every day for my BDD / <a href="http://specunit-net.googlecode.com" target="_blank">SpecUnit</a> tests and I find them quite useful, so I thought I would share with the world.

### File Tempate: “Specification Tests”

Builds a new context/specification file based on the supplied name. Builds a super-class that inherits from ContextSpecification and has an empty SharedContext, named based on the file name supplied. Builds a complete specification class with an empty context and one empty observation, inheriting from the super-class.

The template:

<div>
  <div>
    <pre><span style="color: #0000ff">using</span> NUnit.Framework;</pre>
    
    <pre><span style="color: #0000ff">using</span> SpecUnit;</pre>
    
    <pre>&#160;</pre>
    
    <pre><span style="color: #0000ff">namespace</span> $NAMESPACE$</pre>
    
    <pre>{</pre>
    
    <pre>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> $FILENAME$</pre>
    
    <pre>   {</pre>
    
    <pre>&#160;</pre>
    
    <pre>       <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> $FILENAME$Context: ContextSpecification</pre>
    
    <pre>       {</pre>
    
    <pre>       </pre>
    
    <pre>           <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> SharedContext()</pre>
    
    <pre>           {</pre>
    
    <pre>               </pre>
    
    <pre>           }</pre>
    
    <pre>       </pre>
    
    <pre>       }</pre>
    
    <pre>&#160;</pre>
    
    <pre>       [TestFixture]</pre>
    
    <pre>       [Concern(<span style="color: #006080">"$CONCERN$"</span>)]</pre>
    
    <pre>       <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> When_$WHEN$ : $FILENAME$Context</pre>
    
    <pre>       {</pre>
    
    <pre>   </pre>
    
    <pre>           <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Context()</pre>
    
    <pre>           {</pre>
    
    <pre>   </pre>
    
    <pre>           }</pre>
    
    <pre>   </pre>
    
    <pre>           [Test]</pre>
    
    <pre>           [Observation]</pre>
    
    <pre>           <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Should_$SHOULD$()</pre>
    
    <pre>           {</pre>
    
    <pre>               $END$</pre>
    
    <pre>           }</pre>
    
    <pre>   </pre>
    
    <pre>       }</pre>
    
    <pre>&#160;</pre>
    
    <pre>   }</pre>
    
    <pre>}</pre></p>
  </div>
</div>

The variable options:

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="192" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_671E1B82.png" width="392" border="0" />](https://lostechies.com/content/derickbailey/uploads/2011/03/image_2BCAB5C4.png) 

### Live Template: “spec”

Builds a complete specification class with an empty context and one empty observation.

The template:

<div>
  <div>
    <pre>[TestFixture]</pre>
    
    <pre>[Concern(<span style="color: #006080">"$Concern$"</span>)]</pre>
    
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> When_$When$: $CONTEXTNAME$Context</pre>
    
    <pre>{</pre>
    
    <pre>&#160;</pre>
    
    <pre>   <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Context()</pre>
    
    <pre>   {</pre>
    
    <pre>       </pre>
    
    <pre>   }</pre>
    
    <pre>&#160;</pre>
    
    <pre>   [Test]</pre>
    
    <pre>   [Observation]</pre>
    
    <pre>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Should_$Should$()</pre>
    
    <pre>   {</pre>
    
    <pre>       $END$</pre>
    
    <pre>   }</pre>
    
    <pre>&#160;</pre>
    
    <pre>}</pre></p>
  </div>
</div>

The variable options:

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="192" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_16DBC402.png" width="482" border="0" />](https://lostechies.com/content/derickbailey/uploads/2011/03/image_3B6D5186.png) 

### Live Template: “obs”

Builds an empty observation

The Template:

<div>
  <div>
    <pre>[Test]</pre>
    
    <pre>[Observation]</pre>
    
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Should_$Should$()</pre>
    
    <pre>{</pre>
    
    <pre>   $END$</pre>
    
    <pre>}</pre></p>
  </div>
</div>

The variable options:

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="114" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_thumb_51C2F6CB.png" width="543" border="0" />](https://lostechies.com/content/derickbailey/uploads/2011/03/image_32141D03.png) 

### Exported Template Package

If you want to import these templates, I have an export of my BDD/SpecUnit templates from Resharper at the link below. These XML files can be directly imported into Resharper’s Live Templates and will have all of the above templates and options automatically set.

<a href="https://lostechies.com/media/p/19944.aspx" target="_blank"><strong>You can download the template package (2 .xml files in a .zip file) here</strong></a>**.**