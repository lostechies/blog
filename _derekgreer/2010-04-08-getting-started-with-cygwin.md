---
wordpress_id: 7
title: Getting Started With Cygwin
date: 2010-04-08T14:49:00+00:00
author: Derek Greer
layout: post
wordpress_guid: /blogs/derekgreer/archive/2010/04/08/getting-started-with-cygwin.aspx
dsq_thread_id:
  - "262468834"
categories:
  - Uncategorized
tags:
  - Cygwin
---
With the increasing popularity of the <a id="b89_" title="Git" href="http://git-scm.com/" target="_blank">Git</a> version control system, many .Net developers are being introduced for the first time to Unix-like tools for Windows by way of two popular Git client platforms: <a id="nucy" title="msysgit" href="http://code.google.com/p/msysgit/" target="_blank">msysgit</a> and <a id="tw22" title="Cygwin" href="http://en.wikipedia.org/wiki/Cygwin" target="_blank">Cygwin</a>. The more substantial of the two, Cygwin is a Linux-like environment for Windows and provides a wide range of useful utilities. The following is a guide for helping newcomers quickly get up and going with the Cygwin environment.

## Installation

The first step is to obtain the installer from the <a id="izx." title="Cygwin home page" href="http://www.cygwin.com/" target="_blank">Cygwin home page</a>. Upon running the installer, you&#8217;ll be presented with a wizard which guides you through the installation process:

<img style="border-right-width: 0px; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/04/cygwin-step-1-3.png" width="587" height="480" />

&nbsp;

[<img style="border-right-width: 0px; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/04/cygwin-step-4-6.png" width="584" height="480" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/04/cygwin-step-4-6.png)

Upon arriving at the &#8220;Select Packages&#8221; dialog, you&#8217;ll be presented with all the packages available from the selected mirror site(s):

<img style="border-right-width: 0px; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/04/cygwin-packages-1.png" width="640" height="417" />

The installer allows you to install selected packages, or install by category:

<img style="border-right-width: 0px; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/04/cygwin-packages-2.png" width="640" height="224" />

At the package level, the rotating arrow icon allows you to cycle through the choices of installing one of the package versions available, skipping the package, or in the event the package is already installed, keeping, reinstalling, uninstalling, or obtaining the source code for the package. At the category level, the rotating arrow icon allows you to cycle through the choices of Default, Install, Reinstall, or Uninstall.

It&#8217;s best to only select the packages you really think you&#8217;ll want to use or immediately explore. There&#8217;s quite a bit of applications available and choosing everything would result in quite a large installation time. The installer can always be run at a later time to pickup up additional packages you want to explore.

By default, Cygwin selects the Base category packages as well as a few other odds & ends. Among the packages skipped by default, you may consider also installing the following:

<table style="height: 231px" id="r7mi" border="1" cellspacing="0" cellpadding="3" width="700">
  <tr>
    <td width="206">
      <b>Category</b>
    </td>
    
    <td width="205">
      <b>Package</b>
    </td>
    
    <td width="287">
      <b>Description</b>
    </td>
  </tr>
  
  <tr>
    <td width="204">
      Admin
    </td>
    
    <td width="203">
      cygrunsrv
    </td>
    
    <td width="291">
      Utility for easily working with Windows services (adding/removing/starting/stopping). This is beneficial if you&#8217;d like to run git daemon or sshd as a windows service for anonymous or authenticated access.
    </td>
  </tr>
  
  <tr>
    <td width="203">
      Archive
    </td>
    
    <td width="201">
      zip, unzip
    </td>
    
    <td width="294">
      PKZip compatible zip capabilities.
    </td>
  </tr>
  
  <tr>
    <td width="202">
      Editors
    </td>
    
    <td width="200">
      vim
    </td>
    
    <td width="297">
      An enhanced VI editor.
    </td>
  </tr>
  
  <tr>
    <td width="200">
      Net
    </td>
    
    <td width="199">
      openssh
    </td>
    
    <td width="299">
      Secure shell (ssh) client and server programs.
    </td>
  </tr>
  
  <tr>
    <td width="200">
      Utils
    </td>
    
    <td width="198">
      ncurses
    </td>
    
    <td width="300">
      Terminal utilities (has a clear command for clearing the screen).
    </td>
  </tr>
  
  <tr>
    <td width="199">
      Web
    </td>
    
    <td width="198">
      tidy
    </td>
    
    <td width="301">
      Utility for validating and formatting HTML.
    </td>
  </tr>
  
  <tr>
    <td width="199">
      Web
    </td>
    
    <td width="198">
      curl
    </td>
    
    <td width="302">
      Multi-protocol file transfer tool. This tool is useful for scripting HTTP interaction.
    </td>
  </tr>
