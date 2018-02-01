---
id: 514
title: 'Effective Tests: Avoiding Context Obscurity'
date: 2011-07-19T01:06:51+00:00
author: Derek Greer
layout: post
guid: http://lostechies.com/derekgreer/?p=514
dsq_thread_id:
  - "361992940"
categories:
  - Uncategorized
tags:
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
      Effective Tests: Avoiding Context Obscurity
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/09/05/effective-tests-acceptance-tests/">Effective Tests: Acceptance Tests</a>
    </li>
  </ul>
</div>

In the [last](http://lostechies.com/derekgreer/2011/06/24/effective-tests-expected-objects/) installment of our series, we looked at the Expected Object pattern as a way to reduce code duplication, eliminate the need to add test-specific equality concerns to production code and to aid in clarifying the intent of our tests. This time we’ll take a look at some practices and techniques for avoiding context obscurity.

## Context Obscurity

Validating the behavior of a system generally requires instantiating the System Under Test along with the setup of various dependencies and/or parameter objects which serve to define the context for the system’s execution. When the essential context is not discernible from the test implementation, this results in _Context Obscurity_.

## Context Obscurity Causes

The following sections list some of the main causes of context obscurity.

### Incidental Context

The setup needs for a test often includes information necessary for the behavior’s execution, yet irrelevant to the behavior being validated. For example, a given component may require a logging dependency to be supplied for instantiation, but the behavior being tested may have nothing to do with whether the component logs information or not. These type of setup concerns lead to Incidental Context which can affect the clarity of the test.

Consider the following specification for a payment gateway component which validates that an exception is thrown when the system is asked to process a payment containing an expired credit card:

<pre class="prettyprint">public class when_processing_a_payment_with_an_expired_credit_card
{
  static Exception _exception;
  static PaymentGateway _paymentGateway;
  static PaymentInformation _paymentInformation;
  static Mock&lt;ILoggger&gt; _nullLogger;
  static Mock&lt;IPaymentProvider&gt; _stubPaymentProvider;

  Establish context = () =&gt;
  {
    _nullLogger = new Mock&lt;ILoggger&gt;();
    _stubPaymentProvider = new Mock&lt;IPaymentProvider&gt;();
    _stubPaymentProvider.Setup(x =&gt; x.ProcessPayment(Parameter.IsAny&lt;Payment&gt;()))
      .Returns(new PaymentReceipt
          {
          ReceiptId = "12345",
          ChargeAmount = 300.00m,
          CardType = "Visa",
          CardLastFour = "1111",
          VenderId = "FF26AA123"

          });
    _paymentGateway = new PaymentGateway(_stubPaymentProvider.Object, _nullLogger.Object);

    _paymentInformation = new PaymentInformation
    {
      Amount = 300.00m,
             CreditCardNumber = "41111111111111",
             CreditCardType = CardType.Visa,
             ExpirationDate = Date.Today.Subtract(TimeSpan.FromDays(1)),
             CardHolderName = "John P. Doe",
             BillingAddress = new Address
             {
               Name = "John Doe",
               AddressLineOne = "123 Street",
               City = "Springfield",
               StateCode = "MO",
               Zipcode = "65807"
             }
    };
  };

  Because of = () =&gt; _exception = Catch.Exception(() =&gt; _paymentGateway.Process(_paymentInformation));

  It should_throw_an_expired_card_exception = () =&gt; _exception.ShouldBeOfType&lt;ExpiredCardException&gt;();
}
</pre>

<center>
  <b><font size="1">Listing 1</font></b>
</center>

While the specification in listing 1 only validates that an error occurs when an expired credit card is provided, there is quite a bit of set up necessary for the specification’s execution. Since the only information relevant to understanding how the system fulfills this behavior is how the PaymentGateway type is called, the value of the expiration date and the expected result, the majority of the setup is incidental to the modeling of the specification leading to to a low signal to noise ratio.

### Lack of Cohesion

Another source of incidental context can occur when a System Under Test lacks _Cohesion_. Cohesion can be defined as the functional relatedness of a module. When a module serving as the System Under Test lacks cohesion (i.e. has multiple unrelated responsibilities), this can result in the need to setup dependencies which are never used by the area of concern being exercised by the test.

Consider the following specification which verifies that related product information is returned when a customer requests the details for a product:

<pre class="prettyprint">public class when_the_customer_requests_product_information
{
  static readonly Guid ProductId = new Guid("BD1F1F9A-85BC-48B9-95B5-0CA8219A97A1");
  static readonly Guid RelatedProductId = new Guid("C363577B-1720-43C1-93D9-2C9F239B3D52");
  static Mock&lt;IAuditService&gt; _auditServiceStub;
  static Mock&lt;IOrderHistoryRepository&gt; _orderHistoryRepositoryStub;
  static Mock&lt;IOrderReturnService&gt; _orderReturnServiceStub;
  static Mock&lt;IProductHistoryRepository&gt; _productHistoryRepositoryStub;
  static ProductInformation _productInformation;
  static Mock&lt;IProductRepository&gt; _productRepositoryStub;
  static ProductService _productService;

  Establish context = () =&gt;
  {
    _auditServiceStub = new Mock&lt;IAuditService&gt;();
    _productHistoryRepositoryStub = new Mock&lt;IProductHistoryRepository&gt;();
    _orderHistoryRepositoryStub = new Mock&lt;IOrderHistoryRepository&gt;();
    _orderReturnServiceStub = new Mock&lt;IOrderReturnService&gt;();
    _productRepositoryStub = new Mock&lt;IProductRepository&gt;();

    _productRepositoryStub.Setup(x =&gt; x.Get(ProductId)).Returns(new Product(ProductId, "Product description", 20.00m));
    _productRepositoryStub.Setup(x =&gt; x.GetRelatedProducts(ProductId))
      .Returns(new List&lt;Product&gt;
          {
          new Product(RelatedProductId,
              "Related product description",
              30.10m)
          });

    _productService = new ProductService(_auditServiceStub.Object, _productHistoryRepositoryStub.Object,
        _orderHistoryRepositoryStub.Object, _orderReturnServiceStub.Object,
        _productRepositoryStub.Object);
  };

  Because of = () =&gt; _productInformation = _productService.GetProductInformation(ProductId);

  It should_return_related_products = () =&gt; _productInformation.RelatedProducts.ShouldNotBeEmpty();
}
</pre>

<center>
  <b><font size="1">listing 2</font></b>
</center>

The ProductService class in listing 2 fulfills a number of responsibilities including those dealing with related order history, product returns and various auditing needs. Though the specification is only concerned with verifying that related product information is retrieved, a number of unused test doubles are required to instantiate a ProductService instance which may lead to a false assumption about the role these dependencies play in behavior being validated.

### Missing Context

In some cases, setup code may be factored out of a concrete test implementation to enable reuse by other tests, or perhaps merely to reduce the visible amount of setup code being used. This practice obscures the context of the test when all of the information necessary for understanding how the system is used to facilitate the expected behavior isn’t discernible.

Consider the following variation on the expired credit card specification:

<pre class="prettyprint">public class when_processing_a_payment_with_an_expired_credit_card : PaymentContext
{
  static Exception _exception;

  Because of = () =&gt; _exception = Catch.Exception(() =&gt; PaymentGateway.Process(PaymentInformation));

  It should_throw_an_expired_card_exception = () =&gt; _exception.ShouldBeOfType&lt;ExpiredCardException&gt;();
}
</pre>

<center>
  <b><font size="1">listing 3</font></b>
</center>

While this implementation doesn’t overwhelm its reader with incidental or non-cohesive setup needs, key pieces of information for understanding how the system is used to achieve the expected behavior are missing, namely, the type information for the key objects used and the input values necessary to trigger the expected behavior.

## Guidelines for Avoiding Obscurity

To avoid writing obscure tests, information pertinent to understanding how the system is used to achieve the expected behavior should be discernible within the test’s concrete implementation. While what’s considered pertinent is somewhat subjective, the following are some guidelines for helping to avoid obscure tests:

  * Ensure the type of the System Under Test is discernible.
  * Ensure the input and return parameter types used by the methods being exercised are discernible.
  * Ensure all collaborating test double types and setup which are consequential to the behavior being validated is discernible.
  * Ensure all direct and indirect input values which are consequential to the behavior being validated are discernible.
  * Minimize any setup which is incidental to understanding the behavior being validated.
  * Refactor system components whose behavior results in setup needs unrelated to the area of concern being tested.

## Strategies for Avoiding Obscurity

### Base Fixtures

As previously noted, context obscurity can result from including both too much or too little context information. One strategy which can both cause or help to alleviate context obscurity is the use of _Base Fixtures_. Base fixtures are types which define setup and/or behavior which may be inherited by one or more concrete test cases. Base fixtures are commonly used to eliminate duplication across multiple test cases sharing the same context, but this often leads to obscurity due to the absence of setup information essential to understanding the derived test cases. Unlike the role stereotypes of other objects within a system, the role of executable specifications is to _model the requirements of the system_. The use of design principles and programming language capabilities should therefore be subjugated to this purpose.

One use of base fixtures which can reduce incidental context while preserving relevant context is the use of generic base fixtures. Establishing the System Under Test often requires the setup of test doubles to be used in the object’s instantiation. While any test double configuration needed for understanding a particular behavior of the system should be declared by the verifying test case, the instantiation of the System Under Test and any parameters needed are generally not pertinent to the test case. By allowing derived test cases to specify the type of the System Under Test as a generic parameter to the base fixture and providing methods for accessing any test doubles for unique setup needs, the non-essential portions of the context setup can be removed from the deriving test cases. This technique was demonstrated earlier in this series in the article [Effective Tests: Auto-mocking Containers](http://lostechies.com/derekgreer/2011/05/31/effective-tests-auto-mocking-containers/). 

As a review, the following listing shows a base fixture which defines common code for setting up an auto-mocking container along with methods for configuring any test doubles used:

<pre class="prettyprint">public abstract class WithSubject&lt;T&gt; where T : class
{
  protected static AutoMockContainer Container;
  protected static T Subject;

  Establish context = () =&gt;
  {
    Container = new AutoMockContainer(new MockFactory(MockBehavior.Loose));
    Subject = Container.Create&lt;T&gt;();
  };

  protected static Mock&lt;TDouble&gt; For&lt;TDouble&gt;() where TDouble : class
  {
    return Container.GetMock&lt;TDouble&gt;();
  }
}
</pre>

<center>
  <b><font size="1">listing 4</font></b>
</center>

Given this base fixture, the following specification can be derived which specifies the type of the System Under Test without including the ancillary concerns of setting up the Auto-mocking container or any Test Dummies required:

<pre class="prettyprint">public class when_displaying_part_details : WithSubject&lt;DisplayPartDetailsAction&gt;
{
  const string PartId = "12345";

  Because of = () =&gt; Subject.Display(PartId);

  It should_retrieve_the_part_information_from_the_cache =
    () =&gt; For&lt;ICachingService&gt;().Verify(x =&gt; x.RetrievePartDetails(PartId), Times.Exactly(1));
}
</pre>

<center>
  <b><font size="1">listing 5</font></b>
</center>

Base fixtures can be a benefit or a detriment to the clarity of our tests. When used, care should be taken to ensure the context of each deriving test case can be understood without needing to consult its base fixture.

### Object Mothers

One of the specific types of setup needs which can lead to obscurity is the setup of test data. It is often necessary to construct test data objects to be used as either parameters, test stub values, or expected objects which can begin to dilute the clarity of a test as such needs increase. In some cases, the actual test data values aren’t pertinent to the subject of the test (e.g. an application submitted after the deadline), or a meaningful configuration of test data values can be abstracted into logical, well-known entities (e.g. a valid application). In such cases, the setup of test data can be delegated to an _Object Mother_. An Object Mother is a specialized factory whose role is to create canned test data objects.

The following demonstrates an Object Mother which provides canned Order objects:

<pre class="prettyprint">public static class OrderObjectMother
{
  public static Order CreateOrder()
  {
    var cart = new Cart();
    cart.AddItem(new Guid(), 2);
    var billingInformation = new BillingInformation
    {
      BillingAddress = new Address
      {
        Name = "John Doe",
             AddressLineOne = "123 Street",
             City = "Springfield",
             StateCode = "MO",
             Zipcode = "65807"
      },
        CreditCardNumber = "41111111111111",
        CreditCardType = CardType.Visa,
        ExpirationDate = Date.Today.Subtract(TimeSpan.FromDays(1)),
        CardHolderName = "John P. Doe",
    };

    var shippingInformation = new ShippingInformation(billingInformation);

    return new Order(cart, billingInformation, shippingInformation);
  }
}
</pre>

<center>
  <b><font size="1">listing 6</font></b>
</center>

Note that the CreateOrder() method is required to create several intermediate objects to build up an instance of the Order object. If these intermediate objects are required by other specifications, these might be factored out into their own Object Mother factories.

By delegating the creation of an Order object to the Object Mother in listing 6, the following specification can be implemented with minimal visible context setup while preserving the essence of the declared context information:

<pre class="prettyprint">public class when_placing_a_valid_order : WithSubject&lt;OrderService&gt;
{
  static Order _order;
  static OrderReceipt _receipt;

  Establish context = () =&gt; _order = OrderObjectMother.CreateOrder();

  Because of = () =&gt; _receipt = Subject.PlaceOrder(_order);

  It should_return_the_order_number = () =&gt; _receipt.OrderNumber.ShouldNotBeNull();
}
</pre>

<center>
  <b><font size="1">listing 7</font></b>
</center>

Since the specification in listing 7 concerns what happens when a valid order is placed rather than what constitutes a valid order, there is no need to show the values contained by the Order object created.

If a variation of the object is needed, new methods can be added to the Object Mother to denote the variation. The following specification assumes the existence of an additional factory method used to validate behavior associated with invalid orders:

<pre class="prettyprint">public class when_placing_an_invalid_order : WithSubject&lt;OrderService&gt;
{
  static Exception _exception;
  static Order _invalidOrder;

  Establish context = () =&gt; _invalidOrder = OrderObjectMother.CreateInvalidOrder();

  Because of = () =&gt; _exception = Catch.Exception(() =&gt; Subject.PlaceOrder(_invalidOrder));

  It should_throw_an_invalid_order_exception = () =&gt; _exception.ShouldBeOfType&lt;InvalidOrderException&gt;();
}
</pre>

<center>
  <b><font size="1">listing 8</font></b>
</center>

### Test Builders

While Object Mothers provide a nice way to retrieve canned test data, they don’t present an elegant way to deal with variability. For cases where a number of variations of the test data are needed, or when a subset of the values required for setting up test data objects are relevant to the declaring test case, the test data objects can be created using _Test Builders_. Test Builders are based upon the Builder pattern which creates objects based upon the accumulation of information from successive method calls terminated by a final construction method.

The following demonstrates a Test Builder for creating variations of an Order object:

<pre class="prettyprint">public class OrderBuilder
{
  readonly BillingInformation _billingInformation;
  readonly ShippingInformation _shippingInformation;
  Cart _cart;

  public OrderBuilder()
  {
    _cart = new Cart();
    _cart.AddItem(new Guid(), 2);

    _billingInformation = new BillingInformation
    {
      BillingAddress = new Address
      {
        Name = "John Doe",
             AddressLineOne = "123 Street",
             City = "Springfield",
             StateCode = "MO",
             Zipcode = "65807"
      },
        CreditCardNumber = "41111111111111",
        CreditCardType = CardType.Visa,
        ExpirationDate = Date.Today.Subtract(TimeSpan.FromDays(1)),
        CardHolderName = "John P. Doe",
    };

    _shippingInformation = new ShippingInformation(_billingInformation);
  }

  public OrderBuilder WithCreditCardNumber(string creditCardNumber)
  {
    _billingInformation.CreditCardNumber = creditCardNumber;
    return this;
  }

  public OrderBuilder WithExpirationDate(Date expirationDate)
  {
    _billingInformation.ExpirationDate = expirationDate;
    return this;
  }

  public OrderBuilder WithCreditCardType(CardType cardType)
  {
    _billingInformation.CreditCardType = cardType;
    return this;
  }

  public OrderBuilder WithCardHolderName(string cardHolderName)
  {
    _billingInformation.CardHolderName = cardHolderName;
    return this;
  }

  public OrderBuilder WithCart(Cart cart)
  {
    _cart = cart;
    return this;
  }

  public Order Build()
  {
    return new Order(_cart, _billingInformation, _shippingInformation);
  }
}
</pre>

<center>
  <b><font size="1">listing 9</font></b>
</center>

The following specification demonstrates how the Test Builder in listing 9 might be used to validate the results of placing an order with an invalid credit card:

<pre class="prettyprint">public class when_placing_an_order_with_an_invalid_credit_card : WithSubject&lt;OrderService&gt;
{
  static Exception _exception;
  static Order _invalidOrder;

  Establish context = () =&gt; _invalidOrder = new OrderBuilder()
    .WithCreditCardNumber("12345")
    .Build();

  Because of = () =&gt; _exception = Catch.Exception(() =&gt; Subject.PlaceOrder(_invalidOrder));


  It should_throw_an_invalid_credit_card_exception = () =&gt; _exception.ShouldBeOfType&lt;InvalidCreditCardException&gt;();
}
</pre>

<center>
  <b><font size="1">listing 10</font></b>
</center>

## Conclusion

In this article, we considered several causes of context obscurity and discussed a few ways of avoiding it. Next time, we’ll move on to the topic of writing automated acceptance tests.
