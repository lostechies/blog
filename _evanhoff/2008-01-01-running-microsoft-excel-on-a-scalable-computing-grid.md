---
wordpress_id: 32
title: Running Microsoft Excel on a Scalable Computing Grid
date: 2008-01-01T22:07:03+00:00
author: Evan Hoff
layout: post
wordpress_guid: /blogs/evan_hoff/archive/2008/01/01/running-microsoft-excel-on-a-scalable-computing-grid.aspx
categories:
  - Uncategorized
redirect_from: "/blogs/evan_hoff/archive/2008/01/01/running-microsoft-excel-on-a-scalable-computing-grid.aspx/"
---
Sorry, I had to post this one.

Ever written an Excel application which was both data and cpu intensive?&nbsp; Maybe you work for a financial company and want to run your realtime risk analysis off your current trusty Excel spreadsheet.&nbsp;&nbsp; By now, you&#8217;ve probably realized that Excel isn&#8217;t the quickest thing for pulling 800k records from the database and running the numbers \*in real time\*, so what do you do?

Enter GigaSpaces&#8230;

> GigaSpaces provides a grid-based middleware stack built on a unified messaging, distributed datacaching and parallel-processing engine. GigaSpaces leverages Space-Based technology and shares a single, common runtime clustering model.

Apparently, the whole process involves only two steps:

>   1. Use GigaSpaces’ In-Memory-Data-Grid to store and access the data
>   2. Move the logic from the worksheets to run (in parallel) close to the data
> 
> What kind of work is involved?
> 
> Leverage GigaSpaces’ robust Excel integration and .NET support to connect Excel to the data center
> 
> Initial Effort is Minimal
> 
>   * Replace Excel calls to existing data source(s) with calls to GigaSpaces In-Memory-Data-Grid
> 
> The next step is to migrate the algorithms from the Excel client to the servers (running close to the data)
> 
>   * GigaSpaces’ Microsoft Certified partners are able to assist in  
>     this task

Gotcha! lol

And no, this wasn&#8217;t a joke.&nbsp; I did get a good laugh out of it though.

<a href="http://www.gigaspaces.com/os_papers.html#MS_GigaSpaces_Excel_That_Scales" target="_blank">Excel that Scales</a>

[Presentation](http://www.gigaspaces.com/presentations/Excel_Biz.pdf)

<a href="http://www.gigaspaces.com/presentations/MS_1_Pager.pdf" target="_blank">1 Sheet</a>

If I had to guess, they are probably laughing as well.&nbsp; All the way to the bank.&nbsp; I&#8217;m sure some people are buying this stuff.

GigaSpaces, btw, has some really cool looking stuff.&nbsp; One of these days, I will take the time to dig into it deeper.