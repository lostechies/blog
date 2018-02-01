---
id: 740
title: Automating Docco Generation And Deployment To Heroku And Github
date: 2011-12-26T13:57:46+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=740
dsq_thread_id:
  - "516918942"
categories:
  - Command Line
  - Deployment
  - git
  - Rake
---
I got tired of manually typing &#8220;git push origin master&#8221; and &#8220;git push heroku master&#8221; to push changes in my BBCloneMail app up to Github and then deploy to Heroku. So I automated that with a rake task.

Then I got tired of the same 10 commands to generated new Docco docs for BBCloneMail and push that up to my Github \`gh-pages\`… so I automated that with a rake task, too.

The end result is 23 lines of rake tasks (including spaces and task definitions) to automate the updating of my project&#8217;s Docco documentation, push repository commits up to Github and then deploy to Heroku:

[gist id=1522004 file=rakefile.rb]

The only complexity in this is the process to update the Doco docs for the project. These commands ensure that the docs are built from the branch I&#8217;m currently on (which is always \`master\` for this project), but are only committed to the \`gh-pages\` branch, for the Github &#8220;Pages&#8221; feature. It also pushes the changes up to Github for me.

Now I just run \`rake deploy\` from the command line and everything is done for me. File this under &#8220;that was easy&#8221;.