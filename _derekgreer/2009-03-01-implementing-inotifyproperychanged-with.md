---
id: 449
title: 'Implementing INotifyProperyChanged  with Unity Interception'
date: 2009-03-01T09:32:00+00:00
author: Derek Greer
layout: post
guid: http://www.aspiringcraftsman.com/2009/03/implementing-inotifyproperychanged-with-unity-interception/
dsq_thread_id:
  - "318621003"
categories:
  - Uncategorized
tags:
  - Unity
---
Inspired by Sebastien Lambla&#8217;s post, [Implementing INotifyPropertyChanged with DynamicProxy2](http://serialseb.blogspot.com/2008/05/implementing-inotifypropertychanged.html), I decided to provide an example of how [INotifyPropertyChanged](http://msdn.microsoft.com/en-%20%%20%2020us/library/system.componentmodel.inotifypropertychanged.aspx) can be implemented using Unity&#8217;s new [interception capabilities](http://msdn.microsoft.com/en-us/library/dd140045.aspx).

## Prolegomena

While not necessary for using the Unity container, some may find a basic understanding of how Unity works to be helpful when registering objects for interception or using other capabilities of Unity.

The Unity container is best understood as a façade for a highly configurable, yet complex object factory named Object Builder. Object Builder made its debut within the [Composite UI Application Block](http://msdn.microsoft.com/en-us/library/aa480450.aspx) in November 2005 and was subsequently incorporated into [Enterprise Library 2.0](http://msdn.microsoft.com/en-us/library/cc467893.aspx) with its January 2006 release as its internal configuration strategy.

At its core, Object Builder is based upon the [Chain-of-Responsibility](http://en.wikipedia.org/wiki/Chain-of-responsibility_pattern) pattern. The Object Builder chain-of-responsibility utilizes two primary concepts for configuring how objects are constructed: namely, Strategies and Policies. Strategies serve as the concrete handlers within the chain-of-responsibility implementation, and are the objects which encapsulate the behavior performed during the construction process. Policies serve as the rules for how and when Strategies apply to a given type. Strategies and Policies are the essence of Object Builder&#8217;s extensibility, and by extension Unity&#8217;s extensibility.

While Object Builder can be used directly to provide advanced dependency injection and other inversion of control needs, due to the fact that it waswritten to serve the internal needs of the guidance assets provided by the Microsoft Patterns & Practices group, it wasn&#8217;t developed with ease of use in mind and didn&#8217;t provide the same API nomenclature used by other containers. This is where Unity comes in.

Unity was written to provide an easy to use and more traditional container interface to Object Builder. Part of this interface includes a more simplified end-user extensibility API in the form of Unity Extensions. These extensions encapsulate the lower-level Strategy and Policy configuration for Object Builder.

The 1.2 release of Unity in October 2008 included a new extension for facilitating aspect-oriented programming through method interception. The remainder of this article demonstrates how this new extension can be used to implement the [INotifyPropertyChanged](http://msdn.microsoft.com/en-us/library/system.componentmodel.inotifypropertychanged.aspx) interface.

## Interception Example

To start, we&#8217;ll create a test fixture skeleton to drive our example:

<pre class="brush:csharp">[TestFixture]
public class When_model_property_changes
{
    [SetUp]
    public void SetUp()
    {
        EstablishContext();
        Because();
    }

    protected override void EstablishContext()
    {
    }

    protected override void Because()
    {
    }

    [Test]
    public void A_notify_property_changed_event_should_be_raised()
    {
    }
}
</pre>

Next, we&#8217;ll establish the context of our test by configuring an instance of the Unity container to intercept methods for a type named IModel:

<pre class="brush:csharp">[TestFixture]
public class When_model_property_changes : ContextSpecification
{
    IUnityContainer container;
    IModel model;

    /** snip **/

    protected void EstablishContext()
    {
        container = new UnityContainer();

        container.AddNewExtension()
        .RegisterType&lt;IModel, Model&gt;()
        .Configure()
        .SetDefaultInterceptorFor&lt;IModel&gt;(new TransparentProxyInterceptor());

        model = container.Resolve&lt;IModel&gt;();
    }

    /** snip **/
}
</pre>

We configure our container by first adding the Interception extension. Next, we register the type we will be resolving from the container. Finally, we set a default interceptor for our type.

By adding the Interception extension, two new build strategies are added to the chain-of-responsibility for facilitating interception. Additionally, the extension registers an instance of an AttributeDrivenPolicy which is used by the interception strategies to provide the ability to identify which methods should be intercepted through the use of attributes. We will later create a custom attribute derived from HandlerAttribute which will match our type with the AttributeDrivenPolicy.

Note: The AttributeDrivenPolicy is a policy type internal to the Interception extension and is not related to the IBuilderPolicy types used by the Object Builder component.

Our last step in establishing the context for our test is to have the container create an instance of our registered type.

Next, we&#8217;ll define the behavior of our test to be observed:

<pre class="brush:csharp">protected override void Because()
{
    model.PropertyChanged += (sender, args) =&gt; { propertyChangedEventRaised = true; };
    model.TestProperty = "[any value]";
}
</pre>

Here, we establish that the model should have a public event named PropertyChanged and a public writable string member named TestProperty. When the event is fired, we&#8217;ll set a Boolean named propertyChangedEventRaised to true which we&#8217;ll test for later in our observation.

Our next step is to go ahead and create the types we&#8217;ve registered with the container and declare our propertyChangedEventRaised Boolean member:

<pre class="brush:csharp">[TestFixture]
public class When_model_property_changes
{
    IUnityContainer container;
    IModel model;
    bool propertyChangedEventRaised;

    internal interface IModel : INotifyPropertyChanged
    {
        string TestProperty { get; set; }
    }

    internal class Model : IModel
    {
        public string TestProperty { get; set; }
        public event PropertyChangedEventHandler PropertyChanged;
    }

    /** snip **/
}
</pre>

Notice that we currently have no code within the Model type to actually raise the PropertyChanged event.

Next, we need to provide the observation portion of our test:

<pre class="brush:csharp">bool propertyChangedEventRaised;

[Test]
public void Should_raise_notify_property_changed_event()
{
    Assert.That(propertyChangedEventRaised, Is.True);
}
</pre>

Running the test at this point produces the expected failure result:

<p style="text-align: center">
  <a href="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/unity_interception_nunit_fail.png"><img class="aligncenter size-full wp-image-54" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/unity_interception_nunit_fail.png" alt="" width="568" height="149" /></a>
</p>

To make the test pass, we need to configure our type to match an interception policy and provide an interception handler which will raise the

PropertyChanged event on behalf of our type. Since we&#8217;re using the default AttributeDrivenPolicy to have the interception strategies recognize our type as one to be intercepted, we need to create an attribute derived from the extension&#8217;s HandlerAttribute:

<pre class="brush:csharp">/// &lt;summary&gt;
/// This attribute is used to denote that the event is to be intercepted.
/// &lt;/summary&gt;
public class NotifyAttribute : HandlerAttribute
{
    readonly ICallHandler handler;

    public NotifyAttribute()
    {
        handler = new NotifyPropertyChangedCallHandler();
    }

    public override ICallHandler CreateHandler(IUnityContainer container)
    {
        return handler;
    }
}
</pre>

The HandlerAttribute is used by the AttributeDrivenPolicy to return an ICallHandler. The ICallHandler type encapsulates the behavior used to intercept method calls for the configured types within Unity. Here, we return a NotifyPropertyChangedCallHandler() which will intercept all call to methods adorned with our custom attribute.

Next, we create our NotifyPropertyChangedCallHandler to raise the PropertyChanged event for our property:

<pre class="brush:csharp">/// &lt;summary&gt;
/// This class handler is used in conjunction with Unity to handle INotifiyPropertyChanged
/// implementations as an aspect.
/// &lt;/summary&gt;
class NotifyPropertyChangedCallHandler : ICallHandler
{
    public int Order
    {
        get { return 0; }
        set { }
    }

    public IMethodReturn Invoke(IMethodInvocation input, GetNextHandlerDelegate getNext)
    {
        IMethodReturn result = getNext.Invoke().Invoke(input, getNext);
        MethodBase method = input.MethodBase;

        if (method.IsSpecialName && method.Name.StartsWith("set_"))
        {
            // Get the property name
            string propertyName = method.Name.Substring(4);

            // Get the private event backing field
            FieldInfo info = input.Target.GetType()
            .GetFields(BindingFlags.InstanceBindingFlags.NonPublic)
            .Where(f =&gt; f.FieldType == typeof (PropertyChangedEventHandler))
            .FirstOrDefault();

            if (info != null)
            {
                var handler = info.GetValue(input.Target) as PropertyChangedEventHandler;

                // Ensure subscriptions
                if (handler != null)
                {
                    handler.Invoke(input.Target, new PropertyChangedEventArgs(propertyName));
                }
            }
        }

        return result;
    }
}</pre>

Finally, we need to add our custom attribute to the property of our type for which we want our interception to occur:

<pre class="brush:csharp">internal class Model : IModel
{
    public event PropertyChangedEventHandler PropertyChanged;
    public string TestProperty { get; [Notify] set; }
}
</pre>

Running our test again shows that it now passes!

<p style="text-align: center">
  <a href="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/unity_interception_nunit_pass.png"><img class="aligncenter size-full wp-image-55" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/unity_interception_nunit_pass.png" alt="" width="474" height="139" /></a>
</p>
