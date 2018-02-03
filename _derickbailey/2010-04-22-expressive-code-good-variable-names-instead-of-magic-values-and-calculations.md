---
wordpress_id: 145
title: 'Expressive Code: Good Variable Names Instead Of Magic Values And Calculations'
date: 2010-04-22T12:00:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/04/22/expressive-code-good-variable-names-instead-of-magic-values-and-calculations.aspx
dsq_thread_id:
  - "262068644"
categories:
  - .NET
  - Analysis and Design
  - AntiPatterns
  - 'C#'
  - Craftsmanship
  - Principles and Patterns
---
I like to remind myself of these little principles that I take for granted, now and then. It’s good habit to get back to basics and really understand why you hold principles so that you can judge whether or not they are appropriate in the circumstances you are in. Today’s little nugget of principle is to write expressive code and avoid magic values in your code. 

For example, I was writing some graphics code for a specialized button in Compact Framework development. I wanted to draw an outline around my box but only the left side, top and right side – leaving the bottom blank. I started with this code:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> graphics.DrawLine(outlinePen, 0, 0, 0, ClientRectangle.Height);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> graphics.DrawLine(outlinePen, 0, 0, ClientRectangle.Width, 0);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span> graphics.DrawLine(outlinePen, ClientRectangle.Width-1, 0, ClientRectangle.Width-1, ClientRectangle.Height);</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        (Note: ClientRectangle is provided by inheriting from Control in the compact framework. It’s the visible rectangle of the control.)
      </p>
      
      <p>
        This code works perfectly and does what I want. In writing this code, I had to stop and think about the values that needed to go into each position as I was writing each one of these lines of code. It only took a few seconds to complete all three lines of code so it was not a big deal. However, I decided that I didn’t like this code because I found it very difficult to read. Every time I look at it (even though I wrote it) I have to remember which values are paired together to form which x/y coordinates, so that I can visualize what this will look like. Add in the object.property use and the simple math and there’s more work to read this code than I care for.
      </p>
      
      <p>
        So, I fixed it. I removed the magic values (no hard coded integers) and I created variables that expressed what the math calculations represented.
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">int</span> left = 0;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">int</span> right = ClientRectangle.Width - 1;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span> <span style="color: #0000ff">int</span> top = 0;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span> <span style="color: #0000ff">int</span> bottom = ClientRectangle.Height;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span> graphics.DrawLine(outlinePen, left, top, left, bottom);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span> graphics.DrawLine(outlinePen, left, top, right, top);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span> graphics.DrawLine(outlinePen, right, top, right, bottom);</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              Sure, I have 4 extra lines of code now. But look at the three lines of code that do the actual drawing compared to what was there previously. I don’t have to parse and calculate to understand where the line is being draw anymore. I can simply read “left-top to left bottom” and understand much faster “oh, this draws along the left border.”
            </p>
            
            <p>
              Don’t just fulfill the technical requirements of the language syntax that you are writing. Write code that expresses your intent and an understanding of that intent that can be transferred to anyone else who reads the code.
            </p>