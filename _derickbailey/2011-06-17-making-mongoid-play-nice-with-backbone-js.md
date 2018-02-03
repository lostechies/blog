---
wordpress_id: 442
title: Making Mongoid Play Nice With Backbone.js
date: 2011-06-17T07:12:21+00:00
author: Derick Bailey
layout: post
wordpress_guid: http://lostechies.com/derickbailey/?p=442
dsq_thread_id:
  - "334885734"
categories:
  - Backbone
  - JavaScript
  - JSON
  - MongoDB
  - Mongoid
  - Rails
  - Ruby
---
Backbone has some great features that make it dirt-simple to integrate with a Rails back end. For example, the Backbone models have a .fetch(), .save() and .destroy() method on them. These methods make a call back to your server, based on a url configured on the model. On the server side, you only need to implement the standard CRUD methods of the controller that you routed your Backbone model to, and you have a simple API to CRUD data from the user&#8217;s browser, to your back end, and back.

But there&#8217;s a problem with Mongoid (the document mapper I&#8217;m using for MongoDB) that prevents this from working, out of the box.

 

### The Problem: id vs _id

Most implementations of ORM and ODM mechanisms in Rails use the standard &#8220;id&#8221; attribute on models, to represent the identity of the model. Backbone takes advantage of this knowledge and uses the presence of an id attribute to determine whether or not an object was created in javascript on the browser, or on the server and sent to the browser.

If you create an object in javascript, there won&#8217;t be an id, initially. When you call .save() on that object, Backbone will http &#8220;post&#8221; your object to the server, so that rails will create a new server side object with the data provided. Then, you serialize the object that was created back to json and return it to the calling browser. Backbone reads the id that is now present on the object and updates it&#8217;s JSON representation of the model with the id. When you call .save() on the Backbone model again, it sees the id field and does an http &#8220;put&#8221; to the server, to update the existing model on the server side.

Mongoid, in your rails code, uses a .id attribute to store a document&#8217;s identity. However, there&#8217;s a small problem with the way mongoid serializes the document. If you examine the database collection for your document, you&#8217;ll see that every mongoid document is stored with an \_id instead of an id field. I&#8217;m not sure why mongoid does this, but it does. Since mongodb stores documents as BSON (binary JSON) documents, mongoid naturally has a built in mechanism to convert models to json documents. This mechanism is the same whether you are saving to the database or calling .to\_json on the model to return it to the browser. The net result is that mongoid sends JSON documents with a _id in them, which Backbone does not recognize.

[gist id=1030704 file=1-model.rb]

Because mongoid sends an _id field instead of an id field, Backbone will never try to http &#8220;put&#8221; your models back to the server, for an update. It will always http &#8220;post&#8221; them to create a new one.

 

### The Solution: Override Mongoid&#8217;s .as_json

The solution to making mongoid play well with Backbone, is to provide an id field in the json that mongoid sends to the browser. To do that, we can override the as\_json method of the Mongoid::Document module. This method gets called to generate a json document from a rails model. I&#8217;m not actually sure if this is a method that gets before during the execution of to\_json, or if to_json is just an alias. Either way, this is the method that you want to override, and here&#8217;s how to do it:

[gist id=1030704 file=2-tojson.rb]

In this code, calling the super method of to\_json, to get the json representation of the document from mongoid, directly. Then we&#8217;re adding an id key with the same value as \_id. This allows the json serialization to have an id field the way Backbone wants. Include this module in your rails app and every mongoid document that is serialized to json will include and id field (It will not save the model to the mongodb collection with an &#8220;id&#8221;, though). This lets mongoid play nice with backbone, and you can now call .save() on your Backbone models knowing that it will create or update your model correctly.

(Note that we&#8217;re not removing the \_id field in this code, so we do end up with the id duplicated. I&#8217;m not sure if removing \_id would cause any issues, and we didn&#8217;t want to go a lot of work to find out.)