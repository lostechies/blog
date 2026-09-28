---
wordpress_id: 123
title: Setting up Ubuntu Jaunty for Ruby and Rails development
date: 2009-05-06T15:06:00+00:00
author: Joe Ocampo
layout: post
wordpress_guid: /blogs/joe_ocampo/archive/2009/05/06/setting-up-ubuntu-jaunty-for-ruby-and-rails-development.aspx
dsq_thread_id:
  - "262089985"
categories:
  - Rails
  - Ruby
  - Ubuntu
redirect_from: "/blogs/joe_ocampo/archive/2009/05/06/setting-up-ubuntu-jaunty-for-ruby-and-rails-development.aspx/"
---
Getting Ruby setup on Ubuntu &ndash; Jaunty

**UPDATED: Added RSpec for Rails as well**

Here are some quick steps to get you up and running with Ruby on Ubuntu, Take about 15 minutes depending on your internet connection.

Step 1: The first thing you need to do is update the packages in Ubuntu open the terminal window (Applications Menu | Accessories | Terminal) and type in the following commands.  
&nbsp;&nbsp;&nbsp;   
<span style="font-family: courier new,courier">&nbsp;&nbsp; sudo aptitude update<br />&nbsp;&nbsp; sudo aptitude dist-upgrade</span>

Step 2: The next package will insure you have everything you need in order to build ruby packages on your system.  
&nbsp;&nbsp;&nbsp;   
&nbsp;&nbsp;&nbsp; <span style="font-family: courier new,courier">sudo aptitude install build-essential</span>

Step 3: Type in the following command to install Ruby NOTE: this is all ONE command  
<span style="font-family: courier new,courier"><br />&nbsp;&nbsp;&nbsp; sudo aptitude install ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8 libreadline-ruby1.8 libruby1.8 libopenssl-ruby</span>

Step 4: Type in the following command to install SQLite3 NOTE: ONE command  
<span style="font-family: courier new,courier"><br />&nbsp;&nbsp;&nbsp; sudo aptitude install sqlite3 libsqlite3-ruby1.8</span>

Step 5: Install Ruby Gems NOTE: Multiple commands  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   
<span style="font-family: courier new,courier">&nbsp;&nbsp; wget http://rubyforge.org/frs/download.php/55066/rubygems-1.3.2.tgz<br />&nbsp;&nbsp; tar xvzf rubygems-1.3.2.tgz<br />&nbsp;&nbsp; cd rubygems-1.3.2<br />&nbsp;&nbsp; sudo ruby setup.rb</span>

<span style="color: #ff0000"><b>!! You should get an error stating that Ruby command not found !!</b></span>

Step 6: creating the ruby symlink (symlink stands for symbolic link, windows user can think of it like a shortcut)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   
<span style="font-family: courier new,courier">&nbsp;&nbsp; sudo ln -s /usr/bin/ruby1.8 /usr/local/bin/ruby</span>

Step 7: Install ruby gems NOTE: you should be in the directory rubygems-1.3.2 when you run this command

&nbsp;&nbsp;&nbsp; <span style="font-family: courier new,courier">sudo ruby setup.rb</span>

Step 8: We need to create the remaining symlinks for ruby utilities NOTE: Multiple commands

<span style="font-family: courier new,courier">&nbsp;&nbsp;&nbsp; sudo ln -s /usr/bin/gem1.8 /usr/local/bin/gem<br />&nbsp;&nbsp;&nbsp; sudo ln -s /usr/bin/rdoc1.8 /usr/local/bin/rdoc<br />&nbsp;&nbsp;&nbsp; sudo ln -s /usr/bin/ri1.8 /usr/local/bin/ri<br />&nbsp;&nbsp;&nbsp; sudo ln -s /usr/bin/irb1.8 /usr/local/bin/irb<br /></span>

### Installing Rails

Step 9: Install Rails

<span style="font-family: courier new,courier">&nbsp;&nbsp;&nbsp; sudo gem install rails &#8211;no-rdoc &#8211;no-ri</span>

Step 10: Create a test project NOTE: Multiple commands

<span style="font-family: courier new,courier">&nbsp;&nbsp;&nbsp; cd ~<br />&nbsp;&nbsp;&nbsp; mkdir apps<br />&nbsp;&nbsp;&nbsp; cd apps<br />&nbsp;&nbsp;&nbsp; mkdir rails_apps<br />&nbsp;&nbsp;&nbsp; cd rails_apps<br />&nbsp;&nbsp;&nbsp; rails testapp</span>

Step 9: Start Webrick web server in your testapp directory

<span style="font-family: courier new,courier">&nbsp;&nbsp;&nbsp; ./script/server</span>

Step 11: Open up Firefox and navigate to http://localhost:3000, you should see a page with the text:  
**  
&nbsp;&nbsp;&nbsp; Welcome aboard  
&nbsp;&nbsp;&nbsp; You&rsquo;re riding Ruby on Rails!**

Step 12: Install Rspec  
&nbsp;&nbsp;&nbsp;   
<span style="font-family: courier new,courier">&nbsp;&nbsp;&nbsp; gem install rspec</span>

### Installing source control  


Step 13: Install subversion  
<span style="font-family: courier new,courier"><br />&nbsp;&nbsp;&nbsp; sudo aptitude install subversion</span>

Step 14: Install Git because you are going to use plugins from GitHub

