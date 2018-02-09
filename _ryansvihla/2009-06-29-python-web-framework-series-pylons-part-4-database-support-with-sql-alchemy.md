---
wordpress_id: 17
title: 'Python Web Framework Series – Pylons: Part 4 Introduction For Database Support With SQL Alchemy.'
date: 2009-06-29T02:54:00+00:00
author: Ryan Svihla
layout: post
wordpress_guid: /blogs/rssvihla/archive/2009/06/28/python-web-framework-series-pylons-part-4-database-support-with-sql-alchemy.aspx
dsq_thread_id:
  - "425624187"
categories:
  - ORM
  - Pylons
  - Python
redirect_from: "/blogs/rssvihla/archive/2009/06/28/python-web-framework-series-pylons-part-4-database-support-with-sql-alchemy.aspx/"
---
We last left off with <a href="/blogs/rssvihla/archive/2009/06/25/python-web-framework-series-pylons-part-3-views-with-mako.aspx" target="_blank">Views with Mako</a>, now Pylons does not enforce on you an ORM at all, so you can use hand crafted SQL if you prefer. However, since I&rsquo;ve done enough of that for a career or two we&rsquo;re going to use my Python ORM of choice and the preferred one for Pylons SQLAlchemy. 

### Where does SQLAlchemy fit in as an ORM?

If you used NHibernate, you should feel pretty close to right at home with SQLAlchemy. If you come from an ActiveRecord, Entity Framework, Subsonic,&nbsp; or even Linq2Sql background this will be a bit more hand management than you are used to. If that is the case, I suggest&nbsp; <a href="http://elixir.ematia.de/trac/wiki" target="_blank">Elixir</a> (which I&rsquo;ve heard great things about) or <a href="http://www.sqlobject.org/" target="_blank">SQLObject</a> (which I&rsquo;ve used as well and works fine).

### Mapping and Setup

There are three different ways to map tables to classes with SQLAlchemy, I will pick the most commonly used one, but will show the other two in a later post. In our PylonsForum project open **model\_\_init\_\_.py&nbsp;** and change the file to look like so:

&nbsp;

