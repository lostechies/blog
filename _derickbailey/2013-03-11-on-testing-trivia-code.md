---
wordpress_id: 1063
title: 'On Testing &#8220;Trivial Code&#8221;'
date: 2013-03-11T11:05:06+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=1063
dsq_thread_id:
  - "1130835457"
categories:
  - AntiPatterns
  - Principles and Patterns
  - Quality
  - Test Automation
  - Testing
  - Unit Testing
---
I can&#8217;t resist jumping on the band-wagon and telling people that they&#8217;re wrong, so here goes… 😀

Mark &#8220;Ploeh&#8221; Seemann wrote a post on [testing trivial code](http://blog.ploeh.dk/2013/03/08/test-trivial-code/). There have been several responses saying he&#8217;s wrong and that [you shouldn&#8217;t test trivial code](http://blog.markrendle.net/2013/03/09/dont-unit-test-trivial-code/). Some of the responses have been a little [less graceful](https://github.com/ploeh/ploeh.github.com/pull/7) than others (and slightly gross and maybe NSFW &#8211; an orangutan peeing).

Everyone that has responded so far, is wrong in some way. I&#8217;m wrong in some way as well and I&#8217;m sure this is going to turn in to another &#8220;beating the dead horse&#8221; conversation quickly with people pointing fingers and poking eyes. I just want in on the fun while it is here to be had.

## Ploeh Is Right, For The Wrong Reasons

I think Mark is right in that we should test most of our &#8220;trivial&#8221; code (if not all of it). I think he&#8217;s very very wrong is saying that we should unit test all of it &#8211; especially with the examples that he showed of unit testing a C# auto-property for a date/time field.

Mark is right because this field must add some value to the system. If it doesn&#8217;t add some value, it shouldn&#8217;t be there. If it does add some value, we should guarantee the value that it adds. 

## Jimmy Bogard Got It Right

Jimmy wrote a post that I think was unrelated, but happens to [fit perfectly in to the conversation](http://lostechies.com/jimmybogard/2013/03/06/when-should-you-test/). In that post he says:

> When should you test?
> 
> When it provides value.
> 
> When is that?
> 
> It depends.

Ultimately, it depends is the only reasonable answer. But let&#8217;s take the example of a date/time auto-property that Mark used in his example, for our purposes and discussion.

The value that a date/time property adds may not be in the business logic that uses it. It may not have anything to do with handling of the date/time in some creative way to make sure other things happen at a certain time. It might be as simple as an invoice date, or perhaps a purchase order # on an invoice. Both of these fields are trivial, but both add value to the idea of an invoice. I wouldn&#8217;t unit test these fields if they are only used for display purposes, though. Instead, I would focus the test on the place that the field provides value &#8211; the end to end solution.

## Mark Rendle Got Part Of It Right, Too

I think [Mark Rendle](http://blog.markrendle.net/2013/03/09/dont-unit-test-trivial-code/) got some of it right in his response, too. He talks about the idea of validation code in the UI to ensure a date can&#8217;t be set in the past, if that is what the business needs are.

This leads to the real point in adding value in tests.

## Functional Tests, Not Unit Tests

The value that trivial fields used for display purposes adds, is found in the display of the information. In this case the use of an Invoice Date and Purchase Order Number on the invoice that is sent to the person that needs to pay it  provides value to both the person sending the invoice and the person receiving the invoice &#8211; so test that. Test the display of the information because that&#8217;s where the value is found. Write a functional test that runs your invoice generating process and use a simple UI test to ensure the date shows up. This is where a test provides value for trivial code in this case &#8211; functional tests, not unit tests.

A unit test around a C# auto-property is a bad idea because it only tests the compiler and runtime as others have pointed out. But a functional test that proves &#8220;When I supply a Purchase Order Number, Then the invoice should display the Purchase Order Number&#8221; is a valuable, functional, end to end test. After all, If I were a customer of a company and I sent them a PO# for an invoice, I would want that PO# to show up on my invoice. If it didn&#8217;t show up, I&#8217;d be a little &#8220;[YOU ONLY HAD ONE JOB TO DO!](http://hadonejob.com/)&#8221; upset. If I send you a PO# because I need it on my invoice, you better send the invoice back with the PO# or you&#8217;re not getting paid &#8211; at least, you are decreasing the chances of getting paid on time.

## Value In Trivial Code

There&#8217;s no value in testing trivial code? My &#8220;BS&#8221; alarms are ringing. You want to write unit tests for auto-properties in C#? My &#8220;BS&#8221; alarms are still ringing loud and clear!

My example of using a functional test to prove the value of a PO# is only an example, and not meant to be the ultimate answer or solution. You need to take the time to understand where the value for your trivial code really is. Once you do that, you&#8217;ll understand how to properly scope your tests to prove the value of that trivial code. 

If you can articulate the value of that auto-property when you&#8217;re talking to a coworker, you can write a correctly scoped test to prove the value. If you can&#8217;t provide a description of the value of that trivial code, though… it probably doesn&#8217;t need to be there.