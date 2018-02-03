---
wordpress_id: 215
title: 'Effective Tests: A Test-First Example – Part 2'
date: 2011-04-04T12:24:33+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=215
dsq_thread_id:
  - "270649091"
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
      Effective Tests: A Test-First Example – Part 2
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

In [part 1](http://lostechies.com/derekgreer/2011/03/28/effective-tests-a-test-first-example-part-1/) of our Test-First example, we discussed the Test-Driven Development philosophy in more detail and started a Test First implementation of a Tic-tac-toe game component.

Here’s the progress we’ve made on our requirements so far:

<pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  &lt;strike>When the player goes first
  it should put their mark in the selected position
  it should make the next move&lt;/strike>
  
  &lt;strike>When the player gets three in a row
  it should announce the player as the winner&lt;/strike>
  
  &lt;strike>When the game gets three in a row
  it should announce the game as the winner&lt;/strike>
  
  When the player attempts to select an occupied position
  it should tell the player the position is occupied
  	
  When the player attempts to select an invalid position
  it should tell the player the position is invalid
  
  When the player can not win on the next turn
  it should try to get three in a row
  
  When the player can win on the next turn
  it should block the player
  <br />
  
</div></pre>

Also, here is what our Game class implementation looks like so far:

<pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
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
  <br />
  
</div></pre>

Picking up from here, let’s create our next test skeleton:

<pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
     public class When_the_player_attempts_to_select_an_occupied_position
     {
         [TestMethod]
         public void it_should_tell_the_player_the_position_is_occupied()
         {                   
         }
     }
  <br />
  
</div></pre>

Again, we’ll start by determining how we want to validate our requirements. Let’s assume we’ll get a message of “_That spot is taken!_” if we try to choose a position that’s already occupied:

<pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestMethod]
         public void it_should_tell_the_player_the_position_is_occupied()
         {
             <strong>Assert.AreEqual("That spot is taken!", message);</strong>
         }
  <br />
  
</div></pre>

Since our game is choosing positions sequentially, something easy we can do is to choose the second position, leaving the first open for the game to select. We can then attempt to choose the first position which should result in an error message. I wonder whether depending on the game to behave this way is going to cause any issues in the future though. Let&#8217;s move forward with this strategy for now:

<pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestMethod]
         public void it_should_tell_the_player_the_position_is_occupied()
         {
             <strong>var game = new Game();
             game.ChoosePosition(2);
             string message = game.ChoosePosition(1);</strong>
             Assert.AreEqual("That spot is taken!", message);                   
         }
  <br />
  
</div></pre>

<div style="background: red">
  &nbsp;
</div>

<font face="Courier New"></p> 

<pre><div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_player_attempts_to_select_an_occupied_position
  Failed	it_should_tell_the_player_the_position_is_occupied
  Assert.AreEqual failed. Expected:&lt;That spot is taken!&gt;. Actual:&lt;&gt;. 	
  
</div></pre>

<p>
  </font>
</p>

<p>
  As a reminder, we want to get our test to pass quickly. Since we can do this with an Obvious Implementation of checking if the position already has a value other than null and returning the expected error message, let&#8217;s do that this time:
</p>

<pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public string ChoosePosition(int position)
         { 
             if(_layout[position -1] != '\0')
             {
                 return "That spot is taken!";
             }
  
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
  <br />
  
</div></pre>

<p>
  It&#8217;s time to run the tests again:
</p>

<div style="background: red">
  &nbsp;
</div>

<p>
  <font face="Courier New"></p> 
  
  <pre><div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_player_gets_three_in_a_row
  Failed	it_should_announce_the_player_as_the_winner
  Assert.AreEqual failed. Expected:&lt;Player wins!&gt;. Actual:&lt;&gt;. 	
  
</div></pre>
  
  <p>
    </font>
  </p>
  
  <p>
    Our target test passed, but our changes broke one of the previous tests. The failing test was the one that checks that the player wins when getting three in a row. For our context setup, we just selected the first three positions without worrying about whether the positions were occupied or not. This was our third test and at that point we weren&#8217;t concerned with how the game was going to determine its moves, but it seems this decision wasn&#8217;t without some trade-offs. For now, we can just avoid the first three positions, but I&#8217;m starting to wonder if another strategy is in order. Perhaps a solution will reveal itself in time. To avoid the conflict, we&#8217;ll select positions from the middle row:
  </p>
  
  <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestMethod]
         public void it_should_announce_the_player_as_the_winner()
         {
             var game = new Game();
             game.ChoosePosition(<strong>4</strong>);
             game.ChoosePosition(<strong>5</strong>);
             string message = game.ChoosePosition(<strong>6</strong>);
             Assert.AreEqual("Player wins!", message);
         }
  <br />
  
