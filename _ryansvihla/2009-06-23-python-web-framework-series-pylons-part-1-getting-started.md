---
wordpress_id: 13
title: 'Python Web Framework Series – Pylons: Part 1 Getting Started'
date: 2009-06-23T14:00:00+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2009/06/23/python-web-framework-series-pylons-part-1-getting-started.aspx
dsq_thread_id:
  - "441378294"
categories:
  - Pylons
  - Python
---
This article assumes you have <a target="_blank" href="http://www.python.org/download/">Python 2.6</a> and <a target="_blank" href="http://pypi.python.org/pypi/setuptools">Setuptools</a> already installed on your machine and that you&rsquo;re install SQL Alchemy 0.54 and Pylons 0.97

### Overview

Pylons is a component based MVC web framework. It, like a lot of more recent MVC frameworks, is borrowing some ideas and concepts from rails&nbsp; in a less &ldquo;opinionated &ldquo; way. 

Out of the box Pylons has a preference for using <a target="_blank" href="http://www.sqlalchemy.org/">SQL Alchemy</a> for ORM (similar to NHibernate in philosophy) and <a target="_blank" href="http://www.makotemplates.org/">Mako</a> template engine (uses Python code for markup) .&nbsp; Now if you prefer <a target="_blank" href="http://www.sqlobject.org/">SQLObject</a> , or the <a target="_blank" href="http://elixir.ematia.de/trac/wiki">Elixer</a> dialect of SQL Alchemy for ORM and <a target="_blank" href="http://genshi.edgewall.org/">Genshi</a> template engine pylons supports them all (and others).&nbsp; More importantly this means you have choice down the road to match your personal preferences or particular project complexity needs.

&nbsp;

### Installation

With Setuptools installed Pylons installation is type the following in a command prompt:

`<i>easy_install Pylons</i>`

`<i>easy_install SQLAlchemy</i>&nbsp;`

This will install everything needed to get started. 

### 

### Pylons Forum

Were going to create a simple forum called Pylons Forum. Not exactly imaginative, but it requires authorization, db calls, and basic view logic. Just be glad its not a shopping cart or blog.

Typing __

_paster create &#8211;list-templates_ 

[<img src="//lostechies.com/ryansvihla/files/2011/03/Picture1_thumb_79E3F3A3.png" alt="Picture 1" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" height="71" width="506" />](//lostechies.com/ryansvihla/files/2011/03/Picture1_77A76AE7.png) 

We&rsquo;re going to use the pylons template for now and type 

_paster create &ndash;t pylons pylonsforum_

&nbsp;[<img src="//lostechies.com/ryansvihla/files/2011/03/Picture2_thumb_4BF9319C.png" alt="Picture 2" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" height="102" width="505" />](//lostechies.com/ryansvihla/files/2011/03/Picture2_5C056FA2.png) 

&nbsp;

select enter to pick &lsquo;mako&rsquo;, then you&rsquo;ll see:

&nbsp;[<img src="//lostechies.com/ryansvihla/files/2011/03/Picture4_thumb_0D936DE9.png" alt="Picture 4" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" height="14" width="503" />](//lostechies.com/ryansvihla/files/2011/03/Picture4_19292B28.png)

&nbsp;

&nbsp;

type in true then hit enter.

cd into the pylonsforum directory and run dir(or ls depending on your platform)

should result in:

[<img src="//lostechies.com/ryansvihla/files/2011/03/Picture5_thumb_043A3966.png" alt="Picture 5" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" height="166" width="503" />](//lostechies.com/ryansvihla/files/2011/03/Picture5_01FDB0AA.png) 

Now if this is what you see the key being &ldquo;development.ini&rdquo; file. Type

_paster serve &#8211;reload development.ini_ 

[<img src="//lostechies.com/ryansvihla/files/2011/03/Picture11_thumb_6F4B47A3.png" alt="Picture 11" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" height="50" width="510" />](//lostechies.com/ryansvihla/files/2011/03/Picture11_78384931.png) 

open up a browser to <http://127.0.0.1:5000>

&nbsp;

[<img src="//lostechies.com/ryansvihla/files/2011/03/Picture8_thumb_177D80B6.png" alt="Picture 8" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" height="347" width="431" />](//lostechies.com/ryansvihla/files/2011/03/Picture8_2EA8FB34.png) 

&nbsp;

### First Controller and Test

Now that we have our structure setup go ahead and type the following:

`<br />
` 

`<br />
` 

`<br />
` 

`<br />
` 

`<br />
` 

_cd pylonsforum_

_paster controller home_

&nbsp;

you should see:

[<img src="//lostechies.com/ryansvihla/files/2011/03/Picture12_thumb_5BA841DD.png" alt="Picture 12" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" border="0" height="65" width="495" />](//lostechies.com/ryansvihla/files/2011/03/Picture12_19A1D29C.png) 

So we&rsquo;ve created a controller and a functional test associated with that controller.

open the following url:

<http://localhost:5000/home/index>

will bring up the obligatory &ldquo;hello world&rdquo;.

Next post I&#8217;ll being to cover using controllers and views.