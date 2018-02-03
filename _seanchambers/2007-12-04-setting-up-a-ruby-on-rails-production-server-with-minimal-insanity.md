---
wordpress_id: 3154
title: Setting up a Ruby on Rails Production Server while keeping your sanity
date: 2007-12-04T12:35:40+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2007/12/04/setting-up-a-ruby-on-rails-production-server-with-minimal-insanity.aspx
dsq_thread_id:
  - "263238944"
categories:
  - Uncategorized
---
So last week a co-worker came to me and said he needed a &#8220;quick and dirty&#8221; application for keeping track of assets internally. I told him that I didn&#8217;t have enough time to do a full scale .Net web app but that perhaps RoR could give us what we were looking for. Within 30 minutes we had a pretty good looking model setup and was entering dummy data into it with the help of scaffolding. My co-worker assured me that this would be fine for now pending a handful of changes and validations to perform when entering data. That being said I set off to get a production server up and running. That&#8217;s where I left my sanity.

This post will just go over the steps I took to setup a RoR production server and getting deployment to work. The article that helped get everything setup was <a href="http://www.urbanpuddle.com/articles/2007/05/09/install-ruby-on-rails-on-ubuntu-feisty-fawn" target="_blank">this blog posting here</a> by <a href="http://www.urbanpuddle.com" target="_blank">Urbanpuddle</a>. That post gets you pretty much 99% of the way there and walks you through setting up almost everything in Ubuntu. There were a couple of quirks near the end that I will go over.

Now, I am a RoR newbie so I really can&#8217;t complain about the language at all. I find it to be very easy to use with a huge support community. My pain point is getting a darn production server up and running. The amount of steps that you must take is just absolutely ridiculous. As far as a *nix production server goes, it needs ALOT of work. Just to give you a small taste of what you need to setup on your production server:

