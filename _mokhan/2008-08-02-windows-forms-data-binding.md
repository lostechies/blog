---
wordpress_id: 4559
title: Windows Forms Data Binding
date: 2008-08-02T04:36:34+00:00
author: Mo Khan
layout: post
wordpress_guid: /blogs/mokhan/archive/2008/08/01/windows-forms-data-binding.aspx
categories:
  - Windows Forms
redirect_from: "/blogs/mokhan/archive/2008/08/01/windows-forms-data-binding.aspx/"
---
A couple of weeks ago, [Adam](http://www.linkedin.com/pub/3/933/425) and I were pairing on a new screen in a windows forms application. He started showing me some stuff that he had learned about windows forms data bindings. I showed him a little bit of what [JP](http://jpboodhoo.com) tried to teach me, back in the [Austin Nothin&#8217; But .NET boot camp](http://blog.jpboodhoo.com/NothinButNetAustinRecap.aspx), about Expressions and we decided to try a different way of binding domain object to screen elements in our application. The following is a method on the view that&#8217;s invoked from a presenter. It&#8217;s given an object from our model to display. 

<pre><span>public</span> <span>void</span> Display(<span>IActionPlan</span> actionPlan)
        {
            <span>Create
</span>                .BindingFor(actionPlan)
                .BindToProperty(a =&gt; a.RecommendedAction)
                .BoundToControl(uxRecommendedAction);

            <span>Create
</span>                .BindingFor(actionPlan)
                .BindToProperty(a =&gt; a.AccountablePerson)
                .BoundToControl(uxAccoutablePerson);

            <span>Create
</span>                .BindingFor(actionPlan)
                .BindToProperty(a =&gt; a.EstimatedCompletionDate)
                .BoundToControl(uxEstimatedCompletionDate);

            <span>Create
</span>                .BindingFor(actionPlan)
                .BindToProperty(a =&gt; a.EstimatedStartDate)
                .BoundToControl(uxEstimatedStartDate);

            <span>Create</span>.BindingFor(actionPlan)
                .BindToProperty(a =&gt; a.RequiredResources)
                .BoundToControl(uxResourcesRequired);

            <span>Create</span>.BindingFor(actionPlan)
                .BindToProperty(a =&gt; a.Priority)
                .BoundToControl(uxPriority);
        }</pre>

Each of our controls are prefixed with "ux". What we did was bind different types of controls to property&#8217;s on the object to display. This immediately changed that state of the object as the user filled out information on the screen. The BindToPropery() method is given the property on the object to bind too. The following was the implementation we came up with.

<pre><span>public</span> <span>static</span> <span>class</span> <span>Create
</span>    {
        <span>public</span> <span>static</span> <span>IBinding</span>&lt;T&gt; BindingFor&lt;T&gt;(T object_to_bind_to)
        {
            <span>return</span> <span>new</span> <span>ControlBinder</span>&lt;T&gt;(object_to_bind_to);
        }
    }</pre>

[](http://11011.net/software/vspaste)

<pre><span>public</span> <span>interface</span> <span>IBinding</span>&lt;TypeToBindTo&gt;
    {
        <span>IBinder</span>&lt;TypeToBindTo&gt; BindToProperty&lt;T&gt;(<span>Expression</span>&lt;<span>Func</span>&lt;TypeToBindTo, T&gt;&gt; property_to_bind_to);
    }</pre>

[](http://11011.net/software/vspaste)

<pre><span>public</span> <span>interface</span> <span>IBinder</span>&lt;TypeOfDomainObject&gt;
    {
        <span>string</span> NameOfTheProperty { <span>get</span>; }
        TypeOfDomainObject InstanceToBindTo { <span>get</span>; }
    }</pre>

The implementation of the BindToProperty method takes in an input argument of type Expression<Func<TypeOfDomainObject>>. This allows us to inspect the expression to parse out the name of the property the binding is for. It&#8217;s like treating code as data. The IControlBinder implements two interfaces. One that&#8217;s issued to client components (IBinding) which restricts what they can do with the type. (see above in the Create class) The second interface exposes enough information for extension methods to pull from to build bindings for specific windows forms controls.

<pre><span>public</span> <span>interface</span> <span>IControlBinder</span>&lt;TypeToBindTo&gt; : <span>IBinding</span>&lt;TypeToBindTo&gt;, <span>IBinder</span>&lt;TypeToBindTo&gt;
    {
    }

    <span>public</span> <span>class</span> <span>ControlBinder</span>&lt;TypeOfDomainObject&gt; : <span>IControlBinder</span>&lt;TypeOfDomainObject&gt;
    {
        <span>public</span> ControlBinder(TypeOfDomainObject instance_to_bind_to)
        {
            InstanceToBindTo = instance_to_bind_to;
        }

        <span>public</span> <span>IBinder</span>&lt;TypeOfDomainObject&gt; BindToProperty&lt;TypeOfPropertyToBindTo&gt;(
            <span>Expression</span>&lt;<span>Func</span>&lt;TypeOfDomainObject, TypeOfPropertyToBindTo&gt;&gt; property_to_bind_to)
        {
            <span>var</span> expression = property_to_bind_to.Body <span>as</span> <span>MemberExpression</span>;
            NameOfTheProperty = expression.Member.Name;
            <span>return</span> <span>this</span>;
        }

        <span>public</span> <span>string</span> NameOfTheProperty { <span>get</span>; <span>private</span> <span>set</span>; }

        <span>public</span> TypeOfDomainObject InstanceToBindTo { <span>get</span>; <span>private</span> <span>set</span>; }
    }</pre>

The BoundToControl overloads were put into extension methods, allowing others to create new implementations of bindings without having to modify the Control binder itself. The extension methods&#8230;.

[](http://11011.net/software/vspaste)

<pre><span>public</span> <span>static</span> <span>class</span> <span>ControlBindingExtensions</span> {
        <span>public</span> <span>static</span> <span>IControlBinding</span> BoundToControl&lt;TypeOfDomainObject&gt;(
            <span>this</span> <span>IBinder</span>&lt;TypeOfDomainObject&gt; binder,
            <span>TextBox</span> control) {
            <span>var</span> property_binder = <span>new</span> <span>TextPropertyBinding</span>&lt;TypeOfDomainObject&gt;(
                control,
                binder.NameOfTheProperty,
                binder.InstanceToBindTo);
            property_binder.Bind();
            <span>return</span> property_binder;
        }

        <span>public</span> <span>static</span> <span>IControlBinding</span> BoundToControl&lt;T&gt;(<span>this</span> <span>IBinder</span>&lt;T&gt; binder, <span>RichTextBox</span> box1) {
            <span>var</span> property_binder = <span>new</span> <span>TextPropertyBinding</span>&lt;T&gt;(box1,
                                                             binder.NameOfTheProperty,
                                                             binder.InstanceToBindTo);
            property_binder.Bind();
            <span>return</span> property_binder;
        }

        <span>public</span> <span>static</span> <span>IControlBinding</span> BoundToControl&lt;T&gt;(<span>this</span> <span>IBinder</span>&lt;T&gt; binder, <span>ComboBox</span> box1) {
            <span>var</span> property_binder = <span>new</span> <span>ComboBoxBinding</span>&lt;T&gt;(box1,
                                                         binder.NameOfTheProperty,
                                                         binder.InstanceToBindTo);
            property_binder.Bind();
            <span>return</span> property_binder;
        }

        <span>public</span> <span>static</span> <span>IControlBinding</span> BoundToControl&lt;T&gt;(<span>this</span> <span>IBinder</span>&lt;T&gt; binder, <span>DateTimePicker</span> box1) {
            <span>var</span> property_binder = <span>new</span> <span>DatePickerBinding</span>&lt;T&gt;(box1,
                                                           binder.NameOfTheProperty,
                                                           binder.InstanceToBindTo);
            property_binder.Bind();
            <span>return</span> property_binder;
        }
    }</pre>

For completeness&#8230; the control bindings&#8230;

<pre><span>public</span> <span>class</span> <span>TextPropertyBinding</span>&lt;TypeToBindTo&gt; : <span>IControlBinding</span> {
        <span>private</span> <span>readonly</span> <span>Control</span> control_to_bind_to;
        <span>private</span> <span>readonly</span> <span>string</span> name_of_the_propery_to_bind;
        <span>private</span> <span>readonly</span> TypeToBindTo instance_of_the_object_to_bind_to;

        <span>public</span> TextPropertyBinding(
            <span>Control</span> control_to_bind_to,
            <span>string</span> name_of_the_propery_to_bind,
            TypeToBindTo instance_of_the_object_to_bind_to
            ) {
            <span>this</span>.control_to_bind_to = control_to_bind_to;
            <span>this</span>.name_of_the_propery_to_bind = name_of_the_propery_to_bind;
            <span>this</span>.instance_of_the_object_to_bind_to = instance_of_the_object_to_bind_to;
        }

        <span>public</span> <span>void</span> Bind() {
            control_to_bind_to.DataBindings.Clear();
            control_to_bind_to.DataBindings.Add(
                <span>"Text"</span>,
                instance_of_the_object_to_bind_to,
                name_of_the_propery_to_bind);
        }
    }</pre>

[](http://11011.net/software/vspaste)

<pre><span>public</span> <span>class</span> <span>ComboBoxBinding</span>&lt;TypeToBindTo&gt; : <span>IControlBinding</span> {
        <span>private</span> <span>readonly</span> <span>ComboBox</span> control_to_bind_to;
        <span>private</span> <span>readonly</span> <span>string</span> name_of_the_propery_to_bind;
        <span>private</span> <span>readonly</span> TypeToBindTo instance_of_the_object_to_bind_to;

        <span>public</span> ComboBoxBinding(<span>ComboBox</span> control_to_bind_to,
                               <span>string</span> name_of_the_propery_to_bind,
                               TypeToBindTo instance_of_the_object_to_bind_to) {
            <span>this</span>.control_to_bind_to = control_to_bind_to;
            <span>this</span>.name_of_the_propery_to_bind = name_of_the_propery_to_bind;
            <span>this</span>.instance_of_the_object_to_bind_to = instance_of_the_object_to_bind_to;
        }

        <span>public</span> <span>void</span> Bind() {
            control_to_bind_to.SelectedIndexChanged +=
                <span>delegate</span> {
                    <span>typeof</span> (TypeToBindTo)
                        .GetProperty(name_of_the_propery_to_bind)
                        .SetValue(
                        instance_of_the_object_to_bind_to,
                        control_to_bind_to.Items[control_to_bind_to.SelectedIndex],
                        <span>null</span>);
                };
        }
    }</pre>

[](http://11011.net/software/vspaste)

<pre><span>public</span> <span>class</span> <span>DatePickerBinding</span>&lt;TypeToBindTo&gt; : <span>IControlBinding</span> {
        <span>private</span> <span>readonly</span> <span>DateTimePicker</span> control_to_bind_to;
        <span>private</span> <span>readonly</span> <span>string</span> name_of_the_propery_to_bind;
        <span>private</span> <span>readonly</span> TypeToBindTo instance_of_the_object_to_bind_to;

        <span>public</span> DatePickerBinding(<span>DateTimePicker</span> control_to_bind_to,
                                 <span>string</span> name_of_the_propery_to_bind,
                                 TypeToBindTo instance_of_the_object_to_bind_to) {
            <span>this</span>.control_to_bind_to = control_to_bind_to;
            <span>this</span>.name_of_the_propery_to_bind = name_of_the_propery_to_bind;
            <span>this</span>.instance_of_the_object_to_bind_to = instance_of_the_object_to_bind_to;
        }

        <span>public</span> <span>void</span> Bind() {
            control_to_bind_to.DataBindings.Clear();
            control_to_bind_to.DataBindings.Add(
                <span>"Value"</span>,
                instance_of_the_object_to_bind_to,
                name_of_the_propery_to_bind);
        }
    }</pre>

We found that using the fluent interface for creating bindings was pretty easy and made screen synchronization a breeze, however, our implementation wasn&#8217;t the easiest thing to test. So far it&#8217;s been good to us. 

As a side note&#8230; go [register for the Las Vegas course](http://www.jpboodhoo.com/training.oo), it may cause you to love your job! Also, if you&#8217;ve already attended a boot camp, and you think you already know what the course is about, you have no idea, it keeps getting [better](http://mokhan.ca/blog/2007/11/13/Photos+From+The+Nothin+But+NET+Boot+Camp.aspx) and [better](http://mokhan.ca/blog/2008/04/14/Nothin+But+NET+Retrospective+Austin+Texas+Style.aspx).