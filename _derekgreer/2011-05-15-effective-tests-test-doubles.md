---
wordpress_id: 359
title: 'Effective Tests: Test Doubles'
date: 2011-05-15T23:51:51+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=359
dsq_thread_id:
  - "304756465"
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
      Effective Tests: Test Doubles
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

In our <a href="https://lostechies.com/derekgreer/2011/05/12/effective-tests-a-test-first-example-part-6/" target="_blank">last</a> installment, we concluded our Test-First example which demonstrated the Test Driven Development process through the creation of a Tic-tac-toe component. When writing automated tests using either a Test-First or classic unit testing approach, it often becomes necessary to verify and/or exercise control over the interactions of a component with its collaborators. In this article, I&#8217;ll introduce a family of strategies for addressing these needs, known collectively as _Test Doubles_. The examples within this article will be presented using the Java programming language.

## Doubles

The term &#8220;Test Double&#8221; was popularized by Gerard Meszaros in his book xUnit Test Patterns. Similar to the role of the &#8220;stunt double&#8221; in the movie industry in which a leading actor or actress is replaced in scenes requiring a more specialized level of training and/or physical ability, Test Doubles likewise play a substitute role in the orchestration of a System Under Test.

Test Doubles serve two primary roles within automated tests. First, they facilitate the ability to isolate portions of behavior being designed and/or tested from undesired influences of collaborating components. Second, they facilitate the ability to verify the collaboration of one component with another.

### Isolating Behavior

There are two primary motivations for isolating the behavior being designed from influences of dependencies: Control and Feedback.

It is often necessary to exercise control over the behavior provided by dependencies of a System Under Test in order to effect a deterministic outcome or eliminate unwanted side-effects. When a real dependency can&#8217;t be adequately manipulated for these purposes, test doubles can provide control over how a dependency responds to consuming components.

A second motivation for isolating behavior is to aid in identifying the source of regressions within a system. By isolating a component completely from the behavior of its dependencies, the source of a failing test can more readily be identified when a regression of behavior is introduced. 

<div style="border-bottom: black 1px solid;border-left: black 1px solid;background: rgb(238, 238, 238);border-top: black 1px solid;border-right: black 1px solid">
  <div align="center">
    <strong>Identifying Regression Sources</strong>
  </div>
  
  <p>
    While test isolation aids in identifying the source of regressions, Extreme Programming (XP) offers an alternative process.
  </p>
  
  <p>
    As discussed briefly in the series introduction, XP categories tests as Programmer Tests and Customer Tests rather than the categories of Unit, Integration or Acceptance Tests. One characteristic of Programmer Tests, which differs from classic unit testing, is the lack of emphasis on test isolation. Programmer tests are often written in the form of Component Tests which test subsystems within an application rather than designing/testing the individual units comprising the overall system. One issue this presents is a decreased ability to identify the source of a newly introduced regression based on a failing test due to the fact that the regression may have occurred in any one of the components exercised during the test. Another consequence of this approach is a potential increase in the number of tests which may fail due to a single regression being introduced. Since a single class may be used by multiple subsystems, a regression in behavior of a single class can potentially break the tests for every component which consumes that class.
  </p>
  
  <p>
    The strategy used for identifying sources of regressions within a system when writing Programmer Tests is to rely upon knowledge of the last change made within the system. This becomes a non-issue when using emergent design strategies like Test-Driven Development since the addition or modification of behavior within a system tends to happen in very small steps. The XP practice of Pair-Programming also helps to mitigate such issues due to an increase in the number of participants during the design process. Practices such as Continuous Integration and associated check-in guidelines (e.g. The Check-in Dance) also help to mitigate issues with identifying sources of regression. The topic of Programmer Tests will be discussed as a separate topic later in the series.
  </p></p>
</div>

### &nbsp;

### Verifying Collaboration

To maximize maintainability, we should strive to keep our tests as decoupled from implementation details as possible. Unfortunately, the behavior of a component being designed can&#8217;t always be verified through the component&#8217;s public interface alone. In such cases, test doubles aid in verifying the indirect outputs of a System Under Test. By replacing a real dependency with one of several test double strategies, the interactions of a component with the double can be verified by the test.

## &nbsp;

## Test Double Types

While a number of variations on test double patterns exist, the following presents the five primary types of test doubles: Stubs, Fakes, Dummies, Spies and Mocks.

### Stubs

