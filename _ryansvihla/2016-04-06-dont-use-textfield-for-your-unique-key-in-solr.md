---
wordpress_id: 274
title: Don’t use TextField for your unique key in Solr
date: 2016-04-06T08:42:55+00:00
author: Ryan Svihla
layout: post
wordpress_guid: https://lostechies.com/ryansvihla/?p=274
dsq_thread_id:
  - "4787964919"
categories:
  - Cassandra
  - Solr
tags:
  - Cassandra
  - DSE
  - Solr
---
<div>
  <p id="651b">
    This seems immediately obvious when you think about it, but TextField is what you use for fuzzy searches in Solr, and why would a person want a fuzzy search on a unique value? While I can come up with some oddball use cases, making use of copy fields would seem to be the more valid approach and fitting with the typical use of Solr IE you filter on strings and query on text.
  </p>
  
  <p id="11fe">
    However, people have done this a few times and they throw me for a loop and in the case of DataStax Enterprise Search (built on Solr) this creates an interesting split between the index and the data.
  </p>
  
  <h3 id="c21b">
    Given a Cassandra schema of
  </h3>
  
  <p>
    {% gist 8b9dd0f5dadfa84f7969851b4ae12e7b %}
  </p>
  
  <h3 id="367e">
    A Solr Schema of (important bits in bold):
  </h3>
  
  <p>
    {% gist 36abe7538944fed4a0120bc7cc288c85 %}
  </p>
  
  <h4 id="4d8e">
    Initial records never get indexed
  </h4>
  
  <p id="615f">
    I’m assuming this is because the aspect of indexing that checks to see if it’s been visited or not is thrown by the tokens:
  </p>
  
  <p id="7f81">
    First fill up a table
  </p>
  
  <p>
    {% gist ca4f8e13d8794b3c2d1b7628b6b11887 %}
  </p>
  
  <p id="6da8">
    Then turn on indexing
  </p>
  
  <p>
    {% gist 309f83fb74774c04dfab8f052454ab97 %}
  </p>
  
  <p id="a64a">
    Add one more record
  </p>
  
  <p>
    {% gist f335f8b37bc857e64542eedfaab1cc5d %}
  </p>
  
  <p id="045f">
    Then query via Solr and…no ‘1235’ or ‘1234’
  </p>
  
  <p>
    {% gist a763c29cc02eea4b27c1a5bc6d099b55 %}
  </p>
  
  <p id="2ad2">
    But Cassandra knows all about them
  </p>
  
  <p>
    {% gist 308453d2815b4784caa5210608489083 %}
  </p>
  
  <p id="fa2d">
    To recap we never indexed ‘1234’ and ‘1235’ for some reason ‘123’ indexes and later on when I add 9999 it indexes fine. Later testing showed that as soon as readded ‘1234’ is joined the search results, so this only appears to happen to records that were there before hand.
  </p>
  
  <h4 id="5cae">
    Deletes can greedily remove LOTS
  </h4>
  
  <p>
    {% gist e569418e16e053375c21c67974beaaea %}
  </p>
  
  <p id="5b46">
    I delete id ‘1234’
  </p>
  
  <p>
    {% gist 260f819352540d84098f01896ebd19fd %}
  </p>
  
  <p id="b294">
    But when I query Solr I find only:
  </p>
  
  <p>
    {% gist 545bc4475e071326359657d7915f54fe %}
  </p>
  
  <p id="1cad">
    So where did ‘1234 4566’, ‘1235’, and ‘1230’ go? If I query Cassandra directly they’re safe and sound only now Solr has no idea about them.
  </p>
  
  <p>
    {% gist 54e5c225c213f9f146fb5a34b4f1fe31 %}
  </p>
  
  <p id="20ca">
    To recap, this is just nasty and the only fix I’ve found is either reindexing or just adding the records again.
  </p>
  
  <h4 id="96f5">
    Summary
  </h4>
  
  <p id="a8c0">
    Just use a StrField type for your key and everything is happy. Special thanks to J.B. Langston (twitter <a href="https://twitter.com/jblang3" rel="nofollow" data-href="https://twitter.com/jblang3">https://twitter.com/jblang3</a>) of DataStax for finding the nooks and crannies and then letting me take credit by posting about it.
  </p>
</div>

<div>
</div>