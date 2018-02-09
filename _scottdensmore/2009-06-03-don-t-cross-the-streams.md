---
wordpress_id: 4606
title: 'Don&#8217;t Cross the Streams'
date: 2009-06-03T01:33:00+00:00
author: Scott Densmore
layout: post
wordpress_guid: /blogs/scottdensmore/archive/2009/06/02/don-t-cross-the-streams.aspx
dsq_thread_id:
  - "273601285"
categories:
  - Uncategorized
redirect_from: "/blogs/scottdensmore/archive/2009/06/02/don-t-cross-the-streams.aspx/"
---
&nbsp;

<div>
  <div>
    &#8220;There&#8217;s something very important I forgot to tell you.&nbsp;
  </div>
  
  <div>
    What?&nbsp;
  </div>
  
  <div>
    Don&#8217;t cross the streams.&nbsp;
  </div>
  
  <div>
    Why?&nbsp;
  </div>
  
  <div>
    It would be bad.&nbsp;
  </div>
  
  <div>
    I&#8217;m fuzzy on the whole good/bad thing. What do you mean, &#8220;bad&#8221;?&nbsp;
  </div>
  
  <div>
    Try to imagine all life as you know it stopping instantaneously and every molecule in your body exploding at the speed of light.&nbsp;
  </div>
  
  <div>
    Total protonic reversal.&nbsp;
  </div>
  
  <div>
    Right. That&#8217;s bad. Okay. All right. Important safety tip. Thanks, Egon.&#8221; (from Ghostbusters)
  </div>
  
  <p>
  </p>
  
  <div>
    That is how I feel about models and domains today. We should not cross them up. I here talk about domains and models, yet everyone seems to focus on just one of the domains and models: the business. I can&#8217;t blame them, the business is usually the ones who pays the bills. I think we need to discuss the rest of the domains and models.&nbsp;
  </div>
  
  <p>
  </p>
  
  <div>
    Lately I have been working on a system that is client server (Win Client talking to a database). There isn&#8217;t a large user base [we are installing on a ship]. It is pretty core to the business and some of the functionality will / might be exposed by consumption from other applications. I know that is pretty vague, yet how many times is this not the description of an application you get when a project starts [which then gets the question &#8220;How long will it take?&#8221;]. I came into the project after 6 months. &nbsp;Mostly what had been done is defining the database and using an in house generator to gen out some datasets / stored procedures and a bit of code to work out some integration work. There wasn&#8217;t a lot of focus on getting requirements / stories / use cases, but that is a story for another day. I will not bore you with all the details yet to sum up, we got some basic stories together and started to build out a model of our domain. The next thing we did was start building these stories (after estimating) out. This is where the fun began.
  </div>
  
  <p>
  </p>
  
  <div>
    When we started writing out tests to build a story / feature, the first thing I came up against was that everyone wanted to have one model for everything. One model for the domain and UI. I decided that it was time to break out some code-fu and read the riot act. When you start thinking about the UI you think about binding, how to represent the data to the user, and commands. &nbsp;When we started down the road you would end up having to change each domain object to deal with displaying data, notifying property changes, change tracking etc. &nbsp;That seems like to much for one object to do. &nbsp;If we go back to the definition of Single Responsibility Principle, we can see that if we put all that functionality in one object, there would be more than reason for it to change. &nbsp;Also, we would get into a problem with the impedance mismatch between how we store the data and how we display it. And don&#8217;t get me started on mapping relational data to objects. What we are striving for is high cohesion and low coupling.&nbsp;
  </div>
  
  <p>
  </p>
  
  <div>
    I am sure that some people will argue that a simple application doesn&#8217;t require this complexity. &nbsp;I don&#8217;t agree. &nbsp;It is not about the application now, it is about the application over time. Change is inevitable, from changing requirements, to changing developers, changing versions etc. Coupling your code like this will make changes hard and costly. I only say this because some people might argue cost as being the reason for not considering the separation of domains. While I agree that it is a judgement call, I tend to error on the side of separation and the SOLID principles. Which sounds more complex: a simple object that does one thing, or a big object that does everything (maybe)? I&#8217;ll take the simple one every day of the week and twice on Tuesday. &nbsp;&nbsp;
  </div>
  
  <p>
  </p>
  
  <div>
    When you think about your domain (or all your domains), each one will probably have similar yet different models. This is why trying to shove all these things in one domain can be problematic. Even when you consider one system, there could be more than one business domain. &nbsp;For example, if we are talking about a Reservation System, we have different things like Inventory Management, Pricing, Accounting, Availability, etc. &nbsp;All these domains require different models even though they may share the same names. I am not going to try and recreate Evan&#8217;s book on DDD, but if you haven&#8217;t read it, I highly recommend it. (<a href="http://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215/ref=sr_1_1?ie=UTF8&s=books&qid=1243995956&sr=8-1" title="DDD">Domain Driven Design by Eric Evans</a>)
  </div>
  
  <p>
  </p>
  
  <div>
    When you talk of splitting out your domains you will need a good mapping layer between the domains. Something that I have found very useful is&nbsp;<a href="http://www.codeplex.com/AutoMapper" title="AutoMapper">AutoMapper</a>. &nbsp;It is a great little tool for mapping one object to another. You can use it to map your message objects to your business domain or your business domain to UI objects. It is quite the little power toy.
  </div>
  
  <p>
  </p>
  
  <div>
    And remember: if someone asks if you are a God&#8230; you say &#8220;YES!&#8221;.
  </div>
</div>

&nbsp;