When writing specifications, the System Under Test often collaborates with dependencies which need to be supplied as part of the setup or interaction stages of a specification. In some cases, the verification of a component&#8217;s behavior depends upon providing specific indirect inputs which can&#8217;t be controlled by using real dependencies. Test doubles which serve as substitutes for controlling the indirect input to a System Under Test are known as _Test Stubs_.

The following example illustrates the use of a Test Stub within the context of a package shipment rate calculator specification. In this example, a feature is specified for a shipment application to allow customers to inquire about rates based upon a set of shipment details (e.g. weight, contents, desired delivery time, etc.) and a base rate structure (flat rate, delivery time-based rate, etc.).

In the following listing, a RateCalculator has a dependency upon an abstract BaseRateStructure implementation which is used to calculate the actual rate:

<pre class="prettyprint">public class RateCalculator {

	private BaseRateStructure baseRateStructure;
	private ShipmentDetails shipmentDetails;

	public RateCalculator(BaseRateStructure baseRateStructure, ShipmentDetails shipmentDetails) {
		this.baseRateStructure = baseRateStructure;
		this.shipmentDetails = shipmentDetails;
	}

	public BigDecimal CalculateRateFor(ShipmentDetails shipmentDetails) {
		BigDecimal rate =  baseRateStructure.calculateRateFor(shipmentDetails);

		// other processing ...
		
		return rate;
	}
}
</pre>

The following shows the BaseRateStructure contract which defines a method that accepts shipment details and returns a rate:

<pre class="prettyprint">public abstract class BaseRateStructure {
	public abstract BigDecimal calculateRateFor(ShipmentDetails shipmentDetails);
}
</pre>

To ensure a deterministic outcome, the specification used to drive the feature&#8217;s development can substitute a BaseRateStrctureStub which will always return the configured value:

<pre class="prettyprint">public class RateCalculatorSpecifications {

	public static class when_calculating_a_shipment_rate extends ContextSpecification {

		static Reference&lt;BigDecimal> rate = new Reference&lt;BigDecimal>(BigDecimal.ZERO);
		static ShipmentDetails shipmentDetails;
		static RateCalculator calculator;

		Establish context = new Establish() {
			public void execute() {
				shipmentDetails = new ShipmentDetails();
				BaseRateStructure baseRateStructureStub = new BaseRateStructureStub(10.0);
				calculator = new RateCalculator(baseRateStructureStub, shipmentDetails);
			}
		};

		Because of = new Because() {
			protected void execute() {
				rate.setValue(calculator.CalculateRateFor(shipmentDetails));
			}
		};

		It should_return_the_expected_rate = assertThat(rate).isEqualTo(new BigDecimal(10.0));
	}
}
</pre>

For this specificaiton, the BaseRateStructureStub merely accepts a value as a constructor parameter and returns the value when the calculateRateFor() method is called:

<pre class="prettyprint">public class BaseRateStructureStub extends BaseRateStructure {

	BigDecimal value;

	public BaseRateStructureStub(double value) {
		this.value = new BigDecimal(value);
	}

	public BigDecimal calculateRateFor(ShipmentDetails shipmentDetails) {
		return value;
	}
}
</pre>

### &nbsp;

### Fakes

While it isn&#8217;t always necessary to control the indirect inputs of collaborating dependencies to ensure a deterministic outcome, some real components may have other undesired side-effects which make their use prohibitive. For example, components which rely upon an external data store for persistence concerns can significantly impact the speed of a test suite which tends to discourage frequent regression testing during development. In cases such as these, a lighter-weight version of the real dependency can be substituted which provides the behavior needed by the specification without the undesired side-effects. Test doubles which provide a simplified implementation of a real dependency for these purposes are referred to as _Fakes_.

In the following example, a feature is specified for an application serving as a third-party distributor for the sale of tickets to a local community arts theatre to display the itemized commission amount on the receipt. The theatre provides a Web service which handles the payment processing and ticket distribution process, but does not provide a test environment for vendors to use for integration testing purposes. To test the third-party application&#8217;s behavior without incurring the side-effects of using the real Web service, a Fake service can be substituted in its place.

Consider that the theatre&#8217;s service interface is as follows:

<pre class="prettyprint">public abstract class TheatreService {

	public abstract TheatreReceipt ProcessOrder(TicketOrder ticketOrder);
	
	public abstract CancellationReceipt CancelOrder(int orderId);

	// other methods ...
}
</pre>

