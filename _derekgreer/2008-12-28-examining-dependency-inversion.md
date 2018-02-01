---
id: 442
title: Examining the Dependency Inversion Principle
date: 2008-12-28T16:53:00+00:00
author: Derek Greer
layout: post
guid: http://www.aspiringcraftsman.com/2008/12/examining-the-dependency-inversion-principle/
dsq_thread_id:
  - "319115864"
categories:
  - Uncategorized
tags:
  - Dependency Inversion Principle
---
## Introduction

A hallmark of good solution architecture is the degree of low-coupling between the components comprising an application. One design strategy first postulated by Robert C. Martin for decoupling components within object-oriented systems is the Dependency Inversion Principle. This article provides an introduction to this principle, considers its relationship to other software patterns and practices, and reflects on the merits of adhering to this principle.

## Overview

The Dependency Inversion Principle is defined as follows:

<p style="padding-left: 30px">
  <em>A. High-level modules should not depend upon low-level modules. Both should depend upon abstractions.</em>
</p>

<p style="padding-left: 30px">
  <em>B. Abstractions should not depend upon details. Details should depend upon abstractions.</em>
</p>

In conventional architecture, higher-level components depend upon lower-level components as depicted in the following diagram:

[<img src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/DIP1.png" alt="" width="346" height="250" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/DIP1.png)

In this diagram, component A depends upon component B, which in turn depends upon component C. Due to these dependencies, each of the higher-level components is coupled with the lower-level components.

The goal of the Dependency Inversion Principle is to decouple higher-level components from their dependency upon lower-level components. This may be achieved by creating interfaces as part of the higher-level component package which define the component’s external needs. This allows the component to be isolated from any particular implementation of the provided interface, thus increasing the component’s portability. The following diagram illustrates this relationship:

<p style="text-align: center">
  <a href="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/DIP2.png"><img class="aligncenter size-full wp-image-59" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/DIP2.png" alt="" width="425" height="447" /></a>
</p>

In this diagram, component A provides an interface which defines the services it needs. Component B satisfies this dependency by implementing the interface. The same relationship is additionally shown for components B and C. Take special note that the interfaces are packaged together with the higher-level components and are defined in terms of the higher-level component’s needs, not the lower-level component’s behavior. It is this association of the interface with the client component which logically inverts the conventional dependency flow.

In some cases, multiple higher-level components existing in separate packages share similar external dependency needs which would best be satisfied by a single lower-level component. In this case, the Dependency Inversion Principle requires that clients agree upon the desired interface which is then published in a separate package. The following diagram illustrates this relationship:

<p style="text-align: center">
  <a href="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/DIP3.png"><img class="aligncenter size-full wp-image-60" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/DIP3.png" alt="" width="570" height="456" /></a>
</p>

In this diagram, components A and B share a dependency upon a single package containing the common client interface. Component C implements this interface, thus satisfying the dependency of both higher-level components. Note again that the interface here is defined according to the shared needs of the higher-level components rather than according to the behavior provided by the lower-level component. According to the Dependency Inversion Principle, the higher-level components share the ownership of the separate interface package. While in some situations this will arguably be a nominal distinction to make, especially when all of the components are to be maintained by the same development group, this distinction logically maintains the guideline that higher-level components shouldn’t depend upon lower-level components. When the components are maintained by separate groups, this distinction may have implications on which groups are consulted if changes to the interface become necessary. Additionally, the association of the interface with the higher-level component(s) may in some cases impact the style and naming conventions used in the creation of the interface. However, when all components are maintained by the same group, this can indeed become a distinction without a difference.

The second, seemingly more peculiar aspect of the Dependency Inversion Principle is the stipulation that abstractions should not depend upon details, but rather that details should depend upon abstractions. To fully understand the motivation behind this portion of the principle, it is helpful to understand from wince this principle was derived.

The Dependency Inversion Principle was first conceived within the context of C++ development. In the C++ language, classes are typically defined using both a declaration source file and a definition source file. The declaration source files are referred to as header files and are primarily used for including the necessary class declarations required by other components at compile time. While header files provide a measured form of abstraction in C++, their purpose is not to provide separation of interface from implementation. Header files define all the public and private member functions for a class definition, as well as any member variables used by the class. Due to the fact that header files contain implementation details about the class definition, header files (i.e. the abstraction) are dependent upon the source files (i.e. the detail).

While the C++ language does not define an interface type as a first class entity (as is the case in languages such as Java and C#), it does support the notion of a pure abstract class. A pure abstract class is one which contains only abstract methods and which is devoid of any data. Through the use of pure abstract classes, interfaces can be defined to enforce contracts between components. It is the contrast between the use of header files and the use of pure abstract classes (i.e. interfaces) that is in view when the Dependency Inversion Principle advises that abstractions should not depend upon details, but that details should depend upon abstractions.

The next sections will discuss several other associated patterns and practices related to achieving low coupling between components to further aid in the understanding of the Dependency Inversion Principle.

## Dependency Inversion and Plain Ole Interfaces

One practice often confused with the Dependency Inversion Principle is the fundamental practice of programming to interfaces rather than implementations.

A fairly common description of the Dependency Inversion Principle establishes a base line example demonstrating components which are tightly coupled as
  
in the following diagram:

<p style="text-align: center">
  <a href="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/DIP4.png"><img class="aligncenter size-full wp-image-61" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/DIP4.png" alt="" width="231" height="164" /></a>
</p>

A second example is then typically shown with the introduction of an interface to decouple the dependency between the components as in the following diagram:

<p style="text-align: center">
  <a href="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/DIP5.png"><img class="aligncenter size-full wp-image-62" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/DIP5.png" alt="" width="266" height="207" /></a>
</p>

While programming to interfaces rather than implementations represents good design practice, the Dependency Inversion Principle is not merely concerned with the use of interfaces, but the decoupling of high-level components from dependency packages. All that has been demonstrated in the above example is the introduction of an abstraction to the dependency. If this abstraction is contained within the dependency package, the high-level component is still coupled to the low-level component’s package. While the conventional use of interfaces adhere to the guideline that abstractions should not depend upon details (a somewhat vestigial guideline from the perspective of languages such as Java and C#), inversion of the conventional dependency relationship is not achieved unless the high-level component defines its own interface whose implementations are defined in separate packages.

Simply stated, every case of programming to interfaces rather than implementations are not examples of the Dependency Inversion Principle.

## Dependency Inversion and the Separated Interface Pattern

The Separated Interface Pattern, defined in the book Patterns of Enterprise Application Architecture, sets forth an approach for decoupling components from the implementation details of their dependencies. This is accomplished by defining the interface of the dependency in a separate package from its implementation. One illustration given in the book for how this might be achieved places the interface within the client component package as depicted in the following diagram:

<p style="text-align: center">
  <a href="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/DIP6.png"><img class="aligncenter size-full wp-image-63" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/DIP6.png" alt="" width="281" height="287" /></a>
</p>

An alternate approach of storing the interface in its own package is also presented, and is recommended when the dependency is used by multiple clients. The following diagram depicts this organization:

<p style="text-align: center">
  <a href="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/DIP7.png"><img class="aligncenter size-full wp-image-64" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/DIP7.png" alt="" width="474" height="302" /></a>
</p>

As one might observe, these diagrams bear a striking resemblance to the structures advocated by the Dependency Inversion Principle. This similarity has led some to consider the two to be synonymous, and to a large extent they are. However, while the organization of the components set forth by each is nearly identical, slight nuances exists between the advocacy and description set forth by each approach.

First, while both have in view the decoupling of components from the implementation details of their dependencies, the Dependency Inversion Principle achieves this by assigning ownership of the interface to the higher-level component, whereas the Separated Interface pattern achieves this by separating the interface from the implementation … irrespective of any assumed package ownership.

The distinction is the level of emphasis placed by the Dependency Inversion Principle on the value in reusing higher-level components over that of lower-level components. While such an approach is facilitated by the Separated Interface pattern, no such value assignments are assumed.

Additionally, because the Dependency Inversion Principle assigns ownership of the interface to the higher-level component, it considers interfaces more closely aligned with their clients than with their implementations. The Separated Interface pattern makes no assumption on who should own the interface. In fact, the book Patterns of Enterprise Application Architecture sets forth that one reason for separating an interface into a separate package is when there is a desire for emphasizing that the development of the interface isn’t the responsibility of the client developers.

The Separated Interface pattern does set forth the option of packaging the interface with the client, especially when there is only one client, or all the clients are maintained in the same package, but this is more a matter of pragmatism than principle. In similar fashion, the Dependency Inversion Principle acknowledges situations where there may be no particular owner to an interface. This, however, is set forth more as a special case than the general prescription.

Another nuance is the level of applicability advocated by each approach. The Dependency Inversion Principle declares that higher-level components should never depend upon lower-level components. In contrast, the Separated Interface pattern advocates a more conservative approach, even advising against introducing the complexity of separating interface from implementation prematurely, favoring rather to keep interface and implementation together until a specialized need arises.

While both the Dependency Inversion Principle and the Separated Interface pattern result in nearly identical arrangements of the components involved, each approach the same problem with slightly different perspectives and advocate different levels of applicability.

## Dependency Inversion and Dependency Injection

Another practice often associated with the Dependency Inversion Principle is Dependency Injection. Dependency Injection encompasses a set of techniques for assigning the responsibility of provisioning dependencies for a component to an external source. The goal of Dependency Injection is to separate the concerns of how a dependency is obtained from the core concerns of a component.

One dependency injection technique, referred to as constructor injection, defines the dependencies of a component within its constructor which are supplied at the time of the component’s creation. A simple demonstration of this technique can be seen in the following code example where an instance of an Automobile class is obtained which has a dependency upon an Engine class:

<pre>public class Application
    {
        public void CreateAutomobile()
        {
            var automobile = new Automobile(new Engine());
        }
    }

    public class Automobile
    {
        Engine _engine;

        public Automobile(Engine engine)

        {
            _engine = engine;
        }

        // ...
    }

    public class Engine
    {
        // ...
    }</pre>

In this example, an instance of Automobile is created by passing an instance of a newly created Engine to the Automobile class constructor. This decouples how the Engine is created from the core concerns of the Automobile class. Dependency injection is typically accompanied by the use of interfaces to decouple the dependency from its implementation and is generally facilitated through an Inversion of Control framework to construct complex object graphs. The use of interfaces has been omitted here for clarity, but also to help emphasis that dependency injection is concerned with decoupling how dependencies are obtained, not the abstraction of dependencies.

The practice of dependency injection is often discussed alongside the Dependency Inversion Principle as a facilitating pattern for supplying implementations of the client interface to the client component at run time. While other patterns such as Service Locator and Plug-in can be used to facilitate the Dependency Inversion Principle, Inversion of Control in the more common solution due to its ability to decouple components from how their dependencies are obtained.

One potential stumbling block newcomers to these design approaches face is in the similarity of terms used in describing these approaches. For instance, taken at face value, the phrase “Dependency Inversion” might conjure up the idea that dependency requirements are being inverted (as in turned inside out) rather than the inversion of dependency (as in reversal) between higher-level components and lower-level components. While the former is an adequate understanding of what dependency injection is, it doesn’t describe the goal of the Dependency Inversion Principle. While certainly complimentary, how dependency implementations are obtained is orthogonal to the module dependency concerns set forth by the Dependency Inversion Principle.

Benefits and Consequences
  
The approach advocated by the Dependency Inversion Principle provides a useful option for decoupling components from their external dependencies. By following the guideline that higher-level components shouldn’t depend upon lower-level components, core functionality within an application can be more easily used in different contexts.

While applying the Dependency Inversion Principle enables higher-level components to be used in a different context, it unfortunately negatively impacts the ability to reuse lower-level components. While this may at times be an optimal compromise, it is not always the case that higher-level components possess the greatest need for decoupling.

The core business components within an application often encapsulate a rich set of behavior tailored to a specific context. While such components may be of tremendous benefit to applications requiring the same behavior, it is their specificity that tends to limit the context where reuse is possible. In contrast, lower-level components often encapsulate more generic functionality which is applicable across a wider range of contexts.

Consider for example the development of a custom logging component. Logging is generally a concern shared by many components across all applications within an enterprise. In following the Dependency Inversion Principle, the logging component would be developed to depend upon a client-owned interface package to allow higher-level components to remain decoupled from the specific logging implementation. While this enables a higher-level component to be reused without requiring the specific logging implementation, it doesn’t allow the logging component to be easily used by other applications.

While the Dependency Inversion Principle does account for the reuse of lower-level components by maintaining the client interface in a separate package, assigning ownership of this package to one or more consumers of a lower-level component can itself be problematic. In doing so, this creates a form of associative coupling between clients which may have diverging interests that affect the agreement upon, or stability of the interface contract. Additionally, the resulting contract, naming conventions, and deployment strategy may lack the objectively and elegance that might follow more naturally from assigning the ownership of the interface package to the lower-level component.

## An Alternate Approach

In considering the logging example further, an alternate approach to coupling either component package to the other is the combination of the Separated Interface pattern with the Adapter pattern to allow both higher-level and lower-level components to exist independently.

Through this approach, an interface to the dependency is maintained within the high-level component package (or in a separate package shared among two or more high-level components), but an additional adapter package is created to adapt the interface of the high-level component to that of the low-level component.

The following diagram illustrates this organization:

[<img src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/DIP8.png" alt="" width="570" height="463" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/DIP8.png)

By using a logging adapter to implement the client-owned interface, both the high-level client components and the logging component are able to remain free from dependency upon one another. While this approach dispenses with the notion of dependency inversion from the low-level component point of view, it achieves the Dependency Inversion principle’s goal of decoupling without affecting the potential reuse of lower-level components. Though this level of decoupling is certainly not necessary in every case, this technique offers a more flexible option for those wishing to maximize the level of decoupling between application and infrastructure components.
