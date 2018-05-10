---
wordpress_id: 416
title: 'Effective Tests: Double Strategies'
date: 2011-05-26T13:09:58+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=416
dsq_thread_id:
  - "314372817"
categories:
  - Uncategorized
tags:
  - Test Doubles
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
      Effective Tests: Double Strategies
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

In our [last](https://lostechies.com/derekgreer/2011/05/15/effective-tests-test-doubles/) installment, the topic of Test Doubles was introduced as a mechanism for verifying and/or controlling the interactions of a component with its collaborators. In this article, we&#8217;ll consider a few recommendations for using Test Doubles effectively.

### &nbsp;

## Recommendation 1: Clarify Intent

Apart from guiding the software implementation process and guarding the application&#8217;s current behavior against regression, executable specifications (i.e. Automated Tests) serve as the system&#8217;s documentation. While well-named specifications can serve to describe what the system should do, we should take equal care in clarifying the intent of how the system&#8217;s behavior is verified.

When using test doubles, one simple practice that helps to clarify the verification strategies employed by the specification is to use intention-revealing names for test double instances. Consider the following example which uses the Rhino Mocks framework for creating a Test Stub:

<pre class="prettyprint">public class when_a_user_views_the_product_detail
	{
		public const string ProductId = "1";
		static ProductDetail _results;
		static DisplayOrderDetailCommand _subject;

		Establish context = () =>
			{
				var productDetailRepositoryStub = MockRepository.GenerateStub&lt;IProductDetailRepository>();
				productDetailRepositoryStub.Stub(x => x.GetProduct(Arg&lt;string>.Is.Anything))
					.Return(new ProductDetail {NumberInStock = 42});

				_subject = new DisplayOrderDetailCommand(productDetailRepositoryStub);
			};

		Because of = () => _results = _subject.QueryProductDetails(ProductId);

		It should_display_the_number_of_items_currently_in_stock = () => _results.NumberInStock.ShouldEqual(42);
	}
</pre>

### &nbsp;

In this example, a Test Stub is created for an IProductDetailRepository type which serves as a dependency for the System Under Test (i.e. the DisplayOrderDetailCommand type). By choosing to explicitly name the Test Double instance with a suffix of “Stub”, this specification communicates that the double serves only to provide indirect input to the System Under Test.

### &nbsp;

<div style="border-bottom: black 1px solid;border-left: black 1px solid;background: rgb(238, 238, 238);border-top: black 1px solid;border-right: black 1px solid">
  <div align="center">
    <strong>Note to Rhino Mock and Machine.Specification Users</strong>
  </div>
  
  <p>
  </p>
  
  <p>
    For Rhino Mock users, there are some additional hints in this example which help to indicate that the test double used by this specification is intended to serve as a Test Stub. This includes use of Rhino Mock&#8217;s GenerateStub<T>() method, the lack of “Record/Replay” artifacts from either the old or new mocking APIs and the absence of assertions on the generated test double. Additionally, those familiar with the Machines.Specifications framework (a.k.a. MSpec) would have an expectation of explicit and discrete observations if this were being used as a Mock or Test Spy. Nevertheless, we should strive to make the chosen verification strategy as discoverable as possible and not rely upon framework familiarity alone.
  </p>
</div>

### &nbsp;

While this test also indicates that the test double is being used as a Stub by its use of the Rhino Mock framework&#8217;s GenerateStub<T>() method, Rhino Mocks doesn&#8217;t provide intention-revealing method names for each type of test double and some mocking frameworks don&#8217;t distinguish between the creation of mocks and stubs at all. Using intention-revealing names is a consistent practice that can be adopted regardless of the framework being used.

### &nbsp;

## Recommendation 2: Only Substitute Your Types

Applications often make use of third-party libraries and frameworks. When designing an application which leverages such libraries, there&#8217;s often a temptation to substitute types within the framework. Rather than providing a test double for these dependencies, create an abstraction representing the required behavior and provide a test double for the abstraction instead.

There are several issues with providing test doubles for third party components:

First, it precludes any ability to adapt to feedback received from the specification. Since we don&#8217;t control the components contained within a third-party libraries, coupling our design to these components limits our ability to guide our designs based upon our interaction with the system through our specifications.

Second, we don&#8217;t control when or how the API of third-party libraries may change in future releases. We can exercise some control over when we choose to upgrade to a newer release of a library, but aside from the benefits of keeping external dependencies up to date, there are often external motivating factors outside of our control. By remaining loosely-coupled from such dependencies, we minimize the amount of work it takes to migrate to new versions.

Third, we don&#8217;t always have a full understanding of the behavior of third-party libraries. Using test doubles for dependencies presumes that the doubles are going to mimic the behavior of the type they are substituting correctly (at least within the context of the specification). Substituting behavior which you don&#8217;t fully understand or control may lead to unreliable specifications. Once a specification passes, there should be no reason for it to ever fail unless you change the behavior of your own code. This can&#8217;t be guaranteed when substituting third-party libraries.

While we shouldn&#8217;t substitute types from third-party libraries, we should verify that our systems work properly when using third-party libraries. This is achieved through integration and/or acceptance tests. With integration tests, we verify that our systems display the expected behavior when integrated with external systems. If our systems have been properly decoupled from the use of third-party libraries, only the Adaptors need to be tested. A system which has taken measures to remain decoupled from third-party libraries should have far fewer integration tests than those that test the native behavior of the application. With acceptance tests, we verify the behavior of the entire application from end to end which would exercise the system along with its external dependencies.

### &nbsp;

## Recommendation 3: Don&#8217;t Substitute Concrete Types

The following principle is set forth in the book _Design Patterns: Elements of Reusable Object-Oriented Software by Gamma_, et al:

> Program to an interface, not an implementation.

All objects possess a public interface and in this sense all object-oriented systems are collaborations of objects interacting through interfaces. What is meant by this principle, however, is that objects should only depend upon the interface of another object, not the implementation of that object. By taking dependencies upon concrete types, objects are implicitly bound by the implementation details of that object. Subtypes can be substituted, but subtypes are inextricably coupled to their base types.

Set forth in the book _Agile Software Development, Principles, Patterns, and Practices_ by Robert C. Martin, a related principle referred to as the _Interface Segregation Principe_ states:

> Clients should not be forced to depend on methods that they do not use.

The Interface Segregation Principle is set forth to address several issues that arise from non-cohesive or “fat” interfaces, but the issue most pertinent to our discussion is the problem of associative coupling. When a component takes a dependency upon a concrete type, it forms an associative coupling with all other clients of that dependency. As new requirements drive changes to the internals of the dependency for one client, all other clients coupled directly to the same dependency may be affected regardless of whether they depend upon the same sets of behavior or not. This problem can be mitigated by defining dependencies upon Role-based Interfaces. In this way, objects declare their dependencies in terms of behavior, not specific implementations of behavior.

So, one might ask, “What does this have to do with Test Doubles?” There is nothing particularly problematic about replacing concrete types from an implementation perspective. There&#8217;s certainly the issue in some languages of needing to take measures to ensure virtual dispatching can take place thereby allowing the behavior of a concrete type to be overridden, but where this actually becomes relevant to our discussion is in what our specifications are trying to tell us about our design. When you find yourself creating test doubles for concrete types, it&#8217;s as if your specifications are crying out: “Hey dummy, you have some coupling here!” By listening to the feedback provided by our specification, we can begin to spot code smells which may point to problems in our implementation.

### &nbsp;

## Recommendation 4: Focus on Behavior

When writing specifications, it can be easy to fall into the trap of over-specifying the components of the system. This occurs when we write specifications that not only verify the expected behavior of a system, but which also verify that the behavior is achieved using a specific implementation.

Writing component-level specifications will always require some level of coupling to the component&#8217;s implementation details. Nevertheless, we should strive to minimize the coupling to those interactions which are required to verify the system requirements. If the System Under Test takes 10 steps to achieve the desired outcome, but the outcome of step 10 by itself is sufficient to verify that the desired behavior occurred, our specifications shouldn&#8217;t care about steps 1 through 9. If someone figures out a way to achieve the same outcome with only 3 steps, the specifications of the system shouldn&#8217;t need to change.

This leads us to a recommendation from the book _XUnit Test Patterns: Refactoring Test Code_ by Gerard Meszaros:

> Use the Front Door First

By “front door”, the author means that we should strive to verify behavior using the public interface of our components when _possible_, and use interaction-based verification when _necessary_. For example, when the behavior of a component can be verified by checking return values from operations performed by the object or by checking the interactions which occurred with its dependencies, we should prefer checking the return values over checking its interactions. At times, verifying the behavior of an object requires that we examine how the object interacted with its collaborators. When this is necessary, we should strive to remain as loosely coupled as possible by only specifying the minimal interactions required to verify the expected behavior.

### &nbsp;

## Conclusion

In this article, we discussed a few strategies for using Test Doubles effectively. Next time we&#8217;ll take a look at a technique for creating Test Doubles which aids in both reducing coupling and obscurity &#8230; but at a cost.
