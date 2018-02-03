---
wordpress_id: 262
title: Making frameworks container-aware
date: 2008-12-15T02:12:58+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/12/14/making-frameworks-container-aware.aspx
dsq_thread_id:
  - "264716029"
  - "264716029"
categories:
  - 'C#'
---
I’m currently knee-deep in NHibernate custom listeners, for the purpose of adding auditing to our application.&#160; Besides current documentation being plain wrong on the subject (I’ll update on the solution in the future), I hit a rather frustrating snag around the instantiation of my custom listener.&#160; One of the shouldn’t-be-frustrating-but-yet-it-is side-effects of committing fully to Dependency Injection and Inversion of Control Containers is all the code out there with “extension” points that don’t allow custom factory implementations.&#160; Sure, your framework allows for custom Floogle providers.&#160; But how does it _create_ the IFloogleProvider implementations?

In the NHibernate code, I found this snippet that instantiates custom listeners, which are configured through an XML configuration file:

<pre><span style="color: blue">public void </span>SetListeners(<span style="color: #2b91af">ListenerType </span>type, <span style="color: blue">string</span>[] listenerClasses)
{
    <span style="color: blue">if </span>(listenerClasses == <span style="color: blue">null </span>|| listenerClasses.Length == 0)
    {
        ClearListeners(type);
    }
    <span style="color: blue">else
    </span>{
        <span style="color: blue">var </span>listeners = (<span style="color: blue">object</span>[]) <span style="color: #2b91af">Array</span>.CreateInstance(eventListeners.GetListenerClassFor(type), listenerClasses.Length);
        <span style="color: blue">for </span>(<span style="color: blue">int </span>i = 0; i &lt; listeners.Length; i++)
        {
            <span style="color: blue">try
            </span>{
                listeners[i] = <span style="color: #2b91af">Activator</span>.CreateInstance(<span style="color: #2b91af">ReflectHelper</span>.ClassForName(listenerClasses[i]));
            }
            <span style="color: blue">catch </span>(<span style="color: #2b91af">Exception </span>e)
            {
                <span style="color: blue">throw new </span><span style="color: #2b91af">MappingException</span>(
                    <span style="color: #a31515">"Unable to instantiate specified event (" </span>+ type + <span style="color: #a31515">") listener class: " </span>+ listenerClasses[i], e);
            }
        }
        SetListeners(type, listeners);
    }
}</pre>

[](http://11011.net/software/vspaste)

One. glaring. problem.&#160; It uses [Activator.CreateInstance](http://msdn.microsoft.com/en-us/library/system.activator.createinstance.aspx) to create the instance, which internally calls the default constructor.&#160; As a developer for custom listeners, this means that we need to define a no-argument constructor:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">AuditPreInsertUpdateEventListener </span>: <span style="color: #2b91af">IPreUpdateEventListener</span>, <span style="color: #2b91af">IPreInsertEventListener
</span>{
    <span style="color: blue">private readonly </span>IUserSession _userSession;

    <span style="color: blue">public </span>AuditPreInsertUpdateEventListener(IUserSession userSession)
    {
        _userSession = userSession;
    }

    <span style="color: blue">public </span>AuditPreInsertUpdateEventListener()
        : <span style="color: blue">this</span>(ObjectFactory.GetInstance&lt;IUserSession&gt;())
    {
    }</pre>

[](http://11011.net/software/vspaste)

When doing constructor injection, you normally don’t create this constructor.&#160; Frameworks like ASP.NET MVC, WCF and others provide hooks for custom factories or instance providers.&#160; Containers receive a request to instantiate a component, and the container will create the dependencies, call the right constructor and pass those dependencies in.

From a developer’s perspective, it’s very helpful not to have to define any unnecessary no-arg constructors, as it muddies code.&#160; There is at least one solution out there, such as the [Common Service Locator](http://www.codeplex.com/CommonServiceLocator) project.&#160; Now, NHibernate does allow programmatic configuration, so I do have the option to create the instances myself and pump them into NHibernate.&#160; All I’ve really done is eliminated the possibility of using XML configuration, which isn’t too fun if you’re doing things like XML manipulation as part of your deployments.

For framework developers, something like **Activator.CreateInstance should be a red flag**, that _maybe_ we should provide alternate means of instantiation.&#160; As IoC containers become more mainstream, I think we’ll see more changes in major frameworks to support containers out-of-the-box.&#160; Until then, pointless dual constructors it is.