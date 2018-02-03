---
wordpress_id: 416
title: 'Capturing Rhino Mocks arguments in C# 4.0'
date: 2010-06-09T18:20:30+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/06/09/capturing-rhino-mocks-arguments-in-c-4-0.aspx
dsq_thread_id:
  - "264716497"
dsq_needs_sync:
  - "1"
categories:
  - 'C#'
  - TDD
---
As a quick review, a [test fixture](http://xunitpatterns.com/test%20fixture%20-%20xUnit.html) has inputs and outputs.&#160; We set up our test fixture by configuring inputs.&#160; We observe the results through the fixture’s outputs.

Inputs and outputs can be grouped into direct and indirect variants.&#160; Direct inputs include:

  * Constructor arguments 
  * Method arguments 
  * Property/field values 

[Indirect inputs](http://xunitpatterns.com/indirect%20input.html) are things we can’t directly set on our fixture.&#160; An example would be a ShippingCalculatorService, that returns a shipping cost.&#160; An order processor might use this service to calculate the full cost of an order.&#160; However, we don’t directly set this shipping cost through the direct use of our order processor.&#160; Instead, the shipping cost is an indirect input to our method through this shipping calculator.

On the other side of the coin are direct outputs, which include:

  * Return values 
  * Mutated inputs 
  * Mutated fixture 

Often, we just look at the return value of a method for the direct output.&#160; But we might also look at one of the inputs, which might have mutated as the result of an operation.&#160; We also have [indirect outputs](http://xunitpatterns.com/indirect%20output.html), which again are services whose methods are void.

If we properly follow Command-Query Separation, we can group our Rhino Mock usage into only two buckets:

  * Stubbing indirect inputs 
  * Capturing indirect outputs 

The first case is easy.&#160; The second one can get ugly, as it requires the use of rather funky looking call.&#160; Let’s say we have an order processor that reserves shipping spots through a service:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IShippingReservationService
</span>{
    <span style="color: blue">void </span>Reserve(<span style="color: blue">int </span>orderId, <span style="color: blue">decimal </span>totalWeight);
}</pre>

[](http://11011.net/software/vspaste)

If we want to capture ALL arguments made and want to assert things, we must do something like:

<pre><span style="color: #2b91af">IList</span>&lt;<span style="color: blue">object</span>[]&gt; argsMade = shipper.GetArgumentsForCallsMadeOn(
    s =&gt; s.Reserve(0, 0m), 
    opt =&gt; opt.IgnoreArguments());

argsMade[0][0].ShouldEqual(batch1.Id);</pre>

[](http://11011.net/software/vspaste)

Not too pretty.&#160; I have to make sure I use the “IgnoreArguments” configuration option, so that I get all calls.&#160; Next, I get an IList<object[]>, which is basically a jagged array of objects.&#160; Everything is an object, so I have to cast if I want to do any special assertions.

But if we’re in C# 4.0, we can do better.

### Capturing one argument-methods

I’d really like to capture all the arguments made as a single list of items. First, let’s look at the simple case where I have an indirect output with only ONE argument:

<pre><span style="color: blue">public interface </span><span style="color: #2b91af">IOrderProcessor
</span>{
    <span style="color: blue">void </span>Process(<span style="color: #2b91af">OrderBatch </span>batch);
}</pre>

[](http://11011.net/software/vspaste)

In that case, I only want to capture the arguments made as a list of OrderBatch.&#160; No real need to wrap that with anything else at this point.&#160; To do this, I first set up my objects as I normally would with Rhino Mocks:

<pre><span style="color: blue">var </span>processor = Stub&lt;<span style="color: #2b91af">IOrderProcessor</span>&gt;();
<span style="color: blue">var </span>shipper = Stub&lt;<span style="color: #2b91af">IShippingReservationService</span>&gt;();

<span style="color: blue">var </span>batchProcessor = <span style="color: blue">new </span><span style="color: #2b91af">OrderBatchProcessor</span>(processor, shipper);</pre>

[](http://11011.net/software/vspaste)

The Stub method merely wraps MockRepository.GenerateStub().&#160; From here, I want to then capture the arguments made.&#160; In previous versions, I would do this by passing in a closure for the Do() method of Rhino Mocks.&#160; I can extend this to a general case:

<pre><span style="color: #2b91af">IList</span>&lt;<span style="color: #2b91af">OrderBatch</span>&gt; args = processor
    .Capture()
    .Args&lt;<span style="color: #2b91af">OrderBatch</span>&gt;((p, batch) =&gt; p.Process(batch));

batchProcessor.ProcessBatches(<span style="color: blue">new</span>[]
{
    batch1, batch2, batch3
});

args.Count().ShouldEqual(3);
args.First().ShouldEqual(batch2);</pre>

[](http://11011.net/software/vspaste)

I capture the arguments made as a list of OrderBatch, then call the ProcessBatches as normal.&#160; I have some logic where express batches are processed first, which is why I assert that “batch2” came first.

The CaptureMethod is an extension method that begins a chain for me to start capturing arguments:

<pre><span style="color: blue">public static class </span><span style="color: #2b91af">MockExtensions
</span>{
    <span style="color: blue">public static </span><span style="color: #2b91af">CaptureExpression</span>&lt;T&gt; Capture&lt;T&gt;(<span style="color: blue">this </span>T stub) 
        <span style="color: blue">where </span>T : <span style="color: blue">class
    </span>{
        <span style="color: blue">return new </span><span style="color: #2b91af">CaptureExpression</span>&lt;T&gt;(stub);
    }
}</pre>

[](http://11011.net/software/vspaste)

I have to return a CaptureExpression<T> as a trick so that I don’t have to specify the stub’s type in my test.&#160; My CaptureExpression<T> then lets me capture the args:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CaptureExpression</span>&lt;T&gt;
    <span style="color: blue">where </span>T : <span style="color: blue">class
</span>{
    <span style="color: blue">private readonly </span>T _stub;

    <span style="color: blue">public </span>CaptureExpression(T stub)
    {
        _stub = stub;
    }

    <span style="color: blue">public </span><span style="color: #2b91af">IList</span>&lt;U&gt; Args&lt;U&gt;(<span style="color: #2b91af">Action</span>&lt;T, U&gt; methodExpression)
    {
        <span style="color: blue">var </span>argsCaptured = <span style="color: blue">new </span><span style="color: #2b91af">List</span>&lt;U&gt;();

        <span style="color: #2b91af">Action</span>&lt;U&gt; captureArg = argsCaptured.Add;
        <span style="color: #2b91af">Action</span>&lt;T&gt; stubArg = stub =&gt; methodExpression(stub, <span style="color: blue">default</span>(U));

        _stub.Stub(stubArg).IgnoreArguments().Do(captureArg);

        <span style="color: blue">return </span>argsCaptured;
    }</pre>

[](http://11011.net/software/vspaste)[](http://11011.net/software/vspaste)

In the Args method, I accept an expression detailing the method I want to call.&#160; I create a list of the arguments, which is where I’ll stash them as they come in.&#160; In the next couple of lines, I build the delegates that Rhino Mocks uses to both stub a method, and provide a stand-in callback.

Finally, I use the Stub() and Do() methods from Rhino Mocks to provide a replacement closure for calling the original method.&#160; When the stubbed method is called, Rhino Mocks passes control to my CaptureArg method.&#160; This method is a closure that adds the method argument to the “argsCaptured” list.

Initially, the list returned is empty.&#160; But as the stub is used in the fixture, this list will be populated with the items used.

That’s the easy case of a single argument, let’s look at multiple arguments.

### Capturing multiple arguments with tuples

I’d also like group the arguments made from each call into a single object, instead of just an array that I have to then poke around in.&#160; In earlier versions of C#, I would need to craft an object to hold these values.&#160; In C# 4.0, I have the [Tuple classes](http://msdn.microsoft.com/en-us/magazine/dd942829.aspx).

I’ll follow the same pattern here as the method above, except this time use the Tuple class to group the method arguments together:

<pre><span style="color: blue">public </span><span style="color: #2b91af">IList</span>&lt;<span style="color: #2b91af">Tuple</span>&lt;U1, U2&gt;&gt; Args&lt;U1, U2&gt;(<span style="color: #2b91af">Action</span>&lt;T, U1, U2&gt; methodExpression)
{
    <span style="color: blue">var </span>argsCaptured = <span style="color: blue">new </span><span style="color: #2b91af">List</span>&lt;<span style="color: #2b91af">Tuple</span>&lt;U1, U2&gt;&gt;();

    <span style="color: #2b91af">Action</span>&lt;U1, U2&gt; captureArg = (u1, u2) =&gt; argsCaptured.Add(<span style="color: #2b91af">Tuple</span>.Create(u1, u2));
    <span style="color: #2b91af">Action</span>&lt;T&gt; stubArg = stub =&gt; methodExpression(stub, <span style="color: blue">default</span>(U1), <span style="color: blue">default</span>(U2));

    _stub.Stub(stubArg).IgnoreArguments().Do(captureArg);

    <span style="color: blue">return </span>argsCaptured;
}</pre>

[](http://11011.net/software/vspaste)

I return a Tuple<U1, U2>, which are the types of the method parameters of the stubbed method, but now just grouped together in a strongly-typed bucket.&#160; I can now create strongly-typed assertions about my indirect outputs:

<pre><span style="color: blue">var </span>processor = Stub&lt;<span style="color: #2b91af">IOrderProcessor</span>&gt;();
<span style="color: blue">var </span>shipper = Stub&lt;<span style="color: #2b91af">IShippingReservationService</span>&gt;();

<span style="color: blue">var </span>args = shipper
    .Capture()
    .Args&lt;<span style="color: blue">int</span>, <span style="color: blue">decimal</span>&gt;((s, orderId, weight) =&gt; s.Reserve(orderId, weight));

<span style="color: blue">var </span>batchProcessor = <span style="color: blue">new </span><span style="color: #2b91af">OrderBatchProcessor</span>(processor, shipper);

batchProcessor.ProcessBatches(<span style="color: blue">new</span>[]
{
    batch1, batch2
});

args.Count.ShouldEqual(2);
args[0].Item1.ShouldEqual(batch1.Id);
args[0].Item2.ShouldEqual(batch1.TotalWeight);
args[1].Item1.ShouldEqual(batch2.Id);
args[1].Item2.ShouldEqual(batch2.TotalWeight);</pre>

[](http://11011.net/software/vspaste)

Additionally, because I don’t have to guess at the number of arguments made, the Tuple returned is linked to the number of arguments to the stubbed method.&#160; This provides a much stronger link between the arguments I capture and the method being stubbed.

From here, it’s trivial to extend this approach to as many arguments as I need.&#160; And as long as I stick to CQS, and my methods either do something or answer a question, these are the only mocking requirements I’ll need.&#160; As always, you can find this example on my [github](http://github.com/jbogard/blogexamples).