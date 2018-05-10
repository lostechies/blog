---
wordpress_id: 50
title: Concerns about NBehave
date: 2007-09-05T18:04:10+00:00
author: Joe Ocampo
layout: post
wordpress_guid: /blogs/joe_ocampo/archive/2007/09/05/concerns-about-nbehave.aspx
dsq_thread_id:
  - "262090925"
categories:
  - BDD (Behavior Driven Development)
  - Domain Driven Design (DDD)
redirect_from: "/blogs/joe_ocampo/archive/2007/09/05/concerns-about-nbehave.aspx/"
---
 <img style="border-top-width: 0px;border-left-width: 0px;border-bottom-width: 0px;border-right-width: 0px" height="240" alt="square_round" src="https://lostechies.com/content/joeocampo/uploads/2011/03ConcernsaboutNBehave_CC25/square_round_1.jpg" width="163" align="right" border="0" />This is an attempt to answer <a href="http://codebetter.com/blogs/scott.bellware/archive/2007/09/05/167500.aspx" target="_blank">Scott Bellware’s</a> concerns and questions about <a href="http://nbehave.org/" target="_blank">NBehave</a>. 

Scott, first off thanks for posing the question I really appreciate open honest feedback. 

I want to make sure that everyone understands that I don’t treat Agile as a prescriptive process that has to be rigidly followed. The contextual nature of Agile and its supporting practices require that individuals analyze and determine the best tools to use for the job. 

> “Stories are intentionally malleable. They can be split, joined, negotiated, re-negotiated, and changed. And ultimately, they&#8217;re totally disposable. Once they&#8217;re done, they can be torn up and thrown away.” 

Speaking of my specific context, I work for a financial institution that has heavy Government regulatory oversight concerning software development, in particular requirements traceability. 

