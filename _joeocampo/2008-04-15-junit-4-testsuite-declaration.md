---
id: 112
title: JUnit 4 TestSuite Declaration
date: 2008-04-15T02:35:00+00:00
author: Joe Ocampo
layout: post
guid: /blogs/joe_ocampo/archive/2008/04/14/junit-4-testsuite-declaration.aspx
dsq_thread_id:
  - "262057834"
categories:
  - Java
  - JUnit
---
This is mainly for my own reference but if it helps people out there great!&nbsp; The documentation on this aspect of JUnit is very poor.

<div>
  <pre>package agalliao.wealthManagment.domain;<br /><br />import org.junit.runner.RunWith;<br />import org.junit.runners.Suite;<br /> <br />@RunWith(Suite.<span>class</span>)<br />@Suite.SuiteClasses({<br />  investmentTests.<span>class</span>,<br />  catalogTests.<span>class</span>,<br />  markerTests.<span>class</span> <br />})<br /><span>public</span> <span>class</span> AllTests {<br />    <span>// why on earth I need this class, I have no idea! </span><br />}</pre>
</div>