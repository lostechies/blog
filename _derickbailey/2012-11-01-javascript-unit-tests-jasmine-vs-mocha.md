---
id: 1024
title: 'JavaScript Unit Tests: Jasmine vs Mocha'
date: 2012-11-01T07:04:09+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=1024
dsq_thread_id:
  - "911143963"
categories:
  - ChaiJS
  - Jasmine
  - JavaScript
  - MochaJS
  - Testing
  - Unit Testing
---
Someone recently asked me whether I prefer [Jasmine](http://pivotal.github.com/jasmine/) or [Mocha](http://visionmedia.github.com/mocha/) for unit testing JavaScript. My answer is:

Jasmine and Mocha are both great. I use both, depending on the project and team. There&#8217;s a great community around both, and you&#8217;ll find everything you need for either.

## Jasmine

Jasmine is easier to get started &#8211; it&#8217;s all-in-one package will generally get you and a team up and testing much faster, and you&#8217;ll be in good hands with it.

## Mocha

Mocha is significantly more flexible, but you have to piece it together yourself.

There is no spy framework built in to Mocha, so most people use [sinon.js](http://sinonjs.org/). There&#8217;s no assertion framework built in to Mocha either, so you&#8217;ll have to pick one. I like [Chai](http://chaijs.com/) for that, but there are many, many others available. You can also configure Mocha for BDD (jasmine style) or TDD (qunit style) easily. But you have to pick and choose how you want Mocha to work.

This flexibility is great because you can build the test environment that you really want. But it means you have more work to do, more individual pieces to maintain / keep up to date, etc.