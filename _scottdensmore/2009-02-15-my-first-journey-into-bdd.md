---
id: 4605
title: My First Journey into BDD
date: 2009-02-15T16:22:00+00:00
author: Scott Densmore
layout: post
guid: /blogs/scottdensmore/archive/2009/02/15/my-first-journey-into-bdd.aspx
dsq_thread_id:
  - "273024915"
categories:
  - Uncategorized
---
<p style="clear: both">
  Lately I have been trying to teach people TDD and running into the usual suspects of misconceptions. I decided that maybe it was about time to update my tool belt and try teaching in a new way. I also wanted to try out something new and hopefully improve myself. I decided to give <a href="http://behaviour-driven.org/">BDD (Behavior Driven Development)</a> a try.
</p>

<p style="clear: both">
  I have been practicing TDD for many years now and I just recently started reading about BDD. When I read <a href="http://dannorth.net/introducing-bdd">Dan North&#8217;s intro about BDD,</a> I had a funny feeling I had heard this story before. Back in 2004 while working at Microsoft, I was pairing with <a href="http://www.agileprogrammer.com/oneagilecoder/">Brian Button</a> when he said something that stuck with me, yet I have not thought about in years: &#8220;Instead of Test Fixture per class, why not test per feature.&#8221;. (I know that is probably not word for word.) All this started to rush back at me so I decided to do a bit more reading. There are quite a few frameworks for working in BDD, yet I thought I would start simple and use what we do at work. (Always find it easier to start with what people know when learning something new).
</p>

<p style="clear: both">
  I think the hardest thing for me to change in my thinking was the naming of my test class. (This is where the flashback to <a href="http://www.agileprogrammer.com/oneagilecoder/">Brian</a> happened again so I just dove in and gave it a try). I would normally just give my tests the name $ClassUnderTest$Tests. That really doesn&#8217;t communicate my intent. It really just is a logical grouping. If I use the file as a grouping now, it makes it easier for me to switch. I now call my file $SystemUnderTest$Specs (where System Under Test could be a class). What helped me out tremendously is thinking of my feature / design as a user story. I gained much of this through reading <a href="http://www.code-magazine.com/article.aspx?quickid=0805061&page=1">Scott Bellware&#8217;s article</a> that focused around this area.
</p>

<p style="clear: both">
  Lets take a look at the before and after to see the difference:
</p>

<pre>[TestClass]
public class GuestServiceTests
{
	[TestMethod]
	public void ShouldUpdateGuestAccountWhenRequestingARefund()
	{
		// Arrange 
		Mock&lt;IAccountService&gt; accountService = new Mock&lt;IAccountService&gt;();
		GuestService guestService = new GuestService(accountService.Object);
		int guestId = 7;
		decimal amount = 100M;
		
		// Act
		guestService.RequstRefund(guestId, amount);
		
		// Assert
		accountService.Verify(x=&gt;x.PostReund(7, 100M));
	}
}

[TestClass]
public class when_guest_requests_a_refund
{
	GuestService guestService;
	
	// Arrange
	[TestInitialize]
	public void Context()
	{
		Mock&lt;IAccountService&gt; accountService = new Mock&lt;IAccountService&gt;();
		guestService = new GuestService(accountService.Object);
	}
	
	public void should_update_guest_account_with_amount()
	{
		// Arrange 
		int guestId = 7;
		decimal amount = 100;
		// Act
		guestService.RequestRefund(guestId, amount);
		// Assert
		accountService.Verify(x=&gt;x.PostReund(guestId, amount));
	}
}
</pre>

<p style="clear: both">
  In this example, I am using the <a href="http://xunitpatterns.com/Testcase%20Class%20per%20Fixture.html">Test Fixture Per Class</a> pattern as the classic approach. [I must admit that way back in my learnings of TDD I learned that very descriptive names are important.] The three main portions of your test are still the same: Arrange / Act / Assert, just laid out differently (I labeled them here for the example). The difference is really about how you arrange the tests themselves. This is not the only difference, you also have to think about how this code communicates to the person looking at it. I find this the one thing I really like about this approach. You focus on the concern that you are testing (refunding a guest account). The underscores are a style thing. If you don&#8217;t like them, don&#8217;t use them. Some frameworks use this to build reports and I have found that it is easier to read with the underscores.
</p>

<p style="clear: both">
  The one thing I don&#8217;t like about the way the test looks right now is a little bit of readability. I also feel the act and arrange should not be together: things just don&#8217;t seem to flow. If you think about it: you also have to replicate arrange portions in each test (like guest identifier and amount) because we don&#8217;t have a place to set this up. It also is missing some key pieces that Scott explains in his article. Here we change a couple of things around and I think come up with something easier to read (and explain):
</p>

<pre>public class ContextSpecification
{
	[TestInitialize]
	public void Initialize()
	{
		Context();
		Because();
	}
	
	protected virtual void Context() {}
	protected virtual void Because() {}
}
[TestClass]
public class when_guest_requests_a_refund : ContextSpecifcation
{
	GuestService guestService;
	int guestId;
	decimal amount;
	
	// Arrange
	protected override void Context()
	{
		Mock&lt;IAccountService&gt; accountService = new Mock&lt;IAccountService&gt;();
		guestService = new GuestService(accountService.Object);
	}
	
	// Act (Arrange for concern)
	protected override void Because()
	{
		guestId = 7;
		amount = 100M;
		guestService.Request(Refund);
	}
	
	// Assert
	[TestMethod]
	public void should_update_guest_account_with_amount()
	{
		accountService.Verify(x=&gt;x.PostReund(guestId, amount));
	}
}
</pre>

<p style="clear: both">
  All this for me is just the first part of my journey. Lately I have been moving to writing more of my tests in this style and I am finding I really like it. I don&#8217;t recommend you go and change all your unit tests to this style: it is not worth it. Just try it out. Get a feel for it. Don&#8217;t get caught up in different styles at first. Learn them, internalize them and do what works for you.
</p>

<p style="clear: both">
  <strong>BDD Frameworks</strong>
</p>

<ul style="clear: both">
  <li>
    <a href="http://codebetter.com/blogs/aaron.jensen/archive/2008/05/08/introducing-machine-specifications-or-mspec-for-short.aspx">MSpec</a>
  </li>
  <li>
    <a href="http://code.google.com/p/specunit-net/">SpecUnit</a>
  </li>
  <li>
    <a href="http://nspec.tigris.org/source/browse/nspec/">NSpec</a>
  </li>
  <li>
    <a href="http://www.bjoernrochel.de/2008/10/04/introducing-xunitbddextensions/">xUnit.BDDExtensions</a>
  </li>
</ul>

<p style="clear: both">
  &nbsp;
</p>

<br class="final-break" />