---
id: 17
title: 'A Discussion on Domain Driven Design: Entities'
date: 2007-04-15T02:43:39+00:00
author: Joe Ocampo
layout: post
guid: /blogs/joe_ocampo/archive/2007/04/14/a-discussion-on-domain-driven-design-entities.aspx
dsq_thread_id:
  - "262088529"
categories:
  - Domain Driven Design (DDD)
---
My last post was intended to help better explain how the [ubiquitous language](http://www.lostechies.com/blogs/joe_ocampo/archive/2007/04/02/a-discussion-on-domain-driven-design.aspx) forms the back bone of Domain Driven Design (DDD). I am hoping that this post helps to explain some of the more foundational artifacts of DDD, namely Entities.

What is an entity? Is it a business object? Is it a class that has persistence? Is it a sentient being manifested in the form of a polymorphic construct that is based on a real world object? Ok well maybe the latter is definitely out of scope but as we see there are many possibilities of what an entity is. Hopefully I will help to shed some light on the subject. Either that or I will help to perpetuate the existing confusion. At least we go somewhere!

Let me first start off by what I believe a domain entity is NOT. A domain entity is not a business object! Why do I say this because the term business object has been bastardized to mean all sorts of stupid meanings in the last 10 years! We have presentation tier elements such as a customer form (aren’t forms objects?? Ugggh) being called business objects because they save and update the database from the customer form. We have actual classes that claim to be business objects then get overweighed by the sheer volume of methods and fields on them. Anyone heard of composition? Not to mention they tend to violate Single Responsibility Principle ([SRP](http://www.objectmentor.com/resources/articles/srp.pdf)) all time. These business objects take on the responsibility of knowing how to persist themselves (CSLA) and how to validate themselves even in some cases how to code themselves. Now I am sure there are rare circumstances and I use the term rare with tongue and cheek, that these architectural concepts can be utilized. But the point I am trying to make is that entities are not business objects they are domain entities.

My understanding of Domain Driven Design is rooted from Evans book, who I believe has written one of the best books on software analysis and design ever. A bold statement but none the less an accurate one at that.

Before I go any further I have to give you some history about why I believe DDD works. It works because I have used it. And I am not talking about a small little shopping cart project. I am talking big enterprise level project with a staff of 10 business analyst, 7 systems analyst and 15 developers! Communication is essential when working with a team this large. DDD came in to save the project countless times especially during our planning and modeling iterations. The concepts while foreign to some bridged the gap between the severally non-technical and the technical camps. Needless to say the project was on time and on budget.

If you are a developer take a moment to stop thinking about your code, stop thinking about the database or whatever persistence mechanism you use. If you are an analysts stop thinking about your requirements, or design documents. When you are practicing DDD, a paralleling factor to the ubiquitous language, rest in Model-Driven Development. Model driven development along with the dialog of the ubiquitous language, form the heart of the domain model. Without these two concepts the architecture of the solution to the domain model will be difficult to convey and later maintain.

Let’s take a moment and look at the following sentence in more detail.

> _“Model driven development along with the dialog of the ubiquitous language, form the heart of the domain model.”_

Do you notice the word “dialog”? I can’t stress enough on the importance of this concept of dialog. It is the key word that will help in better understanding entities and other DDD concepts. So let’s get into some dialog.

I would like to thank a fellow Los Techie [Joshua Lockwood](http://www.lostechies.com/blogs/joshua_lockwood) for inspiring me to come up with this scenario.

Consider your wallet? How do you know your wallet is yours? Don’t open it up yet. Does it have a certain look to it? Does it have obvious tear or scratch in a certain location? Does it have a distinct odor that only you can smell (if it does that pretty gross dude). The fact of the matter is you know it is your wallet.

When I go home at night I usually place my wallet on my nightstand. In the morning when I am about to go out the door I sometimes forget my wallet and ask my son to go and get it. He usually asks me where it is and I always tell him “Where it usually is.” What happens next is magical. Why is this magical, because my wallet is not the only artifact on my nightstand? There are several books, a clock, and a lamp and sometimes my wife puts her purse there. But somehow my son was able to retrieve my wallet because I had showed him early on how to indentify Daddy’s Wallet.

> _&#8220;An object defined primarily by its identity is called an ENTITY.&#8221; [Evans 2003]_

So what is my wallets identity? Well that depends on the context. Consider the manufacture of the wallet. We can assume that the manufacturer didn’t care about the individual wallet as much as they did the box of wallets that was shipped to the department store. All the manufacture cared about is that box 24A1 contains 24 wallets of style 6789G. The department store took the box and insured it had 24 wallets and added 24 wallets style 6789G to their inventory. The store clerk then took the box to the front of the store and unpackaged each wallet onto a shelf for purchasing. My son, having only 10 dollars to his name purchased a wallet style 6789G from this store to give to me on Father’s day. On Father’s day I opened this magnificent gift and at that point it was my wallet.

Taking a cue from the film, Full Metal Jacket; “This is my wallet, there are many like it but this one is mine.” When I ask my son to retrieve my wallet I don’t ask him to retrieve the wallet on my nightstand with the tag on the inside marked style 6789G. I ask him to retrieve my wallet based on the identity I have given it. In my case it is torn in the middle and resembles a worn out paper bag. Think [Costanza](http://www.urbandictionary.com/define.php?term=george+costanza's+wallet) wallet. The identities in this case are attributes such as color, shape, size, wear. Almost all the developers immediately thought of, “oh easy this is a composite key based on…” You missed the point! The point is listening to what identity means to the customer. Not what it means to a relational database or whatever persistence mechanism you are using. In most real world scenarios of course it will be something as simple as an Order Number but don’t always look for the obvious. Look at what identity means to the customer. Entities mean something to the customer. They care about them. They want to know what happens to them. They want to know when something changes about them. They want to know when Mommy takes the credit card out of them.

So let’s take this a little further because like I mentioned above identity isn’t the only characteristic that distinguishes an entity from other objects in the system. They also have life cycles. Just like any other lifecycle, it’s all about birth, change and death after all it is an entity.

Going back to my wallet example, lets for a moment consider when I first took it out of its package. It literally came out of a factory in an instantiated state. It didn’t contain anything but it had a lot of potential. It had a pocket for money several smaller pockets for credit cards and a special mini foldout to place my ID. I immediately transferred all the contents of my old wallet over to my new one. Has the state of my wallet changed? Yes, it has, it went from something fresh out of a package to containing new information it didn’t have before. Now I must persist its state. OK here is where my wallet analogy takes a nose dive! Let’s pretend that in order for my wallet to make it to my nightstand it has to go through my wife. I like that. Who better to persist the wallet once it leaves my hand. OK work with me here. She takes the wallet insures that none of credit cards are missing and that her picture is still the first one on the stack. Then she persist the wallet to the nightstand or whatever other container she would like to place it in. At this point I don’t care because when I wake up in the morning I am going to ask the Wife Repository service to retrieve my wallet and I expect it come back the same way I gave it to her.

Let’s recap what just happened:

  1. Wallet was created at the factory
  2. Took it out of the package and I now have a NEW wallet
  3. Populated the wallets pockets with my old wallet’s contents (transient)
  4. Saved the state of the wallet to the wife repository
  5. Praying that when I ask the wife repository for the wallet that it will come back in its original state.

> _An ENTITY is anything that has continuity through a life cycle and distinctions independent of attributes that are important to the application&#8217;s user. [Evans 2003]_

I am going to touch on value objects real quick just so you can understand the difference between entities and value objects. Let’s say my wallet contained 1 five dollar bill and 3 one dollar bills, resulting in a total of 8 dollars. Now we all know that all US currency have a unique ID assigned to them. Is that important to me? Do I really care where it was minted or what hands in went through. NO, I just care that it holds its value and it is in my wallet. So when I add money to the wallet it can add money to the pocket container and increment the value. This is the aggregate pattern that we will talk about on a later post. Back to the wallet, since I don’t care about the identity of the money in relation to the wallet, the money is a value object. I will never ask the wife repository for the one dollar bill with the serial number 1A66784GHII7888 to be placed in my wallet. Identity means nothing to me about the money, only its value! In fact let’s say that the wife repository needed a five dollar bill in exchange for 5 one dollar bills. When I ask for the wallet back in the morning it still contains eight dollars but in a slightly different state. (If this were an application I would hope the service would audit the change)

[![](http://lostechies.com/joeocampo/files/2011/03/DomainDrivenDesignEntities_94AB/image0_thumb7.png)](http://lostechies.com/joeocampo/files/2011/03/DomainDrivenDesignEntities_94AB/image09.png)

I have to find a way to shorten these posts. I never intend for them to be this long but I tend to be rather long winded when I discuss these concepts. My next post with touch a little more on <a href="http://www.lostechies.com/blogs/joe_ocampo/archive/2007/04/23/a-discussion-on-domain-driven-design-value-objects.aspx" target="_blank">Value Objects</a>.