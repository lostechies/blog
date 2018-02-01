---
id: 39
title: 'Closures in C#: Variable Scoping and Value Types vs Reference Types'
date: 2009-02-23T19:10:39+00:00
author: Derick Bailey
layout: post
guid: /blogs/derickbailey/archive/2009/02/23/closures-in-c-variable-scoping-and-value-types-vs-reference-types.aspx
dsq_thread_id:
  - "262068090"
categories:
  - .NET
  - 'C#'
  - Lambda Expressions
  - Principles and Patterns
---
I read Sergio’s post on “<a href="http://devlicio.us/blogs/sergio_pereira/archive/2009/02/23/javascript-time-to-grok-closures.aspx" target="_blank">Javascript, time to grok closures</a>” today and it was very enlightening. Overall, it helped me to understand <a href="http://en.wikipedia.org/wiki/Closure_(computer_science)" target="_blank">closures</a> more than I previously had – not just in Javascript, though. I put together a quick sample on closures in C# to illustrate the same behavior that Sergio is talking about in the ‘Closures can be tricky’ section of his post. I’m happy to see C# is behaving the same way as Javascript, in the case of ‘value’ types in closures. This probably isn’t new to anyone that understands closures already. It’s new to me, though, and seems to be a fairly important concept to understand when using anonymous methods (lambda expression or otherwise) and closures.

### **Illustrating The Closure Scope For Value Types**

Here is the sample code I put together, in unit test form, to illustrate the same behavior that Sergio is pointing out.

