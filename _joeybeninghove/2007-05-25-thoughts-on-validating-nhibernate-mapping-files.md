---
wordpress_id: 11
title: Thoughts On Validating NHibernate Mapping Files
date: 2007-05-25T00:31:46+00:00
author: Joey Beninghove
layout: post
wordpress_guid: /blogs/joeydotnet/archive/2007/05/24/thoughts-on-validating-nhibernate-mapping-files.aspx
categories:
  - NHibernate
  - Tools
redirect_from: "/blogs/joeydotnet/archive/2007/05/24/thoughts-on-validating-nhibernate-mapping-files.aspx/"
---
[Ben](http://flux88.com/) brought up a good (pain) point in his comment on [my last post](http://www.lostechies.com/blogs/joeydotnet/archive/2007/05/17/unit-testing-nhibernate-dals-what-are-you-really-testing.aspx)&nbsp;that can definitely occur when doing integration testing using NHibernate.&nbsp; Invalid mapping files can cause the ISessionFactory to break upon creation, often leaving you to check the logs to see what&#8217;s going on.&nbsp; But there are a few things you can do to help prevent this, or at least, make it easier to figure out what&#8217;s wrong.

#### XML Intellisense Is Your Friend

If you haven&#8217;t already, you&#8217;ll want to [enable intellisense for your NHibernate xml mapping files](http://blog.benday.com/archive/2006/01/15/3646.aspx).&nbsp; This is a good first step to make sure you&#8217;re xml mapping files are valid according to NHibernate&#8217;s mapping file schema.&nbsp; Any syntax errors that violate the schema will immediately be apparent.

[<img alt="nh_mapping_missingkey" src="http://static.flickr.com/199/512954001_c9be9a21b0.jpg" border="0" />](http://www.flickr.com/photos/74595743@N00/512954001/ "nh_mapping_missingkey")

Doh!&nbsp; I forgot to add the <key /> element.&nbsp; No worries&#8230;&nbsp; 🙂

[<img alt="nh_mapping_intellisense" src="http://static.flickr.com/193/512926306_714a6a3c7f.jpg" border="0" />](http://www.flickr.com/photos/74595743@N00/512926306/ "nh_mapping_intellisense")

So xml schema validation and intellisense&nbsp;are kind of your first line of defense against making mistakes in your mapping files.

#### Don&#8217;t Want To Hand Write XML Mapping Files?

For the most part, I still do hand-write my xml mapping files, mostly because they&#8217;re pretty easy once you write a few, and with intellisense enabled, as shown in the previous section, it&#8217;s even easier.&nbsp; But, there is (at least) one alternative to this.&nbsp; One of [Ayende&#8217;s](http://ayende.com/default.aspx) great NHibernate utilities is his [NHibernate Query Analyzer](http://ayende.com/projects/nhibernate-query-analyzer.aspx)&nbsp;(NHQA).&nbsp; This has a couple of uses (another of which I&#8217;ll get into later), but included in it is a UI for maintaining NHibernate mapping files.

[<img alt="nhqa_mapping_ui" src="http://static.flickr.com/225/512969625_faacfaec7b.jpg" border="0" />](http://www.flickr.com/photos/74595743@N00/512969625/ "nhqa_mapping_ui")

So this is one more way&nbsp;you can make sure you don&#8217;t have errors in your mapping files because using the UI will make sure your mappings are in the correct format.

#### Are The Properties In My Mapping File Valid?

Schema validation and a configuration UI are great for making sure your mapping file is in the correct format.&nbsp; But one thing it won&#8217;t catch, for instance, is a <property /> mapping that points to a non-existing property on the specified class.&nbsp; One quick and dirty&nbsp;way to catch these is to load up your mapping files into the NHQA and &#8220;build the project&#8221;.&nbsp; 

[<img alt="nhqa_main_ui" src="http://static.flickr.com/212/512937090_b6b6fafac0.jpg" border="0" />](http://www.flickr.com/photos/74595743@N00/512937090/ "nhqa_main_ui")

When&nbsp;you click on **Build Project**, if any mapping errors are detected, it&#8217;ll show an exception dialog with a pretty good error message telling what&#8217;s wrong.

[<img alt="nhqa_mapping_exception" src="http://static.flickr.com/200/512972851_7f15cc964f.jpg" border="0" />](http://www.flickr.com/photos/74595743@N00/512972851/ "nhqa_mapping_exception")

Of course this is still a manual process, which is not good, but it&#8217;ll get you by for a quick sanity check.&nbsp; It&#8217;s also just a great tool in general for learning and building HQL queries against a real database.

(On a side note&#8230;&nbsp;&nbsp;Is it just me, or does it seem that most open source tools have much better, detailed error/exception messages&nbsp;and logging than a lot of the commerical tools?&nbsp; I&#8217;ve always been impressed with NHibernate and Castle in that regard&#8230;)

Anyways, hope you can find this useful.