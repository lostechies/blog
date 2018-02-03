---
wordpress_id: 3873
title: Your nerd is showing
date: 2014-07-14T08:40:46+00:00
author: Sharon Cichelli
layout: post
wordpress_guid: http://lostechies.com/sharoncichelli/?p=262
dsq_thread_id:
  - "2842564255"
categories:
  - Uncategorized
---
My pharmacy upgraded their computer system. I can tell by the label on my most recent medicine bottle: the QR code is in a different spot, and the prescription identifier now sports a leading zero. (Only programmers think numbers can start with zeros.) The troubling thing, though, was the "Remaining Refills" part. Last month, I had "5" remaining; on this new label, "1.3."

I stopped in at the pharmacy to ask about it. The answer made me laugh. It was such a nerd answer, showing where developer decisions were leaking out into the real world. 

Any time I&#8217;ve tried to push a developer&#8217;s way of thinking onto the business, the result is a mess. True, the requirements they bring to us are often a mess, but getting non-developers to acknowledge the complexity and gaps in their request by drawing charts with boxes and cylinders makes for a tiring and fruitless day.

I&#8217;ll tell you about the (first) time I learned this lesson, by getting it quite wrong. I worked for a large manufacturer, building software to help buyers track and negotiate the costs of parts they were buying. Parts they buy directly are identified by a five-character part number. (As above, they&#8217;re surprisingly not interested in hearing that a number that contains letters is a string. Can&#8217;t imagine why not.) But they also negotiate the cost of components that manufacturers will use to build those parts. So one group is managing motherboards while another is negotiating for the CPU fans that go into those motherboards. (There&#8217;s also a line item for SLPs, which I learned stands for Sh&#8230;illy Little Parts. Screws and LEDs and stuff.)

Thinking database-y for a minute, imagine the rows in your NegotiatedCost table. For some of them, the value in the PartNumber column can be found in the Grand Uber Parts System of Our Fine Company. For others, that value is a part number our supplier uses to identify components in what they&#8217;re selling us. For yet others, it&#8217;s the part number the OEM uses to identify the part they&#8217;re selling to our suppliers.

PartNumber is a lousy primary key. But it becomes unique and usable if you also know whose part number it is. Part number + part-numbering system makes a composite key. (Psst. Please don&#8217;t tell me I should use a guid instead of a composite key. I still have to know in which system I&#8217;m looking up the part&#8217;s description.) What do you call that second column? It&#8217;s going to be seen by users, too. It&#8217;s not the same as the supplier of the part. Remember, the motherboard supplier is (indirectly) selling me the fan, using the fan manufacturer&#8217;s part number. How do I label the column that tells you whose part number it is?

Through a weird kind of linguistic inertia, "Whose Part Number" started to gain traction. (I&#8217;m sure this was totally my fault. I was young.) And because this was a Big Fancy Corporation, that got turned into an acronym, so the UI had a WPN column, which of course had no meaning at all to the users. Revel in my shame.

So what did the pharmacist say to me to explain the "1.3"? "Your doctor wrote the prescription for three months, but your insurance will pay for only one month at a time. So you have 1.3 three-month refills remaining." In other words, one-and-a-third calendar quarters = the 4 months I was expecting.

Does your system have any "1.3 three-month refills" in it?