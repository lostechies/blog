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

<style>
span.highlight
{
  font-weight: 500;
  background-color: #ffffe0;
}
pre.code
{
  font-size: 1em;
  font-family: "Open Sans", sans-serif, Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;
  background-color: #eef;
  border: 1px solid black;
  border-collapse: collapse;
  color: black;
  float: none;
  font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;
  font-style: normal;
  font-variant: normal;
  font-weight: normal;
  line-height: 20px;
  padding: 5px;
  text-align: left;
  vertical-align: baseline;
}
pre.story
{
  border: none;
  padding: 0;
}
</style>

<div>
  <ul>
    <li>
      <a href="/derekgreer/2011/03/07/effective-tests-introduction/">Effective Tests: Introduction</a>
    </li>
    <li>
      <a href="/derekgreer/2011/03/14/effective-tests-a-unit-test-example/">Effective Tests: A Unit Test Example</a>
    </li>
    <li>
      <a href="/derekgreer/2011/03/21/effective-tests-test-first/">Effective Tests: Test First</a>
    </li>
    <li>
      <a href="/derekgreer/2011/03/28/effective-tests-a-test-first-example-part-1/">Effective Tests: A Test-First Example – Part 1</a>
    </li>
    <li>
      <a href="/derekgreer/2011/03/29/effective-tests-how-faking-it-can-help-you/">Effective Tests: How Faking It Can Help You</a>
    </li>
    <li>
      Effective Tests: A Test-First Example – Part 2
    </li>
    <li>
      <a href="/derekgreer/2011/04/11/effective-tests-a-test-first-example-part-3/">Effective Tests: A Test-First Example – Part 3</a>
    </li>
    <li>
      <a href="/derekgreer/2011/04/24/effective-tests-a-test-first-example-part-4/">Effective Tests: A Test-First Example – Part 4</a>
    </li>
    <li>
      <a href="/derekgreer/2011/05/01/effective-tests-a-test-first-example-part-5/">Effective Tests: A Test-First Example – Part 5</a>
    </li>
    <li>
      <a href="/derekgreer/2011/05/12/effective-tests-a-test-first-example-part-6/">Effective Tests: A Test-First Example – Part 6</a>
    </li>
    <li>
      <a href="/derekgreer/2011/05/15/effective-tests-test-doubles/">Effective Tests: Test Doubles</a>
    </li>
    <li>
      <a href="/derekgreer/2011/05/26/effective-tests-double-strategies/">Effective Tests: Double Strategies</a>
    </li>
    <li>
      <a href="/derekgreer/2011/05/31/effective-tests-auto-mocking-containers/">Effective Tests: Auto-mocking Containers</a>
    </li>
    <li>
      <a href="/derekgreer/2011/06/11/effective-tests-custom-assertions/">Effective Tests: Custom Assertions</a>
    </li>
    <li>
      <a href="/derekgreer/2011/06/24/effective-tests-expected-objects/">Effective Tests: Expected Objects</a>
    </li>
    <li>
      <a href="/derekgreer/2011/07/19/effective-tests-avoiding-context-obscurity/">Effective Tests: Avoiding Context Obscurity</a>
    </li>
    <li>
      <a href="/derekgreer/2011/09/05/effective-tests-acceptance-tests/">Effective Tests: Acceptance Tests</a>
    </li>
  </ul>
</div>

In [part 1](/derekgreer/2011/03/28/effective-tests-a-test-first-example-part-1/) of our Test-First example, we discussed the Test-Driven Development philosophy in more detail and started a Test First implementation of a Tic-tac-toe game component.

Here's the progress we've made on our requirements so far:

<pre class="story" style="border-bottom: black 1px solid;text-align: left;border-left: black 1px solid;padding-bottom: 5px;line-height: 20px;background-color: #ffffe0;font-variant: normal;font-style: normal;padding-left: 5px;padding-right: 5px;border-collapse: collapse;float: none;color: black;font-size: 12px;vertical-align: baseline;border-top: black 1px solid;font-weight: normal;border-right: black 1px solid;padding-top: 5px">
  <strike>When the player goes first</strike>
  <strike>it should put their mark in the selected position</strike>
  <strike>it should make the next move</strike>
  
  <strike>When the player gets three in a row</strike>
  <strike>it should announce the player as the winner</strike>
  
  <strike>When the game gets three in a row</strike>
  <strike>it should announce the game as the winner</strike>
  
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
</pre>

Also, here is what our Game class implementation looks like so far:

