---
id: 320
title: Fighting technical debt with the wall of pain
date: 2009-06-04T00:57:39+00:00
author: Jimmy Bogard
layout: post
guid: /blogs/jimmy_bogard/archive/2009/06/03/fighting-technical-debt-with-the-wall-of-pain.aspx
dsq_thread_id:
  - "264716173"
categories:
  - Agile
  - Refactoring
---
Technical debt, even on the agile-ist of agilista teams, still accumulates.&#160; Debt is inevitable, as initial design is always based on assumptions, not all of which pan out.&#160; I never view that as a failure, as all we can do is make the best decision given the limited information we know at any given time.&#160; Experience with DDD has shown me that often, design and architecture doesn’t undergo linear improvements.&#160; Rather, we reach a critical mass of information and knowledge where it becomes plainly and painfully obvious that our current design will no longer suffice.

In other situations, technical debt arises out of creating hidden forms duplication where only large-level, architectural refactorings can take the codebase to another level.&#160; This duplication comes not necessarily from domain concepts, but structural concepts, or what I like to call the “application domain”.&#160; We often need to create a model of our application, with things like the Command pattern, Strategy pattern and so on.&#160; Breakthroughs in this area happen just as they do in our model of the problem domain, but instead arise out of use cases and the structure of our application, rather than from a deeper understanding of our problem domain.

Finally, we have technical debt arising out of finding better ways of accomplishing the same result.&#160; It could be a layer supertype, switching to a jQuery plugin, or just plain removing subtle copy-paste duplication.&#160; Often, we see this last kind of technical debt arising out of larger teams, where individual frequency of duplication is rare, but project-wide duplication is far more pervasive.&#160; For example, I might introduce subtle duplication around an area once every three weeks.&#160; Because it is so sporadic, I don’t necessarily perceive the problem.&#160; But if I have five other team members, the frequency of duplication might be three times per week, above the threshold for one developer’s perception.

To tackle the inevitable growth of technical debt, we need some sort of strategy in place to address that risk.

### Option #1 – Do nothing

Yes, the team might _say_ a lot, complaining and the like, but never do anything about it.&#160; Or, they are simply not aware.&#160; Ignorance, apathy or hopelessness, I’m quite sure this approach is not viable for applications that need to change.

Or, the team has made management or the product team aware of a problem, but were unable to explain or justify the work required to fix the problem, so it merely lingers.&#160; I’ve been in this option far too often in my career, and it’s never a fun feeling.

### Option #2 – Cowboy style

In the absence of any form of technical story artifact, it’s up to the development team to prioritize technical debt payments, in the form of refactoring stories.&#160; Outside of any strategy, prioritization and planning is often cowboy-style, done immediately when found, without regard to impact or other more important issues.&#160; Refactorings are chosen based on how interesting it might be, the level of immediate frustration of the developer finding the duplication, or how easy the fix might seem.

Most of the time, it’s done exactly when the fix is found, without much effort into analysis of the impact, cost or benefit of the fix.&#160; Additionally, the fix is usually quite local, and not propagated to the rest of the system.&#160; We might make it easier going forward working with a standard component, but all too often this new standard is not retrofitted back to the rest of the application.&#160; This leads to multiple “right” ways of doing things, where the design of the next new component starts from the last component built, as long as we happen to remember what the last component was.

This happened on a recent project, where we created a new layer supertype, and all new controllers needed to implement this new base class.&#160; Unfortunately, this design was refined several times, until we had a half-dozen versions of the “right” way to design a controller.

It’s quite enticing to cowboy-code technical debt fixes.&#160; We, as the developer, get to play the hero type, announcing to the team “I fixed the Floogle problem!”.&#160; It’s a good feeling, unless you’re met with blank stares and unspoken (or vocal) questions of “why did you waste time on _that_?”

### Option #3 – Wall of pain

Instead of fixing technical debt issues at the exact moment we encounter them, our team instead keeps a prioritized queue of technical debt items on our whiteboard.&#160; On it, we track two sets of items:

  * Problems with a proposed solution
  * Problems with no solution, and a plea for help

As a contract to ourselves, we took an oath to not go forward with a new solution without retrofitting the application to use the new concept.&#160; This ensured that we didn’t have pockets of bad code intermixed with good code, or worse, seven different designs in our system of the same concept.&#160; The retrofitting was key for us to continue to innovate and improve, and let us find broader concepts.&#160; The more examples we had of a concept, the more we could find commonality.&#160; If there are seven ways to do the same thing in our system, there is just as much duplication, but a duplication that is much _much_ harder to both recognize and fix.

[Kevin](http://khurwitz.blogspot.com/) and [Jeffrey](http://jeffreypalermo.com/) teamed up to imbue in me a sense of pain-driven development.&#160; The more something hurts, the more it needs to be fixed.&#160; If local builds take 10 minutes, that’s a lot of pain throughout the day.&#160; This concept led us to our current “wall of pain” that includes these items:

  * The problem
  * The solution
  * The level of pain (1-5)
  * The estimate to retrofit, in points

If something is very painful, but easy to fix, it is moved up on the list.&#160; However, the effort to retrofit has to be a consideration, as it often indicates the risk introduced into our system of a large change.&#160; Since a defined solution is part of this list, the point estimate is defined in terms of relative complexity, and therefore risk.

For items without a solution, we just leave out the solution and estimate to retrofit.&#160; These items are analyzed and given a solution as needed.&#160; Many designs need vetting before established as the “new standard”, so our team will wait to pick a solution until we’re quite satisfied with the result. 

All of this assumes that technical debt items aren’t tracked in your normal taskboard/kanban/story wall.&#160; Otherwise, you’ll likely have an established manner of prioritization.

We’ve had our wall of pain up for a few months, and at the very least, it provided visibility and a way for us to communicate the day-to-day development pain we might face.&#160; We still introduce minor fixes and technical debt payments during our iterations, without using the wall of pain, but these are of the small and completely obvious variety.&#160; Still key is the concept of retrofitting, which we find greatly helpful in maintaining a consistent codebase.