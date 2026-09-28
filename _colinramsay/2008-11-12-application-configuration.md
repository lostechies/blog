---
wordpress_id: 16
title: Application Configuration
date: 2008-11-12T21:13:00+00:00
author: Colin Ramsay
layout: post
wordpress_guid: /blogs/colin_ramsay/archive/2008/11/12/application-configuration.aspx
categories:
  - configuration
redirect_from: "/blogs/colin_ramsay/archive/2008/11/12/application-configuration.aspx/"
---
I had cause to recently revisit an old ASP.NET application I&#8217;d written way back when I was a development newcomer. Digging around the web.config I found the appSettings section:

<pre>&lt;appSettings&gt;<br />    &lt;add key="systemEmailAddress" value="me@me.com" /&gt;<br />    &lt;add key="adminEmailAddress" value="me@me.com" /&gt;<br />    &lt;add key="templateDirectory" value="~/admin/templates/" /&gt;<br />    &lt;add key="installPath" value="~/admin/" /&gt;<br />&lt;/appSettings&gt;</pre>

You get the idea. There were loads of these, configuring many different aspects of the system. Many should have been configurable by site administrators from some kind of user interface. Technically this is possible &#8211; editing the web.config on the fly &#8211; but I really wouldn&#8217;t recommend it. 

Anyway, since then I&#8217;ve used this method a number of times, as well as having a Settings database table which stores key/value pairs:

<pre>var email = SettingRepository.FindByKey("email");</pre>

Or having a Settings table with a single row and columns for each setting to allow it to be mapped to an object:

<pre>Settings settings = SettingsRepository.FindFirst();</pre>

All three have upsides and downsides but none are particularly satisfying. I&#8217;m mulling over which approach to take in my next project which is going to need a fair few of these settings. Which method do you favour? Do you have a fourth way?