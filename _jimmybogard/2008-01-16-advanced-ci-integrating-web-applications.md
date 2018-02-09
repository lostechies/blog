---
wordpress_id: 130
title: 'Advanced CI: integrating web applications'
date: 2008-01-16T22:35:05+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/01/16/advanced-ci-integrating-web-applications.aspx
dsq_thread_id:
  - "264715509"
categories:
  - ASPdotNET
  - ContinuousIntegration
redirect_from: "/blogs/jimmy_bogard/archive/2008/01/16/advanced-ci-integrating-web-applications.aspx/"
---
So you&#8217;ve already got an automated build with unit tests and deployment packaging.&nbsp; But if you have a Web Application project as part of your solution, there is still the potential for some compilation errors to get past your builds.&nbsp; So if your builds compile your solution, how can we run into compilation problems?&nbsp; Let&#8217;s look at a simple scenario.

### It happens every day

Suppose I&#8217;m creating a simple ASP.NET MVC application, and I put some code in the template (ASPX) page:

<pre><span style="color: blue">&lt;</span><span style="color: #a31515">h2</span><span style="color: blue">&gt;</span>I HAZ A BUKKET<span style="color: blue">&lt;/</span><span style="color: #a31515">h2</span><span style="color: blue">&gt;

</span><span style="background: #ffee62">&lt;%</span> Html.ActionLink&lt;<span style="color: #2b91af">HomeController</span>&gt;(action =&gt; action.Index(), <span style="color: #a31515">"Home"</span>); <span style="background: #ffee62">%&gt;
</span></pre>