</div></pre>
  
  <div style="background:#3C0">
    &nbsp;
  </div>
  
  <p>
    &nbsp;
  </p>
  
  <p>
    We’re green again for now. Let’s move on to our next test:
  </p>
  
  <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
     public class When_the_player_attempts_to_select_an_invalid_position
     {
         [TestMethod]
         public void it_should_tell_the_player_the_position_is_invalid()
         {            
         }
     }
  <br />
  
</div></pre>
  
  <p>
    Similar to our previous test, let’s assume a message is returned of “<i>That spot is invalid!</i>”:
  </p>
  
  <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
     public class When_the_player_attempts_to_select_an_invalid_position
     {
         [TestMethod]
         public void it_should_tell_the_player_the_position_is_invalid()
         {
             <strong>Assert.AreEqual("That spot is invalid!", message);</strong>
         }
     }
  <br />
  
</div></pre>
  
  <p>
    Now, let&#8217;s establish a context which should result in this behavior:
  </p>
  
  <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
      public class When_the_player_attempts_to_select_an_invalid_position
      {
          [TestMethod]
          public void it_should_tell_the_player_the_position_is_invalid()
          {
              <strong>var game = new Game();
              string message = game.ChoosePosition(10);</strong>
              Assert.AreEqual("That spot is invalid!", message);
          }
      }
  <br />
  
</div></pre>
  
  <p>
    Time to run the tests:
  </p>
  
  <div style="background: red">
    &nbsp;
  </div>
  
  <p>
    <font face="Courier New"></p> 
    
    <pre><div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_player_attempts_to_select_an_invalid_position
  Failed	it_should_tell_the_player_the_position_is_invalid
  TestFirstExample.When_the_player_attempts_to_select_an_invalid_position
  .it_should_tell_the_player_the_position_is_invalid threw exception:
  System.IndexOutOfRangeException: Index was outside the bounds of the array.
  
