---
wordpress_id: 229
title: Using HAML, SASS, JQuery And JQuery-Templates To Build An ASync Search
date: 2011-03-25T07:22:44+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=229
dsq_thread_id:
  - "262857533"
categories:
  - Async
  - HAML
  - JQuery
  - SASS
---
In my previous post, I talked about setting up an API that let&#8217;s me [search for insurance companies](http://lostechies.com/derickbailey/2011/03/24/providing-unauthenticated-api-access-to-an-authenticatedauthorized-controller-in-rails-3-with-devise-and-cancan/). My initial use of this is to create a search box on another page in the site and have JQuery call back to the API to retrieve the results, and display them so that the user can select the appropriate insurance company. To accomplish this, I used the following tools:

### HAML

[HAML](http://haml-lang.com/) is our app&#8217;s markup engine of choice. For this feature, I used it to create a search form, an empty search results div, and a search result template. I&#8217;ll cover more about the template in a moment. Here&#8217;s the HAML that I wrote:

<pre>.select-insurance-company
  .search-form
    = form_tag assessment_insurance_path, :method =&gt; :put do
      = text_field_tag "insurance[company[search]]", nil, :class =&gt; "search"
      = submit_tag "Search", :id =&gt; "insurance-company-search-button"
  .search-results
  #search-results-template
    = form_tag assessment_insurance_path, :method =&gt; :put do
      .insurance-company
        %h4
          ${name}
        = submit_tag "Select"
        .address
          .address-line
            ${address_1}
          .address-line
            ${address_2}
          .city
            ${city},
          .state
            ${state}
          .zipcode
            ${zipcode}
          .phone
            ${phone}
</pre>

 

### JQuery

[JQuery](http://jquery.com/), of course, is the ubiquitous javascript library that makes javascript fun again, and makes total javascript n00bs like me look good. For this little feature, I need to wire up several things. When a user clicks the search button, I need to send a request off to the API, asynchronously. When the results come back, I need to display them in the search results div, using the template that I designed in the search-results-template div. Here&#8217;s the basics of wiring up the JQuery code to do this (minus the template population):

<pre>function setupSearchButton(){
    $("#insurance-company-search-button").click(function(){
      searchTerm = $("#insurance_company_search").val();
      base_url = "/insurance_companies/search";
      
      if (searchTerm)
        url = base_url + "/" + searchTerm + ".json";
      else
        url = base_url + ".json";

      $.getJSON(url, function(companies){
        $(".search-results").empty();
        $.each(companies, function(index, company){
          /* do something with each company that was returned */
        });
      });
      return false;
    });
  }
</pre>

I know this code is ugly. Like I said&#8230; javascript n00b. I haven&#8217;t done serious JS work in many many years&#8230; but it gets the job done. When I click the search button, it finds the text in the search box and builds up the appropriate API url. Then it makes a call to the url with the .getJSON method and provides a callback function. The callback clears any existing search results and then iterates over each of the returned companies allowing me to do something interesting with the company.

 

### JQuery-Templates

Here&#8217;s the fun part. [JQuery-Templates](http://stanlemon.net/projects/jquery-templates.html) allows me to take a chunk of HTML text and populate it with data using ${tokens}. The example on the JQuery-Templates website shows the template being hard coded in the JQuery code, directly. I don&#8217;t like that, though. I wanted to be able to design my template in my page and style it correctly, then just dump data into the template at runtime. By using HAML and SASS to generate some simple CSS, I was able to do exactly that.

Let&#8217;s go back to the setupSearchButton() javascript function and add the JQuery-Templates code.

<pre>function setupSearchButton(){
    $("#insurance-company-search-button").click(function(){
      searchTerm = $("#insurance_company_search").val();
      base_url = "/insurance_companies/search";
      if (searchTerm)
        url = base_url + "/" + searchTerm + ".json";
      else
        url = base_url + ".json";

      template_text = $("#search-results-template").html();
      template = $.template(template_text);

      $.getJSON(url, function(companies){
        $(".search-results").empty();
        $.each(companies, function(index, company){
          $(".search-results").append(template, company);
        });
      });
      return false;
    });
  }
</pre>

I&#8217;ve only added three lines of code, here. The template_text line, in the middle of the code, reads the HTML contents of the search results template. The next line creates a template using the JQuery-Templates plugin. Then in the callback method of the getJSON call, I am appending the contents of the template, populated with the data for each company, into the search results.

 

### SASS

Last, but not least, we can&#8217;t forget about [SASS](http://sass-lang.com/). Originally part of HAML, SASS is now it&#8217;s own thing &#8211; a markup language, similar to HAML, but to generate CSS for our site. (I love SASS and all but refuse to write CSS by hand anymore.)

In this case, I&#8217;m not just using the css generated to style the form and the search results, but also to hide the initial template. I don&#8217;t need anyone seeing the template displayed on the page, but I do need to have the template available for the jquery code.

Here&#8217;s the SASS layout that I am currently using:

<pre>.select-insurance-company
  .search-form
    +column(7)
    +append-bottom(1em)
    input.search
      +column(4.95)
    input.button
      +prepend-top(0.5em)
      float: right
  .search-results
    +column(7)
    clear: both
    border-top: 1px solid #cfcfcf
    .insurance-company
      +append-bottom(1em)
      input.button
        float: right
      h4
        padding: 0px
        padding-top: 5px
        margin: 0px
        font-weight: bold
        float: left
      .address
        clear: both
        +prepend(0.5)
        .city, .state, .zipcode
          display: inline
</pre>

(Note that I&#8217;m using the Blueprint css mixins with this SASS code).

 

### The End Result

Put it all together and we get a nice little search box that populates the contents of the search results without doing a refresh of the page:

 <img src="http://lostechies.com/derickbailey/files/2011/03/Screen-shot-2011-03-24-at-9.37.52-PM.png" border="0" alt="Screen shot 2011 03 24 at 9 37 52 PM" width="300" height="367" /><img src="http://lostechies.com/derickbailey/files/2011/03/Screen-shot-2011-03-24-at-9.38.09-PM.png" border="0" alt="Screen shot 2011 03 24 at 9 38 09 PM" width="301" height="365" />

While I am using Rails 3, HAML and SASS for my specific app, there&#8217;s no reason not to do some fun stuff like this with your specific web dev stack. All you need is some JQuery, JQuery-Templates, and JSON on the back-end.