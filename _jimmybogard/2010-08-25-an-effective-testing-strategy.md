---
wordpress_id: 428
title: An effective testing strategy
date: 2010-08-25T03:15:45+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/08/24/an-effective-testing-strategy.aspx
dsq_thread_id:
  - "264716557"
categories:
  - Testing
redirect_from: "/blogs/jimmy_bogard/archive/2010/08/24/an-effective-testing-strategy.aspx/"
---
On a recent large project, we had a goal early on that we didn’t want to have a lot of QA folks manually testing our software.&#160; Finding bugs through manual testing is incredibly time consuming and expensive, so we opted to try and build as much quality in to the product.&#160; That’s not to say that manual testing doesn’t have its place, as humans are fantastic about using software in ways you _didn’t_ expect.

This was a long project, around 18 months, and will continue to have active development in the future.&#160; Very early on we found that a good testing strategy was critical to the success of the project, especially for our team to be able to 1) continue to increase our velocity over time and 2) have the confidence to make both small and large changes in our application.

It took quite a while for us to settle on an effective strategy.&#160; This was mostly because we had to learn how to design our application for testability, in all layers of the application.&#160; Our team were all experienced in TDD before starting the project, but that wasn’t the only skill we needed to create an effective testing strategy.

### Levels of tests

Categorizing tests can get annoying.&#160; You have functional tests, integration tests, unit tests, acceptance tests, slow tests, fast tests, UI tests, and on and on.&#160; We found that our tests belonged in three main categories:

  * Full-system tests 
  * Subcutaneous tests 
  * Unit tests 

Each of these differs in the scope of what’s being tested.&#160; A full-system test exercises the application through the external interface, whether that’s a browser, file drop, queue, WinForms app or whatnot.

Subcutaneous tests work at the layer directly below the external user interface.&#160; In the context of a web application, a subcutaneous test in our case would be a form object sent through a command processor, with all the real classes and implementations in place.&#160; We bypassed the Controller, which only contained UI layer logic, straight to the domain layer.&#160; Send in form object, out pops success/failure.

Finally, we had unit tests.&#160; Unit tests are designed to test one class, and can either be fast or slow tests.&#160; Fast tests are the normal TDD tests, used to build out class design.&#160; Test doubles are used as needed, but strictly interaction-based tests have less value unless we find the interactions very interesting.&#160; We also have slow unit tests, which could also be classified as integration tests.&#160; These would be things like repository tests, persistence tests, etc.

Our ratio of unit:subcutaneous:full-system tests hovered around something like 10:2:1.&#160; We ended the project with something around 5000 unit tests, 1000 subcutaneous tests, and 500 full-system tests that used WatiN and Gallio to drive a browser.&#160; The 6000 unit/subcutaneous tests executed in about 10 minutes, while the 500 UI tests completed in about 50 minutes.

### Unit testing strategy

Unit tests were developed in a pretty strict TDD manner.&#160; We write tests before any implementation is in place, and use the tests to drive the design of the code.&#160; These tests help identify design issues, encapsulation problems, code smells and so on.

We strived to not write code that existed solely to enable testing.&#160; That often meant that we had a design issue, and responsibilities were misplaced or encapsulation was violated.

As we got further down the pipeline in our project, we started to value interaction tests less and less.&#160; **Interaction testing through mocking is only really interesting if you’re truly interested about interactions.**&#160; But more often, we were more interested in side-effects, and interactions were just an implementation detail.&#160; What we often did instead is mock out slow or untestable pieces, like repositories, facades over external services, configuration classes, etc.&#160; Otherwise, we limited mocking only to places where mocks were the only observation points for what we were interested in.

At some point in large projects, it can become obvious that your design needs a large-level refactoring, to extract out concepts to enable quicker delivery of features.&#160; On our last project, some concepts unearthed included:

  * AutoMapper 
  * Processing forms as individual command messages 
  * Input builders 

With each of these, **unit tests were actually a barrier to these refactorings.**&#160; But the barrier only existed because we had relied on these tests to capture _all_ of the interesting behavior in our application.&#160; To effectively allow large- and mid-size refactorings, we needed an additional level of testing.

### Subcutaneous testing strategy

Subcutaneous tests, like their name implies, test everything just below the surface of the user interface.&#160; In an MVC application, these would be tests for everything just below the controller.&#160; For a web service, everything just below the endpoint.&#160; The idea is that the topmost layer in an application does not perform any actual business logic, but just connect the external interfaces with the underlying services.

Subcutaneous tests are important because we want to be able to **test business logic with the entirety of the system in play**, with the exception of external connection points such as the user interface and external services.&#160; While a unit test focuses on small-scale design, a subcutaneous test does not address design, but instead tests basic inputs and outputs of the system as a whole.

To build effective subcutaneous tests, we can try and build uniform pinch points through which common logic flows.&#160; For example, we might build a command message handling system, or a common query interface.&#160; In a recent project that processed batch files, each row in the file was transformed into a message.&#160; We could then craft a message, send it through the system, and then verify all the side effects of processing that message.

Because **subcutaneous tests address high-level behavior, rather than design**, they are ideal for scenario-based testing strategies such as BDD or the [Testcase Class per Fixture](http://xunitpatterns.com/Testcase%20Class%20per%20Fixture.html) pattern.&#160; If we want to be able to perform large refactorings, we need these high-level tests to create that wide-cast safety net for business behavior.&#160; Subcutaneous tests are also great target points for calling features done, as they focus on more end-to-end logic.

While subcutaneous tests allow us to safely perform larger refactorings, they still do not provide a satisfactory level of confidence that our system will work in production.

### Full system testing strategy

Our team originally called these tests “UI tests”, until more and more of our projects entailed integration strategies where the inputs to our system weren’t a browser, but instead messages, a REST endpoint, or FTP drops and batch file processing.&#160; UI testing is a subset of full system testing.&#160; The idea behind a full system test is that we want to test our software as it might be used in production.&#160; For an MVC application, these would be browser-based tests.&#160; For batch files, we would use actual files.&#160; REST, actual HTTP requests.&#160; Messages, real queues and messages.

If we want to know if our application works as expected, before it goes to production, one effective and efficient way to do so is to create an automated test that exercises the full system.&#160; If my UI tests logs in to the application, places an order and I can verify that an order request was generated, I’m feeling pretty good about things.

One common misconception about full system tests is that they are black box tests.&#160; While these have their merit, full system tests should have intimate knowledge about what’s going on underneath the covers.&#160; In fact, full system tests can even take advantage of the domain model to build up data, instead of a back-door system built solely for testing purposes.&#160; One big mistake teams run in to is not following the same code paths in testing as they do in production, leading to wacky invalid, impossible states of the system.

In our projects, a full system test is the last code we write before we call a feature/story done, done, done.&#160; Manual testing is just too expensive and unreliable for characterizing “done-ness” of a feature, but if I can do the exact same actions as would happen in production through the exact same external interfaces, that’s success.

### A holistic approach

In an application without tests, we’ve actually found it most valuable to start with full system testing, moving down towards unit tests as a means of a strategy for coverage.&#160; We cast the widest net possible, but the simplest assertions first, then slowly move down towards unit-level logic.&#160; In new applications, we tend not to focus on any one area, as all of these tests are critical to us for long-term maintainability of a system.

This testing strategy does require a level of investment.&#160; We’ve found this holistic approach especially effective when we know that this application is critical to our client’s business.&#160; If an application is critical to business, it’s going to require change.&#160; If it’s going to require change, we better be able to safely change it without affecting our client’s business.