[](http://11011.net/software/vspaste)

Nothing fancy, I&#8217;m just creating a link to the home url.&nbsp; But what happens when I mess something up here?

<pre><span style="color: blue">&lt;</span><span style="color: #a31515">h2</span><span style="color: blue">&gt;</span>NOOO!!!! THEY BE STEALIN MY BUKKET<span style="color: blue">&lt;/</span><span style="color: #a31515">h2</span><span style="color: blue">&gt;

</span><span style="background: #ffee62">&lt;%</span> Html.ActionLink&lt;<span style="color: #2b91af">HomeController</span>&gt;(action =&gt; action.IndexWHOOPS(), <span style="color: #a31515">"Home"</span>); <span style="background: #ffee62">%&gt;
</span></pre>

[](http://11011.net/software/vspaste)

The &#8220;Index&#8221; method exists on the HomeController class, but the &#8220;IndexWHOOPS&#8221; method definitely does not.&nbsp; This should result in a compilation error.&nbsp; However, when I build the solution, I don&#8217;t have any errors:

<pre>========== Build: 1 succeeded or up-to-date, 0 failed, 0 skipped ==========</pre>

[](http://11011.net/software/vspaste)

Succeeded, hooray!&nbsp; My build is green, let&#8217;s deploy!&nbsp; If I happen to navigate to the [lolrus](http://ihasabucket.com/) page above, I get an error:

 ![](http://grabbagoftimg.s3.amazonaws.com/WebCompile_Bad.PNG)

Well that&#8217;s no good, my build says &#8220;green&#8221; but in reality I have compilation errors.&nbsp; My confidence in my automated build process is shot now, as I can&#8217;t catch all compilation errors.&nbsp; Someone could type in gibberish, and my build wouldn&#8217;t catch it.&nbsp; There are ways to catch these problems, however.

### Precompilation is the key

When ASP.NET 2.0 was released, an additional command-line tool, [aspnet_compiler](http://msdn2.microsoft.com/en-us/library/ms229863(VS.80).aspx), was shipped with it to allow developers to pre-compile web pages, ensuring a snappy response.&nbsp; Without precompilation, each page and user control&#8217;s ASPX and ASCX file are dynamically compiled when first requested, which caused a noticeable delay on the client side.

But I don&#8217;t want to wait for users to catch compilation errors in my templates, I want them caught during my build.&nbsp; Since the tool to do so is already available via the command line, integrating it with NAnt or MSBuild is very straightforward.&nbsp; In fact, there&#8217;s already an [AspNetCompiler](http://msdn2.microsoft.com/en-us/library/ms164291.aspx) task built-in to MSBuild, so you&#8217;ll be able to use that.

Before we integrate precompilation into our NAnt build, our compile task looks like this:

<pre><span style="color: blue">&lt;</span><span style="color: #a31515">target </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">compile</span>"<span style="color: blue">&gt;
    &lt;</span><span style="color: #a31515">exec </span><span style="color: red">program</span><span style="color: blue">=</span>"<span style="color: blue">${environment::get-folder-path('System')}..Microsoft.NETFrameworkv3.5msbuild.exe</span>"
          <span style="color: red">commandline</span><span style="color: blue">=</span>"<span style="color: blue">mvcapp.sln</span>" <span style="color: blue">/&gt;
  &lt;/</span><span style="color: #a31515">target</span><span style="color: blue">&gt;
</span></pre>

[](http://11011.net/software/vspaste)

We just need to add an additional compile step right after the solution compile that will perform our additional ASP.NET compilation:

<pre><span style="color: blue">&lt;</span><span style="color: #a31515">target </span><span style="color: red">name</span><span style="color: blue">=</span>"<span style="color: blue">compile</span>"<span style="color: blue">&gt;
    &lt;</span><span style="color: #a31515">exec </span><span style="color: red">program</span><span style="color: blue">=</span>"<span style="color: blue">${environment::get-folder-path('System')}..Microsoft.NETFrameworkv3.5msbuild.exe</span>"
          <span style="color: red">commandline</span><span style="color: blue">=</span>"<span style="color: blue">mvctest.sln</span>" <span style="color: blue">/&gt;

    &lt;</span><span style="color: #a31515">exec </span><span style="color: red">program</span><span style="color: blue">=</span>"<span style="color: blue">${environment::get-folder-path('System')}..Microsoft.NETFrameworkv2.0.50727aspnet_compiler.exe</span>"
        <span style="color: red">commandline</span><span style="color: blue">=</span>"<span style="color: blue">-v mvctest -p mvctestMvcApplication</span>" <span style="color: blue">/&gt;
  &lt;/</span><span style="color: #a31515">target</span><span style="color: blue">&gt;
</span></pre>

[](http://11011.net/software/vspaste)

Right after the solution compile, I compile the web application.&nbsp; Depending on your deployment scenarios, you may want to tweak the command-line options passed in.&nbsp; The options I used simply compile the web application in-place, but if I wanted to I could supply an output directory to place the compiled files.

I&#8217;m just interested in receiving compiler errors, so what does our build tell us now?

<pre>[exec] c:devmvctestmvctestMvcApplicationViewsHomeIndex.aspx(8): erro
r CS1061: 'MvcApplication.Controllers.HomeController' does not contain a definit
ion for 'IndexWHOOPS' and no extension method 'IndexWHOOPS' accepting a first ar
gument of type 'MvcApplication.Controllers.HomeController' could be found (are y
ou missing a using directive or an assembly reference?)

BUILD FAILED</pre>

Now I get detailed errors when I have compilation errors in my ASPX, ASCX, and all other files that get dynamically compiled by ASP.NET.&nbsp; I can again put code in the designer files with confidence that my backup partner (continuous integration) will catch problems that I miss.

### Compile your designers

Designers provide a nice declarative syntax for UI elements.&nbsp; Many .NET technologies include designers, including ASP.NET and WPF (XAML).&nbsp; But if your designers aren&#8217;t compiled along with the rest of your build process, you have a hole in your build strategy as some bugs won&#8217;t be noticed until they&#8217;re seen by someone trying to view the UI.&nbsp; This problem can be exacerbated if you have actual code in your designer files.

By compiling your designers in the rest of your CI process, you can again have the confidence that 100% of your application is free of compilation errors.&nbsp; But since you already have automated UI tests, you caught the errors already, right?