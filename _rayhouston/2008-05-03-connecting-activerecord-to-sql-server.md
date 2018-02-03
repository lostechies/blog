---
wordpress_id: 20
title: Connecting ActiveRecord to SQL Server
date: 2008-05-03T15:13:36+00:00
author: Ray Houston
layout: post
wordpress_guid: /blogs/rhouston/archive/2008/05/03/connecting-activerecord-to-sql-server.aspx
categories:
  - Uncategorized
---
_Disclaimer: I&#8217;m a Ruby noobie. I know nada about Rails. Please leave a comment if something is not correct or if there is a better way to do this._

At work, we&#8217;re using [Watir](http://wtr.rubyforge.org/) to drive a [Silverlight](http://silverlight.net/) application for some automated end to end testing. We needed an easy way to access the database from our RSpec test fixtures to make sure the proper setup data is put where we need it. I discovered that ActiveRecord can be used without rails and that all I needed to do was just install the gem. Typing the following seemed to do the trick for me:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">gem install activerecord</pre>
</div>

I then found [this](http://wiki.rubyonrails.org/rails/pages/HowtoConnectToMicrosoftSQLServer) which told me that I have install the SQLServer adapter separately like so:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">gem install activerecord-sqlserver-adapter --source=http://gems.rubyonrails.org</pre>
</div>

It then also says that one must get the latest source distribution of Ruby-DBI from [here](http://rubyforge.org/projects/ruby-dbi/) and copy the file:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">lib/dbd/ADO.rb</pre>
</div>

to your Ruby installation directory in the following place:

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">X:/ruby/lib/ruby/site_ruby/1.8/DBD/ADO/ADO.rb</pre>
</div>

After that I was able to create a simple test page to see if could actually get connected.

_ActiveRecordTest.rb_

<div>
  <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">require 'active_record'

ActiveRecord::Base.pluralize_table_names = false

ActiveRecord::Base.establish_connection(
    :adapter =<span style="color: #0000ff">&gt;</span> "sqlserver",
    :host =<span style="color: #0000ff">&gt;</span> ".\SQLEXPRESS",
    :database =<span style="color: #0000ff">&gt;</span> "MyDB",
    :username =<span style="color: #0000ff">&gt;</span> "sa",
    :password =<span style="color: #0000ff">&gt;</span> "sa"
)

class Customer <span style="color: #0000ff">&lt;</span> ActiveRecord::Base
end

Customer.find(:all).each do |cust| puts cust.Name end</pre>
</div>

This test selects all the customers and outputs their names.

<div class="wlWriterSmartContent" style="padding-right: 0px;padding-left: 0px;padding-bottom: 0px;margin: 0px;padding-top: 0px">
  Technorati Tags: <a href="http://technorati.com/tags/Ruby" rel="tag">Ruby</a>,<a href="http://technorati.com/tags/ActiveRecord" rel="tag">ActiveRecord</a>
</div>