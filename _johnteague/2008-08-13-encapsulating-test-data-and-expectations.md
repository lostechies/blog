---
id: 12
title: Encapsulating Test Data and Expectations
date: 2008-08-13T02:13:07+00:00
author: John Teague
layout: post
guid: /blogs/johnteague/archive/2008/08/12/encapsulating-test-data-and-expectations.aspx
dsq_thread_id:
  - "262055500"
categories:
  - TDD
  - Testing
---
I love it when I find new ways to improve my testing ability.&nbsp; In this case, it&#8217;s not really new, just new to me.&nbsp; I&#8217;m referring The [Object Mother](http://c2.com/cgi/wiki?ObjectMother) or [Test Data Builder](http://nat.truemesh.com/archives/000714.html) patterns used to encapsulate objects you need for testing.&nbsp; I started playing with these patterns to simplify my tests and I found a way to further reduce the noise in my tests.

The basic concepts of these concept of these patterns is to put object populated with what you need behind simple factory methods to give you back the objects.&nbsp; Test Builders can be more complicated, perhaps using a [fluent interface](http://codebetter.com/blogs/gregyoung/archive/2008/04/16/dddd-6-fluent-builders-alternate-ending.aspx) to define the object exactly as you need for particular test.&nbsp; The complexity for most of my tests fell somewhere between these too approaches.&nbsp; The factory methods didn&#8217;t give me enough flexibility and most of my objects were not complex enough to warrant a full fluent interfaces.

Most of my tests seem to follow this pattern, where I define variables to hold my expected values, assign these values to the objects I need to test and then run my assertions against these expected values.

And then do my tests:

<pre><span style="color: blue">private string </span>_expectedName = <span style="color: #a31515">"name"</span>;
<span style="color: blue">private string </span>_expectedPhone = <span style="color: #a31515">"phone"</span>;
<span style="color: blue">private string </span>_expectedPlus4 = <span style="color: #a31515">"plus 4"</span>;
<span style="color: blue">private string </span>_expectedStateAbbrev = <span style="color: #a31515">"state"</span>;
<span style="color: blue">private string </span>_expectedZip = <span style="color: #a31515">"zip"</span>;</pre>

<pre>...
[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>should_populate_the_work_order_table_to_the_work_order_dto()
{
    
    <span style="color: #2b91af">WorkOrderMapper </span>mapper = <span style="color: blue">new </span><span style="color: #2b91af">WorkOrderMapper</span>();
    <span style="color: #2b91af">DataSet </span>workOrderDataSet = SetUpWorkOrderDataSet();
    <span style="color: blue">var </span>dto = mapper.MapFrom(workOrderDataSet);
    <span style="color: #2b91af">Assert</span>.That(dto.CompanyName, <span style="color: #2b91af">Is</span>.EqualTo(_expectedCompanyName));
    <span style="color: #2b91af">Assert</span>.That(dto.Phone, <span style="color: #2b91af">Is</span>.EqualTo(_expectedPhone));
    <span style="color: #2b91af">Assert</span>.That(dto.StateAbbrev, <span style="color: #2b91af">Is</span>.EqualTo(_expectedStateAbbrev));
    <span style="color: #2b91af">Assert</span>.That(dto.ZipCode, <span style="color: #2b91af">Is</span>.EqualTo(_expectedZip));
}</pre>

[](http://11011.net/software/vspaste)[](http://11011.net/software/vspaste)

So I once I started exploring the Object Mother pattern, I realized that I could encapsulate not only the data I need for my objects, but also my expectation variables as well.&nbsp; So I created TestData objects, where I declared the expected values and populated the objects with those values.&nbsp; After a couple of different approaches, these test data classes started to look like this.

<pre><span style="color: blue">public class </span><span style="color: #2b91af">CustomerTestData
</span>{
    <span style="color: blue">public </span>CustomerTestData()
        : <span style="color: blue">this</span>(<span style="color: blue">null</span>)
    {
    }</pre>

> <pre><span style="color: blue">public </span><span style="color: #2b91af">ExpectationData </span>Expectations { <span style="color: blue">get</span>;<span style="color: blue">set</span>;} </pre>
> 
> <pre><span style="color: blue">public </span><span style="color: #2b91af">Customer </span>Item{<span style="color: blue">get</span>;<span style="color: blue">set</span>;} 
    <span style="color: blue">public class </span><span style="color: #2b91af">ExpectationData
    </span>{
        <span style="color: blue">public int </span>Id = 0;
        <span style="color: blue">public string </span>CustNo = <span style="color: #a31515">"CustNo"</span>;
        <span style="color: blue">public string </span>Company = <span style="color: #a31515">"Company"</span>;
        <span style="color: blue">public double </span>Tax = 50;
        <span style="color: blue">public double </span>Discount = 10;
        <span style="color: blue">public string </span>GlLink = <span style="color: #a31515">"gl"</span>;
        <span style="color: blue">public bool </span>IsTaxExempt = <span style="color: blue">true</span>;
        ...
        <span style="color: blue">public </span>ExpectationData()
        {
        }
   }
}</pre>

I could then use the Test Data Objects in my test like this:

<pre>[<span style="color: #2b91af">Test</span>] 
<span style="color: blue">public void </span>should_sum_all_line_item_prices_times_quantity()
{
    <span style="color: blue">var </span>salesOrder = <span style="color: #2b91af">TestingData</span>.GetSalesOrderTestData().SalesOrder;
    
    <span style="color: blue">var </span>actualTotal = salesOrder.GetOrderTotal();
    <span style="color: #2b91af">Assert</span>.That(actualTotal, <span style="color: #2b91af">Is</span>.EqualTo(50m));
    
}
</pre>

[](http://11011.net/software/vspaste)

## Variability and Keeping Test Readable

There are two issues with this approach.&nbsp; The first one you probably noticed right away.&nbsp; There&#8217;s no way the same data can be used to satisfy all of your tests.&nbsp; What if I have tests that need a null value or an invalid value?&nbsp; Having the Expectations pre-defined reduce their usability to only positive tests.&nbsp; The other issue is a little more subtle, but this approach reduces the [readability](http://dannorth.net/2008/06/let-your-examples-flow) of my test.&nbsp; Now when someone wants to know what my tests are doing they have to look in two places, the test itself and the TestData objects.&nbsp; The reduces their overall usefulness in describing the behavior of the system and it&#8217;s just plain annoying.

So what we need is the ability to define the values that are important to the test, but also create the objects in a valid state with default values unrelated to the test at hand.&nbsp; We can do this with an Action<T> delegate.&nbsp; Lets create the TestData with an Action<CustomerExpectations> delegate:

<pre><span style="color: blue">public </span>CustomerTestData(<span style="color: #2b91af">Action</span>&lt;<span style="color: #2b91af">CustomerTestData</span>.<span style="color: #2b91af">ExpectationData</span>&gt; overrideDefaultExpecations)
{
    Expectations = <span style="color: blue">new </span><span style="color: #2b91af">CustomertTestData</span>.<span style="color: #2b91af">ExpectationData</span>();
    Item = Expectations.SetExpectionsOn(overrideDefaultExpecations);
}</pre>

[](http://11011.net/software/vspaste)

Since delegates are first class citizens in .Net, we can pass that function around and execute when we need it.&nbsp; Let&#8217;s create a method in ExpectationData class the creates our Customer object.&nbsp; Now we&#8217;ll use the delegate to change the expected values.&nbsp; This will change the value of the expectations before we set the values on the Customer object. 

<pre><span style="color: blue">public </span><span style="color: #2b91af">Customer </span>SetExpectionsOn(<span style="color: #2b91af">Action</span>&lt;<span style="color: #2b91af">CustomerTestData</span>.<span style="color: #2b91af">ExpectationData</span>&gt; setExpectations)
{
    <span style="color: blue">if </span>(setExpectations != <span style="color: blue">null</span>)
    {
        setExpectations(<span style="color: blue">this</span>);
    }
    <span style="color: #2b91af">ArCust </span>item = <span style="color: blue">new </span><span style="color: #2b91af">ArCust</span>();
    item.Id = Id;
    item.Company = Company;
    ...
    <span style="color: blue">return </span>item;

}</pre>

Now are our test looks like this:

[<span style="color: #2b91af">Test</span>] <span style="color: blue">public void </span>should\_sum\_all\_line\_item\_prices\_times_quantity()  
{   
<span style="color: blue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; var </span>salesOrder = <span style="color: #2b91af">TestingData</span>.GetSalesOrderTestData(e => {  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; e.LineItem.Price = 10m;  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; e.LineItem.Price = 5m;  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }).SalesOrder;   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="color: blue">var </span>actualTotal = salesOrder.GetOrderTotal();   
<span style="color: #2b91af">&nbsp;&nbsp;&nbsp;&nbsp; Assert</span>.That(actualTotal, <span style="color: #2b91af">Is</span>.EqualTo(50m));   
} 

Now we can set the values for the parameters we are interested in, keeping our test objects in a valid state and maintaining the readability needed to understand the test without needing to refer to other object.

## Conclusion

I&#8217;m still tweaking the syntax, but so far it has really cleaned up some of my tests.&nbsp; However, it can fall apart if you have a complicated setup process.&nbsp; Some of my tests require the same data in multiple objects, so that that they all&nbsp; match when my service is executed.&nbsp; Using the delegates to wire up 3 different objects in the setup became very difficult to read.&nbsp; So I switched to the Builder pattern (and some refactoring) to clean up the process.&nbsp; In other cases I needed a quick method to populate all the fields, so I wrapped it up in a factory method.&nbsp; It is very easy to combine this approach with Builders and Factory Methods to give you as much control as you need over your test data.