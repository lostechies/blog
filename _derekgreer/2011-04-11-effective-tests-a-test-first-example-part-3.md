---
wordpress_id: 233
title: 'Effective Tests: A Test-First Example &#8211; Part 3'
date: 2011-04-11T11:41:34+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=233
dsq_thread_id:
- "276663420"
categories:
- Uncategorized
tags:
- TDD
- Testing
---

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


## Posts In This Series

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
      <a href="/derekgreer/2011/04/04/effective-tests-a-test-first-example-part-2/">Effective Tests: A Test-First Example – Part 2</a>
    </li>
    <li>
      Effective Tests: A Test-First Example – Part 3
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

In [part 2](/derekgreer/2011/04/04/effective-tests-a-test-first-example-part-2/) of our Test-First example, we continued the implementation of our Tic-tac-toe game using a Test-First approach. This time, we’ll finish out our requirements.

Here’s where we left things:

<pre class="story" style="border-bottom: black 1px solid; text-align: left; border-left: black 1px solid; padding-bottom: 5px; background-color: #ffffe0; padding-left: 5px; padding-right: 5px; border-collapse: collapse; font: 12px/20px consolas, 'Bitstream Vera Sans Mono', 'Courier New', courier, monospace; float: none; color: black; vertical-align: baseline; border-top: black 1px solid; border-right: black 1px solid; padding-top: 5px">
  <strike>When the player goes first</strike>
  <strike>it should put their mark in the selected position</strike>
  <strike>it should make the next move</strike>

  <strike>When the player gets three in a row</strike>
  <strike>it should announce the player as the winner</strike>

  <strike>When the game gets three in a row</strike>
  <strike>it should announce the game as the winner</strike>

  <strike>When the player attempts to select an occupied position</strike>
  <strike>it should tell the player the position is occupied</strike>

  <strike>When the player attempts to select an invalid position</strike>
  <strike>it should tell the player the position is invalid</strike>

  <strike>When the game goes first</strike>
  <strike>it should put an X in one of the available positions</strike>

  When the player can not win on the next turn
  it should try to get three in a row

  When the player can win on the next turn
  it should block the player
</pre>

Our last two requirements pertain to making the game try to win. The first requirement concerns the game trying to get three in a row while the second pertains to the game trying to keep the opponent from getting three in a row. Let’s get started on the first test:

<pre class="code">
[TestClass]
public class When_the_player_can_not_win_on_the_next_turn
{
  [TestMethod]
  public void it_should_try_to_get_three_in_a_row()
  {

  }
}
</pre>

Let’s assume we’ll be validating that the game gets three in a row by completing a sequence ending with the bottom right position being selected:

<pre class="code">
[TestMethod]
public void it_should_try_to_get_three_in_a_row()
{
  <span class="highlight">Assert.AreEqual(9, selection);</span>
}
</pre>

Next, let's establish a scenario were the bottom right corner should always be the position we would expect the game to choose (as opposed to a scenario where the game might have multiple intelligent moves). The following illustrates a layout where the game has gone first and has already achieved two in a row:

&nbsp;

