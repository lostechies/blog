---
wordpress_id: 284
title: Validation in a DDD world
date: 2009-02-15T23:31:16+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2009/02/15/validation-in-a-ddd-world.aspx
dsq_thread_id:
  - "264716071"
categories:
  - DomainDrivenDesign
---
It’s a common question, “Where do I put validation?”&#160; Simple answer: put it where it’s needed.

But it’s not just a question of “where”, but of “when”, “what” and “why”.&#160; If we treat our entities as data holders, we might think to put all of our validation there, in the form of reactive validation, where the entity is allowed to be put into an “invalid” state.

Validation depends completely on the context of the operation you’re trying to perform.&#160; If we start looking at command/query separation and closure of operations not only on our service objects but our entities as well, we can treat our entities with a little more respect and not drag them around into areas they don’t really belong.&#160; Simply put, if we control the operation side of the equation, why in the world would we allow our entities to get into an invalid state?&#160; Life becomes _much_ more complicated if we start having “IsValid” properties on our entities.

Think about that question, “is this entity valid”.&#160; You can’t answer that question unless you know the context for validation.&#160; Are you validating for persistence?&#160; For changing an attribute?&#160; For changing state (in the state pattern)?&#160; For ETL?

In our current application, we have _at least_ 3 different well-known locations for validation:

  * On our messages
  * In a command object
  * In our entities, for ETL scenarios

For about 5 seconds we considered trying to combine all of this validation into one grand uber-validator rules engine.&#160; Ha. ha. ha.

### Worst-case scenario

In the absolute worst case, we would have validation on our entities.&#160; Something like an “IsValid” property or a “Validate” method.&#160; Because we need to make judgment calls on what you’re trying to validate, things can get messy.&#160; If all of your validation is on your entity, why are you even doing the Domain Model pattern in the first place?&#160; Validation directly on entities is more suited for CRUD-y applications, where patterns like Active Record are more appropriate.

If you let your entities become invalid, you’ve most likely lost the context of what operation was being performed on the entity on the first place.&#160; An entity may change state for a wide variety of reasons for a wide variety of operations, so certain attributes may be valid in one operation and invalid in the next.

Imagine an Order class that has several valid states, New, Confirmed, Placed and so on.&#160; Often, we’ll place certain validation in the context of state changes, such as when an order is New versus moved from New to Confirmed.

Suppose we want to require a PhoneNumber for New orders.&#160; But someone comes in that literally does not have a PhoneNumber, which our sales rep confirms through an email.&#160; The Confirmed Orders are therefore allowed to have a blank PhoneNumber.&#160; Are we supposed to capture all of this in a single Validate method?&#160; I certainly hope not.

If you _have_ to put validation on an entity, make sure you capture the context of what the operation the validation is operating against, likely in the name of the method.&#160; For loading or ETL scenarios, I could imagine an IValidateForLoading interface that entities could opt-in to, just in the case where we don’t have control over hydrating the entity from bad data.

### Thinking operationally

Instead of thinking of changing state on an entity, we need to move up to a higher level of command/query separation, where we perform and execute commands on one or many entities.&#160; Am I performing validation, or reporting the result of an operation?&#160; Lately, I’ve tended to go with the latter.

In that case, validation can take many forms.&#160; I can use Castle Validators on my message object, to ensure that certain fields are required, this date can’t be in the future, and so on.&#160; In my Command object, I’ll do further business rule validation, where I might need to coordinate between several different entities to determine if this operation can be performed successfully.

And that’s where I think we should move towards in terms of validation.&#160; Instead of answering the question, “is this object valid”, try and answer the question, “**Can this operation be performed?”**.

Because our command objects know answers to all of the “Who, what, why” questions, they are in the best position to perform contextual validation based on the operation the user is trying to execute.

Validation doesn’t belong in one place, nor should they be constrained to one technology.&#160; Validation belongs as close to the operation being performed as possible, to minimize risk of contaminating our entities with bad data or blurring its cohesion.

### Summing it up

If I could look back at one thing that improved my take on validation the most, it’s adherence to a closure of operations.&#160; I’d encourage you to go back to those sections on command/query separation and closure of operations in the [Big Blue Book](http://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215).&#160; Once I adhered to those two concepts, validation was merely another step in reporting the success or failure of an operation, and like many good simplifications, a host of symptoms I mistook for separate diseases just went away.