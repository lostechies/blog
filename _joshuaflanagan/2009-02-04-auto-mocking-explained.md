---
wordpress_id: 3942
title: Auto mocking Explained
date: 2009-02-04T01:25:32+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: /blogs/joshuaflanagan/archive/2009/02/03/auto-mocking-explained.aspx
dsq_thread_id:
  - "262113157"
categories:
  - RhinoMocks
redirect_from: "/blogs/joshuaflanagan/archive/2009/02/03/auto-mocking-explained.aspx/"
---
## What does it do?

There is nothing fancy about an automocker. There is nothing scary about an automocker. An automocker is like one of those little classes we all write in order to quickly and easily create objects that we need for our tests. Nice, simple, helpful, non-threatening.

You tell the automocker which class you want to test, and the automocker creates an instance of that class for you. If the constructor of your class requires you to pass in other objects, the automocker will automatically create a mock for each of the necessary types and pass them in. The automocker will keep track of all the mocks it creates, and allows you to retrieve them if you need to stub a specific behavior.

## Why should I fear the automocker?

Where it gets scary (for some) is when you use the name most often used to refer to them: auto mocking _container_. “Wait wait wait, you’re using an IOC container in your unit test?! Configuration! Brittle! No thank you!”

The name comes from [AutoMockingContainer](http://blog.eleutian.com/CommentView,guid,762249da-e25a-4503-8f20-c6d59b1a69bc.aspx), which introduced the idea of an automocker (to me, at least) by using the Castle Windsor IOC tool to do the heavy lifting. The <a href="http://structuremap.sourceforge.net" target="_blank">StructureMap</a> IOC tool distribution also includes an automocker. But here’s the thing – the container is just an implementation detail. You, as the test writer, never have to know there is a container in play. Automocking is not an IOC container feature. Automocking is really a feature of a mocking framework, but just happens to be packaged and/or named in relation to a container.

In other words, I suspect the idea of automocking would be a lot less scary to people if it were packaged with the mocking frameworks. Suppose Rhino.Mocks added the method: MockRepository.CreateWithMocks<ClassToTest>() – would automocking still be as distasteful? Maybe it would use Castle MicroKernel under the hood, but you wouldn’t ever be exposed to it (just as Rhino.Mocks currently uses Castle DynamicProxy under the hood).

## Why should I use the automocker?

Ok, so you’re over the container part. But you’re not convinced. The automocker can save you some tedious keystrokes, but code snippets solve that problem. I think the big benefit of the automocker is that it helps keep the content of your tests focused on the functionality being tested. It also helps keep your tests less brittle as your objects evolve.

Consider the following class that I need to test:

<div>
  <div>
    <pre class="brush: csharp; gutter:false; wrap-lines:false; tab-size:2">public class PhotoController
{
    private readonly IPhotoCatalog photoCatalog;
 
    public PhotoController(IPhotoCatalog photoCatalog)
    {
        this.photoCatalog = photoCatalog;
    }
 
    public PhotoDetails[] List()
    {
        return photoCatalog.FindAll();
    }
 
    public void Save(PhotoDetails photo)
    {
        photoCatalog.AddPhoto(photo);
    }
}</pre></p>
  </div>
</div>

A couple tests, without automocking, might look like this:

<div>
  <div>
    <pre class="brush: csharp; gutter:false; wrap-lines:false; tab-size:2">[TestFixture]
public class when_visiting_the_list_page
{
    private PhotoDetails[] Output;
    private PhotoDetails[] AllPhotos;
 
    [SetUp]
    public void Setup()
    {
        AllPhotos = new[] { new PhotoDetails(1), new PhotoDetails(2) };
        IPhotoCatalog photoCatalog = MockRepository.GenerateStub&lt;IPhotoCatalog>();
        photoCatalog.Stub(c => c.FindAll()).Return(AllPhotos);
 
        var controller = new PhotoController(photoCatalog);
        Output = controller.List();
    }
 
    [Test]
    public void should_display_all_of_the_photos_in_the_catalog()
    {
        Assert.AreEqual(AllPhotos, Output);
    }
}
 
[TestFixture]
public class when_saving_a_photo
{
    private PhotoDetails thePhoto;
    private IPhotoCatalog photoCatalog;
 
    [SetUp]
    public void Setup()
    {
        photoCatalog = MockRepository.GenerateStub&lt;IPhotoCatalog>();
        var controller = new PhotoController(photoCatalog);
 
        thePhoto = new PhotoDetails(4);
        controller.Save(thePhoto);
    }
 
    [Test]
    public void should_store_the_photo_details_in_the_catalog()
    {
        photoCatalog.AssertWasCalled(c => c.AddPhoto(thePhoto));
    }
}</pre></p>
  </div>
</div>

The same tests, with automocking, would look like this:

<div>
  <div>
    <pre class="brush: csharp; gutter:false; wrap-lines:false; tab-size:2">[TestFixture]
public class when_visiting_the_list_page
{
    private PhotoDetails[] Output;
    private PhotoDetails[] AllPhotos;
 
    [SetUp]
    public void Setup()
    {
        AllPhotos = new[] { new PhotoDetails(1), new PhotoDetails(2) };
        var mocks = new RhinoAutoMocker&lt;PhotoController>();
        var controller = mocks.ClassUnderTest;
        mocks.Get&lt;IPhotoCatalog>().Stub(c => c.FindAll()).Return(AllPhotos);
 
        Output = controller.List();
    }
 
    [Test]
    public void should_display_all_of_the_photos_in_the_catalog()
    {
        Assert.AreEqual(AllPhotos, Output);
    }
}
 
[TestFixture]
public class when_saving_a_photo
{
    private PhotoDetails thePhoto;
    private RhinoAutoMocker&lt;PhotoController> mocks;
 
    [SetUp]
    public void Setup()
    {
        mocks = new RhinoAutoMocker&lt;PhotoController>();
        var controller = mocks.ClassUnderTest;
 
        thePhoto = new PhotoDetails(4);
        controller.Save(thePhoto);
    }
 
    [Test]
    public void should_store_the_photo_details_in_the_catalog()
    {
        mocks.Get&lt;IPhotoCatalog>().AssertWasCalled(c => c.AddPhoto(thePhoto));
    }
}</pre></p>
  </div>
</div>

Not a huge difference, mostly because the class under test only has a single dependency, so you are only hiding a single call to MockRepository.GenerateMock. But what about when I need to change some functionality on one of the methods? We realize we need to save a copy of the uploaded photo to the file system. We will need to change the Save method on the controller, and add a new dependency on an IFileSystem service.

We’ll update the automocked tests to include the new specification (no other changes to the tests required):

<div>
  <div>
    <pre class="brush: csharp; gutter:false; wrap-lines:false; tab-size:2">[Test]
public void should_store_the_photo_in_the_file_system()
{
    mocks.Get&lt;IFileSystem>().AssertWasCalled(fs => fs.WriteFile(thePhoto.Filename, thePhoto.Data));
}</pre></p>
  </div>
</div>

And the corresponding code to:

<div>
  <div>
    <pre class="brush: csharp; gutter:false; wrap-lines:false; tab-size:2">public class PhotoController
{
    private readonly IPhotoCatalog photoCatalog;
    private readonly IFileSystem fileSystem;
 
    public PhotoController(IPhotoCatalog photoCatalog, IFileSystem fileSystem)
    {
        this.photoCatalog = photoCatalog;
        this.fileSystem = fileSystem;
    }
 
    public PhotoDetails[] List()
    {
        return photoCatalog.FindAll();
    }
 
    public void Save(PhotoDetails photo)
    {
        photoCatalog.AddPhoto(photo);
        fileSystem.WriteFile(photo.Filename, photo.Data);
    }
}</pre></p>
  </div>
</div>

Now I can run all of my tests (for both Save and List) – they all compile and pass. Notice the only change to my tests was adding a single method that asserted the new behavior.

The tests that didn’t use the automocker? Not as lucky. I add the new method that has the new assertion,

<div>
  <div>
    <pre class="brush: csharp; gutter:false; wrap-lines:false; tab-size:2">[Test]
public void should_store_the_photo_in_the_file_system()
{
    fileSystem.AssertWasCalled(fs => fs.WriteFile(thePhoto.Filename, thePhoto.Data));
}</pre></p>
  </div>
</div>

and then I have to update the Setup to create the new mock. Not a big deal. 

<div>
  <div>
    <pre class="brush: csharp; gutter:false; wrap-lines:false; tab-size:2">fileSystem = MockRepository.GenerateStub&lt;IFileSystem>();
var controller = new PhotoController(photoCatalog, fileSystem);</pre></p>
  </div>
</div>

The IDE complains because I’m trying to pass two arguments to the controller constructor, but it only takes one, so I update the controller. Still not a big deal. Try and run my test – ugh, compiler error. Looks like I need to update the tests for the List method? Why? I’m not making any changes to the List method? So I update the Setup for that test fixture as well:

<div>
  <div>
    <pre class="brush: csharp; gutter:false; wrap-lines:false; tab-size:2">var fileSystem = MockRepository.GenerateStub&lt;IFileSystem>();
var controller = new PhotoController(photoCatalog, fileSystem);</pre></p>
  </div>
</div>

Is it horrible? No. Is the automocked version nicer? I think so. The evolution of my code had minimal impact on the tests, plus I was able to eliminate “noise” code that creates all of the mocks. What does the automocked version cost me? Just an Add Reference to an assembly that I already have in the&#160; tools/lib section of my source tree.</p> </p> 

Neither my code nor my tests have any dependency on an IOC container. There is no external dependency or configuration. Even if I don’t use StructureMap in my application code, I could still use the RhinoAutoMocker that it includes for my tests. If my code DOES use StructureMap as its IOC container, I could still use the original Windsor-based AutoMockingContainer for my tests without a problem. The key point being that the IOC container you use in your application has nothing to do with the automocking you do in your tests.