<div>
  <div>
    <pre>[TestFixture]</pre>
    
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> When_referencing_a_value_type_variable_from_the_parent_scope_directly_in_a_closure : ContextSpecification</pre>
    
    <pre>{</pre>
    
    <pre>   <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IList&lt;Func&lt;<span style="color: #0000ff">int</span>&gt;&gt; theActions = <span style="color: #0000ff">new</span> List&lt;Func&lt;<span style="color: #0000ff">int</span>&gt;&gt;();</pre>
    
    <pre>&#160;</pre>
    
    <pre>   <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Context()</pre>
    
    <pre>   {</pre>
    
    <pre>       <span style="color: #0000ff">for</span> (<span style="color: #0000ff">int</span> i = 0; i &lt;= 3; i++)</pre>
    
    <pre>       {</pre>
    
    <pre>           Func&lt;<span style="color: #0000ff">int</span>&gt; foo = (() =&gt; { <span style="color: #0000ff">return</span> i; });</pre>
    
    <pre>           theActions.Add(foo);</pre>
    
    <pre>       }</pre>
    
    <pre>   }</pre>
    
    <pre>&#160;</pre>
    
    <pre>   [Test]</pre>
    
    <pre>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Should_reference_the_original_value_in_the_parent_scope()</pre>
    
    <pre>   {</pre>
    
    <pre>       <span style="color: #008000">//since the value of "i" in the original scope is now 4 (having gone through all of the loop's iterations)</span></pre>
    
    <pre>       <span style="color: #008000">//every value in the execution of the "foo" anonymous function will be 4</span></pre>
    
    <pre>&#160;</pre>
    
    <pre>       <span style="color: #0000ff">int</span> expectedValue = 4;</pre>
    
    <pre>       </pre>
    
    <pre>       <span style="color: #0000ff">int</span> value0 = theActions[0]();</pre>
    
    <pre>       Assert.AreEqual(expectedValue, value0);</pre>
    
    <pre>&#160;</pre>
    
    <pre>       <span style="color: #0000ff">int</span> value1 = theActions[1]();</pre>
    
    <pre>       Assert.AreEqual(expectedValue, value1);</pre>
    
    <pre>&#160;</pre>
    
    <pre>       <span style="color: #0000ff">int</span> value2 = theActions[2]();</pre>
    
    <pre>       Assert.AreEqual(expectedValue, value2);</pre>
    
    <pre>&#160;</pre>
    
    <pre>       <span style="color: #0000ff">int</span> value3 = theActions[3]();</pre>
    
    <pre>       Assert.AreEqual(expectedValue, value3);</pre>
    
    <pre>   }</pre>
    
    <pre>&#160;</pre>
    
    <pre>}</pre>
    
    <pre>&#160;</pre>
    
    <pre>[TestFixture]</pre>
    
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> When_passing_a_value_type_variable_from_the_parent_scope_to_a_method_called_by_a_closure : ContextSpecification</pre>
    
    <pre>{</pre>
    
    <pre>   <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IList&lt;Func&lt;<span style="color: #0000ff">int</span>&gt;&gt; theActions = <span style="color: #0000ff">new</span> List&lt;Func&lt;<span style="color: #0000ff">int</span>&gt;&gt;();</pre>
    
    <pre>&#160;</pre>
    
    <pre>   <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> dooFoo(<span style="color: #0000ff">int</span> <span style="color: #0000ff">value</span>)</pre>
    
    <pre>   {</pre>
    
    <pre>       Func&lt;<span style="color: #0000ff">int</span>&gt; foo = (() =&gt; { <span style="color: #0000ff">return</span> <span style="color: #0000ff">value</span>; });</pre>
    
    <pre>       theActions.Add(foo);</pre>
    
    <pre>   }</pre>
    
    <pre>&#160;</pre>
    
    <pre>   <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Context()</pre>
    
    <pre>   {</pre>
    
    <pre>       <span style="color: #0000ff">for</span> (<span style="color: #0000ff">int</span> i = 0; i &lt;= 3; i++)</pre>
    
    <pre>       {</pre>
    
    <pre>           dooFoo(i);</pre>
    
    <pre>       }</pre>
    
    <pre>   }</pre>
    
    <pre>&#160;</pre>
    
    <pre>   [Test]</pre>
    
    <pre>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Should_create_a_copy_of_the_variable_and_retain_the_original_value()</pre>
    
    <pre>   {</pre>
    
    <pre>       <span style="color: #008000">//since we called a method, passing "i" from the original context into that method,</span></pre>
    
    <pre>       <span style="color: #008000">//the copied value was sent to the "foo" anonymous function, meaning that we got all</span></pre>
    
    <pre>       <span style="color: #008000">//of the numbers - 0, 1, 2, and 3 - in the anonymous "foo" functions.</span></pre>
    
    <pre>       </pre>
    
    <pre>       <span style="color: #0000ff">int</span> expectedValue = 0;</pre>
    
    <pre>       <span style="color: #0000ff">int</span> value0 = theActions[0]();</pre>
    
    <pre>       Assert.AreEqual(expectedValue, value0);</pre>
    
    <pre>&#160;</pre>
    
    <pre>       expectedValue = 1;</pre>
    
    <pre>       <span style="color: #0000ff">int</span> value1 = theActions[1]();</pre>
    
    <pre>       Assert.AreEqual(expectedValue, value1);</pre>
    
    <pre>&#160;</pre>
    
    <pre>       expectedValue = 2;</pre>
    
    <pre>       <span style="color: #0000ff">int</span> value2 = theActions[2]();</pre>
    
    <pre>       Assert.AreEqual(expectedValue, value2);</pre>
    
    <pre>&#160;</pre>
    
    <pre>       expectedValue = 3;</pre>
    
    <pre>       <span style="color: #0000ff">int</span> value3 = theActions[3]();</pre>
    
    <pre>       Assert.AreEqual(expectedValue, value3);</pre>
    
    <pre>   }</pre>
    
    <pre>&#160;</pre>
    
    <pre>}</pre></p>
  </div>
</div>

### **Illustrating The Closure Scope For Reference Types**

It gets a little more interesting when dealing with reference types. The same basic statements can be made for reference types, but we have to remember that we’re now dealing with what are essentially pointers, not values. So, when a reference type variable gets copied, it still points to the same object on the heap. Thus, when dealing with reference types in closures, the scope of the variable that creates the reference type suddenly becomes much more important. 

