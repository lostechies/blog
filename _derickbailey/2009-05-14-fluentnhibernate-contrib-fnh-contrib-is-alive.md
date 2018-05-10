---
wordpress_id: 50
title: FluentNHibernate Contrib (FNH.Contrib) Is Alive!
date: 2009-05-14T02:14:06+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/05/13/fluentnhibernate-contrib-fnh-contrib-is-alive.aspx
dsq_thread_id:
  - "262068153"
categories:
  - .NET
  - Community
  - Fluent NHibernate
  - FNH.Contrib
  - git
  - NHibernate
redirect_from: "/blogs/derickbailey/archive/2009/05/13/fluentnhibernate-contrib-fnh-contrib-is-alive.aspx/"
---
A few months ago, a coworker created a set of extension methods to turn [NHibernate](http://nhibernate.org)’s [Criteria API](https://www.hibernate.org/hib_docs/nhibernate/1.2/reference/en/html/querycriteria.html) into a more fluenty, strongly typed API. We’ve been using it in a production app for a few months, and I wanted to share it with the world. After talking about it with the other [Fluent NHibernate](http://fluentnhibernate.org) contributors, we decided that it was not a good time to introduce new APIs and features into FNH right now (especially considering that we just removed Repository and Linq from FNH).

Thus, [FNH.Contrib](https://github.com/derickbailey/FNH.Contrib/tree/master) was born!

### FluentNHibernate.Query

Right now the only project in FNH.Contrib is the fluent query API. The basic idea was to turn a standard NHibernate Criteria query, like this:

<div>
  <div>
    <pre>IList&lt;Fault&gt; faults = Criteria</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>             .Add(Expression.Eq(<span style="color: #006080">"FaultNumber"</span>, faultNumber))</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>             .Add(Expression.Eq(<span style="color: #006080">"AdminNumber"</span>, adminNumber))</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>             .CreateCriteria(<span style="color: #006080">"UIC"</span>)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>             .Add(Expression.Eq(<span style="color: #006080">"UIC"</span>, uic.UIC))</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>             .SetMaxResults(1)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>             .List&lt;Fault&gt;();</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>&#160;</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre> <span style="color: #0000ff">if</span> (faults != <span style="color: #0000ff">null</span> && faults.Count &gt; 0)</pre>
    
    <p>
      <!--CRLF-->
    </p>
    
    <pre>   fault = faults[0];</pre>
    
    <p>
      <!--CRLF--></div> </div> 
      
      <p>
        Into a more strongly typed, no-magic-strings API, like this:
      </p>
      
      <div>
        <div>
          <pre>fault = Session.GetOne&lt;Fault&gt;()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre>             .Where(f =&gt; f.FaultNumber).IsEqualTo(faultNumber)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre>             .And(f =&gt; f.AdminNumber).IsEqualTo(adminNumber)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre>             .AndHasChild(f =&gt; f.UIC)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre>                    .Where(u =&gt; u.UIC).IsEqualTo(uic.UIC)</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre>                    .EndChild()</pre>
          
          <p>
            <!--CRLF-->
          </p>
          
          <pre>             .Execute();</pre>
          
          <p>
            <!--CRLF--></div> </div> 
            
            <p>
              The syntax is not perfect, by any means. However, it’s a great start and it’s been in a production app for several months now! I’m hoping to continue expanding this, cleaning up the syntax, etc, as I start using it in more projects.
            </p>
            
            <h3>
              Moving Forward and Other Contributions
            </h3>
            
            <p>
              At the moment, there are no other contributions in FNH.Contrib. However, I would love to get input and other projects up and running in it. There was some brief discussion of moving the FNH Repository and Linq APIs into. Perhaps that’s a good place to start?
            </p>
            
            <p>
              I also plan to put in a complete <a href="http://www.lostechies.com/blogs/derickbailey/archive/2009/04/08/how-a-net-developer-learned-ruby-and-rake-to-build-net-apps-in-windows.aspx">Rake</a> based automated build, and hopefully get a full suite of unit tests wrapped around the code, moving forward.
            </p>
            
            <h3>
            </h3>
            
            <h3>
              How To Contribute
            </h3>
            
            <p>
              FNH.Contrib is being hosted over at Github:
            </p>
            
            <blockquote>
              <p>
                <a title="https://github.com/derickbailey/FNH.Contrib/tree/master" href="https://github.com/derickbailey/FNH.Contrib/tree/master"><strong>https://github.com/derickbailey/FNH.Contrib/tree/master</strong></a>
              </p>
            </blockquote>
            
            <p>
              If you would like to contribute, just fork the master repository and start plugging your contributions in! When you have something ready to go, send me a pull request and we can start putting together a more complete contrib library.
            </p>