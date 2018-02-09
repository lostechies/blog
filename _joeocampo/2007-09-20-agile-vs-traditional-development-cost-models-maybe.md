---
wordpress_id: 61
title: 'Agile vs. Traditional Development Cost Models &#8230;Maybe'
date: 2007-09-20T21:24:00+00:00
author: Joe Ocampo
layout: post
wordpress_guid: /blogs/joe_ocampo/archive/2007/09/20/agile-vs-traditional-development-cost-models-maybe.aspx
dsq_thread_id:
  - "262071856"
categories:
  - 'Agile Project Coaching &amp; Management'
  - Agile Teams
redirect_from: "/blogs/joe_ocampo/archive/2007/09/20/agile-vs-traditional-development-cost-models-maybe.aspx/"
---
One of the developers in the lab had been talking to his friends, who is being introduced to Scrum.&nbsp; One of the value proposition that they are selling to his friends company is that Agile will save you money in project cost.&nbsp; I want to caution Agile Practitioners on selling this concept.&nbsp; Agile produces higher value for the money but doesn&#8217;t necessarily save you money in project cost.

The models below are based on the following assumptions.

> &#8220;Given that you have one project that is fixed 12 months in duration and has a fixed amount of resources. What is the overall cost of the project?&#8221; 

It is important to note that we are not talking about maintenance cycles just the cost to the product owner for a project.

  * The project will last 12 months from January to December 
      * Resources 
          * 2 Business Analyst &#8211; Project cost of $40 an hour 
          * 2 Systems Analyst &#8211; Project cost of $40 an hour 
          * 4 Developers &#8211; Project cost of $70 an hour 
          * 3 Quality Technicians &#8211; Project cost of $45 an hour

Here is graph depicting the resource cost of a traditional model over the course of a year.

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" alt="image" src="http://lostechies.com/joeocampo/files/2011/03Agilevs.TraditionalDevelopmentCost.Maybe_F542/image_thumb.png" border="0" height="264" width="617" />](http://lostechies.com/joeocampo/files/2011/03Agilevs.TraditionalDevelopmentCost.Maybe_F542/image.png) 

Not surprising this is what a traditional cost model looks like for a waterfall project but I wanted to add another dimension based on a value stream vs technical debt.

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" alt="image" src="http://lostechies.com/joeocampo/files/2011/03Agilevs.TraditionalDevelopmentCost.Maybe_F542/image_thumb_1.png" border="0" height="375" width="622" />](http://lostechies.com/joeocampo/files/2011/03Agilevs.TraditionalDevelopmentCost.Maybe_F542/image_1.png) 

You can easily see how the cost of change is higher towards the end of the project due to incurring technical debt.&nbsp; In a traditional methodology technical dept is not addressed head on, it is merely prioritized in a defect log.&nbsp; I think all of us at one point in our careers have launched a product into production with a couple of hundred known defects.

