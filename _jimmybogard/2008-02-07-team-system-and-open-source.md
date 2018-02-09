---
wordpress_id: 140
title: Team System and open source
date: 2008-02-07T13:30:08+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2008/02/07/team-system-and-open-source.aspx
dsq_thread_id:
  - "264715549"
categories:
  - Tools
redirect_from: "/blogs/jimmy_bogard/archive/2008/02/07/team-system-and-open-source.aspx/"
---
A note to all open source developers in .NET:

### DO NOT use any exclusive Team System features in your open source projects!

Team System and the Team Edition flavors **do not** mix with open source projects.&nbsp; I opened up the [SDC Tasks Library](http://www.codeplex.com/sdctasks) on CodePlex and was greeted by this fun message:

 ![](http://grabbagoftimg.s3.amazonaws.com/teamtest.PNG)

Since I am using Visual Studio 2005 Professional, I can&#8217;t open the &#8220;Test&#8221; project containing all of the tests.&nbsp; This is unacceptable and borderline insulting.&nbsp; No one except users of Team System can even open the project.&nbsp; Only some of the Team Edition installations can open this project type.&nbsp; There&#8217;s not even anything interesting about this project, it just contains unit tests!

In VS 2008, Test Projects are included with the Professional edition.&nbsp; That means that Express edition users will be out of luck too.

**If you&#8217;re developing open source libraries, all assembly dependencies should be included in your source repository.&nbsp; If the license for the dependent assembly doesn&#8217;t allow for redistribution, don&#8217;t depend on it.&nbsp; Pick something else.**