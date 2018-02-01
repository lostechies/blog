---
id: 18
title: 'Python Web Framework Series – Pylons: Part 5 Testing Models'
date: 2009-07-02T20:09:00+00:00
author: Ryan Svihla
layout: post
guid: /blogs/rssvihla/archive/2009/07/02/python-web-framework-series-pylons-part-5-testing-models.aspx
dsq_thread_id:
  - "425624229"
categories:
  - Pylons
  - Python
  - SqlAlchemy
---
UPDATE: was an error caught by Govind (who is turning out to be my unofficial proofreader). I&#8217;ve made a correction in the thread mapping for &#8220;dateadded&#8221; property in the _previous_ article. If this you are caught up with and _error indicating there is no dateadded property on thread_ make sure to edit your **model\_\_init\_\_.py** file to match the previous article and rebuild your db so that everything is happy. Please bear with me as I hone my tutorial writing skill set.

When we last left of with our Pylons forum we had a had just successfully created a post, and then could immediately retrieve that same post. However, we kind of skimped on the testing story so lets fill in the gaps and do some refactoring as a bonus.

### Functional Testing Models

Open your functional controller test located at **pylonsforumtestsfunctionaltest_home.py** and add the following import line

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <div style="font-family:consolas,lucida console,courier,monospace">
    <span style="color: #008000"><b>from</b></span>&nbsp;<span style="color: #0000ff"><b>pylonsforum.model</b></span>&nbsp;<span style="color: #008000"><b>import</b></span>&nbsp;Thread,&nbsp;Post,&nbsp;meta
  </div>
</div>

