---
wordpress_id: 527
title: 'Effective Tests: Acceptance Tests'
date: 2011-09-05T15:11:12+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=527
dsq_thread_id:
  - "405376160"
categories:
  - Uncategorized
tags:
  - acceptance testing
  - Testing
---
## Posts In This Series

<div>
  <ul>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/03/07/effective-tests-introduction/">Effective Tests: Introduction</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/03/14/effective-tests-a-unit-test-example/">Effective Tests: A Unit Test Example</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/03/21/effective-tests-test-first/">Effective Tests: Test First</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/03/28/effective-tests-a-test-first-example-part-1/">Effective Tests: A Test-First Example – Part 1</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/03/29/effective-tests-how-faking-it-can-help-you/">Effective Tests: How Faking It Can Help You</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/04/04/effective-tests-a-test-first-example-part-2/">Effective Tests: A Test-First Example – Part 2</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/04/11/effective-tests-a-test-first-example-part-3/">Effective Tests: A Test-First Example – Part 3</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/04/24/effective-tests-a-test-first-example-part-4/">Effective Tests: A Test-First Example – Part 4</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/05/01/effective-tests-a-test-first-example-part-5/">Effective Tests: A Test-First Example – Part 5</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/05/12/effective-tests-a-test-first-example-part-6/">Effective Tests: A Test-First Example – Part 6</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/05/15/effective-tests-test-doubles/">Effective Tests: Test Doubles</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/05/26/effective-tests-double-strategies/">Effective Tests: Double Strategies</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/05/31/effective-tests-auto-mocking-containers/">Effective Tests: Auto-mocking Containers</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/06/11/effective-tests-custom-assertions/">Effective Tests: Custom Assertions</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/06/24/effective-tests-expected-objects/">Effective Tests: Expected Objects</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/07/19/effective-tests-avoiding-context-obscurity/">Effective Tests: Avoiding Context Obscurity</a>
    </li>
    <li>
      Effective Tests: Acceptance Tests
    </li>
  </ul>
</div>

