---
id: 7
title: Entity Validation Ideation
date: 2009-02-15T04:33:00+00:00
author: Sean Biefeld
layout: post
guid: /blogs/seanbiefeld/archive/2009/02/14/entity-validation-ideation.aspx
dsq_thread_id:
  - "449608032"
categories:
  - Domain Driven Design
  - Entity Validation
---
### Issue at Hand:

I have been recently <a href="http://en.wikipedia.org/wiki/Sumo" target="_blank">sumo wrestling</a> with the idea of entity validation in my mind. So far, the validation problem, which is like, <a href="http://sbiefeld.com/Stuff/EHonda.png" target="_blank">E. Honda</a>, has the advantage over my mind which is currently like, <a href="http://sbiefeld.com/Stuff/ChunLi.png" target="_blank">Chun Li</a>. The worst thing is, all the other thoughts in my head are constantly struggling against my entity validation thoughts. As <a href="http://en.wikipedia.org/wiki/Homer_Simpson" target="_blank">Homer Simpson</a> says, &#8220;Every time I learn something new, it pushes some old stuff out of my brain&#8221;. Except for me E. Honda is doing his grab move, where he squeezes his opponent between his fat, and squeezing all of my current thoughts out of my brain. I don&#8217;t understand how sumo wrestling evolved as a sport, do they really have nothing to do in Japan. I bet it was the master creation of some drunken emperor. Umm, let&#8217;s see I want to watch two super fat dudes wearing nothing but a diaper try to knock each other out of circle with their bellies, muahahaha, they&#8217;ll be playing this sport for centuries!

### Ideation:

I have been pondering about the idea of validation. <a href="http://www.dictionary.com" target="_blank">Dictionary.com</a> says valid is: _&#8220;sound; just; well-founded, producing the desired result; effective&#8221;_. <a href="http://en.wiktionary.org" target="_blank">Wiktionary&#8217;s</a> valid definition in terms of logic is:_&#8220;A formula or system that evaluates to true regardless of the input values.&#8221;_ When we think of validation in a programmers state of mind, the definition of valid in the logical sense, seems to jive the best. If x == y then it is valid if x != y it is invalid.

Entity validation is determined by business rules and processes. It appears that there are two fundamental approaches to validation, proactive and reactive validation. 

#### Reactive Validation:

The most common way I have seen validation handled is the addition of an IsValid state to the entity. A good way of implementing this approach can be found in a <a href="http://grabbagoft.blogspot.com/2007/10/entity-validation-with-visitors-and.html" target="_blank">posting by Jimmy Bogard</a>. Whenever a business rule or process is broken the entity is no longer in a valid state. Then the user is informed of the problem in a different layer of the application. This form of validation is a very reactive way of handling validation. Meaning that it waits until something bad happens and then performs a function to cope with the contaminated actions. I don&#8217;t like this reactionary response, I would rather use something more preventative.

#### Proactive Validation:

What is valid validation? I wonder how many times I can use the word valid, or one of its etymological children in this post? What is a valid number of uses? I think the answer is <a href="http://en.wikipedia.org/wiki/42_(number)" target="_blank">42</a>.

So, is valid validation a proactive or reactive approach? I believe that proactive is always the best approach. My definition of proactive entity validation is never allowing an invalid entity to exist. This means removing the concept of an IsValid state on the entity. Once that is removed you don&#8217;t have to do an IsValid check everywhere in the application, which is my main gripe with the reactive solution. Is it valid for your domain to ever contain an entity in an invalid state, something about this scenario makes my skin crawl and stomach churn, or maybe it has to do with something I ate last night. Hmm, it was spicy so maybe. An invalid entity just seems like a bad idea, it is a treacherous force that will actively work against you like <a href="http://en.wikipedia.org/wiki/Saruman" target="_blank">Saruman&#8217;s</a> voice being cast across middle earth. I think being proactive is a much cleaner approach, and will cleanse your domain of IsValid checks. Wow, that is just a proof less rant.

Now the question is, what&#8217;s the best way to implement such a proactive solution? That&#8217;s the <a href="http://sbiefeld.com/Stuff/EHonda.png" target="_blank">E. Honda</a> I have been wrestling with. Let&#8217;s go over the broad definition of proactive entity validation. An entity cannot be created if it does not meet the business rules. Once we have a valid entity it cannot be modified unless the modifications satisfy the business rules. The stumbling block arises when your entity&#8217;s validity is based on a certain context. For example, it is valid to have a physicians drug order without a signature. When the process requires that the order to be sent to the pharmacy, the order is only valid when it has a signature. Ah, now the proactive solution becomes tricky because valid is defined by context. Following the proactive approach I could not create the entity without a signature, because it would be an entity in an invalid state. The only solution that I have thought of to this is having a drug order without the signature and a drug order request that inherits drug order and has the signature. The pharmacy then receives that drug order request with the signature on it.

### Outro:

I have not yet fully fleshed out the details of how exactly this would be implemented. I hope to hammer out a spike with a spiked drink. I do believe that using a proactive approach to entity validation falls more in line with domain driven design by having a tighter coupling to the business language. A drug order does not need a signature to exist. A drug order request with a signature fulfills the need of the drug order being sent to the pharmacy.

Be a proactionary and not a reactionary.