<pre class="code">
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
          .First(p => _layout[p].Equals('\0'));
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
          .Any(pattern => Regex.IsMatch(GetLayoutFor(player), pattern));
      }

      string GetLayoutFor(char player)
      {
        return new string(_layout.ToList()
            .Select(c => (c.Equals(player)) ? player : '\0')
            .ToArray());
      }

      public char GetPosition(int position)
      {
        return _layout[position - 1];
      }
    }
</pre>

Picking up from here, let's create our next test skeleton:

<pre class="code">
  [TestClass]
  public class When_the_player_attempts_to_select_an_occupied_position
  {
      [TestMethod]
      public void it_should_tell_the_player_the_position_is_occupied()
      {                   
      }
  }
</pre>

Again, we'll start by determining how we want to validate our requirements. Let's assume we'll get a message of “_That spot is taken!_” if we try to choose a position that's already occupied:

<pre class="code">
  [TestMethod]
  public void it_should_tell_the_player_the_position_is_occupied()
  {
      <span class="highlight">Assert.AreEqual("That spot is taken!", message);</span>
  }
</pre>

Since our game is choosing positions sequentially, something easy we can do is to choose the second position, leaving the first open for the game to select. We can then attempt to choose the first position which should result in an error message. I wonder whether depending on the game to behave this way is going to cause any issues in the future though. Let's move forward with this strategy for now:

<pre class="code">
  [TestMethod]
  public void it_should_tell_the_player_the_position_is_occupied()
  {
      <span class="highlight">var game = new Game();</span>
      <span class="highlight">game.ChoosePosition(2);</span>
      <span class="highlight">string message = game.ChoosePosition(1);</span>
      Assert.AreEqual("That spot is taken!", message);                   
  }
</pre>

<p></p>

<div style="background: red">
&nbsp;
</div>
<div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_player_attempts_to_select_an_occupied_position
  Failed	it_should_tell_the_player_the_position_is_occupied
  Assert.AreEqual failed. Expected:<That spot is taken!>. Actual:<>. 	
</div>

<p>
  As a reminder, we want to get our test to pass quickly. Since we can do this with an Obvious Implementation of checking if the position already has a value other than null and returning the expected error message, let's do that this time:
</p>

<pre class="code">
  public string ChoosePosition(int position)
  { 
      if(_layout[position -1] != '\0')
      {
          return "That spot is taken!";
      }
 
       _layout[position - 1] = 'X';
       int firstUnoccupied = Enumerable.Range(0, _layout.Length)
                                       .First(p => _layout[p].Equals('\0'));
       _layout[firstUnoccupied] = 'O';

       if (WinningPlayerIs('X'))
           return "Player wins!";

       if (WinningPlayerIs('O'))
           return "Game wins.";

       return string.Empty;
  }
</pre>

<p>
  It's time to run the tests again:
</p>

<div style="background: red">
&nbsp;
</div>
<div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_player_gets_three_in_a_row
  Failed	it_should_announce_the_player_as_the_winner
  Assert.AreEqual failed. Expected:<Player wins!>. Actual:<>. 	
  
</div>
  
 Our target test passed, but our changes broke one of the previous tests. The failing test was the one that checks that the player wins when getting three in a row. For our context setup, we just selected the first three positions without worrying about whether the positions were occupied or not. This was our third test and at that point we weren't concerned with how the game was going to determine its moves, but it seems this decision wasn't without some trade-offs. For now, we can just avoid the first three positions, but I'm starting to wonder if another strategy is in order. Perhaps a solution will reveal itself in time. To avoid the conflict, we'll select positions from the middle row:
  
<pre class="code">
  [TestMethod]
  public void it_should_announce_the_player_as_the_winner()
  {
      var game = new Game();
      game.ChoosePosition(<span class="highlight">4</span>);
      game.ChoosePosition(<span class="highlight">5</span>);
      string message = game.ChoosePosition(<span class="highlight">6</span>);
      Assert.AreEqual("Player wins!", message);
  }
</pre>
 
<p></p>
 
<div style="background:#3C0">
&nbsp;
</div>
  
<p>
  We're green again for now. Let's move on to our next test:
</p>
  
<pre class="code">
  [TestClass]
  public class When_the_player_attempts_to_select_an_invalid_position
  {
      [TestMethod]
      public void it_should_tell_the_player_the_position_is_invalid()
      {            
      }
  }
</pre>
  
<p>
Similar to our previous test, let's assume a message is returned of “<i>That spot is invalid!</i>”:
</p>
  
