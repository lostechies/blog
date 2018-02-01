---
id: 4644
title: 'P&#038;P Guidance &#8211; Positive Progress'
date: 2009-02-08T13:39:00+00:00
author: Colin Jack
layout: post
guid: /blogs/colinjack/archive/2009/02/08/p-amp-p-guidance-positive-progress.aspx
categories:
  - ALT.NET
  - DDD
  - 'p&amp;p'
  - REST
---
I put up a post a while back about the P&P REST guidance which I considered to be quite flawed. The reaction from the P&P team was superb and [Greg Young](http://codebetter.com/blogs/gregyoung/), [Sebastien Lambla](http://serialseb.blogspot.com/) and myself immediately got involved in an e-mail exchange with them regarding this and other guidance. They&#8217;ve&nbsp;shown they are incredibly open to feedback and we&#8217;re still involved in this exchange&nbsp;but&nbsp;it looks like the result may be changes to the existing article and/or new articles.

One thing I hadn&#8217;t realized before this started is that P&P actually have three different sites:

  1. Guide &ndash; <http://www.codeplex.com/AppArchGuide>
  2. Knowledge Base &ndash; <http://www.codeplex.com/AppArch>
  3. Community Site &ndash; <http://www.codeplex.com/AppArchContrib>

The community site is quite open so even if our examples use open source frameworks they can still be published on it. I&#8217;m therefore planning on writing one example using WCF, NHibernate and Castle where the two primary areas covered will be:

  1. **REST** &#8211; Although the current example says its using REST I think this is arguable.
  2. **Domain Model** &#8211; I&#8217;ll be using DDD patterns but I&#8217;ve tried to explain that DDD isn&#8217;t always appropriate (e.g. if you don&#8217;t have access to domain experts). Regardless I&#8217;m obviously a big fan of object-oriented domain models and the barrier to entry is so low with modern ORM&#8217;s that I think its a no-brainer to use one in the example.

I&#8217;m not saying I&#8217;ve chosen the best technologies, in particular using WCF is highly questionable, but since I&#8217;m not trying to say this is the &#8220;best&#8221; way to do things I&#8217;m comfortable with the choices especially as I&#8217;d expect other guidance to be given over other approaches (perhaps using an MVC style approach).