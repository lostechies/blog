---
wordpress_id: 3149
title: 'Testing Security Link Demands with R#'
date: 2007-11-06T15:45:00+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2007/11/06/testing-security-link-demands-with-r.aspx
dsq_thread_id:
  - "564117523"
categories:
  - resharper tdd
redirect_from: "/blogs/sean_chambers/archive/2007/11/06/testing-security-link-demands-with-r.aspx/"
---
This is more just a reference for me or anyone else that may stumble across this.


  


I had a set of Controller tests that I needed to set a mock object to Thread.CurrentPrincipal so I could test PrincipalPermission attributes. Off the bat I would just happily set Thread.CurrentPrincipal to my mocked user and everything worked fine.


  


When I ran the full suite of tests including all of my SqlCE Nhibernate tests I saw that NHibernate was throwing a TypeInitializationException from NHibernate.Cfg.Environment. After quite awhile of debugging I found that the data tests would only fail when I ran my Controller tests in conjunction with the data tests. After even more time I remembered about the Thread.CurrentPrincipal.


  


Normally you probably wouldn&#8217;t even notice a problem. It seemed as if though that when R# was trying to load the NHibernate Session it somehow didn&#8217;t have permission because Visual Studios Principal was changed to a mock object! An ephiany ensued followed by kicking myself in the rear.


  


To fix it, I just saved the CurrentPrincipal to an IPrincipal instance and set it back in the TearDown of my Controller test like so:


  


private IPrincipal _oldPrincipal;  
  
[SetUp]  
public void Setup()  
{  
&nbsp;&nbsp;&nbsp; _oldPrincipal = Thread.CurrentPrincipal;  
&nbsp;&nbsp;&nbsp; Thread.CurrentPrincipal = _user;  
}  
  
[TearDown]  
public void TearDown()  
{  
&nbsp;&nbsp;&nbsp; Thread.CurrentPrincipal = _oldPrincipal;  
}


  


Hopefully this post helps someone from falling into the same trap. Cheers!