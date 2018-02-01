---
id: 3353
title: Anti-Patterns and Worst Practices – The Arrowhead Anti-Pattern
date: 2009-05-27T12:00:00+00:00
author: Chris Missal
layout: post
guid: /blogs/chrismissal/archive/2009/05/27/anti-patterns-and-worst-practices-the-arrowhead-anti-pattern.aspx
dsq_thread_id:
  - "262174888"
categories:
  - Best Practices
  - Design Principles
  - DRY
  - legacy code
---
[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;margin: 0px 10px 0px 0px;border-right-width: 0px" alt="arrow" src="//lostechies.com/chrismissal/files/2011/03/arrow_thumb_093FEC00.jpg" width="244" align="left" border="0" height="193" />](//lostechies.com/chrismissal/files/2011/03/arrow_59824380.jpg)

This anti-pattern is named after the shape that most code makes when you have many conditionals, switch statements, or anything that allows the flow to take several paths. You&rsquo;ll commonly see these nested within each other over and over, thus creating the arrow or triangle shape. This anti-pattern doesn&rsquo;t always rely this arrow shape to be created by the nested blocks, but can have just as many paths through the code as it would if the arrow shape was replaced using guard clauses where applicable. The main problem we&rsquo;re trying to solve by eliminating this, is the number of paths (cyclomatic complexity) that the code contains.

Take the following example (from [http://c2.com/cgi/wiki?ArrowAntiPattern](http://c2.com/cgi/wiki?ArrowAntiPattern "http://c2.com/cgi/wiki?ArrowAntiPattern")):

<div style="border: 1px solid gray;margin: 20px 0px 10px;padding: 4px;overflow: auto;font-size: 8pt;width: 60.98%;cursor: text;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;height: 248px;background-color: #f4f4f4">
  <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">if</span> get_resource</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    <span style="color: #0000ff">if</span> get_resource</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        <span style="color: #0000ff">if</span> get_resource</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">            <span style="color: #0000ff">if</span> get_resource</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">                <span style="color: #0000ff">do</span> something</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">                free_resource</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">            <span style="color: #0000ff">else</span></pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">                error_path</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">            <span style="color: #0000ff">endif</span></pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">            free_resource</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        <span style="color: #0000ff">else</span></pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">            error_path</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        <span style="color: #0000ff">endif</span></pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">        free_resource</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">else</span></pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">        error_path</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">endif</span></pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    free_resource </pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">else</span></pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    error_path</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">endif</span></pre>
  </div>
</div>

Not the most elegant code in the world kind of a pain to mentally walk through, huh? Oftentimes I&rsquo;ll put conditionals into guard clauses, this makes for a more readable codebase for starters. The following code is attempting to add a role to a user:

<div style="border: 1px solid gray;margin: 20px 0px 10px;padding: 4px;overflow: auto;font-size: 8pt;width: 97.5%;cursor: text;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
  <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> AddRole(Role role)</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">if</span> (role != <span style="color: #0000ff">null</span>)</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        <span style="color: #0000ff">if</span> (!<span style="color: #0000ff">string</span>.IsNullOrEmpty(role.Name))</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">        {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">            <span style="color: #0000ff">if</span> (!IsInRole(role))</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">            {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">                roles.Add(role);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">            }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">            <span style="color: #0000ff">else</span></pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">            {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">                <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> InvalidOperationException(<span style="color: #006080">"User is already in this role."</span>);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">            }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">        <span style="color: #0000ff">else</span></pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">            <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> ArgumentException(<span style="color: #006080">"role does not have a name"</span>, <span style="color: #006080">"role"</span>);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">else</span></pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    {</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> ArgumentNullException(<span style="color: #006080">"role"</span>);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    }</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">}</pre>
  </div>
</div>

Likely, you see the path that this is going down. We have all these checks, which aren&rsquo;t bad by any means, to ensure that the role is appropriate to add for this user. If we refactor to use guard clauses, it&rsquo;s nicer to read.

<div style="border: 1px solid gray;margin: 20px 0px 10px;padding: 4px;overflow: auto;font-size: 8pt;width: 97.5%;cursor: text;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;height: 261px;background-color: #f4f4f4">
  <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> AddRole(Role role)</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">if</span> (role == <span style="color: #0000ff">null</span>)</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> ArgumentNullException(<span style="color: #006080">"role"</span>);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    <span style="color: #0000ff">if</span> (<span style="color: #0000ff">string</span>.IsNullOrEmpty(role.Name))</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> ArgumentException(<span style="color: #006080">"role does not have a name"</span>, <span style="color: #006080">"role"</span>);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">if</span> (IsInRole(role))</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> InvalidOperationException(<span style="color: #006080">"User is already in this role."</span>);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    roles.Add(role);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">}</pre>
  </div>
</div>

That&rsquo;s a lot better, but I think we can do more here. If we have access to something like a UserRoleValidation class, we&rsquo;ll just use that.

<div style="border: 1px solid gray;margin: 20px 0px 10px;padding: 4px;overflow: auto;font-size: 8pt;width: 97.5%;cursor: text;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;height: 162px;background-color: #f4f4f4">
  <div style="border-style: none;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white"><span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> AddRole(Role role)</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">{</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    userRoleValidator.Validate(role);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">    <span style="color: #0000ff">if</span> (IsInRole(role))</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> InvalidOperationException(<span style="color: #006080">"User is already in this role."</span>);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">&nbsp;</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: #f4f4f4">    roles.Add(role);</pre>
    
    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;font-size: 8pt;width: 100%;color: black;line-height: 12pt;font-family: consolas,'Courier New',courier,monospace;background-color: white">}</pre>
  </div>
</div>

I can find countless other ways to improve this sample code, but these simple tasks are good ways to get rid of that arrowhead that forms when several conditions all must be in tune for your code to work the way you expect it to. The real key is breaking your code apart into smaller pieces that do one thing, and do it well. When you see these &ldquo;arrowheads&rdquo; form, it&rsquo;s likely because the code is trying to do too much.

[See more <a href="/blogs/chrismissal/archive/2009/05/25/anti-patterns-and-worst-practices-you-re-doing-it-wrong.aspx" target="_self">Anti-Patterns and Worst Practices</a>]