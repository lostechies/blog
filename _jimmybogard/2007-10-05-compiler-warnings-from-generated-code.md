---
wordpress_id: 73
title: Compiler warnings from generated code
date: 2007-10-05T14:02:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/10/05/compiler-warnings-from-generated-code.aspx
dsq_thread_id:
  - "266545079"
categories:
  - ASPdotNET
redirect_from: "/blogs/jimmy_bogard/archive/2007/10/05/compiler-warnings-from-generated-code.aspx/"
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/10/compiler-warnings-from-generated-code.html)._

Although I believe strongly in [treating warnings as errors](https://lostechies.com/blogs/jimmy_bogard/archive/2007/10/04/treat-warnings-as-errors.aspx), on rare occasions I get compiler warnings from generated code.&nbsp; Examples of generated code include the designer code files for Windows and Web forms, XAML, etc.&nbsp; Warnings in those files are easily removed, as it&#8217;s almost always&nbsp;related to files coded by the programmer.

I recently hit a really strange compiler warning while using the [aspnet_compiler](http://msdn2.microsoft.com/en-us/library/ms229863(VS.80).aspx) tool, which compiles the ASPX, ASCX, and other content.&nbsp; Part of this process is to parse the ASPX and ASCX files and create C# files from those.&nbsp; However, I started getting very strange warnings from the precompilation:

<pre>c:WINDOWSMicrosoft.NETFrameworkv2.0.50727
  Temporary ASP.NET Filesecommstore5c1cb822
  6aeabbaeApp_Web_d0wxlov2.10.cs(87):
  warning CS0108: Ecomm.Login.Profile' hides inherited member 'Foundation.Core.Web.PageBase.Profile'. 
  Use the new keyword if hiding was intended.</pre>

Shadowing warnings aren&#8217;t new to me, but this one is especially strange since it came from ASP.NET.&nbsp; Specifically, a property created in an auto-generated class conflicts with a property in a global base Page class we use for all of our ASP.NET pages.&nbsp; The base Page class is created by another team here, which provides all sorts of logging, etc.&nbsp; I can&#8217;t touch that one, nor would I want to, as it is used company-wide.&nbsp; That base Profile&nbsp;property isn&#8217;t virtual either.

But how can I get rid of the other one?&nbsp; I tried all sorts of magic:

  * Shadowing and exposing as virtual (the [subclass and override method](https://lostechies.com/blogs/jimmy_bogard/archive/2007/08/31/legacy-code-testing-techniques-subclass.aspx)) 
      * Shadowing and preventing overriding by using the new and sealed modifiers on that property</ul> 
    Nothing worked.&nbsp; No matter what, the Profile property would get created.&nbsp; What does that code file actually look like?&nbsp; Here&#8217;s the more interesting part:
    
    <div class="CodeFormatContainer">
      <pre><span class="kwrd">public</span> <span class="kwrd">partial</span> <span class="kwrd">class</span> Login : System.Web.SessionState.IRequiresSessionState {        
    
    <span class="preproc">#line</span> 12 <span class="str">"E:devecommstorebuildDebugecommstoreLogin.aspx"</span>
    <span class="kwrd">protected</span> global::System.Web.UI.WebControls.PlaceHolder mainPlaceholder;
    
    <span class="preproc">#line</span> <span class="kwrd">default</span>
    <span class="preproc">#line</span> hidden
    
    <span class="kwrd">protected</span> System.Web.Profile.DefaultProfile Profile {
        get {
            <span class="kwrd">return</span> ((System.Web.Profile.DefaultProfile)(<span class="kwrd">this</span>.Context.Profile));
        }
    }
    
    <span class="kwrd">protected</span> ASP.global_asax ApplicationInstance {
        get {
            <span class="kwrd">return</span> ((ASP.global_asax)(<span class="kwrd">this</span>.Context.ApplicationInstance));
        }
    }
}
</pre>
    </div>
    
    There&#8217;s the offender, the auto-generated Profile property.&nbsp; Looking back at some older build logs, I notice that this warning didn&#8217;t show up until we migrated to ASP.NET 2.0.&nbsp; One of the new features of ASP.NET 2.0 is the [Profile properties](http://msdn2.microsoft.com/en-us/library/at64shx3.aspx).&nbsp; ASP.NET 2.0 profiles allow me to create strongly-typed custom profiles for customers and let them be integrated into our ASP.NET pages, be automatically stored and retrieved, etc.&nbsp; If I defined custom properties for my profile, then a dynamically created Profile class would be used (instead of the DefaultProfile type).
    
    However, we don&#8217;t use Profiles, so I can just turn them off in our web.config file:
    
    <div style="font-size: 10pt;background: white;color: black;font-family: consolas">
      <p style="margin: 0px">
        <span style="color: blue"><</span><span style="color: #a31515">profile</span><span style="color: blue"> </span><span style="color: red">enabled</span><span style="color: blue">=</span>&#8220;<span style="color: blue">false</span>&#8220;<span style="color: blue"> /></span>
      </p>
    </div>
    
    By turning Profiles off, the Profile property is never created in the auto-generated code.&nbsp; The warnings go away, and our problem is solved.
    
    There are several other instances of these new ASP.NET 2.0 features in auto-generated code causing naming collisions with existing properties when migrating from ASP.NET 1.1.&nbsp; The solution was always to rename your properties, but since I couldn&#8217;t do that, turning Profiles off did the trick.