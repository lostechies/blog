---
id: 11
title: Windows-Friendly Cygwin Paths
date: 2010-07-09T16:19:23+00:00
author: Derek Greer
layout: post
guid: /blogs/derekgreer/archive/2010/07/09/windows-friendly-cygwin-paths.aspx
dsq_thread_id:
  - "262468829"
categories:
  - Uncategorized
tags:
  - Cygwin
---
Not too long ago, I ventured into using Rake for my .Net project builds.&#160; Given that my shell preference on Windows is Cygwin’s bash port (via the excellent [mintty](http://code.google.com/p/mintty/) terminal), I tend to prefer installing the Cygwin ruby package rather than using the [RubyInstaller for Windows](http://rubyinstaller.org/).

One issue I ran into, however, was that the absolute paths generated under rake resolve to /cygdrive/c/ by default.&#160; This isn’t an issue when calling applications compiled for Cygwin, but they pose a problem if you need to pass an absolute path as a parameter to commands like MSBuild.&#160; One way to resolve this problem is to create an NTFS mount point which mirrors a path that Windows executables can resolve.&#160; Here’s how: 

Open up the file /etc/fstab which configures the mount table under Cygwin.&#160; Add a line similar to the following:

<pre class="brush:bash">C:/projects /projects ntfs binary,posix=0,user 0 0</pre>

### &nbsp;

This mounts the C:/projects folder (where I do all of my project development) as /projects.&#160; Note that the mount point must be named the same as the actual physical NTFS path.&#160; After restarting the shell, the new mount point will be available.&#160; This can be verified by issuing the mount command:

<pre>&gt; mount
C:/cygwin/bin on /usr/bin type ntfs (binary,auto)
C:/cygwin/lib on /usr/lib type ntfs (binary,auto)
C:/projects on /projects type ntfs (binary,posix=0,user)
C:/cygwin on / type ntfs (binary,auto)
C: on /cygdrive/c type ntfs (binary,posix=0,user,noumount,auto)
D: on /cygdrive/d type iso9660 (binary,posix=0,user,noumount,auto)
F: on /cygdrive/f type iso9660 (binary,posix=0,user,noumount,auto)
G: on /cygdrive/g type ntfs (binary,posix=0,user,noumount,auto)
H: on /cygdrive/h type ntfs (binary,posix=0,user,noumount,auto)
I: on /cygdrive/i type vfat (binary,posix=0,user,noumount,auto)</pre>



Since Windows accepts the forward slash as a directory delimiter and considers drive letters to be optional, expanding a relative path under the NTFS mount point will render a path that can be correctly interpreted by Windows executables.
