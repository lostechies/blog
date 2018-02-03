---
wordpress_id: 3872
title: How to Serve a Static File from toto
date: 2012-06-07T08:00:04+00:00
author: Sharon Cichelli
layout: post
wordpress_guid: http://lostechies.com/sharoncichelli/?p=110
dsq_thread_id:
  - "716925890"
categories:
  - Uncategorized
tags:
  - heroku
  - ruby
  - toto
---
## Also, How to Use Google Apps with toto

## Context: Google Apps, toto, dorothy, plain HTML

I am using the [toto blog engine](https://github.com/cloudhead/toto) to publish the [Polyglot Programmers of Austin](http://www.polyglotprogrammers.org/) site because I have always wanted blogging to comprise nothing more than text files and source control. (toto is nearly so.) [dorothy](https://github.com/cloudhead/dorothy) is the toto template I forked for the site.

I am using [Google Apps](http://www.google.com/apps/index1.html) to get a [calendar](http://www.polyglotprogrammers.org/calendar) and an email address at my domain. To make the email address work, I had to [prove to Google that I control the domain](http://support.google.com/a/bin/answer.py?hl=en&answer=60216), which you do by uploading a special file from Google to the root of your website.

## Problem: Requesting the HTML file returns a 404

When I na&iuml;vely deployed the Google Apps domain-verification file to my [heroku](http://www.heroku.com/) site, the verification did not work. Navigating to the url of the file returned a 404, file-not-found error. I needed to get toto out of the way, tell it that this file was outside its purview, do a Jedi mind trick and get the file simply to be served as if it were not Ruby.

## Solution: Add to the list of static files in config.ru

Open the dorothy template&#8217;s [config.ru](https://github.com/cloudhead/dorothy/blob/master/config.ru) configuration file and find the &#8220;Rack::Static&#8221; declaration. That collection lists the files and directories that should be served as static content, without interpretation. Within the brackets, add to that array of urls an entry for the Google Apps file. Surround it with single quotes. Precede it with a slash, to indicate it lives in the root of the directory. Mine looks like this:

<p style="margin-left:3em; font-family:monospace">
  use Rack::Static, :urls => [&#8216;/css&#8217;, &#8216;/js&#8217;, &#8216;/images&#8217;, &#8216;/favicon.ico&#8217;<span style="background-color:yellow;">, &#8216;/myGoogleFile.html&#8217;</span>], :root => &#8216;public&#8217;
</p>

Put the file itself into the /public folder, since the Rack::Static statement specifies that &#8220;public&#8221; is the root of the site. (See it at the end, there?)

Commit config.ru and the Google Apps file to your git repository, then push them to heroku.

<p style="margin-left:3em; font-family:monospace">
  git push heroku master
</p>

Yay!