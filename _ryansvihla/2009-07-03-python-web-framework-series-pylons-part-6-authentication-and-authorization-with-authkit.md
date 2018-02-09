---
wordpress_id: 19
title: 'Python Web Framework Series – Pylons: Part 6 Basic Authorization With AuthKit'
date: 2009-07-03T12:00:00+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2009/07/03/python-web-framework-series-pylons-part-6-authentication-and-authorization-with-authkit.aspx
dsq_thread_id:
  - "425624220"
categories:
  - Authkit
  - Pylons
  - Python
redirect_from: "/blogs/rssvihla/archive/2009/07/03/python-web-framework-series-pylons-part-6-authentication-and-authorization-with-authkit.aspx/"
---
Last post we left off with very basic database access, and testing story completed. Now we&#8217;re going to look at basic Authorization and Authentication with AuthKit. NOTE: most of this post is just an aggregation of a couple of chapters in the [Pylons Book](http://pylonsbook.com/en/1.0/simplesite-tutorial-part-3.html) since this setup is a good base starting point. Read the previous link to the Pylons Book for more in depth coverage of this topic.&nbsp; 

### Setting Up AuthKit

First lets make sure we have AuthKit installed: _easy_install AuthKit_. For this post we&#8217;re working with AuthKit 0.4.3, your mileage may vary if you read this post in the future and are using a different version. Now that we have Authkit installed open up **pylonsforumconfigmiddleware.py** add the following imports: 

&nbsp;

&nbsp;

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <div style="font-family:consolas,lucida console,courier,monospace">
    <span style="color: #008000"><b>import</b></span>&nbsp;<span style="color: #0000ff"><b>authkit.authenticate</b></span><br /> <span style="color: #008000"><b>from</b></span>&nbsp;<span style="color: #0000ff"><b>authkit.permissions</b></span>&nbsp;<span style="color: #008000"><b>import</b></span>&nbsp;ValidAuthKitUser
  </div>
</div>

&nbsp;

and then add somewhere inside the _if asbool(full_stack):_ code block.

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <div style="font-family:consolas,lucida console,courier,monospace">
    permission&nbsp;<span style="color: #666666">=</span>&nbsp;ValidAuthKitUser()<br /> app&nbsp;<span style="color: #666666">=</span>&nbsp;authkit<span style="color: #666666">.</span>authorize<span style="color: #666666">.</span>middleware(app,&nbsp;permission)<br /> app&nbsp;<span style="color: #666666">=</span>&nbsp;authkit<span style="color: #666666">.</span>authenticate<span style="color: #666666">.</span>middleware(app,app_conf)
  </div>
</div>

&nbsp;

&nbsp;

in **development.ini** add this to the end of your _[app:main]_ section

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <div style="font-family:consolas,lucida console,courier,monospace">
    authkit<span style="color: #666666">.</span>setup<span style="color: #666666">.</span>enable&nbsp;<span style="color: #666666">=</span>&nbsp;true<br /> authkit<span style="color: #666666">.</span>setup<span style="color: #666666">.</span>method&nbsp;<span style="color: #666666">=</span>&nbsp;form,&nbsp;cookie<br /> authkit<span style="color: #666666">.</span>form<span style="color: #666666">.</span>authenticate<span style="color: #666666">.</span>user<span style="color: #666666">.</span>type&nbsp;<span style="color: #666666">=</span>&nbsp;authkit<span style="color: #666666">.</span>users<span style="color: #666666">.</span>sqlalchemy_driver:UsersFromDatabase<br /> authkit<span style="color: #666666">.</span>form<span style="color: #666666">.</span>authenticate<span style="color: #666666">.</span>user<span style="color: #666666">.</span>data&nbsp;<span style="color: #666666">=</span>&nbsp;pylonsforum<span style="color: #666666">.</span>model<br /> authkit<span style="color: #666666">.</span>cookie<span style="color: #666666">.</span>secret&nbsp;<span style="color: #666666">=</span>&nbsp;secret&nbsp;string<br /> authkit<span style="color: #666666">.</span>cookie<span style="color: #666666">.</span>signoutpath&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #666666">/</span>home<span style="color: #666666">/</span>signout
  </div>
