---
id: 450
title: Interactive Application Architecture Patterns
date: 2007-08-25T19:54:00+00:00
author: Derek Greer
layout: post
guid: http://www.aspiringcraftsman.com/2007/08/interactive-application-architecture-patterns/
dsq_thread_id:
  - "315803845"
categories:
  - Uncategorized
tags:
  - Model-View-Controller
  - Model-View-Presenter
  - Presentation-Abstracton-Control
---
## Introduction

The MVC, MVP, and PAC patterns are each intended to address the needs of interactive applications by separating the concerns assigned to different components within their respective architectures. While similar, each of these patterns differs slightly in their motivations and applicability to various design goals. This article discusses each pattern along with its history and design motivations to encourage the correct understanding and application of these patterns.

In discussing architecture patterns in general, it is helpful to understand that patterns in this class are often motivated by design considerations which were formed within the context of specific development environments. As such, platform specific motivations and the pattern’s implementation details are often incorporated into the formal description of the pattern. For instance, the Model-View-Controller pattern had the primary design motivation of separating presentation from domain concerns. The division between the input and output of the application (which resulted in the concept of the Controller component), was really a byproduct of addressing complexities inherent to the host platform. Today’s development environments have come a long way in shielding developers from such complexities making divisions between device input and output at the application level unnecessary. In such environments, an application of the Model-View-Controller pattern may result in an approach which adheres to the intent of the pattern while not following its original form, or adheres to its original form without following its original intent. Within many development environments, the original goals of the Model-View-Controller pattern can be accomplished today by merely separating an application’s Forms and associated Controls from its domain model. The formalizing of a Controller for intercepting user input is unnecessary in platforms which natively provide this functionality. When attempting to follow the original form of the Model-View-Controller pattern within such development environments, the resulting architecture may fall somewhere between a strict implementation of MVC which goes against the grain of the hosting environment and an implementation which assigns different responsibilities to the original components. From this observation it can be deduced that the Model-View-Controller pattern isn&#8217;t adequately distilled into pattern language. That is to say, the components prescribed by the MVC pattern are not agnostic of the assumed development environment, and most descriptions do not make this explicit. This often results in a misappropriation of the pattern.

Another suggestion when studying and considering the use of interactive design patterns is to take the whole subject with a grain of salt. Many base patterns, such as those presented in the seminal work Design Patterns – Elements of Reusable Object-Oriented Software by Gamma, etc. al. are well distilled patterns which describe solutions to common problems in a implementation-agnostic way. Because of the nature of these patterns, scores of competing constructs aren&#8217;t generally found purporting to address the same concern. However, when entering the realm of compound patterns such as interactive application patterns, models, styles, etc., the study of such constructs can feel a bit like watching a documentary of the history of airplanes.

<p style="text-align: center">
  <a href="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/airplaneHistory.png"><img class="aligncenter size-full wp-image-185" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/airplaneHistory.png" alt="" width="592" height="293" /></a>
</p>

It’s best to think of architecture patterns as being as much in the realm of art as science. Interactive architecture patterns aren’t the computer science equivalent of Newton’s Law of Gravity. They merely represent our ever evolving attempt to apply the best approach for application development.

Finally, when considering use of these patterns remember that their application should be considered for their applicability to the problem, not so one can proudly proclaim: “I use the such-and-such pattern”. Use of design patterns should be the result of having started with a problem for which an existing pattern was known or found to be applicable, not the result of starting with a pattern for which a problem was sought out or invented in order to use the pattern.

## The Model–View-Controller Pattern

#### Overview

The Model-View-Controller pattern is a methodology for separating the concerns of an application’s domain, presentation, and user input into specialized components.

#### Origins and Motivation

