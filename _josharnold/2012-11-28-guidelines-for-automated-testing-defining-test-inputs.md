---
id: 230
title: 'Guidelines for Automated Testing: Defining Test Inputs'
date: 2012-11-28T16:45:40+00:00
author: Josh Arnold
layout: post
guid: http://lostechies.com/josharnold/?p=230
dsq_thread_id:
  - "947465685"
categories:
  - general
tags:
  - automated-testing
  - guidelines-automated-testing
  - storyteller
---
There are several simple rules to follow when dealing with test setup for automated tests:

  * Data setup should be declarative
  * Data setup should be as easy as you can possibly make it
  * The inputs for your test belong with your test (it lives inside of it)

Let’s walk through some examples of these rules being applied. As usual, I’m going to use StoryTeller for my examples.

#### Data setup should be declarative

We use tabular structures to construct our test inputs. It feels a little spreadsheet-like but it’s the most natural way to input a decent sample population.

Let’s consider a sample example of declaring inputs for “People” in a system. For any given person, you will likely need their first/last name and let’s also optionally capture an email address:

<table width="400" border="2" cellspacing="1" cellpadding="2">
  <tr>
    <td valign="top" width="133">
      <strong>First</strong>
    </td>
    
    <td valign="top" width="133">
      <strong>Last</strong>
    </td>
    
    <td valign="top" width="133">
      <strong>Email</strong>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="133">
      Josh
    </td>
    
    <td valign="top" width="133">
      Arnold
    </td>
    
    <td valign="top" width="133">
      <a href="mailto:josh@arnold.com">josh@arnold.com</a>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="133">
      Olivia
    </td>
    
    <td valign="top" width="133">
      Arnold
    </td>
    
    <td valign="top" width="133">
      <a href="mailto:olivia@arnold.com">olivia@arnold.com</a>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="133">
      Joel
    </td>
    
    <td valign="top" width="133">
      Arnold
    </td>
    
    <td valign="top" width="133">
    </td>
  </tr>
</table>

Another important note here: avoid unnecessary setup of data that is unrelated to the test at hand. For example, if lookup values are required for every single test then create a mechanism to automatically create them.

#### Data setup should be as easy as you can possibly make it

Often times the models that you are constructing aren’t as simple as “first/last/email”. You may have entities with various required inputs, variants, etc. You absolutely do **not** want to have to go through the ceremony of declaring them in every single test.

We beat this a couple of different ways:

  1. Use default values whenever we can (e.g., birthdate will always be 03/11/1979 unless otherwise specified)
  2. Use string conversion techniques to build up more complex objects

In my current project, we have a grid with 30+ fields to maintain. The input that we specify per test leverages default values for field values so that we don’t have to constantly repeat ourselves. This is particularly useful when creating sample populations large enough to test out paging mechanics.

On top of the various fields we must maintain, we have errors that we track per row. Each row can have zero or more errors. Naturally, our test input must be able to support the entry of such errors. Now, rather than creating a separate tabular structure for this, we decided to allow for a particular string syntax that looks something like this:

> {field name}: ErrorCode1[, ErrorCode2]  | {field name}: …

This allows us to input data like:

<table width="407" border="2" cellspacing="1" cellpadding="2">
  <tr>
    <td valign="top" width="133">
      <strong>First Name</strong>
    </td>
    
    <td valign="top" width="133">
      <strong>Last Name</strong>
    </td>
    
    <td valign="top" width="133">
      <strong>Errors</strong>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="133">
      Josh
    </td>
    
    <td valign="top" width="133">
      Arnold
    </td>
    
    <td valign="top" width="133">
      FirstName: E100
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="133">
      Olivia
    </td>
    
    <td valign="top" width="133">
      Arnold
    </td>
    
    <td valign="top" width="133">
      NONE
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="133">
      Joel
    </td>
    
    <td valign="top" width="133">
      Arnold
    </td>
    
    <td valign="top" width="133">
      NONE
    </td>
  </tr>
</table>

We can accomplish this in StoryTeller with something like this:
  

  


#### The inputs for your test belong with your test (it lives inside of it)

This is not an attack on the ObjectMother pattern by any means. However, I strongly believe that in automated testing scenarios, the ObjectMother just doesn’t fit. Consider the following acceptance criteria:

  1. Using the sample database
  2. Open the grid screen
  3. Click on 2nd row
  4. There should be an error on the screen

There are so many things wrong with this that it’s hard to count. Let’s forget about lack of detail and focus on the real question: “What value does this test have?”

If you’re focusing on defining system behavior, then you’ve failed. This doesn’t describe any behavior at all. If you’re focusing on removing flaws, I think you’ve still failed. You’ve identified a problem but you’ve failed to capture the state of the system associated with it.

Here’s my point: tests are most useful when they self-explanatory. I want to pull open a test and have everything that I need right at my finger tips. I don’t want to cross reference other systems, emails, wiki pages, etc. to figure out what data exists for the test.

A well-defined acceptance test should look like this (it should look familiar):

  1. Test input (system state)
  2. Behavior
  3. Expected results

Using StoryTeller for my examples, here’s what a test looks like (a condensed snippet from my current project):

[<img style="background-image: none; padding-top: 0px; padding-left: 0px; margin: 0px 0px 24px; display: inline; padding-right: 0px; border: 0px;" title="storyteller-test" src="http://clayvessel.org/clayvessel/wp-content/uploads/2012/11/storyteller-test_thumb.png" alt="storyteller-test" width="585" height="449" border="0" />](http://clayvessel.org/clayvessel/wp-content/uploads/2012/11/storyteller-test.png)

### Wrapping it up

Let me reiterate my points here for sake of clarity. Automated tests that are easy to read, write, and maintain follow these rules:

  1. Data setup must be declarative (think tabular inputs)
  2. Data setup must be as easy as possible
  3. The inputs and dependencies of the test live within the expression (see the ST screenshot above for an example)

Next time we’ll discuss how to standardize your UI mechanics.