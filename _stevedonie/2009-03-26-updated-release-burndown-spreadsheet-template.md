---
id: 4769
title: Updated Release Burndown Spreadsheet Template
date: 2009-03-26T22:20:00+00:00
author: Steve Donie
layout: post
guid: /blogs/stevedonie/archive/2009/03/26/updated-release-burndown-spreadsheet-template.aspx
dsq_thread_id:
  - "262124062"
categories:
  - Agile
  - burndown
  - ProjectManagement
  - Scrum
---
I mentioned this release burndown template in one of my earlier posts, but I have updated it quite a bit since then, so I am re-posting the link, along with some instructions.

[Release Backlog Template](http://clayvessel.org/clayvessel/wp-content/uploads/2011/05/Release-Backlog-Template.zip)

Here are the instructions &#8211; which are also in the spreadsheet itself.

This spreadsheet was evolved over several years, and incorporates work by Stefan Niejnhuis and Henrik Kniberg. It has been optimized for the process followed by a specific team, and while it can be used as a starting point for your own work, it should probably be adapted to fit oyur particular needs. I will try to describe some of the assumptions made so that customizing it can be done intelligently.

Basic usage is to start by editing the Work Remaining sheet. Set cell A2 to set your starting date. It will automatically fill out the remaining dates. Note that my team uses one week iterations that start and end on a Tuesday. Cell A2 is therefore assumed to be a Monday. Next, switch to the Stories sheet and start filling in one row for each story. You have to manually fill in the Code#, which is a unique ID. I just use incrementing numbers. The Buttons for Code# and Importance sort the stories. I typically keep the stories sorted by importance, but when adding a new story I sort by code # so I can figure out what the next story number is. For each story, fill in Story name, size (T, S, M, L) which automatically fills in the points column based on the lookup on the lookups sheet. Fill in importance &#8211; these should be unique numbers, with the most important things having the highest numbers. Typically I start by using 100, 110, 120, etc. and going up, leaving gaps to make it easier to squeeze new items in between existing items. It is very important that items have unique importance numbers. Fill in the created date and perhaps comments. Stories that have code numbers but no estimates get highlighted in yellow. Stories that are estimated but not prioritized also get highlighted in yellow.

For your day to day work, you will start by deciding on an arbitrary number of points you think you can do in one iteration. Sort the spreadsheet by importance, and start filling in the iteration column with &#8216;1&#8217; and watch the &#8216;points this iteration&#8217; cell until you reach your limit. As the iteration progresses, mark stories complete by filling in the &#8216;date completed&#8217; column and putting a &#8216;y&#8217; in the &#8216;Completed&#8217; column. If you decide to cut a story from this project, just put &#8216;cut&#8217; in the completed column. If you want to postpone a story to some future release, you can put &#8216;future&#8217; in the completed column. Each day after standup, update the work remaining page. Look at the numbers at the top right of the Stories page (Completed and remaining) and transcribe those to the correct row on the &#8216;work remaining&#8217; sheet. Watch your graph grow automagically. One thing that I do is to use Excel&#8217;s built-in &#8216;publish automatically when saving&#8217; functionality to publish the sheet and the graph to some location on my intranet.

For following iterations, you will end the iteration by seeing how many points you completed over the past iteration (see the &#8220;Work Remaining&#8221; page, &#8220;5 day moving average velocity&#8221; and multiply that by 5. Assuming your team has the same capacity as the previous week, that is how many points you can commit to for the next iteration.

On the Stories page, there are three buttons at the top left. The first is &#8220;Generate Index Cards&#8221;. Pressing this opens a dialog with a few options that should be self-explanatory. When you press the &#8216;generate index cards&#8217; button in the dialog, a macro will start that deletes the old cards page, then copies relevant information from the stories page into a new cards page, using the CardTemplate page as a template. Printing these on 8 1/2 x 11 paper using the current template will give 2 cards per page. We just cut those in half and track the weekly iteration on a bulletin board. I&#8217;ll blog about that sometime &#8211; keep your eye on http://stevedonie.lostechies.com/

The other buttons on the stories page are &#8220;compact view&#8221; and &#8220;expanded view&#8221;. These are basically toggles between two different views. I use the compact view most often. When editing stories, I will switch to expanded view to make it a bit easier to type in the story notes and &#8216;how to demo&#8217; sections.

Don&#8217;t get too obsessive about it &#8211; the burndown is not the project, it is just a tool.

Note that this spreadsheet is a release-focused (rather than iteration-focused) burndown that has been created for the style of project that we work on, and may not be the best thing for you or your company. This was developed using Excel 2003, but is known to also work with Excel 2007. Also note that it does have macros, and that it is not signed. It comes with no warranty, expressed or implied. Use at your own risk. Your mileage may vary. Batteries not included. Do not mock happy fun ball. Enjoy!