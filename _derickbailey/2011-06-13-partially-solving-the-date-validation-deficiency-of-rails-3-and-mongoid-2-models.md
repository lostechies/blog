---
wordpress_id: 400
title: Partially Solving The Date Validation Deficiency Of Rails 3 And Mongoid 2 Models
date: 2011-06-13T14:57:11+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=400
dsq_thread_id:
  - "331046922"
categories:
  - Mongoid
  - Rails
  - Ruby
---
A while back, [I posted a question on stack overflow](http://stackoverflow.com/questions/4221574/date-validation-in-rails-3) on how to properly validate a date input from a text field input, without throwing exceptions when the string provided is not a valid date.  The core of the problem is that when a user is allowed to type into a text box, for a date, and they input something invalid, assigning the invalid value to the field on the model will throw an exception, because the field tries to coerce the value into a date immediately.

 

### The Original Workaround

The answer I came up with was based on the answer posted to the question, by Rod Paddock, but was a bit of a hack compared to what I wanted (keep in mind that I&#8217;m using Mongoid instead of ActiveRecord when looking at this example):

{% gist 1023657 1-model-workaround.rb %}

 

This code effectively accomplishes what I want. It allows me to assign any arbitrary value to the model, validate the input to see if it&#8217;s even a valid date format. It let&#8217;s me keep the arbitrary value around and return it from the attribute when called. It also prevents bad dates from being considered ok, if you combine it with a &#8216;validates\_presennce\_of :date&#8217; validation.

 

### Issues With This Workaround

There are a few things that this workaround doesn&#8217;t do. For example, it is not maintainable long-term. Every time I have a date in a model, I have to repeat this code. It&#8217;s not going to work with calls to .update\_attributes or .write\_attributes. And, it&#8217;s not going to tell you that you have an invalid date in the model&#8217;s .errors collection. Instead, it&#8217;s going to tell you that the date is blank. No built in validation technique will validate the value before it&#8217;s assigned to the field. We could use a custom validation class and have itre-parse the value that comes out of the attribute, though. The downside here is re-parsing the value and throwing / catching another exception, which has a cost associated with it. I&#8217;m not sure there&#8217;s a way around the parsing / exception catching, but we should at least minimize that to one call.

What I really wanted to do was abstract this solution out into something reusable, that would solve some of the remaining issues.

 

### A Better Solution With ActiveSupport::Concern And Meta-Programming

My recent use of ActiveSupport::Concern that I talked about in another post gave me an idea, and I ran with it. I could use a concern as a module to plug into a model, and provide a method that would not only define the date field for me, but provide accessor methods that know how to handle all of the parsing and storage needs that I have. I could also use a better data structure to store the results of the parsing, which would give me a better way to handle a custom validator without having to re-parse the input.

The result of a day&#8217;s hacking this weekend, is the following concern:

{% gist 1023657 2-datefield-concern.rb %}

 

The first thing you&#8217;ll notice is that this concern is namespaced for Mongoid. I did this specifically because the solution I built only works with Mongoid, at this point. I don&#8217;t use any of the usual ActiveRecord stuff in this project, so there was no need for me to build support for ActiveRecord. Someone else might be able to make it work with ActiveRecord fairly easily, though.

Next, note the nested ClassMethods module. This module name is recognized by ActiveSupport::Concern and tells the concern to turn all of the method inside of it, into class level methods on the class that is including the concern. The end result is that my model will have a &#8216;date_field&#8217; method that can be called in the class definition.

The implementation of the date\_field method uses some meta-programming to inject a few things into the class when the method is called. First, it defines the date field according to the name that you provide. It then defines the accessor methods for reading and writing the attribute&#8217;s value. All of this is done inside of a class\_eval call, using string injection with <<-EOL &#8230; EOL. This causes ruby to execute all of the code in that string in the context of the class on which class_eval is being called. I&#8217;m normally not a fan of this style of meta-programming, but I think this is an acceptable use to keep the code clean and easy to read and understand.

The accessor methods don&#8217;t do anything more than delegate to another method in the concern. In case of the assignment access, the set\_date\_field\_value method does the parsing and storage of the bad result or good result. The get\_date\_field\_value then does the opposite &#8211; checking to see if a bad value is stored and returning either the bad value or the actual attribute value, depending. All of this is facilitated with a simple hash that uses the field name as the key and tells me whether the input value is valid or not.

Last, there is a custom validator class at the bottom of the code. This validator uses the data structure from the concern&#8217;s input parsing to determine whether or not the value is valid, and injects an error message into the model&#8217;s .errors collection if it&#8217;s not valid. I know that the validator is coupled tightly to my concern&#8217;s implementation and data structure. In this case, I&#8217;m ok with that. This validator is not meant to be used with any other fields, and is very directly a part of this solution&#8217;s implementation detail. The validator is even included automatically, so that I never have to set it up manually inside of my actual model.

 

### Mongoid::DateField In Action

Now that I have this in place, my model is reduced to the following:

{% gist 1023657 3-model-update.rb %}

 

That&#8217;s it. My model will now validate any arbitrary input for a date field, in a clean and easily re-usable manner.

For my actual application, here&#8217;s what that looks like:

<img title="Screen shot 2011-06-13 at 3.35.18 PM.png" src="https://lostechies.com/content/derickbailey/uploads/2011/06/Screen-shot-2011-06-13-at-3.35.18-PM.png" border="0" alt="Screen shot 2011 06 13 at 3 35 18 PM" width="600" height="303" />

Notice the &#8216;Start Date&#8217; field on the right hand side. When I fill in this field with something invalid and click save, I get the error message stating that it&#8217;s not valid and needs to be in a correct format. The value is also retained on the form so that the person can see what they did wrong.

 

### One Remaining Issue: Mass Attribute Updates

Although I&#8217;ve solved the majority of the problems I had with this solution, there is one remaining issue: I can&#8217;t call .write\_attributes or .update\_attributes, and by extension, cannot call .create or .new with a hash of values that contains the date fields. Since the solution only provides the parsing and validation during a call to the get and set accessor methods, the parsing and validation doesn&#8217;t run and an exception would be thrown for an invalid date.

The workaround here, is that I have to resort to rejecting the values from the form&#8217;s params when posting to the server and then manually assign them to the attributes:

{% gist 1023657 4-write_attributes-workaround.rb %}

 

It&#8217;s a small price to pay for having a generally clean solution. However, I would love to solve this and be able to pass the invalid date strings into .write_attributes without worrying. I would love to see a modification to my solution that allows this to happen&#8230; \*wink wink nudge nudge\* 🙂
