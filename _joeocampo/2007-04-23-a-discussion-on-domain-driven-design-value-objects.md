---
wordpress_id: 21
title: 'A Discussion on Domain Driven Design: Value Objects'
date: 2007-04-23T04:00:18+00:00
author: Joe Ocampo
layout: post
wordpress_guid: /blogs/joe_ocampo/archive/2007/04/23/a-discussion-on-domain-driven-design-value-objects.aspx
dsq_thread_id:
  - "262090134"
categories:
  - Domain Driven Design (DDD)
---
&nbsp;

In my previous post we talked about <a href="http://www.lostechies.com/blogs/joe_ocampo/archive/2007/04/14/a-discussion-on-domain-driven-design-entities.aspx" target="_blank">Entities</a>. Entities have a lot of overhead associated with them. They have a full lifecycle from cradle to grave. They also have identity which forces the domain model to be very expressive in tracking and coordinating their transient states. It would be great if we could compositionally break up the Entity into smaller objects that form descriptive attributes of the Entity itself but don’t have identity. Luckily for us these sometimes smaller objects are referred to as Value Objects in Domain Driven Design.

> **_NOTE: It is important not to confuse a Value Object with a CLR value type. Value Objects are unaware of the actual programming language. They are high level modeling concepts that lend themselves to elucidating greater incite of the Domain Model. Don’t assume that an int, string or double are Value Objects._**

Take a look around you I bet you have a container of pens or pencils all with varying tips and colors. You have a pack of gum nearby filled with individual pieces of gum. Looking in your desk you have a container of paper clips of varying size and shape. If you are wearing a pair of sneakers hopefully you have a pair of shoe laces. Let’s consider your wallet, I bet you have currency of some kind in there with varying denominations of value. In the world of DDD we refer to all these objects as Value Objects. Why because we don’t care about the identity of these objects in the context of day to day activities. We don’t care about each individual paperclip when you need to hold papers together, we just care that there are paper clips. When I put on my Nike’s I don’t care about the shoe laces outside of the context of the shoes themselves. If the laces wear out, I simply replace them with new laces not once giving any consideration to the old laces. I don’t look at the old shoe laces, look up their model number and try to find the exact same model number manufactured from the Nike factory.

If I had to give you one rule of a Value Object vs. an Entity it would simply be this.

> &#8220;A Value Object cannot live on its own without an Entity.&#8221;

But I think Eric Evans does a better job at describing Value Objects.

> “An object that represents a descriptive aspect of the domain with no conceptual identity is called a VALUE OBJECT. VALUE OBJECTS are instantiated to represent elements of the design that we care about only for what they are, not who or which they are.” [Evans 2003]

I am going to ask you again to hang up your developer or analyst hat and simply read what I am about to write. Try not to apply any pre-dispositional ideas that you have gained through experience. Don’t apply what you do at work. Work with me here!

My son’s name is Jay. Jay is 10 years old and goes to school. I really care about Jay, I want to make sure he is safe and I need to know his whereabouts at all times. When I wake up Jay in the morning, he knows that I expect him to brush his teeth, comb his hair and put on his clothes for school. Being a Dad I don’t really care what type of clothes he wears, just as long as they are appropriate for school. So Jay has to make sure he is wearing a tee-shirt, pants and shoes. Let’s stop right here. Let’s model this scenario in a Domain Model.

<img src="http://lostechies.com/joeocampo/files/2011/03/ADiscussiononDomainDrivenDesignValueObje_1C47/clip_image002.jpg" alt="" width="106" height="168" />

As you can see the Jay Entity mimics the structure that we described above. But let’s talk a little bit about what Jay means to me. Jay has hair and teeth, which is what Jay is to me. His tee shirt, pants and shoes are important to me but they are not Jay. How can we make the model more expressive yet take the attributes of shirt, pants and shoes and still have meaning to me? How about the following model?

<img src="http://lostechies.com/joeocampo/files/2011/03/ADiscussiononDomainDrivenDesignValueObje_1C47/clip_image004.jpg" alt="" width="299" height="158" />

As you can see I went ahead a created the Attire type. The model is still contains enough information that I have not lost the expressive whole of the Jay Entity having a Tee-Shirt, Pants and Shoes. Since I have taken this path, I have allowed the Jay Entity to have a simpler compositional structure within the domain model. Now if you were paying attention you noticed that I gave Jay an SSN. After all doesn’t he have one? Isn’t this how I could distinguish Jay from other sons or daughters I may have? NO!!! Remember Jay is an Entity and Entities have identity. How do they have identity? They have identity based on the context of the domain model not what the developer or analyst deems necessary to distinguish Jay from the rest of my family. In your family do you call you son, daughter or brother, by saying “Son 000-52-9899 please pick up the trash.” No you simple say “Jay can you please pick up the trash.” So within the domain of my family what makes Jay unique? Within my family how can I guarantee that when I call for him, he will come? I hope you guessed that his _name_ is his identity. Yes it is that simple, his name. Remember <a href="http://en.wikipedia.org/wiki/You_Ain't_Gonna_Need_It" target="_blank">YAGNI</a>, well that applies in domain modeling as well don’t complicate the model by coming up with attributes that mean something to the developers but nothing to the customer. So for the sake of time I am going to speed up the modeling here to show you more of my family domain.

<img src="http://lostechies.com/joeocampo/files/2011/03/ADiscussiononDomainDrivenDesignValueObje_1C47/clip_image006.jpg" alt="" width="313" height="155" />

So here is a more refined model. Talking to myself I discovered that I also have a daughter. So the Jay type didn’t give me near the flexibility that I needed. Now I have and general Kid Entity that I can use for either my son or daughter. I digress, going back to Value Objects. Here is a general question you can ask yourself when you are evaluating your model. &#8220;Can the Attire type exist without the Kid type in the given context of the domain?&#8221; Meaning from an architectural stand point are you ever going to ask the attire, “Who do you belong to?” Maybe in some other context you could, say for instance a dry cleaning application. Yes I would have to agree that the Attire type, such as a suite, may exist on its own and have its own ID. Then I would have to use the Attire type to figure out what customer it belonged too. But in the family context, No! The Attire cannot exist on its own. It is a Value object of the Kid Entity. In fact in order for me to access the Attire or change anything on the Attire I should have to go through the Kid. This concept of ownership and responsibility is called an Aggregate in DDD. We will talk about that on a later post.

As you can see Value Objects are simple in nature but for a reason that still eludes me, are a difficult concept to master in practice. Entities and Value Objects work in tandem to produce a very fluid model. Please don’t get discouraged if you have hard time figuring out what is what. Remember to take a step back and stop thinking like a developer. Talk through the model as if you were the product owner. Usually the Entities and Value Objects pop right out when you do this. Question yourself, “Does this object need identity outside of this object?” “Can I simplify this object by creating a Value Object?” When you answer these questions make sure to put the model in front of the product owner so that they may validate your refactoring. Your model is the code, your code is the model, never forget that. The two must grow organically together and still capture the business domain from the product owner’s perspective. But what if I have an object that isn’t an Entity or a Value object, well this friend is my next post. Services…