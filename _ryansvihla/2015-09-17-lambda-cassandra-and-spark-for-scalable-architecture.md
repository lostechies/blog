---
wordpress_id: 221
title: 'Lambda+: Cassandra and Spark for Scalable Architecture'
date: 2015-09-17T12:54:59+00:00
author: Ryan Svihla
layout: post
wordpress_guid: https://lostechies.com/ryansvihla/?p=221
dsq_thread_id:
  - "4139088813"
categories:
  - Cassandra
  - Spark
tags:
  - Cassandra
  - Lambda
  - Spark
---
<p id="6964">
  <em style="font-size: 16px;">UPDATE: For some background on Spark Streaming and Cassandra please consult some of my previous </em><a style="font-size: 16px;" href="https://medium.com/@foundev/real-time-analytics-with-spark-streaming-and-cassandra-2f90d03342f7" data-href="https://medium.com/@foundev/real-time-analytics-with-spark-streaming-and-cassandra-2f90d03342f7"><em>blog post on the subject</em></a><em style="font-size: 16px;">.</em>
</p>

<p id="abf8">
  Many of you have heard of and a few of you may have used the Lambda Architecture. If you’ve not heard of it the name doesn’t communicate a lot. In short the Lambda Architecture has 3 primary components with a 2 pronged approach to analytics:
</p>

<li id="5758">
  Speed Layer: Records are analyzed as they’re created in the Speed Layer.
</li>
<li id="8180">
  Batch Layer will run the same analytics as the Speed Layer but on <strong>all records</strong> with a database designed for this type of work such as <a href="https://github.com/nathanmarz/elephantdb" rel="nofollow" data-href="https://github.com/nathanmarz/elephantdb">ElephantDB</a>.
</li>
<li id="b5fb">
  A Serving Layer will read data from the Speed Layer and data from the Batch Layer. If there is a disagreement on the same records, then data from the Batch Layer will be treated as authoritative.
</li>

<p id="b533">
  This is a very brief overview with some generalizations, so for those interested in the detail I suggest reading up more at <a href="http://lambda-architecture.net/" rel="nofollow" data-href="http://lambda-architecture.net/">http://lambda-architecture.net/</a>.
</p>

### Ok great so how does Cassandra & Spark fit in? {#de66}

<p id="bb85">
  With <a href="http://www.planetcassandra.org/" rel="nofollow" data-href="http://www.planetcassandra.org/">Cassandra</a> & <a href="http://spark.apache.org/" rel="nofollow" data-href="http://spark.apache.org/">Spark</a> we can build something that achieves the same goals as the Lambda Architecture but more simply and with fewer moving pieces by combining your Speed Layer and your Batch Layer into a single data store running on <a href="http://www.planetcassandra.org/" rel="nofollow" data-href="http://www.planetcassandra.org/">Cassandra</a> and utilizing <a href="http://spark.apache.org/" rel="nofollow" data-href="http://spark.apache.org/">Spark</a> and <a href="https://spark.apache.org/streaming/" rel="nofollow" data-href="https://spark.apache.org/streaming/">Spark Streaming</a> to have a single code base responsible for analytics and streaming. This paper will detail how to achieve this savings in complexity compared to the traditional Lambda Architecture.
</p>

<p id="1eba">
  <strong>Deployment Overview</strong>
</p>

<li id="4384">
  5 Cassandra also running Spark. We place them on the same hardware for data locality reasons.
</li>
<li id="57ee">
  3 Messaging servers to handle ingest. I have chosen Kafka brokers for fast ingest. This can however be any message queue.
</li>
<li id="4bbd">
  3 application servers running the preferred Application server of a given organization. This can be Jetty, NodeJS+Nginix, Ruby + Puma or really anything the organization chooses. I have chosen Tomcat for this demonstration.
</li>
<li id="0340">
  1 Spark Streaming Job running continuously on the cluster every second.
</li>
<li id="d008">
  2 Spark batch jobs running every hour at different time intervals.
</li>
<li id="3468">
  Dashboard for reading the data served up by the Application Servers.
</li>

<div>
  <div>
  </div>
  
  <p>
    <img src="https://cdn-images-1.medium.com/max/800/1*xe8mlxFERpw3aB0V7DMW5A.png" alt="" width="522" height="421" data-image-id="1*xe8mlxFERpw3aB0V7DMW5A.png" data-width="652" data-height="526" /></div> 
    
    <p id="e168">
      <h4 id="3612">
        Schema
      </h4>
      
      <pre name="67b9"><strong>CREATE KEYSPACE lambda_plus WITH REPLICATION = 
{ ‘class’:’NetworkTopologyStrategy’, ‘Analytics’:3 }

</strong><strong>CREATE TABLE lambda_plus.records ( time_bucket ts,
 sensor_id int, data double, ts timestamp, primary key(
time_bucket, sensor_id));</strong><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;"> //populated by the Application Servers