</table>

In addition, I personally always install the X11 category packages. While this adds a bit to the download size, it gives you the ability to run your preferred shell (e.g. bash) in an xterm as opposed to the standard terminal window. I&#8217;ll cover a bit of X11 installation and customization later in this guide.

When you&#8217;re done selecting your packages, click &#8220;Next&#8221; and the install will begin:

<img style="border-right-width: 0px; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/04/cygwin-step-7.png" />

<img style="border-right-width: 0px; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/04/cygwin-step-8.png" />

Once complete, click the Finish button and you&#8217;re done with the install.

## Bash Shell Customization

If you selected the &#8220;Add icon to Start Menu&#8221; option during the install then you should have a new shortcut entitled &#8220;Cygwin Bash Shell&#8221; which will start the bash shell as an interactive login shell (i.e. bash &#8211;login -i). If not, you can browse to cygwin.bat file located within the chosen installation folder.

When bash runs for the first time, it checks to see if the home directory (denoted in the /etc/passwd file) exists for your account. If not, it creates the directory and copies over some default config files for your shell:

<img style="border-right-width: 0px; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/04/bash-text.png" />

The .bash\_profile is used for login shells while the .bashrc file is used for interactive, non-login shells. The default .bash\_profile configuration sources the .bashrc file if it exists, so both are sourced for interactive login shells. This effectively allows the .bashrc to serve as the core configuration for both login and non-login shells. The .inputrc file is used to set custom key mappings. Of the three, the .bashrc file will generally be the one you&#8217;ll deal with most often.

Go ahead and open up the .bashrc file. (Note: Microsoft Notepad does not display Unix-style line endings correctly. If using a Windows editor, use Wordpad.) After opening the file, you&#8217;ll notice that most of the configuration is commented out. The only active configuration are commands to unset the Windows TMP and TEMP variables. You can keep this if you like, but I prefer to keep things a bit more tidy and only have the configuration I actually use. If you want to view the default contents of this file, it can always be viewed from its original source in /etc/skel. The following is a more minimal configuration you might wish to start with:

&nbsp;

<pre>unset TMP
unset TEMP

PATH=.:~/bin:${PATH}
PATH=${PATH}:c:/Windows/Microsoft.Net/Framework/v3.5/
PATH=${PATH}:c:/Program Files/Reflector/
PATH=${PATH}:c:/Program Files/Microsoft SDKs/Windows/v6.1/Bin/

. ~/.alias
. ~/.functions
</pre>

&nbsp;

In this configuration, several folders have been added to the PATH environment variable. The first places a ~/bin folder before the PATH. This ensures any custom scripts found in the users bin folder occur first in the path allowing commands to be overridden. The remaining three lines are example folders you might want to set if you are doing .Net development related tasks at the bash command line.

The remaining two lines assume the existence of two new files, .alias and .functions. I find storing aliases and functions separately to be a bit more tidy, as well as making it easier to share with others.

Now, let&#8217;s take a look at the .bash_profile configuration. By default, the only configuration that exists is the sourcing of the .bashrc file. Again, normally the .bashrc file is only sourced for non-login shells, so this ensures the .bashrc settings are picked up for login shells as well.

In this file, let&#8217;s replace the contents with the following:

&nbsp;

<pre>#  source the system wide bashrc if it exists
if [ -e /etc/bash.bashrc ]  ; then
    source /etc/bash.bashrc
fi
# source the users  bashrc if it exists
if [ -e "${HOME}/.bashrc" ] ; then
    source  "${HOME}/.bashrc"
fi

PS1='[h]: ${PWD##*/} &gt; '
set -o vi
export  DISPLAY=127.0.0.1:0.0
</pre>

&nbsp;

In addition to the existing configuration, we&#8217;ve added three additional settings. The first customizes how the prompt appears at the command line by setting the PS1 variable. This prompt is a bit plain, but you can spruce it up with a bit of color by replacing it with the following:

PS1='\[33]0;w0733[32m\]\[h\]: [33[33m ${PWD##*/}33[0m] > &#8216;

Next, I&#8217;ve issued: &#8220;set -o vi&#8221;. This tells bash to use a vi-style command line editing interface which let&#8217;s you more efficiently issue and edit commands at the command line. You can delete this if you don&#8217;t ever plan on learning vi.

Next, I&#8217;ve set an X environment variable named &#8220;DISPLAY&#8221; to my localhost. This tells the xterm and other X applications where to attempt to display. You can delete this if you don&#8217;t plan on running an xterm, but leaving it certainly won&#8217;t hurt.

