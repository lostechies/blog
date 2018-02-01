---
id: 4453
title: 'Testing with a Compiled Class that Doesn&#8217;t Implement an Interface &#8211; Adapter Pattern'
date: 2009-04-11T01:26:00+00:00
author: Sean Biefeld
layout: post
guid: /blogs/seanbiefeld/archive/2009/04/10/testing-compiled-classes-which-don-t-implement-an-interface.aspx
dsq_thread_id:
  - "459858757"
categories:
  - Adapter Patter
  - 'C#'
  - Compiled Class
  - Implement Interface
  - Specification
  - Unit Test
---
*UPDATE: Per&nbsp;<a href="/members/schambers/default.aspx" target="_blank">sean chambers</a>, this is an example of the&nbsp;<a href="http://en.wikipedia.org/wiki/Adapter_pattern" target="_blank">adapter pattern</a>

I recently ran into an issue where I needed to implement a simple email service to send users a randomly generated PIN when they are first entered into the system. To accomplish this I decided to just use the <a target="_blank" title="system.net.mail" href="http://msdn.microsoft.com/en-us/library/system.net.mail.aspx">System.Net.Mail</a> implementation.&nbsp; To create and send an email you have to use the <a target="_blank" title="SmtpClient" href="http://msdn.microsoft.com/en-us/library/system.net.mail.smtpclient.aspx">SmtpClient</a> class which does not implement an interface. All I really wanted to test was that the Send() method was called, I did not want to write an integration test that actually sends an email.

One way to work around this problem is to create an interface containing the elements you need to mock from the compiled class.&nbsp; After this, create your own class that inherits the compiled class and implements your interface. Now when testing, you can seemingly mock up the non-interfaced compiled class, which is exactly what I wanted to achieve. I am not sure whether this is the appropriate way to handle the issue, if anyone has any thoughts on a better way to do this, I would be grateful for the advice.

My specification ended up looking like this:

<pre style="background-color: #141414;font-family: Lucida Console;padding: 5px;border:solid 1px #333;overflow: auto;color: #BEBEC8;font-size: 10pt"><span style="color: #cda869">public class</span> <span style="color: #7386a5">EmailServiceSpecs</span> : <span style="color: #7386a5">ContextSpecification</span>
{
	<span style="color: #cda869">protected</span> <span style="color: #d0da90">IEmailService</span> _emailService;
	<span style="color: #cda869">protected</span> <span style="color: #d0da90">ISmtpClient</span> _smtpClient;
	<span style="color: #cda869">protected string</span> _emailTo <span style="color: #cda869">=</span> <span style="color: #8f9d6a">"phillip.fry@planetexpress.com"</span>;
	<span style="color: #cda869">protected string</span> _emailFrom <span style="color: #cda869">=</span> <span style="color: #8f9d6a">"hermes.conrad@planetexpress.com"</span>;
	<span style="color: #cda869">protected string</span> _emailSubject <span style="color: #cda869">=</span> <span style="color: #8f9d6a">"New Process to Improve Morale"</span>;
	<span style="color: #cda869">protected string</span> _emailBody <span style="color: #cda869">=</span> <span style="color: #8f9d6a">"From now on all employees will be required to have Brain slugs, remember, a mindless worker is a happy worker."</span>;

	<span style="color: #cda869">protected override void</span> SharedContext()
	{
		<span style="color: #7386a5">DependencyInjection</span><span style="color: #cda869">.</span><span style="color: #7386a5">RegisterType</span>&lt;<span style="color: #d0da90">IEmailService</span>, <span style="color: #7386a5">EmailService</span>&gt;();

		_emailService <span style="color: #cda869">=</span> <span style="color: #7386a5">DependencyInjection</span>
			<span style="color: #cda869">.</span>GetDependency&lt;<span style="color: #d0da90">IEmailService</span>&gt;(_emailTo, _emailFrom, _emailSubject, _emailBody);

		_smtpClient <span style="color: #cda869">=</span> <span style="color: #7386a5">MockRepository</span>.GenerateMock&lt;<span style="color: #d0da90">ISmtpClient</span>&gt;();

		<span style="color: #7386a5">DependencyInjection</span><span style="color: #cda869">.</span>RegisterInstance(_smtpClient);
	}
}

