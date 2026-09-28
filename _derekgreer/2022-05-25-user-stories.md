---
title: "User Stories"
date: 2022-05-25T13:00:00+00:00
author: Derek Greer
layout: post
---

The use of User Stories has become fairly commonplace in the software industry. First introduced as an agile requirements-gathering process by Extreme Programming, User Stories arguably owe their popularity most to the adoption of the Scrum framework for which User Stories have become the de facto expression of its prescribed backlog.

So what exactly is a User Story? Put simply, they are a light-weight approach to expressing the desired needs of a software system. The idea behind User Stories, which was introduced as simply "Stories" in the book _Extreme Programming Explained - Embrace Change_ by Kent Beck, was to move away from rigid requirements gathering processes in process, form, and nomenclature. Beck explained that the very word "requirement" was an inhibitor to embracing change because of its connotations of absolutism and permanence. At their inception, the intended form of stories was to create an index card containing a short title, simple description written in prose, and an estimation.

## The Three-Part Template

In the late 1990's, a software company named Connextra was an early adopter of Extreme Programming. In contrast to the distinct roles defined by the Scrum framework, XP doesn't prescribe any specific roles, but is intended to adapt to existing roles within an organization (e.g. project managers, product managers, executives, technical writers, developers, testers, designers, architects, etc.).

The origin of most of Connextra's stories were from members of their Marketing and Sales departments which wrote down a simple description of features they desired. This posed a problem for the development team, however, for when the time came to have a conversation about the feature, the development team often had difficulty locating the original stakeholder to begin the conversation. This led the team to formulate a 3-part template to help address friction resulting from ambiguous requirement sources. Their 3-part template is as follows:

```
	As a [type of user]
	I want to [do something]
	So that I can [get some benefit]
```

Ironically, while the 3-part template has become the defacto standard for authoring User Story descriptions, Scrum's "Product Owner" role, most often filled by product development specialists acting as customer proxies, along with the use of software agile-planning tools such as Confluence, Planview, Azure DevOps Boards, etc., which captures who created a given story, tends to greatly diminish the need from which the template originated. This template has since become quite the de facto standard in expressing User Story Descriptions. The irony is that many teams, in caro-cult fashion, often utilize the 3-part template where the original need to identify the author of the story to start the conversation no longer exists. Change has occurred, but because many didn't understand the underlying impetus for the 3-part template, they were incapable of _adapting_ to that change.

Jeff Patton writes the following concerning the prevalent use of the 3-part story template in his book "User Story Mapping":

> "... the template has become so ubiquitous, and so commonly taught, that there are those who believe that it's not a story if it's not written in that form. … All of this makes me sad. Because the real value of stories isn't what's written down on the card. It comes from what we learn when we tell the story."

Mike Cohn, author of many books on agile processes including "User Stories Applied" and "Agile Estimating and Planning" writes similarly:

> "Too often team members fall into a habit of beginning each user story with "As a user…" Sometimes this is the result of lazy thinking and the story writers need to better understand the product's users before writing so many "as a user…" stories."

Cohn's observations are spot on. In my experience, not only does this happen "too often", it's the rule, not the exception. It's really just human nature. The moment a process becomes formulaic, teams will begin to just go through the motions without engaging their minds. This can be good for manual tasks like brick-laying, or cleaning a house, but it is detrimental to processes intended to promote communication. Sadly, many teams spend an inordinate amount of time on the trappings of things like ensuring their requirements follow the 3-part story template rather than using the story as a tool for its original intent: A placeholder for a conversation.

## There and Back Again

While not explicitly stated, the original idea behind Stories in Extreme Programming was to facilitate a conversation, not to define an objective goal. The agile movement started as a way to address issues in the industry's largely failing attempts to apply manufacturing processes to software development. In particular, Stories were intended to address the underlying motivation for requirements (i.e. how teams determine what to build), not to themselves be requirements.

In many ways, today's User Stories have become the antithesis of what Kent Beck originally intended. Sadly, much of what is marketed as "agile" today has been corrupted by traditional-minded business analysts, product managers, and marketing agencies who never really understood the agile movement fully. User Stories have, to a large extent, become a casualty of these groups. We've gone from requirements to stories and back again. As described by Jeff Patton, _"Stories aren't a way to write better requirements, but a way to organize and have better conversations._"

## The Better Way

Ultimately, the question companies seek to answer is: How do we determine the features which provide the best ROI for the business? While it may seem counterintuitive to some, customers aren't generally the best source for determining what features to build. They can be _a_ source, but they aren't generally a team's best source. Customers are, however, the best source for determining how customers currently work, what problems they face, and what friction is involved in any current processes. Various analysis techniques can be used to solicit customer opinions on desired features, but it's best to rely upon such techniques merely as means to distill the problems currently faced by customers. From there, stories are best created with a simple title and a description of the customer's problem written in prose with the intent for the description to serve as a starting point for a conversation with the team.

