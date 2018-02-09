---
wordpress_id: 33
title: More BDD xBehave Madness!
date: 2007-07-16T02:17:35+00:00
author: Joe Ocampo
layout: post
wordpress_guid: /blogs/joe_ocampo/archive/2007/07/15/more-bdd-xbehave-madness.aspx
dsq_thread_id:
  - "262090394"
categories:
  - BDD (Behavior Driven Development)
  - Domain Driven Design (DDD)
redirect_from: "/blogs/joe_ocampo/archive/2007/07/15/more-bdd-xbehave-madness.aspx/"
---
Well over the past week or so I have been working off and on with improving the usage of NUnit.Behave.&nbsp; It started off being tightly coupled with NUnit since you actually had to inherit an abstract fixture that exposed the &#8220;Given, When, Then&#8221; <a href="http://dannorth.net/introducing-bdd" target="_blank">BDD</a> constructs.&nbsp; With a bit of tinkering with C# generics and some <a href="http://www.martinfowler.com/bliki/FluentInterface.html" target="_blank">fluent interface</a> magic, I managed to decouple the code into its own, dare I say,&nbsp; framework.

Before I continue I need you to understand the goal of what I am creating.&nbsp; Based on <a href="http://dannorth.net/" target="_blank">Dan North&#8217;s</a> initial vision of <a href="http://dannorth.net/2007/06/introducing-rbehave" target="_blank">rbehave</a>, I modeled the syntax of the xBehave (insert catchy agile term here) framework around rbehave.&nbsp; The primary goal of rbehave is a framework for defining and executing application requirements.&nbsp; These definitions are modeled after BDD terms such as Story, Scenario, Given When Then.&nbsp;**Using a minimum of syntax** (a few “quotes” mostly), this becomes an executable and self-describing requirements document.&nbsp; By utilizing the definitions within the actual unit test code of the application, the ubiquitous nature of the architecture and domain become&nbsp;one cohesive amalgam.&nbsp; With the help of <a href="http://domaindrivendesign.org/" target="_blank">Domain Driven Design</a> all these concepts seemingly bring together our software.&nbsp; The code actually becomes what we have always wanted, living requirements that are constantly asserted on to insure their viability and accuracy from the inception of the software architecture.&nbsp; Can you say true tracebility!

Now lets consider something for a moment.&nbsp; Who are the owners of our requirements(stories)?&nbsp;If you said the product owner, then you guessed correctly.&nbsp; So we have a product owner who wants to tell&nbsp;us how they think our software should behave.&nbsp; So lets take this a little further.&nbsp; 

In my shop, we practice agile development. Our release cycles&nbsp;are comprised of a storming phase, planning phase, development phase, SIT/UAT phase and finally production deployment.&nbsp; Each release cycle is typically 6 weeks long.&nbsp; During the storming and planning phase, we conduct modeling sessions comprised of a product owner, modeler, developer and systems analyst (QA).&nbsp;Utilizing a Domain Driven approach we model each story to understand the business need and value.&nbsp; The problem is that various artifacts have to be maintained during these sessions.&nbsp; Namely wire frames, domain models, and test plans.&nbsp; Not to mention the actual story cards.&nbsp; I am not going to lie to you and tell you that everything runs like a well oiled machine. After all we do have people in the equation here.&nbsp; Their in lies the problem, people think in different ways.&nbsp; Trying to enforce certain story context structures As, I want, So that, seems to be hit and miss.&nbsp; These concepts are hard to enforce when the business is your customer.&nbsp; So my goal was to try and see if a product owner could actually code the requirements in Visual Studio and hope that my type constraints would be enforced at design time.

I approached one of our product owners and asked her if she would be willing to try an experiment with me.&nbsp; She was very reluctant at first but when I explained that I may have an idea that can save her time&nbsp;from a story authoring standpoint and introduce quality from inception she quickly became interested.&nbsp; Like most product owners she had never utilized an IDE.&nbsp; I opened up Visual Studio and created a basic NUnit test fixture.&nbsp; I opened up Dan North&#8217;s blog on another monitor and showed her the basic story for transfer account.