[<span style="color: #7386a5">TestFixture</span>]
[<span style="color: #7386a5">Concern</span>(<span style="color: #8f9d6a">"Email Service"</span>)]
<span style="color: #cda869">public class</span> <span style="color: #7386a5">when_sending_an_email</span> : <span style="color: #7386a5">EmailServiceSpecs</span>
{
	<span style="color: #cda869">protected override void</span> Context()
	{
		_smtpClient.Stub(smptClient <span style="color: #cda869">=&gt;</span> smptClient<span style="color: #cda869">.</span>Send(<span style="color: #cda869">new</span> <span style="color: #7386a5">MailMessage</span>()))
			<span style="color: #cda869">.</span>IgnoreArguments()
			<span style="color: #cda869">.</span>Repeat<span style="color: #cda869">.</span>Any();

		_emailService<span style="color: #cda869">.</span>Send();
	}

	[<span style="color: #7386a5">Test</span>]
	[<span style="color: #7386a5">Observation</span>]
	<span style="color: #cda869">public void</span> should_send_email()
	{
		_smtpClient<span style="color: #cda869">.</span>AssertWasCalled
			(smtpClient <span style="color: #cda869">=&gt;</span> smtpClient<span style="color: #cda869">.</span>Send(<span style="color: #cda869">new</span> MailMessage()),
			assertionOptions <span style="color: #cda869">=&gt;</span> assertionOptions<span style="color: #cda869">.</span>IgnoreArguments());
	}
}
</pre>

Below are my email classes:

<pre style="background-color: #141414;font-family: Lucida Console;padding: 5px;border:solid 1px #333;overflow: auto;color: #BEBEC8;font-size: 10pt"><span style="color: #cda869">public interface</span> <span style="color: #d0da90">ISmtpClient</span>
{
	<span style="color: #cda869">void</span> Send(<span style="color: #7386a5">MailMessage</span> message);
}

[<span style="color: #7386a5">MapDependency</span>(<span style="color: #cda869">typeof</span>(<span style="color: #d0da90">ISmtpClient</span>))]
<span style="color: #cda869">public class </span><span style="color: #7386a5">SubsideSmtpClient</span> : <span style="color: #7386a5">SmtpClient</span>, <span style="color: #d0da90">ISmtpClient</span> { }

<span style="color: #cda869">public interface</span> <span style="color: #d0da90">IEmailService</span>
{
	<span style="color: #cda869">void</span> Send();
}

[<span style="color: #7386a5">MapDependency</span>(<span style="color: #cda869">typeof</span>(<span style="color: #d0da90">IEmailService</span>))]
<span style="color: #cda869">public class</span> <span style="color: #7386a5">EmailService</span> : <span style="color: #d0da90">IEmailService</span>
{
	<span style="color: #cda869">public</span> <span style="color: #7386a5">EmailService</span>(<span style="color: #cda869">string</span> to, <span style="color: #cda869">string</span> from, <span style="color: #cda869">string</span> subject, <span style="color: #cda869">string</span> body)
	{
		Email = <span style="color: #cda869">new</span> <span style="color: #7386a5">MailMessage</span>(from, to, subject, body);
	}

	<span style="color: #cda869">protected</span> <span style="color: #7386a5">MailMessage</span> Email
	{
		<span style="color: #cda869">get</span>; <span style="color: #cda869">set</span>;
	}

	<span style="color: #cda869">private</span> <span style="color: #d0da90">ISmtpClient</span> _smptClient;

	<span style="color: #cda869">protected</span> <span style="color: #d0da90">ISmtpClient</span> Smtp
	{
		<span style="color: #cda869">get</span>
		{
			_smptClient = <span style="color: #7386a5">DependencyUtilities</span>
				<span style="color: #cda869">.</span>RetrieveDependency(_smptClient);
			<span style="color: #cda869">return</span> _smptClient;
		}
	}

	<span style="color: #cda869">public void</span> Send()
	{
		Smtp<span style="color: #cda869">.</span>Send(Email);
	}
}
</pre>