> &#8220;**Technical debt** is the unfinished work the product development team accumulated from previous releases. This debt includes: design debt, where the design is insufficiently robust in some areas; development debt, where pieces of the code are missing; and testing debt, where tests were not developed or run against the code&#8230;&#8221;
> 
> Kane Mar has an excellent [article](http://kanemar.com/2006/07/23/technical-debt-and-the-death-of-design-part-1/) on the subject as well.

Look at this from a Business perspective.&nbsp; Does it matter that I have this debt?&nbsp; The project is done and I am making money.&nbsp; Who cares if it doesn&#8217;t work exactly as I want. The point of the matter is, it is making money.&nbsp; Money that can pay for the maintenance line.&nbsp; Think Microsoft Vista.&nbsp; Was it perfect?&nbsp; NO!&nbsp; Was it close to being perfect?&nbsp; NO!&nbsp; Did MS know that Vista had lots of bugs? Yes! Was it done to a state that could bring in money for the company?&nbsp; Yes!

One other very important attribute is that the &#8220;Value Stream&#8221; of the project is not incurred until the end of the project.

> **Value Stream** is the ROI that is incurred when components of a project are introduced into a production environment producing a revenue stream for the company.

Now come the Agile models.&nbsp; This first set of graphs is based on a evolving Agile team that practices an iterative development methodology&nbsp; but only introduces code into production at the completion of a project.

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" alt="image" src="http://lostechies.com/joeocampo/files/2011/03Agilevs.TraditionalDevelopmentCost.Maybe_F542/image_thumb_2.png" border="0" height="310" width="731" />](http://lostechies.com/joeocampo/files/2011/03Agilevs.TraditionalDevelopmentCost.Maybe_F542/image_2.png) 

As you can see the cost of requirements, development and testing are fixed.&nbsp; This is due in part to the time boxing effect of Agile&#8217;s Planning, Development and Testing into smaller releases throughout the duration of the project.&nbsp; To some this may seem to be a horribly ineffective use of resources but for me it makes things more predictable.&nbsp; You will also notice that their isn&#8217;t a design cost.&nbsp; Theoretically their is it is just absorbed within the development and planning stages.

Lets look at the overall cost of this type of Agile Development.

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" alt="image" src="http://lostechies.com/joeocampo/files/2011/03Agilevs.TraditionalDevelopmentCost.Maybe_F542/image_thumb_3.png" border="0" height="414" width="688" />](http://lostechies.com/joeocampo/files/2011/03Agilevs.TraditionalDevelopmentCost.Maybe_F542/image_3.png) 

As you can see the project cost are almost doubled in comparison to the traditional model.&nbsp; However the value stream is substantially more, due in part to the constant feedback from the product owner and the embracement of change principles.&nbsp; The technical debt is a fraction of the traditional model due in part to quality being introduced from the onset through the development team TDD practices and the testing teams automated testing.

But lets look at a mature Agile Team that introduces working code into production at the end of every release!

[<img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" alt="image" src="http://lostechies.com/joeocampo/files/2011/03Agilevs.TraditionalDevelopmentCost.Maybe_F542/image_thumb_4.png" border="0" height="443" width="738" />](http://lostechies.com/joeocampo/files/2011/03Agilevs.TraditionalDevelopmentCost.Maybe_F542/image_4.png) 

The value stream is substantially higher due in part to introducing working code into production early on in the project, about every other month!

&nbsp;

So lets break it down.

<table border="1" cellpadding="3" width="100%">
  <tr>
    <td>
      <b>Methodology</b>
    </td>
    
    <td>
      <b>Project Cost</b>
    </td>
    
    <td>
      <b>Value Stream</b>
    </td>
    
    <td>
      <b>Technical Debt</b>
    </td>
  </tr>
  
  <tr>
    <td>
      Traditional
    </td>
    
    <td align="right">
      $354,600
    </td>
    
    <td align="right">
      $300,000
    </td>
    
    <td align="right">
      -$161,000
    </td>
  </tr>
  
  <tr>
    <td>
      Agile Evolving
    </td>
    
    <td align="right">
      $650,400
    </td>
    
    <td align="right">
      $500,000
    </td>
    
    <td align="right">
      -$8,600
    </td>
  </tr>
  
  <tr>
    <td>
      Agile Matured
    </td>
    
    <td align="right">
      $650,400
    </td>
    
    <td align="right">
      $1,550,000
    </td>
    
    <td align="right">
      -$8,600
    </td>
  </tr>
</table>

&nbsp;

If your product owner is strictly concerned on cost and that is all that guides their decision making, then stick with a traditional model.  _(By the way you may want to consider looking for a new job if you work for this company.)_

As you can see Agile provides tremendous value and not necessarily **<span style="font-size: large">project cost savings</span>**.&nbsp; The quicker you are able to stabilize a production release the more you will increase the value stream for the business.&nbsp; A win win for everyone involved.

If you noticed I intentionally left bold the phrase &#8220;project cost savings&#8221; because as we all know, projects have end date but production applications don&#8217;t!&nbsp; Production systems need to be maintained and in a traditional model this is where the cost incursion becomes enormous due to technical debt.

&nbsp;

Before I get a borage of comments on the data that supports these claims, the data is based on perfect scenarios in both methodologies.&nbsp; Like all data it can be adjusted to many outcomes I just wanted to be as fair as possible to both.

&nbsp;

I am really curious to see what this is going to spark out there.&nbsp; Looking forward to your comments.

[<img alt="kick it on DotNetKicks.com" src="http://www.dotnetkicks.com/Services/Images/KickItImageGenerator.ashx?url=http://www.lostechies.com/blogs/joe_ocampo/archive/2007/09/20/agile-vs-traditional-development-cost-models-maybe.aspx" border="0" />](http://www.dotnetkicks.com/kick/?url=http://www.lostechies.com/blogs/joe_ocampo/archive/2007/09/20/agile-vs-traditional-development-cost-models-maybe.aspx%20)