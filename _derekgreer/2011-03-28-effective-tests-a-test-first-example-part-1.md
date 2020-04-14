---
wordpress_id: 169
title: 'Effective Tests: A Test-First Example &#8211; Part 1'
date: 2011-03-28T12:19:59+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=169
dsq_thread_id:
  - "264940362"
categories:
  - Uncategorized
tags:
  - BDD
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
      Effective Tests: A Test-First Example – Part 1
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
<br/>

The [last](https://lostechies.com/derekgreer/2011/03/21/effective-tests-test-first/) installment of our series introduced Test-First Programming and briefly discussed its refinements: Test-Driven Development and Behavior-Driven Development.&nbsp; This time, we’ll dive into a simple Test First example using the principles of Test-Driven Development along with some of the Behavior-Driven Development concepts introduced last time.

Before beginning our example, we’ll take some time to discuss the goals and approach of Test-Driven Development in a little more detail to establish the methodology we’ll be following. 

## Test-Driven Development Primer

So, what is Test-Driven Development?&nbsp; The simple answer is that it’s a process of writing tests before writing code, but such a simple answer fails to convey the true spirit of Test-Driven Development. 

Even if we’ve adopted a practice of writing tests first, we’re often tempted to start implementing all the functionality we think will be part of a particular feature in a way that appeals to our design sensibilities.&nbsp; Many of us are conditioned to approach the implementation phase by asking such questions as "_What will this feature need to fully work_", "_What is the most flexible way of fulfilling this feature_", or perhaps "_What future design needs will I have that I can begin leveraging for this feature_".&nbsp; This line of thinking usually leads us down a road of implementing patterns and algorithms, creating infrastructure code, and configuring third-party libraries and frameworks we’ve already planned to use.&nbsp; The end result of such efforts may be working code, perhaps even with high test coverage, but while this approach might be considered Test-**Inspired** Development, it wouldn’t be Test-**Driven** Development.&nbsp;&nbsp; 

The goal of Test-Driven Development isn’t to ensure we write tests by writing them first, but to produce working software that achieves a targeted set of requirements using simple, maintainable solutions.&nbsp; To achieve this goal, TDD provides strategies for keeping code working, simple, relevant and free of duplication. 

### Keep it Working

To keep the code working, TDD encourages development in small steps under the protection and confidence of passing tests which properly validate the desired behavior of the system.&nbsp; To help minimize the amount of time a test exists in a failing state, TDD sets forth two strategies for quickly getting a test to pass.&nbsp; The first strategy, to be used when the solution is simple and straight forward, is to use the _Obvious Implementation_.&nbsp; The second strategy, to be used when a solution isn’t clear or will take some time to complete, is to _Fake It_.&nbsp; The Fake It strategy refers to a technique of satisfying the requirements of a test by merely returning hard-coded values. 

### Keep it Simple

To keep the code simple,&nbsp; TDD sets forth several techniques to help guide the developer toward the simplest solution.&nbsp; First, TDD encourages a willingness to take small steps.&nbsp; Taking small steps, especially for complex and unclear tasks, helps develop an ability to identify simple solutions.&nbsp; Second, TDD provides guidelines for when to add or change code.&nbsp; By changing code only to satisfy a failing test, remove duplication, or to remove unused code, solutions are kept free of complexity.&nbsp; Third, TDD encourages a willingness to just try the _Simplest Thing That Could Possibly Work_ when the obvious implementation isn’t clear.&nbsp; Fourth, TDD sets forth a technique called _Triangulation_ (discussed later) for helping to identify needed generalization. 

### Keep it Relevant

To keep the code relevant, TDD encourages the removal of unused generalization.&nbsp; While this also helps keep the code simple, simplicity doesn’t mean the code is actually needed.&nbsp; Developers often create constructs to improve the flexibility and extensibility of an application or as an outlet for their creativity, but this frequently leads to overly complex solutions which are difficult to understand, difficult to maintain and which are often never used.&nbsp; TDD helps avoid this by keeping us focused on just those things that are needed to satisfy our tests. 

### Keep it Free of Duplication

To keep the code free of duplication, TDD incorporates continuous refactoring into the development process.&nbsp; After writing a failing test and making it pass as quickly as possible, TDD encourages the removal of duplication as the heuristic for the discovery and improvement of design.&nbsp; In TDD, it is through the refactoring process, driven by the goal of removing duplication, that much of an application’s design emerges. 

### The TDD Process

To help facilitate these goals, Test-Driven Development prescribes a set of steps for us to follow: 

* Write a test.
* Make it compile.
* Run it to see that it fails.
* Make it run.
* Remove duplication.
<br/>

These steps are often simplified into a process referred to as _Red/Green/Refactor_.&nbsp; First we write a failing test, then we make it pass, then we refactor. 
With these steps and goals in mind, let’s dive into our example. 
                
## Requirements
                
For this example, we’ll be creating a simple Tic-tac-toe game that allows a single player to compete against the game.&nbsp; Here are the requirements we’ll be working from: 
                
<pre><div style="border-bottom: black 1px solid;text-align: left;border-left: black 1px solid;padding-bottom: 5px;line-height: 20px;background-color: #ffffe0;font-variant: normal;font-style: normal;padding-left: 5px;padding-right: 5px;border-collapse: collapse;float: none;color: black;font-size: 12px;vertical-align: baseline;border-top: black 1px solid;font-weight: normal;border-right: black 1px solid;padding-top: 5px">
  When the player goes first 
  	it should put their mark in the selected position 
  	it should make the next move 
  
  When the player gets three in a row 
  	it should announce the player as the winner 
  
  When the game gets three in a row 
  	it should announce the game as the winner 
  
  When the player attempts to select an occupied position 
  	it should tell the player the position is occupied 
  
  When the player attempts to select an invalid position 
  	it should tell the player the position is invalid 
  
  When the game goes first 
  	it should put an X in one of the available positions 
  
  When the player can not win on the next turn 
  	it should try to get three in a row 
  
  When the player can win on the next turn 
  	it should block the player 
</div></pre>

<br/>
                
## Creating the Specifications
                
While we’ll be striving to follow the Test-Driven Development process, we’ll also try to incorporate some of the Behavior-Driven Development concepts we learned from last time.&nbsp;&nbsp; There are several frameworks which are designed specifically to facilitate&nbsp; Behavior-Driven Development, but we’re going to use the [Visual Studio Unit Testing Framework](http://en.wikipedia.org/wiki/Visual_Studio_Unit_Testing_Framework)&nbsp; to demonstrate how these concepts can be applied using traditional xUnit frameworks. While we could begin by creating some testing infrastructure code, let’s keep things simple for now and just use some of the improved naming concepts presented in our last article. 
                
Our first step will be to create a new Visual Studio project. I’ll use the Test Project type and name the project TestFirstExample:
                
[<img style="border-right-width: 0px;padding-left: 0px;padding-right: 0px;float: none;border-top-width: 0px;border-bottom-width: 0px;margin-left: auto;border-left-width: 0px;margin-right: auto;padding-top: 0px" border="0" alt="TestFirstExampleProjectNew" src="https://lostechies.com/content/derekgreer/uploads/2011/03/TestFirstExampleProjectNew_thumb1.png" width="560" height="388" />](https://lostechies.com/content/derekgreer/uploads/2011/03/TestFirstExampleProjectNew1.png)
                
                
Next, let’s create a test class that reflects the context of our first requirement:
                
```csharp
 using Microsoft.VisualStudio.TestTools.UnitTesting;
 namespace TestFirstExample
 {
     [TestClass]
     public class WhenThePlayerGoesFirst
     {        
     }
 }
```
                
Next, let’s create a method that expresses the first observable behavior for our context:
                
```csharp
using Microsoft.VisualStudio.TestTools.UnitTesting;
namespace TestFirstExample
{
  [TestClass]
    public class WhenThePlayerGoesFirst
    {
      [TestMethod]
        public void ItShouldPutTheirChoiceInTheSelectedPosition()
        {            
        }
    }
}
```

Since we've chosen to follow a more Behavior-Driven Development approach to writing our tests, let’s take a second and reflect on how this reads. Thus far, we’ve used the same wording from our requirements, but the class and method identifiers seem a little difficult to read. Since we’re using code to represent sentences instead of entities and methods, let’s try changing our naming convention to use underscores for separating each word in our identifiers and see how it looks:

```csharp
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace TestFirstExample
{
  [TestClass]
    public class When_the_player_goes_first
    {
      [TestMethod]
        public void it_should_put_their_choice_in_the_selected_position()
        {

        }
    }
}
```

In C#, this breaks with our normal naming conventions for class and method names, but this seems a little easier to read in my opinion.

<div class="note">
  <div class="note-title">Naming Conventions</div>
  <div class="note-body">

  <p>The use of underscores for separating the words within identifiers is a commonly used convention for writing BDD specifications, especially within languages that don’t support the use of spaces. When first encountered, some developers find this unsettling due to the fact that it often represents a deviation from the standard naming convention for the language being used.</p>

  <p>For those who feel uncomfortable with this style due to it’s deviation from standard conventions, it may help to think about naming conventions in terms of modeling. Just as we use a domain model to represent a business domain, a data model to represent data persistence concerns, and a view model to represent a user interface, BDD specifications are a kind of model for representing our requirements. As such, they deserve to be viewed within their own context. In this case, specifications are all about modeling requirements, not real-world entities. As such, some have chosen to depart from standard naming conventions when modeling specifications.</p>

  <p>Of course, this is a matter of preference. What’s important is to view the modeling of specifications as its own concern and allow this understanding to help guide our modeling efforts.</p>
  </div>
</div>


The first step of our test method should be to determine how we want to verify that a player’s choice results in an X being placed in the selected position. To do this, we’ll need a way of evaluating the state of the game. One approach we could take would be to simply ask the game to tell us what value is in a given position. Since a Tic-tac-toe game is comprised of a grid with nine positions, we can refer to each position by number, numbering them from left to right, top to bottom. Let’s assume we can call a method named GetPosition():

```csharp
[TestMethod]
public void it_should_put_their_choice_in_the_selected_position()
{
  <code>Assert.AreEqual('X', game.GetPosition(1));</code>
}
```

<br />

Next, we need to create the instance of our Game variable and determine how we’re going to inform it about our choice. A common rule of Tic-tac-toe is to let ‘X’ go first, so we can keep things simple if we adopt this rule. The only input needed in that case is the position, so let’s call a method named ChoosePosition() and pass an integer value of 1 to indicate the top-left position on the board:

```csharp
[TestMethod]
public void it_should_put_their_choice_in_the_selected_position()
{
  <strong>var game = new Game();</strong>
    <strong>game.ChoosePosition(1);</strong>
    Assert.AreEqual('X', game.GetPosition(1));
}
```

Of course, this won’t compile since our Game class doesn’t exist yet. Let’s create our class and methods now:

```csharp
public class Game
{
  public void ChoosePosition(int position)
  {
    throw new NotImplementedException();
  }

  public char GetPosition(int position)
  {
    throw new NotImplementedException();
  }
}
```


Everything should be ready to compile. Let’s run our test and see what happens:

<div style="background: red">
&nbsp;
</div>
<br/>

<div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
Test method TestFirstExample.When_the_player_goes_first
.it_should_put_their_choice_in_the_selected_position threw exception: 
System.NotImplementedException: The method or operation is not implemented.

</div>
<br/>

As you probably expected, our test fails. Since we’re following the Red/Green/Refactor process, you might think we’re ready to work on getting the test to pass now. Not so fast! The purpose of writing a failing test isn’t failure, but <i>validation</i>. At this point, what we should be interested in is that the behavior of our code will be correctly validated once we write it. To help explain, let’s consider what would happen if we had mistakenly written the test as follows:

```csharp
[TestClass]
public class When_the_player_goes_first
{
  [TestMethod]
    public void it_should_put_their_choice_in_the_selected_position()
    {
      var game = new Game();
      game.ChoosePosition(1);
      Assert.<strong>AreNotEqual</strong>('X', game.GetPosition(1));
    }
}
```
<br />

Here, we’ve changed Assert.AreEqual() to Assert.AreNotEqual(). How do you think this will change the outcome of the test? If you guessed it would not change the outcome then you’re correct. Our test didn’t fail because of our assert, but rather because an exception halted the test before it even got to the assertion. That doesn’t tell us anything about the validity of how we’ve written our test. Merely getting a test to fail doesn’t serve a useful purpose. Our test needs to <i>fail for the right reason</i>.

In this case, we want our test to fail because the call to the GetPosition() method didn’t return an X. Let’s remove the calls which are causing exceptions to be thrown and change the GetPosition() method to return a value that forces the test to fail due to the assertion:

```csharp
public class Game
{
  public void ChoosePosition(int position)
  {
  }

  public char GetPosition(int position)
  {
    <strong>return '\0';</strong>
  }
}
```

Running our test again produces the following output:

<div style="background: red">
&nbsp;
</div>
<br>

<div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
When_the_player_goes_first
Failed	it_should_put_their_choice_in_the_selected_position	
Assert.AreEqual failed. Expected:&lt;X&gt;. Actual:&lt;\0&gt;. 	

</div>
<br/>

We now see that our test is failing due to the assertion properly validating the behavior of our class. Our next step is getting our test to pass quickly. Let's use the Fake It approach and simply return the expected value of ‘X’: 

```csharp
public class Game
{
  public void ChoosePosition(int position)
  {
  }

  public char GetPosition(int position)
  {
    <strong>return 'X';</strong>
  }
}
```

<div style="background:#3C0">
&nbsp;
</div>
<br/>

Our first test passes! Our next step is to eliminate any unnecessary generalization and duplication. While we don’t have any generalization to remove, we do have duplication. At first, our duplication may be difficult to spot as we’re typically accustomed to thinking about it in terms of repeated code blocks, but duplication manifests itself in many forms. In this case we have a form of duplication which I like to think of as <i>Mirroring</i>. We’re simply reflecting back to the test what it is expecting to see. This form of duplication is often the result of using the Fake It approach to getting tests to pass quickly, but this isn’t a bad thing. On the contrary, starting with hard-coded values and generalizing based upon a need to remove duplication helps to ensure that we aren’t introducing generalization unnecessarily.

To remove our duplication, let’s keep track of the player’s choice in a layout field which we can set when the ChoosePosition() method is called and then retrieve when the GetPosition() method is called:

```csharp
public class Game
{
  <strong>char _layout;</strong>

    public void ChoosePosition(int position)
    {
      <strong>_layout = 'X';</strong>
    }

  public char GetPosition(int position)
  {
    <strong>return _layout;</strong>
  }
}
```

<div style="background:#3C0">
&nbsp;
</div>
<br/>

You might be wondering why I chose such a naïve solution here. Won’t we need something that can keep track of all the positions on the board to accommodate other scenarios? The answer is yes, but we don’t have tests to drive our need to accommodate other scenarios yet. By only using the simplest constructs needed by our existing tests, we help to ensure we aren’t writing more complex code than necessary.

Another question that could be posed is, if we’re concerned with eliminating waste, doesn’t this process itself end up causing waste? The answer is yes and no. It can be reasoned that doing simple things does lead to waste in small degrees, but the benefit of allowing our design to emerge from this process is that it helps to eliminate large areas of waste.

Another question some may be wondering is whether taking small steps is a rule we have to follow when doing TDD. The answer to that question is no, but it is a useful methodology that helps keep us honest. We can take larger steps when it makes sense to do so, but it’s important to watch that our steps aren’t getting too large. You’ll know your steps are getting too large when you or others start frequently discovering unnecessary code or simpler solutions. By using this approach as a general practice, it helps to condition our ability to identify simple solutions. In his book <i>Test-Driven Development By Example</i>, Kent Beck points out that TDD is not about taking teeny-tiny steps, it’s about <i>being able to take teeny-tiny steps.</i>

Let’s move on to our next requirement. We’ll start by creating a new test method:

```csharp
[TestMethod]
public void it_should_make_the_next_move()
{
}
```

<p>
Again, our first step is to determine how we want to verify the behavior of the requirement. Since this test would be satisfied by the game choosing any position, we can verify the expected behavior occurred by checking all the positions. A clean way to do this is to create the range we want to check using Enumerable.Range() and then use LINQ’s Any() extension method to check each position for the character ‘O’. The Any() method returns true as soon as one of the enumerated elements is satisfied by the predicate:
</p>

```csharp
[TestMethod]
public void it_should_make_the_next_move()
{
  Assert.IsTrue(Enumerable.Range(1, 9)
      .Any(position =&gt; game.GetPosition(position)
        .Equals('O')));
}
```

Next, we need to establish the context for the test. To avoid duplication, let’s move the context setup from our first test into a setup method and modify our tests to use a class field:

```csharp
[TestClass]
public class When_the_player_goes_first
{
  <strong>Game _game;</strong>

    <strong>[TestInitialize]
    public void establish_context()
    {
      _game = new Game();
      _game.ChoosePosition(1);
    }</strong>

  [TestMethod]
    public void it_should_put_their_choice_in_the_selected_position()
    {
      Assert.AreEqual('X', <strong>_game</strong>.GetPosition(1));
    }

  [TestMethod]
    public void it_should_make_the_next_move()
    {
      Assert.IsTrue(Enumerable.Range(1, 9)
          .Any(position =&gt; <strong>_game</strong>.GetPosition(position)
            .Equals('O')));
    }
}
```

Now we’re ready to run our test. Since we’ve modified things, let’s run both the tests just to make sure we didn’t break the first one:

<div style="background: red">
&nbsp;
</div>
<br/>

<div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
When_the_player_goes_first
Failed	it_should_make_the_next_move
Assert.IsTrue failed.
</div>
<br/>

From the output, we see that we didn’t break our first test and our second test is failing for the right reason. Next, let’s make our new test pass. To do so, the GetPosition() method will need to return an ‘O’ for one of the nine times it’s called. Let’s use the Fake It approach again to get the test to pass quickly. We can change our _layout field to a two character array and hard-code the ChoosePosition() method to assign ‘O’ to the second position:

```csharp
public class Game
{
  char[] _layout = new <strong>char[2]</strong>;

  public void ChoosePosition(int position)
  {
    _layout[position - 1] = 'X';
    <strong>_layout[1] = 'O';</strong>
  }

  public char GetPosition(int position)
  {
    return _layout[position - 1];
  }
}
```

<div style="background:#3C0">
&nbsp;
</div>
<br/>

Now that the tests pass, we can move on to factoring out any duplication we’ve introduced. This time, however, we aren’t checking a specific position that’s we’ve hard coded a value to satisfy. On the other hand, we know this solution isn’t going to be flexible enough based on our knowledge about the rules of the game. How should we proceed?

<p>
To introduce generalization in cases where duplication either doesn’t exist or isn’t readily apparent, we can use a strategy called <i>Triangulation</i>. Similar to the mathematical process of determining the third point of a triangle given the length and angles of the first two points, this process helps you locate a generalized solution based upon two tests which verify the results in intersecting ways.
</p>

<p>
To demonstrate, let’s create a second test which validates the behavior of our class in a slightly different way which the current implementation wouldn’t satisfy:
</p>

```csharp
[TestClass]
public class When_the_player_selects_the_second_position
{
  [TestMethod]
    public void it_should_put_their_choice_in_the_second_position()
    {
      Game game = new Game();
      game.ChoosePosition(2);
      Assert.AreEqual('X', game.GetPosition(2));
    }
}
```

<div style="background:red">
&nbsp;
</div>
<br/>

<div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
When_the_player_selects_the_second_position
Failed	it_should_put_their_choice_in_the_second_position
Assert.AreEqual failed. Expected:&lt;X&gt;. Actual:&lt;O&gt;.
</div>
<br />

Our test fails because the method is hard-coded to assign ‘O’ to the second position. In order to make this test pass, we’ll now need to change our code to a more general solution. To replace the hard-coded selection of the second position, we can use LINQ to locate the first unoccupied element of the array and use that position for our assignment:

```csharp
public class Game
{
  readonly char[] _layout = new char[2];

  public void ChoosePosition(int position)
  {
    _layout[position - 1] = 'X';
    int firstUnoccupied = Enumerable.Range(0, _layout.Length)
      .First(p =&gt; _layout[p].Equals('\0'));
    _layout[firstUnoccupied] = 'O';
  }

  public char GetPosition(int position)
  {
    return _layout[position - 1];
  }
}
```

<div style="background:#3C0">
&nbsp;
</div>
<br/>

Our new test now passes. Our next step would be to factor out any duplication we might have introduced to satisfy the new test, but it doesn’t look like we introduced any this time.

While the use of Triangulation provides a simple to understand and explicit driver for introducing a generalized solution, it’s use is a somewhat inelegant strategy. Once a generalized solution is introduced, intersecting tests become redundant from a specification perspective. They can be useful in cases when it isn’t clear why a generalized solution exists and you need to ensure the solution isn’t lost through a future refactoring, but the resulting extra tests lead to higher test maintenance costs and can lead to confusion when included in reports or used as documentation by other team members. When possible, prefer removing duplication over triangulation as a generalization strategy. If duplication isn’t present or is of a particularly difficult to spot nature and generalization won’t be addressed by a separate requirement then it may be beneficial to leave redundant tests. To help aid in clarifying the intent of the test, we can use a TestCategoryAttribute as follows:

```csharp
[TestClass]
public class When_the_player_selects_the_second_position
{
  <strong>[TestCategory("Triangulation")]</strong> [TestMethod]
    public void it_should_put_their_choice_in_the_second_position()
    {
      var game = new Game();
      game.ChoosePosition(2);
      Assert.AreEqual('X', game.GetPosition(2));
    }
}
```

This helps to identify the reason for the test to other team members in a standard way and provides a mechanism for creating reports which don’t include the redundant test cases when desired. From the command line, our tests can be run without including the triangulation tests using the following:

<pre>
c:\Program Files\Microsoft Visual Studio 10.0\Common7\IDE\MSTest.exe /category:'!Triangulation' \
    /testcontainer:TestFirstExample.dll
</pre>
<br/>

For frameworks which provide non-sealed attributes for identifying categories of tests, we can create our own strongly-typed attribute to minimize any additional syntax noise as shown in the following contrived example:

```csharp
public class TriangulationAttribute : SomeFrameworkCategoryAttribute
{
  public MyAttribute() : base("Triangulation") { }   
}  
```

While perhaps not easily discerned, we might have avoided the use of Triangulation in the above example had we considered our Any() extension method to have been hiding a form of duplication. When we used the Any() method to look for the first occurrence of a position with the value ‘O’, this was logically the same as if we had written the following:

```csharp
[TestMethod]
public void it_should_make_the_next_move()
{
  char[] positions = new char[2];
  bool gamePositionFound = false;
  for(int i = 0; i &lt; 2; i++)
  {
    positions[i] = _game.GetPosition(i + 1);
  }
  for (int i = 0; i &lt; 9; i++)
  {
    if (positions[i].Equals(&#039;O&#039;))
    {
      gamePositionFound = true;
      break;
    }
  }
  Assert.IsTrue(gamePositionFound);

}
```

Breaking the logic down further, our for loop would have performed the following checks:

```csharp
if(positions[0].Equals(‘O’)) { … }
if(positions[1].Equals(‘O’)) { … }
```

Based on a more explicit expression of what our code was doing, it becomes easier to identify the duplication that was present.

Moving on, our next requirement concerns how we’ll determine when the player has won the game. Let’s create a new test class along with it’s single observation:

```csharp
[TestClass]
public class When_the_player_gets_three_in_a_row
{
  [TestMethod]
    public void it_should_announce_the_player_as_the_winner()
    {

    }
}
```

We know that we want to end up with a message that reflects that the player won, so let’s start with this as our assertion:

```csharp
[TestClass]
public class When_the_player_gets_three_in_a_row
{
  [TestMethod]
    public void it_should_announce_the_player_as_the_winner()
    {
      <strong>Assert.AreEqual("Player wins.", message);</strong>
    }
}
```

Next, we need to determine where our message will come from. Let’s assume our ChoosePosition() method returns a message after the player makes a move. We’ll call the ChoosePosition() method three times and declare our Game instance:

```csharp
[TestClass]
public class When_the_player_gets_three_in_a_row
{
  [TestMethod]
    public void it_should_announce_the_player_as_the_winner()
    {
      <strong>Game game = new Game();
      game.ChoosePosition(1);
      game.ChoosePosition(2);
      string message = game.ChoosePosition(3);</strong>
        Assert.AreEqual("Player wins!", message);            
    }
}
```

To get this to compile, we need to change the ChoosePosition() method to return a string:

```csharp
public <strong>string</strong> ChoosePosition(int position)
{
  _layout[position - 1] = value;
  int firstUnoccupied = Enumerable.Range(0, _layout.Length)
    .First(p =&gt; _layout[p].Equals('\0'));
  _layout[firstUnoccupied] = 'O';

  <strong>return string.Empty;</strong>
}
```

We’re now ready to run our tests:

<div style="background:red">
&nbsp;
</div>
<br/>

<div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
When_the_player_gets_three_in_a_row
Failed	it_should_announce_the_player_as_the_winner
Test method TestFirstExample.When_the_player_gets_three_in_a_row
.it_should_announce_the_player_as_the_winner threw exception: 
System.InvalidOperationException: Sequence contains no matching element 
</div>
<br/>

It looks like our test isn’t failing for the right reason yet. The problem is that our array isn’t large enough for our new test scenario. Let’s go ahead and take the larger step of increasing the layout to accommodate the full 9 positions of the game board and run our test again:

```csharp
readonly char[] _layout = <strong>new char[9]</strong>;
```

<div style="background:red">
&nbsp;
</div>
<br/>

<div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
When_the_player_gets_three_in_a_row
Failed	it_should_announce_the_player_as_the_winner
Assert.AreEqual failed. Expected:&lt;Player wins!&gt;. Actual:&lt;&gt;. 	
</div>
<br/>

Now, let’s make it pass. We can just return the string “Player wins!” to get the test to pass quickly:

```csharp
public class Game
{
  readonly char[] _layout = new char[9];

  public string ChoosePosition(int position)
  {
    _layout[position - 1] = 'X';
    int firstUnoccupied = Enumerable.Range(0, _layout.Length)
      .First(p =&gt; _layout[p].Equals('\0'));
    _layout[firstUnoccupied] = 'O';

    return <strong>"Player wins!"</strong>;
  }

  public char GetPosition(int position)
  {
    return _layout[position - 1];
  }
}
```

<div style="background:#3C0">&nbsp;</div>
<br/>

We now have the string "Player wins!" duplicated, so we’ll fix this by putting in some logic to test that the first three positions contain the value ‘X’:

```csharp
public class Game
{
  readonly char[] _layout = new char[9];

  public string ChoosePosition(int position)
  {
    _layout[position - 1] = 'X';
    int firstUnoccupied = Enumerable.Range(0, _layout.Length)
      .First(p =&gt; _layout[p].Equals('\0'));
    _layout[firstUnoccupied] = 'O';

    <strong>if (new string(_layout.ToArray()).StartsWith("XXX"))
      return "Player wins!";

    return string.Empty;</strong>
  }

  public char GetPosition(int position)
  {
    return _layout[position - 1];
  }
}
```

<div style="background:#3C0">&nbsp;</div>
<br/>

We can now move on to our next requirement which concerns determining when the game wins. Here’s our test skeleton:

```csharp
[TestClass]
public class When_the_game_gets_three_in_a_row
{
  [TestMethod]
    public void it_should_announce_the_game_as_the_winner()
    {            
    }
}
```

Again, we’ll start by declaring our assertion and then fill in the context of the test. Since we know that the game chooses the first unoccupied space, we can leverage this by choosing positions which leave the first row open:

```csharp
[TestClass]
public class When_the_game_gets_three_in_a_row
{
  [TestMethod]
    public void it_should_announce_the_game_as_the_winner()
    {
      <strong>Game game = new Game();
      game.ChoosePosition(4);
      game.ChoosePosition(6);
      string message = game.ChoosePosition(8);
      Assert.AreEqual("Game wins.", message);</strong>
    }
}
```

<div style="background:red">&nbsp;</div>
<br/>

<div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
When_the_game_gets_three_in_a_row
Failed	it_should_announce_the_game_as_the_winner
Assert.AreEqual failed. Expected:&lt;Game wins.&gt;. Actual:&lt;&gt;.
</div>
<br/>

To get the test to pass, we can use similar logic as before to check that the layout starts with “OOO”:

```csharp
public string ChoosePosition(int position)
{
  _layout[position - 1] = 'X';
  int firstUnoccupied = Enumerable.Range(0, _layout.Length)
    .First(p =&gt; _layout[p].Equals('\0'));
  _layout[firstUnoccupied] = 'O';

  if (new string(_layout.ToArray()).StartsWith("XXX"))
    return "Player wins!";

  <strong>if (new string(_layout.ToArray()).StartsWith("OOO"))
    return "Game wins.";</strong>

    return string.Empty;
}
```

<div style="background:#3C0">&nbsp;</div>
<br/>

Now, let’s refactor. In reviewing our code, we see that we have some similarities between the logic checking if the player wins and the logic checking if the game wins. We need a way of generalizing this comparison so that it works for both. One option would be to use regular expressions. If we have an array of winning patterns, we can convert the layout to a string and compare it to each one in a loop. Let’s figure up all the winning patterns real quick:

<a href="https://lostechies.com/content/derekgreer/uploads/2011/03/tic-tac-toe.png"><img style="border-right-width: 0px;padding-left: 0px;padding-right: 0px;float: none;border-top-width: 0px;border-bottom-width: 0px;margin-left: auto;border-left-width: 0px;margin-right: auto;padding-top: 0px" border="0" alt="tic-tac-toe" src="https://lostechies.com/content/derekgreer/uploads/2011/03/tic-tac-toe_thumb.png" width="485" height="474" /></a>

It looks like we have eight different winning patterns. Flattening this out becomes:

<pre>
X X X _ _ _ _ _ _,
_ _ _ X X X _ _ _,
_ _ _ _ _ _ X X X,
X _ _ X _ _ X _ _,
_ X _ _ X _ _ X _,
_ _ X _ _ X _ _ X,
X _ _ _ X _ _ _ X,
_ _ X _ X _ X _ _
</pre>

  <p>
  &nbsp;
  </p>

  <p>
  Let’s start by creating a new array reflecting the winning patterns for ‘X’:
  </p>

```csharp
public class Game
{
  readonly char[] _layout = new char[9];

  <strong>readonly string[] _winningXPatterns = new[]
  {
    "XXX......",
      "...XXX...",
      "......XXX",
      "X..X..X..",
      ".X..X..X.",
      "..X..X..X",
      "X...X...X",
      "..X.X.X..",
  };</strong>

  public string ChoosePosition(int position)
  {
    _layout[position - 1] = 'X';
    int firstUnoccupied = Enumerable.Range(0, _layout.Length)
      .First(p =&gt; _layout[p].Equals('\0'));
    _layout[firstUnoccupied] = 'O';

    if (new string(_layout.ToArray()).StartsWith("XXX"))
      return "Player wins!";

    if (new string(_layout.ToArray()).StartsWith("OOO"))
      return "Game wins.";

    return string.Empty;
  }
```

Next, we need to create a string representation of our current layout:

```csharp
    public string ChoosePosition(int position)
    {
      _layout[position - 1] = 'X';
      int firstUnoccupied = Enumerable.Range(0, _layout.Length)
        .First(p =&gt; _layout[p].Equals('\0'));
      _layout[firstUnoccupied] = 'O';

      <strong>var layoutAsString = new string(_layout);</strong>

        if (new string(_layout.ToArray()).StartsWith("XXX"))
          return "Player wins!";

      if (new string(_layout.ToArray()).StartsWith("OOO"))
        return "Game wins.";

      return string.Empty;
    }
```

Next, let’s replace the previous comparison checking if the layout starts with “XXX” with a loop that checks each winning pattern to the current layout:

```csharp
    public string ChoosePosition(int position)
    {
      _layout[position - 1] = 'X';
      int firstUnoccupied = Enumerable.Range(0, _layout.Length)
        .First(p =&gt; _layout[p].Equals('\0'));
      _layout[firstUnoccupied] = 'O';

      var layoutAsString = new string(_layout);

      <strong>foreach (string pattern in _winningXPatterns)
      {
        if (Regex.IsMatch(layoutAsString, pattern))
          return "Player wins!";
      }</strong>

      if (new string(_layout.ToArray()).StartsWith("OOO"))
        return "Game wins.";

      return string.Empty;
    }
```

<div style="background:#3C0">&nbsp;</div>
<br/>

Everything is still working. Now, let’s make the same changes for the game comparison:

```csharp
    public class Game
    {
      readonly char[] _layout = new char[9];

      readonly string[] _winningXPatterns = new[]
      {
        "XXX......",
          "...XXX...",
          "......XXX",
          "X..X..X..",
          ".X..X..X.",
          "..X..X..X",
          "X...X...X",
          "..X.X.X..",
      };

      <strong>readonly string[] _winningOPatterns = new[]
      {
        "OOO......",
          "...OOO...",
          "......OOO",
          "O..O..O..",
          ".O..O..O.",
          "..O..O..O",
          "O...O...O",
          "..O.O.O..",
      };</strong>

      public string ChoosePosition(int position)
      {
        _layout[position - 1] = 'X';
        int firstUnoccupied = Enumerable.Range(0, _layout.Length)
          .First(p =&gt; _layout[p].Equals('\0'));
        _layout[firstUnoccupied] = 'O';

        var layoutAsString = new string(_layout);

        foreach (string pattern in _winningXPatterns)
        {
          if (Regex.IsMatch(layoutAsString, pattern))
            return "Player wins!";
        }

        <strong>foreach (string pattern in _winningOPatterns)
        {
          if (Regex.IsMatch(layoutAsString, pattern))
            return "Game wins.";
        }</strong>

        return string.Empty;
      }

      public char GetPosition(int position)
      {
        return _layout[position - 1];
      }
    }
```

<div style="background:#3C0">&nbsp;</div>
<br/>

We’re still green. At this point we’ve actually introduced a little more duplication than we started with, but we’re making small steps that will eventually lead us to a solution. Next, let’s see if we can combine our two arrays to represent the winning position for both players. Since we’re using a regular expression, we can replace the characters with character sets like this:

```csharp
    readonly string[] _winningPatterns = new[]
    <strong>{
      "[XO][XO][XO]......",
        "...[XO][XO][XO]...",
        "......[XO][XO][XO]",
        "[XO]..[XO]..[XO]..",
        ".[XO]..[XO]..[XO].",
        "..[XO]..[XO]..[XO]",
        "[XO]...[XO]...[XO]",
        "..[XO].[XO].[XO]..",
    }</strong>;
```

We’ll then need to change the comparisons to use the new array. Since we only want to compare one side at a time, we’ll also need to filter out the characters we don’t want:

```csharp
    public string ChoosePosition(int position)
    {
      _layout[position - 1] = 'X';
      int firstUnoccupied = Enumerable.Range(0, _layout.Length)
        .First(p =&gt; _layout[p].Equals('\0'));
      _layout[firstUnoccupied] = 'O';

      string layoutAsString = new string(_layout)<strong>.Replace('O', '\0')</strong>;

      foreach (string pattern in <strong>_winningPatterns</strong>)
      {
        if (Regex.IsMatch(layoutAsString, pattern))
          return "Player wins!";
      }

      layoutAsString = new string(_layout)<strong>.Replace('X', '\0')</strong>;

      foreach (string pattern in <strong>_winningPatterns</strong>)
      {
        if (Regex.IsMatch(layoutAsString, pattern))
          return "Game wins.";
      }

      return string.Empty;
    }
```

<div style="background:#3C0">&nbsp;</div>
<br/>

Now, let’s take care of the looping duplication by creating a method that will perform the comparison based on the given side we’re interested in:

```csharp
    bool WinningPlayerIs(char player)
    {
      var layout = new string(_layout);

      if (player == 'X')
        layout = layout.Replace('O', '\0');
      else
        layout = layout.Replace('X', '\0');

      foreach (string pattern in _winningPatterns)
      {
        if (Regex.IsMatch(layout, pattern))
          return true;
      }

      return false;
    }
```

We can now replace our comparisons with a call to our new method:

```csharp
    public string ChoosePosition(int position)
    {
      _layout[position - 1] = 'X';
      int firstUnoccupied = Enumerable.Range(0, _layout.Length) 
        .First(p =&gt; _layout[p].Equals('\0'));
      _layout[firstUnoccupied] = 'O';

      <strong>if (WinningPlayerIs('X'))
        return "Player wins!";

      if (WinningPlayerIs('O'))
        return "Game wins.";</strong>

          return string.Empty;
    }
```

<div style="background:#3C0">&nbsp;</div>
<br/>

Now, let’s clean up our new WinningPlayerIs() method. We’re duplicating the call to Replace() based upon which character we’re wanting the layout for, so instead of this let’s use LINQ to create an array with the character we want filtered out:

```csharp
    bool WinningPlayerIs(char player)
    {
      <strong>var layout = new string(_layout.ToList()
          .Select(c =&gt; (c.Equals(player)) ? player : '\0')
          .ToArray());</strong>

        foreach (string pattern in _winningPatterns)
        {
          if (Regex.IsMatch(layout, pattern))
            return true;
        }

      return false;
    }
```

<div style="background:#3C0">&nbsp;</div>
<br/>

That’s more concise, but it could stand to be more descriptive. Rather than adding a comment, let’s just wrap this in an intention-revealing method:

```csharp
    bool WinningPlayerIs(char player)
    {
      var layout = <strong>GetLayoutFor(player);</strong>

        foreach (string pattern in _winningPatterns)
        {
          if (Regex.IsMatch(layout, pattern))
            return true;
        }

      return false;
    }

  <strong>string GetLayoutFor(char player)
  {
    return new string(_layout.ToList()
        .Select(c =&gt; (c.Equals(player)) ? player : '\0')
        .ToArray());
  }</strong>
```

We can also eliminate declaring multiple exit points and simplify the comparison by using LINQ’s Any() extension method:

```csharp
    bool WinningPlayerIs(char player)
    {
      var layout = GetLayoutFor(player);
      return _winningPatterns.Any(pattern =&gt; Regex.IsMatch(layout, pattern));
    }
```

Let’s go ahead and in-line our call to GetLayoutFor(player):

```csharp
          bool WinningPlayerIs(char player)
          {
            <strong>return _winningPatterns
              .Any(pattern =&gt; Regex.IsMatch(GetLayoutFor(player), pattern));</strong>
          }

```

<div style="background:#3C0">&nbsp;</div>
<br/>

Here’s what we have so far:

``csharp
    public class Game
    {
      readonly char[] _layout = new char[9];

      readonly string[] _winningPatterns = new[]
      {
        "[XO][XO][XO]......",
          "...[XO][XO][XO]...",
          "......[XO][XO][XO]",
          "[XO]..[XO]..[XO]..",
          ".[XO]..[XO]..[XO].",
          "..[XO]..[XO]..[XO]",
          "[XO]...[XO]...[XO]",
          "..[XO].[XO].[XO]..",
      };

      public string ChoosePosition(int position)
      {
        _layout[position - 1] = 'X';
        int firstUnoccupied = Enumerable.Range(0, _layout.Length)
          .First(p =&gt; _layout[p].Equals('\0'));
        _layout[firstUnoccupied] = 'O';

        if (WinningPlayerIs('X'))
          return "Player wins!";

        if (WinningPlayerIs('O'))
          return "Game wins.";

        return string.Empty;
      }

      bool WinningPlayerIs(char player)
      {
        return _winningPatterns
          .Any(pattern =&gt; Regex.IsMatch(GetLayoutFor(player), pattern));
      }

      string GetLayoutFor(char player)
      {
        return new string(_layout.ToList()
            .Select(c =&gt; (c.Equals(player)) ? player : '\0')
            .ToArray());
      }

      public char GetPosition(int position)
      {
        return _layout[position - 1];
      }
    }
```

We’ll leave things here for now and complete the rest of our requirements next time.
