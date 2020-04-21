---
wordpress_id: 318
title: 'Effective Tests: A Test-First Example &#8211; Part 6'
date: 2011-05-12T17:17:24+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=318
dsq_thread_id:
  - "302067250"
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
  border-bottom: black 1px solid;
  text-align: left;
  border-left: black 1px solid;
  padding-bottom: 5px;
  background-color: #ffffe0;
  padding-left: 5px;
  padding-right: 5px;
  border-collapse: collapse;
  font: 12px/20px consolas, 'Bitstream Vera Sans Mono', 'Courier New', courier, monospace;
  float: none;
  color: black;
  vertical-align: baseline;
  border-top: black 1px solid;
  border-right: black 1px solid;
  padding-top: 5px;
}
div.test-fail
{
  background-color: #FFFFF;
  border: 1px solid black;
  border-collapse: collapse;
  color: black;
  float: none;
  font-family: Consolas, 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace;
  font-size: 12px;
  font-style: normal;
  font-variant: normal;
  font-weight: normal;
  line-height: 20px;
  padding: 5px;
  text-align: left;
  vertical-align: baseline;
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
      <a href="/derekgreer/2011/04/11/effective-tests-a-test-first-example-part-3/">Effective Tests: A Test-First Example – Part 3</a>
    </li>
    <li>
      <a href="/derekgreer/2011/04/24/effective-tests-a-test-first-example-part-4/">Effective Tests: A Test-First Example – Part 4</a>
    </li>
    <li>
      <a href="/derekgreer/2011/05/01/effective-tests-a-test-first-example-part-5/">Effective Tests: A Test-First Example – Part 5</a>
    </li>
    <li>
      Effective Tests: A Test-First Example – Part 6
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

In [part 5](https://lostechies.com/derekgreer/2011/05/01/effective-tests-a-test-first-example-part-5/) of our Test-First example, we continued by addressing issues filed by the QA team. While I thought we had covered the reported defects pretty well, I wanted to do a little smoke testing against the full application to ensure we hadn’t missed anything. It’s probably good that I did, because I ended up finding one last case that didn’t met the original requirements.

In the course of my testing, I discovered that there was an additional way for a player to beat the game by setting up multiple winning paths. Here’s the steps I took:

[<img style="background-image: none; border-bottom: 0px; border-left: 0px; padding-left: 0px; padding-right: 0px; display: inline; border-top: 0px; border-right: 0px; padding-top: 0px" title="tic-tac-toe-ms" border="0" alt="tic-tac-toe-ms" src="https://lostechies.com/content/derekgreer/uploads/2011/05/tic-tac-toe-ms_thumb2.png" width="605" height="110" />](https://lostechies.com/content/derekgreer/uploads/2011/05/tic-tac-toe-ms2.png)

In the depicted steps, my first move was to choose the right edge of the board. This happens to be a strategy the articles I consulted with advised against and for which no counter strategy was provided. By choosing a second position which avoided triggering the game&#8217;s existing defensive strategies, I was able to set up multiple winning paths by countering the next two choices by the game. The game should be able to counter this strategy by blocking at intersections, so let&#8217;s fix this one last issue.

First, let&#8217;s start with a new test which describes the behavior we want:

<pre class="code">
[TestClass]
public class When_the_player_has_two_paths_which_intersect_at_an_available_position
{
  [TestMethod]
  public void it_should_select_the_intersecting_position()
  {
  }
}
</pre>

Next, let’s setup the context and assertion that reflects the way I was able to beat the game:

<pre class="code">
[TestClass]
public class When_the_player_has_two_paths_which_intersect_at_an_available_position
{
  [TestMethod]
  public void it_should_select_the_intersecting_position()
  {
    GameAdvisor gameAdvisor = new GameAdvisor();
    var selection = gameAdvisor.WithLayout("OXO\0\0XX\0\0").SelectBestMoveForPlayer('O');
    Assert.AreEqual(8, selection);
  }
}
</pre>

Now, let’s run our test suite:

<div style="background: red">
  &nbsp;
</div>
<div class="test-fail">
  When_the_player_has_two_paths_which_intersect_at_an_available_position
  Failed	it_should_select_the_intersecting_position
  Assert.AreEqual failed. Expected:&lt;8&gt;. Actual:&lt;9&gt;.
</div>

<p></p>

Let’s get this to pass quickly by returning the expected position for this exact layout:

<pre class="code">
class PositionSelector : IPositionSelector
{
  …

    public int SelectBestMoveForPlayer(char player)
    {
      <span class="highlight">if (_layout == "OXO\0\0XX\0\0")</span>
        <span class="highlight">return 8;</span>

        return GetPositionThreateningPlayer(player) ??
        GetNextWinningMoveForPlayer(player) ??
        Enumerable.Range(1, 9).First(position =&gt; _layout[position - 1] == Game.EmptyValue);
    }

  ...
}
</pre>

<p></p>

<div style="background: #3c0">
  &nbsp;
</div>

To remove the duplication of the layout, let’s start taking small steps toward a final solution. First, let’s create a new DefensiveStrategy for dealing with positions that might allow the opponent to set up multiple winning paths:

<pre class="code">
class PositionSelector : IPositionSelector
{
  …

    int? GetPositionThreateningPlayer(char player)
    {
      return new DefensiveStrategy[]
      {
        PathCompletionStrategy,
          SimpleBlockStrategy,
          FirstMoveCounterCenterStrategy,
          SecondMoveDiagonalCounterStrategy,
          <span class="highlight">MultiPathCounterStrategy</span>
      }
      .Select(strategy =&gt; strategy(player)).FirstOrDefault(p =&gt; p.HasValue);
    }

  <span class="highlight">int? MultiPathCounterStrategy(char player)</span>
    <span class="highlight">{</span>
      <span class="highlight">if (_layout == "OXO\0\0XX\0\0")</span>
        <span class="highlight">return 8;</span>

        <span class="highlight">return null;</span>
        <span class="highlight">}</span>


        ...
}
</pre>

Next, let’s work through the steps we’ll need to arrive at this value. First, we’ll need to get a list of all the available paths for the opponent:

<pre class="code">
int? MultiPathCounterStrategy(char player)
{

  <span class="highlight">char opponentValue = GetOpponentValue(player);</span>

    <span class="highlight">List&lt;int[]&gt; opponentPaths = GetAvailablePathsFor(opponentValue);</span>

    if (_layout == "OXO\0\0XX\0\0")
      return 8;

  return null;
}
</pre>

Next, we want to filter this list down to the paths the opponent has already started:

<pre class="code">
int? MultiPathCounterStrategy(char player)
{

  char opponentValue = GetOpponentValue(player);

  List&lt;int[]&gt; opponentPaths = GetAvailablePathsFor(opponentValue);
  
  <span class="highlight">IEnumerable&lt;int  []> startedPaths =</span>
    <span class="highlight">opponentPaths.Where(path =&gt; new string(path.Select(p =&gt; _layout[p - 1]).ToArray())</span>
        <span class="highlight">.Count(value =&gt; value == opponentValue) &gt;= 1);</span>

    if (_layout == "OXO\0\0XX\0\0")
      return 8;

  return null;
}
</pre>

Lastly, we need to compare all the paths to each other, find the ones that have positions in common, and pick the position in common for the first pair. Since we’ll be calling this after our other strategy for dealing with multiple winning paths as the result of the opponent choosing opposite corners, this should only ever find one pair. This logic seems a little more complicated, so I’m going to write it in LINQ rather than using extension methods this time:

<pre class="code">
int? MultiPathCounterStrategy(char player)
{

  char opponentValue = GetOpponentValue(player);

  List&lt;int[]&gt; opponentPaths = GetAvailablePathsFor(opponentValue);

  IEnumerable&lt;int  []> startedPaths =
    opponentPaths.Where(path =&gt; new string(path.Select(p =&gt; _layout[p - 1]).ToArray())
        .Count(value =&gt; value == opponentValue) &gt;= 1);

  <span class="highlight">return (from path in startedPaths</span>
      <span class="highlight">from position in path</span>
      <span class="highlight">from otherPath in startedPaths.SkipWhile(otherPath =&gt; otherPath == path)</span>
      <span class="highlight">from otherPosition in otherPath</span>
      <span class="highlight">where otherPosition == position</span>
      <span class="highlight">where _layout[position - 1] == Game.EmptyValue</span>
      <span class="highlight">select new int?(position)).FirstOrDefault();</span>
}
</pre>

Let’s run the tests again and see what happens:

<p></p>

<div style="background: #3c0">
  &nbsp;
</div>

It passes! We can now release the new version of our component to be integrated into the next build.

## Conclusion

We’ve finally come to the conclusion of our Test-First example. Along the way, we followed the Test-Driven Development practice of writing a failing test first, making the test pass as quickly as possible, and refactoring to remove duplication and to clarify intent. When we wrote a failing test, we made sure each test was properly verifying the expected results before attempting to add new behavior to the system. To get our tests passing quickly, we used obvious implementations when we were confident about our approach and felt we could achieve it quickly, but used fake implementations when we weren’t as confident or felt the implementation might take some time. When we wrote a new test to capture new requirements that were already present in the system, we temporarily disabled the behavior of the system to ensure our tests were validating the expected behavior correctly. Throughout our effort, we weren’t afraid to take small steps and strove to do simple things.

While we made some mistakes along the way and discovered opportunities for further improvement, using the Test Driven Development approach aided in our ability to produce working, maintainable software that matters.

Next time, we’ll discuss concepts and strategies for writing tests for collaborating components.
