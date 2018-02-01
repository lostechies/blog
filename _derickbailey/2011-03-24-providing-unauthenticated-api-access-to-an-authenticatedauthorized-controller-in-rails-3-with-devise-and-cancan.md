---
id: 223
title: Providing Unauthenticated API Access To An Authenticated/Authorized Controller In Rails 3, With Devise And CanCan
date: 2011-03-24T14:05:04+00:00
author: Derick Bailey
layout: post
guid: http://lostechies.com/derickbailey/?p=223
dsq_thread_id:
  - "262305776"
categories:
  - Model-View-Controller
  - Rails
  - Ruby
  - Security
---
My current Ruby on Rails app defaults to every page and controller action in the system requiring authentication. If you&#8217;re not logged in, you don&#8217;t get to do anything other than see the login page. Once you are logged in, you have to be authorized to do anything. It&#8217;s a fairly tight security setup because we&#8217;re dealing with medical data and patient health care information&#8230; HIPAA and all that jazz&#8230;

 

### Security: Devise And CanCan

To do the authentication, we&#8217;re using [Devise](https://github.com/plataformatec/devise). This makes it very easy to require all users be authenticated. We only needed to add this before filter to our ApplicationController:

> <span style="line-height: 0px">﻿before_filter :authenticate_account!</span>

authenticate_account! is a controller helper method that Devise provides, and it ensures we have an authenticated user. If the user is not authenticated, they get sent back to the login screen.

To do the authorization, we&#8217;re using [CanCan](https://github.com/ryanb/cancan). This makes it very easy to provide authorization rules around resources as well as any other general rules we need. To secure an entire controller and the resource it represents, we only needed to add this to a controller that needs it:

> authorize_resource

CanCan is smart enough to look at the controller name and figure out the resource to authorize against. You can also specify the class to authorize explicitly, etc&#8230; but that&#8217;s another blog post.

 

### I Need A Publicly Available API To Return A JSON Document

I have a list of insurance companies in my app. It&#8217;s just a name, address and phone number for the insurance company so there is nothing sensitive in this information. I also have a need to provide this list to a few third parties, including another company and the end user&#8217;s browser via some JQuery calls.

My general route is /insurance\_companies and I need to provide a search mechanism to return the companies in json format. This is easy enough with a route like this: /insurance\_companies/search/(:search\_term). This lets me hit &#8220;/insurance\_companies/search/bcbs.json&#8221; and return all companies that contains the letters &#8220;bcbs&#8221; in a json document format&#8230; except that you have to be authenticated / authorized to do that search and get the results back.

Here&#8217;s the basic rules that I need to have in place:

  * If a user hits the search url without the .json extension, they must be authenticated / authorized to see the page that tries to render
  * if a request is made to the search url with the .json extension, no authentication / authorization should be done because this is just a search / json document being returned.

To allow this api to work, I would either have to provide a way for the caller to authenticate / authorize each request for each request, use a separate controller that didn&#8217;t require the authentication / authorization, or find a way around the security for this one method.

 

### The Easy Way&#8230; :except filters

Fortunately, i found an easy way to use the same controller and search method to handle all of my needs. Here&#8217;s what the controller previously looked like:

 

<pre>class InsuranceCompaniesController &lt; ApplicationController
  authorize_resource

  def search
    @search_results = InsuranceCompany.search params[:text]
    respond_to do |format|
      format.json { render :json =&gt; @search_results }
      format.html { render :index }
    end
  end
end

class ApplicationController &lt; ActionController::Base
  before_filter :authenticate_account!
end</pre>

 

To meet my needs in this case, I need to put some :except filters into the authorize\_resource and authenticate\_account! calls. Easy enough&#8230; and, copying the :authenticate_account! filter into the InsuranceCompaniesController also overrides the behavior of the base class, meaning I don&#8217;t have to write a bunch of funky code in the base controller to know when / when not to modify the rule. Here&#8217;s what my controller looks like, now:

 

<pre>class InsuranceCompaniesController &lt; ApplicationController
  authorize_resource :except =&gt; :search
  before_filter :authenticate_account!, :except =&gt; :search

  def search
    @search_results = InsuranceCompany.search params[:text]
    respond_to do |format|
      format.json { render :json =&gt; @search_results }
      format.html {
        authenticate_account!
        authorize! :manage, InsuranceCompany
        render :index
      }
    end
  end<br />
end</pre>

 

The big changes here, are the :except filters being applied to both the authorize\_resource and before\_filter calls. This tells cancan and devise to ignore the search action. Then in the search action itself, when I&#8217;m responding to json format, I just format the results and send them on their way. However, when I&#8217;m responding to the html format, I add the authentication and authorization calls explicitly.

It&#8217;s a fairly small set of changes, and it does duplicate a few lines of code by manually calling the authentication and authorization methods, but I&#8217;m happy with the results. It let me keep the same controller and action for my API while providing the context and behavioral changes that I needed.