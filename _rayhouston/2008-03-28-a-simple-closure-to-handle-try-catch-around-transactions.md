---
wordpress_id: 15
title: A Simple Closure To Handle Try/Catch Around Transactions
date: 2008-03-28T00:35:11+00:00
author: Ray Houston
layout: post
wordpress_guid: /blogs/rhouston/archive/2008/03/27/a-simple-closure-to-handle-try-catch-around-transactions.aspx
categories:
  - Uncategorized
---
_(Updated: I moved the begin transaction outside of the try as [Chad](http://www.lostechies.com/blogs/chad_myers/default.aspx) suggested in the comments.)_

If you&#8217;re like me, you&#8217;re lazy and hate putting try/catch around your transaction handling in your code. It has to be there, but it&#8217;s just a pain. You may have code that looks something like:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">domainContext.BeginTransaction();

<span style="color: #0000ff">try</span>
{
    historicalPwdService.RecordHistoricalPassword(user.UserProfileID, currentPassword);

    user.Password = newPassword;
    user.PasswordCreateDate = systemClock.Now();

    userProfileRepo.Save(user);

    domainContext.CommitTransaction();
}
<span style="color: #0000ff">catch</span>
{
    domainContext.RollbackTransaction();
    <span style="color: #0000ff">throw</span>;
}
</pre>
</div>

Well here&#8217;s a little helper class that can ease the pain a bit:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">class</span> WorkUnit
{
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> <span style="color: #0000ff">void</span> Do(IDomainContext context, Action workUnit)
    {
        context.BeginTransaction();

        <span style="color: #0000ff">try</span>
        {
            workUnit();
                
            context.CommitTransaction();
        }
        <span style="color: #0000ff">catch</span>
        {
            context.RollbackTransaction();

            <span style="color: #0000ff">throw</span>;
        }
    }
}
</pre>
</div>

now you can use it with an anonymous method:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">WorkUnit.Do(domainContext, ()=&gt;
    {
        historicalPwdService.RecordHistoricalPassword(user.UserProfileID, currentPassword);

        user.Password = newPassword;
        user.PasswordCreateDate = systemClock.Now();

        userProfileRepo.Save(user);
    });
</pre>
</div>

_Side note for [Jimmy](http://www.lostechies.com/blogs/jimmy_bogard/archive/2008/03/26/stop-creating-custom-delegate-types.aspx): You should be proud. I went back and switched out my custom delegate for Action. 😉_

<div class="wlWriterSmartContent" style="padding-right: 0px;padding-left: 0px;padding-bottom: 0px;margin: 0px;padding-top: 0px">
  Technorati Tags: <a href="http://technorati.com/tags/.NET" rel="tag">.NET</a>,<a href="http://technorati.com/tags/Delegates" rel="tag">Delegates</a>
</div>