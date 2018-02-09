---
wordpress_id: 105
title: 'Branching Strategies: The Cost Of Branching And Merging'
date: 2010-02-24T15:22:50+00:00
author: Derick Bailey
layout: post
wordpress_guid: /blogs/derickbailey/archive/2010/02/24/branching-strategies-the-cost-of-branching-and-merging.aspx
dsq_thread_id:
  - "262544521"
categories:
  - Branch-Per-Feature
  - Branching Strategies
  - Productivity
  - Source Control
  - Test Automation
redirect_from: "/blogs/derickbailey/archive/2010/02/24/branching-strategies-the-cost-of-branching-and-merging.aspx/"
---
[Branching and merging](http://www.lostechies.com/blogs/derickbailey/archive/2010/02/24/branching-strategies-when-to-branch-and-merge.aspx) are never free operations. Even if you are using a source control system that makes the mechanical process of branching and merging negligible, there are other costs that need to be accounted for than just the button clicks or commands that are required for a developer to commit changes. 

If you were to do your current work directly in the main source line, what impact would that have? Would it be possible for your work to be committed in an incomplete or unstable state? Could you possibly prevent another team member from continuing their work because you accidentally created a problem that broke the build or otherwise hampered their efforts? Would you be introducing an immediate need for downstream team members, such as testers or business analysts to do reviews and testing, when those team members may not be immediately available? 

Of course there will be times when the cost of branching and merging is far greater than changing the main line directly. For example, you may need to change a label on a form, or update an email address for logging purposes. Simple changes such as this may not warrant a branch, but there is no hard and fast rule on this. Any change to the source code has the possibility of creating more work downstream. You can’t look at the source code only, when calculating the cost of working directly in the main code line. There are always other considerations and other possible side effects for your team and it’s processes.&#160; 

&#160;

### The Mechanical Cost

There is, at minimum, an inherent cost in branching and merging found in the time that it takes to create the branch, switch to the new working branch, merge the branch to it’s target location and test the merge to ensure nothing broke. This cost is highly variable depending on the source control system that you are using, though. 

With centralized systems where the actual branching takes place on the server, the cost may be fairly high. For example, with Subversion it only takes a moment to create a branch but it may take many minutes (I’ve seen a few hours for some repositories over slow connections) to switch your working branch and to do the merge. With distributed versioning systems (DVCS) like Git or Mercurial, though, the cost of branching and merging may be significantly lower. In fact, a DVCS is by it’s nature a branching scheme in it’s own way. You are never working directly against the master repository or code line. Rather, you are working against a local repository. (This is one of the reasons that working with [git + svn](http://www.lostechies.com/blogs/derickbailey/archive/2010/02/03/branch-per-feature-how-i-manage-subversion-with-git-branches.aspx) is easier than working with svn alone.) And there are some systems that just make branching very painful and difficult. Visual SourceSafe being the prime example of that, and from what I hear (I have never used, though), Team Foundation Server is not much better at branching and merging than VSS was Understanding the cost is important, though. It helps us to know when we should be using a branching strategy. 

&#160;

### The Management / Intellectual Cost

The more branching you have in your system, the more management it takes to keep track of them. When you start working with sub-branches, it becomes even more expensive to track them.

Every branch has a source line that it came from. In most cases, this source line will be the target of the merge as well. However, remembering where each branch came from so that you can merge it back to the correct location can be difficult. A good source control system will offer tools that help you understand where a branch came from, though. Subversion has a commit log that will tell you when and where a branch was made, and there are other tools available that can visualize where the branches came from. Git also has tools to visualize and otherwise represent the branching built right in, such as “gitk”. These tools can help you understand where a branch came from and where it went. They can also help you to know where it should go when you are making the decisions to merge. However, these tools don’t come free from intellectual cost. You must understand how to read the information that the tools provide, and you have to make intelligent decisions based on the information you are seeing.

As you begin to use sub-branches or hub-and-spoke branching, the cost of understanding where these branches came from and where they need to go increases. Better tools will make this easier to process in your mind, but they will not supplant the need to understand. 

&#160;

### The Stability And Testing Cost

### 

How and when your system is tested has a tremendous impact on the cost of branching and merging. 

If testing is done after the software has been built, as a distinct phase before release, then the impact on branching is minimal. Whether or not you branch your code to maintain stability during change, the stability of the system will not be known until after the system has been completely integrated and shipped to the testers. (While this may sound beneficial based only on these points, the long term cost of a test after the build strategy is far more than a test as you go strategy. But that’s another story…)

If testing is done as soon as possible, and done manually – that is, tests plans are written and executed by testers that are using the software directly – then the cost of every branch and merge can be enormous. Imagine having an enterprise logistics and maintenance system with 5+ years of functionality baked into it, and only having manual test plans for this system. If it takes a team of testers 2 weeks to exercise the entire suite of tests, then every branch and merge operation could require up to 2 weeks of testing to ensure nothing was broken. Now imagine working with a large team of developers and 10 or 15 active branches, each taking up to 2 weeks to test. Stability of the system is going to be much higher than a test at the end strategy. However, the cost is quickly rocketing out of the solar system, let alone the realm of possibility. (Note that I am not saying “manual testing is bad.” You need manual testing at some point. It will find things that test automation cannot find. How much manual vs. test automation your system needs is entirely contextual – there is no single correct answer for that.)

If testing is done as soon as possible with test automation either immediately after the changes are made – or better yet, with while changes are being made – then the cost of branching can be balanced with the stability of the system with greater ease. If the entire suite of automated tests takes 1 hour to run, then the cost of every branch and merge operation is potentially 1 hour plus the time it takes to do manual, exploratory testing around the changes. This doesn’t mean that the testing cycles are free, though. If the change requires 2 testers to work 4 hours each, then that is the cost of testing – whether or not the change was made on a branch or directly into the main source line. (Note that the long term cost/benefit of automated testing is almost always better than other testing strategies. There are exceptions to this, of course. Once again, that’s another story…)

&#160;

### The Cost Of Merging Too Much, Too Soon

When a branch is merged – whether into the main source line or another branch – you are effectively coupling the merged branches together. This can be useful at times, and can be detrimental at times. In one team I worked with a while back, we had a policy of merging branches together when they had been tested by the development staff and were ready to go on to testing by the business analyst / testing staff. Once the branches were merged, we did not want to un-merge them or go back to the originating branches because we did not want to introduce yet another variable in an already confusing process. The effect of this policy was to have multiple stories that would travel between “ready for test”, “tested” and/or bug fixes at the same time. At one point, we had nearly 20 stories and defects that were travelling between various steps at the same time. The effect was essentially a waterfall like process where we handed off large amounts of work and re-work to the next step. It was a hard lesson for us, but taught us the value of keeping our branches independent of each other for as long as possible.

So, saying that a branch should be merged when it is “done, done” is saying that the branch should live independently for as long as it can without impeding the flow of work to the next part of your process. How and when work flows to the next part of your process is a policy that you and your team decide within the confines and contexts of your company, customer, and project. 

&#160;

### Other Costs And Consideration

As I said in my first Branching Strategies post, there are many aspects of a system to be considered when branching your code, like a team’s organization, the system’s architecture, etc. Understanding your options, the context in which you are working, the problems you are facing, and the cost of all this will help you choose the right option at the right time. But, while the cost-benefit ratio is often a driving factor, it [should not be the only factor that we consider](http://www.lostechies.com/blogs/derickbailey/archive/2010/02/06/using-roi-as-a-constraint-not-an-end-in-itself.aspx).