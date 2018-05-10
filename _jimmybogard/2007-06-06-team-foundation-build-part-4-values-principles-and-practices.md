---
wordpress_id: 29
title: 'Team Foundation Build, Part 4: Values, Principles, and Practices'
date: 2007-06-06T17:43:00+00:00
author: Jimmy Bogard
layout: post
wordpress_guid: /blogs/jimmy_bogard/archive/2007/06/06/team-foundation-build-part-4-values-principles-and-practices.aspx
dsq_thread_id:
  - "272118837"
categories:
  - Agile
  - TeamBuild
  - VSTS
redirect_from: "/blogs/jimmy_bogard/archive/2007/06/06/team-foundation-build-part-4-values-principles-and-practices.aspx/"
---
> _This post was originally published [here](http://grabbagoft.blogspot.com/2007/06/team-foundation-build-part-4-values.html)._

In the last post of this series, I discussed [how to create a build definition](https://lostechies.com/blogs/jimmy_bogard/archive/2007/05/24/team-foundation-build-part-3-creating.aspx). Before I start discussing extending and customizing Team Foundation Build, I think it&#8217;s important to discuss some values, principles, and practices regarding automated builds and continuous integration. To establish some context, I suggest reading the [original Martin Fowler article on CI](http://www.martinfowler.com/articles/continuousIntegration.html) (Continuous Integration).

When looking at extending a build, it&#8217;s difficult to see which direction to go without having a target or destination in mind. The idea behind having values and principles is to create a shared target that the team tries to hit. I&#8217;m paraphrasing Kent Beck and Martin Fowler quite a bit, so apologies in advance if these ideas are old news to you.

## Values, Principles and Practices

Values and principles are a set of ideas that a team believes are important or worthwhile. By themselves, they can be vague as they aren&#8217;t specific towards a specific domain. But without clear values and principles, the practices the team tries to enforce will have little or no meaning. Values and principles establish a context and meaning to practices, and practices are followed to reinforce a set of values and principles.

Practices are a concrete set of actionable items. They are either done or not done, and there is no gray area. Whether or not you have followed a practice is very clear. A set of practices go hand in hand with values, as Kent Beck says, &#8220;Just as values bring purpose to practices, practices bring accountability to values&#8221;.

## Values and Principles

So if a team decides that it is important to have values regarding builds and integration, what should these values be? I&#8217;ve suggested a few, but these could be expanded and modified depending on the context of the team. It&#8217;s not important that these specific values be agreed upon, but that the team communicates and agrees upon some set of values.

#### 

### Feedback

The only constant of software development is change. Change comes in many forms, whether it is requirements, environments, personnel, etc. It then follows that the software itself is in a constant state of change. Developers are modifying code, adding features, fixing bugs, refactoring, simplifying. But how do we know if the changes we&#8217;re making are successful or even correct? Change necessitates feedback, and feedback validates changes (or invalidates).

Change happens on a constant basis, so feedback should happen early and often to handle the constant changes. The longer we wait to receive feedback on changes, the more difficult it will be to decipher the feedback. The shorter the feedback loop is, the greater chance we will get meaningful and actionable feedback.

### Simplicity

Simplicity is far more difficult to achieve than complexity. However, complex systems take more time to understand and change than simple systems. The simpler the system is, the easier change becomes. Since change is constant in software, optimizations should be made towards simplicity over most anything else.

### Maintainability

Simplicity leads to greater maintainability. A maintainable system is a system that is easy to change. Maintainability can be achieved through simplicity, clarity, and solubility. If I can look at a piece of a system and understand its role or behavior in less than ten seconds, it&#8217;s highly soluble, and therefore maintainable. If a codebase has a solid suite of unit tests with high coverage rates, the codebase is maintainable because the unit tests enable change.

## Practices

Practices are the kinds of things you do day-to-day. They&#8217;re not really in place as a set of goals themselves, since enforcing the values is our true goal. It&#8217;s important to always keep the core values in mind when following the practices, and sometimes it doesn&#8217;t make sense to follow all of the practices. But understanding the values behind the practices will provide context for discussing whether or not to follow each practice. The following build practices are designed to reinforce the values and principles defined above.

### Single source repository

A single source repository is the single truth of the state of the system. Developers can be editing code on each of their systems, but having a single source repository enforces a single point of reference for keeping and finding source code and other information.

Single source repositories don&#8217;t have to only store code, nor can source repositories be only code repositories. SharePoint is a type of repository that can store documents. When you store a document in SharePoint, no one argues which email attachment document is the correct document from whatever email you received. There&#8217;s only one document, and one place to find it.

### Automate the build

Human intervention is a typical source for errors in manual processes. To me, automation is just another way of eliminating duplication in processes. I don&#8217;t want to duplicate my manual actions every day if I can have a reliable way to automate it. I&#8217;ll probably screw something up. The more a process is automated, the less likely it is to fail. We&#8217;re also less likely to forget to do the manual process in the first place. Builds can be complex, and with rich build tools available in nant and MSBuild, there&#8217;s no reason not to automate the build.

### Self-testing build

So we&#8217;ve automated our build, and our code compiled without errors. But is that sufficient for a successful build? In addition to merely compiling the code, our build should also run tests against the compiled code for further verification. Does our code meet specifications and requirements? After all, two developers could check in code that compiles successfully but blows up at runtime, or doesn&#8217;t pass customer acceptance testing. By having a self-testing build, we can receive deeper feedback from our builds.

The tests your builds can run can vary depending on how often the builds run. I posted a while back on [classifying tests](http://developer.us.dell.com/blog/jimmyb/archive/2007/04/23/268.aspx), and when looking at what tests to run, the length of time it takes to run your tests is generally proportional to how often you want to run them. If it takes 3 hours to run a test suite, you can&#8217;t run these tests in a build that builds every hour.

### Everyone commits every day

The longer you wait to commit changes, the more difficult it will be to integrate those changes. Let&#8217;s suppose I&#8217;m changing module A that depends on module B. While I make my changes, developer Joe makes several changes to module B. He adds a couple of features, changes some behavior, maybe even modifies the interface of a couple of classes that I use. If I make a 100 changes in a week, that&#8217;s a lot of changes that could potentially break because of Joe&#8217;s modifications. Maybe it&#8217;s only the changes on the first day that broke, but now it&#8217;s Friday and I don&#8217;t remember exactly all of the changes from the first day. 

The longer I wait to elicit feedback, the less useful that feedback becomes. If I commit daily, the most amount of changes I need to worry about is only what I did yesterday.

### Every commit should build

Following the message of getting feedback early and often, I should build every time I check in to get feedback from the build. If I have an automated, self-testing build, it would be easy to set off a build often. If I commit a dozen changes, and then build, I have a lot more to worry about if the build breaks or a test fails. It could be any one of those dozen changes that broke the build, and it&#8217;s up to me to wade through them all to figure out which one. I should instead add one change at a time, incrementally adding functionality and getting feedback from the build that I haven&#8217;t broken anything.

I like to compare this to the construction of a building. The builders don&#8217;t wait until the entire building is finished to see if it&#8217;s built right, they make small changes and additions, measuring and verifying as they go, until the structure is complete. If they wait until the building is finished, it&#8217;s several magnitudes of order more expensive to fix problems that could have been caught early on.

### Keep the build fast

Also known as the 10-minute build rule. If every commit sets off a build, I don&#8217;t want to have to wait to get feedback. Any longer than 10 minutes might mean I&#8217;ve moved on to something else, and lost the internal stack of ideas in my head that I used to build the original change. What ends up happening in reality is that teams have several types of builds. Usually there is a &#8220;CI build&#8221; that runs on every commit, and it only builds and runs unit tests. The longer the build takes to run, the less often the build should execute. A deployment build that runs lengthy regression tests could run nightly.

I don&#8217;t like to be kept waiting for feedback. If I ask someone a question in a conversation and they wait 5 minutes to answer, I&#8217;ve already walked away. Builds are the other entity in the daily conversation of development, always answering the question, &#8220;Is what I just checked in correct?&#8221; The quicker I get the answer, the quicker I can move on.

### Everyone can see what&#8217;s happening

The entire team should be aware at all times of the statuses of the build(s). Since the build output is the final result of the team&#8217;s production, it&#8217;s in the team&#8217;s best interest to keep the build &#8220;green&#8221;, or successfully run. When it&#8217;s easy to see the status, you can start putting some rules in place:

  * The whole team drops everything to fix a broken build 
  * Nobody checks in when a build is broken or in progress 
  * Nobody leaves after checking in a change until the build is green 
      * In other words, don&#8217;t check in something and go home without verifying the build is green

When results and status are visible, the team accepts responsibility and becomes accountable for the build. If no one can tell what the status of the build is, no one will care.

### Automated deployment

Manual deployments seem to be one of the biggest headache-inducers in development. Any manual process, no matter how explicitly defined in a Word document or Excel spreadsheet, is inherently error-prone because it requires human action on each step. Humans are&#8230;well, human, and mistakes will happen. Having an automated deployment eliminates the human error of a manual deployment.

You can also go one step further and have a self-testing deployment, running the same tests that the builds executed. Having a automated, self-testing deployment would save countless hours of time spent diagnosing and troubleshooting deployment problems. Deployments are stressful enough, I&#8217;d like to have some confidence in what I&#8217;m deploying with an automated, self-testing process.

## Summing it up

By themselves, each practice is valuable. Together, the build practices multiply their collective value significantly. To introduce these practices, always start with automating the build and work your way down the list. It&#8217;s not very effective to have a self-testing build if the builds aren&#8217;t automated, as adding tests to a manual process would just make life more difficult and this practice would likely be dropped. Automation is a great enabler, as it allows much richer and complex processes to be possible.

I should also point out that these values, principles, and practices should be discussed and agreed upon in the team, not dictated to the team. Ideas agreed upon are much stronger than rules forced upon. In the final post in this series, I&#8217;ll look at customizing and extending Team Build to enable you to follow these build practices.