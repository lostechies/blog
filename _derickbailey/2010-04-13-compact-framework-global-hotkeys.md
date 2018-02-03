---
wordpress_id: 137
title: 'Compact Framework: Global Hotkeys'
date: 2010-04-13T17:27:45+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/04/13/compact-framework-global-hotkeys.aspx
dsq_thread_id:
  - "264745023"
categories:
  - .NET
  - 'C#'
  - Compact Framework
---
A long time ago, in a galaxy far far away… well… back when I worked in VB.NET up in Dallas… I wrote a little [hot key class](http://www.avocadosoftware.com/csblogs/dredge/articles/PPC_RegisterHotKey.aspx) for compact framework apps and [posted a little bit on how to use it](http://www.avocadosoftware.com/csblogs/dredge/archive/2005/02/17/PPC_RegisterHotKey_Example.aspx). Of course that was all done in VB.NET and I haven’t used that since the end of 2005. Fast forward 5 years and I find myself using the Compact Framework a lot and needing hotkeys again. So, here is the same code translated into C# ([with the help of PInvoke.NET](http://pinvoke.net/default.aspx/user32/RegisterHotKey.html)):

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">using</span> System;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span> <span style="color: #0000ff">using</span> System.Windows.Forms;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span> <span style="color: #0000ff">using</span> Microsoft.WindowsCE.Forms;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span> <span style="color: #0000ff">using</span> System.Runtime.InteropServices;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span> <span style="color: #0000ff">namespace</span> CFHotKeys</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span> {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>     <span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> HotKeys</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>     {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>         <span style="color: #cc6633">#region</span> dll imports</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>         [DllImport(<span style="color: #006080">"coredll.dll"</span>)]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>         <span style="color: #0000ff">private</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">extern</span> <span style="color: #0000ff">bool</span> RegisterHotKey(IntPtr hWnd, <span style="color: #0000ff">int</span> id, <span style="color: #0000ff">int</span> fsModifiers, <span style="color: #0000ff">int</span> vlc);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span>         [DllImport(<span style="color: #006080">"coredll.dll"</span>)]</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span>         <span style="color: #0000ff">private</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">extern</span> <span style="color: #0000ff">bool</span> UnregisterHotKey(IntPtr hWnd, <span style="color: #0000ff">int</span> id);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  17:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  18:</span>         <span style="color: #cc6633">#endregion</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  19:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  20:</span>         <span style="color: #0000ff">public</span> <span style="color: #0000ff">enum</span> KeyModifiers </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  21:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  22:</span>             None = 0,</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  23:</span>             Alt = 1,</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  24:</span>             Control = 2,</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  25:</span>             Shift = 4,</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  26:</span>             Windows = 8,</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  27:</span>             Modkeyup = 0x1000</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  28:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  29:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  30:</span>         <span style="color: #0000ff">public</span> <span style="color: #0000ff">delegate</span> <span style="color: #0000ff">void</span> KeyPressedEventHandler(Keys key);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  31:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  32:</span>         <span style="color: #0000ff">public</span> <span style="color: #0000ff">event</span> KeyPressedEventHandler KeyPressed;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  33:</span>         <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> HotKeyMessageWindow wnd;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  34:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  35:</span>         <span style="color: #0000ff">public</span> HotKeys()</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  36:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  37:</span>             wnd = <span style="color: #0000ff">new</span> HotKeyMessageWindow(<span style="color: #0000ff">this</span>);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  38:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  39:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  40:</span>         <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Register(Keys Key)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  41:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  42:</span>             RegisterHotKey(wnd.Hwnd, (<span style="color: #0000ff">int</span>)Key, 0, (<span style="color: #0000ff">int</span>)Key);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  43:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  44:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  45:</span>         <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Register(Keys Key, KeyModifiers Modifier)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  46:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  47:</span>             RegisterHotKey(wnd.Hwnd, (<span style="color: #0000ff">int</span>)Key, (<span style="color: #0000ff">int</span>)Modifier, (<span style="color: #0000ff">int</span>)Key);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  48:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  49:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  50:</span>         <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> UnRegister(Keys Key)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  51:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  52:</span>             UnregisterHotKey(wnd.Hwnd, (<span style="color: #0000ff">int</span>)Key);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  53:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  54:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  55:</span>         <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> OnKeyPressed(Keys key)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  56:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  57:</span>             <span style="color: #008000">//forward the keypress event to the outside world.</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  58:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  59:</span>             <span style="color: #0000ff">if</span> (KeyPressed != <span style="color: #0000ff">null</span>)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  60:</span>             {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  61:</span>                 KeyPressed(key);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  62:</span>             }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  63:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  64:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  65:</span>         <span style="color: #0000ff">private</span> <span style="color: #0000ff">class</span> HotKeyMessageWindow : MessageWindow</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  66:</span>         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  67:</span>             <span style="color: #0000ff">private</span> <span style="color: #0000ff">const</span> <span style="color: #0000ff">int</span> WM_HOTKEY = 0x312;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  68:</span>             <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> HotKeys parent;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  69:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  70:</span>             <span style="color: #0000ff">public</span> HotKeyMessageWindow(HotKeys h)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  71:</span>             {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  72:</span>                 parent = h;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  73:</span>             }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  74:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  75:</span>             <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> WndProc(<span style="color: #0000ff">ref</span> Message msg)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  76:</span>             {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  77:</span>                 <span style="color: #0000ff">switch</span> (msg.Msg)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  78:</span>                 {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  79:</span>                     <span style="color: #0000ff">case</span> WM_HOTKEY:</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  80:</span>                         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  81:</span>                             <span style="color: #0000ff">int</span> keyNum = msg.WParam.ToInt32();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  82:</span>                             Keys key = (Keys) keyNum;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  83:</span>                             parent.OnKeyPressed(key);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  84:</span>                             <span style="color: #0000ff">break</span>;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  85:</span>                         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  86:</span>                     <span style="color: #0000ff">default</span>:</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  87:</span>                         {</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  88:</span>                             <span style="color: #0000ff">base</span>.WndProc(<span style="color: #0000ff">ref</span> msg);</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  89:</span>                             <span style="color: #0000ff">break</span>;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  90:</span>                         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  91:</span>                 }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  92:</span>             }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  93:</span>         }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  94:</span>     }</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  95:</span> }</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        You’ll need to add a reference to Microsoft.WindowCE.Forms in your compact framework app.
      </p>
      
      <p>
        The hot key interop call technically requires a windows form to receive the hotkey press using a windows message pump handler. This isn’t available in the standard System.Windows.Forms, but it is available in the MessageWindow class in the Microsoft.WindowsCE.Forms assembly. This code instantiates a class that inherits from MessageWindow so that we can handle the hot key press from anywhere in our application, not just from a specific form.
      </p>
      
      <p>
        As an example of this being a global hotkey, create a Compact Framework app with a single form in it, and change your Program.cs to look like this:
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">class</span> Program</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   2:</span> {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   3:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   4:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">static</span> HotKeys hotKeys;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   5:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   6:</span>     [MTAThread]</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   7:</span>     <span style="color: #0000ff">static</span> <span style="color: #0000ff">void</span> Main()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   8:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">   9:</span>         hotKeys = <span style="color: #0000ff">new</span> HotKeys();</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  10:</span>         hotKeys.Register(Keys.A);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  11:</span>         hotKeys.KeyPressed += hotKeys_KeyPressed;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  12:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  13:</span>         Application.Run(<span style="color: #0000ff">new</span> Form1());</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  14:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  15:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  16:</span>     <span style="color: #0000ff">private</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">void</span> hotKeys_KeyPressed(Keys key)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  17:</span>     {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  18:</span>         <span style="color: #0000ff">switch</span> (key)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  19:</span>         {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  20:</span>             <span style="color: #0000ff">case</span> Keys.A:</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  21:</span>                 {</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  22:</span>                     MessageBox.Show(<span style="color: #006080">"You pressed A!"</span>);</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  23:</span>                     <span style="color: #0000ff">break</span>;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  24:</span>                 }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  25:</span>             <span style="color: #0000ff">default</span>: <span style="color: #0000ff">break</span>;</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  26:</span>         }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  27:</span>     }</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  28:</span>&#160; </pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre><span style="color: #606060">  29:</span> }</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              Anytime you press the “a” or “A” key in the application, you’ll get a message box that pops up. The API for the HotKeys class could be made quite a bit more elegant, IMO. I don’t really like using switch statements like I showed in the program.cs… I would rather register a hotkey with a delegate that gets fired, like this:
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> RegisterHotKeys()</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span>     hotKeys.Register(Keys.A, HandleAPress);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span> }</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   6:</span> <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> HandleAPress()</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   7:</span> {</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   8:</span>     MessageBox.Show(<span style="color: #006080">"You Presed A!"</span>);</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   9:</span> }</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    I don’t want to spoil all the fun of playing with this little snippet of code, though. So I’ll let you, the reader, explore the possibilities of implementing this API. 🙂
                  </p>