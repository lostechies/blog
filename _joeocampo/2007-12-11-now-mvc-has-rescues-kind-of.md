---
wordpress_id: 90
title: 'Now MVC has rescues: Kind Of'
date: 2007-12-11T03:45:44+00:00
author: Joe Ocampo
layout: post
wordpress_guid: /blogs/joe_ocampo/archive/2007/12/10/now-mvc-has-rescues-kind-of.aspx
dsq_thread_id:
  - "262089384"
categories:
  - Architechture
  - ASP.MVC
---
I really missed using the <a href="http://www.castleproject.org/monorail/documentation/v1rc2/usersguide/rescues.html" target="_blank">[Rescue] attribute</a> from <a href="http://www.castleproject.org/monorail/index.html" target="_blank">MonoRail</a> in the ASP MVC framework.&nbsp; I missed it so much that I decided to create my own.&nbsp; With the help of <a href="http://haacked.com/archive/2007/12/09/extending-asp.net-mvc-to-add-conventions.aspx" target="_blank">Phil Haack&#8217;s ConventionController</a> and <a href="http://weblogs.asp.net/fredriknormen/archive/2007/11/22/asp-net-mvc-framework-handling-exception-by-using-an-attribute.aspx" target="_blank">Frederick Norman&#8217;s post on ErrorHandlerAttribute</a> it wasn&#8217;t that hard at all.&nbsp; In fact in the end I have something that almost looks like the MonoRail controller syntax.&nbsp; Mind you it is not using any Filters but I really see how easy it would be implement them given the time.

Anyway, the code!

