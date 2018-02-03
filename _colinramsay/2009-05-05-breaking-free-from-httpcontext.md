---
wordpress_id: 4693
title: 'PTOM: Breaking Free from HttpContext'
date: 2009-05-05T03:08:00+00:00
author: Colin Ramsay
layout: post
wordpress_guid: /blogs/colin_ramsay/archive/2009/05/05/breaking-free-from-httpcontext.aspx
categories:
  - Uncategorized
---
The System.Web.HttpContext class is a real heavyweight of the .NET Framework. It holds a wealth of information on the current server context, from the details of the current user request to a host of details about the server. It&#8217;s accessible from the HttpContext.Current static property, which means you can get hold of this information at and point in your code. Whether this is a strength or a weakness depends on your point of view, but consider the following code:

<pre>public class AuthenticationService<br />{<br />    public IRepository Repository { get; set; }<br /><br />    public void Login(string username, string password)<br />    {<br />        User user = Repository.FindByLogin(username, password);<br /><br />        HttpContext.Current.Session["currentuserid"] = user.Id;<br />    }<br />}<br /></pre>

This type of code is probably pretty widespread; separate authentication code into a separate class. The problem with this type of code comes when you want to test it. Consider this test snippet: 

<pre>[TestMethod]<br />public void Should_Retrieve_User_From_Repo()<br />{<br />    _authService.Login(username, password);<br />    _repo.AssertWasCalled(x =&gt; x.FindByLogin(username, password);<br />}<br /></pre>

This will fail hard, because when your test runs, you don&#8217;t have a current HttpContext available to work with. In theory, you could fire up a webserver class and populate HttpContext.Current and everything would work just fine; with early versions of the Castle Monorail project, the Controller test support did something similar. However, this is pretty unwieldy and not to mention slow.
  
Of course we do have some horrible situations in which teams don&#8217;t run these kind of tests, so they&#8217;re probably thinking that they don&#8217;t care. They always run their code with a valid HttpContext available and are perfectly happy. Wait till you try and reuse your code to integrate with a third party which calls your authentication service. Ouch.
  
So the bottom line is that we need to make sure HttpContext.Current is kept as far away from our code as possible. Another example of HttpContext usage is something like this: 

<pre>public void Log(string message)<br />{<br />    WriteFile(message, DateTime.Now, HttpContext.Current.Url);<br />}<br /></pre>

So we&#8217;re writing a log message along with the time and the page where the message was logged. We need this information for debugging, so it&#8217;s understandable why this code arises, but again we can see testing issues with HttpContext. Fortunately in this case it&#8217;s easy to fix:

<pre>public void Log(string message, string url)<br />{<br />    WriteFile(message, DateTime.Now, url);<br />}<br /></pre>

Of course this kind of solution applies to any static class you need to pull out, so let&#8217;s look at an example which is more closely related to HttpContext: cookies. A standard approach would see us doing something like this:

<pre>private void PersistUser(string encryptedUserIdentifier)<br />{<br />    HttpCookie cookie = new HttpCookie("user");<br />    cookie.Value = encryptedUserIdentifier;<br />    cookie.Expiry = DateTime.Now.AddDays(14);<br />    Response.Cookies.Add(cookie);<br />}</pre>

This does the job, and adds a cookie to the response so that the browser will acknowledge it. The problem again lies in testing this code; without an HttpContext, we&#8217;re in trouble. Because a lot of new C# code is working with ASP.NET MVC and test-first practices, we need to take that in to account in every part of our application. How about this instead: 

<pre>private readonly ICookieContainer _cookies;<br /><br />public Controller(ICookieContainer cookieContainer)<br />{<br />    _cookies = cookieContainer;<br />}<br /><br />private void PersistUser(string encryptedUserIdentifier)<br />{<br />    _cookies.Set("user", encryptedUserIdentifier, DateTime.Now.AddDays(14));<br />}<br /></pre>

Now, we don&#8217;t include any kind of code which references the cookie implementation directly, and that in turn means we don&#8217;t use HttpContext.Current. We provide an implementation of an ICookieContainer via the constructor. That interface and implementation could look like this: 

<pre>public interface ICookieContainer<br />{<br />    void Set(string name, string value, DateTime expires);<br />    string Get(string name);<br />}<br /><br />public class HttpCookieContainer : ICookieContainer<br />{<br />    public void Set(string name, string value, DateTime expires)<br />    {<br />        HttpCookie cookie = new HttpCookie("user");<br />        cookie.Value = encryptedUserIdentifier;<br />        cookie.Expiry = DateTime.Now.AddDays(14);<br />        Response.Cookies.Add(cookie);<br />    }<br />}</pre>

Now, looking at this you might be wondering what on earth the point is &#8211; this is exactly the same code but in a different class! The important thing is that the first set of code is likely to be part of a bigger controller class, a class which you want to keep as thin as possible. So we pull the cookie handling code out and then the controller doesn&#8217;t have to be concerned about it at all.
  
Similar approaches can be used where ever HttpContext touches your code. The important thing is that because HttpContext is such a heavyweight, we can break it apart and use only the parts that are needed by wrapping them up into custom classes which can be injected where they&#8217;re needed.