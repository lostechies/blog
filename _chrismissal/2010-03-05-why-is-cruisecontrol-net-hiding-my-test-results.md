---
id: 3379
title: Why is CruiseControl.Net Hiding My Test Results?
date: 2010-03-05T13:37:00+00:00
author: Chris Missal
layout: post
guid: /blogs/chrismissal/archive/2010/03/05/why-is-cruisecontrol-net-hiding-my-test-results.aspx
dsq_thread_id:
  - "262175130"
categories:
  - Continuous Integration
  - NUnit
  - Testing
---
Some time ago, I noticed a CruiseControl.Net build report with thousands of unit tests passed, zero failed and a dozen or so skipped, suddenly showing that no tests were run:

<img alt="Partial screenshot of CCNET showing no tests run." style="border: 1px solid black;margin: 5px" src="//lostechies.com/chrismissal/files/2011/03/zero-tests-run.png" />

I immediately thought somebody did something really bad. After some digging, I found an error in the CCNET log file that indicated an error was thrown and swallowed during the parsing of the test results xml file. It was choking on an NUnit Row Test with a null character in a string. Here is the exception:

<pre>2010-03-02 13:45:25,567 [Project.Web:DEBUG] Exception: System.Xml.XmlException: '.', hexadecimal value 0x00, is an invalid character. Line 5901, position 160.<br />&nbsp;&nbsp; at System.Xml.XmlTextReaderImpl.Throw(Exception e)<br />&nbsp;&nbsp; at System.Xml.XmlTextReaderImpl.Throw(String res, String[] args)<br />&nbsp;&nbsp; at System.Xml.XmlTextReaderImpl.Throw(Int32 pos, String res, String[] args)<br />&nbsp;&nbsp; at System.Xml.XmlTextReaderImpl.ThrowInvalidChar(Int32 pos, Char invChar)<br />&nbsp;&nbsp; at System.Xml.XmlTextReaderImpl.ParseNumericCharRefInline(Int32 startPos, Boolean expand, BufferBuilder internalSubsetBuilder, Int32& charCount, EntityType& entityType)<br />&nbsp;&nbsp; at System.Xml.XmlTextReaderImpl.ParseNumericCharRef(Boolean expand, BufferBuilder internalSubsetBuilder, EntityType& entityType)<br />&nbsp;&nbsp; at System.Xml.XmlTextReaderImpl.HandleEntityReference(Boolean isInAttributeValue, EntityExpandType expandType, Int32& charRefEndPos)<br />&nbsp;&nbsp; at System.Xml.XmlTextReaderImpl.ParseAttributeValueSlow(Int32 curPos, Char quoteChar, NodeData attr)<br />&nbsp;&nbsp; at System.Xml.XmlTextReaderImpl.ParseAttributes()<br />&nbsp;&nbsp; at System.Xml.XmlTextReaderImpl.ParseElement()<br />&nbsp;&nbsp; at System.Xml.XmlTextReaderImpl.ParseElementContent()<br />&nbsp;&nbsp; at System.Xml.XmlTextReaderImpl.Read()<br />&nbsp;&nbsp; at System.Xml.XmlWriter.WriteNode(XmlReader reader, Boolean defattr)<br />&nbsp;&nbsp; at ThoughtWorks.CruiseControl.Core.Util.XmlFragmentWriter.WriteNode(XmlReader reader, Boolean defattr)<br />&nbsp;&nbsp; at ThoughtWorks.CruiseControl.Core.Util.XmlFragmentWriter.WriteNode(String xml)</pre>

Here&#8217;s an example that again broke our results output the other day.

![](//lostechies.com/chrismissal/files/2011/03/row-test-with-null-char-in-string.png)

&nbsp;

This version of CruiseControl.Net isn&#8217;t the newest, and is older than the version of NUnit that is running. This may be fixed by upgrading CCNet, I haven&#8217;t tried yet though. This is just meant to be a &#8220;heads-up&#8221; in case you run into the same issue.

Unfortunately, my answer to getting the results to show back up was to remove both row tests.&nbsp; If anybody can add more details to this (affected versions, fixes, [workarounds](/blogs/chrismissal/archive/2009/04/02/workaround-is-a-four-letter-word.aspx), etc), it would be greatly appreciated by myself and hopefully somebody else.