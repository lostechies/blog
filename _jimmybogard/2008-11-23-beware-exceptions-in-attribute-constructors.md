---
id: 256
title: Beware exceptions in attribute constructors
date: 2008-11-23T01:05:54+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2008/11/22/beware-exceptions-in-attribute-constructors.aspx
dsq_thread_id:
  - "266628135"
categories:
  - 'C#'
---
If you’d like to have some really wacky bugs, be sure to do something like this:

<pre><span style="color: blue">public class </span><span style="color: #2b91af">BlowupAttribute </span>: <span style="color: #2b91af">Attribute
</span>{
    <span style="color: blue">public </span>BlowupAttribute(<span style="color: blue">int </span>time)
    {
        <span style="color: blue">if </span>(time &lt;= 0)
            <span style="color: blue">throw new </span><span style="color: #2b91af">ArgumentOutOfRangeException</span>(<span style="color: #a31515">"time"</span>, time, <span style="color: #a31515">"Must be greater than zero."</span>);
    }
}</pre>

[](http://11011.net/software/vspaste)

Attributes are a little different than other classes, as you’re never really in control of when the constructor gets called.&#160; Things get especially weird in unit tests, where test runners do quite a bit of reflection that triggers the constructors of attributes.&#160; This test fails:

<pre>[<span style="color: #2b91af">Blowup</span>(-1)]
<span style="color: blue">public void </span>Asplode()
{
}

[<span style="color: #2b91af">Test</span>]
<span style="color: blue">public void </span>Fails_anyway()
{
    <span style="color: blue">true</span>.ShouldBeTrue();
}</pre>

[](http://11011.net/software/vspaste)

Simply because another member in the class has a bad value in the attribute.&#160; Unfortunately, the stack trace gives absolutely zero hint on where the exception occurred:

<pre>TestCase 'M:AttributeExceptions.Blarg.Fails_anyway'
failed: Must be greater than zero.
Parameter name: time
Actual value was -1.
    System.ArgumentOutOfRangeException: Must be greater than zero.
    Parameter name: time
    Actual value was -1.
    C:devMSTestSpecMSTestSpec.TestsAttributeExceptions.cs(13,0): at AttributeExceptions.BlowupAttribute..ctor(Int32 time)
    at System.Reflection.CustomAttribute._CreateCaObject(Void* pModule, Void* pCtor, Byte** ppBlob, Byte* pEndBlob, Int32* pcNamedArgs)
    at System.Reflection.CustomAttribute.CreateCaObject(Module module, RuntimeMethodHandle ctor, IntPtr& blob, IntPtr blobEnd, Int32& namedArgs)
    at System.Reflection.CustomAttribute.GetCustomAttributes(Module decoratedModule, Int32 decoratedMetadataToken, Int32 pcaCount, RuntimeType attributeFilterType, Boolean mustBeInheritable, IList derivedAttributes)
    at System.Reflection.CustomAttribute.GetCustomAttributes(RuntimeMethodInfo method, RuntimeType caType, Boolean inherit)
    at NUnit.Core.Reflect.HasAttribute(MemberInfo member, String attrName, Boolean inherit)
    at NUnit.Core.Reflect.GetMethodWithAttribute(Type fixtureType, String attributeName, BindingFlags bindingFlags, Boolean inherit)
    at NUnit.Core.NUnitTestFixture..ctor(Type fixtureType)
    at NUnit.Core.Builders.NUnitTestFixtureBuilder.MakeSuite(Type type)
    at NUnit.Core.Builders.AbstractFixtureBuilder.BuildFrom(Type type)
    at NUnit.Core.Extensibility.SuiteBuilderCollection.BuildFrom(Type type)
    at NUnit.Core.Builders.TestAssemblyBuilder.GetFixtures(Assembly assembly, String ns)
    at NUnit.Core.Builders.TestAssemblyBuilder.Build(String assemblyName, Boolean autoSuites)
    at NUnit.Core.Builders.TestAssemblyBuilder.Build(String assemblyName, String testName, Boolean autoSuites)
    at NUnit.Core.TestSuiteBuilder.BuildSingleAssembly(TestPackage package)
    at NUnit.Core.TestSuiteBuilder.Build(TestPackage package)
    at NUnit.AddInRunner.NUnitTestRunner.run(ITestListener testListener, Assembly assembly, ITestFilter filter)
    at NUnit.AddInRunner.NUnitTestRunner.runMethod(ITestListener testListener, Assembly assembly, MethodInfo method)
    at NUnit.AddInRunner.NUnitTestRunner.RunMember(ITestListener testListener, Assembly assembly, MemberInfo member)
    at TestDriven.TestRunner.AdaptorTestRunner.Run(ITestListener testListener, ITraceListener traceListener, String assemblyPath, String testPath)
    at TestDriven.TestRunner.ThreadTestRunner.Runner.Run()</pre>

[](http://11011.net/software/vspaste)

Nowhere do we see where the original attribute was declared, that information is lost.&#160; Attributes are meant for metadata, and exceptions can really screw things up.&#160; To be safe, **avoid throwing exceptions in an attribute constructor.**&#160; Also, be very careful of any complex operations done in the constructor.&#160; If you’re doing anything more than merely capturing parameters passed in, you’re doing too much.