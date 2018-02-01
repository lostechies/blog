---
id: 139
title: Taming Callback Hell in Node.js
date: 2014-02-18T20:10:34+00:00
author: Brad Carleton
layout: post
guid: http://lostechies.com/bradcarleton/?p=139
dsq_thread_id:
  - "2285163904"
categories:
  - JavaScript
  - node.js
---
<p dir="ltr">
  One of the first things that you’ll hear about Node.js is that it&#8217;s async and it uses callbacks everywhere.   In some ways this makes Node.js more complex than your typical runtime, and in some ways it makes it simpler.
</p>

When executing long sequences of async steps in series, it can be easy to generate code that looks like this:

<pre>// callback hell
exports.processJob = function(options, next) {
 db.getUser(options.userId, function(err, user) {
  if (error) return next(err);    
  db.updateAccount(user.accountId, options.total, function(err) {
   if (err) return next(err);
    http.post(options.url, function(err) {
     if (err) return next(err);
      next();
    });
  }); 
 });
};</pre>

<p dir="ltr">
  This is known as callback hell.  And while there is nothing wrong with the code itself from a functional perspective,  the readability of the code has gone to hell.
</p>

<p dir="ltr">
  One problem here, is that as you add more steps, you will see your code fly off the right of the screen (as each callback will add an additional nesting/indentation level).  This can be unnerving for us developers since we tend to read code better vertically than horizontally.
</p>

Luckily Node.js code is simply javascript, which means that you actually have a lot of flexibility in how you structure your code. You can make the snippet above much more readable by shuffling some functions around.

Personally, I’m partial to a little Node.js library called <a title="Async" href="https://github.com/caolan/async" target="_blank">async</a>, so I’ll show you how I use one of their constructs <a title="async series" href="https://github.com/caolan/async#series" target="_blank">async.series</a> to make the above snippet more readable.

<pre>exports.processJob = function(options, next) {

  var context = {};

  async.series({

    getUser: function(next) {
      db.getUser(options.userId, function(error) {
        if (error) return next(error);
        context.user = user;
        next();
      });
    },

    updateAcount: function(next) {
      var accountId = context.user.accountId;
      db.updateAccount(accountId, options.amount, next);
    },

    postToServer: function(next) {
      http.post(options.url, next);
    }

  }, next);
};</pre>

<p dir="ltr">
  What did we just do?
</p>

The **async.series** function can take either an array or an object.  The nice thing about handing it an object is that it gives you the opportunity to do some lightweight documentation of the steps by giving the keys of the objects names, like **getUser**, **updateAccount**, and **postToServer**.

Also, notice how we solved another problem, which is sharing state between the various steps by using a variable called “context” that we defined in an outer scope.

One cool thing about Node.js that async shows off quite nicely is that we can easily change these steps to occur in parallel using the same coding paradigm.  Just change from async.series to <a title="async parallel" href="https://github.com/caolan/async#paralleltasks-callback" target="_blank">async.parallel</a>.

The asynchronous archtiecture of Node.js can help make applications more scalable and performant, but sometimes you have to do a little extra to keep things manageable from a coding perspective. 

<link rel="stylesheet" href="//static.techpines.com/rainbow.css" />
</link>