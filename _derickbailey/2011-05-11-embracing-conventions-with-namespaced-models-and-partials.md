---
wordpress_id: 310
title: Embracing Conventions With Namespaced Models And Partials
date: 2011-05-11T07:57:28+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=310
dsq_thread_id:
  - "301007218"
categories:
  - AntiPatterns
  - Model-View-Controller
  - Philosophy of Software
  - Principles and Patterns
  - Rails
  - Ruby
---
Six months ago when I started working a contract with Joey Beninghove, I had never done full time rails work. I had played with it a few times and built a few small example apps just to get the hang of it, but had not done anything large, &#8220;production&#8221; quality, or for a real client. I&#8217;ve learned a lot in the last six months&#8230; too much to cover in one blog post, really. One of the things that I&#8217;ve learned, though, is that I really should embrace the idea of conventions over configuration.

 

## What Is &#8220;Convention Over Configuration&#8221;?

According to Wikipedia, [convention over configuration](http://en.wikipedia.org/wiki/Convention_over_configuration) is

> a software [design paradigm](http://en.wikipedia.org/wiki/Design_paradigm "Design paradigm") which seeks to decrease the number of decisions that [developers](http://en.wikipedia.org/wiki/Software_developer "Software developer") need to make, gaining simplicity, but not necessarily losing flexibility.
> 
> The phrase essentially means a developer only needs to specify unconventional aspects of the application. For example, if there&#8217;s a class Sale in the model, the corresponding table in the database is called sales by default. It is only if one deviates from this convention, such as calling the table &#8220;products_sold&#8221;, that one needs to write code regarding these names.
> 
> When the convention implemented by the tool you are using matches your desired behavior, you enjoy the benefits without having to write configuration files. When your desired behavior deviates from the implemented convention, then you configure your desired behavior.

The most common conventions that people run into in web development, are usually in MVC web apps &#8211; whether it&#8217;s rail or asp.net mvc or whatever. You typically have the controller and models named with conventions: Person and PersonController, for example. There is no need to configure the system or write any code that connects the Person model with the PersonController, because the convention is that a controller for a model will be named the same as the model, with &#8220;Controller&#8221; on the end of it. Between the controller and the views, there are also conventions typically in place. For example, in Rails you typically create a view at \`/app/views/person/index.html.erb&#8217; for the \`index\` action of the PersonController. Again, there is no need to provide any configuration or any code that explicitly points the PersonController&#8217;s index method to this view. The convention will automatically find the right files and tie them together for you.

 

## A Wolf In Sheep&#8217;s Clothing

Shortly after starting work on our rails app, Joey and I were building some models that represented questions and answers for an assessment. Our system supports multiple assessments and we didn&#8217;t want them to clobber each other in our models, views or controllers. With that in mind, we decided to namespace all of the assessment related items. As an example, if we had an assessment called &#8220;Health Risks&#8221;, we would create a &#8220;/health_risks&#8221; folder in each of our mode, view, and controller folders and place all of our work for this assessment in these folders. Then in our code, we would use modules to define the namespaces:

<pre># /app/models/health_risks/assessment.rb
module HealthRisks
  class Assessment

  end
end
</pre>

 

In this specific scenario, we did not want to create a controller or view for every question within a health risk. Our app needs to display multiple questions for each health risk, and each question needs to have a customized partial view to display on the page full of questions. Our first pass at doing this was to put the path to the view directly into the model. We also created another portion of the namespace called \`questions\` so that we could keep our files organized. Each of our assessment specific questions inherits from a generic Question class, as well.

<pre># /app/models/health_risks/questions/yes_no.rb
module HealthRisks::Questions
  class YesNo &lt; Question

    def path
      "/health_risks/questions/yes_no"
    end

  end
end
</pre>

 

We then used this attribute to render the partial for the question, on the view that displays the list of questions for the assessment (using HAML in our case).

<pre>- @questions.each do |question|
  = render :partial =&gt; question.path, :locals =&gt; {:question =&gt; question}
</pre>

 

This worked well for a long time. It also let us change the location of the question&#8217;s partial to be either more specific or more generic. However, this is going against the idea of convention over configuration. Even though we have a &#8220;convention&#8221; of providing a .path attribute on the question models, this is really little more than putting the configuration of which partial to render, directly into the model.

 

## Fixing The Mistake With A Convention Based Approach

Fast forward 5 months or more and I&#8217;ve grown used to the idea of conventions in rails apps. I use them regularly and have even [built my own conventions into various parts of the app](http://lostechies.com/derickbailey/2011/04/12/cleaning-up-rails-helper-methods-with-a-helper-class-good-idea-bad-idea-or-meh/). However, this old code to configure the partial view for a question is still in place and it&#8217;s driving me nuts. I hate having to specify the path on every question. It&#8217;s noise in the class, it&#8217;s a tight coupling between the model and the view&#8217;s location, it&#8217;s mixing concerns between the model and the view and it&#8217;s just plain wrong. So, last night I decided to start cleaning this up.

If you look at the value that I&#8217;m returning from the .path method in that example, you&#8217;ll notice that it&#8217;s already following the same patterns as the namespacing and class name. This makes it extremely simple to build a convention for the partials. We&#8217;ve already got everything in the right place, named correctly. All we need to do is build a helper that converts the class name to the partial name and it should work.

 

## Converting The Class Name To A Folder/File Name

This was probably the easiest part of the process. There&#8217;s a method built into rails called \`underscore\`, as part of the string class. This method turns any capitalized name, such as a ClassName, into a lowercased underscore version: class_name. I also needed to convert the &#8220;::&#8221; namespace separation into &#8220;/&#8221; folder separation. To do this, I could use string class&#8217; gsub method. In my case, though, I need a little more logic for some other specific needs, so I decided to split the name by the &#8220;::&#8221; separator and then join them with a &#8220;/&#8221; later.

<pre>module ApplicationHelper
  def question_path(question)
    # split "Namespace::ClassName" into ["Namespace", "ClassName"]
    segments = question.class.name.split("::")

    # convert the segments to lowercase, underscored; ["namespace", "class_name"]
    segments.map! { |seg| seg.underscore }

    # build the path: /namespace/class_name
    segments.join "/"
  end
end
</pre>

 

Now that we have the question\_path method in our application helper module, we can call this directly from our view to get the path to the question&#8217;s partial. In the case of the example &#8220;HealthRisks::Questions::YesNo&#8221; class, this method will return &#8220;/health\_risks/questions/yes_no&#8221; &#8211; the same value that we were originally providing in our model&#8217;s path method. This means we can get rid of that method and correctly use a convention to determine which partial to load for each question.

Change the view to use this new method, and we&#8217;re done:

<pre>- @questions.each do |question|
  render :partial =&gt; question_path(question), :locals =&gt; {:question =&gt; question}
</pre>

 

The right partial is now displayed for the right question, without having to configure which partial should be used, within the model. What should have been obvious many months ago is finally being fixed.