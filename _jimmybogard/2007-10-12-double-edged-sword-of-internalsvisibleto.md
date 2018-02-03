---
wordpress_id: 79
title: Double-edged sword of InternalsVisibleTo
date: 2007-10-12T21:08:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/10/12/double-edged-sword-of-internalsvisibleto.aspx
dsq_thread_id:
  - "264715373"
categories:
  - 'C#'
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/10/double-edged-sword-of.html)._

I&#8217;ve had some conversations with both [Joe](http://www.lostechies.com/blogs/joe_ocampo/default.aspx) and [Elton](http://eltonomicon.blogspot.com/) lately about the [InternalsVisibleTo](http://msdn2.microsoft.com/en-us/library/system.runtime.compilerservices.internalsvisibletoattribute.aspx) attribute.&nbsp; From the documentation, the assembly-level InternalsVisibleTo attribute:

> Specifies that all nonpublic types in an assembly are visible to another assembly.

This attribute was introduced in C# 2.0, and allows you to specify other assemblies that can see all types and members marked &#8220;internal&#8221;.&nbsp; In practice, all assemblies are signed with the same public key, and you&#8217;d specify that the unit test assembly can see that assembly.

  * MyProject.Core -> has the &#8220;InternalsVisibleTo&#8221; attribute defined in the AssemblyInfo.cs file, pointing at the below assembly 
      * MyProject.Core.Tests -> is signed with the same public key as the Core assembly</ul> 
    Notice that the &#8220;Core&#8221; project knows about the &#8220;Tests&#8221; project, but the actual project&nbsp;dependency is the other way around.&nbsp; It&#8217;s definitely better than using reflection to access private members for testing, but there are some definite pros and cons with this approach.
    
    #### Pros
    
      * Allows your test libraries to access internal classes and methods for additional testing and coverage 
          * Keeps your public API limited to what you want to publish 
              * Provides greater flexibility for internal refactoring and backwards compatibility 
                  * Reduces the surface area of your public API</ul> 
                #### Cons
                
                  * Easily abused, so things usually marked &#8220;private&#8221; are now marked &#8220;internal&#8221; 
                      * Potential loss of encapsulation 
                          * Decision about what should be public could be wrong 
                              * Essentially two levels of &#8220;public&#8221; visibility that have to be managed 
                                  * Enforces bi-directional dependencies between assemblies</ul> 
                                Personally, I always felt like marking something &#8220;internal&#8221; was cheating just a little bit, and I have trouble deciding when to make something internal or not.&nbsp; But unless you&#8217;re delivering a public, published and documented&nbsp;API as part of your product, using the &#8220;InternalsVisibleTo&#8221; attribute would probably be overkill.
                                
                                However, if you are delivering an API, you should consider using this attribute to keep a high level of coverage and reduce the surface area the API for your customers.&nbsp; You could try starting by making everything &#8220;internal&#8221;, then&nbsp;shape the public API based&nbsp;on specific use cases.