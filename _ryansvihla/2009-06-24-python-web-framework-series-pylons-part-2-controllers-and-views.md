---
wordpress_id: 14
title: 'Python Web Framework Series – Pylons: Part 2 Controllers, Views and Testing'
date: 2009-06-24T13:22:00+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2009/06/24/python-web-framework-series-pylons-part-2-controllers-and-views.aspx
dsq_thread_id:
  - "426715348"
categories:
  - Pylons
  - Python
---
We last left off with <a target="_blank" href="/blogs/rssvihla/archive/2009/06/23/python-web-framework-series-pylons-part-1-getting-started.aspx">Getting Started</a> and having created our &ldquo;pylonsforum&rdquo; project and generated our first controller.

Source for home.py

   ``

<div class="wlWriterEditableSmartContent" style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px">
  <div style="font-family:consolas,lucida console,courier,monospace">
    <span style="color: #0000ff">import</span>&nbsp;logging&nbsp;</p> 
    
    <p>
      <span style="color: #0000ff">from</span>&nbsp;pylons&nbsp;<span style="color: #0000ff">import</span>&nbsp;request,&nbsp;response,&nbsp;session,&nbsp;tmpl_context&nbsp;<span style="color: #0000ff">as</span>&nbsp;c&nbsp;<br /> <span style="color: #0000ff">from</span>&nbsp;pylons.controllers.util&nbsp;<span style="color: #0000ff">import</span>&nbsp;abort,&nbsp;redirect_to&nbsp;
    </p>
    
    <p>
      <span style="color: #0000ff">from</span>&nbsp;pylonsforum.lib.base&nbsp;<span style="color: #0000ff">import</span>&nbsp;BaseController,&nbsp;render&nbsp;
    </p>
    
    <p>
      log&nbsp;=&nbsp;logging.getLogger(__name__)&nbsp;
    </p>
    
    <p>
      <span style="color: #0000ff">class</span>&nbsp;<span style="color: #2b91af">HomeController</span>(BaseController):&nbsp;
    </p>
    
    <p>
      &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">def</span>&nbsp;index(self):&nbsp;<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000">#&nbsp;Return&nbsp;a&nbsp;rendered&nbsp;template&nbsp;</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000">#return&nbsp;render(&#8216;/home.mako&#8217;)&nbsp;</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000">#&nbsp;or,&nbsp;return&nbsp;a&nbsp;response&nbsp;</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">return</span>&nbsp;<span style="color: #a31515">&#8216;Hello&nbsp;World</span> </div> </div> 
      
      <p>
        Source for test_home.py<code></code>
      </p>
      
      <p>
        &nbsp;
      </p>
      
      <div class="wlWriterEditableSmartContent" style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px">
        <div style="font-family:consolas,lucida console,courier,monospace">
          <span style="color: #0000ff">from</span>&nbsp;pylonsforum.tests&nbsp;<span style="color: #0000ff">import</span>&nbsp;*&nbsp;</p> 
          
          <p>
            <span style="color: #0000ff">class</span>&nbsp;<span style="color: #2b91af">TestHomeController</span>(TestController):&nbsp;
          </p>
          
          <p>
            &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">def</span>&nbsp;test_index(self):&nbsp;<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;response&nbsp;=&nbsp;self.app.get(url(controller=<span style="color: #a31515">&#8216;home&#8217;</span>,&nbsp;action=<span style="color: #a31515">&#8216;index&#8217;</span>))&nbsp;<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000">#&nbsp;Test&nbsp;response&#8230;</span> </div> </div> 
            
            <p>
              &nbsp;
            </p>
            
            <h3>
              <code></code>
            </h3>
            
            <p>
              &nbsp;
            </p>
            
            <h3>
              Some Testing Setup
            </h3>
            
            <p>
              Now this is optional but these are some things I got out of the <a target="_blank" href="http://pylonsbook.com">Pylons Book</a> with test setup, mainly I wanted to refresh the test database on every go.
            </p>
            
            <p>
              first open up test.ini in the top level of your project and change the [app:main] section to the following:
            </p>
            
            <hr />
            
            <p>
              &nbsp;
            </p>
            
            <div class="wlWriterEditableSmartContent" style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px">
              <div style="font-family:consolas,lucida console,courier,monospace">
                [app:main]<br /> #use&nbsp;=&nbsp;config:development.ini<br /> use&nbsp;=&nbsp;egg:pylonsforum<br /> full_stack&nbsp;=&nbsp;true<br /> cache_dir&nbsp;=&nbsp;%&nbsp;(here)s/data<br /> beaker.session.key&nbsp;=&nbsp;pylonsforum<br /> beaker.session.secret&nbsp;=&nbsp;somesecret</p> 
                
                <p>
                  sqlalchemy.url&nbsp;=&nbsp;sqlite:///%(here)s/test.db </div> </div> 
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <hr />
                  
                  <p>
                    Then open up websetup.py in the pylonsforum directory and change it to so:
                  </p>
                  
                  <div class="wlWriterEditableSmartContent" style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      <span style="color: #a31515">&#8220;&#8221;&#8221;Setup&nbsp;the&nbsp;pylonsforum&nbsp;application&#8221;&#8221;&#8221;</span><br /> <span style="color: #0000ff">import</span>&nbsp;logging<br /> <span style="color: #0000ff">from</span>&nbsp;pylonsforum&nbsp;<span style="color: #0000ff">import</span>&nbsp;model<br /> <span style="color: #0000ff">import</span>&nbsp;os.path</p> 
                      
                      <p>
                        <span style="color: #0000ff">from</span>&nbsp;pylonsforum.config.environment&nbsp;<span style="color: #0000ff">import</span>&nbsp;load_environment
                      </p>
                      
                      <p>
                        log&nbsp;=&nbsp;logging.getLogger(__name__)
                      </p>
                      
                      <p>
                        <span style="color: #0000ff">def</span>&nbsp;setup_app(command,&nbsp;conf,&nbsp;vars):<br /> &nbsp;&nbsp;&nbsp;&nbsp;load_environment(conf.global_conf,&nbsp;conf.local_conf)<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000">#&nbsp;Load&nbsp;the&nbsp;models</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">from</span>&nbsp;pylonsforum.model&nbsp;<span style="color: #0000ff">import</span>&nbsp;meta<br /> &nbsp;&nbsp;&nbsp;&nbsp;meta.metadata.bind&nbsp;=&nbsp;meta.engine<br /> &nbsp;&nbsp;&nbsp;&nbsp;filename&nbsp;=&nbsp;os.path.split(conf.filename)[-1]<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">if</span>&nbsp;filename&nbsp;==&nbsp;<span style="color: #a31515">&#8216;test.ini&#8217;</span>:<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000">#&nbsp;Permanently&nbsp;drop&nbsp;any&nbsp;existing&nbsp;tables</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;log.info(<span style="color: #a31515">&#8220;Dropping&nbsp;existing&nbsp;tables&#8230;&#8221;</span>)<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;meta.metadata.drop_all(checkfirst=True)<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000">#&nbsp;Continue&nbsp;as&nbsp;before</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000">#&nbsp;Create&nbsp;the&nbsp;tables&nbsp;if&nbsp;they&nbsp;aren&#8217;t&nbsp;there&nbsp;already</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;meta.metadata.create_all(checkfirst=True)<br /> &nbsp;&nbsp;&nbsp;&nbsp;log.info(<span style="color: #a31515">&#8220;Successfully&nbsp;set&nbsp;up.&#8221;</span>)
                      </p>
                    </div>
                  </div>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <p>
                    this will ensure a proper refresh of the database each time you run a test.
                  </p>
                  
                  <h3>
                    &nbsp;
                  </h3>
                  
                  <h3>
                    Testing
                  </h3>
                  
                  <p>
                    Now that we&rsquo;re setup lets get onto testing (test first).
                  </p>
                  
                  <p>
                    So far my study has found pylons to emphasize functional tests over unit tests. Hopefully, those with more experience will correct me. On the plus side nothing is stopping you from unit tests, and the functional test support is really nice giving you access to the response object including your view.
                  </p>
                  
                  <p>
                    The response object there will let you examine the html returned based on the conditions you&rsquo;ve set. lets not get to advanced yet and just change test_index to look for a specific page title so change the test_index test to the following
                  </p>
                  
                  <div class="wlWriterEditableSmartContent" style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      &nbsp;&nbsp;<span style="color: #007020"><strong>def</strong></span>&nbsp;<span style="color: #06287e">test_index_title</span>(<span style="color: #007020">self</span>):<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;response&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #007020">self</span><span style="color: #666666">.</span>app<span style="color: #666666">.</span>get(url(controller<span style="color: #666666">=</span><span style="color: #4070a0">&#8216;home&#8217;</span>,&nbsp;action<span style="color: #666666">=</span><span style="color: #4070a0">&#8216;index&#8217;</span>))<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #007020"><strong>assert</strong></span>&nbsp;<span style="color: #4070a0">&#8220;<title>Pylons&nbsp;Forum</title>&#8221;</span>&nbsp;<span style="color: #007020"><strong>in</strong></span>&nbsp;response<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #60a0b0"><i>#&nbsp;Test&nbsp;response&#8230;</i></span>
                    </div>
                  </div>
                  
                  <p>
                    so what we have here is a test asserting that our web response is able to find &ldquo;<title>Pylons Forum</title>&rdquo; in the page somewhere. running the following command from the top level directory where test.ini is located:
                  </p>
                  
                  <p>
                    <code>nosetests --with-pylons=test.ini</code>
                  </p>
                  
                  <p>
                    will results in the following failed test result:
                  </p>
                  
                  <p>
                    &nbsp;<a href="//lostechies.com/ryansvihla/files/2011/03/Picture2_515024A0.png"><img height="274" width="847" border="0" src="//lostechies.com/ryansvihla/files/2011/03/Picture2_thumb_07C0D6A3.png" alt="Picture 2" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" /></a>
                  </p>
                  
                  <h3>
                    Controller and view review
                  </h3>
                  
                  <p>
                    Pylons has a return based controller/action behavior. So it can return a number of objects for now we can focus on raw text and rendering a view.
                  </p>
                  
                  <p>
                    As you can see from the comments rendering a view is as simple as placing one in the template directory
                  </p>
                  
                  <p>
                    edit home.py index action to look like so:
                  </p>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <div class="wlWriterEditableSmartContent" style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      &nbsp;&nbsp;<span style="color: #0000ff">def</span>&nbsp;index(self):<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #0000ff">return</span>&nbsp;render(<span style="color: #a31515">&#8216;index.mako&#8217;</span>)
                    </div>
                  </div>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <p>
                    then create a file in the templates directory called index.mako that looks like so
                  </p>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <div class="wlWriterEditableSmartContent" style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      <span style="color: #507090"><!DOCTYPE&nbsp;html&nbsp;PUBLIC&nbsp;&#8220;-//W3C//DTD&nbsp;XHTML&nbsp;1.0&nbsp;Transitional//EN&#8221;&nbsp;&#8220;http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd&#8221;></span><br /> <span style="color: #007000"><head></span><br /> <span style="color: #007000"><title></span>Pylons&nbsp;Forum<span style="color: #007000"></title></span><br /> <span style="color: #007000"></head></span><br /> <span style="color: #007000"><body></span><br /> <span style="color: #007000"><div</span>&nbsp;<span style="color: #0000c0">id=</span>&#8220;recentposts&#8221;&nbsp;<span style="color: #0000c0">style=</span>&#8220;float:&nbsp;right&#8221;&nbsp;<span style="color: #007000">></span><br /> <span style="color: #007000"><table></span><br /> <span style="color: #007000"><thead><tr><th></span>subject<span style="color: #007000"></th><th></span>author<span style="color: #007000"></th><th></span>date&nbsp;submitted<span style="color: #007000"></th></tr></thead></span><br /> <span style="color: #007000"><tbody></span><br /> <span style="color: #007000"><tr><td></span>jkruse<span style="color: #007000"></td><td></span>Re:&nbsp;Whats&nbsp;Up<span style="color: #007000"></td><td></span>06/01/2009<span style="color: #007000"></td></tr></span><br /> <span style="color: #007000"><tr><td></span>rsvihla<span style="color: #007000"></td><td></span>Whats&nbsp;Up<span style="color: #007000"></td><td></span>06/01/2009<span style="color: #007000"></td></tr></span><br /> <span style="color: #007000"><tr><td></span>thondo<span style="color: #007000"></td><td></span>Re:&nbsp;Looking&nbsp;for&nbsp;new&nbsp;work<span style="color: #007000"></td><td></span>05/25/2009<span style="color: #007000"></td></tr></span><br /> <span style="color: #007000"><tr><td></span>jkruse<span style="color: #007000"></td><td></span>Re:&nbsp;Looking&nbsp;for&nbsp;new&nbsp;work<span style="color: #007000"></td><td></span>5/20/2009<span style="color: #007000"></td></tr></span><br /> <span style="color: #007000"><tr><td></span>usmith<span style="color: #007000"></td><td></span>Looking&nbsp;for&nbsp;new&nbsp;work<span style="color: #007000"></td><td></span>05/01/2009<span style="color: #007000"></td></tr></span><br /> <span style="color: #007000"></tbody></span><br /> <span style="color: #007000"></table></span><br /> <span style="color: #007000"></div></span><br /> <span style="color: #007000"></body></span>
                    </div>
                  </div>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <h3>
                  </h3>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <p>
                    Now that we&rsquo;ve created our view and our action rendering said view, lets run our test again and see what we get:
                  </p>
                  
                  <p>
                    <a href="//lostechies.com/ryansvihla/files/2011/03/Picture4_52B6D823.png"><img height="169" width="810" border="0" src="//lostechies.com/ryansvihla/files/2011/03/Picture4_thumb_0993BD1B.png" alt="Picture 4" style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" /></a>
                  </p>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <h3>
                    In Closing
                  </h3>
                  
                  <p>
                    This whirlwind tour of testing, views and controllers is at an end. Stay tuned for more in depth coverage of controllers and views in the next post.
                  </p>