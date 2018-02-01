---
id: 82
title: Myth of the isolated production fix
date: 2007-10-18T12:10:00+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2007/10/18/myth-of-the-isolated-production-fix.aspx
dsq_thread_id:
  - "264715379"
categories:
  - Agile
---
While in WCF training this week, I heard once again the argument why config files are great &#8211; your IT staff can change them without a recompilation.&nbsp; Sounds great right?&nbsp; But what exactly does this imply?

Sure, there&#8217;s no recompilation, but do the changes get tested?&nbsp; I can&#8217;t imagine someone modifying the production environment without testing those changes first.&nbsp; If something goes wrong, who&#8217;s fault is it?&nbsp; It&#8217;s the application team&#8217;s responsibility to ensure a tested, reliable application, but they&#8217;re not the ones making this change.

How exactly does this change happen?&nbsp; Does the IT staff manually edit the configuration files?&nbsp; What happens if they make a mistake?

#### Flirting with disaster

Statements like that, &#8220;change without a recompilation&#8221;, absolutely makes me cringe, as it usually implies that these changes are small, isolated, easy, and therefore don&#8217;t need to be tested.

The problem is that making configuration changes can sometimes lead to unexpected behavior changes because something we didn&#8217;t anticipate is dependent in some way on the configuration file.&nbsp; Even if the development team is consulted about these changes, how can they say with confidence the change is small or isolated without actually testing those changes?

Every change, no matter how small, that could potentially affect the behavior of the system, needs to be tested in a variety of systems and environments.&nbsp; Automated deployments to, and testing of, clones of production environments gives the team confidence in their changes.&nbsp; Anything else is a wild and potentially hazardous guess.

#### 

#### A responsible SCM process

The first step in any reasonable [SCM process](http://en.wikipedia.org/wiki/Software_configuration_management) is [continuous integration](http://martinfowler.com/articles/continuousIntegration.html).&nbsp; Until the build is repeatable, automated, and tested, the team can&#8217;t have much confidence in the reliability or quality of a build.&nbsp; Even small production fixes should start at this phase, as there&#8217;s never any guarantee a configuration change doesn&#8217;t affect business logic without regression testing.

After a CI build and possibly a nightly deployment, we typically have a set of gated environments where builds are put through more and more tests until they are certified as production-ready.&nbsp; Only builds labeled as production-ready are allowed to be promoted to the production environment.&nbsp; Although every build in CI processes might be labeled &#8220;production-ready&#8221;, sometimes longer regression tests need to occur before certifying a build ready for the next environment.

But why are small changes allowed to subvert this process?&nbsp; The only time this process should be allowed to be subverted is in the event of a critical failure, and the business is losing money because of downtime.&nbsp; If it takes three weeks for a build to move through the pipeline, that&#8217;s three weeks where the business is losing money.&nbsp; The only time we compromise on the quality of the build is when we absolutely have to push it out right away (i.e., in hours).

That&#8217;s not to say testing doesn&#8217;t happen, but it happens in a targeted area.&nbsp; After the hotfix is pushed out, we still go through the gated promotion process, just to make sure we didn&#8217;t miss anything.&nbsp; We might even throw out the changes in source control for more sound fixes.&nbsp; That hotfix is still considered suspect and isn&#8217;t treated as production-ready, but temporary.

#### 

#### Refuse to compromise values

Hotfixes are a rare occurrence and must go through a promotion process themselves, where the severity of the bug must have a certain level of negative effect on business.&nbsp; The temptation to push out lower severity bugs through hotfixes becomes higher when a few successful hotfix deployments occur.&nbsp; The business asks &#8220;well, if it was that easy, why don&#8217;t we do that all the time?&#8221;.&nbsp; This is just playing production roulette, and eventually it will catch up to you.

I don&#8217;t feel terrible occasionally compromising on practices when the urgency of a hotfix requires it, but it&#8217;s important for the team never to compromise on their core values.&nbsp; When hotfix patches are demanded on a regular basis, the team should learn to say &#8220;no&#8221;, push back, and volunteer a more responsible approach.