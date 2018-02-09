---
wordpress_id: 3180
title: Tour of MonoRail Series
date: 2008-06-23T01:00:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2008/06/22/monorail-best-practices-series.aspx
dsq_thread_id:
  - "268123822"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2008/06/22/monorail-best-practices-series.aspx/"
---
<FONT face="Trebuchet MS" size="2">Due to a spell of blogger&#8217;s block, I thought I would do a series postings to help me get past it. This post begins a series on highlighting various features of the Castle Project MonoRail. All series will be examples from the MonoRail trunk. Some of the features I will be discussing are only available on the trunk (specifically the new Routing Module). To start off the series. The first part will cover MonoRail helpers. The series will have the following topics: </FONT>


  


<DIV>
  <FONT face="Trebuchet MS" size="2"><A href="http://www.lostechies.com/blogs/sean_chambers/archive/2008/06/22/monorail-best-practices-series.aspx">Part 1. Helpers</A><BR />Part 2. UI Basics (Layouts, Views and Shared Views, View Components)<BR />Part 3. Using the new Routing Module<BR />Part 4. Authentication/Security</FONT>
</DIV>


  


<DIV>
  <FONT face="Trebuchet MS" size="2">Part 5. Dynamic Actions<BR />Part 6. Using JsonReturnBinder for serializing to JSON<BR />Part 7. Creating Wizards using IWizardController</FONT>
</DIV>


  


<DIV>
  <FONT face="Trebuchet MS" size="2"></FONT>&nbsp;
</DIV>


  


<DIV>
  <FONT face="Trebuchet MS" size="2">Helpers are classes that are created specifically for providing your view templates with a minimal amount of work to perform or some form of html generation. They should not be used for complex operations or domain logic except for some rare circumstance. They are amazingly simple. A prime example of a helper at work is the </FONT><A class="" href="http://castleproject.org/monorail/documentation/trunk/helpers/form/index.html" target="_blank"><FONT face="Trebuchet MS" size="2">FormHelper</FONT></A><FONT face="Trebuchet MS" size="2">. This Helper generates various html tags for the purpose of easily using the DataBinder on your controllers. Let&#8217;s look at the code required to have the FormHelper generate a TextField for us:</FONT>
</DIV>


  


<DIV>
  <FONT face="Trebuchet MS" size="2"></FONT>&nbsp;
</DIV>


  


<DIV class="csharpcode">
  <PRE><SPAN class="lnum">   1:  </SPAN>$FormHelper.TextField(<SPAN class="str">&#8220;blogpost.title&#8221;</SPAN>)</PRE>
</DIV>


  


<DIV class="csharpcode">
  &nbsp;
</DIV>


  


<DIV class="csharpcode">
  <FONT face="Trebuchet MS">This will generate the following code when rendered:</FONT>
</DIV>


  


<DIV class="csharpcode">
  <FONT face="Trebuchet MS"></FONT>&nbsp;
</DIV>


  


<DIV class="csharpcode">
  <PRE><SPAN class="lnum">   1:  </SPAN>&lt;input type=<SPAN class="str">&#8220;text&#8221;</SPAN> id=<SPAN class="str">&#8220;blogpost_title&#8221;</SPAN> name=<SPAN class="str">&#8220;blogpost.title&#8221;</SPAN> /&gt;</PRE>
</DIV>


  


<FONT face="Trebuchet MS" size="2">What happens here is the FormHelper creates the requested form field and sets the id/name attributes properly so the data can be data bound on the controller action which would look something like this:</FONT>


  


<DIV class="csharpcode">
  <PRE><SPAN class="lnum">   1:  </SPAN><SPAN class="kwrd">public</SPAN> <SPAN class="kwrd">void</SPAN> CreateBlogPost([DataBind(<SPAN class="str">&#8220;blogpost&#8221;</SPAN>)] BlogPost blogpost) {}</PRE>
</DIV>

<FONT face="Trebuchet MS"><br /> 

<P>
  <BR /><FONT size="2">As long as you specify the correct id prefix as it appears in your template, MonoRail will do all the binding on the controller. Your controller must also derive from SmartDispatcherController otherwise you will get an exception at runtime. There are many more features that are provided with FormHelper that I will leave you to </FONT><A href="http://castleproject.org/monorail/documentation/trunk/helpers/form/index.html"><FONT size="2">explore here</FONT></A><FONT size="2">. There are a number of other helpers available such as </FONT><A href="http://castleproject.org/monorail/documentation/trunk/helpers/ajax/index.html"><FONT size="2">AjaxHelper</FONT></A><FONT size="2">, </FONT><A href="http://castleproject.org/monorail/documentation/trunk/helpers/url/index.html"><FONT size="2">UrlHelper</FONT></A><FONT size="2"> and </FONT><A href="http://castleproject.org/monorail/documentation/trunk/helpers/date/index.html"><FONT size="2">DateFormatHelper</FONT></A><FONT size="2">.</FONT>
</P>

<br /> 

<P>
  <FONT size="2">If you want to create your own Helper for whatever task you have at hand all you need to do is create a class and then add an attribute to any controllers that wish to use the helper. The code would look like so:</FONT>
</P>

<br /> 

<DIV class="csharpcode">
  <PRE><SPAN class="lnum">   1:  </SPAN><SPAN class="kwrd">public</SPAN> <SPAN class="kwrd">class</SPAN> MyCoolHelper</PRE>
  
  <PRE><SPAN class="lnum">   2:  </SPAN>{</PRE>
  
  <PRE><SPAN class="lnum">   3:  </SPAN>    <SPAN class="kwrd">public</SPAN> <SPAN class="kwrd">string</SPAN> DoSomethingCool()</PRE>
  
  <PRE><SPAN class="lnum">   4:  </SPAN>    {</PRE>
  
  <PRE><SPAN class="lnum">   5:  </SPAN>        <SPAN class="kwrd">return</SPAN> <SPAN class="str">&#8220;cool stuff&#8221;</SPAN>;</PRE>
  
  <PRE><SPAN class="lnum">   6:  </SPAN>    }</PRE>
  
  <PRE><SPAN class="lnum">   7:  </SPAN>}</PRE>
</DIV>

<br /> 

<DIV class="csharpcode">
  &nbsp;
</DIV>

<br /> 

<DIV class="csharpcode">
  <FONT face="Trebuchet MS">The controller that wishes to use the Helper would look like so:<BR /></FONT>
</DIV>

<br /> 

<DIV class="csharpcode">
  <FONT face="Trebuchet MS">&nbsp;</DIV></FONT><br /> 
  
  <DIV class="csharpcode">
    <PRE><SPAN class="lnum">   1:  </SPAN>[Helper(<SPAN class="kwrd">typeof</SPAN>(MyCoolHelper))]</PRE>
    
    <PRE><SPAN class="lnum">   2:  </SPAN><SPAN class="kwrd">public</SPAN> <SPAN class="kwrd">class</SPAN> SomeController</PRE>
    
    <PRE><SPAN class="lnum">   3:  </SPAN>{</PRE>
    
    <PRE><SPAN class="lnum">   4:  </SPAN>}</PRE>
  </DIV>
  
  <br /> 
  
  <P>
    It&#8217;s as easy as that. This first post is pretty basic. I wanted to start off simple and work up to some of the other topics such as Dynamic Actions and doing Ajax/JSON related data retrieval.
  </P>
  
  <br /> 
  
  <P>
    Next time we will go over layouts, views and view components. Should be a fun time!</FONT>
  </P></p>