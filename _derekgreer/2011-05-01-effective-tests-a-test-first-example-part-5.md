---
id: 301
title: 'Effective Tests: A Test-First Example &#8211; Part 5'
date: 2011-05-01T17:28:35+00:00
author: Derek Greer
layout: post
guid: http://lostechies.com/derekgreer/?p=301
dsq_thread_id:
  - "292795566"
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
      <a href="https://lostechies.com/derekgreer/2011/04/24/effective-tests-a-test-first-example-part-4/">Effective Tests: A Test-First Example – Part 4</a>
    </li>
    <li>
      Effective Tests: A Test-First Example – Part 5
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

In [part 4](http://lostechies.com/derekgreer/2011/04/24/effective-tests-a-test-first-example-part-4/) of our Test-First example, we continued by addressing issues filed by the UI team. To conclude our example, we’ll finish the remaining issues this time.

Here’s what we have left:

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
      The game throws an InvalidOperationException when choosing positions 1, 2, 5, and 9.
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
      The game makes a move after the player wins.
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
      After letting the game win by choosing positions 4, 7, 8, and 6, choosing the last position of 3 throws an InvalidOperationException.
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
  </tr></table> 
  
  <p>
  </p>
  
  <p>
    Let’s get started with the first one:
  </p>
  
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
    </tr></table> 
    
    <p>
    </p>
    
    <p>
      This sounds like our game isn’t blocking correctly. After some analysis, the problem appears to be that certain strategies can lead to multiple winning choices which aren’t handled by our blocking strategy. Our game was designed to block when the player’s next move could result in a win, but it wasn’t designed to guard against moves that might lead to multiple winning paths.
    </p>
    
    <p>
      After doing some research, I discovered several websites that discuss the defensive strategies a player should take when playing Tic-tac-toe. While the sites I found spell out each step in detail, I think I’ve condensed the rules we need down to the following:
    </p>
    
    <ul>
      <li>
        When selecting your first position, always choose a corner or the center position. When the opponent goes first and has chosen either a corner or the center, choose the alternate of the two choices.
      </li>
      <li>
        If the player’s second move aligns two of their corners diagonally, choose an edge
      </li>
      <li>
        When you don’t need to block, prefer corners to edges.
      </li>
    </ul>
    
    <p>
      In theory, adding these strategies to our game would mean that a player would never be able to win, so I confirmed that this was indeed what the customer intended by the original requirements. Based on that information, let’s get started.
    </p>
    
    <p>
      We already have a context for describing the behavior that is expected when the game goes first, so let’s review our existing test:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
     public class When_the_game_goes_first
     {
         [TestMethod]
         public void it_should_put_an_X_in_one_of_the_available_positions()
         {
             var game = new Game();
             game.GoFirst();
             Assert.IsTrue(Enumerable.Range(1, 9).Any(position => game.GetPosition(position).Equals('X')));
         }
     }
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      This specification says that the game should put an ‘X’ in one of the available positions. What we now want it to do is to put an ‘X’ in center or one of the corner positions. Therefore, we’ll change the name of the test. This test was also written before we created our GameAdvisor, so let’s change the System Under Test to that as well:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
     public class When_the_game_goes_first
     {
         [TestMethod]
         public void <b>it_should_put_an_X_in_a_corner_or_the_center</b>()
         {
             <b>var gameAdvisor = new GameAdvisor();
             int selection = gameAdvisor.WithLayout("\0\0\0\0\0\0\0\0\0").SelectBestMoveForPlayer('X');
             Assert.IsTrue(new[]{1, 3, 5, 7, 9}.Any(position => position == selection));</b>
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
      Our test passes, but let’s make sure it’s actually verifying the behavior correctly by changing the GameAdvisor to always return the second position:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public int SelectBestMoveForPlayer(char player)
  {
     return 2;
      return GetPositionThreateningPlayer(player) ??
          GetNextWinningMoveForPlayer(player);
  }
  
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <div style="background: red">
      &nbsp;
    </div>
    
    <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_game_goes_first
  Failed	it_should_put_an_X_in_a_corner_or_the_center
  Assert.IsTrue failed. 	
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      Our test appears to be working correctly, so we’ll put the code back like it was.
    </p>
    
    <div style="background:#3C0">
      &nbsp;
    </div>
    
    <p>
      &nbsp;
    </p>
    
    <p>
      The practice of breaking a passing test to watch it fail is a useful strategy for ensuring we aren’t writing self-passing tests (i.e. tests that always pass due to a defect in the test implementation), or to verify that the test communicates regression in a clear way.
    </p>
    
    <p>
      Should we keep tests which pass unexpectedly? While it’s good to delete tests which describe behavior that is no longer applicable or which is explicitly or implicitly covered by another test, we should keep tests which describe important behavior that is coincidentally facilitated by the system. While our GameAdvisor happens to meet our revised specification, it does so because the order of our recommended paths happened to coincide with this requirement, not because anything required it to do so. Therefore, we should keep this test, both because we want to guard against this behavior changing and because it serves as useful documentation of the system’s expectations.
    </p>
    
    <p>
      Next, let’s create a test which describes what the game’s first selection should be if a corner is already occupied:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
     public class When_the_game_selects_its_first_position_where_a_corner_is_occupied
     {
         [TestMethod]
         public void it_should_choose_the_center()
         {
             var gameAdvisor = new GameAdvisor();
             int selection = gameAdvisor.WithLayout("X\0\0\0\0\0\0\0\0").SelectBestMoveForPlayer('O');
             Assert.AreEqual(5, selection);
         }
     }
  
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      Running this test results in the following:
    </p>
    
    <div style="background: red">
      &nbsp;
    </div>
    
    <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_game_selects_its_first_position_where_a_corner_is_occupied
  Failed	it_should_choose_the_center
  Assert.AreEqual failed. Expected:&lt;5>. Actual:&lt;4>. 	
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      Since I’m not quite sure how best to proceed, I’m going to take the easy route and modify the SelectBestMoveForPlayer() method to return a 5 when the layout matches the one we’re testing for:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public int SelectBestMoveForPlayer(char player)
  {
     if (_layout == "X\0\0\0\0\0\0\0\0")
         return 5;
  
     return GetPositionThreateningPlayer(player) ?? GetNextWinningMoveForPlayer(player);
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
      Now let’s work on a real implementation. Since selecting the middle position based on the opponent’s choices is a defensive move, it sounds like the logic for determining this behavior belongs to the GetPositionThreateningPlayer() method. Let’s modify this method to select the middle position if the opponent has a corner and this is the first move for the player being advised:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  int? GetPositionThreateningPlayer(char player)
              {
                  char opponentValue = (player == 'X') ? 'O' : 'X';
                  string opponentLayout = _layout.Replace(opponentValue, 'T');
                  List&lt;int[]> availableOpponentPaths = GetAvailablePathsFor(opponentValue);
  
                  int[] threatingPath = availableOpponentPaths
                      .Where(path => new string(path.Select(p => opponentLayout[p - 1]).ToArray())
                                         .Count(c => c == 'T') == 2).FirstOrDefault();
  
                  if (threatingPath != null)
                  {
                      return threatingPath.First(position => opponentLayout[position - 1] == '\0');
                  }
  
                  <b>if (_layout.Count(position => position == player) == 0 &&
                      new[] {0, 2, 6, 8}.Any(position => opponentLayout[position] == 'T'))
                  {
                      return 5;
                  }</b>
  
                  return null;
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
      Now let’s refactor. While I don’t see any real duplication, I think our code would be more descriptive if we encapsulate these two paths to a list of “defensive strategies”:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  class PositionSelector : IPositionSelector
         {
             ...
  
             int? GetPositionThreateningPlayer(char player)
             {
                 <b>return new DefensiveStrategy[]
                            {
                                SimpleBlockStrategy,
                                FirstMoveCounterCenterStrategy
                            }
                     .Select(strategy => strategy(player)).FirstOrDefault(p => p.HasValue);</b>
             }
  
             <b>int? SimpleBlockStrategy(char player)
             {
                 char opponentValue = (player == 'X') ? 'O' : 'X';
                 string opponentLayout = _layout.Replace(opponentValue, 'T');
                 List&lt;int[]> availableOpponentPaths = GetAvailablePathsFor(opponentValue);
  
                 int[] threatingPath = availableOpponentPaths
                     .Where(path => new string(path.Select(p => opponentLayout[p - 1]).ToArray())
                                        .Count(c => c == 'T') == 2).FirstOrDefault();
  
                 if (threatingPath != null)
                 {
                     return threatingPath.First(position => opponentLayout[position - 1] == '\0');
                 }
  
                 return null;
             }
  
             int? FirstMoveCounterCenterStrategy(char player)
             {
                 int? value = null;
                 char opponentValue = (player == 'X') ? 'O' : 'X';
                 string opponentLayout = _layout.Replace(opponentValue, 'T');
  
                 if (_layout.Count(position => position == player) == 0 &&
                     new[] {0, 2, 6, 8}.Any(position => opponentLayout[position] == 'T'))
                 {
                     value = 5;
                 }
  
                 return value;
             }
  
             ...
  
             delegate int? DefensiveStrategy(char player);</b>
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
      Now we have a bit of duplication for determining the opponent’s value, so let’s factor that out:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  int? SimpleBlockStrategy(char player)
             {
                 char opponentValue = <b>GetOpponentValue(player);</b>
                 string opponentLayout = _layout.Replace(opponentValue, 'T');
                 List&lt;int[]> availableOpponentPaths = GetAvailablePathsFor(opponentValue);
  
                 int[] threatingPath = availableOpponentPaths
                     .Where(path => new string(path.Select(p => opponentLayout[p - 1]).ToArray())
                                        .Count(c => c == 'T') == 2).FirstOrDefault();
  
                 if (threatingPath != null)
                 {
                     return threatingPath.First(position => opponentLayout[position - 1] == '\0');
                 }
  
                 return null;
             }
  
             int? FirstMoveCounterCenterStrategy(char player)
             {
                 int? value = null;
                 string opponentLayout = _layout.Replace(<b>GetOpponentValue(player)</b>, 'T');
  
                 if (_layout.Count(position => position == player) == 0 &&
                     new[] {0, 2, 6, 8}.Any(position => opponentLayout[position] == 'T'))
                 {
                     value = 5;
                 }
  
                 return value;
             }
  
             <b>static char GetOpponentValue(char player)
             {
                 return (player == 'X') ? 'O' : 'X';
             }</b>
  
  
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
      While reviewing this code, I noticed that neither of these methods, nor the GetNextWinningMoveForPlayer() method appear to require the opponentLayout string to be created. This appears to be an artifact left over from a much earlier refactoring that somehow went unnoticed. Let’s go ahead and remove the use of this variable and replace the generic token character ‘T’ we were using with the actual opponent value:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  int GetNextWinningMoveForPlayer(char player)
             {
                 List&lt;int[]> availablePaths = GetAvailablePathsFor(player);
                 int[] bestSlice = availablePaths.OrderByDescending(
                     path => path.Count(p => _layout[p - 1] == <b>player</b>)).First();
                 return bestSlice.First(p => _layout[p - 1] == '\0');
             }
  
  
             ...
  
             int? SimpleBlockStrategy(char player)
             {
                 char opponentValue = GetOpponentValue(player);
                 List&lt;int[]> availableOpponentPaths = GetAvailablePathsFor(opponentValue);
  
                 int[] threatingPath = availableOpponentPaths
                     .Where(path => new string(path.Select(p => _layout[p - 1]).ToArray())
                                        .Count(c => c == <b>opponentValue</b>) == 2).FirstOrDefault();
  
                 if (threatingPath != null)
                 {
                     return threatingPath.First(position => _layout[position - 1] == '\0');
                 }
  
                 return null;
             }
  
             int? FirstMoveCounterCenterStrategy(char player)
             {
                 int? value = null;
                 if (_layout.Count(position => position == player) == 0 &&
                     new[] {0, 2, 6, 8}.Any(position => _layout[position] == <b>GetOpponentValue(player)</b>))
                 {
                     value = 5;
                 }
  
                 return value;
             }
  
  
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      Let’s move on to the alternate first move strategy: Choosing the corner if the opponent has chosen the center:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
     public class When_the_game_selects_its_first_position_where_the_center_is_occupied
     {
         [TestMethod]
         public void it_should_choose_a_corner()
         {
             var gameAdvisor = new GameAdvisor();
             int selection = gameAdvisor.WithLayout("\0\0\0\0X\0\0\0\0").SelectBestMoveForPlayer('O');
             Assert.IsTrue(new[] {1, 3, 7, 9}.Any(position => position == selection));
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
      This test already passes, so let’s make sure we’ve written it correctly:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public int SelectBestMoveForPlayer(char player)
  {
     <b>return 1;</b>
     return GetPositionThreateningPlayer(player) ?? GetNextWinningMoveForPlayer(player);
  }
  
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <div style="background: red">
      &nbsp;
    </div>
    
    <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_game_selects_its_first_position_where_the_center_is_occupied
  Failed	it_should_choose_a_corner
  Assert.IsTrue failed. 	
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      The test looks good, so let’s put things back:
    </p>
    
    <div style="background:#3C0">
      &nbsp;
    </div>
    
    <p>
      &nbsp;
    </p>
    
    <p>
      Our next defensive strategy is to chose an edge position (i.e. a non-corner, non-center position) if the player’s second move aligns two of their corners diagonally. This strategy prevents one of the ways an opponent can set up two non-diagonal winning paths. Here’s our test:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
     public class When_the_game_selects_its_second_position_where_the_player_chooses_opposite_diagonal_corners
     {
         [TestMethod]
         public void it_should_choose_an_edge()
         {
             var gameAdvisor = new GameAdvisor();
             int selection = gameAdvisor.WithLayout("\0\0X\0O\0X\0\0").SelectBestMoveForPlayer('O');
             Assert.IsTrue(new[] { 2, 4, 6, 8 }.Any(position => position == selection));
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
      Interestingly, this test also already passes. This must be due to the fact that our GameAdvisor always selects position 4 as its choice if the first row is occupied. It’s possible that the behavior of the GameAdvisor could change in the future in such a way as to allow this condition to be met but not a horizontal alignment in the opposite direction, so let’s change this test to guard against both conditions:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
     public class When_the_game_selects_its_second_position_where_the_player_chooses_opposite_diagonal_corners
     {
         [TestMethod]
         public void it_should_choose_an_edge()
         {
             var gameAdvisor = new GameAdvisor();
  
             <b>new[]
                 {
                     "\0\0X\0O\0X\0\0",
                     "X\0\0\0O\0\0\0X"
                 }.ToList().ForEach(layout =>
                 {</b>
                     int selection = gameAdvisor.WithLayout(<b>layout</b>).SelectBestMoveForPlayer('O');
                     Assert.IsTrue(new[] { 2, 4, 6, 8 }.Any(position => position == selection));
                 <b>})</b>;
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
      Let’s make sure the test is written correctly for both conditions:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public int SelectBestMoveForPlayer(char player)
  {
     <b>if (_layout == "\0\0X\0O\0X\0\0" || _layout == "X\0\0\0O\0\0\0X")
                     return 1;</b>
  
     return GetPositionThreateningPlayer(player) ?? GetNextWinningMoveForPlayer(player);
  }
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <div style="background: red">
      &nbsp;
    </div>
    
    <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_game_selects_its_second_position_where_the_player_chooses_opposite_diagonal_corners
  Failed	it_should_choose_an_edge
  Assert.IsTrue failed. 	
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      This seems to work, so let’s revert it:
    </p>
    
    <div style="background:#3C0">
      &nbsp;
    </div>
    
    <p>
      &nbsp;
    </p>
    
    <p>
      Our last change for improving our defensive strategy is to modify the game to prefer corners to edges when we don’t need to block. This prevents a situation where an opponent can align one diagonal path and either a horizontal or vertical winning path. Here’s our test:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
     public class When_a_game_selects_an_offensive_position
     {
         [TestMethod]
         public void it_should_prefer_corners_to_edges()
         {
             var gameAdvisor = new GameAdvisor();
             int selection = gameAdvisor.WithLayout("\0\0X\0X\0O\0\0").SelectBestMoveForPlayer('O');
             Assert.IsTrue(new[] {1, 9}.Any(position => position == selection));
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
  When_a_game_selects_an_offensive_position
  Failed	it_should_prefer_corners_to_edges
  Assert.IsTrue failed. 	
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      To make this pass, we should only have to rearrange our winning positions array to put the edges as the last position selected and to move any paths with a first or second edge position to the bottom of the list:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  class PositionSelector : IPositionSelector
         {
             static readonly int[][] _winningPositions = new[]
                                                             {
                                                                 <b>new[] {1, 3, 2},
                                                                 new[] {7, 9, 8},
                                                                 new[] {1, 7, 4},
                                                                 new[] {3, 9, 6},
                                                                 new[] {1, 9, 5},
                                                                 new[] {3, 7, 5},
                                                                 new[] {2, 8, 5},
                                                                 new[] {4, 6, 5}</b>
                                                             };
             …
         }
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      Let’s run our test to see what happens:
    </p>
    
    <div style="background: red">
      &nbsp;
    </div>
    
    <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_a_game_selects_an_offensive_position
  Failed	it_should_choose_an_edge
  Assert.IsTrue failed. 	
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      Our theory seems to have held up, but we ended up breaking our last test. Let’s review the broken test:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
     public class When_the_game_selects_its_second_position_where_the_player_chooses_opposite_diagonal_corners
     {
         [TestMethod]
         public void it_should_choose_an_edge()
         {
             var gameAdvisor = new GameAdvisor();
  
             new[]
                 {
                     "\0\0X\0O\0X\0\0",
                     "X\0\0\0O\0\0\0X"
                 }.ToList().ForEach(layout =>
                     {
                         int selection = gameAdvisor.WithLayout(layout).SelectBestMoveForPlayer('O');
                         Assert.IsTrue(new[] {2, 4, 6, 8}.Any(position => position == selection));
                     });
         }
     }
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      Unfortunately, that test represents multiple layouts, so we can’t tell exactly which layout failed. Before proceeding further, let’s see if we can address this problem.
    </p>
    
    <p>
      Perhaps the most straightforward way of addressing this issue would be to make two separate tests for each of these conditions, but from a documentation perspective I think it’s more clear to have one test that concerns what to do when the player chooses opposite diagonal corners rather than two describing each of the cases. Viewed in isolation, it may not be as clear that both really represent the same strategy for a different orientations of the board. Let’s stay with our existing approach for this test, but modify it so the exception tells us exactly what scenario is causing an issue. We can achieve this by adding a description to our assertion and aggregating any exception messages together to display once all the cases have been run. We’ll use a exception test helper to cut down on the try/catch noise:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
     public class When_the_game_selects_its_second_position_where_the_player_chooses_opposite_diagonal_corners
     {
         [TestMethod]
         public void it_should_choose_an_edge()
         {
             var gameAdvisor = new GameAdvisor();
             <b>var exceptions = new List&lt;string>();</b>
  
             new[]
                 {
                     "\0\0X\0O\0X\0\0",
                     "X\0\0\0O\0\0\0X"
                 }.ToList().ForEach(layout =>
                     {
                         int selection = gameAdvisor.WithLayout(layout).SelectBestMoveForPlayer('O');
                         var exception = Catch.Exception(() =>
                             Assert.IsTrue(new[] {2, 4, 6, 8}.Any(position => position == selection),
                                 <b>string.Format("edge not selected for layout:{0}", layout)));
                         if(exception != null) exceptions.Add(exception.Message);
                     });</b>
  
             <b>if (exceptions.Count > 0)
                 throw new AssertFailedException(string.Join(Environment.NewLine, exceptions));</b>
         }
     }
  
     <b>public static class Catch
     {
         public static Exception Exception(Action action)
         {
             try { action(); }
             catch (Exception e) { return e;  }
             return null;
         }
     }</b>
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      Let’s run our tests again:
    </p>
    
    <div style="background: red">
      &nbsp;
    </div>
    
    <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_game_selects_its_second_position_where_the_player_chooses_opposite_diagonal_corners
  Failed	it_should_choose_an_edge
  Assert.IsTrue failed. edge not selected for layout:\0\0X\0O\0X\0\0
  Assert.IsTrue failed. edge not selected for layout:X\0\0\0O\0\0\0X
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      This produces the result I was looking for, but the test seems a little obscure. Let’s leave it like this for now, but we’ll discuss techniques for cleaning this up later in our series.
    </p>
    
    <p>
      Getting back to the main issue, this test is failing because the GameAdvisor was fulfilling this specification by relying upon the ordering of the original winning patterns array. This was a perfectly acceptable strategy at the time, but we’ll need to add new behavior now that we’ve changed how this works internally.
    </p>
    
    <p>
      To get the test passing, let’s approach this just like we would a new failing test and implement the quickest solution that gets the test passing:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public int SelectBestMoveForPlayer(char player)
             {
                 <b>if (_layout == "\0\0X\0O\0X\0\0" || _layout == "X\0\0\0O\0\0\0X")
                     return 4;</b>
  
                 return GetPositionThreateningPlayer(player) ?? GetNextWinningMoveForPlayer(player);
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
      Next, let’s create a new DefensiveStrategy method and move our fake implementation to our new method:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  int? GetPositionThreateningPlayer(char player)
             {
                 return new DefensiveStrategy[]
                            {
                                SimpleBlockStrategy,
                                FirstMoveCounterCenterStrategy,
                                <b>SecondMoveDiagonalCounterStrategy</b>
                            }
                     .Select(strategy => strategy(player)).FirstOrDefault(p => p.HasValue);
             }
  
             <b>int? SecondMoveDiagonalCounterStrategy(char player)
             {
                 if (_layout == "\0\0X\0O\0X\0\0" || _layout == "X\0\0\0O\0\0\0X")
                     return 4;
                 
                 return null;
             }</b>
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
      Now, let’s change our comparison to only check the positions we care about:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  int? SecondMoveDiagonalCounterStrategy(char player)
             {
                 var opponentValue = GetOpponentValue(player);
  
                 <b>if((_layout[2] == opponentValue && _layout[6] == opponentValue) ||
                     (_layout[0] == opponentValue && _layout[8] == opponentValue))</b>
                     return 4;
                 
                 return null;
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
      Lastly, we’ll change the the value of 4 to be the value of the first unoccupied edge, or null if all are occupied:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  int? SecondMoveDiagonalCounterStrategy(char player)
             {
                 var opponentValue = GetOpponentValue(player);
  
                 if ((_layout[2] == opponentValue && _layout[6] == opponentValue) ||
                     (_layout[0] == opponentValue && _layout[8] == opponentValue))
                     <b>return new[] {2, 4, 6, 8}.FirstOrDefault(position => _layout[position - 1] == '\0');</b>
                 
                 return null;
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
      In theory, our new changes should cover the gaps in our initial blocking strategy, but we don’t actually have a test for the specific defect that was reported. Let’s create a test which describes the specific steps reported in the defect:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  // http://github/mygroup/tic-tac-toe/issues/1
     [TestClass]
     public class When_a_player_attempts_to_choose_positions_1_5_2_and_8
     {
         [TestMethod]
         public void it_should_prevent_the_player_from_winning()
         {
             var game = new Game();
             var result = (GameResult) (-1);
             game.GameComplete += (s, e) => result = e.Result;
  
             new[] {1, 4, 2, 8}.ToList().ForEach(position =>
                 {
                     if (result == (GameResult)(-1))
                         Catch.Exception(() => game.ChoosePosition(position));
                 });
  
             Assert.AreNotEqual(GameResult.PlayerWins, result);
  
         }
     }
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      In this test, we’re choosing each position in sequence until the result changes. Since it’s possible that the game may throw an exception due to our choosing a position already occupied, we’re issuing our ChoosePosition() call within a call to our Catch.Exception() helper.
    </p>
    
    <p>
      The test name for this test is a bit more obscure than our previous ones since it describes more of the “how” than the “why”, but since the purpose of this test is to correct the behavior reported by a specific defect, it seems appropriate to name the test after the scenario it’s intended to address. To aid in its documentation, we’ve included a simple comment containing a link to the issue that was filed.
    </p>
    
    <p>
      Let’s run the test:
    </p>
    
    <div style="background: red">
      &nbsp;
    </div>
    
    <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_a_player_attempts_to_choose_positions_1_5_2_and_8
  Failed	it_should_prevent_the_player_from_winning
  TestFirstExample.When_player_attempts_to_choose_positions_1_5_2_and_8.it_should_prevent_the_player_from_winning threw exception:
  System.InvalidOperationException: Sequence contains no matching element
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      It appears this scenario uncovered an issue we didn’t run into with our previous specifications. Researching the issue, the cause appears to be that the GameAdvisor is throwing an exception in the GetNextWinningMoveForPlayer() method when the First() method is called on an empty bestSlice collection. Let’s fix this:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  int GetNextWinningMoveForPlayer(char player)
             {
                 List&lt;int[]> availablePaths = GetAvailablePathsFor(player);
                 int[] bestSlice = availablePaths.OrderByDescending(
                     path => path.Count(p => _layout[p - 1] == player)).First();
                 return bestSlice.<b>FirstOrDefault</b>(p => _layout[p - 1] == '\0');
             }
  
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      Now, let’s run our tests again:
    </p>
    
    <div style="background: red">
      &nbsp;
    </div>
    
    <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_a_player_attempts_to_choose_positions_1_5_2_and_8
  Failed	it_should_prevent_the_player_from_winning
  TestFirstExample.When_player_attempts_to_choose_positions_1_5_2_and_8.it_should_prevent_the_player_from_winning threw exception:
  System.IndexOutOfRangeException: Index was outside the bounds of the array.
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      We got passed that exception, but now there’s another one. Further analysis reveals that an exception is being thrown from the Game’s SelectAPositionFor() method when a recommended position of zero is returned from the GameAdvisor. The Game class now only calls the GameAdvisor when there are positions left, so it shouldn’t be returning zero. Stepping through the execution of the GameAdvisor, it turns out that it stops recommending positions once it runs out of meaningful offensive and defensive strategies.
    </p>
    
    <p>
      We could correct this within the context of our existing test, but this feels more like missing behavior than just a bug. Since we want our GameAdvisor to continue recommending positions until there are no positions left, let’s write a new test to explicitly specify this new behavior:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
     public class When_the_game_selects_a_position_where_no_winning_spaces_are_left
     {
         [TestMethod]
         public void it_should_choose_the_first_available_position()
         {
             var gameAdvisor = new GameAdvisor();
             int selection = gameAdvisor.WithLayout("0XOOX\0XOX").SelectBestMoveForPlayer('X');
             Assert.AreEqual(6, selection);
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
  When_the_game_selects_a_position_when_no_winning_spaces_are_left
  Failed	it_should_choose_the_first_available_position
  TestFirstExample.When_the_game_selects_a_position_where_no_winning_spaces_are_left.it_should_choose_the_first_available_position threw exception:
  System.InvalidOperationException: Sequence contains no elements
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      Let’s make the test fail for the right reason:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public int SelectBestMoveForPlayer(char player)
             {
                 return GetPositionThreateningPlayer(player) ?? GetNextWinningMoveForPlayer(player) <b>?? 1</b>;
             }
  
             <b>int?</b> GetNextWinningMoveForPlayer(char player)
             {
                 List&lt;int[]> availablePaths = GetAvailablePathsFor(player);
                 <b>int? nextPosition = null;</b>
  
                 <b>if (availablePaths != null)
                 {</b>
                     int[] bestSlice = availablePaths.OrderByDescending(path => path.Count(p => _layout[p - 1] == player)).FirstOrDefault();
                     <b>if (bestSlice != null)</b> nextPosition = bestSlice.FirstOrDefault(p => _layout[p - 1] == '\0');
                 &lt;/b>}&lt;/b>
  
                 <b>return nextPosition;</b>
             }
  
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <div style="background: red">
      &nbsp;
    </div>
    
    <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_game_selects_a_position_when_no_winning_spaces_are_left
  Failed	it_should_choose_the_first_available_position
  Assert.AreEqual failed. Expected:&lt;6>. Actual:&lt;1>. 	
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      To make the test pass, we should be able to select the first empty position as the default strategy:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public int SelectBestMoveForPlayer(char player)
             {
                 return GetPositionThreateningPlayer(player)
                     ?? GetNextWinningMoveForPlayer(player)
                     ?? <b>Enumerable.Range(1, 9).First(position => _layout[position - 1] == '\0');</b>
             }
  
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      Let’s run all our tests again:
    </p>
    
    <div style="background:#3C0">
      &nbsp;
    </div>
    
    <p>
      &nbsp;
    </p>
    
    <p>
      This passes our new test as well as our initial broken test. Now that we’ve make the test pass, let’s refactor.
    </p>
    
    <p>
      As with our Game class, let’s substitute our uses of the null character with the Game’s EmptyValue constant:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public class GameAdvisor : IGameAdvisor
     {
         ...
  
             public int SelectBestMoveForPlayer(char player)
             {
                 return GetPositionThreateningPlayer(player)
                     ?? GetNextWinningMoveForPlayer(player)
                     ?? Enumerable.Range(1, 9).First(position => _layout[position - 1] == <b>Game.EmptyValue</b>);
             }
  
             int? GetNextWinningMoveForPlayer(char player)
             {
                 List&lt;int[]> availablePaths = GetAvailablePathsFor(player);
                 int? nextPosition = null;
  
                 if (availablePaths != null)
                 {
                     int[] bestSlice = availablePaths.OrderByDescending(path => path.Count(p => _layout[p - 1] == player)).FirstOrDefault();
                     if (bestSlice != null) nextPosition = bestSlice.FirstOrDefault(p => _layout[p - 1] == <b>Game.EmptyValue</b>);
                 }
  
                 return nextPosition;
             }
  
             ...
  
             int? SecondMoveDiagonalCounterStrategy(char player)
             {
                 char opponentValue = GetOpponentValue(player);
  
                 if ((_layout[2] == opponentValue && _layout[6] == opponentValue) ||
                     (_layout[0] == opponentValue && _layout[8] == opponentValue))
                     return new[] {2, 4, 6, 8}.FirstOrDefault(position => _layout[position - 1] == <b>Game.EmptyValue</b>);
  
                 return null;
             }
  
             int? SimpleBlockStrategy(char player)
             {
                 char opponentValue = GetOpponentValue(player);
                 List&lt;int[]> availableOpponentPaths = GetAvailablePathsFor(opponentValue);
  
                 int[] threatingPath = availableOpponentPaths
                     .Where(path => new string(path.Select(p => _layout[p - 1]).ToArray())
                                        .Count(c => c == opponentValue) == 2).FirstOrDefault();
  
                 if (threatingPath != null)
                 {
                     return threatingPath.First(position => _layout[position - 1] == <b>Game.EmptyValue</b>);
                 }
  
                 return null;
             }
  
             ...
     }
  
  
  <br />
  
</div></pre>
    
    <p>
    </p>
    
    <p>
      For this to compile, we’ll also need to make this value public:
    </p>
    
    <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public class Game
     {
         …
  
         <b>public</b> const char EmptyValue = char.MinValue;
  
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
      Let’s move on to our next issue:
    </p>
    
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
          The game throws an InvalidOperationException when choosing positions 1, 2, 5, and 9.
        </td>
        
        <td style="border: 1px solid black;">
          <nobr>QA Team</nobr>
        </td>
      </tr></table> 
      
      <p>
      </p>
      
      <p>
        In testing the previous version of the game, the exception being thrown originated from the GameAdvisor’s GetNextWinningMoveForPlayer() position. Since we’ve modified this method, the new version may no longer throw this exception. Let’s write our test and see what happens:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  // http://github/mygroup/tic-tac-toe/issues/2
     [TestClass]
     public class When_a_player_attempts_to_choose_positions_1_2_5_9
     {
         [TestMethod]
         public void it_should_not_throw_an_exception()
         {
             Exception exception = null;
             var game = new Game();
             var result = (GameResult) (-1);
             game.GameComplete += (s, e) => result = e.Result;
  
             new[] {1, 2, 5, 9}.ToList().ForEach(position =>
                 {
                     Exception ex = null;
  
                     if (result == (GameResult) (-1))
                         ex = Catch.Exception(() => game.ChoosePosition(position));
  
                     if (ex is InvalidOperationException )
                         exception = ex;
                 });
  
             Assert.IsNotInstanceOfType(exception, typeof (InvalidOperationException));
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
        As suspected, this error seems to have already been addressed somewhere along the way. Let’s break the test to make sure it’s working:
      </p>
      
      <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public void ChoosePosition(int position)
         {
             throw new InvalidOperationException();
  
             ...
         }
  
  <br />
  
</div></pre>
      
      <p>
      </p>
      
      <div style="background: red">
        &nbsp;
      </div>
      
      <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_a_player_attempts_to_choose_positions_1_2_5_9
  Failed	it_should_not_throw_an_exception
  Assert.IsNotInstanceOfType failed. Wrong Type:&lt;System.InvalidOperationException>. Actual type:&lt;System.InvalidOperationException>. 	
  
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
        Here’s our next defect:
      </p>
      
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
            The game makes a move after the player wins
          </td>
          
          <td style="border: 1px solid black;">
            <nobr>QA Team</nobr>
          </td>
        </tr></table> 
        
        <p>
        </p>
        
        <p>
          I seem to recall we ran into this issue while redesigning the game to raise events when a player wins. I suspect this issue no longer exists, but let’s write a test for this defect to confirm:
        </p>
        
        <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  // http://github/mygroup/tic-tac-toe/issues/3
      [TestClass]
      public class When_the_player_chooses_a_position_which_wins_the_game
      {
          [TestMethod]
          public void it_should_not_select_a_position_for_the_game()
          {
              var game = new Game(new GameAdvisorStub(new[] {4, 5, 9, 6}));
              Enumerable.Range(1, 3).ToList().ForEach(game.ChoosePosition);
              var lastGameChoice = game.GetLastChoiceBy(Player.Game);
              Assert.AreNotEqual(6, lastGameChoice);
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
          It looks like this issue is no longer present. Let’s break the test to make sure our test is validating correctly:
        </p>
        
        <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public int GetLastChoiceBy(Player player)
          {
              return 6;
              // return _lastPositionDictionary[player];
          }
  <br />
  
</div></pre>
        
        <p>
        </p>
        
        <div style="background: red">
          &nbsp;
        </div>
        
        <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_player_chooses_a_position_which_wins_the_game
  Failed	it_should_not_select_a_position_for_the_game
  Assert.AreNotEqual failed. Expected any value except:&lt;6>. Actual:&lt;6>. 	
  
</div></pre>
        
        <p>
        </p>
        
        <p>
          Everything looks correct, so we’ll revert the change:
        </p>
        
        <div style="background:#3C0">
          &nbsp;
        </div>
        
        <p>
          &nbsp;
        </p>
        
        <p>
          After thinking about this issue, it occurred to me that our game probably doesn’t handle the reverse case of a player making a move after the game has been won. This seems like an issue we should address, but to avoid adding anything unnecessarily I checked with the customer and the UI team to see what the expectations were for this scenario. The customer said they wanted the game to tell the user the game was already over in this case, so it was decided that we should raise an exception that could be caught by the UI team. Let’s go ahead and write out test for this case:
        </p>
        
        <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
     public class When_the_player_selects_a_position_after_a_player_has_won
     {
         [TestMethod]
         public void it_should_tell_the_player_the_game_is_over()
         {
             Exception exception = null;
             var game = new Game(new GameAdvisorStub(new[] {1, 2, 3}));
             new[] { 4, 5, 7}.ToList().ForEach(game.ChoosePosition);
  
             exception = Catch.Exception(() => game.ChoosePosition(9));
             Assert.AreSame(typeof(GameOverException), exception.GetType());
         }
     }
  <br />
  
</div></pre>
        
        <p>
        </p>
        
        <p>
          Here’s the exception we need to make the test compile:
        </p>
        
        <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  public class GameOverException : Exception
  {
  }
  
  <br />
  
</div></pre>
        
        <p>
        </p>
        
        <p>
          Let’s run the test:
        </p>
        
        <div style="background: red">
          &nbsp;
        </div>
        
        <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_the_player_selects_a_position_after_a_player_has_won
  Failed	it_should_tell_the_player_the_game_is_over	
  Assert.AreSame failed. 	
  
</div></pre>
        
        <p>
        </p>
        
        <p>
          Now let’s make it pass. Let’s move our existing someoneWon variable to a field and raise our new exception if someone won or if no positions are left at the entry of our method:
        </p>
        
        <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  <b>bool _someoneWon;</b>
     
         public void ChoosePosition(int position)
         {
             <b>if (_someoneWon || !PositionsAreLeft())
             {
                 throw new GameOverException();
             }</b>
  
  
             if (IsOutOfRange(position))
             {
                 throw new InvalidPositionException(string.Format("The position \'{0}\' was invalid.", position));
             }
  
             if (_layout[position - 1] != EmptyValue)
             {
                 throw new OccupiedPositionException(string.Format("The position \'{0}\' is already occupied.", position));
             }
  
             <b>_someoneWon</b> = new Func&lt;bool>[]
                               {
                                   () =>
                                   CheckPlayerStrategy(Player.Human,
                                                       () => _layout[position - 1] = GetTokenFor(Player.Human)),
                                   () => CheckPlayerStrategy(Player.Game, () => SelectAPositionFor(Player.Game))
                               }.Any(winningPlay => winningPlay());
  
             if (!(&lt;/b>_someoneWon&lt;/b> || PositionsAreLeft()))
             {
                 InvokeGameComplete(new GameCompleteEventArgs(GameResult.Draw));
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
          There doesn’t appear to be anything to refactor, so let’s move on. Here’s our next defect:
        </p>
        
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
              After letting the game win by choosing positions 4, 7, 8, and 6, choosing the last position of 3 throws an InvalidOperationException.
            </td>
            
            <td style="border: 1px solid black;">
              <nobr>QA Team</nobr>
            </td>
          </tr></table> 
          
          <p>
          </p>
          
          <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  // http://github/mygroup/tic-tac-toe/issues/5
     [TestClass]
     public class When_a_player_attempts_to_choose_positions_4_7_8_6
     {
         [TestMethod]
         public void it_should_not_throw_an_exception()
         {
             Exception exception = null;
             var game = new Game();
             var result = (GameResult)(-1);
             game.GameComplete += (s, e) => result = e.Result;
  
             new[] { 4, 7, 8, 6 }.ToList().ForEach(position =>
             {
                 Exception ex = null;
  
                 if (result == (GameResult)(-1))
                     ex = Catch.Exception(() => game.ChoosePosition(position));
  
                 if (ex is InvalidOperationException)
                     exception = ex;
             });
  
             Assert.IsNotInstanceOfType(exception, typeof(InvalidOperationException));
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
            As with the others, let’s make sure the test is working properly:
          </p>
          
          <div style="background: red">
            &nbsp;
          </div>
          
          <pre><div style="overflow:auto;background-color: #FFFFF;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  When_a_player_attempts_to_choose_positions_4_7_8_6
  Failed	it_should_not_throw_an_exception
  Assert.IsNotInstanceOfType failed. Wrong Type:&lt;System.InvalidOperationException>. Actual type:&lt;System.InvalidOperationException>. 	
  
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
            We’re almost done! Here’s our last defect:
          </p>
          
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
                When trying to let the game win by choosing positions 1, 7, and 8, the game chose positions 4, 5, and 9 instead of completing the winning sequence 4, 5, 6.
              </td>
              
              <td style="border: 1px solid black;">
                <nobr>QA Team</nobr>
              </td>
            </tr></table> 
            
            <p>
            </p>
            
            <p>
              This isn’t really a bug so much as a missing feature. Rather than addressing this issue with a test describing this specific set of moves, let’s describe the missing behavior whose expectations are implied by this defect:
            </p>
            
            <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  [TestClass]
     public class When_the_game_can_win_with_the_next_move
     {
         [TestMethod]
         public void it_should_select_the_winning_position()
         {
             var game = new Game();
             var result = (GameResult)(-1);
             game.GameComplete += (s, e) => result = e.Result;
             new[] { 1, 7, 8 }.ToList().ForEach(game.ChoosePosition);
             Assert.AreEqual(GameResult.GameWins, result);
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
  When_the_game_can_win_with_the_next_move
  Failed	it_should_not_throw_an_exception
  Assert.AreEqual failed. Expected:&lt;GameWins>. Actual:&lt;-1>. 	
  
</div></pre>
            
            <p>
            </p>
            
            <p>
              I think this can be corrected with a new defensive strategy, so let’s take the leap of skipping a fake implementation and go ahead and add the new behavior:
            </p>
            
            <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  class PositionSelector : IPositionSelector
         {
             ...
  
             int? GetPositionThreateningPlayer(char player)
             {
                 return new DefensiveStrategy[]
                            {
                                <b>PathCompletionStrategy,</b>
                                SimpleBlockStrategy,
                                FirstMoveCounterCenterStrategy,
                                SecondMoveDiagonalCounterStrategy
                            }
                     .Select(strategy => strategy(player)).FirstOrDefault(p => p.HasValue);
             }
  
             <b>int? PathCompletionStrategy(char player)
             {
                 List&lt;int[]> availablePaths = GetAvailablePathsFor(player);
  
  
                 int[] winningPath = availablePaths
                     .Where(path => new string(path.Select(p => _layout[p - 1]).ToArray())
                                        .Count(value => value == player) == 2).FirstOrDefault();                 
                 
                 if(winningPath != null)
                     return winningPath.FirstOrDefault(p => _layout[p - 1] == Game.EmptyValue);
  
                 return null;
             }</b>
  
             ...
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
              We’ve used this approach in another strategy, so let’s factor out the duplication:
            </p>
            
            <pre><div style="overflow:auto;background-color: #FFFFE0;border: 1px solid black;border-collapse: collapse;color: black;float: none;font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;font-size: 12px;font-style: normal;font-variant: normal;font-weight: normal;line-height: 20px;padding: 5px;text-align: left;vertical-align: baseline">
  int? PathCompletionStrategy(char player)
             {
                 int[] winningPath = <b>GetWinningPathForPlayer(player);</b>
  
                 if (winningPath != null)
                     return winningPath.FirstOrDefault(p => _layout[p - 1] == Game.EmptyValue);
                 
                 return null;
             }
  
             int? SimpleBlockStrategy(char player)
             {
                 int[] threatingPath = <b>GetWinningPathForPlayer(GetOpponentValue(player));</b>
  
                 if (threatingPath != null)
                 {
                     return threatingPath.First(position => _layout[position - 1] == Game.EmptyValue);
                 }
  
                 return null;
             }
  
             <b>int[] GetWinningPathForPlayer(char player)
             {
                 List&lt;int[]> availablePaths = GetAvailablePathsFor(player);
  
                 return availablePaths
                     .Where(path => new string(path.Select(p => _layout[p - 1]).ToArray())
                                        .Count(value => value == player) == 2).FirstOrDefault();
             }</b>
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
              I think we’re finished. As a final step, I’m going to ask the UI team if I can get an unofficial build with our new component integrated and do a little smoke testing before I close out our issues. We’ll discuss the outcome of this endeavor next time.
            </p>