</div></pre>
    
    <p>
      </font>
    </p>
    
    <p>
      The test failed, but not for the right reason. Let’s modify the Game class to return an unexpected value to validate our test:
    </p>
    
    <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public string ChoosePosition(int position)
         {
             <strong>if (position == 10)
             {
                 return string.Empty;
             }</strong>
  
             if (_layout[position - 1] != '\0')
             {
                 return "That spot is taken!";
             }
  
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
  <br />
  
</div></pre>
    
    <div style="background:red">
      &nbsp;
    </div>
    
    <p>
      <font face="Courier New"></p> 
      
      <pre><div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_player_attempts_to_select_an_invalid_position
  Failed	it_should_tell_the_player_the_position_is_invalid	
  Assert.AreEqual failed. Expected:&lt;That spot is invalid!&gt;. Actual:&lt;&gt;. 	
  
</div></pre>
      
      <p>
        </font>
      </p>
      
      <p>
        Now we can work on getting the test to pass. We can modify the Game class to check that the position falls within the allowable range about as quickly as we could use a fake implementation, so let’s just do that:
      </p>
      
      <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public string ChoosePosition(int position)
         {
             <strong>if (position  9)
             {
                 return "That spot is invalid!";
             }</strong>
  
             if (_layout[position - 1] != '\0')
             {
                 return "That spot is taken!";
             }
  
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
  <br />
  
</div></pre>
      
      <p>
        &nbsp;
      </p>
      
      <div style="background:#3C0">
        &nbsp;
      </div>
      
      <p>
        &nbsp;
      </p>
      
      <p>
        Now, let&#8217;s refactor. While other issues may exist, the only duplication I see right now is that our new error checking duplicates knowledge about the size of the board. Since we need to modify this anyway, let’s go ahead and pull this section out into a separate method which describes what our intentions are:
      </p>
      
      <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public string ChoosePosition(int position)
         {
             if (<strong>IsOutOfRange(position)</strong>)
             {
                 return "That spot is invalid!";
             }
  
             if (_layout[position - 1] != '\0')
             {
                 return "That spot is taken!";
             }
  
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
  
         <strong>bool IsOutOfRange(int position)
         {
             return position  _layout.Count();
         }</strong>
  
</div></pre>
      
      <div style="background:#3C0">
        &nbsp;
      </div>
      
      <p>
        &nbsp;
      </p>
      
      <p>
        Let’s move on to our next test to describe what happens when the game goes first:
      </p>
      
      <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
     public class When_the_game_goes_first
     {
         [TestMethod]
         public void it_should_put_an_X_in_one_of_the_available_positions()
         {            
         }
     }
  <br />
  
</div></pre>
      
      <p>
        To check that the game puts an ‘X’ in one of the positions, let’s use another enumerable range to check all of the positions for the expected value:
      </p>
      
      <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestMethod]
         public void it_should_put_an_X_in_one_of_the_available_positions()
         {
             <strong>Assert.IsTrue(Enumerable.Range(1, 9)
                 .Any(position =&gt; game.GetPosition(position).Equals('X')));</strong>
         }
  <br />
  
</div></pre>
      
      <p>
        Right now, our game only moves after we’ve chosen a position. We need a way of telling the game to go first, so let’s call a method called GoFirst():
      </p>
      
      <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestMethod]
         public void it_should_put_an_X_in_one_of_the_available_positions()
         {
             <strong>var game = new Game();
             game.GoFirst();</strong>
             Assert.IsTrue(Enumerable.Range(1, 9)
                 .Any(position =&gt; game.GetPosition(position).Equals('X')));
         }
  <br />
  
</div></pre>
      
      <p>
        Next, we’ll need to add our new method:
      </p>
      
      <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public class Game
     {
         // ...
  
         <strong>public void GoFirst()
         {
  
         }</strong>
     }
  <br />
  
</div></pre>
      
      <p>
        We’re ready to run the tests:
      </p>
      
      <div style="background: red">
        &nbsp;
      </div>
      
      <p>
        <font face="Courier New"></p> 
        
        <pre><div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_game_goes_first
  Failed	it_should_put_an_X_in_one_of_the_available_positions
  Assert.IsTrue failed.
  
</div></pre>
        
        <p>
          </font>
        </p>
        
        <p>
          At this point we may have some ideas about how we might implement this, but there isn’t an obvious way I can think of that would only take a few seconds to write, so let’s Fake It again:
        </p>
        
        <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public void GoFirst()
         {
             <strong>_layout[0] = 'X';</strong>
         }
  <br />
  
</div></pre>
        
        <div style="background:#3C0">
          &nbsp;
        </div>
        
        <p>
          &nbsp;
        </p>
        
        <p>
          Refactor time! As a first step, let&#8217;s copy the code we&#8217;re using in the ChoosePosition() to find the first available position and use it to assign the value &#8216;X&#8217;:
        </p>
        
        <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public void GoFirst()
       {
           <strong>int firstUnoccupied = Enumerable.Range(0, _layout.Length)
                                           .First(p =&gt; _layout[p].Equals('\0'));
           _layout[firstUnoccupied] = 'X';</strong>
       }
  <br />
  
</div></pre>
        
        <div style="background:#3C0">
          &nbsp;
        </div>
        
        <p>
          &nbsp;
        </p>
        
        <p>
          Next, let’s factor out a method to remove the duplication between these two methods:
        </p>
        
        <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  void SelectAPositionFor(char value)
       {
           int firstUnoccupied = Enumerable.Range(0, _layout.Length)
               .First(p =&gt; _layout[p].Equals('\0'));
           _layout[firstUnoccupied] = value;
       }
  <br />
  
</div></pre>
        
        <p>
          Now we can replace the locations in the ChoosePosition() and GoFirst() methods to call our new method:
        </p>
        
        <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public string ChoosePosition(int position)
         {
             if (IsOutOfRange(position))
             {
                 return "That spot is invalid!";
             }
  
             if (_layout[position - 1] != '\0')
             {
                 return "That spot is taken!";
             }
  
             _layout[position - 1] = 'X';
             <strong>SelectAPositionFor('O');</strong>
  
             if (WinningPlayerIs('X'))
                 return "Player wins!";
  
             if (WinningPlayerIs('O'))
                 return "Game wins.";
  
             return string.Empty;
         }
  
  
         public void GoFirst()
         {
             SelectAPositionFor('X');
         }
  
</div></pre>
        
        <div style="background:#3C0">
          &nbsp;
        </div>
        
        <p>
          &nbsp;
        </p>
        
        <p>
          We now have two places where the game determines what token it’s using, so let’s fix this. Let’s add a new method called GetTokenFor() which will determine whether the game is assigned an ‘X’ or an ‘O’. We’ll pass it a string of “game”, but we’ll just hard-code it to assign ‘X’ for now and see where this takes us:
        </p>
        
        <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public void GoFirst()
       {
           <strong>char token = GetTokenFor("game");</strong>
           SelectAPositionFor(<strong>token</strong>);
       }
  
       <strong>char GetTokenFor(string player)
       {
           return 'X';
       }</strong>
  <br />
  
</div></pre>
        
        <div style="background:#3C0">
          &nbsp;
        </div>
        
        <p>
          &nbsp;
        </p>
        
        <p>
          In order for our GetTokenFor() method to assign a token conditionally, it will need some way of figuring out who’s going first. If we keep track of the assignments in a dictionary, then this should be fairly straight forward:
        </p>
        
        <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  Dictionary&lt;string, char&gt; _tokenAssignments = new Dictionary&lt;string, char&gt;();
  
       char GetTokenFor(string player)
       {
           <strong>var nextToken = (_tokenAssignments.Count == 0) ? 'X' : 'O';
  
           if (_tokenAssignments.ContainsKey(player))
               return _tokenAssignments[player];
  
           return _tokenAssignments[player] = nextToken;</strong>
       }
   }
  
  <br />
  
