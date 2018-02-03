---
wordpress_id: 3702
title: 'TalesFromTheSmellySide(Of Code) &#8211; Episode #2 &#8211; SQL Injection Infection'
date: 2007-11-02T14:36:00+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/11/02/talesfromthesmellyside-of-code-episode-2-sql-injection-infection.aspx
categories:
  - tales from the smelly side
---
Just so folks don&#8217;t think I&#8217;m coming off as elitist with my [new
  
little series](http://joeydotnet.com/blog/archive/2007/10/29/talesfromthesmellysideltcodegt---episode-1.aspx), here&#8217;s an oldie but a goodie from yours truly on **my
  
first&nbsp;.NET project way back in early 2002.**&nbsp; (And really, my first real
  
programming project, since my&nbsp;previous life was&nbsp;mainly&nbsp;doing
  
scripting/automation.)

And this is VB, folks.&nbsp; <gasp>&nbsp; (Notice the title change?)

<div>
  <pre>cmd.CommandText = <span>"UPDATE ATT_Circuits SET "</span> & strField & <span>"='"</span> & strControlText.Replace(<span>"'"</span>, <span>""</span>) & <span>"' WHERE Hostname='"</span> & txtHostname.Text & <span>"'"</span></pre>
</div>

Ok, so I don&#8217;t think I really need to point out all the embarrassing problems
  
in this one line of code.&nbsp; Obviously it should be parameterized and that
  
Hungarian notation just gives me the willies.&nbsp; Oh and did I mention that I had
  
this in right in the code behind for a web form?&nbsp; Eeek!

In my defense, at the time (and some would say this is still the case),
  
that&#8217;s what Microsoft was encouraging.&nbsp; Back then I didn&#8217;t know any better.&nbsp; But
  
thankfully the many evening and late night hours I&#8217;ve spent over the past&nbsp;5
  
years has allowed me to learn much better ways of building software.&nbsp; <insert
  
thank you to my wife here />&nbsp; Of course, this process seems to never cease!&nbsp;
  
😐

**Anyone else brave enough to share smells from their first software
  
projects?&nbsp; 😀**

&nbsp;