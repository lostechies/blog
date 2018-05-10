---
wordpress_id: 48
title: 'MonoRail Controller Test Analysis &#8211; Problem and Resolution'
date: 2007-10-25T14:08:00+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/10/25/monorail-controller-test-analysis-problem-and-resolution.aspx
categories:
  - Castle
  - MonoRail
  - Refactoring
  - TDD
redirect_from: "/blogs/joeydotnet/archive/2007/10/25/monorail-controller-test-analysis-problem-and-resolution.aspx/"
---
Last night, my fellow [LosTechies](https://lostechies.com/) geek [Jason](//www.lostechies.com/blogs/jason_meridth/default.aspx),&nbsp;wanted
  
me to check out something&nbsp;he was trying to do in a MonoRail controller
  
test.&nbsp;

For some background and the original source code he was working with, see [his Castle forum
  
post](http://forum.castleproject.org/viewtopic.php?t=3644).

So here was the partial test he was working with:

<div>
  <pre>[Test]<br /><span>public</span> <span>void</span> Should_have_error_summary_message_when_required_name_is_not_filled()<br />{<br />    contact.Name = <span>""</span>;<br />    contactController.SendContactMessage(contact);<br />    Assert.AreEqual(<span>@"Contactcontactform"</span>, contactController.SelectedViewName);<br />    ...<br />} </pre>
</div>

&nbsp;

And here is the target controller code being tested:

<div>
  <pre><span>public</span> <span>void</span> SendContactMessage([DataBind(<span>"contact"</span>, Validate = <span>true</span>)] Contact contact)<br />{<br />    <span>if</span> (HasValidationError(contact))<br />    {<br />        Flash[<span>"contact"</span>] = contact;<br />        Flash[<span>"summary"</span>] = GetErrorSummary(contact);<br />        RedirectToAction(<span>"contactform"</span>);<br />    }<br /><br />    <span>// send some email, etc...</span><br /><br />    RenderView(<span>"confirmation"</span>);<br />}</pre>
</div>

So let&#8217;s tackle 3 issues in this scenario, one by one.

#### Correcting the conditional logic

Since the error validation check is not returning out of the method,&nbsp;as it
  
stands now,&nbsp;the email will always be sent and the &#8220;confirmation&#8221; view will
  
always be rendered no matter what.&nbsp; I made the exact same kinds of mistakes when
  
I was first learning MonoRail; expecting that as soon as I call
  
RedirectToAction, it would take care of performing the redirect right then.&nbsp; But
  
of course, essentially, that&#8217;s just a method call to notify the framework of
  
what should be done **when the action execution is complete**. 

So this is an easy one to solve.&nbsp; We can either throw in a return statement
  
inside the conditional making it a guard clause, or just wrap the rest of the
  
logic inside an &#8220;else&#8221; block.

<div>
  <pre><span>public</span> <span>void</span> SendContactMessage([DataBind(<span>"contact"</span>, Validate = <span>true</span>)] Contact contact)<br />{<br />    <span>if</span> (HasValidationError(contact))<br />    {<br />        Flash[<span>"contact"</span>] = contact;<br />        Flash[<span>"summary"</span>] = GetErrorSummary(contact);<br />        RedirectToAction(<span>"contactform"</span>);<br />        <span>return</span>;<br />    }<br /><br />    <span>// send some email, etc...</span><br />    <br />    RenderView(<span>"confirmation"</span>);<br />}</pre>
</div>

OR

<div>
  <pre><span>public</span> <span>void</span> SendContactMessage([DataBind(<span>"contact"</span>, Validate = <span>true</span>)] Contact contact)<br />{<br />    <span>if</span> (HasValidationError(contact))<br />    {<br />        Flash[<span>"contact"</span>] = contact;<br />        Flash[<span>"summary"</span>] = GetErrorSummary(contact);<br />        RedirectToAction(<span>"contactform"</span>);<br />    }<br />    <span>else</span><br />    {<br />        <span>// send some email, etc...</span><br /><br />        RenderView(<span>"confirmation"</span>);<br />    }<br />}</pre>
</div>

I tend to like returning guard clauses&nbsp;shown in the first example better, but
  
either way is of course acceptable.

#### Differences between testing Redirects and Renders

The test method is currently performing an assert on the SelectedViewName of
  
the controller to make sure the &#8220;contactform&#8221; view is being displayed.&nbsp; The
  
problem here is that the controller is actually doing a
  
**Redirect**, not a **Render**.&nbsp; There is a difference
  
in how those are tested.&nbsp; 

  * How to assert that the controller **redirected** to a
  
    particular view:

> <div>
>   <pre>Assert.AreEqual(<span>"/Contact/contactform.rails"</span>, Response.RedirectedTo);</pre>
> </div>

  * How to assert that&nbsp;a particular view was only
  
    **rendered**:

> <div>
>   <pre>Assert.AreEqual(<span>@"Contactconfirmation"</span>, contactController.SelectedViewName);</pre>
> </div>

So this test method we&#8217;re working with needs to be changed to use the first
  
technique of asserting against a redirect, since that&#8217;s what&#8217;s happening in the
  
controller.&nbsp; Easy enough&#8230;

#### Simulating validation errors in the controller&nbsp;

Ok, so now for the interesting one.&nbsp; Right now, the call to
  
**HasValidationError** inside the controller is always going to
  
return false.&nbsp; Because that property relies directly upon a dictionary of error
  
summaries populated by the databinder.&nbsp; The reason this an issue in our test
  
method here, is that if you just call a controller&#8217;s action method directly from
  
a unit test, the databinder is not run, so the actual validation never takes
  
place.&nbsp; So even though the contact object that is being passed in really doesn&#8217;t
  
pass validation, the controller doesn&#8217;t know that if you relying solely on the
  
[DataBind] attribute to take care of the validation for you.&nbsp; Of course you
  
could run the validation yourself inside of the controller&#8217;s action method as an
  
alternative.&nbsp; But there is an easier way.&nbsp; Besides, you have to really ask
  
yourself, &#8220;what should&nbsp;I&nbsp;really be&nbsp;testing here?&#8221;.&nbsp; 

Jason already understood this, but for those who may not.&nbsp; Do you really care
  
about testing specific validation rules in your controller, like &#8220;is the contact
  
name empty?&#8221;?&nbsp; Well, you probably shouldn&#8217;t.&nbsp; Those should be saved for your
  
actual domain object validation tests.&nbsp; All we care about in this controller
  
test is that if the validation fails for whatever reason (we don&#8217;t care why),
  
then show the error summary and redirect back to the contact form.

Here&#8217;s one way that this can be simulated in the controller test:

<div>
  <pre>[Test]<br /><span>public</span> <span>void</span> Should_load_error_summary_when_contact_is_not_valid()<br />{<br />    SimulateOneValidationErrorFor(contactController, contact);<br />    contactController.SendContactMessage(contact);<br /><br />    Assert.AreEqual(<span>"/Contact/contactform.rails"</span>, Response.RedirectedTo);<br /><br />    Assert.IsNotNull(contactController.Flash[<span>"contact"</span>]);<br />    Assert.IsNotNull(contactController.Flash[<span>"summary"</span>]);<br />    Assert.AreEqual(1, ((ErrorSummary) contactController.Flash[<span>"summary"</span>]).ErrorsCount);<br />}</pre>
</div>

The important code is here in the helper methods:

<div>
  <pre><span>private</span> <span>void</span> SimulateOneValidationErrorFor(SmartDispatcherController controller, <span>object</span> instance)<br />{<br />    controller.ValidationSummaryPerInstance.Add(instance, CreateDummyErrorSummaryWithOneError());<br />}<br /><br /><span>private</span> ErrorSummary CreateDummyErrorSummaryWithOneError()<br />{<br />    ErrorSummary errors = <span>new</span> ErrorSummary();<br />    errors.RegisterErrorMessage(<span>"blah"</span>, <span>"blah"</span>);<br /><br />    <span>return</span> errors;<br />}</pre>
</div>

The **ValidationSummaryPerInstance** dictionary is publicly
  
exposed for us to manipulate (which is not my preferred way to expose/manipulate
  
collections, since it breaks encapsulation).&nbsp; But for now this will get us by.&nbsp;
  
We can just add our own dummied up error summary to the controller so that when
  
the **HasValidationError** method is called, it will return true,
  
since the result is based on an inspection of this dictionary of error
  
summaries.

Getting something like this included in the BaseControllerTest would also be
  
a nice thing to have.

There may be a better way to simulate this, but this is what I came up with.&nbsp;
  
**Anyone else got any better ways of doing this?**

&nbsp;