I agree with Scott that Stories should be malleable and the simplest mechanism should be taken in order to determine business value out of the software you are creating. When I was first introduced to Agile we started off with XP practices during the planning phase and came up with stories on index cards. It wasn’t till our auditing department became more aware of certain regulatory constraints (that I am still contesting to this day) where we had to look at more heavy weight measures of documenting our stories (requirements). As you can imagine this became source of contention amongst the team as some of the BA’s and testers wanted to immediately go back to a heavy weight approach of requirement authoring. My remediation to this was to create the requirements goal form and feature cards seen below. This at least got me away from [IEEE 830](http://ieeexplore.ieee.org/xpl/tocresult.jsp?isNumber=15571) style requirements, that we all know do not work! 

&nbsp;

<table width="585" border="1">
  <tr>
    <td width="583">
      <h2>
        Requirement Goal
      </h2>
      
      <p>
        <i>Date<b> 01/01/2007<br /></b>Desired Implementation Date<b> 04/01/2007<br /></b>Business Analyst<b> Susie Que<br /></b>Executive Sponsorship<b> Jack Marshal, Regional Director</b></i>
      </p>
      
      <p>
        <b><i>Goals</i></b><i>:</i>
      </p>
      
      <p>
        <i>The user would like to log into the ATM by first swiping their personal ATM card issued from the branch office and then key in a 4 digit PIN. When the user creates their pin we have to make certain that their pin does not match the last 4 digits of their SSN that we have in the system. If the PIN does not match then store the PIN in the system and associate it with the ATM card. If it does match then display an error message with the following text “You may not use a PIN that matches the last 4 numbers of your social security number&#8221;</i>
      </p>
      
      <p>
        <i>&nbsp;After the user logs into the ATM they should be presented with a home screen that displays a welcome message and their name. The client should then be able to see a menu list with the following options.</i>
      </p>
      
      <p>
        • <i>Balance Inquiry</i>
      </p>
      
      <p>
        • <i>Withdrawal </i>
      </p>
      
      <p>
        • <i>Transfer</i>
      </p>
      
      <p>
        <b><i></i></b>
      </p>
      
      <p>
        <b><i>Benefit</i></b><i>:<br />By implement ATM machines in our branches our company will be able to offer a competitive advantage over our competitors.</i>
      </p>
      
      <p>
        <b><i>Detriment</i></b><i>:</i>
      </p>
      
      <p>
        <i>If we fail to implement ATM machines in our branches our company will be forced to stay open till 10 PM increasing resource cost by 35% nationwide.</i>
      </p>
    </td>
  </tr>
  
  <tr>
    <td width="583">
      <h2>
        Feature Card
      </h2>
      
      <p>
        <b>Card No</b>: 052205
      </p>
      
      <p>
        <b>Name</b>: Branch 4 Digit PIN number creation
      </p>
      
      <p>
        <b>Summary</b>: The client will create a 4 digit pin number in the branch.
      </p>
      
      <p>
        <b>Type</b>: Customer
      </p>
      
      <p>
        <b>Requirements Uncertainty (erratic, variable, regular, stable)</b>: Regular
      </p>
      
      <p>
        <b>Dependencies</b>: None
      </p>
      
      <p>
        <b>User Acceptance Tests</b>:
      </p>
      
      <p>
        <b><i>Given </i></b>that the client is creating a 4 digit PIN number
      </p>
      
      <p>
        <b><i>When</i></b> the client has keyed in a 4 digit pin that does not match the last 4 digits of their SSN
      </p>
      
      <p>
        <b><i>Then</i></b> the PIN is stored in the clients account profile.
      </p>
      
      <p>
        <b><i>This is a </i></b><i>Positive aspect</i>
      </p>
      
      <p>
        <b><i>Given </i></b>that the client is creating a 4 digit PIN number
      </p>
      
      <p>
        <b><i>When</i></b> the client has keyed in a 4 digit pin that does match the last 4 digits of their SSN
      </p>
      
      <p>
        <b><i>Then</i></b> the client is presented with an error containing the text “<i>You may not use a PIN that matches the last 4 numbers of your social security number”</i>.
      </p>
      
      <p>
        <b><i>This is a </i></b><i>Negative aspect</i>
      </p>
    </td>
  </tr>
</table>

As you can imagine this worked great up until we had a change to the Goal or the Feature. Then the traditionalist threw up the change control flag and I cringed. But let’s talk about why they threw up the flag in the first place. 

  * · Is it because the code that was being affected was difficult to change? **_No_** 
      * · Is it because the testing team had to change their acceptance test that they didn’t have automated at the time and only documented steps within a spread sheet? **_Yes_** 
          * · Is it because the business had to go back and make sure they properly documented the changes in the feature and in the requirement goal form? **_Yes_** </ul> 
        So you see it is not that the development team that was not welcoming the change, in fact it took the development team 10 minutes to make a change, where it took the documentation and testing efforts several hours to make a change on average. The point I am trying to make is that Agile methodologies in general (software practices aside) engage teams to find a way to solve _perceived_ complex issues such as change control and find a simpler solution to enable change. 
        
        In the scenario above Automated Acceptance Testing was the logical choice to curve the acceptance testing documentation since now it would be housed in a tool that propagated changes and had auditing features built in. The requirements goal side of the house was, is still a contention point since such a simple form is still not updated. There is talk about more enterprise methods of governing the requirement goals but I am not one to promote enterprise level product suites that cost hundreds of thousands of dollars. 
        
        Then one day I came across <a href="http://dannorth.net/" target="_blank">Dan North’s</a> post on <a href="http://dannorth.net/2007/06/introducing-rbehave" target="_blank">rbehave</a>. What a concept, story authoring at the source code level! This made so much sense to me I quickly found a <a href="https://lostechies.com/blogs/joe_ocampo/archive/2007/06/18/rbehave-with-nunit.aspx" target="_blank">hackish</a> way to make it work in C#. To my amazement it worked and I started to ponder the benefits within my organization. The key was to make the framework as easy as possible for a product owner to author the story within the source code. Bring the focus and the continuity around the source code as point of reference to the inception of the domain concepts. Utilizing the Visual Studio IDE and ReSharper you could really ask the question to the code, “why is this FeeTemplate object here?” you can than quickly trace back to a story and see why it was created. If a domain object doesn’t trace back to a story, you should question the validity of that domain object. 
        
        So it has two benefits Domain Validation and requirements traceability. Not to mention that if a product owner wants to make a change to a story they simply check out the story make the change with the developer and tester on hand, check in the story to the source code repository which prompts the developer and the tester to make the appropriate changes. 
        
        NBehave is still in a beta state so I can’t call it a success or a failure yet but I will say that it has tremendous potential for organizations that have instituted Agile but have to deal with more formal regulatory constraints. 
        
        Having said that, I would like to point out that all Agile Practioners should take a step back and question the tools they are using? Does NBehave make sense for small or medium size shops where you don’t have to worry about formal processes, probably not. Start with the simplest mechanism, in the case of story authoring that would probably be index cards. If you find that you need more control over your story authoring evolve to the next level of simplicity. If it leads to NBehave great! If it doesn’t even better! The point is remembering the first core value of the Agile Manifesto. 
        
        > <font size="4"><em><strong>Individuals and interactions</strong> over processes and tools</em></font> 
        
        Look to the left before you leap to the right! 
        
        And Scott thanks again for making me think if what I was doing is worthwhile.