This should get you started. Your config files will likely evolve from here if you find yourself working at the command line often.

## Aliases

The next step you may want to take is to define some command aliases. The bash alias command allows you to set up aliases for verbose or otherwise undesirable commands. As indicated, I store all of my aliases in a .alias file in my home directory to segregate them away from the rest of my .bashrc configuration. Here is a subset of my current list of aliases you might find useful:

&nbsp;

<pre>alias programfiles="cd /cygdrive/c/Program Files"
alias projects='cd /cygdrive/c/projects'
alias spikes='cd /cygdrive/c/projects/spikes'
alias vs='cmd /c *.sln'
alias vs9='/cygdrive/c/Program Files/Microsoft Visual Studio 9.0/Common7/IDE/devenv.exe *.sln&'
alias wordpad='/cygdrive/c//Program Files/Windows NT/Accessories/wordpad.exe'
alias config='cd /cygdrive/c/Windows/Microsoft.NET/Framework/v2.0.50727/CONFIG'
alias mydocs='cd /cygdrive/c/Users/${USER}/Documents'
alias myhome='cd /cygdrive/c/Documents and Settings/${USER}/'
alias fusion='fuslogvw.exe'
</pre>

&nbsp;

You&#8217;ll be surprised at how fast you&#8217;ll start zipping around the system once you&#8217;ve got some good navigation aliases in place.

## Functions

I don&#8217;t tend to write a lot of bash functions, but I&#8217;m including this section here for completeness. Like the aliases, I like to segregate any functions I do write away from my main config file to make things a bit cleaner. As an example of what you can do, here is the contents of an example .functions file which allows you to tweet from the command line:

&nbsp;

<pre>tweet()
{
    read -s -p "Password:" password
    curl -u  derekgreer:$password -d status="$1"  http://twitter.com/statuses/update.xml
}
</pre>

&nbsp;

<div class="theme-note">
  Note: If you want to actually use this function then you&#8217;ll need to have downloaded the curl package and will need to modify the Twitter id.
</div>

## Basic Commands

If you&#8217;re completely new to the Unix shells, the following are some common commands to get you started with navigating around, creating folders, deleting files, etc.:

<table style="height: 231px" id="pt.-" border="1" cellspacing="0" cellpadding="3" width="700">
  <tr>
    <td width="349">
      <b>Command</b>
    </td>
    
    <td width="349">
      <b>Description</b>
    </td>
  </tr>
  
  <tr>
    <td width="349">
      cd
    </td>
    
    <td width="349">
      Change to home directory
    </td>
  </tr>
  
  <tr>
    <td width="349">
      cd [directory name]
    </td>
    
    <td width="349">
      Change to a specified directory
    </td>
  </tr>
  
  <tr>
    <td width="349">
      cd &#8211;
    </td>
    
    <td width="349">
      Change to the last directory
    </td>
  </tr>
  
  <tr>
    <td width="349">
      ls
    </td>
    
    <td width="349">
      List the contents of the current folder (like dir)
    </td>
  </tr>
  
  <tr>
    <td width="349">
      ls -la
    </td>
    
    <td width="349">
      List the contents of the current folder in long format including all hidden files
    </td>
  </tr>
  
  <tr>
    <td width="349">
      cat [filename]
    </td>
    
    <td width="349">
      Print the context of a file (like DOS type)
    </td>
  </tr>
  
  <tr>
    <td width="349">
      ![command prefix]
    </td>
    
    <td width="349">
      Run the last command starting with the specified prefix.
    </td>
  </tr>
  
  <tr>
    <td width="349">
      mkdir [directory name]
    </td>
    
    <td width="349">
      Make a new directory
    </td>
  </tr>
  
  <tr>
    <td width="349">
      mkdir -p [directory hierarchy]
    </td>
    
    <td width="349">
      Make a all directories listed (e.g. mkdir -p a/b/c/d)
    </td>
  </tr>
  
  <tr>
    <td width="349">
      rm [filename]
    </td>
    
    <td width="349">
      Remove a file
    </td>
  </tr>
  
  <tr>
    <td width="349">
      rm -rf [filename]
    </td>
    
    <td width="349">
      Remove recursively with force
    </td>
  </tr>
  
  <tr>
    <td width="349">
      find [start folder] -name [regex] -print
    </td>
    
    <td width="349">
      Starting at the start folder, find a file matching the given regular expression.
    </td>
  </tr>
  
  <tr>
    <td width="349">
      grep [regex] [filename]
    </td>
    
    <td width="349">
      Display all lines matching the regular expression from the given file.
    </td>
  </tr>