</div></pre>
        
        <div style="background:#3C0">
          &nbsp;
        </div>
        
        <p>
          &nbsp;
        </p>
        
        <p>
          Next, let’s change the ChoosePosition() method to use our new method instead of the hard-coded assignments:
        </p>
        
        <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public string ChoosePosition(int position)
       {
           if (IsOutOfRange(position))
           {
               return "That spot is invalid!";
           }
  
           if (_layout[position - 1] != '\0')
           {
               return "That spot is taken!";
           }
  
           _layout[position - 1] = <strong>GetTokenFor("player");</strong>
           SelectAPositionFor(<strong>GetTokenFor("game")</strong>);
  
           if (WinningPlayerIs('X'))
               return "Player wins!";
  
           if (WinningPlayerIs('O'))
               return "Game wins.";
  
           return string.Empty;
       }
  
</div></pre>
        
        <p>
          &nbsp;
        </p>
        
        <div style="background:#3C0">
          &nbsp;
        </div>
        
        <p>
          &nbsp;
        </p>
        
        <p>
          <P>
            These changes have introduced some duplication in the form of magic strings, so let’s get rid of that. We can define an Enum to identify our players rather than using strings:
          </p>
          
          <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public enum Player
   {
       Human,
       Game
   }
  <br />
  
</div></pre>
          
          <p>
            Now we can change our dictionary, the GetTokenFor() method parameter type and the calls to GetTokenFor() from the ChoosePosition() and GoFirst() methods to use the new Enum:
          </p>
          
          <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  readonly Dictionary&lt;<strong>Player</strong>, char&gt; _tokenAssignments =
      new Dictionary&lt;<strong>Player</strong>, char&gt;();
  
  
       char GetTokenFor(<strong>Player</strong> player)
       {
           char nextToken = (_tokenAssignments.Count == 0) ? 'X' : 'O';
  
           if (_tokenAssignments.ContainsKey(player))
               return _tokenAssignments[player];
  
           return _tokenAssignments[player] = nextToken;
       }
  
  
       public string ChoosePosition(int position)
       {
           if (IsOutOfRange(position))
           {
               return "That spot is invalid!";
           }
  
           if (_layout[position - 1] != '\0')
           {
               return "That spot is taken!";
           }
  
           _layout[position - 1] = GetTokenFor(<strong>Player.Human</strong>);
           SelectAPositionFor(GetTokenFor(<strong>Player.Game</strong>));
  
           if (WinningPlayerIs('X'))
               return "Player wins!";
  
           if (WinningPlayerIs('O'))
               return "Game wins.";
  
           return string.Empty;
       }
  
  
         public void GoFirst()
         {
             char token = GetTokenFor(<strong>Player.Game</strong>);
             SelectAPositionFor(token);
         }
  
  
