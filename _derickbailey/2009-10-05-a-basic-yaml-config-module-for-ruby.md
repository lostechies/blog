---
wordpress_id: 90
title: A Basic YAML Config Module For Ruby
date: 2009-10-05T16:39:01+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/10/05/a-basic-yaml-config-module-for-ruby.aspx
dsq_thread_id:
  - "262068355"
categories:
  - Albacore
  - Principles and Patterns
  - Ruby
redirect_from: "/blogs/derickbailey/archive/2009/10/05/a-basic-yaml-config-module-for-ruby.aspx/"
---
In the process of working with [Albacore](https://github.com/derickbailey/Albacore) and creating a task to wrap around SQL Server’s [SQLCmd.exe](http://msdn.microsoft.com/en-us/library/ms162773.aspx), I wanted to ensure that I could allow individual developers the ability to easily provide their own database server connection information, so that they can easily run database scripts against their local database server instance. To do this, I decided to have a little fun with [YAML](http://www.yaml.org/) and some [ruby metaprogramming](http://pragdave.blogs.pragprog.com/pragdave/2008/06/screencasting-r.html). 

### The YAMLConfigBase Mixin

The end result is a little YAMLConfig module that allows you to mixin the ability to dynamically add / set some attributes on a ruby class.

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> require <span style="color: #006080">'yaml'</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span> module YAMLConfigBase</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>     def configure(yml_file)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>         config = YAML::load(File.open(yml_file))</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>         parse_config config</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>     end    </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>     </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>     def parse_config(config)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>         config.each <span style="color: #0000ff">do</span> |key, value|</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>             setter = <span style="color: #006080">"#{key}="</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>             self.<span style="color: #0000ff">class</span>.send(:attr_accessor, key) <span style="color: #0000ff">if</span> !respond_to?(setter)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>             send setter, value</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span>         end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span>     end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span> end</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        This code will read a simple name/value pair from a yaml file, loop through each of the pairs and set an attr_accessor to that name, with that value. It’s also smart enough to check and see if the attr_accessor exists, before trying to create it. So you can configure a ruby object that already has attributes set up, with this utility.
      </p>
      
      <h3>
        Using YAMLConfigBase
      </h3>
      
      <p>
        Any class that includes the YAMLConfigBase module will be able to easily load a yaml file and have the key / value pairs from that yaml file automatically set as attributes w/ values.
      </p>
      
      <p>
        If we have this yml in a file called “someconfigfile.yml”
      </p>
      
      <div>
        <div>
          <pre><span style="color: #606060">   1:</span> my_setting: my value goes here!</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              and we have this ruby code:
            </p>
            
            <div>
              <div>
                <pre><span style="color: #606060">   1:</span> require <span style="color: #006080">'yamlconfigbase'</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   2:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   3:</span> <span style="color: #0000ff">class</span> Foo</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   4:</span>   include YAMLConfigBase</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   5:</span> end</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   6:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   7:</span> f = Foo.<span style="color: #0000ff">new</span></pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   8:</span> f.configure(<span style="color: #006080">"someconfigfile.yml"</span>)</pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">   9:</span>&#160; </pre>
                
                <p>
                  <!--CRLF-->
                </p>
                
                <pre><span style="color: #606060">  10:</span> puts f.my_setting</pre>
                
                <p>
                  <!--CRLF--></div> </div> 
                  
                  <p>
                    we end up with this output (running IRB in windows command prompt):
                  </p>
                  
                  <p>
                    <img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" border="0" alt="image" src="https://lostechies.com/content/derickbailey/uploads/2011/03/image_6CE8D814.png" width="446" height="263" />
                  </p>
                </p>
                
                <p>
                  The “Foo” class in this example only has 3 lines of code in it, yet I was able to create, set, and get a value in an attribute that I defined in a yaml file. You want to talk about <a href="http://en.wikipedia.org/wiki/Don%27t_repeat_yourself">DRY</a> code? This is death-valley in the middle of a summer drought, dry. 🙂
                </p>
                
                <p>
                  I know it’s not super-duper-amazingly-original stuff, but it’s fun to do this kind of thing and make the rest of a framework easily configurable through yaml. It also shows the power of meta-programming and dynamic languages like ruby.
                </p>