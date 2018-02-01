---
id: 263
title: 'Effective Tests: A Test-First Example &#8211; Part 4'
date: 2011-04-24T17:05:55+00:00
author: Derek Greer
layout: post
guid: http://lostechies.com/derekgreer/?p=263
dsq_thread_id:
  - "287441200"
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
      <a href="https://lostechies.com/derekgreer/2011/03/29/effective-tests-how-faking-it-can-help-you/">Effective Tests: How Faking It Can Help You</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/04/04/effective-tests-a-test-first-example-part-2/">Effective Tests: A Test-First Example – Part 2</a>
    </li>
    <li>
      <a href="https://lostechies.com/derekgreer/2011/04/11/effective-tests-a-test-first-example-part-3/">Effective Tests: A Test-First Example – Part 3</a>
    </li>
    <li>
      Effective Tests: A Test-First Example – Part 4
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

In [part 3](http://lostechies.com/derekgreer/2011/04/11/effective-tests-a-test-first-example-part-3/) of our Test-First example, we finished the initial implementation of our Tic-tac-toe component. After we finished, a team in charge of creating a host application was able to get everything integrated (though rumor has it that there was a bit of complaining) and the application made its way to the QA team for some acceptance testing. Surprisingly, there were several issues reported that got assigned to us. Here are the issues we’ve been assigned:

<table style="clear:both;border: 1px solid black;border-collapse: collapse;color: black;width=100%;">
  <tr style="border: 1px solid black;background-color:#DFDFDF">
    <th style="border: 1px solid black;">
      Issue
    </th>
    
    <th style="border: 1px solid black;">
      Description
    </th>
    
    <th style="border: 1px solid black;">
      Owner
    </th>
  </tr>
  
  <tr style="border: 1px solid black;">
    <td style="border: 1px solid black;">
      Defect
    </td>
    
    <td style="border: 1px solid black;">
      The player can always win by choosing positions 1, 5, 2, and 8. The game should prevent the player from winning.
    </td>
    
    <td style="border: 1px solid black;">
      <nobr>QA Team</nobr>
    </td>
  </tr>
  
  <tr style="border: 1px solid black;">
    <td style="border: 1px solid black;">
      Defect
    </td>
    
    <td style="border: 1px solid black;">
      The game throws an InvalidOperationException when choosing positions 1, 2, 5, and 9
    </td>
    
    <td style="border: 1px solid black;">
      QA Team
    </td>
  </tr>
  
  <tr style="border: 1px solid black;">
    <td style="border: 1px solid black;">
      Defect
    </td>
    
    <td style="border: 1px solid black;">
      The game makes a move after the player wins
    </td>
    
    <td style="border: 1px solid black;">
      QA Team
    </td>
  </tr>
  
  <tr style="border: 1px solid black;">
    <td style="border: 1px solid black;">
      Defect
    </td>
    
    <td style="border: 1px solid black;">
      After letting the game win by choosing positions 4, 7, 8, and 6, choosing the last position of 3 throws an InvalidOperationException
    </td>
    
    <td style="border: 1px solid black;">
      QA Team
    </td>
  </tr>
  
  <tr>
    <td style="border: 1px solid black;">
      Defect
    </td>
    
    <td style="border: 1px solid black;">
      When trying to let the game win by choosing positions 1, 7, and 8, the game chose positions 4, 5, and 9 instead of completing the winning sequence 4, 5, 6.
    </td>
    
    <td style="border: 1px solid black;">
      QA Team
    </td>
  </tr>
  
  <tr style="border: 1px solid black;">
    <td style="border: 1px solid black;">
      New Feature
    </td>
    
    <td style="border: 1px solid black;">
      Add a method to the Game class for retrieving the last position selected by the game.
    </td>
    
    <td style="border: 1px solid black;">
      <nobr>GUI Team</nobr>
    </td>
  </tr>
  
  <tr style="border: 1px solid black;">
    <td style="border: 1px solid black;">
      New Feature
    </td>
    
    <td style="border: 1px solid black;">
      Please modify the ChoosePosition method to throw exceptions for errors rather than returning strings. Additionally, please provide an event we can subscribe to when one of the players wins or when there is a draw.
    </td>
    
    <td style="border: 1px solid black;">
      GUI Team
    </td>
  </tr></table> 
  
  <p>
  </p>
  
  <p>
    As you may have discerned by now, following Test-Driven Development doesn’t ensure the code we produce will be free of errors. It does, however, ensure that our code meets the executable specifications we create to guide the application’s design and aids in the creation of code that&#8217;s maintainable and relevant (that is, to the extent we adhere to Test-Driven Development methodologies). Of course, the Test-Driven Development process is a framework into which we pour both our requirements and ourselves. The quality of both of these ingredients certainly affects the overall outcome. As we become better at gathering requirements, translating these requirements into executable specifications, identifying simple solutions and factoring out duplication, our yield from the TDD process will increase.
  </p>
  
  <p>
    Since our issues have no particular priority assigned, let’s read through them before we get started to see if any make sense to tackle first. Given a couple of the issues pertain to changes to the API, it might be best to address these first to minimize the possibility of writing new tests that could need to be modified later.
  </p>
  
  <p>
    The first of these issues pertain to adding a new method. Here’s the issue:
  </p>
  
  <table style="border: 1px solid black;border-collapse:collapse;color:black;width:100%;">
    <tr style="border: 1px solid black;background-color:#DFDFDF">
      <th style="border: 1px solid black;">
        Issue
      </th>
      
      <th style="border: 1px solid black;">
        Description
      </th>
      
      <th style="border: 1px solid black;">
        Owner
      </th>
    </tr>
    
    <tr style="border: 1px solid black;">
      <td style="border: 1px solid black;">
        <nobr>New Feature</nobr>
      </td>
      
      <td style="border: 1px solid black;">
        Add a method to the Game class for retrieving the last position selected by the game.
      </td>
      
      <td style="border: 1px solid black;">
        <nobr>GUI Team</nobr>
      </td>
    </tr></table> 
    
    <p>
    </p>
    
    <p>
      Upon integrating our component, the GUI team discovered there wasn’t an easy way to tell what positions the game was selecting in order to reflect this to the user. They were able to use techniques similar to those we used in the course of implementing our tests, but they didn’t consider this to be a very friendly API. While such an oversight may seem obvious within the context of the entire application, such issues occur when components are development in isolation. Fundamentally, the problem wasn’t with the Test-Driven Development methodologies we were following, but with the scope in which we were applying them. Later in our series, we’ll discuss an alternative to the approach we’ve taken with this effort that can help avoid misalignments such as this. Until then, we’ll address these issues the best we can with our existing approach.
    </p>
    
    <p>
      To address this issue, we’ll create a new test that describes the behavior for the requested method:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
      public class When_retrieving_the_last_selected_position_for_the_game
      {
          [TestMethod]
          public void it_should_return_the_last_position()
          {
          }
      }
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      As our method of validation, we’ll set up our assertion to verify that some expected position was selected:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
      public class When_retrieving_the_last_selected_position_for_the_game
      {
          [TestMethod]
          public void it_should_return_the_last_position()
          {
              <b>Assert.AreEqual(1, selection);</b>
          }
      }
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      Next, let’s choose what our API is going to look like and then set up the context of our test. Let’s call our new method GetLastChoiceBy(). We can make use of our existing Player enumeration as the parameter type:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
      public class When_retrieving_the_last_selected_position_for_the_game
      {
          [TestMethod]
          public void it_should_return_the_last_position()
          {
              <b>Game game = new Game(new GameAdvisorStub(new [] { 1 }));
              game.GoFirst();
              var selection = game.GetLastChoiceBy(Player.Game);</b>
              Assert.AreEqual(1, selection);
          }
      }
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      Next, let’s add the new method to our Game class so this will compile:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public class Game
      {
          // snip
  
          public int GetLastChoiceBy(Player player)
          {
              return 0;
          }
  }
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      Now we’re ready to run the tests:
    </p>
    
    <div style="background: red">
      &nbsp;
    </div>
    
    <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_retrieving_the_last_selected_position_for_the_game
  Failed	it_should_return_the_last_position
  Assert.AreEqual failed. Expected:&lt;1>. Actual:&lt;0>. 	
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      We can make the test pass by just returning a 1:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public int GetLastChoiceBy(Player player)
          {
              <b>return 1;</b>
          }
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <div style="background:#3C0">
      &nbsp;
    </div>
    
    <p>
      &nbsp;
    </p>
    
    <p>
      Now, we’ll refactor the method to retrieve the value from a new dictionary field which we’ll set in the SelectAPositionFor() method:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public class Game
      {
          <b>readonly Dictionary&lt;Player, char> _tokenAssignments = new Dictionary&lt;Player, char>();</b>
          ...
  
          void SelectAPositionFor(Player player)
          {
              int recommendedPosition = 
                  _advisor.WithLayout(new string(_layout)).SelectBestMoveForPlayer(GetTokenFor(player));
              _layout[recommendedPosition - 1] = GetTokenFor(player);
              <b>_lastPositionDictionary[player] = recommendedPosition;</b>
          }
  
          <b>public int GetLastChoiceBy(Player player)
          {
              return _lastPositionDictionary[player];
          }</b>
      }
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <div style="background:#3C0">
      &nbsp;
    </div>
    
    <p>
      &nbsp;
    </p>
    
    <p>
      That was fairly simple. On to our next feature request:
    </p>
    
    <table style="border: 1px solid black;border-collapse: collapse;color: black;width=100%;">
      <tr style="border: 1px solid black;background-color:#DFDFDF">
        <th style="border: 1px solid black;">
          Issue
        </th>
        
        <th style="border: 1px solid black;">
          Description
        </th>
        
        <th style="border: 1px solid black;">
          Owner
        </th>
      </tr>
      
      <tr style="border: 1px solid black;">
        <td style="border: 1px solid black;">
          New Feature
        </td>
        
        <td style="border: 1px solid black;">
          Please modify the ChoosePosition method to throw exceptions for errors rather than returning strings. Additionally, please provide an event we can subscribe to when one of the players wins or when there is a draw.
        </td>
        
        <td style="border: 1px solid black;">
          GUI Team
        </td>
      </tr></table> 
      
      <p>
      </p>
      
      <p>
        This is slightly embarrassing. While we’ve been striving to guide the design of our public interface from a consumer’s perspective, we seem to have made a poor choice in how the game communicates errors and the concluding status of the game. If our Game class had evolved within the context of the consuming application, perhaps we would have seen these choices in a different light.
      </p>
      
      <p>
        Let’s go ahead and get started on the first part of the request which involves changing how errors are reported. First, let’s take inventory of our existing tests which relate to reporting errors. We have two tests which pertain to error conditions:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
      public class When_the_player_attempts_to_select_an_invalid_position
      {
          [TestMethod]
          public void it_should_tell_the_player_the_position_is_invalid()
          {
              var game = new Game();
              string message = game.ChoosePosition(10);
              Assert.AreEqual("That spot is invalid!", message);
          }
      }
  
</div></pre>
      
      <p>
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
      public class When_the_player_attempts_to_select_an_occupied_position
      {
          [TestMethod]
          public void it_should_tell_the_player_the_position_is_occupied()
          {
              var game = new Game(new GameAdvisorStub(new[] { 1, 4, 7 }));
              game.ChoosePosition(2);
              string message = game.ChoosePosition(1);
              Assert.AreEqual("That spot is taken!", message);      
          }
      }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        Starting with the first method, let’s modify it to check that an exception was thrown:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
      public class When_the_player_attempts_to_select_an_invalid_position
      {
          [TestMethod]
          public void it_should_tell_the_player_the_position_is_invalid()
          {
              var game = new Game();
              string message = game.ChoosePosition(10);
              <b>Assert.AreEqual("The position '10' was invalid.", exception.Message);</b>
          }
      }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        Next, let’s wrap the call to the ChoosePosition() method with a try/catch block. We’ll call our exception an InvalidPositionException:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
      public class When_the_player_attempts_to_select_an_invalid_position
      {
          [TestMethod]
          public void it_should_tell_the_player_the_position_is_invalid()
          {
              <b>var exception = new InvalidPositionException(string.Empty);</b>
  
              var game = new Game();
              <b>try
              {
                  game.ChoosePosition(10);
              }
              catch (InvalidPositionException ex)
              {
                  exception = ex;
              }</b>
  
              Assert.AreEqual("The position '10' was invalid.", exception.Message);
          }
      }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        Next, let’s create our new Exception class:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public class InvalidPositionException : Exception
      {
          public InvalidPositionException(string message) : base(message)
          {
          }
      }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        Now, let’s run our tests:
      </p>
      
      <div style="background: red">
        &nbsp;
      </div>
      
      <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_player_attempts_to_select_an_invalid_position
  Failed	it_should_tell_the_player_the_position_is_invalid
  Assert.AreEqual failed. 
  Expected:&lt;The position '10' was invalid.>. Actual:&lt;>. 	
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        Since all we need to do is to throw our new exception, we’ll use an Obvious Implementation:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public string ChoosePosition(int position)
          {
              if (IsOutOfRange(position))
              {
                  <b>throw new InvalidPositionException(
                      string.Format("The position \'{0}\' was invalid.", position));</b>
              }
  
              if (_layout[position - 1] != '\0')
              {
                  return "That spot is taken!";
              }
  
              _layout[position - 1] = GetTokenFor(Player.Human);
              SelectAPositionFor(Player.Game);
  
              if (WinningPlayerIs(Player.Human))
                  return "Player wins!";
  
              if (WinningPlayerIs(Player.Game))
                  return "Game wins.";
  
              return string.Empty;
          }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <div style="background:#3C0">
        &nbsp;
      </div>
      
      <p>
        &nbsp;
      </p>
      
      <p>
        In this case we haven’t introduced any duplication that I can see, so let’s move on to our next test. We’ll modify it to follow the same pattern as our previous one:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
      public class When_the_player_attempts_to_select_an_occupied_position
      {
          [TestMethod]
          public void it_should_tell_the_player_the_position_is_occupied()
          {
              <b>var exception = new OccupiedPositionException(string.Empty);</b>
              var game = new Game(new GameAdvisorStub(new[] {1, 4, 7}));
              game.ChoosePosition(2);
  
              <b>try
              {
                  game.ChoosePosition(1);
              }
              catch (OccupiedPositionException ex)
              {
                  exception = ex;
              }
  
              Assert.AreEqual("The position '1' is already occupied.", exception.Message);</b>
          }
      }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        Here is our new exception:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public class OccupiedPositionException : Exception
      {
          public OccupiedPositionException(string message): base(message)
          {
          }
      }
  
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        Here’s the results of our test execution:
      </p>
      
      <div style="background: red">
        &nbsp;
      </div>
      
      <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_player_attempts_to_select_an_occupied_position
  Failed	it_should_tell_the_player_the_position_is_occupied	
  Assert.AreEqual failed.
  Expected:&lt;The position '1' is already occupied.>. Actual:&lt;>. 	
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        To provide the implementation, we&#8217;ll throw our new exception:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public string ChoosePosition(int position)
          {
              if (IsOutOfRange(position))
              {
                  throw new InvalidPositionException(string.Format("The position \'{0}\' was invalid.", position));
              }
  
              if (_layout[position - 1] != '\0')
              {
                  <b>throw new OccupiedPositionException(
                      string.Format("The position \'{0}\' is already occupied.", position));</b>
              }
  
              _layout[position - 1] = GetTokenFor(Player.Human);
              SelectAPositionFor(Player.Game);
  
              if (WinningPlayerIs(Player.Human))
                  return "Player wins!";
  
              if (WinningPlayerIs(Player.Game))
                  return "Game wins.";
  
              return string.Empty;
          }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <div style="background:#3C0">
        &nbsp;
      </div>
      
      <p>
        &nbsp;
      </p>
      
      <p>
        Again, there isn’t any noticeable duplication this time. Our next task is to send notifications to observers when the Game class detects a winner. Here are the existing tests we used for indicating a winner:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
      public class When_the_player_gets_three_in_a_row
      {
          [TestMethod]
          public void it_should_announce_the_player_as_the_winner()
          {
              var game = new Game(new GameAdvisorStub(new[] {1, 2, 3}));
              game.ChoosePosition(4);
              game.ChoosePosition(5);
              string message = game.ChoosePosition(6);
              Assert.AreEqual("Player wins!", message);
          }
      }
  
</div></pre>
      
      <p>
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
      public class When_the_game_gets_three_in_a_row
      {
          [TestMethod]
          public void it_should_announce_the_game_as_the_winner()
          {
              var game = new Game();
              game.ChoosePosition(4);
              game.ChoosePosition(6);
              string message = game.ChoosePosition(8);
              Assert.AreEqual("Game wins.", message);
          }
      }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        We’ll start with the first one by modifying our Assert call. First, let’s change the value we’re comparing against from a string to a new GameResult enumeration with a value of PlayerWins:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
      public class When_the_player_gets_three_in_a_row
      {
          [TestMethod]
          public void it_should_announce_the_player_as_the_winner()
          {
              var game = new Game(new GameAdvisorStub(new[] {1, 2, 3}));
              game.ChoosePosition(4);
              game.ChoosePosition(5);
              string message = game.ChoosePosition(6);
              <b>Assert.AreEqual(GameResult.PlayerWins, result);</b>
          }
      }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        Next, let’s create an instance of our as yet created GameResult enumeration and initialize it’s value to something we aren’t expecting:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
      public class When_the_player_gets_three_in_a_row
      {
          [TestMethod]
          public void it_should_announce_the_player_as_the_winner()
          {
              var game = new Game(new GameAdvisorStub(new[] {1, 2, 3}));
              <b>var result = (GameResult) (-1);</b>
              game.ChoosePosition(4);
              game.ChoosePosition(5);
              string message = game.ChoosePosition(6);
              Assert.AreEqual(GameResult.PlayerWins, result); 
         }
      }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        Next, we need to decide how we would like to receive this value. Let’s assume we can subscribe to a GameComplete event. When invoked, we’ll assume the value can be retrieved from a property on the EventArgs supplied with the event:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
      public class When_the_player_gets_three_in_a_row
      {
          [TestMethod]
          public void it_should_announce_the_player_as_the_winner()
          {
              var game = new Game(new GameAdvisorStub(new[] {1, 2, 3}));
              var result = (GameResult) (-1);
              <b>game.GameComplete += (s, e) => result = e.Result;</b>
              game.ChoosePosition(4);
              game.ChoosePosition(5);
              game.ChoosePosition(6);
              Assert.AreEqual(GameResult.PlayerWins, result);
          }
      }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        Our next steps are to create the new enum type and to add an event to our Game class. First, let’s create the enum:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public enum GameResult
      {
          PlayerWins,
          GameWins,
          Draw
      }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        I went ahead and added values for the other two possible states: GameWins and Draw. “Aren’t we getting ahead of ourselves”, you might ask? Perhaps, but we already know we have upcoming tests that will require these states and our GameResult represents the state of our game, not its behavior. We’ve been pretty good about not prematurely adding anything thus far, so this seems like a safe enough step to take without sending us down a slippery slope.
      </p>
      
      <p>
        Here’s our new Game event:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public class Game
      {
          ...
  
          <b>public event EventHandler&lt;GameCompleteEventArgs> GameComplete;</b>
  
          ...
      }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        Now that we’ve created this, we’ll also need to create a GameCompleteEventArgs:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public class GameCompleteEventArgs : EventArgs
      {
          public GameResult Result { get; private set; }
      }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        Now we’re ready to compile and run our tests:
      </p>
      
      <div style="background: red">
        &nbsp;
      </div>
      
      <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_player_gets_three_in_a_row
  Failed	it_should_announce_the_player_as_the_winner	
  Assert.AreEqual failed. Expected:&lt;PlayerWins>. Actual:&lt;-1>. 	
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        There are well established patterns for raising events in .Net, so we’ll follow the standard pattern for this:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public string ChoosePosition(int position)
          {
              if (IsOutOfRange(position))
              {
                  throw new InvalidPositionException(string.Format("The position \'{0}\' was invalid.", position));
              }
  
              if (_layout[position - 1] != '\0')
              {
                  throw new OccupiedPositionException(string.Format("The position \'{0}\' is already occupied.", position));
              }
  
              _layout[position - 1] = GetTokenFor(Player.Human);
              SelectAPositionFor(Player.Game);
  
              if (WinningPlayerIs(Player.Human))
                  <b>InvokeGameComplete(new GameCompleteEventArgs(GameResult.PlayerWins));</b>
  
              if (WinningPlayerIs(Player.Game))
                  return "Game wins.";
  
              return string.Empty;
          }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        Now we need to create our InvokeGameComplete() method and a GameCompleteEventArgs constructor that initializes the Result property:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public class Game
      {
          ... 
  
          public event EventHandler&lt;GameCompleteEventArgs> GameComplete;
  
          <b>public void InvokeGameComplete(GameCompleteEventArgs e)
          {
              EventHandler&lt;GameCompleteEventArgs> handler = GameComplete;
              if (handler != null) handler(this, e);
          }</b>
  
          ... 
  
      }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public class GameCompleteEventArgs : EventArgs
      {
          <b>public GameCompleteEventArgs(GameResult result)
          {
              Result = result;
          }</b>
  
          public GameResult Result { get; private set; }
      }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <div style="background:#3C0">
        &nbsp;
      </div>
      
      <p>
        &nbsp;
      </p>
      
      <p>
        Again, I don’t see any duplication to worry about. Next, we’ll follow similar steps for notifying the game as a winner:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
      public class When_the_game_gets_three_in_a_row
      {
          [TestMethod]
          public void it_should_announce_the_game_as_the_winner()
          {
              var game = new Game(new GameAdvisorStub(new[] {1, 2, 3}));
              <b>var result = (GameResult) (-1);
              game.GameComplete += (s, e) => result = e.Result;</b>
              game.ChoosePosition(4);
              game.ChoosePosition(6);
              game.ChoosePosition(8);
              <b>Assert.AreEqual(GameResult.GameWins, result);</b>
          }
      }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <div style="background: red">
        &nbsp;
      </div>
      
      <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_game_gets_three_in_a_row
  Failed	it_should_announce_the_game_as_the_winner
  Assert.AreEqual failed. Expected:&lt;PlayerWins>. Actual:&lt;-1>. 
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        To make the test pass, we should only need to modify the Game class to raise the event this time:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public string ChoosePosition(int position)
          {
              if (IsOutOfRange(position))
              {
                  throw new InvalidPositionException(string.Format("The position \'{0}\' was invalid.", position));
              }
  
              if (_layout[position - 1] != '\0')
              {
                  throw new OccupiedPositionException(string.Format("The position \'{0}\' is already occupied.", position));
              }
  
              _layout[position - 1] = GetTokenFor(Player.Human);
              SelectAPositionFor(Player.Game);
  
              if (WinningPlayerIs(Player.Human))
                  InvokeGameComplete(new GameCompleteEventArgs(GameResult.PlayerWins));
  
              if (WinningPlayerIs(Player.Game))
                  <b>InvokeGameComplete(new GameCompleteEventArgs(GameResult.GameWins));</b>
  
              return string.Empty;
          }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        Let’s run the tests again:
      </p>
      
      <div style="background: red">
        &nbsp;
      </div>
      
      <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_player_gets_three_in_a_row
  Failed	it_should_announce_the_player_as_the_winner
  Assert.AreEqual failed. Expected:&lt;PlayerWins>. Actual:&lt;GameWins>. 	
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        Our target test passed, but we broke our previous test. Looking at our implementation, the problem seems to be that both the player and game select positions on the board before we check to see if anyone is a winner. Additionally, we should return from the method once a winner is determined. Let’s fix this:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public string ChoosePosition(int position)
          {
              if (IsOutOfRange(position))
              {
                  throw new InvalidPositionException(string.Format("The position \'{0}\' was invalid.", position));
              }
  
              if (_layout[position - 1] != '\0')
              {
                  throw new OccupiedPositionException(string.Format("The position \'{0}\' is already occupied.", position));
              }
  
              _layout[position - 1] = GetTokenFor(Player.Human);
              
              <b>if (WinningPlayerIs(Player.Human))
              {
                  InvokeGameComplete(new GameCompleteEventArgs(GameResult.PlayerWins));
                  return string.Empty;
              }</b>
  
              SelectAPositionFor(Player.Game);
              
              <b>if (WinningPlayerIs(Player.Game))
              {
                  InvokeGameComplete(new GameCompleteEventArgs(GameResult.GameWins));
                  return string.Empty;
              }</b>
  
              return string.Empty;
          }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <div style="background:#3C0">
        &nbsp;
      </div>
      
      <p>
        &nbsp;
      </p>
      
      <p>
        Let’s refactor now. First, let’s remove our unused return type:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public <b>void</b> ChoosePosition(int position)
          {
              if (IsOutOfRange(position))
              {
                  throw new InvalidPositionException(string.Format("The position \'{0}\' was invalid.", position));
              }
  
              if (_layout[position - 1] != '\0')
              {
                  throw new OccupiedPositionException(string.Format("The position \'{0}\' is already occupied.", position));
              }
  
              _layout[position - 1] = GetTokenFor(Player.Human);
  
              if (WinningPlayerIs(Player.Human))
              {
                  InvokeGameComplete(new GameCompleteEventArgs(GameResult.PlayerWins));
                  <b>return;</b>
              }
  
  
              SelectAPositionFor(Player.Game);
  
              if (WinningPlayerIs(Player.Game))
              {
                  InvokeGameComplete(new GameCompleteEventArgs(GameResult.GameWins));
                  <b>return;</b>
              }
          }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <div style="background:#3C0">
        &nbsp;
      </div>
      
      <p>
        &nbsp;
      </p>
      
      <p>
        Now that we’ve rearranged our code, we have a sequence of steps that are repeated between the player and the game. First we use a strategy for moving the player, then we check to see if the player wins. Let’s distill this down to checking for the first winning play from a collection of player strategies:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public void ChoosePosition(int position)
  {
      if (IsOutOfRange(position))
      {
          throw new InvalidPositionException(string.Format("The position \'{0}\' was invalid.", position));
      }
  
      if (_layout[position - 1] != '\0')
      {
          throw new OccupiedPositionException(string.Format("The position \'{0}\' is already occupied.", position));
      }
  
      <b>new Func&lt;bool>[]
          {
              () => CheckPlayerStrategy(Player.Human, () => _layout[position - 1] = GetTokenFor(Player.Human)),
              () => CheckPlayerStrategy(Player.Game, () => SelectAPositionFor(Player.Game))
          }.Any(winningPlay => winningPlay());</b>
  }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        Here’s our new CheckPlayerStrategy() method:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  bool CheckPlayerStrategy(Player player, Action strategy)
  {
      strategy();
      if (WinningPlayerIs(player))
      {
          var result = (player == Player.Human) ? GameResult.PlayerWins : GameResult.GameWins;
          InvokeGameComplete(new GameCompleteEventArgs(result));
          return true;
      }
  
      return false;
  }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <div style="background:#3C0">
        &nbsp;
      </div>
      
      <p>
        &nbsp;
      </p>
      
      <p>
        Our final step for this issue is to raise an event when there is a draw. Following our normal procession, here’s the test we come up with:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
      public class When_a_move_results_in_a_draw
      {
          [TestMethod]
          public void it_should_announce_the_game_is_a_draw()
          {
              var game = new Game(new GameAdvisorStub(new[] { 2, 3, 4, 9 }));
              var result = (GameResult)(-1);
              game.GameComplete += (s, e) => result = e.Result;
              new[] {1, 5, 6, 7, 8}.ToList().ForEach(game.ChoosePosition);
              Assert.AreEqual(GameResult.Draw, result);
          }
      }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <div style="background: red">
        &nbsp;
      </div>
      
      <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_a_move_results_in_a_draw
  Failed	it_should_announce_the_game_is_a_draw	
  TestFirstExample.When_a_move_results_in_a_draw.it_should_announce_the_game_is_a_draw threw exception: 
  System.IndexOutOfRangeException: Index was outside the bounds of the array.
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        This test isn’t failing for the right reason, so let&#8217;s address this before moving on. After investigating the exception, the issue is that we never accounted for the fact that their won’t be a position to choose when the player chooses the last remaining position. Let’s correct this issue by ensuring there is an empty spot left before selecting a position for the game:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  void SelectAPositionFor(Player player)
  {
      <b>if (_layout.Any(position => position == '\0'))
      {</b>
          int recommendedPosition =
              _advisor.WithLayout(new string(_layout)).SelectBestMoveForPlayer(GetTokenFor(player));
          _layout[recommendedPosition - 1] = GetTokenFor(player);
          _lastPositionDictionary[player] = recommendedPosition;
      <b>}</b>
  }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <div style="background: red">
        &nbsp;
      </div>
      
      <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_a_move_results_in_a_draw
  Failed	it_should_announce_the_game_is_a_draw	
  Failed	it_should_announce_the_game_is_a_draw
  Assert.AreEqual failed. Expected:&lt;Draw>. Actual:&lt;-1>. 	
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        Now our test is failing for the right reason. To make the test pass, we can fire the event unless someone won or unless there’s any empty positions left:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public void ChoosePosition(int position)
  {
      if (IsOutOfRange(position))
      {
          throw new InvalidPositionException(string.Format("The position \'{0}\' was invalid.", position));
      }
  
      if (_layout[position - 1] != '\0')
      {
          throw new OccupiedPositionException(string.Format("The position \'{0}\' is already occupied.", position));
      }
  
      <b>var someoneWon =</b> new Func&lt;bool>[]
          {
              () => CheckPlayerStrategy(Player.Human, () => _layout[position - 1] = GetTokenFor(Player.Human)),
              () => CheckPlayerStrategy(Player.Game, () => SelectAPositionFor(Player.Game))
          }.Any(winningPlay => winningPlay());
  
      <b>if (!(someoneWon || _layout.Any(pos => pos == '\0')))
      {
          InvokeGameComplete(new GameCompleteEventArgs(GameResult.Draw));
      }</b>
  }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <div style="background:#3C0">
        &nbsp;
      </div>
      
      <p>
        &nbsp;
      </p>
      
      <p>
        Time to refactor. It looks like we have the same comparison for checking that the game is a draw and our new guard for selecting a position for the game. Let’s create a method for these which expresses the meaning of this check:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  bool PositionsAreLeft()
  {
      return _layout.Any(pos => pos == '\0');
  }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <p>
        Now we can replace the previous calls in the ChoosePosition() and SelectAPositionFor() methods:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public void ChoosePosition(int position)
  {
      if (IsOutOfRange(position))
      {
          throw new InvalidPositionException(string.Format("The position \'{0}\' was invalid.", position));
      }
  
      if (_layout[position - 1] != '\0')
      {
          throw new OccupiedPositionException(string.Format("The position \'{0}\' is already occupied.", position));
      }
  
      bool someoneWon = new Func&lt;&lt;bool>[]
                              {
                                  () =>
                                  CheckPlayerStrategy(Player.Human,
                                                      () => _layout[position - 1] = GetTokenFor(Player.Human)),
                                  () => CheckPlayerStrategy(Player.Game, () => SelectAPositionFor(Player.Game))
                              }.Any(winningPlay => winningPlay());
  
      if (!(someoneWon || <b>PositionsAreLeft()</b>))
      {
          InvokeGameComplete(new GameCompleteEventArgs(GameResult.Draw));
      }
  }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  void SelectAPositionFor(Player player)
  {
      if (<b>PositionsAreLeft()</b>)
      {
          int recommendedPosition =
              _advisor.WithLayout(new string(_layout)).SelectBestMoveForPlayer(GetTokenFor(player));
          _layout[recommendedPosition - 1] = GetTokenFor(player);
          _lastPositionDictionary[player] = recommendedPosition;
      }
  }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <div style="background:#3C0">
        &nbsp;
      </div>
      
      <p>
        &nbsp;
      </p>
      
      <p>
        One thing that occurred to me while implementing this feature is that using a null character to represent an empty position isn’t particularly clear. Let’s define a constant named EmptyValue which we’ll substitute for our use of the null character:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public class Game
      {
          ...
  
          <b>const char EmptyValue = char.MinValue;</b>
  
          ...
  
          public void ChoosePosition(int position)
          {
              ...
  
              if (_layout[position - 1] != <b>EmptyValue</b>)
              {
                  throw new OccupiedPositionException(string.Format("The position \'{0}\' is already occupied.", position));
              }
  
              ...
          }
  
          bool PositionsAreLeft()
          {
              return _layout.Any(pos => pos == <b>EmptyValue</b> );
          }
  
          string GetLayoutFor(Player player)
          {
              return new string(_layout.ToList()
                                    .Select(c => (c.Equals(GetTokenFor(player))) ? GetTokenFor(player) : <b>EmptyValue</b> )
                                    .ToArray());
          }
  
          …
  }
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <div style="background:#3C0">
        &nbsp;
      </div>
      
      <p>
        &nbsp;
      </p>
      
      <p>
        That wraps up the two issues from the UI team. We’ll stop here and address the issues from the QA team next time.
      </p>
