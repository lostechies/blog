---
id: 217
title: Data Density! Destroyer of Scalability
date: 2015-09-17T12:42:10+00:00
author: Ryan Svihla
layout: post
guid: https://lostechies.com/ryansvihla/?p=217
dsq_thread_id:
  - "4139047161"
categories:
  - Cassandra
tags:
  - Cassandra
  - Sizing
---
<p id="3e0f">
  <em style="font-size: 16px;">UPDATE: I’d incorrectly attributed a practice to Netflix about scaling down daily . I cannot find any reference to using today, and I’ve been unable to find the previous reference to it. So I’ve just removed the point. I’ll cover cluster scaling strategies later in another blog post. TLDR smaller nodes are easier to scale.</em>
</p>

<p id="6852">
  My past couple of years I’ve seen a growing and to my mind unfortunate trend towards ever larger Cassandra nodes running more expensive and more specialized hardware. Teams wanting 17TB nodes in a quest to get ever more data on a single unit (TLDR that rarely works). While wanting to lower one’s rack footprint sounds hyper appealing let me be the first to tell you, it comes at a great cost.
</p>

### The Tale of Two Cassandra Clusters {#a342}

#### Low Density Cluster {#f9f3}

<p id="5b90">
  Say 300 GBs per node, it has the following properties:
</p>

<li id="099a">
  Can be very affordable hardware which is easy to replace and procure. Say 4–8 cores, 16-32gb of ram (more if it’s cheap) and 1 single big ssd or 2 ssds in a raid 0
</li>
<li id="19fc">
  Can be very power efficient.
</li>
<li id="b35f">
  More easily can run in 1U rack units.
</li>
<li id="6c7c">
  Can be quickly scaled up and scaled down in a matter of hours, and by multiples. Because of the available overhead scaling down is not painful.
</li>
<li id="aff5">
  More of the dataset can fit into RAM.
</li>
<li id="e446">
  The cluster has more CPU and RAM per node.
</li>
<li id="0f69">
  Losing a node means little, the higher your node count the more readily you can lose hardware.
</li>
<li id="ee5c">
  With a smaller data set a higher node count is needed to get rack awareness and not have all your nodes literally sitting on one rack.
</li>

#### High Density Cluster {#5648}

<p id="b3e2">
  Say 17 TBs per node, it has the following properties:
</p>

<li id="4868">
  High end CPU 20+ cores, 256gb of ram or more, high end disk controllers w 10+ disks, probably all SSD, all enterprise grade.
</li>
<li id="be2d">
  Power hog.
</li>
<li id="1942">
  Very expensive to get stuffed into a small rack, will pay a premium for his.
</li>
<li id="d43f">
  <strong>Will take weeks to scale up, </strong>as bootstrapping individual nodes will take eons. Hard almost by design to scale down.
</li>
<li id="ba72">
  Unfortunately, again almost by design most of the dataset will not fit into RAM.
</li>
<li id="8360">
  You have relatively little horse power relative to data. This can be fine, but it does mean certain operations like repair will be agonizing.
</li>
<li id="e68b">
  Losing a node means you’re losing a large chunk of storage and capacity compared to an equivalent low density cluster. Your unit of work is basically bigger.
</li>
<li id="35de">
  You’ll often end up with small (5 node) clusters for a lot of use cases. This makes rack awareness impractical. In fact you may literally end up with all your nodes in a single rack and you’re one network switch away from being down.
</li>

### Cost Exercise {#c6de}

<p id="4a2a">
  Some of you maybe saying “our rack space is limited and expensive”. I’d suggest looking at platforms like Moonshot if that’s the case, though it’ll suffer from some of the same flaws as the dense cluster, it’s at least dense in a rack sense. But for most of you, you’ll enjoy many factors of cost savings in going with cheaper commodity hardware and get a better bang for your buck when it’s all said and done.
</p>

#### On Premise Scenario {#75ec}

<p id="5722">
  <p id="de89">
    This one actually happened to me and I was shocked at the cost increase.
  </p>
  
  <p id="d493">
    <strong>High Density 5tb per node</strong>
  </p>
  
  <ul>
    <li id="1238">
      70k per node (not a typo)
    </li>
    <li id="68b0">
      Node count — 5
    </li>
    <li id="7e2b">
      total cost = 70k * 5 = 350k
    </li>
  </ul>
  
  <p id="472c">
    <strong>Low Density 300gb per node</strong>
  </p>
  
  <ul>
    <li id="8197">
      2k per node
    </li>
    <li id="e632">
      Node count — 84
    </li>
    <li id="1e67">
      total cost = 2k * 84 = 168k
    </li>
  </ul>
  
  <p id="ad74">
    So I could even spring for double hardware or double node count or just pocket my savings to pay for more colo space. This gets more ridiculous when you start trying to push 17Tbs per node.
  </p>
  
  <h4 id="19d5">
    Cloud Scenario
  </h4>
  
  <p id="bd0e">
    Since the cloud eliminates lots of moving pieces lets use this.
  </p>
  
  <p id="e6b0">
    <strong>High Density Instance</strong>
  </p>
  
  <p id="98aa">
    i2.8xlarge — $6.82 an hour can get about 8*.8tb/2 or 3.2 GB density
  </p>
  
  <p id="fa6b">
    <strong>Low Density Instance</strong>
  </p>
  
  <p id="5287">
    m4.2xlarge — $0.504 an hour + EBS SSD storage (cheap but add a penny for sake of argument). say 300gb density.
  </p>
  
  <p id="b605">
    This ends up being a style choice. Amazon does this really well and you’re getting a good rate on both. The low density option is slightly cheaper if you never scale down and far better hardware for the cost, and the normal tradeoffs I mention above apply. I’ll also node the m4.2xlarge easily could go ‘denser’ I’ve just chosen not to here. One could even look into cheaper node options and see how they perform for your workload.
  </p>
  
  <h3 id="d698">
    Summary
  </h3>
  
  <p id="e61d">
    I hope this helps at least start a conversation about the tradeoffs of data density. I don’t pretend to know all the answers for every scenario, but I do think people have often failed to just run the most basic numbers.
  </p>
  
  <p id="8882">
    Often they believe the cheap hardware is too unreliable but in fact 18 more nodes is more redundant than any single node configuration and often half the cost.
  </p>
  
  <p id="45b3">
    So I suggest leveraging distributed architecture to it’s fullest and consider those smaller nodes with less data. The resulting agility in your ops will allow you to scale up and down with the day to day demands of your business, and allow you to optimize savings further possibly exceeding all savings in rack space with the high density approaches.
  </p>