---
wordpress_id: 146
title: 'Using Vim As Your C# Code Editor From Visual Studio'
date: 2010-04-23T12:00:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/04/23/using-vim-as-your-c-code-editor-from-visual-studio.aspx
dsq_thread_id:
  - "262068674"
categories:
  - .NET
  - 'C#'
  - Productivity
  - Resharper
  - Vim
  - Visual Studio
---
No, not through [ViEmu](http://www.viemu.com/) or [VsVim](http://github.com/jaredpar/VsVim)… I mean, actual honest to goodness [Vim](http://vim.org). 

I’ve been working with Ruby for a not quite a year now (though, not much recently) and in that time I’ve tried a lot of editors and IDEs for ruby on Windows – including the Resharper-like RubyMine from JetBrains. RubyMine is a very powerful IDE with a lot of great refactoring tools built into it, etc. … but after all my experiments with the various ruby editors I find that the only thing I want is a good syntax highlighter and tree navigation. There are dozens of free editors out there that have this and a bunch of paid-for apps that also provide this in very convenient ways, including Vim with it’s many plugins.

Looking at my use of C#, though, I find myself constantly wanting Resharper to be around. Honestly, I think Resharper has made me a lazy developer with C# – and that’s probably a good thing in the world of C# with all of it’s syntax ceremony, etc. But I keep wondering to myself what would happen if I didn’t have that crutch to lean on and I went down to barebones Vim to do my C# coding. 

&#160;

### Add Vim To Visual Studio’s Open With Option

I realize that I still want visual studio around for certain things, so I am not going to completely abandon it … yet… but I decided to do an experiment today and see what I could get away with and get away from, in my C# coding. I added gVim (the Windows Vim port) to my Visual Studio “Open With” options for my C# code files. 

In Visual Studio 2008 (I’m currently doing Windows Mobile development, so I’m stuck with VS2008 for now) right click on a .cs file and selected Open With. You’ll get a nice dialog listing all the different options for .cs files. Click the Add button to add a new one.

 <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_5096F009.png" width="423" height="167" />

Browse to your gvim.exe location with the “…” button and select it. The Friendly name will be populated automatically. Then hit OK. You’ll end up with Vi Improved in your Open With dialog box. 

 <img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" alt="image" src="http://lostechies.com/derickbailey/files/2011/03/image_76F8D354.png" width="575" height="375" /></p> 

Now if you’re really brave, set this as the default. 🙂 If you don’t want to set it as default (I don’t blame you… at least not until I’m more comfortable with this) you can just right click on a file and select Open With whenever you want to use Vim.

&#160;

### Stumble, Trip, Stumble, Trip

Of course I find myself stumbling and tripping and falling all over myself and vim when I’m editing C# files. I’m so used to Resharper being there to do everything for me that I find it very difficult to be productive. I don’t event have a good set of vim files for color coding my C# at this point, so that makes it even more ‘fun’. But I’m determined to see what I can do with Vim as my actual code editor… to face the problems that I run into and find solutions for them… to see if I actually need a micro-code generator like Resharper and find out if it really is just a crutch or if it is one of those necessary items because of the style of development that I engage in with C#. I’m hoping that I can find Vim plugins and syntax highlighting files that will help me solve the various problems that I run into, and that I can slowly replace more and more of my Resharper usage with Vim usage.

I don’t expect to give up Visual Studio any time soon, and I’m not sure that I’ll ever be able to get away from it completely… but we’ll see. I am hoping that over time I’ll rely less and less on Visual Studio and Resharper or at least come away from this experience with a better understanding of why I need them (if that’s the case). 

… and now I’m off to find a good set of C# vim files.