<div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
  <div style="font-family:consolas,lucida console,courier,monospace">
    <span style="color: #ba2121"><i>&#8220;&#8221;&#8221;The&nbsp;application&#8217;s&nbsp;model&nbsp;objects&#8221;&#8221;&#8221;</i></span><br /> <span style="color: #008000"><b>from</b></span>&nbsp;<span style="color: #0000ff"><b>sqlalchemy</b></span>&nbsp;<span style="color: #008000"><b>import</b></span>&nbsp;orm<br /> <span style="color: #008000"><b>import</b></span>&nbsp;<span style="color: #0000ff"><b>sqlalchemy</b></span>&nbsp;<span style="color: #008000"><b>as</b></span>&nbsp;<span style="color: #0000ff"><b>sa</b></span><br /> <span style="color: #008000"><b>import</b></span>&nbsp;<span style="color: #0000ff"><b>datetime</b></span><br /> <span style="color: #008000"><b>from</b></span>&nbsp;<span style="color: #0000ff"><b>pylonsforum.model</b></span>&nbsp;<span style="color: #008000"><b>import</b></span>&nbsp;meta</p> 
    
    <p>
      <span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">now</span>():<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>return</b></span>&nbsp;datetime<span style="color: #666666">.</span>datetime<span style="color: #666666">.</span>now()
    </p>
    
    <p>
      <span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">init_model</span>(engine):<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #ba2121"><i>&#8220;&#8221;&#8221;Call&nbsp;me&nbsp;before&nbsp;using&nbsp;any&nbsp;of&nbsp;the&nbsp;tables&nbsp;or&nbsp;classes&nbsp;in&nbsp;the&nbsp;model&#8221;&#8221;&#8221;</i></span><br /> &nbsp;&nbsp;&nbsp;&nbsp;meta<span style="color: #666666">.</span>Session<span style="color: #666666">.</span>configure(bind<span style="color: #666666">=</span>engine)<br /> &nbsp;&nbsp;&nbsp;&nbsp;meta<span style="color: #666666">.</span>engine&nbsp;<span style="color: #666666">=</span>&nbsp;engine
    </p>
    
    <p>
      <span style="color: #008000"><b>class</b></span>&nbsp;<span style="color: #0000ff"><b>Post</b></span>(<span style="color: #008000">object</span>):<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>pass</b></span>
    </p>
    
    <p>
      <span style="color: #008000"><b>class</b></span>&nbsp;<span style="color: #0000ff"><b>Thread</b></span>(<span style="color: #008000">object</span>):<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>pass</b></span>
    </p>
    
    <p>
      posts_table&nbsp;<span style="color: #666666">=</span>&nbsp;sa<span style="color: #666666">.</span>Table(<span style="color: #ba2121">&#8220;posts&#8221;</span>,&nbsp;meta<span style="color: #666666">.</span>metadata,&nbsp;<br /> sa<span style="color: #666666">.</span>Column(<span style="color: #ba2121">&#8220;id&#8221;</span>,&nbsp;sa<span style="color: #666666">.</span>types<span style="color: #666666">.</span>Integer,&nbsp;primary_key<span style="color: #666666">=</span><span style="color: #008000">True</span>),<br /> sa<span style="color: #666666">.</span>Column(<span style="color: #ba2121">&#8220;threadid&#8221;</span>,&nbsp;sa<span style="color: #666666">.</span>types<span style="color: #666666">.</span>Integer,sa<span style="color: #666666">.</span>ForeignKey(<span style="color: #ba2121">&#8216;threads.id&#8217;</span>)),<br /> sa<span style="color: #666666">.</span>Column(<span style="color: #ba2121">&#8220;content&#8221;</span>,&nbsp;sa<span style="color: #666666">.</span>types<span style="color: #666666">.</span>String(<span style="color: #666666">4000</span>),&nbsp;nullable<span style="color: #666666">=</span><span style="color: #008000">False</span>),<br /> sa<span style="color: #666666">.</span>Column(<span style="color: #ba2121">&#8220;author&#8221;</span>,&nbsp;sa<span style="color: #666666">.</span>types<span style="color: #666666">.</span>String(<span style="color: #666666">255</span>),&nbsp;nullable<span style="color: #666666">=</span><span style="color: #008000">False</span>),<br /> sa<span style="color: #666666">.</span>Column(<span style="color: #ba2121">&#8220;created&#8221;</span>,&nbsp;sa<span style="color: #666666">.</span>types<span style="color: #666666">.</span>TIMESTAMP(),&nbsp;default<span style="color: #666666">=</span>now()),<br /> sa<span style="color: #666666">.</span>Column(<span style="color: #ba2121">&#8220;isparent&#8221;</span>&nbsp;,&nbsp;sa<span style="color: #666666">.</span>types<span style="color: #666666">.</span>Boolean,&nbsp;nullable<span style="color: #666666">=</span><span style="color: #008000">True</span>)<br /> )<br /> threads_table&nbsp;<span style="color: #666666">=</span>&nbsp;sa<span style="color: #666666">.</span>Table(<span style="color: #ba2121">&#8220;threads&#8221;</span>,&nbsp;meta<span style="color: #666666">.</span>metadata,<br /> sa<span style="color: #666666">.</span>Column(<span style="color: #ba2121">&#8220;id&#8221;</span>,&nbsp;sa<span style="color: #666666">.</span>types<span style="color: #666666">.</span>Integer,&nbsp;primary_key&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #008000">True</span>),<br /> sa<span style="color: #666666">.</span>Column(<span style="color: #ba2121">&#8220;subject&#8221;</span>,&nbsp;sa<span style="color: #666666">.</span>types<span style="color: #666666">.</span>String(<span style="color: #666666">255</span>)),</div> 
      
      <div style="font-family:consolas,lucida console,courier,monospace">
        sa.Column(<span style="color: #ba2121">&#8220;dateadded&#8221;</span>, sa.types.TIMESTAMP(), default=now())<br /> )<br /> orm<span style="color: #666666">.</span>mapper(Post,&nbsp;posts_table)<br /> orm<span style="color: #666666">.</span>mapper(Thread,&nbsp;threads_table,properties<span style="color: #666666">=</span>{<span style="color: #ba2121">&#8216;posts&#8217;</span>:orm<span style="color: #666666">.</span>relation(Post,&nbsp;backref<span style="color: #666666">=</span><span style="color: #ba2121">&#8216;thread&#8217;</span>)})
      </div></div> 
      
      <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
        <div style="font-family:consolas,lucida console,courier,monospace">
        </div>
      </div>
      
      <p>
        &nbsp;
      </p>
      
      <p>
        Not the best table structure and you&rsquo;re welcome to improve this on your own but I wanted to create a default setup that was easy to read.&nbsp; Lets take a bit to recap the pieces:
      </p>
      
      <hr />
      
      <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
        <div style="font-family:consolas,lucida console,courier,monospace">
          <span style="color: #008000"><b>def</b></span>&nbsp;<span style="color: #0000ff">init_model</span>(engine):<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #ba2121"><i>&#8220;&#8221;&#8221;Call&nbsp;me&nbsp;before&nbsp;using&nbsp;any&nbsp;of&nbsp;the&nbsp;tables&nbsp;or&nbsp;classes&nbsp;in&nbsp;the&nbsp;model&#8221;&#8221;&#8221;</i></span><br /> &nbsp;&nbsp;&nbsp;&nbsp;meta<span style="color: #666666">.</span>Session<span style="color: #666666">.</span>configure(bind<span style="color: #666666">=</span>engine)<br /> &nbsp;&nbsp;&nbsp;&nbsp;meta<span style="color: #666666">.</span>engine&nbsp;<span style="color: #666666">=</span>&nbsp;engine
        </div>
      </div>
      
      <p>
        Straightforward method here sets up a Session object with the database engine passed into the method.&nbsp; Pylons will call init_model itself when the site is accessed.
      </p>
      
      <hr />
      
      <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
        <div style="font-family:consolas,lucida console,courier,monospace">
          <span style="color: #008000"><b>class</b></span>&nbsp;<span style="color: #0000ff"><b>Post</b></span>(<span style="color: #008000">object</span>):<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>pass</b></span></p> 
          
          <p>
            <span style="color: #008000"><b>class</b></span>&nbsp;<span style="color: #0000ff"><b>Thread</b></span>(<span style="color: #008000">object</span>):<br /> &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>pass</b></span> </div> </div> 
            
            <p>
              So a couple of empty classes?&nbsp; Python being a dynamic language can get away with this and just add the properties at runtime.&nbsp; These are the objects we&rsquo;ll be interacting with when we want to store data.
            </p>
            
            <hr />
            
            <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
              <div style="font-family:consolas,lucida console,courier,monospace">
                posts_table&nbsp;<span style="color: #666666">=</span>&nbsp;sa<span style="color: #666666">.</span>Table(<span style="color: #ba2121">&#8220;posts&#8221;</span>,&nbsp;meta<span style="color: #666666">.</span>metadata,&nbsp;<br /> sa<span style="color: #666666">.</span>Column(<span style="color: #ba2121">&#8220;id&#8221;</span>,&nbsp;sa<span style="color: #666666">.</span>types<span style="color: #666666">.</span>Integer,&nbsp;primary_key<span style="color: #666666">=</span><span style="color: #008000">True</span>),<br /> sa<span style="color: #666666">.</span>Column(<span style="color: #ba2121">&#8220;threadid&#8221;</span>,&nbsp;sa<span style="color: #666666">.</span>types<span style="color: #666666">.</span>Integer,sa<span style="color: #666666">.</span>ForeignKey(<span style="color: #ba2121">&#8216;threads.id&#8217;</span>)),<br /> sa<span style="color: #666666">.</span>Column(<span style="color: #ba2121">&#8220;content&#8221;</span>,&nbsp;sa<span style="color: #666666">.</span>types<span style="color: #666666">.</span>String(<span style="color: #666666">4000</span>),&nbsp;nullable<span style="color: #666666">=</span><span style="color: #008000">False</span>),<br /> sa<span style="color: #666666">.</span>Column(<span style="color: #ba2121">&#8220;author&#8221;</span>,&nbsp;sa<span style="color: #666666">.</span>types<span style="color: #666666">.</span>String(<span style="color: #666666">255</span>),&nbsp;nullable<span style="color: #666666">=</span><span style="color: #008000">False</span>),<br /> sa<span style="color: #666666">.</span>Column(<span style="color: #ba2121">&#8220;dateadded&#8221;</span>,&nbsp;sa<span style="color: #666666">.</span>types<span style="color: #666666">.</span>TIMESTAMP(),&nbsp;default<span style="color: #666666">=</span>now()),<br /> sa<span style="color: #666666">.</span>Column(<span style="color: #ba2121">&#8220;isparent&#8221;</span>&nbsp;,&nbsp;sa<span style="color: #666666">.</span>types<span style="color: #666666">.</span>Boolean,&nbsp;nullable<span style="color: #666666">=</span><span style="color: #008000">True</span>)<br /> )<br /> threads_table&nbsp;<span style="color: #666666">=</span>&nbsp;sa<span style="color: #666666">.</span>Table(<span style="color: #ba2121">&#8220;threads&#8221;</span>,&nbsp;meta<span style="color: #666666">.</span>metadata,<br /> sa<span style="color: #666666">.</span>Column(<span style="color: #ba2121">&#8220;id&#8221;</span>,&nbsp;sa<span style="color: #666666">.</span>types<span style="color: #666666">.</span>Integer,&nbsp;primary_key&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #008000">True</span>),<br /> sa<span style="color: #666666">.</span>Column(<span style="color: #ba2121">&#8220;subject&#8221;</span>,&nbsp;sa<span style="color: #666666">.</span>types<span style="color: #666666">.</span>String(<span style="color: #666666">255</span>))<br /> )
              </div>
            </div>
            
            <p>
              Ok these table declarations are providing the data definition logic, including some basic relationship, nothing too interesting here post in comments if you have specific questions.
            </p>
            
            <hr />
            
            <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
              <div style="font-family:consolas,lucida console,courier,monospace">
                orm<span style="color: #666666">.</span>mapper(Post,&nbsp;posts_table)<br /> orm<span style="color: #666666">.</span>mapper(Thread,&nbsp;threads_table,properties<span style="color: #666666">=</span>{<span style="color: #ba2121">&#8216;posts&#8217;</span>:orm<span style="color: #666666">.</span>relation(Post,&nbsp;backref<span style="color: #666666">=</span><span style="color: #ba2121">&#8216;thread&#8217;</span>)})
              </div>
            </div>
            
            <p>
              Here the orm.mapper calls take the Page and Thread classes and map them with the table data definitions typed in earlier.&nbsp; You can also specify relationships here as we have done in the thread mapping, the properties argument is referencing the <i>Post</i> class and mapping it to a property called posts on the <i>Thread</i> class, while also mapping the other direction and putting thread on the <i>Post</i> class.
            </p>
            
            <hr />
            
            <p>
              Finally run <i>paster setup-app development.ini</i> from the root pylonsforum directory and you should see a bunch of SQL flying by which indicates it has build the database schema for us:
            </p>
            
            <p>
              <a href="//lostechies.com/ryansvihla/files/2011/03/image_3D5BCA36.png"><img style="border-right-width: 0px;border-top-width: 0px;border-bottom-width: 0px;border-left-width: 0px" alt="image" src="//lostechies.com/ryansvihla/files/2011/03/image_thumb_214D9BFC.png" width="609" border="0" height="420" /></a>
            </p>
            
            <h3>
              Making Our New Thread Store In The Database
            </h3>
            
            <p>
              In the interest of space and time I&rsquo;ll skip the testing story for another post.&nbsp;
            </p>
            
            <p>
              Open up <i>controllershome.py</i> .
            </p>
            
            <ul>
              <li>
                Remove the Post class we created several posts ago
              </li>
              <li>
                under the imports add <i>import pylonsforum.model as model </i>
              </li>
              <li>
                under the imports add <i>import pylonsforum.model.meta as meta</i>
              </li>
              <li>
                change the submitnewthread method to the following <ul>
                  <div style="padding-bottom: 0px;margin: 0px;padding-left: 0px;padding-right: 0px;float: none;padding-top: 0px" class="wlWriterEditableSmartContent">
                    <div style="font-family:consolas,lucida console,courier,monospace">
                      thread&nbsp;<span style="color: #666666">=</span>&nbsp;model<span style="color: #666666">.</span>Thread()&nbsp;<br /> thread<span style="color: #666666">.</span>subject&nbsp;<span style="color: #666666">=</span>&nbsp;request<span style="color: #666666">.</span>POST[<span style="color: #ba2121">&#8216;subject&#8217;</span>]<br /> post&nbsp;<span style="color: #666666">=</span>&nbsp;model<span style="color: #666666">.</span>Post()<br /> post<span style="color: #666666">.</span>author&nbsp;<span style="color: #666666">=</span>users<span style="color: #666666">.</span>get_current_user(<span style="color: #008000">self</span>)<br /> post<span style="color: #666666">.</span>isparent&nbsp;<span style="color: #666666">=</span>&nbsp;<span style="color: #008000">True</span><br /> post<span style="color: #666666">.</span>content&nbsp;<span style="color: #666666">=</span>&nbsp;request<span style="color: #666666">.</span>POST[<span style="color: #ba2121">&#8216;content&#8217;</span>]<br /> thread<span style="color: #666666">.</span>posts<span style="color: #666666">.</span>append(post)&nbsp;<span style="color: #408080"><i>#adding&nbsp;post&nbsp;to&nbsp;the&nbsp;thread&nbsp;object</i></span><br /> meta<span style="color: #666666">.</span>Session<span style="color: #666666">.</span>add(thread)&nbsp;<span style="color: #408080"><i>#look&nbsp;only&nbsp;have&nbsp;to&nbsp;add&nbsp;the&nbsp;thread&nbsp;object</i></span><br /> meta<span style="color: #666666">.</span>Session<span style="color: #666666">.</span>flush()&nbsp;<span style="color: #408080"><i>#optional&nbsp;when&nbsp;AutoCommit&nbsp;is&nbsp;on,&nbsp;but&nbsp;useful&nbsp;for&nbsp;control&nbsp;in&nbsp;data&nbsp;integrity&nbsp;cases</i></span><br /> meta<span style="color: #666666">.</span>Session<span style="color: #666666">.</span>commit()&nbsp;<span style="color: #408080"><i>#makes&nbsp;changes&nbsp;real</i></span><br /> thread_query&nbsp;<span style="color: #666666">=</span>&nbsp;meta<span style="color: #666666">.</span>Session<span style="color: #666666">.</span>query(model<span style="color: #666666">.</span>Thread)&nbsp;<span style="color: #408080"><i>#query&nbsp;back&nbsp;submitted&nbsp;data&nbsp;to&nbsp;display&nbsp;to&nbsp;ui</i></span><br /> thread&nbsp;<span style="color: #666666">=</span>&nbsp;thread_query<span style="color: #666666">.</span>filter_by(<span style="color: #008000">id</span><span style="color: #666666">=</span>thread<span style="color: #666666">.</span>id)<span style="color: #666666">.</span>first()&nbsp;<span style="color: #408080"><i>#&nbsp;yes&nbsp;actually&nbsp;querying&nbsp;using&nbsp;the&nbsp;thread&nbsp;id&nbsp;of&nbsp;our&nbsp;created&nbsp;object&nbsp;above</i></span><br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;c<span style="color: #666666">.</span>username&nbsp;<span style="color: #666666">=</span>&nbsp;thread<span style="color: #666666">.</span>posts[<span style="color: #666666"></span>]<span style="color: #666666">.</span>author<br /> c<span style="color: #666666">.</span>subject&nbsp;<span style="color: #666666">=</span>&nbsp;thread<span style="color: #666666">.</span>subject<br /> c<span style="color: #666666">.</span>content&nbsp;<span style="color: #666666">=</span>&nbsp;thread<span style="color: #666666">.</span>posts[<span style="color: #666666"></span>]<span style="color: #666666">.</span>content<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #008000"><b>return</b></span>&nbsp;render(<span style="color: #ba2121">&#8216;submitnewthread.mako&#8217;</span>)
                    </div>
                  </div>
                </ul>
              </li>
            </ul>
            
            <p>
              Finally run the newthread action
            </p>
            
            <p>
              &nbsp; <a href="http://localhost:5000/home/newthread" target="_blank">http://localhost:5000/home/newthread</a>
            </p>
            
            <p>
              then create a thread
            </p>
            
            <p>
              <a title="http://localhost:5000/home/submitnewthread" href="http://localhost:5000/home/submitnewthread">http://localhost:5000/home/submitnewthread</a>
            </p>
            
            <p>
              Should be no change in the actual outward appearance of from what we were doing before.
            </p>
            
            <h3>
            </h3>
            
            <h3>
              Summary and Recap
            </h3>
            
            <p>
              This was a very quick and basic introduction to SQLAlchemy and I will do more with it over the next couple of posts, but please add any comments to things I did not make clear. SQLAlchemy and ORM&rsquo;s in general are a very large subjects and those of us that have used them for a long time tend to forget not all of this was so obvious when we started.
            </p>