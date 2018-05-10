---
wordpress_id: 4054
title: 'How We Do Things &#8211; Testing Part 2'
date: 2009-10-12T00:07:50+00:00
author: Scott Reynolds
layout: post
wordpress_guid: /blogs/scottcreynolds/archive/2009/10/11/how-we-do-things-testing-part-2.aspx
categories:
  - .NET
  - 'C#'
  - how we do it
  - lean
  - Management
  - Quality
  - software
  - team
  - Testing
redirect_from: "/blogs/scottcreynolds/archive/2009/10/11/how-we-do-things-testing-part-2.aspx/"
---
_This content comes solely from my experience, study, and a lot of trial and error (mostly error). I make no claims stating that which works for me will work for you. As with all things, your mileage may vary, and you will need to apply all knowledge through the filter of your context in order to strain out the good parts for you. Also, feel free to call BS on anything I say. I write this as much for me to learn as for you._

_This is part 5 of the [How We Do Things](http://www.lostechies.com/blogs/scottcreynolds/archive/2009/10/04/how-we-do-things-preamble-and-contents.aspx) series._

In the last installment I talked about our the evolution of our TDD/BDD Practice. In this one, I will talk more specifically about the tools we use, where we apply TDD, and other testing practices we employ.

_n.b. I&#8217;ll use &#8220;specification&#8221; interchangeably with &#8220;test&#8221; here, so when you see it, don&#8217;t think &#8220;spec document&#8221;._

### .Net Testing

In our .net applications we employ TDD/BDD with a combination of [NUnit](http://www.nunit.org/index.php), [TestDriven.net](http://testdriven.net/), [ReSharper](http://www.jetbrains.com/resharper/index.html), and a sprinkling of extension methods and abstract base classes inspired by [Scott Bellware&#8217;s](http://blog.scottbellware.com/) [SpecUnit.net](http://code.google.com/p/specunit-net/) project (now defunct, if you are looking for a more full context/specification framework, check out the excellent [Machine.Specifications (MSpec)](https://github.com/machine/machine.specifications) from [Aaron Jensen](http://codebetter.com/blogs/aaron.jensen/default.aspx)).

Our standard abstract base class for a specification looks a bit like this:

<pre>[TestFixture]
    public abstract class SpecificationBase
    {
        protected virtual void Because(){}
        protected abstract void Before_All();
        protected virtual void After_All(){}    
		 
        [TestFixtureSetUp]
        public void context_before_all_specs()
        {
            Before_All();
            Because();
        }
        [TestFixtureTearDown]
        public void teardown_after_all_specs()
        {
            After_All();
        }
    }</pre>

That&#8217;s it, pretty simplistic. With this base we try to &#8220;encourage&#8221; context to get set up in [TestFixtureSetup] rather than [SetUp], the idea being that if a context is going to fit a whole specification (testfixture) then it&#8217;s more efficient to set up once. We don&#8217;t provide a base for [SetUp] and [TearDown] because we want to see those ugly tags in our specification class to remind us to question if we really are breaking up our context appropriately.

We also make heavy use of extension methods to wrap assertions, so that we can do things like 

<pre>observedState.ShouldBeTrue();</pre></p> 

As for the test runner, the R# test runner is great, and pretty, and we will fall back to that to get a nice output list of specs at the end of implementing something, but for the sake of speed and flow, while we&#8217;re actually implementing we tend to prefer the TD.Net runner. This isn&#8217;t mandated though, and some guys stick to the R# runner for everything.

### Higher up the stack in .Net

As it stands today, we do not do any web development in .net. We only have WinForms and a smattering of WPF.

We don&#8217;t use a FIT tool, or a scenario tool like NGourd, because we haven&#8217;t really felt a need for this. We do intend to examine StoryTeller and see if it adds value to our process, and when we do, I&#8217;ll write about it.

We&#8217;ve found that using separated presentation patterns (such as Model-View-Presenter) allows us to very easily drive out everything but the actual UI forms with NUnit and context/specification.

For UI test automation in .net we use [Project White](http://www.codeplex.com/white). We do this similar to how you would run Selenium or Watin tests, carving out chunks of functionality to test as a unit and automating it. Usually these test units are organized around a given MMF because it feels like a natural fit.

We do not have anywhere near 100% coverage for automated UI testing at present because the cost to do so immediately can&#8217;t be justified, so we move forward putting new things under test in this fashion and backfill as we have time. It took us a long time to find a tool we could use (note I didn&#8217;t say &#8220;that we were happy with&#8221;) and Project White fits the bill well enough, but, simply, there&#8217;s just a lot of things you can do in a WinForms UI that makes it **extremely difficult** to test in an automated fashion.

### TDD/BDD in Ruby and Rails

In our new and still evolving rails practice, we utilize [Selenium](http://seleniumhq.org/) and [RSpec](http://rspec.info/) for TDD and for higher-level automation tests. We do context/specification style BDD for our models, and typically do not test-drive our controllers at that level. We will drop down and put some unit tests around our controllers when we feel like we have a hole, or something complicated, but we usually take that as a sign to either move functionality to a model or simplify design.

We started using [Cucumber](http://cukes.info/) for scenario tests, but were not happy with the workflow. The tool itself is great, but the workflow didn&#8217;t get us where we wanted to go. We felt like we were repeating motion on a lot of specification between Cucumber scenarios and RSPec-driven model specs, and that was wasteful.

Instead of that, we test-drive scenarios in RSPec by automating Selenium. This is what covers our controllers and views and sets the expectations of the feature. We do this in context/spec style as well, and the specs (tests) are created as part of the story exploration process, ahead of code being written.

### Manual QA and &#8220;Acceptance&#8221; Testing

We do have a manual QA process, and I&#8217;m not sure that you can safely get away from that in a non-trivial system.

The trick is to make it so that the manual exploratory testing is _strictly_ exploratory, and that by the time a feature gets to this stage TDD and higher-level automated tests are covering the _correctness_ of the expected execution paths.

We combine manual exploratory testing with manual acceptance testing, and the idea here is that any work coming back should be in the realm of usability concerns and slight functional tweaks, not actual bugs. I feel like we&#8217;ve hit a pretty sweet stride here actually, and the ratio of bugs found at this stage to usability issues found at this stage is about 1 to 10. This is a good thing. This means that we have done our due diligence ahead of time with automated tests and our manual testing is concerned with what manual testing should be concerned with &#8211; usability &#8211; 90% of the time.

### Tests as Documentation

We never have had a reason to show test output in any form to a user or other business person, so we haven&#8217;t invested a lot of time into getting nice runner output formatted anywhere (and that&#8217;s also why cucumber and FIT don&#8217;t really have much of a value proposition for us). Our tests themselves are constructed so that both the testers and business analysts can read them and understand the specifications, and the testers, business analysts, and developers all collaborate ahead of time to actually scaffold out the specifications.

By involving the full team in creating the specifications we ensure that they have value beyond the developer desk, and that we are reinforcing among all parties the expectations about the system. This is all about communication, and it&#8217;s the key to any agile or lean development process.

### When we \*don&#8217;t\* TDD

We do not practice TDD 100% of the time. There. I said it.

We don&#8217;t typically TDD spikes. Rather, we don&#8217;t mandate it. If you want to TDD a spike go for it. Sometimes I do, sometimes I don&#8217;t. Depends on the context.

I already said we don&#8217;t TDD our rails controllers or views, and we don&#8217;t TDD the actual forms of our WinForms apps. This is a choice where we figure the cost/benefit ratio is not there. YMMV.

There are certain areas of our system that don&#8217;t end up getting TDD treatment when we add to them. This happens for various reasons, part of which is that it&#8217;s just hard to TDD them, and part of which is that it doesn&#8217;t add much value anyway. One such scenario is in places where we export our data into a common xml format for integrations with other healthcare systems. In these scenarios, the code to generate the xml was done with TDD, and the format is standard. The actual generating and manipulating of the data to feed to the xml builder involves a lot of copy/paste functionality and one-off tweaking on a line-by-line basis. This is all kept black-box to the system at large, uses a known (and tested) api to grab the data, and just doesn&#8217;t make sense to TDD. There&#8217;s a lot of copy/paste because the exporters operate independently and need to have 90% of the same functionality across the board but with variability in how the data is modeled. It works, even though it sounds like it could be constructed better on the surface. You&#8217;ll just have to trust me.

We also don&#8217;t TDD our reports. Much like forms, there&#8217;s too much tweaking and fiddling to get them to lay out right, and TDD just doesn&#8217;t work for us there. But as in the previous example, the api&#8217;s from which the reports get their data have been driven out by tests.

<!-- Technorati Tags Start -->

Technorati Tags:
  
<a href="http://technorati.com/tag/how                   0e                  11o                   8t" rel="tag">how we do it</a>, <a href="http://technorati.com/tag/improvement" rel="tag">improvement</a>, <a href="http://technorati.com/tag/lean" rel="tag">lean</a>, <a href="http://technorati.com/tag/management" rel="tag">management</a>, <a href="http://technorati.com/tag/quality" rel="tag">quality</a>, <a href="http://technorati.com/tag/software" rel="tag">software</a>, <a href="http://technorati.com/tag/team" rel="tag">team</a>, <a href="http://technorati.com/tag/planning" rel="tag">planning</a>
  
<a href="http://technorati.com/tag/TDD" rel="tag">TDD</a>
  
<a href="http://technorati.com/tag/BDD" rel="tag">BDD</a>
  
<a href="http://technorati.com/tag/testing" rel="tag">testing</a> 

<!-- Technorati Tags End -->