**  
Step 1. Supporting Libraries**

  * ruby, ri, rdoc 
      * mysql-server 
          * libmysql-ruby 
              * ruby1.8-dev 
                  * irb1.8 
                      * libdbd-mysql-perl 
                          * libdbi-perl 
                              * libmysql-ruby1.8 
                                  * libnet-daemon-perl 
                                      * libplrpc-perl 
                                          * libreadline-ruby1.8 
                                              * libruby1.8 
                                                  * mysql-client-5.0 
                                                      * mysql-common 
                                                          * mysql-server-5.0 
                                                              * ruby1.8 </ul> 
                                                            Now this is just absolutely crazy. The ruby guys really need to include all of this in one single package like they recently did for the <a href="http://www.bitnami.org/product/rubystack" target="_blank">BitNami RubyStack</a>. I think this is where they are heading with it. There is a spot for Linux and Mac x86 but only for available for windows at the moment. When they do complete this it will allow a lot of people to keep all of their hair.
                                                            
                                                            **  
                                                            Step 2. Install RubyGems & Ruby on Rails**
                                                            
                                                            So now we can get down to the meat and potatoes. Once you install the exhaustive list of apps above you can install Ruby Gems and then install rails. No problems there. This is pretty well documented on how to install so I won&#8217;t dive into this.
                                                            
                                                            **Step 3. Web Server (Nginx and Mongrel)**
                                                            
                                                            Before I describe the steps here, I will give credit to <a href="http://www.gregbenedict.com/" target="_blank">Greg Benedict</a> for his blog post on Nginx/Mongrel as this is what I used to get it working. I had to modify how the configuration is setup to suit my needs but his post got me almost all the way there. <a href="http://www.gregbenedict.com/2007/07/06/hosting-rails-apps-using-nginx-and-mongrel-cluster/" target="_blank">You can find his detailed post here.</a>
                                                            
                                                            [<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;margin: 10px 20px 0px 0px;border-right-width: 0px" height="244" alt="railsscalelighttpd15" src="http://lostechies.com/seanchambers/files/2011/03SettingupaRubyonRailsProductionServerwit_7893/railsscalelighttpd15_thumb.jpg" width="204" align="left" border="0" />](http://lostechies.com/seanchambers/files/2011/03SettingupaRubyonRailsProductionServerwit_7893/railsscalelighttpd15_2.jpg)First let me describe how all of this fits together. I was a little confused at first and would have liked a description as to how everything works. I found this picture on the net to give a basic overview of how Nginx and Mongrel fit together.
                                                            
                                                            User requests a page and nginx is dispatched. The configuration file is checked and then the request is forwarded to an available mongrel in the cluster.
                                                            
                                                            In the picture to the left we have 3 mongrels in the cluster. Pretty straight forward.
                                                            
                                                            Now, I chose nginx as a web server this time around. About 6 months ago I attempted to get apache to work with Mongrel clusters and I could never get it to work so I gave up. This time around I figured I would give something else a try. After looking around I found that Nginx was really easy to configure and a VERY small memory footprint, like 10mb or something around there. That&#8217;s what sold me on it.
                                                            
                                                            So first you need to install Nginx (pronounced engine x) and once thats done, you install fastcgi. Fastcgi is used for parsing php pages like phpMyAdmin for managing the mysql databases. If you are comfortable managing mysql from the command line, then don&#8217;t bother with phpMyAdmin.
                                                            
                                                            Next is the nginx configuration file. The way I was setting&nbsp;up my server is to have multiple named virtual hosts so that I could host multiple ruby apps from the same machine name. The first thing I had to do was add a CNAME wildcard into DNS so that anything.myservername.com would get forwarded to the same IP address. Next you setup a generic nginx.conf file to handle the general configuration. This will apply whether you are doing multiple named virtual hosts or not.
                                                            
                                                            Here is the configuration that I am using. It is located at /etc/nginx/nginx.conf
                                                            
                                                            &nbsp;
                                                            
                                                            <div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;height: 231px;background-color: #f4f4f4">
                                                              <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;height: 961px;background-color: #f4f4f4;border-bottom-style: none"><p>
  user www-data www-data;
  
  worker_processes 1;
  
  pid /var/run/nginx.pid;
  
  <span style="color: #008000"># Valid error reporting levels are debug, notice and info</span>
  error_log /var/log/nginx/error.log debug;
  
  events {
    worker_connections 1024;
  }
  
  http {
    <span style="color: #008000"># pull in mime-types. You can break out your config</span>
    <span style="color: #008000"># into as many include.s as you want to make it cleaner</span>
    include /etc/nginx/mime.types;
  
    <span style="color: #008000"># set a default type for the rare situation that</span>
    <span style="color: #008000"># nothing matches from the mimie-type include</span>
    default_type application/octet-stream;
  
    <span style="color: #008000"># configure log format</span>
    log_format main .$remote_addr - $remote_user [$time_local] .
    ..$request. $status $body_bytes_sent .$http_referer. .
    ..$http_user_agent. .$http_x_forwarded_for..;
  
    <span style="color: #008000"># main access log</span>
    access_log /var/log/nginx_access.log main;
  
    <span style="color: #008000"># main error log</span>
    error_log /var/log/nginx_error.log debug;
  
    <span style="color: #008000"># no sendfile on OSX</span>
    sendfile on;
  
    <span style="color: #008000"># These are good default values.</span>
    tcp_nopush on;
    keepalive_timeout 65;
    tcp_nodelay on;
  
    <span style="color: #008000"># output compression saves bandwidth</span>
    gzip on;
    gzip_min_length 1100;
    gzip_buffers 4 8k;
    gzip_types text/plain text/html text/css application/x-javascript text/xml application/xml application/xml+rss text/javascr$
    gzip_http_version 1.0;
    gzip_comp_level 2;
    gzip_proxied any;
  
    server_names_hash_bucket_size 64;
  
    <span style="color: #008000"># The following includes are specified for virtual hosts</span>
    include /var/www/app1/current/config/nginx.conf;
    include /var/www/app2/current/config/nginx.conf;<br />  include /var/www/app3/current/config/nginx.conf
  }
  
</p></pre>
                                                            </div>
                                                            
                                                            &nbsp;
                                                            
                                                            Pay attention to the last 3 lines in the nginx.conf. These lines include an external configuration that is located under the apps config directories. What this does for us is it allows you to just add one line in your /etc/nginx/nginx.conf, and thats all that needs to be done in nginx when adding another application to your server. Pretty nifty.
                                                            
                                                            And here is the configuration for my app1 which is located in&nbsp; /var/www/app1/current/config/nginx.conf
                                                            
                                                            <div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
                                                              <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #008000"># The name of the upstream server is used by the mongrel</span>
<span style="color: #008000"># section below under the server declaration</span>
upstream app1 {
  server 127.0.0.1:8000;
  server 127.0.0.1:8001;
  server 127.0.0.1:8002;
}

server {
  <span style="color: #008000"># port to listen on. Can also be set to an IP:PORT</span>
  listen 80;

  <span style="color: #008000"># Set the max size for file uploads to 50Mb</span>
  client_max_body_size 50M;

  <span style="color: #008000"># sets the domain[s] that this vhost server requests for.</span>
  server_name app1.myservername.com;

  <span style="color: #008000"># doc root</span>
  root /var/www/app1/current/public;

  <span style="color: #008000"># vhost specific access log</span>
  access_log /var/www/app1/current/log/nginx.access.log main;

  <span style="color: #008000"># this rewrites all the requests to the maintenance.html</span>
  <span style="color: #008000"># page if it exists in the doc root. This is for capistrano.s</span>
  <span style="color: #008000"># disable web task</span>
  <span style="color: #0000ff">if</span> (-f $document_root/system/maintenance.html) {
    rewrite ^(.*)$ /system/maintenance.html last;
    <span style="color: #0000ff">break</span>;
  }

  location / {
    <span style="color: #008000"># Uncomment to allow server side includes so nginx can</span>
    <span style="color: #008000"># post-process Rails content</span>
    <span style="color: #008000">## ssi on;</span>

    <span style="color: #008000"># needed to forward user.s IP address to rails</span>
    proxy_set_header X-Real-IP $remote_addr;
    <span style="color: #008000"># needed for HTTPS</span>
    <span style="color: #008000">#proxy_set_header X_FORWARDED_PROTO https;</span>

    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect false;
    proxy_max_temp_file_size 0;

    <span style="color: #008000"># If the file exists as a static file serve it directly without</span>
    <span style="color: #008000"># running all the other rewite tests on it</span>
    <span style="color: #0000ff">if</span> (-f $request_filename) {
      <span style="color: #0000ff">break</span>;
    }

    <span style="color: #008000"># check for index.html for directory index</span>
    <span style="color: #008000"># if its there on the filesystem then rewite</span>
    <span style="color: #008000"># the url to add /index.html to the end of it</span>
    <span style="color: #008000"># and then break to send it to the next config rules.</span>
    <span style="color: #0000ff">if</span> (-f $request_filename/index.html) {
      rewrite (.*) $1/index.html <span style="color: #0000ff">break</span>;
    }

    <span style="color: #008000"># Look for existence of PHP index file.</span>
    <span style="color: #008000"># Don.t break here.just rewrite it.</span>
    <span style="color: #0000ff">if</span> (-f $request_filename/index.php) {
      rewrite (.*) $1/index.php;
    }

    <span style="color: #008000"># this is the meat of the rails page caching config</span>
    <span style="color: #008000"># it adds .html to the end of the url and then checks</span>
    <span style="color: #008000"># the filesystem for that file. If it exists, then we</span>
    <span style="color: #008000"># rewite the url to have explicit .html on the end</span>
    <span style="color: #008000"># and then send it on its way to the next config rule.</span>
    <span style="color: #008000"># if there is no file on the fs then it sets all the</span>
    <span style="color: #008000"># necessary headers and proxies to our upstream mongrels</span>
    <span style="color: #0000ff">if</span> (-f $request_filename.html) {
      rewrite (.*) $1.html <span style="color: #0000ff">break</span>;
    }

    <span style="color: #008000"># You.ll need to change this proxy_pass to match what</span>
    <span style="color: #008000"># what you specified above. It must be unique to each vhost.</span>
    <span style="color: #0000ff">if</span> (!-f $request_filename) {
      proxy_pass http://app1;
      <span style="color: #0000ff">break</span>;
    }
  }

  error_page 500 502 503 504 /500.html;
  location = /500.html {
    root /var/www/app1/current/public;
  }
}
</pre>
                                                            </div>
                                                            
                                                            &nbsp;
                                                            
                                                            First pay attention&nbsp;at the top where you have the upstream section. Note the name as it is used further in the config file to state what mongrel cluster nginx should forward to for this servername.
                                                            
                                                            The thing to nice is that most of this configuration is encapsulated in a server {} tag. This is the section that holds a virtual host. You can have as many of these as you want per nginx. I have just seperated them out into seperate files to facilitate easier configuration.
                                                            
                                                            Second, make note of &#8220;server_name&#8221; and change that to the server name that will be handling requests for this app. This can be myserver.com, or you can have it setup as a subdomain as I do.
                                                            
                                                            Last, change all other references to app1 to whatever your app is named, then at the bottom you will notice the proxy_pass. This portion is what forwards requests to your mongrel cluster. Change http://app1 to whatever you had for the upstream at the top. They need to the same otherwise you will receive 502 errors.
                                                            
                                                            Ok, now that we have the nginx configuration out of the way we can go on to your Mongrel cluster.
                                                            
                                                            The mongrel cluster is pretty easy to configure. Here is the mongrel\_cluster.yml file that you can drop into yourapp/config/mongrel\_cluster.yml
                                                            
                                                            <div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
                                                              <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;height: 140px;background-color: #f4f4f4;border-bottom-style: none">cwd: /var/www/app1/current
port: 8000
environment: production
user: produser
group: produser
address: 127.0.0.1
pid_file: /var/www/app1/shared/pids/mongrel.pid
servers: 3</pre>
                                                            </div>
                                                            
                                                            &nbsp;
                                                            
                                                            Pretty straightforward. Grab the Restart script <a href="http://topfunky.net/svn/shovel/nginx/init.d/nginx" target="_blank">found here</a>. And place that in /etc/init.d/. This will allow you to do&nbsp;&#8220;sudo /etc/init.d/mongrel_cluster&nbsp;start|stop|restart&#8221;&nbsp;
                                                            
                                                            Your&nbsp;mongrel\_cluster.yml&nbsp;file needs to be linked to /etc/mongrel/app1\_cluster.yml. This way, when you use the restart script. It will look in /etc/mongrel to restart all clusters that are running on the machine. You can create the link like so:
                                                            
                                                            sudo ln -s /var/www/app1/current/config/mongrel_cluster.yml app1.yml
                                                            
                                                            Now that you have that out of the way you can get to deployment with capistrano.
                                                            
                                                            **Step 4. Deployment with Capistrano**
                                                            
                                                            First I would&nbsp;note that if you install the latest version of Capistrano it will be version 2.1. For some reason the <a href="http://manuals.rubyonrails.com/read/book/17" target="_blank">RoR documentation</a> is outdated and references the old version of capistrano. Before you would do &#8220;rake deploy&#8221; but now you run capistrano commands like so: &#8220;cap deploy&#8221;. This was a bit of a pain but there are people out there using it so the documentation should be updated soon.
                                                            
                                                            Capistrano is a standalone utility&nbsp;much like nant. You can run different tasks, deploy in different configurations etc.. The difference is that capistrano can do a lot more stuff than nant can. I only scratched the surface so I employ you to dive further into capistrano.
                                                            
                                                            The really cool part of capistrano deployment is the ability to rollback a deployment. Basically what happens is upon deploying via capistrano, it first exports from subversion to a folder that is named the UTC datetime of the deployment. Then it creates a link from that folder to the current folder that is referenced above. Previous deployments still live in their datetime folder but are no longer symlinked to the current directory. When you want to rollback a deployment type &#8220;cap rollback&#8221; and everything is undone including your database migrations. Pretty neat eh?
                                                            
                                                            Ok, so you have your app built, you have created a subversion repository for it and have checked in your changes to your repository. Now you want to deploy it to your brand new shiny deployment server.
                                                            
                                                            This is the part where I slipped into the seventh level of hell.
                                                            
                                                            There is A LOT of different blog posts on how to accomplish this. After trying&nbsp; multitude of different ways I settled on this deployment script that lives in app1/config/deploy.rb
                                                            
                                                            <div style="border-right: gray 1px solid;padding-right: 4px;border-top: gray 1px solid;padding-left: 4px;font-size: 8pt;padding-bottom: 4px;margin: 20px 0px 10px;overflow: auto;border-left: gray 1px solid;width: 97.5%;cursor: text;line-height: 12pt;padding-top: 4px;border-bottom: gray 1px solid;font-family: consolas, 'Courier New', courier, monospace;background-color: #f4f4f4">
                                                              <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">set :application, <span style="color: #006080">"My App"</span>
set :repository,  <span style="color: #006080">"http://yoursvnserver/svn/app1/trunk"</span>
set :user, <span style="color: #006080">"username"</span>
set :password, <span style="color: #006080">"password"</span>

set :deploy_to, <span style="color: #006080">"/var/www/app1"</span>
set :deploy_via, :export

set :mongrel_conf, <span style="color: #006080">"#{deploy_to}/current/config/mongrel_cluster.yml"</span>

role :app, <span style="color: #006080">"username@mydeploymentserver.com"</span>
role :web, <span style="color: #006080">"username@mydeploymentserver.com"</span>
role :db,  <span style="color: #006080">"username@mydeploymentserver.com"</span>, :primary =&gt; true

namespace :deploy do
  desc <span style="color: #006080">"Restart mongrel servers"</span>
  task :restart, :roles =&gt; [:web] do
    run <span style="color: #006080">"cd #{release_path} && sudo /etc/init.d/mongrel_cluster restart"</span> do |ch, steam, out|
      ch.send_data <span style="color: #006080">"#{password}n"</span> <span style="color: #0000ff">if</span> out =~/password/
    <span style="color: #0000ff">end</span>

    run <span style="color: #006080">"sudo chown -R www-data:www-data #{release_path}/tmp"</span> do |ch, steam, out|
      ch.send_data <span style="color: #006080">"#{password}n"</span> <span style="color: #0000ff">if</span> out =~/password/
    <span style="color: #0000ff">end</span>
  <span style="color: #0000ff">end</span>
<span style="color: #0000ff">end</span>
</pre>
                                                            </div>
                                                            
                                                            &nbsp;
                                                            
                                                            Ok so most of the deployment file is self explanatory. :repository should be set to your repository address, Set :user and :password to the sudo user and password on your deployment server. Now, if you are deploying over the web, I would strongly suggest looking for another way to transmit this data, perhaps an SSL deployment or something. I am running this server on my internal network with limited usage so I didn&#8217;t care if all this information was sitting in my repsoitory but this is bad! bad! bad! =)
                                                            
                                                            The :deploy_via is how you want to perform the deployment from subversion. This states that subversion will perform an export to the deployment server. You can also do a :co which will perform a checkout. Export seemed like the more logical way.
                                                            
                                                            :app, :web and :db are your deployment servers. I am using all the same server so they are all the same. If you wanted to you could break out your application to seperate servers for performance. Pretty neat that it has that option ready to go in there.
                                                            
                                                            The next portion is a little different. This is where you can define commands to run, tasks to perform on the remote server. First I tell it to cd to the apps root directory and then restart the mongrel\_cluster. The ONLY thing you need to restart after a deployment is your mongrel\_cluster. There is no need to restart nginx.
                                                            
                                                            Let me clarify here. In your /etc/init.d/mongrel_cluster script it states who the mongrel clusters should run as. BE SURE that the user you defined there has access to the shared/pids folder otherwise mongrel cannot write the pid files and will fail to start. I bounced around with this problem for a couple of hours banging my head on the wall between attempts.
                                                            
                                                            Next I added in a chown command as I noticed that after everything completed successfully, the nginx user could not write the ruby sessions to the tmp directory.&nbsp;That command fixed the problem, everything was working and there was much rejoicing.
                                                            
                                                            Now, there were&nbsp;quite a few bumps in the road throughout the process that I failed to document but after searching on google for awhile and poking I was able to get around all of them. As a result if I setup another server I know what to expect now and hopefully so will you!
                                                            
                                                            I hope this helps at least one person avoid the insanity that I endured for a couple of days. Good luck!