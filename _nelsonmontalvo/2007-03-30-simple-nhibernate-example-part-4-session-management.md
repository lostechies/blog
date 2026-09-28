---
wordpress_id: 4736
title: 'Simple NHibernate Example, Part 4 : Session Management'
date: 2007-03-30T16:37:00+00:00
author: Nelson Montalvo
layout: post
wordpress_guid: /blogs/nelson_montalvo/archive/2007/03/30/simple-nhibernate-example-part-4-session-management.aspx
categories:
  - NHibernate
redirect_from: "/blogs/nelson_montalvo/archive/2007/03/30/simple-nhibernate-example-part-4-session-management.aspx/"
---
Before continuing with the implementation, let&#8217;s talk briefly about NHibernate session management. This will be a short discussion, as you can get more details from chapter 8 of the book, <a href="http://www.amazon.com/Hibernate-Action-Christian-Bauer/dp/193239415X/ref=pd_bbs_sr_1/104-7167080-3547947?ie=UTF8&s=books&qid=1174402169&sr=8-1" target="_blank">Hibernate In Action</a>. Also, please review the article, <a href="http://www.codeproject.com/aspnet/NHibernateBestPractices.asp" target="_blank">NHibernate Best Practices</a>, for further explanation of the Session In View.

One of the potential problems with using NHibernate is the intermingling of managing the NHibernate sessions and transactions with the basic interactions between the domain and NHibernate. Ideally, we&#8217;d like the client using NHibernate to manage transactions outside of the context of the business workflow, committing or rolling back entire transactions depending on the results of the workflow (this is the unit of work pattern).

We&#8217;d like to be able to manage a single session across a single persistence context (or transaction context). We&#8217;ll utilize the thread safe CallContext object in an NHibernate SessionManager class. An upcoming post will show how this session manager works. In the meantime, here is the code (borrowed from <a href="http://www.codeproject.com/aspnet/NHibernateBestPractices.asp" target="_blank">NHibernate Best Practices</a>):

