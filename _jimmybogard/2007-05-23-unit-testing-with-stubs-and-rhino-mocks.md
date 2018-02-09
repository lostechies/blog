---
wordpress_id: 23
title: Unit testing with stubs and Rhino Mocks
date: 2007-05-23T15:25:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/05/23/unit-testing-with-stubs-and-rhino-mocks.aspx
dsq_thread_id:
  - "267952050"
categories:
  - Agile
  - Testing
redirect_from: "/blogs/jimmy_bogard/archive/2007/05/23/unit-testing-with-stubs-and-rhino-mocks.aspx/"
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/unit-testing-with-stubs-and-rhino-mocks.html)._

I&#8217;ve been using [Rhino Mocks](http://www.ayende.com/projects/rhino-mocks.aspx) for about a year now, and&nbsp;[Oren](http://www.ayende.com/Blog/) has never failed to impress me with the&nbsp;features he keeps adding on a regular basis.&nbsp; I needed to test a particular method that accepted an IProfile interface&nbsp;as an argument.&nbsp; I didn&#8217;t want to use an existing IProfile implementation I found, I was really interested in just sending the method a stub.&nbsp; If I used Rhino Mocks to create a mock, I&#8217;d have to set a bunch of expectations to get everything set up, but I really just want a stub.&nbsp; It&#8217;s a huge pain to set up a stub manually right now, as this would entail creating your own class that implemented IProfile with a basic implementation, etc.&nbsp; For more information about mocks, stubs, dummy objects and fake objects, check out [Fowler&#8217;s paper](http://www.martinfowler.com/articles/mocksArentStubs.html) on the subject.&nbsp; Here&#8217;s the test I created:

<div class="CodeFormatContainer">
  <pre>[TestMethod]<br />
<span class="kwrd">public</span> <span class="kwrd">void</span> SetPaymentType_WithValidPayment_AddsPaymentFieldToPaymentFields()<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;MockRepository repo = <span class="kwrd">new</span> MockRepository();<br />
&nbsp;&nbsp;&nbsp;&nbsp;IProfile profile = repo.Stub&lt;IProfile&gt;();<br />
&nbsp;&nbsp;&nbsp;&nbsp;IPayment payment = repo.Stub&lt;IPayment&gt;();<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">using</span> (repo.Record())<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;profile.Payments = <span class="kwrd">new</span> IPayment[] {payment};<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;payment.PaymentCode = <span class="str">"CC"</span>;<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">using</span> (repo.Playback())<br />
&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="kwrd">bool</span> result = ProfileHelper.SetPaymentType(<span class="str">"TestValue"</span>, profile);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(<span class="kwrd">true</span>, result);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(1, payment.PaymentFields.Length);<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;IField paymentField = payment.PaymentFields[0];<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(<span class="str">"PaymentType"</span>, paymentField.FieldKey);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Assert.AreEqual(<span class="str">"TestValue"</span>, paymentField.FieldValue);<br />
&nbsp;&nbsp;&nbsp;&nbsp;}<br />
}</pre>
</div>

The MockRepository object&nbsp;is from Rhino Mocks.&nbsp; I call the Stub method to generate a stub object for the interfaces I&#8217;m interested in, which are specifically the IProfile and IPayment types.&nbsp; I set the MockRepository to Record to put in the initial values for my stubs.&nbsp; Note that Rhino Mocks creates the interface types, and nowhere in my code will I create an implementation of IProfile or IPayment.&nbsp; Rhino Mocks does this for me.&nbsp; I set the MockRepository back to Playback mode and call the method I wanted to test (ProfileHelper.SetPaymentType).&nbsp; Notice that the SetPaymentType method modifies the PaymentFields property on the IProfile object, and does it correctly.&nbsp; I finish out&nbsp;the test&nbsp;making assertions about&nbsp;the&nbsp;values that should be set in the IProfile object.

What&#8217;s clear from looking at this test is that I&#8217;m only concerned about testing the interaction between the ProfileHelper.SetPaymentType method and the IProfile object, but I don&#8217;t care about the specific implementation of the IProfile object.&nbsp; If I passed in a specific implementation of an IProfile object, there may be some unwanted side effects that might cause some false positives or false negatives.&nbsp; Using stubs makes sure I limit the scope of what&#8217;s being tested only to the method I&#8217;m calling.