---
wordpress_id: 14
title: 'Effective Tests: A Unit Test Example'
date: 2011-03-14T11:32:04+00:00
author: Derek Greer
layout: post
wordpress_guid: /blogs/derekgreer/archive/2011/03/14/effective-tests-a-unit-test-example.aspx
dsq_thread_id:
  - "262503389"
categories:
  - Uncategorized
tags:
  - Testing
redirect_from: "/blogs/derekgreer/archive/2011/03/14/effective-tests-a-unit-test-example.aspx/"
---
## Posts In This Series

<div>
  <ul>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/03/07/effective-tests-introduction/">Effective Tests: Introduction</a>
    </li>
    <li>
      Effective Tests: A Unit Test Example
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

In the [introduction](https://lostechies.com/derekgreer/2011/03/07/effective-tests-introduction/) to our series, I introduced some common types of automated tests: Unit Tests, Integration Tests, and Acceptance Tests.&nbsp; In this article, we’ll take a look at a traditional approach to unit testing and discuss a few practices surrounding good test communication.

## First Things First

Before getting started, we _obviously_ need something to test, so let’s create a Calculator class.

<pre class="prettyprint">public class Calculator
    {
        bool _isDirty;

        string _operation;
        decimal _state;

        public decimal Display { get; private set; }

        public void Enter(decimal number)
        {
            _state = number;
            _isDirty = true;
        }

        public void PressPlus()
        {
            _operation = "+";
            if (_isDirty) Calculate();
        }

        public void PressEquals()
        {
            if (_isDirty) Calculate();
        }

        void Calculate()
        {
            switch (_operation)
            {
                case "+":
                    Display += _state;
                    break;
            }

            _isDirty = false;
        }
    }</pre>

To keep things simple, our Calculator class just adds decimals, but that gives us enough to work with for our discussion.

## Anatomy of a Unit Test 

Now, let’s create a unit test to validate that our Calculator class behaves properly.&nbsp; I’ll use <a href="http://nunit.org/" target="_blank">NUnit</a> for this example:

<pre class="prettyprint">[TestFixture]
public class CalculatorTests
{
    [Test]
    public void TestPressEquals()
    {
        Calculator calculator = new Calculator();
        calculator.Enter(2m);
        calculator.PressPlus();
        calculator.Enter(2m);
        calculator.PressEquals();
        Assert.AreEqual(4m, calculator.Display);
    }
}</pre>

So, what’s going on here?&nbsp; Starting at the top, we have a class with a TestFixture attribute.&nbsp; This tells NUnit that this class contains unit tests.&nbsp; We’ve named our test “CalculatorTests” to denote that this class contains the tests for our Calculator class.&nbsp; Pretty descriptive, eh?

Next, we’ve defined a method with a Test attribute.&nbsp; This tells NUnit that this method should be considered a test when it scans our types for tests to execute.&nbsp; We’ve named our method TestPressEquals() to denote that we’re testing the behavior of the PressEquals method. 

<div style="border-bottom: black 1px solid; border-left: black 1px solid; background: rgb(204,204,204); border-top: black 1px solid; border-right: black 1px solid">
  <div align="center">
    <strong>Note </strong>
  </div>
  
  <p>
    The use of the prefix “Test” is a common convention which originated from a requirement within earlier versions of JUnit.&nbsp; The first version of NUnit was a direct port of JUnit and therefore shared this requirement until it was rewritten to take advantage of .Net attributes.
  </p>
</div>

Next, we’ve defined an instance of the Calculator class we’re going to be testing.&nbsp; In unit testing parlance, this is generally called the _System Under Test_, or the SUT.

Next, we make several calls to the calculator object to instruct it to add two numbers and then call the PressEquals() method.

Our final call is to the NUnit Assert.AreEqual() method.&nbsp; This method tests the expected value against the actual value and raises an exception if the values are not equal.

If we run the test at this point, we should see our test pass.

<div style="background: rgb(51,204,0)">
  &nbsp;
</div>

Hooray!

&nbsp;

## Improving Communication

While our test certainly does the job of validating the Calculator’s behavior, there are a few aspects of our test that we could improve upon.&nbsp; To start, let’s consider what would be displayed should our test actually ever fail.&nbsp; To force it to fail, I’ll comment out the line which increments the Display property.&nbsp; Running the test produces the following:

<div style="background: red">
  &nbsp;
</div>

<font face="Courier New"></p> 

<pre>CalculatorTests.TestPressEquals : Failed 
Expected: 4m 
But was:&nbsp; 0m</pre>

<p>
  </font>
</p>

<p>
  &nbsp;
</p>

<p>
  Ok, so CalculatorTests.TestEquals failed because &#8220;expected 4m, but was 0m&#8221;.&nbsp; Given that we’ve just written this test, this may not seem like much of an issue.&nbsp; The context of how our Calculator class works as well as how our test verifies it behavior is still fresh in our minds.&nbsp; But what if this fails six months from now?&nbsp; Worse, what if it fails and is discovered by someone who wasn’t the author of this test?&nbsp; Without looking at the test code, the most that could be derived from this message is that the Calculator.PressEquals method failed in some way.&nbsp; Let’s see if we can improve upon this.
</p>

<p>
  What would be great is if we could have the test runner print out a descriptive message describing what didn’t work.&nbsp; As it happens, NUnit provides an overload to the TestEquals method which allows us to supply our own message.&nbsp; Let’s change our test to include a custom message:
</p>

<pre class="prettyprint">        
        [Test]
        public void TestPressEquals2()
        {
            var calculator = new Calculator();
            calculator.Enter(2);
            calculator.PressPlus();
            calculator.Enter(2);
            calculator.PressEquals();
            Assert.AreEqual(4, calculator.Display,
                "When adding 2 + 2, expected 4 but found {0}.", calculator.Display);
        }</pre>

<p>
  When we run the test again, we get the following:
</p>

<div style="background: red">
  &nbsp;
</div>

<p>
  <font face="Courier New"></p> 
  
  <pre>CalculatorTests.TestPressEquals : Failed 
When adding 2 + 2, expected 4 but found 0. 
Expected: 4m 
But was:&nbsp; 0m</pre>
  
  <p>
    </font>
  </p>
  
  <p>
    &nbsp;
  </p>
  
  <p>
    By supplying&nbsp; a custom message, our test now provides some context around why the test failed.&nbsp; As an added benefit, our custom message also adds a bit of description to the purpose of our test when reading the source code.
  </p>
  
  <p>
    Unfortunately, these changes have introduced a bit of duplication into our test code.&nbsp; We now have the expected result, the actual result, and the values being added together repeated throughout out test.&nbsp; Also, it seems like a good idea to have the assert message automatically reflect any changes that might be made to the values used by the test.&nbsp; Let’s take a stab at reducing the duplication:
  </p>
  
  <pre class="prettyprint">
        [Test]
        public void TestPressEquals2()
        {
            var value1 = 2m;
            var value2 = 2m;
            var calculator = new Calculator();
            calculator.Enter(value1);
            calculator.PressPlus();
            calculator.Enter(value2);
            calculator.PressEquals();
            decimal expected = 4m;
            decimal actual = calculator.Display;
            Assert.AreEqual(expected, actual, 
                "When adding {0} + {1}, expected {2} but found {3}.", value1, value2, expected, actual);
        }</pre>
  
  <p>
    Now we’ve eliminated the duplication, but the test doesn’t seem as easy to follow.&nbsp; Also, our custom message no longer communicates the purpose of the test clearly.&nbsp; If we revisit this test later, we might as well work through the logic of the test than work through the logic of what this assertion&nbsp; is going to produce.&nbsp; Let’s stick to our principles on keeping our code free of duplication for now, but we’ll revisit this topic later in our series.
  </p>
  
  <p>
    Aside from there being nothing about our test that allows us to easily pick up on what’s occurring, our code is also looking a little crowded.&nbsp; We could easily address this by spacing things out a bit and perhaps adding a few comments.
  </p>
  
  <p>
    One popular style of organization is a pattern first described by Bill Wake as <em>Arrange, Act, Assert</em>.&nbsp; With this organization, the test is separated into three sections: one which Arranges the objects to be used as part of the test, one which Acts upon the objects, and one which Asserts that the expected outcomes have occurred.&nbsp; Since our test mostly follows this sequence already, let’s just space the sections out a bit and add some comments denoting the Arrange, Act and Assert sections:
  </p>
  
  <pre class="prettyprint">
        [Test]
        public void TestPressEquals()
        {
            // Arrange
            decimal value1 = 2m;
            decimal value2 = 2m;
            decimal expected = 4m;
            var calculator = new Calculator();

            // Act
            calculator.Enter(value1);
            calculator.PressPlus();
            calculator.Enter(value2);
            calculator.PressEquals();
            decimal actual = calculator.Display;

            // Assert
            Assert.AreEqual(expected, actual,
                            "When adding {0} + {1}, expected {2} but found {3}.", value1, value2, expected, actual);
        }</pre>
  
  <p>
    That organizes the flow of the test a bit better, but we’re still missing the clarity that initial custom message was providing.&nbsp; We could communicate this through a comment as well, but another approach would be to just improve upon the actual test name.
  </p>
  
  <p>
    One common naming convention is to create a name reflecting the name of the method being tested, the scenario being tested and the expected behavior.&nbsp; Let’s change our test method name to reflect this convention:
  </p>
  
  <pre class="prettyprint">
        [Test]
        public void PressEquals_AddingTwoPlusTwo_ReturnsFour()
        {
            // Arrange
            decimal value1 = 2m;
            decimal value2 = 2m;
            decimal expected = 4m;
            var calculator = new Calculator();

            // Act
            calculator.Enter(value1);
            calculator.PressPlus();
            calculator.Enter(value2);
            calculator.PressEquals();
            decimal actual = calculator.Display;

            // Assert
            Assert.AreEqual(expected, actual,
                            "When adding {0} + {1}, expected {2} but found {3}.", value1, value2, expected, actual);
        }</pre>
  
  <p>
    &nbsp;
  </p>
  
  <p>
    After we’ve adjusted to reading this naming convention, we can now derive the same information that was communicated in that first message.&nbsp; Someone get a banner printed up, we’re declaring <a href="http://en.wikipedia.org/wiki/Sarcasm" target="_blank">victory</a>!
  </p>
  
  <h2>
    Conclusion
  </h2>
  
  <p>
    In this article, we’ve taken a look at a basic approach to writing unit tests and introduced a few techniques for improving unit test communication.&nbsp; While our resulting test correctly validates the behavior of our class, communicates what it does and provides a descriptive error message when it fails, there’s still room for improvement.&nbsp; In our next article, we’ll discuss some alternative approaches that will facilitate these goals as well as help us write working, maintainable software that matters.
  </p>
