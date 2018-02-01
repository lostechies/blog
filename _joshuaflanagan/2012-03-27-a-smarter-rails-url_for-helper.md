---
id: 80
title: A smarter Rails url_for helper
date: 2012-03-27T22:36:06+00:00
author: Joshua Flanagan
layout: post
guid: http://lostechies.com/joshuaflanagan/2012/03/27/a-smarter-rails-url_for-helper/
dsq_thread_id:
  - "626612787"
categories:
  - Conventions
  - Rails
  - Ruby
---
## Problem {#problem}

In my Rails application, I want to be able to determine a URL for any given model, without the calling code having to know the type of the model. Instead of calling `post_path(@post)` or `comment_path(@comment)`, I want to just say `url_for(@post)` or `url_for(@comment)`. This already works in many cases, when Rails can infer the correct route helper method to call. However, Rails cannot always infer the correct helper, and even if it does, it might not be the one you want.

For example, suppose you have comments as a nested resource under posts&nbsp; (config/routes.rb):

    resources :posts do
      resources :comments
    end
    

&nbsp;

I have a `@post` with id 8, which has a `@comment` with id 4. If I call `url_for(@post)`, it will correctly resolve to `/posts/8`. However, if I call `url_for(@comment)`, I get an exception:

    undefined method `comment_path' for #<#<Class:0x007fb58e4dbde0>:0x007fb58d0453e0>
    

&nbsp;

Rails incorrectly guessed the the route helper method would be comment_path (unfortunately, it knows nothing of your route configuration). The correct call would be `post_comment_path(@comment.post, @comment)`, which returns `/posts/8/comments/4`. However, that requires the calling code to _know_ too much about comments.

## My solution {#mysolution}

I wanted a way to “teach” my application how to resolve my various models into URLs. The idea is inspired by FubuMVC’s UrlRegistry (which was originally inspired by Rails’ url_for functionality…). I came up with <a href="https://gist.github.com/2223161" target="_blank">SmartUrlHelper</a>. It provides a single method: `smart_url_for`, which is a wrapper around `url_for`. The difference is that you can register “handlers” which know how to resolve your edge cases.

To solve my example problem above, I’d add the following code to config/initializers/smart_urls.rb:

    SmartUrlHelper.configure do |url|
      url.for ->model{ model.is_a?(Comment) } do |helpers, model|
        helpers.post_comment_path(model.post, model)
      end
    end
    

&nbsp;

Now I can call `smart_url_for(@post)` or `smart_url_for(@comment)` and get the expected URL. The `comment` is resolved by the special case handler, and the `post` just falls through to the default `url_for` call. Note that in this example, I use instance variables named @post and @comment, which implies I know the type of object stored in the variable. In that case, `smart_url_for` is just a convenience. However, consider a scenario where you have generic code that needs to build a URL for any model passed to it (like the form_for helper). In that case, something like `smart_url_for` is a necessity.

## Feedback {#feedback}

First, does Rails already have this functionality built-in, or is there an accepted solution in the community? If not, what do you think of this approach? I&#8217;d welcome suggestions for improvement. Particularly, I’m not wild about storing the handlers in the Rails.config object, but didn’t know a better way to separate the configuration step (config/initializer) from the consuming step (calls to `smart_url_for`). So far, it is working out well on my project.