---
id: 47
title: Java IoC containers and classpath scanning (or what I’ve been looking for from .NET for months)
date: 2010-09-19T19:01:00+00:00
author: Ryan Svihla
layout: post
guid: /blogs/rssvihla/archive/2010/09/19/java-ioc-containers-and-classpath-scanning-or-what-i-ve-been-looking-for-from-net-for-months.aspx
dsq_thread_id:
  - "425624466"
categories:
  - IoC
  - Java
  - Spring
---
Frustrated with the typical way I saw IoC used in Java where every example I found involved thousands of lines of XML   
and/or Java code to configure Java beans or components.&#160; This is very different than IoC typically used in .NET where most IoC containers allow   
you to "autowire" in their terminology up every class in an assembly with a couple of lines of code.&#160; Having been coding in that fashion   
for several years in .NET I was dismayed when none of my fellow Java coders that I worked with or knew personally had any concept   
of the equivalent functionality, and instead informed me the IDE would be my help in maintaining these massive XML files. 

Not content with their answers I burrowed into Spring, Guice and PicoContainer docs and found "classpath scanning" which is roughly   
equivalent to "autowire" in .NET. Below is an example of this in Spring 3:

MyStuff.java (my main class note his has 2 dependencies which you can view on my <a href="http://github.com/rssvihla/SpringDemo/tree/master/src/org/foo" target="_blank">github repo</a>)

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <div style="font-family:consolas,lucida console,courier,monospace">
    <span style="color:#008000"><b>package</b></span>&#160;org<span style="color:#666666">.</span><span style="color:#7D9029">foo</span><span style="color:#666666">;</span></p> 
    
    <p>
      <span style="color:#008000"><b>import</b></span>&#160;<span style="color:#0000FF"><b>org.springframework.beans.factory.annotation.Autowired</b></span><span style="color:#666666">;</span><br /> <span style="color:#008000"><b>import</b></span>&#160;<span style="color:#0000FF"><b>org.springframework.stereotype.Service</b></span><span style="color:#666666">;</span>
    </p>
    
    <p>
      <span style="color:#AA22FF">@Service</span>&#160;<span style="color:#408080"><i>//one&#160;way&#160;of&#160;marking&#160;this&#160;as&#160;a&#160;component&#160;to&#160;register<br /> </i></span><span style="color:#008000"><b>public</b></span>&#160;<span style="color:#008000"><b>class</b></span>&#160;<span style="color:#0000FF"><b>MyStuff</b></span>&#160;<span style="color:#666666">{</span><br /> &#160;&#160;&#160;&#160;<span style="color:#008000"><b>private</b></span>&#160;<span style="color:#008000"><b>final</b></span>&#160;DependencyWithNoInterface&#160;first<span style="color:#666666">;</span><br /> &#160;&#160;&#160;&#160;<span style="color:#008000"><b>private</b></span>&#160;<span style="color:#008000"><b>final</b></span>&#160;DependencyInterface&#160;second<span style="color:#666666">;</span>
    </p>
    
    <p>
      &#160;&#160;&#160;&#160;<span style="color:#AA22FF">@Autowired</span>&#160;<span style="color:#408080"><i>//tells&#160;spring&#160;which&#160;constructor&#160;to&#160;use&#160;for&#160;it&#8217;s&#160;dependencies<br /> </i></span>&#160;&#160;&#160;&#160;<span style="color:#008000"><b>public</b></span>&#160;<span style="color:#0000FF">MyStuff</span><span style="color:#666666">(</span>DependencyWithNoInterface&#160;first<span style="color:#666666">,</span>&#160;DependencyInterface&#160;second<span style="color:#666666">)</span>&#160;<span style="color:#666666">{</span>
    </p>
    
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000"><b>this</b></span><span style="color:#666666">.</span><span style="color:#7D9029">first</span>&#160;<span style="color:#666666">=</span>&#160;first<span style="color:#666666">;</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#008000"><b>this</b></span><span style="color:#666666">.</span><span style="color:#7D9029">second</span>&#160;<span style="color:#666666">=</span>&#160;second<span style="color:#666666">;</span><br /> &#160;&#160;&#160;&#160;<span style="color:#666666">}</span>
    </p>
    
    <p>
      &#160;&#160;&#160;&#160;<span style="color:#008000"><b>public</b></span>&#160;<span style="color:#B00040">void</span>&#160;<span style="color:#0000FF">run</span><span style="color:#666666">(){</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;System<span style="color:#666666">.</span><span style="color:#7D9029">out</span><span style="color:#666666">.</span><span style="color:#7D9029">println</span><span style="color:#666666">(</span><span style="color:#BA2121">&#8220;foo&#160;me&#8221;</span><span style="color:#666666">);</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;first<span style="color:#666666">.</span><span style="color:#7D9029">foo</span><span style="color:#666666">();</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;second<span style="color:#666666">.</span><span style="color:#7D9029">superFoo</span><span style="color:#666666">();</span><br /> &#160;&#160;&#160;&#160;<span style="color:#666666">}</span><br /> <span style="color:#666666">}</span> </div> </div> 
      
      <p>
        appContext.xml (seems you still need some XML)
      </p>
      
      <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
        <div style="font-family:consolas,lucida console,courier,monospace">
          <span style="color:#BC7A00"><?xml&#160;version=&#8221;1.0&#8243;&#160;encoding=&#8221;UTF-8&#8243;?></span><br /> <span style="color:#008000"><b><beans</b></span>&#160;<span style="color:#7D9029">xmlns=</span><span style="color:#BA2121">&#8220;http://www.springframework.org/schema/beans&#8221;</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#7D9029">xmlns:xsi=</span><span style="color:#BA2121">&#8220;http://www.w3.org/2001/XMLSchema-instance&#8221;</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#7D9029">xmlns:context=</span><span style="color:#BA2121">&#8220;http://www.springframework.org/schema/context&#8221;</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;<span style="color:#7D9029">xsi:schemaLocation=</span><span style="color:#BA2121">&#8220;http://www.springframework.org/schema/beans<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;http://www.springframework.org/schema/beans/spring-beans-3.0.xsd<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;http://www.springframework.org/schema/context<br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;http://www.springframework.org/schema/context/spring-context-3.0.xsd&#8221;</span><span style="color:#008000"><b>></b></span><br /> &#160;&#160;&#160;&#160;&#160;<span style="color:#008000"><b><context:component-scan</b></span>&#160;<span style="color:#7D9029">base-package=</span><span style="color:#BA2121">&#8220;org.foo&#8221;</span><span style="color:#008000"><b>/></b></span><br /> <span style="color:#008000"><b></beans></b></span>
        </div>
      </div>
      
      <p>
        Application.java (the initialization)
      </p>
      
      <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
        <div style="font-family:consolas,lucida console,courier,monospace">
          <span style="color:#008000"><b>package</b></span>&#160;org<span style="color:#666666">.</span><span style="color:#7D9029">foo</span><span style="color:#666666">;</span></p> 
          
          <p>
            <span style="color:#008000"><b>import</b></span>&#160;<span style="color:#0000FF"><b>org.springframework.context.ApplicationContext</b></span><span style="color:#666666">;</span><br /> <span style="color:#008000"><b>import</b></span>&#160;<span style="color:#0000FF"><b>org.springframework.context.support.ClassPathXmlApplicationContext</b></span><span style="color:#666666">;</span>
          </p>
          
          <p>
            <span style="color:#008000"><b>public</b></span>&#160;<span style="color:#008000"><b>class</b></span>&#160;<span style="color:#0000FF"><b>Application</b></span>&#160;<span style="color:#666666">{</span><br /> &#160;&#160;&#160;&#160;<span style="color:#008000"><b>public</b></span>&#160;<span style="color:#008000"><b>static</b></span>&#160;<span style="color:#B00040">void</span>&#160;<span style="color:#0000FF">main</span><span style="color:#666666">(</span>String&#160;args<span style="color:#666666">[]){</span><br /> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;ApplicationContext&#160;ctx&#160;<span style="color:#666666">=</span>&#160;&#160;&#160;<span style="color:#008000"><b>new</b></span>&#160;ClassPathXmlApplicationContext<span style="color:#666666">(</span><span style="color:#BA2121">&#8220;appContext.xml&#8221;</span><span style="color:#666666">);</span>&#160;<span style="color:#408080"><i>//the&#160;IoC&#160;container<br /> </i></span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;MyStuff&#160;stff&#160;<span style="color:#666666">=</span>&#160;ctx<span style="color:#666666">.</span><span style="color:#7D9029">getBean</span><span style="color:#666666">(</span>MyStuff<span style="color:#666666">.</span><span style="color:#7D9029">class</span><span style="color:#666666">);</span>&#160;<span style="color:#408080"><i>//my&#160;fully&#160;injected&#160;class<br /> </i></span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;stff<span style="color:#666666">.</span><span style="color:#7D9029">run</span><span style="color:#666666">();</span><br /> &#160;&#160;&#160;&#160;<span style="color:#666666">}</span><br /> <span style="color:#666666">}</span> </div> </div> 
            
            <p>
              &#160;
            </p>
            
            <p>
              &#160;
            </p>
            
            <p>
              Now I’m sure for the .NET developers familiar with StructureMap, Windsor, Autofac, etc this is completely unimpressive. I’m also sure there are Java developers that are somewhat unimpressed with this but for reasons that involve holding onto giant configuration artifacts. <strong>Manual IoC component registration falls where hand writing SQL for trivial data access does for me, extra repetitive work that has been solved years ago</strong>.
            </p>
            
            <p>
              Edit:
            </p>
            
            <p>
              It appears you can forgo XML as well in your main class use a different Application context and add the refresh and scan lines
            </p>
            
            <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterSmartContent">
              <div style="font-family: consolas,lucida console,courier,monospace">
                <span style="color: #008000"><b>package</b></span> org<span style="color: #666666">.</span><span style="color: #7d9029">foo</span><span style="color: #666666">;</span> </p> 
                
                <p>
                  <span style="color: #008000"><b>import</b></span>&#160;<span style="color: #0000ff"><b>org.springframework.context.annotation.AnnotationConfigApplicationContext</b></span><span style="color: #666666">;</span>
                </p>
                
                <p>
                  <span style="color: #008000"><b>public</b></span>&#160;<span style="color: #008000"><b>class</b></span>&#160;<span style="color: #0000ff"><b>Application</b></span>&#160;<span style="color: #666666">{</span> <br />&#160;&#160;&#160; <span style="color: #008000"><b>public</b></span>&#160;<span style="color: #008000"><b>static</b></span>&#160;<span style="color: #b00040">void</span>&#160;<span style="color: #0000ff">main</span><span style="color: #666666">(</span>String args<span style="color: #666666">[]){</span> <br />&#160;&#160;&#160;&#160;&#160;&#160;&#160; AnnotationConfigApplicationContext ctx <span style="color: #666666">=</span>&#160;&#160; <span style="color: #008000"><b>new</b></span> AnnotationConfigApplicationContext<span style="color: #666666">();</span>&#160; <br />&#160;&#160;&#160;&#160;&#160;&#160;&#160; ctx<span style="color: #666666">.</span><span style="color: #7d9029">scan</span><span style="color: #666666">(</span><span style="color: #ba2121">"org.foo"</span><span style="color: #666666">);</span>&#160;<span style="color: #408080"><i>//scans the org.foo package <br /></i></span>&#160;&#160;&#160;&#160;&#160;&#160;&#160; ctx<span style="color: #666666">.</span><span style="color: #7d9029">refresh</span><span style="color: #666666">();</span>&#160;<span style="color: #408080"><i>//needed to load them for some reason <br /></i></span>&#160;&#160;&#160;&#160;&#160;&#160;&#160; MyStuff stff <span style="color: #666666">=</span> ctx<span style="color: #666666">.</span><span style="color: #7d9029">getBean</span><span style="color: #666666">(</span>MyStuff<span style="color: #666666">.</span><span style="color: #7d9029">class</span><span style="color: #666666">);</span> <br />&#160;&#160;&#160;&#160;&#160;&#160;&#160; stff<span style="color: #666666">.</span><span style="color: #7d9029">run</span><span style="color: #666666">();</span> <br />&#160;&#160;&#160; <span style="color: #666666">}</span> <br /><span style="color: #666666">}</span> </div>
                </p>
              </div>