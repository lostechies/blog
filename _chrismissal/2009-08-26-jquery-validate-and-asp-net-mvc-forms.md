---
wordpress_id: 3364
title: jQuery Validation and ASP.NET MVC Forms
date: 2009-08-26T03:48:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2009/08/25/jquery-validate-and-asp-net-mvc-forms.aspx
dsq_thread_id:
  - "262175000"
categories:
  - ASP.NET MVC
  - JQuery
redirect_from: "/blogs/chrismissal/archive/2009/08/25/jquery-validate-and-asp-net-mvc-forms.aspx/"
---
&nbsp;

We have a standard that is part of our [definition of done](http://www.scrumalliance.org/articles/105-what-is-definition-of-done-dod "Definition of Done (DoD)")&nbsp;that includes adding client side validation to any page that contains a form. We always require server side validation, but I really like this standard since I&#8217;m all about [progressive enhancement](http://www.alistapart.com/articles/understandingprogressiveenhancement "Understanding Progressive Enhancement"). We have adopted [J&ouml;rn Zaefferer&#8217;s](http://bassistance.de)&nbsp;[Validation plug-in](http://docs.jquery.com/Plugins/Validation)&nbsp;(to which I have [committed](http://dev.jquery.com/ticket/3635)) as the de-facto plugin of choice. Our previous forms, while on MVC Beta, had the following HTML generated:

<pre style="font-size:125%">&lt;input type="text" name="PostalCode" id="PostalCode" /&gt;</pre>

Since we have upgraded to MVC version 1.0, our HTML is now generated like this:

<pre style="font-size:125%">&lt;input type="text" name="Address.PostalCode" id="Address.PostalCode" /&gt;</pre>

This introduced a problem, _at least temporarily_, for the validation plug-in. Whereas the property of the rules and messages was simply &#8220;PostalCode&#8221; before, it now must be &#8220;Address.PostalCode&#8221;, which causes a syntax error.

<pre style="font-size:125%">rules: {<br />&nbsp;&nbsp; &nbsp;Address.PostalCode: { required: true; digits: true; length: 5; }<br />}</pre>

The beauty of this [excellent language](/blogs/jimmy_bogard/archive/2009/08/11/javascript-a-tool-too-sharp.aspx)&nbsp;is that there is probably a way to handle this. There is a super simple solution, which took me one trial and no errors to figure out:

<pre style="font-size:125%">rules: {<br />&nbsp;&nbsp; &nbsp;'Address.PostalCode': { required: true; digits: true; length: 5; }<br />}</pre>

This was a good reminder to me that [JavaScript isn&#8217;t bad, the DOM is](http://ejohn.org/blog/the-dom-is-a-mess/)&nbsp;and that you can do pretty much anything in JavaScript.

_Also, you can find this_ [_buried in the documentation_](http://docs.jquery.com/Plugins/Validation/Reference#Fields_with_complex_names_.28brackets.2C_dots.29)_._