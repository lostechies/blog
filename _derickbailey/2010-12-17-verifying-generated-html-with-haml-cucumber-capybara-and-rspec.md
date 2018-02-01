---
id: 205
title: Verifying Generated HTML With HAML, Cucumber, Capybara and RSpec
date: 2010-12-17T18:39:00+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2010/12/17/verifying-generated-html-with-haml-cucumber-capybara-and-rspec.aspx
dsq_thread_id:
  - "262436989"
categories:
  - Capybara
  - Cucumber
  - HAML
  - RSpec
  - Ruby
  - Test Automation
  - Testing
---
Several of the reports that the app that Joey and I are working on will be generated via HAML to be displayed in the app, for the users. The generated content will end up being HTML, but starts it&#8217;s life as HAML markup &#8211; our preferred markup for Rails apps. It&#8217;s easy to generate HAML into HTML, in code:</p> 

We store the result of this in a model that is persisted in our database. Later, when a user requests the report, we pull the generated HTML out of the model and put it on the screen, so that it can be rendered in the user&#8217;s browser.

All of this works quite well and is easy for us to do. However, we ran into a problem when trying to verify the content from a Cucumber feature. We used this to try and match the generated HTML content from our model, with the content that was shown on the page:</p> 

But it didn&#8217;t work &#8211; we got errors saying that it couldn&#8217;t find the content we wanted even though we could clearly see the content on the page via our browser. I&#8217;m not entirely sure why this doesn&#8217;t work, honestly. I&#8217;m assuming that Capybara is doing something behind the scenes that causes the text it finds on the page to not be the same as the text we supplied &#8211; though I can&#8217;t say for sure.

After a significant amount of trial and error, writing out various bits of data to the console via Cucumber tests, and reading through a lot of Capybara and HAML documentation, we couldn&#8217;t get it to match with Capybara at all. So, we dropped back down to RSpec for the matcher.</p> 

I&#8217;m still not sure why, but this does work. We&#8217;re using Capybara to find the <body> tag of the page and load all of the content from the body via the .text attribute. Then we&#8217;re using RSpec&#8217;s &#8220;include&#8221; matcher to verify the content we pulled from the model was found in the raw text of the body.

It took significantly longer than we wanted, but we finally got the test passing. In the future when we are generating HTML from HAML, we&#8217;ll know to skip the Capybara matchers and using RSpec&#8217;s matchers within our Cucumber tests.