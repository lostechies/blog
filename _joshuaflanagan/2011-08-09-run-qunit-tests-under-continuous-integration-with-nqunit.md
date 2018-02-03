---
wordpress_id: 57
title: Run QUnit tests under Continuous Integration with NQUnit
date: 2011-08-09T16:20:05+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: http://lostechies.com/joshuaflanagan/2011/08/09/run-qunit-tests-under-continuous-integration-with-nqunit/
dsq_thread_id:
  - "381632599"
categories:
  - JQuery
  - QUnit
  - teamcity
---
Almost three years ago, I wrote about <a href="http://lostechies.com/joshuaflanagan/2008/09/18/running-jquery-qunit-tests-under-continuous-integration/" target="_blank">Running jQuery QUnit tests under Continuous Integration</a>. As you can imagine, a lot has changed in three years. You would now have a lot of trouble following my post if you use the latest versions of WatiN and NUnit.

Fortunately, Robert Moore and Miguel Madero have already taken the code, fixed it to work with the latest libraries, and released it as <a href="https://github.com/robdmoore/NQUnit" target="_blank">NQUnit</a>. They&#8217;ve even packaged it up for easy consumption via Nuget:

<pre class="brush: shell; gutter:false;wrap-lines:false;tab-size:2">PM&gt; Install-Package NQUnit</pre>

My team recently dumped our implementation in favor of NQUnit. Thanks, and great job guys!