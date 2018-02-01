---
id: 73
title: An Evernote backed Journal using Vim/Emacs
date: 2013-04-07T11:54:31+00:00
author: Ryan Svihla
layout: post
guid: http://lostechies.com/ryansvihla/?p=73
dsq_thread_id:
  - "1194358033"
categories:
  - Evernote
  - Vim
tags:
  - Evernote
  - Vim
---
I journal quite a bit and my holy grail has been using my favorite text editor (Vim or Vim bindings) with Evernote to store the everything in a smart searchable format. Today I stumbled onto a neat little tool that makes this all happen called Geeknote http://www.geeknote.me/.  It&#8217;s written in Python and works fine on my Mac.

### Installing Geeknote

<div>
  In the directory of your choosing run the following script.  This will checkout the latest copy from source and allow you to login:
</div>

<div>
  <blockquote>
    <div id="file-install_geeknote-LC1" class="line">
      <span class="c" style="color: #999988; font-style: italic;">#!/bin/sh</span>
    </div>
    
    <div id="file-install_geeknote-LC2" class="line">
      <span class="c" style="color: #999988; font-style: italic;"># Download the repository.</span>
    </div>
    
    <div id="file-install_geeknote-LC3" class="line">
      git clone git://github.com/VitaliyRodnenko/geeknote.git
    </div>
    
    <div id="file-install_geeknote-LC4" class="line">
    </div>
    
    <div id="file-install_geeknote-LC5" class="line">
      <span class="nb" style="color: #0086b3;">cd </span>geeknote
    </div>
    
    <div id="file-install_geeknote-LC6" class="line">
    </div>
    
    <div id="file-install_geeknote-LC7" class="line">
      <span class="c" style="color: #999988; font-style: italic;"># Launch Geeknote and go through login procedure.</span>
    </div>
    
    <div id="file-install_geeknote-LC8" class="line">
      python geeknote.py login
    </div>
    
    <div id="file-install_geeknote-LC9" class="line">
      <span class="c" style="color: #999988; font-style: italic;">#change vim to whatever you want it to be</span>
    </div>
    
    <div id="file-install_geeknote-LC11" class="line">
      python geeknote.py settings &#8211;editor vim
    </div>
  </blockquote>
</div>

<div>
</div>

<div>
  Then add the following script and execute it from whatever directory you want to install Geeknote into
</div>

<div>
  <blockquote>
    <div id="file-gistfile1-sh-LC1" class="line">
      <span class="c" style="color: #999988; font-style: italic;">#!/bin/sh</span>
    </div>
    
    <div id="file-gistfile1-sh-LC2" class="line">
    </div>
    
    <div id="file-gistfile1-sh-LC3" class="line">
      <span class="c" style="color: #999988; font-style: italic;">#change checkout_dir to match where you&#8217;ve checked out the latest</span>
    </div>
    
    <div id="file-gistfile1-sh-LC4" class="line">
      <span class="nv" style="color: teal;">checkout_dir</span><span class="o" style="font-weight: bold;">=</span>~/Documents/geeknote
    </div>
    
    <div id="file-gistfile1-sh-LC5" class="line">
      <span class="c" style="color: #999988; font-style: italic;">#change notebook to whatever notebook you use as your journal</span>
    </div>
    
    <div id="file-gistfile1-sh-LC6" class="line">
      <span class="nv" style="color: teal;">notebook</span><span class="o" style="font-weight: bold;">=</span>Journal
    </div>
    
    <div id="file-gistfile1-sh-LC7" class="line">
      <span class="nv" style="color: teal;">title</span><span class="o" style="font-weight: bold;">=</span><span class="nv" style="color: teal;">$1</span>
    </div>
    
    <div id="file-gistfile1-sh-LC8" class="line">
      <span class="k" style="font-weight: bold;">if</span> <span class="o" style="font-weight: bold;">[</span> -z <span class="s2" style="color: #dd1144;">&#8220;$1&#8221;</span> <span class="o" style="font-weight: bold;">]</span>
    </div>
    
    <div id="file-gistfile1-sh-LC9" class="line">
      <span class="k" style="font-weight: bold;">    then</span>
    </div>
    
    <div id="file-gistfile1-sh-LC10" class="line">
      <span class="nv" style="color: teal;">        title</span><span class="o" style="font-weight: bold;">=</span><span class="k" style="font-weight: bold;">$(</span>date +%Y-%m-%d<span class="k" style="font-weight: bold;">)</span>
    </div>
    
    <div id="file-gistfile1-sh-LC11" class="line">
      <span class="k" style="font-weight: bold;">fi</span>
    </div>
    
    <div id="file-gistfile1-sh-LC12" class="line">
      <span class="nb" style="color: #0086b3;">echo </span>creating a note named <span class="nv" style="color: teal;">$title</span> in the <span class="nv" style="color: teal;">$notebook</span> notebook
    </div>
    
    <div id="file-gistfile1-sh-LC13" class="line">
    </div>
    
    <div id="file-gistfile1-sh-LC14" class="line">
      python <span class="nv" style="color: teal;">$checkout_dir</span>/geeknote.py create &#8211;title <span class="nv" style="color: teal;">$title</span> &#8211;notebook <span class="nv" style="color: teal;">$notebook</span> &#8211;content <span class="s2" style="color: #dd1144;">&#8220;test&#8221;</span>
    </div>
    
    <div id="file-gistfile1-sh-LC15" class="line">
      python <span class="nv" style="color: teal;">$checkout_dir</span>/geeknote.py edit &#8211;note <span class="nv" style="color: teal;">$title</span> &#8211;notebook <span class="nv" style="color: teal;">$notebook</span> &#8211;content <span class="s2" style="color: #dd1144;">&#8220;WRITE&#8221;</span>
    </div>
  </blockquote>
</div>

<div>
  <h3>
    Writing Journal Entries
  </h3>
  
  <div>
    My script is named journal so for me I just type either of the following:
  </div>
  
  <blockquote>
    <div>
      <span style="background-color: white; font-family: monospace; font-size: 12px; line-height: 16px; white-space: pre;">journal </span> <span style="background-color: white; color: #999988; font-family: Consolas, 'Liberation Mono', Courier, monospace; font-size: 12px; font-style: italic; line-height: 16px;">#creates a note in journal with todays date as the title</span>
    </div>
  </blockquote>
  
  <div>
    or
  </div>
  
  <blockquote>
    <div>
      <span style="background-color: white; font-family: monospace; font-size: 12px; line-height: 16px; white-space: pre;">journal custom_title </span> <span style="background-color: white; color: #999988; font-family: Consolas, 'Liberation Mono', Courier, monospace; font-size: 12px; font-style: italic; line-height: 16px;">#no spaces allowed and will use the title specified</span>
    </div>
  </blockquote>
  
  <div>
  </div>
  
  <h3>
    Summary
  </h3>
  
  <div>
    With a few simple scripts and in moments you two can be writing notes in the command prompt. I highly recommend you extend these scripts to your needs or just use the Geeknote command prompt as you see fit.  <span style="background-color: white; font-family: Consolas, 'Liberation Mono', Courier, monospace; font-size: 12px; line-height: 16px;"> </span>
  </div>
  
  <p>
    &nbsp;
  </p>
</div>