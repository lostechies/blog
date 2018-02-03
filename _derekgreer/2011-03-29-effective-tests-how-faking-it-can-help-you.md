---
wordpress_id: 176
title: 'Effective Tests: How Faking It Can Help You'
date: 2011-03-29T17:50:32+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/2011/03/29/effective-tests-how-faking-it-can-help-you/
dsq_thread_id:
  - "266046447"
categories:
  - Uncategorized
tags:
  - TDD
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
      Effective Tests: How Faking It Can Help You
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

In [part 1](http://lostechies.com/derekgreer/2011/03/28/effective-tests-a-test-first-example-part-1/) of our Test-First example, I presented a Test-Driven Development primer before beginning our exercise.&nbsp; One of the techniques I’d like to discuss a little further before we continue is the TDD practice of using fake implementations as a strategy for getting a test to pass.&nbsp; 

While not discounting the benefits of using the _Obvious Implementation_ first when a clear and fast implementation can be achieved, the recommendation to “_Fake It (Until You Make It)_” participates in several helpful strategies, each with their own unique benefits:

&nbsp;

## Going Green Fast

Faking it serves as one of the strategies for passing the test quickly. This has several benefits:

One, it provides rapid feedback that your test will pass when the expected behavior is met. This can be thought of as a sort of counterpart to &#8220;failing for the right reason&#8221;.

Second, it has psychological benefits for some, which can aid in stress reduction through taking small steps, receiving positive feedback, and providing momentum. 

Third, it facilitates a &#8220;safety net&#8221; which can be used to provide rapid feedback if you go off course during a refactoring effort. 

&nbsp;

## Keeping Things Simple

Faking it serves as one of the strategies for writing _maintainable_ software.

Ultimately, we want software that works through the simplest means possible. The &#8220;Fake It&#8221; strategy, coupled with Refactoring (i.e. eliminating duplication) or Triangulation (writing more tests to prove the need for further generalization), leads to an additive approach to arriving at a solution that accommodates the needs of the specifications in a maintainable way.&nbsp; Faking It + Refactoring|Triangulation is a disciplined formula for achieving emergent design.

&nbsp;

## Finding Your Way

Faking it serves as a strategy for reducing mental blocks.&nbsp; 

As the ultimate manifestation of “_Do the simplest thing that could possibly work_&#8220;, quickly seeing how the test can be made to pass tends to shine a bit of light on what the next step should be. Rather than sitting there wondering how to implement a particular solution, faking it and then turning your attention to the task of eliminating duplication or triangulating the behavior will push you in the right direction. 

&nbsp;

## Identifying Gaps

Faking it serves as a strategy for revealing shortcomings in the existing specifications. 

Seeing first hand how easy it is to make your tests pass can help highlight how an implementation might be modified in the future without breaking the existing specifications.&nbsp; Part of the recommended strategy for keeping your code maintainable is to remove unused generalization.&nbsp; Generalization&nbsp; which eliminates duplication is needed, but your implementation may include generalization for which the driving need isn’t particularly clear.&nbsp; Using a fake implementation can help uncover behavior you believe should be explicitly specified, but isn’t required by the current implementation.&nbsp; Faking it can lead to such questions as: “_If I can make it pass by doing anything that produces this value, what might prevent someone from altering what I’m thinking of doing to eliminate this duplication?_”

&nbsp;

## Conditioning

Lastly, faking it helps to condition you to seeing the simplest path first.&nbsp; When you frequently jump to the complex, robust, flexible solution, you’ll tend to condition yourself to think that way when approaching problems.&nbsp; When you frequently do simple things, you’ll tend to condition yourself to seeing the possible simplicity in the solution provided.

&nbsp;

## Conclusion

While we should feel free to use an _Obvious Implementation_ when present, The Test-Driven Development strategy of “_Fake It (Until You Make It)_” can play a part in several overlapping strategies which help us to write <u>working, maintainable software that matters</u>.