</div></pre>
          
          <p>
            &nbsp;
          </p>
          
          <div style="background:#3C0">
            &nbsp;
          </div>
          
          <p>
            &nbsp;
          </p>
          
          <p>
            Now that we know this works, let’s refactor the rest of the methods that are still relying upon character values to identify the player along with their associated calls:
          </p>
          
          <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  bool WinningPlayerIs(<strong>Player</strong> player)
       {
           return _winningPatterns
               .Any(pattern =&gt; Regex.IsMatch(GetLayoutFor(player), pattern));
       }
  
  
         string GetLayoutFor(Player player)
         {
             return new string(_layout.ToList()
                 .Select(c =&gt; (c.Equals(<strong>GetTokenFor(player)</strong>)) ? <strong>GetTokenFor(player)</strong>
                                                              : '\0')
                 .ToArray());
         }
  
  
         void SelectAPositionFor(<strong>Player</strong> player)
         {
             int firstUnoccupied = Enumerable.Range(0, _layout.Length)
                                             .First(p =&gt; _layout[p].Equals('\0'));
             _layout[firstUnoccupied] = <strong>GetTokenFor(player)</strong>;
         }
  
  
         public void GoFirst()
         {
             <strong>SelectAPositionFor(Player.Game);</strong>
         }
  
  
         public string ChoosePosition(int position)
         {
             if (IsOutOfRange(position))
             {
                 return "That spot is invalid!";
             }
  
             if (_layout[position - 1] != '\0')
             {
                 return "That spot is taken!";
             }
  
             _layout[position - 1] = GetTokenFor(Player.Human);
             SelectAPositionFor(<strong>Player.Game</strong>);
  
             if (WinningPlayerIs(<strong>Player.Human</strong>))
                 return "Player wins!";
  
             if (WinningPlayerIs(<strong>Player.Game</strong>))
                 return "Game wins.";
  
             return string.Empty;
         }
  <br />
  
</div></pre>
          
          <div style="background:#3C0">
            &nbsp;
          </div>
          
          <p>
            &nbsp;
          </p>
          
          <p>
            Here’s what we have so far:
          </p>
          
          <pre><div style="background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public class Game
     {
         readonly char[] _layout = new char[9];
         readonly Dictionary&lt;Player, char&gt; _tokenAssignments =
             new Dictionary&lt;Player, char&gt;();
  
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
             if (IsOutOfRange(position))
             {
                 return "That spot is invalid!";
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
  
         bool IsOutOfRange(int position)
         {
             return position &lt; 1 || position &gt; _layout.Count();
         }
  
         bool WinningPlayerIs(Player player)
         {
             return _winningPatterns
                 .Any(pattern =&gt; Regex.IsMatch(GetLayoutFor(player), pattern));
         }
  
         string GetLayoutFor(Player player)
         {
             return new string(_layout.ToList()
                                   .Select(c =&gt; (c.Equals(GetTokenFor(player)))
                                       ? GetTokenFor(player) : '\0')
                                   .ToArray());
         }
  
         public char GetPosition(int position)
         {
             return _layout[position - 1];
         }
  
         public void GoFirst()
         {
             SelectAPositionFor(Player.Game);
         }
  
         char GetTokenFor(Player player)
         {
             char nextToken = (_tokenAssignments.Count == 0) ? 'X' : 'O';
  
             if (_tokenAssignments.ContainsKey(player))
                 return _tokenAssignments[player];
  
             return _tokenAssignments[player] = nextToken;
         }
  
         void SelectAPositionFor(Player player)
         {
             int firstUnoccupied = Enumerable.Range(0, _layout.Length)
                                             .First(p =&gt; _layout[p].Equals('\0'));
             _layout[firstUnoccupied] = GetTokenFor(player);
         }
     }
  <br />
  
</div></pre>
          
          <p>
            We&#8217;ve only got two more requirements to go, but we&#8217;ll leave things here for now. Next time, we&#8217;ll complete our requirements by tackling what looks to be the most interesting portion of our game and perhaps we&#8217;ll discover a solution to our coupling woes in the process.
          </p>