</table>

## Scripts

Once you start getting comfortable with the available commands, you may wish to start writing your own scripts to help with various everyday tasks. While covering the basics of bash shell scripting is beyond the intended scope of this article, you can obtain an archive of some scripts I&#8217;ve written for my own purposes from [here](http://www.aspiringcraftsman.com/downloads/bashscripts.zip "Bash Scripts"){#cf28}. Here&#8217;s a list of the contained scripts along with a brief description:

<table style="height: 293px" id="i6mq" border="1" cellspacing="0" cellpadding="3" width="700">
  <tr>
    <td width="349">
      <b>Script</b>
    </td>
    
    <td width="349">
      <b>Description</b>
    </td>
  </tr>
  
  <tr>
    <td width="349">
      clean
    </td>
    
    <td width="349">
      Cleans up common temp/generated Visual Studio files.
    </td>
  </tr>
  
  <tr>
    <td width="349">
      detachfromcvs
    </td>
    
    <td width="349">
      Removes CVS folders.
    </td>
  </tr>
  
  <tr>
    <td width="349">
      detachfromtfs
    </td>
    
    <td width="349">
      Removes TFS bindings from source files.
    </td>
  </tr>
  
  <tr>
    <td width="349">
      diff
    </td>
    
    <td width="349">
      Overrides the diff command to call WinMerge
    </td>
  </tr>
  
  <tr>
    <td width="349">
      git-diff-wrapper.sh
    </td>
    
    <td width="349">
      Diff wrapper for use with Git.
    </td>
  </tr>
  
  <tr>
    <td width="349">
      replaceinfile
    </td>
    
    <td width="349">
      Replaces string patterns in a file.
    </td>
  </tr>
  
  <tr>
    <td width="349">
      replaceinfiles
    </td>
    
    <td width="349">
      Wrapper for calling replaceinfile for files matching a given pattern.
    </td>
  </tr>
  
  <tr>
    <td width="349">
      rgrep
    </td>
    
    <td width="349">
      Recursive grep (Also greps from .Net assemblies)
    </td>
  </tr>
  
  <tr>
    <td width="349">
      unix2dosall
    </td>
    
    <td width="349">
      Recursive unix2dos
    </td>
  </tr>
</table>

## X11 &#8211; Using an XTerm

<div class="note">
  I now consider this section obsolete. After posting this article, someone clued me into mintty which behaves just like xterm but without all the bloat. I would now recommend this over installing the XServer packages if you’re just after an xterm-like terminal window.&nbsp;&nbsp; Also since this writing, I&#8217;ve learned about <a href="http://sourceforge.net/projects/console/">console2</a>, a multi-tabbed, configurable console application with many of the properties of an xterm (resizable, transparency, better cut-n-paste support, etc.).&nbsp;&nbsp; If you use multiple shells (Cmd.exe, PowerShell, Bash, etc.), definitely check out this project.
</div>

The final portion of this guide is intended for those who would like to explore the X Windows system provided by Cygwin. One of the benefits of running an XServer on Windows is the ability to use an XTerm over the standard terminal provided by DOS. XTerm provides more flexibility over the fonts, colors used, and buffers used, provides dynamic resizing, and provides much more intuitive cut-n-paste capabilities (highlight = cut, middle mouse button = paste). It also displays buffered text which comes in handy when you want to use the tail -f command to follow a log file and queue up a bunch of spaces to visually separate new entries.

Assuming you&#8217;ve already installed the X11 packages, locate the Cygwin-X folder in your start menu and execute the &#8220;XWin Server&#8221; shortcut. By default, the XServer starts a plain white terminal:

<img style="border-right-width: 0px; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/04/white-xterm.png" />

Since this isn&#8217;t likely the style of terminal you&#8217;ll want to work with, you can prevent XServer from starting this default xterm by creating an empty .startxwinrc file in your home directory. You can do this by using the touch command:

touch ~/.startxwinrc

Next, you can modify the XTerm shortcut that was created in your start menu&#8217;s Cygwin-X folder to start a new xterm with no menu, a custom font, colors, a scrollbar, etc. using the following Target value:

C:Cygwinbinrun.exe -p /usr/X11R6/bin xterm -display 127.0.0.1:0.0 -ls -vb -fn 10&#215;20 +tb -bg gray14 -fg ivory -sb -rightbar -sl 400

This command will launch an xterm similar to the following:

<img style="border-right-width: 0px; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/04/xterm.png" />

From here, you may consider adding the XWin Server shortcut to your startup.

That concludes my guide. Enjoy!
