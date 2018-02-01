---
id: 4763
title: 'Break out the popcorn, it&#8217;s movie time!'
date: 2008-11-25T20:46:00+00:00
author: Steve Donie
layout: post
guid: /blogs/stevedonie/archive/2008/11/25/break-out-the-popcorn-it-s-movie-time.aspx
dsq_thread_id:
  - "262124029"
categories:
  - Agile
  - analysis
  - burndown
  - ProjectManagement
  - retrospective
---
My team just finished up our most recent project &#8211; we spent about 4 months writing what we call a loader. It is basically an automated process that loads data from one database into another.

Over the past 2 years, as I have worked through several projects, I have created a spreadsheet that I use to keep track of our projects. One of the things it does is generate a release burndown chart. To help keep the rest of the company aware of our progress, I print that out every day or two and post it to our team room door. I also have Excel auto-publish the sheet, including the graph, to a webserver.

As we finished up, I decided it would be fun to see what the chart looked like in animated form. I was pretty pleased with the outcome of the project as we had been able to do several Good Things:

  * We were able to maintain a very consistent overall average velocity.
  * We were able to give the product owner information he was able to use to make decisions on what features to include or cut, based on a desired release date.
  * We were able to hit a release date without drama.
  * At the end of the project as we discovered problems with the data, our analysis, and the program itself, we were able to show how various decisions would affect the project.
  * It helped us to prevent feature creep &#8211; we had established credibility in the overall accuracy of our estimates and in our velocity.

So without further ado, here is a 6 minute analysis of the project using an animated burndown chart:



&nbsp;

One of the good things that has come from doing this is that when I first sent out a link to it inside the company, several people came up to me afterwards to say that they had learned a lot from it. One of the best comments was from our director of marketing. He said that he finally understood why I had been posting these on my door.

Educating everyone in the company about the benefits of agile software has been one of my most difficult challenges, and it feels like we are really making progress on that front.

For those interested, the tools used to create this are an Excel spreadsheet I use for burndowns, Windows Movie Maker for putting the movie together, Paint.net for doing modifications to various frames in the movie, Audacity for sound recording and editing, and Context programmers editor for editing the script. Basic process was to start at the end of the project and copy the graph from the spreadsheet into Paint.net and then save it as a .png file with a filename like yyyyMMdd.png. I then imported all the .png files into Windows Movie Maker and dropped them on the timeline after setting the default time for photos as short as possible. Watching the movie a couple times gave me some ideas on the script, so I started writing the script, deciding that I wanted to start at the end, rewind backwards to the beginning, and then move forward. As a wrote the script I saw that I was going to need some explanatory graphics, so I worked in paint.net to create the grayscale versions and the color-highlighted versions of some of the frames. After some final tweaking of the script, I used Audacity to record myself reading it. I did a little bit of editing to remove some pops and one or two places where I had to re-read something. After writing down timing down information on the script, I went back into movie maker to add frames and size everything to match up with the audio.

I&#8217;ve <a href="//lostechies.com/stevedonie/files/2011/03/Drillinginfo-Burndown-Template.xls" target="_blank">made the spreadsheet template available</a> &#8211; this is the first time I have made it public, and I don&#8217;t currently have any documentation for it other than what is in this post.

Basic usage is to start by editing the Work Remaining sheet. Set cell A2 to set your starting date. It will automatically fill out the remaining dates. It is up to you to factor in vacations, etc. Next, switch to the Stories sheet and start filling in one row for each story. You have to manually fill in the Code#, which is a unique ID. I just use incrementing numbers. The Buttons for Code# and Iteration sort the stories. For each story, fill in Story name, size (T, S, M, L) which automatically fills in the points column based on the lookup on the lookups sheet. Fill in importance &#8211; these should be unique numbers, with the most important things having the highest numbers. Fill in the created date and perhaps comments. Stories that have code numbers but no estimates get highlighted in yellow.

To start the project, just decide on an arbitrary number of points you think you can do in one iteration (we use 1 week iterations). You&#8217;ve sorted by importance, so start filling in the iteration column with &#8216;1&#8217; and watch the &#8216;points this iteration&#8217; cell until you reach your limit. As the iteration progresses, mark stories complete by filling in the &#8216;date completed&#8217; column and putting a &#8216;y&#8217; in the &#8216;Completed&#8217; column. If you decide to cut a story from this release, just put &#8216;cut&#8217; in the completed column. Usually I will update the burndown right after standup. Look at the numbers at the top right (Completed and remaining) and transcribe those to the correct row on the &#8216;work remaining&#8217; sheet. Watch your graph grow automagically. Use the built-in &#8216;publish automatically when saving&#8217; functionality to publish the sheet and the graph to some location on your intrawebs. Bask in the adulation your peers and managers will heap upon you. Don&#8217;t get too obsessive about it &#8211; the burndown is not the project, it is just a tool.

Note that this spreadsheet is a release-focused (rather than iteration-focused) burndown that has been created for the style of project that we work on, and may not be the best thing for you or your company. This was developed using Excel 2003, but is known to also work with Excel 2007. Also note that it does have macros, and that it is not signed. It comes with no warranty, expressed or implied. Use at your own risk. Your mileage may vary. Batteries not included. Do not mock happy fun ball. Enjoy!