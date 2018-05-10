---
wordpress_id: 4475
title: Building a Rails Server
date: 2010-03-27T21:30:00+00:00
author: Rod Paddock
layout: post
wordpress_guid: /blogs/rodpaddock/archive/2010/03/27/building-a-rails-server.aspx
dsq_thread_id:
  - "263003350"
categories:
  - Uncategorized
redirect_from: "/blogs/rodpaddock/archive/2010/03/27/building-a-rails-server.aspx/"
---
Fellow Los Techie ****[**John Petersen**](/blogs/johnvpetersen/default.aspx "https://lostechies.com/blogs/johnvpetersen/default.aspx") took the famous (or infamous) [**Nerd Dinner**](http://www.nerddinner.com/ "http://www.nerddinner.com/") ****application created by [**Scott Hanselman**](http://www.hanselman.com/blog/) and ported it to the ****[**Ruby on Rails**](http://rubyonrails.org/ "http://rubyonrails.org/") platform. When John was developing this, I recommended we actually put it online and proceeded to purchase the domain name [**www.railsdinner.com**](http://www.railsdinner.com)

Owning the domain name was one thing, hosting the site was entirely another. Last week I decided to find a place to host Rails Dinner. That place conveniently,&nbsp; is the server closet in my home office.

I had a spare machine not really doing much so I decided to appropriate it as a Linux server capable of hosting Ruby on Rails applications.&nbsp;&nbsp;&nbsp;

## The Tools 

Hosting a Rails application requires a number of moving parts. The moving parts I installed and their purpose are as follows:

<table border="1" cellpadding="2" cellspacing="0" width="400">
  <tr>
    <td valign="top" width="200">
      Software
    </td>
    
    <td valign="top" width="200">
      Purpose
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="200">
      Ubuntu 9.10 Server
    </td>
    
    <td valign="top" width="200">
      Linux server.
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="200">
      Ruby (including Gems)
    </td>
    
    <td valign="top" width="200">
      The runtime for ruby
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="200">
      Ruby on Rails
    </td>
    
    <td valign="top" width="200">
      MVC based web application framework
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="200">
      MySQL
    </td>
    
    <td valign="top" width="200">
      Open source SQL database.
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="200">
      Passenger
    </td>
    
    <td valign="top" width="200">
      Runtime deployment tool for Rails applications.
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="200">
      nginx
    </td>
    
    <td valign="top" width="200">
      High performance web server
    </td>
  </tr>
</table>

## &nbsp;The Steps

Around the 3rd or 4th time of trying to install this server I decided to keep a log. The following tasks are what you need to do to get a Rails Server up and running.

<table border="1" cellpadding="2" cellspacing="0" width="925">
  <tr>
    <td valign="top" width="300">
      Task
    </td>
    
    <td valign="top" width="200">
      Purpose
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="300">
      Download and install Ubuntu Server
    </td>
    
    <td valign="top" width="200">
      <a href="http://www.ubuntu.com">www.ubuntu.com</a>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="300">
      sudo apt-get install ubuntu-desktop
    </td>
    
    <td valign="top" width="200">
      Optional step to add GUI support to your Linux server.
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="300">
      sudo apt-get install ruby-full build-essential
    </td>
    
    <td valign="top" width="200">
      Install ruby and all necessary libraries.
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="300">
      sudo apt-get install rubygems
    </td>
    
    <td valign="top" width="200">
      Install ruby gems distribution tools
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="300">
      sudo gem install rails
    </td>
    
    <td valign="top" width="200">
      Install rails
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="300">
      sudo apt-get install mysql-server
    </td>
    
    <td valign="top" width="200">
      Install mySQL Server
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="300">
      sudo apt-get install mysql-client libmysql-ruby libmysqlclient15-dev
    </td>
    
    <td valign="top" width="200">
      Install all libraries used to talk to mySQL
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="300">
      &nbsp;
    </td>
    
    <td valign="top" width="200">
      &nbsp;
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="300">
      sudo gem install passenger
    </td>
    
    <td valign="top" width="200">
      Download all libraries needed to install passenger
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="300">
      sudo apt-get install libopenssl-ruby
    </td>
    
    <td valign="top" width="200">
      Install library required to compile nginx web server
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="300">
      sudo apt-get install libssl-dev
    </td>
    
    <td valign="top" width="200">
      Install library required to compile nginx web server
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="300">
      sudo apt-get install zlib1g-dev
    </td>
    
    <td valign="top" width="200">
      Install library required to compile nginx web server
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="300">
      &nbsp;
    </td>
    
    <td valign="top" width="200">
      &nbsp;
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="300">
      cd /var/lib/gems/1.8/bin
    </td>
    
    <td valign="top" width="200">
      Change to directory where nginx build files are located. </p> 
      
      <p>
        <b>NOTE: You may want to add this folder to your systems PATH settings</b></td> </tr> 
        
        <tr>
          <td valign="top" width="300">
            sudo ./passenger-install-nginx-module
          </td>
          
          <td valign="top" width="200">
            Downloads code and compiles (<b>yes compiles!)</b> custom web server with passenger built in. </p> 
            
            <p>
              <b>NOTE: This command is finicky and took me a few tries to get it to run properly. <br /></b></td> </tr> </tbody> </table> 
              
              <p>
                &nbsp;<b>NOTE: nginx is a high performance web server that is used by a lot of major web sites. It does not have a module/plug-in architecture so passenger is compiled directly into the server code.</b>&nbsp;
              </p>
              
              <h2>
                Web Server Configuration
              </h2>
              
              <p>
                After your web server compiles you need do add a script to your system to facilitate the stopping/starting/restarting of the nginx web server.
              </p>
              
              <p>
                I found the script (and instructions) below at the following site: <a href="http://library.linode.com/development/frameworks/ruby/ruby-on-rails/nginx-ubuntu-9.10-karmic" title="http://library.linode.com/development/frameworks/ruby/ruby-on-rails/nginx-ubuntu-9.10-karmic">http://library.linode.com/development/frameworks/ruby/ruby-on-rails/nginx-ubuntu-9.10-karmic</a>
              </p>
              
              <div style="border: 1px solid silver;margin: 20px 0px 10px;padding: 4px;overflow: auto;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 47.61%;font-family: 'Courier New',courier,monospace;direction: ltr;height: 336px;font-size: 8pt;cursor: text">
                <div style="border-style: none;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">#! /bin/sh</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">&nbsp;</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">### BEGIN INIT INFO</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"># Provides:          nginx</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"># Required-Start:    $all</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"># Required-Stop:     $all</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"># <span style="color: #0000ff">Default</span>-Start:     2 3 4 5</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"># <span style="color: #0000ff">Default</span>-Stop:      0 1 6</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"># Short-Description: starts the nginx web server</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"># Description:       starts nginx using start-stop-daemon</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">### END INIT INFO</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">&nbsp;</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">PATH=/opt/nginx/sbin:/sbin:/bin:/usr/sbin:/usr/bin</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">DAEMON=/opt/nginx/sbin/nginx</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">NAME=nginx</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">DESC=nginx</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">&nbsp;</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">test -x $DAEMON || <span style="color: #0000ff">exit</span> 0</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">&nbsp;</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #cc6633"># Include</span> nginx defaults <span style="color: #0000ff">if</span> available</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #0000ff">if</span> [ -f /etc/<span style="color: #0000ff">default</span>/nginx ] <span style="color: #008000">; then</span></pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">        . /etc/<span style="color: #0000ff">default</span>/nginx</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">fi</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">&nbsp;</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">set -e</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">&nbsp;</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #0000ff">case</span> <span style="color: #006080">"$1"</span> <span style="color: #0000ff">in</span></pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">  start)</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">        echo -n <span style="color: #006080">"Starting $DESC: "</span></pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">        start-stop-daemon --start --quiet --pidfile /opt/nginx/logs/$NAME.pid </pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">                --exec $DAEMON -- $DAEMON_OPTS</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">        echo <span style="color: #006080">"$NAME."</span></pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">        <span style="color: #008000">;;</span></pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">  stop)</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">        echo -n <span style="color: #006080">"Stopping $DESC: "</span></pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">        start-stop-daemon --stop --quiet --pidfile /opt/nginx/logs/$NAME.pid </pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">                --exec $DAEMON</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">        echo <span style="color: #006080">"$NAME."</span></pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">        <span style="color: #008000">;;</span></pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">  restart|force-reload)</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">        echo -n <span style="color: #006080">"Restarting $DESC: "</span></pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">        start-stop-daemon --stop --quiet --pidfile </pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">                /opt/nginx/logs/$NAME.pid --exec $DAEMON</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">        sleep 1</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">        start-stop-daemon --start --quiet --pidfile </pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">                /opt/nginx/logs/$NAME.pid --exec $DAEMON -- $DAEMON_OPTS</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">        echo <span style="color: #006080">"$NAME."</span></pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">        <span style="color: #008000">;;</span></pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">  reload)</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">          echo -n <span style="color: #006080">"Reloading $DESC configuration: "</span></pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">          start-stop-daemon --stop --signal HUP --quiet --pidfile     /opt/nginx/logs/$NAME.pid </pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">              --exec $DAEMON</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">          echo <span style="color: #006080">"$NAME."</span></pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">          <span style="color: #008000">;;</span></pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">      *)</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">            N=/etc/init.d/$NAME</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">            echo <span style="color: #006080">"Usage: $N {start|stop|restart|reload|force-reload}"</span> &gt;<span style="color: #008000">;&2</span></pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">            <span style="color: #0000ff">exit</span> 1</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">            <span style="color: #008000">;;</span></pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">    esac</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">&nbsp;</pre>
                  
                  <p>
                    <!--CRLF-->
                  </p>
                  
                  <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">    <span style="color: #0000ff">exit</span> 0</pre>
                  
                  <p>
                    <!--CRLF--></div> </div> 
                    
                    <p>
                      Copy this file to a file called &ldquo;nginx&rdquo; in your /etc/init.d folder
                    </p>
                    
                    <p>
                      Run the following code to make the script runnable and start your nginx web server when Ubuntu launches.
                    </p>
                    
                    <div style="border: 1px solid silver;margin: 20px 0px 10px;padding: 4px;overflow: auto;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 47.83%;font-family: 'Courier New',courier,monospace;direction: ltr;height: 86px;font-size: 8pt;cursor: text">
                      <div style="border-style: none;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">
                        <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">&nbsp;</pre>
                        
                        <p>
                          <!--CRLF-->
                        </p>
                        
                        <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">chmod +x /etc/init.d/nginx</pre>
                        
                        <p>
                          <!--CRLF-->
                        </p>
                        
                        <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">usr/sbin/update-rc.d -f nginx defaults </pre>
                        
                        <p>
                          <!--CRLF--></div> </div> 
                          
                          <p>
                            &nbsp;Now you can start your server with the following command
                          </p>
                          
                          <p>
                            <b><i>/etc/init.d/nginx start</i></b>
                          </p>
                          
                          <p>
                            The last step is to drop your code into a folder on your server and configure nginx to use it. When you create the folder where you plan on installing your rails application make sure to use the sudo command. The sudo command insures that nginx and passenger can run your code. The following two lines create a directory for your application code.
                          </p>
                          
                          <div style="border: 1px solid silver;margin: 20px 0px 10px;padding: 4px;overflow: auto;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 48%;font-family: 'Courier New',courier,monospace;direction: ltr;height: 86px;font-size: 8pt;cursor: text">
                            <div style="border-style: none;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">
                              <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">&nbsp;</pre>
                              
                              <p>
                                <!--CRLF-->
                              </p>
                              
                              <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">cd /home</pre>
                              
                              <p>
                                <!--CRLF-->
                              </p>
                              
                              <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">sudo mkdir www.railsdinner.com</pre>
                              
                              <p>
                                <!--CRLF--></div> </div> 
                                
                                <p>
                                  Now copy your Rails source code into this folder.
                                </p>
                                
                                <p>
                                  Finally you need to add a configuration setting to your nginx configuration file (<b><i>cd /opt/nginx/conf/nginx.conf</i></b>) .
                                </p>
                                
                                <p>
                                  Add the following code inside the http{} brackets in your .conf file.
                                </p>
                                
                                <div style="border: 1px solid silver;margin: 20px 0px 10px;padding: 4px;overflow: auto;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 49.65%;font-family: 'Courier New',courier,monospace;direction: ltr;height: 134px;font-size: 8pt;cursor: text">
                                  <div style="border-style: none;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">
                                    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">server {</pre>
                                    
                                    <p>
                                      <!--CRLF-->
                                    </p>
                                    
                                    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">      listen 80<span style="color: #008000">;</span></pre>
                                    
                                    <p>
                                      <!--CRLF-->
                                    </p>
                                    
                                    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt"><span style="color: #008000">      server_name railsdinner.com <a href="http://www.railsdinner.com">www.railsdinner.com</a>;</span></pre>
                                    
                                    <p>
                                      <!--CRLF-->
                                    </p>
                                    
                                    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">      root /home/www.railsdinner.com/public<span style="color: #008000">;   # &lt;--- be sure to point to 'public'!</span></pre>
                                    
                                    <p>
                                      <!--CRLF-->
                                    </p>
                                    
                                    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: white;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">      passenger_enabled on<span style="color: #008000">;</span></pre>
                                    
                                    <p>
                                      <!--CRLF-->
                                    </p>
                                    
                                    <pre style="border-style: none;margin: 0em;padding: 0px;overflow: visible;text-align: left;line-height: 12pt;background-color: #f4f4f4;width: 100%;font-family: 'Courier New',courier,monospace;direction: ltr;color: black;font-size: 8pt">   }</pre>
                                    
                                    <p>
                                      <!--CRLF--></div> </div> 
                                      
                                      <p>
                                        &nbsp;
                                      </p>
                                      
                                      <h2>
                                        Finally Rails Dinner!
                                      </h2>
                                      
                                      <p>
                                        Now simply restart your nginx server and you are off to the races.
                                      </p>
                                      
                                      <p>
                                        <b><i>/etc/init.d/nginx restart</i></b>
                                      </p>
                                      
                                      <p>
                                        Go check it out for yourself
                                      </p>
                                      
                                      <h2>
                                        <a href="http://www.railsdinner.com">www.railsdinner.com</a>
                                      </h2>
                                      
                                      <h2>
                                        &nbsp;Thanks!
                                      </h2>
                                      
                                      <h2>
                                      </h2>
                                      
                                      <p>
                                        Thanks to John Petersen for creating this application. It was a great learning experience and it took his work to inspire this endeavor.
                                      </p>