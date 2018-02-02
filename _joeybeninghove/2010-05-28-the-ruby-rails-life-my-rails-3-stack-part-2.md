---
id: 70
title: 'The Ruby/Rails Life &#8211; My Rails 3 Stack &#8211; Part 2'
date: 2010-05-28T13:00:00+00:00
author: Joey Beninghove
layout: post
guid: /blogs/joeydotnet/archive/2010/05/28/the-ruby-rails-life-my-rails-3-stack-part-2.aspx
categories:
  - BDD
  - capistrano
  - Cucumber
  - Deployment
  - factory_girl
  - Rails
  - RSpec
  - rstakeout
  - Ruby
  - steak
  - Testing
---
# **Rails Deployment & Testing**

There are some really nice tools available for deployment and testing rails. Below is a brief description
  
of some of the ones I&#8217;ve been using with success.

### Capistrano

I remember in the early days of my attempts of using Rails back in the 1.x days, the deployment/hosting
  
story was a bit of a headache, even with Capistrano back then. However things have improved dramatically,
  
especially with things like [Phusion Passenger](http://modrails.org). Capistrano is still strong too and I&#8217;ve
  
found that it makes deploying Rails apps extremely simple. The ability to make that &#8220;one quick change&#8221; and redeploy
  
in seconds is an awesome feeling.

Here is a somewhat annotated example of what my deploy script looks like just to give you a glimpse of what a
  
Capistrano script looks like (with certain information removed of course). If you&#8217;ve never used Capistrano before
  
then this might look a bit foreign. Again, this is just a taste, but you&#8217;ll have to dig in a bit more to really
  
understand the moving parts here.

#### Example

**/config/deploy.rb** 

<pre># just some basic info, including where to grab the code from
    set :application, "My Groovy Rails App"
    set :repository,  "[git repo]"
    set :scm, :git

    # there are some SSH options that i don't fully understand yet... :)
    default_run_options[:pty] = true
    ssh_options[:forward_agent] = true

    # ex. /var/www/my_groovy_rails_app
    set :deploy_to, "[path]" 

    # just some basic server properties
    role :web, "[server]"                   # Your HTTP server, Apache/etc
    role :app, "[server]"                   # This may be the same as your `Web` server
    role :db,  "[server]", :primary =&gt; true # This is where Rails migrations will run

    # configure environment variables to propertly use RVM (Ruby Version Manager) on the server
    # as you can see i'm using Ruby 1.8.7 Enterprise Edition on the server
    set :default_environment, {
      'PATH' =&gt; '/home/you/.rvm/gems/ree-1.8.7-2010.01/bin:/home/you/.rvm/gems/ree-1.8.7-2010.01@global/bin:/home/you/.rvm/rubies/ree-1.8.7-2010.01/bin:/home/you/.rvm/bin:$PATH',
      'RUBY_VERSION' =&gt; 'ree-1.8.7-2010.01',
      'GEM_HOME'     =&gt; '/home/you/.rvm/gems/ree-1.8.7-2010.01',
      'GEM_PATH'     =&gt; '/home/you/.rvm/gems/ree-1.8.7-2010.01:/home/you/.rvm/gems/ree-1.8.7-2010.01@global',
      'BUNDLE_PATH'  =&gt; '/home/you/.rvm/gems/ree-1.8.7-2010.01'  # If you are using bundler.
    }

    # automatically restarts the app after deployment
    namespace :deploy do
      task :start do ; end
      task :stop do ; end
      task :restart, :roles =&gt; :app, :except =&gt; { :no_release =&gt; true } do
        run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
      end
    end

    # tasks for bundler, which is the new way dependencies are managed in Rails 3
    namespace :bundler do
      task :create_symlink, :roles =&gt; :app do
        shared_dir = File.join(shared_path, 'bundle')
        release_dir = File.join(current_release, '.bundle')
        run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
      end

      task :bundle_new_release, :roles =&gt; :app do
        bundler.create_symlink
        run "cd #{release_path} && bundle install --without test"
      end

      task :lock, :roles =&gt; :app do
        run "cd #{current_release} && bundle lock;"
      end

      task :unlock, :roles =&gt; :app do
        run "cd #{current_release} && bundle unlock;"
      end
    end

    # the actual task that runs bundler to ensure all dependencies on the server are up to date
    after "deploy:update_code" do
      bundler.bundle_new_release
    end

</pre>

  * <http://www.capify.org/index.php/Capistrano>
  * <http://github.com/capistrano/capistrano>
  * <http://peepcode.com/products/capistrano-2>

### RSpec 2

A lot of you have probably at least heard of RSpec, with some of you perhaps even using it now. It&#8217;s a pretty
  
awesome testing framework, dare I say, BDD framework. Surprisingly I&#8217;ve really only scratched the surface as to
  
what RSpec is capable of, but it&#8217;s a joy to use for sure. So far I&#8217;m mainly using it for testing my models and a
  
little bit of controller testing. However I&#8217;m leaning on my higher level Cucumber integration tests for exercising
  
my controllers for the most part. I also haven&#8217;t gotten into mocking all that much yet, which RSpec has support for
  
as well. Perhaps at some point I&#8217;ll get into mocking. This is probably going to get me flamed by the ALT.NET&#8217;ers,
  
but honestly I just haven&#8217;t felt the pain in the fact that most of my tests DO in fact hit my local test database.
  
Perhaps that&#8217;s because I&#8217;m using MongoDB as my database which is so fast I don&#8217;t really notice that much of a
  
performance hit.

#### Example

Here&#8217;s a brief example of a simple model spec in RSpec.

**/spec/models/user_spec.rb** 

<pre>describe User do
  context "first name" do
    it "is required" do
      user = User.new
      user.should_not be_valid
      user.errors[:first_name].first.should == "can't be blank"
    end
  end

  context "email" do
    it "is unique" do
      user1 = User.create!(:email =&gt; "abc@123.com")
      user2 = User.new(:email =&gt; "abc@123.com")

      user2.should_not be_valid
      user2.errors[:email].first.should == "is already taken"
    end
  end
end
</pre>

Certainly not an exhaustive example, but it gives you the idea of how a basic spec looks in RSpec. And even this is
  
not nearly as elegant as I&#8217;ve been seeing others show lately. I would highly recommend you watch
  
[@l4rk](http://twitter.com/l4rk)&#8216;s presentation at the Scottish Ruby Conference on
  
[Pure RSpec](http://video2010.scottishrubyconference.com/show_video/3/1). I learned a ton from this presentation
  
and hope to incorporate some of his tips into my specs soon. Specifically the elegance of &#8220;let&#8221; and &#8220;subject&#8221;.

Oh, one more note. I&#8217;m using RSpec **2**, which is still in the early stages, but works with Rails 3. And I&#8217;m
  
actually running it straight from the master git repo. So, use at your own risk!

  * <http://rspec.info> &#8211; Only covers RSpec 1.x, but some useful info nonetheless
  * <http://github.com/rspec>
  * [Pure RSpec](http://video2010.scottishrubyconference.com/show_video/3/1) 

### Cucumber

I&#8217;ve named this cute little guy Larry. If you have kids, then you know why. 🙂 This is a pretty nice way of doing
  
high level acceptance/integration testing. It&#8217;s also the first time I&#8217;ve ever thought that ATDD (acceptance test driven
  
development) is actually achievable. The idea is that you write your &#8220;stories&#8221; in plain english, preferrably
  
with your client/customer/product owner using the give/when/then style of syntax. Once written, these stories can be
  
run through the Cucumber framework where it is parsed and coupled with custom ruby code (some of which you have to
  
write) to essentially give you executable specifications. Of all the attempts I&#8217;ve seen out there to achieve ATDD and
  
executable specifications, Cucumber really seems to have it nailed the best so far. Writing the stories does take some
  
getting used to as you do somewhat have to learn to speak the &#8220;language&#8221; of Cucumber. But after writing your first
  
couple &#8220;features&#8221;, as Cucumber calls them, you pretty much get the hang of it.

#### Example

**/features/users/add_new_user.feature** 

<pre>Feature: Add new user
    In order to allow a new user to access the system
    As an admin
    I want to add a new user to the system

    Scenario: New link is clicked from the users page
        Given I am logged in as an admin
        And I am on the users page
        When I follow "New"
        Then I should be on the new user page

    Scenario Outline: Required text fields are blank 
        Given I am logged in as an admin
        And I am on the new user page
        When I fill in "" for ""
        And I press "Save"
        Then I should see an error for ""

        Examples:
            | field_name |
            | First name |
            | Last name  |
            | Email      |
            | Password   |
</pre>

I have another post written that gives a bit more of an overview of Cucumber with more code examples, so look for that
  
soon.

  * <http://cukes.info>
  * <http://github.com/aslakhellesoy/cucumber>
  * <http://peepcode.com/products/cucumber>

### Steak

I&#8217;ve only started to play around with this one, but it&#8217;s a pretty interesting take on acceptance/integration testing.
  
Unlike Cucumber, it doesn&#8217;t use plain text stories. Instead it&#8217;s basically just a small wrapper of aliases on top
  
of RSpec that give you same kinda feel as Cucumber, but without the overhead of the English language. I&#8217;m going to
  
be spiking a bit more with this one as I think it might come in handy for some of my other integration testing needs.
  
Oh, and gotta love its logo! Beef! It&#8217;s what&#8217;s for&#8230;testing?

  * <http://github.com/cavalle/steak>

### factory_girl

Interesting name, very useful tool. You might have guessed that this is a tool to create objects for you. Not a whole
  
lot to say, but it&#8217;s really handy to easily create objects in varying states for testing purposes.

#### Example

**/spec/factories.rb**

<pre># creates a new User model
  Factory.define :user do |u|
    u.first_name 'Bud'
    u.last_name 'Abbott'
    u.email { |x| "#{x.first_name.downcase}.#{x.last_name.downcase}@blah.com" }
    u.password 'secret'
    u.password_confirmation 'secret'
    u.group_ids { [Factory.create(:group, :name =&gt; 'Users').id] }
    u.roles ['manager']
  end
</pre>

You can use this factory in a variety of ways.

<pre># instantiates the User model only, does NOT save it to the database
  Factory.build(:user) 

  # creates the User model and saves it to the database
  Factory.create(:user) 

  # returns a hash of attributes representing this user
  # useful for testing controllers simulating params or for validation
  Factory.attributes_for(:user) 

  # I haven't really found a use for this one yet
  Factory.stub(:user)

  # You can override specific values if desired
  # This would build the user setting a name
  # of "Lou Costello" instead of the default "Bud Abbott"
  Factory.build(:user, :first_name =&gt; "Lou", :last_name =&gt; "Costello")
</pre>

  * <http://github.com/thoughtbot/factory_girl>

### rstakeout

This is a nice little script I got from Geoffrey Grosenbach, of PeepCode fame. I use to automatically run my Cucumber
  
features and RSpec tests anytime I change a file in my Rails app. I find rstakeout to be a lot simpler to get going than
  
Autotest/Autospec. It has growl integration too. And yes, I do like my green and red growl notifications. 🙂

#### Example (from a terminal)

<pre>rstakeout "cucumber -t @wip"
</pre>

If I run that in my terminal, it automatically watches all files in my Rails app for changes and runs the command I give
  
it on each change. In this case, it runs my cucumber features, but only ones I&#8217;ve tagged with @wip, meaning ones I&#8217;m working
  
on at the given moment.

I&#8217;ve posted a Gist of the rstakeout script I&#8217;m using since there has been some confusion over which version to use.

  * [rstakeout script](http://gist.github.com/408007)

### Conclusion

Well I hope that gives you a taste of some of the deployment and testing tools I&#8217;m using so far in Rails. I feel like I
  
still have a ton to learn of course, but so far I&#8217;m really enjoying the testing experience that the Ruby language gives
  
me.

What are your favorite deployment/testing tools in Ruby/Rails? Leave a comment and let me know!