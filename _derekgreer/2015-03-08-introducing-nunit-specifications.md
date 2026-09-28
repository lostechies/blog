---
wordpress_id: 824
title: Introducing NUnit.Specifications
date: 2015-03-08T09:57:06+00:00
author: Derek Greer
layout: post
wordpress_guid: http://lostechies.com/derekgreer/?p=824
dsq_thread_id:
  - "3577757679"
categories:
  - Uncategorized
---
****

I recently started working with a new team that uses NUnit as their testing framework.&nbsp; While I think NUnit is a solid framework, I don’t think the default API and style lead to [effective tests](https://lostechies.com/derekgreer/2011/03/07/effective-tests-introduction/).&nbsp; 

As an advocate of Test-Driven Development, I’ve always appreciated how [context/specification-style](http://www.codemag.com/article/0805061) frameworks such as [Machine.Specifications (MSpec)](https://github.com/machine/machine.specifications) allow for the expression of executable specifications which model how a system is expected to be used rather than the typical unit-test style of testing which tends to obscure the overall purpose of the system.&nbsp; 

To facilitate a context/specification-style API, I created a base class which makes use of the hooks provided by the NUnit testing framework to emulate MSpec.&nbsp; I’ve published this code under the project name [NUnit.Specifications](https://www.nuget.org/packages/NUnit.Specifications/).

The following is an example NUnit test written using the ContextSpecification based class from NUnit.Specifications using the [Should](https://github.com/erichexter/Should) assertion library:

[<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image01" src="https://lostechies.com/content/derekgreer/uploads/2015/03/image01_thumb.png" width="574" height="379" />](https://lostechies.com/content/derekgreer/uploads/2015/03/image01.png){.thickbox}

One nice benefit of building on top of NUnit is the wide-spread tool support available.&nbsp; Here is the test as seen through various test runners:

**Resharper Test Runner:**

[<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image03" src="https://lostechies.com/wp-content/uploads/2015/03/image03_thumb.png" width="574" height="196" />](https://lostechies.com/wp-content/uploads/2015/03/image03.png){.thickbox}

**TestDriven.Net:** (see notes below)

[<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image04" src="https://lostechies.com/wp-content/uploads/2015/03/image04_thumb.png" width="574" height="47" />](https://lostechies.com/wp-content/uploads/2015/03/image04.png){.thickbox}

**NUnit Test Runner:**

[<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image00" src="https://lostechies.com/wp-content/uploads/2015/03/image00_thumb.png" width="574" height="175" />](https://lostechies.com/wp-content/uploads/2015/03/image00.png){.thickbox}

**NUnit Test Adaptor for Visual Studio:**

[<img style="border-left-width: 0px;border-right-width: 0px;border-bottom-width: 0px;padding-top: 0px;padding-left: 0px;padding-right: 0px;border-top-width: 0px" border="0" alt="image02" src="https://lostechies.com/wp-content/uploads/2015/03/image02_thumb.png" width="574" height="519" />](https://lostechies.com/wp-content/uploads/2015/03/image02.png){.thickbox}

&nbsp;

<div class="note">
  <p>
    One caveat I discovered with the TestDriven.Net runner is it’s failure to recognize tests without the specification referencing types from the NUnit.Framework namespace (e.g. TestFixtureAttribute, CategoryAttribute, use of Assert, etc.).&nbsp; That is to say, it didn’t seem to be enough that the spec inherited from a base type with NUnit attributes, but something in the derived class had to reference a type from the NUnit.Framework namespace for the test to be recognized.&nbsp; Therefore, the TestDriven.Net results shown above were actually achieved by annotating the class with [Category(“component”)] explicitly.
  </p>
</div>

&nbsp;

**Other Stuff**

As a convenience, NUnit.Specifications also provides attributes for denoting categories of Unit, Component, Integration, Acceptance, and Subcutaneous as well as a Catch class (as provided by the MSpec library) for working with exceptions.

You can obtain the NUnit.Specifications from [NuGet](https://www.nuget.org/packages/NUnit.Specifications/1.0.1) or grab the source from [github](https://github.com/derekgreer/nunit.specifications).
