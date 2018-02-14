---
wordpress_id: 59
title: The Impact of Staffing Practices on Software Quality and Productivity
date: 2009-06-07T23:59:55+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2009/06/07/the-impact-of-staffing-practices-on-software-quality-and-productivity.aspx
dsq_thread_id:
  - "262068223"
categories:
  - Management
  - Philosophy of Software
  - Quality
redirect_from: "/blogs/derickbailey/archive/2009/06/07/the-impact-of-staffing-practices-on-software-quality-and-productivity.aspx/"
---
### A Junior-Heavy Organization

Companies tend to staff various teams with an experience level of employees that have a very junior heavy bias. That is, for every person with senior level experience in the organization, there tend to be multiple mid level persons. And, for every mid level person, there tend to be multiple junior level persons. The end result is that we create an organization that resembles a hierarchy such as Figure 1. 

<table style="float: left" cellspacing="0" cellpadding="5" border="0">
  <tr>
    <td valign="top" align="center">
      <a href="http://lostechies.com/content/derickbailey/uploads/2011/03/clip_image002_65719362.gif"><img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="187" alt="clip_image002" src="http://lostechies.com/content/derickbailey/uploads/2011/03/clip_image002_thumb_0BD376AE.gif" width="204" border="0" /></a> <br /><font size="1"><b>Figure 1.</b> Junior-Heavy Hierarchy</font>
    </td>
  </tr>
</table>

One of the key factors to understanding this hierarchy is to recognize that a person may be capable of working at a senior level in spite of a relatively short career. It is also likely that an individual in an organization may be considered senior level only by years in the industry or pay level, while that individual may not be able to work in a senior level capacity. Given these factors, an honest analysis of the company is likely to show many department hierarchies that are similar to the one outlined here.

There are many different reasons for staffing an organization in this manner. It may not be possible to find talented, senior level persons when a company is in a position to hire. There may be labor cost considerations, such as a desire to reduce the labor rates of a project resulting in a lower-cost proposal. Furthermore, it is often easier to teach inexperienced persons how to work according to a team or company standard, since they do not come with years of experience working in other manners. No matter the actual reasons, though, a department structure such as this is likely to have a significant and negative impact on the productivity and quality of the work done by that department.

Once a team begins to formalize around a junior heavy structure, there are a number of issues that begin to arise.

__

> _“As new products grow, revenues grow, the R&D budget grows, and engineering and research staff grows. Eventually, this burgeoning technical staff becomes increasingly complex and difficult to manage. The management burden often falls on senior engineers, who in turn have less time to spend on engineering. Diverting the most experienced engineers from engineering to management results in longer product development times, which slow down the introduction of new products.”_

> &#8211; Peter M. Senge, “The Fifth Discipline”, p. 96

### Technical Leadership vs. Project Management

In a software development organization such as ours, there is a distinction between technical leadership versus project management. Technical leadership includes activities such as high level systems design and architecture, implementation details such as frameworks, tools and development techniques, and ensuring that the team is up to speed on the team standards and following those standards. In order to facilitate technical leadership in a team, the person tasked with this role will need to be involved in both the implementation of the system, as well as conversations on the system definition and requirements. However, the role of the technical leader should be to focus on the technical aspects of the system, ensuring consistency and stability of the system while meeting the business needs. It should also be noted that the senior level persons on a team are the appropriate persons for this type of work. They have the necessary experience and design capabilities, and should be adept at communicating decisions and technical directions to the rest of the technical team, effectively.

From a functionality standpoint, the project manager coordinates the high-level requirements and work organization with the customer, helping to prioritize the order in which those features need to be implemented. The prioritization of work is correlated with the assignment of work to be done by the functional groups. For example, the feature with the highest priority will be handed to the various functional teams: “Testers, go write scenarios for this, now,” and “Developers, go architect and build that, next,” etc. 

At the functional group level, a technical lead (dev lead, test lead, etc) would help to break down the features and user stories into individual work tasks, and help to prioritize the order in which those tasks should be done. This is needed to facilitate the implementation needs of the system. At this point, the team members doing the actual work are to be given the authority to grab the next available task from the list, whenever they are freed up from their current task. In situations where individual tasks for a story have a similar or same priority (for example, if it doesn’t matter that screen/workflow X is done before or after screen/workflow Y), then the person who needs work is free to choose which task to take on next.

Unfortunately, senior level engineers often end up doing project management work instead of technical leadership work, when a team is structured in a junior heavy manner. This includes activities that do overlap the technical leadership role, to an extent. For example, the project management role includes definition and discussion of the system and requirements. However, the project management role also includes additional responsibilities that fall outside of the technical leadership role, such as maintaining project status and visibility or determining work to be done by functional groups. The project management role must account for the needs of project team members that are not directly involved in the implementation, as well. Persons such as technical writers, business analysts, testers and others, including the technical staff, need to have consistency of project management to ensure that the entire system is moving forward correctly.

### Cycles of Decreasing Productivity

In Figure 2, there are two cycles of increasing momentum at play, which ultimately lead to the same conclusion – lowered productivity of the team. When the senior engineers in this scenario begin to have their time taken up with management tasks and meetings, there are additional side effects that lead to poor quality and unhappy customers. 