To provide the expected behavior without the undesired side-effects, a fake version of the service can be implemented:

<pre class="prettyprint">public class TheatreServiceFake extends TheatreService {

	// private field declarations used in light implementation ...
	
	public TheatreReceipt ProcessOrder(TicketOrder ticketOrder) {

		// light implementation details ...

		TheatreReceipt receipt = createReceipt();
		return new TheatreReceipt();
	}

	public CancellationReceipt CancelOrder(int orderId) {

		// light implementation details ...

		CancellationReceipt receipt = createCancellationReceipt();
		return receipt;
	}

	// private methods …

}
</pre>

The fake service may then be supplied to a PaymentProcessor class within the set up phase of the specification:

<pre class="prettyprint">public class PaymentProcessorSpecifications {
	public static class when_processing_a_ticket_sale extends ContextSpecification {

		static Reference&lt;BigDecimal> receipt = new Reference&lt;BigDecimal>(BigDecimal.ZERO);
		static PaymentProcessor processor;

		Establish context = new Establish() {
			protected void execute() {
				processor = new PaymentProcessor(new TheatreServiceFake());			
			}
		};

		Because of = new Because() {
			protected void execute() {
				receipt.setValue(processor.ProcessOrder(new Order(1)).getCommission());
			}
		};

		It should_return_a_receipt_with_itemized_commission =
				assertThat(receipt).isEqualTo(new BigDecimal(1.00));
	}
}
</pre>

### &nbsp;

### Dummies

There are times when a dependency is required in order to instantiate the System Under Test, but which isn&#8217;t required for the behavior being designed. If use of the real dependency is prohibitive in such a case, a Test Double with no behavior can be used. Test Doubles which serve only to provide mandatory instances of dependencies are referred to as _Test Dummies_.

The following example illustrates the use of a Test Dummy within the context of a specification for a ShipmentManifest class. The specification concerns verification of the class&#8217; behavior when adding new packages, but no message exchange is conducted between the manifest and the package during execution of the addPackage() method.

<pre class="prettyprint">public class ShipmentManifestSpecifications {
	public static class when_adding_packages_to_the_shipment_manifest extends ContextSpecification {

		static private ShipmentManifest manifest;

		Establish context = new Establish() {
			protected void execute() {
				manifest = new ShipmentManifest();
			}
		};

		Because of = new Because() {
			protected void execute() {
				manifest.addPackage(new DummyPackage());
			}
		};

		It should_update_the_total_package_count = new It() {
			protected void execute() {
				assert manifest.getPackageCount() == 1;
			}
		};	   
	}
}
</pre>

### &nbsp;

### Test Spies

In some cases, a feature requires collaborative behavior between the System Under Test and its dependencies which can&#8217;t be verified through its public interface. One approach to verifying such behavior is to substitute the associated dependency with a test double which stores information about the messages received from the System Under Test. Test doubles which record information about the indirect outputs from the System Under Test for later verification by the specification are referred to as _Test Spies_.

In the following example, a feature is specified for an online car sales application to keep an audit trail of all car searches. This information will be used later to help inform purchases made at auction sales based upon which makes, models and price ranges are the most highly sought in the area.

The following listing contains the specification which installs the Test Spy during the context setup phase and examines the state of the Test Spy in the observation stage:

<pre class="prettyprint">public class SearchServiceSpecifications {
	public static class when_a_customer_searches_for_an_automobile extends ContextSpecification {

		static AuditServiceSpy auditServiceSpy;
		static SearchService searchService;

		Establish context = new Establish() {
			protected void execute() {
				auditServiceSpy = new AuditServiceSpy();
				searchService = new SearchService(auditServiceSpy);
			}
		};

		Because of = new Because() {
			protected void execute() {
				searchService.search(new MakeSearch("Ford"));
			}
		};

		It should_report_the_search_to_the_audit_service = new It() {
			protected void execute() {
				assert auditServiceSpy.WasSearchCalledOnce() == true : "Expected true, but was false.";
			}
		};
	}
}
</pre>

For this specification, the Test Spy is implemented to simply increment a private field each time the recordSearch() method is called, allowing the specification to then call the WasSearchCalledOnce() method in an observation to verify the expected behavior:

<pre class="prettyprint">public class AuditServiceSpy extends AuditService{
	private int calls;

	public boolean WasSearchCalledOnce() {
		return calls == 1;
	}

	public void recordSearch(Search criteria) {
		calls++;
	}
}
</pre>

