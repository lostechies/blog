---
wordpress_id: 75
title: 'Powerfully simple persistence: MongoDB'
date: 2012-02-06T10:15:00+00:00
author: Joshua Flanagan
layout: post
wordpress_guid: http://lostechies.com/joshuaflanagan/2012/02/06/easy-persistence-mongodb/
dsq_thread_id:
  - "566460256"
categories:
  - MongoDB
  - Ruby
---
In my post &#8220;<a href="https://lostechies.com/joshuaflanagan/2012/01/31/great-time-to-be-a-developer/" target="_blank">Great time to be a developer</a>&#8220;, I listed <a href="http://www.mongodb.org/" target="_blank">MongoDB</a> as one of the tools that made my task (track travel times for a given route) easy. This post will show you how.

## What do I need to store?

My travel time data collection job needs the URL for the traffic data endpoint for each route that I&#8217;ll be tracking. I could have just hardcoded the URL in the script, but I knew that my co-workers would be interested in tracking their routes too, so it made sense to store the list of routes in the database.

I need to store the list of &#8216;trips&#8217;. I define a trip as the reported travel details for a given route and departure time (Josh&#8217;s route at 9am, Josh&#8217;s route at 9:10am, Tim&#8217;s route at 9:10am, etc.). I want to capture the date of each trip so that I can chart the trips for a given day, and compare day to day variation. Even though I really only need to the total travel time for each trip, I want to capture the entire response&nbsp; from the traffic service (travel times, directions, traffic delay, etc.) so that I could add new visualizations in the future.

## Setup

First, I had to install mongo on my laptop. I used the <a href="http://www.mongodb.org/downloads" target="_blank">homebrew</a> package manager, but <a href="http://www.mongodb.org/downloads" target="_blank">binary releases are readily available</a>.

<pre>brew install mongodb
</pre>

I need to add the route for my commute. I fire up the mongo console by typing <font size="4" face="Cordia New">mongo</font>. I&#8217;m automatically connected to the default &#8216;test&#8217; database in my local mongodb server. I add my route:

<pre class="brush:js; gutter:false; tab-size:2;toolbar: false">&gt; db.routes.save({
  name: 'josh',
  url: 'http://theurlformyroute...'
})</pre>

I verify the route was saved:

<pre class="brush:js; gutter:false; wrap-lines:true; tab-size:2;toolbar: false">&gt; db.routes.find()
{"_id" : ObjectId("4f22434d47dd721cf842bdf6"),
 "name" : "josh",
 "url" : "http://theurlformyroute..." }
</pre>

It is worth noting that I haven&#8217;t skipped any steps. I fired up the mongo console, ran the save command, and now I have the route in my database. I didn&#8217;t need to create a database, since the &#8216;test&#8217; database works for my needs. I didn&#8217;t need to define the routes collection &#8211; it was created as soon as I stored something in it. I didn&#8217;t need to define a schema for the data I&#8217;m storing, because there is no schema. I am now ready to run my data collection script.

## Save some data

I&#8217;ll use the ruby MongoDB driver (gem install mongo) directly (you can also use something like mongoid or mongomapper for a higher-level abstraction). My update script needs to work with the URL for each route:

<pre class="brush:ruby; gutter:false; wrap-lines:false; tab-size:2;toolbar: false">db = Mongo::Connection.new.db("test")
db["routes"].find({}, :fields =&gt; {"url" =&gt; 1}).each do |route|
  url = route["url"]
  # collect trip data for this route's url
end
</pre>

I want to group related trips for a commute, so I create a &#8216;date\_key&#8217; based on the current date/time. A date\_key looks like: 2012-01-25\_AM, 2012-01-25\_PM, or 2012-01-26_AM. Now to store the details returned from the traffic service:

<pre class="brush:ruby; gutter:false; wrap-lines:false; tab-size:2;toolbar: false">trip_details = TrafficSource.get(url)
db["routes"].update({"_id" =&gt; route["_id"]}, {
  "$addToSet" =&gt; {"trip_keys" =&gt; date_key},
  "$push" =&gt; {"trips.#{date_key}" =&gt; trip_details}
})
</pre>

After running for a couple days, this will result in a route document that looks something like:

<pre class="brush:js; gutter:false; wrap-lines:false; tab-size:2;toolbar: false">{
  _id: 1234,
  name: 'josh',
  url: 'http://mytravelurl...',
  trip_keys: ['2012-01-25_AM', '2012-01-25_PM', '2012-01-26_AM',...],
  trips: {
    2012-01-25_AM: [{departure: '9:00', travelTime: 24, ...}, {departure: '9:10', travelTime: 26}, ...],
    2012-01-25_PM: [{departure: '9:00', travelTime: 28, ...}, {departure: '9:10', travelTime: 29}, ...],
    2012-01-26_AM: [{departure: '9:00', travelTime: 25, ...}, {departure: '9:10', travelTime: 25}, ...],
    ...
  }
}
</pre>

That is \*all\* of the MongoDB-related code in the data collection script. I haven&#8217;t left out any steps &#8211; programmatic, or administratrive. None of the structue was defined ahead of time. I just &#8216;$push&#8217;ed some trip details into &#8216;trips.2012-01-25\_AM&#8217; on the route. It automatically added an object to the &#8216;trips&#8217; field, with a &#8216;2012-01-25\_AM&#8217; field, which holds an array of trip details. I also store a list of unique keys in the trip_keys field using $addToSet in the same \`update\` statement.

## Show the data

The web page that charts the travel times makes a single call to MongoDB:

<pre class="brush:ruby; gutter:false; wrap-lines:false; tab-size:2;toolbar: false;">route = db["routes"].find_one(
  {:name =&gt; 'josh'},
  :fields =&gt; {"trips" =&gt; 1}
)</pre>

The entire trips field, containing all of the trips grouped by date_key, is now available in the ruby hash <font size="4" face="Courier New">route</font>. With a little help from ruby&#8217;s <a href="http://ruby-doc.org/core-1.9.3/Enumerable.html#method-i-map" target="_blank">Enumerable#map</a>, I transform the data into a format consumable by <a href="http://www.highcharts.com/" target="_blank">Highcharts JS</a>.

## Production

Just to be thorough, I&#8217;ll mention that I had to modify the script for production use. I replaced the \`db\` local variable with a method that uses the <a href="http://addons.heroku.com/mongolab" target="_blank">mongolab</a> connection when available, or falls back to the local test connection:

<pre class="brush:ruby; gutter:false; wrap-lines:false; tab-size:2;toolbar: false">def db
  @db ||=
  begin
    mongolab_uri = ENV['MONGOLAB_URI']
    return Mongo::Connection.new.db("test") unless mongolab_uri
    uri = URI.parse(mongolab_uri)
    Mongo::Connection.from_uri(mongolab_uri).db(uri.path.gsub(/^\//, ''))
  end
end
</pre>

## Conclusion

A couple queries, a single, powerful update statement, and no administration or schema preparation. Paired with the <a href="http://api.mongodb.org/ruby/current/file.TUTORIAL.html" target="_blank">ruby driver</a>&#8216;s seemless mapping to native Hash objects, it is hard to imagine a simpler, equally powerful, persistence strategy for this type of project.