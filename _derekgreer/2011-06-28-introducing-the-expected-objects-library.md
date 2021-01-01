---
wordpress_id: 511
title: Introducing the Expected Objects Library
date: 2011-06-28T23:20:17+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=511
dsq_thread_id:
  - "344761418"
categories:
  - Uncategorized
tags:
  - Expected Object Pattern
  - Testing
---
{% raw %}
Introduced in the [Effective Test Series](https://lostechies.com/derekgreer/2011/03/07/effective-tests-introduction/), the [Expected Object](https://lostechies.com/derekgreer/2011/06/24/effective-tests-expected-objects/) pattern is a technique involving the encapsulation of test-specific logic within a specialized type designed to compare its configured state against that of another object. Use of the Expected Object pattern eliminates the need to encumber system objects with test-specific equality behavior, helps to reduce test code duplication and can aid in expressing the logical intent of automated tests.

While the Expected Object pattern is a great strategy for helping adhere to good testing practices, the process of actually implementing the required types can be less than motivating. To alleviate the burden of hand-rolling Expected Object types, I created the [Expected Objects](http://nuget.org/List/Packages/ExpectedObjects) library. This library provides the ability to compare the state of one object against another without relying upon the provided type’s equality members. In addition to the ability to assert equality, the library also provides equality assertion methods which provide feedback of how each member of an object differs from an expected state.

The following examples demonstrate the capabilities of the library:

### &nbsp;

### Comparing Flat Objects

```C#
public class when_retrieving_a_customer
{
  static Customer _actual;
  static ExpectedObject _expected;

  Establish context = () =>
    {
      _expected = new Customer
                    {
                      Name = "Jane Doe",
                      PhoneNumber = "5128651000"
                    }.ToExpectedObject();

      _actual = new Customer
                  {
                    Name = "John Doe",
                    PhoneNumber = "5128654242"
                  };
    };

  It should_return_the_expected_customer = () => _expected.ShouldEqual(_actual);
}



class Customer
{
  public string Name { get; set; }
  public string PhoneNumber { get; set; }
}
```

Results:

<pre><div style="overflow: auto; border-bottom: black 1px solid; text-align: left; border-left: black 1px solid; padding-bottom: 5px; background-color: #fcc; padding-left: 5px; padding-right: 5px; border-collapse: collapse; border-top: black 1px solid; border-right: black 1px solid">
  <b>should return the expected customer : Failed</b>
  For Customer.Name, expected "Jane Doe" but found "John Doe".
  For Customer.PhoneNumber, expected "5128651000" but found "5128654242". 
  
</div>
</pre>

### &nbsp;

### Comparing Composed Objects

```C#
public class when_retrieving_a_customer_with_address
{
  static Customer _actual;
  static ExpectedObject _expected;

  Establish context = () =>
    {
      _expected = new Customer
                    {
                      Name = "Jane Doe",
                      PhoneNumber = "5128651000",
                      Address = new Address
                                  {
                                    AddressLineOne = "123 Street",
                                    AddressLineTwo = string.Empty,
                                    City = "Austin",
                                    State = "TX",
                                    Zipcode = "78717"
                                  }
                    }.ToExpectedObject();

      _actual = new Customer
                  {
                    Name = "John Doe",
                    PhoneNumber = "5128654242",
                    Address = new Address
                                {
                                  AddressLineOne = "456 Street",
                                  AddressLineTwo = "Apt. 3",
                                  City = "Waco",
                                  State = "TX",
                                  Zipcode = "76701"
                                }
                  };
    };

  It should_return_the_expected_customer = () => _expected.ShouldEqual(_actual);
}



class Customer
{
  public string Name { get; set; }
  public string PhoneNumber { get; set; }
  public Address Address { get; set; }
}



class Address
{
  public string AddressLineOne { get; set; }
  public string AddressLineTwo { get; set; }
  public string City { get; set; }
  public string State { get; set; }
  public string Zipcode { get; set; }
}
```

Results:

<pre><div style="overflow: auto; border-bottom: black 1px solid; text-align: left; border-left: black 1px solid; padding-bottom: 5px; background-color: #fcc; padding-left: 5px; padding-right: 5px; border-collapse: collapse; border-top: black 1px solid; border-right: black 1px solid">
  <b>should return the expected customer : Failed</b>
  For Customer.Name, expected "Jane Doe" but found "John Doe". 
  For Customer.PhoneNumber, expected "5128651000" but found "5128654242". 
  For Customer.Address.AddressLineOne, expected "123 Street" but found "456 Street". 
  For Customer.Address.AddressLineTwo, expected "" but found "Apt. 3". 
  For Customer.Address.City, expected "Austin" but found "Waco". 
  For Customer.Address.Zipcode, expected "78717" but found "76701".
  
</div>
</pre>

### &nbsp;

### Comparing Collections

```C#
public class when_retrieving_a_collection_of_customers
{
  static List&lt;Customer> _actual;
  static ExpectedObject _expected;

  Establish context = () =>
    {
      _expected = new List&lt;Customer>
                    {
                      new Customer {Name = "Customer A"},
                      new Customer {Name = "Customer B"}
                    }.ToExpectedObject();

      _actual = new List&lt;Customer>
                  {
                    new Customer {Name = "Customer A"},
                    new Customer {Name = "Customer C"}
                  };
    };

  It should_return_the_expected_customers = () => _expected.ShouldEqual(_actual);
}
```

Results:

<pre><div style="overflow: auto; border-bottom: black 1px solid; text-align: left; border-left: black 1px solid; padding-bottom: 5px; background-color: #fcc; padding-left: 5px; padding-right: 5px; border-collapse: collapse; border-top: black 1px solid; border-right: black 1px solid">
  <b>should return the expected customers : Failed</b>
  For List`1[1].Name, expected "Customer B" but found "Customer C". 
</div>
</pre>

### &nbsp;

### Comparing Dictionaries

```C#
public class when_retrieving_a_dictionary
{
  static IDictionary&lt;string, string> _actual;
  static IDictionary&lt;string, string> _expected;

  static bool _result;

  Establish context = () =>
    {
      _expected = new Dictionary&lt;string, string> {{"key1", "value1"}};
      _actual = new Dictionary&lt;string, string> {{"key1", "value1"}, {"key2", "value2"}};
    };

  It should_return_the_expected_dictionary = () => _expected.ToExpectedObject().ShouldEqual(_actual);
}
```

Results:

<pre><div style="overflow: auto; border-bottom: black 1px solid; text-align: left; border-left: black 1px solid; padding-bottom: 5px; background-color: #fcc; padding-left: 5px; padding-right: 5px; border-collapse: collapse; border-top: black 1px solid; border-right: black 1px solid">
  <b>should return the expected dictionary : Failed</b>
  For Dictionary`2[1], expected nothing but found [[key2, value2]]. 
</div>
</pre>

### &nbsp;

### Comparing Types with Indexes

```C#
public class when_retrieving_a_type_with_an_index
{
  static IndexType&lt;int> _actual;
  static IndexType&lt;int> _expected;

  static bool _result;

  Establish context = () =>
    {
      _expected = new IndexType&lt;int>(new List&lt;int> {1, 2, 3, 4, 6});
      _actual = new IndexType&lt;int>(new List&lt;int> {1, 2, 3, 4, 5});
    };

  It should_return_the_expected_type = () => _expected.ToExpectedObject().ShouldEqual(_actual);
}



class IndexType&lt;T>
{
  readonly IList&lt;T> _ints;

  public IndexType(IList&lt;T> ints)
  {
    _ints = ints;
  }

  public T this[int index]
  {
    get { return _ints[index]; }
  }

  public int Count
  {
    get { return _ints.Count; }
  }
}
```

Results:

<pre><div style="overflow: auto; border-bottom: black 1px solid; text-align: left; border-left: black 1px solid; padding-bottom: 5px; background-color: #fcc; padding-left: 5px; padding-right: 5px; border-collapse: collapse; border-top: black 1px solid; border-right: black 1px solid">
  <b>should return the expected type : Failed</b>
  For IndexType`1.Item[4], expected [6] but found [5]. 
</div>
</pre>

### &nbsp;

### Comparing Partial Objects

```C#
public class when_retrieving_a_customer
{
  static Customer _actual;
  static ExpectedObject _expected;

  Establish context = () =>
    {
      _expected = new
                    {
                      Name = "Jane Doe",
                      Address = new
                                  {
                                    City = "Austin"
                                  }
                    }.ToExpectedObject();

      _actual = new Customer
                  {
                    Name = "John Doe",
                    PhoneNumber = "5128654242",
                    Address = new Address
                                {
                                  AddressLineOne = "456 Street",
                                  AddressLineTwo = "Apt. 3",
                                  City = "Waco",
                                  State = "TX",
                                  Zipcode = "76701"
                                }
                  };
    };

  It should_have_the_correct_name_and_address = () => _expected.ShouldMatch(_actual);
}
```

Results: 

<pre><div style="overflow: auto; border-bottom: black 1px solid; text-align: left; border-left: black 1px solid; padding-bottom: 5px; background-color: #fcc; padding-left: 5px; padding-right: 5px; border-collapse: collapse; border-top: black 1px solid; border-right: black 1px solid">
  <b>should have the correct name and address : Failed</b>
  For Customer.Name, expected "Jane Doe" but found "John Doe".
  For Customer.Address.City, expected "Austin" but found "Waco".
  </pre>
  
  
  <h3>
    &nbsp;
  </h3>
  
  
  <h2>
    Extensibility
  </h2>
  
  
  <p>
    The Expected Objects library is extensible, so if it doesn’t provide the exact comparison strategies you need then you’re free to add our own.
  </p>
  
  
  <p>
    The main extensibility point is the IComparisonStrategy which is declared as follows:
  </p>
  
  
```C#
public interface IComparisonStrategy
{
    bool CanCompare(Type type);
    bool AreEqual(object expected, object actual, IComparisonContext comparisonContext);
}
```
  
  
  <p>
    To register a custom strategy, simply call the Configure() method and use the supplied ConfigurationContext to call the PushStrategy<t>() method:
  </p>
  
  
  <pre class="prettyprint">
_expected = new Foo("Bar")
  .ToExpectedObject()
  .Configure(ctx => ctx.PushStrategy&lt;FooComparisonStrategy>());
</pre>
  
  
  <p>
    This will push the custom strategy onto the stack used by the Expected Objects library during its comparisons.
  </p>
  
  
  <h2>
    Custom Comparison Strategy Example
  </h2>
  
  
  <p>
    The following demonstrates how the Expected Objects library could be extended to compare an expected object to the contents of a Web page.
  </p>
  
  
  <p>
    Consider the following specification:
  </p>
  
  
```C#
public class when_displaying_the_customer_view
{
  static Mock&lt;IWebDriver> _actual;
  static ExpectedObject _expected;

  Establish context = () =>
    {
      var nameElementStub = new Mock&lt;IWebElement>();
      nameElementStub.Setup(x => x.Text).Returns("Jane Doe");
      var addressElementStub = new Mock&lt;IWebElement>();
      addressElementStub.Setup(x => x.Text).Returns("456 Street");
      var buttonElementStub = new Mock&lt;IWebElement>();
      buttonElementStub.Setup(x => x.Text).Returns("Cancel");
      _actual = new Mock&lt;IWebDriver>();
      _actual.Setup(x => x.FindElement(By.Id("name"))).Returns(nameElementStub.Object);
      _actual.Setup(x => x.FindElement(By.CssSelector("input[name='address']"))).Returns(addressElementStub.Object);
      _actual.Setup(x => x.FindElement(By.XPath("//input[@value='submit']"))).Returns(buttonElementStub.Object);

      _expected = new ExpectedView()
        .WithId("name", "John Doe")
        .WithCssSelector("input[name='address']", "123 Street")
        .WithXPath("//input[@value='submit']", "Submit")
        .ToExpectedObject()
        .Configure(ctx =>
          {
            ctx.PushStrategy&lt;ExpecedViewComparisonStrategy>();
            ctx.IgnoreTypes();
          });
    };

  It should_display_the_expected_view = () => _expected.ShouldEqual(_actual.Object);
}
```
  
  
  <p>
    Here, the Selenium 2 IWebDriver type is being stubbed to emulate an active Selenium testing session. Next, a custom ExpectedView type is instantiated and configured to expect one value to be located by an Id, one by a CSS Selector and one by an XPath. Lastly, the expected object is compared to the actual object (in this case, the IWebDriver stub).
  </p>
  
  
  <p>
    Executing the specification produces the following results:
  </p>
  
  
  <pre>


<div style="overflow: auto; border-bottom: black 1px solid; text-align: left; border-left: black 1px solid; padding-bottom: 5px; background-color: #fcc; padding-left: 5px; padding-right: 5px; border-collapse: collapse; border-top: black 1px solid; border-right: black 1px solid">
  <b>should display the expected view : Failed</b>
  For IWebDriverProxy.FindElement(By.Id("name")), expected "John Doe" but found "Jane Doe".
  For IWebDriverProxy.FindElement(By.CssSelector("input[name='address']")), expected "123 Street" but found "456 Street".
  For IWebDriverProxy.FindElement(By.XPath("//input[@value='submit']")), expected "Submit" but found "Cancel".
</div>
</pre>
  
  
  <h3>
    &nbsp;
  </h3>
  
  
  <p>
    Here is the ExpectedView and ExpectedViewComparisonStrategy implementation:
  </p>
  
  
```C#
class ExpectedView
{
  public ExpectedView()
  {
    Ids = new List&lt;Tuple&lt;string, string>>();
    CssSelectors = new List&lt;Tuple&lt;string, string>>();
    XPaths = new List&lt;Tuple&lt;string, string>>();
  }

  public List&lt;Tuple&lt;string, string>> Ids { get; private set; }
  public List&lt;Tuple&lt;string, string>> CssSelectors { get; private set; }
  public List&lt;Tuple&lt;string, string>> XPaths { get; private set; }

  public ExpectedView WithId(string name, string value)
  {
    Ids.Add(new Tuple&lt;string, string>(name, value));
    return this;
  }

  public ExpectedView WithCssSelector(string selector, string value)
  {
    CssSelectors.Add(new Tuple&lt;string, string>(selector, value));
    return this;
  }

  public ExpectedView WithXPath(string path, string value)
  {
    XPaths.Add(new Tuple&lt;string, string>(path, value));
    return this;
  }
}



class ExpecedViewComparisonStrategy : IComparisonStrategy
{
  public bool CanCompare(Type type)
  {
    return typeof (ExpectedView).IsAssignableFrom(type);
  }

  public bool AreEqual(object expected, object actual, IComparisonContext comparisonContext)
  {
    bool areEqual = true;
    var view = (ExpectedView) expected;
    var driver = (IWebDriver) actual;
    view.Ids.ForEach(id => areEqual = CompareIds(driver, id, comparisonContext) && areEqual);
    view.CssSelectors.ForEach(selector => areEqual = CompareCssSelectors(driver, selector, comparisonContext) && areEqual);
    view.XPaths.ForEach(path => areEqual = CompareXPaths(driver, path, comparisonContext) && areEqual);
    return areEqual;
  }

  static bool CompareIds(IWebDriver driver, Tuple&lt;string, string> expected, IComparisonContext comparisonContext)
  {
    bool areEqual = true;
    IWebElement idElement = driver.FindElement(By.Id(expected.Item1));
    areEqual = comparisonContext.AreEqual(expected.Item2, idElement.Text, "FindElement(By.Id(\"" + expected.Item1 + "\"))") && areEqual;
    return areEqual;
  }

  static bool CompareCssSelectors(IWebDriver driver, Tuple&lt;string, string> expected, IComparisonContext comparisonContext)
  {
    bool areEqual = true;
    IWebElement idElement = driver.FindElement(By.CssSelector(expected.Item1));
    areEqual = comparisonContext.AreEqual(expected.Item2, idElement.Text, "FindElement(By.CssSelector(\"" + expected.Item1 + "\"))") && areEqual;
    return areEqual;
  }

  static bool CompareXPaths(IWebDriver driver, Tuple&lt;string, string> expected, IComparisonContext comparisonContext)
  {
    bool areEqual = true;
    IWebElement idElement = driver.FindElement(By.XPath(expected.Item1));
    areEqual = comparisonContext.AreEqual(expected.Item2, idElement.Text, "FindElement(By.XPath(\"" + expected.Item1 + "\"))") && areEqual;
    return areEqual;
  }
}
```
  
  
  <p>
    Note: This example is for demonstration purposes only.
  </p>
  
  
  <h3>
    &nbsp;
  </h3>
  
  
  <h2>
    Conclusion
  </h2>
  
  
  <p>
    The Expected Objects library is published as a <a href="http://nuget.org/List/Packages/ExpectedObjects">NuGet package</a> and the source is hosted on <a href="https://github.com/derekgreer/expectedObjects">github</a>. Feel free to provide feedback.
  </p>
{% endraw %}
