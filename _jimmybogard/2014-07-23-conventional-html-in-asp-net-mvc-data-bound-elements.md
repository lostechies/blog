---
wordpress_id: 922
title: 'Conventional HTML in ASP.NET MVC: Data-bound elements'
date: 2014-07-23T17:03:13+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=922
dsq_thread_id:
  - "2867434454"
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

We’re now at the point where our form elements replace the existing templates in MVC, extend to the HTML5 form elements, but there’s still something missing. I skipped over the dreaded DropDownList, with its wonky SelectListItem objects.

Drop down lists can be quite a challenge. Typically in my applications I have drop down lists based on a few known sets of data:

  * Static list of items
  * Dynamic list of items
  * Dynamic contextual list of items

The first one is an easy target, solved with the previous post and enums. If a list doesn’t change, just create an enum to represent those items and we’re done.

The second two are more of a challenge. Typically what I see is attaching those items to the ViewModel or ViewBag, along with the actual model. It’s awkward, and combines two separate concerns. “What have I chosen” is a different concern than “What are my choices”. Let’s tackle those last two choices separately.

### Dynamic lists

Dynamic lists of items typically come from a persistent store. An administrator goes to some configuration screen to configure the list of items, and the user picks from this list.

Common here is that we’re building a drop down list based on set of known entities. The definition of the set doesn’t change, but its contents might.

On our ViewModel, we’d handle this in our form post with an entity:

{% gist a2d67d622d2975fce594 %}

We have our normal registration data, but the user also gets to choose their account type. The values of the account type, however, come from the database (and we use model binding to automatically bind up in the POST the AccountType you chose).

Going from a convention point of view, if we have a model property that’s an entity type, let’s just load up all the entities of that type and display them. If you have an ISession/DbContext, this is easy, but wait, our view shouldn’t be hitting the database, right?

Wrong.

Luckily for us, our conventions let us easily handle this scenario. We’ll take the same approach as our enum drop down builder, but instead of using type metadata for our list, we’ll use our database.

{% gist d39fc6b458b11bc752a9 %}

Instead of going to our type system, we query the DbContext to load all entities of that property type. We built a base entity class for the common behavior:

{% gist 667c71beb2482a7c7d2d %}

This goes into how we build our select element, with the display value showed to the user and the ID as the value. With this in place, our drop down in our view is simply:

{% gist 912443b8424ab3333b67 %}

And any entity-backed drop-down in our system requires zero extra effort. Of course, if we needed to cache that list we would do so but that is beyond the scope of this discussion.

So we’ve got dynamic lists done, what about dynamic lists with context?

### Dynamic contextual list of items

In this case, we actually can’t really depend on a convention. The list of items is dynamic, and contextual. Things like “display a drop down of active users”. It’s dynamic since the list of users will change and contextual since I only want the list of active users.

It then comes down to the nature of our context. Is the context static, or dynamic? If it’s static, then perhaps we can build some primitive beyond just an entity type. If it’s dynamic, based on user input, that becomes more difficult. Rather than trying to focus on a specific solution, let’s take a look at the problem: we have a list of items we need to show, and have a specific query needed to show those items. We have an input to the query, our constraints, and an output, the list of items. Finally, we need to build those items.

It turns out this isn’t really a good choice for a convention – because a convention doesn’t exist! It varies too much. Instead, we can build on the primitives of what is common, “build a name/ID based on our model expression”.

What we wound up with is something like this:

{% gist 17dd4dd4e0394fb1b235 %}

We represent the list of items we want as a query, then execute the query through a mediator. From the results, we specify what should be the display/value selectors. Finally, we build our select tag as normal, using an HtmlTag instance directly. The [query/mediator](https://github.com/jbogard/mediatr) piece is the same as I described back in my [controllers on a diet series](http://lostechies.com/jimmybogard/2013/10/29/put-your-controllers-on-a-diet-gets-and-queries/), we’re just reusing the concept here. Our usage would look something like:

{% gist 43a7bae28c0cb9d9ac31 %}

If the query required contextual parameters – not a problem, we simply add them to the definition of our request object, the ActiveUsersQuery class.

So that’s how we’ve tackled dynamic lists of items. Depending on the situation, it requires conventions, or not, but either way the introduction of the HtmlTag library allowed us to programmatically build up our HTML without resorting to strings.

We’ve tackled the basics of building input/output/label elements, but we can go further. In the next post, we’ll look at building higher-level components from these building blocks that can incorporate things like validation messages.