In the [last](http://lostechies.com/derekgreer/2011/07/19/effective-tests-avoiding-context-obscurity/) installment of our series, we discussed the topic of Context Obscurity along with strategies for avoiding the creation of obscure tests. As the final topic of this series, we’ll take an introductory look at the practice of writing Automated Acceptance Tests.

## Acceptance Tests

Acceptance testing is the process of validating the behavior of a system from end-to-end. That is to say, acceptance tests ask the question: “When all the pieces are put together, does it work?” Often, when components are designed in isolation at the component or unit level, issues are discovered at the point those components are integrated together. Regression in system behavior can also occur after an initial successful integration of the system due to on-going development without the protection of an end-to-end regression test suite.

Automated acceptance testing is accomplished by scripting interactions with a system along with verification of an observable outcome. For Graphical User Interface applications, acceptance tests typically employ the use of UI-automated testing tools. Examples include [Selenium](http://seleniumhq.org/), [Watir](http://watir.com/) and [WatiN](http://watin.org/) for testing Web applications; ThoughtWorks’ [Project White](http://white.codeplex.com/) for testing Windows desktop applications; and [Window Licker](http://code.google.com/p/windowlicker/) for Java Swing-based applications.

The authorship of acceptance tests fall into two general categories: collaborative and non-collaborative. Collaborative acceptance tests use tools which separate a testing grammar from the test implementation, allowing non-technical team members to collaborate on the writing of acceptance tests. Tools used for authoring collaborative acceptance tests include [FitNesse](http://fitnesse.org/), [Cucumber](http://cukes.info/), and [StoryTeller](http://storyteller.github.com/). Non-collaborative acceptance tests combine the grammar and implementation of the tests, are typically written in the same language as the application being tested and can be authored using traditional xUnit testing frameworks.

## Acceptance Test Driven Development

Acceptance Test Driven Development (A-TDD) is a software development process in which the features of an application are developed incrementally to satisfy specifications expressed in the form of automated acceptance tests where the feature implementation phase is development using the Test-Driven Development methodology (i.e. Red/Green/Refactor).

The relationship of A-TDD to TDD can be expressed as two concentric processes where the outer process represents the authoring of automated acceptance tests which serve as the catalyst for an inner process which represents the implementation of features developed following the TDD methodology. The following diagram depicts this relationship:

&nbsp;

[<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: block; float: none; border-top-width: 0px; border-bottom-width: 0px; margin-left: auto; border-left-width: 0px; margin-right: auto; padding-top: 0px" title="ATDD" border="0" alt="ATDD" src="http://lostechies.com/content/derekgreer/uploads/2011/09/ATDD_thumb.png" width="406" height="406" />](http://lostechies.com/content/derekgreer/uploads/2011/09/ATDD.png)

&nbsp;

When following the A-TDD methodology, one or more acceptance tests are written to reflect the acceptance criteria of a given user story. Based upon the expectations of the acceptance tests, one or more components are implemented using the TDD methodology until the acceptance tests pass. This process is depicted in the following diagram:

&nbsp;

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: block; float: none; margin-left: auto; border-top: 0px; margin-right: auto; border-right: 0px; padding-top: 0px" title="TDD-Process" border="0" alt="TDD-Process" src="http://lostechies.com/content/derekgreer/uploads/2011/09/TDD-Process_thumb1.png" width="423" height="435" />](http://lostechies.com/content/derekgreer/uploads/2011/09/TDD-Process1.png)

&nbsp;

## An Example

The following is a simple example of an automated acceptance test for testing a feature to be developed for a Web commerce application. This test will validate that the first five products in the system are displayed to the user upon visiting the landing page for the site. The tools we’ll be using to implement our acceptance test are the Machine.Specifications library (a.k.a. MSpec) and the Selenium Web UI testing library.

<div style="border-bottom: black 1px solid; border-left: black 1px solid; background: rgb(238,238,238); border-top: black 1px solid; border-right: black 1px solid">
  <div align="center">
    <strong>A Few Recommendations</strong>
  </div>
  
  <p>
    When testing .Net Web applications on a Windows platform, the following are a few recommendations you may want to consider for establishing your acceptance testing infrastructure:
  </p>
  
  <ul>
    <li>
      Use IIS Express or a portable Web server such as CassiniDev. <li>
        Use a portable instance of Firefox or other targeted browser supported by your selected UI automated testing library. <li>
          Establish testing infrastructure which allows single instances of time-consuming processes to be started once for all acceptance tests. Examples of such processes would include starting up Web server and/or browser processes and configuring any Object-Relational Mapping components (e.g. NHibernate SessionFactory initialization). <li>
            Establish testing infrastructure which performs a complete setup and tear down of the application database. Consider setting up multiple strategies for running full test suites vs. running the current use case under test.
          </li></ul> </div> 
          <p>
            &nbsp;
          </p>
          
          <p>
            To keep our example simple, we’ll assume our web site is already deployed as the default site on localhost port 80, that the database utilized by the application is already installed and configured, that our current machine has Firefox installed and that each test will be responsible for launching an instance of Selenium’s FirefoxDriver.
          </p>
          
          <p>
            Here’s our acceptance test:
          </p>
          
          <pre class="prettyprint">
    [Subject("List Products")]
    public class when_a_user_requests_the_default_view
    {
        static Database _database;
        static FirefoxDriver _driver;

        Establish context = () =&gt;
            {
                // Establish known database state
                _database = _database = new Database().Open();
                _database.RemoveAllProducts();
                Enumerable.Range(0, 10).ForEach(i =&gt; _database.AddProduct(i));
                _database.Close();

                // Start the browser
                _driver = new FirefoxDriver();
            };

        Cleanup after = () =&gt; _driver.Close();

        Because of = () =&gt; _driver.Navigate().GoToUrl("http://localhost/");

        It should_display_the_first_five_products = () =&gt; _driver.FindElements(By.ClassName("customer")).Count().ShouldEqual(5);
    }</pre>
          
          <p>
            In this test, the <em>Establish</em> delegate is used to set up the expectations for this scenario (i.e. the context). Those expectations include the presence of at least five product records in the database and that a Firefox browser is ready to use. The <em>Because</em> delete is used to initiate our singe action which should trigger our expected outcome. The <em>It</em> delegate is then used to verify that a call to the Selenium WebDriver’s FindElements() method returns exactly five elements with a class of ‘customer’. Upon completion of the test, the <em>Cleanup</em> delegate is used to close the browser.
          </p>
          
          <h2>
            Conclusion
          </h2>
          
          <p>
            The intent of this article was merely to introduce the topic of automated acceptance testing since a thorough treatment of the subject is beyond the scope of this series. For further reading on this topic, I highly recommend the book <em>Growing Object-Oriented Software Guided By Tests</em> by Steve Freeman and Nat Pryce. While written from a Java perspective, this book is an excellent guide to Acceptance Test Driven Development and test writing practices in general.
          </p>
          
          <p>
            This article concludes the Effective Tests series.&nbsp; I hope it will serve as a useful resource for the software development community.
          </p>
