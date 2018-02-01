---
id: 456
title: An Early Glimpse of Future Composite Smart Client Guidance
date: 2008-01-17T20:01:00+00:00
author: Derek Greer
layout: post
guid: http://www.aspiringcraftsman.com/2008/01/an-early-glimpse-of-future-composite-smart-client-guidance/
dsq_thread_id:
  - "324115939"
categories:
  - Uncategorized
---
This week the Patterns & Practices team invited a small group of members from the composite application development community to discuss ideas surrounding composite development using Windows Presentation Foundation, and to solicit feedback on the team’s latest design ideas and planned direction for the next release of composite guidance assets for the .Net community.<figure id="attachment_100" style="max-width: 300px" class="wp-caption aligncenter">

[<img class="size-medium wp-image-100" src="http://www.aspiringcraftsman.com/wp-content/uploads/2008/01/Seattle-009-300x225.jpg" alt="" width="300" height="225" />](http://www.aspiringcraftsman.com/wp-content/uploads/2008/01/Seattle-009.jpg)<figcaption class="wp-caption-text">Glenn Block (left) and Blaine Wastell (right)</figcaption></figure> 

One of the first topics of the meeting included a discussion of new user interface design approaches enabled through the power of Windows Presentation Foundation, demonstrations of how some companies are currently utilizing these abilities, and the solicitation of information on future design plans from the attendees. This was in part to introduce the audience to the notion of what is being referred to as “Differentiated UI”, but was primarily a continuation of advanced WPF design research the team has been conducting over the past few weeks to ensure that the architecture choices made for any new composite guidance assets would not be a road-block for how WPF applications may be developed going forward.

The next major topic surrounded the existing features of the Composite UI Application Block and Smart Client Software Factory. Glenn, Blaine, and Francis shared some of the feedback their team has received on the existing composite guidance, and attendees were asked to list those features they felt should be carried forward, those that should be removed, and features that should be added. Attendees were then broken up into teams to discuss some of the technical challenges faced in current composite design in order to enumerate issues the team should focus on going forward.

<div class="wp-caption">
  <a href="http://www.aspiringcraftsman.com//wp-content/uploads/2008/01/Seattle-010.jpg"><img class="aligncenter size-medium wp-image-101" style="float: left;padding-right:4px" src="http://www.aspiringcraftsman.com/wp-content/uploads/2008/01/Seattle-010-300x225.jpg" alt="" width="300" height="225" /></a><a href="http://www.aspiringcraftsman.com/wp-content/uploads/2008/01/Seattle-006.jpg"><img class="aligncenter size-medium wp-image-102" src="http://www.aspiringcraftsman.com/wp-content/uploads/2008/01/Seattle-006-300x225.jpg" alt="" width="300" height="225" /></a></p> 
  
  <p class="wp-caption-text">
    The results of the existing CAB/SCSF feature survey can be seen in the above pictures of Glenn Block (left) and Brad Abrams (right).
  </p>
</div>

Following this discussion, Glenn and his team presented a high level overview of the general direction being considered for their new guidance surrounding WPF composite development, and presented three spikes demonstrating the new ideas for module loading, managing Workspaces, and brokering events.

The current direction of the team surrounds the simplification of the existing architecture to make composite development more approachable by the masses. While still in a somewhat malleable state, some of the goals include minimizing the use of dependency injection, separating the former responsibilities of the CAB work item (i.e. the former management of smart parts, work items, event publications and subscriptions, etc.), improving component extensibility, and enabling features to be more easily replaced and possibly used independently.

Some of the notable changes being proposed include a new Dependency Injection façade for enabling other containers to be exchanged for Object Builder, the proposal of a Scope type which would provide the contextual scoping boundary association previously provided by the work item, and a new delegate-based event notification system where publications and subscriptions are associated through the use of registered interfaces.

The meeting also featured an overview of Acropolis by its chief Project Manager and Architect David Hill, and included lots of interesting conversations sprinkled throughout including such topics as Dependency Injection techniques, XAML debugging challenges, Model-View-Presenter and Presentation Model recommendations, whether the Model-View-View-Model pattern is really a rebranded Presentation Model pattern, and many other geeky goodies.

Overall, the meeting was very informative and demonstrated the Pattern & Practices team to be sincerely interested in the needs and desires of the greater .Net development community. Thanks Glenn, Blaine, Francis, and all the guest presenters that took this time to help ensure your group continues its track record of providing great guidance and assets to the .Net community.
