---
id: 325
title: Why opinionated input builders for ASP.NET MVC?
date: 2009-06-15T14:00:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/06/15/why-opinionated-input-builders-for-asp-net-mvc.aspx
dsq_thread_id:
  - "265260473"
categories:
  - ASPNETMVC
---
When we first started looking at crafting forms for MVC in a recent big project, we had just completed a ton of “view” screens for a wide variety of information.&#160; Having learned quite a few things on crafting HTML on the view side, we had a few goals in mind to ensure that we improved our development experience on the edit side.

But it wasn’t just the development experience we wanted to improve, it was the design/conception/analysis phase as well.&#160; By centering our conversations around creating “inputs for” our view model, we could create a lot of consistency in our screens.&#160; Our major goals for our opinionated builders were:

  * Input elements should look the same
  * Common classes of input elements should look the same, so that enumerations are always in a drop-down, nullable enumerations are in a radio button group, date-times are in a special date and time template, etc.
  * Our UI designers should not have to think about designing individual input elements
  * Developers should not have to think about what the standard input element HTML is
  * Everything rendered should work with ModelState, validation, and UI testing in a completely consistent, predictable and deterministic manner

In many of the MVC examples out there, I see a metric ton of duplication around designing forms.&#160; You always see the same “label” element, the input element, validation errors, asterisk for required fields, and so on copied over and over again for every single form element.&#160; What a waste!

### 

### Removing the duplication

What we saw was that if we gathered information from the strongly-typed expression, we could make an informed decision on what HTML to render.&#160; Is your model member decorated with a required field attribute?&#160; Render an asterisk.&#160; Is the type of the member an enumeration?&#160; Render a drop-down, but include all of the other normal input element business (label, etc.).&#160; Is the type of the member a Guid?&#160; Render a hidden field.&#160; But funnel all of these decisions through a single call to a single method, “InputFor”.

The benefit of opinionated input builders was that it was just one less design decision that had to be discussed and implemented, all the way through the process.&#160; By employing rigorous standardization on our design, we could create a very consistent user experience.

I don’t really see a panacea for a master opinion framework, as you’ll still have to decide what opinions are valid on _your_ project.&#160; But ASP.NET MVC, like many other frameworks, is one that allows you to form your own opinions, without making any recommendations on its own.&#160; Do make sure you form these opinions, as otherwise you’ll be stuck maintaining a lot of duplication of HTML and behavior in your views.