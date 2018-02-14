---
wordpress_id: 554
title: Stop premature email sending with NServiceBus
date: 2011-11-22T18:53:20+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/2011/11/22/stop-premature-email-sending-with-nservicebus/
dsq_thread_id:
  - "480580613"
categories:
  - NServiceBus
---
We use NServiceBus quite a lot to manage integration points where the other side isn’t transactional and we need to “shore up the process” of communicating with external services. One integration point we often don’t think about in terms of an integration point is the sending of an email.

Often times, you’ll see some sort of process that needs to notify someone that the job is complete via email. It’ll look something like:

<pre class="code"><span style="color: blue">public void </span>SomeServiceCall()
{
    DoSomeWorkHere();
    CreateSomeObjects();

    SaveToADatabase();

    <span style="color: blue">var </span>message = <span style="color: blue">new </span><span style="color: #2b91af">MailMessage</span>();
    <span style="color: blue">var </span>client = <span style="color: blue">new </span><span style="color: #2b91af">SmtpClient</span>();
    client.Send(message);
}
</pre>

This is all fine and dandy, but the problem comes when something like this is executed inside a transaction. We expect that if the SomeServiceCall method is wrapped in a transaction, that the database save should roll back. But what about that email? It often won’t fail until the transaction commits, which is AFTER the email is sent:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/11/image_thumb.png" width="575" height="321" />](http://lostechies.com/content/jimmybogard/uploads/2011/11/image.png)

In the picture above, we can see that the transaction only involves the database, but we can’t un-send our email.

What we need to do here is decouple the actual sending of an email with the message to indicate an email needs to be sent. Right now, we’re using a synchronous, non-transactional mechanism of sending an email. Instead, we just need to wrap that interaction point with an NServiceBus message:

<pre class="code"><span style="color: blue">public void </span>SomeServiceCall()
{
    DoSomeWorkHere();
    CreateSomeObjects();

    SaveToADatabase();

    _bus.Send(<span style="color: blue">new </span><span style="color: #2b91af">SendEmailMessage</span>());
}

</pre>

We’re using the NServiceBus bus to send a message that we want to send an email. The nice thing about this picture is that the sending of that NServiceBus message now participates in the transaction:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/11/image_thumb1.png" width="575" height="324" />](http://lostechies.com/content/jimmybogard/uploads/2011/11/image1.png)

In the case of failure, that message never makes it over to my NServiceBus host. If it does succeed:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="image" border="0" alt="image" src="http://lostechies.com/content/jimmybogard/uploads/2011/11/image_thumb2.png" width="575" height="335" />](http://lostechies.com/content/jimmybogard/uploads/2011/11/image2.png)

Then my message is delivered to the SMTP NServiceBus host, which will then interact with the SMTP server.

By decoupling the action of sending an email with the intention through an NServiceBus message, I can make sure that the email isn’t sent unless I successfully complete the transaction.

Another nice benefit here is that I was originally synchronously sending an email. With this architecture, if the SMTP server goes down, it doesn’t affect the ability of My Service to stay up. Instead, the durable messaging of MSMQ and NServiceBus reliability mechanisms ensures that I don’t lose the messages of sending those emails.