<div style="background: white none repeat scroll 0% 50%;font-size: 10pt;color: black">
  <p style="margin: 0px">
    <span style="color: blue">using</span> System.Configuration;
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">using</span> System.Runtime.Remoting.Messaging;
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">using</span> System.Web;
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">using</span> NHibernate;
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">using</span> NHibernate.Cache;
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">using</span> <span>Configuration</span>=NHibernate.Cfg.<span>Configuration</span>;
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">using</span> NHibernateConfiguration = NHibernate.Cfg;
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">namespace</span> DealerMatrix.Data.NHibernate.Session
  </p>
  
  <p style="margin: 0px">
    {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> </span><span style="color: gray"><summary></span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> Handles creation and management of sessions and transactions.&nbsp; It is a singleton because </span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> building the initial session factory is very expensive. Inspiration for this class came </span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> from Chapter 8 of Hibernate in Action by Bauer and King.&nbsp; Although it is a sealed singleton</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> you can use TypeMock (http://www.typemock.com) for more flexible testing.</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> </span><span style="color: gray"></summary></span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">sealed</span> <span style="color: blue">class</span> <span>NHibernateSessionManager</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">private</span> <span>ISessionFactory</span> sessionFactory;
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; #region</span> Thread-safe, lazy Singleton
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> </span><span style="color: gray"><summary></span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> This is a thread-safe, lazy singleton.&nbsp; See http://www.yoda.arachsys.com/csharp/singleton.html</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> for more details about its implementation.</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> </span><span style="color: gray"></summary></span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">static</span> <span>NHibernateSessionManager</span> Instance
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">get</span> { <span style="color: blue">return</span> <span>Nested</span>.nHibernateNHibernateSessionManager; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> </span><span style="color: gray"><summary></span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> Initializes the NHibernate session factory upon instantiation.</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> </span><span style="color: gray"></summary></span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">private</span> NHibernateSessionManager()
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; InitSessionFactory();
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> </span><span style="color: gray"><summary></span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> Assists with ensuring thread-safe, lazy singleton</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> </span><span style="color: gray"></summary></span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">private</span> <span style="color: blue">class</span> <span>Nested</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">static</span> Nested()
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">internal</span> <span style="color: blue">static</span> <span style="color: blue">readonly</span> <span>NHibernateSessionManager</span> nHibernateNHibernateSessionManager = <span style="color: blue">new</span> <span>NHibernateSessionManager</span>();
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    <span style="color: blue">&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; #endregion</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">private</span> <span style="color: blue">void</span> InitSessionFactory()
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span>Configuration</span> cfg = <span style="color: blue">new</span> <span>Configuration</span>();
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: green">// The following makes sure the the web.config contains a declaration for the HBM_ASSEMBLY appSetting</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">if</span> (<span>ConfigurationManager</span>.AppSettings[<span>&#8220;HBM_ASSEMBLY&#8221;</span>] == <span style="color: blue">null</span> ||
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span>ConfigurationManager</span>.AppSettings[<span>&#8220;HBM_ASSEMBLY&#8221;</span>] == <span>&#8220;&#8221;</span>)
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">throw</span> <span style="color: blue">new</span> <span>ConfigurationErrorsException</span>(<span>&#8220;NHibernateManager.InitSessionFactory: &#8220;HBM_ASSEMBLY&#8221; must be &#8220;</span> +
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp; <span>&#8220;provided as an appSetting within your config file. &#8220;HBM_ASSEMBLY&#8221; informs NHibernate which assembly &#8220;</span> +
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp; <span>&#8220;contains the HBM files. It is assumed that the HBM files are embedded resources. An example config &#8220;</span> +
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp; <span>&#8220;declaration is <add key=&#8221;HBM_ASSEMBLY&#8221; value=&#8221;MyProject.Core&#8221; />&#8221;</span>);
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; cfg.AddAssembly(<span>ConfigurationManager</span>.AppSettings[<span>&#8220;HBM_ASSEMBLY&#8221;</span>]);
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; sessionFactory = cfg.BuildSessionFactory();
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> </span><span style="color: gray"><summary></span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> Allows you to register an interceptor on a new session.&nbsp; This may not be called if there is already</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> an open session attached to the HttpContext.&nbsp; If you have an interceptor to be used, modify</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> the HttpModule to call this before calling BeginTransaction().</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> </span><span style="color: gray"></summary></span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">void</span> RegisterInterceptor(<span>IInterceptor</span> interceptor)
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span>ISession</span> session = threadSession;
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">if</span> (session != <span style="color: blue">null</span> && session.IsOpen)
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">throw</span> <span style="color: blue">new</span> <span>CacheException</span>(<span>&#8220;You cannot register an interceptor once a session has already been opened&#8221;</span>);
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; GetSession(interceptor);
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span>ISession</span> GetSession()
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">return</span> GetSession(<span style="color: blue">null</span>);
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> </span><span style="color: gray"><summary></span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> Gets a session with or without an interceptor.&nbsp; This method is not called directly; instead,</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> it gets invoked from other public methods.</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> </span><span style="color: gray"></summary></span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">private</span> <span>ISession</span> GetSession(<span>IInterceptor</span> interceptor)
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span>ISession</span> session = threadSession;
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">if</span> (session == <span style="color: blue">null</span>)
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">if</span> (interceptor != <span style="color: blue">null</span>)
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; session = sessionFactory.OpenSession(interceptor);
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">else</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; session = sessionFactory.OpenSession();
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; threadSession = session;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">return</span> session;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">void</span> CloseSession()
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span>ISession</span> session = threadSession;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; threadSession = <span style="color: blue">null</span>;
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">if</span> (session != <span style="color: blue">null</span> && session.IsOpen)
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; session.Close();
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">void</span> BeginTransaction()
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span>ITransaction</span> transaction = threadTransaction;
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">if</span> (transaction == <span style="color: blue">null</span>)
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; transaction = GetSession().BeginTransaction();
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; threadTransaction = transaction;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">void</span> CommitTransaction()
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span>ITransaction</span> transaction = threadTransaction;
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">try</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">if</span> (transaction != <span style="color: blue">null</span> && !transaction.WasCommitted && !transaction.WasRolledBack)
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; transaction.Commit();
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; threadTransaction = <span style="color: blue">null</span>;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">catch</span> (<span>HibernateException</span> ex)
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; RollbackTransaction();
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">throw</span> ex;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">public</span> <span style="color: blue">void</span> RollbackTransaction()
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span>ITransaction</span> transaction = threadTransaction;
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">try</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; threadTransaction = <span style="color: blue">null</span>;
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">if</span> (transaction != <span style="color: blue">null</span> && !transaction.WasCommitted && !transaction.WasRolledBack)
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; transaction.Rollback();
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">catch</span> (<span>HibernateException</span> ex)
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">throw</span> ex;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">finally</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; CloseSession();
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> </span><span style="color: gray"><summary></span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> If within a web context, this uses </span><span style="color: gray"><see cref=&#8221;HttpContext&#8221; /></span><span style="color: green"> instead of the WinForms </span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> specific </span><span style="color: gray"><see cref=&#8221;CallContext&#8221; /></span><span style="color: green">.&nbsp; Discussion concerning this found at </span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> http://forum.springframework.net/showthread.php?t=572.</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> </span><span style="color: gray"></summary></span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">private</span> <span>ITransaction</span> ThreadTransaction
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">get</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">if</span> (IsInWebContext())
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">return</span> (<span>ITransaction</span>) <span>HttpContext</span>.Current.Items[TRANSACTION_KEY];
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">else</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">return</span> (<span>ITransaction</span>) <span>CallContext</span>.GetData(TRANSACTION_KEY);
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">set</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">if</span> (IsInWebContext())
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span>HttpContext</span>.Current.Items[TRANSACTION_KEY] = <span style="color: blue">value</span>;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">else</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span>CallContext</span>.SetData(TRANSACTION_KEY, <span style="color: blue">value</span>);
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> </span><span style="color: gray"><summary></span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> If within a web context, this uses </span><span style="color: gray"><see cref=&#8221;HttpContext&#8221; /></span><span style="color: green"> instead of the WinForms </span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> specific </span><span style="color: gray"><see cref=&#8221;CallContext&#8221; /></span><span style="color: green">.&nbsp; Discussion concerning this found at </span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> http://forum.springframework.net/showthread.php?t=572.</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: gray">///</span><span style="color: green"> </span><span style="color: gray"></summary></span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">private</span> <span>ISession</span> ThreadSession
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">get</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">if</span> (IsInWebContext())
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">return</span> (<span>ISession</span>) <span>HttpContext</span>.Current.Items[SESSION_KEY];
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">else</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">return</span> (<span>ISession</span>) <span>CallContext</span>.GetData(SESSION_KEY);
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">set</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">if</span> (IsInWebContext())
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span>HttpContext</span>.Current.Items[SESSION_KEY] = <span style="color: blue">value</span>;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">else</span>
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span>CallContext</span>.SetData(SESSION_KEY, <span style="color: blue">value</span>);
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">private</span> <span style="color: blue">static</span> <span style="color: blue">bool</span> IsInWebContext()
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; {
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">return</span> <span>HttpContext</span>.Current != <span style="color: blue">null</span>;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    &nbsp;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">private</span> <span style="color: blue">const</span> <span style="color: blue">string</span> TRANSACTION_KEY = <span>&#8220;CONTEXT_TRANSACTION&#8221;</span>;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <span style="color: blue">private</span> <span style="color: blue">const</span> <span style="color: blue">string</span> SESSION_KEY = <span>&#8220;CONTEXT_SESSION&#8221;</span>;
  </p>
  
  <p style="margin: 0px">
    &nbsp;&nbsp;&nbsp; }
  </p>
  
  <p style="margin: 0px">
    }
  </p>
</div>

  * Have a look at the last two properties to see how the CallContext is used. These maintain the transaction and session across a single request thread.

  * InitSessionFactory() requires that HBM_ASSEMBLY be defined in the config file.

  * Finally, be sure to call CommitTransaction(), RollbackTransaction() and/or CloseSession() at the end of the request to clear out the CallContext at the end of the thread request.

Again, I will show you how to put all these pieces together in an upcoming post.