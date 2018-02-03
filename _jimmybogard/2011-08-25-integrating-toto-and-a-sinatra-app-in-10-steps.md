---
wordpress_id: 518
title: Integrating Toto and a Sinatra app in 10 steps
date: 2011-08-25T03:20:58+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: http://lostechies.com/jimmybogard/?p=518
dsq_thread_id:
  - "395597142"
categories:
  - Ruby
---
Integrating a [Sinatra](http://sinatrarb.com/) and [toto](http://cloudhead.io/toto) application is a little tricky for those unfamiliar with hosting multiple [Rack](http://rack.rubyforge.org/) applications in a single Rack instance. To integrate these two for [AutoMapper.org](http://automapper.org/), I followed similar instructions [from the toto wiki](https://github.com/cloudhead/toto/wiki/Integrated-Toto-and-a-Rails-app-in-10-steps.):

  1. cd your\_sinatra\_app
  2. mkdir blog
  3. cd blog
  4. git clone git://github.com/cloudhead/dorothy.git .
  5. merge the contents of the dorothy .gems file with the .gems file in the root of your Sinatra application
  6. remove the files needed for a standalone toto install 
      1. rm README
      2. rm Rakefile (you may want to move the toto rakefile to the root directory to take advantage of the “new” task for creating new posts.)
      3. rm config.ru
      4. rm .gems
      5. rm -rf public
      6. rm -rf .git
  7. cd .. (back to the root of your Sinatra app)
  8. create a Rack config file, config.ru, in your Sinatra root, if it doesn’t already exist
  9. Open config.ru in your favorite text editor and add the following: 
    <pre>require 'toto'
require './app'

use Rack::ShowExceptions

use Rack::CommonLogger

#run the toto application

toto = Toto::Server.new do

  #override the default location for the toto directories
  Toto::Paths = {
    :templates =&gt; "blog/templates",
    :pages =&gt; "blog/templates/pages",
    :articles =&gt; "blog/articles"
  }

  #set your config variables here
  set :title, "Your Blog Title"
  set :date, lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }
  set :summary,   :max =&gt; 500
  set :root, "blog"
  set :url, "http://your-blog.heroku.com/blog/"

end

#create a rack app

app = Rack::Builder.new do

  use Rack::CommonLogger

  #map requests to /blog to toto
  map '/blog' do
  	run toto
  end

  #map all the other requests to sinatra
  map '/' do
    run SinatraApp
  end
end.to_app

run app</pre>

 10. Open your Sinatra app and wrap any Sinatra code with a class &#8220;SinatraApp&#8221; that inherits from Sinatra::Base: 
    <pre>require 'rubygems'
require 'sinatra'

class SinatraApp &lt; Sinatra::Base
  get '/' do
    "I love lamp"
  end
end</pre>

Now test your code with thin or any other rack-enabled test web server and push! A full working application [can be found at my github](https://github.com/jbogard/sinatra-toto).