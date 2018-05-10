---
wordpress_id: 478
title: 'Effective Tests: Custom Assertions'
date: 2011-06-11T15:35:55+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/2011/06/11/effective-tests-custom-assertions/
dsq_thread_id:
  - "328796779"
categories:
  - Uncategorized
tags:
  - Custom Assertions
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
      Effective Tests: Custom Assertions
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

In our [last installment](https://lostechies.com/derekgreer/2011/05/31/effective-tests-auto-mocking-containers/), we took a look at using Auto-mocking Containers as a way of reducing coupling and obscurity within our tests. This time, we’ll take a look at another technique which aids in preventing obscurity caused by complex assertions: Custom Assertions.

## Custom Assertions

As discussed earlier in the series, executable specifications are a model for our requirements. Whether serving as a guide for our implementation or as documentation for existing behavior, specifications should be easy to understand. Assertion implementation is one of the areas that can often begin to obscure the intent of our specifications. When standard assertions fall short of expressing what is being validated clearly and concisely, they can be replaced with _Custom Assertions_. Custom assertions are domain-specific assertions which encapsulate complex or obscure testing logic within intention-revealing methods.

Consider the following example which validates that the items returned from a ReviewService class are sorted in descending order:

<pre class="prettyprint">public class when_a_customer_retrieves_comment_history : WithSubject&lt;ReviewService&gt;
  {
      const string ItemId = "123";
      static IEnumerable&lt;Comment&gt; _comments;

      Establish context = () =&gt; For&lt;IItemRepository&gt;()
                                    .Setup(x =&gt; x.Get(ItemId))
                                    .Returns(new Item(new[]
                                                          {
                                                              new Comment("comment 1", DateTime.MinValue.AddDays(1)),
                                                              new Comment("comment 2", DateTime.MinValue.AddDays(2)),
                                                              new Comment("comment 3", DateTime.MinValue.AddDays(3))
                                                          }));

      Because of = () =&gt; _comments = Subject.GetCommentsForItem(ItemId);
    
      It should_return_comments_sorted_by_date_in_descending_order = () =&gt;
          {
              Comment[] commentsArray = _comments.ToArray();
              for (int i = commentsArray.Length - 1; i &gt; 0; i--)
              {
                  if (commentsArray[i].TimeStamp &gt; commentsArray[i - 1].TimeStamp)
                  {
                      throw new Exception(
                          string.Format(
                              "Expected comments sorted in descending order, but found comment \'{0}\' on {1} after \'{2}\' on {3}",
                              commentsArray[i].Text, commentsArray[i].TimeStamp, commentsArray[i - 1].Text,
                              commentsArray[i - 1].TimeStamp));
                  }
              }
          };
  }</pre>

&#160;

While the identifiers used to describe the specification are clear, the observation’s implementation contains a significant amount of verification logic which makes the specification more difficult to read. By moving the verification logic into a custom assertion which describes what is expected, we can clarify the specification&#8217;s intent.

When developing on the .Net platform, [Extension Methods](http://en.wikipedia.org/wiki/Extension_method) provide a nice way of encapsulating assertion logic while achieving an expressive API. The following listing shows the same assertion logic contained within an extension method:

<pre class="prettyprint">public static class CustomAssertions
  {
      public static void ShouldBeSortedByDateInDescendingOrder(this IEnumerable&lt;Comment&gt; comments)
      {
          Comment[] commentsArray = comments.ToArray();
          for (int i = commentsArray.Length - 1; i &gt; 0; i--)
          {
              if (commentsArray[i].TimeStamp &gt; commentsArray[i - 1].TimeStamp)
              {
                  throw new Exception(
                      string.Format(
                          "Expected comments sorted in descending order, but found comment \'{0}\' on {1} after \'{2}\' on {3}",
                          commentsArray[i].Text, commentsArray[i].TimeStamp, commentsArray[i - 1].Text,
                          commentsArray[i - 1].TimeStamp));
              }
          }
      }
  }</pre>

&#160;

Using this new custom assertion, the specification can be rewritten to be more intention-revealing:

<pre class="prettyprint">public class when_a_customer_retrieves_comment_history : WithSubject&lt;ReviewService&gt;
  {
      const string ItemId = "123";
      static IEnumerable&lt;Comment&gt; _comments;

      Establish context = () =&gt; For&lt;IItemRepository&gt;()
                                    .Setup(x =&gt; x.Get(ItemId))
                                    .Returns(new Item(new[]
                                                          {
                                                              new Comment("comment 1", DateTime.MinValue.AddDays(1)),
                                                              new Comment("comment 2", DateTime.MinValue.AddDays(2)),
                                                              new Comment("comment 3", DateTime.MinValue.AddDays(3))
                                                          }));

      Because of = () =&gt; _comments = Subject.GetCommentsForItem(ItemId);

      It should_return_comments_sorted_by_date_in_descending_order = () =&gt; _comments.ShouldBeSortedByDateInDescendingOrder();
  }</pre>

## Verifying Assertion Logic

Another advantage of factoring out complex assertion logic into custom assertion methods is the ability to verify that the logic actually works as expected. This can be particularly valuable if the assertion logic is reused by many specifications.

The following listing shows positive and negative tests for our custom assertion:

<pre class="prettyprint">public class when_asserting_unsorted_comments_are_sorted_in_descending_order
  {
      static Exception _exception;
      static List&lt;Comment&gt; _unsortedComments;

      Establish context = () =&gt;
          {
              _unsortedComments = new List&lt;Comment&gt;
                                      {
                                          new Comment("comment 1", DateTime.MinValue.AddDays(1)),
                                          new Comment("comment 4", DateTime.MinValue.AddDays(4)),
                                          new Comment("comment 3", DateTime.MinValue.AddDays(3)),
                                          new Comment("comment 2", DateTime.MinValue.AddDays(2))
                                      };
          };

      Because of = () =&gt; _exception = Catch.Exception(() =&gt; _unsortedComments.ShouldBeSortedByDateInDescendingOrder());

      It should_throw_an_exception = () =&gt; _exception.ShouldBeOfType(typeof(Exception));
  }

  public class when_asserting_sorted_comments_are_sorted_in_descending_order
  {
      static Exception _exception;
      static List&lt;Comment&gt; _unsortedComments;

      Establish context = () =&gt;
      {
          _unsortedComments = new List&lt;Comment&gt;
                                      {
                                          new Comment("comment 4", DateTime.MinValue.AddDays(4)),
                                          new Comment("comment 3", DateTime.MinValue.AddDays(3)),
                                          new Comment("comment 2", DateTime.MinValue.AddDays(2)),
                                          new Comment("comment 1", DateTime.MinValue.AddDays(1))
                                      };
      };

      Because of = () =&gt; _exception = Catch.Exception(() =&gt; _unsortedComments.ShouldBeSortedByDateInDescendingOrder());

      It should_not_throw_an_exception = () =&gt; _exception.ShouldBeNull();
  }</pre>

## Conclusion

This time, we examined a simple strategy for clarifying the intent of our specifications involving the movement of complex verification logic into custom assertions methods. Next time we’ll take a look at another strategy for clarifying the intent of our specifications which also serves to reduce test code duplication and test-specific code within production.
