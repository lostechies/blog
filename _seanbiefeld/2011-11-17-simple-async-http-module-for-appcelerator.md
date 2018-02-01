---
id: 4456
title: Simple Async HTTP Module for Appcelerator
date: 2011-11-17T04:00:53+00:00
author: Sean Biefeld
layout: post
guid: http://lostechies.com/seanbiefeld/?p=134
dsq_thread_id:
  - "474622009"
categories:
  - Appcelerator
  - JavaScript
tags:
  - Appcelerator
  - CommonJS
  - http
  - javascript
  - Titanium
---
Hello techies,

I have been using [Appcelerator](http://wiki.appcelerator.org/display/guides/Quick+Start) recently. It is a pretty cool tool, it allows you to create cross platform mobile applications for iOS and Android, writing JavaScript.

Appcelerator&#8217;s Titanium Framework uses the [CommonJS API](http://www.commonjs.org/) so you can reference javascript files as &#8220;modules&#8221;, it is very reminiscent of node.js which also implements CommonJS.

Below is a simple async module I wrote, inspired by [codeboxed&#8217;s gist](https://gist.github.com/888409), to make requests to a web server. Stick it in a file named SimpleHttpAsync.js

<pre style="background-color:#222;color:#ddd;overflow:auto;padding:20px 10px;font-family:monospace;"><span style="color:#666">  //////////////////////////////////////////////
 //                Simple Http Async         //
//////////////////////////////////////////////</span>

exports.call = function (options) {
    <span style="color:#666">//create the titanium HTTPClient</span>
    var httpClient = Titanium.Network.createHTTPClient();

    <span style="color:#666">//set the httpclient's properties with the provided options</span>
    httpClient.setTimeout(options.timeout);
    httpClient.onerror = options.error;
       
    <span style="color:#666">//if and when response comes back
    //the success function is called</span>
    httpClient.onload = function(){
        options.success({
            data: httpClient.responseData, 
            text: httpClient.responseText
        });
    };
        
    <span style="color:#666">//open the connection</span>
    httpClient.open(options.type, options.url, true);

   <span style="color:#666"> //send the request</span>
    httpClient.send();
};</pre>

The following is example code of importing and using the module

<pre style="background-color:#222;color:#ddd;overflow:auto;padding:20px 10px;font-family:monospace;"><span style="color:#666">//import the module</span>
var simpleHttpAsync = require('simpleHttpAsync');

<span style="color:#666">//call the function
//handle errors and successful request</span>
simpleHttpAsync.call({
    type : "POST",
    url : "http://www.someurl.com?somekey=somevalue",
    error : function (error) {
        //do something to handle error
    },
    success : function (response) {
        //do something with the response data from the server
    },
    timeout : 10000
});
</pre>

It&#8217;s nothing special, but the documentation for Appcelerator is pretty sparse and I thought it might be useful for those new to the Appcelerator Titanium Framework.

As always enjoy and let me know if you have any comments/suggestions/questions. Thanks!