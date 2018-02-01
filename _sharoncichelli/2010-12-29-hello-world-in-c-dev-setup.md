---
id: 3867
title: Hello World in C, Dev Setup
date: 2010-12-29T21:15:00+00:00
author: Sharon Cichelli
layout: post
guid: /blogs/sharoncichelli/archive/2010/12/29/hello-world-in-c-dev-setup.aspx
dsq_thread_id:
  - "263371082"
categories:
  - 'C#'
---
As mentioned, [I&#8217;m learning C](/blogs/sharoncichelli/archive/2010/12/03/dipping-into-c.aspx), and I&#8217;ve achieved hello-world, plus recursive calculations of factorials and some data structures. Whee. 🙂 For those playing along at home, I&#8217;ll describe my dev setup.

But first, an unexpected discovery: Counter to my intuition, there&#8217;s a beneficial synergy between learning a new editor and learning a new language at the same time. I had thought it would be too many new things to take on at once. I&#8217;ve wanted to learn [Vim](http://www.vim.org/) for its beautiful efficiency, but its formidable learning curve repels all comers. I couldn&#8217;t gain traction. When writing in a language with which I am comfortable (C#, English), my thoughts would run too fast, too far ahead of my rudimentary editor skills, ideas slipping out of my grasp as I stumbled around the text with j, k, h, and l (and never the one I meant). But in C, where I am carefully picking my way over unfamiliar terrain, my lines of code have slowed down to match my fingers. Because I am trying to hang onto only one edit at a time, I can spare a second to check that A will switch me to insert mode at the end of the current line. I recommend it: learning a new language is a good time to learn a new text editor.

## Sandbox

I use [VirtualBox](http://www.virtualbox.org/) to run virtual machines. VMs are excellent for experiment-based learning; think of it: a nice clean server that you can start up, poke and abuse, throw away and start again. If you start with the right VM image&mdash;for example, one [configured for Ruby on Rails](http://www.turnkeylinux.org/rails)&mdash;you can jump right into the experimentation without all the installation hoop-jumping.

For this endeavor I chose [TurnKey Linux&#8217;s Core appliance](http://www.turnkeylinux.org/core) because it&#8217;s just Linux and not much else, following their [instructions for installing a TurnKey appliance](http://www.turnkeylinux.org/docs/installation-appliances-virtualbox).

To install a compiler (later), I needed my VM to connect to the internet. In VirtualBox Settings > Network, I set &#8220;Attached to&#8221; to &#8220;Bridged Adapter,&#8221; meaning the VM could use my laptop&#8217;s connection, and the adapter&#8217;s &#8220;Name&#8221; to my wireless card. (The other choice in the dropdown list is a PCI-E Fast Ethernet Controller, and that&#8230; didn&#8217;t work.) With that set, I powered up the VM, which starts the webmin console. I let it automatically configure DHCP, and I was internet-ready.

## Editor

Vim is already installed on the Core VM image, so I just needed to type &#8220;vim helloworld.c&#8221; to start stumbling around my new code file. I&#8217;m relying on the TuXfiles [Vim cheat sheet](http://www.tuxfiles.org/linuxhelp/vimcheat.html).

## Compiler

I chose [GCC, the GNU Compiler Collection](http://gcc.gnu.org/) for my C compiler, and I needed to download and install it. Following TurnKey&#8217;s [apt-get instructions](http://www.turnkeylinux.org/docs/apt-howto):

<ul type="none">
  <li>
    apt-get update (to update apt&#8217;s list of modules)
  </li>
  <li>
    apt-cache search gcc (to find modules for the gcc compiler &#8211; gcc-4.1 looked right.)
  </li>
  <li>
    apt-cache show gcc-4.1 (to get info about it)
  </li>
  <li>
    apt-get install gcc-4.1 (to install it)
  </li>
  <li>
    gcc-4.1 myfile.c -o myexename (to compile and generate myexename executable)
  </li>
  <li>
    ./myexename (to run my program)
  </li>
</ul>

## Hello World

I followed a [video that creates and compiles a C program using the GCC compiler](http://www.youtube.com/watch?v=_0_4yiD8_hk). &#8220;Hello, World!&#8221; A simple phrase, profoundly satisfying.