</div>

Open your home.py controller and for now add a &ldquo;signout&rdquo; action:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <div style="font-family:consolas,lucida console,courier,monospace">
    <span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">signout</span>(<span style="color: #008000">self</span>):<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>return</b></span>&nbsp;<span style="color: #ba2121">&#8220;You&#8217;ve&nbsp;been&nbsp;signed&nbsp;out&#8221;</span>
  </div>
</div>

Now in your **websetup.py** we have a ton to add to get the basic setup working. Start right after imports and add these line.

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <div style="font-family:consolas,lucida console,courier,monospace">
    <span style="color: #008000"><b>from</b></span>&nbsp;<span style="color: #0000ff"><b>authkit.users.sqlalchemy_driver</b></span>&nbsp;<span style="color: #008000"><b>import</b></span>&nbsp;UsersFromDatabase
  </div>
</div>

next add the following in your &ldquo;setup\_app&rdquo; method after load\_environment

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <div style="font-family:consolas,lucida console,courier,monospace">
    &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>from</b></span>&nbsp;<span style="color: #0000ff"><b>pylonsforum.model</b></span>&nbsp;<span style="color: #008000"><b>import</b></span>&nbsp;meta<br /> &nbsp;&nbsp;&nbsp;&nbsp;meta<span style="color: #666666">.</span>metadata<span style="color: #666666">.</span>bind&nbsp;<span style="color: #666666">=</span>&nbsp;meta<span style="color: #666666">.</span>engine<br /> &nbsp;&nbsp;&nbsp;&nbsp;filename&nbsp;<span style="color: #666666">=</span>&nbsp;os<span style="color: #666666">.</span>path<span style="color: #666666">.</span>split(conf<span style="color: #666666">.</span>filename)[<span style="color: #666666">&#8211;</span><span style="color: #666666">1</span>]<br /> &nbsp;&nbsp;&nbsp;&nbsp;log<span style="color: #666666">.</span>info(<span style="color: #ba2121">&#8220;Adding&nbsp;the&nbsp;AuthKit&nbsp;model&#8230;&#8221;</span>)<br /> &nbsp;&nbsp;&nbsp;&nbsp;users&nbsp;<span style="color: #666666">=</span>&nbsp;UsersFromDatabase(model)<br /> &nbsp;&nbsp;&nbsp;&nbsp;meta<span style="color: #666666">.</span>metadata<span style="color: #666666">.</span>create_all(checkfirst<span style="color: #666666">=</span><span style="color: #008000">True</span>)<br /> &nbsp;&nbsp;&nbsp;&nbsp;log<span style="color: #666666">.</span>info(<span style="color: #ba2121">&#8220;Adding&nbsp;roles&nbsp;and&nbsp;uses&#8230;&#8221;</span>)<br /> &nbsp;&nbsp;&nbsp;&nbsp;users<span style="color: #666666">.</span>user_create(<span style="color: #ba2121">&#8220;admin&#8221;</span>,&nbsp;password<span style="color: #666666">=</span><span style="color: #ba2121">&#8220;admin&#8221;</span>)
  </div>
</div>

For the final piece delete your development.db file and run _paster setup-app development.ini_ to recreate it with the AuthKit user model. Now you have very basic authentication working in your site

<http://localhost:5000> reveals:

[<img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" alt="Picture 2" src="//lostechies.com/ryansvihla/files/2011/03/Picture2_thumb_343BC8E8.png" width="348" border="0" height="296" />](//lostechies.com/ryansvihla/files/2011/03/Picture2_21F07175.png) 

type in &ldquo;admin&rdquo; for the username and password and it should let you pass.&nbsp; Note going back to the site will not bring up a password box again.

<http://localhost:5000/home/signout>

will remove your cookie and you&rsquo;ll see the sign in form once more if you go to <http://localhost:5000> .&nbsp; Stayed tuned for more posts as I go more in depth with the different features and customizations of AuthKit.