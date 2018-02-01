---
id: 391
title: Using ActiveSupport::Notifications and ActiveSupport::Concern To Create An Audit Trail
date: 2011-06-09T13:24:34+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=391
dsq_thread_id:
  - "327025468"
categories:
  - Analysis and Design
  - Logs
  - Rails
  - Ruby
---
In my previous post, I outlined a scenario that needs to be audited for HIPAA compliance &#8211; a patient with a list of medications. Every time a medication is added, updated or deleted, an audit record has to be created to tell us who made the change, what the change was, and what patient it was for. I also outlined my desire to use an event aggregator pattern or other pub/sub pattern on the backend of my system to facilitate this and other functionality. After some discussion via that blog post and twitter, I came across ActiveSupport::Notifications. I also remembered seeing a tweet from DHH talking about the use of ActiveSupport::Concerns. The combination of these two things makes for a very nice audit system&#8230; though I do still have a few issues to work out regarding specific data I need in the audit record.

 

## Auditing With ActiveSupport::Notifications

There&#8217;s a lot of great information on this subject around the interwebertubes, so it was easy for me to learn about it and how to use it. Here&#8217;s a few of the places I read / watched:

  * [Instrument Anything in Rails 3](https://gist.github.com/566725)
  * [ActiveSupport::Notifications Documentation at RubyOnRails.org](http://api.rubyonrails.org/classes/ActiveSupport/Notifications.html)
  * [RailsCasts Episode #249: Notifications In Rails 3](http://railscasts.com/episodes/249-notifications-in-rails-3)

As it turns out, the implementation of this part of ActiveSupport is basically an event aggregator. This made it an easy choice for me to use for my auditing needs, and possibly useful for other needs, too.

The first thing I want to do for my auditing is have a database record created every time a patient medication is saved. To do this, I can use an after_save callback, and instrument the audit from the Medication class directly.

Here&#8217;s the medication class with the call to the instrumentation.

<pre class="brush:ruby"># app/models/medication.rb
class Medication
  include Mongoid::Document
  after_save :audit

  embedded_in :patient

  private

  def audit
    ActiveSupport::Notifications.instrument(:audit,
      :event_name =&gt; "modified patient medication",
      :audited_object =&gt; self,
      :patient =&gt; patient,
      :current_user =&gt; Thread.current[:user]
    )
  end
end
</pre>

 

Then I need to set up a subscriber for the :audited event and have it create the audit record. Here&#8217;s the code for the Audit class and the subscriber that does the work.

<pre class="brush:ruby"># app/models/audit.rb
class Audit
  include Mongoid::Document
  include Mongoid::Timestamps
end

# lib/initializers/audit_notification_subscriber.rb
ActiveSupport.Notifications.subscribe(/audit) do |*args|
  data = args.last
  event_name = data[:event_name]
  audited_object = data[:audited_object]
  current_user = data[:current_user]
  patient = data[:patient]

  audit_data = {
    :event =&gt; event_name,
    :modified_by =&gt; {
      :name =&gt; current_user.full_name,
      :email =&gt; current_user.email
    },
    :data =&gt; audited_object.audit_data,
    :patient =&gt; {
      patient.full_name,
      patient.patient_id
    }
  }

  Audit.create! audit_data
end
</pre>

 

This is a fairly simple setup. Whenever my medication class is saved, the audit subscriber will create an audit record with all of the data that I need. From here, I can add auditing for updated, deletes, and other callbacks on the model.

 

### Simplifying Audits With ActiveSupport::Concern

DHH talked about this in a tweet and pointed to a gist that outlines [one way he is using concerns](https://gist.github.com/1014971) to keep his models clean. There&#8217;s [a good write up on concerns over at OpenSoul.org](http://opensoul.org/blog/archives/2011/02/07/concerning-activesupportconcern/), to get more familiar with them.

I liked this idea and thought it would be fun to see if it helped me with my auditing. After all, my model really isn&#8217;t concerned with auditing detail, other than knowing that it needs to be audited. With that in mind, I wrote a simple concern that I can include in my models and have them audited without me having to worry about the detail within the model.

<pre class="brush:ruby"># lib/audited.rb
module Audited
  extend ActiveSupport::Concern

  included do
    after_save :audit
  end

  def audit_data
    if respond_to? :attributes
      self.attributes
    else
      fail "No audit data available for #{self.class.name}. Please add an #audit_data method and return a hash of data from it."
    end
  end

  def audit
    event_name = "Save #{self.class.name.split("::").last}"
    ActiveSupport::Notifications.instrument :audit, :event_name =&gt; event_name, :current_user =&gt; Thread.current[:user], :audited_object =&gt; self
  end
end
</pre>

 

This module sets up the after_save callback for me, allowing me to remove that from my Medication model which keeps the model cleaner. It then sets up the audit method which does the call into the ActiveSupport::Notifications, as well.

My medications model is now much more simple than it was, previously:

<pre class="brush:ruby"># app/models/medication.rb
class Medication
  include Mongoid::Document
  include Audited

  embedded_in :patient
end</pre>

 

### A Few Remaining Problems

Unfortunately this solution isn&#8217;t quite as perfect as I had hoped. There are a few remaining problems and ugly things that I haven&#8217;t figured out how to clean up, for my specific scenario. I do think that the idea is good, in general, but I obviously need to do a little more work.

 

#### Access To The Current User via Thread.current[:user]

I know this is ugly, but I don&#8217;t know of any other way for my audit code to get access to the current_user &#8230; the user that is currently making the request to update the patient&#8217;s medication list. I&#8217;ve read through several [blog posts](http://rails-bestpractices.com/posts/47-fetch-current-user-in-models) and stack overflow questions, and this seems to be the &#8220;best&#8221; (meaning, least ugly and horrible) way that I could find. If anyone could point me in a better direction, I would really appreciate it.

 

#### Access To The Current Patient

You&#8217;ll notice in the Concern version of the auditing, that there is a distinct lack of code to provide the patient to the audit trail. Since I moved this code into the concern, I don&#8217;t have knowledge of how to get the patient from the class that the concern is included in. I have no guarantee that there is a .patient method on the class, to get the current patient that the user is working with. The best solution I could come up with for this, is to use a session variable to set the patient when we load the patient the first time, and read that session variable from within the concern. Again, I think this is ugly, but I don&#8217;t know what else to do. Any suggestions you might have for this is also appreciated.

 

### Are Notifications Overkill, In This Scenario?

I think they might be, honestly. I could easily move the code that does the audit creation into the &#8216;audit&#8217; method of the Audited concern, and remove the notifications entirely. I&#8217;m not sure it adds any value to have a notification for this purpose. I&#8217;m probably going to remove the notification. I&#8217;m leaving it in this blog post, though, to show you how I progressed through my audit needs to end up where I am right now.