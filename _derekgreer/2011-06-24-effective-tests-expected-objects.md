---
id: 489
title: 'Effective Tests: Expected Objects'
date: 2011-06-24T12:12:35+00:00
author: Derek Greer
layout: post
guid: http://lostechies.com/derekgreer/?p=489
dsq_thread_id:
  - "341131289"
categories:
  - Uncategorized
tags:
  - Expected Object Pattern
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
      Effective Tests: Expected Objects
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/07/19/effective-tests-avoiding-context-obscurity/">Effective Tests: Avoiding Context Obscurity</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/09/05/effective-tests-acceptance-tests/">Effective Tests: Acceptance Tests</a>
    </li>
  </ul>
</div>

In the [last](http://lostechies.com/derekgreer/2011/06/11/effective-tests-custom-assertions/) installment of the Effective Tests series, the topic of Custom Assertions was presented as a strategy for helping to clarify the intent of our tests. This time we’ll take a look at another test pattern for improving the communication of our tests in addition to reducing test code duplication and the need to add test-specific code to our production types.

## Expected Objects

Writing tests often involves inspecting the state of collaborating objects and the messages they exchange within a system. This often leads to declaring multiple assertions on fields of the same object which can lead to several maintenance issues. First, if multiple specifications need to verify the same values then this can result in test code duplication. For example, two searches for a customer record with different criteria may be expected to return the same result. Second, when many fine-grained assertions are performed within a specification, the overall purpose can become obscured. For example, a specification may indicate that a value returned from an order process _“should contain a first name and a last name and a home phone number and an address line 1 and …”_ while the intended perspective may be that the operation _“should return a shipment confirmation”_.

One solution to this problem is to override an object’s equality operators and/or methods to suit the needs of the test. Unfortunately, this is not without its own set of issues. Aside from introducing behavior into the system which is only exercised by the tests, this strategy may conflict with the existing or future needs of the system due to a difference in how each define equality for the objects being compared. While a test may need to compare all the properties of two objects, the system may require equality to be based upon the object’s identity (e.g. two customers are the same if they have the same customer Id). It may happen that the system already defines equality suitable to the needs of the test, but this is subject to change. A system may compare two objects by value for the purposes of indexing, ensuring cardinality, or an assortment of domain-specific reasons whose needs may change as the system evolves. While the initial state of an object’s definition of equality may coincide with the needs of the test, the needs of both represent two axes of change which could lead to higher maintenance costs if not dealt with separately.

When using state-based verification, one way of avoiding test code duplication, obscurity and the need to equip the system with test-specific equality code is to implement the _Expected Object_ pattern. The Expected Object pattern defines objects which encapsulate test-specific equality separate from the objects they are compared against. An expected object may be implemented as a sub-type whose equality members have been overloaded to perform the desired comparisons or as a test-specific type designed to compare itself against another object type.

Consider the following specification which validates that placing an order returns an order receipt populated with the expected values:

<pre class="prettyprint">[Subject(typeof (OrderService))]
public class when_an_order_is_placed : WithSubject&lt;OrderService&gt;
{
	static readonly Guid CustomerId = new Guid("061F3CED-405F-4261-AF8C-AA2B0694DAD8");
	const long OrderNumber = 1L;
	static Customer _customer;
	static Order _order;
	static OrderReceipt _orderReceipt;


	Establish context = () =&gt;
		{
			_customer = new TestCustomer(CustomerId)
				            {
				            	FirstName = "First",
				            	LastName = "Last",
				            	PhoneNumber = "5129130000",
				            	Address = new Address
				            		        {
				            		          	LineOne = "123 Street",
				            		          	LineTwo = string.Empty,
				            		          	City = "Austin",
				            		          	State = "TX",
				            		          	ZipCode = "78717"
				            		        }
				            };
			For&lt;IOrderNumberProvider&lt;long&gt;&gt;().Setup(x =&gt; x.GetNext()).Returns(OrderNumber);
			For&lt;ICustomerRepository&gt;().Setup(x =&gt; x.Get(Parameter.IsAny&lt;Guid&gt;())).Returns(_customer);
			_order = new Order(1, "Product A");
		};

	Because of = () =&gt; _orderReceipt = Subject.PlaceOrder(_order, _customer.Id);

	It should_return_a_receipt_with_order_number = () =&gt; _orderReceipt.OrderNumber.ShouldEqual(OrderNumber.ToString());

	It should_return_a_receipt_with_order_description = () =&gt; _orderReceipt.Orders.ShouldContain(_order);

	It should_return_a_receipt_with_customer_id = () =&gt; _orderReceipt.CustomerId.ShouldEqual(_customer.Id.ToString());
		
	It should_return_an_order_receipt_with_customer_name = () =&gt; _orderReceipt.CustomerName.ShouldEqual(_customer.FirstName + " " + _customer.LastName);

	It should_return_a_receipt_with_customer_phone = () =&gt; _orderReceipt.CustomerPhone.ShouldEqual(_customer.PhoneNumber);

	It should_return_a_receipt_with_address_line_1 = () =&gt; _orderReceipt.AddressLineOne.ShouldEqual(_customer.Address.LineOne);

	It should_return_a_receipt_with_address_line_2 = () =&gt; _orderReceipt.AddressLineTwo.ShouldEqual(_customer.Address.LineTwo);
		
	It should_return_a_receipt_with_city = () =&gt; _orderReceipt.City.ShouldEqual(_customer.Address.City);

	It should_return_a_receipt_with_state = () =&gt; _orderReceipt.State.ShouldEqual(_customer.Address.State);

	It should_return_a_receipt_with_zip = () =&gt; _orderReceipt.ZipCode.ShouldEqual(_customer.Address.ZipCode);
}</pre>

<center>
  <b><font size="1">Listing 1</font></b>
</center>

While the specification in listing 1 provides ample detail about the values that should be present on the returned receipt, such an implementation precludes reuse and tends to overwhelm the purpose of the specification. This problem is further compounded as the composition complexity increases.

As an alternative to declaring what each field of a particular object should contain, the Expected Object pattern allows you to declare what a particular object _should look like_. By replacing the specification’s discrete assertions with a single assertion comparing an Expected Object against a resulting state, the essence of the specification can be preserved while maintaining an equivalent level of verification.

Consider the following simple implementation for an Expected Object:

<pre class="prettyprint">class ExpectedOrderReceipt : OrderReceipt
{
	public override bool Equals(object obj)
	{
		var otherReceipt = obj as OrderReceipt;

		return OrderNumber.Equals(otherReceipt.OrderNumber) &&
			    CustomerId.Equals(otherReceipt.CustomerId) &&
			    CustomerName.Equals(otherReceipt.CustomerName) &&
			    CustomerPhone.Equals(otherReceipt.CustomerPhone) &&
			    AddressLineOne.Equals(otherReceipt.AddressLineOne) &&
			    AddressLineTwo.Equals(otherReceipt.AddressLineTwo) &&
			    City.Equals(otherReceipt.City) &&
			    State.Equals(otherReceipt.State) &&
			    ZipCode.Equals(otherReceipt.ZipCode) &&
			    Orders.ToList().SequenceEqual(otherReceipt.Orders);
	}
}</pre>

<center>
  <b><font size="1">Listing 2</font></b>
</center>

Establishing an instance of the expected object in listing 2 allows the previous discrete assertions to be replaced with a single assertion declaring what the returned receipt should look like:

<pre class="prettyprint">[Subject(typeof (OrderService))]
public class when_an_order_is_placed : WithSubject&lt;OrderService&gt;
{
	const long OrderNumber = 1L;
	static readonly Guid CustomerId = new Guid("061F3CED-405F-4261-AF8C-AA2B0694DAD8");
	static Customer _customer;
	static ExpectedOrderReceipt _expectedOrderReceipt;
	static Order _order;
	static OrderReceipt _orderReceipt;


	Establish context = () =&gt;
		{
			_customer = new TestCustomer(CustomerId)
				            {
				            	FirstName = "First",
				            	LastName = "Last",
				            	PhoneNumber = "5129130000",
				            	Address = new Address
				            		        {
				            		          	LineOne = "123 Street",
				            		          	LineTwo = string.Empty,
				            		          	City = "Austin",
				            		          	State = "TX",
				            		          	ZipCode = "78717"
				            		        }
				            };
			For&lt;IOrderNumberProvider&lt;long&gt;&gt;().Setup(x =&gt; x.GetNext()).Returns(OrderNumber);
			For&lt;ICustomerRepository&gt;().Setup(x =&gt; x.Get(Parameter.IsAny&lt;Guid&gt;())).Returns(_customer);
			_order = new Order(1, "Product A");

			_expectedOrderReceipt = new ExpectedOrderReceipt
				                        {
				                        	OrderNumber = OrderNumber.ToString(),
				                        	CustomerName = "First Last",
				                        	CustomerPhone = "5129130000",
				                        	AddressLineOne = "123 Street",
				                        	AddressLineTwo = string.Empty,
				                        	City = "Austin",
				                        	State = "TX",
				                        	ZipCode = "78717",
				                        	CustomerId = CustomerId.ToString(),
				                        	Orders = new List&lt;Order&gt; {_order}
				                        };
		};

	Because of = () =&gt; _orderReceipt = Subject.PlaceOrder(_order, _customer.Id);

	It should_return_an_receipt_with_shipping_information_and_order_number =
		() =&gt; _expectedOrderReceipt.Equals(_orderReceipt).ShouldBeTrue();
}</pre>

<center>
  <b><font size="1">Listing 3</font></b>
</center>

The implementation strategy in listing 3 offers a subtle shift in perspective, but one which may more closely model the language of the business.

This is not to say that discrete assertions are always wrong. The level of detail modeled by an application’s specifications should be based upon the needs of the business. Consider the test runner output for both implementations:

[<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="ExpectedObjectContrast" border="0" alt="ExpectedObjectContrast" src="http://lostechies.com/derekgreer/files/2011/06/ExpectedObjectContrast_thumb.png" width="668" height="278" />](http://lostechies.com/derekgreer/files/2011/06/ExpectedObjectContrast.png) 

<font size="1"><b>Figure 1</b> </font>

Examining the results of executing both specifications in figure 1, we see that the first describes each field being validated, while the second describes what the validations of these fields collectively mean. Which is best will depend upon your particular business needs. While the first implementation provides a more detailed specification of the receipt, this may or may not be as important to the business as knowing that the receipt as a whole is correct. For example, consider if the order number were missing. Is the correct perspective that the receipt is 90% correct or 100% wrong? The correct answer is … it depends.

## Explicit Feedback

While the Expected Object implementation shown in listing 2 may be an adequate approach in some cases, it does have the shortcoming of not providing explicit feedback of how the two objects differ. To address this, we can implement our Expected Object as a [Custom Assertion](http://lostechies.com/derekgreer/2011/06/11/effective-tests-custom-assertions/). Instead of asserting on the return value of comparing the expected object to an object returned from our system, we can design the Expected Object to throw an exception detailing what state differed between the two objects. The following listing demonstrates this approach: 

<pre class="prettyprint">class ExpectedOrderReceipt : OrderReceipt
{
	public void ShouldEqual(object obj)
	{
		var otherReceipt = obj as OrderReceipt;
		var messages = new List&lt;string&gt;();

		if (!OrderNumber.Equals(otherReceipt.OrderNumber))
			messages.Add(string.Format("For OrderNumber, expected '{0}' but found '{1}'", OrderNumber, otherReceipt.OrderNumber));

		if (!CustomerId.Equals(otherReceipt.CustomerId))
			messages.Add(string.Format("For CustomerId, expected '{0}' but found '{1}'", CustomerId, otherReceipt.CustomerId));

		if (!CustomerName.Equals(otherReceipt.CustomerName))
			messages.Add(string.Format("For CustomerName, expected '{0}' but found '{1}'", CustomerName, otherReceipt.CustomerName));

		if (!CustomerPhone.Equals(otherReceipt.CustomerPhone))
			messages.Add(string.Format("For CustomerPhone, expected '{0}' but found '{1}'", CustomerPhone, otherReceipt.CustomerPhone));

		if (!AddressLineOne.Equals(otherReceipt.AddressLineOne))
			messages.Add(string.Format("For AddressLineOne, expected '{0}' but found '{1}'", AddressLineOne, otherReceipt.AddressLineOne));

		if (!AddressLineTwo.Equals(otherReceipt.AddressLineTwo))
			messages.Add(string.Format("For AddressLineTwo, expected '{0}' but found '{1}'", AddressLineTwo, otherReceipt.AddressLineOne));

		if (!City.Equals(otherReceipt.City))
			messages.Add(string.Format("For City, expected '{0}' but found '{1}'", City, otherReceipt.City));

		if (!State.Equals(otherReceipt.State))
			messages.Add(string.Format("For State, expected '{0}' but found '{1}'", State, otherReceipt.State));

		if (!ZipCode.Equals(otherReceipt.ZipCode))
			messages.Add(string.Format("For ZipCode, expected '{0}' but found '{1}'", ZipCode, otherReceipt.ZipCode));

		if (!Orders.ToList().SequenceEqual(otherReceipt.Orders))
			messages.Add("For Orders, expected the same sequence but was different.");

		if(messages.Count &gt; 0)
			throw new Exception(string.Join(Environment.NewLine, messages));
	}
}</pre>

<center>
  <b><font size="1">Listing 4</font></b>
</center>

The following listing shows the specification modified to use the new Expected Object implementation with several values on the TestCustomer modified to return values differing from the expected value: 

<pre class="prettyprint">[Subject(typeof (OrderService))]
public class when_an_order_is_placed : WithSubject&lt;OrderService&gt;
{
	const long OrderNumber = 1L;
	static readonly Guid CustomerId = new Guid("061F3CED-405F-4261-AF8C-AA2B0694DAD8");
	static Customer _customer;
	static ExpectedOrderReceipt _expectedOrderReceipt;
	static Order _order;
	static OrderReceipt _orderReceipt;


	Establish context = () =&gt;
		{
			_customer = new TestCustomer(CustomerId)
				            {
				            	FirstName = "Wrong",
				            	LastName = "Wrong",
				            	PhoneNumber = "Wrong",
				            	Address = new Address
				            		        {
				            		          	LineOne = "Wrong",
				            		          	LineTwo = "Wrong",
				            		          	City = "Austin",
				            		          	State = "TX",
				            		          	ZipCode = "78717"
				            		        }
				            };
			For&lt;IOrderNumberProvider&lt;long&gt;&gt;().Setup(x =&gt; x.GetNext()).Returns(OrderNumber);
			For&lt;ICustomerRepository&gt;().Setup(x =&gt; x.Get(Parameter.IsAny&lt;Guid&gt;())).Returns(_customer);
			_order = new Order(1, "Product A");

			_expectedOrderReceipt = new ExpectedOrderReceipt
				                        {
				                        	OrderNumber = OrderNumber.ToString(),
				                        	CustomerName = "First Last",
				                        	CustomerPhone = "5129130000",
				                        	AddressLineOne = "123 Street",
				                        	AddressLineTwo = string.Empty,
				                        	City = "Austin",
				                        	State = "TX",
				                        	ZipCode = "78717",
				                        	CustomerId = CustomerId.ToString(),
				                        	Orders = new List&lt;Order&gt; {_order}
				                        };
		};

	Because of = () =&gt; _orderReceipt = Subject.PlaceOrder(_order, _customer.Id);

	It should_return_an_receipt_with_shipping_and_order_information = () =&gt; _expectedOrderReceipt.ShouldEqual(_orderReceipt);
}</pre>

<center>
  <b><font size="1">Listing 5</font></b>
</center>

Running the specification produces the following output:

[<img style="background-image: none; border-right-width: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" title="ExpectedObjectExplicitFeedback" border="0" alt="ExpectedObjectExplicitFeedback" src="http://lostechies.com/derekgreer/files/2011/06/ExpectedObjectExplicitFeedback_thumb.png" width="639" height="91" />](http://lostechies.com/derekgreer/files/2011/06/ExpectedObjectExplicitFeedback.png)   
**<font size="1">Figure 2</font>** 

## Conclusion

This time, we took a look at the Expected Object pattern which aids in reducing code duplication, eliminating the need to put test-specific equality behavior in our production code and serves as a strategy for further clarifying the intent of our specifications. Next time, we’ll look at some strategies for combating obscurity and test-code duplication caused by test data.