To illustrate the important of variable scope when dealing with closures, I’ve created some examples that scope a small reference type (class) in a few different ways. I’ll use this class definition as the reference type in all three examples.

<div>
  <div>
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> SomeClass</pre>
    
    <pre>{</pre>
    
    <pre>}</pre></p>
  </div>
</div>

#### **Closure Of A Reference In Parent Scope**

<div>
  <div>
    <pre>[TestFixture]</pre>
    
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> When_creating_a_closure_for_a_reference_that_is_part_of_the_parent_scope : ContextSpecification</pre>
    
    <pre>{</pre>
    
    <pre>&#160;</pre>
    
    <pre>   SomeClass someClass;</pre>
    
    <pre>&#160;</pre>
    
    <pre>   <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IList&lt;SomeClass&gt; theValues = <span style="color: #0000ff">new</span> List&lt;SomeClass&gt;();</pre>
    
    <pre>   <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IList&lt;Func&lt;SomeClass&gt;&gt; theClosureValues = <span style="color: #0000ff">new</span> List&lt;Func&lt;SomeClass&gt;&gt;();</pre>
    
    <pre>&#160;</pre>
    
    <pre>   <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Context()</pre>
    
    <pre>   {</pre>
    
    <pre>       <span style="color: #0000ff">for</span> (<span style="color: #0000ff">int</span> i = 0; i &lt;= 3; i++)</pre>
    
    <pre>       {</pre>
    
    <pre>           someClass = <span style="color: #0000ff">new</span> SomeClass();</pre>
    
    <pre>           theValues.Add(someClass);</pre>
    
    <pre>           Func&lt;SomeClass&gt; foo = (() =&gt; { <span style="color: #0000ff">return</span> someClass; });</pre>
    
    <pre>           theClosureValues.Add(foo);</pre>
    
    <pre>       }</pre>
    
    <pre>   }</pre>
    
    <pre>&#160;</pre>
    
    <pre>   [Test]</pre>
    
    <pre>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Then_all_closures_should_reference_the_last_instance_of_the_variable_from_the_parent_scope()</pre>
    
    <pre>   {</pre>
    
    <pre>       SomeClass expectedValue0 = theValues[0];</pre>
    
    <pre>       SomeClass value0 = theClosureValues[0]();</pre>
    
    <pre>       Assert.AreNotSame(expectedValue0, value0);</pre>
    
    <pre>&#160;</pre>
    
    <pre>       SomeClass expectedValue1 = theValues[1];</pre>
    
    <pre>       SomeClass value1 = theClosureValues[1]();</pre>
    
    <pre>       Assert.AreNotSame(expectedValue1, value1);</pre>
    
    <pre>&#160;</pre>
    
    <pre>       SomeClass expectedValue2 = theValues[2];</pre>
    
    <pre>       SomeClass value2 = theClosureValues[2]();</pre>
    
    <pre>       Assert.AreNotSame(expectedValue2, value2);</pre>
    
    <pre>&#160;</pre>
    
    <pre>       SomeClass expectedValue3 = theValues[3];</pre>
    
    <pre>       SomeClass value3 = theClosureValues[3]();</pre>
    
    <pre>       Assert.AreSame(expectedValue3, value3);</pre>
    
    <pre>   }</pre>
    
    <pre>&#160;</pre>
    
    <pre>}</pre></p>
  </div>
</div>

In this example, we’ve declared the “someClass” variable outside of the for-loop. This creates a variable that is scoped outside of the loop, and in this case outside of the Context() method. As long as this variable is scoped outside of the for-loop, we will only have a single variable to create our closure on. We see that the foo() anonymous method encloses someClass, causing it to stay in scope. What we don’t see, though, is that the foo() anonymous method will not be evaluated until the observations (just before the asserts) are executed. This means that every foo() method will have a reference to the same instance of “SomeClass”, not the individual instance that was created inside of the for-loop.

#### **Closure Of A Reference That Is Scoped Within The Loop**

