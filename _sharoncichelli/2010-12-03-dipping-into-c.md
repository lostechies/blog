---
wordpress_id: 3866
title: Dipping into C
date: 2010-12-03T13:59:00+00:00
author: Sharon Cichelli
layout: post
wordpress_guid: /blogs/sharoncichelli/archive/2010/12/03/dipping-into-c.aspx
dsq_thread_id:
  - "263371164"
categories:
  - Books
  - 'C#'
redirect_from: "/blogs/sharoncichelli/archive/2010/12/03/dipping-into-c.aspx/"
---
I decided on Monday that I should learn C. Cultivate a nodding acquaintance, at any rate. [Louis](/blogs/louissalin/) is always prodding me to become a better craftsman, to become more proficient with my tools. So I figured I should understand my roots.

I picked up O&#8217;Reilly&#8217;s _[Mastering Algorithms with C](http://oreilly.com/catalog/9781565924536)_ at the library, and I&#8217;m already having fun. It will get into recursion, Big O notation, linked lists, quicksorts, encryption, and all that jazz, but right off the bat, it starts with pointers.

Immediately some aspects of C# become more clear, by understanding their precursors from C: the ideas behind reference types and passing parameters by reference, and the joys of automatic garbage collection and abstracted memory allocation.

The syntax of pointers in C involves a lot of punctuation&mdash;a subtle and nuanced application of asterisks and ampersands&mdash;which the book assumes I would already know. My favorite search engine (code-named Sweetie, as in, &#8220;Hey, Sweetie, can you find&#8230;&#8221;) turned up an online edition of _[The C Book](http://publications.gbdirect.co.uk/c_book/)_, containing this [excellent explanation of pointers](http://publications.gbdirect.co.uk/c_book/chapter5/pointers.html).

Here&#8217;s my understanding so far. Please suggest corrections if I&#8217;ve gotten it sideways.

<table>
  <tr>
    <td style="border: 1px solid gray">
      int *mypointer;
    </td>
    
    <td style="padding-left:1em">
      mypointer&#8217;s type is &#8220;pointer that can point to an integer&#8221;
    </td>
  </tr>
  
  <tr>
    <td style="border: 1px solid gray">
      mypointer = &myint;
    </td>
    
    <td style="padding-left:1em">
      mypointer is pointing to the location where myint is stored
    </td>
  </tr>
  
  <tr>
    <td style="border: 1px solid gray">
      *mypointer = 7;
    </td>
    
    <td style="padding-left:1em">
      the place where mypointer is pointing now contains a 7, so myint now equals 7
    </td>
  </tr>
  
  <tr>
    <td style="border: 1px solid gray">
      myotherint = myint;
    </td>
    
    <td style="padding-left:1em">
      myotherint also equals 7 (but just a copy of 7, so changes to myint won&#8217;t affect myotherint)
    </td>
  </tr>
</table>

So what? So now I&#8217;m clearer about reference types in C#. In C, I can pass a _pointer_ as a parameter to a function, instead of passing a value. That means I&#8217;m passing the function a reference to a location in memory. If the function uses the pointer to change the stuff in that location, when someone else accesses that location, they will receive the changed stuff. Contrast this with passing a value, such as an integer, to a function, which actually passes a copy of the value. Any changes to the value are scoped within the function and are not detectable from outside. It&#8217;s something I&#8217;ve known for a while, but now I know _why_.

If you no longer need the piece of memory that a pointer points to but you fail to de-allocate that memory, it will stay held in reserve forever&mdash;voil&agrave;, a memory leak. Different data types take up different amounts of memory, so writing a data type into a pointer of a differently sized data type will overwrite other pieces of memory in unpredictable ways. I feel like I&#8217;ve been making peanut-butter sandwiches with a butter knife and just noticed that other people are wielding samurai swords: looks really powerful and flexible, but I&#8217;m scared I&#8217;d cut off a finger. Now I get what the big deal is about the CLR&#8217;s garbage collector (and how in some contexts it would be too restrictive).

I&#8217;m having fun getting &#8220;closer to the metal&#8221; and realizing the reasons behind some things I&#8217;ve taken for granted. I can&#8217;t wait to get into the chapters on algorithms.