<span style="font-family: courier new,courier">&nbsp;&nbsp;&nbsp; sudo aptitude install git-core</span>

Step 15: Install Git-svn

<span style="font-family: courier new,courier">&nbsp;&nbsp;&nbsp; sudo aptitude install git-svn</span>

Step 16: Add SVN Like Shortcuts to Git

<span style="font-family: courier new,courier">&nbsp;&nbsp;&nbsp; git config &#8211;global alias.st status<br />&nbsp;&nbsp;&nbsp; git config &#8211;global alias.ci commit<br />&nbsp;&nbsp;&nbsp; git config &#8211;global alias.co checkout<br />&nbsp;&nbsp;&nbsp; git config &#8211;global alias.br branch</span>

Step 17: configure the global user for Git  
&nbsp;&nbsp;&nbsp;   
<span style="font-family: courier new,courier">&nbsp;&nbsp;&nbsp; git config &#8211;global user.name &#8220;Put your full name here&#8221;<br />&nbsp;&nbsp;&nbsp; git config &#8211;global user.email you@rackspace.com<br /></span>  
Step 18: colorize the output for Git  
&nbsp;&nbsp;&nbsp;   
<span style="font-family: courier new,courier">&nbsp;&nbsp;&nbsp; git config &#8211;global color.branch auto<br />&nbsp;&nbsp;&nbsp; git config &#8211;global color.diff auto<br />&nbsp;&nbsp;&nbsp; git config &#8211;global color.interactive auto<br />&nbsp;&nbsp;&nbsp; git config &#8211;global color.status auto</span>

&nbsp;

### Installing RSpec for Rails

I want to put a disclaimer here that this is my preferred way of installing RSpec from GitHub. It is not the only way.

Step 19: Navigate to the root of your Rails project. I am assuming that in this case it will be &#8220;testapp&#8221;

Step 20: Install Rspec for Rails from GitHub as Git submodules. NOTE: Multiple commands

<p style="padding-left: 30px">
  <span style="font-family: courier new,courier">git submodule add git://github.com/dchelimsky/rspec.git vendor/plugins/rspec</span>
</p>

<p style="padding-left: 30px">
  <span style="font-family: courier new,courier">git submodule add git://github.com/dchelimsky/rspec-rails.git vendor/plugins/rspec-rails</span>
</p>

Step 21: Run the rspec generators, this will enable the rspec_* controller, scaffold, model generators

<p style="padding-left: 30px">
  <span style="font-family: courier new,courier">ruby script/generate rspec</span>
</p>

This is going to drive you nuts if you have to remember to do this for every rails project you create so I created a simple bash script.&nbsp; Actually the contains more than the bash script it also has the aliases that I use for Rails development.

Step 22: Navigate to your home diretory

<p style="padding-left: 30px">
  <span style="font-family: courier new,courier">cd ~</span>
</p>

Step 23: Create the .rails_aliases file

<p style="padding-left: 30px">
  <span style="font-family: courier new,courier">gedit .rails_aliases </span>
</p>

Step 24: In gedit copy the following text to the .rails_aliases file

<span style="font-family: courier new,courier">alias ror-doc-spec=&#8217;open -a Firefox doc/plugins/rspec-rails/index.html&#8217;<br />alias ror-doc=&#8217;open -a Firefox&#8217;<br />alias ror-scaffold=&#8217;ruby script/generate rspec_scaffold&#8217;<br />alias ror-controller=&#8217;ruby script/generate rspec_controller&#8217;<br />alias ror-model=&#8217;ruby script/generate rspec_model&#8217;<br />alias ror-git-customerror=&#8217;script/plugin install git://github.com/gumayunov/custom-err-msg.git&#8217;<br />alias ror-console=&#8217;ruby script/console&#8217;<br />alias rapps=&#8217;cd ~/apps/rails_apps&#8217;<br />alias ror-serv=&#8217;ruby script/server&#8217;<br />alias ror-logtail=&#8217;tail -f log/development.log&#8217;</p> 

<p>
  # Configures a rails app to use rspec<br />specrails(){<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; git submodule add git://github.com/dchelimsky/rspec.git vendor/plugins/rspec<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; git submodule add git://github.com/dchelimsky/rspec-rails.git vendor/plugins/rspec-rails<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ruby script/generate rspec<br />}</span>
</p>

<p>
  Step 25: Save the file and close gedit
</p>

<p>
  Step 26: Open your .bashrc file from the terminal window
</p>

<p style="padding-left: 30px">
  <span style="font-family: courier new,courier">gedit .bashrc</span>
</p>

<p>
  Step 27: Add the reference to your .rails_aliases file in your .bashrc at the top of the file add the following line:
</p>

<p style="padding-left: 30px">
  <span style="font-family: courier new,courier">source ~/.rails_aliases</span>
</p>

<p>
  Step 28: Save the file and exit gedit
</p>

<p>
  Now if you want to add RSpec to any rails project you simply navigate to the root of a rails project and type:
</p>

<p style="padding-left: 30px">
  <span style="font-family: courier new,courier">specrails</span>
</p>

<p>
  If you want to add a controller with RSpec specs you simply have to type:
</p>

<p style="padding-left: 30px">
  <span style="font-family: courier new,courier">ror-controller BlogPost title:string author:string content:text &#8230;</span>
</p>

<p>
  Hope this helps! Happy coding!
</p>