[<img style="border-right-width: 0px; padding-left: 0px; padding-right: 0px; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" border="0" alt="tic-tac-toe-game-win" src="https://lostechies.com/content/derekgreer/uploads/2011/04/tic-tac-toe-game-win_thumb.png" width="221" height="183" />](https://lostechies.com/content/derekgreer/uploads/2011/04/tic-tac-toe-game-win.png)

&nbsp;

Next, we need to determine how we can force the game into the desired state so we can validate the next position selected. We won’t be able to use the same technique as before, so we’ll need to find a new way of manipulating the state. One way would be to just make the Game’s \_layout field public and manipulate it directly, but that would break encapsulation. Another way would be to set the \_layout field through reflection, but this would result in our test being more tightly coupled to the implementation details of our Game. To make our Game testable, we need to adapt its interface. If our game relied upon a separate class for choosing the positions, we would then have a seam we could use to influence the layout. Hey … once this is in place we’ll have a way to fix our test coupling problem!

For now, let’s comment out the test we’ve been working on and start on a new test describing how the Game class will interact with this new dependency. Let’s think of the dependency as an “advisor” and describe the interaction as receiving a recommendation by the advisor:

<pre class="code">
[TestClass]
public class When_the_game_selects_a_position
{
  [TestMethod]
    public void it_should_select_the_position_recommended_by_the_advisor()
    {

    }
}
</pre>

Next, let’s establish an assertion that validates the selection made by the game. We’ll stick with the same scenario we established earlier, expecting the game to choose the bottom right position:

<pre class="code">
[TestClass]
public class When_the_game_selects_a_position
{
  [TestMethod]
    public void it_should_select_the_position_recommended_by_the_advisor()
    {
      <span class="highlight">Assert.AreEqual(9, selection);</span>
    }
}
</pre>

Next, we need a way of determining the last position chosen by the game. As we’ve done in our previous tests, we’ll use the single GetPosition() method and a little bit of LINQ goodness to help us out. To figure out what the last move was, we can get a list of all the game positions before and after its next turn. We can then use the two lists to determine which new position was selected:

<pre class="code">
[TestClass]
public class When_the_game_selects_a_position
{
  [TestMethod]
  public void it_should_select_the_position_recommended_by_the_advisor()
  {
    <span class="highlight">IEnumerable&lt;int> beforeLayout = (Enumerable.Range(1, 9)</span>
        <span class="highlight">.Where(position => game.GetPosition(position).Equals('X'))</span>
        <span class="highlight">.Select(position => position)).ToList();</span>

    <span class="highlight">// make move here</span>

    <span class="highlight">IEnumerable&lt;int> afterLayout = (Enumerable.Range(1, 9)</span>
        <span class="highlight">.Where(position => game.GetPosition(position).Equals('X'))</span>
        <span class="highlight">.Select(position => position)).ToList();</span>

    <span class="highlight">int selection = afterLayout.Except(beforeLayout).Single();</span>

    Assert.AreEqual(9, selection);
  }
}
</pre>

Next, let’s establish the Game context along with the call we’re interested in:

<pre class="code">
[TestClass]
public class When_the_game_selects_a_position
{
  [TestMethod]
  public void it_should_select_the_position_recommended_by_the_advisor()
  {
    var game = new Game(advisor);
    game.GoFirst();
    game.ChoosePosition(1);

    IEnumerable&lt;int> beforeLayout = (Enumerable.Range(1, 9)
        .Where(position => game.GetPosition(position).Equals('X'))
        .Select(position => position)).ToList();

    <span class="highlight">game.ChoosePosition(8);</span>

      IEnumerable&lt;int> afterLayout = (Enumerable.Range(1, 9)
          .Where(position => game.GetPosition(position).Equals('X'))
          .Select(position => position)).ToList();

    int selection = afterLayout.Except(beforeLayout).Single();

    Assert.AreEqual(9, selection);
  }
}
</pre>

Next, let’s establish our GameAdvisor stub. To get our GameAdvisorStub to recommend the positions we’d like, we’ll pass an array of integers to denote the progression we want the game to use:

<pre class="code">
[TestMethod]
public void it_should_select_the_position_recommended_by_the_advisor()
{
  <span class="highlight">IGameAdvisor advisor = new GameAdvisorStub(new[] { 3, 6, 9 });</span>
  var game = new Game(<span class="highlight">advisor</span>);
  game.GoFirst();
  game.ChoosePosition(1);

  IEnumerable&lt;int> beforeLayout = (Enumerable.Range(1, 9)
      .Where(position => game.GetPosition(position).Equals('X'))
      .Select(position => position)).ToList();

  game.ChoosePosition(8);

  IEnumerable&lt;int> afterLayout = (Enumerable.Range(1, 9)
      .Where(position => game.GetPosition(position).Equals('X'))
      .Select(position => position)).ToList();

  int selection = afterLayout.Except(beforeLayout).Single();

  Assert.AreEqual(9, selection);
}
</pre>

To get our test to compile, we’ll need to create our new IGameAdvisor interface, GameAdvisorStub class and add a constructor to our existing Game class. Let’s start with the advisor types:

<pre class="code">
public interface IGameAdvisor
{
}

public class GameAdvisorStub : IGameAdvisor
{
  readonly int[] _positions;

  public GameAdvisorStub(int[] positions)
  {
    _positions = positions;
  }
}
</pre>

Next, let’s create the new constructor for our Game class which takes an IGameAdvisor. We’ll also supply a default no argument constructor to keep our existing tests compiling:

<pre class="code">
public class Game
{
  <span class="highlight">public Game()</span>
    <span class="highlight">{</span>
      <span class="highlight">}</span>

      <span class="highlight">public Game(IGameAdvisor advisor)</span>
      <span class="highlight">{</span>
      <span class="highlight">}</span>

        ...
}
</pre>

Everything should now compile. Let’s run our tests:

<div style="background: red">
  &nbsp;
</div>
<div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_game_selects_a_position
  Failed	it_should_select_the_position_recommended_by_the_advisor
  Assert.AreEqual failed. 
  Expected:<9>. Actual:<2>. 	...	
</div>

<p>
Before we move on, our test could stand a little cleaning up. The verbosity of the LINQ extension method calls we’re using are obscuring the intent of our test a bit. Let’s write a test helper in the form of an extension method to help clarify the intentions of our test:
</p>

<pre class="code">
public static class GameExtensions
{
  public static int GetSelectionAfter(this Game game, Action action)
  {
    IEnumerable&lt;int> beforeLayout = (Enumerable.Range(1, 9)
        .Where(position => game.GetPosition(position).Equals('X'))
        .Select(position => position)).ToList();

    action();

    IEnumerable&lt;int> afterLayout = (Enumerable.Range(1, 9)
        .Where(position => game.GetPosition(position).Equals('X'))
        .Select(position => position)).ToList();

    return afterLayout.Except(beforeLayout).Single();
  }
}
</pre>

<p>
Now we can change our test to the following:
</p>

<pre class="code">
[TestClass]
public class When_the_game_selects_a_position
{
  [TestMethod]
  public void it_should_select_the_position_recommended_by_the_advisor()
  {
    IGameAdvisor advisor = new GameAdvisorStub(new[] {3, 6, 9});
    var game = new Game(advisor);
    game.GoFirst();
    game.ChoosePosition(1);

    <span class="highlight">int selection = game.GetSelectionAfter(() => game.ChoosePosition(8));</span>

      Assert.AreEqual(9, selection);
  }
}
</pre>

<p>
Let’s run the test again to make sure it still validates correctly:
</p>

<div style="background: red">
  &nbsp;
</div>
<div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_game_selects_a_position
  Failed	it_should_select_the_position_recommended_by_the_advisor
  Assert.AreEqual failed. 
  Expected:<9>. Actual:<2>. 	...	

</div>

Good, now let’s work on making the test pass. Something simple we can do to force our test to pass is to play off of a bit of new information we have at our disposal. Since our new test is the only one using the overloaded constructor, we can use the advisor field as a sort of flag to perform some behavior specific to this test. First, let’s assign the parameter to a field:

<pre class="code">
<span class="highlight">readonly IGameAdvisor _advisor;</span>

public Game(IGameAdvisor advisor)
{
  <span class="highlight">_advisor = advisor;</span>
}
</pre>

Next, let’s modify the ChoosePosition() method to set the ninth position to an ‘X’ if the _advisor field is set and the player chooses position 8:

<pre class="code">
public string ChoosePosition(int position)
{
  <span class="highlight">if( _advisor != null && position == 8 )
  {
    _layout[8] = 'X';
    return string.Empty;
  }</span>

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
</pre>

<p>
Now, let’s run our tests:
</p>

<div style="background: #3c0">
  &nbsp;
</div>

<p>
&nbsp;
</p>

<p>
Now, let’s refactor. To eliminate our fake implementation, let’s start by modifying the Game’s SelectAPositionFor() method to call our new IGameAdvisor field. Well assume the IGameAdvisor supports a SelectAPositionFor() method which allows us to pass in the token and the current layout as a string:
</p>

<pre class="code">
void SelectAPositionFor(Player player)
{
  <span class="highlight">int recommendedPosition = 
    _advisor.SelectAPositionFor(GetTokenFor(player),
        new string(_layout));
  _layout[recommendedPosition] = GetTokenFor(player);</span>
}
</pre>

Next, let’s define the new method on our interface:

<pre class="code">
public interface IGameAdvisor
{
  <span class="highlight">int SelectAPositionFor(char player, string layout);</span>
}
</pre>

Next, we need to implement the new method on our stub. To have our stub return the expected positions, we’ll keep track of how many times the method has been called and use that as the offset into the array setup in our test:

<pre class="code">
public class GameAdvisorStub : IGameAdvisor
{
  readonly int[] _positions;
  int _count;

  public GameAdvisorStub(int[] positions)
  {
    _positions = positions;
  }

  public int SelectAPositionFor(char player, string layout)
  {
    return _positions[_count++];
  }
}
</pre>

Lastly, we can delete our fake implementation and run the tests:

<div style="background: red">
  &nbsp;
</div>
<div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_player_goes_first
  Failed	it_should_put_their_choice_in_the_selected_position
  TestFirstExample.When_the_player_goes_first.establish_context threw exception.
  System.NullReferenceException: System.NullReferenceException:
  Object reference not set to an instance of an object..	
  Failed	it_should_make_the_next_move
  TestFirstExample.When_the_player_goes_first.establish_context threw exception.
  System.NullReferenceException: System.NullReferenceException:
  Object reference not set to an instance of an object..	
  ...	
</div>

Oh no, we broke a bunch of tests! They all seem to be failing due to a NullReferenceException. Looking further, this is being caused by the IGameAdvisor field not being assigned when using the default constructor. Let’s fix that by changing our default constructor to call the overloaded constructor with a default implementation of the IGameAdvisor interface:

<pre class="code">
public Game() : <span class="highlight">this(new GameAdvisor())</span>
{
}
</pre>

Next, we’ll create the GameAdvisor class and provide an implementation that mirrors the former behavior:

<pre class="code">
class GameAdvisor : IGameAdvisor
{
  public int SelectAPositionFor(char player, string layout)
  {
    return Enumerable.Range(1, layout.Length)
      .First(p => layout[p - 1].Equals('\0'));
  }
}
</pre>

<p></p>

<div style="background: #3c0">
  &nbsp;
</div>

Our Game class works the same way as before, but we now have a new seam we can influence the layout selection with.

We can now turn our attention back to the requirements. Let’s go back and un-comment the test we started with, but this time we’ll use it to drive the behavior of our GameAdvisor:

<pre class="code">
[TestClass]
public class When_the_player_can_not_win_on_the_next_turn
{
  [TestMethod]
  public void it_should_try_to_get_three_in_a_row()
  {
    Assert.AreEqual(9, selection);
  }
}
</pre>

Next, let’s declare an instance of our GameAdvisor class and ask it to select a position for player ‘X’:

<pre class="code">
[TestClass]
public class When_the_player_can_not_win_on_the_next_turn
{
  [TestMethod]
  public void it_should_try_to_get_three_in_a_row()
  {
    <span class="highlight">IGameAdvisor advisor = new GameAdvisor();</span>
      <span class="highlight">var selection = advisor.SelectAPositionFor('X', "O\0X\0\0X\0O\0");</span>
      Assert.AreEqual(9, selection);
  }
}
</pre>

Before moving on, let’s consider our initial API. Given any approach, is this really the API we want to work with? While the SelectAPositionFor() method seems like a good start, the parameters feel more like an afterthought than a part of the request. It reads more like a “Do something, and oh by the way, here’s some data”. I didn’t notice when we called it from the Game class, but looking back, that call was aided by the context of its usage. We don’t have any variables telling us what ‘X’ and “O\0A&#8230;” mean.

One of the advantages of Test-Driven Development is that it forces us to look at our API from a consumer’s perspective. When we build things from the inside out, we often don’t consider how intuitive the components will be to work with by our consumers. Once we’ve started implementation, our perspective can be prejudiced by our understanding of how the system works. TDD helps to address this issue by forcing us to consider how the components will be used. This in turn guides us to adapt the design to how the system is being used rather than the other way around. Let’s see if we can improve upon this a bit:

<pre class="code">
[TestClass]
public class When_the_player_can_not_win_on_the_next_turn
{
  [TestMethod]
  public void it_should_try_to_get_three_in_a_row()
  {
    IGameAdvisor advisor = new GameAdvisor();
    var selection = advisor.WithLayout("O\0X\0\0X\0O\0").SelectBestMoveForPlayer('X');</b>
      Assert.AreEqual(9, selection);
  }
}
</pre>

That seems to express how I’d like to interact with our advisor more clearly. This breaks our code though, so we’ll need to make some adjustments to our IGameAdvisor interface and GameAdvisor class:

<pre class="code">
public interface IGameAdvisor
{
  <span class="highlight">int SelectBestMoveForPlayer(char player);
  IGameAdvisor WithLayout(string layout);</span>
}

class GameAdvisor : IGameAdvisor
{
  <span class="highlight">string _layout;

  public int SelectBestMoveForPlayer(char player)
  {
    return Enumerable.Range(1, _layout.Length)
      .First(p => _layout[p - 1].Equals('\0'));
  }

  public IGameAdvisor WithLayout(string layout)
  {
    _layout = layout;
    return this;
  }</span>
}
</pre>

That would work, but this implementation would allow us to call the advisor without specifying the layout. Let’s take just a little more time to clear that up by moving the SelectBestMoveForPlayer() method to an inner class to prevent it from being called directly:

<pre class="code">
public interface IGameAdvisor
{
  <span class="highlight">IPositionSelector</span> WithLayout(string layout);
}

<span class="highlight">public interface IPositionSelector
{
  int SelectBestMoveForPlayer(char player);
}</span>

class GameAdvisor : IGameAdvisor
{
  public <span class="highlight">IPositionSelector</span> WithLayout(string layout)
  {
    <span class="highlight">return new PositionSelector(layout);</span>
  }

  <span class="highlight">class PositionSelector : IPositionSelector
  {
    readonly string _layout;

    public PositionSelector(string layout)
    {
      _layout = layout;
    }

    public int SelectBestMoveForPlayer(char player)
    {
      return Enumerable.Range(1, _layout.Length)
        .First(p => _layout[p - 1].Equals('\0'));
    }
  }</span>
}
</pre>

Next, let’s fix up our GameAdvisorStub:

<pre class="code">
public class GameAdvisorStub : IGameAdvisor
{
  readonly int[] _positions;
  int _count;

  public GameAdvisorStub(int[] positions)
  {
    _positions = positions;
  }

  <span class="highlight">public IPositionSelector WithLayout(string layout)
  {
    return new PositionSelector(layout, _positions, _count++);
  }

  class PositionSelector : IPositionSelector
  {
    readonly int[] _positions;
    readonly int _count;

    public PositionSelector(string layout, int[] positions, int count)
    {
      _positions = positions;
      _count = count;
    }

    public int SelectBestMoveForPlayer(char player)
    {
      return _positions[_count];
    }
  }</span>
}
</pre>

<p>
We also need to fix the SelectAPositionFor() method in our Game class:
</p>

<pre class="code">
void SelectAPositionFor(Player player)
{
  int recommendedPosition = 
    _advisor.<span class="highlight">WithLayout(new string(_layout))
    .SelectBestMoveForPlayer(GetTokenFor(player));</span>
    _layout[recommendedPosition - 1] = GetTokenFor(player);
}
</pre>

Now, let’s run our tests and make sure our new test fails for the right reason and that we haven’t broken any of the other behavior:

<div style="background: red">
  &nbsp;
</div>
<div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_player_can_not_win_on_the_next_turn
  Failed	it_should_try_to_get_three_in_a_row
  Assert.AreEqual failed. Expected:<9>. Actual:<2>. 	
</div>

Only our new test fails, which is what we were hoping for. Now, let’s use the Fake It approach to get our test to pass quickly. Since only one of our tests ever call this method with the token ‘X’ and it doesn’t care about which actual position it is, we can change the GameAdvisor’s PositionAdvisor.SelectBestMoveForPlayer() method to always return 9 for player ‘X’:

<pre class="code">
public int SelectBestMoveForPlayer(char player)
{
  if (player == 'X') return 9;

  return Enumerable.Range(0, _layout.Length)
    .First(p => _layout[p].Equals('\0')) + 1;
}
</pre>

Now, let’s refactor to eliminate our duplication. In order to calculate which position should be selected, we’ll need to know what the winning patterns are and which paths in the layout are closest to the winning patterns. My first thought was that we might be able to reuse the winning pattern regular expressions we defined over in our Game class. Let’s go back and look at that again:

<pre class="code">
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
</pre>

While these patterns define what the winning paths are, I don’t think this will work for our needs because this only matches winning patterns. What we need is a way of examining each of the eight winning paths within the layout to see which is the closest to winning. Let’s start by define a new regular expression that we can use to filter out the paths that can’t win:

<pre class="code">
class PositionSelector : IPositionSelector
{
  <span class="highlight">readonly Regex _availablePathPattern = new Regex(@"[X\0]{3}");</span>
    readonly string _layout;

  public PositionSelector(string layout)
  {
    _layout = layout;
  }

  public int SelectBestMoveForPlayer(char player)
  {
    if (player == 'X')
      return 9;

    return Enumerable.Range(0, _layout.Length)
      .First(p => _layout[p].Equals('\0')) + 1;
  }
}
</pre>

This regular expression will match any three characters where each of the characters can be either an ‘X’ or a null. If you’re unfamiliar with regular expressions, the brackets are referred to as <i>Character Classes</i> or <i>Character Sets</i> and allow us to define a group of characters we’re interested in. The curly braces with the number is how we define how many times the pattern should repeat to be a match.

Now, we need to apply this to each of the eight possible paths within our layout. To do so, we’ll need to slice up our layout into the eight possible winning paths. Let’s define an array similar to the one in our Game class, but using the winning positions instead of winning patterns:

<pre class="code">
class PositionSelector : IPositionSelector
{
  readonly Regex _availablePathPattern = new Regex(@"[X\0]{3}");
  readonly string _layout;

  <span class="highlight">static readonly int[][] _winningPositions = new[]
  {
    new[] {1, 2, 3},
    new[] {4, 5, 6},
    new[] {7, 8, 9},
    new[] {1, 4, 7},
    new[] {2, 5, 8},
    new[] {3, 6, 9},
    new[] {1, 5, 9},
    new[] {3, 5, 7},
  };</span>

  public PositionSelector(string layout)
  {
    _layout = layout;
  }

  public int SelectBestMoveForPlayer(char player)
  {
    if (player == 'X')
      return 9;

    return Enumerable.Range(0, _layout.Length)
      .First(p => _layout[p].Equals('\0')) + 1;
  }
}
</pre>

Next, we can loop over each of the _winningPositions, retrieve the slice, compare it to the _availablePathPattern and add the matches to a list of availablePaths:

<pre class="code">
public int SelectBestMoveForPlayer(char player)
{
  <span class="highlight">var availablePaths = new List&lt;int[]>();

  foreach (var winningSlice in _winningPositions)
  {
    var slice = new string(winningSlice.ToList()
        .Select(p => _layout.ElementAt(p - 1)).ToArray());

    if (_availablePathPattern.IsMatch(slice))
      availablePaths.Add(winningSlice);
  }</span>

  if (player == 'X')
    return 9;

  return Enumerable.Range(0, _layout.Length)
    .First(p => _layout[p].Equals('\0')) + 1;
}
</pre>

Now that we have the available paths, we can sort them in descending order based on how many ‘O’s they already have, find the first available slot in the slice and return that as the position:

<pre class="code">
public int SelectBestMoveForPlayer(char player)
{
  var availablePaths = new List&lt;int[]>();

  foreach (var winningSlice in _winningPositions)
  {
    var slice = new string(winningSlice.ToList()
        .Select(p => _layout.ElementAt(p - 1)).ToArray());

    if (_availablePathPattern.IsMatch(slice))
      availablePaths.Add(winningSlice);
  }

  <span class="highlight">var bestSlice = availablePaths
    .OrderByDescending(path => path
        .Count(p => _layout[p - 1] == 'X')).First();
  return bestSlice.First(p => _layout[p - 1] == '\0');</span>
}
</pre>

I think we’re almost done refactoring, but we still have some duplication to eliminate. Both our test and our implementation are using the value of ‘X’ as a constant to represent the player. Let’s fix this by replacing the player’s token to a more neutral value and change our regular expression and sorting call to use the neutral value instead:

<pre class="code">
readonly Regex _availablePathPattern = new <span class="highlight">Regex(@"[T\0]{3}");</span>

public int SelectBestMoveForPlayer(char player)
{
  <span class="highlight">string layout = _layout.Replace(player, 'T');</span>
    var availablePaths = new List&lt;int[]>();

  foreach (var winningSlice in _winningPositions)
  {
    var slice = new string(winningSlice.ToList()
        .Select(p => <span class="highlight">layout</span>.ElementAt(p - 1)).ToArray());

    if (_availablePathPattern.IsMatch(slice))
      availablePaths.Add(winningSlice);
  }

  int[] bestSlice = availablePaths
    .OrderByDescending(path => path
        .Count(p => <span class="highlight">layout</span>[p - 1] == 'T')).First();
  return bestSlice.First(p => _layout[p - 1] == '\0');
}
</pre>

Everything should be good to go. Let’s run our tests and see how we did:

<div style="background: red">
  &nbsp;
</div>
<div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_player_attempts_to_select_an_occupied_positionFailed
  it_should_tell_the_player_the_position_is_occupied
  Assert.AreEqual failed. Expected:<That spot is taken!>. Actual:<>. 	
</div>

Our target test passed, but we broke the test for how the game responds when the player chooses a position that is already occupied. Let’s review the test again:

<pre class="code">
[TestClass]
public class When_the_player_attempts_to_select_an_occupied_position
{
  [TestMethod]
    public void it_should_tell_the_player_the_position_is_occupied()
    {
      var game = new Game();
      game.ChoosePosition(2);
      string message = game.ChoosePosition(1);
      Assert.AreEqual("That spot is taken!", message);
    }
}
</pre>

<p>
Because we are choosing the second position in this test, the GameAdvisor avoids recommending positions within the first winning pattern. We could fix this test pretty easily by avoiding positions two or three, but now that we now have a seam to control exactly what positions are selected, let’s use our new GameAdvisorStub to correct this test in a more explicit way:
</p>

<pre class="code">
[TestClass]
public class When_the_player_attempts_to_select_an_occupied_position
{
  [TestMethod]
    public void it_should_tell_the_player_the_position_is_occupied()
    {
      var game = new Game(<span class="highlight">new GameAdvisorStub(new [] {1, 4, 7})</span>);
      game.ChoosePosition(2);
      string message = game.ChoosePosition(1);
      Assert.AreEqual("That spot is taken!", message);
    }
}
</pre>

<p></p>

<div style="background: #3c0">
  &nbsp;
</div>

The last requirement concerns how the game reacts when the player is about to win. Here’s our skeleton:

<pre class="code">
[TestClass]
public class When_the_player_can_win_on_the_next_turn
{
  [TestMethod]
  public void it_should_block_the_player()
  {

  }
}
</pre>

As always, we’ll start by deciding what observable outcome we want to depend upon to know the behavior is working correctly. Since we’re expecting the game to block the player, let’s come up with a scenario we know wouldn’t result from the existing behavior of trying to get three in a row. Let’s say the player goes first and has one position left in the center vertical row to win:

<a href="https://lostechies.com/content/derekgreer/uploads/2011/04/tic-tac-toe-game-block.png"><img style="border-right-width: 0px; padding-left: 0px; padding-right: 0px; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px" border="0" alt="tic-tac-toe-game-block" src="https://lostechies.com/content/derekgreer/uploads/2011/04/tic-tac-toe-game-block_thumb.png" width="222" height="184" /></a>

To validate this scenario, we’ll check that the GameAdvisor chooses the eighth position:

<pre class="code">
[TestClass]
public class When_the_player_can_win_on_the_next_turn
{
  [TestMethod]
  public void it_should_block_the_player()
  {
    <span class="highlight">Assert.AreEqual(8, selection);</span>
  }
}
</pre>

Next, let’s setup the rest of the context to declare the instance of our SUT and establish the layout:

<pre class="code">
[TestClass]
public class When_the_player_can_win_on_the_next_turn
{
  [TestMethod]
  public void it_should_block_the_player()
  {
    <span class="highlight">IGameAdvisor advisor = new GameAdvisor();
    int selection = advisor.WithLayout("\0X\0OX\0\0\0\0").SelectBestMoveForPlayer('O');</span>
      Assert.AreEqual(8, selection);
  }
}
</pre>

Now, let’s run our test:

<div style="background: red">
  &nbsp;
</div>
<div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_player_can_win_on_the_next_turn
  Failed	it_should_block_the_player
  Assert.AreEqual failed. Expected:<8>. Actual:<1>. 	
</div>

Now, let’s make the test pass. This time, I’ll pass the test by testing specifically for the layout we’re after:

<pre class="code">
public int SelectBestMoveForPlayer(char player)
{
  string layout = _layout.Replace(player, 'T');
  var availablePaths = new List&lt;int[]>();

  foreach (var winningSlice in _winningPositions)
  {
    var slice = new string(winningSlice.ToList()
        .Select(p => layout.ElementAt(p - 1)).ToArray());

    if (_availablePathPattern.IsMatch(slice))
      availablePaths.Add(winningSlice);
  }

  <span class="highlight">if (layout == "\0X\0TX\0\0\0\0")
  {
    return 8;
  }</span>

  int[] bestSlice = availablePaths
    .OrderByDescending(path => path
        .Count(p => layout[p - 1] == 'T')).First();
  return bestSlice.First(p => _layout[p - 1] == '\0');
}
</pre>

<p></p>
<div style="background: #3c0">
  &nbsp;
</div>

Now, let’s refactor. To get the GameAdvisor to choose the eighth position because it recognizes it’s vulnerable to losing, we’ll need to check how close the player is. To do this, we can find all of the available paths for the player and check if any of them already have two positions occupied. First, we’ll need to know which token the player is using:

<pre class="code">

public int SelectBestMoveForPlayer(char player)
{
  string layout = _layout.Replace(player, 'T');
  var availablePaths = new List&lt;int[]>();

  foreach (var winningSlice in _winningPositions)
  {
    var slice = new string(winningSlice.ToList()
        .Select(p => layout.ElementAt(p - 1)).ToArray());

    if (_availablePathPattern.IsMatch(slice))
      availablePaths.Add(winningSlice);
  }

  <span class="highlight">char opponentValue = (player == 'X') ? 'O' : 'X';</span>

    if (layout == "\0X\0TX\0\0\0\0")
    {
      return 8;
    }

  int[] bestSlice = availablePaths
    .OrderByDescending(path => path
        .Count(p => layout[p - 1] == 'T')).First();
  return bestSlice.First(p => _layout[p - 1] == '\0');
}
</pre>

Next, let’s create a new local layout based on the player’s positions:

<pre class="code">
public int SelectBestMoveForPlayer(char player)
{
  string layout = _layout.Replace(player, 'T');
  var availablePaths = new List&lt;int[]>();

  foreach (var winningSlice in _winningPositions)
  {
    var slice = new string(winningSlice.ToList()
        .Select(p => layout.ElementAt(p - 1)).ToArray());

    if (_availablePathPattern.IsMatch(slice))
      availablePaths.Add(winningSlice);
  }

  char opponentValue = (player == 'X') ? 'O' : 'X';
  <span class="highlight">string playerLayout = _layout.Replace(opponentValue, 'T');</span>

    if (layout == "\0X\0TX\0\0\0\0")
    {
      return 8;
    }

  int[] bestSlice = availablePaths
    .OrderByDescending(path => path
        .Count(p => layout[p - 1] == 'T')).First();
  return bestSlice.First(p => _layout[p - 1] == '\0');
}
</pre>

Now, let’s copy the logic we created before and use it to find the available paths for the opponent:

<pre class="code">
public int SelectBestMoveForPlayer(char player)
{
  string layout = _layout.Replace(player, 'T');
  var availablePaths = new List&lt;int[]>();

  foreach (var winningSlice in _winningPositions)
  {
    var slice = new string(winningSlice.ToList()
        .Select(p => layout.ElementAt(p - 1)).ToArray());

    if (_availablePathPattern.IsMatch(slice))
      availablePaths.Add(winningSlice);
  }

  char opponentValue = (player == 'X') ? 'O' : 'X';
  string opponentLayout = _layout.Replace(opponentValue, 'T');
  <span class="highlight">List&lt;int[]> availableOpponentPaths = new List&lt;int[]>();

  foreach (var winningSlice in _winningPositions)
  {
    var slice = new string(winningSlice.ToList()
        .Select(p => opponentLayout.ElementAt(p - 1)).ToArray());

    if (_availablePathPattern.IsMatch(slice))
      availableOpponentPaths.Add(winningSlice);
  }</span>

  if (layout == "\0X\0TX\0\0\0\0")
  {
    return 8;
  }

  int[] bestSlice = availablePaths
    .OrderByDescending(path => path
        .Count(p => layout[p - 1] == 'T')).First();
  return bestSlice.First(p => _layout[p - 1] == '\0');
}
</pre>

Lastly, let’s find all the available paths for which the opponent already has two positions filled and remove our fake implementation:

<pre class="code">
public int SelectBestMoveForPlayer(char player)
{
  string layout = _layout.Replace(player, 'T');
  var availablePaths = new List&lt;int[]>();

  foreach (var winningSlice in _winningPositions)
  {
    var slice = new string(winningSlice.ToList()
        .Select(p => layout.ElementAt(p - 1)).ToArray());

    if (_availablePathPattern.IsMatch(slice))
      availablePaths.Add(winningSlice);
  }

  char opponentValue = (player == 'X') ? 'O' : 'X';
  string opponentLayout = _layout.Replace(opponentValue, 'T');
  List&lt;int[]> availableOpponentPaths = new List&lt;int[]>();

  foreach (var winningSlice in _winningPositions)
  {
    var slice = new string(winningSlice.ToList()
        .Select(p => opponentLayout.ElementAt(p - 1)).ToArray());

    if (_availablePathPattern.IsMatch(slice))
      availableOpponentPaths.Add(winningSlice);
  }

  <span class="highlight">int[] threatingPath = availableOpponentPaths
    .Where(path => new string(
          path.Select(p => opponentLayout[p - 1]).ToArray())
        .Count(c => c == 'T') == 2).FirstOrDefault();

  if (threatingPath != null)
  {
    return threatingPath
      .First(position => opponentLayout[position - 1] == '\0');
  }</span>

  int[] bestSlice = availablePaths.OrderByDescending(
      path => path.Count(p => layout[p - 1] == 'T')).First();
  return bestSlice.First(p => _layout[p - 1] == '\0');
}
</pre>

Let’s run our test and see what happens:

<div style="background: red">
  &nbsp;
</div>
<div style="background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_player_gets_three_in_a_row
  Failed	it_should_announce_the_player_as_the_winner
  Assert.AreEqual failed. Expected:<Player wins!>. Actual:<That spot is taken!>. 	
</div>

Our test still passes, but for some reason we broke the test for testing that the player wins when getting three in a row. Let’s have a look:

<pre class="code">
[TestClass]
public class When_the_player_gets_three_in_a_row
{
  [TestMethod]
  public void it_should_announce_the_player_as_the_winner()
  {
    var game = new Game();
    game.ChoosePosition(4);
    game.ChoosePosition(5);
    string message = game.ChoosePosition(6);
    Assert.AreEqual("Player wins!", message);
  }
}
</pre>

<p>
We wrote this test to assume we could pick positions without worrying about getting blocked. That behavior has changed, so we’ll need to adapt our test. Again, we can use our new seam to plug in the path we want the Game to follow to stay out of our way:
</p>

<pre class="code">
[TestClass]
public class When_the_player_gets_three_in_a_row
{
  [TestMethod]
    public void it_should_announce_the_player_as_the_winner()
    {
      var game = new Game(<span class="highlight">new GameAdvisorStub(new int[] { 1, 2, 3})</span>);
      game.ChoosePosition(4);
      game.ChoosePosition(5);
      string message = game.ChoosePosition(6);
      Assert.AreEqual("Player wins!", message);
    }
}

</pre>

<p></p>
<div style="background: #3c0">
  &nbsp;
</div>

Now that we’ve fixed that test, let’s continue our refactoring effort. In generalizing our code, we introduced some duplication. Let’s fix this by extracting a method for determining the available paths for a given player:

<pre class="code">
List&lt;int[]> GetAvailablePathsFor(char player)
{
  string layout = _layout.Replace(player, 'T');
  var availablePaths = new List&lt;int[]>();

  foreach (var winningSlice in _winningPositions)
  {
    var slice = new string(winningSlice.ToList()
        .Select(p => layout.ElementAt(p - 1)).ToArray());

    if (_availablePathPattern.IsMatch(slice))
      availablePaths.Add(winningSlice);
  }

  return availablePaths;
}
</pre>

Now our SelectBestPlayerFor() method becomes:

<pre class="code">
public int SelectBestMoveForPlayer(char player)
{
  string layout = _layout.Replace(player, 'T');
  var availablePaths = <span class="highlight">GetAvailablePathsFor(player);</span>

    char opponentValue = (player == 'X') ? 'O' : 'X';
  string opponentLayout = _layout.Replace(opponentValue, 'T');

  <span class="highlight">List&lt;int[]> availableOpponentPaths = 
    GetAvailablePathsFor(opponentValue);</span>

    int[] threatingPath = availableOpponentPaths
    .Where(path => new string(
          path.Select(p => opponentLayout[p - 1]).ToArray())
        .Count(c => c == 'T') == 2).FirstOrDefault();

  if (threatingPath != null)
  {
    return threatingPath
      .First(position => opponentLayout[position - 1] == '\0');
  }

  int[] bestSlice = availablePaths.OrderByDescending(
      path => path.Count(p => layout[p - 1] == 'T')).First();
  return bestSlice.First(p => _layout[p - 1] == '\0');
}
</pre>

<p></p>
<div style="background: #3c0">
  &nbsp;
</div>

Next, let’s reorganize some of these operations so we can see how things group together:

<pre class="code">
public int SelectBestMoveForPlayer(char player)
{
  char opponentValue = (player == 'X') ? 'O' : 'X';
  string opponentLayout = _layout.Replace(opponentValue, 'T');
  List&lt;int[]> availableOpponentPaths = 
    GetAvailablePathsFor(opponentValue);

  int[] threatingPath = availableOpponentPaths
    .Where(path => new string(
          path.Select(p => opponentLayout[p - 1]).ToArray())
        .Count(c => c == 'T') == 2).FirstOrDefault();

  if (threatingPath != null)
  {
    return threatingPath
      .First(position => opponentLayout[position - 1] == '\0');
  }

  string layout = _layout.Replace(player, 'T');
  List&lt;int[]> availablePaths = GetAvailablePathsFor(player);
  int[] bestSlice = availablePaths.OrderByDescending(
      path => path.Count(p => layout[p - 1] == 'T')).First();
  return bestSlice.First(p => _layout[p - 1] == '\0');
}
</pre>

<p></p>
<div style="background: #3c0">
  &nbsp;
</div>

The first section is all about checking for threating opponent paths, but this isn’t very descriptive at the moment. Let’s move all of that into a method that describes exactly what we’re doing:

<pre class="code">
public int SelectBestMoveForPlayer(char player)
{
  <span class="highlight">int? threatingPosition = GetPositionThreateningPlayer(player);

  if (threatingPosition != null)
    return threatingPosition.Value;</span>

      string layout = _layout.Replace(player, 'T');
  List&lt;int[]> availablePaths = GetAvailablePathsFor(player);
  int[] bestSlice = availablePaths.OrderByDescending(
      path => path.Count(p => layout[p - 1] == 'T')).First();
  return bestSlice.First(p => _layout[p - 1] == '\0');
}

<span class="highlight">int? GetPositionThreateningPlayer(char player)
{
  char opponentValue = (player == 'X') ? 'O' : 'X';
  string opponentLayout = _layout.Replace(opponentValue, 'T');
  List&lt;int[]> availableOpponentPaths = 
    GetAvailablePathsFor(opponentValue);

  int[] threatingPath = availableOpponentPaths
    .Where(path => new string(
          path.Select(p => opponentLayout[p - 1]).ToArray())
        .Count(c => c == 'T') == 2).FirstOrDefault();

  if (threatingPath != null)
  {
    return threatingPath
      .First(position => opponentLayout[position - 1] == '\0');
  }

  return null;
}</span>
</pre>

<p></p>
<div style="background: #3c0">
  &nbsp;
</div>

Next, let’s extract the code for selecting the next winning path position for the player into a separate method:

<pre class="code">
public int SelectBestMoveForPlayer(char player)
{
  int? threatingPosition = GetPositionThreateningPlayer(player);

  if (threatingPosition != null)
    return threatingPosition.Value;

  <span class="highlight">return GetNextWinningMoveForPlayer(player);</span>
}

<span class="highlight">int GetNextWinningMoveForPlayer(char player)
{
  string layout = _layout.Replace(player, 'T');
  List&lt;int[]> availablePaths = GetAvailablePathsFor(player);
  int[] bestSlice = availablePaths.OrderByDescending(
      path => path.Count(p => layout[p - 1] == 'T')).First();
  return bestSlice.First(p => _layout[p - 1] == '\0');
}</span>
</pre>

<p></p>
<div style="background: #3c0">
  &nbsp;
</div>

Now, we can reduce our SelectBestMoveForPlayer() method down to one fairly descriptive line:

<pre class="code">
public int SelectBestMoveForPlayer(char player)
{
  <span class="highlight">return GetPositionThreateningPlayer(player) ??
    GetNextWinningMoveForPlayer(player);</span>
}
</pre>

<p></p>
<div style="background: #3c0">
  &nbsp;
</div>

We’re done! Here’s our GameAdvisor implementation:

<pre class="code">
class GameAdvisor : IGameAdvisor
{
  public IPositionSelector WithLayout(string layout)
  {
    return new PositionSelector(layout);
  }

  class PositionSelector : IPositionSelector
  {
    static readonly int[][] _winningPositions = new[]
    {
      new[] {1, 2, 3},
      new[] {4, 5, 6},
      new[] {7, 8, 9},
      new[] {1, 4, 7},
      new[] {2, 5, 8},
      new[] {3, 6, 9},
      new[] {1, 5, 9},
      new[] {3, 5, 7},
    };

    readonly Regex _availablePathPattern = new Regex(@"[T]{3}");
    readonly string _layout;

    public PositionSelector(string layout)
    {
      _layout = layout;
    }

    public int SelectBestMoveForPlayer(char player)
    {
      return GetPositionThreateningPlayer(player) ??
        GetNextWinningMoveForPlayer(player);
    }

    int GetNextWinningMoveForPlayer(char player)
    {
      string layout = _layout.Replace(player, 'T');
      List&lt;int[]> availablePaths = GetAvailablePathsFor(player);
      int[] bestSlice = availablePaths.OrderByDescending(
          path => path.Count(p => layout[p - 1] == 'T')).First();
      return bestSlice.First(p => _layout[p - 1] == '\0');
    }

    int? GetPositionThreateningPlayer(char player)
    {
      char opponentValue = (player == 'X') ? 'O' : 'X';
      string opponentLayout = _layout.Replace(opponentValue, 'T');
      List&lt;int[]> availableOpponentPaths = 
        GetAvailablePathsFor(opponentValue);

      int[] threatingPath = availableOpponentPaths
        .Where(path => new string(
              path.Select(p => opponentLayout[p - 1]).ToArray())
            .Count(c => c == 'T') == 2).FirstOrDefault();

      if (threatingPath != null)
      {
        return threatingPath
          .First(position => opponentLayout[position - 1] == '\0');
      }

      return null;
    }

    List&lt;int[]> GetAvailablePathsFor(char player)
    {
      string layout = _layout.Replace(player, 'T');
      var availablePaths = new List&lt;int[]>();

      foreach (var winningSlice in _winningPositions)
      {
        var slice = new string(winningSlice.ToList()
            .Select(p => layout.ElementAt(p - 1)).ToArray());

        if (_availablePathPattern.IsMatch(slice))
          availablePaths.Add(winningSlice);
      }

      return availablePaths;
    }
  }
}
</pre>

<p>
While we've been working on our component, another team has been putting together a host application with a nice user interface. We're now ready to hand our component over so it can be integrated into the rest of the application. Afterward, the full application will be passed on to a Quality Assurance Team to receive some acceptance testing. Next time we'll take a look at any issues that come out of the integration and QA testing processes.
</p>
