---
wordpress_id: 212
title: 'AutoFixture &#8212; a Node.js Test Fixture Library'
date: 2014-05-21T03:35:59+00:00
author: John Teague
layout: post
wordpress_guid: http://lostechies.com/johnteague/?p=212
dsq_thread_id:
  - "2701173483"
categories:
  - JavaScript
  - NodeJS
  - Testing
---
Working on a recent project that was on the MEAN stack, I needed to create test data quickly. I reviewed and tested out some of the existing libraries that are out there, but none of them fit my specific style. My favorite fixture library of all time is NBuilder for C#.  It generates the fixture from the type information and also generates pseudo random data to put into them.  If you can generate a fixture that way in JavaScript, I&#8217;m certainly not capable of it, so I took what I could from NBuilder and applied it to the factory-girl / factory-lady style of defining a fixture, with the pseudo random generation of NBuilder.  The result is <a title="AutoFixturejs" href="https://github.com/jcteague/autofixturejs" target="_blank">AutoFixturejs</a>.

I&#8217;ve been dogfooding it for a while and it&#8217;s met my needs so far, but it&#8217;s far from done.  Please check it out and provide feedback.

## Installing

It is available from npm

<pre>npm install autofixture</pre>

## Usages

Using the library consists of two parts, 1) defining the factories and 2) creating them in your tests

## <a name="user-content-creating-a-factory" href="https://github.com/jcteague/autofixturejs#creating-a-factory"></a>Creating a factory

You can define an object factory in one of the ways

  * Array of strings
  * object notation

### <a name="user-content-fields-defined-with-an-array" href="https://github.com/jcteague/autofixturejs#fields-defined-with-an-array"></a>Fields Defined with an Array

<div>
  <pre>Factory.define('User',['first_name','last_name','email'])</pre>
</div>

This will create an object with the fields specified in the array

<div>
  <pre>var user = Factory.create('User')</pre>
</div>

The user object will have the fields specified in the definition with pseudo random values:

<div>
  <pre>{
    first_name: 'first_name1',
    last_name: 'last_name1',
    email: 'email1'
}</pre>
</div>

When you create another instance of this object with the factory, the numbers will be incremented:

<div>
  <pre>    //second object:
    var user2 = factory.create('User')

    {
        first_name: 'first_name2',
        last_name: 'last_name2',
        email: 'email2'
    }</pre>
</div>

You can also create an array of fixtures, each with with unique values.

<div>
  <pre>var users = factory.createListOf('User',2)

[
    {
        first_name: 'first_name1',
        last_name: 'last_name1',
        email: 'email1'
    },
    {
        first_name: 'first_name2',
        last_name: 'last_name2',
        email: 'email2'
    }</pre>
</div>

## <a name="user-content-overriding-values" href="https://github.com/jcteague/autofixturejs#overriding-values"></a>Overriding values

You can also override at creation time as well

<div>
  <pre>factory.define('User',[
    'first_name',
    'roles'.asArray(1)
]);

var adminUser = factory.create('User',{roles:['admin']});</pre>
</div>

To change the behavior of the factory and return specific data types, several helper methods are added to the string object

<div>
  <pre>Factory.define('User',[
    'first_name',
    'id'.asNumber(),
    'created'.asDate(),
    'roles'.asArray(2)
    'city'.withValue('MyCity')

    ]);

//created will be DateTime.now
var user = Factory.create('user')
{
    first_name: 'first_name1',
    id: 1
    created: Date
    roles: ['roles1','roles2'],
    city: 'MyCity1'
}</pre>
</div>

Custom genearators can be defined as well:

<div>
  <pre>Factory.define('User',[
'first_name',
'email'.as(function(i){ return 'email'+i+'@email.com';});
]);

var user = factory.create('User');

{
    first_name: 'first_name1',
    email: 'email1@email.com'
}</pre>
</div>

You can also used other Factories to generate fields

<div>
  <pre>Factory.define('User',[
    'first_name',

]);

Factory.define('Order',[
    'id'.asNumber(),
    'order_date'.asDate()
    'user'.fromFixture('User')
]);</pre>
</div>

## <a name="user-content-using-objects-to-define-a-factory" href="https://github.com/jcteague/autofixturejs#using-objects-to-define-a-factory"></a>Using Objects to Define a Factory

You can also use an object to define your fixtures. When you use an object the values for each field are used to create random data when you create the fixture

<div>
  <pre>factory.define('User',{first_name, 'first', created_at: new Date(), id:1});
var user = factory.create('User');
{
    first_name: 'first1';
    created_at: new Date
    id: 1
}</pre>
</div>

## <a name="user-content-creating-a-fixtures-file" href="https://github.com/jcteague/autofixturejs#creating-a-fixtures-file"></a>Creating a Fixtures file

Generally speaking you&#8217;ll want to put the fixture definitions into a single file and reuse for different tests. There&#8217;s no real specific way you must do this, but this is how I&#8217;ve set mine up and it is working well for me

Create a module that takes the factory as a function dependency

<div>
  <pre>//fixtures.js
=============

exports.module = function(factory){
    factory.define ...
}</pre>
</div>

In your test files require AutoFixture then pass the AutoFixture variable to the fixtures class

<div>
  <pre>//tests.js
var factory = require('AutoFixture')
require('./fixtures')(factory)</pre>
</div>

Now you can use the factory to access your defined fixtures.

<div>
  <pre>describe("my tests",functio(){
    var user = factory.create('user');

});</pre>
</div>

<pre>npm install autofixture</pre>

## How to Use it

The readme has a lot of examples of how to use it (as well as the tests), so I don&#8217;t want to repeat it here, but here are some hightlights.

You can create a fixture by either providing an array of property names to include or an object:

<pre>Factory.define('User',['first_name','last_name','email'])</pre>