### &nbsp;

### Mocks

Another technique for verifying the interaction of a System Under Test with its dependencies is to create a test double which encapsulates the desired verification within the test double itself. Test Doubles which validate the interaction between a System Under Test and the test double are referred to as Mocks.

Mock validation falls into two categories: _Mock Stories_ and _Mock Observations_.

#### Mock Stories

Mock Stories are a scripted set of expected interactions between the Mock and the System Under Test. Using this strategy, the exact set of interactions are accounted for within the Mock object. Upon executing the specification, any deviation from the script results in an exception. 

#### Mock Observations

Mock Observations are discrete verifications of individual interactions between the Mock and the System Under Test. Using this strategy, the interactions pertinent to the specification context are verified during the observation stage of the specification.

#### Mock Observations and Test Spies

The use of Mock Observations in practice looks very similar to the use of Test Spies. The distinction between the two is whether a method is called on the Mock to assert that a particular interaction occurred or whether state is retrieved from the Test Spy to assert that a particular interaction occurred.

To illustrate the concept of Mock objects, the following shows the previous example implemented using a Mock Observation instead of a Test Spy.

In the following listing, a second specification is added to the previous SearchServiceSpecifications class which replaces the use of the Test Spy with a Mock:

<pre class="prettyprint">public class SearchServiceSpecifications {
	...   

	public static class when_a_customer_searches_for_an_automobile_2 extends ContextSpecification {
		static AuditServiceMock auditServiceMock;
		static SearchService searchService;

		Establish context = new Establish() {
			protected void execute() {
				auditServiceMock = new AuditServiceMock();
				searchService = new SearchService(auditServiceMock);
			}
		};

		Because of = new Because() {
			protected void execute() {
				searchService.search(new MakeSearch("Ford"));
			}
		};

		It should_report_the_search_to_the_audit_service = new It() {
			protected void execute() {
				auditServiceMock.verifySearchWasCalledOnce();
			}
		};
	}
}
</pre>

The Mock implementation is similar to the Test Spy, but encapsulates the assert call within the verifySearchWasCalledOnce() method rather than returning the recorded state for the specification to assert:

<pre class="prettyprint">public class AuditServiceMock extends AuditService {
	private int calls;

	public void verifySearchWasCalledOnce() {
		assert calls == 1;
	}

	public void recordSearch(Search criteria) {
		super.recordSearch(criteria);
		calls++;
	}
}
</pre>

While both the Mock Observation and Mock Story approaches can be implemented using custom Mock classes, it is generally easier to leverage a Mocking Framework.

## Mocking Frameworks

A Mocking Framework is testing library written to facilitate the creation of Test Doubles with programmable expectations. Rather than writing a custom Mock object for each unique testing scenario, Mock frameworks allow the developer to specify the expected interactions within the context setup phase of the specification.

To illustrate the use of a Mocking Framework, the following listing presents the previous example implemented using the Java <a href="http://mockito.org/" target="_blank">Mockito</a> framework rather than a custom Mock object:

<pre class="prettyprint">public class SearchServiceSpecifications {
	... 

	public static class when_a_customer_searches_for_an_automobile_3 extends ContextSpecification {
		static AuditService auditServiceMock;
		static SearchService searchService;

		Establish context = new Establish() {
			protected void execute() {
				auditServiceMock = mock(AuditService.class);
				searchService = new SearchService(auditServiceMock);
			}
		};

		Because of = new Because() {
			protected void execute() {
				searchService.search(new MakeSearch("Ford"));
			}
		};

		It should_report_the_search_to_the_audit_service = new It() {
			protected void execute() {
				verify(auditServiceMock).recordSearch(any(Search.class));
			}
		};
	}
}
</pre>

In this example, the observation stage of the specification uses Mockito&#8217;s static verify() method to assert that the recordSearch() method was called with any instance of the Search class.

In many circumstances, messages are exchanged between a System Under Test and its dependencies. For this reason, Mock objects often need to return stub values when called by the System Under Test. As a consequence, most mocking frameworks can be used to also create Test Doubles whose role is only to serve as a Test Stub. Mocking frameworks which facilitate Mock Observations can also be used to easily create Test Dummies.

## Conclusion

In this article, the five primary types of Test Doubles were presented: Stubs, Fakes, Dummies, Spies, and Mocks. Next time, we&#8217;ll discuss strategies for using Test Doubles effectively.