<pre class="code">
  [TestClass]
  public class When_the_player_attempts_to_select_an_invalid_position
  {
      [TestMethod]
      public void it_should_tell_the_player_the_position_is_invalid()
      {
          <span class="highlight">Assert.AreEqual("That spot is invalid!", message);</span>
      }
  }
</pre>
  
  <p>
    Now, let's establish a context which should result in this behavior:
  </p>
  
<pre class="code">
  [TestClass]
  public class When_the_player_attempts_to_select_an_invalid_position
  {
      [TestMethod]
      public void it_should_tell_the_player_the_position_is_invalid()
      {
          <span class="highlight">var game = new Game();</span>
          <span class="highlight">string message = game.ChoosePosition(10);</span>
          Assert.AreEqual("That spot is invalid!", message);
      }
  }
</pre>
  
<p>
Time to run the tests:
</p>
  
<div style="background: red">
&nbsp;
</div>
<div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_player_attempts_to_select_an_invalid_position
  Failed	it_should_tell_the_player_the_position_is_invalid
  TestFirstExample.When_the_player_attempts_to_select_an_invalid_position
  .it_should_tell_the_player_the_position_is_invalid threw exception:
  System.IndexOutOfRangeException: Index was outside the bounds of the array.
  
</div>
    
<p>
  The test failed, but not for the right reason. Let's modify the Game class to return an unexpected value to validate our test:
</p>
    
<pre class="code">
  public string ChoosePosition(int position)
  {
      <span class="highlight">if (position == 10)</span>
      <span class="highlight">{</span>
          <span class="highlight">return string.Empty;</span>
      <span class="highlight">}</span>

      if (_layout[position - 1] != '\0')
      {
          return "That spot is taken!";
      }

      _layout[position - 1] = 'X';
      int firstUnoccupied = Enumerable.Range(0, _layout.Length)
                                      .First(p => _layout[p].Equals('\0'));
      _layout[firstUnoccupied] = 'O';

      if (WinningPlayerIs('X'))
          return "Player wins!";

      if (WinningPlayerIs('O'))
          return "Game wins.";

      return string.Empty;
  }
</pre>

<p></p>
    
<div style="background: red">
&nbsp;
</div>
<div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_player_attempts_to_select_an_invalid_position
  Failed	it_should_tell_the_player_the_position_is_invalid	
  Assert.AreEqual failed. Expected:<That spot is invalid!>. Actual:<>. 	
  
</div>
      
<p>
Now we can work on getting the test to pass. We can modify the Game class to check that the position falls within the allowable range about as quickly as we could use a fake implementation, so let's just do that:
</p>
      
<pre class="code">
  public string ChoosePosition(int position)
  {
      <span class="highlight">if (position  9)</span>
      <span class="highlight">{</span>
          <span class="highlight">return "That spot is invalid!";</span>
      <span class="highlight">}</span>

      if (_layout[position - 1] != '\0')
      {
          return "That spot is taken!";
      }

      _layout[position - 1] = 'X';
      int firstUnoccupied = Enumerable.Range(0, _layout.Length)
                                      .First(p => _layout[p].Equals('\0'));
      _layout[firstUnoccupied] = 'O';

      if (WinningPlayerIs('X'))
          return "Player wins!";

      if (WinningPlayerIs('O'))
          return "Game wins.";

      return string.Empty;
  }
</pre>
      
<p></p>
      
<div style="background:#3C0">
&nbsp;
</div>
      
<p>
Now, let's refactor. While other issues may exist, the only duplication I see right now is that our new error checking duplicates knowledge about the size of the board. Since we need to modify this anyway, let's go ahead and pull this section out into a separate method which describes what our intentions are:
</p>
      
<pre class="code">
  public string ChoosePosition(int position)
  {
      if (<span class="highlight">IsOutOfRange(position)</span>)
      {
          return "That spot is invalid!";
      }
 
      if (_layout[position - 1] != '\0')
      {
          return "That spot is taken!";
      }

      _layout[position - 1] = 'X';
      int firstUnoccupied = Enumerable.Range(0, _layout.Length)
                                      .First(p => _layout[p].Equals('\0'));
      _layout[firstUnoccupied] = 'O';

      if (WinningPlayerIs('X'))
          return "Player wins!";

      if (WinningPlayerIs('O'))
          return "Game wins.";

      return string.Empty;
  }

  <span class="highlight">bool IsOutOfRange(int position)</span>
  <span class="highlight">{</span>
      <span class="highlight">return position  _layout.Count();</span>
  <span class="highlight">}</span>
</pre>

<p></p>
      
<div style="background:#3C0">
&nbsp;
</div>
      
<p>
Let's move on to our next test to describe what happens when the game goes first:
</p>
      
