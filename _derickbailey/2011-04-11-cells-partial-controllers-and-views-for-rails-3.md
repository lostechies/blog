---
id: 250
title: 'Cells: Partial Controllers And Views For Rails 3'
date: 2011-04-11T19:59:01+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=250
dsq_thread_id:
  - "277191576"
categories:
  - Model-View-Controller
  - Quality
  - Rails
  - Ruby
---
I&#8217;ve got a sort-of meta-application that I&#8217;m building in Rails 3 for a client. The core of the application is a framework on which we build various &#8220;Programs&#8221; that a patient can participate in. On the Patient Profile screen, a doctor or other medical professional has the ability to invite patients to participate in a given program. Once a patient has been invited to participate in that program, they will see a program dashboard on their profile page. The doctors and nurses will also see the dashboard.

Here&#8217;s the mock up of what this looks like:

<img src="http://lostechies.com/derickbailey/files/2011/04/Patient-Profile-For-Programs-Scrubbed.png" border="0" alt="Patient Profile For Programs  Scrubbed" width="600" height="450" />

Each program has the potential for a very complicated and customized set of actions and workflows within it, all driven through the program dashboard on the patient&#8217;s profile.

 

### A Problem Of Coupling

The problem that I was about to run into on this particular requirement, was keeping the code for the dashboard clean and keeping it out of the controller for the patient profile. Sure, we can load up a list of programs that a patient is participating in, but beyond that, it should be the responsibility of the program dashboard to figure out what&#8217;s going on, not the patient profile controller or view.

We could have solved this with a simple partial for the program. In the most basic of scenarios this would have worked nicely. However, the functionality that we need on this first program dashboard is anything but &#8220;basic&#8221;. We have a lot of data to load and sort, filter and prepare, and otherwise work with before we can render the view.

In the end, I did not want to do was clutter up a partial for the dashboard with a bunch of code to load and prep data, or create a bunch of helper methods in the patient profile helper module to do the same. The above options would create far too much coupling between the profile and the programs, which would destroy the ability for this system to be extended with additional programs in the future.

 

### Cells: A Solution For &#8220;Partial Controllers&#8221;

Not liking the options I was faced with, I asked twitter if there was anything like a &#8220;Partial Controller&#8221; in Rails 3. What I wanted was a controller that would execute for a given partial. For example, if I had a \_my\_program\_partial.html.haml, I wanted a my\_program_controller.rb to go along with it. Ben Scheirman ([@subdigital](https://twitter.com/#!/subdigital)) [pointed me to a nice little ruby gem](https://twitter.com/#!/subdigital/status/57502351828856832) that provides exactly the functionality I&#8217;m looking for:

> [Cells &#8211; Compnents for Rails](http://cells.rubyforge.org/)

Directly from the Cells website:

> Cells look like controllers. They are super fast. They provide clean encapsulation. They are reuseable across your project. They can be plugged anywhere in your views or controllers.
> 
> Call them  <span class="quote">&#8220;mini controllers&#8221; </span> . But hey, they are faster!
> 
> Call them  <span class="quote">&#8220;partials on steroids&#8221; </span> . But wait, they are object-oriented instances, not a loose helper+partial _thing_.

 

### Implementing The First Program&#8217;s Dashboard As A Cell

This was surprisingly easy, and I&#8217;m really happy with the result. After installing the cells gem into my app, I ran this from the command line:

<pre>rails g cell SomePatientProgram display</pre>

 

This tells the generator to build a cell for SomePatientProgram with a controller method and view called display. The generator created a set of files for me in a new folder called app/cells

<pre>app/cells/
app/cells/some_patient_program_cell.rb
app/cells/some_patient_program/
app/cells/some_patient_program/display.html.erb
</pre>

 

I had to change the display.html.erb to haml, but it works just fine. Once I had all this in place, I needed to pass the PatientProgram in question (the assignment of a Patient to a Program) to cell. From the patient profile view, I made this call:

<pre>- @patient_programs.each do |patient_program|
  render_cell :some_patient_program, :display, :patient_program =&gt; patient_program</pre>

 

Then in the display method of the cell&#8217;s controller, I grab the patient program from the supplied options and turn it into the pieces that I need, as instance variables.

<pre>class SomePatientProgramCell &lt; Cell::Rails

  def display
    @patient_program = options[:patient_program]
    @program = @patient_program.program
    @patient = @patient_program.patient
    # ... lots of other data manipulation here
    render
  end

end</pre>

 

Then in the display.html.haml view, I set up the various layout elements that I need. I&#8217;m still working on the final layout, but this is what I have so far:

<pre>#some-program
  %h2
    Some Program Title Here
  %p
    A long description of the program should go here [...]

  %fieldset
    %legend Assessments
    assessment stuff goes here.

  %fieldset
    %legend Panels
    Panel stuff goes here.

  %fieldset
    %legend Follow-up Actions
    Follow-up stuff goes here. </pre>

 

Once I had that in place, I was able to view the patient profile, invite the patient to the program, and have the program&#8217;s cell displayed as I needed:

<img src="http://lostechies.com/derickbailey/files/2011/04/Screen-shot-2011-04-11-at-7.16.56-PM.png" border="0" alt="Screen shot 2011 04 11 at 7 16 56 PM" width="600" height="458" />

Note that the bottom section of this screen shot is the actual cell, in place.

 

### A Small Problem And A Workaround: Content_For Doesn&#8217;t Work

There is one little &#8220;bug&#8221; that is annoying me a bit. Due to a bug or design issue or something in Rails 3, calling &#8220;content_for&#8221; does not work from Cell views. In my case, I wanted to provide a style sheet for the cell&#8217;s view and only include it in the header of the page when the cell&#8217;s view is rendered. This is important because every &#8220;Program&#8221; will need it&#8217;s own styling for the dashboard, and I can&#8217;t put all of the styling for every program in a single stylesheet.

After a few answers from the #cells irc chat room turned up nothing, I found a work around via [the content_for bug on the cells github page](https://github.com/apotonick/cells/issues/25). At the bottom of the comments, ahmeij mentions using a helper method to put the content of a cell into a named content area. I only want to put the css file for a cell into my :css area, but the principle of what he said helped me come up with a simple helper method for my patients controller:

<pre>def render_program_cell(*args)
    cell_name = args[0]
    args[0] = cell_name.to_s + "_patient_program"
    content_for :css do
      stylesheet_link_tag "#{cell_name}/patient_program"
    end
    render_cell *args
  end
</pre>

 

This method is pretty simple, but it does a few things for me. It assumes a naming convention for my programs and the related cells. The first argument is the name of the program, minus &#8220;\_patient\_program&#8221;, which is used to figure out where the css file is and use generate the full name of the cell (re-adding the &#8220;\_patient\_program&#8221;). Then I call out to the content\_for :css and supply the right stylesheet name, again using a convent of having a stylesheet named &#8220;(something)\_patient_program&#8221;. And lastly, I render the actual cell by passing all the params to the Cells helper method.

From there, I can call my method in the patient profile view the same as I was calling the original render_cell method:

<pre>- @patient_programs.each do |patient_program|
  render_program_cell :some_patient_program, :display, :patient_program =&gt; patient_program
</pre>

 

Now it produces the cell&#8217;s view and it puts the cell&#8217;s css in the header of the page, the way I want.

 

### A Clean Solution

I generally like the solution that I found. It works well, is simple to work with, etc. Even with the helper method that I had to create, to wrap around my need for css, it&#8217;s still a much better solution than what I would have been able to accomplish with standard Rails controllers, views and partials.