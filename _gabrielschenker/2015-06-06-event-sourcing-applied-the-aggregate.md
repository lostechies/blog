---
id: 1028
title: 'Event Sourcing applied &#8211; the Aggregate'
date: 2015-06-06T08:55:57+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1028
dsq_thread_id:
  - "3826491823"
categories:
  - Uncategorized
---
> This is my 100th post &#8211; I have to open a good bottle of wine tonight!

In my last [post](https://lostechies.com/gabrielschenker/2015/05/26/event-sourcing-revisited/ "Event sourcing revisited") I was presenting my thoughts about event sourcing (ES) as an architectural pattern. In this post I want to show in more detail how ES can be implemented given a somewhat realistic business domain.

In ES we can look at a system and say that there are actions and every action causes a reaction. The action in this case can be implemented as commands and the reactions as events. This is just another naming which might help to make the concepts behind more transparent.

[<img class="alignnone size-full wp-image-1029" title="ActionReaction" src="https://lostechies.com/gabrielschenker/files/2015/05/ActionReaction.png" alt="" width="449" height="153" />](https://lostechies.com/gabrielschenker/files/2015/05/ActionReaction.png)

If the domain we&#8217;re working in is personal loans and we have a loan application in our domain then a possible command could be to &#8220;approve the application&#8221;. Consequently we might name the corresponding command **ApproveLoanApplication**. The name of the command is important

  * The name must be unambiguously describe the context and what should happen
  * The name is written in imperative to indicate that this is a request/command/order to a target.

Each command must have a target otherwise the whole story makes no sense. It is also important to note that we limit ourselves to commands that have **exactly one** target. In our case the target is obviously the loan application (aggregate).

What is now the reaction of the loan application aggregate to the command? For the given command the application would move to a(n) (internal) status equal to Approved. At the same time the aggregate triggers an event telling that it has been approved. We can name this event **LoanApplicationApproved**. Notice that the name of the event is important .

  * The name must be unambiguously describe the context and what has happened
  * The name is written in past tense to indicate that the event is actually telling about something that has happened in the past (and thus cannot be undone or altered)

Another sample of command &#8211; event in the same context could be **SubmitApplication** and **ApplicationSubmitted**.

If we implement a Loan Application aggregate following this pattern then we could do this as follows

[gist id=9c82d252197bb7e89903]

Here we have implemented a method Approve which is called when the command **ApproveLoanApplication** is received. The method might do some interesting things (the code is omitted) apart from promoting its status to **Approved** and triggering/publishing an event **LoanApplicationApproved**. The aggregate does not care what happens with the event, it just triggers it. Someone or something else will take care of this event and handle or persist it. For the moment the aggregate will just put the event into a collection holding uncommitted events. The **Publish** method is simple and looks like this

[gist id=b55c0c5260549ca8bb7d]

The reason why we even care to store the current state internally is because we need the status for pre-condition checking. We only ever want to allow the aggregate to be approved if it is in status Submitted. If someone or something tries to approve a loan application that is not in status Submitted we want to throw an exception. Thus we have this code

[gist id=b44b9819e0bee8c8131f]

Throwing an exception might seem a bit rough to some of you but I like to apply the &#8220;fail fast&#8221; principle whenever a business rule is violated. In my applications I try to make sure that each command that I send to the domain for processing is highly likely to succeed. Thus such a violation of the rules should truly be an exception. [Other ways](https://lostechies.com/gabrielschenker/2015/05/07/ddd-special-scenarios-part-1/ "DDD – Special scenarios, part 1") of handling violations of business rules are of course possible. It is a matter of taste.

Once again I want to point out that when using ES as an architectural pattern it is very important to realize that we do not need to hold the full (current) state inside the aggregate. We only need to keep track of those properties that we need to either validate some pre- or post-conditions or to do some calculations. Everything else is available to us via the events that we are storing. Thus often complex aggregates have a very limited set of internal properties. This is contrary to the case where we do not use ES and thus have a state-ful system. In this latter case we need to keep track of every single property that can ever be changed.

## Re-hydrating an aggregate

How can we now load or as we&#8217;d rather say re-hydrate an existing aggregate instance from a stream of events that has been retrieved from storage? Let&#8217;s add a constructor to the aggregate which expects a stream of events, shall we

[gist id=29e0b533e3750a01fe25]

We can now loop over the collection of events and apply them to the aggregate, one after the other. Eventually, after we have applied all events the aggregate should be in the state it was after we did the last modification to it.

[gist id=86bd508cc94c305fffe1]

Now I do not want to have one big **Apply** method that does it all but I want to define a (private) method for each type of event I have which will contain the code necessary to update the state of the aggregate. To make things easy I introduce the convention that these methods shall always be called **When** and that they shall always have exactly one single parameter which is the respective event. Furthermore these methods are all **void** methods. Thus if I want to handle say the LoanApplicationApproved event then my When method looks like this

[gist id=b9fb7c1b256f96696e6c]

and if I want to handle the PersonalInfoSet event the method might look like this

[gist id=9bdbfd02082e6da24dda]

Since I have introduced the above convention I can now use some easy reflection to dispatch an event from the Apply method to the correct When method. I have the logic abstracted in a static class called **RedirectToWhen**. The implementation details of this class can be found [here](https://gist.github.com/gnschenker/c8e080608682986db7d1 "RedirectToWhen"). Now my Apply method looks like this

[gist id=a3b63b1b73a5f70a622b]

Note how I first increase the version of the aggregate and then use the method InvokeEventOptional to dispatch the event to the correct When method. As the method name <span style="line-height: 24px;">InvokeEventOptional</span><span style="line-height: 24px;"> </span>indicates we do not necessarily need to implement a When method for every event, but only for those that need to change the internal state of the aggregate. And as stated earlier when using event sourcing not everything needs to be kept in the state of the aggregate, thus this makes totally sense.

Now we have a small problem. When we look at the Approve method and at the When(LoanApplicationApproved e) method we can see that they contain duplicate code. Both manipulate the internal state. To keep things dry and with it avoid subtle errors we want to slightly refactor what we have so far

[gist id=58d2b36952ef6f275b7c]

Note how we have removed the state manipulating code from the **Approve** method. On the other hand the **Publish** method now calls the Apply method passing the current event. Consequently the manipulation of the aggregate&#8217;s state always only happens in the corresponding **When** method no matter whether the event has been generated as a reaction to a command or originates from the re-hydration of the aggregate instance.

Now the methods executed on behalf of a command &#8220;only contain&#8221; logic to check the pre-conditions, make sure that no business rules are violated and finally generate the event which is a reaction to the command and tells the interested observers that something has happened to the aggregate.

Once we have implemented the basics of this pattern we can now successively add more logic to our aggregate. Let&#8217;s look at a sample. The first command to start a new loan application shall require the email address, first and  last name to be passed to the aggregate. Furthermore we also expect a (new) unique ID to be provided that will uniquely identify this particular loan application. Let&#8217;s call the public method that will handle this Start.

[gist id=ff135a7e94a31f63a71b]

This method &#8220;only&#8221; checks the preconditions &#8211; in this case that a loan application cannot be started more than once &#8211; and then generates and publishes the event **LoanApplicationStarted**. We also have implemented a corresponding When method which updates the state of the aggregate. Here we only really care about the ID since we will need it moving forward. As long as we do not have an explicit need for email, first or last name we will not store it in the state. It is enough that the latter properties are present in the event. We also set the status to Started.

Who is now responsible to re-hydrate an aggregate and who will persist the newly generated events that the aggregate keeps ready in its _uncommittedEvents collection? It is NOT the aggregate itself. The aggregate is very self centric and doesn&#8217;t care about it&#8217;s environment. Someone else needs to take care about these matters. As we will see this is the so called application service which I will discuss in details in my next post. As it turns out each aggregate will be hosted by such an application service.