<pre class="code">
  [TestClass]
  public class When_the_game_goes_first
  {
      [TestMethod]
      public void it_should_put_an_X_in_one_of_the_available_positions()
      {            
      }
  }
</pre>
      
<p>
  To check that the game puts an 'X' in one of the positions, let's use another enumerable range to check all of the positions for the expected value:
</p>
      
<pre class="code">
  [TestMethod]
  public void it_should_put_an_X_in_one_of_the_available_positions()
  {
      <span class="highlight">Assert.IsTrue(Enumerable.Range(1, 9)</span>
          <span class="highlight">.Any(position => game.GetPosition(position).Equals('X')));</span>
  }
</pre>
      
<p>
Right now, our game only moves after we've chosen a position. We need a way of telling the game to go first, so let's call a method called GoFirst():
</p>
      
<pre class="code">
  [TestMethod]
  public void it_should_put_an_X_in_one_of_the_available_positions()
  {
      <span class="highlight">var game = new Game();</span>
      <span class="highlight">game.GoFirst();</span>
      Assert.IsTrue(Enumerable.Range(1, 9)
          .Any(position => game.GetPosition(position).Equals('X')));
  }
</pre>
      
<p>
Next, we'll need to add our new method:
</p>
      
<pre class="code">
  public class Game
  {
      // ...

      <span class="highlight">public void GoFirst()</span>
      <span class="highlight">{</span>

      <span class="highlight">}</span>
  }
</pre>
      
<p>
We're ready to run the tests:
</p>
      
<div style="background: red">
&nbsp;
</div>
<div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_game_goes_first
  Failed	it_should_put_an_X_in_one_of_the_available_positions
  Assert.IsTrue failed.
  
</div>
        
At this point we may have some ideas about how we might implement this, but there isn't an obvious way I can think of that would only take a few seconds to write, so let's Fake It again:
        
<pre class="code">
  public void GoFirst()
  {
      <span class="highlight">_layout[0] = 'X';</span>
  }
  <br />
</pre>

<p></p>
        
<div style="background:#3C0">
&nbsp;
</div>
    
<p>
Refactor time! As a first step, let's copy the code we're using in the ChoosePosition() to find the first available position and use it to assign the value &#8216;X':
</p>
        
<pre class="code">
  public void GoFirst()
  {
      <span class="highlight">int firstUnoccupied = Enumerable.Range(0, _layout.Length)</span>
                                      <span class="highlight">.First(p => _layout[p].Equals('\0'));</span>
      <span class="highlight">_layout[firstUnoccupied] = 'X';</span>
  }
</pre>

<p></p>
        
<div style="background:#3C0">
&nbsp;
</div>
        
<p>
Next, let's factor out a method to remove the duplication between these two methods:
</p>
        
<pre class="code">
  void SelectAPositionFor(char value)
  {
      int firstUnoccupied = Enumerable.Range(0, _layout.Length)
          .First(p => _layout[p].Equals('\0'));
      _layout[firstUnoccupied] = value;
  }
</pre>
        
<p>
Now we can replace the locations in the ChoosePosition() and GoFirst() methods to call our new method:
</p>
        
<pre class="code">
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
      <span class="highlight">SelectAPositionFor('O');</span>

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
</pre>

<p></p>
        
<div style="background:#3C0">
&nbsp;
</div>
        
        
<p>
We now have two places where the game determines what token it's using, so let's fix this. Let's add a new method called GetTokenFor() which will determine whether the game is assigned an ‘X' or an ‘O'. We'll pass it a string of “game”, but we'll just hard-code it to assign ‘X' for now and see where this takes us:
</p>
       
<pre class="code">
  public void GoFirst()
  {
      <span class="highlight">char token = GetTokenFor("game");</span>
      SelectAPositionFor(<span class="highlight">token</span>);
  }

  <span class="highlight">char GetTokenFor(string player)</span>
  <span class="highlight">{</span>
      <span class="highlight">return 'X';</span>
  <span class="highlight">}</span>
</pre>

<p></p>
        
<div style="background:#3C0">
&nbsp;
</div>
       
<p>
In order for our GetTokenFor() method to assign a token conditionally, it will need some way of figuring out who's going first. If we keep track of the assignments in a dictionary, then this should be fairly straight forward:
</p>
        
<pre class="code">
  Dictionary<string, char> _tokenAssignments = new Dictionary<string, char>();
  
  char GetTokenFor(string player)
  {
      <span class="highlight">var nextToken = (_tokenAssignments.Count == 0) ? 'X' : 'O';</span>
 
      <span class="highlight">if (_tokenAssignments.ContainsKey(player))</span>
          <span class="highlight">return _tokenAssignments[player];</span>

      <span class="highlight">return _tokenAssignments[player] = nextToken;</span>
  }
}
</pre>