and the following methods

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <div style="font-family:consolas,lucida console,courier,monospace">
    <span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">setUp</span>(<span style="color: #008000">self</span>):<br /> &nbsp;&nbsp;&nbsp;&nbsp;meta<span style="color: #666666">.</span>Session<span style="color: #666666">.</span>remove()<br /> &nbsp;&nbsp;&nbsp;&nbsp;meta<span style="color: #666666">.</span>metadata<span style="color: #666666">.</span>create_all(meta<span style="color: #666666">.</span>engine)<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000">self</span><span style="color: #666666">.</span>_createpost(<span style="color: #666666">5</span>)</p> 
    
    <p>
      <span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">_createpost</span>(<span style="color: #008000">self</span>,times):<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;i&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #666666"></span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>while</b></span>&nbsp;i&nbsp;<span style="color: #666666"><</span>&nbsp;times:<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;i&nbsp;<span style="color: #666666">=</span>&nbsp;i&nbsp;<span style="color: #666666">+</span><span style="color: #666666">1</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;thread&nbsp;<span style="color: #666666">=</span>&nbsp;Thread()<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;thread<span style="color: #666666">.</span>subject&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #ba2121">&#8220;subject&nbsp;&#8220;</span>&nbsp;<span style="color: #666666">+</span>&nbsp;<span style="color: #008000">str</span>(i)<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;post&nbsp;<span style="color: #666666">=</span>&nbsp;Post()<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;post<span style="color: #666666">.</span>author&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #ba2121">&#8220;posting&nbsp;away&#8221;</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;post<span style="color: #666666">.</span>content<span style="color: #666666">=</span>&nbsp;<span style="color: #ba2121">&#8220;&#8221;</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;post<span style="color: #666666">.</span>isparent&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #008000">True</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;thread<span style="color: #666666">.</span>posts<span style="color: #666666">.</span>append(post)<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;meta<span style="color: #666666">.</span>Session<span style="color: #666666">.</span>add(thread)<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;meta<span style="color: #666666">.</span>Session<span style="color: #666666">.</span>commit() </div> </div> 
      
      <p>
        &nbsp;
      </p>
      
      <p>
        and change the test_recent_posts method to
      </p>
      
      <p>
        &nbsp;
      </p>
      
      <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
        <div style="font-family:consolas,lucida console,courier,monospace">
          &nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">test_five_most_recent_threads_show_in_homepage</span>(<span style="color: #008000">self</span>):<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;response&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #008000">self</span><span style="color: #666666">.</span>app<span style="color: #666666">.</span>post(url(controller<span style="color: #666666">=</span><span style="color: #ba2121">&#8220;home&#8221;</span>,&nbsp;action<span style="color: #666666">=</span><span style="color: #ba2121">&#8220;index&#8221;</span>))<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>assert</b></span>&nbsp;<span style="color: #ba2121">&#8220;subject&nbsp;1&#8221;</span>&nbsp;<span style="color: #aa22ff"><b>in</b></span>&nbsp;response<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>assert</b></span>&nbsp;<span style="color: #ba2121">&#8220;subject&nbsp;2&#8221;</span>&nbsp;<span style="color: #aa22ff"><b>in</b></span>&nbsp;response<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>assert</b></span>&nbsp;<span style="color: #ba2121">&#8220;subject&nbsp;3&#8221;</span>&nbsp;<span style="color: #aa22ff"><b>in</b></span>&nbsp;response<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>assert</b></span>&nbsp;<span style="color: #ba2121">&#8220;subject&nbsp;4&#8221;</span>&nbsp;<span style="color: #aa22ff"><b>in</b></span>&nbsp;response<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>assert</b></span>&nbsp;<span style="color: #ba2121">&#8220;subject&nbsp;5&#8221;</span>&nbsp;<span style="color: #aa22ff"><b>in</b></span>&nbsp;response
        </div>
      </div>
      
      <p>
        &nbsp;
      </p>
      
      <p>
        &nbsp;
      </p>
      
      <p>
        In summary here we&rsquo;re adding a _createpost factory method that generates some basic test threads and parent posts. running <i>nosetests &ndash;-with-pylons=test.ini </i>should result in failed tests.
      </p>
      
      <h3>
        Changing The View and Controller
      </h3>
      
      <p>
        Now adjust your <b>index.mako </b>view to the following:
      </p>
      
      <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
        <div style="font-family:consolas,lucida console,courier,monospace">
          <span style="color: #bc7a00"><%</span><span style="color: #008000">def</span>&nbsp;<span style="color: #7d9029">name=</span><span style="color: #ba2121">&#8220;title()&#8221;</span><span style="color: #bc7a00">></span>Pylons&nbsp;Forum<span style="color: #bc7a00"></%</span><span style="color: #008000">def</span><span style="color: #bc7a00">></span><br /> <span style="color: #bc7a00"><%</span><span style="color: #008000">def</span>&nbsp;<span style="color: #7d9029">name=</span><span style="color: #ba2121">&#8220;head_tags()&#8221;</span><span style="color: #bc7a00">></%</span><span style="color: #008000">def</span><span style="color: #bc7a00">></span><br /> <span style="color: #008000"><b><div</b></span>&nbsp;<span style="color: #7d9029">id=</span><span style="color: #ba2121">&#8220;recentposts&#8221;</span><span style="color: #008000"><b>></b></span><br /> <span style="color: #008000"><b><table></b></span><br /> <span style="color: #008000"><b><thead><tr><th></b></span>subject<span style="color: #008000"><b></th><th></b></span>author<span style="color: #008000"><b></th><th></b></span>date&nbsp;submitted<span style="color: #008000"><b></th></tr></thead></b></span><br /> <span style="color: #008000"><b><tbody></b></span><br /> <span style="color: #bc7a00">%</span><span style="color: #008000"><b>for</b></span>&nbsp;t&nbsp;<span style="color: #aa22ff"><b>in</b></span>&nbsp;c<span style="color: #666666">.</span>threads:<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b><tr><td></b></span><span style="color: #bc7a00">${</span>t<span style="color: #666666">.</span>subject<span style="color: #bc7a00">}</span><span style="color: #008000"><b></td><td></b></span><span style="color: #bc7a00">${</span>t<span style="color: #666666">.</span>parentpost<span style="color: #666666">.</span>author<span style="color: #bc7a00">}</span><span style="color: #008000"><b></td><td></b></span><span style="color: #bc7a00">${</span>t<span style="color: #666666">.</span>dateadded<span style="color: #bc7a00">}</span><span style="color: #008000"><b></td></tr></b></span>&nbsp;&nbsp;<span style="color: #408080"><i><!&#8211;&nbsp;changed&nbsp;posts&nbsp;properties&nbsp;to&nbsp;thread&nbsp;properties&nbsp;and&nbsp;added&nbsp;parentpost&nbsp;&#8211;></i></span><br /> <span style="color: #bc7a00">%</span><span style="color: #008000"><b>endfor</b></span><br /> <span style="color: #008000"><b></tbody></b></span><br /> <span style="color: #008000"><b></table></b></span><br /> <span style="color: #008000"><b></div></b></span>
        </div>
      </div>
      
      <p>
        So once you&rsquo;ve changed the to using a &ldquo;threads&rdquo; object, added parentpost (where did that come from? I&rsquo;ll get to that in minute) and changed our properties around we need to change the our <b>home.py </b>controller index action for our cosmetic changes and to work with our new tests:
      </p>
      
      <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
        <div style="font-family:consolas,lucida console,courier,monospace">
          &nbsp;<span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">index</span>(<span style="color: #008000">self</span>):<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;c<span style="color: #666666">.</span>username&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #ba2121">&#8220;rsvihla&#8221;</span><br /> &nbsp;&nbsp;&nbsp;<span style="color: #408080"><i>#&nbsp;removing&nbsp;this&nbsp;line&nbsp;&nbsp;&nbsp;&nbsp;c.posts&nbsp;=&nbsp;[Post(&#8220;jkruse&#8221;,&nbsp;&#8220;New&nbsp;Kindle&#8221;,&nbsp;&#8220;06/24/2009&#8221;)]</i></span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;thread_query&nbsp;<span style="color: #666666">=</span>&nbsp;meta<span style="color: #666666">.</span>Session<span style="color: #666666">.</span>query(model<span style="color: #666666">.</span>Thread)<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;c<span style="color: #666666">.</span>threads&nbsp;<span style="color: #666666">=</span>&nbsp;thread_query<span style="color: #666666">.</span>order_by(model<span style="color: #666666">.</span>Thread<span style="color: #666666">.</span>dateadded<span style="color: #666666">.</span>desc())<span style="color: #666666">.</span>limit(<span style="color: #666666">5</span>)<span style="color: #666666">.</span>all()<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>return</b></span>&nbsp;render(<span style="color: #ba2121">&#8216;index.mako&#8217;</span>)
        </div>
      </div>
      
      <p>
        So our index action now is querying for the 5 most recent threads and storing in our new c.threads context variable. Lets strip the query down into pieces.
      </p>
      
      <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
        <div style="font-family:consolas,lucida console,courier,monospace">
          thread_query&nbsp;<span style="color: #666666">=</span>&nbsp;meta<span style="color: #666666">.</span>Session<span style="color: #666666">.</span>query(model<span style="color: #666666">.</span>Thread)
        </div>
      </div>
      
      <p>
        we&rsquo;re working with SQLAlchemy Session object. We call a Thread Model and then store a Thread query object inside the thread_query variable.&nbsp; Now through the thread_query variable we can get&nbsp; access to the Thread objects stored in the database.
      </p>
      
      <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
        <div style="font-family:consolas,lucida console,courier,monospace">
          c<span style="color: #666666">.</span>threads&nbsp;<span style="color: #666666">=</span>&nbsp;thread_query<span style="color: #666666">.</span>order_by(model<span style="color: #666666">.</span>Thread<span style="color: #666666">.</span>dateadded<span style="color: #666666">.</span>desc())<span style="color: #666666">.</span>limit(<span style="color: #666666">5</span>)<span style="color: #666666">.</span>all()
        </div>
      </div>
      
      <p>
        Here we call &ldquo;order_by&rdquo; on our query object and then pass in the Thread model specifying a descending order of the dateadded property. Next we limit it to 5 rows and then call &ldquo;all()&rdquo; which returns our results in a nice python &ldquo;list&rdquo; object.
      </p>
      
      <h3>
        Custom Properties on the Model
      </h3>
      
      <p>
        Ok so back a few paragraphs ago in the <b>index.mako</b> view I stuck in a &ldquo;parentpost&rdquo; property on the thread, and I&rsquo;m quite certain you&rsquo;re wondering how I did that. So I&rsquo;ve created the following class <b>teststest_model.py</b>
      </p>
      
      <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
        <div style="font-family:consolas,lucida console,courier,monospace">
          <span style="color: #008000"><b>from</b></span>&nbsp;<span style="color: #0000ff"><b>pylonsforum.model</b></span>&nbsp;<span style="color: #008000"><b>import</b></span>&nbsp;Thread,&nbsp;Post,&nbsp;meta<br /> <span style="color: #008000"><b>from</b></span>&nbsp;<span style="color: #0000ff"><b>pylonsforum.tests</b></span>&nbsp;<span style="color: #008000"><b>import</b></span>&nbsp;<span style="color: #666666">*</span></p> 
          
          <p>
            <span style="color: #008000"><b>class</b></span>&nbsp;<span style="color: #0000ff"><b>TestThreadParent</b></span>(TestController):
          </p>
          
          <p>
            &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">_makethread</span>(<span style="color: #008000">self</span>,&nbsp;hasparent):<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;thread&nbsp;<span style="color: #666666">=</span>&nbsp;Thread()<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;thread<span style="color: #666666">.</span>subject&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #ba2121">&#8220;test&#8221;</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;parentpost&nbsp;<span style="color: #666666">=</span>&nbsp;Post()<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;parentpost<span style="color: #666666">.</span>content&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #ba2121">&#8220;&#8221;</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;parentpost<span style="color: #666666">.</span>author&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #ba2121">&#8220;first&nbsp;post&#8221;</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;parentpost<span style="color: #666666">.</span>isparent&nbsp;<span style="color: #666666">=</span>&nbsp;hasparent<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;childpost&nbsp;<span style="color: #666666">=</span>&nbsp;Post()<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;childpost<span style="color: #666666">.</span>content&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #ba2121">&#8220;&#8221;</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;childpost<span style="color: #666666">.</span>author&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #ba2121">&#8220;&#8221;</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;childpost<span style="color: #666666">.</span>isparent&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #008000">False</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;thread<span style="color: #666666">.</span>posts<span style="color: #666666">.</span>append(childpost)<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;thread<span style="color: #666666">.</span>posts<span style="color: #666666">.</span>append(parentpost)<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>return</b></span>&nbsp;thread
          </p>
          
          <p>
            &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">test_should_find_parent_post</span>(<span style="color: #008000">self</span>):<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;thread&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #008000">self</span><span style="color: #666666">.</span>_makethread(<span style="color: #008000">True</span>)<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>assert</b></span>&nbsp;thread<span style="color: #666666">.</span>parentpost<span style="color: #666666">.</span>author&nbsp;<span style="color: #666666">==</span>&nbsp;<span style="color: #ba2121">&#8220;first&nbsp;post&#8221;</span>
          </p>
          
          <p>
            &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">test_should_not_find_parent_when_none_set</span>(<span style="color: #008000">self</span>):<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;thread&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #008000">self</span><span style="color: #666666">.</span>_makethread(<span style="color: #008000">False</span>)<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>assert</b></span>&nbsp;thread<span style="color: #666666">.</span>parentpost&nbsp;<span style="color: #aa22ff"><b>is</b></span>&nbsp;<span style="color: #008000">None</span> </div> </div> 
            
            <p>
              Our test has a _makethread factory method (another one of those maybe time for a factory class soon!) which can make a parent post or not depending on its parameter, then two tests documenting its behavior in each situation.
            </p>
            
            <p>
              So I&rsquo;ve gone back to our <b>models__init__.py</b> class and changed the Thread class to look like this:
            </p>
            
            <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
              <div style="font-family:consolas,lucida console,courier,monospace">
                <span style="color: #008000"><b>class</b></span>&nbsp;<span style="color: #0000ff"><b>Thread</b></span>(<span style="color: #008000">object</span>):<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #aa22ff">@property</span><br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">parentpost</span>(<span style="color: #008000">self</span>):<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>for</b></span>&nbsp;p&nbsp;<span style="color: #aa22ff"><b>in</b></span>&nbsp;<span style="color: #008000">self</span><span style="color: #666666">.</span>posts:<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>if</b></span>&nbsp;p<span style="color: #666666">.</span>isparent&nbsp;<span style="color: #666666">==</span>&nbsp;<span style="color: #008000">True</span>:<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>return</b></span>&nbsp;p
              </div>
            </div>
            
            <p>
              &nbsp;
            </p>
            
            <p>
              Not the best method however its VERY interesting for static language veterans. We are searching an<span style="text-decoration: underline"> instance variable that we have not even defined</span>!&nbsp; Remember only our SQLAlchemy mapper even makes mention of a &ldquo;posts&rdquo; variable through our relationship mapping, yet our &ldquo;parentpost&rdquo; property is searching through self.posts.&nbsp; Once it finds a parent post it returns true, this is not perfect and again not the ideal way to enforce a database constraint but for a demo it works fine.
            </p>
            
            <p>
              Calling <i>nosetests &ndash;-with-pylons=test.ini</i> should now give you all passing tests<i>. </i>Running <i>paster serve &ndash;-reload development.ini</i> and opening <a href="http://localhost:5000">http://localhost:5000</a> , adding a couple of threads and you should have something that looks like this:
            </p>
            
            <p>
              <a href="//lostechies.com/ryansvihla/files/2011/03/Picture1_6219E7BC.png"><img style="border-bottom: 0px;border-left: 0px;border-top: 0px;border-right: 0px" alt="Picture 1" src="//lostechies.com/ryansvihla/files/2011/03/Picture1_thumb_71505089.png" width="610" border="0" height="410" /></a>
            </p>
            
            <h3>
              Summary
            </h3>
            
            <p>
              We&rsquo;ve completed a home page now that has some dynamic data, added a custom property on our database class, and addressed functional testing with models.&nbsp;
            </p>