The MVC pattern was originally conceived in 1978-79 by [Trygve Reenskaug](http://en.wikipedia.org/wiki/Trygve_Reenskaug "Trygve Reenskaug") and had the primary goal of providing an interface for users to manipulate multiple views of data as if working with real world entities. The pattern was first referred to as the _Thing-Model-View-Editor_ before Reenskaug and his colleges settled on the name Model-View-Controller (1). A modified version of Dr. Reenskaug’s design was later implemented as part of the [Xerox PARC](http://en.wikipedia.org/wiki/Xerox_PARC "Xerox PARC") Smalltalk-80 class library. A description of this implementation can be found in the work: _Applications Programming in Smalltalk-80(TM): How to use Model-View-Controller (MVC)_.

#### Structure

The following diagram depicts the structure of the Model-View-Controller pattern:

<p style="text-align: center">
  <a href="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/MVC1.png"><img class="aligncenter size-full wp-image-192" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/MVC1.png" alt="" width="450" height="269" /></a>
</p>

<p style="text-align: center">
  <em>Note: While some descriptions of the MVC pattern show an indirect association from the View to the Controller, the original implementation of MVC in Smalltalk-80 coupled View to Controller, and vice-versa (2).</em>
</p>

#### Components

The Model refers to the data and business functionality of the application. This is often represented by a Domain Model where objects are used to model real world entities and processes by representing their properties and behavior.

The View is the visual representation of the Model and is comprised of the screens and widgets used within an application.

The Controller is a component which responds to user input such as data entry and commands issued from a keyboard or mouse. Its responsibility is to act as a bridge between the human and the application, allowing the user to interact with the screen and data.

#### Collaborations

Within the MVC pattern, a Model-View-Controller triad exists for each object intended to be manipulated by a user.

The Model represents the state, structure, and behavior of the data being viewed and manipulated by the user. The Model contains no direct link to the View or Controller, and may be modified by the View, Controller, or other objects with the system. When notification to the View and Controller are necessary, the Model uses the [Observer Pattern](http://en.wikipedia.org/wiki/Observer_Pattern "Observer Pattern") to send a message notifying observing objects that its data has changed.

The View and Controller components work together to allow the user to view and interact with the Model. Each View is associated with a single Controller, and each Controller is associated with a single View. Both the View and Controller components maintain a direct link to the Model.

<p class="theme-note">
  Note: Within the Smalltalk-80 implementation, both the View and Controller maintained a direct link to one another, though the link from the View to the Controller was largely a byproduct of its implementation rather than an inherent part of the MVC pattern. The link was not maintained to delegate user input intercepted by the View to the Controller as is the case with the Dolphin Smalltalk Model-View-Presenter pattern to be discussed later, but was rather used by the View to initialize the controller with an instance of itself, and by a top level Controller to locate the active Controller within a View hierarchy.
</p>

The View’s responsibility can be seen as primarily dealing with output while the Controller’s responsibility can be seen as primarily dealing with input. It is the shared responsibility of both the View and the Controller to interact with the Model. The Controller interacts with the Model as the result of responding to user input, while the View interacts with the Model as the result of updates to itself. Both may access and modify data within the Model as needed.

As data is entered by the user, the Controller intercepts the user’s input and responds appropriately. Some user actions will result in interaction with the Model, such as changing data or invoking methods, while other user actions may result in visual changes to the View, such as the collapsing of menus, the highlighting of scrollbars, etc.

#### MVC Misconceptions

One common misconception about the relationship between the MVC components is that the purpose of the Controller is to separate the View from the Model. While the MVC pattern does decouple the application’s domain layer from presentation concerns, this is achieved through the Observer Pattern, not through the Controller. The Controller was conceived as a mediator between the end user and the application, not between the View and the Model.

#### Pattern Variations and Derivatives

The classic Model-View-Controller pattern is largely no longer used today in its original form, though it has given rise to a number of variations adapted to newer development platforms.
  
The next section will discuss a derivative of the pattern adapted for use with Web development.

## The Model-View-Controller Pattern for Web Applications

#### Overview

Since the advent of the Web, an analog to the original Model-View-Controller pattern has emerged for use with Web applications. Similar to the original pattern, the Web-based MVC pattern aids in separating the concerns of an application&#8217;s domain, client-side presentation, and server side input processing into specialized components.

#### Origins

The Web-based MVC pattern emerged somewhat naturally as object-oriented design was applied to the stateless nature of the HTTP protocol and HTML presentation. Web applications provide the ability to serve up dynamic content to Web clients by processing inbound HTTP requests through server-side components. As various approaches to Web development emerged, the need for processing and routing inbound requests generally led to to the creation of infrastructure code which served the same logical purpose as the original Smalltalk-80 controllers &#8230; directing the application in response to signals from an end-user. The text-based nature of HTML also led to template-based approaches to separating content from application logic, especially for localized applications. As these techniques were applied in the context of object-oriented applications, a pattern emerged similar to that of the original MVC pattern.

The pattern eventually became associated with Java&#8217;s &#8220;Model 2&#8221; architecture. From the mid to late 1990&#8217;s, Web applications were predominately developed using the Common Gateway Interface (CGI) standard. CGI applications can take the form of compiled or interpreted code and are spawned as separate processes by a Web server to process inbound HTTP requests. In 1997, Sun Microsystems published the Java Servlet 1.0 specification to improve upon CGI-based applications by processing HTTP requests as separate threads within a hosted Java Virtual Machine (JVM). In 1999, Sun further built upon their framework by introducing the Java Server Pages (JSP) 1.0 specification. Similar in concept to Microsoft&#8217;s Active Server Pages (ASP) introduced in December of 1996, Java Server Pages provided an abstraction to the creation of Servlets by enabling developers to create specialized HTML templates embedded with Java &#8220;scriptlets&#8221; which were compiled to Java Servlets when accessed. The first draft of the JSP specification included guidance for two approaches to using the new technology. The first was effectively a Model-View separation where requests were routed directly to JSPs which would in turn interact with the application&#8217;s model (&#8220;JavaBeans&#8221; in Java parlance). The second approach, recommended for more complex applications, was effectively a Model-View-Controller separation where requests were routed to Java Servlets which interacted with the model and subsequently transferred control to a JSP for rendering the view back to the browser. An updated draft of the JSP specification referred to these approaches as Model 1 and Model 2 respectively. While no association with the Smalltalk-80 MVC pattern was made within the specification, the similarity was noted in an article appearing in Java World magazine on December of the same year, stating that the Model 2 architecture could be seen as a &#8220;server-side implementation of the popular Model-View-Controller (MVC) design pattern&#8221; (17).

While introduced by Sun as the Model 2 architecture, the credit for the mainstream adoption of a Web-based Model-View-Controller pattern rightly belongs to [Craig R. McClanahan](http://en.wikipedia.org/wiki/Craig_McClanahan "Craig McClanahan") for his creation of the [Struts framework](http://web.archive.org/web/20000619020913/http://jakarta.apache.org/struts/index.html "Struts Framework") and its donation to the Apache Foundation in June of 2000. Struts was introduced as an MVC framework and became widely adopted in the Java development community upon its release as well as the catalyst for the development of a plethora of frameworks in the following years.

#### Structure

While no canonical structure exists, the following diagram is a depiction of how the MVC pattern is often adapted for Web development:

<p style="text-align: center">
  <a href="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/WebMVC.png"><img class="aligncenter size-full wp-image-193" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/WebMVC.png" alt="" width="640" height="480" /></a>
</p>

#### Components

With Web applications, a [Front Controller](http://martinfowler.com/eaaCatalog/frontController.html "Front Controller") is often introduced to handle common infrastructure concerns as well as dispatching requests to individual Controllers. This might take the form of a Servlet in Java-based applications, or an IHttpHandler in ASP.Net-based applications. Examples of common concerns handled by a Front Controller might include security, session state management, or dependency injection resolution of the handling Controller.

As with the Smalltalk-80 MVC pattern, the Model encapsulates the data and business functionality of the application and is typically represented by a Domain Model.

In Web applications, the View is the content (generally HTML and associated client-side script) returned to the Web client. Depending on the implementation, Views may be text-based templates which are rendered by a view processor, or they may be objects compiled from templates which encapsulate the content to be rendered.

Also similar to the original Smalltalk-80 MVC pattern, the Controller is a component which responds to user input. What differs is that rather than receiving signals directly from hardware devices such as the keyboard, mouse, etc., Web-based MVC Controllers process delegated HTTP requests (or information derived from the request depending upon the specific implementation).

#### Collaborations

Upon receiving an HTTP request, the Front Controller executes any common behavior and then uses information derived from the request to locate the concerned Controller. After a Controller is located, the request is delegated for further handling.

Once the Controller receives the specific request, the appropriate operations are performed upon the Model and control is transferred to the View.

Due to the fact that Web applications are stateless, Views are rendered anew upon each request. As such, the Observer Pattern is not used in the process of updating the View. To render the View with the appropriate state, the Controller makes the required state available in the form of a Model, a [Presentation Model](http://martinfowler.com/eaaDev/PresentationModel.html "Presentation Model"), or some more rudimentary form such as a bag of name/value pairs.

Depending upon the implementation, the View then renders the output stream or is parsed by a separate processor to render the output stream based upon the view state made available by the Controller.

In the following section, another derivative of the Model-View-Controller pattern will be discussed which largely resulted as an adaptation for use with the Microsoft Windows development platform. This pattern is known as the Model-View-Presenter pattern.

## The Model-View-Presenter Pattern

The Model-View-Presenter pattern is a variation on the Model-View-Controller pattern, and similarly separates the concerns of an application’s domain, presentation, and user input into specialized components.

The definition and distinctive characteristics of this pattern are not easily summarized due to the fact that there are several patterns commonly accepted under the name “Model-View-Presenter” which do not share the same distinctive qualities over their MVC predecessor. For this reason, this article will discuss the original Model-View-Presenter pattern along with some of its more popular variations and derivatives.

### The Taligent Model-View-Presenter Pattern

#### Overview

The Taligent Model-View-Presenter pattern separates the application concerns of data, data specification, data manipulation, application coordination, user interaction, and presentation into specialized components (whew, that&#8217;s a mouthful).

#### Origins and Motivation

The MVP pattern was based on the Taligent programming model, which itself was influenced by the original Smalltalk-80 MVC pattern. The pattern was first formally described by Mike Potel in 1996 while working for [Taligent, Inc.](http://en.wikipedia.org/wiki/Taligent "Taligent, Inc."). Taligent was started by Apple Computer, Inc. as a joint venture with IBM (and later joined by Hewlett Packard) before becoming the wholly owned subsidiary of IBM in late 1995. Many of the elements of the original MVP pattern began taking form at Apple under the management of [Larry Tesler](http://en.wikipedia.org/wiki/Larry_Tesler "Larry Tesler"), who formerly worked at [Xerox PARC](http://en.wikipedia.org/wiki/Xerox_PARC "Xerox PARC") where he was one of the contributors of the design and implementation of Smalltalk.

While the main elements of the pattern were already being utilized at Taligent between 1992 and 1994, it wasn’t until after Taligent, Inc. was purchased by IBM in 1995 that Mike Potel first suggested the name “Model-View-Presenter” to describe the architecture found within the Taligent programming model. Dr. Potel credits Arn Schaeffer, Dave Anderson, and David Goldsmith as leading contributors to the Taligent programming model from which the MVP pattern was derived (3).

#### Structure

The following diagram depicts the structure of the Taligent Model-View-Presenter pattern:

<p style="text-align: center">
  <a href="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/TaligentMVP.png"><img class="aligncenter size-full wp-image-194" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/TaligentMVP.png" alt="" width="567" height="397" /></a>
</p>

#### Components

The Model refers to the data and business functionality of the application.

Selections are components which specify what portion of the data within the Model is to be operated upon. Examples would be selections which define rows, columns, or individual elements which meet specific criteria.

Commands are components which define the operations which can be performed on the data. Examples might be deleting, printing, or saving data within the Model.

The View is the visual representation of the Model and is comprised of the screens and widgets used within an application.

Interactors are components which address how user events are mapped onto operations performed on the Model, such as mouse movements, keyboard input, and the selection of checkboxes or menu items.

The Presenter is a component which orchestrates the overall interaction of the other components within the application. Its roles include the creation of the appropriate Models, Selections, Commands, Views, and Interactors, and directing the workflow within the application.

#### Collaborations

The most notable collaborative differences between the Taligent Model-View-Presenter pattern and the Model-View-Controller pattern are found within the Presenters and Interactors.

The Presenter acts as an overall manager for a particular subsystem within an application. It maintains the lifecycle and relationships between the Views, Interactors, Commands, Selections, and Model. The responsibility for intercepting user events is governed by Interactors; therefore Presenters are not needed for each widget on a given View as were Smalltalk-80 Controllers. There is generally a single Presenter per View, though in some cases a Presenter may manage multiple logically related Views.

Interactors are somewhat analogous to Smalltalk-80 Controllers. They are the components which respond to user events and in turn call the appropriate Commands and Selections of the Model.

### The Dolphin Smalltalk Model-View-Presenter Pattern

#### Overview

The Dolphin Smalltalk Model-View-Presenter pattern separates an application’s concerns of domain, presentation, and presentation logic into the specialized components of Model, View, and Presenter. The Dolphin Smalltalk team simplified the Taligent MVP pattern by eliminating Interactors, Commands, and Selections from the pattern’s formal description. This in turn simplified the role of the Presenter, changing it from a subsystem controller to a component which mediated updates to the Model on behalf of the View.

#### Origins and Motivation

The Dolphin Smalltalk Model-View-Presenter pattern was adapted from the Taligent Model-View-Presenter pattern to address flexibility issues the Dolphin development team was having in its approach to view/domain separation. One of the team’s early considerations included a variation on the MVC pattern used by ParcPlace Systems’ VisualWorks. While the Dolphin team considered the VisualWorks MVC design initially, they later became disenchanted with its prescribed Application Model whose complexity at times tempted developers to allow the model to access the view directly. They also found that the MVC concept of a Controller, whose primary purpose was to respond to user events, didn’t mesh well with more current development platforms whose native widgets handled user events directly. After encountering the Taligent MVP pattern, the Dolphin team concluded it was more applicable for achieving their design goals. While they saw benefits in the Taligent MVP pattern, they mistakenly believed that Taligent derived their pattern from the VisualWorks’ MVC implementation and had eliminated the use of an Application Model by moving presentation logic concerns from the Model to the Presenter. They described this as “Twisting the Triad”, though this does not accurately portray the differences between the Taligent MVP pattern and the original Smalltalk-80 MVC pattern. Due to this misunderstanding, they viewed the Presenter component as being a replacement of the Application Model within VisualWorks’ MVC rather than an evolution of the Controller component within the Smalltalk-80 MVC. The resulting pattern implemented by the Dolphin Smalltalk team was void of most of the components which gave the original MVP its distinctiveness from MVC, though it introduced distinctive qualities of its own.

#### Structure

The following diagram depicts the structure of the Dolphin Smalltalk Model-View-Presenter pattern:

<p style="text-align: center">
  <a href="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/MVP.png"><img class="aligncenter size-full wp-image-195" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/MVP.png" alt="" width="451" height="270" /></a>
</p>

#### Components

The Model refers to the data and business functionality of the application.

The View is the visual representation of the Model and is comprised of the screens and widgets used within an application.

The Presenter is a component which contains the presentation logic which interacts with the Model.

#### Collaborations

Within the Dolphin MVP pattern, Views intercept the initial user events generated by the operating system. This choice was primarily the result of development on the Microsoft Windows operating system whose native widgets already handled most controller functionality. In a few cases the View responded to user events by updating the Model directly, but in most cases user events were delegated to the Presenter. Implied by the Dolphin Smalltalk description is that Views only delegated events when updates to the Model were required, thus leaving all other presentation logic within the View.

As with the Taligent MVP pattern, there is usually a single Presenter which handles updates to the Model for a specific View.

As with the Model-View-Controller pattern, the View is notified of any changes to the Model using the Observer Pattern and responds by updating the relevant portions of the screen.

#### Dolphin Smalltalk MVP vs. Smalltalk-80 MVC

On the surface, the differences between the Dolphin Smalltalk MVP pattern and the Smalltalk-80 MVC pattern are difficult to discern. Both of the patterns contain a triad. Both of the patterns contain a Model and View which are virtually identical in function. Both the Smalltalk-80 Controller and the Dolphin Smalltalk Presenter are involved in updating the Model. Both of the patterns use the Observer Pattern to update the View when changes occur to the Model. With all these similarities, it is clear why so much confusion surrounds understanding how the Model-View-Presenter pattern sets itself apart from the Model-View-Controller pattern. The key is in understanding the primary functions which Presenters and Controllers play within their respective triads.

Within the original Model-View-Controller pattern, the primary purpose of the Controller was to intercept user input. The Controller’s role of updating the Model was largely a byproduct of this function rather than an inherent part of its purpose.

Conversely, within the Dolphin Smalltalk Model-View-Presenter pattern, the primary purpose of the Presenter was to update the Model. The Presenter’s role of intercepting events delegated by the View was largely a byproduct of this function rather than an inherent part of its purpose.

Part of the original idea leading to the development of the MVC pattern was a separation between the representation of a user’s mental idea of the data (i.e. the Model), and the logic which allowed the user to interact with that representation (i.e. the Editor). This was considered Model/Editor separation (4). Because the tasks involved in displaying data on the screen were technically very different from the tasks involved in interpreting the user’s input from devices such as the keyboard and the mouse, the combination of these tasks into a single object resulted in unnecessary complexity. Therefore, the concerns of input and output were separated into Views and Controllers. Because Controllers were assigned the input responsibility of the Editor, it naturally followed that they took on the responsibility of updating the Model when input was received from the user.

Within the Dolphin Smalltalk MVP pattern, the role of intercepting the user’s input was moved to the View. This effectively eliminated the original need for Controllers or Interactors altogether. While the original idea of the Presenter was seen by the Taligent team as a Controller elevated to an application level, the Dolphin team mistakenly considered it a replacement of the VisualWorks’ Application Model and maintained the Presenter as a mediating component within the triad.

So then, while the Dolphin Smalltalk MVP and the Smalltalk-80 MVC patterns may appear similar on the surface, Presenters and Controllers differ in the purposes they were conceived to address.

### The Fowler Patterns

During his research and preparation of material on presentation layer patterns in 2006 for an upcoming book, Martin Fowler decided that the treatment given to the design intensions behind today’s use of the Model-View-Presenter pattern be divided under the names Supervising Controller and Passive View. This distinction was made around the level of responsibility the Presenter/Controller component of the pattern takes on for presentation layer logic.

The Supervising Controller and Passive View patterns are well distilled constructs which deal with the concerns of presentation logic apart from any specific domain logic strategy. This distilment renders patterns which describe solutions not specific to the Model-View-Presenter pattern, and are an excellent example of how patterns come about. While discussed here within the context of the Model-View-Presenter pattern, these patterns are best understood as facilitating patterns (as with the Observer Pattern) rather than variations of the Model-View-Presenter pattern.

### The Supervising Controller Pattern

#### Overview

The Supervising Controller pattern separates an application’s concerns of presentation and presentation logic into the specialized components of View and Controller, with the View assigned the responsibility of simple presentation logic and the Controller assigned the responsibilities of responding to user input and handling complex presentation logic.

#### Structure

The following diagram depicts the structure of the Supervising Controller pattern:

<p style="text-align: center">
  <a href="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/SupervisingController.png"><img class="aligncenter size-full wp-image-196" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/SupervisingController.png" alt="" width="451" height="270" /></a>
</p>

<p style="text-align: center">
  <em>Note: The model is shown with reduced emphasis to denote its peripheral role to the pattern description.</em>
</p>

#### Components

The View is the visual components used within an application such as screens and widgets.

The Controller is a component which processes user events and the complex presentation logic within an application.

#### Collaborations

Within the Supervising Controller pattern, Views delegate user events to the Controller which in turn interacts with the business domain of the application.

For simple presentation logic, the View uses data binding techniques and the Observer Pattern to update itself when changes occur within the application.

Complex presentation logic, particularly any logic one desires to unit test, is delegated to the Presenter.

### The Passive View Pattern

#### Overview

The Passive View pattern separates an application’s concerns of presentation and presentation logic into the specialized components of View and Controller, with the Controller taking on the responsibility for responding to user events and presentation logic.

#### Structure

The following diagram depicts the structure of the Passive View pattern:

<p style="text-align: center">
  <a href="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/PassiveView.png"><img class="aligncenter size-full wp-image-197" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/PassiveView.png" alt="" width="451" height="270" /></a>
</p>

<p style="text-align: center">
  <em>Note: The model is shown with reduced emphasis to denote its peripheral role to the pattern description.</em>
</p>

#### Components

The View is the visual components used within an application such screens and widgets.

The Controller is a component which processes user events and the presentation logic within an application.

#### Collaborations

Within the Passive View pattern, Views delegate user events to the Controller which in turn interacts with the business domain of the application and/or updates the View. The View maintains no link to the domain layer and relies solely on the Controller for all presentation related logic.

Controllers within this pattern take on a mediating role between the Views and domain logic strategy used. This formalizes a role often erroneously ascribed to Controllers within the Model-View-Controller pattern.

## The Presentation-Abstraction-Control Pattern

#### Overview

The Presentation-Abstraction-Control pattern is an architecture which separates the concerns of an application into a hierarchy of cooperating components, each of which are comprised of a Presentation, Abstraction, and Control. The PAC pattern seeks to decompose an application into a hierarchy of abstractions, and to achieve a consistent framework for constructing user interfaces at any level of abstraction within the application.

#### Origins and Motivation

The PAC pattern was conceived by Joëlle Coutaz in 1987. The goal of the pattern was to provide a model for developing interactive applications which bridges the gap between theoretical models for human/computer interaction and the practical concerns of building user interfaces. The original pattern description can be found in the publication: “PAC, and Object Oriented Model for Dialog Design”.

In her article, Coutaz sets forth that the PAC model more closely follows the cognitive organization of human knowledge. That is to say, the human mind doesn’t perceive the world in layers, but rather in an interconnected web of abstract ideas.

#### Structure

The following diagram depicts the structure of the Presentation-Abstraction-Control pattern:

<p style="text-align: center">
  <a href="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/PAC.png"><img class="aligncenter size-full wp-image-198" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/02/PAC.png" alt="" width="608" height="239" /></a>
</p>

#### Components

The Presentation is the visual representation of a particular abstraction within the application. It is responsible for defining how the user interacts with the system.

The Abstraction is the business domain functionality within the application.

The Control is a component which maintains consistency between the abstractions within the system and their presentation to the user in addition to communicating with other Controls within the system.

Note: Later descriptions generally use the term “agent” to describe each Presentation-Abstraction-Control triad.

#### Collaborations

Conceptually, the Presentation-Abstraction-Control pattern approaches the organization of an application as a hierarchy of subsystems rather than layers of responsibility (e.g. Presentation Layer, Domain Layer, Resource Access Layer, etc.). Each system within the application may depend on zero or more subsystems to accomplish its function. Each subsystem presents a finer grained view of an aspect of the overall system. By organizing systems into a hierarchy of subsystems, each of which are composed of the same PAC components, any level of granularity of the system can be inspected while maintaining the same architectural model.

While interaction between the user and the application occurs through the Presentation components, interaction within the Presentation-Abstraction-Control pattern is accomplished exclusively through the Control element of each triad. The Control exists to bridge the gap between the presentation and the abstraction and maintains extensive knowledge about both components (6). Its responsibilities include updating the view, accessing the abstraction, maintaining state, thread management, flow control, and interaction with parent and child Controls.

There exists no direct link between the Presentation and Abstraction within a PAC object (7).

#### Pattern Variations and Derivatives

From 1989 through 1995, the Commission of the European Communities funded two Human Computer Interface research projects under the names Amodeus and Amodeus-2 (8). Amodeus was an acronym for “Assimilating Models of Designers, Users and Systems”. During Amodeus-2, a researcher named Laurence Nigay, working under the supervision of Joëlle Coutaz, created the PAC-Amodeus Model. PAC-Amodeus is a model which blends the software components advocated by the Arch Model and the multi-agent model prescribed by the Presentation-Abstraction-Control pattern (9). The Arch Model was proposed by Len Bass at a UIMS Tool Developers’ Workshop in 1991 as a way to accommodate rapidly changing UI requirements (10) and itself was a derivative of the Seeheim Model developed in 1985. In many ways the Arch Model was similar to the Taligent Model which was to follow only a few years later. It prescribed a central Dialog Controller which mediated the interaction between the presentation and domain layer components, and used explicit components to define the interaction between the controller, presentation, and domain components. While the Arch Model prescribed specific components to accomplish its goal of flexibility and reuse, the underlying principle at work was its adherence to a layered organization of the application. While PAC provided a highly organized and uniform pattern for decomposing the tasks performed by an application, its insistence on a homogeneous design led to tightly coupled components which were difficult to maintain and reuse. The benefits of the layered approach were appreciated in the Arch Model, but the prescribed Dialog Controller was seen as too vague and all encompassing. It was therefore decided to use the Arch Model as the foundational model, but organize the tasks accomplished by the Dialog Controller into a series of PAC agents whose Presentation and Abstraction components mapped into other layered components within the Arch Model.

Another derivative of PAC, by way of PAC-Amodeus, is PAC\*. PAC\* was developed by Gaelle Calvary, Laurence Nigay, and Joëlle Coutaz around 1997 (11). PAC* follows the PAC-Amodeus style of using the Arch Model as the base architecture with a dialog controller organized as PAC agents, but also incorporates concepts found within a model named Dewan’s Generic Architecture for addressing layer replication within multi-user applications.

Full discussions of the PAC-Amodeus and PAC\* are beyond the scope of this article, but a good summary of the Seeheim, Arch, PAC, PAC-Amodeus, and PAC\* models among others can be found in a technical report by W. Greg Phillips entitled: “Architectures for Synchronous Groupware”.

Another pattern worthy of note is the Hierarchical-Model-View-Controller pattern. While not a direct derivative of the PAC family of patterns, the HMVC pattern is often associated with PAC due to its similarities. The HMVC pattern was first described in an article which appeared in JavaWorld Magazine in July of 2000. Developed by Jason Cai, Ranjit Kapila and Gaurav Pal, the HMVC pattern is a prescription for organizing Model-View-Controller triads into a hierarchy for organizing the presentation layer of a rich client application such as Java Swing applications. While its organization of MVC triads into a hierarchy is similar to PAC, it differs in that Model and View components maintain the same observer relationship as within MVC, and more notably that it seeks only to address the presentation layer of an application rather than addressing the entire application architecture. While derived from the Model-View-Controller pattern, Controllers within the HMVC pattern are described as fulfilling a mediating role within the triad similar to the Supervising Controller pattern. Views receive the initial events generated by the user and decide which actions to delegate to the Controller. For this reason, the HMVC pattern is more similar to the Dolphin MVP pattern than with either the original Model-View-Controller or Presentation-Abstraction-Control patterns.

## Pattern Comparisons

The following chart presents a quick comparison of the components represented in the various patterns presented in this article with a brief description of its role within the architecture.

<div class="theme-table">
  <table>
    <tr>
      <th>
        Pattern
      </th>
      
      <th>
        Domain
      </th>
      
      <th>
        Presentation
      </th>
      
      <th>
        Control
      </th>
    </tr>
    
    <tr>
      <td>
        Smalltalk-80 Model-View-Controller
      </td>
      
      <td>
        Model &#8211; domain objects within an application
      </td>
      
      <td>
        View- Visual presentation to the user
      </td>
      
      <td>
        Controller &#8211; human to Model connector; Intercepts user input
      </td>
    </tr>
    
    <tr>
      <td>
        Taligent Model-View-Presenter
      </td>
      
      <td>
        Same as above
      </td>
      
      <td>
        Same as above
      </td>
      
      <td>
        Presenter &#8211; subsystem component connector; manages application subsystems
      </td>
    </tr>
    
    <tr>
      <td>
        Dolphin Model-View-Presenter
      </td>
      
      <td>
        Same as above
      </td>
      
      <td>
        Same as above
      </td>
      
      <td>
        Presenter &#8211; presentation to domain connector; manages access to Model updates
      </td>
    </tr>
    
    <tr>
      <td>
        Passive View
      </td>
      
      <td>
        N/A
      </td>
      
      <td>
        Same as above
      </td>
      
      <td>
        Controller – manages presentation logic
      </td>
    </tr>
    
    <tr>
      <td>
        Supervising Controller
      </td>
      
      <td>
        N/A
      </td>
      
      <td>
        Same as above
      </td>
      
      <td>
        Controller &#8211; assists with presentation logic
      </td>
    </tr>
    
    <tr>
      <td>
        Presentation-Abstraction-Control
      </td>
      
      <td>
        Abstraction &#8211; domain objects within an application
      </td>
      
      <td>
        Presentation – interactive component within the application
      </td>
      
      <td>
        Control &#8211; Presentation to Abstraction connector
      </td>
    </tr>
  </table>
</div>

</br>

## Conclusion

The Model-View-Controller, Model-View-Presenter, and Presentation-Abstraction-Control patterns are similar in many ways, but have each evolved to address slightly different concerns. By becoming familiar with these patterns and other related architecture models, developers and architects will be better equipped in choosing an appropriate solution in their next design endeavor, or possibly in the creation of future architecture design patterns.

## References

1. Reenskaug, Trygve. The original MVC reports. Trygve Reenskaug Home Page. [Online] May 12, 1979. [Cited: July 07, 2007.] http://heim.ifi.uio.no/~trygver/2007/MVC_Originals.pdf.

2. Steve Burbeck, Ph. D. Applications Programming in Smalltalk-80(TM): How to use Model-View-Controller (MVC). The UIUC Smalltalk Archive. [Online] March 4, 1997. [Cited: July 7, 2007.] http://st-www.cs.uiuc.edu/users/smarch/st-docs/mvc.html.

3. Potel, Mike. [interv.] Derek Greer. July 18, 2007.

4. Reenskaug, Trygve. The Model-View-Controller (MVC) Its Past and Present. Trygve Reenskaug Home Page. [Online] August 20, 2003. [Cited: July 7, 2007.] http://heim.ifi.uio.no/~trygver/2003/javazone-jaoo/MVC_pattern.pdf.

5. Fowler, Martin. Patterns of Enterprise Application Architecture . s.l. : Addison-Wesley Professional, 2002. 978-0321127426.

6. PAC, an Object Oriented Model for Dialog Design. Coutaz, Joëlle. [ed.] H-J. Bullinger and B. Shackel. North-Holland : Elsevier Science Publishers, 1987. Interact&#8217;87.

7. Calvary, Gaëlle, Coutaz, Joëlle and Nigay, Laurence. From Single-User Architectural Design to PAC*: a Generic Software Architecture Model for CSCW. [http://www1.acm.org/sigs/sigchi/chi97/proceedings/paper/jcc.htm] Grenoble, France : s.n., 1997.

8. AMODEUS-2 &#8211; Multidisciplinary HCI Modelling. http://kmi.open.ac.uk. [Online] 1997. [Cited: August 20, 2007.] http://kmi.open.ac.uk/people/sbs/amodeus.html.

9. Nigay, L. and Coutaz, J. Software Architecture Modelling: Bridging Two Worlds Using Ergonomics and Software Properties. http://iihm.imag.fr/. \[Online\] \[Cited: August 20, 2007.\] Software Architecture Modelling: Bridging Two Worlds Using Ergonomics and Software Properties.

10. Sheppard, Sylvia. REPORT ON THE CHI &#8217;91 UIMS TOOL DEVELOPERS&#8217; WORKSHO P. SIGCHI Bulletin. January 1992, Vol. 24, 1.

11. Coutaz, Joëlle. Correspondance with Joëlle Coutaz. [Email]. August 20, 2007.

12. Fowler, Martin. GUI Architectures. www.martinfowler.com. [Online] July 18, 2006. [Cited: July 03, 2007.] http://www.martinfowler.com/eaaDev/uiArchs.html.

13. —. Supervising Controller. www.martinfowler.com. [Online] June 19, 2006. [Cited: July 03, 2007.] http://www.martinfowler.com/eaaDev/SupervisingPresenter.html.

14. —. Passive View. www.martinfowler.com. [Online] July 18, 2006. [Cited: July 3, 2007.] http://www.ibm.com/developerworks/java/library/j-mvp.html.

15. Potel, Mike. MVP: Model-View-Presenter &#8211; The Taligent Programming Model for C++ and Java. www.wildcrest.com. [Online] 1996. [Cited: July 15, 2007.] http://www.wildcrest.com/Potel/Portfolio/mvp.pdf.

16. Phillips, W. Greg. Architectures for Synchronous Groupware. Kingston, Ontario, Canada : s.n., May 6, 1999. ISSN 0836-0227-1999-425. 17. A metamodel for the runtime architecture of an interactive system: the UIMS tool developers workshop. 1, New York, NY : ACM Press, January 1992, ACM SIGCHI Bulletin, Vol. 24, pp. 32-37. ISSN 0736-6906.

17. —. Understanding JavaServer Pages Model 2 architecture. www.javaworld.com. [Online] December 29, 1999. [Cited: February 8, 2010.] http://www.javaworld.com/javaworld/jw-12-1999/jw-12-ssj-jspmvc.html.
