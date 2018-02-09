---
wordpress_id: 22
title: Another Way to Test Ajax Methods
date: 2009-02-10T05:47:45+00:00
author: John Teague
layout: post
wordpress_guid: /blogs/johnteague/archive/2009/02/10/another-way-to-test-ajax-methods.aspx
dsq_thread_id:
  - "262055585"
categories:
  - Uncategorized
redirect_from: "/blogs/johnteague/archive/2009/02/10/another-way-to-test-ajax-methods.aspx/"
---
{% raw %}
A while ago, [Chad](http://chadmyers.lostechies.com) posted about how to [test Ajax methods with QUnit](http://www.lostechies.com/blogs/chad_myers/archive/2008/12/22/asynchronous-javascript-testing-with-qunit.aspx).&#160; I’m also testing Ajax calls, but taking a different approach I thought I would share.

Chad’s approach was to put a timer in the test and waiting a while before performing the assertion.&#160; Another way is to hook into JQuery global ajax events, like the ajaxComplete event.&#160; Here’s some sample code that makes a call to the Flickr API via jsonp.

<div>
  <pre><span style="color: #0000ff">var</span> url = <span style="color: #006080">"http://api.flickr.com/services/feeds/photos_public.gne?tags=austin,tx&format=json&jsoncallback=?"</span>;

$(document).ready(<span style="color: #0000ff">function</span>(){
    test(<span style="color: #006080">"should get results from getJson call"</span>,<span style="color: #0000ff">function</span>(){
        expect(1);
        <span style="color: #0000ff">var</span> results;
        $(document).ajaxComplete(<span style="color: #0000ff">function</span>(){
            start();
            equals(results.title,<span style="color: #006080">"Recent Uploads tagged austin and tx"</span>,<span style="color: #006080">"actual: "</span> + results.title);
        });
        stop();
        $.getJSON(url,<span style="color: #0000ff">null</span>,<span style="color: #0000ff">function</span>(data){
            results = data;
        });
    })

});</pre>
</div>

## Avoid Testing Ajax Calls in Unit Tests

Huh? You just showed me a way to do it, why should I avoid it?&#160; Making an Ajax call is just like making a database call, which should only be done for integration style tests.&#160; Just as you would stub a data repository method call in C#, you should do the same for AJAX calls.&#160; Except in JavaScript, this is 10 time easier because of it’s a dynamic, functional language.&#160; You can easily stub out method calls by replacing the method.

In this case I am testing against the title property, so I need a stub that looks like the getJSON method and returns back the title property.

Here is the same test, but with a stubbed out getJSON method.

<div>
  <pre><span style="color: #0000ff">var</span> stubbedJSON = <span style="color: #0000ff">function</span>(url,data,callback,format){
        callback({title:<span style="color: #006080">"fake results"</span>});
    };
    <span style="color: #0000ff">var</span> originalJSON = $.getJSON;
    module(<span style="color: #006080">"stubbing out getJSON"</span>, {setup: <span style="color: #0000ff">function</span>(){
        $.getJSON = stubbedJSON;
    }, teardown: <span style="color: #0000ff">function</span>(){
      $.getJSON = originalJSON;  
    }})
    test(<span style="color: #006080">"getJSON should be stubbed"</span>,<span style="color: #0000ff">function</span>(){
        expect(1);
        $.getJSON(url,<span style="color: #0000ff">null</span>,<span style="color: #0000ff">function</span>(data){
            equals(data.title,<span style="color: #006080">"fake results"</span>);
        });
    });</pre>
</div>

One thing that I learned the hard way with QUnit tests is that whenever you stub a method, it stays stubbed for **ALL** of the test on the test page.&#160; To get around that, I store the original method in a variable, then reset the method manually in the teardown.&#160; This keeps my changes isolated for each test.

Now I’m able to test the logic of my JavaScript isolated from the data coming back from my data service.&#160; Notice how easy it was to stub out the method.&#160; No complicated mocking tool required.&#160; One you embrace the dynamic_ ****and_ the functional nature of JavaScript, you can do a lot more with the language than you expected.&#160; I’m appreciating JavaScript a lot more these days.
{% endraw %}
