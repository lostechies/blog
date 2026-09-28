---
wordpress_id: 18
title: 'Kanban &#8211; Pulling Value From The Supplier'
date: 2008-11-20T21:03:08+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2008/11/20/kanban-pulling-value-from-the-supplier.aspx
dsq_thread_id:
  - "262067936"
categories:
  - Agile
  - Kanban
  - Lean Systems
  - Management
redirect_from: "/blogs/derickbailey/archive/2008/11/20/kanban-pulling-value-from-the-supplier.aspx/"
---
Before I start talking about how our team is going about our implementations of <a href="http://en.wikipedia.org/wiki/Lean_Systems" target="_blank">Lean</a> and Kanban, I wanted to start by outlining my current understanding of what kanban is. I&#8217;m hoping that this will set the ground work for the rest of my <a href="https://lostechies.com/blogs/derickbailey/archive/2008/11/19/adventures-in-lean.aspx" target="_blank">Adventures in Lean</a> series, and implementing <a href="http://leansoftwareengineering.com/ksse/scrum-ban/" target="_blank">Kanban in a Scrum shop</a>.

### Groceries, On And Off The Shelf

The next time you&#8217;re in a grocery store looking at a shelf stocked full of products, take note of the little stickers that adorn the shelf just below where the product is placed. This sticker is usually crammed full of information &#8211; some of it useful to you, the consumer, and some of it not useful to you. So why is all of that information there? Who is getting any value out of that information? The answer is surprisingly simple &#8211; the people that stock the shelves. When the supply of good on the shelf is running low or is empty the information on those stickers tells the stock-persons what to put back on that shelf. This person is then able to create a pick-list of goods to retrieve from the back of the store so that they can restock the shelves. 

Now consider an extended example of more than just the grocery store. When you, the consumer, take an item off the shelf, you have created room for one more item to be placed on the shelf. The stock-person sees the sticker in that space, goes to the back of the store to retrieve the item and places it on the shelf where the space is. At this point, there is another person paying attention to how much is actually in storage in the back of the store. When the stock-person grabs an item from the back of the store, the back-room person sees that space and determines whether or not they need to order more of those items from the warehouse. When the back-room person orders items from the warehouse, the warehouse workers check to see if they need order more of those items from the supplier. When the warehouse orders those items from the supplier, the supplier checks to see if &#8230; and on and on until we finally get to the point where the products are being made &#8211; the manufacturer or farm or whatever the ultimate source of supply actually is.

### What Is Kanban?

This simple act of seeing that a space on a shelf needs to be filled, and filling it, is the core of what kanban is. Quite literally, a kanban is a sign or signal. In more conventional terms, though, it is a sign for action that must be taken to replenish the empty slots on the shelf of the grocery store, the back room, the warehouse, etc. 

From <a href="http://en.wikipedia.org/wiki/Kanban" target="_blank">Wikipedia</a>:

> _&#8220;The Japanese word kanban (pronounced_ [_[kambaɴ]_](http://en.wikipedia.org/wiki/Help:IPA)_) is a common everyday term meaning &#8220;_[_signboard_](http://en.wikipedia.org/wiki/Signboard)_&#8221; or &#8220;_[_billboard_](http://en.wikipedia.org/wiki/Billboard_%28advertising%29)_&#8221; and utterly lacks the specialized meaning that this_ [_loanword_](http://en.wikipedia.org/wiki/Loanword) _has acquired in English. According to_ [_Taiichi Ohno_](http://en.wikipedia.org/wiki/Taiichi_Ohno)_, the man credited with developing JIT, kanban is a means through which JIT is achieved.&#8221;_

When a consumer takes an item off the shelf, the process of pulling products &#8211; pulling value, really &#8211; from the upstream suppliers begins. It&#8217;s the pull of kanban that makes it such a powerful system. We let the customer pull the items they want which drives the rest of the pull system. If no one takes the item off the shelf, there is no need for the stock-person to put another item on the shelf, and no need for the store to order more from the warehouse, etc. Think of it as a form of <a href="http://en.wikipedia.org/wiki/Demand_and_supply" target="_blank">Demand-And-Supply</a> instead of <a href="http://en.wikipedia.org/wiki/Supply_and_demand" target="_blank">Supply-And-Demand</a>. The customer demands a product, the grocery store supplies it. The store demands the product, the warehouse supplies it, and on and on up the stream.

### What Is An Order Point?

When a space is empty on a shelf, a stock-person may not immediately fill it. In fact, the stock person may wait until there are several spaces on that part of the shelf before filling them. On this shelf, the maximum number of empty spaces allowed is the order point. For example, if the shelf has three empty spaces and the order point is set at three, the stock-person knows that they need to replace the items on the shelf soon. If the number of empty spaces goes up to four, the stock-person knows that they need to replace the items on the shelf now.

Order points can be specified in a few basic ways:

  * Maximum number of empty spaces needing to be filled
  * or Minimum number of products on the shelf

I&#8217;m sure there are other ways, as well. These are the two that I&#8217;ve seen the most often, though.

Each area of the grocery store is going to have it&#8217;s own set of order points. The shelves that consumers pull from will probably have a very low order point &#8211; may two or three items missing. The storage area of the store will probably have a larger order point &#8211; two or three cases missing. On up the supply stream, the warehouse may have a larger order point of two or three pallets, and on and up the stream the order point may grow larger. 

In the grocery store, the kanbans that adorn the shelves often have the order point printed directly on them. This gives a stock-person the knowledge they need, when they need it, and prevents them from having to remember the order points for all the products in the store.

### What Is A Stock Limit?

When a shelf at the grocery store is full of products &#8211; there is no space left to put anything else &#8211; that shelf is full. However, the individual products on that shelf may not be at their stock limit. A stock limit is the maximum number of a given item that can be stocked at a given time &#8211; wether that stock is on the shelf or is in the storage area of the store, or wherever it is. If a shelf has a stock limit of five, for a given product, then there should be no more than five of that product on the shelf. Both the shelf and storage area have their own stock limits. It&#8217;s these stock limits that prevent the store from being overrun with too many of one product, and not enough of another product.&nbsp; 

Like order points, the kanbans that adorn grocery store shelves often have the stock limit printed directly on them. This tells the stock-person when to stop putting items on the shelf without them having to remember the limits for all the products in the store.

### How Does This Apply To Software?

I&#8217;m not going to give away the farm just yet. Moving forward, though, I will be using the terms Kanban, Order Point, and Stock Limit (or just Limit). I wanted to get these core terms defined up front, so that they will make sense in the context of what is still to come.

Stay tuned for the next entry in my <a href="https://lostechies.com/blogs/derickbailey/archive/2008/11/19/adventures-in-lean.aspx" target="_blank">Adventures In Lean</a>!