<div>
  <div>
    <pre>[TestFixture]</pre>
    
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> When_creating_a_closure_for_a_reference_that_is_scoped_within_the_forloop: ContextSpecification</pre>
    
    <pre>{</pre>
    
    <pre>&#160;</pre>
    
    <pre>   <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IList&lt;SomeClass&gt; theValues = <span style="color: #0000ff">new</span> List&lt;SomeClass&gt;();</pre>
    
    <pre>   <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IList&lt;Func&lt;SomeClass&gt;&gt; theClosureValues = <span style="color: #0000ff">new</span> List&lt;Func&lt;SomeClass&gt;&gt;();</pre>
    
    <pre>&#160;</pre>
    
    <pre>   <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Context()</pre>
    
    <pre>   {</pre>
    
    <pre>       <span style="color: #0000ff">for</span> (<span style="color: #0000ff">int</span> i = 0; i &lt;= 3; i++)</pre>
    
    <pre>       {</pre>
    
    <pre>           SomeClass someClass = <span style="color: #0000ff">new</span> SomeClass();</pre>
    
    <pre>           theValues.Add(someClass);</pre>
    
    <pre>           Func&lt;SomeClass&gt; foo = (() =&gt; { <span style="color: #0000ff">return</span> someClass; });</pre>
    
    <pre>           theClosureValues.Add(foo);</pre>
    
    <pre>       }</pre>
    
    <pre>   }</pre>
    
    <pre>&#160;</pre>
    
    <pre>   [Test]</pre>
    
    <pre>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Then_all_closures_should_have_their_own_reference_from_the_loop_iteration()</pre>
    
    <pre>   {</pre>
    
    <pre>       SomeClass expectedValue0 = theValues[0];</pre>
    
    <pre>       SomeClass value0 = theClosureValues[0]();</pre>
    
    <pre>       Assert.AreSame(expectedValue0, value0);</pre>
    
    <pre>&#160;</pre>
    
    <pre>       SomeClass expectedValue1 = theValues[1];</pre>
    
    <pre>       SomeClass value1 = theClosureValues[1]();</pre>
    
    <pre>       Assert.AreSame(expectedValue1, value1);</pre>
    
    <pre>&#160;</pre>
    
    <pre>       SomeClass expectedValue2 = theValues[2];</pre>
    
    <pre>       SomeClass value2 = theClosureValues[2]();</pre>
    
    <pre>       Assert.AreSame(expectedValue2, value2);</pre>
    
    <pre>&#160;</pre>
    
    <pre>       SomeClass expectedValue3 = theValues[3];</pre>
    
    <pre>       SomeClass value3 = theClosureValues[3]();</pre>
    
    <pre>       Assert.AreSame(expectedValue3, value3);</pre>
    
    <pre>   }</pre>
    
    <pre>&#160;</pre>
    
    <pre>}</pre></p>
  </div>
</div>

In this example, we’ve declared the “someClass” variable inside of the for-loop, and is thus, in the local scope of the for-loop. Since the foo() anonymous method is creating a closure on a variable that is scoped to the for-loop, we can be assured that each foo() method will point to the “SomeClass” instance that was created in the for-loop. Our closure’s scope is now limited to the for-loop.

#### **Closure Of A Reference Pointer Copy**

