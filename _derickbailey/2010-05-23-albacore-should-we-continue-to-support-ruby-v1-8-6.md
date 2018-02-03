---
wordpress_id: 160
title: 'Albacore: Should We Continue To Support Ruby v1.8.6?'
date: 2010-05-23T19:08:44+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/05/23/albacore-should-we-continue-to-support-ruby-v1-8-6.aspx
dsq_thread_id:
  - "270051558"
categories:
  - Albacore
  - Ruby
---
Ruby 1.8.6 seems to be an outdated version at this point… but I can’t find any official information on the life cycle and support plans for this version. I’d like to drop support for Ruby 1.8.6 from [albacore](http://albacorebuild.net), but I’m not sure if that’s a good idea. Here’s why I want to drop it:

I&#8217;m working on a new block configuration syntax that will make albacore much easier to deal with. It will let you set up a global and/or task level configuration in one place and have all instances of that configured task or everything that uses that global config option, behave the same way. There’s been a lot of conversation about this over on the google group, so if you want to know more, you should [go read up at the group](http://groups.google.com/group/albacoredev/browse_thread/thread/78b45ed4455c9fe5).

At this point, I&#8217;ve got some pretty nice syntax working that allows any task to add a new configuration method (better than originally shown in the above linked discussion). It let&#8217;s the calling code determine whether the config method will have a code block or not. Here&#8217;s the test that i have running and passing:

<div>
  <div>
    <pre><span style="color: #606060">   1:</span> describe <span style="color: #006080">"when providing a configuration method to the configuration api"</span> <span style="color: #0000ff">do</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   2:</span>   before :all <span style="color: #0000ff">do</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   3:</span>     <span style="color: #0000ff">class</span> Test</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   4:</span>       attr_accessor :test</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   5:</span>     end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   6:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   7:</span>     Albacore.configure <span style="color: #0000ff">do</span> |config|</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   8:</span>       config.add_configuration :testfoo <span style="color: #0000ff">do</span> |&block| </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">   9:</span>         block.call(Test.<span style="color: #0000ff">new</span>) unless block.nil?</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  10:</span>       end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  11:</span>     end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  12:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  13:</span>     Albacore.configure <span style="color: #0000ff">do</span> |config|</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  14:</span>       config.testfoo <span style="color: #0000ff">do</span> |testdata|</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  15:</span>         testdata.test = <span style="color: #006080">"this is config data"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  16:</span>         @configdata = testdata</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  17:</span>       end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  18:</span>     end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  19:</span>   end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  20:</span>&#160; </pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  21:</span>   it <span style="color: #006080">"should accept a parameter for configuration data"</span> <span style="color: #0000ff">do</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  22:</span>     @configdata.test.should == <span style="color: #006080">"this is config data"</span></pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  23:</span>   end</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre><span style="color: #606060">  24:</span> end</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        I like this syntax and i like the functionality it provides&#8230; however, it doesn&#8217;t work in ruby 1.8.6. That version of ruby does not support the |&block| parameter syntax on line 8. So, I&#8217;m wondering&#8230; should albacore drop ruby 1.8.6 support in order to get this feature syntax in place? or should i try to find another way to make it work? &#8230; I&#8217;ve been unable to get "yield if block_given?" syntax to work in this scenario&#8230; for some reason, block_given? always returns false when placed on line 9, which is why I switched to the |&block| syntax in the first place.
      </p>
      
      <p>
        This new syntax works fine in ruby 1.8.7 and ruby 1.9.1… just not 1.8.6
      </p>
      
      <p>
        I don&#8217;t know if that&#8217;s a good reason to drop ruby 1.8.6 support or not&#8230; is there a good reason to drop it? is it really necessary to support that version? ??? thoughts? suggestions? feel free to respond in comments here, or join the google group and respond to <a href="http://groups.google.com/group/albacoredev/browse_thread/thread/68a8b3031096f61f">the discussion there</a>.
      </p>