The best way to determine what to build is as a member of a mature agile team. The operative word here is _mature_. What makes for a mature team is a Product Owner with a background in the problem domain space, a Team Coach with deep knowledge of agile and lean processes, and 3-5 cross-functional developers weighted toward senior experience who have gone through a forming, storming, norming, and performing phase.

User Stories shouldn't be feature requests, but rather a placeholder for a conversation. A conversation with whom? With your team. About what? About how to iteratively solve the problems you learned from customers in small steps with frequent feedback. Product Owners should not bring requirements to a development team. There's great power in collaboration. A smart team of 5 to 7 individuals including a subject matter expert (what the Product Owner should bring to the table) and a coach are a far better source for what features to build than just the customer or the Product Owner.

## An Example

The following is an example story which more closely follows the original intent of Stories.

Our scenario involves a company which provides a website allowing customers to create wedding and gift registries to send to others. In its current form, the site allows customers to pick from among existing vendors, but the company frequently receives requests from customers about specific products they'd like to see included. The current process involves the Sales team creating tickets for their Operations team to add new vendors to the site which involves updating the production database directly. Additionally, the work currently falls to one person whose job entails other operation tasks which often results in a delay to the timely fulfillment of customer requests.

The following represents the story:

<table style="border: 1px solid black; background-color: white; color: black">
<tr>
<td>
<h2>Easily Manage Registry Products</h2>
<hr style="border-top: 1px solid black"/>
<h3>Description</h3>
Our customers often want to add products that aren't part of our current vendor product list.  This causes the sales team to constantly have to put in tickets and currently Margret is the only one that is working the tickets.  We need a better solution!

</td>
</tr>
</table>

Note how the description is written in prose (i.e. in normal conversational language), and doesn't follow the wooden 3-part template. Note also, the story doesn't prescribe _how_ to solve the problem. It just provides background on what the problem is and who it affects. It isn't _just_ that the story doesn't dictate implementation details, but that it doesn't dictate the solution _at all_. This is the ideal starting point for most stories. It's a placeholder for a conversation about how to solve the problem.

From here, the team would collaborate on the story to determine the best solution that results in the smallest feature increment which adds value to the end user. Several ideas may be discussed. The system could integrate with a 3rd-party content management system, allowing people within the company without SQL experience to update content. Alternately, the team may decide that adding a feature to allow customers to add custom products directly to their personal event registry is both easier, and scales far better than solutions requiring company employees to work tickets.

As part of a story refinement session, the team may update the story with acceptance criteria to guide the implementation:

<table style="border: 1px solid black; background-color: white; color: black">
<tr>
<td>
<h2>Easily Manage Registry Products</h2>
<hr style="border-top: 1px solid black"/>
<h3>Description</h3>
Our customers often want to add products that aren't part of our current vendor product list.  This causes the sales team to constantly have to put in tickets and currently Margret is the only one that is working the tickets.  We need a better solution!
<br/><br/>

<h3>Acceptance Criteria</h3>
<b>When the customer navigates to the edit registry view</b><br>
 &nbsp;&nbsp;it should contain a link for adding custom products
<br><br>
<b>When the customer clicks the add custom product link</b><br>
&nbsp;&nbsp;it should navigate to the add custom product view (note: see balsamiq wireframe attached)
<br><br>
<b>When the customer adds a new custom product with valid inputs</b><br/>
&nbsp;&nbsp;it should add the custom product to the customers registry<br/>
&nbsp;&nbsp;it should display a success message in the application banner<br/>
&nbsp;&nbsp;it should navigate back to the edit registry page
<br><br>
<b>When the customer enters invalid custom product parameters</b><br/>
&nbsp;&nbsp;it should show standard field level error messages<br/>
&nbsp;&nbsp;it should not enable the save button<br/>
</td>
</tr>
</table>

While an Acceptance Criteria section isn't mandatory, it can often be valuable for helping to frame the scope of the story, a reminder to the team of the high-level plans discussed for deferred work, and/or may serve as the team's Definition of Done. For small teams involving just a few members, or for highly adaptive and collaborative teams, it may be enough to just just write "_We decided to add a feature to allow the customer to add their own products!_". The team may very well take the initial story description and rapidly iterate on a solution, deciding together when they think it's done! (Gasp!) Of course, this level of informality probably is only best suited to highly cohesive, highly functioning teams. For inexperienced to moderately experienced teams, some denotation of Acceptance Criteria would be advisable. The key point is, the story didn't arrive to the team in the form of requirements, but as a placeholder for a conversation.

## Conclusion

As the adoption of agile frameworks such as Scrum have become more mainstream, a number of practices have become formulaic and adopted by teams via a cargo-cult onboarding to agile practices without truly grasping what it means to be agile. The User Story has all but lost it original intent by many teams who have done little more than slap agile labels onto Waterfall manufacturing processes. User Stories were never intended to be requirements, but rather a placeholder for a conversation with the development team. Let's do better.
