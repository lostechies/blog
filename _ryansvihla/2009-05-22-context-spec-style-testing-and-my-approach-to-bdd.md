---
wordpress_id: 8
title: Context/Spec style testing and my approach to BDD
date: 2009-05-22T00:21:00+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2009/05/21/context-spec-style-testing-and-my-approach-to-bdd.aspx
dsq_thread_id:
  - "425624133"
categories:
  - BDD
  - Context
  - Spec
---
I borrow heavily my approach to testing from a combination of Ayende&#8217;s <a href="http://rhino-tools.svn.sourceforge.net/viewvc/rhino-tools/trunk/" target="_blank">Rhino Tools</a> tests, and my reading of the <a href="http://www.pragprog.com/titles/achbd/the-rspec-book" target="_blank">Rspec</a> beta book. But I think I&#8217;ve stumbled onto something I&#8217;m happy with and I can generate reports out of. Let&#8217;s go over some basic rules first:

  1. Move as much common setup logic to a base class as possible. 
  2. Use your class name as the context 
  3. methods are rules beginning with &#8220;should&#8221; 
  4. create a new subclass of the base context every time you have a new scenario

Code ends up looking like so: 

&nbsp;

<pre>public class BaseAddVacationContext<br />    {<br />        protected AddVacationRequest _submission;<br />        protected IEmailSender _sender;<br />        protected IUserInformation _information;<br />        protected ICrudRepo&ltLeaveRequest&gt; _leaverepo;<br />        protected LeaveRequest _request;<br />        [SetUp]<br />        public virtual void SetUp()<br />        {<br />            _sender = MockRepository.GenerateMock&ltIEmailSender&gt;();<br />            _information = MockRepository.GenerateMock&ltIUserInformation&gt;();<br />            _leaverepo = MockRepository.GenerateMock&ltICrudRepo&ltLeaveRequest&gt;&gt;();<br />            _submission = new AddVacationRequest(_sender, _information, _leaverepo);<br />            _request = new LeaveRequest() { UserName = "userman" };<br />           <br />            <br />        }<br />    }<br />    [TestFixture]<br />    public class SpecAddVacationRequestWhenEmployeeSubmitsRequest : BaseAddVacationContext<br />    {<br />      <br /><br />        [SetUp]<br />        public override void SetUp()<br />        {<br />            base.SetUp();<br />            _information.Stub(x =&gt; x.GetManagersEmailAddresses("userman")).Return(new[] { "manager1@jonbank.com", "manager2@jonbank.com" });<br />            _information.Stub(x =&gt; x.GetReviewersEmailAddress("userman")).Return(new[] { "james@jonbank.com", "jones@jonbank.com" });<br />            _information.Stub(x =&gt; x.GetUserEmail("userman")).Return("userman@jonbank.com");<br />            _submission.Execute(_request);<br />            <br />        }<br />        [Test]<br />        public void should_email_all_managers()<br />        {<br />            _sender.AssertWasCalled(x =&gt; x.Send(Arg&ltMessage&gt;.Matches(y =&gt; y.To == "manager1@jonbank.com")));<br />            _sender.AssertWasCalled(x =&gt; x.Send(Arg&ltMessage&gt;.Matches(y =&gt; y.To == "manager2@jonbank.com")));<br />        }<br /><br />        [Test]<br />        public void should_send_email_to_user()<br />        {<br />            _sender.AssertWasCalled(x =&gt; x.Send(Arg&ltMessage&gt;.Matches(y =&gt; y.To == "userman@jonbank.com")));<br />        }<br /><br />        [Test]<br />        public void should_store_leave_request_in_database()<br />        {<br />            _leaverepo.AssertWasCalled(x=&gt;x.Create(Arg&lt;LeaveRequest&gt;.Matches(u=&gt;u == _request)));<br />        }<br /><br />        [Test]<br />        public void should_email_all_reviewers()<br />        {<br />            _sender.AssertWasCalled(x =&gt; x.Send(Arg&lt;Message&gt;.Matches(y =&gt; y.To == "jones@jonbank.com")));<br />            _sender.AssertWasCalled(x =&gt; x.Send(Arg&lt;Message&gt;.Matches(y =&gt; y.To == "james@jonbank.com")));<br />        }<br />    }<br />    [TestFixture]<br />    public class SpecAddVacationRequestWhenRequesWasAlreadyMadeForThoseDays : BaseAddVacationContext<br />    {<br />      <br /><br />        [SetUp]<br />        public override void SetUp()<br />        {<br />            base.SetUp();<br />            <br />            _leaverepo.Stub(x=&gt;x.Create(null)).Throw(new EmployeeAlreadyRequestedTheseDaysOff()).IgnoreArguments();<br />         }<br />         [Test]<br />         public void should_not_send_email_to_anyone(){<br />            <br />           _sender.AssertWasNotCalled(x =&gt; x.Send(Arg&lt;Message&gt;.Is.Anything));   <br />         }<br />}</pre>

So here we have: 

&nbsp;

  * A setup that you need to override and call to setup context specific behavior 
  * small small tests and asserts. 
  * limited setup on mocks, you can use handrolled mocks or the real classes if you prefer (which I do often).
  * Use AssertWasCalled instead of .Expect() on my mocks

I&#8217;ll post more examples of this as they come up.

EDIT: typo in code and changes to show more than one context