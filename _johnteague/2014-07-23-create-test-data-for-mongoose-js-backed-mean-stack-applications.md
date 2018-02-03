---
wordpress_id: 221
title: Create test data for mongoose.js backed MEAN stack applications
date: 2014-07-23T04:16:08+00:00
author: John Teague
layout: post
wordpress_guid: http://lostechies.com/johnteague/?p=221
dsq_thread_id:
  - "2865887322"
categories:
  - Uncategorized
---
{% raw %}
tl:dr: I&#8217;ve created a node library that creates test data with Mongoose.  You can check it out here:

<https://github.com/jcteague/mongoose-fixtures>

## Integration Tests FTW!

Because nodejs+mongodb applications are so fast to start up, most of my tests are integration tests.  I test from the API level down, spinning up an instance of my application server with each test suite and using SuperTest to generate the http calls and verify the results and http codes that are generated.  And each test runs in about 50 ms so I can run through all of my test very quickly, get very complete code coverage, and reduce my testing footprint.  This simply wouldn&#8217;t be possible using ASP.Net or on a JVM web framework.  It would way too long.  for an application where I would have 100-200 tests, I&#8217;m able to test it thoroughly with 20 or 30 tests.  I break down to unit-level tests only when I don&#8217;t know what I&#8217;m doing and need TDD to guide me through it.

While working mostly with integration tests have helped test more with less, you face the problem of setting up your test data to verify your behavior is correctly.  With the asynchronous of node, this can clutter up your test suites very quickly, especially when you need more that one model or when they are related.

To help remedy that I&#8217;ve shared a module that creates test data with Mongoose.js that abstracts all of the data creation and async goo to help keep your test suites readable. It also makes the test data easily accessible to reference later in your tests.

Mongoose.js is a hard dependency.  If you&#8217;re working with another mongodb library, I doubt this library would work without modification.

## Using Mongoose-Fixtures

The module only exposes two functions:
  
**create** that creates the data
  
**clean_up** that deletes the data

A typical test suite setup / teardown would look like this:

<pre>var FixturePrep = require("mongoose-fixture-prep");
var fixtures = new FixturePrep();</pre>

<pre>describe("creating single fixture",function(){
 before(function(done){
 fixtures.create(
 [
   {name:'user1',
    model: 'User', 
    val:{firstName:'John',lastName:'Smith'}}
 ], done);
 });

 after(function(done){fixtures.clean_up(done)});</pre>

The parameters passed to create are name, model, and val.  The obvious fields here are model and val, where model is the name of the mongoosejs model you&#8217;ve defined and val is the object you want to save.  What name does is creates a new field on the fixtures object so that you can reference it later in your tests.  Here is a test that shows that it works:

<pre>it("should be able to access the object you saved", function(){
 //user1 is attached to the
 fixtures.should.have.property('user1');
 //it's has been saved and now has the _id field
 fixtures.user1.should.have.property('_id');
 });</pre>

## Multiple Objects

As you can see the create takes an array of these objects, so you can create multiple test data objects at once:

<pre>var FixturePrep = require("mongoose-fixture-prep");
var fixtures = new FixturePrep();</pre>

<pre>describe("creating a multiple fixtures", function(){
 before(function(done){
 fixtures.create([{name:'user1',model: 'User', val:{firstName:'John',lastName:'Smith'}},
 {name:'admin',model: 'User', val:{firstName:'super',lastName:'user', roles:['admin']}}
 ], done) 
 })

 it("should be able to access the object you saved", function(){
 //user1 is attached to the
 fixtures.should.have.property('user1');
 fixtures.should.have.property('admin');

 fixtures.admin.should.have.property('_id');
 });
});</pre>

## Arrays of Data

You can also create an array of data and have it associated with one test fixture property.

<pre>describe("creating an array of data", function(){
 before(function(done){
  fixtures.create([
    {name:'users',
     model: 'User', 
     val:[
     {firstName:'John',lastName:'Smith'},
     {firstName:'Jane',lastName:'Doe'}
    ]},
    {name:'admin',model: 'User', val:{firstName:'super',lastName:'user', roles:['admin']}}
 ], done) 
 });
 it("should be able to access the object you saved", function(){
 fixtures.users.length.should.eql(2);
 fixtures.should.have.property('admin');
 });
});</pre>

## Related Data

One of the hardest parts was coming up with a way to create inter-related test data.  The cleanest way I could come up with is passing a function for the val parameter that has can access to the fixtures already created.

<pre>describe("related data", function(){
 before(function(done){
 user_with_company = function(fixtures){
  return {firstName:'John',lastName:'Smith', company: fixtures.testCompany}
 };
 fixtures.create(
 [
 {name:'testCompany',model:'Company',val:{name:'my company'}},
 {name:'user1',model: 'User', val:user_with_company}<span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">], done) </span><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">})</span><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">it("should have the saved product in the line items", function(){ </span><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;"> fixtures.user1.should.have.property('company'); </span><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;"> fixtures.user1.company.should.eql(fixtures.testCompany._id); </span><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">}); </span><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">})</span></pre>

This is not as clean as I would like it, but it sure beats the alternative of trying to do all of that in the setup manually 😉

## Use with AutoFixture

In a previous post, I introduced AutoFixture.js, that is a test fixture factory to generate the test objects.  In my applications I use these two together.  In the spirit of having small composable  modules, they have been separated.  But they work well together.

<pre>describe('using with autofixture',function(){
 before(function(done){
 factory.define('User',['firstName','lastName'])
 fixtures.create([
 {name:'user1',model:'User',val:factory.create('User')}
 ],done);
 });</pre>

<pre>it("should create the fixtures from the factory",function(){
 fixtures.should.have.property('user1');
 //it's has been saved and now has the _id field
 fixtures.user1.should.have.property('_id');
 })
})</pre>

These have been extracted out of a project that I worked on recently, so they are being used in real life.  I&#8217;d still like to do more to make it more integrated into mocha.  For instance it&#8217;d be cool of the fields were part of the test suite directly instead of the fixture class.  Related data still needs some work too.  It&#8217;s all available on github, so Pull Requests are welcome!!

&nbsp;
{% endraw %}
