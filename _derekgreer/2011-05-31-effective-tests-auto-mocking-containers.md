---
wordpress_id: 465
title: 'Effective Tests: Auto-mocking Containers'
date: 2011-05-31T12:20:52+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=465
dsq_thread_id:
  - "318415972"
categories:
  - Uncategorized
tags:
  - Auto-mocking Containers
  - Test Doubles
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
      Effective Tests: Auto-mocking Containers
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

In the [last installment](https://lostechies.com/derekgreer/2011/05/26/effective-tests-double-strategies/), I set forth some recommendations for using Test Doubles effectively. In this article, I’ll discuss a class of tools which can aid in reducing some of the coupling and obscurity that comes with the use of Test Doubles: Auto-mocking Containers.

## Auto-mocking Containers

Executable specifications can provide valuable documentation of a system’s behavior. When written well, they can not only clearly describe what the system does, but also serve as an example for how the system is intended to be used. Unfortunately, it is this aspect of our specifications which can often end up working against our goal of writing maintainable software.

Ideally, an executable specification would describe the expected behavior of a system in such a way as to also clearly demonstrate it’s intended use without obscuring its purpose with extraneous implementation details. One class of tools which aid in achieving this goal are Auto-mocking Containers.

An _Auto-mocking Container_ is a specialized [inversion of control](http://en.wikipedia.org/wiki/Inversion_of_control) container for constructing a System Under Test with Test Doubles automatically supplied for any dependencies. By using an auto-mocking container, details such as the declaration of test double fields and test double instantiation can be removed from the specification, rendering a cleaner implementation void of such extraneous details.

Consider the following class which displays part details to a user and is responsible for retrieving the details requested form a cached copy if present:

<pre class="prettyprint">public class DisplayPartDetailsAction
    {
        readonly ICachingService _cachingService;
        readonly IPartDisplayAdaptor _partDisplayAdaptor;
        readonly IPartRepository _partRepository;

        public DisplayPartDetailsAction(
            ICachingService cachingService,
            IPartRepository partRepository,
            IPartDisplayAdaptor partDisplayAdaptor)
        {
            _cachingService = cachingService;
            _partRepository = partRepository;
            _partDisplayAdaptor = partDisplayAdaptor;
        }

        public void Display(string partId)
        {
            PartDetail details = _cachingService.RetrievePartDetails(partId) ??
                                 _partRepository.GetPartDetailByPartId(partId);

            _partDisplayAdaptor.Display(details);
        }
    }
</pre>



The specification for this behavior would need to verify that the System Under Test attempts to retrieve the PartDetail from the ICachingService, but would also need to supply implementations for the IPartRepository and IPartDisplayAdaptor as shown in the following listing:

<pre class="prettyprint">public class when_displaying_part_details
    {
        const string PartId = "12345";
        static Mock&lt;ICachingService&gt; _cachingServiceMock;
        static DisplayPartDetailsAction _subject;

        Establish context = () =>
            {
                _cachingServiceMock = new Mock&lt;ICachingService&gt;();
                var partRepositoryDummy = new Mock&lt;IPartRepository&gt;();
                var partDisplayAdaptorDummy = new Mock&lt;IPartDisplayAdaptor&gt;();
                _subject = new DisplayPartDetailsAction(_cachingServiceMock.Object, partRepositoryDummy.Object,
                                                        partDisplayAdaptorDummy.Object);
            };

        Because of = () => _subject.Display(PartId);

        It should_retrieve_the_part_information_from_the_cache =
            () => _cachingServiceMock.Verify(x => x.RetrievePartDetails(PartId), Times.Exactly(1));
    }
</pre>



By using an auto-mocking container, the specification can be written without the need of an explicit Mock field, or instantiating Dummy instances for the IPartRepository and IPartDisplayAdaptor dependencies. The following demonstrates such an example using [AutoMock](http://code.google.com/p/moq-contrib/wiki/Automocking), an auto-mocking container which leverages the Moq framework:

<pre class="prettyprint">public class when_displaying_part_details
    {
        const string PartId = "12345";
        static AutoMockContainer _container;
        static DisplayPartDetailsAction _subject;

        Establish context = () =>
            {
                _container = new AutoMockContainer(new MockFactory(MockBehavior.Loose));
                _subject = _container.Create&lt;DisplayPartDetailsAction&gt;();
            };

        Because of = () => _subject.Display(PartId);

        It should_retrieve_the_part_information_from_the_cache =
            () => _container.GetMock&lt;ICachingService&gt;().Verify(x => x.RetrievePartDetails(PartId), Times.Exactly(1));
    }
</pre>



While this implementation eliminates references to the extraneous dependencies, it does impose a bit of extraneous implementation details of its own. To further relieve this specification of implementation details associated with the auto-mocking container, a reusable base context can be extracted:

<pre class="prettyprint">public abstract class WithSubject&lt;T&gt; where T : class
    {
        protected static AutoMockContainer Container;
        protected static T Subject;

         Establish context = () =>
            {
                Container = new AutoMockContainer(new MockFactory(MockBehavior.Loose));
                Subject = Container.Create&lt;T&gt;();
            };

        protected static Mock&lt;TDouble&gt; For&lt;TDouble&gt;() where TDouble : class
        {
            return Container.GetMock&lt;TDouble&gt;();
        }
    }
</pre>



By extending the auto-mocking base context, the specification can be written more concisely:

<pre class="prettyprint">public class when_displaying_part_details : WithSubject&lt;DisplayPartDetailsAction&gt;
    {
        const string PartId = "12345";

        Because of = () => Subject.Display(PartId);

        It should_retrieve_the_part_information_from_the_cache =
            () => For&lt;ICachingService&gt;().Verify(x => x.RetrievePartDetails(PartId), Times.Exactly(1));
    }
</pre>



Another advantage gained by the use of auto-mocking containers is decoupling. By inverting the concern of how the System Under Test is constructed, dependencies can be added, modified, or deleted without affecting specifications for which the dependency has no bearing.

## Trade-offs

While auto-mocking containers can make specifications cleaner, easier to write, and more adaptable to change, their use can come at a slight cost. By using mocking frameworks and hand-rolled doubles directly, there is always at least one point of reference where the requirements of instantiating the System Under Test provides feedback about its design as a whole.

Use of auto-mocking containers allows us to produce contextual slices of how the system works, limiting the information about the system’s dependencies to that knowledge required by the context in question. From a documentation perspective, this can aid in understanding how the system is used to facilitate a particular feature. From a design perspective, however, their use can eliminate one source of feedback about the evolving design of the system. Without such inversion of control, hints of violating the Single Responsibility Principle can be seen within the specifications, evidenced by overly complex constructor initialization. By removing the explicit declaration of the system’s dependencies from the specifications, we also remove this point of feedback.

That said, the benefits of leveraging auto-mocking containers tend to outweigh the cost of removing this point of feedback. Cases of mutually-exclusive dependencies are usually in the minority and each addition and/or modification to a constructor provides an equal level of feedback about a class&#8217;s potential complexity.

## Conclusion

In this article, we looked at the use of auto-mocking containers as a tool for reducing obscurity and coupling within our specifications. Next time, we’ll look at a technique for reducing the obscurity that comes from overly complex assertions.
