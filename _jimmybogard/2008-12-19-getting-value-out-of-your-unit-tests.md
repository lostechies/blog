---
id: 265
title: Getting value out of your unit tests
date: 2008-12-19T03:26:02+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/12/18/getting-value-out-of-your-unit-tests.aspx
dsq_thread_id:
  - "264716006"
categories:
  - TDD
---
Unit tests, with TDD in particular, are the most efficient way I’ve found in creating behavior for my application.&#160; For lasting value, beyond just the safety net of “if I change something, will something break”, requires extra discipline, and a more refined manner in which we go about doing TDD.&#160; One of the most frustrating aspects of TDD done wrong is dozens of unit tests that provide no other value than they might fail.

Back when [Scott](http://blog.scottbellware.com/) and others were refining TDD into Context/Specification BDD-style, I remember him posing the question, “if we actually treat tests as documentation, what is the result?”.&#160; For a lot of unit tests, that documentation is a muddled, miserable mess.&#160; Nothing can be more frustrating than a failing unit test that provides **zero** insight into _why_ the test exists in the first place.

My first year or so of doing TDD produced exactly that, a mess.&#160; No insight into the what or why of my system’s behavior, but merely a retrospective look on what each individual class did.&#160; But by adding a few rules, as well as personal guidelines, I’ve noticed my tests have started to provide what I really wanted – a description of the behavior of the system.&#160; These rules injected that value in my tests that would have otherwise made the tests just dead weight, code I avoided after I wrote them.

### Rule #1 – Test names should describe the what and the why, from the user’s perspective

One way to do this easily is the Context/Observation(specification) naming style.&#160; I’m not the greatest at explaining exactly the BDD style, I’d rather defer to [JP Boodhoo](http://www.jpboodhoo.com/Home.oo), [Scott Bellware’s article](http://www.code-magazine.com/Article.aspx?quickid=0805061), [Aaron Jensen](http://codebetter.com/blogs/aaron.jensen/default.aspx) and [Raymond Lewallen](http://codebetter.com/blogs/raymond.lewallen/default.aspx) on this one.&#160; But the general idea is that an outside developer should be able to read the test/class name, and clearly understand what the intended observable behavior is, for a given context.&#160; Here’s a bad, bad example:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>ValidationShouldWorkCorrectly()</pre>

[](http://11011.net/software/vspaste)

Validation should work correctly.&#160; Hmm.&#160; “Correctly” is in the eye of the beholder.&#160; “Correctly” depends on the circumstances.&#160; “Correctly” depends on your definition of “correct”.&#160; The kicker is, **if this test fails in the future, how will I know if it is because the test is wrong or the code is wrong?**&#160; I won’t.&#160; And at that point, I have to make a judgment call on whether the test is holding its water or not.&#160; Sometimes, I’ll just make the test pass, sometimes I’ll remove the test, and sometimes I’ll spend a lot of wasted time trying to figure why the heck the test was written in the first place.

That’s perhaps the most frustrating aspect.&#160; A unit test that was supposed to provide value when it failed, instead only caused confusion and consternation.

### Rule #2 – Tests are code too, give them some love

Whether you think so or not, you will have to maintain your tests.&#160; You don’t have to _model_ your tests like you would, but duplication matters in your tests.&#160; Do yourself a favor, right now, go order the [xUnit Test Patterns](http://www.amazon.com/xUnit-Test-Patterns-Refactoring-Addison-Wesley/dp/0131495054) book.&#160; TDD is a craft, and the xUnit book is a How-To.&#160; Veteran or neophyte, you’ll learn a new angle that you didn’t know before.&#160; One thing it showed me is that tests are code, which I have to maintain, and showing them love pays almost just as well as it would refactoring production code.

Refactoring tests does many things for you:

  * Eliminates test smells such as brittleness, obscurity or erraticism, and more
  * Provide insight into common contexts and behavioral connections (if several tests have the same setup, then their assertions/observations are related somehow)
  * Reduces nausea

I hate, hate long, complex tests.&#160; If a test has 30 lines of setup, please put that behind a creation method.&#160; A long test just irritates and leaves the developer cross-eyed.&#160; If I don’t have long methods in production code, why would I allow this in our test code?&#160; A test has three parts: Setup, Execute, Verify (and sometimes Teardown).&#160; Following the Context/Specification test pattern already groups these three parts for you, so you can’t get yourself in trouble.

Bottom line, tests are code, love them, and they’ll love you back.

### Rule #3 – Don’t settle on one fixture pattern/organizational style

This assumption killed me for a quite a long time.&#160; For some reason or another, I always assumed that I should have a test fixture pattern of One Class, One Fixture.&#160; One problem of course, this makes _understanding_ behavior of the system as a whole, and of its parts, quite difficult.&#160; Systems with hundreds of classes aren’t very easy to see how the pieces fit, and finding usages and following control flow just doesn’t cut it.&#160; **But aren’t our tests supposed to be documentation?**&#160; Aren’t they supposed to describe how the system works?

**If you’re blindly following one fixture per class, that ain’t happening.**

One fixture per class leads to some pretty crappy test fixtures.&#160; I’ve seen (and created) test fixtures literally _thousands_ of lines long.&#160; That’s right, **_thousands_**.&#160; We would never, ever, ever tolerate that in production code, why is our test code exempt?&#160; Simply because we assumed that there is one pattern to rule them all.&#160; Well, I don’t construct every object with a no-arg constructor, why should I tie both hands behind my back with One fixture pattern?

Or better yet, why just one organizational pattern?&#160; Do unit tests have to match the existing code base file for file, class for class, just with “UnitTests” somewhere in the namespace?&#160; That creates absolute insanity.

Sometimes classes have a lot of behavior that belongs in one place.&#160; Big fixtures can indicate I need to refactor…unless it’s my fixtures that are the problem.&#160; Repositories that provide complex searching are going to have a lot of tests.&#160; But do yourself a favor, look at alternative grouping, such as \*gasp\* common contexts.&#160; The really cool thing about exploring alternate organization is that it fits perfectly with Rule #2.&#160; Explore other organizational styles and fixture patterns.&#160; Try organizing by user experience contexts, not strictly by classes.

When you start seeing behavior in your system not through your classes’ eyes, but from the expected user experience, you’re on the road to truly valuable, descriptive tests.

### Rule #4 – One Setup, Execute and Verify per Test

Another side-effect of blindly using one fixture per class are tests that either:

  * Have a lot of asserts
  * Have a lot of Setup/Execute/Verify in one test

Tests should have one reason to fail.&#160; Asserting twenty different pieces isn’t one reason to fail.&#160; If we’re following Rule #1, that test name is going to get very, very long if we try and describe all of the observations we’re doing.&#160; Have a lot of asserts?&#160; Pick a different fixture pattern.&#160; Test fixture per feature and test fixture per fixture are great for breaking out separate assertions into individual tests.&#160; The better I can describe the observations (from the user experience side), the more the code being created will match what is actually needed.

The multiple execute/verify in a single test is also indicative of assuming one fixture per class.&#160; Here’s one example:

<pre>[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>ValidationShouldWorkCorrectly()
{
    <span style="color: blue">var </span>user = <span style="color: blue">new </span><span style="color: #2b91af">User</span>();

    user.Username = <span style="color: #a31515">"   "</span>;
    user.IsValid().ShouldBeFalse();

    user.Username = <span style="color: #a31515">"34df"</span>;
    user.IsValid().ShouldBeFalse();

    user.Username = <span style="color: #a31515">"oijwoiejf^&*"</span>;
    user.IsValid().ShouldBeFalse();
}</pre>

[](http://11011.net/software/vspaste)

Blech.&#160; Not only does the test name suck (which with this many asserts, did we expect any different?), but I have zero insight into the different contexts and valid observations going on here.&#160; What if the second assertion fails a month from now.&#160; How exactly am I to know if the test is wrong?&#160; Or the code is wrong?&#160; Another headache.

Whatever test fixture pattern you go with, you have to stick with one Setup Execute and Verify per test.&#160; If your current fixture pattern doesn’t allow you to adhere to this rule…change patterns.

### Keepin’ it clean

Tests _can_ be documentation, but only if you try.&#160; If you’re in the “write and forget” category, your tests will become a deadweight, some even causing negative value.&#160; Thousand-line test fixtures, hundred-line tests, incoherent and illegible tests, bad test names, all of these both contribute waste and detract from the maintainability of your system.&#160; So what, a test failed.&#160; Congratulations.&#160; But can you understand why it failed, what behavior is being specified, and why it was important under what circumstances?&#160; If not, what value are your tests giving you, except for a future headache?