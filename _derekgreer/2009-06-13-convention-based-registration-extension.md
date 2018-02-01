---
id: 443
title: Convention-based Registration Extension for Unity
date: 2009-06-13T07:38:00+00:00
author: Derek Greer
layout: post
guid: http://www.aspiringcraftsman.com/2009/06/convention-based-registration-extension-for-unity/
dsq_thread_id:
  - "325777995"
categories:
  - Uncategorized
tags:
  - Convention over Configuration
  - Unity
---
Inspired by [Jeremy Miller](http://codebetter.com/blogs/jeremy.miller/)’s presentation of [StructureMap](http://structuremap.sourceforge.net/Default.htm)’s convention-based type registration at this week’s [Austin .Net User’s Group](http://www.adnug.org/), I set out to create a convention-based type registration extension for the Unity container.

For those unfamiliar with the convention-based approach to type registration for IoC containers, I’ll refer you to Jeremy’s article [here](http://codebetter.com/blogs/jeremy.miller/archive/2009/01/20/create-your-own-auto-registration-convention-with-structuremap.aspx) which should get you up to speed on the concept.

Unity is fairly easy to extend, so I had the first working prototype after about 15 minutes. I spent several hours afterward, however, trying to tease out an API I felt was suitable. After a few cycles attempting to design a fluent API, I settled upon something similar to Fluent NHibernate’s mapping registration, and one which I think fits decently with Unity’s existing API.

Without further ado, here is an example of its usage:

<pre class="brush:csharp">[Concern("During setup")]
        public class When_container_configured_with_interface_impl_name_match_convention :
            Behaves_like_context_with_container_with_convention_extension
        {
            protected override void Because()
            {
                _container
                    .Using&lt;IConventionExtension&gt;()
                    .Configure(x =&gt;
                        {
                            x.Conventions.Add&lt;InterfaceImplementionNameMatchConvention&gt;();
                            x.Assemblies.Add(Assembly.GetExecutingAssembly());
                        })
                    .Register();
            }

            [Observation, Test]
            public void Types_matching_convention_should_be_auto_registered()
            {
                _container.Resolve&lt;ITestType&gt;().ShouldBeOfType(typeof (TestType));
            }
        }
</pre>

After adding the extension to the container, the IConventionExtension configuration is used to configure the conventions and assemblies used during the auto-registration process. The convention used here matches the common .Net naming convention where interface and default implementation pairs share the same name, with the interface carrying an ‘I’ prefix. The test demonstrates resolving an instance of ITestType, though no explicit registration has been provided.

The following test demonstrates using an alternate convention where only implementations of the specified type are auto-registered:

<pre class="brush:csharp">[Concern("During setup")]
        public class When_container_configured_with_implementation_convention_with_name_replacement :
            Behaves_like_context_with_container_with_convention_extension
        {
            protected override void Because()
            {
                _container
                    .Using&lt;IConventionExtension&gt;()
                    .Configure(x =&gt;
                        {
                            x.Conventions.Add&lt;ImplementationConvention&lt;IController&gt;&gt;();
                            x.Assemblies.Add(Assembly.GetExecutingAssembly());
                        })
                    .Register(x =&gt; x.Replace("Controller", ""));
            }

            [Observation, Test]
            public void Controller_types_should_be_resolvable_by_prefix_name()
            {
                _container.Resolve&lt;IController&gt;("MainView").ShouldNotBeNull();
            }

            [Observation, Test]
            public void Types_not_of_type_controller_should_not_be_resolvable()
            {
                try
                {
                    _container.Resolve&lt;ITestType&gt;();
                    throw new Exception("Type ITestType should not be resolvable.");
                }
                catch (ResolutionFailedException)
                {
                }
            }
        }
</pre>

In this example, the types are registered by name utilizing a delegate to facilitate the ability to modify the default name of the concrete type to be registered in some way. In this case, all implementations of IController are registered under the name of the concrete type, minus the “Controller” suffix.

The full extension source can be downloaded at: <http://code.google.com/p/conventionextension/>. Enjoy!
