---
id: 78
title: Dialing up quality
date: 2007-10-12T20:30:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/10/12/dialing-up-quality.aspx
dsq_thread_id:
  - "1232433748"
categories:
  - Agile
  - Misc
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/10/dialing-up-quality.html)._

Quality is not a light switch, it can&#8217;t be flipped on&nbsp;overnight, or even in six months.&nbsp; Although the term &#8220;quality&#8221; differs from person to person, I rather like [James Shore&#8217;s](http://www.jamesshore.com/)&nbsp;description of [Quality With a Name](http://www.jamesshore.com/Articles/Quality-With-a-Name.html).&nbsp; He defines quality as having a great design, and that a **great design is easy to change**.

Furthermore, he concludes:

> **_Great designs_**:
> 
>   * Are easily modified by the people who most frequently work within them, 
>       * Easily support unexpected changes, 
>           * Are easy to modify and maintain, 
>               * _and_ Prove their value by becoming steadily easier to modify over years of changes and&nbsp;upgrades.&nbsp;</ul> </blockquote> 
>             Now that your team agrees on what great design is, reality sinks in when they go back to the monolithic flying-spaghetti-code-monster system and see how far away they are from great design.
>             
>             Great design and high quality _can_ be achieved, but it takes many individual victories to reach the final goal.&nbsp; A team can dial up quality, one&nbsp;principle/practice at a time, until the team and the system are one smoothly running machine.
>             
>             #### Low hanging fruit
>             
>             So how do we decide where to begin?&nbsp; The easiest is the low hanging fruit, pain points that affect developers every day.&nbsp; Here&#8217;s some common pain points/smells I run in to:
>             
>               * Everyone is afraid to get the latest version
>               * &#8220;It works on my machine&#8221; is your team&#8217;s mantra
>               * Every source code file has at least 3 different coding styles
>               * It takes forever to reproduce a defect locally
>               * No one knows if the defect is still fixed next week, month, or six months from now
>             
>             And the list can go on and on.&nbsp; Once pain points are found, take the top pain point and set a goal to tackle it in the next week or month.&nbsp; Then schedule a brown-bag lunch to show the problem, how you tackled it, and the principles that led you to these actions.
>             
>             #### Show the value
>             
>             When I want to correct some of these quality issues, I can&#8217;t tackle the issue in one fell swoop.&nbsp; Often new ideas have to be introduced a little at a time, where I prove the value as I go.
>             
>             I can&#8217;t force unit tests or pair programming on a team if no one sees the value.&nbsp; If I try it out, show the value, then team members will start to come onboard.
>             
>             A plan of action might be:
>             
>               1. Automate the build locally
>               2. Automate the build of the latest version on a build server
>               3. Remove all warnings
>               4. Add some automated tests to reproduce a defect
>               5. Get these automated tests running with the nightly build
>               6. Introduce unit tests on new code, running with the nightly build
>               7. Introduce some key FxCop rules where we&#8217;re seeing the most varying coding styles
>               8. Gradually introduce other FxCop rules to hit other pain points
>             
>             Once initial buy-in for values like &#8220;feedback&#8221; and &#8220;maintainability&#8221; happens in your team, it&#8217;s that much easier to introduce other practices that enforce those key values.&nbsp; Perfect quality is never achieved, but as my dentist told me, **excellence is the pursuit of perfection**.
>             
>             #### Baby steps to excellence
>             
>             It&#8217;s easy to get discouraged trying to get 100% test coverage on a legacy app.&nbsp; A better intermediate step is to get 80% coverage on the class or classes that have the most defects.&nbsp; Lessons learned from that experience can then be applied to the rest of the app.&nbsp; But if we tried to tackle the entire system all at once, we wouldn&#8217;t get far enough to realize the value, and the team would discard the value as impossible to achieve.
>             
>             By taking small steps toward realizing our goals, dialing up quality one step at a time, we can create a pattern of success take the system to a level of quality that otherwise would not have been imagined to be possible.