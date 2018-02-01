---
id: 285
title: 'Spaces in identifier names in C#'
date: 2009-02-17T03:49:55+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/02/16/spaces-in-identifier-names-in-c.aspx
dsq_thread_id:
  - "264716088"
categories:
  - BDD
  - 'C#'
---
While I’m a fan of descriptive member names for testcase classes and test methods, there wasn’t a great way to create readable text.&#160; Text in code editors is almost universally monospace, which reads very well for languages with lots of syntax.&#160; But when it comes to stringing several words together to form a phrase, things get ugly.&#160; Here’s a test I found in the StructureMap source code:

![](http://grabbagoftimg.s3.amazonaws.com/testnames_underscores.png)

Or, let’s try that one converted to PascalCase:

![](http://grabbagoftimg.s3.amazonaws.com/testnames_pascalcase.png)

As I see it, both of these options aren’t optimal.&#160; It’s still work for me to read them, as each style is still only geared towards smallish groups of words.&#160; But they don’t gel well to how people actually read, which is by groups of words, by scanning.&#160; These naming styles simply don’t scan well, and to be honest, give me a headache after awhile.

While I’d rather not re-train myself to read with underscores, we can however do this:

![](http://grabbagoftimg.s3.amazonaws.com/testnames_spaces.png)

Yes, this compiles.

Yes, it runs, in TD.NET and nunit-console.

Yes, it’s completely compliant to the [ECMA C# language specification](http://www.ecma-international.org/publications/standards/Ecma-334.htm).&#160;&#160; It still suffers from the same monospace issues, that monospace text is still more difficult to read than non-monospace text.&#160; But I do find it visually less distracting.&#160; Here’s how it’s done:

### AutoHotKey fun

First, you’ll need to use either a VS Macro or AutoHotKey to help.&#160; I use AutoHotKey to switch into a “Test Naming Mode”, borrowed from JP Boodhoo’s [great start on the subject](http://blog.jpboodhoo.com/BDDAutoHotKeyScriptUpdateTake2.aspx).&#160; Mine is a little different at this point, as I have my R# template shortcut keys for generating BDD-style tests _also_ kick off my AutoHotKey script.&#160; “spec+TAB” creates my whole context base class, plus AutoHotKey listens to this same keystroke combination.&#160; Otherwise, I can still use the same “Ctrl+Shift+U” keystroke to switch in and out of the test naming mode.

Somewhere along the line, you’ll see a method that either sends an underscore or a space to the target application:

<pre>;==========================
;Handle SPACE press
;==========================
$Space::
  if (IsInTestNamingMode) {
    Send, _
  } else {
    Send, {Space}
  } </pre>

[](http://11011.net/software/vspaste)

That first part, “Send, _” is what we’ll need to change.&#160; Once we have our AutoHotKey script up and going, we can change it to send a very different character, a Unicode character instead of the underscore.

### Trolling through Unicode

We can’t pick just _any_ Unicode character of course.&#160; First, it needs to be a valid C# identifier.&#160; To find what a valid C# identifier is, we can reference the ECMA C# language specification, specifically section A.1.6, “Identifiers”.&#160; In that section, it details what exactly a valid identifier can look like, described as the set of valid Unicode characters.&#160; It’s much more than your traditional ASCII characters as well.

What I needed to find was a valid character for an identifier that looked like a space for the font I used.&#160; There, it was simply a matter of trial and error going through the [various categories](http://www.fileformat.info/info/unicode/category/index.htm) allowed by the C# specification.&#160; Some characters worked for some fonts and sizes, others did not.&#160; Finally, I settled on one that worked for me at Consolas 10pt and 14pt, the font and size I use the most: [UTF-16 0x200E](http://www.fileformat.info/info/unicode/char/200e/index.htm), or “Left-to-right mark”.&#160; I have zero idea what this character means, nor do I care, other than it’s a valid identifier character and it looks like a space in VS 2008 and most other text editors (and Word, Notepad2, Notepad++, etc.).

Once I found the right character, which I tested by copying and pasting into the editor, I was ready to change my AutoHotKey script to use the Unicode character instead of the underscore.

### Sending Unicode through AutoHotKey

Unfortunately, AutoHotKey does not support sending Unicode characters very well out of the box.&#160; From [this forum post](http://www.autohotkey.com/forum/topic7328.html) however, I found a great solution.&#160; This code added to my AutoHotKey script:

<pre>EncodeInteger( p_value, p_size, p_address, p_offset )
{
   loop, %p_size%
      DllCall( "RtlFillMemory"
         , "uint", p_address+p_offset+A_Index-1
         , "uint", 1
         , "uchar", ( p_value &gt;&gt; ( 8*( A_Index-1 ) ) ) & 0xFF )
}

SendInputU( p_text )
{
   StringLen, len, p_text

   INPUT_size = 28
   
   event_count := ( len//4 )*2
   VarSetCapacity( events, INPUT_size*event_count, 0 )

   loop, % event_count//2
   {
      StringMid, code, p_text, ( A_Index-1 )*4+1, 4
      
      base := ( ( A_Index-1 )*2 )*INPUT_size+4
         EncodeInteger( 1, 4, &events, base-4 )
         EncodeInteger( "0x" code, 2, &events, base+2 )
         EncodeInteger( 4, 4, &events, base+4 ) ; KEYEVENTF_UNICODE

      base += INPUT_size
         EncodeInteger( 1, 4, &events, base-4 )
         EncodeInteger( "0x" code, 2, &events, base+2 )
         EncodeInteger( 2|4, 4, &events, base+4 ) ; KEYEVENTF_KEYUP|KEYEVENTF_UNICODE
   }
   
   result := DllCall( "SendInput", "uint", event_count, "uint", &events, "int", INPUT_size )
   if ( ErrorLevel or result &lt; event_count )
   {
      MsgBox, [SendInput] failed: EL = %ErrorLevel% ~ %result% of %event_count%
      return, false
   }
   
   return, true
}</pre>

[](http://11011.net/software/vspaste)

Allowed me to call one method to send the right Unicode value to my editor:

<pre>$Space::
  if (IsInTestNamingMode) {
    SendInputU("200E")
  } else {
    Send, {Space}
  }</pre>

[](http://11011.net/software/vspaste)

Instead of sending an underscore character, I send the Unicode “200E” value, which happens to look just like a space.&#160; Presto chango, my code now looks like it has spaces, but is still able to compile and run without skipping a beat.

### Some major caveats

I’ve only played with this for a day or so, so I don’t know all the ramifications of going with these quasi-spaces in test class and method names.&#160; Some things I’ve noticed so far:

  * R# Smart completion works some of the time (V4.5)
  * I don’t care

  * Test names are output without spaces or underscores
  * Could be a problem, maybe I just need to find a better space substitute

  * Anyone that wants to write test or method names like this NEEDS to have a macro or AutoHotKey script to convert spaces to the special character.&#160; I haven’t found a way to easily, directly input this character inside the IDE.

**This type of technique should not be used in any production, public API**.&#160; I’m targeting simply my test method and class names, which tend to get rather long and don’t have RSpec’s advantage of being able to use string literals.

It’s weird, but it works.