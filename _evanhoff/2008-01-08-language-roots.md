---
wordpress_id: 4320
title: Language Roots
date: 2008-01-08T04:54:51+00:00
author: Evan Hoff
layout: post
wordpress_guid: /blogs/evan_hoff/archive/2008/01/07/language-roots.aspx
categories:
  - Uncategorized
---
Where does C# get its roots?

Most C# developers would say it&#8217;s a descendant&nbsp;of C++, but is that the case?&nbsp; Did we really get our heritage from C and C++?

Here&#8217;s a comparison for you:

<table style="border-right: dimgray 1px solid;border-top: dimgray 1px solid;border-left: dimgray 1px solid;border-bottom: dimgray 1px solid" cellspacing="0" cellpadding="6" border="1">
  <tr>
    <td>
      &nbsp;
    </td>
    
    <td>
      C++
    </td>
    
    <td>
      C#
    </td>
    
    <td>
      Modula-3
    </td>
  </tr>
  
  <tr>
    <td>
      Single Inheritance
    </td>
    
    <td>
      &nbsp;
    </td>
    
    <td>
      X
    </td>
    
    <td>
      X
    </td>
  </tr>
  
  <tr>
    <td>
      Multiple Inheritance
    </td>
    
    <td>
      X
    </td>
    
    <td>
      &nbsp;
    </td>
    
    <td>
      &nbsp;
    </td>
  </tr>
  
  <tr>
    <td>
      Interfaces
    </td>
    
    <td>
      &nbsp;
    </td>
    
    <td>
      X
    </td>
    
    <td>
      X
    </td>
  </tr>
  
  <tr>
    <td>
      Safe/Unsafe Code
    </td>
    
    <td>
      &nbsp;
    </td>
    
    <td>
      X
    </td>
    
    <td>
      X
    </td>
  </tr>
  
  <tr>
    <td>
      Generics
    </td>
    
    <td>
      &nbsp;
    </td>
    
    <td>
      X
    </td>
    
    <td>
      X
    </td>
  </tr>
  
  <tr>
    <td>
      Templates
    </td>
    
    <td>
      X
    </td>
    
    <td>
      &nbsp;
    </td>
    
    <td>
      &nbsp;
    </td>
  </tr>
  
  <tr>
    <td>
      Garbage Collection
    </td>
    
    <td>
      &nbsp;
    </td>
    
    <td>
      X
    </td>
    
    <td>
      X
    </td>
  </tr>
  
  <tr>
    <td>
      Exceptions
    </td>
    
    <td>
      &nbsp;
    </td>
    
    <td>
      X
    </td>
    
    <td>
      X
    </td>
  </tr>
</table>

While some of the features above are more runtime features than language features (say, garbage collection), I think they are valid for the comparison.&nbsp; The choice to exclude memory management features from the language dictates (to an extent) the runtime environment.&nbsp; I&#8217;ll save that for another post sometime I suppose.

Oh, and Modula-3 also shipped with an AST (Abstract Syntax Tree) implementation.&nbsp; CodeDOM anyone?

For the interested, you can take a quick glance at the following language families:

  * <a href="http://en.wikipedia.org/wiki/BCPL" target="_blank">BCPL</a> (Basic Combined Programming Language)- The family to which C and C++ belong 
      * <a href="http://en.wikipedia.org/wiki/ALGOL" target="_blank">ALGOL</a> &#8211; The family to which Modula-3 and C#&nbsp;belong (along with&nbsp;its .NET siblings) 
          * The mathematics based languages, such as <a href="http://en.wikipedia.org/wiki/Lisp_programming_language" target="_blank">Lisp</a></ul> 
        It seems that a large portion of what we think of as Microsoft&#8217;s .NET was really designed by Digital (later to become Compaq, later to become HP).
        
        An interesting side note of Modula-3 is that simplicity was a major goal of the language.&nbsp; The designers gave themselves a mandate to produce a language which could adequately be described in 50 pages or less.