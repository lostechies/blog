---
id: 4037
title: VMWare Fusion Shared Folders and Visual Studio Development
date: 2009-03-31T05:01:00+00:00
author: Scott Reynolds
layout: post
guid: /blogs/scottcreynolds/archive/2009/03/31/vmware-fusion-shared-folders-and-visual-studio-development.aspx
categories:
  - mac
  - vmware
---
So today I had a bit of an adventure that I figured I would document for those of you that may run into this same thing and get just as frustrated as I was for many hours trying to make this work.

I do my work on a MacBook Pro these days. My first setup was to do my .net work in a Vista VM using VMWare Fusion. I created a vmware disk to store my code, installed TortoiseSVN, and worked normally as if I were on a regular windows box. It was a nice little self-contained world.

As my usage of other tools grew, I ran into problems with this setup. Namely: 

  * Tortoise is aptly named, speedwise. Especially on a VM. But also just on regular windows.
  * My files were locked away in my VM unusable by me (in an easy way) natively on the Mac OSX host. This became an issue as I started to work more and more in alternative tools, like MonoDevelop and TextMate.
  * My files were locked away in my VM unable to be explicitly backed up by TimeMachine. Less of an issue because they&#8217;re in a central source repo, but still an issue.
  * I wanted to use Git more and git-svn on windows is&#8230;slow. Also cygwin and I are not buddies yet. Plus I have a nice Terminal setup.
  * The VMdisk was big, unwieldy, not all that portable, and not all that speedy anyway.

So what I decided to do was set up a VMWare shared folder from my ~/code folder on Mac OSX, exposing it to the guest OS (Vista) as a mapped drive (z: by default). Then I cloned the svn repo with git svn to this folder, checked out a local branch, flipped to my VM, opened the project in Visual Studio, and was prompted with partial trust errors (&#8220;Project Location Not Trusted&#8221;). At first it seems like ignoring these errors will work, until you go to run some tests, and n number of tools (RhinoMocks, NUnit, SpecUnit, and so on) throw the error that the assembly does not allow partially trusted callers.

Long story short, the solution is to use caspol.exe to set the share to full trust. The documentation on this tool is terse at best, and cobbling together several blog posts (none of which got it right&#8230;) I found the command-line magic that made things work.

&nbsp;

  1. Disable UAC (may not be completely necessary, but UAC sucks so do it anyway)
  2. Open a Visual Studio 2008 Command Prompt as Administrator (right-click and run as administrator) and run the following:
  3. _caspol -m -ag 1.5 -url file://z:/* FullTrust_

Breaking that command down a bit, you may have to substitute a couple of params. The -ag 1.5 may be different on your machine. You need to add the share (from mac osx anyway) into the &#8220;Internet\_Zone&#8221; because something to do with the share path starting with a . makes Vista assume it&#8217;s in the Internet and not Intranet. To find the group number for your Internet\_Zone run the command _caspol -m -listgroups_ and look for the one that says &#8220;Zone: Trusted-Internet&#8221; (or something similar, I make no claims to Vista operating sanely across all installs). Mine was 1.5.

The second bit you may need to change is the actual share location. Mine mapped to z:/ by default, but you&#8217;ll want to check that yourself.

If all goes well you should get a message about &#8220;Added union code group with -url membership condition&#8230;&#8221; and a &#8220;success&#8221; status. All that out of the way, I reloaded Visual Studio from the share, ran tests, and they failed, but for the right reasons 😉