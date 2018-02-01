---
id: 13
title: 'Effective Tests: Introduction'
date: 2011-03-07T12:09:24+00:00
author: Derek Greer
layout: post
guid: /blogs/derekgreer/archive/2011/03/07/effective-tests-introduction.aspx
dsq_thread_id:
  - "262468846"
categories:
  - Uncategorized
tags:
  - Testing
---
## Posts In This Series

<div>
  <ul>
    <li>
      Effective Tests: Introduction
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
      <a href="https://lostechies.com/derekgreer/2011/09/05/effective-tests-acceptance-tests/">Effective Tests: Acceptance Tests</a>
    </li>
  </ul>
</div>

This is the first installment of a series discussing&#160; topics surrounding effective automated testing.&#160; Automated testing can be instrumental to both the short and long-term success of a project.&#160; Unfortunately, it is too often overlooked due to either a lack of knowledge of how to incorporate test into an existing process, or a lack of recognition of the deficiencies within an existing process.&#160; As with any new pursuit, learning how to use automated testing effectively within a development process can take time.&#160; The goal of this series is to help those new to the practice of automated testing by gradually introducing concepts which aid in the creation of working, maintainable software that matters.

This introduction will start things off by discussing some of the fundamental types of automated tests.

## &#160;

## Unit Testing

Unit tests are perhaps the most widely recognized form of test automation.&#160; A Unit Test is a process which validates behavior within an application in isolation from any of its dependencies.&#160;&#160; Unit tests are typically written in the same language as the software being tested, take the form of a method or class designed for a particular testing framework (such as JUnit, NUnit, or MSTests) and are generally designed to validate the behavior of individual methods or functions within an application.&#160; The behavior of a component being tested can be isolated from the behavior of its dependencies using substitute dependencies known as _Test Doubles_.&#160; By testing each component’s behavior in isolation, failing tests can be used to more readily identify which components are causing a regression in behavior.

The primary goal of traditional unit testing is verification.&#160; By establishing a suite of unit tests, the software can be tested each time modifications are made to ensure the software still behaves as expected.&#160; To ensure that existing tests are always run when modifications are introduced, the tests can also be run at regular intervals or triggered as part of a check-in policy using a process known as _Continuous Integration_.

## &#160;

## Integration Testing

While unit tests are useful for verifying that the encapsulated behavior of a component works as expected within a known context, they often fall short of anticipating how the component will interact with other components used by the system.&#160; Tests which verify that components behave as expected with all, or a subset of their real dependencies are often categorized as _Integration Tests_.&#160; Of particular interest are interactions with third-party libraries and external resources such as file systems, databases, and network services.&#160; This is due to the fact that the behavior of such dependencies may not be fully known or controlled by the consuming development team, or may change in unexpected ways when new versions are introduced.

Integration tests often require more setup and/or reliance upon communication with external processes and are therefore usually slower than unit test suites.&#160; Due to this fact, separate strategies are often used to ensure regular feedback of integration tests.&#160; In some cases, slow-running tests can be mitigated by the use of “almost-real” substitutes such as in memory file systems and databases which are known to adequately represent the functionality expected by the real dependencies.

While the term “integration test” is often applied to any test verifying the behavior of collaborating components, it can be useful for test organization and the development of testing strategies to draw a distinction between tests which verify integration with disparate systems and those that verify that a collection of classes correctly provide a logical service.&#160; In the book _xUnit Test Patterns: Refactoring Test Code_, Gerard Meszaros refers to tests for such collaborating classes as _Component Tests_.&#160; While both test the interaction of multiple components, Component Tests ask the question “Does this logical service perform the expected behavior?” while Integration Tests asks the question “Do these components work together?”.

## &#160;

## Acceptance Testing

Acceptance tests, or end-to-end tests, verify that particular use cases of the system work as a whole.&#160; Such tests are characterized by a focus on how the system will be used by the customer by exercising as much of the real system as possible.&#160; While finer-grained tests such as unit and component tests can help ensure the functional integrity of the individual components, acceptance testing ensures that the components function correctly together.

Although the purpose of acceptance testing is to verify the system works as a whole, it may still be necessary in some cases to substitute portions of the system where full end-to-end testing isn’t&#160; cost-effective or practical.&#160; For instance, some external services may not provide integration testing environments or may place limits on its use.&#160; In other cases, the user interface technology used may not lend itself to test automation in which case tests may be written against a layer just below the user interface layer.&#160; This is referred to as _Subcutaneous Testing_.

## &#160;

## Classifications

The terms unit test, integration test and acceptance test classify tests in terms of their utility.&#160; Another way to classify tests are in terms of their audience.&#160; In Extreme Programming (XP), tests are broken down into the categories of _Customer Tests_ and _Programmer Tests_.&#160; Customer Tests are synonymous with User Acceptance Tests and are focused on the external quality of the system.&#160; Programmer Tests are similar to Unit Tests in that they are written by programmers and are generally focused on the internal quality of the system, but they are less prescriptive about their level of test isolation.&#160; Programmer Tests will be discussed in more detail later in our series.

## &#160;

## Conclusion

This article presents only a brief introduction to some of the classifications of automated tests.&#160; We’ll continue to explore these and others throughout the series.&#160; Next time, we’ll take a look a traditional approach to writing unit tests.