<p></p>
        
<div style="background:#3C0">
&nbsp;
</div>
        
Next, let's change the ChoosePosition() method to use our new method instead of the hard-coded assignments:
        
<pre class="code">
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
  
      _layout[position - 1] = <span class="highlight">GetTokenFor("player");</span>
      SelectAPositionFor(<span class="highlight">GetTokenFor("game")</span>);
  
      if (WinningPlayerIs('X'))
          return "Player wins!";
  
      if (WinningPlayerIs('O'))
          return "Game wins.";
  
      return string.Empty;
  }
</pre>

<p></p>        
        
<div style="background:#3C0">
&nbsp;
</div>
        
<p>
These changes have introduced some duplication in the form of magic strings, so let's get rid of that. We can define an Enum to identify our players rather than using strings:
</p>
          
<pre class="code">
  public enum Player
   {
       Human,
       Game
   }
</pre>
          
<p>
Now we can change our dictionary, the GetTokenFor() method parameter type and the calls to GetTokenFor() from the ChoosePosition() and GoFirst() methods to use the new Enum:
</p>
         
<pre class="code">
  readonly Dictionary<<span class="highlight">Player</span>, char> _tokenAssignments =
      new Dictionary<<span class="highlight">Player</span>, char>();
  
  
  char GetTokenFor(<span class="highlight">Player</span> player)
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

      _layout[position - 1] = GetTokenFor(<span class="highlight">Player.Human</span>);
      SelectAPositionFor(GetTokenFor(<span class="highlight">Player.Game</span>));

      if (WinningPlayerIs('X'))
          return "Player wins!";

      if (WinningPlayerIs('O'))
          return "Game wins.";

      return string.Empty;
  }


  public void GoFirst()
  {
      char token = GetTokenFor(<span class="highlight">Player.Game</span>);
      SelectAPositionFor(token);
  }
</pre>
          
<p></p>
          
<div style="background:#3C0">
&nbsp;
</div>

Now that we know this works, let's refactor the rest of the methods that are still relying upon character values to identify the player along with their associated calls:

<pre class="code">
  bool WinningPlayerIs(<span class="highlight">Player</span> player)
  {
    return _winningPatterns
      .Any(pattern => Regex.IsMatch(GetLayoutFor(player), pattern));
  }


  string GetLayoutFor(Player player)
  {
    return new string(_layout.ToList()
        .Select(c => (c.Equals(<span class="highlight">GetTokenFor(player)</span>)) ? <span class="highlight">GetTokenFor(player)</span>
          : '\0')
        .ToArray());
  }


  void SelectAPositionFor(<span class="highlight">Player</span> player)
  {
    int firstUnoccupied = Enumerable.Range(0, _layout.Length)
      .First(p => _layout[p].Equals('\0'));
    _layout[firstUnoccupied] = <span class="highlight">GetTokenFor(player)</span>;
  }


  public void GoFirst()
  {
    <span class="highlight">SelectAPositionFor(Player.Game);</span>
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
    SelectAPositionFor(<span class="highlight">Player.Game</span>);

    if (WinningPlayerIs(<span class="highlight">Player.Human</span>))
      return "Player wins!";

    if (WinningPlayerIs(<span class="highlight">Player.Game</span>))
      return "Game wins.";

    return string.Empty;
  }
</pre>

<p></p>          
<div style="background:#3C0">
&nbsp;
</div>

Here's what we have so far:

<pre class="code">
  public class Game
  {
    readonly char[] _layout = new char[9];
    readonly Dictionary<Player, char> _tokenAssignments =
      new Dictionary<Player, char>();

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
      return position < 1 || position > _layout.Count();
    }

    bool WinningPlayerIs(Player player)
    {
      return _winningPatterns
        .Any(pattern => Regex.IsMatch(GetLayoutFor(player), pattern));
    }

    string GetLayoutFor(Player player)
    {
      return new string(_layout.ToList()
          .Select(c => (c.Equals(GetTokenFor(player)))
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
        .First(p => _layout[p].Equals('\0'));
      _layout[firstUnoccupied] = GetTokenFor(player);
    }
  }
</pre>

We've only got two more requirements to go, but we'll leave things here for now. Next time, we'll complete our requirements by tackling what looks to be the most interesting portion of our game and perhaps we'll discover a solution to our coupling woes in the process.
