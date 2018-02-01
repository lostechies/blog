---
id: 920
title: 'Conventional HTML in ASP.NET MVC: Replacing form helpers'
date: 2014-07-22T15:51:10+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=920
dsq_thread_id:
  - "2864471321"
categories:
  - ASPNETMVC
---
Other posts in this series:

  * [A primer](http://lostechies.com/jimmybogard/2013/07/18/conventional-html-in-asp-net-mvc-a-primer/)
  * [Building tags](http://lostechies.com/jimmybogard/2013/08/13/conventional-html-in-asp-net-mvc-building-tags/)
  * [Adopting Fubu conventions](http://lostechies.com/jimmybogard/2014/07/11/conventional-html-in-asp-net-mvc-adopting-fubu-conventions/)
  * [Baseline behavior](http://lostechies.com/jimmybogard/2014/07/17/conventional-html-in-asp-net-mvc-baseline-behavior/)
  * [Replacing form helpers](http://lostechies.com/jimmybogard/2014/07/22/conventional-html-in-asp-net-mvc-replacing-form-helpers/)
  * [Data-bound elements](http://lostechies.com/jimmybogard/2014/07/23/conventional-html-in-asp-net-mvc-data-bound-elements/)
  * [Validators](http://lostechies.com/jimmybogard/2014/07/24/conventional-html-in-asp-net-mvc-validators/)
  * [Building larger primitives](http://lostechies.com/jimmybogard/2014/07/25/conventional-html-in-asp-net-mvc-building-larger-primitives/)
  * [Client-side templates](http://lostechies.com/jimmybogard/2014/08/14/conventional-html-in-asp-net-mvc-client-side-templates/)

Last time, we ended at the point where we had a baseline behavior for text inputs, labels and outputs. We don’t want to stop there, however. My ultimate goal is to eliminate (as much as possible) using any specific form helper from ASP.NET MVC. Everything we need to determine what/how to render input elements is available to us on metadata, we just need to use it.

Our first order of business is to catalog the expected elements we wish to support:

  * Button (no)
  * Checkbox (yes)
  * Color (yes)
  * Date (yes)
  * DateTime (yes)
  * DateTime Local (yes)
  * Email (Yes)
  * File (No)
  * Hidden (Yes)
  * Image (No)
  * Month (No)
  * Number (Yes)
  * Password (Yes)
  * Radio (Yes)
  * Range (No)
  * Reset (No)
  * Search (No)
  * Telephone (Yes)
  * Text (Yes)
  * Time (Yes)
  * Url (Yes)

And the other two input types that don’t use the <input> element, <select> and <textarea>. This is where convention-based programming and the object model of HtmlTags really shines. Instead of us needing to completely replace a template as we do in MVC, we only need to extend the individual tags, and leave everything else alone. We know that we want to have a baseline style on all of our inputs. We also want to configure this once, which our HTML conventions allow.

So how do we want to key into our conventions? I like to follow a progression:

  * Member type
  * Member name
  * Member attributes

We can infer a lot from the type of a member. Boolean? That’s a checkbox. Nullable bool? That’s not a checkbox, but a select, and so on. Let’s look at each type of input and see what we can infer to build our conventions.

### Labels

Labels can be a bit annoying, you might need localization and so on. What I’d like to do is provide some default, sensible behavior. If we look at a login view model:

[gist id=47d7b43d6f52e4bc47f9]

We have a ton of display attributes, all basically doing nothing. These labels key into a couple of things:

  * Label text
  * Validation errors

We’ll get to validation in a future post, but first let’s look at the labels. What can we provide as sensible defaults?

  * Property name
  * Split PascalCase into separate words
  * Booleans get a question mark
  * Fallback to the display attribute if it exists

A sensible label convention would get rid of nearly all of our “Label” attributes. The default conventions get us the first two, we just need to modify for the latter two:

[gist id=2ed5fbff5bdee3240371]

With this convention, our Display attributes go away. If we have a mismatch between the view model property and the label, we can use the Display attribute to specify it explicitly. I only find myself using this when a model is flattened. Otherwise, I try and keep the label I show the users consistent with how I model the data behind the scenes.

### Checkbox

This one’s easy. Checkboxes represent true/false, so that maps to a boolean:

[gist id=82bc42c54ac0b13d124b]

Not very exciting, we just tell Fubu for bools, make the “type” attribute a checkbox. The existing MVC template does a few other things, but I don’t like any of them (like an extra hidden etc).

### Color

With some model binding magic, we can handle this by merely looking at the type:

[gist id=71b60a8c3a4727730427]

### Date/Time/DateTime/Local DateTime

This one is a little bit more difficult, since the BCL doesn’t have a concept of a Date. However, [NodaTime](http://nodatime.org/) does, so we can use that type and key off of it instead:

[gist id=50dafb99e31fd2f3df43]

### Email

Email could go a number of different ways. There’s not really an Email type in .NET, so we can’t key off the property type. The MVC version uses an attribute to opt-in to an Email template, but I think that’s redundant. In my experience, every property with “Email” in the name is an email address. Why not key off this?

[gist id=c55c5a8f72c4c29a8b27]

This one could go both ways, but if I want to also/instead go off the DataType attribute, it’s just as easy. I don’t like being too explicit or too confusing, so you’ll have to base this on what you actually find in your systems.

### Hidden

Hiddens can be a bit funny. If I’m being sensible with Guid identifiers, I know right off the bat that any Guid type should be hidden. It’s not always the case, so I’d like to support the attribute if needed.

[gist id=a500412f9b1c526991ea]

### Number

Number inputs are a bit complicated. I actually tend to avoid them, as I find they’re not really that usable. However, I do want to provide some hints to the user as well as some rudimentary client-side validation with the “pattern” attribute.

[gist id=0557b7c12edf18108f98]

I’d do similar for other numeric types (integer/floating point).

### Password

We’ll use the same strategy as our hidden input – key off the name if we can, otherwise check for an attribute.

[gist id=e03317906cb2bd0e441e]

We had to get a little fancy with our attribute check, but nothing too crazy.

### Radio

Radio buttons represent a selection of a group of items. In my code, this is represented with an enum. Since radio buttons are a bit more complicated than just an input tag, we’ll need to build out the list of elements manually. We can either build up our select element from scratch, or modify the defaults. I’m going to go the modification route, but because it’s a little more complicated, I’ll use a dedicated class instead:

[gist id=8ad824fdbf79adcee075]

Element modifiers and builders follow the chain of responsibility pattern, where any modifier/builder that matches a request will be called. We only want enums, so our Matches method looks at the accessor property type. Again, this is where our conventions show their power over MVC templates. In MVC templates, you can’t modify the matching algorithm, but in our example, we just need to supply the matching logic.

Next, we use the Modify method to examine the incoming element request and make changes to it. We replace the tag name with “select”, remove the “type” attribute, but leave the other attributes alone. We append a child option element, then loop through all of the enum values to build out name/value options from our enum’s metadata.

Why use this over EnumDropDownListFor? Pretty easy – it gets all of our other conventions, like the Bootstrap CSS classes. In a system with dozens or more enumerations shown, that’s not something I want to repeat all over the place.

### Telephone

We’ll treat the telephone just like our password element – check for a property name, and fall back to an attribute.

[gist id=050e36ae0d2dbc7046e5]

If we want to enforce a specific pattern, we’d use the appropriate data-pattern attribute.

### Text

This is the default, so nothing to do here!

### 

### Url

Just like our password, we’ll look at the property name, then an attribute:

[gist id=2fc5f29b0234e72b3b23]

If we get tired of typing that attribute matching logic out, we can create an extension method:

[gist id=d19e31fcaaf4dc5e4bcf]

And our condition becomes a bit easier to read:

[gist id=970fcfd5777fd914f241]

### Wrapping up

We knocked out most of the HTML5 input element types, leaving out ones that didn’t make too much sense. We can still create conventions for those missing elements, likely using property names and/or attributes to determine the right convention to use. Quite a bit more powerful than the MVC templates!

Next up, we’ll look at more complex element building example where we might need to hit the database to get a list of values for a drop down.