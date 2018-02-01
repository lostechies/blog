---
id: 261
title: A Better Solution For Partial View Controllers
date: 2011-04-13T13:49:03+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=261
dsq_thread_id:
  - "278674509"
categories:
  - Model-View-Controller
  - Quality
  - Rails
  - Ruby
---
A few days ago, I wrote about [using the Cells gem to create an encapsulated segment of my app](http://lostechies.com/derickbailey/2011/04/11/cells-partial-controllers-and-views-for-rails-3/), with view and controller, etc. Well, this didn&#8217;t work out so well after all. Aside form the initial problem of \`content_for\` not working, I ran into another set of issues where the controller and view for the cell wouldn&#8217;t play nice with CanCan &#8211; our authorization system of choice. Rather than go down the path of trying to make it work (which I tried, for an hour or so), I decided to take [the advice of Brian Hogan](https://twitter.com/#!/bphogan/status/57625998866399236) and change approaches.

 

### A Helper Class And A Service Object

In another post, the day after my post on Cells, I wrote about [changing a helper method into a helper class](http://lostechies.com/derickbailey/2011/04/12/cleaning-up-rails-helper-methods-with-a-helper-class-good-idea-bad-idea-or-meh/). This is the first part of the solution to my needs, with the new direction. My helper class uses several conventions to determine what partial to use, what css file to include, and what service object to pass to the partial.

As a refresher, here is a mock up of the page with the program dashboard, in question.

<img src="http://lostechies.com/derickbailey/files/2011/04/NewImage.png" border="0" alt="NewImage" width="600" height="450" />

The bottom section of this screen is the dashboard for the program. It is related to a patient because a patient participates in a program. However, I wanted to make sure I was keeping the logic and data for the program dashboard encapsulated. I don&#8217;t want to have a bunch of code in my patient profile controller or view (the host for the program dashboard) when it was not used directly by the patient profile. It really belongs to the program dashboard.

To do this, I created an object that acts somewhat like a controller and somewhat like a view model. It contains all the logic and code that I need to load up my data and parse through all the bits that are specific to the program dashboard. Yet, it&#8217;s a model that is passed to the view partial so that the view partial can pull data from it and populate the view correctly.

It&#8217;s a fairly simple object, in this case, with some methods that retrieve bits of data that the program dashboard needs:

<pre>module BaleDoneen
  class ProgramDashboard

    def initialize(patient_program)
      @patient_program = patient_program
    end

    def program
      @program ||= @patient_program.program
    end

    def patient
      @patient ||= @patient_program.patient
    end

    def open_assessments
      @open_assessments ||= PatientAssessment.find_open(patient)
      @open_assessments if @open_assessments.count &gt; 0
    end

    def closed_assessments
      @closed_assessments ||= PatientAssessment.find_closed(patient)
      @closed_assessments if @closed_assessments.count &gt; 0
    end

    def available_assessments
      @available_assessments ||= ::Assessment.where(:program_id =&gt; program.id)
    end
  end
end</pre>

 

My view partial was updated to use this class, by having a \`:locals => {}\` variable named \`dashboard\` passed into it. For example, here&#8217;s the code that displays the open assessments, from the partial:

<pre>- if dashboard.open_assessments
        %li#open-assessments
          %h3 Open
          - dashboard.open_assessments.each do |assessment|
            = form_tag assessment_close_path(assessment.id), :method =&gt; :post do
              = link_to assessment.assessment.name, edit_assessment_path(assessment.id)
              - if can? :close, PatientAssessment
                \||
                = submit_tag "Close" </pre>

 

You can see several calls to \`dashboard\` in this code, to retrieve the data I need.

 

### Calling The Helper Class And Running The Partial

To wire all of this together, I make a call to my helper class from within the patient profile view, like this:

<pre>- @patient_programs.each do |patient_program|
    #program= ProgramDashboard.render self, patient_program</pre>

 

The \`ProgramDashboard.render\` is the call to the helper class. I&#8217;m passing \`self\` as the first parameter because this gives me access to the render and content_for methods, from within the helper class. The helper class then uses conventions to find the correct partial, css, and service object to run the partial and wires it all up.

Within the ProgramDashboard helper class, I am making a call to render the partial that I found, passing along the \`dashboard\` service object for the partial:

<pre>view.render :partial =&gt; "#{key}/program/dashboard", :locals =&gt; { :dashboard =&gt; dashboard }</pre>

 

### A Better Solution For Partial Controllers

In the end, I think this solution is a little cleaner. It uses the built in rails functionality, keeping me from having to install yet another gem. It still keeps all of the code for the program dashboard well encapsulated within the partial and service object for the dashboard. And it also kept me from having to deal with strange issues with methods like \`content_for\` or the various CanCan methods not working properly.

As always, I&#8217;m interested in feedback on this. What do you think? It obviously solves my problem, but does it do it in a well structured manner that doesn&#8217;t violate a ton of design principles? Is there sill a better way to solve my problem? Any feedback you have is always welcome.

 