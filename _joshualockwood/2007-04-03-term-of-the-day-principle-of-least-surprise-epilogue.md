---
wordpress_id: 11
title: 'Term of the Day: Principle Of Least Surprise &#8211; Epilogue'
date: 2007-04-03T17:51:00+00:00
author: Joshua Lockwood
layout: post
wordpress_guid: /blogs/joshua_lockwood/archive/2007/04/03/term-of-the-day-principle-of-least-surprise-epilogue.aspx
categories:
  - Agile
  - Best Practices
  - Principles
  - TDD
  - Unit Tests
  - Why We Rock
---
<SPAN>Okay, this is funny.&nbsp; Little did I know that while writing “Term of the Day: Principle Of Least Surprise” I was entering the midst of just such a problem.</SPAN>


  


<SPAN>The entry was written over a 2-3 hour span during compile waits on various tasks.<SPAN>&nbsp; </SPAN>The last hour or so required debugging due to some really strange behavior.<SPAN>&nbsp; </SPAN>I was working at the persistence layer on a data mapper responsible for persisting a complex object, adding support for new composite type that was a few levels down in the object model.<SPAN>&nbsp; </SPAN>Everything looked right, but for some reason my tests kept failing.<SPAN>&nbsp; </SPAN><SPAN>&nbsp;</SPAN>I finally had to debug and intercept the SQL that was generated to see what was going on.<SPAN>&nbsp; </SPAN></SPAN>


  


<SPAN>In the end I found the problem in a class that I wasn’t using directly that was providing the table name.<SPAN>&nbsp; </SPAN>This is okay and common in our persistence framework.<SPAN>&nbsp; </SPAN>What was not okay was that it specified the target database along with the table name, ignoring the connection information that was passed back to the data mapper.<SPAN>&nbsp; </SPAN>The mapper was saving data to the correct database, but was retrieving it from another database.<SPAN>&nbsp; </SPAN>I took out notwhatiwant.dbo from the const defining the table name and ran my tests again…some other tests on code that I wasn’t working on started to fail.<SPAN>&nbsp; </SPAN>It didn’t take too long to clean everything up after that, but it was annoying.</SPAN>


  


<SPAN>…lol, told you it wasn’t that uncommon</SPAN>


  


<SPAN>P.S.<SPAN>&nbsp; </SPAN>This is also a great argument for automated unit tests.<SPAN>&nbsp; </SPAN>Resolving this was only quick because of over 5,000 automated unit tests that cover our code.<SPAN>&nbsp; </SPAN>The tests that broke relate to the code base from a separate subsystem that I wasn’t even working on.<SPAN>&nbsp; </SPAN>The need that prompted the addition of the database name to the tableName constant was addressed implicitly and in such a way that limited reuse.<SPAN>&nbsp; </SPAN>Without the tests I probably would have ended up deploying a new bug.<SPAN>&nbsp; </SPAN>We have great tests…that’s why we rock.</SPAN>