---
wordpress_id: 112
title: 'CQRS Performance Engineering: Read vs Read/Write Models'
date: 2010-03-08T16:14:00+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/03/08/cqrs-performance-engineering-read-vs-read-write-models.aspx
dsq_thread_id:
  - "262068443"
categories:
  - Analysis and Design
  - CQRS
  - Pragmatism
  - Principles and Patterns
---
I&rsquo;ve used a lot of different architectures, patterns and implementations that revolve around the core concept of [command-query separation](http://en.wikipedia.org/wiki/Command-query_separation) (CQS) and the more recent label of [command-query responsibility separation](http://www.udidahan.com/2009/12/09/clarified-cqrs/) (CQRS). The ideas behind these principles help us create code that targeted to a single purpose, generally side-effect free and easier to work with and maintain. In the last few days, though, I&rsquo;ve begun to see how CQRS can be used for performance engineering as well.

### Performance Problems With A Common Pattern

A few weeks ago, our product owner reported a performance problem with a control that is used on two screens in our handheld / Compact Framework application. This control is not terribly complicated &ndash; it has 4 drop down lists, each one loaded based on the data selected in the previous one. I&rsquo;m pretty sure every developer has created a series of drop down lists like this at some point in their career. It&rsquo;s not difficult&hellip; it just takes a little time and effort to handle all the cases of no items found, auto-selecting if there&rsquo;s only a single item in the list, having a &ldquo;Select One&rdquo; or other default option, etc. 

After digging into the offending control, I found that it was doing the following for every drop down list on the control:

Data Load / Display:

  1. Load all data from the database into a DataTable
  2. Convert each row of data into the full object it represents
  3. Convert each object into a simple Name/Value Lookup object
  4. Bind the Lookup objects to the drop down list

Data Select / Use (on selected index changed):

  1. Get Value (ID) of the selected lookup item and load the full object for that ID
  2. Run the Data Load / Display for the next drop down list based on the ID of the object
  3. Publish the selected object on an event so the parent form could respond to it as needed

This is a pattern that I see a lot of &ndash; whether it&rsquo;s WinForms or WebForms development. It&rsquo;s especially common in a WebForms environment, though, where there is not state on the view implementation. Unfortunately, this pattern and implementation is very problematic when it comes to performance. The actual performance on the control in question was so bad that we resorted to using asynchronous commands to retrieve the data for the drop down lists. This let us keep the UI &ldquo;responsive&rdquo; to the user &ndash; it prevented the screen from locking up with strange artifacts for the 3 to 5 seconds that it took to load any given drop down list.

&nbsp;

### Separation Of Concerns

Why would I want to load the entire set of data from the database and deserialize that into the full object model just so I can bind the name and id of the objects to a drop down list and then re-load the same object from the database again? That doesn&rsquo;t make much sense to me &ndash; even in a web environment where I should bind nothing more than the name and id in the form. In a WinForms environment, though, I guess I can see &ldquo;the easy way out&rdquo; by loading up the objects with my existing data access infrastructure&hellip; but that just doesn&rsquo;t make any sense other than being lazy. 

Here&rsquo;s the crux of a read-only or view model in this situation: if I&rsquo;m only going to display the name and id of the objects, then that&rsquo;s all I should load.

&nbsp;

### Load View Model, Lazy Load Full Object When Its Needed

To solve the performance problems in this control, I decided to use the basic CQRS tenants of separating my view model, which is a read-only representation of my data, from the object model which is a read/write representation. Here&rsquo;s the new approach I took to solve the performance problems, with each of the drop down lists:

Data Load / Display

  1. Load the name and id only, from the database using a DataReader
  2. Populate a generic Lookup object with the name / id of each record
  3. Bind the drop down list to the Lookup objects

Data Select / Use

  1. Get the the id of the selected item in the drop down list
  2. Run the Data Load / Display for the next drop down list based on the id of the selected item

Data Collection

  1. After the entire selection process has been performed, then and only then load the full object that was selected and publish it to the parent form

There are a couple of key things to note in this solution&hellip; namely, I&rsquo;m only loading the name and id for the drop down lists. I only need that information for the drop down list to work, so I&rsquo;m not going to bother loading anything else. And I&rsquo;m not loading the full object model until I&rsquo;m actually ready to use it. If the user is constantly switching the drop down lists to figure out what they need, then loading the full object model after each individual selection will just use up a bunch of time and resources for no good reason. I&rsquo;m waiting until some level of confidence in the selection can be established and the code is ready to use the object model before loading the full model.

&nbsp;

### The Performance Improvements

I don&rsquo;t have any scientific performance metrics for this, yet. I&rsquo;m not sure if I&rsquo;ll need to do that, actually. I do have first hand experience with the existing performance and the new performance, though.

The original code tended to take anywhere from 3 to 5 seconds, on average, to load any given drop down list. The worst performance, though, was one particular query that returned nearly a thousand items for the drop list to display. This would take closer to 6 or 8 seconds to load. &hellip; again, these are all based on my experiences, not actual timers&hellip; I can say with certainty, though, that I was never able to use keypad up/down arrows to select items in the drop down list. The control was simply too slow in responding so I would sit there and wait for it to finish loading before clicking the down arrow again.

With the new implementation in place, the control&rsquo;s performance is significantly enhanced. The average time it takes to load the drop down list has dropped to far below a second. Again, I haven&rsquo;t done any real timer / performance testing with this&hellip; but I can say with certainty that I can now use the up/down arrow keys on the keypad and the control keeps up with me no matter how fast I&rsquo;m able to click the keys. Furthermore, the performance is good enough that I have not yet needed to use any asynchronous processing to load or display any data. Even with the one query that returns nearly a thousand records to the drop list, the time to load is less than a second &ndash; a barely noticeable stutter in the list being available for selection.

&nbsp;

### Conclusions And Other Considerations

The principles and patterns that comprise CQRS can be used for a number of different reasons &ndash; not the least of which is performance improvements in your code. Whether you are working on Winforms, Webforms, Compact Framework or another system or platform that has read vs. read/write needs, keeping CQRS in mind at all levels of the system can have a significant impact in many different ways. 

Of course, this does not come free. There is an increase in the amount of code you have to maintain when you go down this path. You may end up writing two or more different types of data access code and you will have the same data represented in multiple objects and queries in your system. These costs are not to be taken lightly. However, when used judiciously and understood by the entire team the [impact of these costs can be mitigated](http://codebetter.com/blogs/gregyoung/archive/2010/02/15/cqrs-is-more-work-because-of-the-read-model.aspx). Keep your data access methods simple and have a clean separation between your full object model and your read only models. Constantly communication with team members and work on well named and organized code. Its your team&rsquo;s communication, collaboration and standards that will help to cut the costs, keep your system clean and maintain it&rsquo;s performance over time.