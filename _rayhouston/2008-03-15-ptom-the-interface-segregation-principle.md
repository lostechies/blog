---
id: 12
title: 'PTOM: The Interface Segregation Principle'
date: 2008-03-15T03:04:48+00:00
author: Ray Houston
layout: post
guid: /blogs/rhouston/archive/2008/03/14/ptom-the-interface-segregation-principle.aspx
categories:
  - PTOM
---
In following suite with the [The Los Techies Pablo&#8217;s Topic of the Month &#8211; March: SOLID Principles](http://lostechies.com/blogs/chad_myers/archive/2008/03/07/pablo-s-topic-of-the-month-march-solid-principles.aspx), I chose to write a little about the [The Interface Segregation Principle (ISP)](http://www.objectmentor.com/resources/articles/isp.pdf). As [Chad](http://lostechies.com/blogs/chad_myers/default.aspx) pointed out with [LSP](http://www.lostechies.com/blogs/chad_myers/archive/2008/03/09/ptom-the-liskov-substitution-principle.aspx), the ISP is also one of Robert &#8216;Uncle Bob&#8217; Martin&#8217;s S.O.L.I.D design principles.

Basically ISP tells us that clients shouldn&#8217;t be forced to implement interfaces they don&#8217;t use. In other words, if you have an abstract class or an interface, then the implementers should not be forced to implement parts that they don&#8217;t care about.

I was having trouble thinking of a real world example for ISP but then was reminded about implementing a custom Membership Provider in ASP.NET 2.0. I had completely blocked that monstrosity out of my mind (for good reason).

The Membership Provider was a way to integrate with some of the ASP.NET&#8217;s built in management of users and its associated server controls. For me, it ended up being a lot more trouble than it was worth, but it turns out to be a good example of a fat interface. In order to implement your own Membership Provider you &#8220;simply&#8221; implement the abstract class MembershipProvider like so:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> CustomMembershipProvider : MembershipProvider
{
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">string</span> ApplicationName
    {
        get
        {
            <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>);
        }
        set
        {
            <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>);
        }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">bool</span> ChangePassword(<span style="color: #0000ff">string</span> username, <span style="color: #0000ff">string</span> oldPassword, <span style="color: #0000ff">string</span> newPassword)
    {
        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">bool</span> ChangePasswordQuestionAndAnswer(<span style="color: #0000ff">string</span> username, <span style="color: #0000ff">string</span> password, 
        <span style="color: #0000ff">string</span> newPasswordQuestion, <span style="color: #0000ff">string</span> newPasswordAnswer)
    {
        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> MembershipUser CreateUser(<span style="color: #0000ff">string</span> username, <span style="color: #0000ff">string</span> password, <span style="color: #0000ff">string</span> email, 
        <span style="color: #0000ff">string</span> passwordQuestion, <span style="color: #0000ff">string</span> passwordAnswer, <span style="color: #0000ff">bool</span> isApproved, <span style="color: #0000ff">object</span> providerUserKey, 
        <span style="color: #0000ff">out</span> MembershipCreateStatus status)
    {
        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">bool</span> DeleteUser(<span style="color: #0000ff">string</span> username, <span style="color: #0000ff">bool</span> deleteAllRelatedData)
    {
        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">bool</span> EnablePasswordReset
    {
        get { <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>); }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">bool</span> EnablePasswordRetrieval
    {
        get { <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>); }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> MembershipUserCollection FindUsersByEmail(<span style="color: #0000ff">string</span> emailToMatch, <span style="color: #0000ff">int</span> pageIndex, 
        <span style="color: #0000ff">int</span> pageSize, <span style="color: #0000ff">out</span> <span style="color: #0000ff">int</span> totalRecords)
    {
        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> MembershipUserCollection FindUsersByName(<span style="color: #0000ff">string</span> usernameToMatch, <span style="color: #0000ff">int</span> pageIndex, 
        <span style="color: #0000ff">int</span> pageSize, <span style="color: #0000ff">out</span> <span style="color: #0000ff">int</span> totalRecords)
    {
        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> MembershipUserCollection GetAllUsers(<span style="color: #0000ff">int</span> pageIndex, <span style="color: #0000ff">int</span> pageSize, <span style="color: #0000ff">out</span> <span style="color: #0000ff">int</span> totalRecords)
    {
        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">int</span> GetNumberOfUsersOnline()
    {
        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">string</span> GetPassword(<span style="color: #0000ff">string</span> username, <span style="color: #0000ff">string</span> answer)
    {
        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> MembershipUser GetUser(<span style="color: #0000ff">string</span> username, <span style="color: #0000ff">bool</span> userIsOnline)
    {
        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> MembershipUser GetUser(<span style="color: #0000ff">object</span> providerUserKey, <span style="color: #0000ff">bool</span> userIsOnline)
    {
        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">string</span> GetUserNameByEmail(<span style="color: #0000ff">string</span> email)
    {
        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">int</span> MaxInvalidPasswordAttempts
    {
        get { <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>); }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">int</span> MinRequiredNonAlphanumericCharacters
    {
        get { <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>); }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">int</span> MinRequiredPasswordLength
    {
        get { <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>); }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">int</span> PasswordAttemptWindow
    {
        get { <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>); }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> MembershipPasswordFormat PasswordFormat
    {
        get { <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>); }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">string</span> PasswordStrengthRegularExpression
    {
        get { <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>); }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">bool</span> RequiresQuestionAndAnswer
    {
        get { <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>); }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">bool</span> RequiresUniqueEmail
    {
        get { <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>); }
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">string</span> ResetPassword(<span style="color: #0000ff">string</span> username, <span style="color: #0000ff">string</span> answer)
    {
        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">bool</span> UnlockUser(<span style="color: #0000ff">string</span> userName)
    {
        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> UpdateUser(MembershipUser user)
    {
        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>);
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">bool</span> ValidateUser(<span style="color: #0000ff">string</span> username, <span style="color: #0000ff">string</span> password)
    {
        <span style="color: #0000ff">throw</span> <span style="color: #0000ff">new</span> Exception(<span style="color: #006080">"The method or operation is not implemented."</span>);
    }
}
</pre>
</div>

Holy guacamole! That&#8217;s a lot of stuff. Sorry for the code puke there, but wanted you to feel a little pain as I did trying to actually implement this thing. Hopefully you didn&#8217;t get tired of scrolling through that and you&#8217;re still with me. 😉

It turns out that you don&#8217;t have to implement the parts you don&#8217;t need, but this clearly violates the Interface Segregation Principle. This interface is extremely fat and not cohesive. A better approach would have been to break it up into smaller interfaces that allow the implementers to only worry about the parts that they need. I&#8217;m not going to go into the details of splitting this up, but I think you get the idea.

Since I cannot think of another real world example, let&#8217;s look at a completely bogus example. Say you have the following code:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">abstract</span> <span style="color: #0000ff">class</span> Animal
{
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">abstract</span> <span style="color: #0000ff">void</span> Feed();
}

<span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Dog : Animal
{
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Feed()
    {
        <span style="color: #008000">// do something</span>
    }
}

<span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Rattlesnake : Animal
{
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Feed()
    {
        <span style="color: #008000">// do something</span>
    }
}
</pre>
</div>

But then you realize that you have a need for some of the animals to be treated as pets and have them groomed. You may be tempted to do

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">abstract</span> <span style="color: #0000ff">class</span> Animal
{
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">abstract</span> <span style="color: #0000ff">void</span> Feed();
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">abstract</span> <span style="color: #0000ff">void</span> Groom();
}
</pre>
</div>

which would be fine for the Dog, but it may not be fine for the Rattlesnake (although I&#8217;m sure there is some freako out there that grooms their pet rattlesnake)

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Rattlesnake : Animal
{
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Feed()
    {
        <span style="color: #008000">// do something</span>
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Groom()
    {
        <span style="color: #008000">// ignore - I'm not grooming a freaking rattlesnake</span>
    }
}
</pre>
</div>

Here we have violated the ISP by polluting our Animal interface. This requires us to implement a method that doesn&#8217;t make sense for the Rattlesnake object. A better choice would to implement an IPet interface which just Dog could implement and without affecting Rattlesnake. You might end up with something like this:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">interface</span> IPet
{
    <span style="color: #0000ff">void</span> Groom();
}

<span style="color: #0000ff">public</span> <span style="color: #0000ff">abstract</span> <span style="color: #0000ff">class</span> Animal
{
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">abstract</span> <span style="color: #0000ff">void</span> Feed();
}

<span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Dog : Animal, IPet
{
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Feed()
    {
        <span style="color: #008000">// do something</span>
    }

    <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Groom()
    {
        <span style="color: #008000">// do something</span>
    }
}

<span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> Rattlesnake : Animal
{
    <span style="color: #0000ff">public</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Feed()
    {
        <span style="color: #008000">// do something</span>
    }
}
</pre>
</div>

I think the key is if you find yourself creating interfaces that don&#8217;t get fully implemented in its clients, then that&#8217;s a good sign that you&#8217;re violating the ISP. You can check out the link to this [pdf](http://www.objectmentor.com/resources/articles/isp.pdf) for more complete information on the subject.

<div class="wlWriterSmartContent" style="padding-right: 0px;padding-left: 0px;padding-bottom: 0px;margin: 0px;padding-top: 0px">
  Technorati Tags: <a href="http://technorati.com/tags/.NET" rel="tag">.NET</a>,<a href="http://technorati.com/tags/Principles" rel="tag">Principles</a>,<a href="http://technorati.com/tags/PTOM" rel="tag">PTOM</a>
</div>