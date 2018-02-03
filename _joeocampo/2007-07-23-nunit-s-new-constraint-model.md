---
wordpress_id: 36
title: 'NUnit&#8217;s new Constraint model'
date: 2007-07-23T01:48:35+00:00
author: Joe Ocampo
layout: post
wordpress_guid: /blogs/joe_ocampo/archive/2007/07/22/nunit-s-new-constraint-model.aspx
dsq_thread_id:
  - "262088275"
categories:
  - BDD (Behavior Driven Development)
---
I was working on some code this weekend and happened to come across <a href="http://nunit.com/blogs/?p=44" target="_blank">NUnit 2.4&#8217;s&nbsp;new constraint objects</a>.&nbsp; I can&#8217;t believe I just now found out about this!&nbsp; I am glad to see that the mocking frameworks influenced this addition to NUnit.&nbsp; &nbsp;Being a big fan of fluent interfaces, I love how the new constraint model allows the assertion model to be easily read.&nbsp; For example:

This was the tried and true Assertion model for the past 4 years.

> <font face="Courier New">Assert.AreEqual(expectedBallance, savings.Ballance);</font>

Now with the new constraint model the assertion can now be written as:

> <font face="Courier New">Assert.That(savings.Ballance, Is.EqualTo(expectedBallance));</font>

&nbsp;

I will start refactoring my unit test to this syntax going forward.&nbsp; I encourage everyone else to do the same as well.

If you want to see the different uses of the constraint model you can view the NUnit source code&nbsp;and look for the class: AssertSyntaxTests

or you can click <a href="http://www.koders.com/csharp/fidD1B83A597F488B4428269DC8051FFDE8208C2C56.aspx" target="_blank">here</a>.