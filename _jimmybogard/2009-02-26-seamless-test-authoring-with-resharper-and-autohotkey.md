---
id: 288
title: Seamless test authoring with ReSharper and AutoHotKey
date: 2009-02-26T14:38:26+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/02/26/seamless-test-authoring-with-resharper-and-autohotkey.aspx
dsq_thread_id:
  - "264716083"
categories:
  - Tools
---
Although I’m no big believer of code generation, the micro-code generation of ReSharper can be a huge timesaver.&#160; For every common snippet of code or common file I would create, I could create a simple template that might create a class, method, or just a small snippet of code.

Another tool I love to use is AutoHotKey.&#160; For about a year and a half now, I’ve used BDD-style names in my tests, which leads to a lot of underscores in test names.&#160; Underscores are a pain to type however, especially when you would use it as much as a spacebar.&#160; AutoHotKey allows me to map keystrokes to other keystrokes, such as say, spacebar to underscores.&#160; With ReSharper and AutoHotKey integrated, you’ll have about as seamless TDD/BDD experience as you can get.

To integrate the two, I’ll first need to get some ReSharper templates going.

### Some simple test templates

I only use underscores in test class/method names, so we’ll just create templates for those two items.&#160; Step zero of course, is to have ReSharper, but you can also do this with Visual Studio’s code snippets.&#160; I prefer ReSharper templates just because they’re ridiculously easy to create, and more powerful.&#160; First, let’s create a fixture template by going to ReSharper –> Live Templates:

 ![](http://grabbagoftimg.s3.amazonaws.com/RSAHK_step1.png)

This brings up the Templates Explorer.&#160; In the Live Templates tab, navigate to the Shared Solution Templates C# in the tree view and click the “New Template” button in the toolbar:

 ![](http://grabbagoftimg.s3.amazonaws.com/RSAHK_step2.png)</p> 

I already have a couple of templates in there, and our team has some shared templates we keep in source control (makes pairing waaaay easier).&#160; Clicking the New Template button brings up the template editor, where we need to supply three pieces:

  * Shortcut
  * Description
  * Template

For the “Shortcut”, I’ll use “tc” for “test class”, which is what I’ll also put in the Description.&#160; Also, uncheck “Reformat”, which automatically reformats when you put the template in (and we don’t want).&#160; Finally, we’ll put the following text in our template section:

<pre>[TestFixture]
public class $TESTNAME$
{
    $END$
}</pre>

[](http://11011.net/software/vspaste)

The dollar signs create editable areas that take focus whenever we execute the shortcut.&#160; The final result should look something like this:

 ![](http://grabbagoftimg.s3.amazonaws.com/RSAHK_step3.png)

There are tons of other options I could look at, such as setting the available context, but I’ll leave it alone for now.

To execute the template, I go to a C# file and type in “tc+TAB”, and my template pops out.&#160; Before we look at AutoHotKey, make sure your template is working properly.

### 

### Integrating AutoHotKey

I was introduced to AutoHotKey by JP Boodhoo a long time ago, and I still use his template as a starting point for mine.&#160; In his starting template, you can use “Ctrl+Shift+U” to enable the TestNamingMode script, and from there on out your spacebars turn into underscores.&#160; The starting point script can be found here: [http://pastie.org/395769](http://pastie.org/395769 "http://pastie.org/395769").&#160; Additionally, you’ll need the [two images that JP created](http://blog.jpboodhoo.com/ct.ashx?id=e8d02850-60a2-4c81-8061-bc72291b12de&url=http%3a%2f%2fblog.jpboodhoo.com%2fcontent%2fbinary%2f2008%2fmay%2f27%2fbdd_autohotkey_script_update_take_1%2fbdd_style_naming_script.rar) for your system tray.

AutoHotKey is a script, which you compile into an executable.&#160; You’ll need to download AutoHotKey (free) to compile the script we create.

However, I don’t really like turning on and off the test naming mode, I want this to just turn on _right after_ I execute the ReSharper template shortcut, “tc+TAB”.&#160; To do so, first I’ll need to comment out the part that checks to make sure Visual Studio is active in our AutoHotKey script:

<pre>;==========================
;Test Mode toggle
;==========================
;#IfWinActive Microsoft Visual Studio
^+u::
SetTestNamingMode(!IsInTestNamingMode)
return</pre>

[](http://11011.net/software/vspaste)

I did this by putting a semi-colon in front of the “#IfWinActive” piece.&#160; Next, I insert the following at the bottom of the script:

<pre>;==========================
;R# Template hotkeys
;==========================
::tc::tc^+u
return</pre>

[](http://11011.net/software/vspaste)

This piece takes any “tc” plus a terminator key (enter, tab, etc.) and pipes out the original “tc+TAB”, plus “Ctrl+Shift+U”, which turns on my TestNamingMode.&#160; Save this file, and right click and hit “compile” from Windows Explorer:

 ![](http://grabbagoftimg.s3.amazonaws.com/RSAHK_step4.png)

Once the script is compiled, run the executable that was created, and you’ll see a little tray icon pop up in your system tray:

![](http://grabbagoftimg.s3.amazonaws.com/RSAHK_step5.png)

Now that my AutoHotKey script is up and running, I can go back to Visual Studio and use my R# template integrated with AutoHotKey.

When I execute my template:

  * “tc+TAB” turns on TestNamingMode in my AutoHotKey script
  * The AHK script pipes “tc+TAB” back to Visual Studio
  * R# uses “tc+TAB” to spit out my template
  * I type away with test names and spacebars, and AHK turns my spacebar key into underscores
  * When I’m done with the test name, I hit “ENTER”, which both turns off my TestNamingMode, and moves the caret to the “$END$” part in my template (the body of the test class)

This is about the most seamless way I’ve seen to do TDD.&#160; I hit “tc+TAB”, or “t+tab” (my test method template), and I can _immediately_ start typing normally and my test names show up just fine, without having to fight with either the underscore key, or a macro that doesn’t play well with IntelliSense.

You can find the final script, plus the compiled version and images [here](http://grabbagoftimg.s3.amazonaws.com/TestNamingMode.zip).