---
wordpress_id: 15
title: 'Effective Tests: Test First'
date: 2011-03-21T12:43:37+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=15
dsq_thread_id:
  - "262469062"
categories:
  - Uncategorized
tags:
  - BDD
  - TDD
  - Testing
redirect_from: "/blogs/derekgreer/archive/2011/03/21/effective-tests-test-first.aspx/"
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
      Effective Tests: Test First
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
      <a href="https://lostechies.com/derekgreer/2011/09/05/effective-tests-acceptance-tests/">Effective Tests: Acceptance Tests</a>
    </li>
  </ul>
</div>

In the [last](http://www.lostechies.com/blogs/derekgreer/archive/2011/03/14/effective-tests-a-unit-test-example.aspx) installment of our series, I presented a simple example of a traditional unit test.  In this article, we’ll discuss a completely different way to use unit tests: Test First Programming.

## Test-First Programming

In the book _Extreme Programming Explained: Embrace Change_ published in October 1999, Kent Beck introduced what was at the time a rather foreign concept to software development: Writing unit tests to drive software design.  Described as _Test-First Programming_, the technique involves first writing a test to verify a small increment of desired functionality and then writing code to make the test pass.  This process is then repeated until no additional functionality is desired.

## Incremental Design

Another practice introduced alongside Test-First Programming was _Incremental Design_.  Incremental design is the process of evolving the design of an application as new functionality is developed and better design approaches are recognized.  Due to the fact that software development is an inherently empirical process,  following a defined model where the software is designed up front generally leads to waste and rework.  Incremental design postpones design decisions until needed, introducing patterns and frameworks as a byproduct of refactoring as well as eliminating any flexibility that is unused.

## Test Driven Development

Later, these ideas were  refined into a practice known as _Test Driven Development_.  Test-Driven Development can be described simply as the ideas of Test-First Programming coupled with Incremental Design.  In a later book entitled _Test-Driven Development By Example_ published in November of 2002, Beck presents a refined process involving the writing of a failing test, taking the simplest steps possible to make the test pass, and removing any duplication introduced.  This process was described succinctly as _Red/Green/Refactor_, where red and green referred to the colors typically presented by test runners to indicate failing and passing tests respectively.

## Behavior-Driven Development

[<img style="padding-left: 0px;padding-right: 0px;padding-top: 0px;border-width: 0px" src="http://lostechies.com/content/derekgreer/uploads/2011/03/TestDrivenDevelopment_thumb_107D31DD.png" border="0" alt="Test Driven Development" width="494" height="330" />](http://lostechies.com/content/derekgreer/uploads/2011/03/TestDrivenDevelopment_155FE599.png)

While the practice of Test-Driven Development utilized unit tests primarily for driving application design, its outgrowth from traditional unit testing practices were still evident in its style,  language, and supporting frameworks. This presented an obstacle for some in understanding and communicating the concepts behind the practice.

In the course of teaching and practicing TDD, Dan North began encountering various strategies for designing tests in a more intent-revealing way which aided in his understanding and ability to convey the practice to others.  As a way to help distinguish the differences between what he saw as an exercise in defining behavior rather than testing, he began describing the practice of Test-Driven Development as _Behavior Driven Development_.  By shifting the language to the discussion about behavior, he found that many of the questions he frequently encountered in presenting TDD concepts became easier to answer.  North went on to introduce a framework incorporating this shift in thinking called _JBehave_.  North’s work on JBehave along with his promotion of the ideas behind Behavior-Driven Development served as the inspiration for the creation of many other frameworks including RSpec, Cucumber, NBehave, NSpec, SpecFlow, MSpec and many others.

## Behavior-Driven Development Approaches

Two main approaches have emerged from BDD practices which I’ll categorize as the Plain-Text Story approach and the Executable Specification approach.

### Plain-Text Stories

With the Plain-Text Story approach, software features are written as a series of plain-text scenarios which the framework associates with executable steps used to drive feature development.  This approach is typically associated with a style referred to _Given/When/Then_ (GWT), named after the grammar set forth by Dan North.  This style is facilitated by popular BDD frameworks such as Cucumber and JBehave.

The following is an example story using [Gherkin](https://github.com/aslakhellesoy/cucumber/wiki/gherkin) grammar, the language used by Cucumber and other Plain-Text Story BDD frameworks:

<span style="font-family: Verdana">Feature: Addition<br /> In order to calculate totals<br /> As a user<br /> I want to calculate the sum of multiple numbers</span>

<span style="font-family: Verdana">Scenario: Add two numbers<br /> Given I have entered 10 into the calculator<br /> And I have entered 50 into the calculator<br /> When I press add<br /> Then the result should be 60 on the screen</span>

&nbsp;

Using Cucumber, the “Given” step in this scenario may then be associated to the following step definition in Ruby:

<pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  Given /I have entered (d+) into the calculator/ do |n|
    calc = Calculator.new
    calc.push n.to_i
  end
  
</div></pre>

&nbsp;

Using SpecFlow, the same “Given” step can also be associated to the following step definition in C#:

<pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [Given("I have entered (.*) into the calculator")]
  public void GivenIHaveEnteredSomethingIntoTheCalculator(int number)
  {
      _calculator = new Calculator();
      _calculator.Enter(number);
  }
  
</div></pre>

## &nbsp;

### Executable Specifications

In contrast to the use of plain-text stories, the Executable Specification approach uses source code as the medium for expressing specifications in the language of the business.  Executable Specifications can be written using existing unit-testing frameworks such as JUnit, NUnit, and MSTest, or are written in frameworks designed exclusively to facilitate the Behavior-Driven Development style such as RSpec and MSpec.

One style, referred to as _Context/Specification_, expresses software features in terms of specifications within a given usage context.  In this style, each unique way the software will be used is expressed as a context along with one or more expected outcomes.

While specialized frameworks have been created to support the Context/Specification style, this approach can also be facilitated using existing xUnit frameworks.  This is generally accomplished by creating a Context base class which uses the Template Method pattern to facilitate the desired language.

The following example demonstrates this technique using the NUnit framework:

<pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestFixture]
      public abstract class Context
      {
          [TestFixtureSetUp]
          public void setup()
          {
              establish_context();
              because_of();
          }
  
          [TestFixtureTearDown]
          public void teardown()
          {
              cleanup();
          }
  
          protected virtual void establish_context()
          {
          }
  
          protected virtual void because_of()
          {
          }
  
          protected virtual void cleanup()
          {
          }
      }
</div></pre>

&nbsp;

In addition to providing a Contact base class, the NUnit framework’s TestAttribute can also be sub-classed to aid in moving toward specification-oriented language:

&nbsp;

<pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public class ObservationAttribute : TestAttribute {}
</div></pre>

&nbsp;

By extending the Context base class, NUnit can then be used to write Context/Specification style BDD specifications:

&nbsp;

<pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public class when_adding_two_numbers : Context
  {
      Calculator _calculator;
  
      protected override void establish_context()
      {
          _calculator = new Calculator();
          _calculator.Enter(2);
          _calculator.PressPlus();
          _calculator.Enter(2);
      }
  
      protected override void because_of()
      {
          _calculator.PressEnter();
      }
  
      [Observation]
      public void it_should_return_the_correct_sum()
      {
          Assert.AreEqual(_calculator.Result, 4);
      }
  }
</div></pre>

## &nbsp;

## Working, Maintainable Software That Matters

The ideas behind Test-First Programming continue to be refined by the software development community and have lead to still other variations in name and style, including Example Driven-Development, Specification-Driven Development, Need-Driven Development, and Story Test-Driven Development.  Regardless of its label or flavor, the refinements of Test-First Programming can be distilled down to the following goal: The creation of working, maintainable software that matters.  That is to say, the software should be functional, should be easily maintainable and should be relevant to needs of our customers.

## Conclusion

This time we discussed Test-First Programming and traced its steps to today’s practice of Behavior-Driven Development.  Next time we’ll discuss Test-Driven Development in more detail and walk through a Test First example using the TDD methodology while incorporating some of the Behavior-Driven Development concepts presented here.
