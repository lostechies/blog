---
id: 64
title: Coordinating multiple ajax requests with jquery.when
date: 2011-10-20T22:17:33+00:00
author: Joshua Flanagan
layout: post
guid: http://lostechies.com/joshuaflanagan/2011/10/20/coordinating-multiple-ajax-requests-with-jquery-when/
dsq_thread_id:
  - "449213909"
categories:
  - JQuery
---
While building a rich JavaScript application, you may get in a situation where you need to make multiple ajax requests, and it doesn&#8217;t make sense to work with the results until after _all_ of them have returned. For example, suppose you wanted to collect the tweets from three different users, and display the entire set sorted alphabetically (yes, its contrived). To get the tweets for a user via jQuery, you write code like: 

<div style="padding-bottom: 0px; margin: 0px; padding-left: 0px; padding-right: 0px; display: inline; float: none; padding-top: 0px" id="scid:812469c5-0cb0-4c63-8c15-c81123a09de7:bbddfc1a-6180-4391-bcb6-b6b5299f83ba" class="wlWriterEditableSmartContent">
  <pre name="code" class="js">$.get("http://twitter.com/status/user_timeline/SCREEN_NAME.json",
  function(tweets){
    // work with tweets
   },
  "jsonp");
</pre>
</div>

_(For the purposes of this example, I&#8217;m going to assume there is no way to get the tweets for multiple users in a single call)_

To get the tweets for three users, you would need to make three separate <font face="Courier New">$.get</font> calls to the user_timeline endpoint. Since each call is executed asynchronously, with no guarantee which would return first, the code to coordinate the response for all three users would likely be a mess of shared state and/or nested callbacks.

As of jQuery 1.5, the solution is much simpler. Each of the ajax functions were changed to return a Deferred object which manages the callbacks for a call. (The Deferred object is beyond the scope of this post, but I encourage you to <a href="http://api.jquery.com/category/deferred-object/" target="_blank">read the documentation</a> for a more thorough explanation.) The power of Deferred objects become apparent when used with the new <font face="Courier New">jquery.when</font> utility function. <font face="Courier New">jquery.when</font> accepts any number of Deferred objects, and allows you to assign callbacks that will be invoked when all of the Deferred objects have completed. The Deferred objects returned by the ajax functions are complete when the responses are received. This may sound confusing, but it should be much clearer when you see it applied to the example scenario:

[gist id=1302978] 

  * I have a helper method, <font face="Courier New">getTweets</font>, which returns the return value of a call to $.get. This will be a Deferred object representing that call to the twitter server. 
      * I call <font face="Courier New">$.when</font>, passing it the three Deferred objects from the three ajax calls. 
          * The <font face="Courier New">done()</font> function is chained off of $.when to declare the code to run when all three ajax calls have completed successfully. 
              * The <font face="Courier New">done()</font> function receives an argument for each of the ajax calls. Each argument holds an array of the arguments that would be passed to that ajax call&#8217;s <font face="Courier New">success</font> callback. The <font face="Courier New">$.get success</font> callback gets three arguments: <font face="Courier New">data</font>, <font face="Courier New">textStatus</font>, and <font face="Courier New">jqXHR</font>. Therefore, the <font face="Courier New">data</font> argument from the call for @greenling_com tweets is available in <font face="Courier New">greenlingArgs[0]</font>. Similarly, the <font face="Courier New">textStatus</font> argument for the call for @austintexasgov tweets would be in <font face="Courier New">atxArgs[1]</font>. 
                  * The fifth line creates the <font face="Courier New">allTweets</font> array combining the tweets (the first, or <font face="Courier New">data</font>, argument) from all three calls to twitter.</ul> 
                It it that last point that is interesting to me. I&#8217;m able to work with a single collection containing data from three separate ajax requests, without writing any awkward synchronization code.
                
                <a href="http://jsfiddle.net/94PGy/4/" target="_blank">Play with the example</a> on jsFiddle