</span><strong>CREATE TABLE lambda_plus.bucket_rollups 
</strong><strong>( time_bucket datetime, average_reading double, 
</strong><strong>max_reading double, min_reading double);</strong><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;"> 
</span><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">// populated by Spark Streaming and 
</span><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">//Spark Job and therefore populated every second
</span><strong>
CREATE TABLE lambda_plus.sensor_rollups (sensor_id, 
last_reading ts, average_reading double, max_reading double, 
min_reading double)</strong><span style="color: #222222; font-family: 'Courier 10 Pitch', Courier, monospace; line-height: 21px;">; 
// populated by Spark Job only and therefore
// stale for up to an hour</span></pre>
      
      <h3 id="c8f2">
        Application Components
      </h3>
      
      <h4 id="e7e8">
        Sensor Data Ingest
      </h4>
      
      <div>
        <div>
        </div>
        
        <p>
          <img src="https://cdn-images-1.medium.com/max/800/1*yY1iIpqPX7hkjt9TTri3fg.png" alt="" width="522" height="421" data-image-id="1*yY1iIpqPX7hkjt9TTri3fg.png" data-width="652" data-height="526" /></div> 
          
          <p id="79a1">
            Sensors themselves submit an HTTP request to the application servers which then perform 2 functions:
          </p>
          
          <ol>
            <li id="71bb">
              Submit a record to Kafka
            </li>
            <li id="6259">
              Submit a record directly into the lambda_plus.records table on a 100ms time bucket (failure handling for the 2 current writes is an exercise left to the reader and a paper in and of itself) to Cassandra.
            </li>
          </ol>
          
          <h4 id="15c0">
            Spark Streaming Job
          </h4>
          
          <div>
            <div>
            </div>
            
            <p>
              <img src="https://cdn-images-1.medium.com/max/800/1*lkolmQyy98CfXnigaPDetw.png" alt="" width="522" height="262" data-image-id="1*lkolmQyy98CfXnigaPDetw.png" data-width="652" data-height="328" /></div> 
              
              <p id="379e">
                A Spark Streaming job will be running on the cluster every second. This will take messages from Kafka and aggregate the results and flush them to the lambda_plus.bucket_rollups table.
              </p>
              
              <h4 id="5e53">
                Spark Batch Job — Bucket Rollups
              </h4>
              
              <div>
                <div>
                </div>
                
                <p>
                  <img src="https://cdn-images-1.medium.com/max/800/1*8b6enOOQRDtjV0qSfHLoMA.png" alt="" width="534" height="268" data-image-id="1*8b6enOOQRDtjV0qSfHLoMA.png" data-width="668" data-height="335" /></div> 
                  
                  <p id="d47f">
                    This will operate on every data row older than 5 minutes in the lambda_plus.records table (This is to allow for time series buckets to be totally complete and all retries to have been already sent by sensor data.). The role of this job is to correct any errors in the Spark Streaming Job that may have occurred due to message loss.
                  </p>
                  
                  <h4 id="7ce4">
                    Spark Batch Job — Sensor Rollups
                  </h4>
                  
                  <p id="3c6e">
                    <div>
                      <div>
                      </div>
                      
                      <p>
                        <img src="https://cdn-images-1.medium.com/max/800/1*2-TippWpPDgfaZt3-IlEIw.png" alt="" width="534" height="268" data-image-id="1*2-TippWpPDgfaZt3-IlEIw.png" data-width="668" data-height="335" /></div> 
                        
                        <p id="6fcd">
                          This will operate on every data row older than 5 minutes in the lambda_plus.records table (This is to allow for time series buckets to be totally complete and all retries to have been already sent by sensor data.). This will take each sensor found and aggregate the results in lambda_plus.sensor_rollups. <strong>You’ll note this is not filled by the Spark Streaming Job as it would require a historical lookup</strong>, while this can be doable it can be expensive if there is a lot of historical data and may not be efficient. This is a classic design tradeoff, and one must decide how important really fresh data is.
                        </p>
                        
                        <h4 id="35a0">
                          Dashboard
                        </h4>
                        
                        <p id="e982">
                          The application servers driving the dashboard will be able to use pure CQL queries to get up to the second data for bucket rollups and 1 hour delayed data for sensor rollups. This provides low latency and high throughput for answering queries. Our dashboard is using Cassandra in the optimal fashion.
                        </p>
                        
                        <h3 id="f09c">
                          Lambda Architecture compared
                        </h3>
                        
                        <p id="e92d">
                          <h4 id="4b45">
                            Speed Layer
                          </h4>
                          
                          <p id="77d8">
                            Identical between this architecture and Lambda. A lot of customers will use Spark and Cassandra for the traditional Speed Layer.
                          </p>
                          
                          <h4 id="a385">
                            Batch Layer
                          </h4>
                          
                          <p id="c21e">
                            Instead of writing to a separate database our Batch Layer will write directly to the same Speed Layer tables that are then served up by Cassandra. Contrast this with the traditional Lambda Architecture where the Batch Layer is using a different code base and a different database than the Speed Layer, I think you’ll agree the Lambda+ approach is much simpler.
                          </p>
                          
                          <h4 id="c9e0">
                            Serving Layer
                          </h4>
                          
                          <p id="33a8">
                            Can all be done out of Cassandra, instead of out of a Batch Layer database. This provides operational simplicity over the traditional Lambda Architecture and not only results in less servers but in less code complexity.
                          </p>
                          
                          <h3 id="134d">
                            Conclusion
                          </h3>
                          
                          <p id="20df">
                            This approach will not only scale as you add more nodes and more data, it will allow you the best of several approaches at once and with the operational simplicity of a single data store.
                          </p>