<table style="float: left" cellspacing="0" cellpadding="5" border="0">
  <tr>
    <td valign="top" align="center">
      <a href="http://lostechies.com/content/derickbailey/uploads/2011/03/clip_image004_21D69694.jpg"><font size="1"><a href="http://lostechies.com/content/derickbailey/uploads/2011/03/clip_image004_47CC46EA.jpg"><img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="363" alt="clip_image004" src="http://lostechies.com/content/derickbailey/uploads/2011/03/clip_image004_thumb_1E3BC763.jpg" width="429" border="0" /></a></font></a><font size="1"> <br /><b>Figure 2. </b>Increasing Cycles of Lowered Productivity</font>
    </td>
  </tr>
</table>

As hiring is done, it is focused on mid and junior level personnel, for the various reasons previously discussed. This causes an obvious growth in the team, increasing the need for management structure and overhead in the team. Most often, the senior level persons on the team will fulfill this need. They are the most qualified individuals to do the training, and are able to help organize, direct, and assist the new hires and existing team members. 

With the senior level persons’ time taken up with management tasks, they no longer have time to perform the high level designs and architectures for the team efforts. This leaves the mid level persons to the designs and architecture, when they may not have the experience and understanding necessary to complete these tasks. The burden of learning through trial and error of implementation can quickly become overwhelming, and the mid level persons will often spend an inordinate amount of time working on these tasks. When this occurs, the junior level team members will do the majority of the implementation work, in spite of being the least capable and least well equipped for the job. This ultimately leads to lowered productivity of the team, as the junior level members struggle with implementation details and technology questions that they cannot answer or get quick answers to. The lowered productivity of a team often leads to a desire to increase the staff, to boost productivity. However, only mid and junior level personnel are hired and the cycle begins again, causing additional delays.

The second cycle depicted shows how the lowered productivity of the team will lead to longer delays for customers to receive the end product. This often leads to unhappy customers, wondering why they must wait. When the management structure of the team hears about the unhappy customers, they often push the team harder, to try and increase productivity. Unfortunately, this usually comes at the cost of lowering standards and cutting corners. The individuals doing the work, at mid and junior levels of experience, may not have an adequate knowledge or understanding of the standards, or simply may not be able to maintain the standards without significant guidance from the senior level persons, who are not available on a regular basis. The drop in standards will eventually create a drop in the quality of the product, which inevitably leads to defects being found in the end product. The defective parts of the product are either delivered as-is, or immediately reworked to correct the issues, resulting in a still longer lead time for the delivery of the product. The result is again, a lowered productivity of the team as they deal with the issues that they are introducing into the system, and this secondary cycle begins again, resulting in customers that are less and less satisfied.

### Combating the Issues

<table style="float: left" cellspacing="0" cellpadding="5" border="0">
  <tr>
    <td valign="top" align="center">
      <a href="http://lostechies.com/content/derickbailey/uploads/2011/03/clip_image006_0152A28E.jpg"><img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="77" alt="clip_image006" src="http://lostechies.com/content/derickbailey/uploads/2011/03/clip_image006_thumb_0EB8B594.jpg" width="240" border="0" /></a> <br /><font size="1"><b>Figure 3.</b> Senior Heavy Structure</font>
    </td>
  </tr>
</table>

Fortunately, there are ways to mitigate the issues described. To start with, teams should not be created with junior heavy structures. Rather, a senior heavy structure is desirable, as shown in Figure 3. This structure allows for the necessary promotion of senior level persons, into management roles and responsibilities. Assuming that the senior level persons have the necessary people skills for management and leadership, they are the most qualified persons to lead the teams in question. With such a structure, though, the teams are not left with a missing portion of technical leadership, implementation, and training needs. When one or two senior level persons are required to perform management tasks or attend meetings, there are additional senior level members available to handle the work load of that experience level.

Additional benefits can also be realized through a structure such as this. For example, it is widely believed that there are productivity gains of 10 to 20 times, or more, for senior level software developers vs. junior level software developers. 

> “_The original study that showed huge variations in individual programming productivity was conducted in the late 1960s by Sackman, Erikson, and Grant (1968). They studied professional programmers with an average of 7 years&#8217; experience and found that the ratio of initial coding time between the best and worst programmers was about 20 to 1, the ratio of debugging times over 25 to 1, of program size 5 to 1, and of program execution speed about 10 to 1. They found no relationship between a programmer&#8217;s amount of experience and code<a name="or_productivity"></a> quality or productivity._”
> 
> &#8211; Steve McConnell, “Code Complete 2<sup>nd</sup> Edition”, p. 682

Such productivity gains should immediately result in lower cost and shorter lead times. The experience and capabilities of the senior level personnel should also reduce the number of defects that are introduced into the product, improving quality and again reducing the lead time for delivery of the product. 

### Recognizing Reality

There are likely other benefits that can be attributed directly to the capabilities of a senior heavy team structure, as well. However, there are no silver bullets for anything in the real world. Simply having a team structured with a high number of seniors does not ensure that the work will be of high quality, or that they will be significantly more productive. Additional factors such as empowering the employees, focusing them with short term objectives that move toward long term goals, and a culture of open communication are also necessary. Fortunately, truly senior level persons should be able to facilitate the additional needs of the culture and environment. And in the end the time to delivery, product quality, and ultimately customer satisfaction should be sufficient motivation to begin ensuring a proper team structure.