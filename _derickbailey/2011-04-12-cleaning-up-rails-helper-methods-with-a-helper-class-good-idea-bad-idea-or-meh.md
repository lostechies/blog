---
wordpress_id: 258
title: 'Cleaning Up Rails Helper Methods With A Helper Class: Good Idea, Bad Idea, Or &#8216;Meh&#8217;?'
date: 2011-04-12T13:01:54+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=258
dsq_thread_id:
  - "277777361"
categories:
  - Model-View-Controller
  - Quality
  - Rails
  - Ruby
---
I found myself writing a very ugly helper method in my rails ApplicationHelper module:

<pre>def render_program_dashboard(patient_program)
    key = patient_program.program.key
    content_for :css do
      stylesheet_link_tag "#{key}/patient_program"
    end

    dashboard_instance = nil
    dashboard_class_name = "#{key.to_s.classify}::ProgramDashboard"

    begin
      dashboard_class = dashboard_class_name.constantize
      dashboard_instance = dashboard_class.new(patient_program)
    rescue
      Rails.logger.info "Dashboard Class Not Found: #{dashboard_class_name}"
    end

    render :partial =&gt; "#{key}/program/dashboard", :locals =&gt; { :dashboard =&gt; dashboard_instance }
  end</pre>

 

This chunk of code uses some conventions to include a stylesheet and a partial view in the view that calls it, and it also instantiates a class that the partial uses to populate itself with data. &#8230; But I don&#8217;t like this code living inside of a helper method. It&#8217;s very specific to one part of my app, not the app in general. It&#8217;s also a little large and ugly and could use some cleaning up, splitting into separate methods, etc&#8230; all of which I&#8217;m reluctant to do in a helper method, because the helper module would start to get really ugly really quickly.

My answer to this was to move the code into a class on it&#8217;s own, codifying the concept that was being skirted around with this helper method. I created a ProgramDashboard class that contains this code, and cleaned up a tiny bit of it along the way. In order to use the render and content\_for methods in the class, though, I needed access to the view that was being rendered. To solve this, I pass the view into the class along with the patient\_program. The code ends up looking like this:

<pre>class ProgramDashboard
  def self.render(view, patient_program)
    key = patient_program.program.key

    view.content_for :css do
      view.stylesheet_link_tag "#{key}/patient_program"
    end

    dashboard = get_dashboard key, patient_program

    view.render :partial =&gt; "#{key}/program/dashboard", :locals =&gt; { :dashboard =&gt; dashboard }
  end

  private 

  def self.get_dashboard(key, patient_program)
    dashboard_instance = nil
    dashboard_class_name = "#{key.to_s.classify}::ProgramDashboard"

    begin
      dashboard_class = dashboard_class_name.constantize
      dashboard_instance = dashboard_class.new(patient_program)
    rescue
      Rails.logger.info "Dashboard Class Not Found: #{dashboard_class_name}"
    end

    dashboard_instance 
  end
end</pre>

 

I like this solution because it encapsulates a specific set of functionality for a specific part of the app better than a helper method does. It keeps my code cleaner, over-all, and keeps me from bleeding a bunch of abstractions that most of my app don&#8217;t need via helper methods.

I know there are things I can do to clean up the ProgramDashboard class. What I&#8217;m really interested in, though, is whether or not this is a good idea, a bad idea, or just &#8220;meh&#8221; &#8211; who cares&#8230;

Let me know what you think. Do you do things like this? Is there something better that I can do? Is this something that works in &#8216;the right circumstances&#8217; and I just happened to stumble across a scenario that supports it? I&#8217;m interested in all feedback on this.

 

 

 