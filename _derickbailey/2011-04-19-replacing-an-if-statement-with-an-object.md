---
wordpress_id: 267
title: Replacing An If Statement With An Object
date: 2011-04-19T08:19:44+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=267
dsq_thread_id:
  - "283375381"
categories:
  - Analysis and Design
  - AntiPatterns
  - Principles and Patterns
  - Ruby
---
I found myself writing this code yesterday:

<pre>def to_s
  if status == AssessmentStatus::Open
    date = get_assessment_short_date(:date_opened)
    "#{assessment.name}, Opened #{date}"
  else
    date = get_assessment_short_date(:date_closed)
    "#{assessment.name}, Closed #{date}"
  end
end</pre>

 

I wrote it and moved on. It worked and it did what I needed it to do &#8211; format a string to show when an assessment was opened, or when it was closed, depending on the current state of the assessment. A few moments later, I found myself writing the same code in my LabOrder class. I needed to know the date of the order vs the date it was received, depending on the state of the object.

When I saw myself writing this for the second time, I realized I was missing an abstraction. I needed to stop writing procedural code and start writing objects instead.

 

### Not Quite A State Machine

Remembering this little quote and re-examining the code I was writing, I thought about creating a simple state machine in my app. I would only have a few transitions &#8211; from open to closed, or from ordered to received &#8211; but it seemed like a nice clean way to handle things. After doing a bit of looking around at the various state machine implementations for ruby, though, I decided I didn&#8217;t need that much complexity in my app. I already have the business logic of transitioning from Open to Closed, for my assessment, wrapped up in my Assessment object. It would be easier to just move my object&#8217;s \`status\` attribute into a class that contained the actual status and the date that the status occurred. (Note that I also renamed the field to \`state\` instead of \`status\`, on the Assessment.)

Here&#8217;s what that class looks like:

<pre>class AssessmentStatus
  include Mongoid::Document

  Open = "open"
  Closed = "closed"

  embedded_in :assessment, :inverse_of =&gt; :state
  
  field :status, :default =&gt; Open
  field :date, :type =&gt; DateTime, :default =&gt; DateTime.now
end</pre>

 

It&#8217;s a very simple class with no real logic in it at this point. However, it gives me a starting point to move forward in the event that I do find myself needing a complete state machine. For now, though, having the status and date stored in it&#8217;s own class allows me to change my \`.to_s\` method on the Assessment class:

<pre>def to_s
  "#{assessment.name} #{state.status} #{state.date.short_date}"
end</pre>

 

(Note the \`.short_date\` method on my date field is a helper method that I created in a DateTimeFormats module, which gives me several date and time formats that I use throughout my app)

 

### &#8220;An Object Is A Choice&#8221;

I don&#8217;t remember who said this originally, but it&#8217;s been quoted on twitter recently and it has stuck with me for a few weeks now. When I first read this statement, I misunderstood the context. I thought it was saying you can choose to create an object, or not; that there is no hard and fast rule that says everything must be an object. While this interpretation may hold some ground on, too, I think the real intention of this statement was to say that you can write better code by removing flow-control logic (if statements, switch statements, etc) and replace them with objects. Stated a little differently, an object can be used in place of flow-control logic.

That&#8217;s not to say you should [never use an if statement](http://www.antiifcampaign.com/), though. There are times when you don&#8217;t necessarily need an object; when the if-statement or switch statement is [sufficient for your design](https://elearning.industriallogic.com/gh/submit?Action=PageAction&album=blog2009&path=blog2009/2010/sufficientDesign&devLanguage=Java). Remember, though, that there are trade-offs that need to be accounted for. A good guideline to know when you should have an object instead of an if or switch statement, is when you see the same if or switch statement in more than one place. Where two or more ifs are repeated, an object should be present.

 