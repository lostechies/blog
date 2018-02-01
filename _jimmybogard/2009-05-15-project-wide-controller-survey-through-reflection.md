---
id: 314
title: Project-wide controller survey through reflection
date: 2009-05-15T02:28:22+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/05/14/project-wide-controller-survey-through-reflection.aspx
dsq_thread_id:
  - "265232530"
categories:
  - ASPNETMVC
  - LINQ
---
I often lose track of all of the different controllers in our system, especially if I’m trying to see what existing conventions we have in place for the design of actions.&#160; To get around this, I use a simple LINQ query to display all of the controllers and actions in our system in an easily readable format:

<pre><span style="color: blue">var </span>controllers =
    <span style="color: blue">from </span>t <span style="color: blue">in </span>GetAllControllerTypes()
    <span style="color: blue">where typeof</span>(<span style="color: #2b91af">Controller</span>).IsAssignableFrom(t) && !t.IsAbstract
    <span style="color: blue">orderby </span>t.FullName
    <span style="color: blue">from </span>m <span style="color: blue">in </span>t.GetMethods(<span style="color: #2b91af">BindingFlags</span>.Instance | <span style="color: #2b91af">BindingFlags</span>.Public | <span style="color: #2b91af">BindingFlags</span>.DeclaredOnly)
    <span style="color: blue">where </span>!m.IsSpecialName
    <span style="color: blue">select new </span>{ ControllerName = FormatControllerName(t.FullName), ActionName = m.Name, Params = m.GetParameters() };

controllers.Each(c =&gt; <span style="color: #2b91af">Debug</span>.WriteLine(<span style="color: #a31515">"Controller: " </span>+ c.ControllerName + <span style="color: #a31515">", Action: " </span>+ c.ActionName + <span style="color: #a31515">"(" </span>+ <span style="color: blue">string</span>.Join(<span style="color: #a31515">", "</span>, c.Params.Select(p =&gt; p.Name).ToArray()) + <span style="color: #a31515">")"</span>));
<span style="color: #2b91af">Debug</span>.WriteLine(<span style="color: #a31515">"Controller/action count: " </span>+ controllers.Count());
<span style="color: #2b91af">Debug</span>.WriteLine(<span style="color: #a31515">"Controller count: " </span>+ controllers.Distinct(c =&gt; c.ControllerName).Count());</pre>

[](http://11011.net/software/vspaste)

The above LINQ query combines the controller name with each action, showing the action parameter names in a readable format.&#160; The GetAllControllerTypes is just a method that returns all types in an assembly where my controllers can be found:

<pre><span style="color: blue">private static </span><span style="color: #2b91af">Type</span>[] GetAllControllerTypes()
{
    <span style="color: blue">return typeof</span>(<span style="color: #2b91af">ProductController</span>).Assembly.GetTypes();
}</pre>

[](http://11011.net/software/vspaste)

Finally, I like to remove all of the namespace information from the controller names, but keep any potential area information (i.e., get rid of the root namespace, but keep any sub-namespaces:

<pre><span style="color: blue">private static string </span>FormatControllerName(<span style="color: blue">string </span>typeName)
{
    <span style="color: blue">return </span>typeName.Replace(<span style="color: #a31515">"MvcApplication2."</span>, <span style="color: blue">string</span>.Empty).Replace(<span style="color: #a31515">"Controllers."</span>, <span style="color: blue">string</span>.Empty);
}</pre>

[](http://11011.net/software/vspaste)

When I run this against a sample application provided by the MVC default project:

<pre>Controller: AccountController, Action: LogOn()
Controller: AccountController, Action: LogOn(userName, password, rememberMe, returnUrl)
Controller: AccountController, Action: LogOff()
Controller: AccountController, Action: Register()
Controller: AccountController, Action: Register(userName, email, password, confirmPassword)
Controller: AccountController, Action: ChangePassword()
Controller: AccountController, Action: ChangePassword(currentPassword, newPassword, confirmPassword)
Controller: AccountController, Action: ChangePasswordSuccess()
Controller: HomeController, Action: Index()
Controller: HomeController, Action: About()
Controller: ProductController, Action: Index()
Controller: ProductController, Action: Details(id)
Controller: ProductController, Action: Create()
Controller: ProductController, Action: Create(product)
Controller: ProductController, Action: Edit(id)
Controller: ProductController, Action: Edit(id, product)
Controller/action count: 16
Controller count: 3</pre>

[](http://11011.net/software/vspaste)

The cool thing about LINQ against reflection is it lets you get these interesting surveys of your system.&#160; When you start filtering it against base types, you can see a nice view of your system that things like ReSharper and other tools aren’t easily massaged.