---
wordpress_id: 3152
title: Entities vs. Value Objects
date: 2007-11-29T01:54:08+00:00
author: Sean Chambers
layout: post
wordpress_guid: /blogs/sean_chambers/archive/2007/11/28/entities-vs-value-objects.aspx
dsq_thread_id:
  - "268123727"
categories:
  - Uncategorized
redirect_from: "/blogs/sean_chambers/archive/2007/11/28/entities-vs-value-objects.aspx/"
---
I haven&#8217;t done a post in quite awhile. I have been taking care of my newborn boy Aidan of just about 2 months and needless to say I greatly underestimated the amount of time and effort it takes in the first couple of months for a new parent. We love him all the same and are getting enough sleep to not keel over and die. That being said, I hope everyone can forgive my absence. 

I recently purchased <a href="http://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215/ref=pd_bbs_sr_1?ie=UTF8&s=books&qid=1196302523&sr=8-1" target="_blank">Domain Driven Design by Eric Evans</a> (I know, it took me this long to buy it) and have been working through the book finding that a lot of the ideas I have been practicing from reading <a href="http://www.amazon.com/Applying-Domain-Driven-Design-Patterns-Examples/dp/0321268202/ref=pd_bbs_sr_1?ie=UTF8&s=books&qid=1196304360&sr=8-1" target="_blank">Applying DDD and Patterns by Jimmy Nilsson</a>, but Eric&#8217;s book definitely lays down a much better foundation to work off and wrap your head around. In hindsight, at <a href="http://lostechies.com/blogs/joe_ocampo/" target="_blank">Joe Ocampo&#8217;s</a> recommendation I would urge anyone else looking at a DDD book to start with Eric&#8217;s and then read Jimmy&#8217;s. Jimmy&#8217;s book refers back to ALOT of the work outlined in Eric&#8217;s book. 

One of the topics I have spent the most time reading over was Entities and Value Objects. These are two very important and ideas in a rich Domain Model (not to forget Aggregates and Repositories of course) and have to be identified very explicitly in the model. I don&#8217;t mean to undermine any other topics in the book, but to just focus on these ideas for this post as I could write ALOT of posts of the knowledge I&#8217;ve absorbed thus far from Eric&#8217;s book. 

I have been hanging out on the <a href="http://tech.groups.yahoo.com/group/domaindrivendesign/" target="_blank">Yahoo DDD Group</a> for some time now. If any of of you are looking for great information from very knowledgeable people, then subscribe to the rss feed and hold onto your seat! Almost all of the posts on this group are gems in their own right. This leads me to my main point. 

I started on a new project recently and thought very hard about the Entities/Value Objects in the first refactoring of the Domain. It was about a &#8220;State&#8221; object. State as in Florida or California. I thought about it and said to myself, A State is very clearly a value object since it is immutable and I can pass it to around to other objects in the model. Then once I thought some more, I figured, well maybe it is an entity because each instance of a &#8220;State&#8221; is obviously unique because you can only have one Florida or one California. After thinking about it for awhile I posted a question on the Yahoo group and got an <a href="http://tech.groups.yahoo.com/group/domaindrivendesign/message/6290" target="_blank">amazing explanation from Daniel Gackle</a> and just had to share it with everyone at LosTechies. At the same time, I also went back and read <a href="http://www.lostechies.com/blogs/joe_ocampo/archive/2007/04/23/a-discussion-on-domain-driven-design-value-objects.aspx" target="_blank">Joe&#8217;s post</a> from a little while ago and understood much more coming back to it this time around. 

You can read the post for yourself but I will paraphrase here because I loved this example and gave me real good insight into the idea of Entities vs. Value Objects.&nbsp; 

Here is the example: Imagine a table in a classroom filled with a large number of unopened bottles of water. When the class starts, the teacher says, &#8220;Everyone please grab a bottle of water from the table&#8221;. Everyone goes to the table and grabs any bottle, not caring which one to grab since they are all unopened bottles of water, thus they are all the same thing. They have no individual identity. 

Now, the same scenario except this time the teacher opens one of the bottles and drinks from it and places it back on the table. When he tells everyone to get a bottle this time the students will get a SPECIFIC bottle. This is because the opened bottle now has an identity and no one wants to drink the teachers spit. Thus, now the bottles can be considered Entities because they identities have to be kept track of so we don&#8217;t get the one with spit. 

To add to this example let&#8217;s think that for some crazy reason, everyone does not care about the teachers spit in the water bottle. If no one cares about the teachers spit then the bottles are value objects again because the spit is outside of the scope of the domain model. 

So, to summarize Daniel&#8217;s response to my question. Look at the objects in the actual context of the domain. In my instance, I don&#8217;t really care if the state of Florida is passed between multiple users and there is no attributes in the Florida object that sets it apart from other Florida object. Therefore, the State class can be considered a Value Object. Now, the moment I want to keep track of which states have electronic voting machines, then the State class could become an Entity because there is clearly a specific identity and attributes that go along with it. 

I hope that wasn&#8217;t too confusing. I&#8217;m trying to present the idea in the way I understood it. Please do go read the whole thread though. There are other people that really add to the description and make the meaning much more thick then what I can present here. Good Luck!