So the first thing I did was create the actual Rescue attribute:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 10pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> RescueAttribute : Attribute
{
    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IList&lt;Type&gt; exceptionTypes = <span style="color: #0000ff">new</span> List&lt;Type&gt;();
    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> <span style="color: #0000ff">string</span> rescueView;
    <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> Action&lt;Type&gt; preRescueAction;


    <span style="color: #0000ff">public</span> RescueAttribute(<span style="color: #0000ff">string</span> rescueView) : <span style="color: #0000ff">this</span>(rescueView, <span style="color: #0000ff">new</span> Exception().GetType())
    {
    }


    <span style="color: #0000ff">public</span> RescueAttribute(<span style="color: #0000ff">string</span> rescueView, Type exceptionType)
    {
        <span style="color: #0000ff">this</span>.rescueView = rescueView;

        <span style="color: #0000ff">if</span> (exceptionType != <span style="color: #0000ff">null</span>)
            exceptionTypes.Add(exceptionType);
    }

    <span style="color: #0000ff">public</span> RescueAttribute(<span style="color: #0000ff">string</span> rescueView, Type exceptionType, Action&lt;Type&gt; preRescueAction)
    {
        <span style="color: #0000ff">this</span>.rescueView = rescueView;
        <span style="color: #0000ff">this</span>.preRescueAction = preRescueAction;

        <span style="color: #0000ff">if</span> (exceptionType != <span style="color: #0000ff">null</span>)
            exceptionTypes.Add(exceptionType);
    }

    <span style="color: #0000ff">public</span> RescueAttribute(<span style="color: #0000ff">string</span> rescueView, <span style="color: #0000ff">params</span> Type[] exceptionType)
    {
        <span style="color: #0000ff">this</span>.rescueView = rescueView;

        <span style="color: #0000ff">if</span> (exceptionType != <span style="color: #0000ff">null</span>)
        {
            <span style="color: #0000ff">foreach</span> (Type type <span style="color: #0000ff">in</span> exceptionType)
            {
                exceptionTypes.Add(type);
            }
        }
    }

    <span style="color: #0000ff">public</span> IEnumerable ExceptionTypes
    {
        get { <span style="color: #0000ff">return</span> exceptionTypes; }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">string</span> View
    {
        get { <span style="color: #0000ff">return</span> rescueView; }
    }


    <span style="color: #0000ff">public</span> Action&lt;Type&gt; PreRescueAction
    {
        get { <span style="color: #0000ff">return</span> preRescueAction; }
    }
}</pre>
</div>

Now I had to add a couple of methods to Phil&#8217;s ConventionController:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 10pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">bool</span> OnError(<span style="color: #0000ff">string</span> actionName, MethodInfo methodInfo, Exception exception)
{
    ArrayList attributes = GetRescueHandlerAttribute(methodInfo);

    <span style="color: #0000ff">foreach</span> (RescueAttribute rescueAttribute <span style="color: #0000ff">in</span> attributes)
    {
        <span style="color: #0000ff">foreach</span> (Type exceptionType <span style="color: #0000ff">in</span> rescueAttribute.ExceptionTypes)
        {
            <span style="color: #0000ff">if</span> (exceptionType.IsAssignableFrom(exception.InnerException.GetType()))
            {
                <span style="color: #0000ff">if</span>(rescueAttribute.PreRescueAction != <span style="color: #0000ff">null</span>)
                {
                    rescueAttribute.PreRescueAction.Invoke(exceptionType);
                }

                <span style="color: #0000ff">if</span> (!<span style="color: #0000ff">string</span>.IsNullOrEmpty(rescueAttribute.View))
                    RenderView(<span style="color: #006080">"~/Views/Rescue/"</span> + rescueAttribute.View + <span style="color: #006080">".aspx"</span>, exception);

                <span style="color: #0000ff">return</span> <span style="color: #0000ff">true</span>;
            }
        }
    }

    <span style="color: #0000ff">return</span> <span style="color: #0000ff">false</span>;
}

<span style="color: #0000ff">private</span> ArrayList GetRescueHandlerAttribute(ICustomAttributeProvider methodInfo)
{
    ArrayList attributes = <span style="color: #0000ff">new</span> ArrayList();

    attributes.AddRange(
        methodInfo.GetCustomAttributes(
            <span style="color: #0000ff">typeof</span> (RescueAttribute),
            <span style="color: #0000ff">false</span>));

    attributes.AddRange(
        GetType().GetCustomAttributes(
            <span style="color: #0000ff">typeof</span> (RescueAttribute),
            <span style="color: #0000ff">true</span>));

    <span style="color: #0000ff">return</span> attributes;
}</pre>
</div>

The OnError is called when ever there is an Exception within an Action.&nbsp; All I did was simply find all the Rescue Attributes on the controller class and iterate through all the registered exception types.&nbsp; If it finds a registered exception type it looks for a PreAction delegate or lambda and invokes it (still working on this but I thought it was overkill).

Finally it Renders the rescue view in the Rescue folder.

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="152" alt="image" src="http://lostechies.com/joeocampo/files/2011/03NowMVChasrescuesKindOf_13519/image_thumb.png" width="169" border="0" />](http://lostechies.com/joeocampo/files/2011/03NowMVChasrescuesKindOf_13519/image_2.png) 

That&#8217;s it!

Now my controller looks like this (check out the new hip name for the convention controller:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 10pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">[Rescue(<span style="color: #006080">"HelpMe"</span>)]
<span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> HomeController : SuperConventionController
{
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Index()
    {
        RenderView(<span style="color: #006080">"Index"</span>);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> About()
    {
        RenderView(<span style="color: #006080">"About"</span>);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Error()
    {
        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> NotImplementedException(<span style="color: #006080">"Did you get this?"</span>);
    }
}</pre>
</div>

When I type in the following url: http://localhost:52634/Home/**Error</a>**</p> 

It immediately redirects me to the Rescue page HelpMe.aspx

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="199" alt="image" src="http://lostechies.com/joeocampo/files/2011/03NowMVChasrescuesKindOf_13519/image_thumb_1.png" width="496" border="0" />](http://lostechies.com/joeocampo/files/2011/03NowMVChasrescuesKindOf_13519/image_4.png) 

I don&#8217;t think this code is near production ready but it serves as a quick representation on how quickly and easily you can extend the MVC framework.

Happy coding!