---
wordpress_id: 213
title: 'Trusted Subsystem, WCF and IIS 5 &#8211; revisited'
date: 2008-08-01T00:26:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/07/31/trusted-subsystem-wcf-and-iis-5-revisited.aspx
dsq_thread_id:
  - "264715857"
categories:
  - WCF
---
In my last post, I tried to get the following scenario to work:

![](http://grabbagoftimg.s3.amazonaws.com/trusted_subsystem.PNG)

One thing I _didn&#8217;t_ add was that I&#8217;m running IIS in Windows XP, in IIS 5.&nbsp; In this [article on CodePlex](http://www.codeplex.com/WCFSecurity/Wiki/View.aspx?title=Intranet%20%u2013%20Web%20to%20Remote%20WCF%20Using%20Transport%20Security%20%28Trusted%20Subsystem%2c%20HTTP%29&referringTitle=Application%20Scenarios), which I originally modeled my solution after and a couple of folks pointed out, it recommends setting both the ASP.NET identity (outside the Trusted Zone) and the App Pool identity to the Service account identity.

Now, in my case, I don&#8217;t care about who calls my service, nor do I want any requirement on their side to provide any transport security.&nbsp; The article also recommends this, but I don&#8217;t need it.

The real problem came from me running in IIS 5.&nbsp; In IIS 5, the aspnet_wp process runs as MACHINEASPNET, which examining WindowsIdentity.GetCurrent() confirmed.&nbsp; Even though I set the identity in IIS to use the service account as anonymous user, WCF **by default** uses the process identity, not any other identity.&nbsp; WCF has no knowledge of the host environment, by default, so it doesn&#8217;t know it&#8217;s hosted in ASP.NET or IIS normally.

To do a Trusted Subsystem model under IIS 5, I had to make the following changes:

  * Set the anonymous account to the service account, turn off any other security (like Integrated Windows Security)
  * Turn on impersonation in the web.config (<identity impersonate=&#8221;true&#8221; />)
  * Turn on ASP.NET compatibility for the service hosting environment and each individual service

The last part is critical, and detailed in [this MSDN article](http://msdn.microsoft.com/en-us/library/aa702682.aspx).&nbsp; I&#8217;ve had to do that before, when designing JSON services for an AJAX application, where the services needed access to HttpContext.Session.

Once ASP.NET compatibility is turned on, WCF requests now go through the ASP.NET pipeline, which means the normal ASP.NET impersonation model.&nbsp; From the article:

> WCF services run using the current identity of the ASP.NET impersonated thread, which may be different than the IIS process identity if ASP.NET impersonation has been enabled for the application.

With the full ASP.NET impersonation set up, and the correct identity set up in IIS, WCF could now take the identity of the ASP.NET impersonated thread.&nbsp; Even though Thread.CurrentPrincipal reflected the service identity, WCF won&#8217;t use it unless I set up the compatibility mode.

Of course, if I had been developing in a Workstation 2008 machine, or something with IIS 6 or 7, this wouldn&#8217;t be a problem.&nbsp; Setting the App Pool identity is the process identity.&nbsp; In IIS 5, the identity is configured elsewhere.&nbsp; In any case, it&#8217;s all working now locally.&nbsp; I guess this means it&#8217;s finally time to upgrade to Workstation 2008.

Thanks to everyone for all the pointers!