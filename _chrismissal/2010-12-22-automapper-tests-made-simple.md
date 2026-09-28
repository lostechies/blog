---
wordpress_id: 3384
title: AutoMapper Tests Made Simple
date: 2010-12-22T04:37:00+00:00
author: Chris Missal
layout: post
wordpress_guid: /blogs/chrismissal/archive/2010/12/21/automapper-tests-made-simple.aspx
dsq_thread_id:
  - "264669624"
categories:
  - AutoMapper
  - DRY
  - NUnit
  - Testing
redirect_from: "/blogs/chrismissal/archive/2010/12/21/automapper-tests-made-simple.aspx/"
---
I work primarily on a C# ASP.NET MVC application that deals with many other systems which seem to dish out strings all over the place. Hence the need for something like AutoMapper. When converting this data into objects or enumerations, I find it&#8217;s easiest to extend TypeConverter<TSource, TDestination> with our own class that we can cover with several data/unit tests. A lot of these test fixtures were very similar and I was looking to clean up some of these tests to make them easier to maintain and less &#8220;copy/paste&#8221; when a new one is ready to be added.

I believed had an abstraction almost ready to go with NUnit&#8217;s TestCaseSource and TestCaseData classes, but there was one little piece that was bothering me. Our previous tests were subclassing our TypeConverters and overriding the ConvertCore method to make it public. This seemed goofy, but also seemed necessary after upgrading AutoMapper from 0.4 to version 1.0 a while back. Today I asked whoever was listening on Twitter for ways that they test their TypeConverters, and Matt Hinze (@mhinze) pointed me towards ResolutionContext.New(), which makes our tests much simpler, and removes the need for subclassing. From here, there&#8217;s not much to do.

Our original tests looked something like this:

<pre>[TestFixture]
public class StringToSectionConverterTests
{
	[TestCase(null, Section.Unknown)]
	[TestCase("", Section.Unknown)]
	[TestCase("category", Section.Category)]
	[TestCase("brand", Section.Brand)]
	[TestCase("machine", Section.Machine)]
	[TestCase("model", Section.Machine)]
	[TestCase("make", Section.Make)]
	[TestCase("jacky treehorn", Section.Unknown, ExpectedException = typeof(ArgumentException))]
	public void ConvertCore_returns_expected_result(string source, Section expected)
	{
		// Arrange
		var resolver = new TestStringToSectionConverter();

		// Act
		var result = resolver.ConvertCore(source);

		// Assert
		result.ShouldEqual(expected);
	}

	private class TestStringToSectionConverter : StringToSectionResolver
	{
		public new Section ConvertCore(string source)
		{
			return base.ConvertCore(source);
		}
	}
}
</pre>

After some fairly easy changes and some excellence from NUnit, we now have something like this:

<pre>public abstract class TypeConverterTesterBase where T : TypeConverter
{
	public abstract IEnumerable GetTestData { get; }

	[TestCaseSource("GetTestData")]
	public TDestination Source_can_be_converted_to_expected_destination(TSource source)
	{
		var typeConverter = Activator.CreateInstance();
		return typeConverter.Convert(ResolutionContext.New(source));
	}

	public TestCaseData CaseReturning(TSource source, TDestination destination)
	{
		return new TestCaseData(source).Returns(destination);
	}

	public TestCaseData CaseThrowing(TSource source) where TException : Exception
	{
		return new TestCaseData(source).Throws(typeof(TException));
	}
}

[TestFixture]
public class StringToSectionConverterTests : TypeConverterTesterBase&lt;StringToSectionConverter, string, Section&gt;
{
    public override IEnumerable GetTestData
    {
        get
        {
            yield return CaseReturning(null, Section.Unknown);
            yield return CaseReturning("", Section.Unknown);
            yield return CaseReturning("Category", Section.Category);
            yield return CaseReturning("brand", Section.Brand);
            yield return CaseReturning("machine", Section.Machine);
            yield return CaseReturning("model", Section.Machine);
            yield return CaseReturning("make", Section.Make);
            yield return CaseReturning("section", Section.Section);
            yield return CaseThrowing("jacky treehorn");
        }
    }
}
</pre>

For tests like this where you&#8217;re testing data transformations, NUnit has TestCaseSource and TestCaseData. These are super helpful; check them out if you haven&#8217;t used them before.

&nbsp;

  * [NUnit TestCaseSource](http://www.nunit.org/index.php?p=testCaseSource&r=2.5)
  * [AutoMapper](http://automapper.codeplex.com/)

<div>
  Enjoy and be sure to ask me questions if you have any. I feel like I rushed my thoughts here! 😛
</div>

&nbsp;