> Story: transfer to cash account  
> &nbsp; As a savings account holder  
> &nbsp; I want to transfer money from my savings account  
> &nbsp; So that I can get cash easily from an ATM

I told her we are going to create a new story based on this model but I want you to type it in code.&nbsp; She quickly told me that she had never typed any code in her life and she doesn&#8217;t know how productive she could be.&nbsp; So I walked her though the instantiation of the story as I knew this would probably be the hardest concept to grasp. 

> <font face="Courier New">Story story = new Story(&#8220;Transfer to cash account&#8221;);</font>

I explained to her that the title of the story is the first piece of information that is needed.&nbsp; I showed her the intellisence that visual studio would lend to help her along. 

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="190" alt="image" src="http://lostechies.com/joeocampo/files/2011/03MoreBDDxBehaveMadness_14ABE/image_thumb.png" width="848" border="0" />](http://lostechies.com/joeocampo/files/2011/03MoreBDDxBehaveMadness_14ABE/image.png) 

After that we went ahead and created the remainder of the story using a <a href="http://www.martinfowler.com/bliki/FluentInterface.html" target="_blank">fluent interface</a>.&nbsp; I made certain not the expose all the fluent behaviors off the story class.&nbsp; I did this because I wanted to walk the user through the template.&nbsp; If I exposed all the behaviors at once they could mess up the fluidity of the interface. Such as: 

> <font face="Courier New">story.I_want(&#8220;to transfer money from my savings account&#8221;)<br />&nbsp;&nbsp;&nbsp;&nbsp; .As_a(&#8220;savings account holder&#8221;)<br />&nbsp;&nbsp;&nbsp; .So_that(&#8220;I can get cash easily from an ATM&#8221;);</font>

This doesn&#8217;t help the user, so after they press &#8220;.&#8221; on the story class the only methods that are exposed are: 

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="84" alt="image" src="http://lostechies.com/joeocampo/files/2011/03MoreBDDxBehaveMadness_14ABE/image_thumb_1.png" width="690" border="0" />](http://lostechies.com/joeocampo/files/2011/03MoreBDDxBehaveMadness_14ABE/image_1.png) 

I did this by chaining together conjunction types that expose only the required methods at one given point in time.&nbsp; Works out quiet well since the editor enforces the type hierarchy at design time.&nbsp; Notice how similar it is to rbehave (lots of quotes). 

In the end we ended up with the following syntax. 

<font face="Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [Test]<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public void Transfer_to_cash_account()<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Story transfer_to_cash_account = new Story(&#8220;Transfer to cash account&#8221;); </font> 

<font face="Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; transfer_to_cash_account.As_a(&#8220;savings account holder&#8221;)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .I_want(&#8220;to transfer money from my savings account&#8221;)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .So_that(&#8220;I can get cash easily from an ATM&#8221;); </font> 

<font face="Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Scenario savings_account_is_in_credit = new Scenario(&#8220;savings account is in credit&#8221;); </font> 

<font face="Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; savings_account_is_in_credit<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .Given(&#8220;my savings account balance is&#8221;, 100)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .And(&#8220;my cash account balance is&#8221;, 10)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .When(&#8220;I transfer to cash account&#8221;, 20)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .Then(&#8220;my savings account balance should be&#8221;, 80)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .And(&#8220;my cash account balance should be&#8221;, 30); </font> 

<font face="Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; savings_account_is_in_credit<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .Given(&#8220;my savings account balance is&#8221;, 400)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .And(&#8220;my cash account balance is&#8221;, 100)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .When(&#8220;I transfer to cash account&#8221;, 100)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .Then(&#8220;my savings account balance should be&#8221;, 300)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .And(&#8220;my cash account balance should be&#8221;, 200);<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</font> 

When you run the test runner you receive the following output. 

> <font face="Courier New">Story: Transfer to cash account<br />&nbsp;&nbsp;&nbsp; As a savings account holder<br />&nbsp;&nbsp;&nbsp; I want to transfer money from my savings account<br />&nbsp;&nbsp;&nbsp; So that I can get cash easily from an ATM </font> 
> 
> <font face="Courier New">Scenario: savings account is in credit<br />&nbsp;&nbsp;&nbsp; Given my savings account balance is 100 <pending action><br />&nbsp;&nbsp;&nbsp; And my cash account balance is 10 <pending action><br />&nbsp;&nbsp;&nbsp; When I transfer to cash account 20 <pending action><br />&nbsp;&nbsp;&nbsp; Then my savings account balance should be 80 <pending action><br />&nbsp;&nbsp;&nbsp; And my cash account balance should be 30 <pending action> </font> 
> 
> <font face="Courier New">Scenario: savings account is in credit<br />&nbsp;&nbsp;&nbsp; Given my savings account balance is 400 <pending action><br />&nbsp;&nbsp;&nbsp; And my cash account balance is 100 <pending action><br />&nbsp;&nbsp;&nbsp; When I transfer to cash account 100 <pending action><br />&nbsp;&nbsp;&nbsp; Then my savings account balance should be 300 <pending action><br />&nbsp;&nbsp;&nbsp; And my cash account balance should be 200 <pending action></font>

The <pending actions> indicate that the development team still has to&nbsp;wire up the&nbsp;implementation code. 

I asked her if she thought if she could do this with ALL the stories her team creates.&nbsp; I proposed that during the storming phase her team(business analyst)&nbsp;just create the stories.&nbsp; During the planning phase we can come up with the scenarios and edit them together.&nbsp; From there the developers can take these behavioral scenarios and implement the code to insure that we created the functionality according to business teams specifications.&nbsp; We both agreed that it was possible but that it would take time to get everyone on board. 

I asked her 3 closing questions. 

  1. Was the story easy to author? Yes &#8220;After I got use to the little boxes popping up and remembering to use quotes.&#8221;
  2. Were the scenarios east to author? Yes, &#8220;but the action value took me a while to get use too.&#8221;
  3. Is the output valuable?&nbsp;Not really, it helps but I don&#8217;t see how we would use it.

I followed up question 3 with &#8221; I am working on a way to output all the output to an HTML page similar to CruiseControl and you can visually see after every build what stories have been completed and what stories haven&#8217;t.&nbsp; She seemed OK with the response but reserved on actually seeing the final product.

&nbsp;

So as a developers we would simple use the Action<T> delegates to pass in statement blocks of the actual code implementation.&nbsp; Which would look like the following code.

<font face="Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [Test]<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public void Transfer_to_cash_account()<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Story transfer_to_cash_account = new Story(&#8220;Transfer to cash account&#8221;); </font> 

<font face="Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; transfer_to_cash_account.As_a(&#8220;savings account holder&#8221;)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .I_want(&#8220;to transfer money from my savings account&#8221;)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .So_that(&#8220;I can get cash easily from an ATM&#8221;); </font> 

<font face="Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Account savings = null;<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Account cash = null; </font> 

<font face="Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Scenario savings_account_is_in_credit = new Scenario(&#8220;savings account is in credit&#8221;);<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; savings_account_is_in_credit<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .Given(&#8220;my savings account balance is&#8221;, 100,<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; delegate(int accountBallance)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; savings = new Account(accountBallance);<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; })<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .And(&#8220;my cash account balance is&#8221;, 10,<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; delegate(int accountBallance)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cash = new Account(accountBallance);<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; })<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .When(&#8220;I transfer to cash account&#8221;, 20,<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; delegate(int transferAmount)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; savings.TransferTo(cash, transferAmount);<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; })<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .Then(&#8220;my savings account balance should be&#8221;, 80,<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; delegate(int expectedBallance)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Assert.AreEqual(expectedBallance, savings.Ballance);<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; })<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .And(&#8220;my cash account balance should be&#8221;, 30,<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; delegate(int expectedBallance)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Assert.AreEqual(expectedBallance, cash.Ballance);<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }); </font> 

<font face="Courier New">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; savings_account_is_in_credit<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .Given(&#8220;my savings account balance is&#8221;, 400)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .And(&#8220;my cash account balance is&#8221;, 100)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .When(&#8220;I transfer to cash account&#8221;, 100)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .Then(&#8220;my savings account balance should be&#8221;, 300)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .And(&#8220;my cash account balance should be&#8221;, 200);<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</font> 

When you run this test with the delegates wired up you receive the following output: 

> <font face="Courier New">Story: Transfer to cash account<br />&nbsp;&nbsp;&nbsp; As a savings account holder<br />&nbsp;&nbsp;&nbsp; I want to transfer money from my savings account<br />&nbsp;&nbsp;&nbsp; So that I can get cash easily from an ATM </font> 
> 
> <font face="Courier New">Scenario: savings account is in credit<br />&nbsp;&nbsp;&nbsp; Given my savings account balance is 100<br />&nbsp;&nbsp;&nbsp; And my cash account balance is 10<br />&nbsp;&nbsp;&nbsp; When I transfer to cash account 20<br />&nbsp;&nbsp;&nbsp; Then my savings account balance should be 80<br />&nbsp;&nbsp;&nbsp; And my cash account balance should be 30 </font> 
> 
> <font face="Courier New">Scenario: savings account is in credit<br />&nbsp;&nbsp;&nbsp; Given my savings account balance is 400<br />&nbsp;&nbsp;&nbsp; And my cash account balance is 100<br />&nbsp;&nbsp;&nbsp; When I transfer to cash account 100<br />&nbsp;&nbsp;&nbsp; Then my savings account balance should be 300<br />&nbsp;&nbsp;&nbsp; And my cash account balance should be 200</font>

&nbsp;

As you can tell the <Pending Action> flags are gone indicating that the code has been implemented.&nbsp; The fact that we didn&#8217;t receive any assertion errors means that the code passes the behavioral expectations.

## The magic of generics and anonymous generic delegates

I learned a great deal about generics implementing this framework, so I thought I would pass some tidbits of information on to the rest of you.

lets look at the following method:

> <font face="Courier New">public GivenContext Given<T>(string theGivenSentence, T actionValue)</font>

Since <T> is declared at the method level the C# compiler will infer the type being passed to the method.&nbsp; This inference model is what allows the&nbsp;xBehave framework to persist it&#8217;s syntactic goal of being as similar to rbehave as possible.&nbsp; With out it&nbsp;a Given statement would look like this.

> <font face="Courier New">.Given<int>(&#8220;my savings account balance is&#8221;, 100)</font>

Imagine training a business analyst to make sure they use the correct types in the angle brackets.&nbsp; Ummmm No.

But the magic doesn&#8217;t stop there.&nbsp;&nbsp; You can use the generic type within an anonymous delegate.&nbsp; Consider the following Given method:

> <font face="Courier New">public GivenContext Given<T>(string theGivenSentence, T actionValue, Action<T> delegateAction)</font>

You will notice the Action<T> delegate type.&nbsp; This is wonderful as it allows the inferred &#8220;T&#8221; type to be passed to the delegate as well.&nbsp; You cannot break the signature, even if you try the editor (with ReSharper that is) will flag an error a follows:

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="115" alt="image" src="http://lostechies.com/joeocampo/files/2011/03MoreBDDxBehaveMadness_14ABE/image_thumb_2.png" width="575" border="0" />](http://lostechies.com/joeocampo/files/2011/03MoreBDDxBehaveMadness_14ABE/image_2.png) 

Notice that the actionValue being passed in is an integer and in the delegate the developer accidentally thought it should be a string.&nbsp; This type checking at design time Forces the developer to implement the correct parameter types within their code.

&nbsp;

I emailed Dan to make certain I was on the correct path with his intentions of rbehave as I created this framework.&nbsp; My hope is that it will gain momentum and help to synergies development around the story aspect of agile development.&nbsp; Bringing the product owners ever closer to the&nbsp;foundation of code can only be a good thing.

&nbsp;

As always the latest code can be downloaded from <a href="http://code.google.com/p/nunitbehave/source" target="_blank">here</a>.