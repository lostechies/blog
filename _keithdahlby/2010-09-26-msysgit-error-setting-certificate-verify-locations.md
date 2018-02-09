---
wordpress_id: 4215
title: msysGit error setting certificate verify locations
date: 2010-09-26T15:03:00+00:00
author: Keith Dahlby
layout: post
wordpress_guid: /blogs/dahlbyk/archive/2010/09/26/msysgit-error-setting-certificate-verify-locations.aspx
dsq_thread_id:
  - "262493369"
categories:
  - git
  - msysgit
redirect_from: "/blogs/dahlbyk/archive/2010/09/26/msysgit-error-setting-certificate-verify-locations.aspx/"
---
I had never had any problems using msysGit with SSL until last night, when I came across the following error:

<pre>$ git pull
Password:
error: error setting certificate verify locations:
 CAfile: /bin/curl-ca-bundle.crt
 CApath: none
 while accessing https://dahlbyk@github.com/dahlbyk/posh-git.git/info/refs

fatal: HTTP request failed</pre>

There were a number of suggestions in the comments on [GitHub&#8217;s Smart HTTP post](http://github.com/blog/642-smart-http-support "Smart HTTP Support - GitHub"), but they mostly seemed like hacks (most common: copy file from msysGit elsewhere, or turn off `http.sslverify`). A much easier fix is just to set `http.sslcainfo` to the absolute path of the `curl-ca-bundle.crt` file in your msysGit install&#8217;s `bin` folder:

<pre>$ git config --global http.sslcainfo "/c/Program Files (x86)/Git/bin/curl-ca-bundle.crt"</pre>

I chose to do this at the `--global` level so the setting won&#8217;t be overwritten by future msysGit installs.