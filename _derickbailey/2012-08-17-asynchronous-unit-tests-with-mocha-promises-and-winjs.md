---
wordpress_id: 976
title: Asynchronous Unit Tests With Mocha, Promises, And WinJS
date: 2012-08-17T08:58:12+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=976
dsq_thread_id:
  - "809007782"
categories:
  - Async
  - ChaiJS
  - CommonJS
  - JavaScript
  - MochaJS
  - Testing
  - WinJS
---
Before I get in to the guts of this post, you need to [read Christopher Bennage&#8217;s post on how we have our Mocha test suite set up for our Win8 / WinJS project](http://dev.bennage.com/blog/2012/08/15/unit-testing-winjs/). It&#8217;s not the best setup, but it works. It allows us to write tests for our app, even if it is a little bit painful to constantly link files in to the test project. I have hopes that we&#8217;ll find a better solution for this, but for now, we&#8217;re moving forward with this because it works.

I&#8217;ve already talked about how [you need to understand promises in order to build Win8 / WinJS applications](http://lostechies.com/derickbailey/2012/07/19/want-to-build-win8winjs-apps-you-need-to-understand-promises/). It&#8217;s an absolute must because there is almost no way you can build an app without using them. Anything you might build that doesn&#8217;t use them would likely be very trivial and not very useful, honestly. They are baked in to the WinJS framework very deeply and I see this as a good thing. But understanding how to use a promise is very different than understanding how to write tests for code that uses promises. 

## Asynchronous Mocha Tests

Testing a promise means that you&#8217;re testing asynchronous code. You have no knowledge of when the asynchronous code will finish. Because of this you can&#8217;t just assign some value to a variable in the async callback and hope your test will catch it. This can be demonstrated easily by using a call to &#8220;setTimeout&#8221; within a [Mocha](http://visionmedia.github.com/mocha/) test, using [Chai](http://chaijs.com/) as the expect framework:

{% gist 3379456 1.js %}

Now you might think that this test should pass. When the &#8220;expect&#8221; is run inside of the specification, it should verify that the &#8220;foo&#8221; variable is set to true because the code in the setTimeout call sets it to true. But the test fails because the expectation is run before the callback in the setTimeout is called. 

To correct this, Mocha can provide a &#8220;done&#8221; callback method that you can call from the beforeEach call, afterEach call, it calls, and more. This &#8220;done&#8221; parameter, when present in your callback function, tells Mocha that you are writing an asynchronous test. This causes mocha to enter a timer when the function with the &#8220;done&#8221; parameter runs, waiting for the async function to finish &#8211; which is facilitated by either calling the \`done()\` function, or by exceeding a 2 second timeout. 

The basic idea behind the \`done()\` call is that you call this after your async code has completed, and your test has modified everything it needs to modify, so you can check the results correctly.

With that in mind, we can update our test to use the done call:

{% gist 3379456 2.js %}

And now the test passes. We&#8217;re telling Mocha to wait for the async code to complete before it runs the expectations. When the timeout finally fires, we set our &#8220;foo&#8221; variable to true and then call \`done()\`. This tells Mocha that the async test is finished and it moves on to the expectations. 

## Testing The Value In A Promise&#8217; Callback

When a promise resolves, it often provides a value as a parameter to the callback function. This allows you to get the information that you requested in an asynchronous manner. And it&#8217;s often the case that the value of this async callback needs to have assertions or expectations set against it. There are a couple of ways that this can be done, depending on your specific scenario and the code you&#8217;re trying to test.

The first way is to add your &#8220;then&#8221; callback in the beforeEach of the test. You would assign the value from this function to a variable that is set up in the &#8220;describe&#8221; function. Then your expectations can check the value.

{% gist 3379456 3.js %}

This works well for very simple scenarios and I generally recommend doing this when you can. It&#8217;s the easiest way to test the result of the promise. However, that&#8217;s not always an option. Sometimes a test is more complicated, has more expectations that it needs to verify, etc. In more complex situations you might find that the number of variables you have to create in the describe block is getting out of hand, or that the beforeEach function is doing too much work &#8211; work that should legitimately be in the expectations. In this scenario, you can move the async test and the &#8220;done&#8221; call in to the expecation&#8217;s &#8220;it&#8221; function. But it comes with a small trick that you need to do.

## Expectations In Promises Are Problematic

Moving the async &#8220;done&#8221; call to an expectation is easy. You just add the &#8220;done&#8221; parameter to the &#8220;it&#8221; function and call it &#8211; the same as you would do in the beforeEach function.

{% gist 3379456 4.js %}

But testing a WinJS promise with Mocha introduces a small complexity. When you call the &#8220;expect&#8221; function and the expectation fails, an exception is thrown. Normally, Mocha intercepts this exception from the expectation and reports it as a test failure. This is how Mocha works and it works well… until we introduce WinJS promises.

The problem with promises is that they intercept the expectation&#8217;s error throwing for us, preventing Mocha from seeing the error. For example, in this test, we should see a message saying it expected &#8220;false&#8221; to be &#8220;true&#8221;. What we get instead is a timeout error saying the test exceeded 2 seconds (2000ms). 

{% gist 3379456 5.js %}

When the promise completes, a value of false is passed in as the parameter of the &#8220;then&#8221; function. The expectation throws an error because it expects false to be true. This is all good so far. We expect this to fail. The problem comes in when the exception is thrown, though. Normally, the exception would be caught by the Mocha test runner which would cause the test to fail and Mocha would report the failure. But in this case, the promise is catching the error for us. That means the error never makes it out to Mocha. Throwing an error also means the &#8220;done()&#8221; function is never called, so the test goes in to a wait state and Mocha times out at 2 seconds, giving us a report of the testing timing out instead of the message from the failed expectation.

## Done, Done, Done, Done: Async Expectations With WinJS Promises

To fix this problem, we need to take advantage of how WinJS promises work. According to the [WinJS promises documentation](http://msdn.microsoft.com/en-us/library/windows/apps/hh700337.aspx) and the [Promises/A Spec](http://wiki.commonjs.org/wiki/Promises/A) that WinJS promises implements, throwing an exception in a &#8220;then&#8221; function causes the error to be forwarded to the error handling function of the promises &#8220;done&#8221; function. In other words, we can get access to the error that the expectation threw by chaining a &#8220;done&#8221; call on to the end of the &#8220;then&#8221; call:

{% gist 3379456 6.js %}

Ok, this is going to be a bit confusing. The &#8220;promise.then().done()&#8221; call is [the promise&#8217;s &#8220;done&#8221; function](http://msdn.microsoft.com/en-us/library/windows/apps/hh701079.aspx). But Mocha also provides a &#8220;done&#8221; callback to the beforeEach and it functions… So there&#8217;s a lot of &#8220;done&#8221; in the upcoming discussion. I&#8217;ll try to keep things clear as much as I can.

At this point, we need to complete the async expectation. But we don&#8217;t want to call Mocha&#8217;s &#8220;done()&#8221; callback as-is because that would tell Mocha that the test passed. Instead, we need to call Mocha&#8217;s &#8220;done&#8221; callback with a parameter &#8211; the error that we caught. Passing a parameter to the Mocha&#8217;s &#8220;done&#8221; function &#8211; any parameter &#8211; tells Mocha that the test failed. It assumes that the parameter you pass in is the error from the expectation or the reason that the test failed. That means we can call Mocha&#8217;s &#8220;done&#8221; function with the &#8220;error&#8221; parameter of our error handling callback:

{% gist 3379456 7.js %}

Note the &#8220;null&#8221; first parameter of the promise&#8217;s &#8220;done&#8221; call. This is there because the &#8220;done&#8221; method takes 3 parameters as noted in the previous code snippet.

And we can make the code even more simple than this. Since the error handling callback of the promise has the same method signature of Mocha&#8217;s &#8220;done&#8221; callback, we can get rid of the inline function and pass &#8220;done&#8221; as the callback directly:

{% gist 3379456 8.js %}

Lastly, we still need to call Mocha&#8217;s &#8220;done()&#8221; from within our promise&#8217;s &#8220;then&#8221; function. This tells Mocha that the test is complete in cases where the expectation is met (the test passes).

Now you might be tempted to pass Mocha&#8217;s &#8220;done&#8221; as a parameter to the promise&#8217;s &#8220;then&#8221; and &#8220;error&#8221; callbacks of the promise&#8217;s &#8220;done&#8221;, like this:

{% gist 3379456 9.js %}

That won&#8217;t work, though, because the &#8220;then&#8221; callback receives a parameter from the promise and this would forward the parameter to Mocha&#8217;s &#8220;done&#8221; function, which would be interpreted as a test failure. So we have to keep Mocha&#8217;s &#8220;done()&#8221; call for a successful test in an inline callback of the promise&#8217;s &#8220;then&#8221; function, with our expectation.

With this in place our test passes and fails correctly. We get the error message that says it expected false to be true when we complete the promise with a value of &#8220;false&#8221;, and we get a passing test when we complete the promise with a value of &#8220;true&#8221;.

(… yeah, that&#8217;s a lot of &#8220;done&#8221; calls in our expectation, but it works. Hopefully that made sense.)

## Async Tests: Problem Solved

As you can see, promises can pose a small challenge for unit tests. But they aren&#8217;t impossible or really that difficult to test. It just takes a little bit of understanding &#8211; how promises work, and how Mocha works. With that bit of knowledge, it&#8217;s pretty easy to get the tests to pass and fail correctly. The best part of this, though, is that you now have all the tools you need to do asynchronous testing with or without promises. You know all of the traps to look for, and all of the patterns to implement &#8211; whether it&#8217;s a WinJS promise, a jQuery AJAX call in a browser, a setTimeout call in your JavaScript code somewhere else, or any other asynchronous code in NodeJS or any other JavaScript runtime.
