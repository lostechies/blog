---
wordpress_id: 438
title: Five rules for writing effective UI tests
date: 2010-10-06T03:34:40+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2010/10/05/five-rules-for-writing-effective-ui-tests.aspx
dsq_thread_id:
  - "264934531"
categories:
  - Testing
redirect_from: "/blogs/jimmy_bogard/archive/2010/10/05/five-rules-for-writing-effective-ui-tests.aspx/"
---
For about 3 years, I wrote absolutely horrible UI tests.&#160; These tests worked great for a while, but like most people that tried their hands at UI tests, found them to be utterly brittle and unmaintainable in the face of change.

And, like most people, I would mark these tests explicit or ignored, until I ditched most or all of them.&#160; I’ve heard this story over and over again, from folks that wrote lots and lots of UI tests, only to see their investment go to waste as the time and effort to maintain these often-breaking tests far outweighs any benefit gained from full, end-to-end UI tests.&#160; I gave some presentations on [UI testing](http://www.lostechies.com/blogs/jimmy_bogard/archive/2009/10/22/c4mvc-ui-testing-screencast-posted.aspx), but two things I’d like to make absolutely clear:

  * Maintainable UI tests are absolutely possible
  * Automated UI tests are absolutely possible

I know this because our team did this.&#160; It was quite a bit of work to get to that point, but once we did, we had a great set of concepts on how we can continue to do so in the future.

In a recent show-and-tell session with another team that I really wish would blog about their efforts (they know who they are ;), it became even more clear to me exactly _why_ we had such success with our UI tests.&#160; I didn’t have all the pieces in my head, and lots of our success was completely accidental, but we settled on a set of rules that no matter what our external user interface technology, these rules led to maintainable, effective UI tests.

### Rule 1: Strongly-typed views

Whether it’s ASP.NET MVC, WebForms, Silverlight or whatever, the views need to be built from a model type.&#160; It doesn’t really matter how that model type is built, CQRS, SQL projection, LINQ projection, AutoMapper or what, but we got the most mileage out of creating models specific for each view.&#160; That type represented the information to show on that screen.

Besides being a great source for metadata about the view, a view-specific model, or “view model” becomes a specification for how the view should render.&#160; Our views are very convention-based, where things like the presence of a “RequiredField” attribute not only instructs the validation framework to kick in.

There’s the magic string problem with web frameworks such as ASP.NET MVC, that strongly-typed views eliminate.&#160; But step 1 – strongly-typed views.

### Rule 2: Expression-based UI element generation

Another big must.&#160; Every UI element needs to be generated from a C# expression used to output the display or edit field.&#160; With ASP.NET MVC, it means doing something like “Html.DisplayFor” or “Html.EditorFor(m => m.FirstName)”.

We want this because strongly typed views plus expression based UI element generation gives us a very, very powerful tool to build very intelligent views.&#160; These intelligent views are critical to easily designing for UI tests.&#160; Using the expression gives us a metric ton of metadata information from which we can build convention-based UI element generators, including:

  * Class type/attributes
  * Property type
  * Property name
  * Attributes
  * Property value

All this information gives us all we need to easily build UIs that don’t break and are easy to test.

### Rule 3: Metadata-driven UI element identifiers

When it comes to the mechanics of UI testing, you have to figure out how the UI framework will locate edit and display fields in your specific UI platform.&#160; For the web, we chose to use the ID HTML element for both display and edit fields.&#160; Display fields were wrapped in <span> tags with an ID value matching the property name of the view model property.

If we coded “Html.DisplayFor(m => m.FirstName)”, this would render “<span id=’FirstName’>Bob</span>”.&#160; In the edit fields, the property name shows up in both the NAME and ID attributes of the input field.

Since the HTML generation includes model-based identifiers, this greatly helps locating these elements in UI automation frameworks.&#160; Magic strings get eliminated from both your views and your UI tests.

In other frameworks, such as Silverlight and WinForms, element location is done by grabbing the actual field’s name in the form class.&#160; In that case, something like “TextBox1” is useless.&#160; We want the element identifiers to be driven off of the property name metadata of our view models.

### Rule 4: Expression-based element locators in tests

When it comes to building our UI tests, we want to use the EXACT SAME expressions in our UI tests that we find in our views.&#160; If I code “Html.EditorFor(m => m.FirstName)” in my view, I need to see something like “Form.TextBox(m => m.FirstName, “Bob”)” in my UI tests.&#160; The exact same view model type and the exact same expression are used to generate the UI element, as is used to locate the UI element.

When my UI element generation and location logic are the same, and bound by view model metadata, I no longer have to worry about broken UI tests because of changing my view.&#160; If I remove a member from the screen, I delete that property from my view model, and now I need to update my UI test, all before I can commit the change!

I really can’t stress enough how important this rule is.&#160; Without it, you’re really spending too much time futzing around with broken UI tests, or just not getting as much mileage as you could have.

### Rule 5: Set up context using existing business logic

If you need to set up data, and you WILL need to set up data, don’t go through any back doors to set things up.&#160; Don’t build new data access layers, and don’t go through custom-built back doors to build state that doesn’t go through the normal domain logic.

Whatever your domain layer is, use it to set up your contexts.&#160; Don’t design workarounds to get things in a state that isn’t normally possible.&#160; If you look for usages of a type or member and it’s only used in tests, you’re asking for brittle tests.

### Wrapping it up

Effective, maintainable UI tests are definitely possible.&#160; They can be written in such a way that it doesn’t require lots of babysitting or dedicated personnel to maintain.&#160; They can even be automated to run after every commit.&#160; They can provide value, catch bugs, and expose all those unintended consequences from changes that complex applications tend to have.

It’s all possible, but only if the UI is designed with tests in mind.&#160; I’m sure these aren’t the only ways to create maintainable UI tests, as I know the Dovetail folks also have a lot of innovation in that area, but these rules certainly worked for us.