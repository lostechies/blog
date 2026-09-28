---
wordpress_id: 533
title: Custom Jasmine Matchers For Clarity In Testing Backbone.js Models
date: 2011-09-03T14:22:40+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=533
dsq_thread_id:
  - "403891191"
categories:
  - Backbone
  - Behavior Driven Development
  - JavaScript
  - Testing
---
I&#8217;ve been writing some [Jasmine](http://pivotal.github.com/jasmine/) specs for a sample [Backbone.js](http://documentcloud.github.com/backbone/) application that I&#8217;m building. The application is a simple image gallery, and one of the features is the ability to navigate to through the image list with &#8216;next&#8217; and &#8216;previous&#8217; arrows. The code to move to the next or previous image is not terribly difficult, but there are a few edge cases to cover &#8211; such as what happens when no image is selected and you call &#8216;next&#8217;, or when you&#8217;re on the first image in the list and you call &#8216;previous&#8217;. I wanted to make sure I covered these cases in my specs, to make sure I didn&#8217;t have any regression failures as additional features were added to the application.

## Duplicate Code In My Specs

In the process of writing up specs for the image navigation, I found myself repeating a few lines of code in each of them to check the index of the currently selected image.

{% gist 1191641 1-no-custom-matcher.js %}

Lines 7, 8 and 9 of this gist show what I was doing to check the index of the selected image against what I expected. This code works and it got me through my first set of tests. I quickly got tired of writing the same lines of code for every test while only varying the actual and expected indexes, though.

In addition to the duplicated code, a failing test (when the index was not what I expected) would produce an error message like &#8220;Expected 0 to 1&#8221;. This is not terribly informative&#8230; what do &#8220;0&#8221; and &#8220;1&#8221; mean? If I wasn&#8217;t in the code already working with it, I&#8217;d have to go examine the failing code to be able to answer that.

## Custom Jasmine Matchers FTW!

To reduce the code duplication and provide a better error message, I decided to write a custom jasmine matcher. The end result allowed me to have spec code that looks like this:

{% gist 1191641 2-with-custom-matcher.js %}

Line 7 of this gist shows the new matcher in action.

Note the name of the matcher that I created: &#8216;toHaveSelectedImageAt&#8217;. Not only have I reduced the amount of cod (and code duplication) to check the index, but I&#8217;ve also introduced application-specific language into the syntax of my tests! When I read this test now, I read it in my mind as &#8220;i expect this image collection to have a selected image at index #&#8217;. This provides much greater understanding of what the matcher does and is looking for / checking against.

Also note that I&#8217;m calling the &#8216;expect(…)&#8217; method on my images collection, directly, and then telling my matcher method what index I expect to see for the selected image. Since the images collection knows which image is selected, there&#8217;s no need for me to pull the index out of the collection in my spec, directly. I can let the custom matcher do this for me and simply tell the matcher what index I&#8217;m expecting the currently selected image to be at.

Lastly, the error message that I receive when a test fails has been customized to say: &#8220;Expected selected image index of 0 to be 1&#8221;. Again, this gives me application-specific information instead of just raw numbers. Now when my tests fails, I can see exactly what was being checked and have some context to interpret the numbers &#8220;1&#8221; and &#8220;0&#8221; in the error message.

## Implementing toHaveSelectedImageAt

The basic implementation of my &#8216;toHaveSelectedImageAt&#8217; matcher uses the same code that I originally had in my specs.

{% gist 1191641 3-toHaveSelectedImageAt.js %}

In addition to the index checking code, I&#8217;m modifying a few properties of the matcher object to provide better context and information for the error messages.

&#8220;this.actual&#8221; is initially set by the object that you pass into the &#8216;expect&#8217; method call. It&#8217;s used to report the actual value found by your test, if you don&#8217;t provide a custom error message. I&#8217;m sure there are other uses for this, but that&#8217;s the most basic use I&#8217;ve seen so far.

The &#8220;this.message&#8221; function returns the error message that I want. I&#8217;m not entirely sure why this needs to be a function, but it does need to be. You&#8217;ll get error messages about not being able to call &#8220;apply&#8221; if it isn&#8217;t a function.

Last, the function needs to return a boolean to specify whether or not the test passed. True == passed, false == failed. When a test fails, the message function is called to retrieve the message that is displayed.

If you&#8217;d like to see all of this code in one place, it&#8217;s available on [this github gist](https://gist.github.com/1191641).

## Not Just For Backbone Objects

The truth about this example is that I&#8217;m only incidentally using Backbone.js models and collections. Any time you have repetitious code in your specs&#8217; expectations, error messages that offer no insight into the application&#8217;s functional failures, or plain-old ugly code to set up and assert your expectations, you should consider creating a custom matcher. And, if you can add application-specific language into that matcher&#8217;s method name and error message while you&#8217;re at it, you&#8217;ll be sitting in a much better position a few days / weeks / months down the road when you have to revisit this code and remember / re-learn what you had previously built.
