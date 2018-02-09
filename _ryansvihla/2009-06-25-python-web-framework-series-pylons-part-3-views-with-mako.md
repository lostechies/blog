---
wordpress_id: 16
title: 'Python Web Framework Series – Pylons: Part 3 Views with Mako'
date: 2009-06-25T04:53:00+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2009/06/25/python-web-framework-series-pylons-part-3-views-with-mako.aspx
dsq_thread_id:
  - "425624199"
categories:
  - Mako
  - Pylons
  - Python
redirect_from: "/blogs/rssvihla/archive/2009/06/25/python-web-framework-series-pylons-part-3-views-with-mako.aspx/"
---
This is a huge post and I should have split this into several smaller ones so please bear with me while I get my series format tweaked.&nbsp; We last left off with <a href="/blogs/rssvihla/archive/2009/06/24/python-web-framework-series-pylons-part-2-controllers-and-views.aspx" target="_blank">Controllers, Views and Testing</a> with a basic test, basic view and basic controller.&nbsp; Now with our basic scaffold built we can focus on making our views reusable, dynamic, and more pleasant to look at.

### First things first

First before we dive too deeply into Mako, lets setup a default home page by doing the following: 

  1. delete the index.html in the **pylonsforumpubl**_ic_ folder. 
  2. in **pylonsforumconfigrouting.py** add the following line somewhere under the line **&ldquo;# CUSTOM ROUTES HERE&rdquo;** but before **&ldquo;return map&rdquo;**. 
      1. map.connect(&#8220;home&#8221;, &#8220;/&#8221;, controller=&#8221;home&#8221;, action=&#8221;index&#8221;) 
  3. assuming you have your Pylons command we used earlier&nbsp; **paster serve &ndash;-reload development.ini** then open your browser to <http://127.0.0.1:5000> and you should see the view we created in the last lesson. 

### 

### Basics

&nbsp;

Mako uses standard python mixed with HTML to display views. This gives you both a great deal of flexibility and a great deal of ability to hang yourself. So be warned, avoid putting to much logic into your view, since you can do about anything there.

Open up **templatesindex.mako** __replace the table rows in the table body with the following:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterSmartContent">
  <div style="font-family: consolas,lucida console,courier,monospace">
    <span style="color: #008000"><b><tbody></b></span> <br /><span style="color: #bc7a00">%</span><span style="color: #008000"><b>for</b></span> p <span style="color: #aa22ff"><b>in</b></span> c<span style="color: #666666">.</span>posts: <br /><span style="color: #008000"><b><tr><td></b></span><span style="color: #bc7a00">${</span>p<span style="color: #666666">.</span>author<span style="color: #bc7a00">}</span><span style="color: #008000"><b></td><td></b></span><span style="color: #bc7a00">${</span>p<span style="color: #666666">.</span>subject<span style="color: #bc7a00">}</span><span style="color: #008000"><b></td><td></b></span><span style="color: #bc7a00">${</span>p<span style="color: #666666">.</span>dateadded<span style="color: #bc7a00">}</span><span style="color: #008000"><b></td></tr></b></span> <br /><span style="color: #bc7a00">%</span>endfor&nbsp; <br /><span style="color: #008000"><b></tbody></b></span>
  </div>
</div>

for good measure in the beginning of the body before the &ldquo;recent posts&rdquo; div place the following

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterSmartContent">
  <div style="font-family: consolas,lucida console,courier,monospace">
    <span style="color: #008000"><b><body></b></span> <br />username: <span style="color: #bc7a00">${</span>c<span style="color: #666666">.</span>username<span style="color: #bc7a00">}</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br /><span style="color: #008000"><b><div</b></span>&nbsp;<span style="color: #7d9029">id=</span><span style="color: #ba2121">&#8220;recentposts&#8221;</span>&nbsp;<span style="color: #7d9029">style=</span><span style="color: #ba2121">&#8220;float: right&#8221;</span><span style="color: #008000"><b>></b></span>
  </div>
</div>

Looking at this, for the tables we&rsquo;ve done a for loop over some variable called c.posts. In the second we&rsquo;re accessing another variable c.username. &ldquo;c&rdquo; is shorthand for Template Context, similar to ViewData in Asp.Net MVC and PropertyBag in Monorail, except we&rsquo;re not accessing a string dictionary.&nbsp; 

Add the following tests in &ldquo;**pylonsforumtestsfunctionaltest_home.py**&rdquo;&nbsp; for what we need to add to the controller:

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterSmartContent">
  <div style="font-family: consolas,lucida console,courier,monospace">
    &nbsp;&nbsp;&nbsp; <span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">test_username</span>(<span style="color: #008000">self</span>): <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; response <span style="color: #666666">=</span>&nbsp;<span style="color: #008000">self</span><span style="color: #666666">.</span>app<span style="color: #666666">.</span>get(url(controller<span style="color: #666666">=</span><span style="color: #ba2121">&#8216;home&#8217;</span>, action<span style="color: #666666">=</span><span style="color: #ba2121">&#8216;index&#8217;</span>)) <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="color: #008000"><b>assert</b></span>&nbsp;<span style="color: #ba2121">&#8220;username: rsvihla&#8221;</span>&nbsp;<span style="color: #aa22ff"><b>in</b></span> response </p> 
    
    <p>
      &nbsp;&nbsp;&nbsp; <span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">test_recent_posts</span>(<span style="color: #008000">self</span>): <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; response <span style="color: #666666">=</span>&nbsp;<span style="color: #008000">self</span><span style="color: #666666">.</span>app<span style="color: #666666">.</span>get(url(controller<span style="color: #666666">=</span><span style="color: #ba2121">&#8216;home&#8217;</span>, action<span style="color: #666666">=</span><span style="color: #ba2121">&#8216;index&#8217;</span>)) <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="color: #008000"><b>assert</b></span>&nbsp;<span style="color: #ba2121">&#8220;<tr><td>jkruse</td><td>New Kindle</td><td>06/24/2009</td></tr>&#8221;</span>&nbsp;<span style="color: #aa22ff"><b>in</b></span> response </div> </div> 
      
      <p>
        running <i>nosetests &ndash;-with-pylons=test.init</i> should give you two assertion failures.
      </p>
      
      <p>
        now change &ldquo;<b>pylonsforumcontrollershome.py</b>&rdquo; to look like so:
      </p>
      
      <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterSmartContent">
        <div style="font-family: consolas,lucida console,courier,monospace">
          <span style="color: #008000"><b>import</b></span>&nbsp;<span style="color: #0000ff"><b>logging</b></span> </p> 
          
          <p>
            <span style="color: #008000"><b>from</b></span>&nbsp;<span style="color: #0000ff"><b>pylons</b></span>&nbsp;<span style="color: #008000"><b>import</b></span> request, response, session, tmpl_context <span style="color: #008000"><b>as</b></span> c <br /><span style="color: #008000"><b>from</b></span>&nbsp;<span style="color: #0000ff"><b>pylons.controllers.util</b></span>&nbsp;<span style="color: #008000"><b>import</b></span> abort, redirect_to
          </p>
          
          <p>
            <span style="color: #008000"><b>from</b></span>&nbsp;<span style="color: #0000ff"><b>pylonsforum.lib.base</b></span>&nbsp;<span style="color: #008000"><b>import</b></span> BaseController, render
          </p>
          
          <p>
            log <span style="color: #666666">=</span> logging<span style="color: #666666">.</span>getLogger(__name__)
          </p>
          
          <p>
            <span style="color: #008000"><b>class</b></span>&nbsp;<span style="color: #0000ff"><b>Post</b></span>(<span style="color: #008000">object</span>):
          </p>
          
          <p>
            &nbsp;&nbsp;&nbsp; <span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">__init__</span>(<span style="color: #008000">self</span>, author, subject, dateadded): <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="color: #008000">self</span><span style="color: #666666">.</span>author <span style="color: #666666">=</span> author <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="color: #008000">self</span><span style="color: #666666">.</span>subject <span style="color: #666666">=</span> subject <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="color: #008000">self</span><span style="color: #666666">.</span>dateadded <span style="color: #666666">=</span> dateadded
          </p>
          
          <p>
            <span style="color: #008000"><b>class</b></span>&nbsp;<span style="color: #0000ff"><b>HomeController</b></span>(BaseController):
          </p>
          
          <p>
            &nbsp;&nbsp;&nbsp; <span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">index</span>(<span style="color: #008000">self</span>): <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; c<span style="color: #666666">.</span>username <span style="color: #666666">=</span>&nbsp;<span style="color: #ba2121">&#8220;rsvihla&#8221;</span> <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; c<span style="color: #666666">.</span>posts <span style="color: #666666">=</span> [Post(<span style="color: #ba2121">&#8220;jkruse&#8221;</span>, <span style="color: #ba2121">&#8220;New Kindle&#8221;</span>, <span style="color: #ba2121">&#8220;06/24/2009&#8221;</span>)] <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="color: #008000"><b>return</b></span> render(<span style="color: #ba2121">&#8216;index.mako&#8217;</span>) </div> </div> 
            
            <p>
              We&rsquo;ve added a Post class with basic attributes and placed them in an array in the c.posts variable, also we&rsquo;ve hardcoded the username &ldquo;rsvihla&rdquo;.&nbsp; I know the more experience developers here are cringing at my awful little Post class, don&rsquo;t worry its a just a place holder and will be removed later.&nbsp; The point here is building functionality in steps with test coverage.&nbsp; Now run nosetests just as before and you should have all tests passing.&nbsp; For bonus measure refresh <a href="http://127.0.0.1:5000">http://127.0.0.1:5000</a> .
            </p>
            
            <h3>
              Base Layouts
            </h3>
            
            <p>
              We&rsquo;ve built a very basic page now, but suppose we want to build several and have some bits of information show up over and over again, like user name or menu structure.
            </p>
            
            <p>
              create a base template named &ldquo;base.mako&rdquo; in the templates directory that has the following in it:
            </p>
            
            <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
              <div style="font-family:consolas,lucida console,courier,monospace">
                <span style="color: #bc7a00"><%</span><span style="color: #008000">namespace</span>&nbsp;<span style="color: #7d9029">name=</span><span style="color: #ba2121">&#8220;user&#8221;</span>&nbsp;<span style="color: #7d9029">module=</span><span style="color: #ba2121">&#8220;pylonsforum.model.users&#8221;</span>&nbsp;<span style="color: #bc7a00">/></span><br /> <span style="color: #bc7a00"><!DOCTYPE&nbsp;html&nbsp;PUBLIC&nbsp;&#8220;-//W3C//DTD&nbsp;XHTML&nbsp;1.0&nbsp;Transitional//EN&#8221;&nbsp;&#8220;http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd&#8221;></span><br /> <span style="color: #008000"><b><html></b></span><br /> <span style="color: #008000"><b><head></b></span><br /> <span style="color: #008000"><b><title></b></span><span style="color: #bc7a00">${</span><span style="color: #008000">self</span><span style="color: #666666">.</span>title()<span style="color: #bc7a00">}</span><span style="color: #008000"><b></title></b></span><br /> <span style="color: #bc7a00">${</span><span style="color: #008000">self</span><span style="color: #666666">.</span>head_tags()<span style="color: #bc7a00">}</span><br /> <span style="color: #008000"><b><style&nbsp;</b></span><span style="color: #7d9029">type=</span><span style="color: #ba2121">&#8220;text/css&#8221;</span><span style="color: #008000"><b>></b></span><br /> <span style="color: #bc7a00">#header{&nbsp;</span><br /> <span style="color: #008000"><b>height</b></span><span style="color: #666666">:</span>&nbsp;<span style="color: #008000"><b>70px</b></span><span style="color: #666666">;</span><br /> <span style="color: #008000"><b>width</b></span><span style="color: #666666">:</span>&nbsp;<span style="color: #008000"><b>100</b></span><span style="color: #666666">%;</span><br /> <span style="color: #008000"><b>border-width</b></span><span style="color: #666666">:</span>&nbsp;<span style="color: #008000"><b></b></span><span style="color: #0000ff"><b>.5px</b></span><span style="color: #666666">;</span><br /> <span style="color: #008000"><b>border-style</b></span><span style="color: #666666">:</span>&nbsp;<span style="color: #008000"><b>solid</b></span><span style="color: #666666">;</span><br /> <span style="color: #008000"><b>font-size</b></span><span style="color: #aa22ff">:30px</span><span style="color: #666666">;</span><br /> <span style="color: #008000"><b>text-align</b></span><span style="color: #666666">:</span>&nbsp;<span style="color: #008000"><b>center</b></span><span style="color: #666666">;</span><br /> <span style="color: #008000"><b>background-color</b></span><span style="color: #666666">:</span>&nbsp;<span style="color: #0000ff">#9B2C25</span><span style="color: #666666">;</span><br /> }<br /> <span style="color: #bc7a00">#sidebar{</span><br /> <span style="color: #008000"><b>background-color</b></span><span style="color: #666666">:</span>&nbsp;<span style="color: #0000ff">#C1AD72</span><span style="color: #666666">;</span><br /> <span style="color: #008000"><b>border-width</b></span><span style="color: #666666">:</span>&nbsp;<span style="color: #008000"><b></b></span><span style="color: #0000ff"><b>.5px</b></span><span style="color: #666666">;</span><br /> <span style="color: #008000"><b>border-style</b></span><span style="color: #666666">:</span>&nbsp;<span style="color: #008000"><b>dotted</b></span><span style="color: #666666">;</span><br /> <span style="color: #008000"><b>width</b></span><span style="color: #666666">:</span>&nbsp;<span style="color: #008000"><b>150px</b></span><span style="color: #666666">;</span><br /> <span style="color: #008000"><b>height</b></span><span style="color: #666666">:</span>&nbsp;<span style="color: #008000"><b>600px</b></span><span style="color: #666666">;</span><br /> <span style="color: #008000"><b>float</b></span><span style="color: #666666">:</span>&nbsp;<span style="color: #008000"><b>right</b></span><span style="color: #666666">;</span><br /> <span style="color: #008000"><b>font-size</b></span><span style="color: #666666">:</span>&nbsp;<span style="color: #008000"><b>15px</b></span><span style="color: #666666">;</span><br /> <span style="color: #008000"><b>padding-top</b></span><span style="color: #aa22ff">:10px</span><span style="color: #666666">;</span><br /> <span style="color: #008000"><b>padding-left</b></span><span style="color: #aa22ff">:5px</span><span style="color: #666666">;</span><br /> }<br /> <span style="color: #bc7a00">#content{</span><br /> <span style="color: #008000"><b>margin-top</b></span><span style="color: #aa22ff">:10px</span><span style="color: #666666">;</span><br /> }<br /> <span style="color: #008000"><b>body</b></span>&nbsp;{<br /> <span style="color: #008000"><b>background-color</b></span><span style="color: #666666">:</span>&nbsp;<span style="color: #666666">#DACEAB</span>;<br /> }<br /> <span style="color: #008000"><b></style></b></span><br /> <span style="color: #008000"><b></head></b></span><br /> <span style="color: #008000"><b><body></b></span></p> 
                
                <p>
                  <span style="color: #008000"><b><div</b></span>&nbsp;<span style="color: #7d9029">id=</span><span style="color: #ba2121">&#8220;header&#8221;</span><span style="color: #008000"><b>></b></span>Pylons&nbsp;Forum<span style="color: #008000"><b></div></b></span><br /> <span style="color: #008000"><b><div</b></span>&nbsp;<span style="color: #7d9029">id=</span><span style="color: #ba2121">&#8220;sidebar&#8221;</span><span style="color: #008000"><b>></b></span><br /> username:&nbsp;<span style="color: #bc7a00">${</span>user<span style="color: #666666">.</span>get_current_user()<span style="color: #bc7a00">}</span><br /> <span style="color: #008000"><b></div></b></span>
                </p>
                
                <p>
                  <span style="color: #008000"><b><div</b></span>&nbsp;<span style="color: #7d9029">id=</span><span style="color: #ba2121">&#8220;content&#8221;</span>&nbsp;<span style="color: #008000"><b>></b></span><br /> <span style="color: #bc7a00">${</span><span style="color: #008000">self</span><span style="color: #666666">.</span>body()<span style="color: #bc7a00">}</span><br /> <span style="color: #008000"><b></div></b></span>
                </p>
                
                <p>
                  <span style="color: #008000"><b></div></b></span><br /> <span style="color: #008000"><b></body></b></span><br /> <span style="color: #008000"><b></html></b></span> </div> </div> 
                  
                  <p>
                    Most everything is standard HTML so lets restrict this to the interesting bits:
                  </p>
                  
                  <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      <span style="color: #bc7a00"><%</span><span style="color: #008000">namespace</span>&nbsp;<span style="color: #7d9029">name=</span><span style="color: #ba2121">&#8220;user&#8221;</span>&nbsp;<span style="color: #7d9029">module=</span><span style="color: #ba2121">&#8220;pylonsforum.model.users&#8221;</span>&nbsp;<span style="color: #bc7a00">/></span>
                    </div>
                  </div>
                  
                  <p>
                    The namespace directive here is basically doing an import of a custom module and giving it an alias of user. This is no different than in normal python code typing:
                  </p>
                  
                  <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      <span style="color: #008000"><b>import</b></span>&nbsp;<span style="color: #0000ff"><b>pylonsforum.model.users</b></span>&nbsp;<span style="color: #008000"><b>as</b></span>&nbsp;<span style="color: #0000ff"><b>user</b></span>
                    </div>
                  </div>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <p>
                    This is used later in the div sidebar by pulling the current user from my customer users module:
                  </p>
                  
                  <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      username&nbsp;:&nbsp;<span style="color: #bc7a00">${</span>user<span style="color: #666666">.</span>get_current_user()<span style="color: #bc7a00">}</span>
                    </div>
                  </div>
                  
                  <p>
                    the module source only contains a simple hard coded value for now so in <b>pylonsforummodel </b>make a <b>users.py</b> file with only the following:
                  </p>
                  
                  <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      <span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">get_current_user</span>(<span style="color: #008000">self</span>):<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>return</b></span>&nbsp;<span style="color: #ba2121">&#8220;rsvihla&#8221;</span>
                    </div>
                  </div>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <hr />
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <p>
                    Now onto the next non-HTML tidbits
                  </p>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      <span style="color: #008000"><b><title></b></span><span style="color: #bc7a00">${</span><span style="color: #008000">self</span><span style="color: #666666">.</span>title()<span style="color: #bc7a00">}</span><span style="color: #008000"><b></title></b></span><br /> <span style="color: #bc7a00">${</span><span style="color: #008000">self</span><span style="color: #666666">.</span>head_tags()<span style="color: #bc7a00">}</span><br /> <span style="color: #bc7a00">${</span><span style="color: #008000">self</span><span style="color: #666666">.</span>body()<span style="color: #bc7a00">}</span>
                    </div>
                  </div>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <p>
                    Everyone of the above methods establishes a base method that the child templates must now call with the exception of self.body (which is called when the templates actually render the content anyway).&nbsp; So lets adjust &ldquo;index.mako&rdquo; template to the following:
                  </p>
                  
                  <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      <span style="color: #bc7a00"><%</span><span style="color: #008000">inherit</span>&nbsp;<span style="color: #7d9029">file=</span><span style="color: #ba2121">&#8220;/base.mako&#8221;</span><span style="color: #bc7a00">/></span><br /> <span style="color: #bc7a00"><%</span><span style="color: #008000">def</span>&nbsp;<span style="color: #7d9029">name=</span><span style="color: #ba2121">&#8220;title()&#8221;</span><span style="color: #bc7a00">></span>Pylons&nbsp;Forum<span style="color: #bc7a00"></%</span><span style="color: #008000">def</span><span style="color: #bc7a00">></span><br /> <span style="color: #bc7a00"><%</span><span style="color: #008000">def</span>&nbsp;<span style="color: #7d9029">name=</span><span style="color: #ba2121">&#8220;head_tags()&#8221;</span><span style="color: #bc7a00">></%</span><span style="color: #008000">def</span><span style="color: #bc7a00">></span><br /> <span style="color: #008000"><b><div</b></span>&nbsp;<span style="color: #7d9029">id=</span><span style="color: #ba2121">&#8220;recentposts&#8221;</span><span style="color: #008000"><b>></b></span><br /> <span style="color: #008000"><b><table></b></span><br /> <span style="color: #008000"><b><thead><tr><th></b></span>subject<span style="color: #008000"><b></th><th></b></span>author<span style="color: #008000"><b></th><th></b></span>date&nbsp;submitted<span style="color: #008000"><b></th></tr></thead></b></span><br /> <span style="color: #008000"><b><tbody></b></span><br /> <span style="color: #bc7a00">%</span><span style="color: #008000"><b>for</b></span>&nbsp;p&nbsp;<span style="color: #aa22ff"><b>in</b></span>&nbsp;c<span style="color: #666666">.</span>posts:<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b><tr><td></b></span><span style="color: #bc7a00">${</span>p<span style="color: #666666">.</span>author<span style="color: #bc7a00">}</span><span style="color: #008000"><b></td><td></b></span><span style="color: #bc7a00">${</span>p<span style="color: #666666">.</span>subject<span style="color: #bc7a00">}</span><span style="color: #008000"><b></td><td></b></span><span style="color: #bc7a00">${</span>p<span style="color: #666666">.</span>dateadded<span style="color: #bc7a00">}</span><span style="color: #008000"><b></td></tr></b></span><br /> <span style="color: #bc7a00">%</span>endfor&nbsp;<br /> <span style="color: #008000"><b></tbody></b></span><br /> <span style="color: #008000"><b></table></b></span><br /> <span style="color: #008000"><b></div></b></span>
                    </div>
                  </div>
                  
                  <p>
                    The inherit line at the very top references our base.mako template. The next two lines with the <%def tag are where our previous self.head_tags() and self.title() methods are referenced.
                  </p>
                  
                  <p>
                    You&rsquo;ll notice the title method is passing in a new title for the page, and our head_tags method is doing nothing, so no changes there. Browse to your pylons home page and you should see something resembling this:
                  </p>
                  
                  <p>
                    <a href="//lostechies.com/ryansvihla/files/2011/03/image_024C9A53.png"><img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" alt="image" src="//lostechies.com/ryansvihla/files/2011/03/image_thumb_4B061317.png" width="624" border="0" height="412" /></a>
                  </p>
                  
                  <p>
                    Your tests should also still pass with no modification.
                  </p>
                  
                  <p>
                    <a href="//lostechies.com/ryansvihla/files/2011/03/image_296A8FE0.png"><img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" alt="image" src="//lostechies.com/ryansvihla/files/2011/03/image_thumb_4436B5EC.png" width="655" border="0" height="91" /></a>
                  </p>
                  
                  <h3>
                    Forms and Web Helpers
                  </h3>
                  
                  <p>
                    Lets add a basic submit form and a link in the base.mako template to go to the new form page.
                  </p>
                  
                  <p>
                    Add the following tests to <b>test_home.py</b>
                  </p>
                  
                  <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">test_new_thread</span>(<span style="color: #008000">self</span>):<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;response&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #008000">self</span><span style="color: #666666">.</span>app<span style="color: #666666">.</span>get(url(controller<span style="color: #666666">=</span><span style="color: #ba2121">&#8220;home&#8221;</span>,&nbsp;action<span style="color: #666666">=</span><span style="color: #ba2121">&#8220;newthread&#8221;</span>))<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>assert</b></span>&nbsp;<span style="color: #ba2121">&#8220;<input&nbsp;id=</span><span style="color: #bb6622"><b>&#8220;</b></span><span style="color: #ba2121">subject</span><span style="color: #bb6622"><b>&#8220;</b></span><span style="color: #ba2121">&nbsp;name=</span><span style="color: #bb6622"><b>&#8220;</b></span><span style="color: #ba2121">subject</span><span style="color: #bb6622"><b>&#8220;</b></span><span style="color: #ba2121">&nbsp;type=</span><span style="color: #bb6622"><b>&#8220;</b></span><span style="color: #ba2121">text</span><span style="color: #bb6622"><b>&#8220;</b></span><span style="color: #ba2121">&nbsp;/>&#8221;</span>&nbsp;<span style="color: #aa22ff"><b>in</b></span>&nbsp;response<br /> &nbsp;&nbsp;&nbsp;&nbsp;<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">test_submit_new_thread</span>(<span style="color: #008000">self</span>):<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;response&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #008000">self</span><span style="color: #666666">.</span>app<span style="color: #666666">.</span>post(url(controller<span style="color: #666666">=</span><span style="color: #ba2121">&#8220;home&#8221;</span>,&nbsp;action<span style="color: #666666">=</span><span style="color: #ba2121">&#8220;submitnewthread&#8221;</span>),&nbsp;params<span style="color: #666666">=</span>{<span style="color: #ba2121">&#8216;subject&#8217;</span>:<span style="color: #ba2121">&#8216;test&#8217;</span>,<span style="color: #ba2121">&#8216;content&#8217;</span>:<span style="color: #ba2121">&#8216;testcontent&#8217;</span>})<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>assert</b></span>&nbsp;<span style="color: #ba2121">&#8220;post&nbsp;submitted&#8221;</span>&nbsp;<span style="color: #aa22ff"><b>in</b></span>&nbsp;response
                    </div>
                  </div>
                  
                  <p>
                    Install FormBuild with the following command:
                  </p>
                  
                  <p>
                    <a href="//lostechies.com/ryansvihla/files/2011/03/image_786ADF32.png"><img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" alt="image" src="//lostechies.com/ryansvihla/files/2011/03/image_thumb_61AB97A9.png" width="647" border="0" height="39" /></a>
                  </p>
                  
                  <p>
                    Next open <b>libhelpers.py </b>and change the imports to as follows:
                  </p>
                  
                  <p>
                    <a href="//lostechies.com/ryansvihla/files/2011/03/image_080D7AF5.png"><img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" alt="image" src="//lostechies.com/ryansvihla/files/2011/03/image_thumb_181C49AC.png" width="655" border="0" height="85" /></a>
                  </p>
                  
                  <p>
                    In the sidebar div under username add
                  </p>
                  
                  <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      <span style="color: #008000"><b><br/></b></span><br /> <span style="color: #bc7a00">${</span>h<span style="color: #666666">.</span>link_to(<span style="color: #ba2121">&#8216;new&nbsp;thread&#8217;</span>,&nbsp;h<span style="color: #666666">.</span>url_for(controller<span style="color: #666666">=</span><span style="color: #ba2121">&#8216;home&#8217;</span>,&nbsp;action<span style="color: #666666">=</span><span style="color: #ba2121">&#8216;newthread&#8217;</span>))<span style="color: #bc7a00">}</span>
                    </div>
                  </div>
                  
                  <p>
                    Now add an action on the home controller for :&rdquo;new thread&rdquo; and create a view in your templates folder called <b>newthread.mako</b>.
                  </p>
                  
                  <p>
                    Add the following to your <b>home.py</b> controller:
                  </p>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">newthread</span>(<span style="color: #008000">self</span>):<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>return</b></span>&nbsp;render(<span style="color: #ba2121">&#8216;newthread.mako&#8217;</span>)
                    </div>
                  </div>
                  
                  <h3>
                  </h3>
                  
                  <h3>
                    &nbsp;
                  </h3>
                  
                  <p>
                    The newthread.mako file should have the following in it:
                  </p>
                  
                  <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      <span style="color: #bc7a00"><%</span><span style="color: #008000">inherit</span>&nbsp;<span style="color: #7d9029">file=</span><span style="color: #ba2121">&#8220;/base.mako&#8221;</span><span style="color: #bc7a00">/></span><br /> <span style="color: #bc7a00"><%</span><span style="color: #008000">def</span>&nbsp;<span style="color: #7d9029">name=</span><span style="color: #ba2121">&#8220;title()&#8221;</span><span style="color: #bc7a00">></span>Make&nbsp;A&nbsp;New&nbsp;Thread<span style="color: #bc7a00"></%</span><span style="color: #008000">def</span><span style="color: #bc7a00">></span><br /> <span style="color: #bc7a00"><%</span><span style="color: #008000">def</span>&nbsp;<span style="color: #7d9029">name=</span><span style="color: #ba2121">&#8220;head_tags()&#8221;</span><span style="color: #bc7a00">></%</span><span style="color: #008000">def</span><span style="color: #bc7a00">></span><br /> <span style="color: #bc7a00">${</span>h<span style="color: #666666">.</span>form_start(h<span style="color: #666666">.</span>url_for(controller<span style="color: #666666">=</span><span style="color: #ba2121">&#8216;home&#8217;</span>,&nbsp;action<span style="color: #666666">=</span><span style="color: #ba2121">&#8216;submitnewthread&#8217;</span>),&nbsp;method<span style="color: #666666">=</span><span style="color: #ba2121">&#8220;post&#8221;</span>)<span style="color: #bc7a00">}</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #bc7a00">${</span>h<span style="color: #666666">.</span>field(<span style="color: #ba2121">&#8220;Subject&#8221;</span>,&nbsp;field<span style="color: #666666">=</span>h<span style="color: #666666">.</span>text(name<span style="color: #666666">=</span><span style="color: #ba2121">&#8216;subject&#8217;</span>))<span style="color: #bc7a00">}</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #bc7a00">${</span>h<span style="color: #666666">.</span>field(<span style="color: #ba2121">&#8220;Content&#8221;</span>&nbsp;,field<span style="color: #666666">=</span>h<span style="color: #666666">.</span>textarea(name<span style="color: #666666">=</span><span style="color: #ba2121">&#8216;content&#8217;</span>))<span style="color: #bc7a00">}</span>&nbsp;<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #bc7a00">${</span>h<span style="color: #666666">.</span>field(field<span style="color: #666666">=</span>h<span style="color: #666666">.</span>submit(value<span style="color: #666666">=</span><span style="color: #ba2121">&#8220;Create&nbsp;Thread&#8221;</span>,&nbsp;name<span style="color: #666666">=</span><span style="color: #ba2121">&#8216;submit&#8217;</span>))<span style="color: #bc7a00">}</span><br /> <span style="color: #bc7a00">${</span>h<span style="color: #666666">.</span>form_end()<span style="color: #bc7a00">}</span>
                    </div>
                  </div>
                  
                  <p>
                    Sooooooo what are h values everywhere?&nbsp; Do I need them? They come from our earlier imports in <b><span style="text-decoration: underline">l</span>ibhelpers.py , </b>and no you do not actually need to use them, a typical HTML form tag is all you actually need, this is an available option for those interested.
                  </p>
                  
                  <ul>
                    <li>
                      h.form_start and h.form_end are pretty self explanatory
                    </li>
                    <li>
                      h.field takes label text as argument one, and then a url for argument two.
                    </li>
                    <li>
                      h.text, h.textarea, h.hidden and h.submit represent their html counterparts.
                    </li>
                    <li>
                      h.url_for takes a controller and action to make a url for you.
                    </li>
                  </ul>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <hr />
                  
                  <p>
                    We now need another action for actually posting our data. so add another method to our <b>home.py</b> controller:
                  </p>
                  
                  <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">submitnewthread</span>(<span style="color: #008000">self</span>):<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;c<span style="color: #666666">.</span>username&nbsp;<span style="color: #666666">=</span>&nbsp;users<span style="color: #666666">.</span>get_current_user(<span style="color: #008000">self</span>)<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;c<span style="color: #666666">.</span>subject&nbsp;<span style="color: #666666">=</span>&nbsp;request<span style="color: #666666">.</span>POST[<span style="color: #ba2121">&#8216;subject&#8217;</span>]<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;c<span style="color: #666666">.</span>content&nbsp;<span style="color: #666666">=</span>&nbsp;request<span style="color: #666666">.</span>POST[<span style="color: #ba2121">&#8216;content&#8217;</span>]<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>return</b></span>&nbsp;render(<span style="color: #ba2121">&#8216;submitnewthread.mako&#8217;</span>)
                    </div>
                  </div>
                  
                  <p>
                    With the following import at the top
                  </p>
                  
                  <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      <span style="color: #008000"><b>import</b></span>&nbsp;<span style="color: #0000ff"><b>pylonsforum.model.users</b></span>
                    </div>
                  </div>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <p>
                    Our <b>submitnewthread.mako</b> view should have the following:
                  </p>
                  
                  <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      <span style="color: #bc7a00"><%</span><span style="color: #008000">inherit</span>&nbsp;<span style="color: #7d9029">file=</span><span style="color: #ba2121">&#8220;/base.mako&#8221;</span><span style="color: #bc7a00">/></span><br /> <span style="color: #bc7a00"><%</span><span style="color: #008000">def</span>&nbsp;<span style="color: #7d9029">name=</span><span style="color: #ba2121">&#8220;title()&#8221;</span><span style="color: #bc7a00">></span>Thank&nbsp;You&nbsp;For&nbsp;Your&nbsp;Submission<span style="color: #bc7a00"></%</span><span style="color: #008000">def</span><span style="color: #bc7a00">></span><br /> <span style="color: #bc7a00"><%</span><span style="color: #008000">def</span>&nbsp;<span style="color: #7d9029">name=</span><span style="color: #ba2121">&#8220;head_tags()&#8221;</span><span style="color: #bc7a00">></%</span><span style="color: #008000">def</span><span style="color: #bc7a00">></span><br /> <span style="color: #008000"><b><p></b></span>post&nbsp;submitted&nbsp;<span style="color: #008000"><b></p></b></span><br /> data&nbsp;was&nbsp;as&nbsp;follows&nbsp;<span style="color: #008000"><b><br/></b></span><br /> author:&nbsp;&nbsp;<span style="color: #bc7a00">${</span>c<span style="color: #666666">.</span>username<span style="color: #bc7a00">}</span>&nbsp;<span style="color: #008000"><b><br/></b></span><br /> subject:&nbsp;<span style="color: #bc7a00">${</span>c<span style="color: #666666">.</span>subject<span style="color: #bc7a00">}</span>&nbsp;<span style="color: #008000"><b><br</b></span>&nbsp;<span style="color: #008000"><b>/></b></span><br /> content:&nbsp;<span style="color: #bc7a00">${</span>c<span style="color: #666666">.</span>content<span style="color: #bc7a00">}</span>&nbsp;<span style="color: #008000"><b><br</b></span>&nbsp;<span style="color: #008000"><b>/></b></span>
                    </div>
                  </div>
                  
                  <p>
                    newthread view should look like so
                  </p>
                  
                  <h3>
                    <a href="//lostechies.com/ryansvihla/files/2011/03/image_0C868C6D.png"><img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" alt="image" src="//lostechies.com/ryansvihla/files/2011/03/image_thumb_67F4FEE8.png" width="595" border="0" height="376" /></a>
                  </h3>
                  
                  <p>
                    and submitnewthread page should look like this
                  </p>
                  
                  <p>
                    <a href="//lostechies.com/ryansvihla/files/2011/03/image_63124B2C.png"><img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" alt="image" src="//lostechies.com/ryansvihla/files/2011/03/image_thumb_10936AF0.png" width="598" border="0" height="524" /></a>
                  </p>
                  
                  <h3>
                    Validation
                  </h3>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <p>
                    Validation is a huge subject in Pylons, I&rsquo;m going to just focus on the most basic common case.
                  </p>
                  
                  <p>
                    Open <b>home.py </b>controller again and add these two imports to the top
                  </p>
                  
                  <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      <span style="color: #008000"><b>import</b></span>&nbsp;<span style="color: #0000ff"><b>formencode</b></span><br /> <span style="color: #008000"><b>from</b></span>&nbsp;<span style="color: #0000ff"><b>pylons.decorators</b></span>&nbsp;<span style="color: #008000"><b>import</b></span>&nbsp;validate
                    </div>
                  </div>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <p>
                    Then in the same file for now below the post object add
                  </p>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      <span style="color: #008000"><b>class</b></span>&nbsp;<span style="color: #0000ff"><b>PostForm</b></span>(formencode<span style="color: #666666">.</span>Schema):<br /> &nbsp;&nbsp;&nbsp;&nbsp;allow_extra_fields&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #008000">True</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;filter_extra_fields&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #008000">True</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;subject&nbsp;<span style="color: #666666">=</span>&nbsp;formencode<span style="color: #666666">.</span>validators<span style="color: #666666">.</span>String(not_empty<span style="color: #666666">=</span><span style="color: #008000">True</span>)<br /> &nbsp;&nbsp;&nbsp;&nbsp;content&nbsp;<span style="color: #666666">=</span>&nbsp;formencode<span style="color: #666666">.</span>validators<span style="color: #666666">.</span>String(not_empty<span style="color: #666666">=</span><span style="color: #008000">True</span>)
                    </div>
                  </div>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <p>
                    Finally on top of the submitnewthead action in the same class file add
                  </p>
                  
                  <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #aa22ff">@validate</span>(schema<span style="color: #666666">=</span>PostForm(),&nbsp;form<span style="color: #666666">=</span><span style="color: #ba2121">&#8216;newthread&#8217;</span>,&nbsp;post_only<span style="color: #666666">=</span><span style="color: #008000">True</span>,&nbsp;on_get<span style="color: #666666">=</span><span style="color: #008000">True</span>)<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">submitnewthread</span>(<span style="color: #008000">self</span>):
                    </div>
                  </div>
                  
                  <p>
                    Now if you attempt to leave either the subject or content fields blank PylonsForum will now notify you of what you missed.
                  </p>
                  
                  <p>
                    <a href="//lostechies.com/ryansvihla/files/2011/03/image_26E91035.png"><img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" alt="image" src="//lostechies.com/ryansvihla/files/2011/03/image_thumb_546A2FF8.png" width="605" border="0" height="388" /></a>
                  </p>
                  
                  <p>
                    &nbsp;
                  </p>
                  
                  <p>
                    When done your tests should all pass
                  </p>
                  
                  <p>
                    <a href="//lostechies.com/ryansvihla/files/2011/03/image_17F14468.png"><img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" alt="image" src="//lostechies.com/ryansvihla/files/2011/03/image_thumb_5E6E3470.png" width="602" border="0" height="91" /></a>
                  </p>
                  
                  <h3>
                    Summary
                  </h3>
                  
                  <p>
                    We went through the 80% cases for views, controllers and a brief bit about testing the response object. We still haven&rsquo;t done a lot of unit testing in the traditional sense but we&rsquo;ve been focusing exclusively on UI.&nbsp; Stay tuned next for my SQL Alchemy piece.
                  </p>