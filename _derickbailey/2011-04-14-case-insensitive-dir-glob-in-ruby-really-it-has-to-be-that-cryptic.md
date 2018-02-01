---
id: 263
title: 'Case Insensitive Dir.glob In Ruby: Really? It Has To Be That Cryptic?'
date: 2011-04-14T08:53:48+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=263
dsq_thread_id:
  - "279330617"
categories:
  - Ruby
---
I&#8217;m writing a small file importer in Ruby 1.9, to grab files form an FTP drop. The files are HL7 format, and will have a .HL7 extension. However, I had no guarantee that it would be capitalized .HL7 for the name.

The first version of the code I wrote, to get around this, was ugly:

<pre><span style="line-height: 0px">def import(folder)
  files = []
  files &lt;&lt; Dir.glob(folder + "**/*.HL7")
  files &lt;&lt; Dir.glob(folder + "**/*.hl7")
  files &lt;&lt; Dir.glob(folder + "**/*.Hl7")
  files &lt;&lt; Dir.glob(folder + "**/*.hL7")

  files.flatten.each { |file|
    LabResult.import(file)
  }
end</span></pre>

<div>
  <p>
     
  </p>
  
  <p>
    After some googling, I found this post where someone is asking for the same thing, wondering if there is <a href="http://www.ruby-forum.com/topic/119964">a way to do case insensitive Dir.globs</a>. About halfway down the list of replies, I found what I was looking for.
  </p>
  
  <p>
    Now my code is much less ugly, and much less intuitive:
  </p>
  
  <pre><span style="line-height: 0px">def import(folder)
  files = Dir.glob(folder + "**/*.hl7", File::FNM_CASEFOLD)
  files.each { |file|
    LabResult.import(file)
  }
end</span><span style="line-height: 0px">﻿</span></pre>
</div>

<div>
  <p>
     
  </p>
  
  <p>
    Really?! <strong>File::FNM_CASEFOLD</strong>?! Yeah&#8230; so much for Ruby&#8217;s &#8220;intuitive&#8221; and &#8220;natural language&#8221; syntax. At least it works. Now I just have to add a comment to my code to let people know what this is doing.
  </p>
  
  <p>
    Any know of a better, more intuitive way of doing case insensitive Dir.globs?
  </p>
</div>