<div>
  <div>
    <pre>[TestFixture]</pre>
    
    <pre><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> When_creating_a_closure_for_a_copy_of_a_reference_pointer : ContextSpecification</pre>
    
    <pre>{</pre>
    
    <pre>&#160;</pre>
    
    <pre>   SomeClass someClass;</pre>
    
    <pre>   <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IList&lt;SomeClass&gt; theValues = <span style="color: #0000ff">new</span> List&lt;SomeClass&gt;();</pre>
    
    <pre>   <span style="color: #0000ff">private</span> <span style="color: #0000ff">readonly</span> IList&lt;Func&lt;SomeClass&gt;&gt; theClosureValues = <span style="color: #0000ff">new</span> List&lt;Func&lt;SomeClass&gt;&gt;();</pre>
    
    <pre>&#160;</pre>
    
    <pre>   <span style="color: #0000ff">private</span> <span style="color: #0000ff">void</span> dooFoo(SomeClass <span style="color: #0000ff">value</span>)</pre>
    
    <pre>   {</pre>
    
    <pre>       Func&lt;SomeClass&gt; foo = (() =&gt; { <span style="color: #0000ff">return</span> <span style="color: #0000ff">value</span>; });</pre>
    
    <pre>       theClosureValues.Add(foo);</pre>
    
    <pre>   }</pre>
    
    <pre>&#160;</pre>
    
    <pre>   <span style="color: #0000ff">protected</span> <span style="color: #0000ff">override</span> <span style="color: #0000ff">void</span> Context()</pre>
    
    <pre>   {</pre>
    
    <pre>       <span style="color: #0000ff">for</span> (<span style="color: #0000ff">int</span> i = 0; i &lt;= 3; i++)</pre>
    
    <pre>       {</pre>
    
    <pre>           someClass = <span style="color: #0000ff">new</span> SomeClass();</pre>
    
    <pre>           theValues.Add(someClass);</pre>
    
    <pre>           dooFoo(someClass);</pre>
    
    <pre>       }</pre>
    
    <pre>   }</pre>
    
    <pre>&#160;</pre>
    
    <pre>   [Test]</pre>
    
    <pre>   <span style="color: #0000ff">public</span> <span style="color: #0000ff">void</span> Then_all_closures_should_have_their_own_reference_to_the_copied_reference_pointer()</pre>
    
    <pre>   {</pre>
    
    <pre>       SomeClass expectedValue0 = theValues[0];</pre>
    
    <pre>       SomeClass value0 = theClosureValues[0]();</pre>
    
    <pre>       Assert.AreSame(expectedValue0, value0);</pre>
    
    <pre>&#160;</pre>
    
    <pre>       SomeClass expectedValue1 = theValues[1];</pre>
    
    <pre>       SomeClass value1 = theClosureValues[1]();</pre>
    
    <pre>       Assert.AreSame(expectedValue1, value1);</pre>
    
    <pre>&#160;</pre>
    
    <pre>       SomeClass expectedValue2 = theValues[2];</pre>
    
    <pre>       SomeClass value2 = theClosureValues[2]();</pre>
    
    <pre>       Assert.AreSame(expectedValue2, value2);</pre>
    
    <pre>&#160;</pre>
    
    <pre>       SomeClass expectedValue3 = theValues[3];</pre>
    
    <pre>       SomeClass value3 = theClosureValues[3]();</pre>
    
    <pre>       Assert.AreSame(expectedValue3, value3);</pre>
    
    <pre>   }</pre>
    
    <pre>&#160;</pre>
    
    <pre>}</pre></p>
  </div>
</div>

In this last example, we can see that the “someClass” variable is again scoped outside of the Context() method. However, notice that we are now calling a “dooFoo()” method inside of the loop, instead of creating the closure locally. The effectively means that we are not creating a closure of “someClass” anymore. When someClass is passed into the dooFoo method, a copy of the reference is made – that is, we have a new variable with a new scope; this new variable just happens to be pointing to the same object as someClass, on the heap. Since we are now creating a closure around the “value” parameter of dooFoo, the scope of the closure has changed and acts the same as the closure of a reference in that is scoped with the loop. Each foo() anonymous method, with it’s closure, will now have it’s own instance of “value” to reference – the reference that was created in the scope of the for-loop, and then copied into the “value” parameter.

### 

### **In “Closing” (pun intended 🙂 )**

It’s important to keep the scope of the variables in our closures in mind. If we scope our closures incorrectly, we can have some strange bugs in our system. Understanding the scope of your closures does require us to know a little bit of computer science, though – stack vs. heap, reference vs. value type – but that’s not a bad thing. 

(If you see something wrong in my explanations or think my spec/observation names should be changed, let me know. I tried to make it clear, but am not sure that I did a good job.)